# Build status

## Converted to the shared header and footer (14 pages)

- `/` home
- `/pricing`
- `/quiz`
- `/reviews`
- `/techtips` (was `/blog`)
- `/techtips/*` — all 8 articles (were `/blog/*`)
- `/privacy` — new page

These render from `_layouts/default.html` with `_includes/header.html`,
`_includes/footer.html` and `_includes/sticky-cta.html`. One header, one footer.

## Left untouched, still live and working (41 pages)

All service pages, the 8 industry IT pages, the 8 suburb pages,
`/business-it-support`, `/quote-request` and `/terms`.

These have no front matter, so Jekyll copies them through verbatim. They serve
exactly as they do today, with their own headers. They earn 39 clicks and 4,535
impressions a year, which is why they were not replaced with placeholders.

Only change made to them: `blog` links repointed to `techtips`.

## Next batches, in traffic order

1. `/business-it-support` (343 impressions), `/quote-request`, `/terms`
2. The 8 suburb pages — `/suburbs/cannington` earns 10 clicks
3. The 11 service pages
4. The 8 industry IT pages (125 impressions, 0 clicks — candidates to cut)
5. Then generate the 11 new suburb pages from `_data/suburbs.yml`
6. Then `404.html`

## Known, deliberate

- 12 homepage links to unbuilt suburbs point at `/quote-request` with
  `rel="nofollow"` rather than being dead `#` anchors. They become real links
  when those pages exist.
- `_data/services.yml` holds the authoritative prices but pages still hard-code
  them. Wiring pages to the data file comes after the conversion is complete.
