// 디버그(2026-11-18): SCP0111 Insert 뒤 행 수 — 화면에 그려진 행(.wj-row) ↔ 그리드 행(control rows) 비교(crud 'Insert 후 행 증가 없음' 원인 확인). 저장하지 않는다
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('SCP0111 Insert 행 수 @dbginsert', async ({ nscm }) => {
  test.setTimeout(300_000);
  const p = nscm.page;
  await nscm.openScreen('SCP0111'); await nscm.search(); await probe.waitRows(p, 120_000); await nscm.clearDialogs();
  const dom = () => p.locator('.wj-flexgrid').first().locator('.wj-cells .wj-row').count();
  const d0 = await dom(), c0 = await probe.rowCount(p);
  await nscm.clickInsert(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const d1 = await dom(), c1 = await probe.rowCount(p); const nw = await probe.findRow(p, 'new');
  console.log(`DOM 행 ${d0} → ${d1} · 그리드 행 ${c0} → ${c1} · 신규 행 ${JSON.stringify(nw)}`);
});
