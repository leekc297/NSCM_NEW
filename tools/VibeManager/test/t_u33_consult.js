// U33 consultNoResponse 감지기 시험(2026-11-26 개선안 20261126191217_SELF): 컨설팅 요청 뒤 3분 안에 대기, 시작, 끝 기록이 없으면 미응답
//   사용: node test/t_u33_consult.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs');
const Module = require('module'); const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => () => { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const uc = require(path.join(dir, 'orch-usercheck'));
const D = uc.DETECTORS; chk('감지기 consultNoResponse 있음', D && typeof D.consultNoResponse === 'function');
const u = { id: 'U33', detector: 'consultNoResponse', params: { waitMin: 3 } };
const now = Date.now(); const M = 60000;
const x = ev => ({ now, cfg: {}, events: ev });
chk('요청 뒤 응답 없음(10분 전 요청) = fail 1건', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 10 * M, manual: true, topic: 'UI 안' }])).length === 1);
chk('요청 1분 뒤 시작 = 통과', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 10 * M }, { type: 'consult.start', ms: now - 9 * M }])).length === 0);
chk('요청 뒤 대기(에이전트 사용 중) = 응답으로 봄', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 10 * M }, { type: 'consult.wait', ms: now - 10 * M + 20000 }])).length === 0);
chk('요청 뒤 3분 지나 시작 = 미응답', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 10 * M }, { type: 'consult.start', ms: now - 5 * M }])).length === 1);
chk('요청 뒤 아직 3분 안 됨 = 판정 안 함', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 1 * M }])).length === 0);
chk('24시간 지난 요청 = 보지 않음', D.consultNoResponse(u, x([{ type: 'consult.request', ms: now - 25 * 60 * M }])).length === 0);
const led = JSON.parse(fs.readFileSync(path.join(dir, 'user_checks.json'), 'utf8')); const u33 = (led.items || []).find(i => i.id === 'U33');
chk('원장 U33 = active · detector consultNoResponse', u33 && u33.status === 'active' && u33.detector === 'consultNoResponse', JSON.stringify(u33 && { s: u33.status, d: u33.detector }));
const src = fs.readFileSync(path.join(dir, 'orch-consult.js'), 'utf8');
chk('orch-consult.js 가 consult.request, start, wait, end 사건을 남김', ['consult.request', 'consult.start', 'consult.wait', 'consult.end'].every(t => src.includes(`'${t}'`)));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
