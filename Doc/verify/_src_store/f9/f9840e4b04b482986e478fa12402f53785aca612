// 2026-11-20 T499(SCP0028 G1 V-dd4f9db4 From Site '결과 컬럼 FROM_SITE_DESCRIPTION 값에서 고를 후보를 못 찾아 임의 후보 선택' → 0행 ERROR):
//   다중 선택 조건의 후보 글자는 코드('AU000062_81-P')인데 라벨로 찾은 결과 컬럼(FROM_SITE_DESCRIPTION)은 설명이라 겹치는 값이 없었다.
//   같은 그리드의 숨은 코드 컬럼(FROM_SITE · header 'From Site' · visible false)은 후보와 값이 겹친다.
//   T385(_trace.spec.ts:1496 SSP0014)는 콤보 응답 코드·이름 쌍으로 결과 값을 환산했으나 이 화면 콤보는 CODE=NAME 이라 환산이 안 된다.
//   → 후보 글자(전체 또는 첫 토큰)와 값이 가장 많이 겹치는 컬럼(숨김 포함)을 고르고, 그 컬럼에서 가장 드문 값의 후보를 고른다. 순수 함수(condcol.selftest.js)
export type CondColPick = { col: string; cand: string; value: string; hits: number; how: string };

/** 2026-11-25 T560: 칸·라벨 이름 갈래. 대문자·영숫자만 · 여부 꼬리(_YN·_FLAG·_FLG, 밑줄 뒤만) 제거 · 이름·코드 꼬리 제거. 'Valid' = VALID_YN = VALID · 'Mon' ≠ DAYS_MON */
export function stemCol(c: string): string {
  return String(c || '').toUpperCase().trim().replace(/[\s_-]+(YN|FLAG|FLG)$/, '').replace(/[^A-Z0-9]/g, '').replace(/(DESCRIPTION|DESC|NAME|NM|CODE|CD|ID)$/, '');
}

const ALL_RX = /^(select all|all|전체|\(all\))$/i;

/** opts = 콤보 후보 글자 · cols = 결과 컬럼별 값(숨김 포함 · 기본 조회 결과) · prefer = 먼저 볼 컬럼(라벨로 찾은 컬럼 등) */
export function pickCondCol(opts: string[], cols: Record<string, string[]>, prefer: string[] = [], label = ''): CondColPick {
  const cands = opts.map(t => String(t || '').trim()).filter(t => t && !ALL_RX.test(t));
  const keyOf = (t: string) => [t, t.split(/\s+/)[0]].filter((v, i, a) => v && a.indexOf(v) === i);
  // 2026-11-20 T521(SCP0028 G1 V-8e065123 To Site): 후보가 코드라 라벨 컬럼(TO_SITE_DESCRIPTION)과 안 겹치면 전 컬럼을 훑는데,
  //   같은 사이트 코드를 담은 FROM_SITE 가 TO_SITE 보다 겹침이 많아 To Site 조건을 FROM_SITE 로 대조했다(조건 밖 값 허위 FAIL).
  //   → 이름이 라벨·라벨 컬럼과 같은 갈래인 컬럼(TO_SITE_DESCRIPTION·'To Site' → TO_SITE)을 먼저 보고 겹치면 그 컬럼을 쓴다. 없을 때만 전 컬럼 최다 겹침
  // 2026-11-25 T560(SCP0005 G1 V-e5d15dff 조회조건 Valid): 라벨 'Valid' 갈래가 VALID_YN(갈래 'VALIDYN')과 안 맞아 Y/N 값이 같은 DAYS_MON 을 골랐다
  //   (AS-IS SP 조건 a.valid_yn = @p_valid_yn · AsIs_LGCE_SCMDEV_SP6_DDL.sql:34766). 여부 칸 꼬리(_YN·_FLAG·_FLG)도 갈래에서 뗀다 → stemCol 공용
  const stem = stemCol;
  const stems = new Set([...prefer.map(stem), stem(label)].filter(Boolean));
  let best: CondColPick = { col: '', cand: '', value: '', hits: 0, how: '' };
  const scan = (list: string[]) => {
    for (const col of list) {
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
  };
  const order = [...prefer.filter(c => c in cols), ...Object.keys(cols).filter(c => !prefer.includes(c))];
  scan(order.filter(c => stems.has(stem(c))));
  if (best.col) { best.how += ` · 라벨 '${label || prefer[0] || ''}' 과 이름 갈래가 같은 컬럼 우선(T521)`; return best; }
  scan(order);
  return best;
}

/** 2026-11-20 T527: pickCondCol 결과(pk)와 라벨 갈래 칸으로 대조 칸을 정한다. 라벨 갈래 칸(코드 칸 우선)에 값이 있으면 겹침 0 이어도 그 칸 · 순수 함수 */
export function chooseCondCol(pk: CondColPick, cols: Record<string, string[]>, col: string, label: string, nOpts: number): { col: string; how: string } {
  const stemOf = stemCol;  // 2026-11-25 T560 갈래 공용
  const lst = new Set([stemOf(label), col ? stemOf(col) : ''].filter(Boolean));
  const head = col ? `라벨 컬럼 ${col} 값과 후보 겹침 0 → ` : '';
  if (pk.col && lst.has(stemOf(pk.col))) return { col: pk.col, how: head + pk.how };
  const rel = Object.keys(cols).filter(c => lst.has(stemOf(c)) && (cols[c] || []).some(v => String(v || '').trim()));
  const relCode = rel.filter(c => !/(DESCRIPTION|DESC|NAME|NM)$/i.test(c.replace(/_/g, '')))[0] || '';
  if (relCode) return { col: relCode, how: `라벨 '${label}' 갈래 코드 칸 ${relCode}(읽은 후보 ${nOpts}개와 겹침 0 · 후보는 검색창으로 찾음${pk.col ? ` · 최다 겹침 ${pk.col} 은 다른 조건 칸이라 안 씀` : ''} · T527)` };
  if (!pk.col) return { col, how: `라벨 갈래 칸 겹침 0 · 다른 칸 겹침 0 → ${col || '칸 없음'} 유지` };
  return { col: pk.col, how: head + pk.how };
}
