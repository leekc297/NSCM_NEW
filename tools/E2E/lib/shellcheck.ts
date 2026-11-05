// 화면 틀 판정(2026-11-02 엔진 갭 EG379·EG332·EG381·EG272). 순수 함수 — shellcheck.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };
type R = { x: number; y: number; w: number; h: number };

/** 메뉴 오픈 — notFound 화면 문구 · status 화면 파일 요청 실패 수 */
export function judgeOpen(s: { notFound: boolean; authorized: boolean; failed: string[] }): J {
  if (!s.authorized) return { result: 'ERROR', why: '[측정 경로 없음] 화면 권한 없음' };
  if (s.notFound) return { result: 'FAIL', why: "메뉴 오픈 시 'Page Not Found'" };
  if (s.failed.length) return { result: 'FAIL', why: `메뉴 오픈 시 요청 실패 ${s.failed.length}건: ${s.failed.slice(0, 3).join(', ')}` };
  return { result: 'PASS', why: '메뉴 오픈 정상 — 404·요청 실패 0' };
}

/** 탭 이름 — tab 현재 탭 문구 · names 메뉴 등록 이름(언어별) */
export function judgeTabName(s: { tab: string; names: string[] }): J {
  if (!s.tab) return { result: 'ERROR', why: '[측정 경로 없음] 현재 탭 문구를 읽지 못함' };
  if (!s.names.length) return { result: 'ERROR', why: `[측정 경로 없음] 메뉴 등록 이름 없음(탭 '${s.tab}')` };
  const nm = (v: string) => v.replace(/\s+/g, ' ').trim().toLowerCase();
  if (s.names.some(x => nm(x) === nm(s.tab))) return { result: 'PASS', why: `탭 '${s.tab}' = 메뉴 등록 이름` };
  return { result: 'FAIL', why: `탭 '${s.tab}' ≠ 메뉴 등록 이름 ${s.names.slice(0, 3).join(' / ')}` };
}

/** 돋보기 버튼 위치 — 입력칸 안쪽(오차 2px). pairs: 조건별 입력칸·버튼 사각형 */
export function judgeSearchBtn(pairs: { label: string; input: R; btn: R }[]): J {
  if (!pairs.length) return { result: 'NA', why: '돋보기 버튼 달린 입력칸 없음' };
  const inside = (i: R, b: R) => b.x >= i.x - 2 && b.y >= i.y - 2 && b.x + b.w <= i.x + i.w + 2 && b.y + b.h <= i.y + i.h + 2;
  const bad = pairs.filter(p => !inside(p.input, p.btn));
  if (bad.length) return { result: 'FAIL', why: `돋보기 버튼이 입력칸 밖 ${bad.length}/${pairs.length}: ${bad.slice(0, 4).map(p => p.label).join(', ')}` };
  return { result: 'PASS', why: `돋보기 버튼 ${pairs.length}개 입력칸 안쪽` };
}

/** 조회조건 초기값 — div 진입 시 Division 값 · divCands 후보 · year Year 값(없으면 null) · nowYear 현재 연도 (EG293·EG277) */
export function judgeInitVals(s: { div: string; divCands: string[]; year: string | null; nowYear: string; hasDiv: boolean }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.hasDiv && s.year == null) return { result: 'NA', why: 'Division·Year 조건 없음' };
  if (s.hasDiv && !s.div.trim()) return { result: 'FAIL', why: `진입 시 Division 빈 칸(후보 ${s.divCands.length}건)` };
  if (s.hasDiv && s.divCands.length && !s.divCands.includes(s.div.trim())) return { result: 'ERROR', why: `[확인 대상] Division 초기값 '${s.div}' 가 후보에 없음 — 후보 ${s.divCands.slice(0, 4).join(', ')}` };
  if (s.year != null && !s.year.trim().startsWith(s.nowYear)) return { result: 'FAIL', why: `Year 초기값 '${s.year}' ≠ 현재 연도 ${s.nowYear}` };
  return { result: 'PASS', why: `Division '${s.div}'${s.year != null ? ` · Year '${s.year}'` : ''}` };
}

/** Division 변경 뒤 Version — before 변경 전 값 · after 변경 뒤 값 · changedDiv 실제 변경됨 (EG290·EG082) */
export function judgeVersionAfterDiv(s: { hasVersion: boolean; changedDiv: boolean; before: string; after: string; cands: string[] }): { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string } {
  if (!s.hasVersion) return { result: 'NA', why: 'Version 조건 없음' };
  if (!s.changedDiv) return { result: 'ERROR', why: '[측정 경로 없음] Division 후보 1건 이하 또는 변경 실패' };
  if (!s.after.trim()) return { result: 'FAIL', why: `Division 변경 뒤 Version 빈 칸(전 '${s.before}' · 후보 ${s.cands.length}건)` };
  if (s.cands.length && !s.cands.includes(s.after.trim())) return { result: 'FAIL', why: `Division 변경 뒤 Version '${s.after}' 가 새 후보에 없음 — 재구성 안 됨` };
  return { result: 'PASS', why: `Division 변경 뒤 Version '${s.before}' → '${s.after}'(새 후보 안)` };
}

type PJ = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };
/** 기간 칸에 글자 입력 — v0 전 값 · typed 입력 뒤 값 · sent 조회 요청 · msg 안내 (EG149·EG274) */
export function judgePeriodGarbage(s: { hasPeriod: boolean; v0: string; typed: string; sent: boolean; msg: string }): PJ {
  if (!s.hasPeriod) return { result: 'NA', why: '기간 조회조건 없음' };
  if (!/[A-Za-z]/.test(s.typed)) return { result: 'PASS', why: `기간 칸 글자 입력 거부 — '${s.v0}' → '${s.typed}'` };
  if (s.msg) return { result: 'PASS', why: `기간 칸 글자 '${s.typed}' 조회 시 안내 '${s.msg.slice(0, 60)}'` };
  if (s.sent) return { result: 'FAIL', why: `기간 칸 글자 '${s.typed}' 그대로 조회 요청 나감 — 형식 안내 없음` };
  return { result: 'ERROR', why: `[확인 대상] 기간 칸 글자 '${s.typed}' 남음 · 요청·안내 없음` };
}

/** From > To 조회 — sent 조회 요청 · msg 안내 · asisGuard AS-IS 기간 비교 근거 (EG151 · 문서 MSG01135·MSG00164) */
export function judgePeriodReverse(s: { hasRange: boolean; set: boolean; from: string; to: string; sent: boolean; msg: string; asisGuard: boolean; ctrlOk?: boolean }): PJ {
  if (!s.hasRange) return { result: 'NA', why: 'From·To 기간 조회조건 없음' };
  // 대조군 — 정상 범위 날짜는 들어가는데 역전 날짜만 안 들어가면 컨트롤이 막는 것이다
  if (!s.set) return s.ctrlOk ? { result: 'PASS', why: `기간 역전 입력을 컨트롤이 거부(From '${s.from}' · To '${s.to}') · 정상 범위 날짜 입력은 됨` } : { result: 'ERROR', why: `[측정 경로 없음] 기간을 뒤집어 넣지 못함 · 대조군도 안 들어감(From '${s.from}' · To '${s.to}')` };
  if (s.msg && !s.sent) return { result: 'PASS', why: `기간 역전 '${s.from}'~'${s.to}' 안내 '${s.msg.slice(0, 60)}' · 조회 요청 없음` };
  if (s.sent && s.asisGuard) return { result: 'FAIL', why: `기간 역전 '${s.from}'~'${s.to}' 조회 요청 나감${s.msg ? ` · 안내 '${s.msg.slice(0, 40)}'` : ' · 안내 없음'} — AS-IS 는 기간 검사` };
  if (s.sent) return { result: 'ERROR', why: `[확인 대상] 기간 역전 '${s.from}'~'${s.to}' 조회 요청 나감 — AS-IS 기간 검사 근거 못 찾음` };
  return { result: 'ERROR', why: `[확인 대상] 기간 역전 요청·안내 모두 없음` };
}
