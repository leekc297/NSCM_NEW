// 2026-11-26 개선안 20261126164547_SELF (L3, 묶음 S-W): quick.json 체인 공통 단계 틀
//   종전: 미검증 해소 3단계(S8.unverified, S8.unverifiedGate, S8.verify 재검증 1회)를 체인 5개 9곳에 복사해 둠. 규칙이 바뀔 때마다 9곳을 고침(11-25 21:56, 11-26 14:20, 15:02).
//   변경: quick.json 최상위 stepTemplates.<이름> = { desc, steps: [...] } 에 한 번 두고, 체인 단계는 { "use": "<이름>" } 로 부름.
//   읽을 때 expand() 가 틀의 steps 사본으로 펼침. 펼친 결과는 종전 정의와 단계 수, 단계 내용이 같음(test/t_quick_tpl.js 가 반영 전 사본과 비교).
//   읽는 곳: prompt-panel.js loadQuick(VM 메뉴, 체인 실행, VMW 일괄 실행이 모두 이것을 씀)
'use strict';

const clone = v => JSON.parse(JSON.stringify(v));

/** 체인 단계 배열 펼치기. 없는 틀 이름은 그 단계를 그대로 두고 errors 에 남김 */
function expandSteps(steps, tpls, errors, where) {
  if (!Array.isArray(steps)) return steps;
  const out = [];
  for (const s of steps) {
    if (s && typeof s === 'object' && typeof s.use === 'string' && !s.task && !s.claudeOf) {
      const t = tpls[s.use];
      if (!t || !Array.isArray(t.steps)) { errors.push(`${where}: 없는 단계 틀 '${s.use}'`); out.push(s); continue; }
      for (const x of t.steps) out.push(clone(x));
      continue;
    }
    out.push(s);
  }
  return out;
}

/** quick.json 객체를 받아 체인 steps 의 { use } 를 펼친 새 객체를 돌려줌(원본은 바꾸지 않음). 결과 _tplErrors = 펼치지 못한 곳 */
function expand(q) {
  if (!q || typeof q !== 'object' || !q.stepTemplates || !Array.isArray(q.groups)) return q;
  const tpls = q.stepTemplates; const errors = [];
  const out = Object.assign({}, q, { groups: q.groups.map(g => Object.assign({}, g, { items: (g.items || []).map(it => (it && Array.isArray(it.steps) ? Object.assign({}, it, { steps: expandSteps(it.steps, tpls, errors, `메뉴 '${it.label || ''}'`) }) : it)) })) });
  if (errors.length) Object.defineProperty(out, '_tplErrors', { value: errors, enumerable: false });
  return out;
}

module.exports = { expand, expandSteps };
