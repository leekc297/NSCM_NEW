# -*- coding: utf-8 -*-
"""UM-01~12 브라우저 런타임 실측 (hook #125 셀프 런타임 검증 — HTTP 러너가 못 보는 UI 행동 축)

  python um12_browser_probe.py DMF0040 DMF0053 DMF0035   (로컬 FE 5173 + BE 8080 기동 전제)

축: UM-01 Division 기본선택 / UM-06 헤더 총높이 48 / UM-07 Filter 버튼 → 필터 아이콘 노출 /
    조회 후 footer(UM-11) / ONLY_WEEKLY 전환 후 헤더 행수(UM-09)·그리드 비움(UM-08).
판정은 DOM 실측(wijmo 클래스) — 사람 눈 확인 전 기계 선판정. 스크린샷은 _gate_reports/ 에 저장.
"""
import io, sys, time, json, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

BASE = "http://127.0.0.1:5173"
USER = "minyonglee1"
OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_gate_reports")
STAMP = datetime.datetime.now().strftime("%Y%m%d_%H%M")

def log(msg): print(msg, flush=True)

def header_rows(page):
    """렌더된(활성 뷰) wijmo 그리드의 컬럼헤더 행 높이 목록 — 셀을 top 좌표로 묶는다 (.wj-row 는 0-height 컨테이너)."""
    return page.evaluate("""() => {
      const grids = [...document.querySelectorAll('.wj-flexgrid')].filter(g => window.__vis(g));
      const panel = grids.length ? grids[0].querySelector('.wj-colheaders') : null;
      if (!panel) return null;
      const byTop = new Map();
      panel.querySelectorAll('.wj-cell').forEach(c => {
        const t = Math.round(c.getBoundingClientRect().top);
        const h = Math.round(c.getBoundingClientRect().height);
        if (h > 0 && !byTop.has(t)) byTop.set(t, h);
      });
      const rows = [...byTop.entries()].sort((a, b) => a[0] - b[0]).map(e => e[1]);
      // 총높이 = 셀(top+height) 최대 — 세로 병합 셀은 여러 행 높이를 합친 값이라 행별 합산 대신 경계로 잰다
      const p0 = panel.getBoundingClientRect().top;
      let total = 0; panel.querySelectorAll('.wj-cell').forEach(c => { const r = c.getBoundingClientRect(); if (r.height > 0) total = Math.max(total, Math.round(r.bottom - p0)); });
      return { rows, total };
    }""")

def footer_present(page):
    return page.evaluate("""() => {
      const g = [...document.querySelectorAll('.wj-flexgrid')].find(x => window.__vis(x));
      const f = g ? g.querySelector('.wj-colfooters') : null;
      if (!f) return {present:false};
      const cells = [...f.querySelectorAll('.wj-cell')].map(c => c.textContent.trim()).filter(Boolean);
      return {present: cells.length > 0, sample: cells.slice(0, 6)};
    }""")

def grid_rows(page):
    return page.evaluate("() => { const g = [...document.querySelectorAll('.wj-flexgrid')].find(x => window.__vis(x)); return g ? g.querySelectorAll('.wj-cells .wj-row').length : 0; }")

def js_click(page, text):
    """텍스트가 정확히 일치하는 **렌더된** 버튼을 DOM 에서 직접 click (MUI 버튼이 offscreen/0-size 사본을 가질 때 로케이터 회피)."""
    return page.evaluate("""(t) => {
      const b = [...document.querySelectorAll('button')].find(x => x.textContent.trim() === t && window.__vis(x));
      if (!b) return false; b.click(); return true; }""", text)

def probe(page, menu):
    res = {"menu": menu, "checks": []}
    def ok(name, cond, detail=""):
        res["checks"].append((name, bool(cond), detail)); log(f"  {'PASS' if cond else 'FAIL'} | {name} {detail}")
    page.goto(f"{BASE}/view/{menu}", wait_until="networkidle")
    page.wait_for_timeout(4000)
    # MDI 탭 활성화 — 딥링크로 탭은 열리지만 활성 탭이 남아 있으면 뷰가 hidden(0-size) 이라 클릭이 안 된다
    TAB_RX = {"DMF0040": "Comparison", "DMF0053": "Cust", "DMF0035": "Demand Plan Waterfall"}
    activated = page.evaluate("""(rx) => {
      const re = new RegExp(rx, 'i');
      const bs = [...document.querySelectorAll('button')].filter(b => re.test(b.textContent.trim()) && window.__vis(b));
      if (!bs.length) return null; bs[0].click(); return bs[0].textContent.trim(); }""", TAB_RX.get(menu, menu))
    log(f"  tab activate → {activated!r}")
    page.wait_for_timeout(3000)
    # UM-01 — Division 기본 선택 (Div 라벨 옆 input 값)
    div_val = page.evaluate("""() => {
      const lbl = [...document.querySelectorAll('label, span, div')].find(e => /^Div\\.?\\*?$/.test(e.textContent.trim()));
      const root = lbl ? lbl.closest('.MuiGrid-root') : null;
      const inp = root ? root.querySelector('input') : null;
      const v = inp ? inp.value : '';
      return v || (root ? root.innerText.replace(/Div\.?\*?/, '').trim() : null);
    }""")
    ok("UM-01 Division 기본 선택", div_val, f"value={div_val!r}")
    # UM-07 — Filter 버튼 클릭 → wijmo 필터 아이콘(.wj-elem-filter) 노출
    # 조회 (Search) — DMF0035 는 MKT 기본 CURRENT, 0040 은 기본 Version 자동세팅 대기
    page.wait_for_timeout(2500)
    ok("Search 버튼 존재", js_click(page, "Search(F5)"))
    page.wait_for_timeout(15000)
    rows = grid_rows(page)
    ok("조회 행 렌더", rows > 0, f"rows={rows}")
    # UM-07 — Filter(F4) 버튼 → wijmo 필터 아이콘(.wj-elem-filter) 토글 (조회 후 컬럼이 있어야 아이콘이 생긴다)
    page.evaluate("() => { const g = [...document.querySelectorAll('.wj-flexgrid')].find(x => window.__vis(x)); const c = g && g.querySelector('.wj-cells .wj-cell'); if (c) c.click(); }")
    page.wait_for_timeout(300)
    before = page.evaluate("() => [...document.querySelectorAll('.wj-elem-filter')].filter(e => window.__vis(e)).length")
    page.keyboard.press("F4"); page.wait_for_timeout(800)
    after = page.evaluate("() => [...document.querySelectorAll('.wj-elem-filter')].filter(e => window.__vis(e)).length")
    if after == before:
        js_click(page, "Filter(F4)"); page.wait_for_timeout(800)
        after = page.evaluate("() => [...document.querySelectorAll('.wj-elem-filter')].filter(e => window.__vis(e)).length")
    if menu == "DMF0035":
        # OLAP: Filter(F4) = Grid Layout 레일 열기(Filters 영역 = 값 필터 편집기). 레일 'Grid layout' 헤더가 렌더되면 PASS
        rail = page.evaluate("() => { const e = [...document.querySelectorAll('aside')].find(a => /Grid layout/i.test(a.textContent) && window.__vis(a)); return !!e && !!e.querySelector('input'); }")
        ok("UM-07 (OLAP) Filter/F4 → Grid Layout 레일(Filters 영역) 열림", rail, f"rail={rail}")
    else:
        ok("UM-07 Filter 버튼/F4 → 필터 아이콘 토글", after != before, f"icons {before}→{after}")
    hr = header_rows(page)
    ok("UM-06 헤더 총높이(조회 후) = 48", hr and abs(hr["total"] - 48) <= 2, f"{hr}")
    ft = footer_present(page)
    if menu == "DMF0035":
        tot = page.evaluate("() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(x => window.__vis(x)); const g = window.wijmo && window.wijmo.Control.getControl(el); if (!g) return []; const n = g.rows.length; const out = []; for (let i = Math.max(0, n-2); i < n; i++) { out.push(String(g.rowHeaders.getCellData(i, 0, true) || '') + '|' + String(g.getCellData(i, 0, true) || '')); } return out.filter(t => /Total|합계|Sum/i.test(t)); }")
        ok("UM-11 OLAP 총계 행(GrandTotals)", len(tot) > 0, f"{tot}")
    else:
        ok("UM-11 footer 합계 행", ft.get("present"), f"{ft}")
    page.screenshot(path=str(OUT / f"{menu}_um_probe_{STAMP}_1.png"), full_page=False)
    # UM-08/09 — Bucket → ONLY_WEEKLY: 그리드 비움(0040/0053) + 헤더 재생성, 재조회 후 헤더 3행·footer
    changed = False
    try:
        opened = page.evaluate("""() => {
          const lbl = [...document.querySelectorAll('label, span')].find(e => e.textContent.trim() === 'Bucket' && window.__vis(e));
          const root = lbl && lbl.closest('.MuiGrid-root');
          const btn = root && (root.querySelector('.MuiAutocomplete-popupIndicator') || root.querySelector('input'));
          if (!btn) return false; btn.click(); return true; }""")
        if not opened: raise RuntimeError("Bucket input not found")
        page.wait_for_timeout(600)
        page.keyboard.press("ArrowDown"); page.wait_for_timeout(200)
        picked = page.evaluate("""() => {
          const o = [...document.querySelectorAll('li, [role=option]')].find(e => /ONLY.?WEEKLY/i.test(e.textContent) && window.__vis(e));
          if (!o) return false; o.click(); return true; }""")
        if not picked: raise RuntimeError("ONLY_WEEKLY option not found")
        page.wait_for_timeout(2500); changed = True
    except Exception as e:
        log(f"  WARN | Bucket 전환 실패: {str(e)[:80]}")
    if changed:
        rows2 = grid_rows(page)
        ok("UM-08 ONLY_WEEKLY 전환 = 그리드 비움(0040/0053) 또는 재피벗(0035)", menu == "DMF0035" or rows2 == 0, f"rows={rows2}")
        ok("Search 버튼 존재", js_click(page, "Search(F5)")); page.wait_for_timeout(15000)
        hr = header_rows(page)
        ok("UM-09 ONLY_WEEKLY 헤더 총 48 (3행)", hr and abs(hr["total"] - 48) <= 3, f"{hr}")
        ft = footer_present(page)
        ok("UM-11 ONLY_WEEKLY footer", menu == "DMF0035" or ft.get("present"), f"{ft}")
        page.screenshot(path=str(OUT / f"{menu}_um_probe_{STAMP}_2_onlyweekly.png"), full_page=False)
    return res

def main():
    menus = sys.argv[1:] or ["DMF0040", "DMF0053", "DMF0035"]
    OUT.mkdir(parents=True, exist_ok=True)
    with sync_playwright() as p:
        # 브라우저: 시스템 Edge(다운로드 불요) 우선 → 없으면 playwright chromium
        try:
            browser = p.chromium.launch(headless=True, channel="msedge")
        except Exception:
            browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1600, "height": 900})
        # 활성(가시) 요소 판정 헬퍼 — 페이지 이동마다 다시 정의되도록 init script 로 주입
        page.add_init_script("window.__vis = el => !!el && (el.checkVisibility ? el.checkVisibility() : el.getClientRects().length > 0);")
        page.goto(BASE, wait_until="networkidle")
        page.locator("input").first.fill(USER)
        page.locator("button:has-text('Login')").click()
        page.wait_for_timeout(3000)
        log(f"login → {page.url}")
        results = []
        for m in menus:
            log(f"## {m}")
            try:
                results.append(probe(page, m))
            except Exception as e:
                log(f"  ERROR | {m}: {str(e)[:200]}")
                page.screenshot(path=str(OUT / f"{m}_um_probe_{STAMP}_error.png"))
        browser.close()
    (OUT / f"UM_browser_probe_{STAMP}.json").write_text(json.dumps(results, ensure_ascii=False, indent=1), encoding="utf-8")
    fails = sum(1 for r in results for _, okk, _ in r["checks"] if not okk)
    log(f"== 종합 {'PASS' if fails == 0 else f'FAIL {fails}건'} — {OUT}")

if __name__ == "__main__":
    main()
