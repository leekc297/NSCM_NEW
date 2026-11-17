// 자동 생성 — tools/E2E/gen-e2e.js (2026-11-14) · 원천: Doc/gen/SCP0037/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0037.plan.json', 'utf8'));
const MENU = "SCP0037";
import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)

test.describe(`${MENU} OperationLT 스모크 @smoke`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
    const r = await nscm.openScreen(MENU);
    expect(r.notFound, '404 아님').toBeFalsy();
    expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
    await nscm.snapshot(`${MENU}_open`);
    // 2026-10-21: 화면 열자마자 콘솔 치명 오류를 먼저 확인 — 그리드 생성이 Wijmo 단언으로 죽으면(SCP0100 "Unknown property inner") 뒤의 라벨/그리드 검사는 전부 부수 증상이다
    { await page.waitForTimeout(800); const errs0 = nscm.consoleErrors; const fatal0 = errs0.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
      if (errs0.length) test.info().annotations.push({ type: 'console', description: `열림 직후 오류 ${errs0.length}(치명 ${fatal0.length}): ${[...fatal0, ...errs0.filter(e => !fatal0.includes(e))].slice(0, 3).join(' || ')}` });
      expect.soft(fatal0.length, `화면 열림 직후 브라우저 콘솔 치명 오류 0 — ${fatal0[0] || ''}`).toBe(0); }
    // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
    //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
    const expanded = await nscm.expandSearchArea();
    const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
    for (const f of PLAN.fields) {
      if (f.excluded) { labelSkip.push(`${f.label}(${f.asis}: ${f.excludedWhy})`); continue; }
      // 2026-11-08 (a): 별칭 표의 TO-BE 명칭(예 Valid→Active)도 후보 — 검사기와 기대값 원천을 같이 쓴다(종전엔 smoke 만 별칭 없이 '누락' → 검사기 PASS 와 불일치)
      const cands0: string[] = f.labels && f.labels.length ? f.labels : [f.label];
      const AL = loadLabelAliases(MENU); const cands = [...new Set([...cands0, ...cands0.map((l: string) => aliasFor(l, AL)?.tobe_label || '').filter(Boolean)])];
      const hit = await nscm.fieldExistsAny(cands);
      if (hit) labelHits.push(`${f.label}→${hit}`); else labelMiss.push(f.label);
      expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
    }
    test.info().annotations.push({ type: 'labels', description: `펼침=${expanded} 일치 ${labelHits.length} / 누락 ${labelMiss.length}${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}` });
    // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
    const gridCount = await nscm.grids().count();
    expect(gridCount, `그리드 ≥1 (메인시트 ${PLAN.mainSheets.length})`).toBeGreaterThanOrEqual(1);
    // Division 선택(있으면) 후 조회
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    const calls = await nscm.search();
    const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
    expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
    for (const c of calls) expect.soft(c.status, `call-proc ${c.sheet}/${c.btn} HTTP`).toBeLessThan(400);
    // 2026-10-21: 브라우저 콘솔 오류/페이지 예외 — Wijmo 단언(그리드 생성 실패)·Uncaught 는 화면 결함으로 FAIL, 나머지는 기록만
    { const errs = nscm.consoleErrors; const fatal = errs.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
      test.info().annotations.push({ type: 'console', description: errs.length ? `오류 ${errs.length}(치명 ${fatal.length}): ${[...fatal, ...errs.filter(e => !fatal.includes(e))].slice(0, 3).join(' || ')}` : '오류 0' });
      expect.soft(fatal.length, `브라우저 콘솔 치명 오류 0 — ${fatal[0] || ''}`).toBe(0); }
    const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
    expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
    // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
    const headers = await nscm.gridHeadersAll(0);  // T162: 가로 가상화로 DOM 헤더가 일부만 보여 허위 누락
    // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
    const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
    const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
    const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
    const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
    const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
    const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
    // 2026-10-21: As-is SetLayout(조회조건에 따라 표시/숨김)이 다루는 컬럼은 기본 조회에서 안 보여도 '누락' 이 아니다(SCP0100 Product Level1~3)
    const condSet = new Set(((PLAN.condLabels || []) as string[]).map(norm));
    const missingAll = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
    const condHidden = missingAll.filter((c: string) => condSet.has(norm(c)));
    const missing = missingAll.filter((c: string) => !condSet.has(norm(c)));
    test.info().annotations.push({ type: 'columns', description: `시트 ${sheetName}(${firstSearch ? firstSearch.sheet : '-'}) 헤더 ${headers.length} / 기대 ${expectCols.length} / 누락 ${missing.length}: ${missing.slice(0, 10).join(', ')}${condHidden.length ? ' / 조건부 표시(SetLayout) 제외 ' + condHidden.length + ': ' + condHidden.join(', ') : ''}` });
    expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
    // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
    // As-is 헤더 사양 대조(2026-10-21 SCP0100: 대조표 '구현' 인데 3단 헤더가 144px 한 칸으로 병합되고 "Qty" 행이 없었다) — 행 수·병합 리터럴·행 높이
    if (PLAN.headerSpec && PLAN.headerSpec.rows > 1) {
      const HS = PLAN.headerSpec; const hr = await nscm.gridHeaderRows(0);
      const texts = new Set(hr.rows.flatMap(r => r.texts));
      const missLit = (HS.literals || []).filter((l: string) => !texts.has(l));
      test.info().annotations.push({ type: 'header', description: `As-is 헤더 ${HS.rows}행(병합 리터럴 ${(HS.literals || []).join('/') || '-'}) ↔ To-Be 행 ${hr.rows.length}(높이 ${hr.rows.map(r => r.h).join('+')}=${hr.height}px)${missLit.length ? ' · 리터럴 누락 ' + missLit.join(',') : ''}` });
      // 행 수는 '시각적 단' 기준 — As-is 월간은 3행이어도 Qty 가 1~2행을 병합해 2단으로 보인다. 따라서 2단 이상이면 통과(리터럴·분리·높이 검사가 실질 판정)
      expect.soft(hr.rows.length, `헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn ${HS.rows}행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검`).toBeGreaterThanOrEqual(Math.min(HS.rows, 2));
      expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
      expect.soft(hr.height, `헤더 총 높이 ≤ ${HS.maxRowPx}px × ${HS.rows}행 (headerRowHeight 재적용 — check.js H01)`).toBeLessThanOrEqual(HS.maxRowPx * HS.rows);
      // 2026-10-21 사용자 지적: ① 리터럴(Qty) 칸은 상단 월 칸이 분리돼 있으면 하단도 분리(가로 병합 1칸 금지) ② leaf(Qty) 행이 그룹(월) 행보다 낮으면 As-is 와 역전
      if (HS.literals && HS.literals.length && hr.rows.length >= 2) {
        const top = hr.rows[0]; const litRow = hr.rows.find(r => (HS.literals as string[]).some((l: string) => r.texts.includes(l)));
        if (litRow) {
          const topDyn = top.cells.filter(c => !/^[A-Za-z가-힣 ./()]+$/.test(c)).length; // 상단 행에서 문자 라벨(고정 컬럼)이 아닌 칸(연월·주차) 수
          test.info().annotations.push({ type: 'header', description: `리터럴 행 칸 ${litRow.n} / 상단 동적 칸 ${topDyn} · 높이 상단 ${top.h} vs 리터럴 행 ${litRow.h}` });
          if (topDyn >= 2) expect.soft(litRow.n, `리터럴(${HS.literals.join('/')}) 칸이 월마다 분리(상단 동적 칸 ${topDyn}) — 1칸이면 헤더 가로 병합(check.js H05)`).toBeGreaterThanOrEqual(Math.min(topDyn, 2));
          expect.soft(litRow.h >= top.h, `leaf(${HS.literals.join('/')}) 행 높이(${litRow.h}) ≥ 상단 그룹 행(${top.h}) — As-is 는 Qty 영역이 더 높다(1~2행 병합)`).toBeTruthy();
        }
      }
    }
    if (PLAN.dynamicHeader) {
      const DH = PLAN.dynamicHeader;
      const binds = await nscm.gridBindings(0);
      const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
      const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
      const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
      test.info().annotations.push({ type: 'dynamic', description: `As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 ${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 ${binds ? binds.length : '판정불가'} / 정적밖 ${dyn.length} (${dyn.slice(0, 5).join(',')}) · 타이틀 시트 ${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 ${titleCalls.length}` });
      expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
      expect.soft(dyn.length, `동적 기간 컬럼 ≥1 (As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 ${stat.size}개 밖 컬럼)`).toBeGreaterThan(0);
      if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), `타이틀 시트 '${DH.titleSheets.join("','")}' call-proc 조회`).toBeTruthy();
    }
    await nscm.snapshot(`${MENU}_searched`);
    test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
    // 2026-10-23 사용자 지시: 다국어 미적용(코드 미등록 → '_기본문구' 노출) = 오류 — 조회조건 펼침·조회 후 보이는 글자 전체
    { const u = await nscm.untranslatedTexts();
      test.info().annotations.push({ type: 'i18n', description: u.length ? `'_' 노출 ${u.length}: ${u.slice(0, 15).join(' | ')}` : "'_' 노출 0" });
      expect.soft(u.length, `다국어 미적용 '_' 노출 0 — ${u.slice(0, 8).join(' | ')} (SCM_ADM_MSG_M 에 코드 등록 또는 기존 LBL/MSG 재사용 · 하네스 I18N1)`).toBe(0); }
  });
  // 2026-10-23 사용자 지시: 조회조건 각각의 동작 · 공통 기능 동작 (lib/smoke-extra.ts) — 결과는 cond:/common: 어노테이션 → _summary · 대조표(recon) 열
  test('조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인', async ({ nscm }) => {
    test.setTimeout(1_200_000);
    const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
    const items = await conditionCycle(nscm, test.info(), PLAN);
    const s = record(test.info(), 'cond', items);
    await nscm.snapshot(`${MENU}_cond`);
    expect.soft(s.fail, `조회조건 동작 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
    expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
  });
  test('공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual', async ({ nscm }) => {
    test.setTimeout(600_000);
    const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
    const items = await commonCycle(nscm, test.info(), PLAN);
    const s = record(test.info(), 'common', items);
    await nscm.snapshot(`${MENU}_common`);
    expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  });
});
