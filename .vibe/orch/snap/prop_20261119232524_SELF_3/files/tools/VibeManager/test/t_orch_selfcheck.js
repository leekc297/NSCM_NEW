// orch-selfcheck.js: 실패 주입 4건(구문 · 설치본 차이 · 없는 작업 참조 · 등록 안 된 명령) → 사건 R12 · 고치면 사건 해결 · 설치 폴더 동기화 · 실행 오류 · 미확인 원장
//   사용: node test/t_orch_selfcheck.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'self-')); const vibeDir = path.join(root, '.vibe'); const vmd = path.join(root, 'tools', 'VibeManager'); const inst = path.join(root, 'installed');
const mk = (f, s) => { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s, 'utf8'); }; const NL = String.fromCharCode(10);
mk(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false, selfErrRepeat: 3, ghostKey: 1, tickSec: 30 } }));
mk(path.join(vmd, 'good.js'), "'use strict';\nconst x = require('./other');\nconst tickSec = 1; const agentEnabled = 1; const selfErrRepeat = 1;\nmodule.exports = { x, tickSec, agentEnabled, selfErrRepeat };\n");
mk(path.join(vmd, 'other.js'), 'module.exports = 1;\n');
mk(path.join(vmd, 'bad.js'), 'function broken( {\n');
mk(path.join(vmd, 'extension.js'), "const vscode = {}; vscode.commands = { registerCommand() {} };\nvscode.commands.registerCommand('vibeManager.one', () => {});\nconst gone = () => require('./missing-mod');\nconst c = cfg => cfg.get('usedSetting');\n");
mk(path.join(vmd, 'package.json'), JSON.stringify({ name: 'x', contributes: { commands: [{ command: 'vibeManager.one' }, { command: 'vibeManager.two' }], configuration: { properties: { 'vibeManager.usedSetting': {}, 'vibeManager.deadSetting': {} } } } }));
mk(path.join(vmd, 'steps.json'), JSON.stringify({ steps: [{ id: 'S1', tasks: [{ id: 'S1.run' }, { id: 'S8.verify' }] }] }));
mk(path.join(vmd, 'quick.json'), JSON.stringify({ groups: [{ items: [{ label: '🔎 CheckList', kind: 'chain', steps: [{ task: 'S8.verify' }, { task: 'S9.nope', claudeOf: '🧪 없는 메뉴' }] }, { label: 'A', task: 'S1.run', preTask: 'S1.run' }] }] }));
for (const f of ['good.js', 'other.js', 'bad.js', 'extension.js', 'package.json', 'steps.json', 'quick.json']) mk(path.join(inst, f), fs.readFileSync(path.join(vmd, f), 'utf8'));
mk(path.join(inst, 'other.js'), 'module.exports = 2; // 옛 판\n');
mk(path.join(vmd, 'CHANGELOG.md'), ['## (판 번호 없음, VM 저장소) 시험 절 (2026-11-19 10:00)', '- 확인(10:00 실행): 시험 3건. VS Code 실화면 미확인(창 다시 로드 필요).', '- 미확인: 실제 Claude 응답', '- 확인: node --check. VS Code 화면 미확인.'].join(NL));
mk(path.join(inst, 'CHANGELOG.md'), fs.readFileSync(path.join(vmd, 'CHANGELOG.md'), 'utf8'));

const p = { root, vibeDir, extDir: inst };
const errlog = require(path.join(dir, 'orch-errlog')); const watch = require(path.join(dir, 'orch-watch')); const st = require(path.join(dir, 'orch-state'));
const hist = require(path.join(dir, 'orch-history')); const sc = require(path.join(dir, 'orch-selfcheck'));
watch.init(p, {}); hist.init({ paths: () => p, sessionDirs: [] }); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const keys = (r, id) => r.checks[id].items.map(i => i.key);
(async () => {
  let r = await sc.run(['S1', 'S3', 'S4'], '시험');
  chk('S1 구문 오류 1건(bad.js)', r.checks.S1.status === 'fail' && keys(r, 'S1').join() === 'S1|bad.js', JSON.stringify(r.checks.S1.items));
  chk('S3 설치본 차이 1건(other.js)', r.checks.S3.status === 'fail' && keys(r, 'S3').join() === 'S3|other.js' && r.checks.S3.info.compared === 8, JSON.stringify(r.checks.S3));
  const k4 = keys(r, 'S4');
  chk('S4 없는 작업 · 없는 메뉴 · 등록 안 된 명령 · 없는 모듈', k4.includes('S4|task|S9.nope') && k4.includes('S4|label|🧪 없는 메뉴') && k4.includes('S4|cmd|vibeManager.two') && k4.includes('S4|req|extension.js|./missing-mod') && k4.length === 4, JSON.stringify(k4));
  let incs = watch.list().filter(x => x.rule === 'R12');
  chk('사건 R12 6건(S1 1 · S3 1 · S4 4) · 제목에 항목 이름', incs.length === 6 && incs.every(x => x.status === 'open') && incs.some(x => /S1 구문: bad\.js/.test(x.title)), incs.map(x => x.title).join(' | '));
  r = await sc.run(['S1', 'S3', 'S4'], '시험 2회');
  chk('같은 실패 다시 점검 = 새 사건 없음', watch.list().filter(x => x.rule === 'R12').length === 6 && r.newIncidents.length === 0);
  // 고침: 구문 오류 제거 · 설치 폴더 동기화
  fs.writeFileSync(path.join(vmd, 'bad.js'), 'module.exports = 0;\n');
  const sy = sc.syncInstalled('시험', 'selftest');
  chk('동기화: 다른 파일 2개 복사 · 설치본 백업', sy.ok && sy.copied.sort().join() === 'bad.js,other.js' && fs.readdirSync(inst).filter(f => /^other\.js\.bak_\d{8}_selftest$/.test(f)).length === 1 && fs.readFileSync(path.join(inst, 'other.js'), 'utf8') === 'module.exports = 1;\n', JSON.stringify(sy));
  r = await sc.run(['S1', 'S3'], '시험 3회');
  incs = watch.list().filter(x => x.rule === 'R12');
  chk('고친 뒤 S1 · S3 통과 · 그 사건 2건 해결 · S4 사건 4건 그대로', r.checks.S1.status === 'ok' && r.checks.S3.status === 'ok' && incs.filter(x => x.status === 'resolved').length === 2 && incs.filter(x => x.status === 'open').length === 4, incs.map(x => `${x.evidence.check}:${x.status}`).join(','));
  // S5 실행 오류: 새 서명 1건 → fail, 같은 서명 다시 점검 = 기준 미만이면 통과
  errlog.note('orch-watch', 'tick', new Error('boom 12'));
  r = await sc.run(['S5'], '시험'); chk('S5 새 오류 서명 = 실패 1건', r.checks.S5.status === 'fail' && r.checks.S5.count === 1 && /새 서명/.test(r.checks.S5.items[0].what), JSON.stringify(r.checks.S5.items));
  r = await sc.run(['S5'], '시험'); chk('S5 본 서명 1회 = 통과(3회 미만)', r.checks.S5.status === 'ok' && r.checks.S5.info.week === 1);
  // S6 미확인 원장
  r = await sc.run(['S6'], '시험'); chk('S6 이력 수집 전 = 건너뜀', r.checks.S6.status === 'skip');
  await hist.collect(); r = await sc.run(['S6', 'S9'], '시험');
  const rows = sc.ledger(); chk('S6 미확인 3건 · 다시 로드 필요 2건', r.checks.S6.status === 'warn' && rows.length === 3 && rows.filter(x => x.reload).length === 2 && r.checks.S6.info.open === 3 && r.checks.S6.info.reloadOpen === 2, JSON.stringify(rows.map(x => x.text)));
  const vsRow = rows.find(x => x.text === 'VS Code 화면 미확인.'); chk("'VS Code 화면 미확인.' 항목 = reload true(2026-11-19 SELF_2)", !!vsRow && vsRow.reload === true, JSON.stringify(vsRow));
  fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true }); fs.appendFileSync(path.join(vibeDir, 'orch', 'activations.jsonl'), JSON.stringify({ ms: Date.parse('2026-11-19T11:00:00+09:00') }) + NL);
  chk('창 로드 기록이 절 시각 뒤 = 로드 표시', sc.ledger().find(x => x.reload).loaded !== '');
  sc.markUnverified(rows[0].key, 'confirmed', '사용자', '확인함'); r = await sc.run(['S6'], '시험');
  chk('확인 처리 뒤 열림 2건', r.checks.S6.info.open === 2 && r.checks.S6.info.confirmed === 1);
  // S7 · S12
  watch.tick(); r = await sc.run(['S7', 'S12'], '시험');
  chk('S7 감시기 tick 시각 · 규칙별 건수', r.checks.S7.info.started === true && !!r.checks.S7.info.lastTickAt && r.checks.S7.info.byRule.R12 === 7 /* S1 1 · S3 1 · S4 4 · S5 1 */, JSON.stringify(r.checks.S7.info));
  const k12 = keys(r, 'S12'); chk('S12 읽는 코드 없는 설정 2건', k12.includes('S12|orch|ghostKey') && k12.includes('S12|cfg|vibeManager.deadSetting') && k12.length === 2, JSON.stringify(k12));
  const g = await sc.gate(); chk('게이트: 시험 실행기 없음 = 통과 아님 · S4 실패 표시', g.ok === false && g.bad.includes('S4'), g.text);
  const h = fs.readFileSync(path.join(vibeDir, 'orch', 'selfcheck', 'history.jsonl'), 'utf8').trim().split(NL);
  chk('회차 기록', h.length >= 9 && JSON.parse(h[0]).status.S1 === 'fail:1');
  // tick(): VM 파일을 바꾼 직후에는 가벼운 점검에서 S3 를 빼고, selfSettleSec 뒤 무거운 점검에서 판정한다
  const selfF = path.join(vibeDir, 'orch', 'selfcheck'); const resNow = () => JSON.parse(fs.readFileSync(path.join(selfF, 'result.json'), 'utf8')); const r12 = () => watch.list().filter(x => x.rule === 'R12').length;
  const setCfg = o => mk(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: Object.assign({ agentEnabled: false, selfErrRepeat: 3, tickSec: 30, selfDiagOnFail: false, selfAutoApply: false, selfLightMin: 0 }, o) }));
  mk(path.join(selfF, 'diag_meta.json'), JSON.stringify({ lastMs: Date.now() })); // 하루 1회 진단(Claude 호출)이 시험에서 돌지 않게 함
  setCfg({ selfSettleSec: 120 }); await sc.tick(); // 첫 tick = 무거운 점검(기준 지문 기록)
  let rn = resNow(); const ran1 = fs.readFileSync(path.join(selfF, 'history.jsonl'), 'utf8').trim().split(NL).slice(-2).map(l => JSON.parse(l).ran); // 첫 tick 은 무거운 점검 뒤 하루 1회 점검(S10 S6 S9)도 돌린다
  chk('tick 첫 회 = 무거운 점검 · S3 통과', ran1[0].includes('S1') && ran1[0].includes('S3') && ran1[1].join() === 'S10,S6,S9' && rn.checks.S3.status === 'ok', JSON.stringify(ran1));
  const n0 = r12(); const at0 = rn.checks.S3.at; await new Promise(x => setTimeout(x, 1100));
  fs.appendFileSync(path.join(vmd, 'good.js'), '// 수정 중\n'); await sc.tick(); rn = resNow();
  chk('파일 변경 직후 tick = S3 뺀 가벼운 점검 · R12 사건 수 그대로 · S3 시각 그대로', !rn.ran.includes('S3') && rn.ran.includes('S5') && !rn.ran.includes('S1') && r12() === n0 && rn.checks.S3.at === at0 && rn.checks.S3.status === 'ok', `${JSON.stringify(rn.ran)} R12 ${n0}→${r12()} S3 ${at0}→${rn.checks.S3.at}`);
  setCfg({ selfSettleSec: 0 }); await sc.tick(); rn = resNow();
  chk('selfSettleSec 지난 뒤 tick = 무거운 점검에서 S3 판정 · R12 1건 추가', rn.ran.includes('S1') && rn.ran.includes('S3') && rn.checks.S3.status === 'fail' && rn.checks.S3.items.map(i => i.key).join() === 'S3|good.js' && rn.checks.S3.at !== at0 && r12() === n0 + 1, `${JSON.stringify(rn.ran)} R12 ${n0}→${r12()} ${JSON.stringify(rn.checks.S3.items.map(i => i.key))}`);
  await sc.tick(); rn = resNow();
  chk('무거운 점검 뒤 tick = 가벼운 점검에 S3 포함 · 새 사건 없음', rn.ran.includes('S3') && !rn.ran.includes('S1') && r12() === n0 + 1, JSON.stringify(rn.ran));
  sc.dispose(); watch.dispose(); st.dispose(); await new Promise(x => setTimeout(x, 100)); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
