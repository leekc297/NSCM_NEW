// 시범(2026-10-23) — SCP0007 BOD 신규행 흐름 검증. 생성기(gen-e2e.js) 산출물이 아니다: CRUD 단계 확장 설계를 실측으로 검증하기 위한 수기 시범 스펙.
//   태그 @insertflow — run-e2e.cmd 의 smoke/crud/auth/authcrud 체인에는 포함되지 않는다. 저장(Save)은 하지 않는다(DB 무변경).
//   기대값 = AS-IS 원문(GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0007_BOD/SCP0007_BOD.cs) 동작.
//     A1 cs:370-376/540  Insert 는 조회 버튼이 strSel_InputStatus 를 'C' 로 세팅한 뒤에만 행을 추가 → 조회 전 Insert = 무동작
//     A2 cs:408-411      Division 자동세팅·잠금은 '조회한 Division 이 1개(2자리)' 일 때만. 다중/ALL 조회 후 신규행의 Division 은 계속 편집 가능
//     A3 cs:1163-1176    From/To Site 콤보 선택 시 그 콤보 행의 CITY 로 FROM_CITY/TO_CITY 를 채운다(조회 시점 캐시 무관)
//     A4 cs:1126-1159    To Site 후보 = 조회조건 Division 으로 거른 목록(행의 Division 아님) — 고객 지적 '행 Div 변경 시 cascade 없음' 은 AS-IS 와 같아 판정 대상
import { test, expect } from '../../../tools/E2E/fixtures/test';
import type { Page } from '@playwright/test';

const MENU = 'SCP0007';
const B = { DIV: 'DIVISION_ID', FROM: 'FROM_SITE_CODE', TO: 'TO_SITE_CODE', FROM_CITY: 'FROM_CITY', TO_CITY: 'TO_CITY' } as const;

type NewRow = { row: number; values: Record<string, string> } | null;

// 보이는 첫 Wijmo 그리드의 컨트롤을 꺼내는 코드 — lib/nscm.ts gridColumnsMeta 와 같은 방식($WJ-CTRL 또는 columns 보유 속성)
const CTL = `(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); if (!el) return null;
  let c = el['$WJ-CTRL']; if (!c || !c.columns) for (const k of Object.getOwnPropertyNames(el)) { const v = el[k]; if (v && typeof v === 'object' && v.columns && typeof v.columns.length === 'number') { c = v; break; } } return c || null; })()`;

const g = {
  /** 신규행(CRUD_TYPE='I') 개수 */
  newRowCount: (p: Page) => p.evaluate(`(() => { const c = ${CTL}; if (!c) return -1; let n = 0; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && d.CRUD_TYPE === 'I') n++; } return n; })()`) as Promise<number>,
  /** 첫 신규행의 위치와 주요 값 */
  newRow: (p: Page) => p.evaluate(`(() => { const c = ${CTL}; if (!c) return null; for (let r = 0; r < c.rows.length; r++) { const d = c.rows[r].dataItem; if (d && d.CRUD_TYPE === 'I') { const v = {}; for (const b of ${JSON.stringify(Object.values(B))}) v[b] = d[b] == null ? '' : String(d[b]); return { row: r, values: v }; } } return null; })()`) as Promise<NewRow>,
  /** 셀 편집기가 열리는지(beginningEdit 취소 여부) — 열리면 즉시 취소(값 변경 없음) */
  editable: (p: Page, row: number, binding: string) => p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${JSON.stringify(binding)}); if (!col) return null;
    const ok = c.startEditing(true, ${row}, col.index); if (ok) c.finishEditing(true); return !!ok; })()`) as Promise<boolean | null>,
  /** 콤보 셀 후보(표시값) — DataMap.getDisplayValues(행) */
  candidates: (p: Page, row: number, binding: string) => p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${JSON.stringify(binding)}); if (!col || !col.dataMap) return null;
    const d = c.rows[${row}].dataItem; return (col.dataMap.getDisplayValues(d) || []).map(String); })()`) as Promise<string[] | null>,
  /** 편집기를 통해 값 입력(사용자 편집과 같은 cellEditEnding/cellEditEnded 경로) — 편집기가 안 열리면 false */
  setByEditor: (p: Page, row: number, binding: string, display: string) => p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${JSON.stringify(binding)}); if (!col) return false;
    c.select(${row}, col.index); if (!c.startEditing(true, ${row}, col.index)) return false; const ed = c.activeEditor; if (!ed) { c.finishEditing(true); return false; }
    ed.value = ${JSON.stringify(display)}; c.finishEditing(false); return true; })()`) as Promise<boolean>,
};

/** 조회 요청 본문에서 divisionId 추출(조회조건이 실제로 무엇으로 나갔는지) */
const searchedDivision = (body: string | undefined) => { try { const j = JSON.parse(body || '{}'); const v = j.divisionId ?? j.data?.divisionId ?? j.params?.divisionId; return v == null ? '' : String(v); } catch { return /divisionId"?\s*[:=]\s*"?([^",}]*)/.exec(body || '')?.[1] ?? ''; } };

/** Site 콤보에서 후보를 하나 골라 입력 — 성공한 표시값 반환.
 *  CITY 가 있는 후보를 우선한다(2026-10-23 1차 실행: 'EG00' 은 SCM_MST_SITE.CITY 가 비어 있는 CORP Site 라 AS-IS 에서도 City 가 빈다 → 오탐) */
async function pickFirst(p: Page, row: number, binding: string) {
  const cands = (await g.candidates(p, row, binding)) || [];
  const withCity = (await p.evaluate(`(() => { const c = ${CTL}; const col = c && c.columns.getColumn(${JSON.stringify(binding)}); const items = col && col.dataMap && col.dataMap.collectionView ? col.dataMap.collectionView.items : [];
    const s = new Set(); for (const it of items) if (it && it.CITY) s.add(String(col.dataMap.getDisplayValue(it.CODE))); return [...s]; })()`)) as string[];
  const ordered = [...cands.filter(v => withCity.includes(v)), ...cands.filter(v => !withCity.includes(v))];
  for (const v of ordered.slice(0, 5)) { if (v && (await g.setByEditor(p, row, binding, v))) return { picked: v, count: cands.length, hasCity: withCity.includes(v) }; }
  return { picked: '', count: cands.length, hasCity: false };
}

test.describe(`${MENU} 신규행 흐름 @insertflow`, () => {
  test.describe.configure({ retries: 0 });

  test('A1 조회 전 Insert = 행 추가 없음 (AS-IS cs:370-376) · 추가되면 City 매핑(A3)까지 기록', async ({ nscm }) => {
    test.setTimeout(180_000);
    const p = nscm.page;
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    await p.waitForTimeout(3_000); // 그리드 콤보 원천(FROM/TO_SITE) 로드 대기
    const before = await g.newRowCount(p);
    await nscm.subButton('Insert').click({ timeout: 10_000 });
    await p.waitForTimeout(1_000);
    const alert = await nscm.alertText(); if (alert) await nscm.clearDialogs();
    const after = await g.newRowCount(p);
    const added = after > before;
    test.info().annotations.push({ type: 'A1', description: `조회 전 Insert: 신규행 ${before}→${after}${alert ? ` · 알림='${alert}'` : ''}` });

    if (added) {
      // 결함 재현 기록(#22): 행 Division → From/To Site 선택 → City 채움 여부
      const nr = (await g.newRow(p))!;
      const divEditable = await g.editable(p, nr.row, B.DIV);
      const divCands = (await g.candidates(p, nr.row, B.DIV)) || [];
      const div = divCands.find(v => /^40\b/.test(v)) || divCands[0] || '';
      const divSet = div ? await g.setByEditor(p, nr.row, B.DIV, div) : false;
      const f = await pickFirst(p, nr.row, B.FROM);
      const t = await pickFirst(p, nr.row, B.TO);
      await p.waitForTimeout(1_500); // applyCityCode 비동기(Route Cnt 조회)
      const v = (await g.newRow(p))!.values;
      test.info().annotations.push({ type: 'A1-row', description: `Division 편집=${divEditable} 후보=${divCands.length} 입력='${div}'(${divSet}) · From 후보=${f.count} 선택='${f.picked}' · To 후보=${t.count} 선택='${t.picked}' · FROM_CITY='${v[B.FROM_CITY]}' TO_CITY='${v[B.TO_CITY]}'` });
      expect.soft(f.picked && v[B.FROM_CITY] !== '', 'A3 From Site 선택 시 FROM_CITY 채움(AS-IS cs:1163)').toBeTruthy();
      expect.soft(t.picked && v[B.TO_CITY] !== '', 'A3 To Site 선택 시 TO_CITY 채움(AS-IS cs:1172-1176)').toBeTruthy();
    }
    expect(added, 'A1 AS-IS 는 조회 전 Insert 무동작(strSel_InputStatus 미세팅) — TO-BE 는 행이 추가됨').toBeFalsy();
  });

  test('A2 ALL(다중) Division 조회 후 신규행 Division = 선택 후에도 다시 변경 가능 (AS-IS cs:408-411)', async ({ nscm }) => {
    test.setTimeout(300_000);
    const p = nscm.page;
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    const calls = await nscm.search();
    const sent = searchedDivision(calls.find(c => c.btn.toUpperCase() === 'SEARCH')?.body);
    test.info().annotations.push({ type: 'A2-search', description: `조회 divisionId='${sent}' · 호출 ${calls.map(c => `${c.sheet}/${c.btn}:${c.status}`).join(', ')}` });
    test.skip(sent.length === 2, `조회조건 Division 이 단일(${sent}) — 다중 조건 전제 불성립`);

    await nscm.subButton('Insert').click({ timeout: 10_000 });
    await p.waitForTimeout(1_000); await nscm.clearDialogs();
    const nr = await g.newRow(p); expect(nr, '조회 후 Insert = 신규행 추가').not.toBeNull();
    expect(nr!.values[B.DIV], 'A2 다중 조회 → Division 자동세팅 없음(cs:408 Length==2 아님)').toBe('');

    const e1 = await g.editable(p, nr!.row, B.DIV);
    const cands = (await g.candidates(p, nr!.row, B.DIV)) || [];
    const first = cands.find(v => /^40\b/.test(v)) || cands[0] || '';
    const second = cands.find(v => v !== first && /^8[12]\b/.test(v)) || cands.find(v => v !== first) || '';
    const s1 = first ? await g.setByEditor(p, nr!.row, B.DIV, first) : false;
    const v1 = (await g.newRow(p))!.values[B.DIV];
    const e2 = await g.editable(p, nr!.row, B.DIV);
    const s2 = e2 && second ? await g.setByEditor(p, nr!.row, B.DIV, second) : false;
    const v2 = (await g.newRow(p))!.values[B.DIV];
    test.info().annotations.push({ type: 'A2', description: `선택 전 편집=${e1} · 1차 '${first}'→${s1}(값 ${v1}) · 1차 후 편집=${e2} · 2차 '${second}'→${s2}(값 ${v2}) · 후보 ${cands.length}` });
    expect(e1, 'A2 신규행 Division 최초 편집 가능').toBeTruthy();
    expect(e2, 'A2 Division 을 한 번 고른 뒤에도 다시 변경 가능(AS-IS 는 자동세팅 행만 잠금) — 고객 #18 "Div를 한번 선택하면 변경 불가"').toBeTruthy();
  });

  test('A3 조회 후 신규행 From/To Site 선택 = City 채움 · A4 To Site 후보는 조회조건 Division 기준(기록)', async ({ nscm }) => {
    test.setTimeout(300_000);
    const p = nscm.page;
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    await nscm.search();
    await nscm.subButton('Insert').click({ timeout: 10_000 });
    await p.waitForTimeout(1_000); await nscm.clearDialogs();
    const nr = await g.newRow(p); expect(nr, '조회 후 Insert = 신규행 추가').not.toBeNull();
    const row = nr!.row;
    const divCands = (await g.candidates(p, row, B.DIV)) || [];
    const div = nr!.values[B.DIV] || divCands.find(v => /^40\b/.test(v)) || divCands[0] || '';
    if (!nr!.values[B.DIV] && div) await g.setByEditor(p, row, B.DIV, div);

    // A4 기록: 행 Division 이 달라도 To Site 후보가 같은지(AS-IS 도 조회조건 Division 기준 — 판정 대상)
    const toBy = await p.evaluate(`(() => { const c = ${CTL}; const col = c.columns.getColumn('TO_SITE_CODE'); if (!col || !col.dataMap) return null; const d = c.rows[${row}].dataItem;
      const n = dv => (col.dataMap.getDisplayValues(Object.assign({}, d, { DIVISION_ID: dv })) || []).length; return { d40: n('40'), d81: n('81'), d82: n('82') }; })()`);
    const fromBy = await p.evaluate(`(() => { const c = ${CTL}; const col = c.columns.getColumn('FROM_SITE_CODE'); if (!col || !col.dataMap) return null; const d = c.rows[${row}].dataItem;
      const n = dv => (col.dataMap.getDisplayValues(Object.assign({}, d, { DIVISION_ID: dv })) || []).length; return { d40: n('40'), d81: n('81'), d82: n('82') }; })()`);
    test.info().annotations.push({ type: 'A4', description: `행 Division 별 후보 수 — From ${JSON.stringify(fromBy)} · To ${JSON.stringify(toBy)} (To 가 같으면 AS-IS 와 동일: 조회조건 Division 기준)` });

    const f = await pickFirst(p, row, B.FROM);
    const t = await pickFirst(p, row, B.TO);
    await p.waitForTimeout(1_500);
    const v = (await g.newRow(p))!.values;
    test.info().annotations.push({ type: 'A3', description: `Division='${v[B.DIV]}' · From 후보=${f.count} 선택='${f.picked}' FROM_CITY='${v[B.FROM_CITY]}' · To 후보=${t.count} 선택='${t.picked}' TO_CITY='${v[B.TO_CITY]}'` });
    expect(t.count, 'A3 To Site 후보 목록 비어 있지 않음 — 고객 #22 "to site 콤보 리스트 누락"').toBeGreaterThan(0);
    expect.soft(f.picked !== '' && v[B.FROM_CITY] !== '', 'A3 From Site 선택 → FROM_CITY 채움').toBeTruthy();
    expect.soft(t.picked !== '' && v[B.TO_CITY] !== '', 'A3 To Site 선택 → TO_CITY 채움').toBeTruthy();
  });
});
