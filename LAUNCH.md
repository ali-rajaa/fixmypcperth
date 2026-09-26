# Launch checklist: staging to www.fixmypcperth.com

Do these in order, on one day. Steps 1 to 3 take about an hour. Nothing
here touches the live site until step 3.

Live repo today: `ali-rajaa/fixmypcperth`, plain HTML, deployed straight
from its branch, CNAME `www.fixmypcperth.com`, last commit `1712f00`.
Staging repo: `ali-rajaa/fixmypcperth-staging`, Jekyll 4, built by
`.github/workflows/pages.yml`.

Same on both, checked: Google Analytics `G-S0CW1QXBDY`, the Web3Forms
access key in `_data/services.yml`. Search Console verification is not a
meta tag on the live site, so it is DNS based and carries over untouched.

---

## 0. Before launch day (owner)

- [x] Open claims confirmed by the owner (brands, same-day screens, parts
      checks, deleted-files price, drive supplied, MacBook recovery,
      hardware check before a reinstall, remote virus removal, account
      recovery, second-drive price, parts supplied on request).
- [x] Six homepage reviews confirmed genuine by the owner.
- [ ] Have Cloudflare and GitHub (owner of both repos) logged in.

## 1. Cloudflare: redirects (before the site switches)

The new site drops 72 old addresses (old /blog URLs, merged service pages,
`.html` copies, the old /quiz, /computer-repair-<suburb> and
/industries/... links). Every one is mapped in
`_launch/cloudflare-bulk-redirects.csv`: 301, one line each, built from
the live repo's pages, its sitemap, its internal links and the Search
Console export. None is left unmapped. Together they carry 4,745
impressions.

- [ ] Cloudflare dashboard > Rules > Redirect Rules > Bulk Redirects.
- [ ] Create a Bulk Redirect List, "fixmypcperth-launch", and upload the
      CSV. Each line is: source, target, 301, preserve query string,
      include subdomains, subpath matching, preserve path suffix. Sources
      have no www and include subdomains is on, so one line covers
      fixmypcperth.com and www, http and https.
- [ ] If Cloudflare rejects the two targets with a `#` (`#battery`,
      `#backup`), remove the `#...` from those two lines and upload again.
      They then land at the top of the page instead of the section.
- [ ] Create a Bulk Redirect Rule using that list. Leave it DISABLED until
      step 3, or the old site starts redirecting to pages it does not
      have.
- [ ] SSL/TLS: "Always Use HTTPS" on (check it already is).

## 2. Staging: final pass

- [ ] Staging build green on the latest commit (GitHub > Actions).
- [ ] Spot-check staging on a phone: home, /services, one service page,
      the quote form sends (use a real test enquiry).

## 3. Switch

In the LIVE repo (`ali-rajaa/fixmypcperth`). Claude pushes; the owner
does the two settings.

- [ ] (Claude) The `launch` branch holds the new site: the staging repo's
      files, with `CNAME` set to `www.fixmypcperth.com` and `staging:
      false` in `_config.yml`. Every old plain-HTML file is gone from it;
      the redirects cover each one. Pushing a branch other than main
      changes nothing on the live site.
- [ ] (Owner) Settings > Pages > Build and deployment > Source: change
      from "Deploy from a branch" to "GitHub Actions". The live site keeps
      serving the old deployment until the next step. The new site needs
      the workflow to build (Jekyll 4); left on "branch", GitHub's own
      builder would publish a broken site.
- [ ] (Claude) Make `main` the `launch` branch. The push runs "Build and
      deploy"; when it goes green the new site is live and the old one is
      gone.
- [ ] (Owner) Cloudflare: ENABLE the Bulk Redirect Rule from step 1.

## 4. Check (within the hour)

- [ ] Actions > "Verify live site" > Run workflow (or run
      `bash _launch/check-live.sh` and `bash _launch/test-redirects.sh`
      from any machine with curl). It checks robots.txt, the sitemap and
      every page in it, the 404 page, the apex redirect, that staging is
      still noindex, and all 72 redirects. Expect 0 problems in both.
- [ ] https://www.fixmypcperth.com/robots.txt shows `Allow: /` and the
      Sitemap line. If it says `Disallow: /`, `staging` is still true.
- [ ] https://www.fixmypcperth.com/sitemap.xml lists about 50 pages, all
      https://www.fixmypcperth.com/..., no `.html`.
- [ ] View source on the home page: `<meta name="robots" content="index,
      follow...">`, not noindex.
- [ ] A made-up address such as /xyz shows the FixMyPC "That page has
      moved" page.
- [ ] Send one quote form and one WhatsApp click; check the enquiry
      arrives and Analytics records the visit (Realtime).

## 5. Search Console (same day)

- [ ] Sitemaps: submit `https://www.fixmypcperth.com/sitemap.xml`
      (remove the old one if listed separately).
- [ ] URL Inspection > Request indexing for the home page, /services and
      the three biggest service pages (laptop repair, virus removal, data
      recovery).

## 6. First two weeks

- [ ] Every 2 to 3 days: Search Console > Pages > "Not found (404)". Any
      old address listed there needs adding to the redirect list.
- [ ] After 2 weeks: compare the target terms against the old export
      (laptop repair near me, laptop repair perth, data recovery perth,
      virus removal perth, malware removal perth).

## Rolling back

If something is badly wrong after the switch:

1. Cloudflare: disable the Bulk Redirect Rule.
2. Live repo: revert the switch commit (back to `1712f00`), and set
   Settings > Pages > Source back to "Deploy from a branch".

The old site is back as it was within a few minutes.

---

## Files

| File | What it is |
|---|---|
| `_launch/cloudflare-bulk-redirects.csv` | The 72 redirects, ready to upload |
| `_launch/test-redirects.sh` | Checks every redirect after launch |
| `_launch/check-live.sh` | Checks robots, sitemap pages, 404, apex, staging noindex |
| `_launch/mobile-check.js` | Measures every live page on a 390px and 360px phone against the mobile standard |
| `.github/workflows/verify-live.yml` | Runs both checks on GitHub's servers, on demand |
| `robots.txt` | Allows crawling on both; names the sitemap only when `staging: false`. Staging stays out of Google by noindex |
| `sitemap.xml` | Built from the pages; add `sitemap: false` to a page to leave it out |
| `404.html` | Shown for any address that does not exist; noindex |

`_launch/` starts with an underscore, so Jekyll never publishes it.
