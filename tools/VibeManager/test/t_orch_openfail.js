// R13 화면 진입 실패 반복(2026-11-20): 실행 로그에 화면 진입 실패 줄이 5회 이상이면 사건 1건 · FE 변환 오류가 있으면 원인과 조치 명령을 사건에 담음 · 4회 이하는 사건 없음
//   사용: node test/t_orch_openfail.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const http = require('http');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ofail-')); const p = { root, vibeDir: path.join(root, '.vibe') };
const W = (rel, txt) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, txt, 'utf8'); };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const LINE = '[openScreen] ZZP0001: 주소 진입 뒤 Home 에 남음(http://127.0.0.1:5173/view/home) — 화면 진입 실패로 처리\n';
(async () => {
  // FE 개발 서버 흉내: Form 파일만 변환 오류(500), 나머지 200
  const srv = http.createServer((q, r) => { if (/ZzForm\.tsx/.test(q.url)) { r.statusCode = 500; r.end('<script>const error = {"message":"[plugin:vite:import-analysis] Failed to resolve import \\"@shared/paste\\" from \\"ZzForm.tsx\\". Does the file exist?","stack":""}</script>'); } else { r.statusCode = 200; r.end('export {}'); } });
  await new Promise(x => srv.listen(0, '127.0.0.1', x)); const port = srv.address().port;
  W('tools/Harness/harness.json', JSON.stringify({ orch: {} })); W('tools/E2E/e2e.config.json', JSON.stringify({ feUrl: `http://127.0.0.1:${port}` }));
  W('nscm-fe/features/shipping/src/pages/zz/zz.constants.ts', "export const MENU_ID = 'ZZP0001' as const;\n"); W('nscm-fe/features/shipping/src/pages/zz/components/ZzForm.tsx', "import { x } from '@shared/paste';\n"); W('nscm-fe/features/shipping/src/pages/zz/index.tsx', 'export {};\n');
  W('nscm-fe/features/shipping/src/pages/yy/yy.constants.ts', "export const MENU_ID = 'YYP0002' as const;\n"); W('nscm-fe/features/shipping/src/pages/yy/index.tsx', 'export {};\n');
  W('.vibe/logs/zz.log', 'ok 1\n' + LINE.repeat(6)); W('.vibe/logs/yy.log', LINE.replace('ZZP0001', 'YYP0002').repeat(7)); W('.vibe/logs/few.log', LINE.repeat(4));
  fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true });
  const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
  w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
  const now = Date.now(); const ev = (wb, screen, log, id) => st.apply({ ms: now - 60000, type: 'proc.start', src: 'vm', pid: process.pid, wb, screen, label: `CheckList ${screen}`, procId: id, childPid: process.pid, log });
  ev(1, 'ZZP0001', '.vibe/logs/zz.log', 1); ev(2, 'YYP0002', '.vibe/logs/yy.log', 2); ev(3, 'XXP0003', '.vibe/logs/few.log', 3);
  w.tick(); await new Promise(x => setTimeout(x, 1200));
  const r13 = got.filter(x => x.rule === 'R13'); const z = r13.find(x => x.screen === 'ZZP0001'); const y = r13.find(x => x.screen === 'YYP0002');
  chk('진입 실패 6회 · 7회 = 사건 2건 · 4회 = 사건 없음', r13.length === 2 && !!z && !!y, JSON.stringify(got.map(x => [x.rule, x.screen, x.title])));
  chk('FE 변환 오류 화면: 원인 파일과 문구, 조치 명령을 사건에 담음', !!z && /FE 변환 오류/.test(z.title) && /ZzForm\.tsx/.test(z.detail) && /Failed to resolve import/.test(z.detail) && z.evidence.fix === 'python tools/CommonSync/screen_sync.py ZZP0001' && z.evidence.count === 6, z && JSON.stringify([z.title, z.detail, z.evidence.fix]));
  chk('FE 변환 오류 없는 화면: 다음 확인 순서 안내 · 조치 명령 없음', !!y && !/FE 변환 오류\)/.test(y.title) && /메뉴 권한/.test(y.detail) && y.evidence.fix === '', y && JSON.stringify([y.title, y.detail]));
  got.length = 0; w.tick(); await new Promise(x => setTimeout(x, 600)); chk('같은 실행은 다시 올리지 않음', got.filter(x => x.rule === 'R13').length === 0);
  w.dispose(); st.dispose(); srv.close(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
