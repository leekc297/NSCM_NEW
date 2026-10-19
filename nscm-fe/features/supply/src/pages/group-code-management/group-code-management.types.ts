/**
 * 조회조건 화면 상태 (02_search-combo.md §1 정본).
 *
 * - divisionId : Division_SCP_NoEE 단일선택 (권한+EE제외 내장). cascade 최상위.
 * - operationIds : Operation 다중선택. 파라미터 없이 1회 전체 로드 후 division 클라 필터.
 * - model / nickName : 다중행 텍스트 (개행 = 여러 값). SP 파라미터로 그대로 전달.
 * - checkFcst/Production/Active/Bom : Y/N 체크박스. 초기 전부 false. chkActive/chkBom 은 기본 숨김.
 */
export interface SearchCondition {
  divisionId: string;
  operationIds: string[];
  model: string;
  nickName: string;
  checkFcst: boolean;
  checkProduction: boolean;
  checkActive: boolean;
  checkBom: boolean;
}

/**
 * GET SP 조회 payload (P_SCP0080_GET_GROUP_CODE_MANAGEMENT 10 IN 1:1).
 *
 * key 는 camelCase — BE makeProcedure(BaseService.java) 가 SCM_ADM_PROC_M.COL_NM 기준으로
 *   SP IN 파라미터(P_DIVISION_ID 등)에 매핑한다. 누락 key 는 NULL 전달 → 권한/조건 불일치로 0행.
 *   P_USER_ID(세션)·P_DEBUG_MODE('F')는 BE 가 채우므로 FE payload 에 넣지 않는다.
 */
export interface GroupCodeSearchFilter {
  divisionId: string;
  operationId: string;
  modelId: string;
  nickName: string;
  checkFcst: string;
  checkProduction: string;
  checkActive: string;
  checkBom: string;
}

// admin 컬럼 메타(SCM_MST_SHEET_COLUMNS)가 division 별로 다른 sheetNm 을 내려주므로
//   행 타입은 동적이다. 표시 컬럼은 staticColumns(RawFlexGridColumnConfig[]) 가 결정한다.
//   공용 DataGrid/EditTracker 제약(WijmoRowItem)을 만족하도록 값 타입은 WijmoPrimitive 로 둔다
//   (Record<string, unknown> 교차는 인덱스 시그니처 unknown 이 제약 위반 — BusinessPlanRow 와 달리
//    본 화면 그리드는 FlexGrid<GroupCodeRow> 제네릭에 직접 대입하므로 원자값 인덱스가 필수).
//   CRUD_TYPE: 'I'(신규) / 'M'(수정) / 'D'(삭제) — EditTracker 가 찍는다.
export type GroupCodeRow = WijmoRowItem & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  DIVISION_ID?: string;
  STATUS_MASS?: string;
  PIC_ID?: string;
};
