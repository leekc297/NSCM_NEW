// 런타임 프로브 — 실행 중인 Wijmo 그리드에서 셀 단위 사실(편집 가능·후보·값)을 읽는다(2026-10-23, 화면 정합검증).
//   정적 AST 로 TO-BE 핸들러 본문(beginningEdit·dataMap·cellEditEnded)을 추출하는 대신, 실제 동작을 직접 묻는다.
//   원형 = Doc/e2e/specs/SCP0007.insertflow.spec.ts(시범). 저장은 하지 않는다 — 값 입력 프로브는 화면을 닫으면 버려진다.
import type { Page } from '@playwright/test';

// 보이는 첫 Wijmo 그리드 컨트롤(lib/nscm.ts gridColumnsMeta 와 같은 탐색: $WJ-CTRL 또는 columns 보유 속성)
// 2026-11-01: 한 화면에 그리드가 여럿(상단 메인 + 하단 시트)이면 첫 그리드만 보여 하위 시트 컬럼을 못 쟀다(DMF0004 Sales Customer) — pickGrid 로 지정하면 그 컬럼을 가진 그리드를 쓴다. 지정 없으면 종전과 같음
const CTL = `(() => { const ctlOf = el => { let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } return c || null; };
  const els = [...document.querySelectorAll('.wj-flexgrid')].filter(e => e.offsetParent !== null); if (!els.length) return null; const want = window.__e2eGridCols;
  if (want) for (const e of els) { const c = ctlOf(e); if (c && want.every(b => { const x = c.columns.getColumn(b); return x && x.visible !== false; })) return c; } return ctlOf(els[0]); })()`;
const J = (v: unknown) => JSON.stringify(v);

export type RowRef = { row: number; crud: string } | null;

export const probe = {
  /** 보이는 첫 그리드 컨트롤 식(평가용 소스) — 스펙에서 행 전체를 훑을 때 쓴다(2026-10-25) */
  CTL_SRC: CTL,
  /** 편집 불가 칸에 시험 값을 직접 넣는다(화면에서 입력 경로가 없는 하위 칸의 '이전 값' 준비용 · 저장하지 않음) */
  /** 저장 없는 시험 — GET 이 아닌 XHR·fetch 를 전부 막고 건수를 센다. off() 로 해제 */
  blockWrites: async (p: Page) => { const st = { n: 0, urls: [] as string[], reads: 0 }; const h = async (route: import('@playwright/test').Route) => { const q = route.request(); if (q.method() !== 'GET' && ['xhr', 'fetch'].includes(q.resourceType())) { /* 이 앱은 읽기도 POST — 쓰기 이름이 있는 요청만 쓰기로 센다(읽기까지 세면 허위 · 2026-11-02 SCP0028 12건) · 전부 막아 쓰기 이름이 달라도 저장되지 않는다 */ if (/SAVE|DELETE|INSERT|UPDATE|MERGE|\/(INS|UPD|DEL)\b/i.test(q.url())) { st.n++; st.urls.push(q.url().slice(-60)); } else st.reads++; await route.abort().catch(() => undefined); } else await route.continue().catch(() => undefined); }; await p.route('**/*', h); return { st, off: () => p.unroute('**/*', h).catch(() => undefined) }; },
  /** 그리드 붙여넣기 API — pastingCell·pastedCell 까지 같은 경로. 헤드리스 Ctrl+V 는 그리드에 닿지 않는다(2026-11-02 이벤트 0건 실측) */
  pasteText: (p: Page, row: number, binding: string, v: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return false; c.finishEditing(true); c.select(${row}, col.index); c.setClipString(${J(v)}); return true; })()`) as Promise<boolean>,
  /** 붙여넣기 진단 — pastingCell·pastedCell 발생 수·취소 여부 · 칸 읽기 전용 · 뒤 값 */
  pasteDebug: (p: Page, row: number, binding: string, v: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return 'no col'; const ev = []; const h1 = (s, e) => ev.push('pasting r' + e.row + ' d=' + String(e.data) + ' cancel=' + !!e.cancel); const h2 = (s, e) => ev.push('pasted r' + e.row + ' d=' + String(e.data)); c.pastingCell.addHandler(h1); c.pastedCell.addHandler(h2); c.select(${row}, col.index); const sel = c.selection; c.setClipString(${J(v)}); c.pastingCell.removeHandler(h1); c.pastedCell.removeHandler(h2); const a0 = String(c.getCellData(${row}, col.index, true) ?? ''); const raw0 = String(c.getCellData(${row}, col.index, false) ?? ''); return new Promise(res => setTimeout(() => res(JSON.stringify({ ev: ev.slice(0, 4), sel: [sel.row, sel.col], binding: col.binding, auto: c.autoClipboard, after: a0, raw: raw0, after1s: String(c.getCellData(${row}, col.index, true) ?? ''), raw1s: String(c.getCellData(${row}, col.index, false) ?? ''), crud: String((c.rows[${row}].dataItem || {}).CRUD_TYPE || '') })), 1000)); })()`) as Promise<string>,
  seedCell: (p: Page, row: number, binding: string, v: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return false; const d = c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return false; d[${J(binding)}] = ${J(v)}; c.invalidate(); return true; })()`) as Promise<boolean>,
  /** 원천 칸이 v 인 기존 행(신규행 제외)의 대상 칸 값들 — 코드·표시값 둘 다 비교 */
  peerValues: (p: Page, src: string, v: string, tgt: string, skipRow: number) =>
    p.evaluate(`(() => { const c = ${CTL}; const cs = c && c.columns.getColumn(${J(src)}); const ct = c && c.columns.getColumn(${J(tgt)}); if (!cs || !ct) return { n: 0, values: [] }; const out = new Set(); let n = 0; const N = Math.min(c.rows.length, 3000); for (let r = 0; r < N; r++) { if (r === ${skipRow}) continue; const d = c.rows[r].dataItem; if (!d || d.CRUD_TYPE === 'I') continue; const a = String(c.getCellData(r, cs.index, false) ?? ''), b = String(c.getCellData(r, cs.index, true) ?? ''); if (a !== ${J(v)} && b !== ${J(v)}) continue; n++; for (const k of [c.getCellData(r, ct.index, false), c.getCellData(r, ct.index, true)]) { if (k != null && String(k).trim()) out.add(String(k)); } } return { n, values: [...out] }; })()`) as Promise<{ n: number; values: string[] }>,
  /** 대상 칸에 값이 있는 기존 행의 원천 값(코드·표시값) — 많은 순 */
  srcWithTarget: (p: Page, src: string, tgt: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const cs = c && c.columns.getColumn(${J(src)}); const ct = c && c.columns.getColumn(${J(tgt)}); if (!cs || !ct) return []; const m = new Map(); const N = Math.min(c.rows.length, 3000); for (let r = 0; r < N; r++) { const d = c.rows[r].dataItem; if (!d || d.CRUD_TYPE === 'I') continue; const t = c.getCellData(r, ct.index, false); if (t == null || !String(t).trim()) continue; for (const k of [c.getCellData(r, cs.index, false), c.getCellData(r, cs.index, true)]) { if (k != null && String(k).trim()) m.set(String(k), (m.get(String(k)) || 0) + 1); } } return [...m.entries()].sort((a, b) => b[1] - a[1]).map(e => e[0]).slice(0, 40); })()`) as Promise<string[]>,
  /** 이 컬럼들을 모두 표시한 그리드를 이후 프로브 대상으로 지정(없으면 false · null 이면 해제) */
  pickGrid: (p: Page, cols: string[] | null) =>
    p.evaluate(`(() => { window.__e2eGridCols = ${J(cols)}; if (!window.__e2eGridCols) return true; const c = ${CTL}; return !!c && window.__e2eGridCols.every(b => { const x = c.columns.getColumn(b); return x && x.visible !== false; }); })()`) as Promise<boolean>,
  /** 보이는 컬럼 binding 목록 */
  visibleBindings: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const o = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && x.visible !== false) o.push(String(x.binding)); } return o; })()`) as Promise<string[] | null>,
  /** 전체 컬럼 binding(숨김 포함) */
  allBindings: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const o = []; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding) o.push(String(x.binding)); } return o; })()`) as Promise<string[] | null>,
  rowCount: (p: Page) => p.evaluate(`(() => { const c = ${CTL}; return c ? c.rows.length : -1; })()`) as Promise<number>,
  /** 그리드에 행이 찰 때까지 **시간 상한**으로 대기(기본 120s) → 마지막 행 수. 2026-10-29: 횟수 상한(240회×500ms)은 부하 시 evaluate 1회가 수 초라 15분 테스트 타임아웃을 넘겼다(SCP0111 B1·B2 G1 루프) */
  waitRows: async (p: Page, ms = 120_000, pollMs = 500): Promise<number> => { const t0 = Date.now(); let n = await probe.rowCount(p); while (n <= 0 && Date.now() - t0 < ms) { await p.waitForTimeout(pollMs); n = await probe.rowCount(p); } return n; },
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
      if (col.isReadOnly || c.isReadOnly) return false;
      // 2026-11-06 T60(SCP0127·SCP0131): 날짜 칸 편집기가 Date 아닌 셀 값으로 'Assertion failed in Wijmo: Date expected' 를 던지면 evaluate 가 실패해
      //   그리드 컬럼 프로브 테스트 전체(A5·D1·H2…)가 중단됐다. beginningEdit 를 통과해 편집기 생성까지 간 것이므로 편집 가능(true)으로 보고, 예외는 따로 남긴다.
      try { const ok = c.startEditing(true, ${row}, col.index); if (ok) c.finishEditing(true); return !!ok; }
      catch (e) { try { c.finishEditing(true); } catch (e2) { /* 편집 상태 정리 실패 무시 */ } (window.__e2eEditorErr = window.__e2eEditorErr || []).push(${J(binding)} + ': ' + String((e && e.message) || e).slice(0, 120)); return true; } })()`) as Promise<boolean | null>,
  /** T60: probe.editable/startEdit 이 삼킨 편집기 예외(컬럼: 메시지) — 읽으면 비운다 */
  editorErrors: (p: Page) =>
    p.evaluate(`(() => { const a = window.__e2eEditorErr || []; window.__e2eEditorErr = []; return a; })()`).catch(() => [] as string[]) as Promise<string[]>,
  /**
   * 편집 시작/취소 — 화면이 beginningEdit 에서 후보 필터를 설치하는 경우(FCST Type W/S 게이트·Measure·Cell Prod Site, ForecastPriceGrid.tsx:1345-1375)
   * 편집기를 연 상태에서 후보를 읽어야 사용자가 보는 후보다(2026-10-24: 닫힌 상태로 읽어 누적 표시맵을 후보로 오인 — Measure 허위 FAIL)
   */
  startEdit: (p: Page, row: number, binding: string) =>
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col || col.isReadOnly || c.isReadOnly) return false;
      try { if (c.startEditing(true, ${row}, col.index)) return true; }
      catch (e) { (window.__e2eEditorErr = window.__e2eEditorErr || []).push(${J(binding)} + ': ' + String((e && e.message) || e).slice(0, 120)); if (c.activeEditor) return true; try { c.finishEditing(true); } catch (e2) { /* 무시 */ } return false; }  // T60
      for (let k = 0; k < 15; k++) { if (c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index) return true; await new Promise(r => setTimeout(r, 200)); }
      return false; })()`) as Promise<boolean>,
  cancelEdit: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (c && c.activeEditor) c.finishEditing(true); return true; })()`) as Promise<boolean>,
  /** 콤보 셀 후보(표시값) — DataMap.getDisplayValues(행). 편집 중 후보가 필요하면 startEdit → 이것 → cancelEdit */
  candidates: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col || !col.dataMap) return null;
      const rw = c.rows[${row}]; if (!rw) return null; return (col.dataMap.getDisplayValues(rw.dataItem) || []).map(v => v == null ? '' : String(v)); })()`) as Promise<string[] | null>,
  /** 셀 원값(dataItem[binding]) */
  value: (p: Page, row: number, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const d = c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return null; const v = d[${J(binding)}];
      return v == null ? '' : (v instanceof Date ? v.toISOString() : String(v)); })()`) as Promise<string | null>,
  /** 편집기 경로로 입력(사용자 편집과 같은 cellEditEnding/cellEditEnded) — 편집기가 안 열리면 false */
  // 첫 편집 시도를 취소하고 후보를 불러온 뒤 편집기를 비동기로 다시 여는 셀(DMF0082 Cell Prod Site — ForecastPriceGrid.tsx:1872-1900)은
  //   startEditing 이 false 여도 최대 3초 동안 그 셀에 편집기가 다시 열리는지 기다린다(2026-10-24 '편집 불가' 오판)
  setByEditor: (p: Page, row: number, binding: string, text: string) =>
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return false;
      c.select(${row}, col.index); let ok = false;
      // 2026-11-07 T156(SCP0131 E3 · chain6b/6f 2회): 날짜 칸 편집기(InputDate)가 Date 아닌 셀 값으로 'Assertion failed in Wijmo: Date expected' 를 던지면 evaluate 가 실패해
      //   테스트 전체가 중단됐다(F1/F2/F4/F6 5행 '검증엔진 미기동'). T60 과 같이 예외를 기록하고 false(입력 경로 실패)로 돌려 그 칸만 ERROR 로 남긴다
      try { ok = c.startEditing(true, ${row}, col.index); }
      catch (e) { (window.__e2eEditorErr = window.__e2eEditorErr || []).push(${J(binding)} + ': ' + String((e && e.message) || e).slice(0, 120)); try { c.finishEditing(true); } catch (e2) { /* 무시 */ } return false; }
      if (!ok) { for (let k = 0; k < 15 && !(c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index); k++) await new Promise(r => setTimeout(r, 200));
        ok = !!(c.activeEditor && c.editRange && c.editRange.row === ${row} && c.editRange.col === col.index); }
      if (!ok) return false; const ed = c.activeEditor; if (!ed) { c.finishEditing(true); return false; }
      try { ed.value = ${J(text)}; c.finishEditing(false); } catch (e) { (window.__e2eEditorErr = window.__e2eEditorErr || []).push(${J(binding)} + ': ' + String((e && e.message) || e).slice(0, 120)); try { c.finishEditing(true); } catch (e2) { /* 무시 */ } return false; }
      return true; })()`) as Promise<boolean>,
  /** 셀을 화면에 스크롤해 화면 좌표 중심점 반환(더블클릭 프로브용) */
  cellCenter: (p: Page, row: number, binding: string) =>
    // 스크롤 직후에는 셀이 아직 다시 그려지지 않아 null 이 나온다(2026-10-23 실측) → 최대 10회(약 2초) 재시도
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(${row}, col.index);
      for (let k = 0; k < 10; k++) { let el = c.cells.getCellElement(${row}, col.index);
      if (!el) { try { c.scrollIntoView(${row}, col.index); c.refresh(false); await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 120));
        el = c.cells.getCellElement(${row}, col.index);
        if (!el) for (const cand of c.cells.hostElement.querySelectorAll('.wj-cell')) { const rc = cand.getBoundingClientRect(); if (!rc.width) continue; const ht = c.hitTest(rc.left + rc.width / 2, rc.top + rc.height / 2); if (ht && ht.row === ${row} && ht.col === col.index && ht.panel === c.cells) { el = cand; break; } }
      } catch { el = null; } }
      if (el) { const r = el.getBoundingClientRect(); if (r.width > 0) return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }
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
      const el = c.cells.getCellElement(${row}, col.index); if (!el) return null;
      const bg = String(el.style.backgroundColor || getComputedStyle(el).backgroundColor || '').replace(/\\s+/g, '');
      return String(el.className) + (/^(rgb\\(255,248,205\\)|#fff8cd)$/i.test(bg) && !/wj-cell-editable/.test(el.className) ? ' wj-cell-editable--inline-bg' : ''); })()`) as Promise<string | null>,
  // ↑ 2026-11-06(SCP0084 H2 허위 FAIL 2건): 화면이 편집 셀을 클래스(.wj-cell-editable) 대신 인라인 배경색 #fff8cd(hook #95 표준 편집 노랑 = .wj-cell-editable 과 같은 색)
  //   로 칠하는 경우(LongTermStockGrid formatItem MEMO) 클래스만 보던 H2 가 '편집 가능인데 노랑 아님' 으로 오판 → 실제 배경색이 표준 노랑이면 표식 클래스를 덧붙여 노랑으로 본다.
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
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return []; const n = s => String(s || '').replace(/[*\\s.]/g, '').toLowerCase(); const h = n(${J(header)}); const out = [];
      for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && n(x.header) === h) out.push(String(x.binding)); } return out; })()`) as Promise<string[]>,
  /** 콤보 후보 품질 — 빈 항목·중복 */
  /** 동적(런타임) 컬럼 binding — 정규식 일치 전부(2026-10-30 WP1 월/주 피벗 컬럼) */
  dynColumns: async (p: Page, re: string): Promise<string[]> => { const all = (await probe.allBindings(p)) || []; const rx = new RegExp(re); return all.filter(b => rx.test(b)); },
  /** 조건을 만족하는 행 번호들 — pred 는 dataItem 전체를 받는다(행 값 기반 조건부 잠금 평가·값 있는/빈 셀 표본). c.rows 를 직접 순회(columnValues 인덱스 ≠ 행 번호) */
  findRowsByValue: (p: Page, predSrc: string, max = 2) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return []; const pred = ${predSrc}; const o = []; for (let r = 0; r < c.rows.length && o.length < ${max}; r++) { const d = c.rows[r].dataItem; if (!d) continue; try { if (pred(d)) o.push(r); } catch {} } return o; })()`) as Promise<number[]>,
  /** 행 dataItem 전체(조건 평가용) */
  rowItem: (p: Page, row: number) =>
    p.evaluate(`(() => { const c = ${CTL}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return null; const o = {}; for (const k of Object.keys(d)) { const v = d[k]; o[k] = v == null ? '' : (v instanceof Date ? v.toISOString() : String(v)); } return o; })()`) as Promise<Record<string, string> | null>,
  /** 편집 가능한 첫 행(0-base) — 한 번의 evaluate 로 최대 max 행에 startEditing 을 시도(행 조건부 잠금 컬럼은 상위 행이 전부 잠겨 있어도 아래 어딘가 열린다). skip 행 제외. 없으면 -1 */
  firstEditableRow: (p: Page, binding: string, max = 400, skip: number[] = [], budgetMs = 6_000) =>
    // 시간 예산(기본 6초) 안에서 균등 간격(stride) 으로 행을 훑는다 — 2026-10-30 v14 그리드 프로브 테스트가 400행×startEditing 반복으로 689초 타임아웃(T20)
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return -2; if (col.isReadOnly || c.isReadOnly) return -1; const sk = new Set(${J(skip)});
      const total = c.rows.length; const n = Math.min(total, ${max}); const t0 = Date.now(); const seen = new Set();
      const order = []; for (let step = Math.max(1, Math.floor(total / Math.max(1, n))); order.length < n && step >= 1; step = Math.floor(step / 2)) { for (let r = 0; r < total && order.length < n; r += step) { if (!seen.has(r)) { seen.add(r); order.push(r); } } if (step === 1) break; }
      for (const r of order) { if (sk.has(r)) continue; if (Date.now() - t0 > ${budgetMs}) return -3; let ok = false; try { ok = c.startEditing(true, r, col.index); if (ok) c.finishEditing(true); } catch { ok = false; } if (ok) return r; } return -1; })()`) as Promise<number>,
  /** 대상 컬럼이 고정 영역 밖이고 고정 폭이 가시 폭의 85% 를 넘으면(스크롤 영역 ≈0 → 셀 미렌더·startEditing 실패) 측정 동안 frozenColumns=0 — 측정 전용(화면 재진입 시 원복). 2026-10-31 SCP0111 고정 21컬럼 1415px */
  unfreezeIfNeeded: (p: Page, binding: string) =>
    p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; const n = c.frozenColumns || 0; if (!(n > 0 && col.index >= n)) return { did: false, n };
      const last = c.columns[n - 1]; const fw = (last.pos || 0) + (last.renderWidth || 0); const cw = (c.clientSize && c.clientSize.width) || c.hostElement.clientWidth || 0;
      if (cw && fw > cw * 0.85) { c.frozenColumns = 0; c.refresh(true); return { did: true, n, fw, cw }; } return { did: false, n, fw, cw }; })()`) as Promise<{ did: boolean; n: number; fw?: number; cw?: number } | null>,
  /** 대상 컬럼 집합에서 '렌더된' 음수 값 셀 하나를 찾아 스타일을 읽는다(H13 폴백) — 데이터 행 번호로 셀을 찍는 방식이 가로 가상화(col 24 미렌더)로 실패할 때(2026-10-30 SCP0111 v16). 스크롤 위치를 컬럼 pos·행 pos 로 직접 옮기며 시간 예산 안에서 탐색 */
  renderedNegativeStyle: (p: Page, bindings: string[], budgetMs = 8_000) =>
    p.evaluate(`(async () => { const c = ${CTL}; if (!c) return null; const want = new Set(${J(bindings)}); const cols = []; for (let i = 0; i < c.columns.length; i++) if (want.has(String(c.columns[i].binding || ''))) cols.push(c.columns[i]); if (!cols.length) return { err: '대상 컬럼 없음' };
      const P0 = c.scrollPosition.constructor; const t0 = Date.now(); const h = c.cells.hostElement.clientHeight || 400; const tried = [];
      for (const col of cols) { for (let y = 0; y < (c.rows.length ? c.rows[c.rows.length - 1].pos : 0) && Date.now() - t0 < ${budgetMs}; y += Math.max(h - 40, 100)) {
        try { c.scrollPosition = new P0(-(col.pos || 0), -y); c.refresh(false); } catch { } await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 60));
        for (const cand of c.cells.hostElement.querySelectorAll('.wj-cell')) { const rc = cand.getBoundingClientRect(); if (!rc.width) continue; const ht = c.hitTest(rc.left + rc.width / 2, rc.top + rc.height / 2); if (!ht || ht.panel !== c.cells || ht.col !== col.index) continue;
          const v = Number(String(cand.textContent || '').replace(/[,\\s]/g, '')); if (!isNaN(v) && v < 0) { const cs = getComputedStyle(cand); const inner = cand.querySelector('span,div'); const ics = inner ? getComputedStyle(inner) : null; return { b: String(col.binding), row: ht.row, color: cs.color, innerColor: ics ? ics.color : '', bg: cs.backgroundColor, cls: cand.className, text: String(cand.textContent || '').trim() }; } }
        tried.push(String(col.binding) + '@' + y); }
      } return { err: '렌더된 음수 셀 없음(탐색 ' + tried.length + '구간 · ' + (Date.now() - t0) + 'ms)' }; })()`) as Promise<{ b?: string; row?: number; color?: string; innerColor?: string; bg?: string; cls?: string; text?: string; err?: string } | null>,
  /** 열린 편집기 닫기(취소) — 탐색용 startEditing·후보 조회가 남긴 상태가 뒤이은 키보드 입력을 먹지 않게 */
  endEdit: (p: Page) => p.evaluate(`(() => { const c = ${CTL}; if (c && c.activeEditor) c.finishEditing(true); return true; })()`) as Promise<boolean>,
  /** 행 식별 문자열 — 행 전체 데이터(제외 컬럼·감사·CRUD 상태 제외). 저장 후 원복 대상을 찾는 근거(앞 몇 칸 값은 유일하지 않다) */
  rowIdentity: (p: Page, row: number, exclude: string[]) =>
    p.evaluate(`(() => { const c = ${CTL}; const d = c && c.rows[${row}] && c.rows[${row}].dataItem; if (!d) return ''; const ex = new Set(${J(exclude)}); const o = []; for (const k of Object.keys(d).sort()) { if (ex.has(k) || /^(CRUD_TYPE|LAST_UPDATE|LAST_UPDATED|CREATION_DATE|CREATED_BY|__)/i.test(k) || typeof d[k] === 'number' || typeof d[k] === 'object' && !(d[k] instanceof Date)) continue; o.push(k + '=' + String(d[k] ?? '')); } return o.join('\u0001'); })()`) as Promise<string>,
  /** 식별 문자열이 같은 데이터 행 번호 전부 */
  findRowsByIdentity: (p: Page, ident: string, exclude: string[]) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return []; const ex = new Set(${J(exclude)}); const want = ${J(ident)}; const hit = []; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (!d) continue; const o = []; for (const k of Object.keys(d).sort()) { if (ex.has(k) || /^(CRUD_TYPE|LAST_UPDATE|LAST_UPDATED|CREATION_DATE|CREATED_BY|__)/i.test(k) || typeof d[k] === 'number' || typeof d[k] === 'object' && !(d[k] instanceof Date)) continue; o.push(k + '=' + String(d[k] ?? '')); } if (o.join('\u0001') === want) hit.push(r); } return hit; })()`) as Promise<number[]>,
  /** 식별 문자열과 가장 가까운 유일한 행 — 저장 SP 가 다른 칸을 함께 바꾸면 완전 일치가 안 된다(2026-11-02 DMF0005 원복 실패). 달라진 칸 maxDiff 개 이하 · 최소 차이가 유일할 때만 */
  findRowNear: (p: Page, ident: string, exclude: string[], maxDiff = 3) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const ex = new Set(${J(exclude)}); const want = new Map(${J(ident)}.split('\u0001').map(t => { const i = t.indexOf('='); return [t.slice(0, i), t.slice(i + 1)]; })); let best = 99, hits = [], diff = []; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (!d) continue; const dd = []; for (const [k, v] of want) { if (ex.has(k)) continue; if (String(d[k] ?? '') !== v) dd.push(k + " '" + v + "'→'" + String(d[k] ?? '') + "'"); if (dd.length > ${maxDiff}) break; } if (dd.length > ${maxDiff}) continue; if (dd.length < best) { best = dd.length; hits = [r]; diff = dd; } else if (dd.length === best) hits.push(r); } return hits.length === 1 ? { row: hits[0], diff } : null; })()`) as Promise<{ row: number; diff: string[] } | null>,
  /** 셀의 계산된 글자색·배경·클래스(음수 빨강 H13 · 편집 노랑 H2) — 셀을 화면에 스크롤해 읽는다 */
  cellStyle: (p: Page, row: number, binding: string) =>
    p.evaluate(`(async () => { const c = ${CTL}; const col = c && c.columns.getColumn(${J(binding)}); if (!col) return null; c.scrollIntoView(${row}, col.index);
      for (let k = 0; k < 10; k++) { let el = c.cells.getCellElement(${row}, col.index);
      if (!el) { try { c.scrollIntoView(${row}, col.index); c.refresh(false); await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 120));
        el = c.cells.getCellElement(${row}, col.index);
        if (!el) for (const cand of c.cells.hostElement.querySelectorAll('.wj-cell')) { const rc = cand.getBoundingClientRect(); if (!rc.width) continue; const ht = c.hitTest(rc.left + rc.width / 2, rc.top + rc.height / 2); if (ht && ht.row === ${row} && ht.col === col.index && ht.panel === c.cells) { el = cand; break; } }
      } catch { el = null; } }
      if (!el) { try { const P0 = c.scrollPosition.constructor; c.scrollPosition = new P0(-(col.pos || 0), -(c.rows[${row}] ? c.rows[${row}].pos : 0)); c.refresh(false); await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 150)); el = c.cells.getCellElement(${row}, col.index);
        if (!el) for (const cand of c.cells.hostElement.querySelectorAll('.wj-cell')) { const rc = cand.getBoundingClientRect(); if (!rc.width) continue; const ht = c.hitTest(rc.left + rc.width / 2, rc.top + rc.height / 2); if (ht && ht.row === ${row} && ht.col === col.index && ht.panel === c.cells) { el = cand; break; } } } catch { el = null; } }
      if (!el) { try { c.select(${row}, col.index); c.refresh(false); await new Promise(r => requestAnimationFrame(r)); await new Promise(r => setTimeout(r, 120)); el = c.cells.getCellElement(${row}, col.index);
        if (!el) for (const cand of c.cells.hostElement.querySelectorAll('.wj-cell.wj-state-selected, .wj-cell.wj-state-active')) { const rc = cand.getBoundingClientRect(); if (!rc.width) continue; const ht = c.hitTest(rc.left + rc.width / 2, rc.top + rc.height / 2); if (ht && ht.row === ${row} && ht.col === col.index) { el = cand; break; } } } catch { el = null; } }
      if (el) { const cs = getComputedStyle(el); const inner = el.querySelector('span,div'); const ics = inner ? getComputedStyle(inner) : null;
        return { color: cs.color, innerColor: ics ? ics.color : '', bg: cs.backgroundColor, cls: el.className, text: (el.textContent || '').trim(), bl: cs.borderLeftWidth + '|' + cs.borderLeftColor, br: cs.borderRightWidth + '|' + cs.borderRightColor }; } await new Promise(r => setTimeout(r, 200)); }
      const vr = c.viewRange; return { err: '셀 요소 없음 — rows ' + c.rows.length + ' · viewRange r' + (vr ? vr.row : '?') + '~' + (vr ? vr.row2 : '?') + ' c' + (vr ? vr.col : '?') + '~' + (vr ? vr.col2 : '?') + ' · scrollPosition ' + JSON.stringify(c.scrollPosition) + ' · col.index ' + col.index + ' visible ' + col.visible + ' · 렌더 셀 ' + c.cells.hostElement.querySelectorAll('.wj-cell').length }; })()`) as Promise<{ color: string; innerColor: string; bg: string; cls: string; text: string; err?: string } | null>,
  /** 좌측 고정 컬럼 수와 그 binding 목록(H12 · SHEET_COLUMNS FIXED_FLAG 대조) */
  frozenColumns: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const n = c.frozenColumns || 0; const o = []; for (let i = 0; i < n && i < c.columns.length; i++) o.push(String(c.columns[i].binding || ''));
      const last = n > 0 && n <= c.columns.length ? c.columns[n - 1] : null; const frozenW = last ? (last.pos || 0) + (last.renderWidth || 0) : 0; const clientW = (c.clientSize && c.clientSize.width) || c.hostElement.clientWidth || 0;
      return { n, bindings: o, frozenW, clientW, viewportW: window.innerWidth }; })()`) as Promise<{ n: number; bindings: string[]; frozenW: number; clientW: number; viewportW: number } | null>,
  /** 보이는 컬럼 헤더 텍스트(binding → header) */
  headersOf: (p: Page) =>
    p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; const o = {}; for (let i = 0; i < c.columns.length; i++) { const x = c.columns[i]; if (x.binding && x.visible !== false) o[String(x.binding)] = String(x.header || ''); } return o; })()`) as Promise<Record<string, string> | null>,
  /** rgb 문자열이 '빨강 계열'인지(r 우세) */
  isRedColor(c: string): boolean { const m = /rgba?\((\d+),\s*(\d+),\s*(\d+)/.exec(c || ''); if (!m) return false; const [r, g, b] = [Number(m[1]), Number(m[2]), Number(m[3])]; return r >= 150 && g <= 110 && b <= 110; },
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
