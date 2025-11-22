require 'feedjira'
require 'httparty'
require 'jekyll'
require 'nokogiri'
require 'time'

module ExternalPosts
  class ExternalPostsGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      if site.config['external_sources'] != nil
        site.config['external_sources'].each do |src|
          puts "Fetching external posts from #{src['name']}:"
          if src['rss_url']
            fetch_from_rss(site, src)
          elsif src['posts']
            fetch_from_urls(site, src)
          end
        end
      end
    end

    def fetch_from_rss(site, src)
      # fetch with a clear user-agent and a short timeout to avoid being blocked/hanging
      begin
        resp = HTTParty.get(src['rss_url'],
                            headers: { 'User-Agent': 'GitHub Actions - jekyll (https://github.com)' },
                            follow_redirects: true,
                            timeout: 10)
      rescue StandardError => e
        puts "Warning: HTTP request failed for #{src['name']} (#{src['rss_url']}): #{e.class}: #{e.message}"
        return
      end

      unless resp && resp.code == 200
        puts "Warning: Failed to fetch RSS for #{src['name']} (#{src['rss_url']}): HTTP #{resp&.code}"
        return
      end

      xml = resp.body
      if xml.nil? || xml.strip.empty?
        puts "Warning: Empty response for #{src['rss_url']}"
        return
      end

      # quick sanity check — avoid passing HTML or other non-XML content to Feedjira
      content_type = resp.headers['content-type'] || ''
      unless xml.include?('<rss') || xml.include?('<feed') || xml.start_with?('<?xml') || content_type.include?('xml')
        snippet = xml[0, 200].gsub(/
   +/, '')
        puts "Warning: Content from #{src['rss_url']} does not look like RSS/XML. First 200 chars: #{snippet.inspect}"
        return
      end

      begin
        feed = Feedjira.parse(xml)
      rescue Feedjira::NoParserAvailable => e
        puts "Warning: Feedjira couldn't parse feed for #{src['name']} (#{src['rss_url']}): #{e.message}"
        return
      rescue StandardError => e
        puts "Warning: Error parsing feed for #{src['name']} (#{src['rss_url']}): #{e.class}: #{e.message}"
        return
      end

      if feed && feed.respond_to?(:entries) && !feed.entries.empty?
        process_entries(site, src, feed.entries)
      else
        puts "Warning: No entries found in feed for #{src['name']} (#{src['rss_url']})"
      end
    end

    def process_entries(site, src, entries)
      entries.each do |e|
        puts "...fetching #{e.url}"
        create_document(site, src['name'], e.url, {
          title: e.title,
          content: e.content,
          summary: e.summary,
          published: e.published
        })
      end
    end

    def create_document(site, source_name, url, content)
      # check if title is composed only of whitespace or foreign characters
      if content[:title].gsub(/[^
   a-zA-Z0-9 ]/, '').strip.empty?
        # use the source name and last url segment as fallback
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^
   a-zA-Z0-9-]/, '')}-#{url.split('/').last}"
      else
        # parse title from the post or use the source name and last url segment as fallback
        slug = content[:title].downcase.strip.gsub(' ', '-').gsub(/[^
   a-zA-Z0-9-]/, '')
        slug = "#{source_name.downcase.strip.gsub(' ', '-').gsub(/[^
   a-zA-Z0-9-]/, '')}-#{url.split('/').last}" if slug.empty?
      end

      path = site.in_source_dir("_posts/#{slug}.md")
      doc = Jekyll::Document.new(
        path, { :site => site, :collection => site.collections['posts'] }
      )
      doc.data['external_source'] = source_name
      doc.data['title'] = content[:title]
      doc.data['feed_content'] = content[:content]
      doc.data['description'] = content[:summary]
      doc.data['date'] = content[:published]
      doc.data['redirect'] = url
      doc.content = content[:content]
      site.collections['posts'].docs << doc
    end

    def fetch_from_urls(site, src)
      src['posts'].each do |post|
        puts "...fetching #{post['url']}"
        content = fetch_content_from_url(post['url'])
        content[:published] = parse_published_date(post['published_date'])
        create_document(site, src['name'], post['url'], content)
      end
    end

    def parse_published_date(published_date)
      case published_date
      when String
        Time.parse(published_date).utc
      when Date
        published_date.to_time.utc
      else
        raise "Invalid date format for #{published_date}"
      end
    end

    def fetch_content_from_url(url)
      html = HTTParty.get(url).body
      parsed_html = Nokogiri::HTML(html)

      title = parsed_html.at('head title')&.text.strip || ''
      description = parsed_html.at('head meta[name="description"]')&.attr('content')
      description ||= parsed_html.at('head meta[name="og:description"]')&.attr('content')
      description ||= parsed_html.at('head meta[property="og:description"]')&.attr('content')

      body_content = parsed_html.search('p').map { |e| e.text }
      body_content = body_content.join() || ''

      {
        title: title,
        content: body_content,
        summary: description
        # Note: The published date is now added in the fetch_from_urls method.
      }
    end

  end
end
