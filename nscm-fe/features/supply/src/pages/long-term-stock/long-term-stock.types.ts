import type { MENU_ID, SHEETS } from './long-term-stock.constants';

// 조회조건(입력 중) — SearchArea 가 읽고 쓴다. AS-IS SCP0084_LongTermStock.cs 조회조건 4종.
//   divisionId/plantId/longTermTypeCode 는 콤마 다중값(CheckedList), month 는 단일값.
export interface SearchParams {
  month: string; // YYYYMM — monthPicker(기본=최신월)
  divisionId: string; // 콤마 다중(전체=ALL) — cboDivision(Division_SCP + EE 제외)
  plantId: string; // 콤마 다중(전체=ALL) — clbPlant(PlantByGroup1_SCP_ALL, Division 클라 cascade)
  longTermTypeCode: string; // 콤마 다중(전체=ALL) — cboLongTermType(정적 3옵션)
}

// 조회 결과 행 — GET SP 반환 ∩ SCM_MST_SHEET_COLUMNS 메타(design 03 §1, 59컬럼). 컬럼셋은
//   admin 메타 구동이라 동적 인덱스 시그니처로 받고, 코드가 직접 참조하는 판정/저장키 컬럼만 명시한다.
export type LongTermStockRow = ResponseData<MENU_ID, SHEETS.MAIN>;
