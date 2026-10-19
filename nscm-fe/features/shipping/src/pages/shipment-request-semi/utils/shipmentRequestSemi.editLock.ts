// SSP0045 그리드 편집잠금 순수 함수 1벌 (design 01 §2.5 L05·L07·L11·L14 / 03 §3.3 L-D·L-D'·L-F).
//
//   필수: 이 파일의 `isEditableDayCell` 하나를 `beginningEdit`(e.cancel) · `formatItem`(배경) ·
//   `pastingCell` 세 경로가 **공유**한다. 두 벌로 나누면 한쪽만 고쳐지는 표류가 생긴다(K2).
//
//   금지: "초기값 = 전체 개방" 경로를 재현하지 말 것. AS-IS 루프의 초기값(0..ColumnCount-1)은
//   case1/case2 가 모두 거짓이면 case3 이 **항상** 참이라 수학적으로 도달 불가다(design 01 §2.5).
//   그 초기값을 기본값으로 이식하면 전 컬럼이 열리는 중대 결함이 된다 → **기본 거부 화이트리스트**로 구현한다.

import {
  COLUMN,
  EDITABLE_MEASURE,
  PIVOT_PREFIX,
} from '../shipment-request-semi.constants';

type Row = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

/** SUM 컬럼(M_/W_) 판정 — AS-IS `SetLockSumColumn` 의 컬럼 Tag prefix 기준(G11 / L-F). */
export const isSumBinding = (binding: string): boolean =>
  binding.startsWith(PIVOT_PREFIX.MONTH) || binding.startsWith(PIVOT_PREFIX.WEEK);

/** 일자 컬럼(D_yyyymmdd) 판정. */
export const isDayBinding = (binding: string): boolean => /^D_\d{8}$/.test(binding);

/** 동적 기간칼럼 전체(M_/W_/D_) 판정 — 값 클리어(R12)·가시성 매트릭스(R07) 대상 범위. */
export const isPivotBinding = (binding: string): boolean =>
  isSumBinding(binding) || binding.startsWith(PIVOT_PREFIX.DAY);

/** binding 에서 yyyymmdd 8자리 추출. 일자 컬럼이 아니면 ''. */
export const dayOfBinding = (binding: string): string =>
  isDayBinding(binding) ? binding.slice(2) : '';

/**
 * frozen 승격 — AS-IS cs:479-482 / cs:1280-1283.
 *   `FROZEN_YYYYMMDD` 가 공백이거나 조회 시작일보다 이르면 **조회 시작일로 승격**한다.
 */
export const resolveFrozen = (row: Row, startPeriod: string): string => {
  const frozen = str(row[COLUMN.FROZEN_YYYYMMDD]);
  if (!frozen || frozen < startPeriod) return startPeriod;
  return frozen;
};

export interface DayRange {
  from: string; // yyyymmdd (포함)
  to: string; // yyyymmdd (포함)
}

/**
 * BOD × Frozen 3-케이스 편집구간 (design 01 §2.5 / 03 §3.3 L-D·L-D' — K1).
 *   case1  frozen >= bodTo   → null (편집 구간 없음)
 *   case2  bodFrom >= frozen → [bodFrom .. bodTo]
 *   case3  그 외              → [frozen  .. bodTo]
 *
 * 의도적 이탈 1건(design 01 §5.1 Q7): AS-IS 는 `Convert.ToInt32(공백)` 에서 FormatException 으로
 *   죽는다(try/catch 없음). TO-BE 는 크래시를 재현하지 않고 **case1 동등(편집 없음)으로 안전 차단**한다.
 */
export const editableDayRange = (row: Row, startPeriod: string): DayRange | null => {
  const bodFrom = str(row[COLUMN.BOD_FROM_YYYYMMDD]);
  const bodTo = str(row[COLUMN.BOD_TO_YYYYMMDD]);
  if (!bodFrom || !bodTo) return null; // Q7 — 공백/NULL 이면 안전 차단
  const frozen = resolveFrozen(row, startPeriod);
  if (!frozen) return null;
  if (frozen >= bodTo) return null; // case1
  if (bodFrom >= frozen) return { from: bodFrom, to: bodTo }; // case2
  return { from: frozen, to: bodTo }; // case3
};

/**
 * 셀 편집 가능 판정 — 이 화면의 유일한 편집 게이트.
 *
 * 평가 순서가 곧 규칙이다(K3):
 *   ① SUM(M_/W_) 절대 잠금 — 개방 규칙보다 **먼저** 평가한다(AS-IS `SetLockSumColumn` 이 개방 직후 호출).
 *   ② 고정 18컬럼은 어떤 경우에도 편집 불가(`INPUT_TP_CD='S'` 전건 + L04 상한).
 *   ③ measure 가 `SHIP_REQ` 인 행만 편집 후보(L-D 루프 조건).
 *   ④ 신규행이면서 BOD 미선택이면 전 기간셀 거부 — 입력 순서 강제(L11 / K4).
 *   ⑤ BOD × Frozen 3-케이스 구간 안에서만 허용.
 */
export const isEditableDayCell = (row: Row, binding: string, startPeriod: string): boolean => {
  if (isSumBinding(binding)) return false; // ①
  if (!isDayBinding(binding)) return false; // ②
  if (str(row[COLUMN.MEASURE]) !== EDITABLE_MEASURE) return false; // ③
  if (str(row.CRUD_TYPE) === 'I' && !str(row[COLUMN.BOD_ID])) return false; // ④
  const range = editableDayRange(row, startPeriod); // ⑤
  if (!range) return false;
  const ymd = dayOfBinding(binding);
  return ymd >= range.from && ymd <= range.to;
};

/**
 * Frozen 이전(확정) 구간의 경계 일자 — 배경 회색 `#F2F2F2` 대상 판정 입력 (design 03 §3.2 R15-b / G10).
 *   AS-IS cs:1090: `FROZEN_YYYYMMDD > 조회시작일` 일 때
 *   `Cells[i, MEASURE_LABEL+1, i, index("D_"+frozen)-1]` 구간을 칠한다.
 *   즉 **원본 FROZEN 값**(승격 전)이 조회 시작일보다 뒤일 때만 대상이고, frozen 당일은 제외된다.
 *
 *   반환은 "경계 일자"이지 "이 셀이 회색인가"가 아니다 — 판정이 **컬럼 인덱스 기준**이어야
 *   그 구간에 섞여 있는 `M_`/`W_` SUM 칸까지 AS-IS 처럼 함께 칠해지기 때문이다.
 *   binding 의 날짜만으로 판정하면 SUM 칸(주/월 단위)을 일자 경계와 비교할 수 없어 누락된다
 *   (react-gap-audit iter-1 G-18). 실제 인덱스 비교는 호출부(formatItem)가 수행한다.
 */
export const frozenPastBoundary = (row: Row, startPeriod: string): string | null => {
  const frozen = str(row[COLUMN.FROZEN_YYYYMMDD]);
  if (!frozen || frozen <= startPeriod) return null;
  return frozen;
};

/** 신규행 여부 — 저장 대상 판정·BOD 팝업 진입 가드(BG11/BG17) 공용. */
export const isInsertRow = (row: Row): boolean => str(row.CRUD_TYPE) === 'I';
