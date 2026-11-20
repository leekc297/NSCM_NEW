// AI 주간 한도 표시(2026-11-20 사용자 지시 'VMO OVERVIEW 의 부하 보드에 클로드 주간한도 사용량 표기')
//   · claude-usage.read: 최근 AI 실행 기록에서 마지막 rate_limit_event 를 읽음(새 파일 우선 · 잘린 줄 건너뜀 · 기록 없으면 null)
//   · orchestra.js aiWk: 사용률 · 색 구간(80 주의, 95 위험, status allowed 아님 = 위험) · 재설정 · 기준 시각 · 다른 창(5시간) 표시
//   사용: node test/t_claude_usage.js <VibeManager 폴더>
const fs = require('fs'); const path = require('path'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const U = require(path.join(dir, 'claude-usage'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const vibe = fs.mkdtempSync(path.join(os.tmpdir(), 'usage-')); const logs = path.join(vibe, 'logs'); fs.mkdirSync(logs);
const ev = (u, extra) => JSON.stringify({ type: 'rate_limit_event', rate_limit_info: Object.assign({ status: 'allowed', resetsAt: 1795528800, rateLimitType: 'seven_day', isUsingOverage: false, unifiedWindows: { seven_day: { utilization: u, resetsAt: 1795528800, status: 'allowed' } } }, extra || {}) });
const put = (n, lines, agoSec) => { const f = path.join(logs, n); fs.writeFileSync(f, lines.join('\n') + '\n'); const t = (Date.now() - agoSec * 1000) / 1000; fs.utimesSync(f, t, t); };
chk('기록 없음 = null', U.read(vibe) === null);
put('2026-11-20T10-00-00_claude_orch.log', ['$ claude -p', ev(0.40), '{"type":"assistant"}', ev(0.42)], 600);
put('2026-11-20T11-00-00_claude_wb1.log', ['$ claude -p', ev(0.55), '{"type":"result"}'], 60);
put('2026-11-20T11-30-00_server_be.log', [ev(0.99)], 1);                         // claude 기록 아님 = 무시
put('2026-11-20T11-10-00_claude_wb2.log', ['$ claude -p', '{"type":"assistant"}'], 30); // 한도 줄 없음 = 다음 파일
let r = U.read(vibe);
chk('가장 새 기록 중 한도 줄 있는 파일의 마지막 값(55%)', r && r.weekly && r.weekly.pct === 55 && r.file === '2026-11-20T11-00-00_claude_wb1.log', JSON.stringify(r));
chk('재설정 시각 ms', r.weekly.resetsAt === 1795528800000);
chk('기준 시각 = 그 파일 수정 시각', Math.abs(r.at - (Date.now() - 60000)) < 5000);
put('2026-11-20T12-00-00_claude_orch.log', ['$ claude -p', ev(0.61), ev(0.63, { unifiedWindows: { seven_day: { utilization: 0.63, resetsAt: 1795528800, status: 'allowed' }, five_hour: { utilization: 0.2, resetsAt: 1795160000, status: 'allowed' } } }), '{"type":"rate_limit_event","rate_limit_info":{"status":"al'], 5);
r = U.read(vibe);
chk('끝 줄이 잘려도 앞 줄 값(63%) · 창 2개', r && r.weekly.pct === 63 && r.windows.length === 2 && r.windows.some(w => w.type === 'five_hour' && w.pct === 20), JSON.stringify(r && r.windows));
// 웹뷰 aiWk
const src = fs.readFileSync(path.join(dir, 'orchestra.js'), 'utf8'); const m = src.match(/function aiWk\(L\)\{[\s\S]*?\n\s*return \{[\s\S]*?\}; \}/);
chk('orchestra.js 에 aiWk 있음', !!m);
const aiWk = new Function('KO', `${m[0]}; return aiWk;`)(true);
let w = aiWk({ ai: r });
chk('표시 63% · 색 기본', w.pct === 63 && w.cls === '', JSON.stringify(w));
chk('재설정 · 기준 · 5시간 표시', /재설정 11-24 23:00/.test(w.sub) && /기준 /.test(w.sub) && /5시간 20%/.test(w.sub), w.sub);
chk('80% 이상 = 주의', aiWk({ ai: { weekly: { pct: 82, resetsAt: 0, status: 'allowed' }, windows: [] } }).cls === 'warn');
chk('95% 이상 = 위험', aiWk({ ai: { weekly: { pct: 96, resetsAt: 0, status: 'allowed' }, windows: [] } }).cls === 'bad');
chk('status allowed 아님 = 위험', aiWk({ ai: { weekly: { pct: 50, resetsAt: 0, status: 'rejected' }, windows: [] } }).cls === 'bad');
chk('자료 없음 = null(미측정 표시)', aiWk({}) === null && aiWk({ ai: null }) === null);
const st = fs.readFileSync(path.join(dir, 'orch-state.js'), 'utf8');
chk('부하 자료에 ai 포함', /ai: aiUsage\(\)/.test(st));
try { fs.rmSync(vibe, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
