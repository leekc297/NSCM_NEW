// 2026-11-26 사용자 지시('VMO 가 지금 하고 있는 보완 작업을 자가검진해서 보완 · 자동 승인 · 승인 가이드 완화') 시험 — 임시 폴더, Claude 호출 없음
//   ① S16 항목 만들기(탐지기 행 0 은 빼고 · 묶음 포함 · 전부 warn) ② 새 항목 = 처음 보거나 행 수가 늘어난 것 ③ 진단 지시문에 사용자 결정 예외·미검증 원칙·engine_selfcheck 검증
//   ④ 자동 반영 대상: .claude/agents·.claude/skills·.vibe/orch 자동 · 실행 hook 은 승인 · FE·BE 는 작업 모드(DB_FE 자동 · DB_ONLY 승인)
//   사용: node test/t_checkerscan.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const cs = require(path.join(dir, 'orch-checkerscan'));
const j = { detectors: [{ id: 'K1', name: '한 글자', rows: 3, screens: ['A'], samples: [] }, { id: 'K2', name: '반복', rows: 0, screens: [], samples: [] }],
  clusters: [{ rule_id: 'D1', result: 'ERROR', sig: '조건 평가 불가 <C>', rows: 40, screens: ['A', 'B'], samples: [] }] };
const it = cs.itemsFrom(j);
chk('① 행 0 탐지기 제외 · 묶음 포함', it.length === 2 && it.some(x => x.key === 'S16|K1') && it.some(x => x.key.startsWith('S16|C|D1|')), JSON.stringify(it.map(x => x.key)));
chk('① 전부 warn', it.every(x => x.level === 'warn'));
chk('② 처음 보는 항목 = 새 항목', cs.newItems(it, {}).length === 2);
chk('② 행 수 같으면 새 항목 아님 · 늘면 새 항목', cs.newItems(it, { 'S16|K1': { rows: 3 }, [it[1].key]: { rows: 39 } }).map(x => x.key).join() === it[1].key);
const dp = cs.diagPrompt('.vibe/orch/selfcheck/checker_diag_in.json');
chk('③ 지시문 = 읽기 전용 · 사용자 결정 예외 · 미검증 원칙 · engine_selfcheck', /고치지 않는다/.test(dp) && /checker_scan_ignore\.csv/.test(dp) && /미검증\(ERROR\)/.test(dp) && /engine_selfcheck\.py/.test(dp));

// ④ 자동 반영 대상
const mk = scope => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'chkscan-')); const vibeDir = path.join(root, '.vibe');
  fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ repairScope: scope, orch: { agentEnabled: false, coreAutoApply: true } }));
  return { root, vibeDir, extDir: path.join(root, 'installed'), claude: 'none', claudeModel: '' };
};
const loadSc = p => { for (const k of Object.keys(require.cache)) if (/orch-selfcheck/.test(k)) delete require.cache[k]; const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false }); return sc; };
const pr = t => ({ id: 'x', title: '검사기 결함 수정', impact: 'fix', source: 'self', targets: [t], before_after: 'a → b' });
let sc = loadSc(mk('DB_ONLY'));
chk('④ .claude/agents 자동', sc.autoEligible(pr('.claude/agents/vm-orchestra.md')).ok === true, JSON.stringify(sc.autoEligible(pr('.claude/agents/vm-orchestra.md'))));
chk('④ .claude/skills 자동', sc.autoEligible(pr('.claude/skills/vmo-diagnosis-ladder/SKILL.md')).ok === true);
chk('④ .vibe/orch 상태 파일 자동', sc.autoEligible(pr('.vibe/orch/purpose_ledger.json')).ok === true);
chk('④ 실행 hook 은 승인', sc.autoEligible(pr('.claude/hooks/check-x.ps1')).ok === false);
chk('④ DB 객체는 승인', sc.autoEligible(pr('tools/CloudPkg/out/PKG_X.sql')).ok === false);
chk('④ DB MODE 에서 FE 는 승인', sc.autoEligible(pr('nscm-fe/features/a/b.tsx')).ok === false);
sc.dispose && sc.dispose();
sc = loadSc(mk('DB_FE'));
chk('④ UI/DB MODE 에서 FE·BE 자동', sc.autoEligible(pr('nscm-fe/features/a/b.tsx')).ok === true && sc.autoEligible(pr('nscm-be/src/main/A.java')).ok === true);
sc.dispose && sc.dispose();
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
