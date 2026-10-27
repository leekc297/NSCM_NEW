import type { MENU_ID, SHEETS } from './scp-bom-elec.constants';

// 그리드 행 — procedures.d.ts(SSOT)에 SCP0097 미생성 상태라 Base index fallback(WijmoRowItem)으로 해석된다
//   (자매 SCP0053 scp-bom 동일 방식). O_RC1 13필드(design 03 §1)는 Record 접근 헬퍼로 읽는다.
export type ScpBomElecRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 3행:
//   Division(단일, 필수, 기본 '81') / Parent Item / Child Item(멀티라인 텍스트, 콤마 다중).
export interface SearchCondition {
  divisionId: string; // 단일·필수 (R1)
  parentId: string; // 멀티라인 → 콤마 다중, 공백=전체
  childId: string; // 멀티라인 → 콤마 다중, 공백=전체
}
