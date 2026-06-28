---
layout: page
title: Experience
permalink: /experience/
description:
nav: true
nav_order: 4
_styles: |
  .experience-logo-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 2.75rem 2rem;
    align-items: start;
    margin-top: 1.5rem;
  }

  .experience-logo-item {
    display: grid;
    grid-template-rows: 96px auto;
    justify-items: center;
    text-align: center;
    min-width: 0;
  }

  .experience-logo-frame {
    width: 100%;
    height: 96px;
    display: grid;
    place-items: center;
  }

  .experience-logo-frame img {
    max-width: min(170px, 100%);
    max-height: 72px;
    width: auto;
    height: auto;
    object-fit: contain;
  }

  .experience-logo-dark {
    display: none;
  }

  html[data-theme="dark"] .experience-logo-light {
    display: none;
  }

  html[data-theme="dark"] .experience-logo-dark {
    display: block;
  }

  .experience-timeline {
    margin-top: 0.75rem;
    color: var(--global-text-color-light);
    font-size: 0.95rem;
    line-height: 1.35;
  }
---

<div class="experience-logo-grid">
  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/msr-light.png' | relative_url }}" alt="Microsoft Research logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/msr-dark.png' | relative_url }}" alt="Microsoft Research logo">
    </div>
    <div class="experience-timeline">July'26 - Present</div>
  </div>

  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/mbzuai-light.png' | relative_url }}" alt="MBZUAI logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/mbzuai-dark2.png' | relative_url }}" alt="MBZUAI logo">
    </div>
    <div class="experience-timeline">Dec'25 - May'26</div>
  </div>

  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/hms-light3.png' | relative_url }}" alt="Harvard Medical School logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/hms-dark.png' | relative_url }}" alt="Harvard Medical School logo">
    </div>
    <div class="experience-timeline">May'25 - Nov'25</div>
  </div>

  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/wiai-light.png' | relative_url }}" alt="Wadhwani AI placeholder logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/wiai-dark.png' | relative_url }}" alt="Wadhwani AI placeholder logo">
    </div>
    <div class="experience-timeline">June'25 - Nov'25</div>
  </div>

  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/iisc-light.png' | relative_url }}" alt="IISc placeholder logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/iisc-dark.png' | relative_url }}" alt="IISc placeholder logo">
    </div>
    <div class="experience-timeline">Summer'24</div>
  </div>

  <div class="experience-logo-item">
    <div class="experience-logo-frame">
      <img class="experience-logo-light" src="{{ '/assets/img/experience_logos/plaksha-light.png' | relative_url }}" alt="Plaksha University logo">
      <img class="experience-logo-dark" src="{{ '/assets/img/experience_logos/plaksha-dark.png' | relative_url }}" alt="Plaksha University logo">
    </div>
    <div class="experience-timeline">Bachelor's (2022-2026)</div>
  </div>
</div>
