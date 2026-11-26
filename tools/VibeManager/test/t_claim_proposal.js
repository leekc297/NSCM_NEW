// 개선안 맡음 표시 시험(2026-11-26 R244): claim_proposal.js claim, done, release, hold 와 orch-selfcheck 맡음 조건(claimedNow)
//   사용: node test/t_claim_proposal.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const Module = require('module'); const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => () => { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
// claim_proposal.js 는 __dirname/../../.vibe 를 쓰므로 임시 저장소 구조(tools/VibeManager)에 복사해 돌린다
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'claim-')); const vm = path.join(root, 'tools', 'VibeManager'); fs.mkdirSync(vm, { recursive: true });
fs.copyFileSync(path.join(dir, 'claim_proposal.js'), path.join(vm, 'claim_proposal.js'));
const pd = path.join(root, '.vibe', 'orch', 'proposals'); fs.mkdirSync(pd, { recursive: true });
const mk = (id, st) => fs.writeFileSync(path.join(pd, `${id}.json`), JSON.stringify({ id, status: st, impact: 'fix', title: `t ${id}`, history: [] }));
mk('20261126000001_SELF', 'pending'); mk('20261126000002_SELF', 'apply-failed'); mk('20261126000003_SELF', 'applied'); mk('20261126000004_SELF', 'pending');
const run = (...a) => cp.spawnSync(process.execPath, [path.join(vm, 'claim_proposal.js'), ...a], { encoding: 'utf8' }).stdout.trim();
const rd = id => JSON.parse(fs.readFileSync(path.join(pd, `${id}.json`), 'utf8'));
const out = run('claim', 'S-T', '20261126000001_SELF', '20261126000002_SELF', '20261126000003_SELF');
chk('claim = pending, apply-failed 만 맡음', /OK claim 20261126000001_SELF/.test(out) && /OK claim 20261126000002_SELF/.test(out) && /SKIP 20261126000003_SELF/.test(out), out.replace(/\n/g, ' | '));
const sc = require(path.join(dir, 'orch-selfcheck'));
chk('맡은 apply-failed 안 = claimedNow true(반영 실패 진단·재시도에서 빠짐)', sc._claimedNow(rd('20261126000002_SELF')) === true);
chk('맡지 않은 안 = claimedNow false', sc._claimedNow(rd('20261126000004_SELF')) === false && sc._claimedNow({ claimedBy: 'x', autoWaitMs: Date.now() - 1000 }) === false);
run('done', '20261126000001_SELF', '고침', '시험');
chk('done = applied, 이력 기록', rd('20261126000001_SELF').status === 'applied' && /반영 완료\(세션 직접 보완\)/.test(JSON.stringify(rd('20261126000001_SELF').history)));
run('release', '20261126000002_SELF');
chk('release = 맡음 해제', !rd('20261126000002_SELF').claimedBy && !rd('20261126000002_SELF').autoWaitMs);
run('hold', '20261126000004_SELF', '사람', '판단');
const h = rd('20261126000004_SELF');
chk('hold = impact core, userHold, reason, autoWaitMs 먼 뒤', h.impact === 'core' && h.userHold === true && /사람 판단/.test(h.reason) && h.autoWaitMs > Date.now() + 365 * 86400000);
chk('잘못된 번호 = 오류', /ERROR/.test(run('claim', 'S-T', '../x')));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
