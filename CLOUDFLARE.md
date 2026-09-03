# Cloudflare rules — add these the same time you push

Search Console shows 1,018 impressions split across duplicate URLs. These rules
consolidate them. Add all four before purging cache.

## 1. Strip .html  (biggest win)
Rules > Redirect Rules > Create

    Field:    URI Path
    Operator: ends with
    Value:    .html
    Then:     Dynamic redirect, 301
    Expression: concat("https://www.fixmypcperth.com",
                regex_replace(http.request.uri.path, "\\.html$", ""))

Consolidates: /pricing.html, /reviews.html, /blog.html, /quiz.html, /terms.html,
/business-it-support.html, /quote-request.html, /blog/how-to-fix-a-slow-computer.html,
/blog/why-is-my-pc-so-slow.html, /blog/how-to-tell-if-pc-has-virus.html

## 2. Force https + www
Rules > Settings > enable "Always Use HTTPS", then a redirect rule:

    Field:    Hostname
    Operator: equals
    Value:    fixmypcperth.com
    Then:     301 to https://www.fixmypcperth.com/$1

## 3. Renamed page
    /laptop-repair-perth  ->  /laptop-screen-repair-perth   (301)

Required. That file has been renamed. Without this rule the old URL 404s.
It had 420 impressions in the last 12 months.

## 4. Historic suburb URL
    /computer-repair-canning-vale  ->  /suburbs/canning-vale   (301)

Still earning 2 clicks and 45 impressions with no file behind it.

## After deploying
- Purge everything in Caching > Configuration
- Submit sitemap.xml in Search Console
- Request indexing for /laptop-screen-repair-perth
