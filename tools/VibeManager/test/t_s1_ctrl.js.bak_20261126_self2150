// VMO 자가진단 S1 제어 문자 검사 시험(2026-11-26): 쓰기 스크립트가 넣은 0x08 등은 JS 구문 오류가 아니므로 따로 잡음
//   사용: node test/t_s1_ctrl.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 's1c-')); const vibeDir = path.join(root, '.vibe'); const vmd = path.join(root, 'tools', 'VibeManager'); const inst = path.join(root, 'installed');
const mk = (f, s) => { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s, 'utf8'); };
mk(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false } }));
const BS = String.fromCharCode(8); const SL = String.fromCharCode(92);
mk(path.join(vmd, 'ok.js'), 'const re = /' + SL + 'bA' + SL + 'b/; module.exports = re;\n'); // 정상 정규식 \bA\b
mk(path.join(vmd, 'ctrl.js'), 'const a = 1;\nconst re = /x(_|' + BS + ')/; module.exports = re;\n'); // 구문은 정상, 2줄에 0x08
mk(path.join(vmd, 'test', 't_x.js'), "// 시험\nconst s = 'a" + String.fromCharCode(1) + "';\n");
for (const f of ['package.json', 'quick.json', 'steps.json']) mk(path.join(vmd, f), f === 'quick.json' ? '{"groups":[]}' : f === 'steps.json' ? '{"steps":[]}' : '{"name":"x"}');
const p = { root, vibeDir, extDir: inst };
const watch = require(path.join(dir, 'orch-watch')); const sc = require(path.join(dir, 'orch-selfcheck'));
watch.init(p, {}); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  const r = await sc.run(['S1'], '시험'); const its = r.checks.S1.items; const keys = its.map(i => i.key);
  chk('구문은 정상인 0x08 파일 = S1 제어 문자 실패', keys.includes('S1|ctrl|ctrl.js') && /2줄 0x08/.test((its.find(i => i.key === 'S1|ctrl|ctrl.js') || {}).detail || ''), JSON.stringify(its));
  chk('test/*.js 의 제어 문자도 잡음(0x01)', keys.includes('S1|ctrl|test/t_x.js') && /0x01/.test((its.find(i => i.key === 'S1|ctrl|test/t_x.js') || {}).detail || ''));
  chk('정상 역슬래시 b 정규식 파일은 걸리지 않음', !keys.some(k => /ok\.js/.test(k)), keys.join());
  chk('제어 문자 항목만 나옴(구문 오류 없음)', keys.every(k => k.startsWith('S1|ctrl|')), keys.join());
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
