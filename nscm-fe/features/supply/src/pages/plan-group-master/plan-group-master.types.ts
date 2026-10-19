import type { MENU_ID, SHEETS } from './plan-group-master.constants';

// 메인 그리드 행 (GET SP 반환 11컬럼 = DB 메타 11컬럼, 03_grid §1).
export type PlanGroupRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;

// searchInfo 6커서 행 (CODE/NAME/DIVISION_ID 공통).
export type SearchInfoRow = {
  CODE: string;
  NAME: string;
  DIVISION_ID: string;
  [key: string]: string | number;
};

// Line 커서는 다축 필터용 상위 키를 추가로 싣는다.
export type LineInfoRow = SearchInfoRow & {
  OPERATION_ID: string;
  PLANT_ID: string;
  FACTORY_ID: string;
};

// 조회조건 입력 상태. 체크리스트 5개는 다중선택 — CustomDropdown multiple 규약대로 CSV 문자열
//   (전체 = 'ALL' sentinel, 미선택 = ''). 콤마결합 CODE 목록.
export interface PlanGroupSearchParams {
  divisionId: string;
  operation: string;
  plant: string;
  building: string;
  line: string;
  planGroup: string;
}

// 드롭다운 옵션.
export interface ComboOption {
  label: string;
  value: string;
}
