// SDM2010 — 화면 전용 타입. 커서 컬럼 구조는 procedures.d.ts SDM2010 블록과 짝을 맞춘다.
import type { MENU_ID, RESPONSE_SET, SHEETS } from './production-request.constants';

export type TreeRow = ResponseData<MENU_ID, SHEETS.TREE, RESPONSE_SET.DATA>;
export type ProcessRow = ResponseData<MENU_ID, SHEETS.PROCESS, RESPONSE_SET.DATA>;
export type DemandRow = ResponseData<MENU_ID, SHEETS.DEMAND, RESPONSE_SET.DATA>;

/** 샘플 현황 Tree 커서 1행 — level1 고객 / level2 프로젝트 / level3 빌드 No. (flat 행 수신) */
// export interface TreeRow {
//   END_CUSTOMER: string;
//   END_CUSTOMER_NAME: string;
//   DPJT_CODE: string;
//   DPJT_NAME: string;
//   DPJT_BUILD_NO: string;
//   /** 진행 샘플 현황 스위치 필터 축 — SP 미확정(설계서 §확인사항 "기능 확인"), 없으면 필터 무시 */
//   PROGRESS_YN?: string;
//   [key: string]: string | number | undefined;
// }

/** 샘플 현황 Process 커서 1행 — ProcessFlow 단계별 건수 */
// export interface ProcessRow {
//   STEP_SEQ: string | number;
//   STEP_NAME: string;
//   CURRENT_CNT: string | number;
//   TOTAL_CNT: string | number;
//   [key: string]: string | number | undefined;
// }

/** 샘플 빌드 커서 1행 — 샘플 빌드 등록 패널(조회 모드) */
export interface BuildRow {
  DPJT_CODE: string;
  STACK_METHOD: string;
  DPJT_BUILD_NO: string;
  DPJT_BUILD_TYPE: string;
  DPJT_BUILD_SEQ: string | number;
  DPJT_BIND_TYPE: string;
  DPJT_BIND_SEQ: string | number;
  NOTE: string;
  [key: string]: string | number | undefined;
}

/** 샘플 빌드 등록 패널 편집 상태 (Insert View — 설계서 GRID LEFT 시트) */
export interface BuildFormState {
  buildType: string; // 빌드 차수 구분 (A/B/…)
  buildSeq: string; // 빌드 차수 Sequence
  bindType: string; // 묶음 차수 구분
  bindSeq: string; // 묶음 차수 Sequence
  note: string; // 특이사항
}

/** 샘플 수요 그리드 1행 — 컬럼은 admin 메타(staticColumns) 100% 주도라 열 하드코딩 금지.
 *  신규 행 키(DPJT_CODE/DPJT_BUILD_NO)와 CRUD_TYPE 만 코드가 직접 만진다. */
// export interface DemandRow {
//   CRUD_TYPE?: string;
//   DPJT_CODE?: string;
//   DPJT_BUILD_NO?: string;
//   [key: string]: string | number | undefined;
// }

/** Tree 에서 선택된 빌드 No. — process/build/demand 조회 필터의 원천 */
export interface SelectedBuild {
  dpjtCode: string;
  dpjtName: string;
  dpjtBuildNo: string;
}
