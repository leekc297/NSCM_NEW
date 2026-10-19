export const MENU_ID = 'SSP0025' as const;
export type MENU_ID = typeof MENU_ID;

// UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 실측 역조회 — Hook #114, lbl-dict 검증본).
//   값 = LBL 코드, 사용처 = t(LBL.KEY, '_Fallback'). admin 그리드 헤더(colLblNm)는 대상 아님.
export const LBL = {
  SEARCH: 'LBL00112', // 'Search(F5)' — 메인 조회영역 SearchArea
  SEARCH_MODAL: 'LBL00664', // 'Search' — 모달 내부 SearchArea
  DIVISION: 'LBL00001', // 'Div.'
  PLANT_SITE: 'LBL00005', // 'Plant Site'
  MATERIAL: 'LBL00021', // 'Material'
  NICK_NAME: 'LBL00767', // 'Nick Name'
  MODEL: 'LBL00669', // 'Model'
  NO: 'LBL00674', // 'No'
  ITEM_BY_DIVISION: 'LBL00343', // 'Item Popup'
  OK: 'LBL00716', // 'OK'
  CLOSE: 'LBL00627', // 'Close'
} as const;

// AS-IS GSCM.SSP.Plan.UIL SSP0025_ShipmentRequestorPIC (단일 그리드 spdMain "Shipment Requestor PIC"):
//   설계 근거: .atlas/gscm-design/SSP0025/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   전극(EE) 자재의 Division×Plant Site(To Site)×Material(Item)별 출하요청 PIC(담당자)/Part Leader/Team Leader 마스터.
//   자매 SSP0024(Ship Master Elec, 편집모드·셀콤보·Item팝업) + SSP0014(Shipment Model PIC, User 이미지셀 팝업)에서 복제.
//   - GET   SP : PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC (반환 19컬럼, o_rc1)
//   - SAVE  SP : PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC (변경행만 ^-delim MERGE, SSP_MST_MODEL_USER_EE)
//   - CHECK SP : PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK (저장 전 User/Leader 등록 검증, 미등록 시 MSG00251)
//   - POPUP SP : PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP (Material/Model 선택, 화면전용)
//   - 편집 파리티: 조회직후 = 기존행 편집칸(USER/PART/TEAM/VALID) / 신규행('I') = 지정칸(콤보·팝업). 셀 edit-lock 이 판정.
//     편집 파리티(사용자 결정 2026-09-23): Edit 버튼 없이 진입 즉시 편집, 단 편집권한을 화면 Load 시점에
//     판정해 권한 없으면 읽기전용. 권한 원천 = admin 버튼권한 EDIT(AS-IS SSP0002 서버판정의 TO-BE 등가).
//     AS-IS EditButton→SwitchLock 2-상태는 재현하지 않는다(04 §C2 종결).
//   - 삭제(#138): 신규행('I')만 removeRow, 기존행은 VALID_YN='N'+저장('M'). 물리삭제 없음(SAVE SP active_flag 미사용, 07 보완6).
//   - SP 미배포(goal.md ②): PKG_SSP0025 all_objects 0건 → 런타임 실행체인 미완(convert-sp 후속).
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (19컬럼)
  POPUP = 'popup', // SSP0025_ItembyDivisionPopup (Material/Model 선택, 화면전용 SP)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0025' SHEET_NAME='Shipment Requestor PIC' 19행(배포됨, design 03 §0).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Requestor PIC',
};

// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1.2·§1.4 — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   조회조건: MyDivision(ATTRIBUTE3<>'EE'·권한필터 내장) / PlantCell(@divisionId cascade, OPERATION_GROUP='A'·OSP제외 내장).
//   셀 콤보 3(전건 admin 메타 등록 완료 — 05_register.sql §7): VALID_YN=YesOrNo /
//     SITE_DESCRIPTION=PlantCell(PARAM2='DIVISION_ID:divisionId'·PARAM10='D' 행 division 재조회) /
//     DIVISION_ID=MyDivision(PARAM9 신규행 전용).
export const COMBO = {
  DIVISION: 'MyDivision',
  PLANT_SITE: 'PlantCell',
  VALID: 'YesOrNo',
} as const;

// 기존행(조회행) 편집 가능 칸 (design 03 §3 R3): User/Part/Team(더블클릭 팝업) + VALID_YN(콤보).
//   CELL_TYPE 은 07_human-doc 보완4(대조#9)로 ReadOnly 확정 → 편집칸에서 제외(design §6-C4 해소).
export const EDIT_EDITABLE_COLUMNS: readonly string[] = [
  'USER_ID',
  'PART_LEADER',
  'TEAM_LEADER',
  'VALID_YN',
];

// 신규행(Insert) 편집 가능 칸 (design 03 §3 R4): DIVISION_ID/SITE_DESCRIPTION(콤보)·ITEM_ID(팝업) + 기존행 편집칸.
export const INSERT_EDITABLE_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'SITE_DESCRIPTION',
  'ITEM_ID',
  ...EDIT_EDITABLE_COLUMNS,
];

// 필수(*) 4칸 (design 03 §1.1 라벨 *). admin 메타 INPUT_TP_CD 는 gap-resolve 이전 정비로
//   SITE_DESCRIPTION/ITEM_ID='IM'(신규행 필수), USER_ID/VALID_YN='M'(상시 필수) 이라 공용
//   useSaveWithValidation 이 발동한다. 단 admin 컬럼메타 fetch 가 실패하면 staticColumns 가 빈 배열이라
//   공용 검증이 통째로 skip 되므로, 화면이 이 목록으로 먼저 검사한다(자매 SSP0024 findMissingRequired 동일).
export const REQUIRED_COLUMNS: readonly string[] = [
  'SITE_DESCRIPTION',
  'ITEM_ID',
  'USER_ID',
  'VALID_YN',
];

// ITEM_ID = 셀 더블클릭 팝업 전용(키입력/인라인 편집 차단, design 03 §3 R12). 신규행 + PlantSite 있을 때만.
export const ITEM_POPUP_COLUMN = 'ITEM_ID';

// User/Part/Team = 더블클릭 UserInfoPopup(SsoUserModal) 전용 이미지셀 (design 03 §3 R16~R18). ID만 대입.
export const USER_POPUP_COLUMNS = ['USER_ID', 'PART_LEADER', 'TEAM_LEADER'] as const;

// 이미지셀 팝업 컬럼 -> 짝 이름 컬럼. AS-IS UserInfoPopup 은 ID만 SetValue(*_NAME 미세팅, design 03 §3.1/§6-C3).
//   TO-BE 는 선택 즉시 이름도 채워 UX 개선(이름 컬럼은 조회전용 'S' — SAVE payload 미포함, 표시 목적만).
export const USER_POPUP_NAME_COLUMN: Record<string, string> = {
  USER_ID: 'USER_NAME',
  PART_LEADER: 'PART_LEADER_NAME',
  TEAM_LEADER: 'TEAM_LEADER_NAME',
};

// Item 팝업(SSP0025_ItembyDivisionPopup) 확정 시 신규행에 일괄 채우는 6칸 (design 03 §3 R12 cs:642~666).
//   반환 프로퍼티 = 셀 컬럼명 동일(팝업 SP 반환 alias). DIVISION_ID 는 신규행 division 컨텍스트, 나머지는 파생 표시.
export const POPUP_FILL_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'ITEM_ID',
  'ELECTRODE_TYPE',
  'MODEL_ID',
  'NICK_NAME',
  'CELL_TYPE',
];

// 신규행 DIVISION_ID 콤보 변경 시 초기화할 종속 7칸 (design 03 §3 R14 cs:683~695).
export const DIVISION_CASCADE_CLEAR: readonly string[] = [
  'TO_SITE',
  'SITE_DESCRIPTION',
  'ITEM_ID',
  'ELECTRODE_TYPE',
  'MODEL_ID',
  'NICK_NAME',
  'CELL_TYPE',
];

// SITE_DESCRIPTION(PlantCell 콤보, value=SCM_SITE_ID) 선택 시 TO_SITE 파생 원천 (design 03 §3 R13 cs:679~682).
export const SITE_DESCRIPTION_COLUMN = 'SITE_DESCRIPTION';
export const TO_SITE_COLUMN = 'TO_SITE';
export const DIVISION_COLUMN = 'DIVISION_ID';
export const VALID_YN_COLUMN = 'VALID_YN';

// 신규행 기본값 (design 03 §3 R7 — VALID_YN='Y'. DIVISION_ID 는 확정 searchParams 기준, 페이지 handleInsert 에서 주입).
export const INSERT_DEFAULT_VALID_YN = 'Y';

// 컬럼 메타 fallback (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 19행 실측, SORT_ORDER_NO 순).
//   admin 등록본이 있으면 authoritative(실측 19행 배포됨 — 편집 파리티는 화면 editLock 이 최종 판정).
//   셀콤보 좁힘(PARAM2/9/10)은 admin 메타(05_register.sql)가 원천.
//   미등록/실패 시 이 fallback. _cell: 'combo'=FPComboBox / 'popup'=이미지셀(User) / 'date'=FPDateTime.
//   ITEM_ID(팝업)는 셀타입 미지정 — 더블클릭(화면 dblClick)으로만 열고 beginningEdit 이 인라인 편집 취소(팝업 전용).
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  _cell?: 'combo' | 'popup' | 'date';
  _comboId?: string; // _cell==='combo' 일 때 cellCboDataTp
}

export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 60, align: 'C', _cell: 'combo', _comboId: COMBO.DIVISION },
  { key: 'TO_SITE', header: 'Plant Site Code', width: 100, align: 'C' },
  { key: 'SITE_DESCRIPTION', header: 'Plant Site*', width: 100, align: 'C', _cell: 'combo', _comboId: COMBO.PLANT_SITE },
  { key: 'ITEM_ID', header: 'Material*', width: 100, align: 'L' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 100, align: 'C' },
  { key: 'MODEL_ID', header: 'Model', width: 120, align: 'L' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'L' },
  { key: 'CELL_TYPE', header: 'Cell Type', width: 0, align: 'C', visible: false },
  { key: 'USER_ID', header: 'User ID*', width: 100, align: 'L', _cell: 'popup' },
  { key: 'USER_NAME', header: 'User Name', width: 100, align: 'L' },
  { key: 'PART_LEADER', header: 'Part Leader', width: 100, align: 'L', _cell: 'popup' },
  { key: 'PART_LEADER_NAME', header: 'Part Leader Name', width: 100, align: 'L' },
  { key: 'TEAM_LEADER', header: 'Team Leader', width: 100, align: 'L', _cell: 'popup' },
  { key: 'TEAM_LEADER_NAME', header: 'Team Leader Name', width: 100, align: 'L' },
  { key: 'VALID_YN', header: 'Valid*', width: 60, align: 'C', _cell: 'combo', _comboId: COMBO.VALID },
  { key: 'CREATED_BY', header: 'Created By', width: 110, align: 'L' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 130, align: 'C', _cell: 'date' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 110, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 130, align: 'C', _cell: 'date' },
];

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회로 확정 — Hook #114). AS-IS 번호를 그대로 쓰지 않는다.
//   자매 SSP0024(ora.py 실측 2026-09-22) 역조회 재사용 — 동일 도메인/메시지 레지스트리 공유:
//     AS-IS MSG00004(성공)=TO-BE MSG00004("No changes to save")로 의미가 달라 저장 성공은 MSG00672 사용.
//     AS-IS MSG00093(select {0})=TO-BE 는 MSG00097(Division) / MSG00429("{0} value is required")로 분해.
//   gap-resolve iter-1 재실측(ora.py, SCM_ADM_MSG_M): MSG00006·MSG00251 은 TO-BE 에 **존재하지 않는다**
//     (LANG_CD 무관 0행). 04 iter-2 의 "MSG00006/MSG00251 EN 실재" 기재는 오기였다 — 그대로 두면 i18n 이
//     미스해 `_Save failed.` 처럼 밑줄 붙은 defaultValue 가 사용자에게 노출된다. 문구 역조회로 정본 확정:
//     - "Failed to save." = MSG00003 (EN/KO, USE_YN='Y')
//     - "This user does not have permission to the SSP Planner.\n\rUser ID : {0}" = MSG01261 (EN/KO, USE_YN='Y')
//   주의: AS-IS MSG00284(실행중 에러)를 그대로 쓰면 안 된다 — TO-BE MSG00284 는 "The grid is not ready." 로
//     뜻이 전혀 다르다(실측). 자매 SSP0024 gap-resolve iter-1 과 동일 결론.
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (저장 성공, 건수) — AS-IS MSG00004 대응
  SAVE_FAIL: 'MSG00003', // "Failed to save." (서버 'N' 판정) — AS-IS MSG00284 대응, 구 MSG00006 은 미존재
  NO_CHANGES: 'MSG00004', // "No changes to save." (변경 없음)
  REQUIRE_DIVISION: 'MSG00097', // "Please select Division." (조회/셀편집 전 Division 필수) — AS-IS MSG00093(Division)
  REQUIRED_FIELD: 'MSG00429', // "{0} value is required." (셀편집 전 {0}=Plant Site 필수) — AS-IS MSG00093(Plant Site)
  USER_NOT_REGISTERED: 'MSG01261', // "This user does not have permission to the SSP Planner. User ID : {0}" — 구 MSG00251 은 미존재
} as const;
