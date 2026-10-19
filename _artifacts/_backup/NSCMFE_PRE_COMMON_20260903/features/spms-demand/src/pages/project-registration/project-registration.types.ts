// SDM1010 화면 전용 row 타입.
//
// ⚠ BE 미착수 화면(2026-08-07 기준 nscm-be 에 SDM1010 SP 없음) — 아래 필드명은
//   화면설계서(SDM1010_ProjectReg_화면설계서_20260806) "UI컬럼 및 Measure정의" 시트
//   (실제 컬럼명/라벨/폭/콤보ID 가 셀 단위로 정의된 유일한 authoritative 표)를 그대로 옮긴 것이다.
//   configs/types/procedures.d.ts 의 RawProcedureMap 에 SDM1010 항목을 이미 등록해 두었으니
//   (project/myProject/popupOrg/... 시트별 request/response) BE SP 확정 시 그 파일과 이 파일의
//   필드명을 함께 실제 컬럼명으로 맞춰야 한다 — 두 파일이 어긋나면 여기 타입과 실제 응답이 달라진다.
//
// ⚠ 재작업 이력(2026-08-07): 최초 작성 시 이 "UI컬럼 및 Measure정의" 시트를 확인하지 않고
//   미리보기용 TAB1_GRID/TAB2_GRID 목업 시트의 헤더 라벨만 보고 필드명을 추측해 넣었었다
//   (PJT_CODE/DEMAND_STAGE_NAME/SPMS_CELL_TYPE 콤보 등 — 전부 존재하지 않는 이름이었음).
//   실제 그리드 컬럼과 화면설계서가 다르다는 지적을 받고 "UI컬럼 및 Measure정의" 시트 기준으로
//   전면 재작성했다. 설계서 표를 스펙으로 옮길 땐 목업 시트가 아니라 이 컬럼 정의 표를 봐야 한다.

// 화면설계서 TAB1 "프로젝트 등록" 그리드 1행 ("UI컬럼 및 Measure정의" D=TAB1, 26개 컬럼).
export interface ProjectRow {
  DPJT_KEY: string;
  DPJT_CODE: string;
  DPJT_SEQ: string;
  DIVISION_ID: string;
  DIVISION_NAME: string;
  DPJT_CLASS: string;
  DPJT_CLASS_NAME: string;
  END_CUSTOMER: string;
  END_CUSTOMER_NAME: string;
  DPJT_NAME: string;
  CELL_TYPE: string;
  CELL_TYPE_NAME: string;
  STACK_METHOD: string;
  STACK_METHOD_NAME: string;
  BIZ_TYPE: string;
  BIZ_TYPE_NAME: string;
  SOP_DATE: string;
  SOP_PLANT_ID: string;
  SOP_PLANT_NAME: string;
  DPJT_ATUH_REG_STR: string;
  DPJT_ATUH_REG_STATUS: string;
  DPJT_ATUH_REG_STATUS_NAME: string;
  DPJT_ATUH_REG_STATUS_COLOR_TYPE: string;
  MGMT_USER_ID: string;
  USER_NAME: string;
  USER_NAME_EN: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  DEPT_NAME_KO: string;
  DEPT_NAME_EN: string;
  DEPT_NAME_CN: string;
  DPJT_REG_STATUS: string;
  DPJT_REG_STATUS_NAME: string;
  DPJT_REG_STATUS_COLOR_TYPE: string;
  REG_REQ_DATE: string;
  [key: string]: WijmoPrimitive;
}

// TAB1/TAB2 등록 상태 코드 — 화면설계서 TAB1 §확인사항/메시지 코드에 등장하는 상태값을 코드화.
// PKG_SDM1010과 SPMS_DPJT_REG_STATUS 룩업의 실제 코드값.
export const REG_STATUS = {
  WRITING: 'WRITING',
  WAITING: 'WAITING',
  COMPLETE: 'COMPLETE',
} as const;

export const isDraftRegStatus = (status: string) => status === REG_STATUS.WRITING;

export const isPendingRegStatus = (status: string) => status === REG_STATUS.WAITING;

// 화면설계서 TAB2 "나의 프로젝트 현황" 그리드 1행 ("UI컬럼 및 Measure정의" D=TAB2, 29개 컬럼).
// ProjectRow 와 프로젝트 기본 정보(사업부/구분/고객/이름/셀유형/Stack공법/BizType/SOP)는 같은
// 이름을 공유하되, 권한관리 팝업 링크·상태(DPJT_ATUH_REG_STR/STATUS) 대신 My Work 아이콘 열과
// 나의 권한/등록완료일/개발현황 열을 갖는다(§확인사항: TAB2 는 조회 전용, 저장/삭제 없음).
export interface MyProjectRow {
  DPJT_KEY: string;
  DPJT_CODE: string;
  DPJT_SEQ: string;
  MY_WORK: string;
  DIVISION_ID: string;
  DIVISION_NAME: string;
  DPJT_CLASS: string;
  DPJT_CLASS_NAME: string;
  END_CUSTOMER: string;
  END_CUSTOMER_NAME: string;
  DPJT_NAME: string;
  CELL_TYPE: string;
  CELL_TYPE_NAME: string;
  STACK_METHOD: string;
  STACK_METHOD_NAME: string;
  BIZ_TYPE: string;
  BIZ_TYPE_NAME: string;
  SOP_DATE: string;
  SOP_PLANT_ID: string;
  SOP_PLANT_NAME: string;
  MGMT_USER_ID: string;
  USER_NAME: string;
  USER_NAME_EN: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  DEPT_NAME_EN: string;
  DEPT_NAME_CN: string;
  DPJT_AUTH_TYPE: string;
  DPJT_AUTH_TYPE_NAME: string;
  DPJT_REG_STATUS: string;
  DPJT_REG_STATUS_NAME: string;
  DPJT_REG_STATUS_COLOR_TYPE: string;
  REG_COMP_DATE: string;
  DPJT_DEVELOP_STATUS: string;
  DPJT_DEVELOP_STATUS_NAME: string;
  [key: string]: WijmoPrimitive;
}

// 권한관리 팝업 — 조직도 트리 1노드("UI컬럼 및 Measure정의" D=POP1_TREE).
// BE는 LEVEL_NO/UPPER_DEPT_ID를 포함한 플랫 목록으로 반환하며
// FE(components/authManagementPopup/authManagementPopup.utils.ts 의 buildOrgTree)에서 트리로
// 조립한다 — 디자인시스템 Tree는 중첩 children 데이터를 요구한다.
// DataGrid를 거치지 않고 디자인시스템 Tree로만 쓰이므로 WijmoRowItem(index sig)을 따르지 않는다.
// OrgTreeNode(트리 조립 후 형태)의 children?: OrgTreeNode[]가 WijmoPrimitive 인덱스 시그니처와
// 충돌하기 때문(배열은 WijmoPrimitive 가 아님).
export interface OrgTreeRow {
  LEVEL_NO: number;
  DEPT_ID: string;
  DEPT_NAME: string;
  UPPER_DEPT_ID: string | null;
  USER_COUNT: number;
  ORGN: string;
  /** 세션 사용자의 부서 — 조직도 기본 선택/펼침 기준 (행마다 동일 값, 첫 행 사용) */
  SES_DEPT_ID: string;
}

// 권한관리 팝업 — 선택한 조직 노드 소속 사용자 목록 1행("UI컬럼 및 Measure정의" D=POP1_GRID1).
export interface PopupUserRow {
  USER_ID: string;
  USER_NAME: string;
  JOB_CODE: string;
  JOB_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  [key: string]: WijmoPrimitive;
}

// 권한관리 팝업 — 입력/조회 권한 리스트 1행("UI컬럼 및 Measure정의" D=POP1_GRID2 입력목록/
// POP1_GRID3 조회목록 — 두 그리드가 컬럼셋은 완전히 동일해 FE 는 SP 1개(popupAuthMgmt)로
// WRITE/READ 조회 결과를 합친 뒤 AUTH_TYPE_CD로 화면에서 구분한다.
export const AUTH_TYPE = {
  INPUT: 'WRITE',
  VIEW: 'READ',
} as const;

export interface AuthMgmtUserRow {
  DPJT_KEY: string;
  USER_ID: string;
  USER_NAME: string;
  JOB_CODE: string;
  JOB_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  /** Request — 이 사용자에 대한 대기중 변경요청 유무/상태 태그(설계서 M열="TAG") */
  /** FE 전용 구분 필드 — 설계서엔 없음, 위 주석 참고 */
  AUTH_TYPE_CD: string;
  [key: string]: WijmoPrimitive;
}

// 권한관리 팝업 — 하단 "요청" 리스트 1행("UI컬럼 및 Measure정의" D=POP1_GRID4, 권한 요청 승인/반려 대상).
export interface AuthRequestRow {
  /** 설계서엔 명시된 키 컬럼이 없으나(STATUS/USER_ID/.../REQUEST 8개 뿐) 그리드 체크박스로
   *  개별 행을 식별하려면 고유키가 필요해 FE 에서 가정한 필드. BE 확정 시 실제 PK 로 맞출 것. */
  DPJT_AUTH_STATUS: string;
  DPJT_AUTH_STATUS_NAME: string;
  DPJT_KEY: string;
  /** 상태 — 대기중 등 */
  USER_ID: string;
  USER_NAME: string;
  JOB_CODE: string;
  JOB_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  /** 요청한 권한 유형. 패키지 코드값은 WRITE 또는 READ이다. */
  DPJT_AUTH_TYPE: string;
  DPJT_AUTH_TYPE_NAME: string;
  /** 화면설계서의 요청별 처리 컬럼. 입력/조회/반려 중 하나를 선택한다. */
  PROCESS: string;
  [key: string]: WijmoPrimitive;
}

// My Work 팝업 — 샘플 일정 상세 1행("UI컬럼 및 Measure정의" D=POP2_GRID5, 15개 컬럼).
export interface MyWorkScheduleRow {
  DPJT_KEY: string;
  DPJT_CODE: string;
  DIVISION_ID: string;
  DIVISION_NAME: string;
  DPJT_CLASS: string;
  DPJT_CLASS_NAME: string;
  END_CUSTOMER: string;
  DPJT_NAME: string;
  SAMPLE_A_DATE: string;
  SAMPLE_B_DATE: string;
  SAMPLE_C_DATE: string;
  SAMPLE_D_DATE: string;
  SOP_DATE: string;
  SOP_PLANT_ID: string;
  SOP_PLANT_NAME: string;
  [key: string]: WijmoPrimitive;
}
