import {
  ADMIN_SHEET_NAME,
  EE_UC_DIVISION_TOKEN,
  GRID_SHEETS,
  SHEETS,
  SPD_SHEET_ORDER,
  type GridSheet,
} from '../opt-capa.constants';
import type { ExcludedSheetRow } from '../opt-capa.types';

import { str } from './optCapa.candidates';

/** AS-IS `CreateSpread` 가 `Preparation Rate` 탭을 만드는 첫 Division(cs:617). */
const PREP_RT_CREATE_DIVISION = '40';

/**
 * 탭 집합 · 조회영역 전용버튼 노출 파생 — AS-IS 명령형 3회 호출을 순수함수로 이식.
 *
 * AS-IS 는 `SetVisibleSearchControls()`/탭 add·remove 를 Form_Load(cs:196) · Division 변경
 * (cs:3397) · 탭 전환(cs:3689) **세 곳에서 각각** 부른다. TO-BE 는 `useMemo` 파생으로 두어
 * 호출 누락형 버그가 구조적으로 불가능하게 만든다(design 01 §2.1 R02~R04 비고행).
 */

/**
 * Division 별 제외 시트 — `init` `o_rc4`(`OPMZ_OPT_CAPA_EXPT_DIV` lookup, `VALID_YN='Y'` 만) 구동.
 *
 * `SHEET_NAME` 은 컬럼 메타와 같은 **표시명 축**이다(A축) — `SHT_NM`(camelCase) 로 비교하면
 * 한 건도 안 걸려 탭이 항상 8개가 된다. 하드코딩·화이트리스트 금지(hook #113 / design 01 R13).
 */
export const buildExcludedSheetNames = (
  exclusionRows: readonly ExcludedSheetRow[],
  divisionId: string
): Set<string> => {
  if (!divisionId) return new Set<string>();
  return new Set(
    exclusionRows
      .filter(row => str(row.DIVISION_ID) === divisionId)
      .map(row => str(row.SHEET_NAME))
      .filter(Boolean)
  );
};

/**
 * 노출 탭 기본 집합 — `init` 응답 전에만 쓴다. 응답 뒤의 탭 순서는 {@link buildInitialSheets} ·
 * {@link nextTabOrder} 가 정한다.
 */
export const buildVisibleSheets = (
  exclusionRows: readonly ExcludedSheetRow[],
  divisionId: string
): GridSheet[] => {
  const excluded = buildExcludedSheetNames(exclusionRows, divisionId);
  return GRID_SHEETS.filter(sheet => !excluded.has(ADMIN_SHEET_NAME[sheet]));
};

/**
 * 첫 진입 탭 — AS-IS `CreateSpread`(cs:595-639) 이식.
 * `Preparation Rate` 는 첫 Division 이 `40` 일 때만 만들고, 그 뒤 제외 탭을 지운다.
 */
export const buildInitialSheets = (
  exclusionRows: readonly ExcludedSheetRow[],
  divisionId: string
): GridSheet[] => {
  const excluded = buildExcludedSheetNames(exclusionRows, divisionId);
  const prepRt: readonly GridSheet[] = divisionId === PREP_RT_CREATE_DIVISION ? [SHEETS.PREP_RT] : [];
  const created: GridSheet[] = [
    SHEETS.NO_WORK,
    SHEETS.DAILY_CAPA,
    SHEETS.SOP_EOP,
    SHEETS.RAMP_UP,
    SHEETS.RAMP_UP_ITVL,
    ...prepRt,
    SHEETS.UTIL_RT,
    SHEETS.YLD_ELEC,
  ];
  return created.filter(sheet => !excluded.has(ADMIN_SHEET_NAME[sheet]));
};

/**
 * Division 변경 시 탭 — AS-IS `ClbDivision_SelectedIndexChanged`(cs:3710-3768) 이식.
 * 제외 탭을 지우고, 없는 탭을 `SPD_SHEET_ORDER` 순서로 맨 뒤에 붙인다. 순서는 이동 이력에 따라 달라진다.
 */
export const nextTabOrder = (
  currentSheets: readonly GridSheet[],
  exclusionRows: readonly ExcludedSheetRow[],
  divisionId: string
): GridSheet[] => {
  const excluded = buildExcludedSheetNames(exclusionRows, divisionId);
  const isShown = (sheet: GridSheet) => !excluded.has(ADMIN_SHEET_NAME[sheet]);
  const kept = currentSheets.filter(isShown);
  const added = SPD_SHEET_ORDER.filter(sheet => isShown(sheet) && !kept.includes(sheet));
  return [...kept, ...added];
};

/**
 * 활성 탭 폴백 — 현재 탭이 제외되면 첫 탭으로 내린다(design 01 R13 마지막 문장 / L-13).
 * 노출 탭이 0건이면 `undefined` 를 돌려주고 호출부가 그리드를 렌더하지 않는다.
 */
export const resolveActiveSheet = (
  visibleSheets: readonly GridSheet[],
  activeSheet: GridSheet
): GridSheet | undefined =>
  visibleSheets.includes(activeSheet) ? activeSheet : visibleSheets[0];

/** 조회영역 전용버튼 3종 노출 — AS-IS `SetVisibleSearchControls`(cs:3698-3730). */
export interface FeatureButtonVisibility {
  /** R02 — 활성시트 == No Work (cs:3700·3705 / else 3726). */
  excelUpload: boolean;
  /** R03 — 동일 조건 (cs:3706 / else 3727). */
  excelForm: boolean;
  /** R04 — No Work **AND** `division != 'EE_UC'` (cs:3709-3718 / else 3728). Division 축을 갖는 유일 버튼. */
  batchSave: boolean;
}

export const buildFeatureButtonVisibility = (
  activeSheet: GridSheet,
  divisionId: string
): FeatureButtonVisibility => {
  const isNoWork = activeSheet === SHEETS.NO_WORK;
  return {
    excelUpload: isNoWork,
    excelForm: isNoWork,
    batchSave: isNoWork && divisionId !== EE_UC_DIVISION_TOKEN,
  };
};
