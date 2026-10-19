export const MENU_ID = 'SSP0014' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0014_ShipmentModelPIC (단일 그리드 spdMain "Shipment Model PIC"):
//   설계 근거: .atlas/gscm-design/SSP0014/design/00_checklist.md ~ 03_grid-columns.md
//   - GET  SP : PKG_SSP0014.P_SSP0014_GET_MODEL_PIC  (반환 21컬럼, o_rc1)
//   - SAVE SP : PKG_SSP0014.P_SSP0014_SAVE_MODEL_PIC (변경행만 ^-delim UPSERT, SSP_MST_MODEL_USER)
//   - CHECK SP: PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK (저장 전 사용자 등록 검증, 미등록 시 MSG00251)
//   - 편집 상태기계: 조회=전체 lock(뷰) -> Edit(SwitchLock)=유일 편집 진입 -> Save 성공 후 뷰 복귀
//   - Insert/Delete = NO-OP (AS-IS override 본문 주석처리 cs:254/259) -> 버튼 노출 + 클릭 무동작
//   - 편집셀 8 = USER_ID/PART_LEADER/TEAM_LEADER/MAIL_USER1~5(팝업) + VALID_YN(콤보). 나머지 13 lock.
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (21컬럼)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0014' SHEET_NAME='Shipment Model PIC' 21행(배포됨).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Model PIC',
};

// 편집 가능 = 이미지셀 팝업 7 + VALID_YN 콤보 1 (design 03 §1/§2.2, 01_layout §2.2).
//   USER_ID 계열 7 = 더블클릭 UserInfoPopup(SsoUserModal) -> 선택 UserID SetValue.
export const USER_POPUP_COLUMNS = [
  'USER_ID',
  'PART_LEADER',
  'TEAM_LEADER',
  'MAIL_USER1',
  'MAIL_USER2',
  'MAIL_USER3',
  'MAIL_USER4',
  'MAIL_USER5',
] as const;

// 이미지셀 팝업 컬럼 -> 짝 이름 컬럼. 팝업에서 사용자 선택 시 ID 와 함께 이름도 채운다
//   (AS-IS UserInfoPopup 은 선택 시 ID+Name 동시 SetValue). 이름 컬럼은 조회전용('S')이라 SAVE
//   payload 에는 포함되지 않고 표시 목적으로만 갱신한다. MAIL_USER1~5 는 짝 이름 컬럼이 없다.
export const USER_POPUP_NAME_COLUMN: Record<string, string> = {
  USER_ID: 'USER_NAME',
  PART_LEADER: 'PART_LEADER_NAME',
  TEAM_LEADER: 'TEAM_LEADER_NAME',
};

// 편집 콤보 셀 (YesOrNo) — 편집모드에서만 편집 가능 (design 03 §1.1).
export const VALID_YN_COLUMN = 'VALID_YN';

// OPERATION_GROUP 코드->표시. lookup NAME(P/A/E)에 W 는 없어 클라 하드코딩 (AS-IS cs:183-187,
//   [C20200324-000461] Warranty LOOKUP 등록 불가로 하드코딩). 그리드 렌더는 lookup NAME +
//   이 W 매핑을 합쳐 표시하고(03_grid-columns §3 W->Warranty), 조회콤보도 동일하게 W 를 추가한다.
export const OPERATION_GROUP_WARRANTY_CODE = 'W';
export const OPERATION_GROUP_WARRANTY_NAME = 'Warranty';

// 컬럼 메타 (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 21행 실측). GET SP 반환컬럼과 1:1.
//   binding key = SHEET_COLUMNS COLUMN_ID(대문자) = GET SP o_rc1 반환 컬럼명(순서 동일).
//   _inputEditType: 'S'=항상 잠금(키/이름/감사/조회) / 'O'=편집후보(editLock 이 세부 판정).
//   _cell: 'popup'=이미지셀 UserInfoPopup / 'combo'=FPComboBox 셀 / 'opGroup'=W->Warranty 표시.
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _cell?: 'popup' | 'combo' | 'opGroup' | 'date';
  _comboId?: string; // _cell==='combo' 일 때 cellCboDataTp
  _inputEditType?: 'S' | 'O';
}

// SORT_ORDER_NO 순 (design 03 §1 실측 21열).
export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 60, align: 'C', _inputEditType: 'S' },
  { key: 'OPERATION_GROUP', header: 'Operation Group', width: 100, align: 'C', _cell: 'opGroup', _inputEditType: 'S' },
  { key: 'FROM_SITE', header: 'From Site', width: 120, align: 'L', _cell: 'combo', _comboId: 'PlantSiteByDivision', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'USER_ID', header: 'User ID', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'USER_NAME', header: 'User Name', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'PART_LEADER', header: 'Part Leader', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'PART_LEADER_NAME', header: 'Part Leader Name', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'TEAM_LEADER', header: 'Team Leader', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'TEAM_LEADER_NAME', header: 'Team Leader Name', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'MAIL_USER1', header: 'Mail User1', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'MAIL_USER2', header: 'Mail User2', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'MAIL_USER3', header: 'Mail User3', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'MAIL_USER4', header: 'Mail User4', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'MAIL_USER5', header: 'Mail User5', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'O' },
  { key: 'VALID_YN', header: 'Valid', width: 60, align: 'C', _cell: 'combo', _comboId: 'YesOrNo', _inputEditType: 'O' },
  { key: 'CREATED_BY', header: 'Created By', width: 110, align: 'L', _inputEditType: 'S' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _cell: 'date', _inputEditType: 'S' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 110, align: 'L', _inputEditType: 'S' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 130, align: 'C', _cell: 'date', _inputEditType: 'S' },
];

// ====================================================================================
// 조회조건 콤보/lookup ID (design 02 §2/§5 — TO-BE Oracle 실측)
// ====================================================================================
//   - DIVISION : MyDivision(CMBO_SQL) — 권한 division + ATTRIBUTE3<>'EE'(전극/EE 제외).
//       AS-IS GetSSPInnerTable("MyDivisionCMM") 등가. EE 제외는 CMBO WHERE 에 이미 있으나
//       (design 02 §2.1), combo-semantic-parity 상 화면에서도 ATTRIBUTE3!=='EE' 재현(방어).
//   - FROM_SITE: PlantSiteByDivision(CMBO_SQL) @divisionId — SITE_TYPE='PLANT', 다중선택.
//   - VALID    : YesOrNo(CMBO_SQL) Y/N.
//   - OPERATION_GROUP: LookupCommon lookupType='OPERATION_GROUP'(P/A/E) + 클라 W 추가.
export const COMBO = {
  DIVISION: 'MyDivision',
  FROM_SITE: 'PlantSiteByDivision',
  VALID: 'YesOrNo',
} as const;

export const LOOKUP = {
  OPERATION_GROUP: 'OPERATION_GROUP',
} as const;

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회로 확정 — Hook #114). AS-IS 번호를 그대로 쓰지 않는다.
//   역조회 실측(SCM_ADM_MSG_M, LANG_CD KO/EN):
//     MSG00672 = "{0}개의 데이터가 저장되었습니다." / "{0} data saved."  (건수 플레이스홀더 — 저장 성공)
//     MSG00003 = "저장에 실패하였습니다." / "Failed to save."
//     MSG00004 = "수정한 내용이 없습니다." / "No changes to save."  (변경 없음)
//     MSG00097 = "Division 을 선택하세요." / "Please select Division."
//   USER_NOT_REGISTERED: MSG00251 — TO-BE SCM_ADM_MSG_M(KO/EN/CN) + public/locales(KO/EN) 등록.
//     문구는 AS-IS GSCM 알람과 동일하게 "SSP Planner 권한이 없는 사용자 입니다 . User ID : {0}"
//     (design 10_update_msg_wording_asis.sql, 사용자 확인 2026-09-22).
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // 저장 성공 (건수) — "{0}개의 데이터가 저장되었습니다."
  SAVE_FAIL: 'MSG00003', // 저장 실패 — "저장에 실패하였습니다."
  USER_NOT_REGISTERED: 'MSG00251', // 미등록 사용자 — TO-BE 등가 미등록(신규 등록 필요), defaultValue fallback
  REQUIRED_DIVISION: 'MSG00097', // 조회 필수(Division) — "Division 을 선택하세요."
  NO_CHANGES: 'MSG00004', // 변경 없음 — "수정한 내용이 없습니다."
} as const;
