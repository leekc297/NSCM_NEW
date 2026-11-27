// orch-undo.js(2026-11-20): VMO 되돌림 = AI 가 한 편집만 거꾸로 적용 · 안 되면 사본 복원 + 덮기 전 파일 보관
//   사고 재현: AI 실행 도중 다른 세션이 같은 파일을 고친 뒤 반영 실패로 되돌림 → 다른 세션 편집이 남아야 함
//   사용: node test/t_orch_undo.js <VibeManager 폴더>
const fs = require('fs'); const path = require('path'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const U = require(path.join(dir, 'orch-undo'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'undo_')); const snap = path.join(root, '_snap'); fs.mkdirSync(snap);
let seq = 0;
const logOf = (items) => { // items: { tool, input, err }
  const L = ['$ claude -p ...', '--- output ---'];
  for (const it of items) { const id = `tu${++seq}`;
    L.push(JSON.stringify({ type: 'assistant', message: { content: [{ type: 'tool_use', id, name: it.tool, input: it.input }] } }));
    L.push(JSON.stringify({ type: 'user', message: { content: [{ type: 'tool_result', tool_use_id: id, is_error: !!it.err, content: it.err ? 'error' : 'ok' }] } })); }
  const rel = `log_${seq}.log`; fs.writeFileSync(path.join(root, rel), L.join('\n') + '\n'); return rel;
};
const setup = (name, before) => { fs.writeFileSync(path.join(root, name), before); fs.writeFileSync(path.join(snap, name), before); return path.join(root, name).replace(/\//g, '\\'); };
const read = n => fs.readFileSync(path.join(root, n), 'utf8');
const edit = (fp, o, n, all) => ({ tool: 'Edit', input: { file_path: fp, old_string: o, new_string: n, replace_all: !!all } });
const run = (name, log, wholeOk) => U.restoreFile({ root, rel: name, snapFile: path.join(snap, name), info: U.readOps(root, log), wholeOk });

// 1 사고 재현: AI 편집 + 실행 도중 다른 세션 편집 → AI 편집만 빠짐
let fp = setup('a.js', "const a = 1;\nconst t = 'Claude';\nfunction f() { return a; }\n");
let s = read('a.js').replace('return a;', 'return a + 1; // AI'); fs.writeFileSync(path.join(root, 'a.js'), s);           // AI 편집
fs.writeFileSync(path.join(root, 'a.js'), read('a.js').replace("'Claude'", "'AI Agent'"));                             // 다른 세션 편집
let r = run('a.js', logOf([edit(fp, 'return a;', 'return a + 1; // AI')]), () => true);
chk('사고 재현: AI 편집만 되돌림', r.how === 'undo' && read('a.js') === "const a = 1;\nconst t = 'AI Agent';\nfunction f() { return a; }\n", `${r.how} ${r.why}`);
chk('다른 쪽 편집 유지 문구', /다른 쪽 편집 유지/.test(r.why), r.why);

// 2 AI 편집만 있음 → 반영 전과 같아짐
fp = setup('b.js', 'let x = 1;\nlet y = 2;\n');
fs.writeFileSync(path.join(root, 'b.js'), 'let x = 10;\nlet y = 20;\n');
r = run('b.js', logOf([edit(fp, 'let x = 1;', 'let x = 10;'), edit(fp, 'let y = 2;', 'let y = 20;')]), () => true);
chk('AI 편집 2건 되돌림 = 반영 전과 같음', r.how === 'undo' && r.n === 2 && read('b.js') === 'let x = 1;\nlet y = 2;\n' && /반영 전과 같음/.test(r.why), r.why);

// 3 실패한 도구 호출(is_error)은 되돌리지 않음
fp = setup('c.js', 'var k = 1;\n');
fs.writeFileSync(path.join(root, 'c.js'), 'var k = 2;\n');
r = run('c.js', logOf([edit(fp, 'var k = 1;', 'var k = 2;'), { ...edit(fp, 'var k = 2;', 'var k = 9;'), err: true }]), () => true);
chk('실패한 Edit(is_error)는 되돌리지 않음', r.how === 'undo' && r.n === 1 && read('c.js') === 'var k = 1;\n', `${r.how} ${r.why}`);

// 4 MultiEdit · replace_all · 순서
fp = setup('d.txt', 'A A\nB\n');
fs.writeFileSync(path.join(root, 'd.txt'), 'Q Q\nB2\n');
r = run('d.txt', logOf([{ tool: 'MultiEdit', input: { file_path: fp, edits: [{ old_string: 'A', new_string: 'Q', replace_all: true }, { old_string: 'B', new_string: 'B2' }] } }]), () => true);
chk('MultiEdit + replace_all 되돌림', r.how === 'undo' && read('d.txt') === 'A A\nB\n', `${r.how} ${r.why} ${JSON.stringify(read('d.txt'))}`);

// 5 연속 편집(앞 편집 결과를 뒤 편집이 다시 고침) → 뒤에서부터 되돌림
fp = setup('e.js', 'v = 1;\n');
fs.writeFileSync(path.join(root, 'e.js'), 'v = 3;\n');
r = run('e.js', logOf([edit(fp, 'v = 1;', 'v = 2;'), edit(fp, 'v = 2;', 'v = 3;')]), () => true);
chk('연속 편집 역순 되돌림', r.how === 'undo' && read('e.js') === 'v = 1;\n', r.why);

// 6 Write 로 통째로 씀 → 사본 복원 + 덮기 전 파일 보관
fp = setup('f.js', 'old();\n');
fs.writeFileSync(path.join(root, 'f.js'), 'new();\n');
r = run('f.js', logOf([{ tool: 'Write', input: { file_path: fp, content: 'new();\n' } }]), () => true);
chk('Write = 사본 복원', r.how === 'whole' && read('f.js') === 'old();\n' && /Write/.test(r.why), r.why);
chk('덮기 전 파일 보관(.bak_prerestore_)', r.keep && /\.bak_prerestore_\d{8}_\d{6}$/.test(r.keep) && fs.readFileSync(path.join(root, r.keep), 'utf8') === 'new();\n', r.keep);

// 7 셸로 파일을 씀 → 거꾸로 적용 안 함 · wholeOk false 면 건너뜀(파일 그대로)
fp = setup('g.js', 'p = 1;\n');
fs.writeFileSync(path.join(root, 'g.js'), 'p = 5;\n');
r = run('g.js', logOf([edit(fp, 'p = 1;', 'p = 4;'), { tool: 'Bash', input: { command: "sed -i 's/p = 4/p = 5/' tools/g.js" } }]), () => false);
chk('셸 쓰기 흔적 + 다른 쪽이 고침 = 건너뜀', r.how === 'skip' && read('g.js') === 'p = 5;\n' && /셸 명령/.test(r.why), r.why);
r = run('g.js', logOf([{ tool: 'Bash', input: { command: 'node tools/VibeManager/test/t_g.js 2>&1 | tail -3' } }, edit(fp, 'p = 1;', 'p = 5;')]), () => true);
chk('읽기·시험 셸 명령은 쓰기로 보지 않음', r.how === 'undo' && read('g.js') === 'p = 1;\n', r.why);

// 8 새 문자열이 두 곳 → 위치 불명 → 사본 복원
fp = setup('h.js', 'k(1);\nm(2);\n');
fs.writeFileSync(path.join(root, 'h.js'), 'k(3);\nk(3);\n');
r = run('h.js', logOf([edit(fp, 'k(1);', 'k(3);')]), () => true);
chk('위치 불명 = 사본 복원', r.how === 'whole' && /2곳/.test(r.why), r.why);

// 9 다른 쪽이 AI 편집 자리를 다시 고침 → 거꾸로 적용 불가 · wholeOk false = 건너뜀
fp = setup('i.js', 'z = 1;\n');
fs.writeFileSync(path.join(root, 'i.js'), 'z = 7;\n');
r = run('i.js', logOf([edit(fp, 'z = 1;', 'z = 2;')]), () => false);
chk('AI 편집 자리를 다른 쪽이 고침 = 건너뜀', r.how === 'skip' && read('i.js') === 'z = 7;\n', r.why);

// 10 되돌린 결과 구문 오류 → 사본 복원
fp = setup('j.js', 'f(1);\n');
fs.writeFileSync(path.join(root, 'j.js'), 'f(2);\n');
r = run('j.js', logOf([edit(fp, 'f(1', 'f(2);\n')]), () => true);
chk('되돌린 결과 구문 오류 = 사본 복원', r.how === 'whole', `${r.how} ${r.why}`);

// 11 CRLF 파일
fp = setup('k.js', 'a();\r\nb();\r\n');
fs.writeFileSync(path.join(root, 'k.js'), 'a();\r\nc();\r\nd();\r\n');
r = run('k.js', logOf([edit(fp, 'b();', 'c();\nd();')]), () => true);
chk('CRLF 파일 되돌림', r.how === 'undo' && read('k.js') === 'a();\r\nb();\r\n', r.why);

// 12 실행 기록 없음 → wholeOk 정책대로
fp = setup('l.js', 'q();\n'); fs.writeFileSync(path.join(root, 'l.js'), 'w();\n');
r = U.restoreFile({ root, rel: 'l.js', snapFile: path.join(snap, 'l.js'), info: U.readOps(root, ''), wholeOk: () => false });
chk('실행 기록 없음 + 다른 쪽 수정 = 건너뜀', r.how === 'skip' && read('l.js') === 'w();\n', r.why);
r = U.restoreFile({ root, rel: 'l.js', snapFile: path.join(snap, 'l.js'), info: U.readOps(root, ''), wholeOk: () => true });
chk('실행 기록 없음 + 다른 쪽 수정 없음 = 사본 복원(보관 포함)', r.how === 'whole' && read('l.js') === 'q();\n' && !!r.keep, r.why);

// 13 반영 전과 같음 = 아무것도 안 함
setup('m.js', 'same();\n');
r = run('m.js', logOf([]), () => true);
chk('반영 전과 같음 = same', r.how === 'same');

// 14 JSON 파일 구문 확인
fp = setup('n.json', '{"a":1}\n'); fs.writeFileSync(path.join(root, 'n.json'), '{"a":2}\n');
r = run('n.json', logOf([edit(fp, '"a":1', '"a":2')]), () => true);
chk('JSON 되돌림', r.how === 'undo' && JSON.parse(read('n.json')).a === 1, r.why);

// 15 2026-11-24 개선안 20261123215513_INC: 셸 쓰기 판정 = 그 파일을 쓰는 조각만. 실제 오판 명령 3개(21:42 grep · 21:42 node 리디렉션 · 13:13 awk|grep|head)
const REAL_READ = [
  ['21:42 grep(정규식 안 cp)', "cd /c/Projects/NSCM/tools/VibeManager; grep -n -E \"styleBase|gate\\(|restoreTargets\\(cur\\)|selfPre|module.exports|apply-style|readText|^const cp|require\\('child_process'\\)\" orch-improve.js orch-selfcheck.js test/t_orch_improve.js | head -60; sed -n 368,380p orch-selfcheck.js.bak_prerestore_20261123_181247; grep -n \"module.exports\" orch-selfcheck.js.bak_prerestore_20261123_181247", ['tools/VibeManager/orch-improve.js', 'tools/VibeManager/orch-selfcheck.js', 'tools/VibeManager/test/t_orch_improve.js']],
  ['21:42 node 시험 출력 리디렉션', 'timeout 600 node test/t_orch_improve.js . > ../../.vibe/t_oi_20261123.txt 2>&1; echo done; date', ['tools/VibeManager/test/t_orch_improve.js', 'tools/VibeManager/orch-improve.js']],
  ['13:13 awk|grep|head', "cd /c/Projects/NSCM; awk 'NR>=1291 && NR<=1420' tools/Harness/verify/run_verify.py | grep -n \"triage\\|unverified\" | head; sed -n 140,180p tools/VibeManager/quick.json", ['tools/VibeManager/quick.json', 'tools/Harness/verify/run_verify.py']],
];
for (const [n, c, rels] of REAL_READ) for (const rel of rels) chk(`실제 읽기 명령 = 쓰기 아님: ${n} · ${path.basename(rel)}`, U.shellWritesFile(c, rel) === false);
const WR = 'tools/VibeManager/orch-improve.js';
const WRITE_CASES = ['sed -i s/a/b/ orch-improve.js', 'cp x orch-improve.js', 'echo x > orch-improve.js', 'node -e "fs.writeFileSync(\'tools/VibeManager/orch-improve.js\', s)"',
  "cat > tools/VibeManager/orch-improve.js <<'EOF'\nx\nEOF", "python - <<'EOF'\nopen('tools/VibeManager/orch-improve.js','w').write(s)\nEOF", 'bash -c "sed -i s/a/b/ orch-improve.js"',
  'powershell -Command "Set-Content -Path C:\\x\\orch-improve.js -Value 1"', 'Set-Content C:\\Projects\\NSCM\\tools\\VibeManager\\orch-improve.js $t', "(Get-Content orch-improve.js) -replace 'a','b' | Set-Content orch-improve.js",
  'Out-File -FilePath orch-improve.js', 'Add-Content -Path orch-improve.js -Value x', 'git checkout -- tools/VibeManager/orch-improve.js', 'git restore orch-improve.js', 'git checkout .', 'rm -rf tools/VibeManager', 'Remove-Item tools\\VibeManager\\orch-improve.js',
  'mv orch-improve.js y', 'Move-Item a orch-improve.js', 'Copy-Item a -Destination tools/VibeManager/orch-improve.js', 'echo x >> orch-improve.js', 'node t.js 2>&1 | tee orch-improve.js', 'find . -name orch-improve.js -delete', 'rm *.js', 'perl -pi -e s/a/b/ orch-improve.js'];
for (const c of WRITE_CASES) chk(`쓰기 명령 = 쓰기: ${c.split('\n')[0].slice(0, 60)}`, U.shellWritesFile(c, WR) === true);
const READ_CASES = ["cat x <<EOF\ncp a orch-improve.js\nEOF", 'Get-Content orch-improve.js | Select-String cp', 'git diff orch-improve.js', 'rm ../../.vibe/t.txt; grep -c x orch-improve.js', 'cp orch-improve.js /tmp/b',
  'sed -n 1,5p orch-improve.js > /dev/null', 'ls *.js > list.txt', 'node --check tools/VibeManager/orch-improve.js && echo OK', 'grep -n "writeFile" orch-improve.js', "grep -E 'a > b|rm x' orch-improve.js"];
for (const c of READ_CASES) chk(`읽기 명령 = 쓰기 아님: ${c.split('\n')[0].slice(0, 60)}`, U.shellWritesFile(c, WR) === false);
// 재현: 읽기 셸 명령 + AI 편집 → AI 편집만 되돌림(종전 = 셸 쓰기 흔적으로 건너뜀)
fp = setup('orch-improve.js', 'const g = 1;\n');
fs.writeFileSync(path.join(root, 'orch-improve.js'), 'const g = 2;\n');
r = run('orch-improve.js', logOf([{ tool: 'Bash', input: { command: REAL_READ[0][1] } }, edit(fp, 'const g = 1;', 'const g = 2;')]), () => false);
chk('실제 grep 명령 + AI 편집 = undo', r.how === 'undo' && read('orch-improve.js') === 'const g = 1;\n', `${r.how} ${r.why}`);

try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
