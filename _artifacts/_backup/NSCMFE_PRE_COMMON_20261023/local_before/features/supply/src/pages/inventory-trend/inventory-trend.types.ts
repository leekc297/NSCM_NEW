import type { MENU_ID, SHEETS } from './inventory-trend.constants';

// 조회조건(입력 중) — SearchArea 가 읽고 쓴다. AS-IS SCP0101_InventoryTrend.cs 조회조건 5종.
//   divisionId/plantId 는 콤마 다중값(CheckedList), itemId 는 텍스트(콤마 다중)/팝업 반환값.
export interface SearchParams {
  month: string; // YYYYMM — monthPicker(기본=최신월). 헤더 relabel 기준(focus 월)
  divisionId: string; // 콤마 다중(전체=ALL) — cboDivision(Division_SCP + EE 클라 제외)
  plantId: string; // 콤마 다중(전체=ALL) — clbPlant(PlantByGroup_SCP, @divisionId cascade)
  itemId: string; // Item 팝업 반환값/텍스트 다중 — txtItem_Id(Material 라벨)
}

// 조회 결과 행 — GET SP 반환 ∩ SCM_MST_SHEET_COLUMNS 메타(design 03 §1, 47컬럼). 컬럼셋은
//   admin 메타 구동이라 동적 인덱스 시그니처로 받고, 코드가 직접 참조하는 판정 컬럼만 명시한다.
export type InventoryTrendRow = ResponseData<MENU_ID, SHEETS.MAIN>;
