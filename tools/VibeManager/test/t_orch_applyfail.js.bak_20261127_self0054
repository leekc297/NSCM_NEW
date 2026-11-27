// 2026-11-23 사용자 지시 'VMO EVENTS 반영 실패 사유 찾아 보완' 시험 — 임시 폴더, 실제 Claude 호출 없음
//   ① 게이트 항목 비교는 PASS, FAIL 건수를 뺀 키(시험을 늘린 개선안이 반영 전 실패를 새 실패로 세던 12:46, 16:18 실패)
//   ② 반영 실패 때 AI 가 대상 밖에 만든 새 파일 = .bak_failed_<개선안> 으로 치움, 대상 밖 기존 파일 = AI 편집만 되돌림, AI 가 안 쓴 파일 = 그대로(12:11 되돌림 뒤 남은 시험 2개)
//   ③ .claude/settings.json 이 든 안 = 자동 반영 대상 아님, 승인해도 AI 를 부르지 않음(18:12 acceptEdits 권한 거부)
//   사용: node test/t_orch_applyfail.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'applyfail-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8'); const has = rel => fs.existsSync(path.join(root, rel));
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, coreAutoApply: true } }));
const p = { root, vibeDir, extDir: path.join(root, 'installed'), claude: 'none', claudeModel: '' };
const ev = require(path.join(dir, 'orch-events')); ev.init(vibeDir);
const agent = require(path.join(dir, 'orch-agent')); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const im = require(path.join(dir, 'orch-improve')); im.init({ notify: () => { } });
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  // ① 게이트 키
  const gk = im._gateKey;
  const pre = 'S2 t_orch_usercheck.js 실패: exit 1 · PASS 133 · FAIL 1 · FAIL U3 장부 막힘 2건 = 실패 1항목(S13|U3|worklist) [] / SOME FAIL';
  const post = 'S2 t_orch_usercheck.js 실패: exit 1 · PASS 137 · FAIL 1 · FAIL U3 장부 막힘 2건 = 실패 1항목(S13|U3|worklist) [] / SOME FAIL';
  chk('① 같은 실패, PASS 건수만 다름 = 같은 키', gk(pre) === gk(post), gk(post));
  chk('① 실패 내용이 다르면 다른 키', gk(pre) !== gk(post.replace('U3 장부', 'U5 장부')));
  chk('① 실패 이름의 숫자(U3, R12)는 남김', /FAIL U3 장부/.test(gk(post)) && !/PASS \d/.test(gk(post)));
  chk('① S2 밖 항목은 그대로', gk('S4 inventory_check CHAIN_FILES: 없는 파일 1 - run_verify.py:451 x.py') === 'S4 inventory_check CHAIN_FILES: 없는 파일 1 - run_verify.py:451 x.py');

  // ② 대상 밖 정리
  const tgt = 'tools/VibeManager/orch-x.js'; W(tgt, "module.exports = { a: 1 };\n");
  const oldRel = 'tools/VibeManager/test/t_old.js'; W(oldRel, "// 시험\nconst n = 1;\n");
  const otherRel = 'tools/VibeManager/other.js'; W(otherRel, "// 다른 세션 파일\n");
  await new Promise(r => setTimeout(r, 50));
  const pr = { id: 'P_TEST', applyStartMs: Date.now() };
  await new Promise(r => setTimeout(r, 50));
  const newRel = 'tools/VibeManager/orch-new.js'; const newTest = 'tools/VibeManager/test/t_new.js';
  W(newRel, "module.exports = {};\n"); W(newTest, "console.log('ALL PASS');\n");
  fs.writeFileSync(path.join(root, oldRel), "// 시험\nconst n = 1;\nconst u3 = 'worklist';\n");
  fs.appendFileSync(path.join(root, otherRel), "// 다른 세션이 반영 중에 고침\n");
  const ab = f => path.join(root, f).replace(/\\/g, '/');
  const lines = [
    { type: 'assistant', message: { content: [{ type: 'tool_use', id: 't1', name: 'Write', input: { file_path: ab(newRel), content: 'module.exports = {};\n' } }] } },
    { type: 'assistant', message: { content: [{ type: 'tool_use', id: 't2', name: 'Write', input: { file_path: ab(newTest), content: "console.log('ALL PASS');\n" } }] } },
    { type: 'assistant', message: { content: [{ type: 'tool_use', id: 't3', name: 'Edit', input: { file_path: ab(oldRel), old_string: 'const n = 1;\n', new_string: "const n = 1;\nconst u3 = 'worklist';\n" } }] } },
    { type: 'assistant', message: { content: [{ type: 'tool_use', id: 't4', name: 'Edit', input: { file_path: ab(tgt), old_string: 'a: 1', new_string: 'a: 2' } }] } },
  ];
  const logRel = '.vibe/logs/x_claude_orch.log'; W(logRel, lines.map(x => JSON.stringify(x)).join('\n') + '\n');
  const snap = { kept: [tgt], absent: [] };
  const ro = im._revertOutside(pr, [tgt, newRel, newTest, oldRel, otherRel, 'nscm-fe/src/a.ts'], snap, logRel);
  chk('② AI 가 만든 새 파일 2개 = 치움', !has(newRel) && !has(newTest) && has(`${newRel}.bak_failed_P_TEST`) && has(`${newTest}.bak_failed_P_TEST`) && ro.moved.length === 2, JSON.stringify(ro.moved));
  chk('② 대상 밖 기존 파일 = AI 편집만 되돌림', R(oldRel) === "// 시험\nconst n = 1;\n" && ro.undone.includes(oldRel), JSON.stringify(R(oldRel)));
  chk('② AI 가 안 쓴 파일(다른 세션) = 그대로', /다른 세션이 반영 중에 고침/.test(R(otherRel)));
  chk('② 대상 파일은 건드리지 않음(restoreTargets 몫)', /a: 1/.test(R(tgt)));
  chk('② 기록 문구에 치운 파일과 되돌린 파일', /대상 밖 새 파일 2개 치움/.test(ro.note) && /AI 편집 되돌림/.test(ro.note), ro.note);
  chk('② 실행 기록이 없으면 아무것도 안 함', im._revertOutside(pr, [otherRel], snap, '').note === '');

  // ④ 2026-11-25 git 이 추적하는 기존 파일을 AI 가 통째로 다시 써도(생성 시각이 반영 뒤) 치우지 않음(07:20 extension.js 사고)
  const cp = require('child_process'); const g = (...a) => cp.spawnSync('git', ['-c', 'user.name=t', '-c', 'user.email=t@t', ...a], { cwd: root, windowsHide: true });
  const trk = 'tools/VibeManager/extension_t.js'; W(trk, '// 기존\nconst a = 1;\n');
  const gi = g('init', '-q'); g('add', trk); g('commit', '-q', '-m', 't');
  if (gi.status === 0) {
    fs.writeFileSync(path.join(root, trk), '// 기존\nconst a = 2;\n');
    const log2 = '.vibe/logs/y_claude_orch.log'; W(log2, JSON.stringify({ type: 'assistant', message: { content: [{ type: 'tool_use', id: 'w1', name: 'Write', input: { file_path: ab(trk), content: '// 기존\nconst a = 2;\n' } }] } }) + '\n');
    const ro2 = im._revertOutside({ id: 'P_TRK', applyStartMs: 1 }, [trk], { kept: [], absent: [] }, log2);
    chk('④ git 추적 파일 = 생성 시각이 뒤여도 치우지 않음(이름 그대로)', has(trk) && !has(`${trk}.bak_failed_P_TRK`) && !ro2.moved.includes(trk), JSON.stringify(ro2));
    const nf = 'tools/VibeManager/brand_new.js'; W(nf, 'x'); const log3 = '.vibe/logs/z_claude_orch.log'; W(log3, JSON.stringify({ type: 'assistant', message: { content: [{ type: 'tool_use', id: 'w2', name: 'Write', input: { file_path: ab(nf), content: 'x' } }] } }) + '\n');
    const ro3 = im._revertOutside({ id: 'P_NEW', applyStartMs: 1 }, [nf], { kept: [], absent: [] }, log3);
    chk('④ git 저장소 안에서도 추적 안 되는 새 파일은 종전처럼 치움', !has(nf) && has(`${nf}.bak_failed_P_NEW`), JSON.stringify(ro3.moved));
  } else chk('④ git 없음 → 건너뜀', true);
  // ③ .claude/settings.json
  const base = { id: 'P_SET', source: 'self', impact: 'fix', status: 'pending', title: 'hook 등록', targets: ['tools/VibeManager/orch-x.js', '.claude/settings.json'] };
  const e1 = sc.autoEligible(base);
  chk('③ 대상에 .claude/settings.json = 자동 반영 대상 아님', e1.ok === false && /Claude 반영 세션이 고칠 수 없음/.test(e1.why), e1.why);
  chk('③ 코드 대상만이면 자동 반영 대상', sc.autoEligible(Object.assign({}, base, { targets: ['tools/VibeManager/orch-x.js'] })).ok === true);
  chk('③ harness.json 은 그대로 자동(coreAutoApply)', sc.autoEligible(Object.assign({}, base, { targets: ['tools/Harness/harness.json'] })).ok === true);
  const added = im.add(Object.assign({}, base, { id: undefined }));
  const pid = (added && (added.id || (added.proposal && added.proposal.id))) || (im.list().find(x => x.title === 'hook 등록') || {}).id;
  const r = pid ? await im.approve(pid, '사용자') : { ok: true, why: '추가 실패' };
  const after = pid ? im.get(pid) : null;
  chk('③ 사람이 승인해도 AI 를 부르지 않고 이유를 남김', r.ok === false && /acceptEdits/.test(r.why) && after && after.status === 'pending' && (after.history || []).some(h => /고칠 수 없어 반영하지 않음/.test(h.what)), JSON.stringify(r));
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e && e.stack); process.exit(1); });
