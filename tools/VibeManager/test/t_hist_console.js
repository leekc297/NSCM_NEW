// 2026-11-24 사용자: Workbench History 의 Task = 그 실행의 Console 내용(폴더 열기, 수정전/수정후는 Revision 에서만) 시험
//   사용: node test/t_hist_console.js <VibeManager 폴더>
'use strict';
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? {} : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const H = require(path.join(dir, 'history'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'histcon-')); const vibeDir = path.join(root, '.vibe'); const logs = path.join(vibeDir, 'logs'); fs.mkdirSync(logs, { recursive: true });
const p = { root, vibeDir, genDir: path.join(root, 'gen'), outDir: path.join(root, 'out'), pageDirOf: () => '' };
// 1) 연결된 로그
const d1 = H.begin(p, 'DMF0082', 'S1.live', 'AS-IS 실측', 'none', { source: 'menu', label: '🎥 AS-IS 실측' });
const lf = path.join(logs, '2026-11-24T18-45-24_wb2_3_live.log'); fs.writeFileSync(lf, '[실측 1] 기본 실측\n\x1b[31m[ERROR] 기본 실측 실패\x1b[0m\n');
H.addLog(d1, lf); H.addLog(d1, lf); H.finish(p, d1, 3);
const it1 = H.list(p).find(x => x.dir === d1);
chk('연결 로그 1개(중복 없음) + 끝난 뒤에는 더 붙지 않음', it1.logs.length === 1 && (H.addLog(d1, path.join(logs, 'x.log')), H.list(p).find(x => x.dir === d1).logs.length === 1));
const c1 = H.consoleLogs(p, it1); chk('Console 로그 = 연결 기록', c1.how === 'linked' && c1.files[0] === lf);
const t1 = H.tailText(lf); chk('색 코드 제거', !/\x1b/.test(t1.text) && /\[ERROR\] 기본 실측 실패/.test(t1.text));
const task = H.innerHtml(p, 'date', d1, 'all', 'task');
chk('Task 화면 = Console 내용 + Console 열기 단추, 폴더 열기 없음', /🖥 Console/.test(task) && /hist-log/.test(task) && /기본 실측 실패/.test(task) && !/폴더 열기/.test(task));
// 2) Revision 화면은 폴더 열기 유지(스냅샷 이력)
const d2 = H.begin(p, 'DMF0082', 'S5.pkg', 'PKG', 'none', {}); const m2 = JSON.parse(fs.readFileSync(path.join(d2, 'meta.json'), 'utf8')); m2.scope = 'pkg'; m2.end = m2.start; m2.exit = 0; m2.afterMode = 'end'; m2.changed = []; fs.writeFileSync(path.join(d2, 'meta.json'), JSON.stringify(m2));
chk('Revision 화면 = 폴더 열기 유지', /폴더 열기/.test(H.innerHtml(p, 'date', d2, 'all', 'rev')));
// 3) 예전 이력(연결 없음) = 시각으로 찾기. 단일 실행 = 시작 뒤 가장 가까운 1개, 체인 = 구간 전부
const mk = (n) => { fs.writeFileSync(path.join(logs, n), n); return n; };
const at = '2026-11-24T10:00:00+09:00';
const old = (task, start, end, exit) => { const dd = path.join(vibeDir, 'history', 'X', task + start.slice(11, 19).replace(/:/g, '')); fs.mkdirSync(dd, { recursive: true }); fs.writeFileSync(path.join(dd, 'meta.json'), JSON.stringify({ id: 'X', task, scope: 'none', start, end, exit })); return dd; };
mk('2026-11-24T10-00-00_ASIS_IIS.log'); mk('2026-11-24T10-00-01_wb1_1_a.log'); mk('2026-11-24T10-00-05_wb1_2_b.log'); mk('2026-11-24T10-00-06_claude_wb1.log');
const s1 = old('S1.a', at, '2026-11-24T10:00:05+09:00', 0); const ch = old('chain_x', at, '2026-11-24T10:00:09+09:00', 0); const cl = old('claude', '2026-11-24T10:00:06+09:00', '2026-11-24T10:00:30+09:00', 0);
const L = H.list(p); const base = f => (f || []).map(x => path.basename(x)).join(',');
chk('예전 단일 실행 = 시작 뒤 가장 가까운 자기 로그 1개(서버 로그, 다음 단계 로그 제외)', base(H.consoleLogs(p, L.find(x => x.dir === s1)).files) === '2026-11-24T10-00-01_wb1_1_a.log', base(H.consoleLogs(p, L.find(x => x.dir === s1)).files));
chk('예전 체인 = 구간 안 단계 로그 전부', H.consoleLogs(p, L.find(x => x.dir === ch)).files.length === 4);
chk('예전 AI 실행 = claude 로그', base(H.consoleLogs(p, L.find(x => x.dir === cl)).files) === '2026-11-24T10-00-06_claude_wb1.log');
// 4) workbench 연결(소스 확인)
const wb = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8');
chk('workbench: spawnStream 이 로그를 실행, 체인 이력에 연결', /for \(const hd of \[opts && opts\.hist, this\._chainHist\]\) if \(hd\) history\.addLog\(hd, logF\)/.test(wb) && /hist: hdir \}, 'task', task\.title\)/.test(wb));
chk('workbench: AI 실행 로그 연결 + Console 열기 처리(.vibe/logs 안만)', /for \(const hd of \[hdir, this\._chainHist\]\) if \(hd\) history\.addLog\(hd, logF\)/.test(wb) && /case 'history:openLog'/.test(wb) && /startsWith\(logs\.toLowerCase\(\) \+ path\.sep\)/.test(wb));
// 5) 2026-11-24 20:2x 사용자: Console 클릭 = Console 에 보였던 내용 그대로(머리 줄, 원문 줄, 종료 줄)
const rp = H.replayLines(p, it1, lf);
chk('다시 보기 = ▶ 이름(cmd) + 원문 줄 + ■ 종료 exit 3(bad)', rp[0].cls === 'cmd' && /▶ 🎥 AS-IS 실측/.test(rp[0].text) && rp.some(x => /\[ERROR\] 기본 실측 실패/.test(x.text) && !/\x1b/.test(x.text)) && /■ 종료 exit 3/.test(rp[rp.length - 1].text) && rp[rp.length - 1].cls === 'bad', JSON.stringify(rp.slice(-1)));
const cf = path.join(logs, '2026-11-24T11-00-00_claude_wb1.log'); fs.writeFileSync(cf, '$ claude -p\n--- prompt ---\n고쳐줘\n--- output ---\n' + JSON.stringify({ type: 'assistant', message: { content: [{ type: 'text', text: '확인함' }, { type: 'tool_use', name: 'Bash', input: { command: 'ls' } }] } }) + '\n' + JSON.stringify({ type: 'result', subtype: 'success', duration_ms: 5000, num_turns: 2 }) + '\n');
const rc = H.replayLines(p, { label: 'AI', exit: 0 }, cf);
chk('AI 실행 다시 보기 = 프롬프트, 답변, 도구 호출, 결과 줄', rc.some(x => /💬 고쳐줘/.test(x.text)) && rc.some(x => /🤖 확인함/.test(x.text)) && rc.some(x => /🔧 Bash/.test(x.text)) && rc.some(x => /■ 완료 · 5초 · 2턴/.test(x.text)));
chk('workbench: Console 단추 = history:replay → Log 탭 다시 보기(rplog)', /type:'history:replay'/.test(wb) && /case 'history:replay'/.test(wb) && /id="rplog"/.test(wb) && /m\.type==='replay'/.test(wb));
// 6) 2026-11-24 사용자: Console 창에 나왔던 결과 그대로 = 표시 메시지 녹화, 재생
(async () => {
  const d3 = H.begin(p, 'DMF0082', 'S1.x', 'x', 'none', { source: 'menu', label: '녹화 시험' }); H.recStart(d3);
  const sent = [{ type: 'out', stream: 'task', text: '▶ 시작\n', cls: 'cmd' }, { type: 'chat', role: 'assistant', text: '답변' }, { type: 'fb', state: 'step', no: 1 }, { type: 'out', stream: 'task', text: '■ 종료 exit 0\n', cls: 'ok' }];
  for (const m of sent) H.recAdd(d3, m);
  H.finish(p, d3, 0); H.recAdd(d3, { type: 'run', state: 'done', text: '끝' }); // 끝 뒤 1.5초 안 마지막 표시도 담음
  await new Promise(r => setTimeout(r, 1800));
  const got = H.recRead(d3);
  chk('녹화 = 보낸 표시 메시지 그대로(순서, 색 구분, 끝 표시 포함)', got.length === 5 && JSON.stringify(got.slice(0, 4)) === JSON.stringify(sent) && got[4].type === 'run', JSON.stringify(got));
  chk('녹화 닫힘 뒤 추가 = false(대상에서 빠짐)', H.recAdd(d3, { type: 'out', text: 'x' }) === false);
  chk('Task 화면 = Console 다시 보기 단추(녹화 있을 때)', /hist-rec/.test(H.innerHtml(p, 'date', d3, 'all', 'task')) && H.hasRec(d3));
  chk('녹화 없는 이력 = 안내 + 로그 다시 보기', /Console 녹화가 없습니다/.test(H.innerHtml(p, 'date', d1, 'all', 'task')));
  const wb2 = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8');
  chk('workbench: post 가 녹화 대상 메시지를 녹화(be/fe 서버 로그 제외), 실행 3곳 녹화 시작', /REC_TYPES\.has\(m\.type\) && !\(m\.type === 'out' && \(m\.stream === 'be' \|\| m\.stream === 'fe'\)\)/.test(wb2) && (wb2.match(/this\.recBegin\(/g) || []).length === 3);
  chk('workbench: 재생 창 = 같은 Workbench 화면, 입력 칸 숨김, history:console', /function openConsoleReplay/.test(wb2) && /#pbox\{display:none!important\}/.test(wb2) && /case 'history:console'/.test(wb2) && /type:'history:console'/.test(wb2));
  chk('AI 실행 로그 파일 이름 = 파일 이름 문자만(VMW 실행기 이름 J…:화면 의 콜론 = NTFS 숨은 스트림, 2026-11-25)', wb2.includes("_claude_wb${String(this.inst).replace(/[^" + String.fromCharCode(92) + "w.-]/g, '_')}.log"));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();

