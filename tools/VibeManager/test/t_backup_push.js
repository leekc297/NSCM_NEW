// Source Backup 시험(2026-11-26 개선안 20261126165225_INC, 20261126164857_INC 후 2): workbench.js
//   ① 2/3 commit 명령에 -c maintenance.auto=false -c gc.auto=0 이 있고 실제 commit 단계가 그 명령을 씀, push 성공 뒤 정리 안내 1줄
//   ② push 전 검사(prePushCheck): 임시 git 저장소의 미push 커밋 표본으로 .gitignore 제외 경로, 상한 넘는 파일 = 멈춤, 경고 구간 = 경고만, 원격 기준 없음 = 건너뜀
//   임시 저장소만 씀(프로젝트 저장소 git 명령 없음). 상한은 시험용으로 작게 줌(실제 100MB, 50MB)
//   사용: node test/t_backup_push.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const Module = require('module'); const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const wb = require(path.join(dir, 'workbench.js'));
const src = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8');
// ①
const ca = wb._backupCommitArgs('BACKUP_"x"');
chk('① commit 명령에 maintenance.auto=false, gc.auto=0', /-c maintenance\.auto=false/.test(ca) && /-c gc\.auto=0/.test(ca) && /commit -q -m "BACKUP_'x'"/.test(ca), ca);
chk('① 2/3 commit 단계가 backupCommitArgs 를 씀(옛 명령 문자열 0)', /run\('2\/3 commit', backupCommitArgs\(msg\)\)/.test(src) && !/run\('2\/3 commit', `-c core\.safecrlf=false commit/.test(src));
chk('① push 성공 뒤 정리 안내 1줄', (src.match(/git maintenance run\)는 백업 밖에서 실행/g) || []).length === 1);
chk('② 3/3 push 앞에서 prePushCheck 를 부르고 멈춤(break)', /const pc = prePushCheck\(cwd, `\$\{item\.remote\}\/\$\{item\.branch\}`\);[\s\S]{0,1500}push blocked[^\n]*break;[\s\S]{0,200}let c3 = await pushOnce\('3\/3 push'\)/.test(src));
// ② 임시 저장소
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'bkpush-'));
const g = (...a) => cp.spawnSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@t', '-c', 'core.autocrlf=false', '-c', 'commit.gpgsign=false', ...a], { cwd: root, encoding: 'utf8', windowsHide: true });
g('init', '-q'); fs.writeFileSync(path.join(root, '.gitignore'), 'snap/\n*.webm\n'); fs.writeFileSync(path.join(root, 'a.txt'), 'a'); g('add', '-A'); g('commit', '-q', '-m', 'base');
g('update-ref', 'refs/remotes/origin/main', 'HEAD'); // 원격 기준 = 첫 커밋
const lim = { stopBytes: 3000, warnBytes: 1500 };
let r = wb._prePushCheck(root, 'origin/main', lim); chk('② 미push 커밋 없음 = 통과', r.ok && r.files === 0 && !r.skipped, JSON.stringify(r));
fs.writeFileSync(path.join(root, 'b.txt'), 'x'.repeat(2000)); fs.writeFileSync(path.join(root, 'c.bin'), 'y'.repeat(4000)); g('add', '-A'); g('commit', '-q', '-m', 'big');
r = wb._prePushCheck(root, 'origin/main', lim);
chk('② 상한 넘는 파일 = 멈춤, 경고 구간 = 경고', !r.ok && r.stop.map(x => x.f).join() === 'c.bin' && r.stop[0].size === 4000 && r.warn.map(x => x.f).join() === 'b.txt' && !r.ignored.length, JSON.stringify(r));
g('rm', '-q', '--cached', 'c.bin'); fs.unlinkSync(path.join(root, 'c.bin')); g('commit', '-q', '-m', 'drop');
fs.mkdirSync(path.join(root, 'snap')); fs.writeFileSync(path.join(root, 'snap', 's.json'), '{}'); g('add', '-f', 'snap/s.json'); g('commit', '-q', '-m', 'forced');
r = wb._prePushCheck(root, 'origin/main', lim);
chk('② .gitignore 제외 경로 파일(강제 추가) = 멈춤', !r.ok && r.ignored.map(x => x.f).join() === 'snap/s.json' && !r.stop.length, JSON.stringify(r));
chk('② 커밋에서 지운 대용량 파일은 대상 아님(blob 기준)', !r.stop.length && !r.warn.some(x => x.f === 'c.bin') === true);
g('rm', '-q', '--cached', 'snap/s.json'); g('commit', '-q', '-m', 'unforce');
r = wb._prePushCheck(root, 'origin/main', lim); chk('② 정리 뒤 = 통과(경고 b.txt 만)', r.ok && r.warn.length === 1, JSON.stringify(r));
r = wb._prePushCheck(root, 'origin/nope', lim); chk('② 원격 기준 없음 = 검사 건너뜀(통과, 사유 기록)', r.ok && /origin\/nope/.test(r.skipped || ''), JSON.stringify(r));
r = wb._prePushCheck(root, 'origin/main'); chk('② 기본 상한 100MB, 50MB = 작은 파일 경고 없음', r.ok && !r.warn.length && !r.stop.length);
try { fs.rmSync(root, { recursive: true, force: true }); } catch { /* 임시 */ }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
