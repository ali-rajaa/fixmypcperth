# Cloudflare rules for this deploy

## 1. blog -> techtips  (REQUIRED — 9 URLs, 232+ impressions)

Rules > Redirect Rules > Create > Dynamic redirect, 301

    When: (starts_with(http.request.uri.path, "/blog"))
    Then: concat("https://www.fixmypcperth.com/techtips",
          substring(http.request.uri.path, 5))

Covers /blog and all 8 posts, e.g.
  /blog/how-much-does-pc-repair-cost-perth  ->  /techtips/how-much-does-pc-repair-cost-perth
  (351 impressions, 6 clicks in the last 12 months — do not skip this)

## 2. Strip .html  (1,018 impressions currently split across duplicates)

    When:  ends_with(http.request.uri.path, ".html")
    Then:  concat("https://www.fixmypcperth.com",
           regex_replace(http.request.uri.path, "\.html$", ""))

## 3. Force https + www

Rules > Settings > enable "Always Use HTTPS", then:

    When: http.host eq "fixmypcperth.com"
    Then: 301 to https://www.fixmypcperth.com + path

## After deploying
- Purge everything under Caching > Configuration
- Resubmit sitemap.xml in Search Console
- Request indexing for /techtips and /privacy
