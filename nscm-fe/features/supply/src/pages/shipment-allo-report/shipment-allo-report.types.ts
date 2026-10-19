// SCP0055 Shipment(Allo) Report — 조회조건/그리드 타입.
// 근거: .atlas/gscm-design/SCP0055/design/02_search-combo.md §1, 03_grid-columns.md §1/§4.

export interface SearchCondition {
  divisionId: string; // OnShown 고정 "40" (design 01 §2 #1)
  operationGroup: string; // OnShown 고정 "A"(Cell) (design 01 §2 #1)
  bucketType: string; // OnShown 고정 Monthly (design 01 §2 #1)
  cellTypeGr: string; // OnShown 고정 "C"(Cyl) (design 01 §2 #1)
  team: string; // clbTeam 다중선택(콤마구분)
  fromSite: string; // clbFromSite 다중선택(콤마구분)
  fcstYn: boolean; // chkFCST → P_FCST_YN
  planDate: string; // cboPlanDate 단일값(YYYYMMDD)
  gapDate: string; // cboGapDate 단일값(YYYYMMDD) — PlanDate index+1 자동 동기화
  fromYyyymm: string; // umpMonthFrom
  toYyyymm: string; // umpMonthTo
  itemId: string; // txtModel_ID(팝업 결과)
  nickName: string; // txtNickName(팝업 결과)
}

// SP Tables[0] — 계획(Plan) raw (design 03 §4.1)
export interface PlanRawRow {
  SITE_NAME: string;
  EXTRA_SPEC: string;
  NICK_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  YYYYMMDD: string;
  QTY: number;
}

// SP Tables[1] — 팀 목록(행 뼈대, design 03 §4.1) — 그리드 row 자체를 결정.
// PLAN_DATE/GAP_DATE/NOTE/PROGRAM_ID/USER_ID 는 GET 응답엔 없고, 저장(useProcMutation) 시
// 동일 response key(o_rc2)를 재사용해 이 필드들을 채운 배열을 보낸다(design 03 §4.3).
export interface TeamRow {
  SITE_NAME: string;
  SITE_ID: string;
  EXTRA_SPEC: string;
  NICK_NAME: string;
  DEPT_ID: string;
  DEPT_NAME: string;
  PLAN_DATE?: string;
  GAP_DATE?: string;
  NOTE?: string;
  PROGRAM_ID?: string;
  USER_ID?: string;
}

// SP Tables[2] — 실적(Result) raw
export interface ResultRawRow {
  SITE_NAME: string;
  EXTRA_SPEC: string;
  NICK_NAME: string;
  DEPT_NAME: string;
  YYYYMMDD: string;
  QTY: number;
}

// SP Tables[3] — Plan Type/Seq(첫 행만 사용)
export interface PlanTypeSeqRow {
  PLAN_TYPE: string;
  SEQ: string;
}

// 비고(NOTE) 단건 조회 응답 — 행 단위 개별 호출(design 03 §4.2, N+1 — 성능 개선 후보로 기록)
export interface NoteRow {
  NOTE: string;
}

// 클라 조립 그리드 행 — 정적 6칼럼(admin 바인딩명) + 동적 pivot(M_yyMM[_RESULT|_PLAN|_TOTAL]) +
// SUBTOTAL/GAP(클라 계산) + 비고(NOTE, 편집대상). 요약행은 IS_SUMMARY=true.
export interface ShipmentAlloRow {
  SITE_ID: string;
  FROM_SITE: string; // = TeamRow.SITE_NAME
  EXTRA_SPEC: string;
  NICK_NAME: string;
  DEPT_ID: string;
  TEAM_NAME: string; // = TeamRow.DEPT_NAME
  NOTE: string;
  SUBTOTAL: number;
  GAP?: number; // Main 탭에만 존재(Main.SUBTOTAL - Gap.SUBTOTAL)
  IS_SUMMARY?: boolean;
  IS_TEAM_BLANK?: boolean; // TEAM_NAME 공백 행 — 비고 배경 LightGray(시각효과만, design 03 §3 #29-부속)
  [key: string]: string | number | boolean | undefined;
}

// 동적 pivot 월 분류 — 실적(Result 1칼럼) / 계획(Plan 1칼럼) / 기준월(Result+Plan+Total 3칼럼)
export const enum PIVOT_KIND {
  RESULT = 'RESULT',
  PLAN = 'PLAN',
  BASE = 'BASE',
}

export interface PivotMonthMeta {
  yyMM: string; // 예: '2409' — 컬럼ID 근간(design 03 §2.2)
  headerLabel: string; // 'yy/MM' 예: '24/09'
  kind: PIVOT_KIND;
}
