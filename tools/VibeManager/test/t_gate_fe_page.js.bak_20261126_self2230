// 반영 게이트 화면 게이트(G-FE): UI/DB MODE 에서 FE 화면 폴더를 고치는 안(개선안 20261126180323_VISION)
//   임시 저장소에 check.js 대역(페이지 폴더의 BLOCK.txt 숫자를 BLOCK 수로 출력)을 두고 본다. 실제 nscm-fe 에는 쓰지 않는다
//   ① BLOCK 1 → 2 = G-FE 실패 ② 1 → 1 = 통과 ③ DB_ONLY = 건너뜀 ④ 페이지 폴더 없음 = 건너뜀 ⑤ check.js 에 --tsc, --lint, --final 을 주지 않음
//   사용: node test/t_gate_fe_page.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'gatefe-')); const vibeDir = path.join(root, '.vibe');
const hj = path.join(root, 'tools', 'Harness', 'harness.json'); fs.mkdirSync(path.dirname(hj), { recursive: true });
const setScope = s => fs.writeFileSync(hj, JSON.stringify({ repairScope: s, orch: { agentEnabled: false, styleGate: false } }));
setScope('DB_FE');
const argLog = path.join(root, 'args.log');
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'check.js'), [
  "const fs = require('fs'); const path = require('path'); const a = process.argv.slice(2); const pg = a[a.indexOf('--page') + 1];",
  `fs.appendFileSync(${JSON.stringify(argLog)}, a.join(' ') + '\\n');`,
  "const n = Number(fs.readFileSync(path.join(pg, 'BLOCK.txt'), 'utf8').trim());",
  "console.log('[Harness] 대역'); console.log(JSON.stringify({ id: 'T0001', pageDir: pg, block: n, warn: 0, findings: [] })); process.exit(n ? 2 : 0);",
].join('\n'));
const pageRel = 'nscm-fe/features/dm/src/pages/T0001'; const pageAbs = path.join(root, ...pageRel.split('/')); fs.mkdirSync(pageAbs, { recursive: true });
const setBlock = n => fs.writeFileSync(path.join(pageAbs, 'BLOCK.txt'), String(n));
const targets = [`${pageRel}/T0001.tsx`, `${pageRel}/hooks/useT0001.ts`, 'tools/VibeManager/orch-vision.js'];
const p = { root, vibeDir, extDir: path.join(root, 'installed') };
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false, vmDir: path.join(root, 'tools', 'VibeManager') }); // 2026-11-26: 사건 기록 끔(종전 = tools/VibeManager 에 R12 사건 파일이 생김)
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  chk('페이지 폴더 1개(중복 제거)', JSON.stringify(sc.fePages(targets)) === JSON.stringify([pageRel]), JSON.stringify(sc.fePages(targets)));
  // ① 1 → 2
  setBlock(1); const pre = await sc.gate({ targets }); setBlock(2); const post = await sc.gate({ targets, feBase: pre.fe });
  chk('① 반영 전 BLOCK 1 측정', pre.fe && pre.fe.ok && pre.fe.total === 1 && !pre.bad.includes('G-FE'), pre.text);
  chk('① BLOCK 1 → 2 = G-FE 실패', post.bad.includes('G-FE') && /화면 게이트 BLOCK 1 → 2, 타입 검사와 린트 미실행/.test(post.text) && post.detail.some(d => /^G-FE .*1 → 2/.test(d)), post.text);
  // ② 1 → 1
  setBlock(1); const post2 = await sc.gate({ targets, feBase: pre.fe });
  chk('② BLOCK 1 → 1 = 통과', !post2.bad.includes('G-FE') && /화면 게이트 BLOCK 1 → 1/.test(post2.text), post2.text);
  // ③ DB_ONLY
  setScope('DB_ONLY'); const g3 = await sc.gate({ targets, feBase: pre.fe });
  chk('③ DB_ONLY = 건너뜀', g3.fe.skip === 'DB MODE' && !g3.bad.includes('G-FE') && /화면 게이트 건너뜀\(DB MODE\)/.test(g3.text), g3.text);
  chk('③ gateSpec 에 G-FE 없음(DB_ONLY)', !sc.gateSpec(targets).some(x => x.id === 'G-FE'));
  setScope('DB_FE');
  chk('gateSpec 에 G-FE 있음(DB_FE)', sc.gateSpec(targets).some(x => x.id === 'G-FE' && /타입 검사와 린트 미실행/.test(x.what)));
  // ④ 페이지 폴더 없음
  const g4 = await sc.gate({ targets: ['tools/VibeManager/orch-vision.js', 'nscm-fe/features/dm/src/shared/a.ts'], feBase: pre.fe });
  chk('④ 페이지 폴더 없음 = 건너뜀', g4.fe.skip === '페이지 폴더 없음' && !g4.bad.includes('G-FE') && !/화면 게이트/.test(g4.text), g4.text);
  // ⑤ 인자
  const args = fs.readFileSync(argLog, 'utf8'); chk('⑤ --tsc, --lint, --final 안 줌', /--json/.test(args) && !/--tsc|--lint|--final/.test(args), args.split('\n')[0]);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e && e.stack); process.exit(1); });
