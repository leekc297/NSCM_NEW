// 2026-11-26 사용자 지시('VMO 는 IT 컨설턴트이며 DB, UI 모두를 섭렵한 최고의 엔지니어 · 스스로 의견을 내고 개발 진행') 시험 — 임시 폴더, 실제 Claude 호출 없음
//   ① 지시문 = 컨설턴트 역할 · 진단·로드맵·개선안 · 읽기 전용 · 중복·사용자 결정 존중 ② 보고서 표 ③ 실행: 개선안 '컨설팅:' 머리말로 등록(vision) · 보고 last.md · meta ④ 주기(consultEveryDays) · 끄기
//   사용: node test/t_orch_consult.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'consult-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
const setCfg = o => fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: Object.assign({ consultMaxPerRun: 2 }, o || {}) }));
setCfg();
const added = [];
const imp = { list: () => [{ title: '기존 안', status: 'pending', ms: Date.now() }], add: (o, src) => { if (/중복/.test(o.title)) return { dup: 'x' }; const id = `ID${added.length}`; added.push({ o, src, id }); return { id }; } };
const OUT = { summary: '요약', assessment: [{ area: 'UI 개발', verdict: '약점', evidence: 'gen.js:10' }], roadmap: [{ when: '지금', item: 'A', why: 'B', measure: 'C' }],
  proposals: [{ title: '드릴 진입 시각화', evidence: 'e', targets: ['tools/VibeManager/a.js'], impact: 'fix' }, { title: '중복 안', evidence: 'e', targets: ['x'] }, { title: '세 번째(상한 밖)', evidence: 'e', targets: ['y'] }] };
const agent = { runClaude: async () => ({ ok: true, text: 'x', log: 'l' }), withLock: async (id, fn) => fn(), lastJsonBlock: () => OUT, say: () => { } };
const cs = require(path.join(dir, 'orch-consult'));
cs.init({ paths: () => ({ root, vibeDir }), noTimer: true, mods: { 'orch-agent': agent, 'orch-improve': imp } });
const pr = cs.buildPrompt({ consultMaxPerRun: 6 }, [{ title: '기존 안', status: 'pending' }]);
chk('① 컨설턴트 역할 · DB·UI 수석 엔지니어', /IT 컨설턴트/.test(pr) && /Oracle DB/.test(pr) && /React/.test(pr));
chk('① 진단 · 로드맵 · 개선안 · 읽기 전용', /현황 진단/.test(pr) && /개선 로드맵/.test(pr) && /바로 개발할 개선안 최대 6건/.test(pr) && /파일을 고치지 않는다/.test(pr));
chk('① 중복·사용자 결정 존중 · 지난 보고 읽기', /이미 올라온 개선안 1건/.test(pr) && /checker_scan_ignore\.csv/.test(pr) && /consult\/last\.md/.test(pr));
const md = cs.reportMd(OUT, ['ID0', ''], '2026-11-26 16:40:00');
chk('② 보고서 표(진단 · 로드맵 · 개선안 id · 중복 표시)', /\| UI 개발 \| 약점 \| gen\.js:10 \|/.test(md) && /\| 지금 \| A \| B \| C \|/.test(md) && /\(ID0\)/.test(md) && /\(중복 제외\)/.test(md));
chk('④ 처음 = 주기 도래', cs.due() === true);
(async () => {
  const r = await cs.run(false);
  chk('③ 실행: 상한 2건 안에서 1건 등록 · 1건 중복', r.ok && r.added === 1 && r.dups === 1, JSON.stringify(r));
  chk('③ 머리말 컨설팅: · 출처 vision · origin consult', added[0] && added[0].o.title === '컨설팅: 드릴 진입 시각화' && added[0].src === 'vision' && added[0].o.origin === 'consult');
  chk('③ 보고 last.md · meta', fs.existsSync(path.join(vibeDir, 'orch', 'consult', 'last.md')) && /개선안 1건 등록/.test(cs.meta().lastResult || ''));
  chk('④ 방금 돌았으면 주기 전', cs.due() === false);
  setCfg({ consultEnabled: false }); chk('④ 끄기 = 자동 실행 안 함', (await cs.run(false)).skipped === '꺼짐' && cs.due(Date.now() + 9 * 86400000) === false);
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
