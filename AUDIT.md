# FixMyPC Perth — Repo Audit

Source: `github.com/ali-rajaa/fixmypcperth` @ clone of 3 Sep 2026.
Every number below was produced by parsing all 43 HTML files, not by sampling.

---

## 1. Real inventory: 43 pages, not 40

The handover accounted for ~29 and guessed 11 were missing. Here is what is
actually in the repo.

**Core (8)**
`index`, `pricing`, `business-it-support`, `quiz`, `blog`, `reviews`,
`quote-request`, `terms`

**Service pages (11)**
`data-recovery-perth`, `virus-removal-perth`, `ssd-upgrade-perth`,
`laptop-repair-perth`, `laptop-battery-replacement-perth`,
`gaming-pc-build-perth`, `slow-computer-repair-perth`,
`computer-wont-turn-on-perth`, `windows-11-upgrade-perth`,
`windows-reinstall-perth`, `computer-backup-setup-perth`

`windows-reinstall-perth` was not in the handover inventory.

**Industry IT pages (8) — entirely absent from the handover**
`it-support-accountants-perth`, `it-support-allied-health-perth`,
`it-support-childcare-perth`, `it-support-hospitality-perth`,
`it-support-legal-perth`, `it-support-real-estate-perth`,
`it-support-retail-perth`, `it-support-trades-perth`

**Suburb pages (8)** — as listed in the handover.

**Blog posts (8), not 2**
`data-recovery-perth-guide`, `why-is-my-pc-so-slow`,
`how-much-does-pc-repair-cost-perth`, `how-to-fix-a-slow-computer`,
`how-to-tell-if-pc-has-virus`, `laptop-screen-replacement-physical-repairs`,
`signs-hard-drive-failing`, `ssd-upgrade-perth-guide`

**A page that does not exist:** `laptop-screen-repair-perth.html`. See §3.

---

## 2. Prices: three separate price generations are live simultaneously

`pricing.html` is treated here as the single source of truth, per instruction.
The site currently contradicts it in two large, systematic blocks: **all 8 blog
posts** share one outdated price block, and **all 8 suburb pages** share a
different outdated price block.

| Service | pricing.html (authority) | 8 blog posts say | 8 suburb pages say | Other pages say |
|---|---|---|---|---|
| Base diagnostic & repair | **$120 all-in** | — | — | index + suburbs headline "from $49" |
| Virus & malware removal | **$99** | from $80 | $140 | index: $99 ✓ |
| Data recovery, failing drive | **$149** | from $120 | $120 to $300 | index: $149 ✓ |
| Data recovery, dead drive | **$249** | — | — | quiz: $249 ✓ |
| External drive / USB recovery | **$99** | — | — | — |
| SSD upgrade, labour only | **$65** | $65 ✓ | — | ✓ |
| SSD supplied & fitted | **from $150** (500GB) | from $150 ✓ | — | ✓ |
| Laptop screen replacement | **$145 / $175 / $199** (standard / touch / OLED) | from $120, from $150 | — | index: from $120 and $149; laptop-battery page: from $145 |
| Laptop battery, labour | **$89** | — | — | — |
| Windows reinstall + backup | **$120** | $120 ✓ | — | ✓ |
| Windows 11 upgrade with key | **$120** | — | — | ✓ |
| Overheating fix / deep clean | **$89** | — | — | ✓ |
| Gaming PC build | **$149 / $199 / $249** | — | — | ✓ |
| Business IT | **from $149/mo** | $149/mo ✓ | $149/mo ✓ | consistent everywhere ✓ |

**Worst offenders, customer-facing:**

- Virus removal is quoted at **$80, $99 and $140** on the live site right now.
  A customer reading a blog post and then the pricing page sees a 24% increase.
- Data recovery is quoted as **from $120**, **$120–$300**, and **from $149**.
- Laptop screen replacement has **five** different figures: $120, $145, $149,
  $150, $175/$199.

**Needs a business decision before I can normalise (not resolvable from the repo):**

1. **"from $49"** appears on the homepage and all 8 suburb pages. The cheapest
   item on the pricing page is $40 (case fan install) and the cheapest
   repair-adjacent item is $45 (remote session) / $49 (pre-purchase check).
   No repair starts at $49. Keep the headline and accept it points at the
   pre-purchase check, or change it to "from $120"?
2. **Screen replacement**: is `$120` a labour-only figure and `$145` the
   panel-included figure, or is `$120` simply stale? They can't both be the
   headline.
3. **The pricing hero band says `$79–$149`** while the section below says the
   common starting point is `$120 all-in`. Which is the headline number?

Everything else I can propagate mechanically from `pricing.html`.

---

## 3. The single most damaging bug on the site

`laptop-repair-perth.html`:

- **Title:** Laptop Screen Replacement Perth – From $120 Labour
- **H1:** Laptop Screen Replacement Perth
- **Canonical:** `https://www.fixmypcperth.com/laptop-screen-repair-perth`

That canonical URL **does not exist**. There is no
`laptop-screen-repair-perth.html` in the repo and it is not in `sitemap.xml`.

The page is telling Google that its authoritative version lives at a 404. That
is a page instructing search engines not to index it. It is also the only page
covering screen replacement, which the pricing page prices at $145–$199 and
which is one of the highest-intent local searches in this niche.

Six other pages link to that non-existent URL:
`data-recovery-perth`, `laptop-battery-replacement-perth`, and four blog posts.

**Fix:** rename the file to `laptop-screen-repair-perth.html` so it matches its
own canonical, its title, its H1 and every inbound internal link. Then 301
`/laptop-repair-perth` → `/laptop-screen-repair-perth` at Cloudflare, since the
old URL may have accrued links.

---

## 4. Internal links: 243 broken instances

| Format | Count |
|---|---|
| `page.html` (with extension) | 1,014 |
| `/page` (root-relative, extensionless) | 118 |
| `page` (relative, extensionless) | 21 |
| `#` (dead) | 10 |

**All 8 industry IT pages are broken in the same way.** They live in the repo
root but every navigation link is written as if they lived one folder down:
`../index.html`, `../pricing.html`, `../blog.html`, `../reviews.html`,
`../quiz.html`, `../terms.html`, `../business-it-support.html`. From the root
those resolve above the site root and 404. Their `../favicon.png` and
`../logo.png` are broken for the same reason.

That is 72 of the 243 broken instances, and it means **every one of those 8
pages is a dead end for both users and crawlers**.

**Other breakage:**

- `quiz.html` links to 9 URLs on a scheme that has never existed:
  `/computer-repair-armadale`, `/computer-repair-atwell`,
  `/computer-repair-canning-vale`, `/computer-repair-cockburn`,
  `/computer-repair-gosnells`, `/computer-repair-harrisdale`,
  `/computer-repair-jandakot`, `/computer-repair-thornlie`,
  `/computer-repair-willetton`. The real scheme is `/suburbs/<name>`.
- 4 suburb pages link to `gosnells.html`, which was never built.
- 4 blog posts link to `../blog/data-recovery-perth.html`,
  `../blog/virus-removal-perth.html`, `../blog/ssd-upgrade-perth.html` — service
  slugs pasted under `/blog/`.
- `blog/signs-hard-drive-failing.html` links to `blog.html`, `pricing.html`,
  `quiz.html`, `reviews.html` without `../`, so they resolve inside `/blog/`.
- `suburbs/canning-vale.html` links to `index.html`, resolving to
  `/suburbs/index.html`.
- 10 dead `#` links on the homepage (Gosnells, Armadale, Byford, Piara Waters,
  Southern River, Riverton, Parkwood, Queens Park, Maddington, Leeming).

---

## 5. Metadata

**Canonicals** are in good shape: all 43 use `www`, only 2 carry `.html`, only
the homepage carries a trailing slash (correct, it's the root). This already
matches the chosen convention.

**`og:url` does not.** 13 pages have `.html` in `og:url`, and **12 of 43 pages
have a canonical that disagrees with their own `og:url`.** Affected:
`business-it-support`, `data-recovery-perth`, `gaming-pc-build-perth`,
`laptop-repair-perth`, `slow-computer-repair-perth`, `ssd-upgrade-perth`,
`virus-removal-perth`, `windows-reinstall-perth`, `terms` (no `og:url` at all),
and 3 blog posts.

**`og:image` is broken site-wide.** 39 pages point at `facebook-cover.png` —
33 on the non-www host, 6 on www — and **that file is not in the repo**. One
page (`reviews`) points at `og-image.png`, also missing. Three pages
(`terms`, `blog/signs-hard-drive-failing`, `blog/ssd-upgrade-perth-guide`) have
no `og:image` at all. Every WhatsApp, Facebook and LinkedIn share of this site
is currently previewing without an image, which matters given most enquiries
arrive via WhatsApp.

**Good news:** exactly one `<h1>` per page across all 43. `robots` meta is clean.
`sitemap.xml` holds 42 URLs, all `www`, all extensionless, none with a trailing
slash — it already matches the target convention. Only
`laptop-battery-replacement-perth` is missing from it.

---

## 6. Templating drift

- **16 distinct `<nav>` markup variants** across 43 pages.
- **16 distinct `<footer>` markup variants** across 43 pages.

The largest cluster is 8 pages. There is no such thing as "the header" on this
site; there are sixteen of them. This is the quantified version of the
handover's argument for migrating.

- **Zero external stylesheets.** Every page carries its own `<style>` block.
  Roughly **890 KB of inline CSS** across the site, from 9 KB (`terms`) to
  53 KB (`index`). Nothing is cached between page views.

---

## 7. Things that are already fine

Worth stating, because they reduce risk:

- **No `.nojekyll` and no `_config.yml`.** Nothing blocks the Jekyll migration.
- **Zero Liquid collisions.** Not one `{{` or `{%` in any of the 43 files, so
  turning Jekyll on will not break a build.
- **`CNAME` = `www.fixmypcperth.com`**, matching the chosen www decision.
- **GA4 is consistent**: one property, `G-S0CW1QXBDY`, on all 43 pages, twice
  each (loader + config). Nothing to reconcile.
- **Phone is consistent**: `0452 573 701` and `wa.me/61452573701` (202 links).
  The one `0412 345 678` occurrence is a form input placeholder, not a live number.
- Only one real form endpoint in the repo: `https://api.web3forms.com/submit`.

---

## 8. Recommended order of work

1. Rename `laptop-repair-perth.html` → `laptop-screen-repair-perth.html`, add
   the 301. Highest value per minute of any item here.
2. Fix the 8 industry IT pages' `../` links. 72 broken links, one find/replace.
3. Add `facebook-cover.png` to the repo and point all 43 `og:image` tags at the
   www host.
4. Normalise every price against `pricing.html`, once the three open questions
   in §2 are answered.
5. Build the 10 missing suburb pages, replacing the dead `#` links.
6. Then the Jekyll conversion, which makes 2–5 impossible to regress.

Items 1–3 are bug fixes on a live site and do not need to wait for the
migration.
