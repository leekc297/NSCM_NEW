// 디버그(2026-10-25): DMF0005 그리드 컬럼 binding·dataMap·editor 유무. 저장하지 않는다
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';
test('DMF0005 cols @dbgcols', async ({ nscm }) => {
  test.setTimeout(300_000);
  const p = nscm.page;
  await nscm.openScreen('DMF0005');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  const info = await p.evaluate(`(() => [...document.querySelectorAll('.wj-flexgrid')].map((el, gi) => { const c = wijmo.Control.getControl(el); return { gi, visible: el.offsetParent !== null, rows: c.rows.length,
    cols: c.columns.filter(col => /COMPANY|PLANT|CELL_PROD|CUST_GROUP/.test(col.binding || '')).map(col => ({ b: col.binding, h: col.header, map: !!col.dataMap, mapN: col.dataMap && col.dataMap.collectionView ? col.dataMap.collectionView.items.length : null, editor: !!col.editor, ro: col.isReadOnly })) }; }))()`);
  console.log('grids', JSON.stringify(info));
});
