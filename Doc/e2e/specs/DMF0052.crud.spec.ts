// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-20) · 원천: Doc/gen/DMF0052/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/DMF0052.plan.json', 'utf8'));
const MENU = "DMF0052";
import { crudCycle } from '../../../tools/E2E/lib/crud';

test.describe(`${MENU} EDISummary CRUD @crud`, () => {
  test('조회 전용 화면 — 저장 버튼이 없어야 한다', async ({ nscm }) => {
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    expect.soft(await nscm.subButtonVisible('Save'), 'As-is 에 저장 SP 없음 → Save(F7) 비노출').toBeFalsy();
  });
});
