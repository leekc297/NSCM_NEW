import type { BUCKET_TYPE, MENU_ID, SHEETS } from './shipment-plan-fg.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0009 는 procedures.d.ts 에 아직 등록되지 않았다
//   (PROC_M 메타 등록은 convert-sp activity 소관, convert-core §2.3) — RawProcedureMap 의 index
//   signature fallback(Record<string, JsonPrimitive|WijmoRowItem>)으로 타입체크는 통과하되 자동완성은
//   느슨하다. convert-sp 완료 후 이 파일 변경 없이 자동으로 엄격해진다.
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;
export type PeggingRow = ResponseData<MENU_ID, SHEETS.PEGGING>;
export type ProblemRow = ResponseData<MENU_ID, SHEETS.PROBLEM>;

// 정보컬럼 constants fallback 메타 (admin SCM_MST_SHEET_COLUMNS 미조회/실패 시에만 사용).
export interface MainColumnMeta {
  key: string;
  header: string;
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  frozen?: boolean;
  _ctrlType?: 'FPText' | 'FPModal' | 'FPComboBox' | 'FPDate' | 'FPNumber';
  _inputEditType?: 'S' | 'O';
  _comboKey?: string;
}

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1/§5 인벤토리.
export interface SearchCondition {
  divisionId: string;
  operationGroupId: string; // cboBizType
  fromSiteIds: string[]; // clbFromSite(다중)
  toSiteIds: string[]; // clbToSite(다중)
  teamIds: string[]; // clbTeam(다중) — cascade 트리거
  endCustomerIds: string[]; // clbCustomer(다중)
  electrodeTypeIds: string[]; // clbElecType(다중, EE 만 Enabled)
  planStartYyyymmdd: string; // cboPlanDate
  planType: string; // cboPlanType
  planSeq: string; // cboPlanSeq
  fromYyyymmdd: string; // dCalendar From
  toYyyymmdd: string; // dCalendar To
  itemId: string; // txtItem_Id(다건, btnItem_Id 팝업이 채움)
  projectCode: string; // txtProject(다건, btnProject 팝업이 채움)
  bucketType: BUCKET_TYPE; // cboBucketType
  chkAll: boolean; // chkAll — 전체 대상 여부(P_CHK_ALL)
  chkSum: boolean; // chkSum — SUM(W_/M_) 컬럼 표시 토글(재조회 없는 클라 토글)
}

// Fix 정보(O_RC3) — 셀 하이라이트 오버레이 전용(design 03 §2.5). 편집 잠금과 무관(AS-IS 기지결함, §6#3).
export interface FixInfoRow {
  KEY_IDX?: string;
  FIX_ID?: string;
  FROM_SITE?: string;
  INCOTERMS?: string;
  BOD_ID?: string;
  YYYYMMDD?: string; // 'D_'+원본일자 형태로 이미 컬럼ID 매칭 가능
}
