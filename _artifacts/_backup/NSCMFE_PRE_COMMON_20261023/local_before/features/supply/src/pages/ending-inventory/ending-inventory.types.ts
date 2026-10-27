import type { MENU_ID, SearchMode, SHEETS } from './ending-inventory.constants';

// 조회조건(입력 중) — SearchArea 가 읽고 쓴다. AS-IS SCP0085_EndingInventory.cs 조회조건.
//   divisionId/plantId 는 콤마 다중값(CheckedList), itemId 는 팝업 단일값.
export interface SearchParams {
  mode: SearchMode; // 조회모드(MONTH 기본/DAILY) — RdoMonth/RdoDate
  month: string; // YYYYMM — monthPicker(MONTH 모드)
  date: string; // YYYYMMDD — datePicker(DAILY 모드)
  divisionId: string; // 콤마 다중(전체=ALL) — cboDivision(MyDivision)
  plantId: string; // 콤마 다중(전체=ALL) — clbPlant(PlantByGroup_SCP, Division cascade)
  itemId: string; // Material 팝업 반환값(콤마 다중) — txtItem_Id
  itemType: string; // 콤마 다중(전체=ALL) — Item Type 콤보. 현재 SP 파라미터 없음(확인 필요)
  devaluationAge: boolean; // Devaluation Age 체크 — 재고월령 39컬럼 표시 토글
}

// 조회 결과 행 — GET SP 반환 ∩ SCM_MST_SHEET_COLUMNS 메타(design 03 §1, 99컬럼). 컬럼셋은
//   admin 메타 구동이라 동적 인덱스 시그니처로 받고, 코드가 직접 참조하는 판정 컬럼만 명시한다.
export type EndingInventoryRow = ResponseData<MENU_ID, SHEETS.MAIN>;
