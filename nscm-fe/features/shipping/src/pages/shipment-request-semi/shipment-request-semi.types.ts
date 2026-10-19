import type { BUCKET_TYPE } from './shipment-request-semi.constants';

// 조회조건 8필드 (design 02 §1 F1~F8). Bucket/Sum 은 SP 파라미터가 아니라 그리드 가시성 전용이다.
export interface SearchCondition {
  divisionId: string; // F1 Division*  (단일 코드 — ALL 전개 없음, P4)
  operationGroup: string; // F2 Operation Group* (단일 코드 'P'|'A')
  itemId: string; // F3 Model (콤마 구분 다중 or '')
  scmSiteIds: string[]; // F5 From Site (다중, 빈 배열 = 전체 → SP 에는 빈 문자열, P3)
  fromYyyymmdd: string; // F7 Period* from (서버 산출 고정값 — 입력 불가)
  toYyyymmdd: string; // F7 Period* to
  bucketType: BUCKET_TYPE; // F6 Bucket (그리드 전용)
  showSum: boolean; // F8 Sum (그리드 전용)
}

// 메인 그리드 행 — 고정 18컬럼(메타) + 동적 기간칼럼(M_/W_/D_). 동적 키는 인덱스 시그니처로 받는다.
export interface ShipmentRequestRow extends Record<string, unknown> {
  DIVISION_ID?: string;
  ITEM_ID?: string;
  NICK_NAME?: string;
  FROM_SITE?: string;
  TO_SITE?: string;
  TR_MODE?: string;
  INCOTERMS?: string;
  PROJECT_CODE?: string;
  FCST_TYPE?: string;
  LT_DAY?: string;
  LAST_UPDATED_BY?: string;
  MEASURE_LABEL?: string;
  BOD_ID?: string;
  MEASURE_COLOR?: string;
  FROZEN_YYYYMMDD?: string;
  MEASURE?: string;
  BOD_FROM_YYYYMMDD?: string;
  BOD_TO_YYYYMMDD?: string;
  CRUD_TYPE?: string;
}

// CALENDAR SP(GET_SHEET_CALENDAR_3SPAN) 반환 1행 (design 03 §2.1).
export interface CalendarSpanRow extends Record<string, unknown> {
  COLUMN_NAME?: string; // 그리드 binding — 'M_yyyymm' / 'W_yyyymmww' / 'D_yyyymmdd'
  COLUMN_LABEL_NAME?: string; // 3단(leaf) 라벨 = 일자
  SMALL_CLASS_LABEL_NAME?: string; // 2단 라벨 = 주
  LARGE_CLASS_LABEL_NAME?: string; // 1단 라벨 = 월
  DAY_CODE?: string; // 'SAT' / 'SUN' — 일자 헤더 글자색(R04)
  SORT_ORDER_NO?: string | number; // 좌우 정렬 (M_ 01 < W_ 21 < D_ 31)
}

// BOD 팝업(PU04) **그리드 행** — 팝업 SP 결과 컬럼 그대로다.
//   컬럼명 원천: AS-IS `SCM0002_GetBODItemPrjRoutePopup.cs:53-77 DefColumns`
//   (Voyage 7칸의 실제 필드명은 `VOYAGE_*` 가 아니라 `DAYS_*` 다).
//   표시 컬럼 정의는 admin 메타(`SHEET_NAME='bodPopup'`)가 소유한다 — 여기서는 선택 매핑에 쓰는 것만 선언한다.
export interface BodPopupRow extends Record<string, unknown> {
  ITEM_ID?: string;
  FROM_SITE?: string;
  TO_SITE?: string;
  TRANSPORT_MODE?: string;
  INCOTERMS?: string;
  LEAD_TIME?: string;
  FROZEN_YYYYMMDD?: string;
  BOD_ID?: string;
  BOD_FROM_YYYYMMDD?: string;
  BOD_TO_YYYYMMDD?: string;
}

// BOD 팝업 **선택 결과 DTO** — AS-IS `BODItemPrjRoutePopup`(retList) 의 c_* 프로퍼티.
//   AS-IS `OKButtonClick`(cs:315-332)이 그리드 행 → 이 DTO 로 옮기는 단계를 팝업이 그대로 수행한다.
//   AS-IS DTO 의 `c_origin_*`/`c_voyage_*` 는 SSP0045 가 한 번도 읽지 않아 옮기지 않는다.
//   주의: `c_item_id` 는 AS-IS DTO 에도 없다 — 호출 화면이 클릭한 행의 기존 ITEM_ID 를 그대로 유지한다(cs:1264).
//   주의: `c_bod_from/to_yyyymmdd` 는 AS-IS DTO 에 선언만 있고 `OKButtonClick` 이 채우지 않는다(Q7).
//        팝업 SP 가 그 컬럼을 내려주면 여기서 채워지고, 아니면 undefined 로 남아 편집구간이 안전 차단된다.
export interface BodItemRow extends Record<string, unknown> {
  C_FROM_SITE?: string;
  C_TO_SITE?: string;
  C_TRANSPORT_MODE?: string;
  C_INCOTERMS?: string;
  C_LT_DAY?: string;
  C_FROZEN_YYYYMMDD?: string;
  C_BOD_ID?: string;
  C_BOD_FROM_YYYYMMDD?: string;
  C_BOD_TO_YYYYMMDD?: string;
}
