// 화면 구성 판정(2026-11-01 엔진 갭 EG029 Division별 컬럼 · EG270·EG321·EG324 조회조건 겹침). 순수 함수 — viewcheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR'; why: string };
export type Rect = { label: string; x: number; y: number; w: number; h: number; reach?: boolean };

/** grid_effective 한 Division — 기본·필수 = 보여야 함 · 숨김·공란 = 안 보여야 함 · 선택 등 = 개인화에 따라 다름(판정 제외) */
export function judgeDivCols(s: { div: string; expect: Record<string, string>; visible: string[]; gridOk: boolean; labels?: Record<string, string>; shownLabels?: string[] }): J {
  if (!s.gridOk || !s.visible.length) return { result: 'ERROR', why: `[측정 경로 없음] Div ${s.div} 그리드 컬럼을 읽지 못함` };
  // 바인딩 이름이 AS-IS 와 달라도(END_CUSTOMER40 ↔ END_CUSTOMER) 같은 라벨이 보이면 같은 컬럼 — 이름만 대조하면 허위 FAIL(2026-11-01 DMF0005)
  const nl = (t: string) => String(t || '').replace(/[*\s]/g, '').toLowerCase(); const shown = new Set((s.shownLabels || []).map(nl)); const lab = (c: string) => nl((s.labels || {})[c] || '');
  const wantLabels = new Set(Object.entries(s.expect).filter(([, v]) => ['기본', '필수'].includes(v.trim())).map(([c]) => lab(c)).filter(Boolean));
  // 2026-11-06(SCP0016 A5 project_code/version_no 허위 FAIL): AS-IS 메타 소문자 ↔ TO-BE 바인딩 대문자 — 이름 비교는 대소문자 무시
  const vis = new Set(s.visible.map(v => v.toUpperCase())); const has = (c: string) => vis.has(String(c).toUpperCase()); const miss: string[] = []; const extra: string[] = []; const opt: string[] = []; let n = 0;
  for (const [c, v] of Object.entries(s.expect)) {
    const t = v.trim();
    if (t === '기본' || t === '필수') { n++; if (!has(c) && !(lab(c) && shown.has(lab(c)))) miss.push(c); }
    else if (t === '선택') { n++; if (!has(c) && !(lab(c) && shown.has(lab(c)))) opt.push(c); }  // 개인화 가능 컬럼 — 없어도 결함 아님(2026-11-06)
    else if (t === '' || t === '숨김' || t === '→숨김') { n++; if (has(c) && !(lab(c) && wantLabels.has(lab(c)))) extra.push(c); }
  }
  if (!n) return { result: 'ERROR', why: `[측정 경로 없음] Div ${s.div} 판정할 기대 컬럼 없음` };
  if (miss.length || extra.length) return { result: 'FAIL', why: `Div ${s.div} 대조 ${n}컬럼 · 있어야 하는데 없음 ${miss.length}개 ${miss.slice(0, 6).join(',')} · 없어야 하는데 있음 ${extra.length}개 ${extra.slice(0, 6).join(',')}` };
  return { result: 'PASS', why: `Div ${s.div} 대조 ${n}컬럼 일치${opt.length ? ` · 개인화 가능(TO-BE DEFAULT=Y·USER_SELECTABLE=Y) 컬럼 미표시 ${opt.length}개 ${opt.slice(0, 6).join(',')} — 사용자가 개인화로 뺄 수 있는 컬럼이라 미표시는 결함 기준 아님(미표시 원인 = 개인화·화면 코드 중 무엇인지는 이 검사가 가리지 않음)` : ''}` };  // 2026-11-16 SCP0104 SOP: '사용자 설정으로 뺀 것'이라고 단정했으나 실제 원인은 화면 코드(capaLineAssignColumns.ts:143~148)였음 — 원인을 단정하지 않는다
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
  // 2026-11-06(SCP0037·SCP0016·SCP0084 H4 허위 FAIL): 화면은 최소 폭 1460(SearchArea SEARCH_AREA_MIN_WIDTH · ViewContainer minWidth)에 .view 가로 스크롤 설계 —
  //   뷰포트 밖이어도 가로 스크롤 조상으로 도달 가능한 칸(reach)은 넘침이 아니다. 잘려 도달 불가한 칸만 FAIL
  const ov = overlaps(s.rects); const off = s.rects.filter(r => r.x + r.w > s.width + 1); const out = off.filter(r => !r.reach).map(r => r.label); const scrolled = off.filter(r => r.reach).map(r => r.label);
  if (ov.length) return { result: 'FAIL', why: `폭 ${s.width} 겹침 ${ov.length}건 ${ov.slice(0, 4).join(' · ')}` };
  if (out.length) return { result: 'FAIL', why: `폭 ${s.width} 화면 밖 칸 ${out.slice(0, 4).join(',')}` };
  return { result: 'PASS', why: `폭 ${s.width} 조회조건 ${s.rects.length}칸 겹침·넘침 없음${scrolled.length ? ` · 가로 스크롤로 도달 ${scrolled.slice(0, 4).join(',')}(최소 폭 1460 설계)` : ''}${s.overflowX ? ' · 페이지 가로 스크롤 있음' : ''}` };
}
