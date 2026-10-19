import type { BUCKET_TYPE, MENU_ID, SHEETS } from './dmf0045.constants';

// AS-IS DMF0045 조회조건 (design 02 §1 영역2 인벤토리 전건):
//   Row0: Division*(단일) / Team / End Customer / Period*
//   Row1: Sales Site / Project(팝업) / Model=Item ID(팝업) / (btnMeasure)
//   Row2: Plant Site(40 비활성) / Bucket*(기본 Daily) / Sum 체크박스
//   lblItemType 는 캡션(콤보 아님) — 조회조건 아님. SCM0001 BizType 은 사표(미이식).
export interface SearchCondition {
  divisionId: string; // 필수 — Division 단일 콤보 (MSG00097). cascade root.
  deptIds: string[]; // Team (UserTeamByDivision)
  endCustomers: string[]; // End Customer (EndCustomerByDivisionDept)
  scmSiteIds: string[]; // Sales Site (UserSiteByEndCustomer, OPERATION_GROUP<>'W'·DIVISION_ID<>'40')
  plantSiteIds: string[]; // Plant Site (PlantSiteByDivision, SITE_TYPE='PLANT', 40 비활성)
  projectCodes: string[]; // Project — 팝업(SCM0002) 반환 누적(40 비활성)
  itemIds: string[]; // Model/Item ID — 팝업(DMF0047) 반환 누적. 화면 라벨=Model(LBL00669).
  startYyyymmdd: string; // Period.start (필수 — 오늘)
  endYyyymmdd: string; // Period.end (필수 — 오늘+55일, readOnly)
  bucketType: BUCKET_TYPE; // Bucket (필수 — 기본 Daily, LOOKUP BUCKET_TYPE_CODE)
  sumYn: boolean; // Sum — 상위 버킷 합계 컬럼(M_/W_) 표시 토글 (FE 전용, AS-IS chkSum)
}

// 활성 시트(탭) — Pack Biz / Cell Biz. 조회·저장·컬럼메타·팝업 sBizType 스코프.
export type ActiveSheet = SHEETS.PACK | SHEETS.CELL;

// 메인 그리드 행 (PIVOT wide format — 정적 16 admin 메타 + 동적 M_/W_/D_/DB_ 컬럼)
//   CRUD_TYPE: 'I'(신규) / 'M'(수정 — EditTracker 자동 마킹). 저장행 삭제는 셀 0 저장 경로.
//   INSERT_GROUP_ID: Insert 행 식별자 (셀 팝업 반영 대상 추적).
export type ShipmentRequestRow = Record<string, unknown> & {
  CRUD_TYPE?: 'I' | 'M' | 'D';
  INSERT_GROUP_ID?: string;
  MEASURE?: string;
  SHIP_FROZEN?: string | number; // 선두 D_ 잠금 카운트 (design 03 §3)
  MEASURE_COLOR?: string; // 콤마 RGB — Measure 셀 글자색 (design 03 §3)
};

// 동적 기간 컬럼 메타 (P_DMF0045_GET_SPREAD_TITLE data 커서 — design 03 §2.1).
//   COLUMN_NAME: D_yyyymmdd(일) / W_...(주) / M_...(월) / DB_...(버킷일 플래그, 숨김) / 정적 컬럼명.
//   LARGE/SMALL_CLASS_LABEL_NAME: 2단 그룹 헤더 병합용.
export type SpreadTitleRow = ResponseData<MENU_ID, SHEETS.SPREAD_TITLE, 'data'>;

// TR_MODE 셀 BOD 팝업(DMF0046 GetBODItemPrjRoutePopup) 응답 행 — o_rc1(admin 컬럼 메타로 표시).
//   DMF0045 는 procedures.d.ts 미등재라 응답 타입을 여기서 명시 고정한다(SP 계약 자기문서화).
//   컬럼명은 AS-IS SCM0002_GetBODItemPrjRoutePopup.InitSpread 반환 컬럼 기준(design 03 §3 근거표).
export interface BodPopupRow {
  FROM_SITE?: string;
  TO_SITE?: string;
  INCOTERMS?: string;
  TRANSPORT_MODE?: string;
  BOD_ID?: string;
  END_CUSTOMER?: string;
  DEPT_NAME_KO?: string;
  [key: string]: unknown;
}

// BOD 팝업 확정 반환 DTO — 호출 화면은 c_* 계약만 알면 되고 팝업 SP 컬럼 변화에 끌려가지 않는다
//   (shipping SSP0045 BodItemRouteModal 선례). applyPopupFill 의 BOD 소스키(c_*)와 1:1.
export interface BodItemReturn {
  c_FROM_SITE?: string;
  c_TO_SITE?: string;
  c_INCOTERMS?: string;
  c_TRANSPORT_MODE?: string;
  c_BOD_ID?: string;
  c_END_CUSTOMER?: string;
  c_DEPT_NAME_KO?: string;
}

// Validation 결과 (sales-plan.validate 동형).
export interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
  rowIdx?: number;
}
