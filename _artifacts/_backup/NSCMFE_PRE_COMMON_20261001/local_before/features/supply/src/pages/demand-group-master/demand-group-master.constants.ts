// SCP0110 Demand Group Master — 상수/키 정의 (AS-IS SCP0110_GroupModelMapping).
//   SHEETS value = 버튼-API SHT_NM(groupName/modelList) 과 정합 → proc 라우팅.
//   ADMIN_SHEET_NAME = SCM_MST_SHEET_COLUMNS.SHEET_NAME 원본('Group Name'/'Model List') — 컬럼메타 fetch 키.
export const MENU_ID = 'SCP0110' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  GROUP_NAME = 'groupName', // siMain — Group Master
  MODEL_LIST = 'modelList', // siSub  — Model List
}

// 단일 커서 표준 — PKG_SCP0110 GET 프로시저 OUT 커서명(all_arguments 실측 = o_rc1).
export const RESPONSE_SET = {
  [SHEETS.GROUP_NAME]: 'o_rc1',
  [SHEETS.MODEL_LIST]: 'o_rc1',
} as const;

// 컬럼 메타(SCM_MST_SHEET_COLUMNS) 는 SHEET_NAME 이 라벨('Group Name'/'Model List')로 등록돼 있다.
//   버튼 SHT_NM(camelCase) 과 다르므로 컬럼 fetch 시에는 이 원본명을 넘겨야 매칭된다(hook #54).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.GROUP_NAME]: 'Group Name',
  [SHEETS.MODEL_LIST]: 'Model List',
};

// 활성 그리드 추적 — Insert/Delete 는 Group Master(main)에서만 (AS-IS: sub 신규/삭제 없음).
export enum ACTIVE_GRID {
  MAIN = 'main',
  SUB = 'sub',
}

// 편집 가능 컬럼 화이트리스트 (AS-IS LockColumn 범위 재현 — cs L338/354).
//   메타(SCM_MST_SHEET_COLUMNS)가 전열 INPUT_TP_CD='S' 라 공용 DataGrid isEditableCell 은 전셀을
//   막는다. §11(EditButton 토글 미이식) 에 따라 편집모드 상태 없이, beginningEdit 에서 이 화이트리스트만
//   e.cancel=false 로 재허용한다(grid-behavior-parity §2). 키 컬럼(DIVISION_ID/OPERATION_GROUP/GROUP_ID)은
//   잠금 유지.
export const MAIN_EDITABLE_COLUMNS = ['GROUP_NAME', 'ONLY_STOCK'] as const;
export const SUB_EDITABLE_COLUMNS = ['GROUP_ID'] as const;

// 조회조건/셀 콤보 SQL_ID (전부 SCM_ADM_CMBO_SQL_M USE_YN='Y' 실측 확인).
export const COMBO_ID = {
  DIVISION: 'Division_SCP', // 권한필터 동일 — EE/'81' 클라필터는 화면 재현
  LOOKUP_COMMON: 'LookupCommon', // @lookupType 바인드
  YES_OR_NO: 'YesOrNo', // Y/N 고정
  GROUP_MASTER: 'GroupMaster_SCP_ALL', // GROUP_ID 셀 콤보 원천(메타 'GroupMaster' 미등록 → 실등록명 사용)
} as const;

export const OPERATION_GROUP_LOOKUP_TYPE = 'OPERATION_GROUP' as const;

// 라벨 — 문구 역조회로 확정한 TO-BE LBL ID(design 02 §4.5, hook #114). 하드코딩 금지.
export const LABEL = {
  DIVISION: 'LBL00641',
  OPERATION_GROUP: 'LBL00027',
  GROUP_NAME: 'LBL00037',
  PROJECT: 'LBL00617',
  MODEL: 'LBL00669',
  SEARCH: 'LBL00112',
} as const;

export const MSG = {
  // 그룹명 중복(신규간/기존대비) — design 03 §3-E 실측 MSG00043.
  DUPLICATE_GROUP_NAME: 'MSG00043',
  // 변경 없음 — SCM_ADM_MSG_M 실측 MSG00004='No changes to save.'(KO/EN/CN 3행). hook #114 문구 역조회.
  //   gap-resolve iter-1 G-02: 미등록 자유형식 키 'MSG_NO_CHANGE' → 실등록 표준 MSG00004 로 교체(EN/CN 대응).
  NO_CHANGE: 'MSG00004',
  // 저장 성공 — SCM_ADM_MSG_M 실측 MSG00002='Saved successfully.'(KO/EN/CN 3행). hook #114 문구 역조회.
  //   gap-resolve iter-1 G-01: 기존 'MSG00004' 는 TO-BE 에서 'No changes to save.' 라 성공 문구 아님 → 재매핑.
  SAVED: 'MSG00002',
  // 저장 실패 — SCM_ADM_MSG_M 실측 MSG00006='Failed to save.'(KO/EN/CN 3행). 저장 오류 alert 전용.
  SAVE_FAILED: 'MSG00006',
  // 복수 Project 동일그룹 금지 — AS-IS 리터럴(SCM_ADM_MSG_M 미등록). 다국어 신규 등록 필요(04 확인필요/I-04).
  //   미등록 상태라 fallback 문구(AS-IS 한글 리터럴)로 노출 — 기존 화면의 t(key,'_fallback') 관례.
  MULTI_PROJECT_SAME_GROUP: 'MSG_SCP0110_MULTI_PROJECT',
} as const;
