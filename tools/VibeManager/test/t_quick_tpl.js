// quick.json 체인 단계 틀 시험(2026-11-26 개선안 20261126164547_SELF): quick-tpl.js expand, prompt-panel.js loadQuick
//   확인: ① { use } 가 모두 펼쳐짐(없는 틀 0) ② 틀을 쓰는 곳 수, rerunTask 'S8.checklistSettle' 원문 1곳
//         ③ 반영 전 사본(quick.json.bak_20261126_sw)이 있으면 체인마다 단계 수, 단계별 task, args, repair 와 단계 전체 내용이 같음
//         ④ loadQuick 이 펼친 결과를 돌려줌(VM 메뉴, 체인 실행, VMW 일괄 실행 공통) ⑤ 없는 틀 이름 = 그 단계 그대로 + 오류 기록
//   사용: node test/t_quick_tpl.js <VibeManager 폴더>
'use strict';
const fs = require('fs'); const path = require('path'); const os = require('os');
const Module = require('module'); const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? stub : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const rd = f => JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, ''));
const tpl = require(path.join(dir, 'quick-tpl.js'));
const chains = o => o.groups.flatMap(g => g.items || []).filter(i => Array.isArray(i.steps));
// 변환기(quick_tpl_apply.js)를 임시 폴더의 사본에 돌려 변환 결과를 봄(저장소 quick.json 이 변환 전이든 뒤든 같은 시험)
//   설치 폴더에는 변환기를 두지 않음(설치본 quick.json 을 바꾸지 않게). 변환기가 없으면 ①~③ 건너뜀
if (!fs.existsSync(path.join(dir, 'quick_tpl_apply.js'))) { console.log('PASS 변환기 없는 폴더(설치 폴더) · ①~③ 건너뜀, ④⑤ 만 봄'); }
else (function convTest() {
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'qtpl-conv-'));
for (const n of ['quick.json', 'quick_tpl_apply.js']) fs.copyFileSync(path.join(dir, n), path.join(tmp, n));
const conv = require('child_process').spawnSync(process.execPath, [path.join(tmp, 'quick_tpl_apply.js')], { encoding: 'utf8' });
const raw = rd(path.join(tmp, 'quick.json')); const q = tpl.expand(raw);
const uses = chains(raw).flatMap(c => c.steps.filter(s => s && s.use));
chk('① 변환 뒤 펼치면 { use } 0, 없는 틀 0', conv.status === 0 && chains(q).every(c => c.steps.every(s => !(s && s.use))) && !(q._tplErrors || []).length, `${String(conv.stdout).trim()} ${(q._tplErrors || []).join(' / ')}`);
const rawText = fs.readFileSync(path.join(tmp, 'quick.json'), 'utf8');
chk('② 틀 unverifiedLoop 1곳 정의, 체인이 부르는 곳 9, rerunTask S8.checklistSettle 원문 1곳', !!(raw.stepTemplates && raw.stepTemplates.unverifiedLoop) && uses.filter(s => s.use === 'unverifiedLoop').length === 9 && (rawText.match(/"rerunTask": "S8\.checklistSettle"/g) || []).length === 1, `use ${uses.length}, rerunTask ${(rawText.match(/"rerunTask": "S8\.checklistSettle"/g) || []).length}`);
const again = require('child_process').spawnSync(process.execPath, [path.join(tmp, 'quick_tpl_apply.js'), '--check'], { encoding: 'utf8' });
chk('② 변환 2번째 = 바꿀 곳 0(같은 결과)', /바꿀 곳 0|바꿀 묶음 없음/.test(again.stdout), String(again.stdout).trim());
// ③ 변환 전(저장소 quick.json 을 펼친 것)과 변환 뒤 펼친 것 비교
{
  const before = tpl.expand(rd(path.join(dir, 'quick.json'))); const bc = chains(before); const ac = chains(q); let diff = [];
  const strip = s => JSON.stringify(s);
  if (bc.length !== ac.length) diff.push(`체인 수 ${bc.length} → ${ac.length}`);
  for (const b of bc) { const a = ac.find(x => x.label === b.label); if (!a) { diff.push(`없어진 체인 ${b.label}`); continue; }
    if (a.steps.length !== b.steps.length) { diff.push(`${b.label} 단계 수 ${b.steps.length} → ${a.steps.length}`); continue; }
    b.steps.forEach((s, i) => { const t = a.steps[i]; if (s.task !== t.task || strip(s.args) !== strip(t.args) || strip(s.repair) !== strip(t.repair) || strip(s) !== strip(t)) diff.push(`${b.label} ${i + 1}단계`); }); }
  // 체인 밖 항목(메뉴 정의)은 틀 반영으로 바뀌지 않음: steps 를 뺀 나머지가 같음
  const noSteps = o => strip(o.groups.map(g => Object.assign({}, g, { items: (g.items || []).map(i => Object.assign({}, i, { steps: undefined })) })));
  if (noSteps(before) !== noSteps(q)) diff.push('체인 밖 항목 다름');
  chk(`③ 변환 전과 같음: 체인 ${bc.length}개, 단계 ${bc.reduce((n, c) => n + c.steps.length, 0)}개(단계 수, task, args, repair, 전체 내용)`, !diff.length, diff.slice(0, 5).join(' / '));
  if (diff.length || bc.length === 0) ok = false;
}
try { fs.rmSync(tmp, { recursive: true, force: true }); } catch { /* 임시 */ }
})();
const q = tpl.expand(rd(path.join(dir, 'quick.json')));
// ④ loadQuick
try { const pp = require(path.join(dir, 'prompt-panel.js')); const root = fs.mkdtempSync(path.join(os.tmpdir(), 'qtpl-'));
  const lq = pp.loadQuick(dir, root); chk('④ prompt-panel.loadQuick = 펼친 결과', chains(lq).length === chains(q).length && chains(lq).every(c => c.steps.every(s => !(s && s.use))) && JSON.stringify(chains(lq).map(c => c.steps)) === JSON.stringify(chains(q).map(c => c.steps)));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { /* 임시 */ } } catch (e) { chk('④ prompt-panel 불러오기', false, e.message); }
// ⑤ 없는 틀
{ const t = { stepTemplates: { a: { steps: [{ task: 'X' }, { task: 'Y' }] } }, groups: [{ items: [{ label: 'c', steps: [{ task: 'P' }, { use: 'a' }, { use: 'zz' }] }] }] };
  const e = tpl.expand(t); chk('⑤ 틀 펼침 순서 유지, 없는 틀은 그대로 + 오류 1건, 원본 안 바뀜', e.groups[0].items[0].steps.map(s => s.task || s.use).join() === 'P,X,Y,zz' && e._tplErrors.length === 1 && t.groups[0].items[0].steps.length === 3);
  const e2 = tpl.expand(t); e2.groups[0].items[0].steps[1].task = 'CHANGED'; chk('⑤ 펼친 단계는 사본(틀 원문 안 바뀜)', t.stepTemplates.a.steps[0].task === 'X'); }
// 체인 단계 task 참조(S4 와 같은 기준): 펼친 뒤 모든 task 가 steps.json 에 있음
{ const steps = rd(path.join(dir, 'steps.json')); const ids = new Set(); (function walk(o) { if (Array.isArray(o)) return o.forEach(walk); if (!o || typeof o !== 'object') return; if (typeof o.id === 'string' && (o.script || o.kind)) ids.add(o.id); Object.values(o).forEach(walk); })(steps);
  const miss = chains(q).flatMap(c => c.steps.filter(s => s.task && !ids.has(s.task)).map(s => `${c.label}:${s.task}`)); const rmiss = chains(q).flatMap(c => c.steps.filter(s => s.repair && s.repair.rerunTask && !ids.has(s.repair.rerunTask)).map(s => s.repair.rerunTask));
  chk('펼친 체인의 task, repair.rerunTask 가 steps.json 에 있음', !miss.length && !rmiss.length, miss.concat(rmiss).slice(0, 5).join(', ')); }
// ⑥ 틀 풀이 전 사본(test/fixtures/quick_chains_before_tpl_20261126.json = 17:47:12 변환 직전 quick.json 체인)과 대조
//   틀로 부르는 자리마다 펼친 단계가 변환 전 같은 자리 단계와 같음(task, args, title, optional, 조건 필드 ifJsonGt, ifMissing, okCodes, verify, repair, 단계 전체)
//   🚒 자동보완(chainId autofix-full) = 단계 수 15, 단계별 task 순서, 3~5단계와 10~12단계가 변환 전과 같음
{ const fx = path.join(__dirname, 'fixtures', 'quick_chains_before_tpl_20261126.json');
  if (!fs.existsSync(fx)) console.log('PASS ⑥ 변환 전 사본 없음(설치 폴더) · 건너뜀');
  else {
    const before = rd(fx).chains; const cur = tpl.expand(rd(path.join(dir, 'quick.json'))); const rawc = chains(rd(path.join(dir, 'quick.json')));
    const F = ['task', 'args', 'title', 'optional', 'ifJsonGt', 'ifMissing', 'okCodes', 'verify', 'repair'];
    const diff = [];
    for (const rc of rawc) { const b = before.find(x => x.label === rc.label); if (!b) continue;
      let ai = 0, bi = 0; // 원문 단계를 따라가며 틀 자리만 대조(틀 밖 단계는 두 쪽 모두 1칸)
      const ec = chains(cur).find(x => x.label === rc.label);
      for (const s of rc.steps) {
        const n = s && s.use ? ((cur.stepTemplates || {})[s.use] || rd(path.join(dir, 'quick.json')).stepTemplates[s.use]).steps.length : 1;
        if (s && s.use) for (let k = 0; k < n; k++) { const e = ec.steps[ai + k], o = b.steps[bi + k]; if (!o) { diff.push(`${rc.label} ${ai + k + 1}단계 변환 전에 없음`); continue; }
          for (const f of F) if (JSON.stringify(e[f]) !== JSON.stringify(o[f])) diff.push(`${rc.label} ${ai + k + 1}단계 ${f}`);
          if (JSON.stringify(e) !== JSON.stringify(o)) diff.push(`${rc.label} ${ai + k + 1}단계 전체`); }
        ai += n; bi += n;
      } }
    const useN = rawc.reduce((n, c) => n + c.steps.filter(s => s && s.use).length, 0);
    chk(`⑥ 틀 자리 펼친 단계 = 변환 전 같은 자리(${useN}곳, 필드 ${F.join(', ')})`, !diff.length, diff.slice(0, 5).join(' / '));
    const af = chains(cur).find(c => c.chainId === 'autofix-full'); const ab = before.find(c => c.chainId === 'autofix-full');
    const pick = (c, i) => JSON.stringify(F.map(f => c.steps[i][f]));
    chk('⑥ 🚒 자동보완: 단계 수 15, task 순서 같음', !!af && !!ab && af.steps.length === 15 && ab.steps.length === 15 && af.steps.map(s => s.task || s.claudeOf).join() === ab.steps.map(s => s.task || s.claudeOf).join(), af && af.steps.map(s => s.task || s.claudeOf).join());
    chk('⑥ 🚒 자동보완: 3~5단계, 10~12단계 = 변환 전과 같음(S8.unverified, S8.unverifiedGate --gate, S8.verify 재검증 1회)', !!af && [2, 3, 4, 9, 10, 11].every(i => pick(af, i) === pick(ab, i) && JSON.stringify(af.steps[i]) === JSON.stringify(ab.steps[i])) && af.steps[3].args.join(' ') === '${input:ids} --gate' && af.steps[10].args.join(' ') === '${input:ids} --gate');
  } }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
