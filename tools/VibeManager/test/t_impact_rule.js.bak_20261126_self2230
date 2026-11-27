// 반영 지시문 IMPACT_RULE 의 사용자 승인 문장 = autoEligible 판정 기준(개선안 20261126180321_VISION_2)
//   autoApplyAll true/false × 작업 모드 DB_ONLY/DB_FE 4조합. 표본 8건마다 '승인 문장에 든 대상' 과 'autoEligible 이 승인으로 막음' 이 같은지 본다
//   사용: node test/t_impact_rule.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'imprule-')); const vibeDir = path.join(root, '.vibe');
const hj = path.join(root, 'tools', 'Harness', 'harness.json'); fs.mkdirSync(path.dirname(hj), { recursive: true });
const setH = (all, scope) => fs.writeFileSync(hj, JSON.stringify({ repairScope: scope, orch: { agentEnabled: false, autoApplyAll: all, coreAutoApply: true, visionAutoApply: true } }));
setH(true, 'DB_ONLY');
const p = { root, vibeDir, extDir: path.join(root, 'installed') };
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false });
const imp = require(path.join(dir, 'orch-improve'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
// [이름, 개선안, 승인 문장에서 찾을 낱말]
const S = [
  ['실행 hook 스크립트', { impact: 'fix', title: 'hook 수정', targets: ['.claude/hooks/check-work-mode.js'] }, '실행 hook 스크립트'],
  ['.claude/settings.json', { impact: 'fix', title: '설정', targets: ['.claude/settings.json'] }, '.claude/settings.json'],
  ['FE 소스', { impact: 'fix', title: '화면 수정', targets: ['nscm-fe/features/dm/src/pages/DMF0004/index.tsx'] }, 'FE·BE 소스'],
  ['DB 객체', { impact: 'fix', title: 'PKG 수정', targets: ['tools/CloudPkg/out/PKG_X.pkb'] }, 'DB 객체'],
  ['시험 계정 설정', { impact: 'fix', title: '계정', targets: ['tools/E2E/users.json'] }, '시험 계정 설정'],
  ['AS-IS 소스', { impact: 'fix', title: 'AS-IS', targets: ['GSCM/a.cs'] }, 'AS-IS 소스'],
  ['작업 모드 변경', { impact: 'fix', title: 'repairScope 를 DB_FE 로', before_after: 'repairScope DB_ONLY → DB_FE', targets: ['tools/Harness/harness.json'] }, '작업 모드(repairScope) 변경'],
  ['VM 코드', { impact: 'fix', title: '표시 수정', targets: ['tools/VibeManager/orch-vision.js'] }, 'tools/VibeManager'],
];
for (const [all, scope] of [[true, 'DB_ONLY'], [true, 'DB_FE'], [false, 'DB_ONLY'], [false, 'DB_FE']]) {
  setH(all, scope); const note = sc.approvalNote(); const part = (/사용자 승인은 (.*?)만\(/.exec(note) || [])[1] || '';
  chk(`[${all}/${scope}] 승인 문장 형식`, !!part && note.includes(`작업 모드 ${scope}`), note);
  for (const [name, pr, kw] of S) {
    const e = sc.autoEligible(pr); const listed = part.includes(kw);
    chk(`[${all}/${scope}] ${name}: 문장 ${listed ? '있음' : '없음'} = 판정 ${e.ok ? '자동' : '승인'}`, listed === !e.ok, e.why || '');
  }
  const rule = imp.IMPACT_RULE;
  chk(`[${all}/${scope}] IMPACT_RULE 마지막 문장 = approvalNote`, rule.endsWith(note) && rule.startsWith(imp.IMPACT_RULE_BASE.slice(0, 40)), rule.slice(-120));
}
chk('impactRule() 와 IMPACT_RULE 같음', imp.impactRule() === imp.IMPACT_RULE);
chk('core·fix 정의 유지', /core = VM 근간 로직 변경/.test(imp.IMPACT_RULE) && /fix = 결함 수정/.test(imp.IMPACT_RULE));
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
