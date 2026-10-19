export const MENU_ID = 'SCP0033' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SCP.Master.UIL SCP0033_Shipment_semi_dept_day (단일 그리드 spdMain "Shipment Semi Dept Day"):
//   설계 근거: .atlas/gscm-design/SCP0033/design/00_checklist.md ~ 03_grid-columns.md, 07_human-doc-supplement.md
//   반제품(Semi)의 사업부·모델별 출발요일(Departure Day)/유효여부(Valid) 등록 마스터.
//   코드 접두어 SCP 이나 실제 도메인은 SSP(Shipping) — features/shipping (00 §0 도메인 판정, 프리픽스 단정 금지).
//   자매 SSP0024(shipment-master-electrode)/SSP0025(shipment-requestor-pic) 구조 복제(단일그리드 CRUD+셀콤보+Item팝업+머지).
//   - GET   SP : PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY  (Table[0] 그리드 11열 / Table[1] 중복체크 원장)
//   - SAVE  SP : PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY (변경행만 ^-delim, I=INSERT·M=UPDATE(valid_yn/departure_day)·D 미전송)
//   - POPUP SP : SCM0002 Item by Division (신규행 ITEM_ID 셀 팝업, 반환 ItemID/NickName)
//   - 편집 규칙(design 03 §3.1 + 사용자 지시 2026-09-23): **상시 편집**(Edit 버튼 없음, 진입부터 편집 가능).
//     열리는 셀은 editLock 이 행상태로 판정 — 기존행 = DEPARTURE_DAY/VALID_YN,
//     신규행('I') = + DIVISION_ID(콤보)·ITEM_ID(팝업). 삭제는 신규행('I')만.
//   - SP 미배포(goal.md ②): PKG_SCP0033 all_objects 0건 -> 런타임 실행체인 미완(convert-sp 후속).
export enum SHEETS {
  MAIN = 'main', // spdMain 단일 시트 (11컬럼, 표시 10 + S_VALID_YN 숨김)
  POPUP = 'popup', // SCM0002 Item by Division (신규행 ITEM_ID 셀 팝업)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 그대로 (design 03 §1).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0033' SHEET_NAME='Shipment Semi Dept Day' 11행(배포됨, design 03 §0).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Semi Dept Day',
};

// 조회조건/셀 콤보 SQL_ID (TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   조회조건 Division = MyDivisionInEE — AS-IS 정본 소스 실측(SCP0033.cs:42 dtMyDivision =
//     Data_SCP.Common(Type.MyDivisionInEE, NowGroupID, UserId)). 권한게이트(@sesUserId+@mnuId) + EE 미제외.
//     설계 02 §2 의 Division_SCP(=BLUtils.GetDivision)는 호출체인 오기재였다(후보집합은 동일하나 정렬이
//     DIVISION_ID vs ATTRIBUTE1 로 다름). 검색 clbDivision 과 그리드 신규행 셀콤보 둘 다 이 소스(cs:133,204).
//   셀 콤보(메타): OPERATION_GROUP=LookupCommon(ATTRIBUTE1='OPERATION_GROUP', 항상 잠금 §6-C) /
//     DEPARTURE_DAY=LookupCommon(ATTRIBUTE1='DEPARTURE_DAY') / VALID_YN=YesOrNo.
export const COMBO = {
  DIVISION: 'MyDivisionInEE',
  VALID: 'YesOrNo',
  LOOKUP_COMMON: 'LookupCommon',
} as const;

// LookupCommon @lookupType 파라미터(ATTRIBUTE1) — design 03 §1.1.
export const LOOKUP_TYPE = {
  OPERATION_GROUP: 'OPERATION_GROUP',
  DEPARTURE_DAY: 'DEPARTURE_DAY',
} as const;

// Edit 모드(기존행) 편집 가능 = DEPARTURE_DAY/VALID_YN 만 (design 03 §3.1 — DIVISION_ID~NICK_NAME·감사컬럼 잠금).
export const EDIT_EDITABLE_COLUMNS: readonly string[] = ['DEPARTURE_DAY', 'VALID_YN'];

// 신규행(Insert) 편집 가능 = DIVISION_ID(콤보)·ITEM_ID(팝업) + 기존행 편집칸 (design 03 §3.1).
//   OPERATION_GROUP/NICK_NAME/감사컬럼은 잠금(신규행 LockRange cs:209~211).
export const INSERT_EDITABLE_COLUMNS: readonly string[] = [
  'DIVISION_ID',
  'ITEM_ID',
  ...EDIT_EDITABLE_COLUMNS,
];

// 필수(*) 2칸 (design 03 §1 라벨 * — INPUT_TP_CD 전건 'S' 라 라벨이 필수 원천).
//   INPUT_TP_CD='S' 전건이라 공용 useSaveWithValidation 은 isEditableForRow default->false 로 필수판정을 스킵한다
//   (§6-A 사문화, 메모리 input-tp-cd-search-only-kills-save-validation). 화면이 findMissingRequired 로 직접 차단.
export const REQUIRED_COLUMNS: readonly string[] = ['DIVISION_ID', 'ITEM_ID'];

// 필수검증 alert 문구용 컬럼 라벨('*' 제외 — admin 헤더와 동일, MAIN_COLUMNS Division*/Model* 대응).
export const REQUIRED_COLUMN_LABELS: Record<string, string> = {
  DIVISION_ID: 'Division',
  ITEM_ID: 'Model',
};

// ITEM_ID = 셀 클릭/더블클릭 팝업 전용(키입력 차단, design 03 §3.4 cs:440). 신규행 + DIVISION_ID 있을 때만(cs:463).
export const ITEM_POPUP_COLUMN = 'ITEM_ID';

// 세로 머지 대상 = DIVISION_ID (동일값 병합, design 03 §3.3). 신규행('I')은 CustomMergeManager 가 제외.
export const MERGE_COLUMN = 'DIVISION_ID';

// 신규행 DIVISION_ID 콤보 (메타 미반영, design 03 §1.2). cellCboDataTp + attribute9(신규행 전용 후보).
export const DIVISION_COLUMN = 'DIVISION_ID';
export const VALID_YN_COLUMN = 'VALID_YN';

// 신규행 기본값 (design 03 §3.2 #1 — VALID_YN='Y'. DIVISION_ID 는 신규행 셀콤보로 사용자 선택).
export const INSERT_DEFAULT_VALID_YN = 'Y';

// Item 팝업(SCM0002) 확정 시 신규행에 채우는 2칸 -> 팝업 반환 프로퍼티 (design 03 §3.2 cs:487~488).
//   popItem.ItemID -> ITEM_ID / popItem.NickName -> NICK_NAME.
export const POPUP_FILL_MAP: Record<string, string> = {
  ITEM_ID: 'ITEM_ID',
  NICK_NAME: 'NICK_NAME',
};

// GET SP 별칭 정정 (design 03 §6-D): GET SP 가 `VALID_YN AS S_VALUE_YN` 반환 -> 그리드 hidden 컬럼 S_VALID_YN 로 매핑.
export const GET_ALIAS_S_VALID_YN = { from: 'S_VALUE_YN', to: 'S_VALID_YN' } as const;

// Item 팝업 division 전극 재구성 (AS-IS UIUtils.GetAllDivisionsExceptUCEE, UIUtils.cs:56~76):
//   권한 목록의 CODE 중 뒤 2자가 'UC' 이거나 앞 2자가 'EE' 인 것을 빼고 나머지를 넘긴다.
export const ELECTRODE_DIVISION_PREFIX = 'EE';
export const NON_ELECTRODE_EXCLUDED_SUFFIX = 'UC';

// 컬럼 메타 fallback (design 03 §1 — DB SCM_MST_SHEET_COLUMNS 11행 실측, SORT_ORDER_NO 순, 표시순서 확정).
//   admin 등록본이 있으면 authoritative(실측 11행 배포됨, design 03 §0). 셀콤보(OPERATION_GROUP/DEPARTURE_DAY/VALID_YN)
//   도 admin 메타가 원천. 미등록/실패 시 이 fallback. 신규행 DIVISION_ID 콤보는 admin 메타에 없어 buildColumns 가 주입.
//   물리 데이터타입/길이(07 보완 S1): DIVISION_ID nvarchar(30)/ITEM_ID nvarchar(50)/DEPARTURE_DAY nvarchar(3)/
//   VALID_YN nvarchar(1)/CREATED_BY·LAST_UPDATED_BY nvarchar(150)/CREATION_DATE·LAST_UPDATE_DATE datetime.
export interface ColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  maxLength?: number;
  _cell?: 'combo' | 'date';
  _comboId?: string; // _cell==='combo' 일 때 cellCboDataTp
  _lookupType?: string; // LookupCommon @lookupType (attribute1)
}

export const MAIN_COLUMNS: ColumnMeta[] = [
  { key: 'DIVISION_ID', header: 'Division*', width: 120, align: 'C', maxLength: 30, _cell: 'combo', _comboId: COMBO.DIVISION },
  { key: 'OPERATION_GROUP', header: 'Operation Group', width: 120, align: 'C', _cell: 'combo', _comboId: COMBO.LOOKUP_COMMON, _lookupType: LOOKUP_TYPE.OPERATION_GROUP },
  { key: 'ITEM_ID', header: 'Model*', width: 150, align: 'L', maxLength: 50 },
  { key: 'NICK_NAME', header: 'Nick Name', width: 110, align: 'L' },
  { key: 'DEPARTURE_DAY', header: 'Departure day', width: 140, align: 'L', maxLength: 3, _cell: 'combo', _comboId: COMBO.LOOKUP_COMMON, _lookupType: LOOKUP_TYPE.DEPARTURE_DAY },
  { key: 'VALID_YN', header: 'Valid', width: 65, align: 'C', maxLength: 1, _cell: 'combo', _comboId: COMBO.VALID },
  { key: 'CREATED_BY', header: 'Created By', width: 90, align: 'L' },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 150, align: 'C', _cell: 'date' },
  { key: 'LAST_UPDATED_BY', header: 'Last Updated By', width: 90, align: 'L' },
  { key: 'LAST_UPDATE_DATE', header: 'Last Update Date', width: 150, align: 'C', _cell: 'date' },
  { key: 'S_VALID_YN', header: 'S_VALID_YN', width: 65, align: 'C', visible: false },
];

// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회로 확정 — Hook #114). AS-IS 번호를 그대로 쓰지 않는다.
//   자매 SSP0024/SSP0025 역조회 재사용(동일 도메인 메시지 레지스트리 공유):
//     저장 성공 = MSG00672("{0} data saved.") — 저장 실패 = MSG00006, 중복 = MSG00060.
//     저장대상 0건 = MSG00004("No changes to save.").
//       정정(gap-resolve iter-1, asis.py 실측): AS-IS MSG00059 의 문구는 "No data to save." 가 아니라
//       **"Check before adding."**("조회 후 추가하십시오.") 이고, 발동 조건도 dirty 0 이 아니라
//       RowCount<=0(빈 그리드)다(cs:306~310). AS-IS 는 그리드에 행이 있는데 변경이 0건이면 cs:370 에서
//       메시지 없이 조용히 빠진다. 즉 이 화면의 dirty 0 안내는 AS-IS MSG00059 의 이식이 아니라 TO-BE 표준
//       (datagrid-nochange-save-toast-standard)을 따른 것이며, MSG00004("No changes to save.")가 의미상 맞다.
//       빈 그리드에 "조회 후 추가" 안내를 따로 띄울지는 사용자 결정 대기(gap-resolve iter-1 notes).
//       참고: MSG00059 는 TO-BE SCM_ADM_MSG_M 에 미등록(전 언어 0행)이라 어차피 그대로 쓸 수 없다.
//   REQUIRE_DIVISION(hook #114 실측): TO-BE MSG00097 의 등록 문구는 "Division 을 선택하세요."="Please select Division."
//     (자매 SSP0024/SSP0025 + DMF0003 mkt-fcst 사내 DB 대조 EXACT). 신규행/팝업 Division 미선택 안내 전용.
//   NO_DIVISION_AUTH(hook #114 실측, iter-2 G8): L1 권한게이트(권한 division 0건)는 "권한 없음" 의도이므로
//     MSG00097(선택 안내)이 아니라 MSG00667("No authority assigned."/"권한이 있는 Division이 없습니다.")로 분리.
//     MSG00097 을 권한게이트에 쓰면 권한없는 사용자에게 "Division 선택하세요" 오안내(iter-2 ora.py 실측 확정).
//     AS-IS 는 같은 자리에 MSG00097 을 쓰지만(BaseForm.SetDivisionAuthCheck cs:5998) AS-IS MSG00097 의 문구가
//     "권한을 가진 Division이 없습니다." 라 의도가 TO-BE MSG00667 과 같다 — 번호가 아니라 문구로 매핑한다.
//   SAVE_FAIL(gap-resolve iter-1 실측): AS-IS 는 MSG00006 이나 TO-BE SCM_ADM_MSG_M 에 MSG00006 은 전 언어 0행
//     (미등록). 등록된 MSG00003 이 EN/KO/CN 3언어로 같은 문구("Failed to save.")를 갖고 있어 그쪽으로 환원한다.
//     미등록 코드를 두면 i18next 가 키를 못 찾아 KO/CN 사용자에게도 영문 defaultValue 가 뜬다(MSG00059 와 같은 함정).
//     임의 INSERT 금지(convert-core §2.3)라 등록 코드로 우회한다.
// i18n 라벨 코드 — SCM_ADM_MSG_M(MSG_TP_CD='LBL') 문구 역조회 실측(#114). AS-IS 번호 그대로 쓰지 않는다.
//   Division 은 표준 LBL00001(자매 shipment-working-day/bod-item 동일 — LBL00641 금지).
//   조회영역 Search 버튼 = LBL00112. 팝업/결과영역 Search 버튼 = LBL00664(위치로 구분).
export const LBL = {
  DIVISION: 'LBL00001', // "Div"
  MODEL: 'LBL00669', // "Model" (ITEM_ID 라벨)
  VALID: 'LBL00639', // "Valid"
  SEARCH: 'LBL00112', // 조회영역 상단 Search
  SEARCH_POPUP: 'LBL00664', // 팝업 내부 Search
  ITEM_POPUP_TITLE: 'LBL00343', // "Item Popup"
  NO: 'LBL00674', // "No"
  OK: 'LBL00716', // "OK"
  CLOSE: 'LBL00627', // "Close"
} as const;

export const MSG = {
  SAVE_SUCCESS: 'MSG00672', // "{0} data saved." (저장 성공, 건수)
  SAVE_FAIL: 'MSG00003', // "Failed to save." (서버 비'S' 판정) — AS-IS MSG00006 은 TO-BE 미등록이라 환원
  NO_DATA: 'MSG00004', // "No changes to save." (저장 대상 0건=무변경) — MSG00059 미등록 환원(iter-2 G9)
  DUP_KEY: 'MSG00060', // "Duplicate key exists." (DIVISION_ID+ITEM_ID 중복) — AS-IS MSG00060
  REQUIRE_DIVISION: 'MSG00097', // "Please select Division." (신규행/팝업 Division 미선택 안내 전용) — AS-IS MSG00093
  NO_DIVISION_AUTH: 'MSG00667', // "No authority assigned." (L1 권한 division 0건 게이트) — iter-2 G8 분리
} as const;
