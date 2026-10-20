// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-20) · 원천: Doc/gen/SCP0096/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0096.plan.json', 'utf8'));
const MENU = "SCP0096";
import { crudCycle } from '../../../tools/E2E/lib/crud';

test.describe.serial(`${MENU} Shipment_Working_Day_OSP CRUD @crud`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  const MARK = "E2E_" + Date.now().toString(36).toUpperCase();
  test('Save 노출 · Insert 화면은 마커 행 Insert→Save→재조회→수정→Delete→Save→재조회 · Insert 없는 화면은 셀 수정 Save→재조회→원복 Save→재조회', async ({ nscm }) => {
    test.setTimeout(300_000); // 수정 저장 → 재조회 → 원복 저장 → 재조회(저장·조회 각 최대 60~120s)
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    await nscm.search();
    const out = await crudCycle(nscm, test.info(), PLAN, MARK);
    expect(out.saveVisible, 'As-is 저장 SP 있음 → Save(F7) 버튼').toBeTruthy();
    if (out.mode === 'insert') {
      expect.soft(out.inserted, 'Insert(F8) 로 행 추가').toBeTruthy();
      expect.soft(out.saved, `마커 행 저장 성공 ${out.saveErrors.join(' / ')}`).toBeTruthy();
      expect.soft(out.found, '재조회 후 신규 행 존재').toBeTruthy();
      if (out.found) expect.soft(out.updated, '수정 반영').toBeTruthy();
      expect(out.cleaned, '마커 행 정리(삭제) 완료 — 남아 있으면 수동 삭제 필요').toBeTruthy();
    } else if (out.mode === 'edit-save') {
      // 셀 편집 저장형: 값 변경 → Save → 재조회 반영 → 원복 Save → 재조회 복원 (2026-10-20 사용자 승인)
      expect.soft(out.editable, '편집 가능 셀 존재(값 변경됨)').toBeTruthy();
      if (out.editable) { expect.soft(out.saved, `수정 저장 성공 ${out.saveErrors.join(' / ')}`).toBeTruthy(); expect.soft(out.found, '재조회 후 수정값 반영').toBeTruthy(); expect(out.restored, '원래 값으로 복원 저장·확인 — 실패면 수동 복원 필요').toBeTruthy(); }
    }
    await nscm.snapshot(`${MENU}_crud`);
  });
});
