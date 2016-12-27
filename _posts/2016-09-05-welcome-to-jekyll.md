---
layout: post
title:  "Storing Credit Cards with Stripe"
date:   2016-09-05 21:37:32 -0400
categories: jekyll update
excerpt_separator: <!-- excerpt -->

---
Hi There

Taking payments with Stripe is mostly straightforward. However, models and controllers can easily become overwrought with logic. We'll export this logic to service objects each designed to perform one particular task.

<!-- excerpt -->

{% gist 02e835ae0f45bea13a7e692606cb998e %}
{% gist d1566486a2e9e039343e46bdb8b043bf %}
{% gist 7e96510fc643062e45ca8631c29ba4ff %}
