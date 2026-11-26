// 반영 도중 창 다시 로드로 끊긴 개선안(2026-11-20 반영 실패 원인 보완 · 끊긴 반영 7건)
//   recoverInterrupted: 그 반영의 AI 실행 기록을 찾아 AI 편집만 되돌리고(다른 작업 편집 유지) 다시 대기 · 실패로 세지 않음(autoTries 하나 줄임)
//   기록을 못 찾으면 사본 복원 + 덮기 전 파일 보관
//   사용: node test/t_orch_apply_recover.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'apprec-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8');
W('tools/Harness/harness.json', JSON.stringify({ orch: { agentEnabled: false } }));
const p = { root, vibeDir, claude: 'none', claudeModel: '' };
const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent')); const im = require(path.join(dir, 'orch-improve'));
watch.init(p, { noReloadSweep: true }); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [], restoreDelayMs: 600000 });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const mkProp = (id, rel, before) => {
  W(rel, before); const sd = path.join(vibeDir, 'orch', 'snap', `prop_${id}`); fs.mkdirSync(path.join(sd, 'files', path.dirname(rel)), { recursive: true });
  fs.writeFileSync(path.join(sd, 'files', rel), before); fs.writeFileSync(path.join(sd, 'before.json'), JSON.stringify({ at: '', kept: [rel], absent: [] }));
  const pr = { id, at: '', ms: Date.now(), source: 'self', self: true, gated: true, status: 'applying', title: '시험 개선안', targets: [rel], history: [{ at: '', by: 'VMO', what: '승인' }, { at: '', by: 'VMO', what: '반영 시작' }], autoTries: 1, applyStartMs: Date.now() - 1000 };
  fs.mkdirSync(path.join(vibeDir, 'orch', 'proposals'), { recursive: true }); fs.writeFileSync(path.join(vibeDir, 'orch', 'proposals', `${id}.json`), JSON.stringify(pr)); return pr;
};
(async () => {
  // ① 기록 있음: AI 가 a.js 를 고치던 중 끊김 · 같은 시간 다른 작업도 같은 파일을 고침
  const rel = 'tools/VibeManager/a.js'; mkProp('P1', rel, "const x = 1;\nconst label = 'Claude';\n");
  fs.writeFileSync(path.join(root, rel), "const x = 2; // AI\nconst label = 'AI Agent';\n");
  const logRel = '.vibe/logs/2026-11-20T16-00-00_claude_orch.log';
  W(logRel, ['$ claude -p', '--- prompt ---', '[개선안]', '{', '  "id": "P1",', '  "title": "시험"', '}', '--- output ---',
    JSON.stringify({ type: 'assistant', message: { content: [{ type: 'tool_use', id: 't1', name: 'Edit', input: { file_path: path.join(root, rel), old_string: 'const x = 1;', new_string: 'const x = 2; // AI' } }] } }),
    JSON.stringify({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: 't1', content: 'ok' }] } })].join('\n') + '\n');
  const r1 = im.recoverInterrupted('P1'); const p1 = im.get('P1');
  chk('AI 편집만 되돌림 · 다른 작업 편집 유지', R(rel) === "const x = 1;\nconst label = 'AI Agent';\n", JSON.stringify(R(rel)));
  chk('다시 대기(pending) · 실패로 세지 않음(autoTries 1 → 0)', p1.status === 'pending' && p1.autoTried === false && p1.autoTries === 0, JSON.stringify({ s: p1.status, t: p1.autoTries }));
  chk('이력 문구 = AI 편집만 되돌림 · 실패로 세지 않음', /AI 편집만 되돌림/.test(r1.note) && /실패로 세지 않음/.test(r1.note), r1.note);
  // ② 기록 없음: 사본 복원 + 덮기 전 파일 보관
  const rel2 = 'tools/VibeManager/b.js'; mkProp('P2', rel2, 'let y = 1;\n'); fs.writeFileSync(path.join(root, rel2), 'let y = 9;\n');
  const r2 = im.recoverInterrupted('P2');
  const keep = fs.readdirSync(path.join(root, 'tools', 'VibeManager')).filter(n => /^b\.js\.bak_prerestore_/.test(n));
  chk('기록 없음 = 사본 복원', R(rel2) === 'let y = 1;\n' && /사본 복원/.test(r2.note), r2.note);
  chk('덮기 전 파일 보관', keep.length === 1 && fs.readFileSync(path.join(root, 'tools', 'VibeManager', keep[0]), 'utf8') === 'let y = 9;\n', keep.join(','));
  // ③ 자가진단 recoverStale 경로: 반영 시작 뒤 끊긴 안 = recoverInterrupted 로(종전 apply-failed)
  const rel3 = 'tools/VibeManager/c.js'; mkProp('P3', rel3, 'c = 1;\n'); fs.writeFileSync(path.join(root, rel3), 'c = 2;\n');
  const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, vmDir: dir, timer: false, incidents: false, autoSync: false, inventory: false, docStyle: false });
  sc.recoverStale(); const p3 = im.get('P3');
  chk('자가진단 recoverStale = 다시 대기(apply-failed 아님)', p3.status === 'pending' && R(rel3) === 'c = 1;\n', p3.status);
  try { sc.dispose(); } catch { } try { agent.dispose(); } catch { } try { watch.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
