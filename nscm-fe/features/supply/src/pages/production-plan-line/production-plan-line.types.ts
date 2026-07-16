import type { MENU_ID, SHEETS } from './production-plan-line.constants';

// 조회조건 — AS-IS SCP0013 usrConditionPanel 1:1 (.cs InitControls/FindData_Main 실측).
//   레이아웃(2026-07-13 사용자 지시): 1행 4개 × 2단(conditions) + 나머지 extraConditions(펼치기/닫기),
//   맨끝 체크박스 3종(ALL/Line Assign/Sum), Bucket 우측 W26/W52 프리셋 버튼.
export interface SearchCondition {
  /** Division* — MyDivision 콤보 (AS-IS cboDivision) */
  divisionId: string;
  /** Operation Group* (AS-IS cboOperationGroup — EE 분기 소스) */
  operationGroup: string;
  /** Cell Type Gr — division '40' 전용 enable (AS-IS cboCellTypeGr) */
  cellTypeGrs: string[];
  /** Electrode — operationGroup A/P 시 'ALL' 고정+비활성 (AS-IS cboElectrode) */
  electrodes: string[];
  /** Extra Spec — division '40' 전용 enable (AS-IS clbExtraSpec) */
  extraSpecs: string[];
  /** Plant Site (AS-IS clbPlantSite) */
  plantSiteIds: string[];
  /** Line (AS-IS clbLine) */
  lineIds: string[];
  /** Model — 텍스트 (AS-IS txtModel) */
  modelId: string;
  /** Material — 텍스트 + 검색 popup (AS-IS txtItemId + btnItemId) */
  itemIds: string[];
  /** Nick Name — 텍스트 (AS-IS txtNickName) */
  nickName: string;
  /** Plan-date* (AS-IS cboPlanDate — DATE_WEEKLY) */
  planDate: string;
  /** Plan-type* (AS-IS cboPlanType — 기본 목록 마지막값) */
  planType: string;
  /** Seq* (AS-IS cboPlanSeq — 기본 첫번째) */
  planSeq: string;
  /** Period* from (AS-IS dCalendar — 기본 W52 range) */
  fromYyyymmdd: string;
  /** Period* to */
  toYyyymmdd: string;
  /** Bucket — BUCKET_TYPE 풀워드 (기본 WEEKLY) */
  bucketType: string;
  /** ALL 체크 — p_chk_all 'Y'/'N' (bucket 무관 일별 상세 포함 조회) */
  chkAll: boolean;
  /** Line Assign 체크 — p_line_assign 'Y'/'N' (체크 시 Material 필수 — MSG00290, Phase B 검증) */
  lineAssign: boolean;
  /** Sum 체크 — FE 전용: W_/M_ SUM 컬럼 Visible 토글 (조회 파라미터 아님 — AS-IS chkSum 1:1) */
  sumYn: boolean;
}

// 메인 그리드 행 — SP o_rc1 wide-pivot (고정 binding + D_/W_/M_/B_ 동적 컬럼 index signature).
export type ProductionPlanLineRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc1'>;
