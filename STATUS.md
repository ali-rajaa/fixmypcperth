# Build status

## Done

**`/` — the homepage.** Converted to Jekyll. Its content is byte-for-byte the
original homepage; only the header, footer, sticky bar and scripts were lifted
out into shared includes.

**The shared shell**, used by every page converted from here on:

| File | What it is |
|---|---|
| `_layouts/default.html` | The only file with `<html>` and `<head>` |
| `_includes/header.html` | Desktop nav + mobile nav + hamburger |
| `_includes/footer.html` | Footer |
| `_includes/sticky-cta.html` | Sticky mobile call bar |
| `_includes/scripts.html` | Scroll bar, menu toggle, GA4 click tracking |
| `assets/css/shell.css` | Chrome styling, desktop and mobile |
| `assets/css/pages/index.css` | The homepage's own styles |

`shell.css` contains no `:root`, `body`, `html` or `*` rules and no `var()`
references, so it cannot override a page's own design tokens. It loads after
the page stylesheet so the header always wins. Its media queries are intact:
below 720px the desktop nav hides, the mobile nav and sticky bar appear, and
the footer stacks.

## Not built yet — deliberately

Every other page is the **untouched original** and still serves exactly as it
does today, with its own inline header. Nothing has been renamed, moved or
edited. Jekyll copies them through verbatim because they have no front matter.

Still to convert, in traffic order from Search Console:

| Page | Clicks / 12mo | Impressions |
|---|---|---|
| `/pricing` | 8 | 1,231 |
| `/reviews` | 5 | 411 |
| `/blog` and 8 posts | 12 | 2,100 |
| `/quiz` | 2 | 116 |
| `/business-it-support` | 0 | 343 |
| `/suburbs/*` (8 pages) | 11 | 1,900 |
| service pages (11) | 4 | 900 |
| `/it-support-*` (8 pages) | 0 | 125 |
| `/terms`, `/quote-request` | 0 | 60 |

Also pending, once pages are converted:
- `/privacy` — new page
- `404.html`
- Renaming `/blog` to `/techtips` (needs 9 redirects)
- Wiring prices to a `_data/services.yml`

## How to convert the next page

1. Copy its `<style>` block to `assets/css/pages/<name>.css`
2. Delete from its body: `#scroll-bar`, `.desk-nav`, `.mob-nav`, `.mob-menu`,
   `<footer>`, `.sticky-cta`, the trailing `<script>`, and all `<style>`
3. Move `<title>`, the meta description and every JSON-LD block into front matter
4. Add `layout: default` and `page_css`

Do one page. Check it in a browser. Then do the next.
