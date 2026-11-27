// VMO Overview 진단 사다리 카드 렌더 시험(개선안 20261126173142_SELF, L4 원장 20261125000242_VISION 단계 4)
//   orchestra.js html() 이 만든 웹뷰 스크립트에서 ladWaitRows 를 꺼내 표본 묶음으로 그려 본다(VS Code 없이)
//   사용: node test/t_orch_ladder_card.js <VibeManager 폴더>
'use strict';
const path = require('path');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x === undefined ? '' : x); if (!c) ok = false; };
const fnSrc = (js, name) => { const i = js.indexOf(`function ${name}(`); if (i < 0) return ''; let d = 0, j = js.indexOf('{', i); for (let k = j; k < js.length; k++) { if (js[k] === '{') d++; else if (js[k] === '}') { d--; if (!d) return js.slice(i, k + 1); } } return ''; };
for (const lang of ['ko', 'en']) {
  const html = require(path.join(dir, 'orchestra')).html({ root: 'C:\\x', vibeDir: 'C:\\x\\.vibe', extDir: dir, language: lang }, { tab: '' });
  const js = (html.match(/<script>([\s\S]*?)<\/script>/g) || []).map(s => s.replace(/^<script>|<\/script>$/g, '')).join('\n');
  const src = fnSrc(js, 'ladWaitRows');
  chk(`${lang}: 웹뷰 스크립트에 ladWaitRows 함수`, !!src);
  chk(`${lang}: paintVision 이 사다리 카드에 ladWaitRows(m.ladder) 를 그림`, /ladWaitRows\(m\.ladder\)/.test(fnSrc(js, 'paintVision')));
  const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
  const f = new Function('esc', 'KO', `${src}; return ladWaitRows;`)(esc, lang === 'ko');
  const lad = { bundles: [
    { key: 'L4|useraxis|checklistTime', level: 'L4', title: '같은 축 사용자 지적 3건(checklistTime, 7일)', why: '효력 뒤 실행 0건', status: 'wait', statusLabel: '실측 대기: 다음 CheckList 1회 필요' },
    { key: 'L4|useraxis|vmoCadence', level: 'L4', title: '같은 축 지적', status: 'wait', statusLabel: '' },
    { key: 'L3|x', level: 'L3', title: '열린 묶음', status: 'open' },
    { key: 'L3|y', level: 'L3', title: '닫힌 묶음', status: 'resolved' }] };
  const out = f(lad);
  chk(`${lang}: 대기 묶음 2줄만(열린, 해결 묶음 제외)`, (out.match(/class="vs-kv"/g) || []).length === 2 && !/열린 묶음|닫힌 묶음/.test(out), out.length);
  chk(`${lang}: 실측 대기 문구와 근거(title) 표시`, out.includes('실측 대기: 다음 CheckList 1회 필요') && out.includes('title="효력 뒤 실행 0건"'));
  chk(`${lang}: 사유 없는 대기 = 기본 문구`, lang === 'ko' ? /같은 축 지적 · 대기</.test(out) : /같은 축 지적 · waiting</.test(out));
  chk(`${lang}: 묶음 없음 = 빈 문자열`, f({}) === '' && f(null) === '');
  // 개선안 20261126173842_SELF 후속: 효력 뒤 CheckList 1판 원장 줄(clEffRows)
  const ce = new Function('esc', 'KO', `${fnSrc(js, 'clEffRows')}; return clEffRows;`)(esc, lang === 'ko');
  chk(`${lang}: paintVision 이 clEffRows(m.checklistEffect) 를 그림`, /clEffRows\(m\.checklistEffect\)/.test(fnSrc(js, 'paintVision')));
  const runs = [{ runId: 'r0', screen: 'OLD', at: '2026-11-24T01:00:00+09:00', firstDocMin: 10, chainMin: 10 }, { runId: 'SCP0028_1795535760315', screen: 'SCP0028', at: '2026-11-25T03:19:27+09:00', firstDocMin: 79.7, chainMin: 143, stageMin: { diff: 16 }, outsidePct: 47.5, concurrent: 3 },
    { runId: 'SSP0005_1795535760347', screen: 'SSP0005', at: '2026-11-25T03:19:19+09:00', firstDocMin: null, chainMin: 143, outsidePct: null, concurrent: 0 },
    { runId: 'r3', screen: 'SCP0005', at: '2026-11-26T02:41:21+09:00', firstDocMin: 25, chainMin: 40, outsidePct: 5, concurrent: 0 }]; // 시간 순(events.jsonl 순서) · 가장 오래된 OLD 는 최근 3건 밖
  const o2 = ce({ proposal: '20261123000419_VISION', effAt: '2026-11-23T15:58:21+09:00', targetMin: 30, runsAfter: runs });
  const ko = lang === 'ko';
  chk(`${lang}: 머리 줄 + 최근 3건(오래된 OLD 제외)`, (o2.match(/class="vs-kv"/g) || []).length === 4 && !o2.includes('>OLD<') && o2.includes(ko ? '효력 뒤 4건' : 'after effect 4 runs'), o2.length);
  chk(`${lang}: 1판 초과, 단계 밖 비율 귀속 부족, 동시 실행 화면 수`, o2.includes(ko ? '1판 79.7분 (목표 30분) 초과, 단계 밖 47.5%(귀속 부족), 동시 4화면' : '1st 79.7m (target 30m) over, outside 47.5%(unattributed), concurrent 4'));
  chk(`${lang}: 1판 없음 = 체인 분 · 목표 이하 = 초과 표시 없음`, o2.includes(ko ? '1판 없음, 체인 143분' : 'no 1st doc, chain 143m') && o2.includes(ko ? '1판 25분 (목표 30분), 단계 밖 5%,' : '1st 25m (target 30m), outside 5%,'));
  const o3 = ce({ proposal: 'P', effAt: '', targetMin: 30, runsAfter: [], note: '실측 대기: 효력 뒤 CheckList 0건' });
  chk(`${lang}: 효력 뒤 0건 = 사유 줄 1개`, (o3.match(/class="vs-kv"/g) || []).length === 1 && o3.includes('실측 대기: 효력 뒤 CheckList 0건') && ce(null) === '');
}
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
