// Workbench 열기 공용 함수(workbench.openForScreen, 2026-11-20 사용자 지시): VMO·VMW 에서 화면을 눌렀을 때 같은 화면 창이 열려 있으면 새 창 없이 그 창을 앞으로 + Console 탭
//   · 창 번호와 화면 ID 가 모두 같은 창 먼저 · 없으면 같은 화면 ID 창 · 화면 ID 형식이 아니면 아무것도 안 함
//   새 창을 여는 경로는 VS Code 웹뷰가 필요해 이 시험에서 다루지 않음(창 없을 때 open 호출 여부만 확인)
//   사용: node test/t_wb_openscreen.js <VibeManager 폴더>
const Module = require('module'); const path = require('path');
let created = 0;
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: (t2, k2) => k2 === 'createWebviewPanel' ? () => { created++; throw new Error('시험: 새 창 만들기 호출됨'); } : () => Promise.resolve(undefined) });
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'ViewColumn') return { Active: 1, Beside: 2 };
  if (k === 'Uri') return { file: f => ({ fsPath: f }) };
  return new Proxy(function () { }, { get: () => function () { } });
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const W = require(path.join(dir, 'workbench'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const fake = (inst, id) => { const w = { inst, titleId: id, posts: [], revealed: 0, panel: { reveal: () => { w.revealed++; } } }; w.post = m => w.posts.push(m); return w; };
const panels = W._mirror.panels();
const A = fake(1, 'SCP0028'), B = fake(2, 'SCP0028'), C = fake(3, 'SSP0005');
panels.add(A); panels.add(B); panels.add(C);
const api = { paths: () => ({ root: 'C:/x', vibeDir: 'C:/x/.vibe', extDir: dir, language: 'ko' }), ctx: { workspaceState: { get: () => '', update: () => { } }, extensionPath: dir } };
let r = W.openForScreen(api, 'scp0028', 2);
chk('창 번호·화면 ID 같은 창(VM#2) 재사용', r && r.reused && r.wb === B && B.revealed === 1 && A.revealed === 0);
chk('재사용한 창에 Console 탭 보이기', B.posts.some(m => m.type === 'showTab' && m.tab === 'chat' && !m.auto));
r = W.openForScreen(api, 'SSP0005');
chk('창 번호 없이 화면 ID 로 재사용', r && r.reused && r.wb === C && C.revealed === 1);
r = W.openForScreen(api, 'SCP0028', 9);
chk('창 번호가 없는 번호면 같은 화면 ID 창 재사용', r && r.reused && (r.wb === A || r.wb === B));
chk('새 창 만들기 호출 없음(재사용 3회)', created === 0);
chk('화면 ID 형식 아님 = 아무것도 안 함', W.openForScreen(api, '업무') === null && created === 0);
let threw = false; try { W.openForScreen(api, 'DMF0042'); } catch { threw = true; }
chk('열린 창이 없으면 새 창 만들기로 감', created === 1 || threw, `created=${created}`);
panels.delete(A); panels.delete(B); panels.delete(C);
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
