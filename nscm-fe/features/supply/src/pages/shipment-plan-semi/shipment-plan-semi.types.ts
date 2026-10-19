import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-semi.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0010 은 SCP0009 와 동일하게 procedures.d.ts 에
//   아직 등록되지 않았다(PROC_M 메타 0행, convert-sp activity 소관, convert-core §2.3) —
//   RawProcedureMap 의 index signature fallback(Record<string, JsonPrimitive|WijmoRowItem>)으로
//   타입체크는 통과하되 자동완성은 느슨하다. convert-sp 완료 후 이 파일 변경 없이 자동으로 엄격해진다.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 정보컬럼 constants fallback 메타 (admin SCM_MST_SHEET_COLUMNS 미조회/실패 시에만 사용).
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  frozen?: boolean;
}

// Fix 정보(O_RC3) — 셀 하이라이트 오버레이 전용(design 03 §4.2). 편집 잠금과 무관.
export interface FixInfoRow {
  KEY_IDX?: string;
  FIX_ID?: string;
  TO_SITE?: string;
  BOD_ID?: string;
  YYYYMMDD?: string; // 'D_'+원본일자 형태로 이미 컬럼ID 매칭 가능
}

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리(14개 상호작용 컨트롤).
export interface SearchCondition {
  divisionId: string;
  operationGroupId: string; // cboOperGroup
  fromSiteIds: string[]; // clbFromSite(다중)
  toSiteIds: string[]; // clbToSite(다중)
  electrodeTypeIds: string[]; // clbElecType(다중, EE 만 Enabled)
  planStartYyyymmdd: string; // cboPlanDate
  planType: string; // cboPlanType
  planSeq: string; // cboPlanSeq
  fromYyyymmdd: string; // dCalendar From
  toYyyymmdd: string; // dCalendar To
  itemId: string; // txtItemId(btnItem_Id 팝업이 채움, 직접입력도 가능)
  bucketType: BUCKET_TYPE; // cboBucketType
  chkSum: boolean; // chkSum — SUM(W_/M_) 컬럼 표시 토글(재조회 없는 클라 토글)
}
