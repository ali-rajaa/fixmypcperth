# Price Reconciliation — fill in the right column, I do the rest

Every price claim on the site, grouped by service. `pricing.html` is shown as the
authority. Fill in **CORRECT** for each row, then send this file back and I will
propagate it to all 43 pages in one pass, including titles, meta descriptions,
Open Graph tags and JSON-LD schema.

Where the "correct" answer is just the pricing.html value, write `pricing`.

---

## 1. Virus & malware removal — BLOCKING

This is the biggest conflict on the site and I will not guess it.

| Source | Says |
|---|---|
| `pricing.html` | **$99** |
| `virus-removal-perth.html` | **$140 flat** — in the `<title>`, meta description, `og:title`, H1 area, schema, and ~20 places in the body |
| All 8 suburb pages | **$140 flat** |
| All 8 blog posts | **from $80** |
| `index.html` | **from $99** |

The dedicated service page and the pricing page disagree by 41%. Changing it
means rewriting an indexed page title, so I need you to be certain.

**CORRECT: ________**

Also confirm: the virus page sells a package at **$140, was $340**. Is that a
separate bundle that keeps its price, or the same thing?

**Package answer: ________**

---

## 2. Data recovery

| Source | Says |
|---|---|
| `pricing.html` | **$149** failing drive · **$249** dead drive · **$99** external/USB |
| 8 blog posts | from $120 |
| 8 suburb pages | $120 to $300 |
| `index.html`, `quiz.html` | from $149 ✓ |

**CORRECT: ________**

---

## 3. Laptop screen replacement

| Source | Says |
|---|---|
| `pricing.html` | **$145** standard · **$175** touch · **$199** OLED |
| `laptop-screen-repair-perth.html` title | From $120 labour |
| 8 suburb pages | from $150 |
| `index.html` | from $120, and $149 elsewhere on the page |
| `laptop-battery-replacement-perth.html` | from $145 ✓ |

Is $120 a labour-only figure that coexists with $145 all-in, or is it stale?

**CORRECT: ________**

---

## 4. "Same day from $49" — BLOCKING

Appears in the `<title>`, meta description and `og:title` of the homepage and all
8 suburb pages. Nothing on the pricing page supports it for a repair — the
cheapest repair-adjacent item is the $49 pre-purchase check, and the cheapest
listed item at all is $40 for a case fan install.

Keep the headline as a genuine entry price, change it to "from $120", or point
it explicitly at the pre-purchase check?

**CORRECT: ________**

---

## 5. Pricing page hero, internal contradiction

The hero band on `pricing.html` says **$79–$149**. The section directly beneath
it says the common starting point is **$120 all-in**. Which is the headline?

**CORRECT: ________**

---

## 6. Already consistent — no action needed

Confirm these are right and I will lock them into `_data/services.yml`:

| Service | Price |
|---|---|
| SSD upgrade, labour only | $65 |
| SSD supplied & fitted, 500GB | from $150 |
| RAM upgrade, labour only | $55 |
| Windows reinstall + data backup | $120 |
| Windows 11 upgrade with key | $120 |
| Overheating fix / deep clean | $89 |
| Laptop battery replacement, labour | $89 |
| Gaming PC build | $149 / $199 / $249 |
| Business IT support | from $149/mo |
| Remote support session | $45/hr |

---

## 7. Business facts for `_data/site.yml`

Confirm exactly as they should appear everywhere:

- Phone: 0452 573 701
- WhatsApp: wa.me/61452573701
- Address: 7 Barraberry Retreat, Canning Vale WA 6155
- ABN: 67 645 153 359
- Trading since: 2024
- Review count / rating currently claimed: **200+ five-star**. Still accurate?
  It appears in schema, so a wrong number is a rich-result risk.
- Opening hours as they should read: ________
