// 조회 기간 시간축 — 시간축 SP(P_DMF0020_GET_SPREAD_TITLE_DATE, BTN_MPG main/SPREAD_TITLE_DATE) 결과를
//   그리드 동적 컬럼 키(W_yyyymmdd / M_yyyymm01)로 바꾼다.
//
// 배경(2026-10-13 클라우드 통테 지적 — Sales Site 'AJ상사_AB_TES' 가 조회 기간 중 5주만 표시):
//   조회 SP 는 조회 기간 전체의 주/월 컬럼을 PIVOT 으로 내려주지만(값 없는 주는 NULL), BE MyBatis 가
//   callSettersOnNulls 미설정이라 NULL 컬럼은 응답 Map 에서 키째 빠진다. 그리드는 행의 키로 컬럼을 만들어
//   값이 있는 주차만 컬럼이 선다. 그래서 컬럼 뼈대는 데이터가 아니라 같은 달력에서 받아 그린다.
//
// 키 규칙은 조회 SP 의 V_PROD 와 동일하다 (PKG_DMF0020 body 5862-5872):
//   주 = 'W_' || SCM_SYS_CALENDAR_M.BASIS_START_DATE  /  월 = 'M_' || BASIS_YYYYMM || '01'
//   시간축 SP 도 같은 달력 테이블을 같은 기간으로 읽으므로 데이터 행의 키와 1:1 로 맞는다.
//   월경계 분할 주차(예: W_20261001, 월 1일 시작)도 두 SP 가 똑같이 낸다 — 그리드의 "월요일 또는 1일" 필터 그대로.

export interface PeriodAxisRow {
  BASIS_START_DATE: string; // 주 시작일 yyyymmdd
  BASIS_YYYYMM: string; // yyyymm
  WEEK_NAME?: string; // 'W36' 등 — 헤더는 그리드가 binding 에서 다시 계산하므로 여기선 쓰지 않는다
  DATE_SHORT1_NAME?: string; // 'MMDD'
  [key: string]: string | undefined;
}

const YMD = /^\d{8}$/;
const YM = /^\d{6}$/;

/** 시간축 행 → W_/M_ 컬럼 키 (중복 제거, 오름차순). 형식이 깨진 행은 버린다. */
export const periodBindingsOf = (rows: readonly PeriodAxisRow[] | undefined): string[] => {
  if (!rows || rows.length === 0) return [];
  const set = new Set<string>();
  for (const r of rows) {
    const w = r.BASIS_START_DATE ?? '';
    const m = r.BASIS_YYYYMM ?? '';
    if (YMD.test(w)) set.add(`W_${w}`);
    if (YM.test(m)) set.add(`M_${m}01`);
  }
  return [...set].sort();
};

/**
 * 시간축 행 → yyyymm 별 주 시작일 목록 (오름차순). Monthly 저장 시 월 입력값을 실제 주차로 펼치는 백필용.
 * 데이터 행의 W_ 키에서 모으던 것(SalesFuturePrice.tsx weeklyDatesByMonth)과 같은 모양 — 데이터가 없는
 *   달에도 컬럼이 서게 되면서(위 배경) 그 달의 주차를 데이터 행에서 빌릴 수 없어, 달력에서 직접 받는다.
 * 월 귀속은 데이터 키와 같이 주 시작일의 yyyymm 으로 본다 (W_20260928 → 202609, W_20261001 → 202610).
 */
export const weeklyDatesByMonthOf = (
  rows: readonly PeriodAxisRow[] | undefined
): Map<string, string[]> => {
  const map = new Map<string, string[]>();
  if (!rows) return map;
  for (const r of rows) {
    const w = r.BASIS_START_DATE ?? '';
    if (!YMD.test(w)) continue;
    const ym = w.slice(0, 6);
    const list = map.get(ym);
    if (list) {
      if (!list.includes(w)) list.push(w);
    } else {
      map.set(ym, [w]);
    }
  }
  for (const list of map.values()) list.sort();
  return map;
};
