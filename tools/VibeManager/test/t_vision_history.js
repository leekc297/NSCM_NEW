// VMO Overall Review 지난 결과 목록 시험(2026-11-26 개선안 20261126182424_SELF, 규칙 R255)
//   ① workbench.js visionHistory: vision/<시각>.json 최신순, 요약, 목적 수, 어긋남 수, 개선안 id · concept_*.md 목록 ② 열기 경로 제한(VISION_FILE_RE)
//   ③ orchestra.js 웹뷰: vsHist, vsHistBind, 'id:' 필터, paintVision 이 목록을 그림
//   사용: node test/t_vision_history.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const Module = require('module'); const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'vhist-')); const vd = path.join(root, '.vibe', 'orch', 'vision'); fs.mkdirSync(vd, { recursive: true });
fs.writeFileSync(path.join(vd, '20261120_115806.json'), JSON.stringify({ at: '2026-11-20T11:58:06+09:00', summary: '옛 결과', purposes: [{ verdict: '맞음' }], proposals: [] }));
fs.writeFileSync(path.join(vd, '20261126_110059.json'), JSON.stringify({ at: '2026-11-26T11:00:59+09:00', summary: '새 결과', purposes: [{ verdict: '어긋남' }, { verdict: '맞음' }, { verdict: '어긋남' }], proposals: ['20261126110100_VISION', '20261126110101_VISION'] }));
fs.writeFileSync(path.join(vd, 'meta.json'), '{}'); fs.writeFileSync(path.join(vd, 'concept_20261126_L4_x.md'), '# x');
const wb = require(path.join(dir, 'workbench.js'));
const h = wb._visionHistory({ root, vibeDir: path.join(root, '.vibe') });
chk('① 지난 결과 최신순 2건, meta.json 제외', h.results.length === 2 && h.results[0].file === '.vibe/orch/vision/20261126_110059.json', JSON.stringify(h.results.map(r => r.file)));
chk('① 요약, 목적 3, 어긋남 2, 개선안 id 2', h.results[0].summary === '새 결과' && h.results[0].purposes === 3 && h.results[0].miss === 2 && h.results[0].proposals.join() === '20261126110100_VISION,20261126110101_VISION');
chk('① 개념 재정립 문서 1건(이름에서 concept_ 뺌)', h.concepts.length === 1 && h.concepts[0].name === '20261126_L4_x' && h.concepts[0].file === '.vibe/orch/vision/concept_20261126_L4_x.md');
const R = wb._VISION_FILE_RE;
chk('② 열기 경로 = 결과, 개념, 플랜 문서만', R.test('.vibe/orch/vision/20261126_110059.json') && R.test('.vibe/orch/vision/concept_a.md') && R.test('.vibe/orch/vision/plan_x.md') && !R.test('.vibe/orch/vision/meta.json') && !R.test('.vibe/orch/vision/../../tools/x.json') && !R.test('C:/x/concept_a.md'));
const html = require(path.join(dir, 'orchestra.js')).html({ root, vibeDir: path.join(root, '.vibe'), extDir: dir, language: 'ko' }, { tab: '' });
chk('③ 웹뷰: vsHist, vsHistBind, paintVision 연결, orch:visionOpen', /function vsHist\(h\)/.test(html) && /function vsHistBind\(\)/.test(html) && /\+vsHist\(m\.history\)/.test(html) && /csBind\(\); vsHistBind\(\);/.test(html) && /type:'orch:visionOpen'/.test(html));
chk("③ 개선안 이동 = prQ 'id:' 필터", /prQ='id:'\+b\.dataset\.vsids/.test(html) && /\/\^id:\/\.test\(ql\)/.test(html));
try { fs.rmSync(root, { recursive: true, force: true }); } catch { /* 임시 */ }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
