# New chat: start here

Paste this into the new chat:

> Working on fixmypcperth (repo `ali-rajaa/fixmypcperth`, live only,
> push straight to `main`). Before doing anything, read `STATUS.md`,
> starting with **"Latest session (20 to 22 October 2026)"**. It lists
> every change made on 20 to 22 October 2026, the owner decisions that are
> now locked, how everything was tested, and what is still open. Check the
> latest commits on `main` so you know the current state. Do not re-decide
> anything marked locked. Then continue with: <your task>.

## State at hand-off (22 October 2026)

Everything is live and verified:

- **Deploys:** Build and deploy runs 94 and 95 both succeeded.
- **Live check:** Verify live site run 48 passed all three steps: the live
  site checks, every redirect, and the phone mobile standard on every page.
- **Earlier failures:** the two earlier failures that day were the web host
  answering one request with an error page or a 503. The checkers now retry
  a page before counting it.

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
