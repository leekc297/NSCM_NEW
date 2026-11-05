// 화면 구성 판정(2026-11-01 엔진 갭 EG029 Division별 컬럼 · EG270·EG321·EG324 조회조건 겹침). 순수 함수 — viewcheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };
export type Rect = { label: string; x: number; y: number; w: number; h: number };

/** grid_effective 한 Division — 기본·필수 = 보여야 함 · 숨김·공란 = 안 보여야 함 · 선택 등 = 개인화에 따라 다름(판정 제외) */
export function judgeDivCols(s: { div: string; expect: Record<string, string>; visible: string[]; gridOk: boolean; labels?: Record<string, string>; shownLabels?: string[] }): J {
  if (!s.gridOk || !s.visible.length) return { result: 'ERROR', why: `[측정 경로 없음] Div ${s.div} 그리드 컬럼을 읽지 못함` };
  // 바인딩 이름이 AS-IS 와 달라도(END_CUSTOMER40 ↔ END_CUSTOMER) 같은 라벨이 보이면 같은 컬럼 — 이름만 대조하면 허위 FAIL(2026-11-01 DMF0005)
  const nl = (t: string) => String(t || '').replace(/[*\s]/g, '').toLowerCase(); const shown = new Set((s.shownLabels || []).map(nl)); const lab = (c: string) => nl((s.labels || {})[c] || '');
  const wantLabels = new Set(Object.entries(s.expect).filter(([, v]) => ['기본', '필수'].includes(v.trim())).map(([c]) => lab(c)).filter(Boolean));
  const vis = new Set(s.visible); const miss: string[] = []; const extra: string[] = []; let n = 0;
  for (const [c, v] of Object.entries(s.expect)) {
    const t = v.trim();
    if (t === '기본' || t === '필수') { n++; if (!vis.has(c) && !(lab(c) && shown.has(lab(c)))) miss.push(c); }
    else if (t === '' || t === '숨김' || t === '→숨김') { n++; if (vis.has(c) && !(lab(c) && wantLabels.has(lab(c)))) extra.push(c); }
  }
  if (!n) return { result: 'ERROR', why: `[측정 경로 없음] Div ${s.div} 판정할 기대 컬럼 없음` };
  if (miss.length || extra.length) return { result: 'FAIL', why: `Div ${s.div} 대조 ${n}컬럼 · 있어야 하는데 없음 ${miss.length}개 ${miss.slice(0, 6).join(',')} · 없어야 하는데 있음 ${extra.length}개 ${extra.slice(0, 6).join(',')}` };
  return { result: 'PASS', why: `Div ${s.div} 대조 ${n}컬럼 일치` };
}

/** 조회조건 칸 겹침 — 1px 이내 맞닿음은 겹침 아님 */
export function overlaps(rs: Rect[]): string[] {
  const out: string[] = [];
  for (let i = 0; i < rs.length; i++) for (let j = i + 1; j < rs.length; j++) {
    const a = rs[i]; const b = rs[j]; const ox = Math.min(a.x + a.w, b.x + b.w) - Math.max(a.x, b.x); const oy = Math.min(a.y + a.h, b.y + b.h) - Math.max(a.y, b.y);
    if (ox > 1 && oy > 1) out.push(`'${a.label}'↔'${b.label}' ${Math.round(ox)}×${Math.round(oy)}px`);
  }
  return out;
}

export function judgeLayout(s: { width: number; rects: Rect[]; overflowX: boolean }): J {
  if (!s.rects.length) return { result: 'ERROR', why: `[측정 경로 없음] 폭 ${s.width} 조회조건 칸 0개` };
  const ov = overlaps(s.rects); const out = s.rects.filter(r => r.x + r.w > s.width + 1).map(r => r.label);
  if (ov.length) return { result: 'FAIL', why: `폭 ${s.width} 겹침 ${ov.length}건 ${ov.slice(0, 4).join(' · ')}` };
  if (out.length) return { result: 'FAIL', why: `폭 ${s.width} 화면 밖 칸 ${out.slice(0, 4).join(',')}` };
  return { result: 'PASS', why: `폭 ${s.width} 조회조건 ${s.rects.length}칸 겹침·넘침 없음${s.overflowX ? ' · 페이지 가로 스크롤 있음' : ''}` };
}
