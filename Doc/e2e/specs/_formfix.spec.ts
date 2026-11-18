// 폼 저장형 화면의 검증용 데이터 준비·정리(2026-11-16 · SSP0020 미검증 0 작업)
//   Doc/verify/<ID>/form_scenarios.json 의 phase=setup 시나리오를 E2E 앞에서(@formsetup), phase=teardown 시나리오를 E2E 뒤에서(@formteardown) 실행한다(run_verify.py 가 호출).
//   setup = 화면 저장으로 검증용 행을 만든다(AS-IS 정상 저장 메시지 판정을 겸한다). teardown = 화면에서 그 행을 해제하고, 행에 걸린 시나리오 전부의 합산 결과를 e2e_results.json 에 적는다.
//   시나리오 파일이 없는 화면은 아무것도 하지 않는다(테스트 skip).
import * as fs from 'node:fs';
import * as path from 'node:path';

import { test } from '../../../tools/E2E/fixtures/test';
import { combine, countRows, coverRows, loadFormScen, loadResults, runFormScen, saveResult, scenariosOfRow, setVars, type FRes } from '../../../tools/E2E/lib/formscen';
import { parseCsv, probe } from '../../../tools/E2E/lib/probe';
import { recordTouched } from '../../../tools/E2E/lib/saveprobe';

const ID = (process.env.VERIFY_ID || '').toUpperCase();
const ROOT = path.resolve(__dirname, '..', '..', '..');
const DIR = path.join(ROOT, 'Doc', 'verify', ID);
const LEDGER = path.join(DIR, 'verify_ledger.csv');
const OUT = process.env.CL_RESULTS || path.join(DIR, 'e2e_results.json');
const FSN = ID ? loadFormScen(ROOT, ID) : null;
type Res = { row_id: string; result: string; evidence: string; tobe_ref: string; run?: string };

async function runPhase(nscm: import('../../../tools/E2E/lib/nscm').Nscm, phase: 'setup' | 'teardown'): Promise<FRes[]> {
  const p = nscm.page; const fsn = FSN!; const rx = new RegExp(fsn.saveRx || '/(SAVE|INS|UPD|DEL)[^/]*/call-proc', 'i'); let saves = 0;
  let delay = 0;  // 로딩 표시 시험용 응답 지연(시나리오 delayMs)
  await p.route(rx, async route => { saves++; if (delay > 0) await new Promise(r => setTimeout(r, delay)); await route.continue(); });
  const r = await nscm.openScreen(ID); await p.waitForTimeout(2_500); await nscm.clearDialogs();
  if (!r.authorized) throw new Error(`${ID} 화면 권한 없음 — ${phase} 시나리오 실행 불가`);
  setVars({ ...(fsn.vars || {}), ME: (nscm as unknown as { curUser: string }).curUser || '' });
  await nscm.search().catch(() => undefined); await p.waitForTimeout(2_000); await nscm.clearDialogs();
  const out: FRes[] = [];
  for (const sc of fsn.scenarios.filter(s => s.phase === phase)) {
    // setup: 이미 행이 있으면(앞 실행이 정리를 못 함) 다시 저장하지 않는다 — 그 사실을 결과에 남긴다
    // 가드 기준 = 그 시나리오가 만드는 행(matchAfter.where). 없으면 화면 공통 fixture_where — 준비 시나리오가 여러 개면(F09·F09b) 앞 시나리오의 행이 뒤 시나리오를 막지 않게 한다(2026-11-16 5회차 F09b 가 F09 행 때문에 건너뛰어짐)
    const fw = sc.matchAfter?.where || (fsn as unknown as { fixture_where?: Record<string, string> }).fixture_where;
    if (phase === 'setup' && fw && (await countRows(p, fw)) > 0) { const n0 = await countRows(p, fw); const fr: FRes = { id: sc.id, msg: sc.msg, meth: sc.meth, result: 'ERROR', why: `[측정 경로 없음] ${sc.id}: 준비 전 그리드에 검증용 행 ${n0}건이 이미 있음 — 앞 실행의 정리(teardown)가 끝나지 않음. 다시 저장하지 않음`, shown: '', saves: 0 }; out.push(fr); continue; }
    delay = sc.delayMs || 0; const fr = await runFormScen(nscm, sc, () => saves, () => probe.rowCount(p)); delay = 0; out.push(fr);
  }
  await p.unroute(rx).catch(() => undefined);
  return out;
}

test.describe(`폼 저장형 준비·정리 ${ID}`, () => {
  test.describe.configure({ retries: 0 });
  test('준비 — 검증용 행 저장 @formsetup', async ({ nscm }) => {
    test.skip(!FSN || !FSN.scenarios.some(s => s.phase === 'setup'), '폼 저장형 시나리오(setup) 없음');
    test.setTimeout(300_000);
    // 2026-11-17 SSP0020 위임 표 잔존 535행(11-10~11-17): 준비 저장이 만든 행을 정리(teardown)가 해제(VALID_YN N)만 하고 남겼다 —
    //   저장 전 시작 시각을 touched_rows 에 남겨 체인 끝 restore_touched 가 이 시각 뒤 시험 계정이 만든 행을 백업 후 삭제하게 한다
    recordTouched({ __since: 'formsetup', run: process.env.E2E_RUN_ID || '', ts: Date.now() }, new Date(Date.now() - 3_000 - new Date().getTimezoneOffset() * 60_000).toISOString().slice(0, 19));
    // 2026-11-17 SSP0020 --only A1(23:52): 부분 재판정에서도 결과 파일을 비워 이번에 안 돈 폼 시나리오(P01·F02·B01·B02 등) 원장 행 10건이 '미실행' 미검증으로 바뀌었다 → 부분 재판정이면 병합
    const rs = await runPhase(nscm, 'setup'); let first = !process.env.VERIFY_ONLY;
    for (const fr of rs) { saveResult(ROOT, ID, fr, first); first = false; console.log(`[formfix setup] ${fr.id} ${fr.result} ${fr.why.slice(0, 220)}`); }
  });
  test('정리 — 검증용 행 해제·합산 기록 @formteardown', async ({ nscm }) => {
    test.skip(!FSN || !FSN.scenarios.some(s => s.phase === 'teardown'), '폼 저장형 시나리오(teardown) 없음');
    test.setTimeout(300_000);
    const rs = await runPhase(nscm, 'teardown');
    for (const fr of rs) { saveResult(ROOT, ID, fr); console.log(`[formfix teardown] ${fr.id} ${fr.result} ${fr.why.slice(0, 220)}`); }
    const left = await probe.rowCount(nscm.page); console.log(`[formfix teardown] 정리 뒤 그리드 ${left}행`);
    // 합산 기록 — 행에 걸린 시나리오가 전부 끝난 행만
    if (!fs.existsSync(LEDGER)) return;
    const done = loadResults(ROOT, ID); const add: Res[] = [];
    for (const x of parseCsv(fs.readFileSync(LEDGER, 'utf8')).filter(q => q.rule_id === 'E4' && (q.source === 'TRACE' || q.source === 'ASIS'))) {
      const scs = scenariosOfRow(x, FSN!.scenarios); if (!scs.length) continue;
      const cb = combine(scs, done); if (cb) add.push({ row_id: x.row_id, result: cb.result, evidence: cb.why.slice(0, 900), tobe_ref: 'E2E @form', run: process.env.E2E_RUN_ID || '' });
    }
    for (const c of coverRows(parseCsv(fs.readFileSync(LEDGER, 'utf8')), FSN!.scenarios, done)) add.push({ row_id: c.row_id, result: c.result, evidence: c.why.slice(0, 900), tobe_ref: 'E2E @form', run: process.env.E2E_RUN_ID || '' });
    const prev: Res[] = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : []; const m = new Map(prev.map(r => [r.row_id, r])); for (const r of add) m.set(r.row_id, r);
    fs.writeFileSync(OUT, JSON.stringify([...m.values()], null, 1), 'utf8'); console.log(`[formfix teardown] 원장 행 ${add.length}건 합산 기록`);
  });
});
