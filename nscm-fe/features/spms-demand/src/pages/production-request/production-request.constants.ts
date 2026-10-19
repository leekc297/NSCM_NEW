// SDM2010 화면의 이름표 — 다른 모든 파일이 여기서 import 한다.

// 화면 고유 ID. BE API 경로(/admin/menu/SDM2010/column)와 procedures.d.ts 의
// RawProcedureMap 키의 기준이 된다.
export const MENU_ID = 'SDM2010' as const;
export type MENU_ID = typeof MENU_ID;

// SDM2010 Production Request (샘플 수요 > 샘플제작 요청 > 생산 요청 — ROUTE_PATH
// 'spms-demand/production-request').
//   ⭐ 정본 원천 = 화면설계서 `Doc/화면설계서_SDM/SDM2010_ProdReq_화면설계서_20260824.xlsx`
//     (AS-IS GSCM 대응 화면 부재 — 순수 신규).
//   조회조건(SearchArea) 없음 — 좌측 샘플 현황 Tree 의 빌드 No. 선택이 곧 조회 트리거다.
//   구성 = Tree(샘플 현황) + ProcessFlow(샘플 현황 Process) + 샘플 빌드 등록 패널(조회/편집 모드)
//     + 샘플 수요 등록 그리드(Insert/Delete/Save).
//   SP 4본 = PKG_SDM2010 (P_SDM2010_GET_PJT_SAMPLE_TREE / GET_PJT_SAMPLE_PROCESS /
//     GET_PJT_SAMPLE_BUILD / SAVE_PJT_SAMPLE_BUILD).
//   ⚠ 설계서 정오 메모(개발 중 확정 필요):
//     - 샘플수요등록 시트의 조회 프로시저가 Tree SP(P_SDM2010_GET_PJT_SAMPLE_TREE)로 적혀 있음
//       (복붙 정황) — 수요 그리드 전용 GET/SAVE SP 는 시트명 'demand' 로 PROC_M 등재 시 확정.
//     - SAVE_PJT_SAMPLE_BUILD 의 IN 파라미터에 P_DPJT_BUILD_SEQ 가 2회(빌드/묶음) 등장 —
//       묶음 차수는 P_DPJT_BIND_SEQ 오기로 보고 bindSeq 로 전달한다.

// 서버로 보낼 sheet 이름(요청). PROC_M(API_ID 시트 토큰) 등재 기준 — 화면설계서 시트와 1:1:
//   TREE(샘플현황/샘플수요등록 시트) / PROCESS(Process 시트) / BUILD(샘플빌드등록 시트) /
//   DEMAND(샘플수요등록 그리드 — SP 미확정, 위 정오 메모).
export enum SHEETS {
  TREE = 'tree',
  PROCESS = 'process',
  BUILD = 'build',
  DEMAND = 'demand',
}

// 커서명 'data' (PROC_M 실등재 — SDM1020/SDM5010 RESPONSE_SET 용법 동일)
export enum RESPONSE_SET {
  DATA = 'data',
}

// 버튼 BTN_CD (SCM_ADM_MNU_BTN_MPG_M — 03_META §[6])
export const BTN = {
  /** 샘플 빌드 저장 — PKG_SDM2010.P_SDM2010_SAVE_PJT_SAMPLE_BUILD (단건 call-proc) */
  SAVE_BUILD: 'SAVEBUILD',
  /** 샘플 수요 저장 — PKG_SDM2010.P_SDM2010_SAVE_PJT_SAMPLE_DEMAND
   *  (⭐ 행별 단건 call-proc — SDM1020 확정 계보: '^' bulk join 금지) */
  SAVE_DEMAND: 'SAVE',
} as const;

// 본 화면이 담당하는 프로세스 단계 코드 (lookup SPMS_DPJT_BUILD_PROCESS — ProcessFlow 선택 표시)
export const CURRENT_PROCESS = 'PROD_REQ' as const;

// 빌드 차수 편집 모드 드롭다운 lookup 타입 (SCM0001_GET_LOOKUP_VALUES 도메인 — SDM1020 LOOKUP
//   소비 패턴 동일). ⚠ 설계서에 도메인 미기재 — lookup 원장 등재 시 타입명 확정 필요.
export const LOOKUP = {
  BUILD_TYPE: 'SPMS_DPJT_BUILD_TYPE', // 빌드 차수 구분 (A/B/…)
  BIND_TYPE: 'SPMS_DPJT_BIND_TYPE', // 묶음 차수 구분
} as const;

// MSG 매핑 — 전부 기존 코드 재사용 (설계서 메시지 코드 시트 미기재 — 신규 채번 없음)
export const MSG = {
  SAVE_CONFIRM: 'MSG00001', // 저장 confirm
  SAVED: 'MSG00002', // 저장 성공 (toast)
  SAVE_FAIL: 'MSG00003', // 저장 실패
  NO_CHANGES: 'MSG00004', // 수정된 내용 없음
  REQUIRED_INPUT: 'MSG00013', // 필수값 입력
  NO_SELECTION: 'MSG00014', // 선택 항목 없음
  PENDING_SEARCH_CONFIRM: 'MSG00703', // 수정 pending 중 재조회/트리 이동 confirm
} as const;

// 수요 그리드 신규 행에 심는 키 컬럼 (Tree 선택 정보 — SAVE SP IN 파라미터 원천)
export const DEMAND_KEY_BINDINGS = {
  DPJT_CODE: 'DPJT_CODE',
  DPJT_BUILD_NO: 'DPJT_BUILD_NO',
} as const;
