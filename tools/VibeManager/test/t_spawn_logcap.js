// 서버 출력 로그 크기 상한 시험(2026-11-26 개선안 20261126164445_VISION_2): logpipe.js 중계기, server-service.js start()
//   확인: ① 쓴 바이트가 상한을 넘으면 <로그>_partN.log 로 옮기고 같은 이름으로 새로 씀 ② 서버가 쓴 줄이 빠지거나 잘리지 않음
//         ③ _part 파일은 keep 개만 남음 ④ harness.json orch.serverLogMaxMB, serverLogKeep 읽음(없으면 200 MB, 5개), 0 = 종전 방식
//         ⑤ server-service.start() 로 띄운 서버: 기동 완료 줄 감지, 종료 코드 전달, 로그 교체 ⑥ 종료 코드 그대로 전달
//   사용: node test/t_spawn_logcap.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const Module = require('module'); const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'logcap-')); const vibe = path.join(root, '.vibe'); const logs = path.join(vibe, 'logs');
fs.mkdirSync(logs, { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
const hj = path.join(root, 'tools', 'Harness', 'harness.json');
const lp = require(path.join(dir, 'logpipe.js'));
const N = 40000;
// 서버 흉내: READY 줄 뒤 번호 붙은 줄 N개(배치마다 5ms 쉼), 끝에 종료 코드 3
const W = path.join(root, 'w.js');
fs.writeFileSync(W, `console.log('READY');let i=0;const pad='x'.repeat(80);(function b(){for(let k=0;k<500&&i<${N};k++,i++)process.stdout.write('L'+i+' '+pad+'\\n');if(i<${N})setTimeout(b,5);else process.exitCode=3;})();`);
const cmdLine = `"${process.execPath}" "${W}"`;
// start() 용 서버 흉내: 실제 서버처럼 기동 완료 줄을 쓰고 잠깐 뒤 출력(1.5초 쉼)
const W2 = path.join(root, 'w2.js');
fs.writeFileSync(W2, `console.log('READY');let i=0;const pad='x'.repeat(80);setTimeout(function b(){for(let k=0;k<500&&i<${N};k++,i++)process.stdout.write('L'+i+' '+pad+'\\n');if(i<${N})setTimeout(b,5);else process.exitCode=3;},1500);`);
function verify(name, logF) {
  const parts = lp.partsOf(logF);
  const all = parts.map(x => fs.readFileSync(x.f, 'utf8')).concat([fs.readFileSync(logF, 'utf8')]).join('');
  const lines = all.split(/\r?\n/).filter(Boolean).filter(l => !/^\[logpipe\]|^READY$/.test(l));
  const nums = lines.map(l => (/^L(\d+) x{80}$/.exec(l) || [])[1]).filter(x => x != null).map(Number);
  chk(`${name}: 줄 ${N}개 빠짐, 잘림 없이 1번씩`, lines.length === N && nums.length === N && new Set(nums).size === N, `줄 ${lines.length}, 번호 ${new Set(nums).size}`);
  return parts;
}
(async () => {
  // ① ② ③ 중계기 직접
  const logA = path.join(logs, 'A_NSCM_BE.log');
  const r = cp.spawnSync(process.execPath, [path.join(dir, 'logpipe.js'), logA, String(1048576), '100', '--', cmdLine], { encoding: 'utf8', windowsHide: true, timeout: 120000 });
  chk('중계기 종료 코드 = 서버 종료 코드(3)', r.status === 3, `status ${r.status} ${r.stderr || ''}`);
  const parts = verify('중계기', logA);
  chk('1 MB 넘을 때마다 _partN 로 옮김(번호 1부터 이어짐)', parts.length >= 3 && parts.every((x, i) => x.n === i + 1) && parts.every(x => fs.statSync(x.f).size >= 1048576 && fs.statSync(x.f).size < 1048576 + 64 * 1024), parts.map(x => `${path.basename(x.f)} ${fs.statSync(x.f).size}`).join(', '));
  chk('현재 로그 = 상한 아래', fs.statSync(logA).size < 1048576 + 64 * 1024, String(fs.statSync(logA).size));
  const logB = path.join(logs, 'B_NSCM_BE.log');
  cp.spawnSync(process.execPath, [path.join(dir, 'logpipe.js'), logB, String(1048576), '2', '--', cmdLine], { encoding: 'utf8', windowsHide: true, timeout: 120000 });
  const pb = lp.partsOf(logB);
  chk('keep 2 = _part 2개만 남고 가장 새 번호', pb.length === 2 && pb[1].n >= 3 && pb[0].n === pb[1].n - 1, pb.map(x => x.n).join());
  // ④ harness 값
  const ss = require(path.join(dir, 'server-service.js'));
  fs.writeFileSync(hj, JSON.stringify({ orch: {} }));
  ss.init({ root, vibeDir: vibe });
  let c = ss.logCapCfg(); chk('harness 키 없음 = 기본 200 MB, 5개', c.maxBytes === 200 * 1048576 && c.keep === 5 && !c.off, JSON.stringify(c));
  fs.writeFileSync(hj, JSON.stringify({ orch: { serverLogMaxMB: 0 } }));
  chk('serverLogMaxMB 0 = 종전 방식(cmd /c, 파일 핸들 직접)', ss.serverSpawnArgs('x', 'y.log').pipe === false && ss.serverSpawnArgs('x', 'y.log').args.join(' ') === '/c x');
  fs.writeFileSync(hj, JSON.stringify({ orch: { serverLogMaxMB: 1, serverLogKeep: 10 } }));
  c = ss.logCapCfg(); const sa = ss.serverSpawnArgs('gradlew.bat bootRun', 'z.log');
  chk('harness 1 MB, 10개 = 중계기 인자', c.maxBytes === 1048576 && c.keep === 10 && sa.pipe && sa.args[0].endsWith('logpipe.js') && sa.args.slice(1).join('|') === `z.log|1048576|10|--|cmd /c gradlew.bat bootRun` && sa.env.ELECTRON_RUN_AS_NODE === '1', JSON.stringify(sa));
  // ⑤ start() 로 서버 흉내 기동
  const lines = []; ss.subscribe && ss.subscribe(m => { if (m && m.text) lines.push(String(m.text)); });
  const res = await ss.start({ root, vibeDir: vibe }, { cmd: `node "${W2}"`, ready: '^READY', readyTimeoutSec: 30 }, root, 'NSCM_TEST', () => { });
  chk('start(): 기동 완료 줄 감지', res && res.ok === true, JSON.stringify(res));
  const t0 = Date.now(); let logF = '';
  while (Date.now() - t0 < 60000) { const f = fs.readdirSync(logs).find(n => /_NSCM_TEST\.log$/.test(n)); if (f) logF = path.join(logs, f); if (logF && !ss.isRunning('NSCM_TEST')) break; await new Promise(r2 => setTimeout(r2, 300)); }
  await new Promise(r2 => setTimeout(r2, 1500));
  chk('start(): 서버 끝남', !!logF && !ss.isRunning('NSCM_TEST'));
  if (logF) { const p2 = verify('start()', logF); chk('start(): 로그 _part 교체', p2.length >= 3, p2.map(x => path.basename(x.f)).join(', ')); }
  // 로그 따라 읽기(tailFile): 상한 교체로 파일이 줄면 직전 _part 의 안 읽은 뒷부분부터 읽음
  { const tf = path.join(logs, 'T_NSCM_BE.log'); fs.writeFileSync(tf, 'a1\nb1\n'); const got = []; const t = ss._tailFile(tf, ln => got.push(ln), 0);
    await new Promise(r2 => setTimeout(r2, 900)); fs.appendFileSync(tf, 'c1\nd'); fs.renameSync(tf, path.join(logs, 'T_NSCM_BE_part1.log')); fs.writeFileSync(tf, '1\ne1\n');
    await new Promise(r2 => setTimeout(r2, 1600)); t.stop();
    chk('tailFile: 교체 때 part 뒷부분 + 새 파일 = 줄 빠짐 없음(잘린 줄 이어 붙음)', got.join(',') === 'a1,b1,c1,d1,e1', got.join(',')); }
  try { ss.dispose(); } catch { /* 정리 */ }
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { /* 임시 폴더 */ }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
