// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-19) · 원천: Doc/gen/DMF0052/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/DMF0052.plan.json', 'utf8'));
const MENU = "DMF0052";

// 계정별(권한그룹) × Division 매트릭스 — 로그인은 dev-login(id) 이라 비밀번호가 필요 없다
for (const acc of PLAN.accounts) {
  test.describe(`${MENU} 권한 @auth [${acc.id} ${acc.groups.join('/')}]`, () => {
    test.use({ account: acc.id });
    test('메뉴 접근 · 버튼 노출 · Division 데이터 범위', async ({ nscm }) => {
      const r = await nscm.openScreen(MENU);
      const expectedGroup = acc.screenGroup; // 통합테스트 데이터셋의 화면별 권한 해석(없으면 기록만)
      test.info().annotations.push({ type: 'access', description: `authorized=${r.authorized} notFound=${r.notFound} group=${expectedGroup || '-'}` });
      if (!r.authorized || r.notFound) { expect.soft(acc.admin, 'ADMIN 계정은 모든 화면 접근 가능해야 함').toBeFalsy(); return; }
      const buttons = await nscm.visibleButtons();
      test.info().annotations.push({ type: 'buttons', description: buttons.join(' | ') });
      // btn_auth 메타가 있으면 그룹별 기대 버튼과 대사(soft)
      for (const g of acc.groups) { const exp = PLAN.expectedBtnsByGroup[g]; if (!exp) continue; for (const b of exp) expect.soft(buttons.some(x => x.toUpperCase().includes(String(b).toUpperCase())), `[${g}] 버튼 '${b}' 노출`).toBeTruthy(); }
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
