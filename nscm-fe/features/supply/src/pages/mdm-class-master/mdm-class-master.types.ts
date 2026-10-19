import type { MENU_ID, SHEETS } from './mdm-class-master.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET 반환 23컬럼(design 03 §4.2).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리: Class ID(text) / Class Name(text) / Use Flag(combo).
export interface SearchCondition {
  classId: string;
  className: string;
  useFlag: string; // 'ALL' | 'Y' | 'N' — ALL 선택 시 GET p_use_flag='' (design 02 §5.2)
}
