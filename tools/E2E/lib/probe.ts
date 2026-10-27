// 런타임 프로브 — 실행 중인 Wijmo 그리드에서 셀 단위 사실(편집 가능·후보·값)을 읽는다(2026-10-23, 화면 정합검증).
//   정적 AST 로 TO-BE 핸들러 본문(beginningEdit·dataMap·cellEditEnded)을 추출하는 대신, 실제 동작을 직접 묻는다.
//   원형 = Doc/e2e/specs/SCP0007.insertflow.spec.ts(시범). 저장은 하지 않는다 — 값 입력 프로브는 화면을 닫으면 버려진다.
import type { Page } from '@playwright/test';

// 보이는 첫 Wijmo 그리드 컨트롤(lib/nscm.ts gridColumnsMeta 와 같은 탐색: $WJ-CTRL 또는 columns 보유 속성)
const CTL = `(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); if (!el) return null;
  let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } return c || null; })()`;
const J = (v: unknown) => JSON.stringify(v);

export type RowRef = { row: number; crud: string } | null;

export const probe = {
  /** 보이는 첫 그리드 컨트롤 식(평가용 소스) — 스펙에서 행 전체를 훑을 때 쓴다(2026-10-25) */
  CTL_SRC: CTL,
  /** 보이는 컬럼 binding 목록 */
  visibleBindings: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const o = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && x.visible !== false) o.push(String(x.binding)); } return o; })()`) as Promise<string[] | null>,
  /** 전체 컬럼 binding(숨김 포함) */
  allBindings: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const o = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding) o.push(String(x.binding)); } return o; })()`) as Promise<string[] | null>,
  rowCount: (p: Page) => p.evaluate(`(() => { const c = ${CTL}; return c ? c.rows.length : -1; })()`) as Promise<number>,
  /** CRUD_TYPE='I' 신규행 수 */
  newRowCount: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return -1; let n = 0; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && d.CRUD_TYPE === 'I') n++; } return n; })()`) as Promise<number>,
  /** 첫 신규행 / 첫 기존행 위치 */
  findRow: (p: Page, kind: 'new' | 'existing') =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (!d) continue;
      const isNew = d.CRUD_TYPE === 'I'; if (${J(kind)} === 'new' ? isNew : !isNew) return { row: r, crud: String(d.CRUD_TYPE || '') }; } return null; })()`) as Promise<RowRef>,
  /** 편집기 열림 여부(beginningEdit 취소 포함) — 열리면 즉시 취소, 값 변경 없음. 컬럼 없으면 null */
  editable: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null;
      if (col.isReadOnly || c.isReadOnly) return false; const ok = c.startEditing(true, ${row}, col.index); if (ok) c.finishEditing(true); return !!ok; })()`) as Promise<boolean | null>,
  /**
   * 편집 시작/취소 — 화면이 beginningEdit 에서 후보 필터를 설치하는 경우(FCST Type W/S 게이트·Measure·Cell Prod Site, ForecastPriceGrid.tsx:1345-1375)
   * 편집기를 연 상태에서 후보를 읽어야 사용자가 보는 후보다(2026-10-24: 닫힌 상태로 읽어 누적 표시맵을 후보로 오인 — Measure 허위 FAIL)
   */
  startEdit: (p: Page, row: number, binding: string) =>
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col || col.isReadOnly || c.isReadOnly) return false;
      if (c.startEditing(true, ${row}, col.index)) return true;
      for (let k = 0; k < 15; k++) { if (c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index) return true; await new Promise(r => setTimeout(r, 200)); }
      return false; })()`) as Promise<boolean>,
  cancelEdit: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (c && c.activeEditor) c.finishEditing(true); return true; })()`) as Promise<boolean>,
  /** 콤보 셀 후보(표시값) — DataMap.getDisplayValues(행). 편집 중 후보가 필요하면 startEdit → 이것 → cancelEdit */
  candidates: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col || !col.dataMap) return null;
      return (col.dataMap.getDisplayValues(c.rows[${row}].dataItem) || []).map(v => v == null ? '' : String(v)); })()`) as Promise<string[] | null>,
  /** 셀 원값(dataItem[binding]) */
  value: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const d = c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return null; const v = d[${J(binding)}];
      return v == null ? '' : (v instanceof Date ? v.toISOString() : String(v)); })()`) as Promise<string | null>,
  /** 편집기 경로로 입력(사용자 편집과 같은 cellEditEnding/cellEditEnded) — 편집기가 안 열리면 false */
  // 첫 편집 시도를 취소하고 후보를 불러온 뒤 편집기를 비동기로 다시 여는 셀(DMF0082 Cell Prod Site — ForecastPriceGrid.tsx:1872-1900)은
  //   startEditing 이 false 여도 최대 3초 동안 그 셀에 편집기가 다시 열리는지 기다린다(2026-10-24 '편집 불가' 오판)
  setByEditor: (p: Page, row: number, binding: string, text: string) =>
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return false;
      c.select(${row}, col.index); let ok = c.startEditing(true, ${row}, col.index);
      if (!ok) { for (let k = 0; k < 15 && !(c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index); k++) await new Promise(r => setTimeout(r, 200));
        ok = !!(c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index); }
      if (!ok) return false; const ed = c.activeEditor; if (!ed) { c.finishEditing(true); return false; }
      ed.value = ${J(text)}; c.finishEditing(false); return true; })()`) as Promise<boolean>,
  /** 셀을 화면에 스크롤해 화면 좌표 중심점 반환(더블클릭 프로브용) */
  cellCenter: (p: Page, row: number, binding: string) =>
    // 스크롤 직후에는 셀이 아직 다시 그려지지 않아 null 이 나온다(2026-10-23 실측) → 최대 10회(약 2초) 재시도
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(${row}, col.index);
      for (let k = 0; k < 10; k++) { const el = c.cells.getCellElement(${row}, col.index); if (el) { const r = el.getBoundingClientRect(); if (r.width > 0) return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }
        await new Promise(res => setTimeout(res, 200)); }
      return null; })()`) as Promise<{ x: number; y: number } | null>,
  /** 콤보 셀 후보 중 원천 행에 지정 필드(예 CITY)가 채워진 것의 표시값 */
  candidatesWithField: (p: Page, binding: string, field: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); const dm = col && col.dataMap; if (!dm || !dm.collectionView) return [];
      const s = new Set(); for (const it of dm.collectionView.items) if (it && it[${J(field)}]) s.add(String(dm.getDisplayValue(it[dm.selectedValuePath]))); return [...s]; })()`) as Promise<string[]>,
  /**
   * 셀 콤보 덤프(W1 B4·B3) — dataMap 전체 항목(코드·표시값, 원천 순서) + 그 행에서 실제로 보이는 후보(getDisplayValues, 표시 순서)
   * 2026-10-24 AS-IS 원천 비교(combo_oracle.py)의 TO-BE 쪽 실측값
   */
  comboDump: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); const dm = col && col.dataMap; if (!dm) return null;
      const items = (dm.collectionView ? dm.collectionView.items : []).filter(Boolean).map(it => ({ c: String(it[dm.selectedValuePath] ?? ''), v: String(dm.getDisplayValue(it[dm.selectedValuePath]) ?? '') }));
      const r = c.rows[${row}]; const disp = (dm.getDisplayValues ? dm.getDisplayValues(r && r.dataItem) : []) || [];
      return { valuePath: String(dm.selectedValuePath || ''), displayPath: String(dm.displayMemberPath || ''), items, disp: disp.map(String) }; })()`) as Promise<{ valuePath: string; displayPath: string; items: { c: string; v: string }[]; disp: string[] } | null>,
  /**
   * 콤보 원천 항목의 분기 속성 — 항목 필드 중 값 종류가 적은(≤6) 필드(OSP_YN·SITE_TYPE 등)만 골라 표시값별로 돌려준다.
   * AS-IS 연쇄 분기가 이런 속성으로 갈리므로(SCP0007 From Site 'A'+OSP_YN='Y') C2 원천 대표값을 속성 조합별로 고르는 데 쓴다(2026-10-24)
   */
  candidateAttrs: (p: Page, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); const dm = col && col.dataMap; if (!dm || !dm.collectionView) return [];
      const items = dm.collectionView.items.filter(Boolean); const skip = new Set([dm.selectedValuePath, dm.displayMemberPath, 'CODE', 'NAME']);
      const keys = [...new Set(items.flatMap(it => Object.keys(it)))].filter(k => !skip.has(k) && !k.startsWith('_'));
      const few = keys.filter(k => { const s = new Set(items.map(it => it[k] == null ? '' : String(it[k]))); return s.size >= 2 && s.size <= 6; });
      return items.map(it => ({ v: String(dm.getDisplayValue(it[dm.selectedValuePath])), attrs: Object.fromEntries(few.map(k => [k, it[k] == null ? '' : String(it[k])])) })); })()`) as Promise<{ v: string; attrs: Record<string, string> }[]>,
  /** 셀 DOM 클래스(편집 표시 판정 H2) — 화면에 스크롤 후 읽는다 */
  cellClasses: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(${row}, col.index);
      const el = c.cells.getCellElement(${row}, col.index); return el ? String(el.className) : null; })()`) as Promise<string | null>,
  /** 컬럼 정의 — Wijmo DataType(0 Object·1 String·2 Number·3 Boolean·4 Date) · dataMap/에디터 · 형식 · 읽기전용 */
  colInfo: (p: Page, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null;
      return { dataType: Number(col.dataType || 0), hasMap: !!col.dataMap, editor: col.editor ? 'custom' : '',
        format: String(col.format || ''), readOnly: !!(col.isReadOnly || c.isReadOnly), header: String(col.header || '') }; })()`) as Promise<{ dataType: number; hasMap: boolean; editor: string; format: string; readOnly: boolean; header: string } | null>,
  /** 셀 표시 텍스트(dataMap·format 적용 후) */
  displayText: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; const v = c.getCellData(${row}, col.index, true); return v == null ? '' : String(v); })()`) as Promise<string | null>,
  /** dataMap 이 원값 key 에 대해 가진 표시값(없으면 null) */
  mapName: (p: Page, binding: string, key: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); const dm = col && col.dataMap; if (!dm) return null; const v = dm.getDisplayValue(${J(key)}); return v == null ? null : String(v); })()`) as Promise<string | null>,
  /** 키 값이 모두 같은 그리드 행 번호(c.rows 기준 — probe.value 와 같은 번호). 없으면 -1.
   *  columnValues(collectionView 순서·5000행 상한)의 인덱스를 행 번호로 쓰면 다른 행을 읽는다(2026-10-25 DMF0005 오판) */
  findRowBy: (p: Page, keys: Record<string, string>) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return -1; const ks = ${J(keys)}; const names = Object.keys(ks);
      for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (!d) continue;
        if (names.every(k => String(d[k] == null ? '' : d[k]) === ks[k])) return r; } return -1; })()`) as Promise<number>,
  /** 컬럼 전체 원값(가상화 무관 — collectionView 기준, 최대 5000행) */
  columnValues: (p: Page, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c || !c.collectionView) return null; return c.collectionView.items.slice(0, 5000).map(d => d && d[${J(binding)}] != null ? String(d[${J(binding)}]) : ''); })()`) as Promise<string[] | null>,
  /** 헤더 문구로 binding 찾기('*'·공백·'.' 무시, 대소문자 무시) */
  bindingByHeader: (p: Page, header: string) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const n = s => String(s || '').replace(/[*\\s.]/g, '').toLowerCase(); const h = n(${J(header)});
      for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && x.visible !== false && n(x.header) === h) return String(x.binding); } return null; })()`) as Promise<string | null>,
  /** 같은 헤더의 바인딩 전부(표시용·편집용이 따로 있는 경우 — DMF0005 Team = TEAM_NAME 표시 + 편집 컬럼, 2026-10-24) */
  bindingsByHeader: (p: Page, header: string) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return []; const n = s => String(s || '').replace(/[*\s.]/g, '').toLowerCase(); const h = n(${J(header)}); const out = [];
      for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && n(x.header) === h) out.push(String(x.binding)); } return out; })()`) as Promise<string[]>,
  /** 콤보 후보 품질 — 빈 항목·중복 */
  comboQuality(cands: string[]) {
    const blanks = cands.filter(v => !String(v).trim()).length;
    const seen = new Map<string, number>(); for (const v of cands) seen.set(v, (seen.get(v) || 0) + 1);
    const dups = [...seen.entries()].filter(([, n]) => n > 1).map(([v, n]) => `${v}×${n}`);
    return { count: cands.length, blanks, dups };
  },
};

/**
 * 열린 공용 드롭다운(CustomDropdown = MUI Autocomplete + 가상 스크롤 목록 role="list")의 후보 전체.
 *  가상 스크롤이라 보이는 줄만 DOM 에 있다(2026-10-23 실측: 어느 콤보든 13건으로 읽힘) → 끝까지 스크롤하며 스크롤 콘텐츠 안 절대 위치를 키로 수집.
 */
export async function dropdownOptions(p: Page): Promise<string[] | null> {
  return p.evaluate(async () => {
    // 실측 DOM(2026-10-23): .MuiAutocomplete-popper > Paper > div[role=listbox] > ul[role=list](스크롤) > li[role=option]
    //   팝퍼는 position:fixed 라 offsetParent 가 null — 가시성은 크기로 판정한다
    const shown = (e: Element) => { const r = (e as HTMLElement).getBoundingClientRect(); return r.width > 0 && r.height > 0; };
    const lists = [...document.querySelectorAll('.MuiAutocomplete-popper ul[role="list"], .MuiAutocomplete-popper [role="listbox"]')].filter(shown);
    const list = lists[lists.length - 1] as HTMLElement | undefined;
    if (!list) return null;
    const scroller = list.scrollHeight > list.clientHeight ? list : ((list.querySelector('ul') as HTMLElement | null) || list);
    const seen = new Map<string, string>();
    const grab = () => {
      for (const el of [...list.querySelectorAll('li[role="option"]')] as HTMLElement[]) {
        const t = (el.innerText || '').replace(/\s+/g, ' ').trim();
        // 키 = 스크롤 콘텐츠 안 절대 위치(화면 좌표 - 목록 상단 + scrollTop). 가상 목록이 항목을 transform 으로 배치해
        //   style.top·data-option-index·offsetTop 이 전 항목 같은 값이었다(2026-10-23 실측: offsetTop 전부 8 → 14건이 1건으로 합쳐짐).
        //   위치 키라 같은 문구가 두 번 나오는 진짜 중복도 따로 센다(B2 판정)
        const key = String(Math.round(el.getBoundingClientRect().top - scroller.getBoundingClientRect().top + scroller.scrollTop));
        if (!seen.has(key)) seen.set(key, t);
      }
    };
    grab();
    for (let k = 0; k < 400 && scroller.scrollTop + scroller.clientHeight < scroller.scrollHeight - 1; k++) {
      scroller.scrollTop += Math.max(scroller.clientHeight - 20, 40);
      await new Promise(r => setTimeout(r, 40)); grab();
    }
    scroller.scrollTop = 0;
    return [...seen.values()];
  });
}

/** 원장 CSV 파서(따옴표·줄바꿈 포함 RFC4180) — 의존성 없이 */
export function parseCsv(text: string): Record<string, string>[] {
  const s = text.replace(/^﻿/, ''); const rows: string[][] = []; let cur: string[] = []; let f = ''; let q = false;
  for (let i = 0; i < s.length; i++) {
    const ch = s[i];
    if (q) { if (ch === '"') { if (s[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; continue; }
    if (ch === '"') q = true; else if (ch === ',') { cur.push(f); f = ''; } else if (ch === '\n') { cur.push(f.replace(/\r$/, '')); rows.push(cur); cur = []; f = ''; } else f += ch;
  }
  if (f || cur.length) { cur.push(f); rows.push(cur); }
  const [h, ...rest] = rows; return rest.filter(r => r.length > 1).map(r => Object.fromEntries(h.map((k, i) => [k, r[i] ?? ''])));
}
