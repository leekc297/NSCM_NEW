// 큰 그림 점검 첫 실행 지연 시험(2026-11-26 개선안 20261126182422_SELF, R254): 실행 기록이 없으면 60초, 있으면 10분
//   사용: node test/t_vision_first.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const Module = require('module'); const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => () => { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'vfirst-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const v = require(path.join(dir, 'orch-vision'));
v.init({ paths: () => ({ root, vibeDir }), vmDir: dir, memDir: path.join(root, 'mem'), planFile: path.join(root, 'none.md'), mods: {}, noTimer: true, settings: () => ({}) });
chk('실행 기록 없음 = 60초 뒤 첫 점검', v.firstDelayMs() === 60000, v.firstDelayMs());
fs.mkdirSync(path.join(vibeDir, 'orch', 'vision'), { recursive: true }); fs.writeFileSync(path.join(vibeDir, 'orch', 'vision', 'meta.json'), JSON.stringify({ lastMs: Date.now() - 3600000 }));
chk('실행 기록 있음 = 10분 뒤(종전)', v.firstDelayMs() === 600000, v.firstDelayMs());
fs.writeFileSync(path.join(vibeDir, 'orch', 'vision', 'meta.json'), '{깨진');
chk('meta.json 이 깨지면 기록 없음으로 봄(60초)', v.firstDelayMs() === 60000, v.firstDelayMs());
try { v.dispose(); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
