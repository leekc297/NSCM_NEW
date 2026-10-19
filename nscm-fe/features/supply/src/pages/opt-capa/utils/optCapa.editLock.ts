import {
  COATING_OPERATION_ID,
  COLUMN,
  EE_UC_DIVISION_TOKEN,
  SHEETS,
  type GridSheet,
} from '../opt-capa.constants';
import type { GridRow } from '../opt-capa.types';

import { str } from './optCapa.candidates';

/**
 * 화면 고유 편집 잠금 — AS-IS `EditButton`(cs:833-921) 의 Lock 집합 중 **메타로 표현할 수 없는
 * 규칙만** 남긴 것이다.
 *
 * ## 컬럼 단위 잠금은 여기 없다 (2026-09-26 iter-2)
 * 파리티의 정본은 `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 메타다(hook #130 — LockColumn 컬럼명을 FE
 * 상수배열로 이식 금지 / CLAUDE.md §2 "속성 단위 덮어쓰기 금지"). iter-1 에서는 메타가 131행
 * 전건 `'S'`(SEARCH_ONLY)라 공용 `GridUtils.isEditableCell` 이 전 셀을 잠갔고, 그 사이를
 * 메우려고 시트별 Lock 컬럼 배열(`LOCKED_COLUMNS`)을 FE 에 들고 `beginningEdit` 를 **양방향**
 * 으로 override 했다. `05_register.sql [블록 3]` 적용(2026-09-26, S 60 / M 48 / O 23 실측)으로
 * 메타가 AS-IS Lock 집합과 1:1 일치하게 되었으므로 그 배열을 **삭제**했다 — 같은 사실을 코드와
 * 메타 두 곳에 두면 admin 에서 메타를 고쳐도 화면이 안 바뀌는 사고(SCM0008 형)가 된다.
 *
 * 그래서 호출부(`OptCapaGrid`)의 판정식은 `공용 메타 게이트 AND 이 파일의 추가 잠금` 이고,
 * `beginningEdit` override 는 **단방향(잠그기만)** 이다.
 *
 * ## 메타로 표현할 수 없어 남은 규칙
 *   · R-02·R-03 시트별 편집모드 — 조회 직후 전 컬럼 잠금, Edit 버튼이 유일 해제 경로(행/열 축 아님)
 *   · R-05 비`EE_UC` 의 `LINE_TYPE` 추가 잠금 (division 종속)
 *   · R-06 Daily Capa × `EE_UC` × 행 `OPERATION_ID` 교차 잠금 (행 값 종속)
 *   · R-07 `LINE_TYPE` 셀 콤보 주입 자체가 `EE_UC` 한정
 *
 * ## 신규행
 * AS-IS `Insert_Row` 의 `LockRange` 집합이 `EditButton` 의 `LockColumn` 집합과 시트별로
 * **완전히 동일**하다(cs:1002-1054 ↔ cs:876-918 대조) → 행 상태 분기가 없다(R-16 / `IM`·`IO` 불요).
 */

export interface LockRuleArgs {
  sheet: GridSheet;
  binding: string;
  row: GridRow | undefined;
  /** 확정 조회조건의 division — AS-IS 도 `cboDivision` 현재값을 읽는다(cs:847·885·899). */
  divisionId: string;
}

/**
 * Daily Capa × `EE_UC` 교차 잠금(R-06, cs:848-867).
 * 행 `OPERATION_ID == 'E2000'`(Coating) → `CAPA` 잠금 / 그 외 → `M_MIN`·`LANE`·`WIDE_YN` 잠금.
 * 비`EE_UC` 는 행 분기가 없다(cs:869-873 = 컬럼 잠금만).
 */
const isDailyCapaRowLocked = (binding: string, row: GridRow | undefined): boolean => {
  const isCoating = str(row?.[COLUMN.OPERATION_ID]) === COATING_OPERATION_ID;
  if (isCoating) return binding === COLUMN.CAPA;
  return binding === COLUMN.M_MIN || binding === COLUMN.LANE || binding === COLUMN.WIDE_YN;
};

/** `division.IndexOf("EE_UC") >= 0` — cs:731·848 은 부분문자열 비교다(완전일치 분기와 구분). */
const containsEeUc = (divisionId: string): boolean => divisionId.includes(EE_UC_DIVISION_TOKEN);

/**
 * 화면 고유 추가 잠금 판정 — `true` 면 메타가 편집 가능이라고 해도 잠근다.
 * `beginningEdit`/`pastingCell`/`formatItem` 이 **같은 함수**를 쓴다(판정 불일치 방지).
 *
 * 컬럼 단위 잠금(`DIVISION_ID`/`LINE_NAME`/감사/`PRE_KEY_VALUES` 등)은 여기서 판정하지 않는다 —
 * 메타 `INPUT_TP_CD='S'` 가 정본이다(파일 상단 주석).
 */
export const isLockedByOptCapaRule = ({
  sheet,
  binding,
  row,
  divisionId,
}: LockRuleArgs): boolean => {
  if (!binding) return true;

  // R-05 — 비EE_UC 는 LINE_TYPE 추가 잠금. 여기는 **완전일치**다(cs:887 `division != "EE_UC"`).
  //   `LINE_TYPE` 컬럼이 없는 시트는 메타에 행 자체가 없어 여기까지 오지 않는다(시트 배열 불요).
  if (binding === COLUMN.LINE_TYPE) return divisionId !== EE_UC_DIVISION_TOKEN;

  // R-06 — Daily Capa 는 EE_UC 일 때만 행 단위 교차 잠금이 걸린다.
  if (sheet === SHEETS.DAILY_CAPA && containsEeUc(divisionId)) {
    return isDailyCapaRowLocked(binding, row);
  }

  return false;
};

/**
 * **행 조건부** 잠금인가 — 배경색 3색 구분(hook #95 §3.3)의 Gray 대상 판정용.
 *
 * hook #95 는 Gray(`wj-cell-non-editable`)를 "원래 편집 가능하나 **지금** 잠긴 특수 셀" 에만 허용하고
 * (§1-3), "비편집 컬럼 **전체** 회색칠" 을 안티패턴으로 금지한다(§2 #1·#2). 이 화면의 추가 잠금 2종은
 * 성격이 갈린다:
 *   · R-06 Daily Capa × `EE_UC` × 행 `OPERATION_ID` — **같은 컬럼 안에서 행마다 갈린다** → Gray 대상
 *   · R-05 비`EE_UC` 의 `LINE_TYPE`               — 그 division 에서 **컬럼 전체**가 잠긴다 → 대상 아님
 *     (AS-IS 도 `LockColumn`(cs:889·903) = 컬럼 단위이고 색을 칠하지 않는다 — `SetBGColor` 2건은
 *      전건 주석처리다. Gray 로 칠하면 §2 #2 안티패턴이 된다.)
 *
 * 그래서 Gray 는 이 함수가 참인 셀에만 붙는다. Yellow/White 판정은
 * {@link isLockedByOptCapaRule} 가 그대로 담당한다(판정식 분기 금지 — 같은 함수를 공유한다).
 */
export const isRowConditionalLock = ({ sheet, binding, row, divisionId }: LockRuleArgs): boolean => {
  if (!binding) return false;
  if (sheet !== SHEETS.DAILY_CAPA) return false;
  if (!containsEeUc(divisionId)) return false;
  return isDailyCapaRowLocked(binding, row);
};

/**
 * `LINE_TYPE` 셀 콤보 주입 가드(R-07, cs:3806-3818).
 * `division_id == "EE_UC"` **완전일치** 일 때만 후보를 주입한다 — 그 외에는 드롭다운 자체가 없다.
 */
export const canInjectLineTypeCombo = (divisionId: string): boolean =>
  divisionId === EE_UC_DIVISION_TOKEN;
