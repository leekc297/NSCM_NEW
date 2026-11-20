// 그리드 표시 묶음 판정(2026-11-02 엔진 갭 EG456·EG352·EG027). 순수 함수 — griddisp.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };

/** 빈 값 센티널 '/' 가 화면에 그대로 노출된 칸 — hits: 컬럼별 건수 · scanned 본 칸 수 */
export function judgeSentinel(s: { hits: Record<string, number>; scanned: number }): J {
  if (!s.scanned) return { result: 'ERROR', why: '[측정 경로 없음] 조회 결과 0행' };
  const k = Object.keys(s.hits).filter(c => s.hits[c] > 0);
  if (k.length) return { result: 'FAIL', why: `빈 값 센티널 '/' 화면 노출 ${k.length}컬럼: ${k.slice(0, 6).map(c => `${c} ${s.hits[c]}칸`).join(', ')} (본 칸 ${s.scanned})` };
  return { result: 'PASS', why: `센티널 '/' 노출 0 (본 칸 ${s.scanned})` };
}

/** 총 건수 표시 — label 화면 문구 · n 실제 행 수. 1000 미만이면 천단위 판정 불가 */
export function judgeCountLabel(s: { label: string; n: number }): J {
  if (!s.label) return { result: 'NA', why: '총 건수 표시 없음' };
  if (s.n < 1000) return { result: 'NA', why: `행 ${s.n} — 천 단위 미만이라 판정 재료 없음 ('${s.label}')` };
  if (/\d{4,}/.test(s.label)) return { result: 'FAIL', why: `총 건수 천단위 구분 없음 '${s.label}'(행 ${s.n})` };
  return { result: 'PASS', why: `총 건수 '${s.label}'(행 ${s.n})` };
}

/** 컬럼 표시 순서 — 양쪽에 다 있는 컬럼만 상대 순서 비교 · 어긋난 첫 쌍 */
export function judgeColOrder(s: { asis: string[]; tobe: string[]; sheet: string }): J {
  const set = new Set(s.tobe); const a = s.asis.filter(c => set.has(c)); const aset = new Set(a); const t = s.tobe.filter(c => aset.has(c));
  if (a.length < 2) return { result: 'ERROR', why: `[측정 경로 없음] 비교할 공통 컬럼 ${a.length}개(시트 ${s.sheet})` };
  const i = a.findIndex((c, k) => c !== t[k]);
  if (i >= 0) return { result: 'ERROR', why: `[확인 대상] 컬럼 순서 다름 ${i + 1}번째 AS-IS ${a[i]} ↔ TO-BE ${t[i]} (시트 ${s.sheet} · 공통 ${a.length}개) — 관리자 메타 변경·계정 개인화일 수 있어 결함 단정 안 함` };
  return { result: 'PASS', why: `공통 ${a.length}개 컬럼 순서 일치(시트 ${s.sheet})` };
}

/** 저장 버튼 없는 화면 = 셀 편집 불가 · 저장 버튼 있는 화면 = Edit 버튼 없이 조회 직후 편집 (EG105·EG110 · CR-093) */
export function judgeEditMode(s: { save: boolean; editBtn: boolean; rows: number; editable: string[]; checked: number }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (s.rows <= 0) return { result: 'ERROR', why: '[측정 경로 없음] 조회 0행 — 편집 가능 여부 판정 불가' };
  if (s.editBtn) return { result: 'FAIL', why: `툴바에 Edit 버튼 노출 — TO-BE 는 Edit 없이 상시 편집(CR-093)` };
  if (!s.save) return s.editable.length ? { result: 'FAIL', why: `저장 버튼 없는 화면인데 편집 가능 칸 ${s.editable.length}개: ${s.editable.slice(0, 5).join(', ')}` } : { result: 'PASS', why: `조회 전용 — Save 없음 · 칸 ${s.checked}개 편집 불가` };
  if (!s.editable.length) return { result: 'NA', why: `Save 있으나 첫 기존 행 편집 가능 칸 0(행 조건부 잠금일 수 있음 · 칸 ${s.checked}개 확인)` };
  return { result: 'PASS', why: `Edit 버튼 없이 조회 직후 편집 가능 칸 ${s.editable.length}개` };
}

/** 2026-11-12 CR-103(C1-26): 편집 권한 계정으로 조회한 뒤 AS-IS 편집 가능 컬럼이 TO-BE 에서 실제로 편집되는가.
 *  asisEdit = AS-IS 가 기존 행에서 조건 없이 편집 가능으로 두는 컬럼 수(edit_expect existing_row=EDIT) · asisCond = 행 조건부(COND) 컬럼 수
 *  measured = 그 컬럼들을 실제로 열어 본 칸 수 · editable = 편집기가 열린 컬럼 · sheets = 잰 시트 · account = 계정(증거용)
 *  권한 있는 계정인데 무조건 편집 컬럼이 하나도 안 열리면 FAIL. 조건부 컬럼만 있고 안 열리면 조건 맞는 행을 못 찾은 것 — 미검증(ERROR). */
export function judgeEditAfterSearch(s: { save: boolean; editBtn: boolean; rows: number; asisEdit: number; asisCond: number; measured: number; editable: string[]; sheets: string[]; account: string }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  const at = `${s.sheets.length ? '시트 ' + s.sheets.join(', ') : '시트 미상'} · 계정 ${s.account || '?'}`;
  if (s.editBtn) return { result: 'FAIL', why: `툴바에 Edit 버튼 노출 — TO-BE 는 Edit 없이 상시 편집(CR-093)` };
  if (s.asisEdit + s.asisCond <= 0) return { result: 'NA', why: 'AS-IS 편집 가능 컬럼 사실(edit_expect) 없음 — 화면 단위 편집 가능 판정은 종전 검사로' };
  if (s.rows <= 0) return { result: 'ERROR', why: `[측정 경로 없음] AS-IS 편집 가능 시트에 조회 행 0 — 편집 가능 여부 판정 불가(${at})` };
  if (s.measured <= 0) return { result: 'ERROR', why: `[측정 경로 없음] AS-IS 편집 가능 컬럼을 TO-BE 그리드에서 찾지 못함(${at})` };
  if (s.editable.length) return { result: 'PASS', why: `조회 직후 편집 가능 컬럼 ${s.editable.length}개(${s.editable.slice(0, 5).join(', ')}) — AS-IS 편집 가능 ${s.asisEdit}개·조건부 ${s.asisCond}개 중 · ${at}` };
  if (s.asisEdit > 0) return { result: 'FAIL', why: `권한 있는 계정으로 조회했는데 편집 가능 컬럼 0 — AS-IS 는 조건 없이 편집 가능 ${s.asisEdit}개(편집 모드 기준 CR-093) · ${s.measured}칸 확인 · ${at} (CR-103: 권한 있는 사용자가 조회 후 편집 불가면 오류)` };
  return { result: 'ERROR', why: `[미검증] AS-IS 편집 가능 컬럼이 전부 행 조건부(${s.asisCond}개)이고 확인한 ${s.measured}칸은 모두 잠김 — 조건에 맞는 행을 찾지 못함(${at})` };
}
/** 값 0·빈 값의 표시 — want '0' 빈 값도 0 으로 보임 · 'blank' 0 은 빈칸 (EG348 · 기준 Doc/verify/zero_display_expect.csv) */
export function judgeZeroShow(s: { want: string; cols: string[]; zeroCells: number; blankShown: number; zeroShown: number; ex: string }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.cols.length) return { result: 'ERROR', why: '[측정 경로 없음] 기준표 칸이 그리드에 없음' };
  if (!s.zeroCells) return { result: 'NA', why: `칸 ${s.cols.slice(0, 3).join(',')} 에 값 0·빈 값 행 없음 — 표본 없음` };
  if (s.want === '0' && s.blankShown) return { result: 'FAIL', why: `${s.cols[0]} 0·빈 값 ${s.zeroCells}칸 중 빈칸 표시 ${s.blankShown}칸 — 0 으로 표시해야 함(${s.ex})` };
  if (s.want === 'blank' && s.zeroShown) return { result: 'FAIL', why: `${s.cols[0]} 값 0 ${s.zeroCells}칸 중 0 표시 ${s.zeroShown}칸 — 빈칸이어야 함(${s.ex})` };
  return { result: 'PASS', why: `${s.cols[0]} 0·빈 값 ${s.zeroCells}칸 표시 규칙(${s.want === '0' ? '0 표시' : '빈칸'}) 일치` };
}

/** 칸 이름 → 지난 기간 여부 — 현재 구간(이번 달·이번 주 ±1주)은 실적·계획 경계라 판정 제외(null) · 판독 불가도 null */
export function isPastPeriod(binding: string, today: string): boolean | null {
  const t = String(binding).replace(/\D/g, ''); const ym = today.slice(0, 6);
  if (/^W/i.test(String(binding)) && t.length === 8 && +t.slice(6, 8) > 31) { // 연월주(W_20261144 = 2026년 44주) — 지난 주 비교는 연·주 번호로
    const d0 = new Date(Date.UTC(+today.slice(0, 4), +today.slice(4, 6) - 1, +today.slice(6, 8))); const jan1 = Date.UTC(d0.getUTCFullYear(), 0, 1); const wk = Math.ceil(((d0.getTime() - jan1) / 86400000 + new Date(jan1).getUTCDay() + 1) / 7);
    const yy = +t.slice(0, 4), ww = +t.slice(6, 8); if (yy === d0.getUTCFullYear() && Math.abs(ww - wk) <= 1) return null; return yy < d0.getUTCFullYear() || (yy === d0.getUTCFullYear() && ww < wk);
  }
  if (t.length === 6) { const m = +t.slice(4, 6); return m >= 1 && m <= 12 ? (t === ym ? null : t < ym) : null; }
  if (t.length !== 8) return null;
  const mo = +t.slice(4, 6), d = +t.slice(6, 8); if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
  const lim = new Date(Date.UTC(+today.slice(0, 4), +today.slice(4, 6) - 1, +today.slice(6, 8) - 8)).toISOString().slice(0, 10).replace(/-/g, '');
  const lim2 = new Date(Date.UTC(+today.slice(0, 4), +today.slice(4, 6) - 1, +today.slice(6, 8) + 8)).toISOString().slice(0, 10).replace(/-/g, ''); if (t > lim && t < lim2) return null;
  return t <= lim;
}

/** 회색 계열(R≈G≈B · 밝기 190~248) — AS-IS Gainsboro(220) · TO-BE 합계 연회색(#d3)·실적 연회색(#f1f4f3) 포함 · 흰색(255) 제외 */
export function isGrayBg(bg: string): boolean { const m = /rgba?\((\d+),\s*(\d+),\s*(\d+)/.exec(bg || ''); if (!m) return false; const [r, g, b] = [+m[1], +m[2], +m[3]]; return Math.max(r, g, b) - Math.min(r, g, b) <= 6 && r >= 190 && r <= 248; }

/** 실적 구간 색(EG310) — mode: gray_actual = 지난 칸 회색·앞으로 칸 회색 아님 / all_white = 회색 0 / actual_color = 지난 칸 머리글·셀 모두 앞으로 칸과 다른 색 */
export function judgePeriodColor(s: { mode: string; cols: { b: string; bg: string; hdr: string }[]; today: string }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.cols.length) return { result: 'ERROR', why: '[측정 경로 없음] 기간 칸 색을 읽지 못함' };
  const gray = s.cols.filter(c => isGrayBg(c.bg));
  if (s.mode === 'all_white') return gray.length ? { result: 'FAIL', why: `전 구간 흰색이어야 하는데 회색 ${gray.length}칸: ${gray.slice(0, 3).map(c => c.b).join(',')}` } : { result: 'PASS', why: `기간 칸 ${s.cols.length}개 회색 0` };
  const past = s.cols.filter(c => isPastPeriod(c.b, s.today) === true), fut = s.cols.filter(c => isPastPeriod(c.b, s.today) === false);
  if (!past.length) return { result: 'NA', why: `조회 범위에 지난 기간 칸 없음(칸 ${s.cols.length}개 · 예 ${s.cols[0].b}) — 실적 구간 표본 없음` };
  if (s.mode === 'actual_color') {
    const base = fut[0]; if (!base) return { result: 'ERROR', why: '[측정 경로 없음] 비교할 앞으로 칸 없음' };
    if (!base.hdr || past.some(c => !c.hdr)) return { result: 'ERROR', why: `[측정 경로 없음] 머리글 색을 읽지 못함(${past.filter(c => !c.hdr).length}칸)` };
    const badC = past.filter(c => c.bg === base.bg), badH = past.filter(c => c.hdr === base.hdr);
    if (badC.length || badH.length) return { result: 'FAIL', why: `지난 칸 ${past.length}개 중 셀 색 같음 ${badC.length} · 머리글 색 같음 ${badH.length}(앞으로 칸과 구분 안 됨): ${(badC[0] || badH[0]).b} 셀 ${(badC[0] || badH[0]).bg}·머리글 ${(badC[0] || badH[0]).hdr} ↔ 앞으로 ${base.b} 셀 ${base.bg}·머리글 ${base.hdr}` };
    return { result: 'PASS', why: `지난 칸 ${past.length}개 머리글·셀이 앞으로 칸과 구분됨` };
  }
  const pw = past.filter(c => !isGrayBg(c.bg)), fg = fut.filter(c => isGrayBg(c.bg));
  if (pw.length) return { result: 'FAIL', why: `지난 칸 ${past.length}개 중 회색 아님 ${pw.length}칸: ${pw.slice(0, 3).map(c => `${c.b}=${c.bg}`).join(',')}` };
  if (fg.length) return { result: 'FAIL', why: `앞으로 칸 ${fut.length}개 중 회색 ${fg.length}칸: ${fg.slice(0, 3).map(c => c.b).join(',')}` };
  return { result: 'PASS', why: `지난 칸 ${past.length}개 회색 · 앞으로 칸 ${fut.length}개 회색 아님` };
}

/** 조건 조회 ↔ 전체 조회의 그 값 행 수(EG002) — 조건 쪽이 많으면 부분집합이 아님 · 적으면 표시 칸과 필터 칸이 다를 수 있어 확인 대상 */
export function judgeCondRange(s: { base: number; cond: number; label: string }): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  if (s.cond === s.base) return { result: 'PASS', why: `${s.label} 조건 ${s.cond}행 = 전체 조회의 그 값 ${s.base}행` };
  if (s.cond > s.base) return { result: 'FAIL', why: `${s.label} 조건 ${s.cond}행 > 전체 조회의 그 값 ${s.base}행 — 조건 결과가 전체의 부분집합이 아님` };
  return { result: 'ERROR', why: `[확인 대상] ${s.label} 조건 ${s.cond}행 < 전체 조회의 그 값 ${s.base}행 — 조건을 걸면 행이 사라짐(마스터 미등록 행·결합 조건 확인)` };
}

/** 같은 대상을 이름·ID 로 조회한 건수(EG002 GAP-75) */
export function judgeNameIdCount(s: { label: string; id: string; name: string; byId: number; byName: number }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.id || !s.name) return { result: 'NA', why: `${s.label} ID·이름 짝이 있는 행 없음 — 표본 없음` };
  if (!s.byId) return { result: 'ERROR', why: `[측정 경로 없음] ID '${s.id}' 조회 0행` };
  return s.byId === s.byName ? { result: 'PASS', why: `${s.label} '${s.name}' ${s.byName}건 = '${s.id}' ${s.byId}건` } : { result: 'FAIL', why: `${s.label} 이름 '${s.name}' ${s.byName}건 ≠ ID '${s.id}' ${s.byId}건` };
}

/** Sum 체크박스·합계 칸(EG016) — toggle = 체크로 합계 칸이 재조회 없이 보임·해제로 숨김 / absent = 체크박스 없음 */
export function judgeSumToggle(s: { mode: string; found: boolean; before: string[]; on: string[]; off: string[]; reqs: number; label: string }): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  if (s.mode === 'absent') return s.found ? { result: 'FAIL', why: `'${s.label}' 체크박스가 보임 — 문서상 비노출` } : { result: 'PASS', why: `'${s.label}' 체크박스 없음` };
  if (!s.found) return { result: 'FAIL', why: `'${s.label}' 체크박스 없음` };
  if (!s.before.length) return { result: 'ERROR', why: '[측정 경로 없음] 그리드 칸을 읽지 못함' };
  const added = s.on.filter(b => !s.before.includes(b)); const left = added.filter(b => s.off.includes(b));
  if (!added.length) return { result: 'FAIL', why: `'${s.label}' 체크해도 보이는 칸이 늘지 않음(칸 ${s.before.length}개)` };
  if (left.length) return { result: 'FAIL', why: `'${s.label}' 해제해도 합계 칸이 남음: ${left.slice(0, 4).join(',')}` };
  if (s.reqs) return { result: 'FAIL', why: `'${s.label}' 토글에 조회 요청 ${s.reqs}건 — 재조회 없이 바뀌어야 함` };
  return { result: 'PASS', why: `'${s.label}' 체크 시 합계 칸 ${added.length}개 표시·해제 시 숨김·재조회 0 (예 ${added.slice(0, 3).join(',')})` };
}

/** 숫자 표시 형식(EG351) — 빈 값 제외한 표시 문구가 문서 형식과 일치 */
export function judgeNumFormat(s: { cols: string[]; checked: number; bad: string[]; desc: string }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.cols.length) return { result: 'ERROR', why: '[측정 경로 없음] 기준표 칸이 그리드에 없음' };
  if (!s.checked) return { result: 'NA', why: `칸 ${s.cols.slice(0, 3).join(',')} 에 표시 값 없음 — 표본 없음` };
  return s.bad.length ? { result: 'FAIL', why: `${s.desc} — ${s.checked}칸 중 어긋남 ${s.bad.length}칸: ${s.bad.slice(0, 4).join(' · ')}` } : { result: 'PASS', why: `${s.desc} — ${s.checked}칸 전부 일치` };
}

/** 문서가 정한 표시 문구(EG329·EG331) — 대상 칸 값들에 문구가 있는지 · 행이 없으면 재료 없음 */
export function judgeTextShown(s: { name: string; text: string; rows: number; vals: string[]; applied: boolean }): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  if (!s.applied) return { result: 'ERROR', why: `[측정 경로 없음] ${s.name} 조건을 못 맞춤` };
  if (!s.rows) return { result: 'ERROR', why: `[측정 경로 없음] ${s.name} 조회 0행` };
  const hit = s.text.startsWith('~') ? (() => { const re = new RegExp(s.text.slice(1), 'i'); return s.vals.find(v => re.test(v)); })() : s.vals.find(v => v.trim() === s.text); /* ~ 로 시작하면 정규식 */ if (hit !== undefined) return { result: 'PASS', why: `${s.name} '${hit.slice(0, 60)}' 표시` };
  return s.vals.length ? { result: 'FAIL', why: `${s.name} '${s.text}' 없음 — 실제 ${[...new Set(s.vals)].slice(0, 6).join(', ')}` } : { result: 'ERROR', why: `[측정 경로 없음] ${s.name} 대상 칸 값 없음` };
}

/** 체크 즉시 조회·서로 배타(EG258 GAP-276) — reqs 체크 후 조회 요청 수 · body 그 요청 본문 변화 키 · other 짝 체크 상태(체크 뒤) */
export function judgeCheckImmediate(s: { label: string; found: boolean; reqs: number; other: string; otherChecked: boolean | null }): { result: 'PASS' | 'FAIL' | 'ERROR'; why: string } {
  if (!s.found) return { result: 'FAIL', why: `'${s.label}' 체크박스 없음` };
  if (!s.reqs) return { result: 'FAIL', why: `'${s.label}' 체크해도 조회 요청 없음 — 즉시 조회여야 함` };
  if (s.other && s.otherChecked === null) return { result: 'ERROR', why: `[측정 경로 없음] 짝 '${s.other}' 체크 상태를 못 읽음` };
  if (s.other && s.otherChecked) return { result: 'FAIL', why: `'${s.label}' 체크 뒤 '${s.other}' 도 체크 — 서로 배타여야 함` };
  return { result: 'PASS', why: `'${s.label}' 체크 즉시 조회 ${s.reqs}건${s.other ? ` · '${s.other}' 해제` : ''}` };
}

/** 칸 폭 = 메타(EG354 DM-C4) — 개인화가 있으면 대상 아님 · 폭은 메타 ±10% 또는 자동 맞춤 없음 */
export function judgeMetaWidth(s: { personal: number; cols: { b: string; meta: number; w: number }[] }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (s.personal < 0) return { result: 'ERROR', why: '[측정 경로 없음] 계정 개인화 건수 조회 실패' };
  if (s.personal > 0) return { result: 'NA', why: `계정 개인화 ${s.personal}행 — 폭은 개인화 기준이라 대상 아님` };
  if (!s.cols.length) return { result: 'ERROR', why: '[측정 경로 없음] 메타 폭이 있는 칸이 그리드에 없음' };
  const bad = s.cols.filter(c => Math.abs(c.w - c.meta) > Math.max(4, c.meta * 0.1));
  return bad.length ? { result: 'FAIL', why: `칸 ${s.cols.length}개 중 메타 폭과 다름 ${bad.length}개: ${bad.slice(0, 4).map(c => `${c.b} ${c.w}≠${c.meta}`).join(', ')}` } : { result: 'PASS', why: `칸 ${s.cols.length}개 폭 = 메타` };
}
