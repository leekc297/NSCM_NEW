// SCP0039 Master Validation — 타입 정의
//   design: .atlas/gscm-design/SCP0039/design/00_checklist.md ~ 03_grid-columns.md

// 마스터 목록 행 — lookup MASTER_VALIDATION(admin/lookup) pivot 결과.
//   컬럼 라벨은 SCM_ADM_LOOKUP_MASTER 헤더 정의(SEGMENT1->VALIDATION_TYPE, SEGMENT2->SHEET_NAME,
//   SEGMENT4->PROGRAM_ID, SEGMENT5->PROCEDURE_NAME, ATTRIBUTE1->CONSTRAINTS01,
//   ATTRIBUTE2->OPMZ_TGT_DIVISION, ATTRIBUTE3->IMPACT) 로 정해진다(DB 실측).
//   VALIDATION_TYPE = 코드(BOM/PROJECT_ROUTE...) — dispatch 키(대소문자·truncation 불변).
//   SHEET_NAME = 표시명(BOM/Project Route...) — 그리드 "Validation Type" 표시값.
//   COUNT = 조회 결과 건수(클라 파생). PROCEDURE_NAME='-' 행은 조회 불가(Sales Site).
export interface MasterValidationRow {
  VALIDATION_TYPE: string;
  SHEET_NAME: string;
  PROGRAM_ID: string;
  PROCEDURE_NAME: string;
  CONSTRAINTS01: string;
  OPMZ_TGT_DIVISION: string;
  IMPACT: string;
  COUNT: string;
  [key: string]: string | number;
}

// detail(결과) 그리드 행 — 검증유형별 SP 결과셋. 컬럼은 sheetNm 별 SCM_MST_SHEET_COLUMNS 메타 구동.
export type DetailRow = Record<string, string | number>;

// 조회조건(searchParams). planGroupIds 는 다중선택('ALL' sentinel).
export interface SearchParamProps {
  divisionId: string;
  planGroupIds: string[];
  itemId: string;
}
