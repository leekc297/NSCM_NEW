export const MENU_ID = 'SCP0002' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0002_LineMaster (단일 FpSpread spdMain, 2 SheetView 전환):
//   설계 근거: .atlas/gscm-design/SCP0002/design/00_checklist.md ~ 03_grid-columns.md
//   - GET SP 2종 : SCP0002_GET_LINE_MASTER(Plant 13칼럼) / SCP0002_GET_LINE_MASTER_OSP(Packer 9칼럼)
//   - SAVE SP 1종: SCP0002_SAVE_LINE_MASTER_OSP (Packer 만, I/M only — D 분기 없음, design 03 §4.4)
//   - Plant 시트 = 조회 전용(전 칼럼 잠금, Edit 시 MSG00109). Packer 시트 = 편집(Insert/Edit/Delete/Save).
//   - 그리드 편집잠금 white-list gridSignals 31건 / SCM_SITE_ID 신규행 콤보 파생 / Insert 기본값 (design 03 §3)
export enum SHEETS {
  PLANT = 'plant', // shtMain (ActiveSheetIndex 0) — 조회 전용
  PACKER = 'packer', // shtPacker (OSP) — 편집 대상 시트
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  PLANT: 'o_rc1',
  PACKER: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 상수 그대로 (design 03 §1).
//   shtMain='Plant' / shtPacker='Packer'. 라우팅 SHEETS value 와 분리.
//   design 03 §6-3 실측: SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SCP0002) Plant 17 / Packer 9 등록됨(PASS).
//   'Line Master' sheetNm(Plant 와 완전 동일 중복 17칼럼)은 화면 미사용 — 매핑하지 않는다(design 03 §화면구조전제).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.PLANT]: 'Plant',
  [SHEETS.PACKER]: 'Packer',
};

// spdMain 활성 시트 모드 — AS-IS siMain.ActiveSheet(shtMain Plant / shtPacker Packer).
//   초기 활성 = Plant (cs:228 ChangeActiveSheet shtMain). 시트전환이 조회 SP·편집가부·저장대상을 가른다(design 03 §화면구조전제).
export enum LINE_MODE {
  PLANT = 'PLANT',
  PACKER = 'PACKER',
}

// 신규행 전용 셀콤보 (SCM_SITE_ID) — AS-IS C# 런타임 SetCellTypeCombo (메타 PARAM 미사용, design 03 §1.3).
//   반환 컬럼 CODE / NAME / OPERATION_ID (ora.py SCM_ADM_CMBO_SQL_M 실측). 파라미터 divisionId=40,81,82 / operationGroup=P / param3=Y.
//   신규행 후보만 노출은 화면 하드코딩(getDisplayValues) — memory insert-only-combo-hardcode.
export const SITE_COMBO_ID = 'PlantByDivisionOperOsp3_SCP';
export const SITE_COMBO_DIVISIONS = '40,81,82';

// 정적 셀콤보 (VALID_YN/RACK_YN/SCS_PROD_AMEND) — 공통 Y/N (design 03 §1.4, SCM_ADM_CMBO_SQL_M).
export const YESORNO_COMBO_ID = 'YesOrNo';

// RACK_YN='Y' 시 OPERATION_ID 접미사 (design 03 §3.1 #6 — cs:795).
export const RACK_SUFFIX = '_R1';

// ====================================================================================
// 조회조건 콤보 ID (design 02 §5.2 전환 계약)
// ====================================================================================
// design 02 실측(PASS): 조회콤보 8종. cascade Division root -> PlantSite/Building/Operation/Line.
//   Plant/Packer 시트로 PlantSite·Line 공급 콤보가 갈린다(이름유사 금지·의미매칭 — combo-semantic-parity).
export const COMBO = {
  // cboDivision — MyDivision(권한 사업부). AS-IS 권한필터 ATTRIBUTE3<>'EE' + VALID_YN='Y' 는 화면에서 재현
  //   (이관 SQL 본문 수정 금지 — Hard Boundary. combo-semantic-parity-no-name-reuse).
  DIVISION: 'MyDivision',
  // cboValid — 독립 Y/N (조회조건, 그리드 셀콤보와 동일 SQL_ID 이지만 소비 위치가 다름).
  VALID: 'YesOrNo',
  // clbPlantSite — Plant 시트 = PlantByDivisionOperNonOsp123(CommonAll → _SCP_ALL), Packer 시트 = PlantByDivisionOperOsp3(Common → _SCP).
  //   SQL_ID 접미사는 SCM_ADM_CMBO_SQL_M 등록명 실측 = 로드 방식(_SCP_ALL 권한무시 전량 / _SCP 권한필터, convert-core §2.6).
  PLANT_SITE_PLANT: 'PlantByDivisionOperNonOsp123_SCP_ALL',
  PLANT_SITE_PACKER: 'PlantByDivisionOperOsp3_SCP',
  // clbBuilding — BuildingByDivision1 (Plant 시트에서만 표시, CommonAll → _SCP_ALL).
  BUILDING: 'BuildingByDivision1_SCP_ALL',
  // clbOperation — LocationGroupByCapa (param-less 전량, requery 방식 — design 02 filter/requery 구분. 접미사 없는 공통 콤보).
  OPERATION: 'LocationGroupByCapa',
  // clbLine — Plant 시트 = LineByOperation2(CommonAll → _SCP_ALL), Packer 시트 = LineByPlantPacker(Common → _SCP).
  LINE_PLANT: 'LineByOperation2_SCP_ALL',
  LINE_PACKER: 'LineByPlantPacker_SCP',
} as const;

// 화면 UI 라벨 — DB SCM_ADM_MSG_M(MSG_TP_CD='LBL') 문구 매칭으로 확정한 코드.
//   값 자체가 LBL 코드 문자열이며 호출부는 t(LBL.KEY, '_Fallback') 형태로 소비한다.
export const LBL = {
  SEARCH: 'LBL00112', // Search (표준 LBL00112)
  DIVISION: 'LBL00001', // Division (표준 LBL00001)
  PLANT_SITE: 'LBL00005', // Plant Site
  PLANT: 'LBL00030', // Plant
  BUILDING: 'LBL00008', // Building
  OPERATION: 'LBL00009', // Operation
  LINE: 'LBL00010', // Line
  VALID: 'LBL00639', // Valid
  ALL: 'LBL00632', // All
} as const;

// AS-IS Validation MSG — TO-BE SCM_ADM_MSG_M 실측 역매핑(문구 기준, AS-IS 번호 그대로 복사 금지).
//   design 00 §2b 매핑: MSG00109 읽기전용 / MSG00002 필수·성공 / MSG00004 변경없음 / MSG00006 저장성공.
//   TO-BE 미등록 항목은 영문 defaultValue 로 표시(엉뚱한 한글 매핑 회피).
export const MSG = {
  READ_ONLY: 'MSG00109', // 읽기전용 상태입니다. (Plant 시트 Edit 차단)
  REQUIRED_FIELD: 'MSG00429', // {0} 값은 필수 입력 항목입니다.
  NO_AUTH_DIVISION: 'MSG00097', // 권한을 가진 Division이 없습니다. (SetDivisionAuthCheck 검색영역 잠금 안내)
  NO_CHANGES: 'MSG00004', // 변경된 내용이 없습니다.
  SAVE_SUCCESS: 'MSG00002', // 성공적으로 저장되었습니다.
  SAVE_FAIL: 'MSG00043', // 저장 중 오류가 발생하였습니다. {0}
} as const;

// 컬럼 메타 (룰 12 §11.7 형식) — admin SCM_MST_SHEET_COLUMNS 미로드 시 fallback.
//   inputTp: 'S'=조회전용(잠금) / 'O'=편집후보(최종 편집가부는 utils/lineMasterEditLock 화이트리스트가 판정).
//   cell='combo' 인 칼럼만 comboId 를 싣는다 — 그 외엔 공용 매핑의 editor/format 미부착(SalesFuturePriceGrid 규약).
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  inputTp: 'S' | 'O';
  cell?: 'combo';
  comboId?: string;
}

// ===== Plant 시트 (design 03 §1.1 — 메타 17칼럼, 표시 12) =====
//   GET SP 반환 13칼럼 기준으로 표시칼럼 구성. COMPANY_ID/SITE_ID/PLANT_ID(15~17)·LOCATION_*(13~14)는 hidden meta-only.
export const PLANT_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 80, align: 'C', inputTp: 'S' },
  { key: 'SCM_SITE_ID', header: 'Plant Site Code', width: 110, align: 'L', inputTp: 'S' },
  { key: 'SITE_DESCRIPTION', header: 'Plant Site', width: 140, align: 'L', inputTp: 'S' },
  { key: 'FACTORY_ID', header: 'Building Code', width: 100, align: 'C', inputTp: 'S' },
  { key: 'FACTORY_NAME', header: 'Building', width: 120, align: 'L', inputTp: 'S' },
  { key: 'OPERATION_ID', header: 'Operation Code', width: 110, align: 'L', inputTp: 'S' },
  { key: 'OPERATION_NAME', header: 'Operation', width: 120, align: 'L', inputTp: 'S' },
  { key: 'LINE_ID', header: 'Line Code', width: 100, align: 'L', inputTp: 'S' },
  { key: 'LINE_NAME', header: 'Line', width: 120, align: 'L', inputTp: 'S' },
  { key: 'LINE_SETUP_GROUP_ID', header: 'Line Setup Group', width: 120, align: 'L', inputTp: 'S' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 110, align: 'L', inputTp: 'S' },
  { key: 'ACTIVE_FLAG', header: 'Valid', width: 70, align: 'C', inputTp: 'S' },
  // hidden meta-only / LOCATION 계열 (design 03 §1.1 VISIBLE_FLAG=N)
  { key: 'LOCATION_CODE', header: 'Location Code', width: 100, align: 'L', visible: false, inputTp: 'S' },
  { key: 'LOCATION_DESCRIPTION', header: 'Location', width: 120, align: 'L', visible: false, inputTp: 'S' },
];

// ===== Packer 시트 (design 03 §1.2 — 9칼럼, SORT 1~8 + 11) =====
//   OPERATION_ID(sort7) hidden 이나 파생·저장 대상이라 유지. 편집후보(O) = 신규행 SCM_SITE_ID(콤보) +
//   LINE_NAME/VALID_YN/SCS_PROD_AMEND (편집모드 잔여). 최종 편집가부는 lineMasterEditLock 화이트리스트가 판정.
export const PACKER_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division', width: 80, align: 'C', inputTp: 'S' },
  // SCM_SITE_ID — 메타는 FPTextBox(콤보 아님). 신규행 전용 콤보는 화면 하드코딩(insertOnlyDataMaps). inputTp='O'.
  { key: 'SCM_SITE_ID', header: 'Plant Site Code', width: 130, align: 'L', inputTp: 'O' },
  { key: 'SITE_DESCRIPTION', header: 'Plant Site', width: 140, align: 'L', inputTp: 'S' },
  { key: 'LINE_ID', header: 'Line Code', width: 100, align: 'L', inputTp: 'O' },
  { key: 'LINE_NAME', header: 'Line', width: 120, align: 'L', inputTp: 'O' },
  { key: 'VALID_YN', header: 'Valid', width: 70, align: 'C', inputTp: 'O', cell: 'combo', comboId: YESORNO_COMBO_ID },
  { key: 'OPERATION_ID', header: 'Operation', width: 110, align: 'C', visible: false, inputTp: 'O' },
  { key: 'RACK_YN', header: 'Rack', width: 70, align: 'C', inputTp: 'O', cell: 'combo', comboId: YESORNO_COMBO_ID },
  { key: 'SCS_PROD_AMEND', header: 'SCS Prod Amend', width: 120, align: 'C', inputTp: 'O', cell: 'combo', comboId: YESORNO_COMBO_ID },
];

// Freeze 좌측 고정 경계 — SITE_DESCRIPTION 까지 (design 03 §3.4 #24 — cs:244).
export const FREEZE_ANCHOR = 'SITE_DESCRIPTION';
