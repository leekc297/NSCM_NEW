import type { MENU_ID, SHEETS } from './scp-bom.constants';

// 그리드 행 — procedures.d.ts(SSOT)에 SCP0053 미생성 상태라 Base index fallback(WijmoRowItem)으로 해석된다
//   (자매 SCP0037 operation-lt 동일 방식). o_rc 20필드(design 03 §4.1)는 Record 접근 헬퍼(s())로 읽는다.
export type ScpBomRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 7행:
//   Division(단일, '81' 고정) / PlantSite(다중) / Model·Parent·Child(텍스트 단일값) / AlterBOM(체크박스).
export interface SearchCondition {
  divisionId: string; // '81' 고정 (R7)
  plantSiteIds: string[]; // 다중 — 전체선택 시 NULL(빈 문자열) 전달
  modelId: string;
  parentId: string;
  childId: string;
  alterBom: boolean; // 기본 false → 'ALL', true → 'ALTER'
}
