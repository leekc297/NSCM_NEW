// 디버그(2026-10-24): DMF0082 신규행 — Site·Model 변경 후 Cell Prod Site 편집 후보 확인. 저장하지 않는다
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('DMF0082 Cell Prod Site 후보 @dbgitem', async ({ nscm }) => {
  test.setTimeout(400_000);
  const p = nscm.page;
  await nscm.openScreen('DMF0082');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  await nscm.subButton('Insert').click(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const nr = (await probe.findRow(p, 'new'))!;
  console.log('site', await probe.setByEditor(p, nr.row, 'SCM_SITE_ID', 'Sunwoda_CN_SZX'), await probe.value(p, nr.row, 'CELL_PROD_SITE_ID'));
  const pt = (await probe.cellCenter(p, nr.row, 'ITEM_ID'))!;
  await p.mouse.dblclick(pt.x, pt.y);
  const dlg = p.locator('[role="dialog"]:visible').last();
  let n = 0; for (let k = 0; k < 180 && !n; k++) { n = await dlg.locator('.wj-cells .wj-row').count().catch(() => 0); if (!n) await p.waitForTimeout(500); }
  const row = dlg.locator('.wj-cells .wj-row').filter({ hasText: 'MCP2684B9A20-D01' }).first();
  console.log('popup rows', n, 'target visible', await row.isVisible().catch(() => false));
  await row.locator('.wj-cell').nth(1).click(); await p.waitForTimeout(300);
  await dlg.getByRole('button', { name: /^OK$/i }).first().click(); await p.waitForTimeout(3000); await nscm.clearDialogs();
  console.log('item', await probe.value(p, nr.row, 'ITEM_ID'), 'cell prod', await probe.value(p, nr.row, 'CELL_PROD_SITE_ID'));
  const calls = nscm.combos.filter(c => /CELL_PROD/.test(c.body)).map(c => ({ body: c.body.slice(0, 160), n: c.n, rows: (c.rows || []).map(r => r.c) }));
  console.log('cellprod combos', JSON.stringify(calls).slice(0, 900));
  const opened = await probe.startEdit(p, nr.row, 'CELL_PROD_SITE_ID'); await p.waitForTimeout(800);
  console.log('edit opened', opened, 'cands', JSON.stringify(await probe.candidates(p, nr.row, 'CELL_PROD_SITE_ID')));
  await probe.cancelEdit(p);
  console.log('setByEditor 오창A', await probe.setByEditor(p, nr.row, 'CELL_PROD_SITE_ID', '오창A'), '→', await probe.value(p, nr.row, 'CELL_PROD_SITE_ID'));
});
