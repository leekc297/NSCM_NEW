import type { MENU_ID, SHEETS } from './scp-if-blocking.constants';

// GET 반환행 — procedures.d.ts(SSOT) 기반. SCM0019 는 생성 SSOT 에 아직 없어(PKG_SCM0019 미배포)
//   Base index-signature 로 loose 해석된다(자매 SSP0020 Delegate 선례와 동일 — 생성 파일은 건드리지
//   않는다, convert-core §2.2 Hard Boundary). design 03 §1: DIVISION_ID / PLAN_START_YYYYMMDD(키·잠금)
//   + FP_TARGET_YN / MRP_TARGET_YN / DM_RTF_YN(YesOrNo 셀콤보, 편집).
export type ScpIfBlockingRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 입력값 (design 02 §5): clbDivision(다중 체크) + drpPeriod(From/To, YYYYMMDD).
export interface ScpIfBlockingSearch {
  divisionIds: string[]; // 체크된 Division CODE (CSV 로 p_division_id 전송, 비필수)
  fromYyyymmdd: string; // 기간 시작 (p_from_yyyymmdd, 필수)
  toYyyymmdd: string; // 기간 종료 (p_to_yyyymmdd, 필수)
}
