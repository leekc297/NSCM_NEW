// 변경 기록 분류 시험(2026-11-26 개선안 20261126164321_SELF, 20261126164550_SELF, 20261126164030_SELF, 20261126164033_SELF)
//   S13 사용자 지시 규칙 적용 절 = request(원인 줄, 결함 제목이면 defect) · '- 변경: … 파일 <목록>.' 표시가 있으면 그 목록만 고친 파일
//   사용: node test/t_orch_history_kind.js <VibeManager 폴더>
const path = require('path'); const Module = require('module');
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => () => { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const h = require(path.join(dir, 'orch-history'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const s13 = ['- 사용자(2026-11-26): 개선안 20261125034940_SELF_3 승인(VM 자가진단 S13 S13|R218|tools/VibeManager/quick.json). 근거 = 규칙 R218 "CheckList 미검증 …"',
  '- 변경: 라벨 문구를 규칙에 맞춤. workbench.js 설명 참고. 파일 tools/VibeManager/quick.json. 대상 밖 변경 2개(다른 작업).', '- 확인(10:00): 시험 통과'];
chk('S13 규칙 적용 절 = request', h.fixKindOf('사용자 지시 R218 같은 문제: quick.json 라벨', s13) === 'request');
chk('S13 절이라도 원인 줄이 있으면 defect', h.fixKindOf('사용자 지시 R218 같은 문제', s13.concat(['- 원인: 단계 인자 누락'])) === 'defect');
chk('S13 절이라도 제목에 오류가 있으면 defect', h.fixKindOf('체인 인자 오류 수정', s13) === 'defect');
chk('S13 없는 SELF 승인 절 = defect(종전)', h.fixKindOf('창 종료 기록', ['- 사용자(2026-11-20): 개선안 20261120005942_SELF 승인(VM 자가진단 S5 S5|x)']) === 'defect');
chk('S11 근거 절 = style(종전)', h.fixKindOf('문구', ['- 근거 S11|workbench.js']) === 'style');
const txt = ['## (판 번호 없음, VM 저장소 + 설치 폴더) VMO 자가 보완: 라벨 (2026-11-26 10:00)', ...s13, '',
  '## (판 번호 없음, VM 저장소) 옛 절 (2026-11-20 09:00)', '- 변경: workbench.js 와 orchestra.js 를 고침', ''].join('\n');
const sec = h.parseChangelog(txt);
chk("'파일 <목록>.' 표시 = 그 목록만(설명 속 workbench.js 제외)", JSON.stringify(sec[0].files) === JSON.stringify(['tools/VibeManager/quick.json']), JSON.stringify(sec[0].files));
chk('표시 없는 옛 절 = 종전 방식(문장 속 파일 이름)', sec[1].files.includes('workbench.js') && sec[1].files.includes('orchestra.js'), JSON.stringify(sec[1].files));
chk("'파일 없음.' = 빈 목록", JSON.stringify(h.parseChangelog('## a (2026-11-26 10:00)\n- 변경: x. 파일 없음.\n')[0].files) === '[]');
// 2026-11-26 개선안 20261126183040_SELF: 사용자 지적 감지기 추가 절 = request, 동작 수정 절 = defect. 실제 CHANGELOG 절로 확인
{
  const cl = require('fs').readFileSync(path.join(dir, 'CHANGELOG.md'), 'utf8'); const all = h.parseChangelog(cl);
  const u29 = all.find(s => /사용자 지적 감지기 추가 U29 asisLiveLogin/.test(s.title));
  const u3 = all.find(s => /U3 조치 없는 열린 사건 판정에서 U3 자신이 올린 R12 사건 제외/.test(s.title));
  chk('실제 절: U29 감지기 추가 = request', u29 && u29.fix === 'request', u29 ? u29.fix : '절 없음');
  chk('실제 절: U3 판정 수정 = defect(종전)', u3 && u3.fix === 'defect', u3 ? u3.fix : '절 없음');
  const det = ['- 사용자(2026-11-26): 개선안 20261126000001_SELF 승인(VM 자가진단 S13 S13|U40).', '- 변경: DETECTORS 에 x 없음 → 추가. 파일 tools/VibeManager/orch-usercheck.js, tools/VibeManager/user_checks.json, tools/VibeManager/test/t_orch_usercheck.js.'];
  chk("'DETECTORS 에 … 없음 → 추가' + 감지기 파일뿐 = request", h.fixKindOf('VMO 자가 보완: 감시 항목', det) === 'request');
  chk('감지기 추가라도 동작 파일이 섞이면 defect', h.fixKindOf('VMO 자가 보완: 감시 항목', [det[0], det[1].replace('tools/VibeManager/user_checks.json', 'tools/VibeManager/orch-agent.js')]) === 'defect');
  chk('감지기 파일만 고쳤어도 추가 표시가 없으면(판정 로직 수정) defect', h.fixKindOf('VMO 자가 보완: 감시 항목 판정 수정', [det[0], '- 변경: 조건 바꿈. 파일 tools/VibeManager/orch-usercheck.js.']) === 'defect');
  const uc = require(path.join(dir, 'orch-usercheck')); const lad = require(path.join(dir, 'orch-ladder'));
  for (const pr of [{ targets: ['tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/user_checks.json'] }, { targets: ['tools/VibeManager/orch-agent.js'] }, { sig: 'sn|newdet|x', targets: ['a.js'] }, { kind: 'fix', targets: ['tools/VibeManager/orch-usercheck.js'] }]) {
    if (typeof uc.isDetectorProposal === 'function') chk(`감지기 판정 하나로 맞춤 ${JSON.stringify(pr).slice(0, 60)}`, uc.isDetectorProposal(pr) === (lad.proposalKind(pr) === 'detector'));
  }
}
// 2026-11-26 개선안 20261126183313_SELF: 원본과 같은 절의 시험 파일은 반복 수정 집계에서 세지 않음(withSrc 만), 시험 파일만 고친 절은 셈
{
  const mkC = (files, date) => ({ kind: 'change', fix: 'defect', date, files, ask: [], baks: [], unverified: [], screens: [], sources: [] });
  const days = ['2026-11-20', '2026-11-21', '2026-11-22', '2026-11-23', '2026-11-24', '2026-11-25'];
  const ent = days.map(d => mkC(['tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/test/t_orch_usercheck.js'], d)).concat([mkC(['tools/VibeManager/test/t_only.js'], '2026-11-25')]);
  { const os = require('os'); const fs = require('fs'); const r0 = fs.mkdtempSync(path.join(os.tmpdir(), 'hk-')); h.init({ paths: () => ({ root: r0, vibeDir: path.join(r0, '.vibe') }), sessionDirs: [] }); }
  const st = h._buildStats(ent, [], [], {});
  const rf = n => (st.repeatFiles || []).find(r => r.file === n);
  chk('(가) 원본과 함께 고친 시험 파일 = 결함 집계 0(반복 수정 목록에 없음)', !rf('t_orch_usercheck.js'), JSON.stringify(rf('t_orch_usercheck.js')));
  chk('(가) 원본 파일은 종전대로 결함 6', rf('orch-usercheck.js') && rf('orch-usercheck.js').defect === 6, JSON.stringify(rf('orch-usercheck.js')));
  const st1 = h._buildStats([mkC(['tools/VibeManager/orch-usercheck.js', 'tools/VibeManager/test/t_orch_usercheck.js'], '2026-11-25')], [], [], {});
  const b1 = st1.byFile['t_orch_usercheck.js'] || {}; const sum = o => Object.values(o || {}).reduce((a, b) => a + b, 0);
  chk('(가) 절 1건: t_orch_usercheck.js kindDays.defect 합 0, withSrc 1', sum((b1.kindDays || {}).defect) === 0 && b1.withSrc === 1, JSON.stringify(b1));
  const st1b = h._buildStats([mkC(['tools/VibeManager/test/t_orch_usercheck.js'], '2026-11-25')], [], [], {});
  chk('(나) 절 1건: 시험 파일만이면 defect 1', sum(((st1b.byFile['t_orch_usercheck.js'] || {}).kindDays || {}).defect) === 1, JSON.stringify(st1b.byFile['t_orch_usercheck.js']));
  const st2 = h._buildStats(days.map(d => mkC(['tools/VibeManager/test/t_only.js'], d)), [], [], {});
  chk('(나) 시험 파일만 고친 절 = 종전대로 셈(결함 6)', (st2.repeatFiles || []).some(r => r.file === 't_only.js' && r.defect === 6), JSON.stringify(st2.repeatFiles));
  // 개선안 20261126190703_SELF: 측정 산출물 경로는 집계에서 뺌, 경로 없는 같은 이름은 종전
  const st3 = h._buildStats(days.map(d => mkC(['tools/VibeManager/orch-improve.js', 'Doc/verify/SCP0005/verify_ledger.csv', 'Doc/e2e/results/SCP0005/x.json', 'Doc\\verify\\_llm_usage.csv'], d)).concat(days.map(d => mkC(['verify_ledger2.csv'], d))), [], [], {});
  const n3 = (st3.repeatFiles || []).map(r => r.file);
  chk('측정 산출물(Doc/verify, Doc/e2e/results, 역슬래시 경로 포함) = 집계 안 함', !n3.includes('verify_ledger.csv') && !n3.includes('x.json') && !n3.includes('_llm_usage.csv') && n3.includes('orch-improve.js'), JSON.stringify(n3));
  chk('경로 없는 이름 = 종전대로 셈', n3.includes('verify_ledger2.csv'), JSON.stringify(n3));
}
// 2026-11-26 개선안 20261126234153_SELF: VMO 승인, 되돌리기 기록 줄의 인용은 같은 지시 집계에서 빼고 ruleAsk 에 둠. 사람이 입력한 '사용자(…): "…"' 줄은 종전대로 셈
{
  const rule = (d, id) => `## (판 번호 없음, VM 저장소) VMO 자가 보완: 규칙 적용 (${d} 10:00)\n- 사용자(${d}): 개선안 ${id} 승인(VM 자가진단 S13 S13|R83|x.js). 근거 = 규칙 R83 "산출물 폴더 경로는 설정 1곳에 두고 소스에 경로를 따로 적지 않음"\n- 사용자(${d}): 개선안 ${id} 되돌리기 실행. 원래 지시 "산출물 폴더 경로는 설정 1곳에 두고 소스에 경로를 따로 적지 않음"\n`;
  const secR = h.parseChangelog(rule('2026-11-25', '20261125000001_SELF') + rule('2026-11-26', '20261126000002_SELF'));
  const stR = h._buildStats(secR, [], [], {});
  chk('승인, 되돌리기 기록 줄 2절 = 같은 지시 0건(ruleAsk 에 따로 둠)', stR.repeatAsks.length === 0 && secR[0].ask.length === 0 && secR[0].ruleAsk.length === 2, JSON.stringify({ ra: stR.repeatAsks, ask: secR[0].ask, ruleAsk: secR[0].ruleAsk }));
  const user = d => `## 사용자 요청 반영 (${d} 11:00)\n- 사용자(${d} 10:50): "계속 개선항목 찾아서 진행해주세요"\n- 변경: x\n`;
  const stU = h._buildStats(h.parseChangelog(user('2026-11-25') + user('2026-11-26')), [], [], {});
  chk('사람이 입력한 인용 2절 = 같은 지시 1건(count 2)', stU.repeatAsks.length === 1 && stU.repeatAsks[0].count === 2, JSON.stringify(stU.repeatAsks));
}
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
