// SCP0006 Plant 파생값(design/03 §3.2 R-ORG).
//   FROM/TO_YYYYMMDD 셀 변경 시 ORG_FROM/ORG_TO/MERGE_DATE 를 세팅한다. 저장검증(N1~N9)이
//   ORG_*·MERGE_DATE 기준으로 판정하므로 이 파생이 검증의 전제다(design/03 R-ORG).

import { safeString } from '@foundation/utils';

/** 하이픈 제거 후 8자리 숫자만. 그 외는 빈 문자열. */
const toYmd8 = (value: unknown): string => {
  const digits = safeString(value).replace(/\D/g, '');
  return digits.length === 8 ? digits : '';
};

/** FROM/TO → { ORG_FROM_YYYYMMDD, ORG_TO_YYYYMMDD, MERGE_DATE }. */
export const deriveOrgDates = (
  fromValue: unknown,
  toValue: unknown
): { ORG_FROM_YYYYMMDD: string; ORG_TO_YYYYMMDD: string; MERGE_DATE: string } => {
  const orgFrom = toYmd8(fromValue);
  const orgTo = toYmd8(toValue);
  return {
    ORG_FROM_YYYYMMDD: orgFrom,
    ORG_TO_YYYYMMDD: orgTo,
    MERGE_DATE: orgFrom + orgTo,
  };
};

/**
 * 저장검증(N1~N9) 직전, 각 행의 ORG_* 파생(MERGE_DATE 포함)을 현재 화면값(FROM/TO_YYYYMMDD)으로 재동기화.
 *
 * AS-IS 는 모델 Changed 이벤트(SCP0006_ProjectRoute.cs:225 `dsdm.Changed` → spdPlant_Change →
 *   SetOrgData, cs L1331-1399)로 FROM/TO 가 '어떤 방식으로든' 바뀌면 ORG 를 재파생한다 — 타이핑·
 *   붙여넣기·채우기·프로그램 세팅 전부. TO-BE 는 파생을 cellEditEnded(대화형 편집 완료)에만 걸어
 *   붙여넣기/드래그-채우기 편집에선 ORG 가 stale 해지고, 화면엔 같은 날짜로 보여도 검증이 옛 ORG 로
 *   비교해 N1(중첩 종료일)을 오탐한다(2026-11-12 실측). 검증 직전 전건 재파생으로 AS-IS 파리티 복원.
 *   저장 payload 는 화면값(FROM/TO_YYYYMMDD)을 직접 쓰므로(plantSaveRequest) ORG 는 검증 전용 —
 *   이 재동기화는 저장 데이터에 영향이 없다.
 */
export const syncOrgDates = (rows: readonly unknown[]): void => {
  for (const row of rows) {
    const rec = row as Record<string, unknown>;
    const derived = deriveOrgDates(rec.FROM_YYYYMMDD, rec.TO_YYYYMMDD);
    rec.ORG_FROM_YYYYMMDD = derived.ORG_FROM_YYYYMMDD;
    rec.ORG_TO_YYYYMMDD = derived.ORG_TO_YYYYMMDD;
    rec.MERGE_DATE = derived.MERGE_DATE;
  }
};

export { toYmd8 };

// ── 저장검증 실패 셀 하이라이트(design/03 §3.4 SetBGColor, AS-IS IS_PASS_N* 파리티) ──
//   AS-IS 는 실패 행에 IS_PASS_N* 플래그를 세우고 그리드가 셀을 (재)그릴 때마다 그 플래그로 색을
//   칠해, 스크롤/리페인트에도 하이라이트가 유지된다. TO-BE 가 종전에 쓰던 DOM 직접 칠하기
//   (getCellElement().style.background)는 Wijmo 가 가상 스크롤로 셀 DOM 을 재활용하면 지워졌다
//   (04_react-gap 잔여 gap). 실패 셀을 행 객체에 심어두고 formatItem 에서 읽어 칠하면 AS-IS 처럼
//   영구 유지된다 — 아래 유틸이 그 플래그(행별 invalid 컬럼 집합)를 세우고/지운다.

/** 행 객체에 심는 invalid 컬럼 집합 키(런타임 전용 — 저장 payload·검증 비교에 미사용). */
const INVALID_COLS_KEY = '__INVALID_COLS__';

/** 이 행에서 column 이 저장검증 실패 셀인지(formatItem 이 호출). */
export const isPlantCellInvalid = (row: unknown, column: string): boolean => {
  const cols = (row as Record<string, unknown>)[INVALID_COLS_KEY];
  return cols instanceof Set && cols.has(column);
};

/** 저장검증 실패 셀 목록을 행별로 모아 각 행에 플래그로 심는다(기존 cells 는 clearPlantInvalidMarks 가 먼저 비움). */
export const markPlantInvalidCells = (cells: { row: unknown; column: string }[]): void => {
  for (const { row, column } of cells) {
    const rec = row as Record<string, unknown>;
    const cols = rec[INVALID_COLS_KEY] instanceof Set ? (rec[INVALID_COLS_KEY] as Set<string>) : new Set<string>();
    cols.add(column);
    rec[INVALID_COLS_KEY] = cols;
  }
};

/** 모든 행의 invalid 플래그 제거(재검증/재시도 전 AS-IS 매 검사 BG 리셋 대응). */
export const clearPlantInvalidCells = (rows: readonly unknown[]): void => {
  for (const row of rows) {
    delete (row as Record<string, unknown>)[INVALID_COLS_KEY];
  }
};
