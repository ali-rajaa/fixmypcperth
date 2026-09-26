// Mobile standard check, run on GitHub's servers against the live site
// (Actions > Verify live site). Loads every page in the live sitemap on a
// 390px and a 360px phone and measures it against the mobile standard in
// STATUS.md: 20px side margin, card padding and corners, gaps, H1/H2
// sizes, 12 under each H2, 16px reading text, 13px minimum, 48px
// buttons, no sideways scroll. Exits 1 on anything not in EXEMPT.
const { chromium } = require('playwright');
const BASE = process.env.SITE || 'https://www.fixmypcperth.com';
// Measured on purpose and left as they are (see STATUS.md).
const EXEMPT = [
  /^gutter-(left|right) main>\.pr-tools /,   // search field: text sits after the icon
  /^card \.pr-quick>\.pr-quick-item /,       // chips keep chip padding
  /^gap \.pr-hero-top>\.pr-quick /,          // chips: 8 gap
  /^gap \.page>\.faq-wrap /,                 // FAQ rows spaced by margin, 10
];
(async () => {
  const xml = await (await fetch(BASE + '/sitemap.xml')).text();
  const urls = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map(m => m[1].replace('https://www.fixmypcperth.com', BASE) + (process.env.SUFFIX || ''));
  if (!urls.length) { console.log('No pages in the sitemap'); process.exit(1); }
  const b = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
  let bad = 0, exempt = 0;
  for (const W of [390, 360]) {
    const p = await b.newPage({ viewport: { width: W, height: 844 }, isMobile: true, hasTouch: true });
    await p.route(/google-analytics|googletagmanager|doubleclick/, r => r.abort());
    for (const u of urls) {
      await p.goto(u, { waitUntil: 'load' });
      const V = await p.evaluate((W)=>{
  const V=[]; const vis=e=>{const c=getComputedStyle(e);if(c.display==='none'||c.visibility==='hidden'||parseFloat(c.opacity)===0&&!e.classList.contains('fade-up'))return false;const r=e.getBoundingClientRect();return r.height>0&&r.width>0};
  const cls=e=>{const c=typeof e.className==='string'?e.className.trim().split(/\s+/)[0]:''; return c?'.'+c:e.tagName.toLowerCase()};
  const sig=e=>{let a=e,parts=[];while(a&&a!==document.body&&parts.length<2){parts.unshift(cls(a));a=a.parentElement;}return parts.join('>')};
  const px=v=>Math.round(parseFloat(v)*10)/10||0;
  const inScroller=e=>{let a=e.parentElement;while(a){if(/(auto|scroll)/.test(getComputedStyle(a).overflowX))return true;a=a.parentElement;}return false};
  const negM=(e,s)=>{let a=e;while(a&&a!==s){if(parseFloat(getComputedStyle(a).marginLeft)<0)return true;a=a.parentElement;}return false};
  const main=document.querySelector('main')||document.body;
  const crumb=e=>!!e.closest('[class*=crumb],[aria-label=Breadcrumb]');
  const isCard=e=>{const c=getComputedStyle(e),r=e.getBoundingClientRect(); return ((px(c.borderTopWidth)>0&&c.borderTopStyle!=='none')||(c.backgroundColor!=='rgba(0, 0, 0, 0)'&&c.backgroundColor!=='rgb(255, 255, 255)'&&c.backgroundColor!=='rgb(248, 250, 252)')||c.backgroundImage!=='none')&&px(c.borderTopLeftRadius)>=6&&r.height>50&&r.width>100&&r.width<W-1&&!/^(BUTTON|INPUT|SELECT|TEXTAREA|A)$/.test(e.tagName)&&!/btn|cta-btn|submit|chip|pill|tab|toggle/.test(String(e.className))};
  // 1 gutter: min left of content per top-level block
  let secs=[...main.children].filter(e=>vis(e)&&!/^(SCRIPT|STYLE|HEADER|FOOTER|NAV)$/.test(e.tagName)); if(secs.length===1) secs=[...secs[0].children].filter(vis);
  const hasText=e=>[...e.childNodes].some(n=>n.nodeType===3&&n.textContent.trim().length>2);
  for(const s of secs){ if(s.classList.contains('trust-strip')) continue; const els=[...s.querySelectorAll('*')].filter(e=>vis(e)&&!e.closest('svg')&&!crumb(e)&&!inScroller(e)&&!negM(e,s)&&e.getBoundingClientRect().width<W-1&&e.getBoundingClientRect().width>8&&(hasText(e)||isCard(e)||/^(IMG|INPUT|SELECT|TEXTAREA|BUTTON)$/.test(e.tagName)||(e.tagName==='A'&&e.getBoundingClientRect().height>30)));
    { const c=getComputedStyle(s); if(s.getBoundingClientRect().width<W-1&&((parseFloat(c.borderTopWidth)>0&&c.borderTopStyle!=='none')||c.backgroundColor!=='rgba(0, 0, 0, 0)')) els.push(s); }
    if(!els.length) continue; const L=Math.round(Math.min(...els.map(e=>e.getBoundingClientRect().left))); const R=Math.round(W-Math.max(...els.map(e=>e.getBoundingClientRect().right)));
    if(L!==20) V.push(`gutter-left ${sig(s)} = ${L}`); if(R!==20&&R<40) V.push(`gutter-right ${sig(s)} = ${R}`);}
  for(const sc of main.querySelectorAll('*')){ if(!vis(sc)) continue; const c=getComputedStyle(sc); if(!/(auto|scroll)/.test(c.overflowX)||sc.scrollWidth<=sc.clientWidth+2) continue; if(sc.closest('.trust-strip')) continue;
    const first=[...sc.children].map(k=>k.matches&&isCard(k)?k:[...k.querySelectorAll('*')].find(isCard)).find(Boolean); if(!first) continue; const L=Math.round(first.getBoundingClientRect().left+sc.scrollLeft);
    if(L!==20) V.push(`scroller-first-card ${sig(sc)} left=${L}`);}
  // 2 cards
  const seen=new Set();
  for(const e of main.querySelectorAll('*')){ if(!vis(e)||!isCard(e)) continue; const c=getComputedStyle(e); const k=sig(e);
    const pad=[px(c.paddingTop),px(c.paddingRight),px(c.paddingBottom),px(c.paddingLeft)]; const rad=px(c.borderTopLeftRadius);
    const nested=!!e.parentElement.closest('*') && (()=>{let a=e.parentElement;while(a&&a!==main){if(isCard(a))return true;a=a.parentElement;}return false})();
    const okPad = pad.every(v=>v===20) || (nested&&pad.every(v=>v===16)) || (pad[0]===14&&pad[2]===14&&pad[1]===16&&pad[3]===16) || pad.every(v=>v===0);
    const accent=px(c.borderLeftWidth)>=3&&px(c.borderTopLeftRadius)===0; const okRad = rad===14 || (nested&&rad===12) || (accent&&px(c.borderTopRightRadius)===12);
    const key=k+pad.join('/')+rad; if(seen.has(key)) continue; seen.add(key);
    if(!okPad||!okRad) V.push(`card ${k}${nested?' (nested)':''} pad=${pad.join('/')} r=${rad}`);}
  // 3 gaps between cards / rows
  for(const e of main.querySelectorAll('*')){ if(!vis(e)) continue; const c=getComputedStyle(e); if(c.display!=='grid'&&c.display!=='flex') continue;
    const kids=[...e.children].filter(vis); if(kids.length<2) continue; const cards=kids.filter(isCard).length, faq=kids.filter(k=>k.classList.contains('faq-item')||k.classList.contains('faq-col')).length;
    if(cards<2&&faq<2) continue; const g=[px(c.rowGap),px(c.columnGap)]; const rows=kids.filter(k=>{const kc=getComputedStyle(k);return px(kc.paddingTop)===14&&px(kc.paddingLeft)===16}).length; const want=(faq>=2||rows>=2)?10:null;
    const ok = want? (c.flexDirection==='row'&&c.display==='flex'? g[1]===10||g[1]===0 : g[0]===10) : ((c.display==='flex'&&c.flexDirection==='row')? g[1]===12 : g[0]===12 || g[0]===10&&false);
    if(!ok) V.push(`gap ${sig(e)} ${c.display}${c.display==='flex'?'-'+c.flexDirection:''} = ${g.join('/')} (want ${want||12})`);}
  // 4 headings
  const h1=document.querySelector('h1'); if(h1&&px(getComputedStyle(h1).fontSize)!==27.2) V.push(`h1 ${sig(h1)} = ${px(getComputedStyle(h1).fontSize)}`);
  for(const h of main.querySelectorAll('h2')){ if(!vis(h)) continue; let inCard=false,a=h.parentElement; while(a&&a!==main){if(isCard(a)){inCard=true;break;}a=a.parentElement;} if(inCard) continue;
    const c=getComputedStyle(h); let n=h.nextElementSibling; while(n&&!vis(n)) n=n.nextElementSibling; const after=n?Math.round(n.getBoundingClientRect().top-h.getBoundingClientRect().bottom):null;
    if(px(c.fontSize)!==20.8) V.push(`h2-size ${sig(h)} = ${px(c.fontSize)}`); if(after!==null&&after!==12) V.push(`h2-space-after ${sig(h)} = ${after}`);}
  // 5 reading text
  const rt=new Set();
  for(const e of main.querySelectorAll('p,li')){ if(!vis(e)||e.textContent.trim().length<80||/privacy|byline|fine|small|note-sm|disclaim/.test(String(e.className))) continue; let inCard=false,a=e.parentElement; while(a&&a!==main){if(isCard(a)){inCard=true;break;}a=a.parentElement;} if(inCard) continue;
    const fs=px(getComputedStyle(e).fontSize); if(fs!==16&&!rt.has(sig(e)+fs)){rt.add(sig(e)+fs); V.push(`text ${sig(e)} = ${fs}`);}}
  // 6 minimum size
  const sm=new Set();
  for(const e of main.querySelectorAll('*')){ if(!vis(e)) continue; const own=[...e.childNodes].filter(n=>n.nodeType===3).map(n=>n.textContent.trim()).join(' '); if(own.length<3) continue; const c=getComputedStyle(e);
    if(px(c.fontSize)<13&&c.textTransform!=='uppercase'&&!sm.has(sig(e))){sm.add(sig(e)); V.push(`small ${sig(e)} = ${px(c.fontSize)} "${own.slice(0,24)}"`);}}
  // 7 buttons
  const bt=new Set();
  for(const e of main.querySelectorAll('a,button')){ if(!vis(e)) continue; const c=getComputedStyle(e); const r=e.getBoundingClientRect();
    const looks=(c.backgroundColor!=='rgba(0, 0, 0, 0)'||px(c.borderTopWidth)>0)&&px(c.borderTopLeftRadius)>=8&&r.height>=30&&r.height<=90&&r.width>=70&&!/card|chip|pill|faq|dot|tab|opt|link-card|row|industry|hub-link|post-|rating|area/.test(String(e.className))&&!e.classList.contains('faq-q');
    if(looks&&Math.round(r.height)!==48&&!bt.has(sig(e)+Math.round(r.height))){bt.add(sig(e)+Math.round(r.height)); V.push(`button ${sig(e)} h=${Math.round(r.height)} w=${Math.round(r.width)}`);}}
  if(document.documentElement.scrollWidth>W) V.push('OVERFLOW '+document.documentElement.scrollWidth);
  return V;}, W);
      for (const v of V) {
        if (EXEMPT.some(re => re.test(v))) { exempt++; continue; }
        bad++; console.log(`${W}px ${u.replace(BASE, '') || '/'}  ${v}`);
      }
    }
    await p.close();
  }
  await b.close();
  console.log(`${urls.length} pages x 2 widths: ${bad} problems, ${exempt} known exemptions`);
  process.exit(bad ? 1 : 0);
})();
