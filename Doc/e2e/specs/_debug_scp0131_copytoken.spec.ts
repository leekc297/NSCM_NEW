// 디버그(2026-11-09): _verify.spec.ts 의 @copy:in/@copy:out 페이지 스크립트를 원문 그대로 꺼내 SCP0131 Plan Group 에서 실행 — 엔진 수정 실측. 저장하지 않는다
import * as fs from 'node:fs';
import * as path from 'node:path';
import { test } from '../../../tools/E2E/fixtures/test';
import { probe } from '../../../tools/E2E/lib/probe';

test('SCP0131 @copy 토큰 실측 @dbgcopytok', async ({ nscm }) => {
  test.setTimeout(400_000);
  const p = nscm.page;
  const src = fs.readFileSync(path.join(__dirname, '_verify.spec.ts'), 'utf8');
  const a = src.indexOf('const r4 = await p.evaluate(`') + 'const r4 = await p.evaluate(`'.length; const b = src.indexOf('`).catch(() => null) as { i: number; v?: string', a);
  const tpl = src.slice(a, b);
  const build = new Function('probe', 'JSON', 'rowSel', 'col', 'val0', 'return `' + tpl + '`;') as (...x: unknown[]) => string;
  await nscm.openScreen('SCP0131');
  await nscm.search(); for (let k = 0; k < 240 && (await probe.rowCount(p)) <= 0; k++) await p.waitForTimeout(500);
  await nscm.clearDialogs();
  await nscm.subButton('Insert').click(); await p.waitForTimeout(1500); await nscm.clearDialogs();
  const nr = (await probe.findRow(p, 'new'))!;
  for (const tok of ['@copy:in', '@copy:out']) {
    const r4 = await p.evaluate(build(probe, JSON, nr.row, 'OPMZ_PLAN_GR_ID', tok)).catch(e => ({ err: String(e).slice(0, 200) }));
    console.log('TOKEN', tok, JSON.stringify(r4));
    const clip = (r4 as { clip?: string }).clip;
    if (clip) { await probe.pasteText(p, nr.row, 'OPMZ_PLAN_GR_ID', clip); await p.waitForTimeout(800); console.log('  paste', JSON.stringify(clip), '→', JSON.stringify(await probe.value(p, nr.row, 'OPMZ_PLAN_GR_ID'))); await p.evaluate(`(() => { const el = [...document.querySelectorAll('.wj-flexgrid')].find(e => e.offsetParent !== null); const c = el && el['$WJ-CTRL']; c.rows[${nr.row}].dataItem.OPMZ_PLAN_GR_ID = ''; c.invalidate(); })()`); }
  }
});
