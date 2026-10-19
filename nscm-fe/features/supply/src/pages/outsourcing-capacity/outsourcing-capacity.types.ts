import type { MENU_ID, SHEETS } from './outsourcing-capacity.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. 편집판정/파생에 쓰는 값 컬럼은 GET SP 반환에 포함됨(design 03 §4.1).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리:
//   division(단일·필수) / plantSite(다중 OSP cascade) / model(다건, 팝업) / nickName(LIKE).
export interface SearchCondition {
  divisionId: string;
  plantSiteIds: string[];
  itemId: string; // Model — 개행/콤마 다건 (btnItemId 팝업이 채움)
  nickName: string; // Nick Name — LIKE 검색(p_nick_name)
}
