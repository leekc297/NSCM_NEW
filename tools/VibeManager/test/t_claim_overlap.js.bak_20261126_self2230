// 맡음 표시 대상 파일 겹침 경고 시험(2026-11-26 개선안 20261126180320_VISION)
//   사용: node test/t_claim_overlap.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'clov-')); const pd = path.join(root, '.vibe', 'orch', 'proposals'); fs.mkdirSync(pd, { recursive: true });
const mk = (id, targets, extra) => fs.writeFileSync(path.join(pd, `${id}.json`), JSON.stringify(Object.assign({ id, status: 'pending', impact: 'fix', title: `t ${id}`, targets, history: [] }, extra || {})));
mk('20261126000001_SELF', ['tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/test/t_a.js'], { claimedBy: 'S-X', autoWaitMs: Date.now() + 3600000 });
mk('20261126000002_SELF', ['tools\\VibeManager\\orch-selfcheck.js', 'tools/VibeManager/orch-improve.js']);
mk('20261126000003_SELF', ['tools/VibeManager/jobs.js']);
mk('20261126000004_SELF', ['tools/VibeManager/jobs.js'], { claimedBy: 'S-OLD', autoWaitMs: Date.now() - 1000 });
const run = (...a) => cp.spawnSync(process.execPath, [path.join(dir, 'claim_proposal.js'), '--root', root, ...a], { encoding: 'utf8' }).stdout.trim();
const rd = id => JSON.parse(fs.readFileSync(path.join(pd, `${id}.json`), 'utf8'));
const o1 = run('claim', 'S-Y', '20261126000002_SELF');
chk('다른 세션이 맡은 안과 파일이 겹치면 WARN 1줄(역슬래시 경로도 같은 파일)', /WARN 20261126000002_SELF 대상 파일 겹침 tools\/VibeManager\/orch-selfcheck\.js \(S-X 20261126000001_SELF\)/.test(o1) && /OK claim 20261126000002_SELF/.test(o1), o1);
chk('경고가 이력에 남음', rd('20261126000002_SELF').history.some(h => /^경고: 대상 파일 겹침/.test(h.what)));
const o2 = run('claim', 'S-Y', '20261126000003_SELF');
chk('맡음 시간이 지난 안과의 겹침은 경고 안 함', !/WARN/.test(o2) && /OK claim/.test(o2), o2);
const o3 = run('claim', 'S-X', '20261126000003_SELF');
chk('이미 다른 세션이 맡은 안은 종전대로 SKIP', /SKIP 20261126000003_SELF 이미 S-Y 가 맡음/.test(o3), o3);
const o4 = run('list', 'S-Y');
chk('list 에 대상 파일 표시', /20261126000002_SELF[^\n]*tools\/VibeManager\/orch-selfcheck\.js, tools\/VibeManager\/orch-improve\.js/.test(o4), o4.replace(/\n/g, ' | '));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
