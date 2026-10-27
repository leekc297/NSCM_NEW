// 디버그(2026-10-24): DMF0005 신규행 Owner 팝업(2단 이동형) 선택 경로 확인. 저장하지 않는다
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('DMF0005 Owner 팝업 @dbgowner', async ({ nscm }) => {
  test.setTimeout(600_000);
  const p = nscm.page;
  await nscm.openScreen('DMF0005');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  await nscm.subButton('Insert').click(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const nr = (await probe.findRow(p, 'new'))!;
  console.log('owner bindings', JSON.stringify(await probe.bindingsByHeader(p, 'Owner')));
  for (const b of ['OWNER', 'OWNER_NAME']) {
    const pt = await probe.cellCenter(p, nr.row, b);
    console.log('cell', b, JSON.stringify(pt));
    if (!pt) continue;
    await p.mouse.dblclick(pt.x, pt.y); await p.waitForTimeout(3000);
    const dlgs = p.locator('[role="dialog"]:visible');
    console.log('visible dialogs', await dlgs.count());
    const dlg = dlgs.last();
    console.log('dlg text', ((await dlg.innerText().catch(() => '')) || '').slice(0, 300).replace(/\n/g, ' | '));
    const grids = dlg.locator('.wj-flexgrid');
    console.log('grids', await grids.count(), 'rows per grid', await grids.evaluateAll(gs => gs.map(g => g.querySelectorAll('.wj-cells .wj-row').length)));
    console.log('buttons', JSON.stringify(await dlg.locator('button').evaluateAll(bs => bs.map(b => (b.textContent || '').trim() || b.getAttribute('aria-label') || '(icon)'))));
    if (await grids.count() >= 2) {
      const cand = grids.nth(0).locator('.wj-cells .wj-row').first();
      await cand.locator('.wj-cell').nth(1).dblclick().catch(e => console.log('dbl err', String(e).slice(0, 100)));
      await p.waitForTimeout(800);
      console.log('after dbl rows', await grids.evaluateAll(gs => gs.map(g => g.querySelectorAll('.wj-cells .wj-row').length)));
      await dlg.getByRole('button', { name: /^OK$/i }).first().click(); await p.waitForTimeout(1500);
      console.log('after OK dialogs', await p.locator('[role="dialog"]:visible').count(), 'text', ((await p.locator('[role="dialog"]:visible').last().innerText().catch(() => '')) || '').slice(0, 200));
      await nscm.clearDialogs();
    } else {
      await nscm.clearDialogs();
    }
    console.log('value OWNER', await probe.value(p, nr.row, 'OWNER'), 'OWNER_NAME', await probe.value(p, nr.row, 'OWNER_NAME'), 'DEPT_ID', await probe.value(p, nr.row, 'DEPT_ID'));
  }
});
