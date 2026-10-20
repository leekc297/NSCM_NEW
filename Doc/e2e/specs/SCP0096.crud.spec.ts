// 자동 생성 — tools/E2E/gen-e2e.js (2026-10-20) · 원천: Doc/gen/SCP0096/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
import { test, expect } from '../../../tools/E2E/fixtures/test';
import * as fs from 'node:fs';
const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0096.plan.json', 'utf8'));
const MENU = "SCP0096";

test.describe.serial(`${MENU} Shipment_Working_Day_OSP CRUD @crud`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  const MARK = "E2E_" + Date.now().toString(36).toUpperCase();
  test('Insert(F8) → 입력 → Save(F7) → 재조회 → Delete(F9) → Save → 재조회', async ({ nscm, page }) => {
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    await nscm.search();
    expect(await nscm.subButtonVisible('Save'), 'Save(F7) 버튼').toBeTruthy();
    const canInsert = await nscm.subButtonVisible('Insert');
    const before = await nscm.gridRowCount(0);
    if (canInsert) {
      // C: 행 추가 + 첫 편집 가능 컬럼에 마커 입력 (키 컬럼 구성은 화면별 — 실패 시 플랜의 keyColumns 를 채워 보완)
      await nscm.subButton('Insert').click();
      await expect.poll(() => nscm.gridRowCount(0), { timeout: 10_000 }).toBeGreaterThan(before);
      const headers = await nscm.gridHeaders(0);
      const keyCols: string[] = PLAN.keyColumns || [];
      const targetCol = keyCols.length ? headers.findIndex(h => h.toLowerCase() === keyCols[0].toLowerCase()) : 0;
      await nscm.setCell(0, Math.max(targetCol, 0), MARK);
      const saved = await nscm.save();
      expect.soft(saved.message, '저장 알림').not.toMatch(/ORA-|Exception|실패|fail|error/i);
      for (const c of saved.calls) expect.soft(c.status, `SAVE call-proc ${c.sheet}/${c.btn}`).toBeLessThan(400);
      // R: 재조회 → 마커 존재
      await nscm.search();
      const txt = await nscm.grid(0).innerText();
      expect.soft(txt.includes(MARK), '재조회 후 신규 행 존재').toBeTruthy();
      // U: 마커 행 수정(두 번째 컬럼) → Save → 재조회
      const rows = nscm.grid(0).locator('.wj-cells .wj-row'); const n = await rows.count(); let ri = -1;
      for (let i = 0; i < n && ri < 0; i++) if ((await rows.nth(i).innerText()).includes(MARK)) ri = i;
      if (ri >= 0 && headers.length > 1) { await nscm.setCell(ri, Math.min(targetCol + 1, headers.length - 1), MARK + '_U'); const u = await nscm.save(); expect.soft(u.message).not.toMatch(/ORA-|Exception|실패|error/i); await nscm.search(); expect.soft((await nscm.grid(0).innerText()).includes(MARK + '_U'), '수정 반영').toBeTruthy(); }
      // D: 마커 행 선택 → Delete(F9) → Save → 재조회 → 마커 없음
      if (await nscm.subButtonVisible('Delete')) {
        const rows2 = nscm.grid(0).locator('.wj-cells .wj-row'); const n2 = await rows2.count();
        for (let i = 0; i < n2; i++) if ((await rows2.nth(i).innerText()).includes(MARK)) { await rows2.nth(i).locator('.wj-cell').first().click(); break; }
        await nscm.subButton('Delete').click(); await nscm.closeAlert('ok');
        const d = await nscm.save(); expect.soft(d.message).not.toMatch(/ORA-|Exception|실패|error/i);
        await nscm.search();
        expect.soft((await nscm.grid(0).innerText()).includes(MARK), '삭제 후 마커 없음').toBeFalsy();
      } else test.info().annotations.push({ type: 'skip', description: 'Delete(F9) 버튼 없음 — 삭제 미지원 화면' });
    } else {
      // Insert 가 없는 저장 화면(셀 편집 저장형): 첫 행 첫 편집가능 컬럼 수정 → 저장 → 재조회 → 원복
      test.info().annotations.push({ type: 'mode', description: '셀 편집 저장형(Insert 없음)' });
      const cell = await nscm.gridCell(0, 1); const orig = (await cell.innerText()).trim();
      await nscm.setCell(0, 1, MARK); const s1 = await nscm.save(); expect.soft(s1.message).not.toMatch(/ORA-|Exception|실패|error/i);
      await nscm.search(); expect.soft((await nscm.grid(0).innerText()).includes(MARK), '수정 반영').toBeTruthy();
      await nscm.setCell(0, 1, orig); await nscm.save(); // 원복
    }
    await nscm.snapshot(`${MENU}_crud`);
  });
});
