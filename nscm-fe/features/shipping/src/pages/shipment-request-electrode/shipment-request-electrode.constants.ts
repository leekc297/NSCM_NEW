export const MENU_ID = 'SSP0022' as const;
export type MENU_ID = typeof MENU_ID;

// 사용자 노출 라벨 코드(SCM_ADM_MSG_M MSG_TP_CD='LBL') — DB 역조회로 확정한 코드만 등재.
export const LBL = {
  DIV: 'LBL00641', // AS-IS lblCombo1.Text "Division*"(design 02 §4.5) — 기존 LBL00001("Div") 교정
  COMPANY: 'LBL00047',
  FROM_SITE: 'LBL00022', // clbPlantSite 라벨 — "From Site"(사용자 지시 2026-10-22, SSP0023 동일). 기존 LBL00005("Plant Site")
  BUCKET: 'LBL00710', // cboBucketType "Bucket"
  PLAN_DATE: 'LBL00039',
  PERIOD: 'LBL00013',
  CELL_TYPE: 'LBL00046',
  // Material / Model/Nickname — SSP0023 동일 처리(사용자 지시 2026-10-22): 둘 다 MaterialByDivisionModal 팝업,
  //   Model+NickName 은 'Model/Nickname' 한 칸으로 통합(LBL00618). 상단 standalone Nick Name 제거.
  MATERIAL: 'LBL00021', // txtItemId "Material"(+팝업 → itemId)
  MODEL: 'LBL00618', // txtModelId "Model/Nickname"(+팝업 → modelId + nickName)
  NICK_NAME: 'LBL00767', // 2차 DetailBar Nick Name
  LOT_ID: 'LBL01090', // 2차 DetailBar Lot ID(재고상세 탭 전용)
  REQUESTOR: 'LBL01108', // 2차 DetailBar Requestor(요청상세 탭 전용, +UserInfoPopup) — design 02 §1 #20
  SHIPMENT_ETA: 'LBL01116', // 2차 DetailBar Shipment ETA(drpPeriod2 날짜범위) — DB 실측 LBL01116
  SEARCH: 'LBL00112', // 상단 SearchArea 검색
  SEARCH_GRID: 'LBL00664', // 2차 DetailBar 검색(하단) — SSP0023 동일
  MEASURE: 'LBL00310', // btnMeasure "Measure" 설정 버튼(SSP0026 동일)
  EXCEL_FORM: 'LBL00762', // formDown "Excel Form" 양식 다운로드(SSP0026 동일)
  EXCEL_UPLOAD: 'LBL00346', // btnExcelUpload "Excel Upload"(SSP0026 동일)
  // 하단 탭 이름 — AS-IS 는 시트명 리터럴(SpdSheet.shtStockDetail/shtRequestDetail)을 탭 캡션으로 쓴다.
  //   SCM_ADM_MSG_M 에 해당 LBL 미등록(실측 0건) → 합성 키 + fallback 리터럴(PAST_PERIOD 패턴 동일).
  TAB_STOCK_DETAIL: 'LBL_SSP0022_STOCK_DETAIL',
  TAB_REQUEST_DETAIL: 'LBL_SSP0022_REQUEST_DETAIL',
  // UOM Type(BOH 3-radio) + 체크박스 6종 — AS-IS Designer 라벨 실측, SSP0023 코드 재사용(DB 실측 동일).
  UOM_TYPE: 'LBL01127', // usrLabel1 "UOM Type"(BOH 3-radio 그룹 라벨)
  BOH_UOM: 'LBL01126', // rdButton1 "UOM"
  BOH_CELL: 'LBL01059', // rdButton2 "Cell"
  BOH_PCM: 'LBL01099', // rdButton3 "Pancake m"
  SUM: 'LBL00687', // chkSum "Sum"
  PAST_PERIOD: 'LBL_SSP0022_PAST_PERIOD', // chkPastPeriod "Including Past Period"(DB 미매칭 — defaultValue fallback)
  MY_MODEL: 'LBL01093', // chkMyModel "My Model"
  PART_LEADER: 'LBL01101', // chkPartLeader "Part Leader"
  TEAM_LEADER: 'LBL01124', // chkTeamLeader "Team Leader"
  DELEGATE_MODEL: 'LBL01070', // chkDelegateModel "Delegatee Model"
} as const;

// AS-IS GSCM.SSP.Plan.UIL SSP0022_ShipmentRequestElectrode (4시트: spdMain 피벗 + spdDetail 2탭(요청상세/재고상세)
//   + spdSub 엑셀전용). 설계 근거: .atlas/gscm-design/SSP0022/design/00_checklist.md ~ 03_grid-columns.md.
//   - GET  SP (4): PKG_SSP0022.P_SSP0022_GET_SHIPMENT_PSI / P_SSP0022_GET_REQUEST_DETAIL /
//     P_SSP0022_GET_STOCK_DETAIL / P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
//   - SAVE SP    : PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST (spdMain/spdDetail 공용, 호출 컨텍스트로 분기)
//   - 보조 SP    : P_SSP0022_GET_SHEET_CALENDAR_3SPAN(동적 pivot 헤더) / P_SSP0022_GET_ITEM_POPUP(BOD/Item 팝업)
//     / P_SSP0022_GET_BOD_ITEM_VALID_CHECK(현재 호출부 비활성 — dead code, 신규 구현 보류)
//   - 콤보 SP    : Bucket 은 PKG_DM0003 SP 미이식 — lookup 'BUCKET_TYPE_CODE' 콤보 재사용(COMBO.BUCKET) / PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST(Edit 권한체크)
//   - SP 미배포(design 00 §0 / goal.md): PKG_SSP0022·PKG_SSP0002 all_objects 0건
//     → 런타임 조회/저장/권한체크 실행체인 미완(convert-sp 후속). FE 배선만 완비한다. Bucket 은 lookup 콤보로 배선 완료.
export enum SHEETS {
  MAIN = 'main', // spdMain — Shipment Request(Electrode), pivot 34칼럼 + 동적 X_/Y_/Z_×D_/W_/M_
  REQUEST_DETAIL = 'requestDetail', // spdDetail.shtRequestDetail — 요청상세, 31칼럼, 유일한 편집 대상
  STOCK_DETAIL = 'stockDetail', // spdDetail.shtStockDetail — 재고상세, 29칼럼, 읽기전용
  REQUEST_DETAIL_EXCEL = 'requestDetailExcel', // spdSub.shtRequestDetail_Excel — 엑셀 다운로드 전용, 9칼럼
  SPREAD_TITLE = 'spreadTitle', // P_SSP0022_GET_SHEET_CALENDAR_3SPAN — 동적 기간 헤더(3-span)
  BOD_ITEM_POPUP = 'bodItemPopup', // SSP0022_BodItemPopup 원천(P_SSP0022_GET_ITEM_POPUP)
}

// NSCM 단일 cursor 표준 'o_rc1'
export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  REQUEST_DETAIL: 'o_rc1',
  STOCK_DETAIL: 'o_rc1',
  REQUEST_DETAIL_EXCEL: 'o_rc1',
  SPREAD_TITLE: 'o_rc1',
  BOD_ITEM_POPUP: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// admin UI Category Setup(SCM_MST_SHEET_COLUMNS) SHEET_NAME — AS-IS SpdSheet 원본명 그대로(design 03 §1).
//   실측(ora.py, 2026-09-26): 4개 SHEET_NAME 103행 전건 배포 완료(34+31+29+9).
export const ADMIN_SHEET_NAME: Partial<Record<SHEETS, string>> = {
  [SHEETS.MAIN]: 'Shipment Request(Electrode)',
  [SHEETS.REQUEST_DETAIL]: 'Shipment Request Detail',
  [SHEETS.STOCK_DETAIL]: 'Stock Detail',
  [SHEETS.REQUEST_DETAIL_EXCEL]: 'Shipment Request Detail Excel',
};

// 하단 상세 그리드 합계(Sum) 대상 컬럼 — AS-IS InitSpreadFooterSum(cs:3597-3636) ColumnFooter SumIgnoreHidden.
//   Stock Detail = IWMS_QTY_UOM ~ TOTAL_QTY_PCM 수량 8컬럼(iStCol=IWMS_QTY_UOM, TOTAL_QTY_PCM 에서 break, cs:3604/3620).
//   Request Detail = SHIPMENT_QTY 단일(iStCol=SHIPMENT_QTY, +1 에서 break, cs:3609/3626). 모두 FPNumber 로 실측(SCM_MST_SHEET_COLUMNS).
export const STOCK_DETAIL_AGGREGATE_COLUMNS = [
  'IWMS_QTY_UOM',
  'IWMS_QTY_PCM',
  'GMES_QTY_UOM',
  'GMES_QTY_PCM',
  'OWMS_QTY_UOM',
  'OWMS_QTY_PCM',
  'TOTAL_QTY_UOM',
  'TOTAL_QTY_PCM',
] as const;
export const REQUEST_DETAIL_AGGREGATE_COLUMNS = ['SHIPMENT_QTY'] as const;

// Measure 정의(SCM_MST_SHEET_MEASURE, PROGRAM_ID=SSP0022, SHEET_NAME=ADMIN_SHEET_NAME.MAIN) — 10건 실측 배포됨.
//   design 03 §1.5 — R_SHIP_REQ_ETA 는 코드 특별분기(lock 범위·BackColor) 대상.
export const MEASURE = {
  SCP_PROD_PLAN: 'R_SCP_PROD_PLAN',
  SCP_SHIP_PLAN_ETA: 'R_SCP_SHIP_PLAN_ETA',
  SHIP_REQ_ETA: 'R_SHIP_REQ_ETA',
  FP_NPC_ASSY_PLAN: 'R_FP_NPC_ASSY_PLAN',
  FP_COATER_PLAN: 'R_FP_COATER_PLAN',
  FP_COATER_POST_PLAN: 'R_FP_COATER_POST_PLAN',
  SHIP_PLAN_ETD: 'R_SHIP_PLAN_ETD',
  INTRANSIT_ETA: 'R_INTRANSIT_ETA',
  INV_SHIP_REQ: 'R_INV_SHIP_REQ',
  INV_SHIP_PLAN: 'R_INV_SHIP_PLAN',
} as const;

// 조회조건 콤보 SQL_ID (design 02 §2 — TO-BE Oracle SCM_ADM_CMBO_SQL_M 실측 USE_YN='Y').
//   cascade: Division(필터) → Company(재조회 PlantSite/PlanDate).
export const COMBO = {
  // AS-IS 전극 Division = MyDivisionInEE(원래 코드 Data_SCP.Type.MyDivisionInEE) + FE 후필터 CODE!='EE'(cs
  //   SetChangedControl L532). 자매 화면 SSP0023 동일. 일반 MyDivision(ATTRIBUTE3<>'EE')은 전극 디비전(EE_*)을
  //   통째로 제외해 등가 아님 — design 02 §2.2 의 CODE!='EE'↔ATTRIBUTE3<>'EE' 등가 가정이 오류(DB 실측 교정 2026-10-26).
  DIVISION: 'MyDivisionInEE', // @sesUserId @mnuId → Division (FE 후필터 CODE!='EE')
  COMPANY: 'Div_CompanyEE_SCP', // OPERATION_GROUP='E'+@divisionId(확실성 높음)
  PLANT_SITE: 'PlantEE', // OPERATION_GROUP='E'+OSP_YN='N' 내장(재사용 판정 완료, convert-core §2.6 5층 대조 PASS)
  PLAN_DATE: 'Plan_InforElectrode_SCP', // CURRENT_PLAN_DATE_YN='Y'+@companyId
  CELL_TYPE: 'CellTypeGr_SCP', // 확실성 중간(design 02 §2.2 — convert 단계 반환값 대조 권고, 확인 필요로 유지)
  // Bucket(cboBucketType) — AS-IS DM0003_GET_BUCKET_TYPE_CODE 는 lookup 'BUCKET_TYPE_CODE'(SCM_ADM_LOOKUP_MASTER_DETAIL)
  //   를 감싼 래퍼 SP 다. SP 를 이식하지 않고 이미 배포된 동명 콤보 SQL_ID 를 재사용한다(자매 SSP0023·shipment-request-semi
  //   동일 방침, convert-core §2.6 "배포된 메타 재사용"). CODE=DAILY/WEEKLY/MONTHLY(무파라미터) → Form 에서 D/W/M 로 매핑.
  BUCKET: 'BUCKET_TYPE_CODE',
  // 신규행 FROM_SITE/TO_SITE 셀콤보 — admin PARAM9 미배선 확인(design 03 §1.6). 옵션(b) FE 직접조회 채택
  //   (AS-IS 도 InsertRow() 코드에서 직접 Data.Common 호출 — admin PARAM9 경로 자체가 AS-IS에 없었다).
  CELL_FROM_SITE: 'PlantByElectordeShipFromSite',
  CELL_TO_SITE: 'PlantByElectordeShipToSite',
  CELL_INCOTERMS: 'Incoterms',
  CELL_TRANSPORT_MODE: 'TransportMode',
} as const;

// GetSSPUserCheck(EditButton 가드①, cs:1482) — SSP 등록 사용자 체크. AS-IS GetSSPUserCheck = SSP0002_GET_USER_INFO_LIST.
//   TO-BE: /SSP0022/main/USER_CHECK/call-proc {userId, language, ssoUserYn:'N'} → o_rc1 0행 or 403 이면 비SSP(자매
//   SSP0015/SSP0021 동형). 백엔드 실측(2026-11-04 ora.py): PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST = VALID 배포,
//   공용 API P_SSP0200_USER_CHECK(PROC_SELECT → 그 proc, USE_YN='Y')도 등록돼 자매 SSP0015/0021/0060/0200 이 재사용 중.
//   남은 것은 SSP0022 메타 2행뿐: SCM_ADM_MNU_BTN_MPG_M(SSP0022,main,USER_CHECK → P_SSP0200_USER_CHECK) +
//   SCM_ADM_USER_GR_MNU_BTN_MPG_M 그룹권한. 이 2행이 등록되면 가드가 런타임 동작한다(미등록 시 403 → fail-closed).
export const USER_CHECK_BTN = 'USER_CHECK' as const;

// 팝업 트리거 버튼 → 대상 텍스트 필드 (design 02 §4.6).
//   btnModelId(#27) 는 AS-IS Click 핸들러 미배선(dead button 의심) — TO-BE 신규 팝업 미신설(사용자 확인 대상).
export const SEARCH_POPUP = {
  ITEM_ID: 'ITEM_ID_1', // btnItemId → SCM0002_ItembyDivisionPopup → txtItemId
  ITEM_ID_2: 'ITEM_ID_2', // btnItemID2 → SCM0002_ItembyDivisionPopup → txtItemId2
  REQUESTOR: 'REQUESTOR', // btnRequestor → UserInfoPopup → txtRequestor
} as const;

// EDIT_FLAG 값별 요청상세 '기존행' 편집가능 컬럼 — AS-IS EditButton spdDetail(cs:1703-1718) 실측.
//   AS-IS 는 SwitchLock 로 행 전체를 연 뒤 LockRange2(...,true=Lock)로 다시 잠근다(SpreadInfo.cs:7072 `range1.Locked=pLock`).
//   컬럼순서 실측(SCM_MST_SHEET_COLUMNS): DIVISION_ID(1)…SHIPMENT_DATE(9) SHIPMENT_QTY(10) INCOTERMS(11)
//   TRANSPORT_MODE(12)…REQUESTOR(32) REQUEST_DATE(33, 마지막). 따라서:
//     · EDIT_FLAG=='N' → LockRange2(0..REQUEST_DATE) = 행 전체 잠금 → **편집 가능 컬럼 없음**.
//     · 그 외          → LockRange2(0..SHIPMENT_DATE) + LockRange2(REQUESTOR..REQUEST_DATE) → 그 사이(가시 기준
//       SHIPMENT_QTY/INCOTERMS/TRANSPORT_MODE)만 열림. SHIPMENT_DATE·REQUESTOR·REQUEST_DATE 는 잠긴다.
//   주의: design 01 R10 / 03 §3 규칙#11 의 "N=REQUEST_DATE / 그외=SHIPMENT_DATE+REQUESTOR~REQUEST_DATE 편집가능"
//   서술은 LockRange2 를 unlock 으로 오해한 **반전 오류**였다 — LockRange2 정의·컬럼순서 실측으로 교정(2026-11-05 사용자 지적).
export const REQUEST_DETAIL_EDIT_COLUMNS_BY_FLAG: Readonly<Record<'N' | 'DEFAULT', readonly string[]>> = {
  N: [],
  DEFAULT: ['SHIPMENT_QTY', 'INCOTERMS', 'TRANSPORT_MODE'],
};

// Insert(신규행) 직후 편집불가(lock) 5컬럼(design 01 R6 / 03 §3 규칙#8, cs:1466-1470).
export const INSERT_LOCK_COLUMNS: readonly string[] = [
  'MODEL_ID',
  'NICK_NAME',
  'DIVISION_ID',
  'REQUESTOR',
  'REQUEST_DATE',
];

// Insert 시 편집 가능(콤보 배선 대상) 2컬럼 — FROM_SITE/TO_SITE(design 03 §1.6).
export const INSERT_EDITABLE_COMBO_COLUMNS: readonly string[] = ['FROM_SITE', 'TO_SITE'];

// 그리드 셀 콤보 컬럼(요청상세, design 03 §1.2 FPComboBox 2 + 런타임 부여 2).
export const CELL_COMBO_COLUMNS = ['INCOTERMS', 'TRANSPORT_MODE', 'FROM_SITE', 'TO_SITE'] as const;

// 동적 pivot 컬럼 태그 패턴 — X_/Y_/Z_(BOH표시모드) × D_/W_/M_(Bucket) × 날짜코드(design 03 §2.2).
//   날짜코드 길이: D_=8(yyyymmdd) · W_=8(yyyymm+isoweek) · M_=6(yyyymm). SHEET_CALENDAR_3SPAN SP 실측
//   (COLUMN_NAME 'X_M_'||yyyymm 은 6자리) — 기존 \d{8} 고정은 M_ 를 못 잡아 Monthly 버킷이 안 뜸.
export const DYNAMIC_COLUMN_TAG_PATTERN = /^([XYZ])_([DWM])_(\d{6,8})$/;

// rdButton(BOH 표시모드) → 동적컬럼 태그 접두 매핑(design 01 R4 / 03 §2.2).
export const BOH_MODE_PREFIX = {
  rdButton1: 'X',
  rdButton2: 'Y',
  rdButton3: 'Z',
} as const;
export type BohMode = keyof typeof BOH_MODE_PREFIX;

// UOM Type(BOH 3-radio) 라벨 매핑 — AS-IS Designer rdButton1 "UOM" / rdButton2 "Cell" / rdButton3 "Pancake m".
//   SSP0023 BOH_RADIO_ITEMS 와 동일 패턴(@shared RadioGroup 미제공 → 로컬 radio 마크업으로 재현).
export const BOH_RADIO_ITEMS: { radio: BohMode; lbl: string; fallback: string }[] = [
  { radio: 'rdButton1', lbl: LBL.BOH_UOM, fallback: 'UOM' },
  { radio: 'rdButton2', lbl: LBL.BOH_CELL, fallback: 'Cell' },
  { radio: 'rdButton3', lbl: LBL.BOH_PCM, fallback: 'Pancake m' },
];

// rdButton 3-way 합계컬럼 세트(design 01 R4 매핑표) — 9칼럼×3세트 중 1세트만 노출.
export const BOH_SUM_COLUMN_SETS: Readonly<Record<BohMode, readonly string[]>> = {
  rdButton1: ['TOT_BOH_QTY', 'JR_BOH_QTY', 'PC_BOH_QTY'],
  rdButton2: ['TOT_BOH_QTY_PCM', 'JR_BOH_QTY_PCM', 'PC_BOH_QTY_PCM'],
  rdButton3: ['TOT_BOH_QTY_CELL', 'JR_BOH_QTY_CELL', 'PC_BOH_QTY_CELL'],
};

export const BUCKET_TYPE = {
  DAILY: 'D',
  WEEKLY: 'W',
  MONTHLY: 'M',
} as const;

// TO-BE MSG 코드 — SCM_ADM_MSG_M / public/locales(EN.json) 실측 역조회로 확정(Hook #114). 저장확인은 AS-IS
//   MSG00012 가 TO-BE 에서 "Maximum of 10 tabs allowed." 로 재사용돼(07_validation-audit §0.5 결함) 쓰면 안 되며,
//   공용 CRUD_MSG.SAVE_CONFIRM(MSG00001)/SAVED(MSG00002)/NO_CHANGES(MSG00004)/DUPLICATE(MSG00043) 로 대체한다
//   (@foundation/constants). 아래는 이 화면 validation 전용으로 EN.json 실측(2026-10-27)해 확정한 코드다.
export const MSG = {
  // 등록 확인(EN.json 실측): 등가 코드로 대체.
  PREREQUISITE: 'MSG01126', // "First, select {0}." — AS-IS MSG00098(TO-BE 미등록) 등가(자매 shipment-change-request-plan 동일 선택)
  INVALID_DATE: 'MSG00611', // "Invalid date format. (YYYYMMDD)" — AS-IS MSG00049 재번호
  // 조회 기간 범위(AS-IS 공통 DateUtil.Check_PeriodDate, 감사 07 누락분) — 자매 semi/pack 동일 코드.
  PERIOD_EMPTY: 'MSG00665', // "Please enter the search period."
  PERIOD_ORDER: 'MSG00108', // "Invalid period (start > end)."
  PERIOD_MAX: 'MSG01187', // "Maximum Period is From Date + {0}." ({0}=371)
  // 미등록(EN.json 0건, 2026-10-27 실측) — AS-IS 번호를 key 로 두되 EN.json 에 없어 영문 fallback 이 표시된다.
  CONFIRM_DAY_BEFORE: 'MSG01320', // AS-IS MSG00323 // "Shipment date cannot be entered before {0}"
  STANDARD_INFO: 'MSG01321', // 저장결과 'X' — "Standard information is not registered."
  SYSTEM_ERROR: 'MSG01075', // AS-IS MSG00042 // 저장결과 'F'/else — "A system error occurred."
  // ETA 요청팝업 출하일 하한(AS-IS SpdMain_EditChange cs:1058) — EN.json 미등록(TC-V-19, 2026-10-27 실측 0건).
  //   AS-IS 번호를 key 로 두되 영문 fallback 이 표시된다. {0}=D+n(CHANGE_REQ_DAY lookup, 기본 1).
  CHANGE_REQ_MIN_SHIP: 'MSG01206', // AS-IS MSG00194 // "Change requests are possible from the current D+{0} ship date."
  // GetSSPUserCheck(EditButton 가드①, cs:1482-1489) — SSP Planner 미등록 사용자. AS-IS MSG00251 은
  //   TO-BE SCM_ADM_MSG_M 에 미존재(0행)라 전 자매(SSP0015/SSP0021/SSP0024/SSP0025)가 동일 문구 MSG01261
  //   "This user does not have permission to the SSP Planner.\n\rUser ID : {0}" 로 대체했다 — 그 선례를 따른다.
  USER_NOT_REGISTERED: 'MSG01261',
  // bRealFlag==false(과거/CutOff Plan Date) 편집 차단(EditButton 가드②·SpdMain 더블클릭 가드, cs:1494-1498/1368-1372).
  //   AS-IS MSG00312 "It is not real time data." — TO-BE 등록 코드 미확정(verify 대상)이라 호출부 fallback 문구로 degrade.
  NOT_REAL_TIME: 'MSG01314', // AS-IS MSG00312
} as const;

// ETA 요청팝업(SSP0022_ShipmentRequestPopup "Shipment Request Insert") 전용 상수.
export const POPUP = {
  // 출하일 하한 오프셋(D+n) lookup — AS-IS dtBaseDay=Data.Common(LookupCommon,'CHANGE_REQ_DAY'), dDay=row[0][1].
  //   lookup 값컬럼(day 숫자) 실측 미확정 → 모달에서 Number(NAME) 우선·실패 시 기본 1(AS-IS dtBaseDay 빈 경우 dDay=1).
  CHANGE_REQ_DAY_LOOKUP: 'CHANGE_REQ_DAY',
  CHANGE_REQ_DAY_DEFAULT: 1,
} as const;

// 저장결과 'X'(기준정보/BOD 미등록) → MSG01321 '예' 시 여는 SSP 기준정보 매뉴얼 — AS-IS
//   AddHelpButton("Standard Information SSP Manual")(BaseForm.cs L3501→FileDownLoad L3406)은 사내 Help 서버의
//   구 매뉴얼(구)SCM 화면 내용)을 받았으나, 신 매뉴얼을 FE 정적 호스팅(nscm-fe/public/manual/)에 동봉해 제공한다.
//   자매 SSP0060·SSP0021·SSP0023 상수와 같은 값.
export const STANDARD_MANUAL_URL = encodeURI('/manual/Standard Information SSP Manual.pptx');
