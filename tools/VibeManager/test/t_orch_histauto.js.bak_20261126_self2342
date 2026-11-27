// 이력 자동 수집 체크(2026-11-20 사용자 지시) — harness.json orch.historyAuto 값만 바꾸고, 켜져 있고 주기가 지났을 때만 수집
//   사용: node test/t_orch_histauto.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'hauto-')); const p = { root, vibeDir: path.join(root, '.vibe') };
const hf = path.join(root, 'tools', 'Harness', 'harness.json'); fs.mkdirSync(path.dirname(hf), { recursive: true }); fs.mkdirSync(path.join(p.vibeDir, 'orch', 'history'), { recursive: true });
const SRC = '{\n  "llmReview": true,\n  "orch": {\n    "agentEnabled": true,\n    "historyEnabled": true\n  },\n  "x": 1\n}\n'; fs.writeFileSync(hf, SRC, 'utf8');
const h = require(path.join(dir, 'orch-history')); h.init({ paths: () => p, sessionDirs: [], writeMd: false, timer: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  chk('기본 = 끔 · 주기 60분', h.autoCfg().on === false && h.autoCfg().min === 60 && h.status().auto.on === false);
  chk('끔 = 수집 안 함', h.autoTick() === null);
  const r1 = h.setAuto(true); const t1 = fs.readFileSync(hf, 'utf8');
  chk('켜기 = historyAuto 줄 1개 추가, 다른 줄 그대로', r1.ok && h.autoCfg().on === true && t1 === SRC.replace('"orch": {\n', '"orch": {\n    "historyAuto": true,\n'), t1);
  const pr = h.autoTick(); chk('켬 + 수집 기록 없음 = 수집 실행', !!pr && typeof pr.then === 'function'); if (pr) await pr;
  const s = h.stats(); chk('수집 뒤 통계 파일 생김', !!(s && s.ms), JSON.stringify(s && { at: s.at, total: s.total }));
  chk('주기 안 = 수집 안 함', h.autoTick() === null);
  const sf = path.join(p.vibeDir, 'orch', 'history', 'stats.json'); const j = JSON.parse(fs.readFileSync(sf, 'utf8')); j.ms = Date.now() - 61 * 60000; fs.writeFileSync(sf, JSON.stringify(j));
  const pr2 = h.autoTick(); chk('주기 지남 = 수집 실행', !!pr2); if (pr2) await pr2;
  const r2 = h.setAuto(false); const t2 = fs.readFileSync(hf, 'utf8');
  chk('끄기 = 값만 false', r2.ok && h.autoCfg().on === false && t2 === t1.replace('"historyAuto": true', '"historyAuto": false'));
  j.ms = Date.now() - 61 * 60000; fs.writeFileSync(sf, JSON.stringify(j)); chk('끈 뒤 주기 지나도 수집 안 함', h.autoTick() === null);
  fs.writeFileSync(hf, '{"a":1}', 'utf8'); chk('orch 절 없음 = 실패 사유 반환', h.setAuto(true).ok === false);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
