// 2026-11-23 사용자 '18:46 재개 대기 건(답을 받은 뒤 창이 닫힌 AI 대화)이 Workbench 에 안 보이고 지울 수 없음' 시험
//   ① 마지막 입력 뒤 정상 답(result)을 받은 체인 밖 AI 대화 = 창 종료 때 재개 기록을 지움(재개 대기로 남기지 않음)
//   ② 답 뒤에 다시 입력한 AI 대화(답을 아직 못 받음) = 종전처럼 재개 대기로 남김
//   사용: node test/t_wb_resultdone.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'resdone-')); const vibeDir = path.join(root, '.vibe'); const pd = path.join(vibeDir, 'orch', 'chain_progress'); fs.mkdirSync(pd, { recursive: true });
const p = { root, vibeDir };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
require(path.join(dir, 'orch-events')).init(vibeDir);
const wbm = require(path.join(dir, 'workbench'));
const now = Date.now();
const mk = (runId, wb) => { const prog = { runId, screen: 'DMF0082', chainId: 'claude', label: 'AI 대화 · 시험', kind: 'claude', single: true, wb: wb.inst, job: '', t0: now - 20000, steps: 1, res: [], shown: [0], cur: 0, ownerPid: process.pid, updatedMs: now - 20000 };
  fs.writeFileSync(path.join(pd, `${runId}.json`), JSON.stringify(prog)); wbm._liveChains.set(runId, { p, evCh: { wb: wb.inst, screen: 'DMF0082', job: '' }, t0: now - 20000, prog, single: true, wb }); };
const fakeWb = (inst, inputMs, resultMs) => ({ inst, titleId: '', _inputMs: inputMs, _resultOkMs: resultMs, stopAll() { }, getState: () => ({ id: 'DMF0082' }) });
mk('A_done_ai', fakeWb(1, now - 15000, now - 2000));   // 입력 15초 전, 답 2초 전 = 끝난 대화
mk('B_wait_ai', fakeWb(2, now - 1000, now - 8000));    // 답 8초 전, 그 뒤 1초 전 다시 입력 = 답 기다리는 중
mk('C_none_ai', fakeWb(3, now - 5000, 0));             // 답 없음
wbm.abortRunningChains('VM 창 종료로 중단');
const exists = id => fs.existsSync(path.join(pd, `${id}.json`));
const rd = id => { try { return JSON.parse(fs.readFileSync(path.join(pd, `${id}.json`), 'utf8')); } catch { return null; } };
chk('① 답을 받은 뒤 끊긴 AI 대화 = 재개 기록 지움', !exists('A_done_ai'));
chk('② 답 뒤 다시 입력(답 기다림) = 재개 대기로 남김', exists('B_wait_ai') && !!rd('B_wait_ai').interruptedAt, JSON.stringify(rd('B_wait_ai') && rd('B_wait_ai').interruptedAt));
chk('② 답이 없던 AI 대화 = 재개 대기로 남김', exists('C_none_ai') && !!rd('C_none_ai').interruptedAt);
chk('실행 중 목록 비움', wbm._liveChains.size === 0, String(wbm._liveChains.size));
const rs = wbm.resumable(p, { screen: 'DMF0082' }).map(r => r.runId).sort().join(',');
chk('화면 DMF0082 재개 목록 = 남긴 2건', rs === 'B_wait_ai,C_none_ai', rs);

// 개선안 20261126192236_SELF(R256): VMO 단추 공용 응답 orchAck = 접수, 대기 순번과 사유, 실패를 에이전트 탭 줄로
(async () => {
  const ack = wbm._orchAck; const tick = () => new Promise(r => setTimeout(r, 20));
  const mkAg = st => { const notes = []; return { notes, say: (k, o) => notes.push(o.text), status: () => Object.assign({}, st) }; };
  const posts = []; const wb = { post: m => posts.push(m) };
  { const ag = mkAg({ busy: false, current: '', queued: 0 }); await ack(wb, '사건 X 에이전트 조치', () => ({ ok: true }), { queue: true, ag }); await tick();
    chk('한가함: 접수 줄만, 대기 줄 없음', ag.notes.length === 1 && /^접수: 사건 X/.test(ag.notes[0]), JSON.stringify(ag.notes));
    chk('접수 때 agentStatus 보냄', posts.some(m => m.type === 'agentStatus')); }
  { const st = { busy: true, current: 'INC_A', queued: 1 }; const ag = mkAg(st); await ack(wb, '사건 Y 에이전트 조치', () => { st.queued = 2; return { ok: true }; }, { queue: true, ag }); await tick();
    chk('바쁨: 대기열 2번째, 대기 사유 = 현재 조치 INC_A', ag.notes.some(t => /^대기: 사건 Y .*대기열 2번째, 대기 사유 = 현재 조치 INC_A/.test(t)), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: true, current: 'INC_A', queued: 1 }); await ack(wb, '사건 Z 에이전트 조치', () => ({ ok: false, why: '이미 대기열에 있거나 조치 중: Z' }), { queue: true, ag }); await tick();
    chk('enqueue 거절 = 실패 줄에 사유, 대기 줄 없음', ag.notes.some(t => t === '실패: 사건 Z 에이전트 조치 · 이미 대기열에 있거나 조치 중: Z') && !ag.notes.some(t => /^대기/.test(t)), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: false }); let caught = false; await ack(wb, '컨설팅', () => Promise.reject(new Error('boom')), { ag }).catch(() => { caught = true; }); await tick();
    chk('Promise 예외 = 실패 줄 + 부른 쪽에도 그대로 전달', caught && ag.notes.includes('실패: 컨설팅 · boom'), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: false }); let caught = false; await ack(wb, '진단 사다리', () => { throw new Error('sync'); }, { ag }).catch(() => { caught = true; }); await tick();
    chk('동기 예외 = 실패 줄', caught && ag.notes.includes('실패: 진단 사다리 · sync'), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: true, current: 'INC_B' }); await ack(wb, '자가진단 진단', () => Promise.resolve({ busy: true }), { ag }); await tick();
    chk('busy 결과 = 진행 안 함 줄', ag.notes.some(t => /^대기: 자가진단 진단 · 대기 사유 = 현재 조치 INC_B/.test(t)) && ag.notes.some(t => /이번에는 진행하지 않음/.test(t)), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: true, current: 'INC_B' }); await ack(wb, '컨설팅', { skipped: '이미 검토 중' }, { ag, noWait: true }); await tick();
    chk('skipped = 건너뜀 줄, noWait 이면 대기 줄 없음', ag.notes.includes('건너뜀: 컨설팅 · 이미 검토 중') && !ag.notes.some(t => /^대기/.test(t)), JSON.stringify(ag.notes)); }
  { const ag = mkAg({ busy: false }); await ack(wb, '자가진단 진단', () => Promise.resolve({ skipped: true, why: '어긋난 항목 0건' }), { ag }); await tick();
    chk('skipped true = why 를 사유로', ag.notes.includes('건너뜀: 자가진단 진단 · 어긋난 항목 0건'), JSON.stringify(ag.notes)); }
  const src = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8');
  for (const c of ['orch:incAgent', 'orch:ladder', 'orch:vision', 'orch:consult', 'orch:selfRun', 'orch:selfDiag', 'orch:histCollect', 'orch:histSummarize']) {
    const i = src.indexOf(`case '${c}':`); const j = src.indexOf('break;', i); const body = i >= 0 ? src.slice(i, src.indexOf("        case '", i + 10) > 0 ? src.indexOf("        case '", i + 10) : j) : '';
    chk(`${c} 분기가 orchAck 를 씀`, body.includes('orchAck('));
  }
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('ERROR', e && e.stack || e); process.exit(1); });
