import {
  ADMIN_SHEET_NAME,
  EE_UC_DIVISION_TOKEN,
  GRID_SHEETS,
  SHEETS,
  type GridSheet,
} from '../opt-capa.constants';
import type { ExcludedSheetRow } from '../opt-capa.types';

import { str } from './optCapa.candidates';

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
 * 노출 탭 — 초기 로드와 Division 변경이 **같은 파생식 하나**를 쓴다(design 01 R14).
 *
 * AS-IS `CreateSpread` 의 `division == "40"` 리터럴 분기(cs:587-593)는 제외목록 도입(2025-09-11)
 * 이전의 잔재이고, 같은 파일에 구버전 분기가 통째로 주석처리돼 남아 있다(cs:3465-3522).
 * 그 리터럴을 이식하면 7 division(`81_HD`/`81_HM`/`81_ST`/`EE_HD`/`EE_HG`/`EE_HM`/`EE_ST`)에서
 * "진입 직후 7탭 → Division 한 번 바꾸면 8탭" 이라는 AS-IS 결함이 그대로 복제된다(§5 V-1 FAIL).
 * 제외목록 단일 원천이 설계 권고이며, 그 결정은 04 리포트에 "확인 필요(사용자 축)" 로 남겼다.
 */
export const buildVisibleSheets = (
  exclusionRows: readonly ExcludedSheetRow[],
  divisionId: string
): GridSheet[] => {
  const excluded = buildExcludedSheetNames(exclusionRows, divisionId);
  return GRID_SHEETS.filter(sheet => !excluded.has(ADMIN_SHEET_NAME[sheet]));
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
