// VMO 개입 장부 · 사후 검증 · 오판 자동 처리 · 관찰 모드 · S14(2026-11-20 플랜 vm-ui-snug-mountain J1~J4)
//   사고 재현: 16:06:50 R14 가 재개된 SCP0028 체인(중지 14:56:34 뒤 14:58:16 시작)을 멈춤 → 사후 검증이 오판으로 판정해야 함
//   오판 뒤: 재개 기록 되살림 · VMW 작업 재개 가능 · 원 사건 falsePositive · 사건 R15 · 개선안(self, fix) · R14 관찰 모드(자가 복구 안 함) · 개선안 반영 완료면 해제
//   사용: node test/t_orch_ledger.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ledger-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { checkDelayMin: 0, agentEnabled: false, rerunAfterFix: 'none' } })); // 앞 경우 = 수행 없음 · 뒤 ⑩-2 = 재수행
const p = { root, vibeDir };
const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch')); const L = require(path.join(dir, 'orch-ledger')); const heal = require(path.join(dir, 'orch-heal'));
watch.init(p, { noReloadSweep: true });
const props = {}; const added = []; const restored = []; let evs = [];
const improve = { add: (o, src) => { const id = `P${added.length + 1}`; added.push(Object.assign({ id, src }, o)); props[id] = { id, status: 'pending' }; return { id }; }, get: id => props[id] || null };
const started = []; const jobRunner = { restoreInterrupted: (job, screen, why) => { restored.push({ job, screen, why }); return true; }, stopScreen: () => ({}), start: job => { started.push(job); return true; } };
L.init({ paths: () => p, watch, state: st, improve, jobRunner, events: () => evs, serverSvc: { stateList: () => [{ port: 8080, state: 'up' }, { port: 5173, state: 'down' }] } });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const rowOf = id => L.readAll().find(r => r.id === id);
(async () => {
  const now = Date.now();
  // ① 사고 재현: 중지 14:56:34, 멈춘 체인은 그 뒤 14:58:16 시작(재개)
  const stopMs = now - 70 * 60000; const startMs = stopMs + 102000; const runId = `SCP0028_${startMs}`;
  const inc = watch.raise('R14', { screen: 'SCP0028', sig: `R14|J1:SCP0028|${runId}`, title: '중지 뒤 계속 실행. SCP0028', evidence: { wb: 'J1:SCP0028', job: 'J1', runId, stopMs } });
  const prog = { runId, screen: 'SCP0028', chainId: 'checklist', label: 'CheckList', steps: 6, sig: '6:x', cur: 1, res: [{ no: 1, status: 'OK' }], job: 'J1', wb: 'J1:SCP0028', t0: startMs };
  const id1 = L.note({ kind: 'stop', rule: 'R14', inc: inc.id, screen: 'SCP0028', job: 'J1', runId, target: 'J1:SCP0028', by: 'VMO 자가 복구', premise: { key: 'chainStartedBeforeStop', runId, stopMs }, undo: { how: 'resume', prog } });
  chk('개입 1건 = 장부 1줄', !!id1 && L.readAll().length === 1 && rowOf(id1).check.verdict === '', JSON.stringify(rowOf(id1) && rowOf(id1).check));
  const t1 = L.tick(Date.now() + 1000);
  chk('사후 검증 = 오판(체인이 중지 뒤 시작)', t1.checked === 1 && t1.falses === 1 && rowOf(id1).check.verdict === 'false' && /중지\(.*\) 뒤 .* 시작한 새 실행/.test(rowOf(id1).check.why), rowOf(id1).check.why);
  const pf = path.join(vibeDir, 'orch', 'chain_progress', `${runId}.json`); let pr = null; try { pr = JSON.parse(fs.readFileSync(pf, 'utf8')); } catch { }
  chk('피해 복구: 재개 기록 되살림(2단계부터)', !!pr && pr.resumeFrom === 2 && !!pr.interruptedAt && /오판/.test(pr.why || ''), JSON.stringify(pr && { from: pr.resumeFrom, why: pr.why }));
  chk('피해 복구: VMW 작업 재개 가능으로', restored.length === 1 && restored[0].job === 'J1' && restored[0].screen === 'SCP0028', JSON.stringify(restored));
  const i1 = watch.get(inc.id);
  chk('원 사건 = 감시 오판(resolved · falsePositive) + 판정 줄', i1.status === 'resolved' && i1.falsePositive === true && i1.vmoCheck && i1.vmoCheck.verdict === 'false' && (i1.actions || []).some(a => /판정: 오판/.test(a.what || '')), JSON.stringify({ s: i1.status, a: (i1.actions || []).map(a => a.what.slice(0, 30)) }));
  const r15 = watch.list(50).find(x => x.rule === 'R15');
  chk('사건 R15 VMO 개입 오판', !!r15 && /R14 실행 중지 SCP0028/.test(r15.title) && r15.evidence.entry === id1 && r15.evidence.observe === true, r15 && r15.title);
  chk('개선안 등록(self · fix · 재현 시험 포함)', added.length === 1 && added[0].src === 'self' && added[0].impact === 'fix' && /R14 오판 정정/.test(added[0].title) && added[0].targets.some(t => /orch-watch\.js$/.test(t)) && added[0].targets.some(t => /test\/t_fp_r14_\d{8}\.js$/.test(t)) && /재현 시험/.test(added[0].verify), JSON.stringify(added[0] && { t: added[0].title, tg: added[0].targets }));
  chk('R14 관찰 모드', L.observing('R14') === true && !L.observing('R13'));
  chk('재수행 설정 = 수행 없음: 재개 가능으로만 되돌리고 시작 안 함', started.length === 0 && /재개는 사용자/.test((r15 && r15.detail) || ''), (r15 && r15.detail || '').slice(0, 200));
  // ② 관찰 모드에서 자가 복구가 개입하지 않음
  heal.init({ paths: () => p, watch }); let killed = 0;
  const inc2 = watch.raise('R14', { screen: 'SSP0005', sig: 'R14|J2:SSP0005|x', title: '중지 뒤 계속 실행. SSP0005', evidence: { wb: 'J2:SSP0005', job: 'J2', runId: 'SSP0005_1', stopMs: now } });
  await new Promise(r => setTimeout(r, 200));
  const i2 = watch.get(inc2.id);
  chk('관찰 모드: 사건은 올리되 자가 복구 안 함', i2.status === 'open' && (i2.actions || []).some(a => /관찰 모드: 자가 복구하지 않음/.test(a.what || '')) && killed === 0 && L.readAll().length === 1, JSON.stringify((i2.actions || []).map(a => a.what)));
  // ③ 개선안 반영 완료 = 관찰 모드 해제
  props.P1.status = 'applied'; const t3 = L.tick(Date.now() + 2000);
  chk('개선안 반영 완료 = 관찰 모드 자동 해제', t3.released.join(',') === 'R14' && L.observing('R14') === false, JSON.stringify(t3));
  // ④ 정상 개입 = 맞음 · 관찰 모드 아님
  const st4 = now - 5000; const id4 = L.note({ kind: 'stop', rule: 'R14', screen: 'SCP0111', runId: `SCP0111_${st4 - 600000}`, premise: { key: 'chainStartedBeforeStop', runId: `SCP0111_${st4 - 600000}`, stopMs: st4 } });
  L.tick(Date.now() + 1000);
  chk('정상 중지 = 맞음 · 관찰 모드 아님 · 개선안 추가 없음', rowOf(id4).check.verdict === 'ok' && !L.observing('R14') && added.length === 1, JSON.stringify(rowOf(id4).check));
  // ⑤ 잠금 삭제: 주인 PID 살아 있음 = 오판 · 없음 = 맞음
  const id5a = L.note({ kind: 'lockdel', rule: 'lock', target: 'Doc/e2e/a.lock', premise: { key: 'lockOwnerDead', lockPid: process.pid } });
  const id5b = L.note({ kind: 'lockdel', rule: 'R9', target: 'Doc/e2e/b.lock', premise: { key: 'lockOwnerDead', lockPid: 999991 } });
  L.tick(Date.now() + 1000);
  chk('잠금 삭제: 주인 살아 있음 = 오판 · 주인 없음 = 맞음', rowOf(id5a).check.verdict === 'false' && rowOf(id5b).check.verdict === 'ok' && L.observing('lock') && !L.observing('R9'), JSON.stringify([rowOf(id5a).check.verdict, rowOf(id5b).check.verdict]));
  // ⑥ 사건 자동 해결 뒤 같은 사건 재발 = 오판 → 사건 다시 열림
  const inc6 = watch.raise('R1', { screen: 'DMF0042', sig: 'R1|x|6', title: '실행 실패' }); watch.update(inc6.id, { status: 'resolved', notice: true, reload: 'cut' }, { by: 'VMO', what: '창 다시 로드' });
  const id6 = L.note({ kind: 'resolve', rule: 'reload', inc: inc6.id, screen: 'DMF0042', premise: { key: 'causedByReload', sig: 'R1|x|6', why: '창 다시 로드' }, undo: { how: 'reopen', status: 'open' } });
  await new Promise(r => setTimeout(r, 30)); watch.raise('R1', { screen: 'DMF0042', sig: 'R1|x|6', title: '실행 실패(재발)' });
  L.tick(Date.now() + 1000);
  chk('자동 해결 뒤 재발 = 오판 · 닫은 사건 다시 열림 · reload 관찰 모드', rowOf(id6).check.verdict === 'false' && watch.get(inc6.id).status === 'open' && L.observing('reload'), JSON.stringify([rowOf(id6).check, watch.get(inc6.id).status]));
  chk('관찰 모드: 창 다시 로드 사건 자동 해결 안 함', watch.reloadSweep().length === 0);
  // ⑦ 다시 실행: 결과가 나올 때까지 대기 → 단계 OK = 맞음
  const id7 = L.note({ kind: 'requeue', rule: 'R13', screen: 'SCP0005', job: 'J7', premise: { key: 'screenOpensAfterFix' } });
  L.tick(Date.now() + 1000); const v7a = rowOf(id7).check.verdict;
  evs = [{ type: 'step.end', screen: 'SCP0005', status: 'OK', ms: Date.now() + 500 }]; L.tick(Date.now() + 2000);
  chk('다시 실행: 근거 없으면 대기 → 단계 OK 뒤 맞음', v7a === '' && rowOf(id7).check.verdict === 'ok', `${v7a}|${rowOf(id7).check.verdict}`);
  // ⑧ 서버 재기동 · 검증 대상 아닌 종류
  const id8a = L.note({ kind: 'server', rule: 'R6', premise: { port: 8080 } }); const id8b = L.note({ kind: 'server', rule: 'R6', premise: { port: 5173 } }); const id8c = L.note({ kind: 'pause', rule: 'R8', target: '2건' });
  L.tick(Date.now() + 1000);
  chk('서버 재기동: 응답 = 맞음 · 미응답 = 효과 없음 · 일시 중지 = 검증 대상 아님', rowOf(id8a).check.verdict === 'ok' && rowOf(id8b).check.verdict === 'noeffect' && rowOf(id8c).check.verdict === 'n/a', JSON.stringify([rowOf(id8a).check.verdict, rowOf(id8b).check.verdict, rowOf(id8c).check.verdict]));
  // ⑨ 사용자 반응 신호
  const id9 = L.note({ kind: 'stop', rule: 'agent', screen: 'SSP0014', runId: 'SSP0014_1', premise: { key: 'agentRequest' } });
  evs = [{ type: 'chain.start', screen: 'SSP0014', runId: 'SSP0014_2', ms: Date.now() + 5 * 60000 }]; L.tick(Date.now() + 1000);
  chk('사용자 재실행 신호 기록 · 전제 원천 없음 = 미확인', !!rowOf(id9).react && /같은 화면 다시 실행/.test(rowOf(id9).react.what) && rowOf(id9).check.verdict === 'unknown', JSON.stringify(rowOf(id9)));
  // ⑩ 집계 · S14 · U20
  const s = L.stats(7);
  chk('집계: R14 개입 2 · 오판 1 · 맞음 1', s.byRule.R14.n === 2 && s.byRule.R14.false === 1 && s.byRule.R14.ok === 1 && s.falses.length === 3, JSON.stringify(s.byRule));
  const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, vmDir: dir, timer: false, incidents: false, autoSync: false, inventory: false, docStyle: false });
  const res = await sc.run(['S14'], '시험'); const k = res.checks.S14;
  chk('S14: 오판 = 어긋남(fail) · 관찰 모드 = 주의 · 집계', k.status === 'fail' && k.items.some(i => i.key === 'S14|R14|false' && i.level !== 'warn') && k.items.some(i => i.key === 'S14|lock|observe' && i.level === 'warn') && k.info.false === 3 && k.info.total === s.total, JSON.stringify({ st: k.status, info: k.info, keys: k.items.map(i => i.key) }));
  const uc = require(path.join(dir, 'orch-usercheck')); const u20 = uc.DETECTORS.vmoFalseStop({ id: 'U20' }, { now: Date.now() });
  chk('U20: 잘못 멈춘 개입(R14)과 사용자 재실행 신호를 올림', u20.some(x => /정상 실행을 잘못 멈춤 R14 SCP0028/.test(x.what)) && u20.some(x => /사용자가 곧 다시 실행/.test(x.what)), JSON.stringify(u20.map(x => x.what)));
  // ⑩-2 재수행 설정 = 재수행 → 오판 복구 뒤 작업 재개 시작
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { checkDelayMin: 0, agentEnabled: false, rerunAfterFix: 'rerun' } }));
  const sm = Date.now() - 60000; const rid = `SCP0096_${sm + 30000}`;
  const idR = L.note({ kind: 'stop', rule: 'R14', screen: 'SCP0096', job: 'J96', runId: rid, premise: { key: 'chainStartedBeforeStop', runId: rid, stopMs: sm }, undo: { how: 'resume', prog: { runId: rid, screen: 'SCP0096', cur: 2, steps: 6, job: 'J96' } } });
  L.tick(Date.now() + 1000);
  chk('재수행 설정 = 재수행: 오판 복구 뒤 작업 재개 시작', rowOf(idR).check.verdict === 'false' && started.join(',') === 'J96', JSON.stringify(started));
  // ⑩-3 개선안 20261125000907_VISION 재개 원장: 16:06 R14 사고 재현을 감시기 입력(사건 줄)으로. 옛 VM 프로세스의 runId 없는 중지 기록을 재개 체인 시작 뒤에 읽음
  //   재개 체인(chain.resume resumedFrom = 끊긴 runId)은 계보로 가려 R14 를 올리지 않음 · 계보 없는 같은 형태의 체인은 그대로 R14(감지 유지)
  { const n2 = Date.now(); const X = `SCP0028_${n2 - 300000}`; const Y = `SCP0028_${n2 - 6000}`; const Z = `SCP0005_${n2 - 6000}`;
    const feed = e => { st.apply(e); watch.onEvent(e); };
    feed({ type: 'chain.start', runId: Y, screen: 'SCP0028', wb: 'J9:SCP0028', job: 'J9', chainLabel: 'CheckList', steps: 6, ms: n2 - 6000 });
    feed({ type: 'chain.resume', runId: Y, screen: 'SCP0028', wb: 'J9:SCP0028', job: 'J9', steps: 6, resumeFrom: 2, resumedFrom: X, carried: [{ no: 1, status: 'OK' }], ms: n2 - 5900 });
    feed({ type: 'user.stop', wb: 'J9:SCP0028', screen: 'SCP0028', job: 'J9', by: 'VS Code 종료', why: 'vscode.dispose', ms: n2 - 2000 });
    feed({ type: 'step.start', runId: Y, wb: 'J9:SCP0028', screen: 'SCP0028', job: 'J9', no: 2, name: '2. 판정', ms: n2 - 1000 });
    feed({ type: 'chain.start', runId: Z, screen: 'SCP0005', wb: 'J10:SCP0005', job: 'J10', chainLabel: 'CheckList', steps: 6, ms: n2 - 6000 });
    feed({ type: 'user.stop', wb: 'J10:SCP0005', screen: 'SCP0005', job: 'J10', by: '작업 목록 중지', why: 'job.stop', ms: n2 - 2000 });
    feed({ type: 'step.start', runId: Z, wb: 'J10:SCP0005', screen: 'SCP0005', job: 'J10', no: 2, name: '2. 판정', ms: n2 - 1000 });
    const r14 = id => watch.list(500).filter(i => i.rule === 'R14' && i.evidence && i.evidence.runId === id);
    chk('16:06 재현: 재개 체인(계보 resumedFrom) = R14 없음 · 재개 체인을 멈추지 않음', r14(Y).length === 0, JSON.stringify(r14(Y).map(i => i.title)));
    chk('계보 없는 중지 뒤 체인 = R14 유지(감지 약화 없음)', r14(Z).length === 1, JSON.stringify(r14(Z).map(i => i.title)));
    feed({ type: 'chain.end', runId: Y, wb: 'J9:SCP0028', ok: true, ms: Date.now() }); feed({ type: 'chain.end', runId: Z, wb: 'J10:SCP0005', ok: true, ms: Date.now(), stopped: true }); }
  // ⑪ 사용자 해제
  chk('사용자 해제', L.release('lock', '사용자') === true && !L.observing('lock') && L.release('lock', '사용자') === false);
  try { sc.dispose(); } catch { } try { heal.dispose(); } catch { } try { watch.dispose(); } catch { } try { st.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
