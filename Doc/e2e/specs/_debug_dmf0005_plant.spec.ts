// 디버그(2026-10-25): DMF0005 신규행 Sales Plant 직접 입력이 지워지는 원인 — 콤보 응답 원문 확인. 저장하지 않는다
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('DMF0005 Sales Plant 입력 @dbgplant', async ({ nscm }) => {
  test.setTimeout(240_000);
  const p = nscm.page;
  const log: string[] = [];
  p.on('response', async r => {
    const req = r.request(); const body = req.postData() || '';
    if (!/PLANT|Company/i.test(body)) return;
    const t = await r.text().catch(() => '(no body)');
    log.push(`${req.method()} ${r.url().replace(/^https?:\/\/[^/]+/, '')} ${r.status()} req=${body.slice(0, 160)} res=${t.slice(0, 300)}`);
  });
  await nscm.openScreen('DMF0005');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  await nscm.subButton('Insert').click(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const nr = (await probe.findRow(p, 'new'))!;
  const show = async (tag: string) => console.log(tag, JSON.stringify(Object.fromEntries(await Promise.all(['SCM_SITE_ID', 'SALES_COMPANY', 'SALES_PLANT'].map(async b => [b, await probe.value(p, nr.row, b)])))));
  await probe.setByEditor(p, nr.row, 'SCM_SITE_ID', 'Peopleworks_KR_KUM'); await p.waitForTimeout(3000); await show('after site');
  for (const [co, pl] of [['NJ00', 'NJ01']]) {
    log.length = 0;
    console.log('company', co, await probe.setByEditor(p, nr.row, 'SALES_COMPANY', co)); await p.waitForTimeout(4000); await show('after company');
    console.log('plant', pl, await probe.setByEditor(p, nr.row, 'SALES_PLANT', pl));
    await show('plant +0.3s'); await p.waitForTimeout(4000); await show('plant +4s');
    console.log('net', JSON.stringify(log, null, 1).slice(0, 3000));
    const al = p.locator('[role="dialog"]:visible, [role="alertdialog"]:visible');
    console.log('dialogs', await al.count(), ((await al.last().innerText().catch(() => '')) || '').slice(0, 200));
    await nscm.clearDialogs();
  }
});
