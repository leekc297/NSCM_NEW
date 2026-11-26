// 2026-11-20 T499(SCP0028 G1 V-dd4f9db4 From Site '결과 컬럼 FROM_SITE_DESCRIPTION 값에서 고를 후보를 못 찾아 임의 후보 선택' → 0행 ERROR):
//   다중 선택 조건의 후보 글자는 코드('AU000062_81-P')인데 라벨로 찾은 결과 컬럼(FROM_SITE_DESCRIPTION)은 설명이라 겹치는 값이 없었다.
//   같은 그리드의 숨은 코드 컬럼(FROM_SITE · header 'From Site' · visible false)은 후보와 값이 겹친다.
//   T385(_trace.spec.ts:1496 SSP0014)는 콤보 응답 코드·이름 쌍으로 결과 값을 환산했으나 이 화면 콤보는 CODE=NAME 이라 환산이 안 된다.
//   → 후보 글자(전체 또는 첫 토큰)와 값이 가장 많이 겹치는 컬럼(숨김 포함)을 고르고, 그 컬럼에서 가장 드문 값의 후보를 고른다. 순수 함수(condcol.selftest.js)
export type CondColPick = { col: string; cand: string; value: string; hits: number; how: string };

const ALL_RX = /^(select all|all|전체|\(all\))$/i;

/** opts = 콤보 후보 글자 · cols = 결과 컬럼별 값(숨김 포함 · 기본 조회 결과) · prefer = 먼저 볼 컬럼(라벨로 찾은 컬럼 등) */
export function pickCondCol(opts: string[], cols: Record<string, string[]>, prefer: string[] = []): CondColPick {
  const cands = opts.map(t => String(t || '').trim()).filter(t => t && !ALL_RX.test(t));
  const keyOf = (t: string) => [t, t.split(/\s+/)[0]].filter((v, i, a) => v && a.indexOf(v) === i);
  let best: CondColPick = { col: '', cand: '', value: '', hits: 0, how: '' };
  const order = [...prefer.filter(c => c in cols), ...Object.keys(cols).filter(c => !prefer.includes(c))];
  for (const col of order) {
    const freq = new Map<string, number>();
    for (const v of cols[col] || []) { const s = String(v ?? '').trim(); if (s) freq.set(s, (freq.get(s) || 0) + 1); }
    if (!freq.size) continue;
    const matched = cands.map(t => ({ t, v: keyOf(t).find(k => freq.has(k)) || '' })).filter(x => x.v);
    if (matched.length <= best.hits) continue;
    // 후보 글자 하나가 같은 값 여러 개에 맞거나(중복 표시명) 값이 후보 하나에만 대응하는 것만 고른다
    const uniq = matched.filter(x => matched.filter(y => y.v === x.v).length === 1);
    if (!uniq.length) continue;
    const pick = uniq.sort((a, b) => (freq.get(a.v) || 0) - (freq.get(b.v) || 0))[0];
    best = { col, cand: pick.t, value: pick.v, hits: matched.length, how: `결과 컬럼 ${col} 값과 후보 ${matched.length}/${cands.length}개 일치 · '${pick.v}' ${freq.get(pick.v)}행` };
  }
  return best;
}
