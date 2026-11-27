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
chk('아래 줄 = 재설정 · 기준 만(2026-11-24 사용자), 5시간은 title', /^재설정 11-24 23:00 · 기준 \d+-\d+ \d+:\d+$/.test(w.sub) && /5시간 20%/.test(w.title), w.sub + ' | ' + w.title);
chk('80% 이상 = 주의', aiWk({ ai: { weekly: { pct: 82, resetsAt: 0, status: 'allowed' }, windows: [] } }).cls === 'warn');
chk('95% 이상 = 위험', aiWk({ ai: { weekly: { pct: 96, resetsAt: 0, status: 'allowed' }, windows: [] } }).cls === 'bad');
chk('status allowed 아님 = 위험', aiWk({ ai: { weekly: { pct: 50, resetsAt: 0, status: 'rejected' }, windows: [] } }).cls === 'bad');
chk('자료 없음 = null(미측정 표시)', aiWk({}) === null && aiWk({ ai: null }) === null);
const st = fs.readFileSync(path.join(dir, 'orch-state.js'), 'utf8');
chk('부하 자료에 ai 포함', /ai: aiUsage\(\)/.test(st));
// 2026-11-24 사용자: 1분 주기 다시 읽기 + 확인 시각 표시
chk('다시 읽기 주기 = 1분(60000ms)', U.RELOAD_MS === 60000, String(U.RELOAD_MS));
chk('값에 확인 시각(checkedAt) 있음', r && typeof r.checkedAt === 'number' && Math.abs(r.checkedAt - Date.now()) < 60000);
chk('확인 시각 = title(아래 줄에는 없음)', /확인 /.test(aiWk({ ai: r }).title) && !/확인 /.test(aiWk({ ai: r }).sub), aiWk({ ai: r }).sub);
// 2026-11-24 사용자(B): 사용량 조회 원천
const api = U.fromApi({ five_hour: null, seven_day: { utilization: 98.0, resets_at: '2026-11-24T14:00:00+00:00' }, limits: [{ kind: 'weekly_all', percent: 98, severity: 'critical', resets_at: '2026-11-24T14:00:00+00:00' }, { kind: 'weekly_scoped', percent: 57, scope: { model: { display_name: 'Fable' } }, resets_at: '2026-11-24T14:00:00+00:00' }] }, Date.now());
chk('조회 응답 → 주간 98%, 재설정 ms, 모델별 창, 원천 api', api && api.weekly.pct === 98 && api.weekly.resetsAt === Date.parse('2026-11-24T14:00:00+00:00') && api.windows.some(w => w.type === 'Fable 주간' && w.pct === 57) && api.source === 'api', JSON.stringify(api));
chk('주간 값 없는 응답 = null', U.fromApi({ seven_day: null }, 1) === null);
fs.mkdirSync(path.join(vibe, 'orch'), { recursive: true });
fs.writeFileSync(path.join(vibe, 'orch', 'ai_usage.json'), JSON.stringify(Object.assign({}, api, { checkedAt: Date.now() - 30000 })));
let r2 = U.read(vibe); chk('조회 결과 3분 안 = 조회 값 우선(실행 기록보다)', r2 && r2.source === 'api' && r2.weekly.pct === 98, JSON.stringify(r2 && r2.source));
const U2 = (() => { delete require.cache[require.resolve(path.join(dir, 'claude-usage'))]; return require(path.join(dir, 'claude-usage')); })();
fs.writeFileSync(path.join(vibe, 'orch', 'ai_usage.json'), JSON.stringify(Object.assign({}, api, { checkedAt: Date.now() - 1000000 })));
r2 = U2.read(vibe); chk('조회 결과 15분 지남 + 실행 기록이 더 새로움 = 실행 기록 값', r2 && r2.source !== 'api' && r2.weekly.pct === 63, JSON.stringify(r2 && [r2.source, r2.weekly.pct]));
// 2026-11-24 사용자: 최신 조회 실패 = 마지막 정상 조회 값 유지(실행 기록이 더 새로울 때만 실행 기록)
const old = path.join(logs); for (const n of fs.readdirSync(logs)) { const f = path.join(logs, n); const t = (Date.now() - 3600 * 1000) / 1000; fs.utimesSync(f, t, t); }
fs.writeFileSync(path.join(vibe, 'orch', 'ai_usage.json'), JSON.stringify(Object.assign({}, api, { checkedAt: Date.now() - 1000000 })));
const U3 = (() => { delete require.cache[require.resolve(path.join(dir, 'claude-usage'))]; return require(path.join(dir, 'claude-usage')); })();
r2 = U3.read(vibe); chk('조회 값 15분 지남 + 실행 기록이 더 오래됨 = 마지막 정상 조회 값 유지(stale 표시)', r2 && r2.source === 'api' && r2.weekly.pct === 98 && r2.stale === true, JSON.stringify(r2 && [r2.source, r2.weekly.pct, r2.stale]));
chk('화면 설명 = 마지막 정상 조회 값', /마지막 정상 조회 값/.test(aiWk({ ai: r2 }).title));
chk('주기: 성공 10분(1분 = HTTP 429), 실패 10분, stale 15분', U.OK_MS === 600000 && U.BACKOFF_MS === 600000 && U.FRESH_MS === 900000);
U.start(vibe); chk('시험 폴더(임시)에서는 실제 조회 타이머 안 띄움', U.apiState().nextMs === 0);
const ow = aiWk({ ai: Object.assign({}, api, { checkedAt: Date.now() }) }); chk('사용량 조회 원천 = title(아래 줄 = 재설정 · 기준)', /사용량 조회/.test(ow.title) && /10분 주기/.test(ow.title) && !/사용량 조회|Fable/.test(ow.sub), ow.sub);
try { fs.rmSync(vibe, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
