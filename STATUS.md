# STATUS

Where the site is up to. Kept in the repo so any new chat can read one
file instead of being re-told everything.

**Live only.** The staging repo and staging.fixmypcperth.com were deleted
on purpose (26 Sep 2026). All work happens in `ali-rajaa/fixmypcperth` and
is pushed straight to `main`, which deploys www.fixmypcperth.com. There is
no preview, so verify locally (build, verify_page.py, screenshots) before
every push, and show the owner screenshots first for bigger changes.

**Read this first, then work from the live repo.** The house rules live in
the `fixmypcperth-jekyll` skill, which loads on its own. Do not re-decide
anything listed under "Locked decisions" there or here.

Last updated: 4 October 2026.

---

## How to start a new chat

Say this:

> Working on fixmypcperth (live only). Read STATUS.md, then continue
> with <the task>.

Pull files raw, with a cache-buster, not the codeload tarball: the tarball
serves a cached archive and has reported a finished push as missing.

    https://raw.githubusercontent.com/ali-rajaa/fixmypcperth/main/<path>?x=<random>

Run `scripts/verify_page.py` from the skill on every page touched, before
delivering anything. There is no staging preview any more, so that script
and a local build are the only safety net.

---

## Built and live on staging

**Suburb pages** (18, the full cluster) at `/suburbs/<slug>`, sharing
`_layouts/suburb.html` and `assets/css/pages/suburb.css`:

    huntingdale (the pattern page)   canning-vale   thornlie   willetton
    harrisdale   jandakot   cannington   cockburn   gosnells
    southern-river   piara-waters   maddington   parkwood   leeming
    armadale   byford   riverton   queens-park

Each is a single file of front matter. The layout holds everything shared.
Siblings and the footer list find suburb pages automatically, so **adding a
suburb is one new file and nothing else**.

**Industry pages** (9) at `/it-support-<industry>-perth`, sharing
`assets/css/pages/industry.css`.

**Tech Tips**: hub at `/tech-tips`, `_layouts/tech-tip.html`,
`assets/css/pages/tech-tip.css`. All 6 guides built, see below.

**Homepage rebuild (in progress)**: `index.html` and `index.css` are being
brought up to the same standard as the rest of the site, one step at a
time, url and section IDs unchanged throughout.

- Step 1, prices - done. Every price on the page, including all 10
  `Offer` entries in the schema, now comes from `services.yml` through
  `price.html`. Two new price.html modes were added for this:
  `numeric=true` (bare digits, no `$`, for a schema.org `"price"` field)
  and `was=true` (a package's own `was:` text, e.g. "Was $340"). Found and
  fixed a real bug along the way: the "New PC Setup" card was silently
  showing the Essential plan's price, because no key existed for it.
  Added `business-pc-setup-migration` to `services.yml`. The "Save $200"
  package ribbon is now computed (`was_price` minus `price`), not typed.
  The few dollar figures still typed on the page are deliberate: the
  $900-$1,800 new-PC comparison is not one of FixMyPC's own service
  prices.
- Step 2, buttons - done. 7 separate button classes
  (`.pkg-btn`, `.its-cta`, `.hero-icon-btn`, plus `.mq-submit` drifting
  from `.btn-blue`) collapsed onto the 3 that already existed and were
  barely used: `.btn-blue`, `.btn-wa`, `.btn-outline`. Removed a dead
  `.fb` button variant along the way (referenced an undefined `--fb`
  color, never actually used in the markup, so not a live violation of
  the Facebook-footer-only rule, just dead weight).
- Step 3, cards - done. 9 card classes were on 4 different border-radius
  values (14px/18px/20px/22px) and 2 different hover-shadow formulas. All
  now share `var(--radius)` and one shadow. The hero panel keeps its own
  permanent (non-hover) shadow on purpose, since it is a floating UI
  panel, not a flat content card.
- Step 4, type scale - done. The shared `.s-title` (used for every
  section H2) was rendering up to 2.8rem, close to hero size, instead
  of the locked 1.45rem. Fixed, along with `.s-eyebrow` (12px to 11px)
  and `.s-sub`. A full section-by-section spacing and rhythm pass
  followed: every section's header-to-content gap unified to 2.5rem
  (one section was 3rem, two more set the same value with an inline
  `style=` instead of a shared class), the "why a workshop beats a
  callout" section was removed at the user's request (read as
  structurally out of place, not fixable with a spacing tweak), and a
  real phone-only bug was found and fixed: the Business IT and Reviews
  carousels' swipe-bar rule used a `margin` shorthand that wiped out
  their top gap, so cards sat flush against the intro text on phones.
- Step 5, section redesigns - done, live (25 September 2026).
  - Hero, left side: one price line ("$120 all-in") in place of three,
    the blue "Repairs, data recovery..." sub-line removed (it fought the
    H1 accent), paragraph cut to two sentences at the Lede size. H1
    capped at 3.4rem with `text-wrap: balance`, so it is 3 lines beside
    the quote card instead of 4. Buttons: one solid WhatsApp button plus
    a quiet "Or request a quote online" text link (was two equal pills).
    The link goes to `/quote-request`, not the card, because the card is
    hidden between 721 and 900px.
    The copy column is centred against the quote card and carries a
    second, quieter paragraph (`.hero-more`) with the services and areas
    in plain prose for search, linking 4 built suburb pages and
    `/business-it-support`, so the two columns are roughly equal height.
  - Ticks: the page used the text character U+2713, which DM Sans does
    not contain, so browsers drew it from a fallback system font. All
    ticks (info strip, packages, quote success) are now SVG.
  - Testing note: headless Chromium here cannot fetch Google Fonts
    through the proxy, so screenshots silently fall back to Liberation
    Sans. Download the font CSS and woff2 files with curl and serve them
    from the local test build to see the real Sora and DM Sans.
  - Hero info strip: rating now reads from `_data/reviews.yml` (it said
    "5/5 rated" while the card said 4.8). The "30-day warranty" check
    duplicated the "30d" stat beside it, replaced with "Drop off any
    time, 24/7". Fixed a layout bug where the checks were crushed and
    the rating overlapped them between 721 and 1080px. Checked for
    overlap and overflow at every width from 320 to 1600px.
  - Contact card: WhatsApp only (the call option is gone), email row
    added, same-day turnaround shown as its own panel.
  - Closing CTA: the icon-only WhatsApp circle replaced with a labelled
    WhatsApp button plus an outline "Request a quote online" button.
  - Repair packages: moved from the dark navy template onto the light
    card system. Diagonal "Save" ribbon replaced by a plain-text saving
    next to the price, star eyebrows replaced by icon-wraps, lists split
    into two labelled groups, price and CTA moved above the list.
  - Quote card success message said "Our tech team", changed to "A
    member of our team" per the house rule.
  - Still unverified: the "500+ Systems Optimised" stat in the info
    strip. Owner to confirm or it comes out.
  - `verify_page.py` reports `#miniQuoteForm` has no script. False
    positive: the handler is in `_includes/scripts.html`, which the
    script does not scan.
- Step 6, full homepage audit applied - done, live (25 September 2026).
  Audit findings and what was done about each:
  - Dead links: the "Explore services and guides" row is now built from
    `service_links` in `_data/suburbs.yml` (built: true only) plus every
    built guide in `_data/techtips.yml`. Same gating added to
    `pricing.html` (its "Read more about a repair" section hides itself
    until a service page is built) and the warehousing industry page.
    Three planned slugs added to `service_links` as built: false:
    `gaming-pc-build-perth`, `windows-11-upgrade-perth`,
    `wifi-network-setup-perth`. Site-wide sweep of all 43 built pages:
    zero dead internal links, every JSON-LD block valid.
  - Contrast: `--wa-dk` is now #15803D in every page stylesheet (was
    #16A34A, 3.3:1) and a new `--wa-deep` #166534 is the hover. Every
    white-text WhatsApp button uses `--wa-dk` as its fill: white on the
    old #22C55E was 2.28:1, now 5.02:1. The floating bubble keeps
    #22C55E because it carries an icon, not text.
  - Offer banner: $10 and $99 now come from a new `offers:` list in
    `services.yml` (price.html looks there too), so they are no longer typed anywhere
    on the homepage. The button is a WhatsApp link that pre-fills the claim,
    replacing "#top-quote", which was dead at tablet widths.
  - Hero: the quote card now shows at 721 to 900px (it was display:none,
    so tablets had no form). Phones get a one-line price and promise
    (`.hero-lead`) above the card. Meta description said "Call", now
    "WhatsApp".
  - Font layout shift: metric-matched fallback faces (`Sora Fallback`,
    `DM Sans Fallback`) are declared in `_layouts/default.html` and added
    to every font stack, with size-adjust and ascent/descent overrides
    measured from the real woff2 files. Phone content below the hero
    shifted 57px on font load; now 18px. Desktop: 0 either way.
  - Page order: Services, Reviews, How it works, Packages, Offer, Why us,
    Business IT, Guide, FAQ, Areas, Contact, CTA (reviews were 11th of
    15). Backgrounds now alternate with no two alike in a row. Three
    keyword-stuffed H2s shortened (process, FAQ, guide).
  - Reviews: the six homepage quotes moved word for word into
    `_data/reviews.yml` under `homepage:` and render in a loop with the
    `stars.html` component, plus a "Read our reviews on Google" link.
    Owner decision: never show the review count on a page, even from
    data, because it changes.
    Owner confirmed all six are genuine Google reviews; Harrison and
    Karl-Kristjan were added to `reviews:` (the /reviews page) as well.
  - Stats: "500+ Systems Optimised" (unverified) replaced by "Same day /
    Typical turnaround". The strip's rating was removed: it duplicated
    the quote card's rating directly above and collided with the checks.
  - Reply time: one value, `reply_time` in `_config.yml` ("within 2
    hours"), used by the quote card and the closing CTA, which used to
    promise "within the hour" and "within 2 hours" respectively.
  - Ratings draw as 4.8 of 5 stars, not five full stars.
  - Shared chrome: desktop header has a solid WhatsApp button at 1121px
    and up (measured to fit with real fonts). Kept after review: never in
    the mobile header. Phones: the sticky bar is
    WhatsApp first, quote second. The floating bubble only shows where
    neither of those is on screen (721 to 1120px).
  - Phone sticky bar slides away while the footer is on screen (class
    `at-footer`, set by an IntersectionObserver in scripts.html) and
    returns on scroll up. It used to cover the last footer line on 21
    pages; the 76px body padding-bottom that four stylesheets added for
    it (index, suburb, health-check, reviews) was removed.
  - Motion: `.fade-up`, FAQ chevron and card chevron use `--ease-settle`
    (they overshot). The info strip no longer fades in above the fold.
  - Schema: homepage FAQPage now lists all 12 visible questions (was 9).
    The homepage BreadcrumbList, which used .html URLs, was removed.
  - WhatsApp icon: one `<symbol>` referenced 8 times (the audit said
    about 15 copies; there were 7).
  - `relative_url` added to every internal href and src in index.html,
    header.html, footer.html and sticky-cta.html. Output is identical
    today (root domain, no baseurl); it only matters if the site ever
    moves under a path.
  - Guide CSS: `.guide-block a/p/li/h3...` element-in-class selectors
    replaced with child combinators and `a:not([class])`, per the house
    rule. The guide was already tabbed on desktop too, so the audit's
    "2,200-word wall" was overstated and it was not collapsed further.
  - Not done, needs the owner: real workshop photos; a business email
    to replace the personal Gmail in the contact card (kept because the
    owner asked for it); the "Can't thank Ali enough" quote.
  - Found, not fixed (outside the homepage): `business-it-support.html`
    scrolls sideways at 390px; the pricing-plan carousel overflows.
    It did so before this change too.
- Step 7, site-wide mobile audit applied - done, live (26 September 2026).
  All 43 pages scanned in mobile Chromium at 320/360/390/430/768 with the
  real fonts, before and after, plus a computed-style diff of every element
  on every page to prove the refactors changed nothing.
  - H1 Business IT scrolled sideways on every phone: an inline
    `minmax(420px,1fr)` FAQ grid, now `minmax(min(420px,100%),1fr)`.
  - H2 7 industry pages scrolled sideways at 320px: `.service-links` used
    `1fr`, now `minmax(0,1fr)`, and `.service-link-card > div` has
    `min-width:0`. No page is wider than the device at any tested width.
  - H3 sticky bar over the footer: fixed by the footer slide-away (step 6).
  - H4 iOS zoom on focus: every form field is now 16px (quote-request,
    suburb, industry and Business IT forms, pricing search).
  - H5 logo: `logo.png` was 5000x5000 (194KB) shown at 38px. It is now a
    1024x1024 master (17KB) for OG/schema, and header/footer use a new
    114x114 `logo-sm.png` (2KB).
  - M1 stuck hover on touch: 148 pure `:hover` rules wrapped in place in
    `@media (hover: hover)`. Zero computed-style change.
  - M2 tap targets: one documented TOUCH TARGETS block in shell.css
    (phones, tablets and coarse pointers). Buttons/chips/tabs min-height
    44px; text links padding plus equal negative margin; carousel dots an
    invisible 44px hit area (verified by tap position). Hamburger 44px.
    Exempt: inline links inside running text, and form labels (the input
    is the target).
  - M3 call links: all 6 `tel:` links replaced with WhatsApp or removed
    (footer, quote-request, privacy x2, terms, Business IT). Footer head
    "Visit or Call" is now "Visit or Message".
  - M4 text under 12px: every non-eyebrow text style raised to 12px (the
    Label size). Uppercase eyebrows stay at their type-scale size; tick
    glyph icons and SVG chart text are not text.
  - M5/L3 duplicate selectors: 69 exact duplicates merged (57 in
    industry.css). A shell.css merge that moved `.logo-name` past its
    mobile override was caught by the diff and done by hand instead.
  - L1 `text-size-adjust:100%` on html.
  - L2 element-in-class selectors: 199 rules now end in
    `:where(:not([class]))` (zero added specificity). 32 were left as is
    because an element with a class really relies on them (checked in the
    DOM of every page). Zero computed-style change.
  - Also: the phone title above the quote card is centred and balanced,
    and on screens under 380px the card header drops its "Tap to close"
    hint so it stays on one line.
  - Still open (owner): "no charge" in privacy.html and terms.html is on
    the banned list but is legal wording, so it was not changed.
- Not started: a true content/layout reform of individual sections
  (new section designs, not just consistent versions of the current
  ones). Discussed as a bigger, separate conversation from the
  consistency pass above.

## Sitewide consistency audit (in progress)

A full audit (CSS inconsistencies within the homepage, the homepage
against every other page stylesheet, and SEO) turned up a prioritised
list. Progress by priority:

- **Priority 1, bugs and rule breaks - done, live.** FAQ answers were
  clipping on phones (fixed properly in Priority 3 below, not just
  patched); hero trust badge and a "Why choose us" card both implied a
  refund guarantee that contradicts the locked $120-charged-regardless
  policy, reworded to match it; `payment-pill` and `pkg-count-pill`
  were capsule-styled labels, converted to plain uppercase text; three
  stray " , " left over from an em-dash cleanup, fixed.
- **Priority 2, homepage CSS inconsistencies - done, live.** Card
  titles/text across Services, Business IT, Process and Why-us cards
  were on two different sizes, unified to the documented H3 (1.05rem)
  and Small (13px) roles. Closing CTA heading was near hero-sized
  (clamp up to 2.6rem), brought down to the standard 1.45rem H2 scale;
  its padding (80px) brought to the standard 96px. All 11 px-based
  `letter-spacing` values converted to em. 3 dead CSS classes removed
  (`hero-eyebrow`, `hero-eyebrow-dot`, `svc-perk-line`, including their
  references inside shared media queries). 4 hardcoded radius values
  that duplicated `var(--radius)` / `var(--radius-sm)` tokenized.
- **Priority 3, one FAQ component sitewide - in progress, not yet
  pushed.** The FAQ accordion existed in 7 different shapes across the
  site (own class names, own look, own open/close behaviour) - the
  single biggest cross-page inconsistency found. `pricing.html` turned
  out to already use a better technique than the homepage: it sizes
  the open answer to its actual content (`grid-template-rows: 0fr` to
  `1fr`) rather than a fixed max-height, so it can never clip an
  answer no matter how long. That became the canonical pattern -
  `.faq-item` / `.faq-q` (button, with a `<polyline>` chevron svg that
  rotates 180deg) / `.faq-a` (a `<p>`-wrapped answer). Converted so
  far: `index.html`/`index.css` (also retired the max-height band-aid
  from the Priority 1 fix in favour of this), `pricing.css` (padding
  and radius brought fully in line, markup untouched, was already
  close), `pc-health-check-perth.html`/`health-check.css` (was a
  joined-panel style with instant show/hide, converted to individual
  cards with the animation; also caught a stale mobile rule that would
  have left a visible gap on collapsed answers), `reviews.html`
  (native `<details>` driven by a `{% for f in rv.faqs %}` loop over
  `_data/reviews.yml`, converted to the button/div pattern - one
  template edit covers all 12 items) and `reviews.css`.
  **Still to convert:**
    - `business-it-support.html` / `assets/css/pages/business-it.css`
      - raw `<details class="hov-edge" style="...">` with the styling
        written inline on the element, no `faq-*` classes at all.
    - `_layouts/suburb.html` / `assets/css/pages/suburb.css` - own
      `sub-faq-*` prefixed classes. One layout edit fixes all 18
      suburb pages.
    - `_layouts/tech-tip.html` / `assets/css/pages/tech-tip.css` - own
      `tip-faq-*` prefixed classes. One layout edit fixes all 6 guides.
    - The 8 `it-support-*-perth.html` industry pages /
      `assets/css/pages/industry.css` - `.faq-question` /
      `.faq-answer` classes, with their own JS handler already living
      in `_includes/scripts.html` (added separately at some point
      because the shared `.faq-q` handler was never wired to them).
      Once these are converted, that now-redundant handler block in
      `scripts.html` should come out.
    - **Done 25 Sep 2026:** `industry.css` had been saved as an EMPTY
      file by commit e7f7400 ("d"), so all 9 industry pages rendered
      unstyled. Restored from 04aa92a, then the undefined `--teal`,
      `--green` and `--radius-lg` below were defined. Check any upload
      for a 0-byte file before committing.
    - `industry.css` also has a real, separate bug found in the same
      audit, unrelated to the FAQ: it uses `--teal` and `--radius-lg`
      without ever defining them, so the gradient top bars on the
      industry pages don't render and some corners come out square.
      Worth fixing in the same pass since it's the same file.
  After every page is converted: run `verify_page.py` on each,
  re-diff every changed file against live, and only then deliver.
- **Priority 4, cross-stylesheet CSS inconsistencies - not started.**
  Missing/undefined CSS custom properties on several page stylesheets
  (beyond the `industry.css` one above), section heading sizes and
  padding drifting page to page, more px-based letter-spacing outside
  index.css.
- **Priority 5, SEO - not started.** FAQ schema on the homepage
  declares 9 questions but 12 are visible; a `BreadcrumbList` schema on
  the homepage that doesn't belong there and uses `.html` URLs; 10 dead
  links in the homepage's "popular services" row (7 are planned
  service pages, 3 aren't even on the roadmap); keyword-stuffed copy
  in the suburbs intro and guide section.

Two open questions from the audit the user hasn't answered yet:
whether to edit a customer review quote that names the owner ("Can't
thank Ali enough"), and whether the brand badges (Crucial, Samsung)
count as the kind of label the no-pill rule covers.

**Other pages**: home, pricing, business IT support, PC health check, quote
request, reviews, privacy, terms.

The Tech Tips hub lists and links every guide in `_data/techtips.yml`,
built or not. Unbuilt ones 404 for now, and that is fine while the
cluster is being built out.

---

## To build

**Tech Tips guides:** all 6 built and `built: true` in `_data/techtips.yml`
(`why-is-my-pc-so-slow`, `how-to-tell-if-pc-has-virus`,
`signs-hard-drive-failing`, `how-much-does-pc-repair-cost-perth`,
`ssd-upgrade-perth-guide`, `laptop-screen-replacement-physical-repairs`).

**Suburb pages**: all 18 built. Nothing left in this section.

**Service pages** (9), all built. Plan approved from the Search Console export.

Service page audit, all applied:

- `/services` hub lists the nine (from `service_links`, kind: service), in
  demand order, each with a `summary` and a `from_key` price. It is linked
  from the footer (not the header, by owner choice), and every service page breadcrumb is now
  Home / Services / page (visible and in schema).
- Homepage service card titles link to their pages. The explore row shows
  six on phones then "Show more" / "Show less" (no count).
- Every service page links in its body to the related service pages; the
  cost and slow-PC guides and the Health Check symptom cards link to them.
- Laptop screen prices include the panel and the labour (owner confirmed);
  the quote itemises both. Price boxes can use an option tier key; a price
  already shown in full is a one-line reminder the second time.
- Price table: diagnostic no longer listed twice; on phones each row keeps
  its note under the name. A mid-page call to action sits halfway down.
- Section headings use each page's `topic`; each page has its own
  `costs_intro` and its own FAQ in place of the shared booking question.
- Contrast: breadcrumb current page 4.8:1, small form text 7.4:1. Nav
  tightening breakpoint moved from 1120 to 1200px for the Services pill.
- Footer split into Repairs (the nine) and Company.
All share `_layouts/service.html` + `assets/css/pages/service.css`
(same design as the Tech Tips guides). Each page file is front matter
only: facts, written copy, repairs with a `price_key` each, FAQs with
`[[key]]` price tokens, and suburb and guide slugs. The page types no
price; the layout pulls every figure and its note from services.yml.
A page links out only once its `service_links` entry in
`_data/suburbs.yml` is `built: true`, and flipping that flag also adds
it to the homepage links, the suburb "Repairs we do most" block, the
footer Services column and the other service pages.

Build order, one page per push:

    1. laptop-repair-perth          BUILT (absorbs laptop battery, #battery)
    2. virus-removal-perth          BUILT
    3. slow-computer-repair-perth   BUILT
    4. laptop-screen-repair-perth   BUILT (new; replaces the Wi-Fi page)
    5. data-recovery-perth          BUILT (absorbs backup setup, #backup)
    6. windows-reinstall-perth      BUILT (kept: position 5.3; windows-11 301s here)
    7. gaming-pc-build-perth        BUILT (gaming PC repair and builds)
    8. computer-upgrades-perth      BUILT (renamed from ssd-upgrade-perth)
    9. computer-wont-turn-on-perth  BUILT

A Tech Tips guide links to its service page through `service_page:` in
its front matter (shown in the costs section once the page is built).
The laptop screen guide already does this.

**Redirects at launch:** all 72 are in `_launch/cloudflare-bulk-redirects.csv`,
built from the live repo (pages, sitemap, internal links) and the Search
Console export, none unmapped. See LAUNCH.md. The planned Wi-Fi page never
existed on the live site, so it needs no redirect.

**SEO at launch (production), found in the laptop repair audit:**

- `robots.txt` lets crawlers in on both sites; only the live one (staging:
  false) names the sitemap. `staging: true` adds noindex to every page,
  and that is what keeps staging out of Google (a Disallow would stop
  Google reading the noindex).
- `sitemap.xml` is built from the pages (clean URLs, no .html).
- The `.html` duplicates Search Console lists are in the redirect CSV.
- Old production `/laptop-repair-perth` had a canonical pointing at a URL that
  does not exist. The new page's canonical is self-referencing.
- Queries this page targets (16-month GSC): laptop repair near me (263 impr,
  pos 8.4), laptop repair perth (236, pos 33), laptop repairs (178),
  laptop repair (157, pos 9.8), laptop battery replacement (130),
  laptop repairs perth (88), laptop battery replacement perth (57, pos 18),
  laptop repair shop near me (27, pos 8.3), macbook repair perth (pos 2.5),
  laptop cleaning service (24), laptop keyboard repair perth (12),
  same day laptop repair (pos 7). Screen queries go to laptop-screen-repair-perth.
- `pc-health-check-perth` typed prices: all replaced with price.html
  includes (September 2026).

---

## Deferred on purpose

- **Drive times** on 7 suburb pages are estimates, not yet checked against
  Google Maps. Each page carries a "Directions from ..." link.
- **Workshop photos**: suburb and guide pages have no real photographs.
  Needed from the owner.
- **"No surprises"** is in the homepage description, the ticker and a few
  section intros (the footer no longer uses it). It reads like the banned reassurance
  lines, but it is the brand line, so it stays until the owner decides.
- **Contact email** on the homepage visit card carries the owner's name
  (aly.imran.raja@gmail.com). Swap for a business address when there is one.
- **Low SEO items deliberately left alone**: shared FAQs repeated in schema
  across pages, plain suburb names as homepage link text, and suburbs
  sharing a postcode. Each was judged and rejected, not missed.

---

## Design standard (type scale)

Every page stylesheet follows this. New pages are built on it from day one;
older stylesheets are moved onto it one file per push after the build-out,
`index.css` first. Each page CSS still carries its own `:root`; this is a
written standard every file copies, not a shared file.

| Role        | Size                          | Weight | Line height      | Tracking            |
|-------------|-------------------------------|--------|------------------|---------------------|
| H1          | clamp(1.8rem, 4vw, 2.7rem)    | 800    | 1.1              | -0.035em            |
| H2          | 1.45rem (1.3rem on phones)    | 800    | 1.2              | -0.02em             |
| H3          | 1.05rem                       | 700    | 1.3              | -0.01em             |
| Panel title | 1.3rem                        | 800    | 1.25             | -0.02em             |
| Lede        | 1.0625rem (1rem on phones)    | 400    | 1.75             | 0                   |
| Body        | 16px                          | 400    | 1.85 prose, 1.6 UI | 0                 |
| Small       | 13px                          | 500    | 1.5              | 0                   |
| Label       | 12px                          | 700    | 1.4              | 0.02em              |
| Eyebrow     | 11px                          | 700    | 1.4              | 0.09em, uppercase   |
| Button      | 15px                          | 700    | 1                | 0                   |
| Input       | 16px                          | 400    | 1.4              | 0                   |

- Tracking is always in `em`, never `px`.
- Inputs are 16px: anything smaller makes iPhones zoom the page on focus.
- Eyebrows and labels are plain uppercase text, never pills.
- The homepage hero is the one exception allowed a larger display H1.
- The teal is `#00CFFF` everywhere.
- Text contrast is WCAG AA everywhere (4.5:1, 3:1 for large text),
  checked on every page at phone and desktop width, including errors,
  success panels, the open menu and every quiz result. Greys:
  `--muted` #5E6E84 (passes on white and every pale panel), `--muted2`
  #64748B (white and #F8FAFC only; never on #F1F5F9 or #EEF3FF). Never
  #94A3B8 for text. White text on dark sections is at least 70%.
  Coloured labels use the -700 shade (#15803D, #B45309, #0E7490).
  Decorative numbers that are not meant to be read carry aria-hidden.

**Quote forms:** every quote form offers WhatsApp and Email as reply
options. No phone call option, on any form.

**Writing style** (from the "signs of AI writing" pass, September 2026):
section headings in sentence case (page titles, product names and
proper names keep their capitals); no emoji, icons are SVG; no
"No X, no Y, no Z" lists in sales copy (plain descriptions of symptoms
are fine, and "no fix, no fee" is the industry term); no "not just X
but Y"; no false "from X to Y" ranges; no teaser labels like "The
question worth asking:", lead with the fact; no ", ensuring..." tails;
no "knows X, knows Y and knows Z" triples; straight apostrophes.
Customer reviews and the client quote are never edited.

## Mobile standard (phones, max-width 720px)

One set of spacing numbers on every page, applied September 2026. Each page
stylesheet has the `--m-*` tokens in its `:root` and a "MOBILE STANDARD"
block as the last thing in the file, mapping that page's classes onto the
tokens. Desktop and tablet are untouched. A new page or section gets its
classes added to its stylesheet's block; never a one-off number.

| What | Phone value |
|---|---|
| Side margin | 20px (carousels bleed to the edge, first card on the 20px line) |
| Sections | 48 top and bottom; hero 24 under the header, 48 below |
| Thin bands | 24 top and bottom |
| Cards and lists inside a section | 24 above and below |
| Cards | 20 padding, 14 corners |
| Boxes inside a card | 16 padding, 12 corners |
| Table-style rows | 14 top/bottom, 16 sides |
| Gaps | 12 between cards, 10 between stacked rows, 8 between chips |
| H1 | 1.7rem |
| H2 | 1.3rem, 12 below; the element after it has no top margin |
| Article head | 24 under breadcrumb, 12 under label, 16 under H1, 24 under lede and byline, 48 to the next block |
| Article body H2 | 48 above |
| Reading text | 16px |
| Smallest text | 13px (uppercase labels excepted) |
| Buttons | 48px tall; standalone buttons full width |

Exempt: the trust ticker strip, and chips (their own 8 gap).
`shell.css` cannot use `var()`, so its phone button block writes 48px.

Check it on the live site: Actions > Verify live site > Run workflow. The
"Mobile standard" step (`_launch/mobile-check.js`) measures every page in
the sitemap at 390px and 360px and fails on anything off the standard.

---

## Business IT and industry pages: email only

Owner decision, October 2026: the Business IT page and all nine
it-support-*-perth industry pages are professional and email only. No
WhatsApp anywhere on them. Privacy and terms are email only too, with an
"Email us" header button (contact_href and contact_label in front matter). `contact: email` in its front
matter switches the shared chrome: the header button becomes "Book a free
IT call" (blue, scrolls to the form), the footer shows the email instead
of WhatsApp, and the phone bar and floating bubble are not rendered. The
form messages point to the email, not the phone. The plan features say
phone and email support. `contact_form` sets where the header button
scrolls (#audit on the industry pages, #audit-section by default). Every
other page keeps WhatsApp. It still uses
the owner's Gmail until a business address exists.

---

## Motion and feedback standard

**One control, one press.** A link or button presses as a single unit
(scale on :active from pointer-down). No part inside it (an icon, the logo
mark, an arrow) gets its own press motion. The logo has no hover effect.
No hover nudges either: arrows and icons inside links do not move on hover
(colour changes only).

Applied October 2026. Motion here is feedback, not decoration.

- **Press.** Every button, card and chip responds the moment it is pressed
  (compress to 0.97-0.985, or a colour change on rows and text links) and
  settles back on release without overshoot. Where a control also lifts on
  hover, the press uses the `scale` property, not `transform`: a hover lift
  in a later or more specific rule used to win while the mouse was held, so
  a desktop click showed nothing.
- **Forms.** Every quote and audit form uses the shared sequence in
  `scripts.html`: `formSending(btn)` (spinner, "Sending", full colour),
  `formSent(btn, then)` (green tick, "Sent", 0.7s), `formShow(el)` (the
  confirmation fades and lifts in), `formReset(btn)` on failure (puts the
  original label and icon back). A new form calls these; it never sets its
  own button text. Styles are in `shell.css`. The Business IT call form now
  confirms on the page too; it used to post away to Web3Forms.
- **Hover.** Arrow links nudge their arrow 2-3px. Hover only exists inside
  `@media (hover: hover)`.
- **Reveal.** Homepage, Business IT and PC Health Check use `.fade-up`
  (a fade and short lift, staggered 60ms). Other pages do not animate content
  in, on purpose: they are search landing pages and guides, where text
  should be readable immediately.
- **Not used, on purpose:** magnetic buttons, parallax, pinned scroll
  scenes and clip-mask text reveals. They slow phones, can trigger motion
  sickness and do nothing to help someone book a repair.
- **Reduced motion.** Every lift and press goes, the spinner breathes
  instead of turning, and confirmations fade without moving.

---

## Footer (October 2026)

Condensed without dropping service or suburb links. Repairs keeps all its
service pages, in two columns (`footer_label` in `_data/suburbs.yml` gives a
shorter name for the footer only). Company is five links: All Services,
Pricing, Business IT Support, Reviews & FAQ, Get a Quote. Terms and Privacy
sit in the bottom bar; Health Check and Tech Tips are in the header. On
phones (760px and under) Repairs, Company and Suburbs collapse behind their
headings (`.footer-sec`, toggled in scripts.html); contact stays open, and
with no JavaScript every list shows. Heights: desktop 715 to 546px, tablet
1159 to 818px, phone about 1150 to 624px.
The brand block reads "We fix your tech properly." (owner's wording) with a short
brand line, not prices (owner decision, October 2026); prices live on the
pricing page and the service pages.

---

## Header (October 2026)

Decided by an LLM council review for SEO, usability and conversion. Do not
reshuffle without a reason.

- Desktop: Logo | Repairs (menu) | Pricing | Reviews | Free PC Health Check |
  Business IT | WhatsApp Us. Plain text links, no pills. The WhatsApp button
  shows from 901px up; the floating bubble only shows on tablets (721-900).
- Repairs menu: with a mouse it opens on hover (60ms intent delay, closes
  220ms after leaving; a mouse click keeps it open). Keyboard and touch open
  it on click / Enter (aria-expanded). Escape / outside click / Tab out close
  it, arrow keys move through it. No prices in it, on purpose.
  Built from service_links in _data/suburbs.yml (kind: service, built: true),
  ordered by nav_order; nav_label overrides label there only. A new service
  page appears by itself once built: true; give it a nav_order.
  Below a divider, in brand blue: All repair services (/services), Tech Tips
  (/tech-tips). It animates in and out from its button and reverses cleanly
  if clicked mid-way (class-based transitions, not [hidden]).
- Phones: Repairs (closed by default, unfolds in place, inert while folded)
  then Pricing, Reviews, Free PC Health Check, Tech Tips, Business IT, Get a
  quote. Closing the menu folds Repairs again. WhatsApp stays on the sticky bar,
  which carries the line "24/7 drop-off, Canning Vale".
- Business IT (contact: email) keeps "Book a free IT call" and no WhatsApp.
- The current page's link gets aria-current="page" (scripts.html).
- Tech Tips is in the Repairs menu (desktop), top level on phones, and in the
  footer Company list.

## /services hub (October 2026)

All from data, nothing typed: the nine service cards (nav_order), every
service in services.yml by category as name / price / link, and the extras
minus the biz- ones. What each price covers stays on /pricing only, so the
two pages do not duplicate. A row links to the service page that lists its
key most (headline "from" price wins, option keys count, ties go to the
page with fewer repairs); `page:` on a services.yml entry overrides it.
The quote form is _includes/quote-form.html, shared with every service page.

## Case Swap (October 2026)

case-swap in services.yml, Gaming PC Builds > Case swaps: from 129, options
case-swap-air 129 and case-swap-aio 169 (custom loops quoted). Priced under
Essential Assembly since there is no Windows install. Shown on /pricing,
/services, the gaming page (section, costs intro, FAQ) and the homepage
gaming card; pricing search finds "case swap", "new case", "transfer".
Terms section 6 covers a part that does not fit the new case.

## WhatsApp messages

_includes/wa-href.html builds every shared WhatsApp link (header button,
sticky bar, bubble, service and suburb CTAs). Message order: include text,
then page.wa_text (each service page sets one, pricing too), then on suburb
pages "Hi! I'm in <suburb> and need a computer repair quote.", then the
generic quote message. Every wa.me link on the site now carries a message:
the footer number, quote-request ("I've just sent a quote request" on the
confirmation), privacy and terms have their own, and the /pricing package
buttons go through wa-href too. A bare wa.me link with no ?text= is a bug.

## Where the first call to action sits (October 2026)

Every page gets a way to act on its first screen or close to it:
- Service pages and /services: WhatsApp button + "Or get a fixed price
  online" under the intro (.sv-act).
- Suburb pages: the same pair under the standfirst (.sub-act in
  _layouts/suburb.html), WhatsApp message names the suburb.
- Industry pages: an .inline-cta straight after the .stat-row ("Book a free
  IT audit" to #audit, plans link). Trades says "an IT audit", no "free",
  matching the rest of that page.
- /pricing: the Book buttons on every row, plus a closing box after the FAQ.
- Tech Tips hub: health check first, then a WhatsApp link under the buttons.
The sticky bar covers phones everywhere else. Audit copy never says "at no
cost" or "most <industry> owners find": "free" already says the first,
and the second implies clients we do not have.

## Logo (owner decision, October 2026)

The gradient monitor logo **with the green tick** is the main logo, everywhere:
header, footer, phone menu (`logo-sm.png`), schema (`logo.png`), iPhone home
screen (`apple-touch-icon.png`), the 14 share images, and all social profiles.
The **only** place without the tick is the browser-tab favicon (`favicon.ico`,
`favicon.png`), which also has transparent rounded corners. When an icon file
changes, bump its `?v=` number in `default.html`, `header.html` and `footer.html`
so browsers drop the cached copy.

---

## Accessibility rules (axe-core audit, October 2026)

Every page scanned with axe-core (WCAG 2.2 AA plus best practice) at
1280 and 390px. What it found and the rule that now stands:

- **FAQ answers** carry no `role="region"`. Ninety-seven unnamed regions
  were flooding the landmark list. The button's `aria-expanded` and
  `aria-controls` are enough. A closed answer is `visibility: hidden` (it
  waits out the close animation), so its links leave the tab order: before
  this, Tab landed on invisible links inside closed answers.
- **Horizontal scroll strips** with nothing focusable inside get
  `tabindex="0" role="region" aria-label="..."` and a focus ring, so arrow
  keys can scroll them.
- **One `<main>` per page.** The layout provides it; a page never adds its own.
- **`role="listitem"`** only inside a `role="list"` parent, and never on
  `<article>`.
- **Decorative icons** (SVG or a glyph like "!") carry `aria-hidden="true"`.
  Controls that hold only an icon need an `aria-label`.
- **Link text says where it goes.** No bare "Learn more" or "Read more":
  Lighthouse SEO fails it even with an aria-label. Lighthouse SEO is 100 on
  every page except 404.html, which is noindex on purpose.
- **Accepted:** the faint "01 02 03" step numbers fail contrast on
  purpose. They are aria-hidden watermarks, which WCAG exempts as decoration.

---

## Tech Tips rules

- Guides say what a symptom **means**, how urgent it is, and what it costs.
  **Never how to fix it.** No steps, no downloads, no settings to change.
  The live `/blog` versions break this and are rewritten, not ported.
- Guides answer questions ("why is my PC slow"). Service pages sell the
  repair ("data recovery Perth"). A guide must not chase its service page's
  search term; it links to it instead.
- Keep the existing slugs. The live site serves them under `/blog/<slug>`,
  so each old URL redirects one-to-one at launch.

---

## At launch

**Launched 26 Sep 2026.** www.fixmypcperth.com now serves this site from
`ali-rajaa/fixmypcperth` (Pages source: GitHub Actions; CNAME www;
`staging: false`). The old plain-HTML site was removed in full. Cloudflare
bulk list `fixmypcperth_launch` holds the 73 redirects and is live.
"Verify live site" (Actions, run on demand): 9 of 9 live checks and 73 of
73 redirects pass; 15 old .html addresses take two hops because a
Cloudflare .html rule runs first, which is fine. Staging was later deleted on
purpose; the live repo is the only one (`staging: false` stays in
_config.yml).

**After launch (SEO audit, applied 26 Sep 2026):**

- Every page now has a wide 1200x630 share card (summary_large_image).
  The nine service pages, pricing and business IT set their own with
  `image:` / `image_alt:` in front matter (cards in `assets/og/`);
  suburbs and Tech Tips keep theirs; everything else uses
  `assets/og/default.png`. `og:locale` is en_AU.
- H1s: /reviews "Computer repair reviews from Perth customers", /quote-request
  "Get a Free Computer Repair Quote in Perth".
- Fonts are self-hosted from `assets/fonts` (Sora and DM Sans variable
  woff2, latin preloaded); Google Fonts is no longer called.
- Favicons: favicon.ico (16/32/48), favicon.png 96px, apple-touch-icon.png
  180px.
- `url:` is set in _config.yml; templates build full URLs from
  `{{ site.url }}` instead of typing the domain.
- Suburb FAQ schema holds only each suburb's own questions; the five
  general ones repeated on every suburb page are visible but no longer
  marked up.

**Consistency pass (26 Sep 2026):**

- One FAQ component sitewide, the homepage one: `.faq-item` / `.faq-q` /
  `.faq-a`, an identical CSS block in every page stylesheet that has an
  FAQ (index, pricing, reviews, health-check, service, tech-tip, suburb,
  industry, business-it), one JS handler in `_includes/scripts.html`.
  The sub-faq, tip-faq, sv-faq, industry faq-question and Business IT
  `<details>` versions are gone. Checked on all 47 FAQ pages against the
  homepage, desktop and phone.
- Free PC Health Check and Business IT: every business price comes from
  services.yml (added `business-it-first-month` and `biz-cyber-training`).
  "5/5" ratings removed (Business IT and the sitewide ticker); they read
  the Google rating from `_data/reviews.yml`.
- Business IT: all 213 inline styles moved into business-it.css classes
  (tone-* classes for the coloured cards); capsule tags on the Why cards
  are plain text; section headings on the H2 standard; its own footer and
  WhatsApp-button overrides removed; the "Also need PC repair?" row lists
  the built service pages from data.
- Industry pages: industry.css rebuilt (it was eight sheets pasted
  together: 43 repeated properties, five copies of the phone block, nav
  and footer rules), H1/H2 on the type scale, tracking in em, the
  other-industries block is one class set on all nine pages.
- Every page stylesheet now defines every token it uses (pricing, legal,
  quote and tech-tip were missing --radius and others).

Everything is in LAUNCH.md, in order: Cloudflare redirects, a final
staging pass, the switch (copy to the live repo, CNAME, `staging: false`,
Pages source to GitHub Actions), checks including
`_launch/test-redirects.sh`, then Search Console, with a rollback plan.

---

## Traps that have actually bitten

- The repo is CRLF. An edit written with `\n` matches nothing and fails
  silently. Assert every replacement matched exactly once.
- A layout with no front matter renders with no `<head>`, so no stylesheet
  and no nav.
- Never put an element selector inside a class scope in CSS
  (`.sub-body a`). It outranks component classes and wins silently; that
  once made every CTA button's text blue on a blue fill.
- Front matter cannot run Liquid, so a price include inside front matter
  renders as literal text.
- Prices are never typed. They come from `_data/services.yml` through
  `price.html`. Problem cards must use a service with a real number, and
  never an add-on (`plus: true`). `price.html` has 4 modes beyond the
  default: `bare=true` (no prefix/suffix), `raw=true` (no wrapping span,
  for inside JSON or an SVG), `numeric=true` (bare digits, no `$`, for a
  schema.org `"price"` field), `was=true` (a package's `was:` text).