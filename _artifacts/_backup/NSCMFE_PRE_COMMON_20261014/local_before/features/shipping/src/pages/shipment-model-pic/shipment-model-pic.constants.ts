export const MENU_ID = 'SSP0014' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0014_ShipmentModelPIC (단일 그리드 spdMain "Shipment Model PIC"):
//   설계 근거: .atlas/gscm-design/SSP0014/design/00_checklist.md ~ 03_grid-columns.md
//   - GET  SP : PKG_SSP0014.P_SSP0014_GET_MODEL_PIC  (반환 21컬럼, o_rc1)
//   - SAVE SP : PKG_SSP0014.P_SSP0014_SAVE_MODEL_PIC (변경행만 ^-delim UPSERT, SSP_MST_MODEL_USER)
//   - CHECK SP: PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK (저장 전 그룹권한 검증, 미통과 시 MSG01261)
//   - 편집모드: AS-IS Edit(SwitchLock) 토글은 미이식(convert-core §2.4 — 조회 직후부터 편집 가능).
//   - Insert/Delete = NO-OP (AS-IS override 본문 주석처리 cs:254/259) -> 버튼 노출 + 클릭 무동작
//   - 편집셀 9 = USER_ID(필수 M) + PART_LEADER/TEAM_LEADER/MAIL_USER1~5/VALID_YN(선택 O). 나머지 12 lock.
//     편집가능 판정은 admin 메타(INPUT_TP_CD)가 정본 — 화면 상수/핸들러로 덮어쓰지 않는다.
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

// 더블클릭 UserInfoPopup(SsoUserModal) 대상 8열 — 선택 UserID 를 그 셀에 SetValue
//   (AS-IS cs:225~233 cellTypeImage / 메타 FPTextModal 8열과 1:1, design 03 §3 R4/R6).
//   이 목록은 "팝업 대상"만 정의한다 — 편집가능 여부는 메타 INPUT_TP_CD 소관.
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

// OPERATION_GROUP 코드->표시. lookup NAME(P/A/E)에 W 는 없어 클라 하드코딩 (AS-IS cs:183-187,
//   [C20200324-000461] Warranty LOOKUP 등록 불가로 하드코딩). 그리드 렌더는 lookup NAME +
//   이 W 매핑을 합쳐 표시하고(03_grid-columns §3 W->Warranty), 조회콤보도 동일하게 W 를 추가한다.
export const OPERATION_GROUP_WARRANTY_CODE = 'W';
export const OPERATION_GROUP_WARRANTY_NAME = 'Warranty';

// 컬럼 메타 (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 21행 실측). GET SP 반환컬럼과 1:1.
//   binding key = SHEET_COLUMNS COLUMN_ID(대문자) = GET SP o_rc1 반환 컬럼명(순서 동일).
//   _inputEditType: DB INPUT_TP_CD 실측 그대로 — 'S'=잠금(키/이름/감사) / 'M'=필수 / 'O'=선택.
//   _cell: 'popup'=이미지셀 UserInfoPopup / 'combo'=FPComboBox 셀 / 'opGroup'=W->Warranty 표시.
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _cell?: 'popup' | 'combo' | 'opGroup' | 'date';
  _comboId?: string; // _cell==='combo' 일 때 cellCboDataTp
  _inputEditType?: 'S' | 'M' | 'O';
}

// SORT_ORDER_NO 순 (design 03 §1 실측 21열).
export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 60, align: 'C', _inputEditType: 'S' },
  { key: 'OPERATION_GROUP', header: 'Operation Group', width: 100, align: 'C', _cell: 'opGroup', _inputEditType: 'S' },
  { key: 'FROM_SITE', header: 'From Site', width: 120, align: 'L', _cell: 'combo', _comboId: 'PlantSiteByDivision', _inputEditType: 'S' },
  { key: 'ITEM_ID', header: 'Model', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'L', _inputEditType: 'S' },
  { key: 'USER_ID', header: 'User ID*', width: 100, align: 'L', _cell: 'popup', _inputEditType: 'M' },
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

// i18n 라벨 코드 — SCM_ADM_MSG_M 문구 역조회로 확정(Hook #114). value = LBL 코드.
//   조회조건 6조건 라벨 + 메인 SearchArea 조회 버튼. AS-IS 번호를 그대로 쓰지 않는다.
export const LBL = {
  DIVISION: 'LBL00001', // "Div." (조회조건 Division 라벨 — 정책상 LBL00641 금지)
  OPERATION_GROUP: 'LBL00027', // "Operation group"
  FROM_SITE: 'LBL00022', // "From Site"
  VALID: 'LBL00639', // "Valid"
  MODEL: 'LBL00669', // "Model"
  USER_ID_NAME: 'LBL00339', // "User ID(Name)"
  SEARCH: 'LBL00112', // "Search(F5)" (메인 상단 SearchArea 조회 버튼)
} as const;

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회로 확정 — Hook #114). AS-IS 번호를 그대로 쓰지 않는다.
//   역조회 실측(SCM_ADM_MSG_M, LANG_CD KO/EN):
//     MSG00672 = "{0}개의 데이터가 저장되었습니다." / "{0} data saved."  (건수 플레이스홀더 — 저장 성공)
//     MSG00003 = "저장에 실패하였습니다." / "Failed to save."
//     MSG00004 = "수정한 내용이 없습니다." / "No changes to save."  (변경 없음)
//     MSG00097 = "Division 을 선택하세요." / "Please select Division."
//     MSG00667 = "권한을 가진 Division이 없습니다." / "No authority assigned."  (권한 Division 0건)
//   USER_NOT_REGISTERED: AS-IS 는 MSG00251 이지만 **TO-BE SCM_ADM_MSG_M 에 MSG00251 은 0행**이고
//     public/locales(KO/EN)에도 없다(2026-09-28 ora.py 실측). 등가 문구가 이미 등록된 코드는
//     MSG01261 = "SSP Planner 권한이 없는 사용자 입니다 .\n\rUser ID : {0}" /
//                "This user does not have permission to the SSP Planner.\n\rUser ID : {0}" (KO/EN/CN + 번들).
//     SP 실 의미도 "그룹(SSP Planner/ADMIN/SCM PI Admin) 멤버십 검증"이라 MSG01261 이 정확하다
//     (design 00 §2b-3, 01 §10-⑥). AI 가 문구를 새로 지어 등록하지 않는다 — convert-core §2.3.
//   INQUIRY_ERROR: MSG01052 = "조회시 오류가 발생하였습니다." / "An error has occurred when inquiring."
//     (KO/EN/CN + public/locales 등재 실측 2026-09-28). 쓰이는 3곳 — ① Division 콤보 요청 실패
//     (권한 0건과 구분: 실패는 "권한 없음"이 아니다) ② 컬럼 메타 요청 실패(staticColumnsError)
//     ③ 저장 성공 후 재조회 실패. 신규 문구를 만들지 않고 등록 실재 코드를 쓴다(convert-core §2.3).
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // 저장 성공 (건수) — "{0}개의 데이터가 저장되었습니다."
  SAVE_FAIL: 'MSG00003', // 저장 실패 — "저장에 실패하였습니다."
  USER_NOT_REGISTERED: 'MSG01261', // 그룹권한 없는 사용자 (AS-IS MSG00251 등가 — 위 주석)
  REQUIRED_DIVISION: 'MSG00097', // 조회 필수(Division) — "Division 을 선택하세요."
  NO_CHANGES: 'MSG00004', // 변경 없음 — "수정한 내용이 없습니다."
  NO_DIVISION_AUTH: 'MSG00667', // 권한 Division 0건 — AS-IS SetDivisionAuthCheck(cs:178, BF:5273)
  INQUIRY_ERROR: 'MSG01052', // 조회/메타 로드 실패 — 권한 0건·정상 0건과 구분(위 주석)
} as const;

// SAVE 결과커서 계약 (PKG_SSP0014.P_SSP0014_SAVE_MODEL_PIC — ora.py 본문 실측 2026-09-28).
//   BE 는 OUT 커서를 `SCM_ADM_PROC_M.COL_NM` **그대로** JSON 키로 쓴다
//   (BaseService.java:412 `gen.writeArrayFieldStart(cursorKey)` — 소문자화 없음).
//   이 화면의 등록값은 대문자 `O_RESULT_CURSOR` 이다(실측). 저장소에 소문자 `o_result_cursor`
//   등록(153행)도 섞여 있어 기존 화면 코드(cust-psi-upload 등)를 그대로 베끼면 undefined 가 된다.
//   본문 성공(645~648): RESULT_CODE='S', RESULT_CNT=V_MAX_LOOP_CNT, CODE='0', MSG='SUCCESS'
//   본문 실패(690~693, EXCEPTION WHEN OTHERS -> ROLLBACK): RESULT_CODE='F', ERR_MESSAGE, CODE='-1', MSG
//   -> 성공·실패 양 경로 모두 커서를 OPEN 하므로 "성공인데 커서 없음" 은 없다(= 커서 부재는 실패).
export const SAVE_RESULT = {
  CURSOR_KEY: 'O_RESULT_CURSOR',
  CURSOR_KEY_LOWER: 'o_result_cursor', // 방어 — 등록 케이스가 바뀌어도 판정이 조용히 깨지지 않게
  CODE_COLUMN: 'RESULT_CODE',
  COUNT_COLUMN: 'RESULT_CNT',
  SUCCESS: 'S',
} as const;
