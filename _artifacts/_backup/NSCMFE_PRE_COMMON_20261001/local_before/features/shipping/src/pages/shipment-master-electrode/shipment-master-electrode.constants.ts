export const MENU_ID = 'SSP0024' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0024_ShipmentMasterElectrode (단일 그리드 spdMain "Ship Master Elec"):
//   설계 근거: .atlas/gscm-design/SSP0024/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   - GET  SP  : PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER          (반환 25컬럼, o_rc1)
//   - SAVE SP  : PKG_SSP0024.P_SSP0024_SAVE_SHIP_MASTER         (변경행만 ^-delim, 16 파라미터, SSP_MST_SHIP_MASTER_EE)
//   - CHECK SP : PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST       (Edit 진입 SSP Planner 권한체크, 0건→MSG00251)
//   - POPUP SP : PKG_SSP0024.P_SSP0024_GET_ITEM_BY_DIVISION_POPUP (Material/Model 선택 팝업, 원천 SCP_MST_FINAL_ITEM)
//   - 편집 상태기계: 조회=전체 lock(뷰) -> Edit(권한체크 통과) 진입 = 기존행 9칸 편집 / Insert = 신규행 지정칸 편집
//     -> Save 성공 후 뷰 복귀. 신규행('I')만 삭제 가능(기존행 삭제 불가).
//   - SP 미배포(design 00 §0 / goal.md): PKG_SSP0024·PKG_SSP0002 all_objects 0건 → 런타임 실행체인 미완(convert-sp 후속).
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (25컬럼)
  POPUP = 'popup', // SSP0024_ItembyDivisionPopup (Material/Model 선택, 원천 SCP_MST_FINAL_ITEM)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SSP0024' SHEET_NAME='Ship Master Elec' 25행(배포됨, goal.md ②).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Ship Master Elec',
};

// 조회조건/셀 콤보 SQL_ID (design 02 §2 / 03 §1.1 — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   조회조건: MyDivision(ATTRIBUTE3<>'EE' 내장) / PlantSiteByFactoryEEOperation(@divisionId, OPERATION_GROUP='E' 내장).
//   셀 콤보 5: PlantSiteByFactoryEEOperation / ElectrodePostOperCode / ElectrodePackageType / DomExpTypeCode / BuildingByPlantSite.
//   신규행 DIVISION 전용 콤보 = MyDivision (attribute9, design 03 §2.2 dtMyDivisionIns).
//   PLANT_SITE_ID 셀콤보(iter-2 G2 수정): 기존 PlantByDivisionOperation 은 @operationGroup 미바인드로
//     OPERATION_GROUP 무제한(비-EE plant 노출). AS-IS 는 dtPlantSiteByFactoryForSpread=
//     PlantSiteByFactoryEEOperation("40,81,82,81_UC")=OPERATION_GROUP='E'+FACTORY_SN 조인으로 좁혔다.
//     PlantSiteByFactoryEEOperation 은 @divisionId 만 받고 OPERATION_GROUP='E'+FACTORY_SN 조인을 SQL 본문에
//     내장하므로(ora.py 실측) 행 DIVISION_ID cascade(A2='DIVISION_ID:divisionId')만으로 AS-IS EE plant
//     후보범위를 재현한다. 05_register.sql §7-1 SCM_MST_SHEET_COLUMNS 메타도 동일 SQL_ID 로 배선.
//   BUILDING 셀콤보(gap-resolve iter-1 G9): AS-IS 는 dtBuilding 결과에 'ALL' 행을 C# 에서 선두에 끼워 넣고
//     (cs:155~159) SetCellCombo(pAllYN=true) 로 좁힌 결과에도 다시 넣는다(cs:843~850). 이 후처리는 이관 CMBO
//     SQL(BuildingByPlantSite)에 없어 ALL 후보가 사라졌다(convert-core §2.6 "소스 필터는 화면 재구현").
//     후보 목록은 공용 DataGrid 가 admin 메타로 만들므로 화면에서 끼워 넣을 수 없다 -> 화면 전용 CMBO SQL_ID
//     SSP0024_BUILDING_BY_PLANTSITE_ALL (= BuildingByPlantSite + 'ALL' 선두행) 등록(05_register.sql §9).
//     근거: SSP_MST_SHIP_MASTER_EE.FACTORY_ID='ALL' 실데이터 135행(ora.py 실측).
//   DIVISION_ID 셀콤보(gap-resolve iter-1 A01): 조회조건 콤보와 달리 **코드만** 보여야 한다. AS-IS 는
//     신규행 콤보용 DataTable 을 만들 때 CODE 를 NAME 에도 복사한다(cs:140~149) — 컬럼폭 40px 의 첫 칸에
//     '40 Mobility & IT Battery' 같은 긴 이름이 들어가지 않게 한 의도다. 후보집합은 MyDivision 그대로 두고
//     NAME 표기만 코드로 바꾼 화면 전용 SQL_ID 를 쓴다(05_register.sql §10).
export const COMBO = {
  DIVISION: 'MyDivision',
  CELL_DIVISION: 'SSP0024_MY_DIVISION_CODE',
  PLANT_SITE: 'PlantSiteByFactoryEEOperation',
  CELL_PLANT_SITE: 'PlantSiteByFactoryEEOperation',
  CELL_POST_OPER: 'ElectrodePostOperCode',
  CELL_PACKAGE_TYPE: 'ElectrodePackageType',
  CELL_DOM_EXP: 'DomExpTypeCode',
  CELL_BUILDING: 'SSP0024_BUILDING_BY_PLANTSITE_ALL',
} as const;

// POST_OPER -> POST_OPER_LT 파생 원천 lookup (design 03 §1.2 / §3.2 cs:615~623).
//   ELECTRODE_POST_OPER_CODE: SEGMENT1=DIVISION_ID / SEGMENT2=CODE(POST_OPER) / SEGMENT4=명 / SEGMENT5=LT(일수).
export const LOOKUP = {
  POST_OPER: 'ELECTRODE_POST_OPER_CODE',
} as const;

// 셀 콤보 컬럼 (design 03 §1 FPComboBox 5). 후보 좁힘(PARAM2/9/10)은 admin 메타(05_register.sql)가 원천 —
//   공용 DataGrid 가 메타로 조회·좁힘·DataMap 을 만든다(useRowParamCombos). 화면은 메타를 넘길 뿐이다.
export const CELL_COMBO_COLUMNS = [
  'PLANT_SITE_ID',
  'POST_OPER',
  'PACKAGE_TYPE_CODE',
  'DOM_EXP_TYPE_CODE',
  'BUILDING',
] as const;

// Edit 모드(기존행) 편집 가능 9칸 (design 03 §3.1 — POST_OPER..REMARKS). 나머지는 lock.
export const EDIT_EDITABLE_COLUMNS: readonly string[] = [
  'POST_OPER',
  'PC_ROLL_LENGTH',
  'PACKAGE_TYPE_CODE',
  'STEELCRATE_PER_CUT',
  'BOX_PER_CUT',
  'STEELRACK_PER_CUT',
  'DOM_EXP_TYPE_CODE',
  'BUILDING',
  'REMARKS',
];

// 신규행(Insert) 편집 가능 = DIVISION_ID/PLANT_SITE_ID(콤보) + Edit 편집 9칸 (design 03 §3.1).
//   PLANT_SITE_CODE 는 파생(잠금). MATERIAL_ID 는 팝업 트리거(인라인 편집 아님 — 아래 MATERIAL_POPUP_COLUMN).
export const INSERT_EDITABLE_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'PLANT_SITE_ID',
  ...EDIT_EDITABLE_COLUMNS,
];

// 필수(*) 10칸 (design 03 §1 라벨 * — INPUT_TP_CD 전건 'S' 라 라벨이 필수 원천). useSaveWithValidation 대상.
export const REQUIRED_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'PLANT_SITE_ID',
  'MATERIAL_ID',
  'POST_OPER',
  'PACKAGE_TYPE_CODE',
  'STEELCRATE_PER_CUT',
  'BOX_PER_CUT',
  'STEELRACK_PER_CUT',
  'DOM_EXP_TYPE_CODE',
  'BUILDING',
];

// MATERIAL_ID = 셀클릭/더블클릭 팝업 전용(키입력 차단, design 03 §3.4 cs:650). 신규행 + PLANT_SITE_CODE 있을 때만.
export const MATERIAL_POPUP_COLUMN = 'MATERIAL_ID';

// Material 팝업(SSP0024_ItembyDivisionPopup) 확정 시 신규행에 일괄 채우는 10칸 -> 팝업 반환 프로퍼티 (design 03 §3.2 cs:570~579).
//   원천 SCP_MST_FINAL_ITEM (07_human-doc §2: Model=CELL_ITEM_ID / CellType=SEGMENT2 / NickName=NICK_NAME /
//   ElectrodeType=ELECTRODE_TYPE / Pancake=ROUND(1/CONVERT_QTY_CELL,4)). 팝업 SP 가 산출해 반환.
//   주의(gap-resolve iter-1 G6): AS-IS 는 PLANT_SITE_CODE·PLANT_SITE_ID 두 칸에 **똑같이 popup.PlantSiteCode**
//     를 넣는다(cs:571~572). 팝업은 PLANT_SITE_ID 컬럼도 따로 반환하지만(popup cs:56,288) 그리드에는 쓰지
//     않는다 — 그리드의 두 칸은 Plant Site 셀콤보 CODE(SCM_SITE_ID)와 같은 값이어야 하기 때문이다(cs:640).
export const POPUP_FILL_MAP: Record<string, string> = {
  DIVISION_ID: 'DIVISION_ID',
  PLANT_SITE_CODE: 'PLANT_SITE_CODE',
  PLANT_SITE_ID: 'PLANT_SITE_CODE',
  MATERIAL_ID: 'MATERIAL_ID',
  MODEL_ID: 'MODEL_ID',
  CELL_TYPE: 'CELL_TYPE',
  NICK_NAME: 'NICK_NAME',
  ELECTRODE_TYPE: 'ELECTRODE_TYPE',
  ITEM_UOM: 'ITEM_UOM',
  UOM_CONVERT_IN_TACT_TIME: 'UOM_CONVERT_IN_TACT_TIME',
};

// 신규행 DIVISION_ID 콤보 변경 시 클리어할 종속 7칸 (design 03 §3.2 cs:630~636).
export const DIVISION_CASCADE_CLEAR: readonly string[] = [
  'PLANT_SITE_CODE',
  'PLANT_SITE_ID',
  'MATERIAL_ID',
  'MODEL_ID',
  'CELL_TYPE',
  'NICK_NAME',
  'ELECTRODE_TYPE',
];

// SAVE SP(P_SSP0024_SAVE_SHIP_MASTER) 16 파라미터 대상 컬럼 (design 03 §4.3 cs:475~490).
//   p_factory_id = BUILDING 콤보의 NAME(FACTORY_NAME) 변환값. 표시전용 10칸(MODEL_ID/CELL_TYPE/... )은 미전송.
//   p_created_by/p_creation_date/p_last_updated_by 는 세션·서버 처리(감사키 회피 — createId 단일 스칼라).

// 컬럼 메타 fallback (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 25행 실측, SORT_ORDER_NO 순).
//   admin 등록본이 있으면 authoritative(실측 25행 배포됨, goal.md ②). 미등록/실패 시 이 fallback.
//   _cell: 'combo'=FPComboBox / 'number'=FPNumber / 'popup'=MATERIAL 셀팝업. _edit 은 화면 로직(editLock)이 최종 판정.
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  scale?: number;
  _cell?: 'combo' | 'number' | 'popup';
  _comboId?: string; // _cell==='combo' 일 때 cellCboDataTp
}

export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Div*', width: 40, align: 'C', _cell: 'combo', _comboId: COMBO.CELL_DIVISION },
  { key: 'PLANT_SITE_CODE', header: 'Plant Site Code', width: 80, align: 'C' },
  { key: 'PLANT_SITE_ID', header: 'Plant Site*', width: 120, align: 'C', _cell: 'combo', _comboId: COMBO.CELL_PLANT_SITE },
  { key: 'MATERIAL_ID', header: 'Material*', width: 100, align: 'C', _cell: 'popup' },
  { key: 'MODEL_ID', header: 'Model', width: 130, align: 'L' },
  { key: 'CELL_TYPE', header: 'Cell Type', width: 70, align: 'C' },
  { key: 'NICK_NAME', header: 'Nick Name', width: 100, align: 'L' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 80, align: 'C' },
  { key: 'ITEM_UOM', header: 'UOM', width: 60, align: 'C' },
  { key: 'POST_OPER', header: 'Post Oper.*', width: 100, align: 'L', _cell: 'combo', _comboId: COMBO.CELL_POST_OPER },
  { key: 'POST_OPER_LT', header: 'Post Oper.LT(Day)', width: 80, align: 'C' },
  { key: 'UOM_CONVERT_IN_TACT_TIME', header: 'Pancake (m/cell)', width: 100, align: 'R', scale: 4, _cell: 'number' },
  { key: 'PC_ROLL_LENGTH', header: 'Pancake Roll Length', width: 100, align: 'R', _cell: 'number' },
  { key: 'PACKAGE_TYPE_CODE', header: 'Package Type*', width: 100, align: 'C', _cell: 'combo', _comboId: COMBO.CELL_PACKAGE_TYPE },
  { key: 'STEELCRATE_PER_CUT', header: 'Steelcrate/Cut*', width: 60, align: 'R', _cell: 'number' },
  { key: 'BOX_PER_CUT', header: 'Box/Cut*', width: 80, align: 'R', scale: 2, _cell: 'number' },
  { key: 'STEELRACK_PER_CUT', header: 'Steelrack/Cut*', width: 100, align: 'R', scale: 2, _cell: 'number' },
  { key: 'DOM_EXP_TYPE_CODE', header: 'DOM/EXP.*', width: 100, align: 'C', _cell: 'combo', _comboId: COMBO.CELL_DOM_EXP },
  { key: 'BUILDING', header: 'Building*', width: 50, align: 'C', _cell: 'combo', _comboId: COMBO.CELL_BUILDING },
  { key: 'BUILDING_DESC', header: 'Building Desc.', width: 140, align: 'L' },
  { key: 'REMARKS', header: 'Remarks', width: 100, align: 'L' },
  { key: 'CREATED_BY', header: 'Created By', width: 100, align: 'L' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 160, align: 'C' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 100, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 160, align: 'C' },
];

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회로 확정 — Hook #114, ora.py 실측 2026-09-22).
//   주의: AS-IS 번호를 그대로 쓰지 않는다. AS-IS MSG00004(성공)=TO-BE MSG00004("No changes to save") 로 의미가 달라
//     저장 성공은 MSG00672("{0} data saved.")를, 필수 셀 가드는 MSG00429("{0} value is required.")를 쓴다.
//   gap-resolve iter-1 재실측(ora.py, SCM_ADM_MSG_M): MSG00251·MSG00006·MSG00093 은 TO-BE 에 **존재하지 않는다**
//     (3건 전부 0행). 설계 01 §6·runtime-parity ⑥ 의 "MSG00251 존재" 기재는 오기였다. 문구 역조회로 정본 확정:
//     - "This user does not have permission to the SSP Planner.\n\rUser ID : {0}" = MSG01261 (EN/KO, USE_YN='Y')
//     - "Failed to save." = MSG00003 (EN/KO, USE_YN='Y')
export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (저장 성공, 건수)
  SAVE_FAIL: 'MSG00003', // "Failed to save." (서버 'N' 판정) — 구 MSG00006 은 미존재
  NO_CHANGES: 'MSG00004', // "No changes to save." (변경 없음)
  DUP_KEY: 'MSG00060', // "Duplicate key exists." (DIV+PLANT_SITE_CODE+MATERIAL 중복)
  REQUIRE_DIVISION: 'MSG00097', // "Please select Division." (조회/셀편집 전 Division 필수)
  REQUIRED_FIELD: 'MSG00429', // "{0} value is required." (셀편집 전 {0}=Plant Site 등 필수)
  EDIT_NO_PERMISSION: 'MSG01261', // "This user does not have permission to the SSP Planner. User ID : {0}"
  // AS-IS SetDivisionAuthCheck(BaseForm.cs:5995~6002)는 조회영역 disable 과 함께 알림을 띄운다
  //   (AS-IS MSG00097="권한을 가진 Division이 없습니다"). TO-BE MSG00097 은 "Please select Division." 로
  //   의미가 다르므로 문구 역조회로 가장 근접한 MSG00667("No authority assigned.")을 쓴다 — 정확 등가 문구가
  //   TO-BE 에 없어 사용자 확인 대상(notes.md "사용자 확인" 표).
  NO_DIVISION_AUTH: 'MSG00667',
} as const;
