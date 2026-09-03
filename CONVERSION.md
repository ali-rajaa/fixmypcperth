# Jekyll Conversion — state and what's next

## What is built

```
_config.yml                     permalinks left at default (see warning below)
_layouts/default.html           the only file with <html>, <head>, header, footer
_layouts/service.html           wraps default
_layouts/suburb.html            wraps default
_layouts/post.html              wraps default
_includes/header.html           one header, taken from index.html
_includes/footer.html           one footer, taken from index.html
_data/site.yml                  phone, address, ABN, warranty
_data/services.yml              every price, from pricing.html
_data/suburbs.yml               8 built + 11 unbuilt, one row each
assets/css/pages/*.css          43 stylesheets, one per page, byte-identical to before
```

**Three pages are converted**, exactly as the handover prescribes: the homepage,
one service page, one suburb page.

| Page | Was | Now | Cut |
|---|---|---|---|
| `index.html` | 171 KB | 95 KB | 44% |
| `data-recovery-perth.html` | 79 KB | 45 KB | 43% |
| `suburbs/canning-vale.html` | 74 KB | 43 KB | 42% |

None of them contains `<html>`, `<head>`, a nav or a footer any more. The layout
supplies all of it.

## Critical warning about `_config.yml`

**Never set `permalink: pretty`.** Jekyll's default keeps `page.html` serving at
`/page` with no trailing slash, which is exactly what Google has indexed and
exactly the convention you chose. `pretty` would silently move every URL on the
site to a trailing-slash directory form.

## The 40 remaining pages are blocked on CSS, not on effort

The other 40 conversions are mechanical and I can run them in one pass. What
stops me shipping them blind is measurable:

| | |
|---|---|
| Distinct CSS selectors across the site | 1,570 |
| Selectors identical on all 43 pages | **1** |
| Selectors with conflicting definitions | **226** |
| Selectors used on exactly one page | 1,159 |
| `:root` variable blocks | **16 different versions** |
| `body` rules | 6 different versions |
| `footer` rules | 5 different versions |

`:root` holds the design tokens — brand colours, spacing, fonts. Sixteen
different versions means the same header markup renders sixteen different ways
depending on which page it lands on. Merging these into one `site.css` without
reconciling them first would change the appearance of most of the site.

That is why each page currently keeps its own stylesheet. The conversion is
lossless: `assets/css/pages/<page>.css` is byte-identical to the `<style>` block
that page carried before.

## Order for the rest

1. **Reconcile `:root`.** Pick one set of design tokens, apply to all 43 page
   stylesheets, confirm nothing shifts. This is the real work and it needs eyes
   on rendered pages, not a script alone.
2. **Reconcile the other 225 conflicting selectors**, same way.
3. **Split each page stylesheet** into shared rules (→ `assets/css/site.css`,
   with `VERSION n` on line one) and genuinely page-specific rules.
4. **Convert the remaining 40 pages.** One pass once 1–3 are done.
5. **Generate the suburb pages from `_data/suburbs.yml`.** Flip `built: false`
   to `true` and fill in `drive_minutes`. Note: generating pages from a data
   file needs a plugin GitHub Pages does not allow, so either add a GitHub
   Actions build or use one 4-line stub file per suburb.
6. **Move every price reference to `site.data.services`** so a price can only
   ever be changed in one place.

## Verification limitation

I could not run `jekyll build` in this environment — rubygems.org is not
reachable from the sandbox. The structure and Liquid are correct by inspection,
but the build has not been executed. Run it locally or check the Actions tab
after the first push before trusting it.

Test locally with:

```
bundle exec jekyll serve
```

Compare the three converted pages against the live versions before pushing.
