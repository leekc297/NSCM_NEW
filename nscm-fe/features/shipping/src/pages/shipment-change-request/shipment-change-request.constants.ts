export const MENU_ID = 'SSP0201' as const;

// 저장 전 출하상태 재검사 call-proc 버튼코드 — API_ID `SSP0201_main_STATUS_CHECK`(SP: P_SSP0201_GET_SHIPMENT_STATUS).
//   버튼맵/권한은 28_register_search_new_btn_auth.sql [B]STATUS_CHECK 블록에 등록(화면 버튼 아님, 백그라운드 검사).
export const BTN_STATUS_CHECK = 'STATUS_CHECK' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS GSCM.SSP.Plan.UIL SSP0201_ShipmentChangeRequest (출하 변경 요청, 5838라인):
//   설계 근거: .atlas/gscm-design/SSP0201/design/00_checklist.md ~ 03_grid-columns.md, 상세 매핑 __asis-mapping__.md
//   - 그리드 2개: spdMain "Shipment Change Request"(65컬럼, 편집) / spdSub "Change Request"(58컬럼, 전량 읽기전용)
//   - GET  SP : PKG_SSP0201.P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST(메인) / _GET_SHIPMENT_REQUEST_DRAFTING(서브)
//   - SAVE SP : _SAVE_SHIPMENT_REQUEST_DRAFTING(NewNonSoNo/NonSoNo/SoNo 3분기) / _SAVE_SHIPMENT_REQUEST_COMPLETE
//   - 편집모드 모드토글 미이식: AS-IS 는 EditButton/SwitchLock 상태기계(조회=전열 lock -> Edit 으로 해제,
//       cs:693~762, 진입가드 siSub.RowCount==0)지만 **편집 기본 ON** 으로 간다 — convert-core §2.4 +
//       사용자 지시(2026-09-25/2026-10-07). 자매 SSP0200 과 동일하다. 종전 TO-BE 의 Edit 버튼은 가드
//       `subRows.length > 0` 에 걸리면 알림도 없이 무동작이라 서브에 행이 있는 순간 편집이 도달불가였다.
//       컬럼 단위 잠금은 모드가 아니라 행 상태/컬럼 속성(editLock)이 담당한다.
//   - Division "40" 고정 + disabled(R3). Insert=실동작 / Delete=저장 전 신규행 전용(아래) / dead UI 5버튼 미노출(R4)
//   - Delete: AS-IS `DeleteButton()`(본문 공백 NO-OP)이나, 넣은 신규행을 되돌릴 수단이 없어 자매 SSP0200 과
//       동일하게 **저장 전 신규행(CRUD_TYPE='I')만 제거**로 실동작을 부여했다(사용자 지시 2026-10-07).
//   - PKG_SSP0201 배포 상태(2026-10-07 ora.py 실측): PACKAGE/PACKAGE BODY 모두 VALID. 종전 "미배포" 주석은 stale.
//       배포된 SP 10종 = _GET_SHIPMENT_CHANGE_REQUEST / _GET_SHIPMENT_CHANGE_REQUEST_N(신규조회 라우팅) /
//       _GET_SHIPMENT_REQUEST_DRAFTING / _GET_CHANGE_REQ_NO / _GET_ERP_SO_NO_CNT / _GET_SHIPMENT_STATUS /
//       _SAVE_SHIPMENT_CONFIRM_NEW / _SAVE_SHIPMENT_REQUEST_DRAFTING / _SAVE_SHIPMENT_REQUEST_COMPLETE /
//       _DELETE_SHIPMENT_REQUEST_DRAFTING.
//   - 단, 버튼메타(SCM_ADM_MNU_BTN_MPG_M)는 초기 SEARCH/SAVE/EDIT/INSERT + sub SEARCH **5행만**이었고
//       증분 등록으로 DELETE(21_) · SEARCH_NEW/STATUS_CHECK(28_) · GET_SCP_DAY_PERIOD(32_) · EXCEL(33_)
//       을 보강했다. EXCEL 은 클라이언트 그리드 export 라 API_ID 없이 버튼맵만 등록(hasButton('EXCEL')→공용 SubTitle 기본 핸들러).
//       GET_CHANGE_REQ_NO · GET_ERP_SO_NO_CNT · USER_CHECK 는 아직 미등록 → 해당 FE 경로는 메타 등록 후 배선.
//       (자매 SSP0200 은 18행 등록.)
export enum SHEETS {
  MAIN = 'main', // spdMain "Shipment Change Request" (65컬럼)
  SUB = 'sub', // spdSub "Change Request" (58컬럼, 읽기전용)
}

// NSCM 단일 cursor 표준 'o_rc1'. 서브 GET SP 는 2개 결과셋(상세 + Model PIC)이나 주 표시셋은 o_rc1.
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  SUB: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 명 그대로 (design 03 §0).
//   실측: PROGRAM_ID='SSP0201' -> "Shipment Change Request" 65행 / "Change Request" 58행 (총 123행 배포됨).
export const ADMIN_SHEET_NAME: Record<SHEETS, string> = {
  [SHEETS.MAIN]: 'Shipment Change Request',
  [SHEETS.SUB]: 'Change Request',
};

// ====================================================================================
// 조회조건 콤보/lookup ID (design 02 §2/§5 — TO-BE Oracle 실측, ora.py)
// ====================================================================================
//   - MyDivision(CMBO_SQL): 권한 division + ATTRIBUTE3<>'EE'(EE 제외 WHERE 내장). Division 40 고정.
//   - To Site: ShipmentPlanToSite_SCP(CMBO_SQL) @divisionId 재조회.
//   - From Site: CN-1 미확정(iter-2 재확인) — AS-IS 활성코드 Data.UserPlantSiteByDivisionOspPack 는
//       C# Data.* 메서드로 asis.py procs 조회 0건(MSSQL SP/함수 아님) → WHERE 실측 불가. TO-BE 엔
//       유사명 ShipmentPlanPlantSite_SCP(PLANT+EE_SHIPMENT_PLAN, SSP_UI_EXCEPT_COMPANY 제외)만 존재.
//       OSP 외주/Packer 권한 반영 여부를 DB 로 검증할 수 없어 의미 등가 미확정 — 잠정 유지, 04 CN-1
//       확인필요(사용자 축) 인계(convert-core §2.6 이름재사용 단정 금지).
export const COMBO = {
  DIVISION: 'MyDivision',
  TO_SITE: 'ShipmentPlanToSite_SCP',
  FROM_SITE: 'ShipmentPlanPlantSite_SCP', // CN-1 해소 — 아래 CELL_FROM_SITE 주석 참조
  // ── 그리드 셀 콤보(From/To Site) — 신규행 편집·복제값 표시용 dataMap 공급원 ──
  //   두 콤보 모두 `CODE=SCM_SITE_ID` / `NAME=SITE_DESCRIPTION` 이라, 셀에는 **코드가 저장되고
  //   화면에는 설명이 보인다**. 저장 payload(`P_FROM_SITE`/`P_TO_SITE`)가 site_id 를 요구하므로
  //   이 대응이 성립해야 복제·저장이 동시에 맞는다(dataMap 없으면 코드가 날것으로 보인다).
  //
  //   **CELL_FROM_SITE 는 조회조건과 같은 `ShipmentPlanPlantSite_SCP` 다(CN-1 해소, 측정 근거).**
  //   AS-IS 는 `Data.UserPlantSiteByDivisionOspPack`(OSP 팩, C# 전용 메서드라 CMBO 미등록)를 쓴다.
  //   자매 SSP0200 은 셀 From Site 에 `PlantSiteByDivisionEEOperation_SCP` 를 쓰지만 그 SQL 은
  //   `NOT EXISTS(... OPERATION_GROUP='P' AND OSP_YN='Y')` 로 **OSP 패커 사이트를 배제**한다 —
  //   SSP0201 은 Packer 화면이라 정반대다. ora.py 실측(2026-10-13): SSP0201 이 실제로 쓰는
  //   From Site 12종 중 `PlantSiteByDivisionEEOperation_SCP` 커버리지 **0/12**,
  //   `ShipmentPlanPlantSite_SCP` **12/12**. 자매 값을 베끼면 전 행이 매칭 실패한다.
  CELL_FROM_SITE: 'ShipmentPlanPlantSite_SCP',
  //   셀 To Site 는 조회조건(`ShipmentPlanToSite_SCP`)과 **다른 SQL_ID** 다 — AS-IS
  //   `ToSiteByDivisionEEForSSP`(cs:2478) 의 TO-BE 등가(design 03 §1.3-B).
  CELL_TO_SITE: 'ToSiteByDivisionEEForSSP_SCP',
  //   셀 End Customer — 신규행 div40 필수 편집셀. per-row 재조회(div/toSite/item + 상수 param5='P').
  //   AS-IS setEndCustomer(div,toSite,item,fromSite,'P')(cs:5743) 의 TO-BE 등가.
  //   메타 cascade(PARAM10='D')로는 상수 'P' 를 못 실어(ATTRIBUTE2 는 행컬럼 바인드 전용) FE 가 직접
  //   행별로 조회해 dataMap 을 교체한다(From/To Site 와 같은 FE dataMap 처방, 단 per-row 스왑).
  //   콤보 바인드는 @divisionId/@scmSiteId/@itemId/@param5 — fromSite 는 TO-BE 콤보 바인드가 아니다
  //   (05_runtime-parity §콤보 ora.py 실측, SSP0200 과 동일 콤보·바인드. SSP0200 은 param5='' 비-packer,
  //   SSP0201 은 param5='P' packer 분기).
  CELL_END_CUSTOMER: 'EndCustomerByItemForSSP_SCP',
  // 요청정보 Change Reason — 그리드 셀 콤보(META_COMBO.CHANGE_REASON_CODE)와 같은 SQL_ID 다.
  //   다만 요청정보는 화면이 직접 호출하므로 @lookupType/@mnuId 를 **명시 전달**해야 한다(LOOKUP 주석).
  CHANGE_REASON: 'CHANGE_REASON_CODE_ALL',
  // 요청정보 Requestor Dept — AS-IS 는 `UserInfoContext["Dept_ID"]/["Dept_Name"]`(cs:521~526)를 쓰는데
  //   TO-BE UserSession 에는 부서 필드가 없다(groupId/langCd/userId/userEngNm/userNm/div/menus 뿐).
  //   -> 로그인 사용자 부서를 주는 기등록 콤보로 보완한다(자매 SSP0200 과 동일 축).
  //   `SalesPlanUserDept` = SELECT DEPT_ID CODE, DEPT_ID NAME FROM SCM_ADM_USER_M WHERE USER_ID=@sesUserId
  //   (ora.py 본문 실측 2026-10-13, USE_YN='Y'). @sesUserId 는 BE 주입이라 화면은 파라미터를 싣지 않는다.
  REQUESTOR_DEPT: 'SalesPlanUserDept',
  // 부서ID -> 부서명. 본문 WHERE 가 `DEPT_ID LIKE '%'||@deptId||'%' OR DEPT_NAME_KO LIKE …` OR 체인이라
  //   과다 매칭된다 — 호출부가 CODE 완전일치로 좁힌다. @param1=langCd 로 KO/EN/CN 분기.
  DEPT_NAME: 'Dept',
} as const;

export const LOOKUP = {
  CHANGE_REQ_TYPE: 'CHANGE_REQ_TYPE', // Plan Type: P/C/N/A (ALL 없음, 기본 C)
  SHIPMENT_STATUS: 'SHIPMENT_STATUS', // Status: P/C/D/R (P 제외 + ALL 선두, 기본 ALL)
  SALES_TYPE_CODE: 'SALES_TYPE_CODE', // 그리드 FCST_TYPE 셀콤보
  // `CHANGE_REASON_CODE_ALL`(CMBO_SQL) 의 @lookupType 인자값. 본문이
  //   `WHERE A.LOOKUP_TYPE = @lookupType` 라 **미전달 시 BE 가 '' 로 치환**해 후보가 더미 '-' 1행만
  //   남는다(ora.py 실측 2026-10-13: @lookupType='CHANGE_REASON_CODE' 8행 vs '' 1행).
  //   Change Reason 은 요청완료 필수 4항목이라 이 값을 빠뜨리면 완료가 불가능해진다.
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE',
  // 출하일 상·하한 기준일수(dDay). MASTER 헤더가 SEGMENT1='CODE'/SEGMENT2='NAME' 라 응답 키는
  //   CODE/NAME 이고 AS-IS `dtBaseDay.Rows[0][1]`(= NAME) 이 기준일수다(ora.py 실측 CODE='D'/NAME='-56').
  CHANGE_REQ_DAY: 'CHANGE_REQ_DAY',
  // 저장 시 출하일 허용범위 기준(AS-IS SHIPMENT_PERIOD_DAY inner-table, cs:347/490). CODE/NAME 2행:
  //   '1D+'/NAME=상한일수(today+N), '2D-'/NAME=하한일수(today-N). ora.py·BE log 실측 +56 / -30.
  //   완료 경로의 CHANGE_REQ_DAY(-56)와 다른 축이다 — 저장은 이 범위(today-30~+56)로 막는다(MSG00194).
  SHIPMENT_PERIOD_DAY: 'SHIPMENT_PERIOD_DAY',
} as const;

// 조회조건 sentinel/기본값 (design 02 §4)
export const ALL = 'ALL';
export const FIXED_DIVISION = '40'; // R3: Division "40" 고정 + disabled
export const DEFAULT_PLAN_TYPE = 'C'; // Plan Type 기본 Confirm (SelectedIndex=1)
export const DEFAULT_STATUS = ALL; // Status 기본 ALL
export const PLAN_TYPE_PLAN = 'P'; // Plan 분기(from=오늘+9D 재계산)
export const PERIOD_OFFSET_DAY = '30'; // Period 기본 30일 (SCM0001_GET_SCP_DAY_PERIOD p_offset_day)
export const PLAN_TYPE_P_FROM_OFFSET = 9; // Plan Type='P' 시 from = 오늘+9D (design 02 §3 cascade#2)
// Period 기본값 SP 호출 버튼코드 — 공용 API SCM0001_SCP_DAY_PERIOD_GET(→PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD)
//   을 /SSP0201/main/GET_SCP_DAY_PERIOD/call-proc 로 경유한다. 버튼맵/권한은 32_register_day_period_btn_auth.sql
//   에 등록(화면 버튼 아님, 백그라운드 기간 산출 — 자매 SSP0200 05_register.sql:156 동일). dayjs 근사 금지(design 02 §5.4).
export const BTN_DAY_PERIOD = 'GET_SCP_DAY_PERIOD' as const;

// ====================================================================================
// 그리드 셀 콤보 (design 03 §1.3)
// ====================================================================================
// A. 메타 구동 콤보(FPComboBox, admin 메타 정상 등록 — 자동 배선). CELL_COMBO_DATA_TYPE 로 DataGrid 자동.
//    **참조용 상수다(코드 소비처 없음)** — 후보는 DataGrid 가 DB 메타로 직접 가져온다. 화면에서
//    `useTabComboQueries` 로 다시 부르지 마라: 이 값들은 comboId 뿐이라 @lookupType/@mnuId 같은
//    바인드가 빠지고, 실제로 그렇게 쓴 Change Reason 이 더미 1행만 받았다(2026-10-13 교정).
//    화면이 직접 호출해야 하는 콤보는 위 `COMBO` 에 바인드 주석과 함께 둔다.
export const META_COMBO = {
  SHIPMENT_STATUS: 'LookupCommon', // PARAM1=SHIPMENT_STATUS (lookup)
  FCST_TYPE: 'LookupCommon', // PARAM1=SALES_TYPE_CODE (lookup)
  INCOTERMS: 'Incoterms', // CMBO_SQL
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE_ALL', // CMBO_SQL
} as const;

// B. 코드 구동 cascade 셀 콤보(AS-IS SetCellTypeCombo — per-row 재조회). 콤보 SQL_ID 는 등록됐으나
//    SCM_MST_SHEET_COLUMNS 의 이 컬럼들은 CELL_COMBO_DATA_TYPE/ATTRIBUTE2/10 이 공란(미이관, design 03 §6).
//    per-row cascade 는 공용 DataGrid 가 admin 메타(PARAM10='D' + ATTRIBUTE2 부모바인드)로만 구동한다
//    (useRowParamCombos — FE 전용 cascade 경로 없음). 그래서 05_register.sql 메타 등록이 유일한 재현 수단.
//    iter-2(GAP-02): 의미 명확·자기완결 2종만 메타 등록 완료(ora.py exec 재조회 확인):
//      - TRANSPORT_MODE      : `TransMode`(CN-2 확정 — ora.py 실측 3종 중 @div/@from/@to/@incoterms +
//                              BOD 상세 반환형이 AS-IS FindData_BOD 파생과 등가. TransModeCode=정적 lookup,
//                              SSP16LocTransMode_SCP=패킹CODE형 → 배제).
//      - TO_SITE_SHIPTO_CODE : `ShipToCodeByDivision`(@div/@scmSiteId=TO_SITE).
//    보류 4종(04 리포트 확인필요): DIVISION_ID(전량 잠금—실익 없음), FROM_SITE_DESCRIPTION(CN-1 OSP팩
//      SQL_ID 미확정), TO_SITE_DESCRIPTION(콤보 CODE=site_id vs 컬럼=description 저장규약+TO_SITE 동기),
//      END_CUSTOMER(콤보 @param5 상수 'P' 를 행-파라미터 메타로 전달 불가).
export const CASCADE_CELL_COMBO = {
  DIVISION_ID: 'MyDivision', // 고정 목록(EE 제외), 재조회 아님, 전량 잠금(메타 보류)
  FROM_SITE_DESCRIPTION: COMBO.FROM_SITE, // division (CN-1 미확정 — 메타 보류)
  TO_SITE_DESCRIPTION: 'ToSiteByDivisionEEForSSP_SCP', // division (code/desc 규약 — 메타 보류)
  TO_SITE_SHIPTO_CODE: 'ShipToCodeByDivision', // division + toSite (메타 등록됨 PARAM10='D')
  TRANSPORT_MODE: 'TransMode', // division+fromSite+toSite+incoterms (CN-2 확정, 메타 등록됨 PARAM10='D')
  END_CUSTOMER: 'EndCustomerByItemForSSP_SCP', // division+toSite+item+fromSite+'P'(상수 — 메타 보류)
} as const;

// ====================================================================================
// 편집 축 (design 03 §3.1) — **열 잠금의 원천은 메타 INPUT_TP_CD** 다(표준 COL-02 / hook #130).
//   종전 EXISTING_ROW_EDIT_COLUMNS / NEW_ROW_EDIT_COLUMNS 컬럼명 화이트리스트(`new Set([컬럼명])`)는
//   제거하고 design/31_fix_main_input-tp-cd_standard-parity.sql 로 메타에 이관했다(IM/IO/M/O).
//   공용 DataGrid 가 GridUtils.isEditableCell 로 열 축을, editLock.ts 의 isRowEditable 이 행 축을 판정한다
//   (자매 SSP0200 과 동일 구조). 선행조건: 그 SQL 적용 — 미적용이면 메타 전건 'S'라 편집 전면 잠김.
// ====================================================================================

// 라벨 `*` 필수 컬럼(메인, INPUT_TP_CD 전건 'S'라 라벨 매핑으로 필수검증 — design 03 §1.1/§4.4).
export const REQUIRED_MAIN_COLUMNS = [
  'ITEM_ID',
  'PROJECT_CODE',
  'END_CUSTOMER',
  'FCST_TYPE',
  'FROM_SITE_DESCRIPTION',
  'TO_SITE_DESCRIPTION',
  'SHIPMENT_CONFIRM_QTY',
  'SHIPMENT_DATE',
  'TRANSPORT_MODE',
] as const;

// 팝업(이미지셀) 컬럼 — 더블클릭 팝업으로만 값 입력(인라인 편집 취소, nscm-patterns §5-16).
export const ITEM_POPUP_COLUMN = 'ITEM_ID'; // SSP0026_ItembyDivisionPopup
export const PROJECT_POPUP_COLUMN = 'PROJECT_CODE'; // SCM0002_ProjectbyDivisionPopup

// EDIT_MAIN 파생마다 재계산되는 변경검지 플래그(design 03 §3.2). 저장 대상 판정 근거.
export const EDIT_MAIN_FLAG = 'EDIT_MAIN';
// Insert(복사) 경로로 생성된 신규행 표식 — **UI 편집 축 전용**, 저장 payload 에 실리지 않는다.
//   AS-IS 비대칭 재현용: Insert 복사행은 END_CUSTOMER 를 잠그고(InsertRow cs:2523 LockRange),
//   New 버튼 빈 행은 편집 허용(BtnNew cs:3007-3014). 메타(INPUT_TP_CD)는 New/Insert 를 구분 못 해
//   (둘 다 CRUD_TYPE='I') 화면단에서만 가를 수 있다 — buildCopiedRow 만 이 표식을 심는다.
//   CRUD_TYPE(저장 판정 축, convert-core §2.4)과 다른 축이라 isNew 대체 필드가 아니다.
export const INSERT_COPIED_FLAG = 'INSERT_COPIED';
// SO No 그룹 전파 키(같은 ERP_SO_NO 전행에 동일 변경 복제, design 03 §3.2).
export const SO_GROUP_KEY = 'ERP_SO_NO';

// 동적 컬럼/헤더 토글 대상 (design 03 §2 #1) — changeType='P' 면 숨김.
//   **CONFIRM_ID 만이다.** AS-IS cs:567~570 은 'P' 에서 ERP_SO_NO·CONFIRM_ID 둘 다 Width=0 으로
//   접지만, else 분기에서 되살리는 줄이 ERP_SO_NO 쪽은 **주석**이다(cs:569, "20211109 ERP_SO_NO
//   컬럼 안보이게 수정") — 즉 메인 ERP_SO_NO 는 어느 분기에서도 보이지 않는다. 메타도 그에 맞춰
//   VISIBLE_FLAG='N'/W=0 으로 복원했다(24_fix_main_visible_asis_parity.sql) → 컬럼셋에 아예 없으므로
//   여기 넣어 두면 죽은 분기다. 주의: **서브 그리드의 ERP_SO_NO 는 반대로 표시가 정상**이다
//   (AS-IS cs:649 `siSub...ERP_SO_NO.Visible = true`) — buildSubColumns 가 'P' 때만 숨긴다.
export const PLAN_TOGGLE_COLUMNS = ['CONFIRM_ID'];

// 화면이 dataMap 을 주입하는 셀 콤보 2열(useShipmentChangeRequestCellCombos).
//   값=site_id(코드) / 표시=SITE_DESCRIPTION. 복제·저장은 코드, 화면은 설명이 되게 하는 축이다.
//   주의: 주입 시 `cellCboDataTp` 를 반드시 비운다 — 비우지 않으면 공용 DataGrid 의 자동 콤보가
//   같은 컬럼을 덮어써 다른 후보(또는 빈 목록)가 붙는다.
export const CELL_COMBO_COLUMNS = {
  FROM_SITE_DESCRIPTION: 'FROM_SITE_DESCRIPTION',
  TO_SITE_DESCRIPTION: 'TO_SITE_DESCRIPTION',
  // END_CUSTOMER 도 FE dataMap 주입이다 — From/To 는 division 고정이라 전행 공용이지만 END_CUSTOMER 는
  //   행별(item/toSite 종속)이라 포커스 행마다 재조회해 같은 dataMap 슬롯을 교체한다(SSP0200 미러).
  END_CUSTOMER: 'END_CUSTOMER',
} as const;

// EndCustomer 후보가 0행일 때 AS-IS 가 합성하는 단일 행(자매 SSP0200 END_CUSTOMER_EMPTY_CODE 동일).
//   자동선택(1건 확정)과는 별개 축이다 — '-' 합성은 드롭다운 표시용이고 셀 자동대입은 하지 않는다.
export const END_CUSTOMER_EMPTY_CODE = '-';

// ====================================================================================
// spdSub "Change Request" 런타임 파생 (AS-IS InitSpread(shtSub) cs:597~653 실측)
// ====================================================================================
export const SUB_COLUMN = {
  CHK: 'CHK', // 헤더 체크박스(cs:606~613) + MergePolicy.None(cs:615~617)
  REMARKS: 'REMARKS', // "화면에서만 제거함" 런타임 폭 0 (cs:622)
  ERP_SO_NO: 'ERP_SO_NO', // changeType='P' 면 숨김 (cs:627) / 그 외 표시 (cs:649)
} as const;

// 2단 헤더 그룹라벨 — 메타 SMALL_CLASS_LABEL_NAME 기본값이 else 분기(Confirmed/Change)다.
//   changeType='P' 일 때만 Plan/Confirm 으로 교체한다(cs:629~630 vs cs:651~652, 각 span 7열).
//   앵커 컬럼: 비NEW군 선두 LT_DAY / NEW군 선두 NEW_LT_DAY.
export const SUB_GROUP_LABEL = {
  DEFAULT: { confirmed: 'Confirmed', change: 'Change' }, // changeType != 'P' (메타 SCLS 일치)
  PLAN: { confirmed: 'Plan', change: 'Confirm' }, // changeType == 'P'
} as const;
export const DIVISION_EXCLUSIVE = {
  END_CUSTOMER: 'END_CUSTOMER', // div 40/EE 노출
  PROJECT_CODE: 'PROJECT_CODE', // div!=40/EE 노출
  PROJECT_NAME: 'PROJECT_NAME',
} as const;
export const EE_DIVISION = 'EE';

// ====================================================================================
// TO-BE MSG 코드 (SCM_ADM_MSG_M 문구 역조회 — Hook #114. AS-IS 번호를 그대로 쓰지 않는다).
//   AS-IS 원 MSG 번호는 주석 병기(design 01 §2 R8/R14). 미검증 코드는 defaultValue fallback 유지.
// ====================================================================================
export const MSG = {
  REQUIRED_DIVISION: 'MSG00097', // 조회 필수(Division) — "Division 을 선택하세요."
  NO_CHANGES: 'MSG00004', // 변경 없음 — bolChang_Flag==false ("수정한 내용이 없습니다", AS-IS MSG00133 → TO-BE MSG00004)
  SAVE_CONFIRM: 'MSG00001', // 저장 확인 다이얼로그 "Would you like to save it?" (AS-IS 번호 MSG00012). iter-3 GAP-11: TO-BE MSG00012='Maximum of 10 tabs allowed.' 오매핑을 실측(EN/KO.json) 정문구 MSG00001 로 수정
  SAVE_SUCCESS: 'MSG00672', // 저장 성공(건수)
  SAVE_FAIL: 'MSG00003', // 저장 실패
  // R8 ERP 중단기간 차단 — **TO-BE 등가 미등록**(역조회 0건). 번호를 다른 코드로 빌리면 그 코드가
  //   등록되는 순간 엉뚱한 문구가 뜬다(#114) → AS-IS 번호 유지 + 영문 fallback. 자매 SSP0200 도 동일.
  ERP_BLOCK: 'MSG01202',
  // AS-IS MSG00174 -> 등가 MSG01189 'You have already requested to change your shipment plan'
  //   (SHIPMENT_STATUS='R' 저장 차단. MSG00174 는 TO-BE 미등록 — ora.py 실측 0행)
  ALREADY_COMPLETE: 'MSG01189',
  // AS-IS MSG00195('취소하시겠습니까?') -> 등가 MSG00684 'Are you sure you want to cancel?'
  //   MSG00195 는 TO-BE 미등록이라 종전엔 defaultValue 가 그대로 떠 `__Cancel this request?` 가
  //   보였다(사용자 신고 2026-10-13). 등가 2후보(MSG00684/MSG01459, EN 동일) 중 먼저 등록된 쪽을
  //   쓴다 — 자매 SSP0200 과 같은 선택이다.
  CANCEL_CONFIRM: 'MSG00684',
  // ── 요청완료 수량·출하일 검증 3종 ──
  //   종전엔 AS-IS 번호(MSG00202/00201/00194)를 그대로 썼는데 **TO-BE 에 전부 미등록**이라
  //   (ora.py 실측 2026-10-13 KO/EN 0행) alert 가 defaultValue `_Invalid.` 로만 떴다 —
  //   사용자가 왜 막혔는지 알 수 없었다(사용자 신고 2026-10-13). Hook #114 대로 **문구 역조회**로
  //   TO-BE 등가 코드에 재매핑한다(자매 SSP0200 과 동일 번호, KO/EN 등록 확인).
  QTY_ZERO: 'MSG01213', // AS-IS MSG00202 등가 — 'Enter a number greater than 0.'
  // AS-IS MSG00201 등가 — 'Current D + {0} days can not be requested. Please delete and request again.'
  DATE_UNDER_BASE: 'MSG01212',
  // AS-IS MSG00194 등가 — 'Change requests are possible from the current D + {0} ship date.'
  DATE_OVER_MAX: 'MSG01206',
  // AS-IS MSG00359('변경요청은 Shipment Date 조회 구간에서 가능합니다') -> 등가 MSG01353
  //   (재번호 동일 문구 'Change request can be made within the inquiry date.', placeholder 없음).
  //   저장 시 출하일이 조회구간 Period[from,to] 밖이면 차단(AS-IS SSP_Main_Validation
  //   cs:3173-3178/3383-3388 = 07_validation-audit C7). Period 는 SCM0001_GET_SCP_DAY_PERIOD 산출값.
  SHIP_DATE_OUT_OF_PERIOD: 'MSG01353',
  // 날짜로 해석 안 되는 NEW_SHIPMENT_DATE — AS-IS 는 `Convert.ToDateTime` 예외로 죽는 자리다.
  //   TO-BE 는 조용히 skip 하지 않고 명시 차단한다(자매 SSP0200 선례).
  INVALID_DATE_FORMAT: 'MSG01081', // 'This is not a valid date format. {0}'
  // AS-IS MSG00189 -> 등가 MSG01202 'In ERP, DO is created and can not request change. …'
  //   (erp_status='C' = DO 생성됨 변경 차단. MSG00189 는 TO-BE 미등록)
  ERP_STATUS_LOCKED: 'MSG01202',
  // 아래 2종은 **TO-BE 등가 미등록**(역조회 0건) — AS-IS 번호 유지 + 영문 fallback. SSP0200 도 동일.
  REASON_CODE_REQUIRED: 'MSG01291', // Reason Detail 입력 전 Reason Code 필수 (AS-IS MSG00287 → TO-BE MSG01291)
  FROM_SITE_REQUIRED: 'MSG01126', // To Site/Incoterms 선행 필수(From Site 등)
  // AS-IS MSG00293(TransMode 후보 없음) -> 근사 MSG01296 'BOD (Trans mode, Incoterms) information
  //   corresponding to Div, From Site, To Site is invalid.' MSG00293 전용 등가는 TO-BE 미등록이라
  //   뜻이 가장 가까운 등록 문구를 쓴다(SSP0200 과 같은 근사 — 04 확인필요 유지).
  TRANS_MODE_UNAVAILABLE: 'MSG01296',
  // 필수값 누락 — **어느 항목인지 알려주는** MSG00614 'The {0} value is required.'(KO '{0} 값은 필수
  //   입력입니다.')를 쓴다. AS-IS 번호 MSG00002 는 TO-BE 에서 'Saved successfully.' 로 뜻이 달라
  //   금지(iter-3 GAP-11). 종전 MSG00013('Please enter the required fields.')은 `{0}` 자리가 없어
  //   호출부가 넘긴 항목명이 **버려졌다** — 어느 칸이 비었는지 알 수 없었다.
  //   주의: `{0}` 치환은 `.replace('{0}', …)` 수동이다(i18next 보간자는 `{{ }}`).
  REQUIRED_FIELD: 'MSG00614',
  // AS-IS MSG00286('{0}Row There is a Shipment not change. Unable To enter Change_Reason') -> 등가 MSG01290
  //   (재번호 동일 문구, ora.py 실측). 변경 없이 Change_Reason 만 입력된 행 저장 차단(AS-IS
  //   SSP_Main_Validation cs:3265-3355 = 07_validation-audit C8). `{0}` 은 1-based 행번호 —
  //   i18next 보간자가 아니라 수동 replace 다.
  REASON_WITHOUT_CHANGE: 'MSG01290',
  // ── 신규행 저장(SAVE_SHIPMENT_CONFIRM_NEW) 응답 RESULT_CODE 분기 (AS-IS L994~1010) ──
  //   'N' AS-IS MSG00261 "Model 조회 후 입력하여 주십시오" -> SCM_ADM_MSG_M 문구 역조회
  //       (convert-core §4.1). TO-BE 에 MSG00261 번호는 부재하고 MSG01269 가 동치 문구다.
  NEW_MODEL_REQUIRED: 'MSG01269', // "Please check the model before entering."
  //   'F' AS-IS MSG00328 — TO-BE 에 **같은 번호로 같은 문구**가 실재(실측):
  //       "The sales price has not been entered. Please enter the sales price before proceeding."
  NEW_PRICE_REQUIRED: 'MSG00328',
  // ── 변경요청 완료(btnChangeRe2) ──
  //   AS-IS MSG00173('확정 출하 계획 변경 요청이 완료되었습니다') -> TO-BE 등가 MSG01188
  //   'Your confirmed shipment plan change request has been completed.'(EN 실측, 자매 SSP0200 동일 번호).
  REQUEST_COMPLETED: 'MSG01188',
  // 완료 SP 결과 커서의 실패 사유 분기다(AS-IS cs:2305~2320).
  //   APPROVER_UNAVAILABLE: 2026-11-17 MSG01317→MSG01500 교체. MSG01317 의 DB 문구와 화면 fallback
  //   ("No model owner is registered...")이 불일치해, 그 fallback 문구를 MSG01500 으로 신규 등록
  //   (33_register_msg01500_... / QA 등록분). 이제 DB 문구 = fallback 이라 KO 세션에서도 정합.
  //   (자매 SSP0200 UNAUTHORIZED_APPROVER 는 MSG01317 유지 — 그 fallback 은 MSG01317 과 일치.)
  APPROVER_UNAVAILABLE: 'MSG01500', // 'No model owner is registered...' — 모델 담당자 미등록으로 승인자 지정 불가
  MODEL_PIC_MISMATCH: 'MSG01347', // 'UnModelPic'/'UnModelItem' — 서로 다른 PIC·Model 혼재(미등록 시 fallback)
} as const;

// ====================================================================================
// UI 라벨 코드 (SCM_ADM_MSG_M MSG_TP_CD='LBL' 문구 역조회). AS-IS 번호 그대로 쓰지 않는다(#114).
//   Division=LBL00001(표준), Search=LBL00112(표준). 등가 없으면 defaultValue fallback 유지.
// ====================================================================================
export const LBL = {
  DIVISION: 'LBL00001',
  FROM_SITE: 'LBL00022',
  TO_SITE: 'LBL00023',
  // Plan Type(cboChangeType) 라벨 — AS-IS `PlanType1.Visibility=Never`(Designer:810) 로 **렌더하지 않는다**.
  //   값은 store 에서 'C'(Confirm) 고정이다. 상수는 근거 추적용으로만 남긴다(사용처 0건).
  PLAN_TYPE: 'LBL00040',
  STATUS: 'LBL00014',
  SHIPMENT_DATE: 'LBL01115', // 자매 SSP0200 과 동일 코드(DB·번들 실측 'Shipment Date')
  // 조회조건 Model 필드 라벨 = "Model/Nickname"(사용자 지시 2026-10-07. 자매 SSP0015 400ceb57 선례).
  //   LBL00618 은 SCM_ADM_MSG_M(KO/EN/CN 전건 'Model/Nickname', USE_YN='Y') + public/locales 번들 양쪽
  //   실측 완료 — 신규 등록 불요. 종전 LBL00669('Model')에서 교체. 4자매 화면 동일 적용.
  //   라벨칸 폭 override 는 두지 않는다 — 상세 근거는 SSP0200 constants 의 동일 주석 참조.
  MODEL_NICKNAME: 'LBL00618',
  // SO No(txtSoNo) 라벨 — AS-IS `lblSONo.Visibility=Never`(Designer:824, `lblSONo.Control=txtSoNo` 로
  //   입력칸까지 감싼 항목이라 필드 전체 비노출) → **렌더하지 않는다**. 자매 SSP0200 은 노출한다.
  //   store `erpSoNo` 는 payload 계약상 유지하고 항상 ''(전체) 로 나간다. 상수는 근거 추적용(사용처 0건).
  SO_NO: 'LBL01111',
  CONFIRM_ID: 'LBL01063',
  SEARCH: 'LBL00112',
  CANCEL: 'LBL00107',
  REQUEST_COMPLETE: 'LBL01105',
  TITLE: 'LBL01125',
  // 요청정보 섹션 헤더 — AS-IS `usrLabel2.Text = "Request Info"`(Designer:1351, Location 12,12).
  //   LBL01107: DB·번들 실측 등록분 — 자매 SSP0200 과 동일 코드.
  REQUEST_INFO: 'LBL01107',
  REQUESTOR: 'LBL01108',
  DEPT_NAME: 'LBL01071',
  APPROVAL: 'LBL01052',
  CHANGE_REASON: 'LBL01060',
  REASON_DETAIL: 'LBL01104',
} as const;

// ====================================================================================
// 화면 전용 문구 키 — AS-IS 에 대응 MSG/LBL 코드가 없는 자리(hook #114: 번호를 빌리면 그 코드가
//   등록되는 순간 엉뚱한 문구가 뜬다). `_` 접두 미등록 키라 항상 defaultValue 로 표시된다.
// ====================================================================================
export const SCREEN_TEXT = {
  // New 버튼 캡션 — AS-IS `btnNew.Text="New"`(Designer 실측, 로케일 무관 고정 영문)이라 i18n LBL01028
  //   (KO='신규')을 쓰지 않는다. 자매 SSP0200 과 동일 축.
  NEW: '_ssp0201.new',
  // Delete 가 저장 전 신규행만 지운다는 안내. 선택행에 신규행이 하나도 없을 때만 띄운다 —
  //   조용히 무동작이면 "버튼이 고장났다" 로 읽힌다. AS-IS 에 대응 문구가 없다(DeleteButton 빈 본문).
  DELETE_INSERT_ONLY: '_ssp0201.deleteInsertOnly',
  // 메인 그리드 SHIPMENT_CONFIRM_QTY 동적 헤더 — AS-IS cs:562/574 가 `MessageHelper.GetTerm()` 으로
  //   "Shipment Plan Qty"(changeType='P') / "Shipment Confirm Qty"(그 외)를 넣는다. TO-BE 는 두 문구가
  //   `SCM_ADM_MSG_M` 0행이라(자매 SSP0200 R-70 D3/D6 실측) MSG/LBL 코드를 빌리지 않고 화면 전용 키로 둔다.
  //   `*` 는 메타 COLUMN_LABEL_NAME('Shipment Qty*')의 필수 표식을 승계한 것이다(REQUIRED_MAIN_COLUMNS 포함).
  QTY_HEADER_PLAN: '_ssp0201.qtyHeaderPlan',
  QTY_HEADER_CONFIRM: '_ssp0201.qtyHeaderConfirm',
  // spdSub 2단 헤더 changeType='P' 분기 그룹라벨(cs:629~630 "Plan"/"Confirm"). 메타 기본값
  //   Confirmed/Change 는 SCLS 에 실재하지만 Plan/Confirm 은 메타에 없어 FE 가 공급한다.
  //   'Confirmed'/'Change'/'Plan'/'Confirm' 4문구 모두 SCM_ADM_MSG_M 0행이라 화면 전용 키로 둔다.
  SUB_GROUP_PLAN: '_ssp0201.subGroupPlan',
  SUB_GROUP_CONFIRM: '_ssp0201.subGroupConfirm',
  // ERP 중단기간 게이트가 판정 불가('unknown')일 때의 고지 — 조용히 통과시키지 않는다(V-13 정직 판정,
  //   SSP0200 미러). AS-IS 에 대응 문구가 없다 — MSG 코드를 빌리면 그 코드가 등록되는 순간 엉뚱한
  //   문구가 뜬다(hook #114). 콤보 SQL 자체가 실패하는 상태(SEGMENT2 시각포함 ↔ TO_DATE 마스크
  //   불일치, GAP-ERP-DATEFMT)라 'unknown'을 차단으로 올리면 저장이 영구 불가가 된다 → 고지 후 진행.
  ERP_BLOCK_UNKNOWN: '_ssp0201.erpBlockUnknown',
} as const;
