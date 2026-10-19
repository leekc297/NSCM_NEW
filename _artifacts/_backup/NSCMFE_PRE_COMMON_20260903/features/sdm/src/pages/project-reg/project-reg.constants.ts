export const MENU_ID = 'SDM1010' as const;
export type MENU_ID = typeof MENU_ID;

// SDM1010 Project Registration (SDM > SDM_Project > Project Registration — ROUTE_PATH 'sdm/project-reg').
//   ⭐ 2026-08-13 신본 PKG_SDM1010(외부 전달 정본) 15 SP 계약으로 전면 재배선
//     (계약 명세: scratchpad PKG_SDM1010_NEW_CONTRACT.md — 커서 컬럼·상태 도메인·'^' 규약).
//   TAB1 = 프로젝트 등록 (CRUD C/M/D + 등록요청 REQ/요청취소 CANCEL — 저장·버튼 = 행별 단건 호출) /
//   TAB2 = 나의 프로젝트 현황 (조회 전용 — 기간 기본값 = period 시트 GET_PERIOD).
//   POP1_* = 권한관리 모달(ProjectAuthRegModal) / POP2_GRID5 = MY_WORK 모달(MyWorkModal).
export enum SHEETS {
  TAB1 = 'TAB1',
  TAB2 = 'TAB2',
  POP1_TREE = 'POP1_TREE',
  POP1_GRID1 = 'POP1_GRID1',
  POP1_GRID2 = 'POP1_GRID2', // §8 입력(WRITE) 권한 조회 + §11 replace-set SAVE
  POP1_GRID3 = 'POP1_GRID3', // §9 조회(READ) 권한 조회 + §12 replace-set SAVE (신본에서 실데이터 원천)
  POP1_GRID4 = 'POP1_GRID4', // §10 요청·이력 조회 + §13 반려 단건 SAVE
  POP2_GRID5 = 'POP2_GRID5',
  PERIOD = 'period', // §15 GET_PERIOD — TAB2 등록완료일 기본값
}

// 커서명 'data' (PROC_M 실등재 — sales-site RESPONSE_SET 용법 동일)
export enum RESPONSE_SET {
  DATA = 'data',
}

// 탭 인덱스 (TabWrapper activeTabIndex)
export enum TAB_INDEX {
  TAB1,
  TAB2,
}

// ⭐ 등록 상태 코드 — 신본 도메인 (lookup SPMS_DPJT_REG_STATUS. REQUEST/CHG_* 폐지 — 계약 §17)
//   전이: DRAFT(신규 INSERT §2) / WRITING(작성중 — 삭제·등록요청 가드 §2·§3) /
//        WAITING(승인대기 — BTN_REQ 목표·BTN_CANCEL 원상태 §3·§4) / COMPLETE / REJECT (승인 화면 관할)
export const REG_STATUS = {
  DRAFT: 'DRAFT', // 신규 (서버 INSERT 초기값 — SEG2 '작성중')
  WRITING: 'WRITING', // 작성중
  WAITING: 'WAITING', // 승인대기
  COMPLETE: 'COMPLETE', // 등록완료
  REJECT: 'REJECT', // 반려
} as const;
export type RegStatus = (typeof REG_STATUS)[keyof typeof REG_STATUS];

// ⭐ 권한 유형 — 신본 도메인 (lookup SPMS_DPJT_AUTH_TYPE. M/I/R 폐지 — 계약 §17)
export const AUTH_TYPE = {
  ADMIN: 'ADMIN', // §11·§12 MERGE 보호 대상 (모달 편집 불가)
  WRITE: 'WRITE', // 입력
  READ: 'READ', // 조회
} as const;
export type AuthType = (typeof AUTH_TYPE)[keyof typeof AUTH_TYPE];

// ⭐ 권한 요청 상태 — 신본 도메인 (계약 §17. 처리 버튼은 REQUEST 행만 활성 — §10)
export const AUTH_STATUS = {
  REQUEST: 'REQUEST',
  CONFIRM: 'CONFIRM',
  REJECT: 'REJECT',
} as const;
export type AuthStatus = (typeof AUTH_STATUS)[keyof typeof AUTH_STATUS];

// 권한 요청 pending 결정 (FE 로컬 — OK 시 승인=목록 포함 저장 §11·§12 / 반려=§13 단건 호출)
export const REQ_DECISION = {
  APPROVE: 'APPROVE',
  REJECT: 'REJECT',
} as const;
export type ReqDecision = (typeof REQ_DECISION)[keyof typeof REQ_DECISION];

// 커스텀 버튼 BTN_CD (= call-proc 액션 세그먼트 — BTN 배선 실등재)
export const BTN = {
  REQ: 'REQ', // 등록요청 (§3 P_SDM1010_BTN_REQ_PJT_REG — WRITING→WAITING)
  CANCEL: 'CANCEL', // 요청취소 (§4 P_SDM1010_BTN_CANCEL_PJT_REG — WAITING→WRITING)
} as const;

// 조회조건 lookup 타입
export const LOOKUP = {
  AUTH_TYPE: 'SPMS_DPJT_AUTH_TYPE',
  REG_STATUS: 'SPMS_DPJT_REG_STATUS',
} as const;

// ⭐ MSG 매핑 — 전부 사내 기등재 재사용 (신규 채번 0 — hook #114 3분기)
export const MSG = {
  SAVE_CONFIRM: 'MSG00001', // 저장하시겠습니까?
  SAVED: 'MSG00002', // 저장 성공 (⭐ toast — hook #132)
  SAVE_ERROR: 'MSG00003', // 저장 실패
  NO_CHANGES: 'MSG00004', // 변경 없음 (EVENT '0' — 허위성공 방지 계보: 성공 토스트 금지)
  DUPLICATE: 'MSG00043', // payload 내 중복 (division+class+customer+name)
  DIVISION_REQUIRED: 'MSG00097', // Division 필수
  DATE_INVERTED: 'MSG00108', // 기간 역전/한쪽만 입력
  REQUIRED_COLUMN: 'MSG00113', // IM 필수 컬럼 누락
  PENDING_SEARCH_CONFIRM: 'MSG01016', // 수정 pending 중 재조회 confirm (UC-02)
  DELETE_ONLY_DRAFT: 'MSG01017', // 작성중 외 삭제 불가
  DELETE_CONFIRM: 'MSG00710', // 삭제 confirm
  REQ_ONLY_DRAFT: 'MSG01018', // 작성중 아닌 행 등록요청 불가
  NO_CHECKED: 'MSG01019', // 대상 0건
  REQ_CONFIRM: 'MSG01020', // 등록요청 confirm
  REQ_DONE: 'MSG00712', // 등록요청 성공 (toast)
  REQ_FAIL: 'MSG00711', // 등록요청 실패
  CANCEL_ONLY_REQUEST: 'MSG00707', // 승인대기 외 요청취소 불가
  CANCEL_CONFIRM: 'MSG00713', // 요청취소 confirm
  RANGE_OVER_3Y: 'MSG00164', // TAB2 조회기간 3년 초과
  AUTH_INPUT_DUP: 'MSG01021', // 입력 리스트 기존재
  AUTH_READ_DUP: 'MSG01022', // 조회 리스트 기존재
} as const;

// ⭐ NAME↔CODE 페어 (FPComboBox 메타 NAME 컬럼 편집 → cellEditEnded 에서 CODE 컬럼 동기 기입.
//   DIVISION_NAME/SOP_PLANT_NAME 은 불규칙 페어(_ID) — 나머지는 '_NAME' 제거 규칙과 일치하지만 명시 등재로 고정.
//   콤보 원천 (계약 결정 12): DIVISION_NAME=MyDivision / DPJT_CLASS_NAME=DpjtClass /
//   CELL_TYPE_NAME=CellTypeByDivision / STACK_METHOD_NAME=StackMethod / BIZ_TYPE_NAME=DmBizType(CELL/MODULE/PACK) /
//   SOP_PLANT_NAME=PlantByDivisionCompany. END_CUSTOMER 는 CODE 컬럼 직결 콤보 'EndCustomer' — 페어 없음)
export const CODE_PAIR: Record<string, string> = {
  DIVISION_NAME: 'DIVISION_ID',
  DPJT_CLASS_NAME: 'DPJT_CLASS',
  CELL_TYPE_NAME: 'CELL_TYPE',
  STACK_METHOD_NAME: 'STACK_METHOD',
  BIZ_TYPE_NAME: 'BIZ_TYPE',
  SOP_PLANT_NAME: 'SOP_PLANT_ID',
};

// ⭐ division 종속 셀 콤보 — 행 division 의 dataMap 으로 스왑(hook #59 §5-G)하고 division 변경 시
//   종속 셀을 clear 한다 (Insert 시 Division 이 행별 필수입력 — 2026-08-13).
//   신본 정정: BIZ_TYPE 은 무토큰 DmBizType 으로 전환(비종속) / END_CUSTOMER('EndCustomer') 편입.
//   ⚠ 'EndCustomer' SQL 은 @divisionId 토큰이 **없고** @sesUserId 권한 division 전체를 반환
//   (2026-08-13 실측) — 행 division 스코프는 payload DIVISION_ID 컬럼 클라이언트 필터가 담당
//   (ProjectRegTab1Grid scoped maps). 미필터 = 40 PROJECT_CODE 도메인 오염 → §1 EDC INNER
//   JOIN(DIVISION_ID+END_CUSTOMER) 불일치로 저장 행 조회 소실 (E2E 실측 계보).
export const DIVISION_SCOPED_COMBOS = [
  'CellTypeByDivision',
  'PlantByDivisionCompany',
  'EndCustomer',
] as const;

// FPModal 셀 메타 ATTRIBUTE1 → 모달 배선 (SHEET_COLUMNS ATTRIBUTE1 소비 — 하드코딩 바인딩 금지)
export const MODAL_ATTR = {
  AUTH_REG: 'ProjectAuthRegModal', // TAB1 DPJT_ATUH_REG_STR (오타 alias = 패키지 정본 §18-10)
  MY_WORK: 'MyWorkModal', // TAB2 MY_WORK
} as const;

// TAG 렌더 메타 ATTRIBUTE1 값 (DPJT_REG_STATUS_NAME / DPJT_ATUH_REG_STATUS_NAME)
export const TAG_ATTR = 'TAG' as const;

// 권한요청 처리 버튼 컬럼 메타 ATTRIBUTE1 값 (POP1_GRID4 PROCESS — 목업 [✓입력][✓조회][x반려])
export const REQ_ACTION_ATTR = 'REQ_ACTION' as const;

// ⭐ TAG pill 색 = 커서 `*_COLOR_TYPE` 컬럼 소비 (데이터 주도 — 계약 결정 7. 하드코딩 매핑 제거).
//   값 Gray/Amber/Green/Red = scss 클래스 접미(tagGray 등)와 일치. 색 컬럼명 규칙:
//   `X_NAME` → `X_COLOR_TYPE` / 그 외 → `{binding}_COLOR_TYPE` (DPJT_REG_STATUS_NAME →
//   DPJT_REG_STATUS_COLOR_TYPE · DPJT_ATUH_REG_STATUS_NAME → DPJT_ATUH_REG_STATUS_COLOR_TYPE)
export const colorTypeColumnOf = (binding: string): string =>
  `${binding.replace(/_NAME$/, '')}_COLOR_TYPE`;

// 저장 payload 내 중복 판정 키 (division+class+customer+name)
export const DUP_KEY_COLUMNS = ['DIVISION_ID', 'DPJT_CLASS', 'END_CUSTOMER', 'DPJT_NAME'] as const;

// ⭐ TAB2 등록완료일 기본값 — period 시트(§15 GET_PERIOD) SEARCH 파라미터 (M-1 시작 ~ 당월 말.
//   실측 2026-08-13: 20260701/20260831. FR/TO 동일 bucket 만 — §15 결함 ③ 회피)
export const PERIOD_DEFAULT_FILTERS = {
  frBucket: 'M',
  frDateVal: '-1',
  frBucketType: 'S',
  toBucket: 'M',
  toDateVal: '0',
  toBucketType: 'E',
} as const;

// Insert 신규행 기본 필드 — TAB1 §1 커서 35컬럼 전량 '' 초기화 (Tab1Row 전 필드 non-optional 계약.
//   CRUD_TYPE 'C' 는 호출부가 override. DIVISION 은 필수입력(IM 콤보 — 자동 부여 금지, 2026-08-13).
//   신규행 채번은 서버(TEMP_*) — KEY/CODE 는 빈 값 전달, 저장 후 재조회로 실키 수신 (계약 결정 3)
export const INSERT_ROW_DEFAULTS = {
  DPJT_KEY: '',
  DPJT_CODE: '',
  DPJT_SEQ: '',
  DIVISION_ID: '',
  DIVISION_NAME: '',
  DPJT_CLASS: '',
  DPJT_CLASS_NAME: '',
  END_CUSTOMER: '',
  END_CUSTOMER_NAME: '',
  DPJT_NAME: '',
  CELL_TYPE: '',
  CELL_TYPE_NAME: '',
  STACK_METHOD: '',
  STACK_METHOD_NAME: '',
  BIZ_TYPE: '',
  BIZ_TYPE_NAME: '',
  SOP_DATE: '',
  SOP_PLANT_ID: '',
  SOP_PLANT_NAME: '',
  DPJT_ATUH_REG_STR: '',
  DPJT_ATUH_REG_STATUS: '',
  DPJT_ATUH_REG_STATUS_NAME: '',
  DPJT_ATUH_REG_STATUS_COLOR_TYPE: '',
  DEPT_ID: '',
  DEPT_NAME: '',
  DEPT_NAME_KO: '',
  DEPT_NAME_EN: '',
  DEPT_NAME_CN: '',
  MGMT_USER_ID: '',
  USER_NAME: '',
  USER_NAME_EN: '',
  DPJT_REG_STATUS: '',
  DPJT_REG_STATUS_NAME: '',
  DPJT_REG_STATUS_COLOR_TYPE: '',
  REG_REQ_DATE: '',
} as const;
