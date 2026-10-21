// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-21) · 원천: Doc/gen/SCP0096/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0096.plan.json', 'utf8'));
const MENU = "SCP0096";

// 계정별(권한그룹) × Division 매트릭스 — 로그인은 dev-login(id) 이라 비밀번호가 필요 없다
// 2026-10-20: btn_auth 의 코드 중 실제 '버튼' 으로 뜨는 것만 노출 대조 — EDIT(셀 편집 권한)·SEARCH(조회 버튼은 항상) 등은 버튼이 아니거나 항상 있어 제외
const BUTTON_CODES: Record<string, RegExp> = { SAVE: /^Save/i, INSERT: /^Insert/i, DELETE: /^Delete/i, EXCEL: /Excel/i, EXCEL_UPLOAD: /Excel\s*Upload/i, EXCEL_DOWNLOAD: /Excel\s*Download/i, COPY: /^Copy/i, PRINT: /^Print/i, EXECUTE: /^Execute/i, CONFIRM: /^Confirm/i, APPROVE: /^Approve/i, TRANSFER: /^Transfer/i, ACTION: /^Action/i };
for (const acc of PLAN.accounts) {
  const G = (acc.tobeGroups && acc.tobeGroups.length ? acc.tobeGroups : acc.groups) as string[];
  test.describe(`${MENU} 권한 @auth [${acc.id} ${G.join('/')}]`, () => {
    test.use({ account: acc.id });
    test('메뉴 접근 · 버튼 노출 · Division 데이터 범위', async ({ nscm }) => {
      // 시간 예산: Division 마다 조회(최대 searchTimeoutMs) — 기본 180s 로는 3 Division 계정이 초과한다(2026-10-20 실측)
      test.setTimeout(90_000 + (acc.divisions || []).length * (120000 + 30_000));
      const r = await nscm.openScreen(MENU);
      const expectedGroup = acc.screenGroup; // 통합테스트 데이터셋의 화면별 권한 해석(없으면 기록만)
      test.info().annotations.push({ type: 'access', description: `authorized=${r.authorized} notFound=${r.notFound} menuAccess=${acc.menuAccess || '?'} tobeGroups=${G.join('|')} roster=${Object.entries(acc.roles || {}).map(([d, ro]) => d + ':' + ro).join(',') || (acc.adminOf || []).join('|') || expectedGroup || '-'} (${PLAN.accountSource || 'accounts.json'})` });
      if (!r.authorized || r.notFound) { expect.soft(acc.admin, 'ADMIN 계정은 모든 화면 접근 가능해야 함').toBeFalsy(); return; }
      if (acc.menuAccess === 'N') test.info().annotations.push({ type: 'gap', description: `메뉴 권한(user_group_menu) 없는 계정이 /view/${MENU} 직접 접근으로 열림 — To-Be FE 는 라우트 가드 없음(메뉴 트리에서만 숨김)` });
      const buttons = await nscm.visibleButtons();
      test.info().annotations.push({ type: 'buttons', description: buttons.join(' | ') });
      // To-Be 메타 기대(계정 그룹 합집합 × btn_auth) 와 대사 — 버튼 코드만, 양방향(있어야 할 버튼 노출 · 없어야 할 버튼 비노출)
      const expBtns: string[] | null = acc.expectedBtns || null; const codes: string[] = PLAN.menuBtnCodes || [];
      if (expBtns) for (const code of codes) { const re = BUTTON_CODES[code]; if (!re) continue; const want = expBtns.includes(code); expect.soft(buttons.some(x => re.test(x)), `[${acc.id} ${G.join('/')}] btn_auth ${code}=${want ? 'Y' : 'N'} → 버튼 ${want ? '노출' : '비노출'}`).toBe(want); }
      else test.info().annotations.push({ type: 'note', description: 'btn_auth 에 이 계정 그룹의 행이 없어 버튼 실측만 기록' });
      // Viewer/Planner 가 아닌데 Save 가 보이면 의심(soft)
      if (!acc.admin && acc.groups.every((g: string) => /viewer/i.test(g))) expect.soft(buttons.some(b => /^Save/i.test(b)), 'Viewer 그룹은 Save 비노출').toBeFalsy();
      for (const d of acc.divisions) {
        const ok = await nscm.setDivision(d);
        const calls = await nscm.search();
        for (const c of calls) expect.soft(c.status, `[${d}] call-proc ${c.sheet}/${c.btn}`).toBeLessThan(400);
        const alert = await nscm.alertText(); if (alert) await nscm.closeAlert();
        // DIVISION 컬럼이 있으면 값이 선택 Division 과 같아야 한다
        const divVals = (await nscm.gridColumnValues('DIVISION')).concat(await nscm.gridColumnValues('DIVISION_ID')).concat(await nscm.gridColumnValues('Division'));
        if (divVals.length) expect.soft(divVals.every(v => !v || v.startsWith(d)), `[${d}] 그리드 DIVISION 값 범위`).toBeTruthy();
        test.info().annotations.push({ type: 'division', description: `${d} set=${ok} rows=${await nscm.gridRowCount(0)} alert=${alert.slice(0, 80)}` });
      }
    });
  });
}
