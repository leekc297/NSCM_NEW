// 조회 전 합계 행·기간 칸 이상값·정렬 상태 Copy/Hide 판정(2026-11-02 엔진 갭 EG009·EG017·EG458·EG390). 순수 함수 — disp2.selftest.js
export type J = { result: 'PASS' | 'FAIL' | 'ERROR' | 'NA'; why: string };

/** 조회 전·후 그리드 — rows0/foot0 조회 전 행·합계 행 수 · rows1/foot1 조회 뒤. 조회 뒤에도 합계 행이 없으면 대상 아님 */
export function judgeSumBefore(s: { rows0: number; foot0: number; rows1: number; foot1: number; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (s.rows0 > 0) return { result: 'ERROR', why: `[측정 경로 없음] 진입 직후 이미 ${s.rows0}행 — 조회 전 상태를 못 잼` };
  if (s.foot0 > 0) return { result: 'FAIL', why: `조회 전 빈 그리드에 합계 행 ${s.foot0}개 표시` };
  if (s.rows1 <= 0) return { result: 'ERROR', why: `[측정 경로 없음] 조회 뒤 0행 — 합계 행 유무 미확인` };
  if (!s.foot1) return { result: 'NA', why: `조회 ${s.rows1}행 뒤에도 합계 행 없음 — 합계 없는 화면` };
  return { result: 'PASS', why: `조회 전 합계 행 0 · 조회 ${s.rows1}행 뒤 합계 행 ${s.foot1}개` };
}

/** 기간 값이 달력에 있는 값인지 — YYYYMM · YYYYMMDD 숫자 8/6자리만 본다 */
export function badPeriod(v: string): boolean {
  const t = String(v ?? '').trim();
  if (/^\d{8}$/.test(t)) { const m = +t.slice(4, 6), d = +t.slice(6, 8); return m < 1 || m > 12 || d < 1 || d > new Date(+t.slice(0, 4), m, 0).getDate(); }
  if (/^\d{6}$/.test(t)) { const m = +t.slice(4, 6); return m < 1 || m > 12; }
  return false;
}

/** 칸 이름 기간(YYYYMM·YYYYMMWW) — 뒤 두 자리는 주차일 수 있어 월만 본다(DMF0082 W_20261144 = 2026년 11월 44주차 · 문서 20280001 = 월 00) */
//   2026-11-10 T186(SCP0108 2번 허위 FAIL): 8자리 이름은 앞 번호 + 연월('01'+'202611' = 01202611)일 수도 있다 — 'YYYYMM??' · '??YYYYMM' 두 읽기 중
//   하나라도 연도 1900~2100·월 1~12 이면 정상. 둘 다 아니면 이상값(문서 20280001: 2028년 00월 · '280001' 은 연도 2800)
export function badPeriodName(v: string): boolean {
  const t = String(v ?? '').trim(); if (!/^\d{6}$|^\d{8}$/.test(t)) return false;
  const ym = (y: number, m: number) => y >= 1900 && y <= 2100 && m >= 1 && m <= 12;
  if (t.length === 6) return !ym(+t.slice(0, 4), +t.slice(4, 6));
  return !(ym(+t.slice(0, 4), +t.slice(4, 6)) || ym(+t.slice(2, 6), +t.slice(6, 8)));
}

/** 기간 칸 스윕 — cols 대상 칸 · checked 본 값 수 · bad 이상값 예시 */
export function judgePeriodSweep(s: { cols: string[]; checked: number; bad: string[] }): J {
  if (!s.cols.length) return { result: 'NA', why: '기간 값 칸 없음(이름에 DATE·MONTH·WEEK·PERIOD·YYYYMM)' };
  if (!s.checked) return { result: 'ERROR', why: `[측정 경로 없음] 기간 칸 ${s.cols.length}개에 YYYYMM·YYYYMMDD 값 0건` };
  if (s.bad.length) return { result: 'FAIL', why: `기간 칸 값 ${s.checked}건 중 달력에 없는 값 ${s.bad.length}건: ${s.bad.slice(0, 4).join(', ')}` };
  return { result: 'PASS', why: `기간 칸 ${s.cols.length}개 값 ${s.checked}건 이상값 0` };
}

/** 정렬 상태에서 Copy·Hide — want 첫 칸 표시값 · clip Copy 뒤 클립보드 · hideMenu 메뉴 유무 · hidden 칸 숨김 · sorted 끝까지 정렬 유지 */
export function judgeSortedCopyHide(s: { sorted: boolean; want: string; clip: string; hideMenu: boolean; hidden: boolean; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  // 병합 칸은 범위 전 행이 복사된다 — 줄마다 같은 값이면 정상
  const lines = s.clip.split(/\r?\n/).map(t => t.trim()).filter(Boolean);
  if (!lines.length || lines.some(t => t !== s.want.trim())) return { result: 'FAIL', why: `정렬 상태 Copy — 칸 '${s.want}' ≠ 클립보드 '${s.clip}'` };
  if (s.hideMenu && !s.hidden) return { result: 'FAIL', why: `정렬 상태 Hide 메뉴 눌러도 칸 안 숨겨짐` };
  if (!s.sorted) return { result: 'FAIL', why: `Copy·Hide 뒤 정렬 풀림` };
  return { result: 'PASS', why: `정렬 유지 · Copy '${s.want}'${s.hideMenu ? ' · Hide 동작' : ' · Hide 메뉴 없음(미측정)'}` };
}

/** 동적 칸 정렬·필터·Copy — binding 없으면 동적 칸 없는 화면 (EG385·EG404) */
export function judgeDynSort(s: { binding: string; sorted: boolean; filterIcon: boolean; want: string; clip: string; why?: string }): J {
  if (s.why) return { result: 'ERROR', why: `[측정 경로 없음] ${s.why}` };
  if (!s.binding) return { result: 'NA', why: '동적 기간 칸 없음' };
  if (!s.sorted) return { result: 'FAIL', why: `동적 칸 ${s.binding} F3·헤더 클릭으로 정렬 안 됨` };
  if (!s.filterIcon) return { result: 'FAIL', why: `동적 칸 ${s.binding} F4 뒤 필터 아이콘 없음` };
  // T187: 빈 칸 복사는 Copy 동작 증명 재료가 아니다(클립보드 '\n') — 판정 보류
  if (!s.want.trim()) return { result: 'ERROR', why: `[측정 재료 부족] 동적 칸 ${s.binding} 값이 있는 행 없음 — Copy 미측정(정렬·필터 아이콘은 정상)` };
  const lines = s.clip.split(/\r?\n/).map(t => t.trim()).filter(Boolean);
  if (!lines.length || lines.some(t => t.replace(/,/g, '') !== s.want.trim().replace(/,/g, ''))) return { result: 'FAIL', why: `동적 칸 ${s.binding} Copy — 칸 '${s.want}' ≠ 클립보드 '${s.clip.slice(0, 40)}'` };
  return { result: 'PASS', why: `동적 칸 ${s.binding} 정렬·필터 아이콘·Copy '${s.want}' 정상` };
}

/** 방향키 반복 응답 — ms 키마다 선택 이동까지 시간. 앞 10회 대비 뒤 10회 평균이 2배를 넘고 200ms 를 넘으면 저하 (EG416) */
export function judgeKeyTrend(s: { ms: number[]; moved: number }): J {
  if (s.ms.length < 20) return { result: 'ERROR', why: `[측정 경로 없음] 방향키 이동 ${s.ms.length}회만 측정(행 부족 또는 선택 안 움직임)` };
  const avg = (a: number[]) => Math.round(a.reduce((x, y) => x + y, 0) / a.length); const a = avg(s.ms.slice(0, 10)), b = avg(s.ms.slice(-10));
  if (b > 200 && b > a * 2) return { result: 'FAIL', why: `방향키 ${s.ms.length}회 — 앞 10회 평균 ${a}ms → 뒤 10회 ${b}ms 누적 지연` };
  return { result: 'PASS', why: `방향키 ${s.ms.length}회 — 앞 10회 평균 ${a}ms · 뒤 10회 ${b}ms · 누적 지연 없음` };
}

/** Division 값별 조회 오류 — runs Division·HTTP 오류·ORA·행 수 (EG206) */
export function judgeDivSearches(s: { runs: { div: string; bad: string[]; rows: number; sentDiv?: string }[] }): J {
  if (s.runs.length < 2) return { result: 'NA', why: `Division 후보 ${s.runs.length}건 — 순회 대상 아님` };
  const f = s.runs.filter(r => r.bad.length);
  if (f.length) return { result: 'FAIL', why: `Division ${s.runs.length}개 중 조회 오류 ${f.length}개: ${f.slice(0, 3).map(r => `${r.div} ${r.bad[0]}`).join(' / ')}` };
  // 요청 본문의 Division 이 고른 값이 아니면 순회가 안 된 것이다(2026-11-02 8개 전부 2430행 허위 PASS)
  // 다중 선택 Division 은 값이 콤마로 함께 실려 값별 순회가 안 된다(SCP0007) — 전체 조회 오류만 잰다
  if (s.runs.some(r => (r.sentDiv || '').includes(','))) return { result: 'PASS', why: `다중 선택 Division(요청 '${(s.runs[0].sentDiv || '').slice(0, 30)}') — 값별 순회 불가 · 전체 조회 오류 0 · 행 ${s.runs[0].rows}` };
  const un = s.runs.filter(r => r.sentDiv !== r.div.split(/\s/)[0]);
  if (un.length) return { result: 'ERROR', why: `[측정 경로 없음] Division ${s.runs.length}개 중 ${un.length}개 값이 요청에 안 실림: ${un.slice(0, 3).map(r => `${r.div.slice(0, 8)}→${r.sentDiv || '없음'}`).join(', ')}` };
  if (!s.runs.some(r => r.rows > 0)) return { result: 'ERROR', why: `[측정 경로 없음] Division ${s.runs.length}개 전부 0행 — 조회가 실행됐는지 확인 필요` };
  return { result: 'PASS', why: `Division ${s.runs.length}개 조회 오류 0 · 행 ${s.runs.map(r => `${r.div.slice(0, 6)}:${r.rows}`).join(' ')}` };
}

/** 콤보 칸 코드 그대로 노출 — cols 칸별 후보에 없는 코드 수 · checked 본 칸 수 (EG014) */
export function judgeCodeShown(s: { checked: number; cols: { b: string; n: number; ex: string }[] }): J {
  if (!s.checked) return { result: 'NA', why: '값 있는 콤보 칸 없음' };
  if (s.cols.length) return { result: 'ERROR', why: `[확인 대상] 콤보 칸 ${s.checked}개 중 후보에 없는 코드가 그대로 보이는 칸 ${s.cols.length}개: ${s.cols.slice(0, 4).map(c => `${c.b} ${c.n}행(${c.ex})`).join(', ')} — 비활성 코드 여부 확인` };
  return { result: 'PASS', why: `콤보 칸 ${s.checked}개 전부 이름 표시` };
}
