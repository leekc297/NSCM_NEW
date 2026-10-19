// SCP0006 Project Route — 상수/메타 매핑.
//   AS-IS: GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0006_ProjectRoute/SCP0006_ProjectRoute.cs (2142 lines)
//   설계: .atlas/gscm-design/SCP0006/design/00~03. RESPONSE_SET/SHEETS 는 procedures.d.ts SCP0006 정합.

import type { ComboResponse } from '@foundation/models';

export const MENU_ID = 'SCP0006' as const;
export type MENU_ID = typeof MENU_ID;

// BE 프로시저 라우팅 키(SCM_ADM_MNU_BTN_MPG_M.SHT_NM) + procedures.d.ts sheetName.
export enum SHEETS {
  SITE = 'site',
  BOM = 'bom',
  PLANT = 'plant',
}

// 각 시트 커서 결과 key(procedures.d.ts response key). 단일 커서 화면은 '_rc1' 대신 시트명과 동일.
export enum RESPONSE_SET {
  SITE = 'site',
  BOM = 'bom',
  PLANT = 'plant',
}

export enum SHEET_INDEX {
  SITE,
  BOM,
  PLANT,
}

/**
 * 컬럼 메타 fetch(/admin/menu/SCP0006/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과
 * 정확히 일치해야 한다(BE 문자열 매칭). AS-IS SpreadInfo 시트명(Main/BOM Explosion/Plant Assign)이
 * DB SHEET_NAME 으로 배포된 것으로 본다(design/03 §0). 라이브 확인필요(design/03 §6-2).
 */
export const COLUMN_SHEET_NAME: Record<RESPONSE_SET, string> = {
  [RESPONSE_SET.SITE]: 'Main',
  [RESPONSE_SET.BOM]: 'BOM Explosion',
  [RESPONSE_SET.PLANT]: 'Plant Assign',
};

// 사업부 분기 — 40/82 는 Main 에서 SCM_SITE_NAME/PROJECT_CODE/SALES_MODEL 숨김(design/03 R-DYN),
//   조회조건에서 Sales Site ALL 고정 + Project 입력/픽커 비활성(design/01 R2).
export const DIVISION_82 = '82';
export const DIVISION_40 = '40';
export const isProjectHiddenDivision = (divisionId: string): boolean =>
  divisionId === DIVISION_82 || divisionId === DIVISION_40;

// Main 시트 division 82/40 시 숨기는 컬럼(design/03 R-DYN).
export const SITE_HIDE_ON_82_40 = ['SCM_SITE_NAME', 'PROJECT_CODE', 'SALES_MODEL'] as const;

// Plant 편집가능 컬럼(design/03 §1.3) — 나머지 키·감사·파생·플래그 열은 잠금.
export const PLANT_EDITABLE_COLUMNS = [
  'PLANT_SITE_ID',
  'VALID_YN',
  'PRIORITY',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
] as const;

// Period 기본 구간 = PERIOD_DEFAULT From ~ +11M(design/02 §4). 기본 12개월.
export const PERIOD_MONTHS_SPAN = 11;

// 동적 월 컬럼 prefix — AS-IS 는 raw YYYYMM 을 컬럼ID 로 쓰나(design/02 SetCalendar), TO-BE 는
//   고정 컬럼과의 충돌을 피하려 M_ 접두를 붙인다(sales-future-price 동일 관례). SITE GET 응답도
//   동일 key(M_YYYYMM)로 내려주는 계약(design/03 §2 TO-BE 재현계약). 확인필요(SP 미배포, design/03 §6-5).
export const DYN_MONTH_PREFIX = 'M_';

// 셀 콤보 SQL_ID(design/03 §4.5). DB 실측 확정(2026-09-21, ora.py).
// PLANT_SITE 는 AS-IS _SCP proc(UP_FX_GetCommonDataList_SCP) 출처라 도메인 suffix '_SCP' 부여
//   (cascade-combo-filter §0-N — 공통+_SCP 양쪽 존재 실측 2026-09-10). VALID_YN 은
//   공통 proc 출처라 무접미 유지. `PlantByDivisionOperationItem_SCP` 등록 SQL 실측 완료 — 토큰
//   `@divisionId`/`@operationGroup`/`@param3`(itemId, 위치 토큰) 확인, ProjectRoutePlantGrid.tsx
//   가 이미 이 3개를 그대로 전달 중(회귀 없음).
// runtime-parity-gate §6-3 해소(사용자 지시 2026-09-21): admin 메타(`SCM_MST_SHEET_COLUMNS.
//   CELL_COMBO_DATA_TYPE`)가 한때 base(`PlantByDivisionOperationItem`, OSP 외주 미필터)를 가리키고
//   있어 이 상수(`_SCP`, OSP 필터 포함)와 불일치했다 — "OSP 외주 사이트도 Plant Site 후보에 포함할지"
//   업무 결정을 받아 `_SCP`(OSP 필터 적용)로 확정, admin 메타를 이 상수 값에 맞춰 교정했다
//   (`05_register_plantsite_scp.sql`, 토큰 동일이라 FE 변경 없음).
// DIVISION 정정(사용자 지시 2026-09-22): AS-IS `dtMyDivision = BLUtils.GetDivisionWithoutEE(false,"")`
//   는 두 단계다 — ① `GetDivision()` → `Data_SCP.Common(Type.Division, addAll, groupId, userId)`
//   (BLUtils.cs L58-71, `Common`이므로 `_SCP` 변형=권한 스코프) ② 그 결과를 클라에서
//   `DBUtils.Filter("ATTRIBUTE3<>'EE'")`로 다시 거름(BLUtils.cs L107-117). 즉 ①은 EE 포함 전체
//   권한목록, EE 제외는 ②의 화면측 후처리 필터다(convert-core §2.6 "AS-IS 소스 필터는 화면에서
//   재구현" 원칙 그대로). TO-BE `Division_SCP`(ora.py 실측)가 정확히 ①(권한 스코프, EE 미필터)이라
//   AS-IS 1단계와 1:1 대응 — ②(EE 제외)는 `EXCLUDE_EE_DIVISION`으로 이 파일이 재현한다.
//   이전 값(`MyDivision`)은 이 화면의 실제 AS-IS 호출 체인과 무관한 별개 콤보(우연히 서버 SQL에
//   같은 EE 필터가 이미 박혀 있어 결과가 같았을 뿐 — 다른 화면 목적으로 등록된 콤보에 결과 우연 일치로
//   의존하면 그 콤보가 바뀔 때 이 화면이 말없이 깨진다)라 정정한다.
export const COMBO = {
  DIVISION: 'Division_SCP',
  STATUS: 'YesOrNo',
  VALID_YN: 'YesOrNo',
  PLANT_SITE: 'PlantByDivisionOperationItem_SCP',
  // Period From 기본값(G6, design/02 §4) — AS-IS CallBizCommonData('PERIOD_DEFAULT') 와 동일 등록
  //   SQL(2026-09-21 ora.py 실측: FROM_VALUE/TO_VALUE 반환, ISO_WEEK 당주 기준). 이 화면은 FROM_VALUE
  //   만 쓰고 To 는 기존대로 PERIOD_MONTHS_SPAN(+11개월) 로컬 계산 — SQL 자체의 TO_VALUE 는 당주+3주
  //   범위라는 별도 의미(다른 화면 용도로 추정)라 이 화면의 "12개월 구간"과 무관.
  PERIOD_DEFAULT: 'PERIOD_DEFAULT',
  // Sales Site 정정(사용자 지시 2026-09-22): AS-IS `dtSalesSiteAll = Data_SCP.CommonAll(
  //   Type.SaleSiteByDivision1, false, "")`(cs L51, `CommonAll`→`_SCP_ALL` 권한무시 전체)를
  //   TO-BE `SaleSiteByDivision1_SCP_ALL`(ora.py 실측: SCM_MST_SITE, SITE_TYPE='SALES'
  //   AND VALID_YN='Y' AND @divisionId 콤마매치)로 그대로 재현한다. 이전엔 어차피 화면상
  //   disabled+'ALL' 고정이라(design/02 §2 AS-IS SetValues("ALL") 강제잠금 재현) 콤보를 호출하지
  //   않고 단일 'ALL' 옵션만 하드코딩했었다 — 검색 파라미터 결과는 동일하지만 AS-IS는 실제로는
  //   division별 후보 목록을 (비활성 상태로) 그대로 보여준다(체크리스트에 실 사이트명이 나열됨).
  //   화면 표시까지 AS-IS와 맞추기 위해 실제 콤보를 호출한다(선택값은 여전히 'ALL' 고정, 비활성 유지).
  SALES_SITE: 'SaleSiteByDivision1_SCP_ALL',
  // Input All 팝업(SCM0002_ProjectRouteListSavePopup) 전용 — 본 화면 Plant Assign 그리드와 이름은
  // 비슷하지만 AS-IS 호출 체인이 다르다(combo-semantic-parity 원칙, 이름 유사 재사용 금지). 본 화면은
  // `Data_SCP.Common(Type.PlantByDivisionOperationItem, ...)`(SCP0006_ProjectRoute.cs L1085, `_SCP`
  // 변형 = OSP 필터 포함) 인데, 이 팝업은 `Data.Common(Type.PlantByDivisionOperationItem, ...)`
  // (SCM0002_ProjectRouteListSavePopup.cs L563, base `Data` 클래스)를 쓴다 — TO-BE 등록명도
  // suffix 없는 `PlantByDivisionOperationItem`(ora.py 실측: 토큰 @divisionId/@operationGroup/
  // @itemId, OSP 유니온·BOM 조인 없는 단순 SCP_MST_TACT_TIME(+OSP) 직접 조회, `_SCP` 변형과 SQL·
  // 토큰명 전부 다름 — `_SCP` 변형은 @param3, 이건 @itemId).
  PLANT_SITE_POPUP: 'PlantByDivisionOperationItem',
} as const;

// BLUtils.GetDivisionWithoutEE 2단계 중 화면측 후처리(위 COMBO.DIVISION 주석 참고) — EE(전극)
//   사업부는 항상 제외. Division_SCP 응답의 ATTRIBUTE3 컬럼으로 판정.
export const EXCLUDE_EE_DIVISION = (row: ComboResponse): boolean =>
  String(row.ATTRIBUTE3 ?? '') !== 'EE';

// TO-BE i18n 코드 — SCM_ADM_MSG_M 실측 정합(2026-09-28 ora.py, 클라우드 동기화분) + AS-IS
//   TB_FX_MessageInfo/호출부 주석 대조. AS-IS MSG 번호(MSSQL)와 TO-BE 번호 체계가 달라
//   (convert-i18n-code-guess-verify-msg-m) 그대로 쓰면 미등록(fallback)·타화면 문구로 연결된다 —
//   AS-IS 호출부 문구를 근거로 동일 문구를 가진 TO-BE 등록 코드로 매핑한다.
export const MSG = {
  // 주의: TO-BE MSG00097='Division 을 선택하세요' 로, AS-IS R1 "권한 division 없음" 의도와 문구가
  //   다르다. 클라우드 DB 에 "조회 가능한 사업부 권한이 없습니다" 전용 코드가 없어 defaultValue
  //   fallback 을 유지한다(확인필요 — 전용 코드 신규 등록 또는 문구 재확정 필요).
  REQUIRE_DIVISION: 'MSG00097', // 권한 division 없음(design/01 R1)
  READONLY_EDIT_BLOCK: 'MSG00109', // 읽기전용 상태입니다.(AS-IS MSG00109 동일 문구)
  // MSG00004 는 프레임워크 전역 "수정한 내용이 없습니다"(No changes to save) 예약 ID —
  //   useCustomQueryClient.ts 공통 저장거부 경로가 사용 중. 저장 성공 토스트는 MSG00002
  //   ('성공적으로 저장되었습니다.').
  SAVE_RESULT: 'MSG00002',
  SAVE_ERROR: 'MSG00618', // 저장 중 오류가 발생했습니다.(AS-IS MSG00006 → TO-BE MSG00618)
  NO_CHANGE: 'MSG00004', // 수정한 내용이 없습니다.(AS-IS 무번호 TO-BE 추가 → 프레임워크 예약 MSG00004)
  INSERT_NEED_BOM: 'MSG01140', // 더블클릭하여 BOM Item을 선택한 후 사용하세요!(AS-IS MSG00116 → MSG01140)
  OS_PACKER_MISSING: 'MSG01236', // 외주 PACKER ITEM 미등록(AS-IS MSG00226 → MSG01236). N0 dead code(미사용)
  N1_END_OVERLAP: 'MSG01129', // 중첩되는 종료일자가 있습니다.(AS-IS MSG00101 → MSG01129)
  N2_START_OVERLAP: 'MSG01130', // 중첩되는 시작일자가 있습니다.(AS-IS MSG00102 → MSG01130)
  N3_PLANT_DUP: 'MSG01131', // 동일 기간에 Plant Site가 중복되었습니다.(AS-IS MSG00103 → MSG01131)
  N4_PRIORITY_DUP: 'MSG01132', // 동일 기간에 Priority가 중복되었습니다.(AS-IS MSG00104 → MSG01132)
  N5_PERIOD_OVERLAP: 'MSG00700', // 중첩된 기간이 있습니다.(AS-IS MSG00105 → TO-BE MSG00700)
  N6_PERIOD_CONTINUITY: 'MSG01133', // 기간은 연속적으로 입력하여야 합니다.(AS-IS MSG00106 → MSG01133)
  N7_PRIORITY_POSITIVE: 'MSG01134', // Priority는 양의 정수입니다.(AS-IS MSG00107 → MSG01134)
  N8_DATE_ORDER: 'MSG01135', // 시작일자가 종료일자보다 늦을 수 없습니다.(AS-IS MSG00108 → MSG01135)
  N8_DATE_RANGE: 'MSG01080', // 처리가능한 날짜 범위가 아닙니다. {0}(AS-IS MSG00048 → MSG01080)
  // N8-format(사용자 지시 2026-09-23) — "20261251" 처럼 자리수는 맞지만 실제 달력에 없는 날짜 차단.
  //   MSG00611='유효한 날짜 형식이 아닙니다. (YYYYMMDD)' 범용 재사용(TO-BE 추가, AS-IS 무번호).
  N8_DATE_FORMAT: 'MSG00611',
  N9_PRIORITY_ONE: 'MSG01137', // 해당 기간에 Priority 1이 없습니다.(AS-IS MSG00110 → MSG01137)
} as const;

// design/02 §5 btnAllFind — Input All. SYS0004 미등록(정직 고지, design/02 §7).
//   등록 전까지는 로케일 전환이 반영되지 않는 임시 fallback.
export const LBL = {
  // G11 해소(04_impl-gap-audit, 2026-09-21 ora.py 실측): 신규 등록 불필요 — SCM_ADM_MSG_M 에
  //   'LBL01082'(KO/EN/CN 전부 'Input All')가 이미 등록돼 있어 그대로 재사용.
  INPUT_ALL: 'LBL01082',
} as const;
