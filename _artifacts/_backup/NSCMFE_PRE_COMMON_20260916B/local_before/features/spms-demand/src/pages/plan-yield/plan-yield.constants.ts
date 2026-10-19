// SDM2020 화면의 이름표 — 다른 모든 파일이 여기서 import 한다.

// 화면 고유 ID. BE API 경로(/admin/menu/SDM2020/column)와 procedures.d.ts 의 RawProcedureMap 키의 기준.
export const MENU_ID = 'SDM2020' as const;
export type MENU_ID = typeof MENU_ID;

// SDM2020 계획수율 (샘플 수요 > 샘플제작 요청 > 계획수율 — ROUTE_PATH 'spms-demand/plan-yield').
//   ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM2020/계획수율_20260828.xlsx`(UI 목업 5시트) +
//     `테이블 명세_v1.0_20260828.xlsx` + 사내 DB PKG_SDM2020 실측 (화면설계서 없음 — AS-IS 부재).
//     정오표 = `Doc/화면분석서/SDM2020_PlanYield_정오표.md`.
//   조회조건(SearchArea) 없음 — 좌측 샘플 현황 Tree(SDM2010 공유)의 빌드 No. 선택이 곧 조회 트리거.
//   구성 = Tree + ProcessFlow(SDM2010 공유) + [1. 샘플 요청 법인] 패널(빌드 헤더 + 공정별 요청법인
//     그리드 + 저장 + 진행률) + [2. 수율/Loss 계획 점검] 그리드(선택 공정 기준 — 확정/Excel).
//   ⚠ 요청법인 패널 (2026-09-03): 조회 = build 시트 2번째 커서 'plant'(P_SDM2020_GET_PJT_SAMPLE_BUILD
//     O_PLANT_CURSOR), 저장 = P_SDM2020_SAVE_PJT_SAMPLE_BUILD (P_OPERATION_ID '^' 전달 시 요청법인 저장 모드).
//     수율/Loss 그리드 (2026-09-04): 조회 = P_SDM2020_GET_PJT_YIELD (SPMS_YIELD_TABLE 템플릿 + DTL LEFT JOIN),
//     확정 = P_SDM2020_SAVE_PJT_YIELD (선택 공정 단위 DELETE 후 INSERT). 선택 공정 키 = 법인+그룹+양음극+공정.

// 서버로 보낼 sheet 이름 — PROC_M/API_ID 시트 토큰 = 이 값 (04_META §[5]/[6])
export enum SHEETS {
  TREE = 'tree',
  PROCESS = 'process',
  BUILD = 'build',
  PLANT = 'plant',
  YIELD = 'yield',
}

// 커서명 (PROC_M 등재 — SDM2010 RESPONSE_SET 용법 동일). 'plant' 는 build 시트 2번째 커서
export enum RESPONSE_SET {
  DATA = 'data',
  PLANT = 'plant',
}

// 버튼 BTN_CD (SCM_ADM_MNU_BTN_MPG_M — 04_META §[6]. SEARCH/EXCEL/FILTER/SORT 는 공통 버튼)
export const BTN = {
  /** 샘플 요청 법인 저장 — PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_BUILD ('^' 벌크 1건 replace-set) */
  SAVE_PLANT: 'SAVEPLANT',
  /** 수율/Loss 계획 확정 — PKG_SDM2020.P_SDM2020_SAVE_PJT_YIELD ('^' 벌크 1건, 선택 공정 replace-set) */
  CONFIRM: 'CONFIRM',
} as const;

// 본 화면이 담당하는 프로세스 단계 코드 (lookup SPMS_DPJT_BUILD_PROCESS — ProcessFlow 선택 표시)
export const CURRENT_PROCESS = 'PLAN_YIELD' as const;

// MSG 매핑 — 재사용 6 + 신규 3 (채번 = 패키지 _CONTRACT.md §3. MSG01024~01026 — DB 실측 MAX MSG01023)
export const MSG = {
  SAVE_CONFIRM: 'MSG00001', // 저장 confirm
  SAVED: 'MSG00002', // 저장 성공 (toast)
  SAVE_FAIL: 'MSG00003', // 저장 실패
  NO_CHANGES: 'MSG00004', // 수정된 내용 없음 (EVENT 0 허위성공 방지 겸용)
  NO_SELECTION: 'MSG00014', // 선택 항목 없음 (확정 대상 공정 미선택)
  PENDING_SEARCH_CONFIRM: 'MSG00703', // 수정 pending 중 Tree 이동/공정 전환 confirm
  CONFIRM_CONFIRM: 'MSG01024', // 계획수율 확정 confirm (신규)
  CONFIRM_DONE: 'MSG01025', // 계획수율 확정 성공 (toast — 신규)
  CONFIRM_FAIL: 'MSG01026', // 계획수율 확정 실패 (신규)
} as const;

// LBL 매핑 — 재사용 6 + 신규 (채번 = _CONTRACT.md §3. LBL01031~ — DB 실측 MAX LBL00395)
export const LBL = {
  DPJT_CODE: 'LBL01024', // D-PJT 코드
  STACK_METHOD: 'LBL01025', // 공법 (목업 '공법' = Stack 공법)
  BUILD_NO: 'LBL01026', // 빌드 차수
  NOTE: 'LBL01027', // 특이사항
  SAVE: 'LBL00395', // 저장
  CONFIRM: 'LBL01034', // 확정 (Confirm — 신규 채번)
  REQUEST_PLANT_TITLE: 'LBL01031', // 1. 샘플 요청 법인 (신규)
  YIELD_TITLE: 'LBL01032', // 수율/Loss 계획 점검 (신규 — 앞에 선택 공정명 결합)
  PROGRESS: 'LBL01033', // 진행률 (신규)
} as const;

// SHEET_COLUMNS ATTRIBUTE1 값 — 세로 병합 대상 컬럼 표식 (컬럼명 배열 하드코딩 금지 → 메타 주도)
export const MERGE_ATTR = 'MERGE' as const;

// 요청법인 패널 바인딩 (구분 단위 확인 토글 축 + 수율/Loss 그리드 조회 트리거 — 이 셀 선택만 조회, 행 다른 셀은 무시).
//   구분 = 표시명 — OPERATION_GROUP 코드는 양극/음극이 같은 'E'
export const PLANT_GROUP_BINDING = 'OPERATION_GROUP_NAME' as const;
export const PLANT_CONFIRM_BINDING = 'CONFIRM_FLAG' as const;
// 공정 컬럼 (조회 트리거 아님 — 2026-09-04 사용자 확정: 트리거는 PLANT_GROUP_BINDING 만)
export const PLANT_OPERATION_BINDING = 'OPERATION_NAME' as const;

// 수율 그리드 바인딩 (그룹 헤더행·단위·선택 축 — 커서 계약 procedures.d.ts SDM2020.yield)
export const YIELD_IS_GROUP_BINDING = 'IS_GROUP' as const;
export const YIELD_UOM_BINDING = 'UOM' as const;
export const YIELD_CHECK_BINDING = 'CHECKED_FLAG' as const;
export const YIELD_GROUP_FLAG = 'Y' as const;
export const PERCENT_UOM_MARK = '%' as const;
