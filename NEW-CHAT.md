# New chat: start here

Paste this into the new chat:

> Working on fixmypcperth (repo `ali-rajaa/fixmypcperth`, live only,
> push straight to `main`). Before doing anything, read `STATUS.md`,
> starting with **"Latest session (20 to 22 October 2026)"**. It lists
> every change made on 20 to 22 October 2026, the owner decisions that are
> now locked, how everything was tested, and what is still open. Check the
> latest commits on `main` so you know the current state. Do not re-decide
> anything marked locked. Then continue with: <your task>.

## First thing to check

At hand-off on 22 October, two GitHub Actions runs were still queued on
GitHub's side and had not started:

- **Build and deploy run 94**, commit `7d009b9` (the phone menu trim and
  these notes).
- **Verify live site run 48**.

Open the repo's Actions tab and confirm both succeeded. If Verify live
site fails, read its log before changing anything.

- **Earlier failures:** both earlier failures on 22 October were the web
  host answering one request with an error page or a 503. The checkers now
  retry a page before counting it.
- **Already passed live:** the phone layout check (0 problems on 53 pages)
  and all 73 redirects, on the earlier version.

## Headline updates, 20 to 22 October 2026

- **Phone number:** 0470 308 676 everywhere, WhatsApp included.
- **Payment:** card, PayID or bank transfer, and cash, with no surcharge.
- **Reviews:** 10 new reviews, rated 4.8 from 47. The reviews row always
  scrolls and has no pause button.
- **Homepage:** restructured, with a minimal contact block and a square map.
- **Wording:** the word "workshop" is gone sitewide.
- **Suburb pages (18):**
  - unique copy
  - laptop/desktop/data tabs, a short price list, grouped FAQs
  - entity schema
  - drive times hidden until checked
- **Contact order:** Call, then WhatsApp, then Email everywhere, the quote
  forms included. Call and WhatsApp stay together in the navigation.
- **Phone menu:** Repairs, Pricing, Free PC Health Check, Business IT, then
  Call | WhatsApp | Get a quote.
- **Live checks:** the live-site checks retry a page before failing it.

## Still needed from the owner

- Check the 17 suburb drive times on Google Maps.
- The Wikidata IDs for each suburb.
- Real repair jobs for the suburb pages.
- The `GOOGLE_PLACES_API_KEY` secret, so the rating can update itself.
