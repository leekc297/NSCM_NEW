import type {
  DYNAMIC_SUB_COLUMNS,
  MENU_ID,
  RESPONSE_SET,
  SHEETS,
} from './constraint-mgmt.constants';

export type MasterRow = ResponseData<MENU_ID, SHEETS.LOOKUP_MASTER, RESPONSE_SET.SAVE>;
export type DetailRow = ResponseData<MENU_ID, SHEETS.LOOKUP_DETAIL, RESPONSE_SET.SAVE>;

/** 동적 3축 대상 컬럼 25개. Main·Sub 양쪽의 키라 인덱싱에 그대로 쓸 수 있다. */
export type DynamicSubColumn = (typeof DYNAMIC_SUB_COLUMNS)[number];

/**
 * 조회조건 3건 (design 02 §1). Plan Group 은 서버 파라미터가 없고 FE 클라 필터 전용이라
 * payload 로 나가지 않는다 — 값 축도 CODE 가 아니라 NAME 이다(§2 #2).
 */
export interface SearchParamProps {
  /** 부분일치(LIKE contains). 빈 값 = 전건. 'ALL' 로 치환 금지 — SP 가 리터럴로 받아 0행이 된다. */
  lookupType: string;
  /** Plan Group NAME 목록. 빈 배열 = "필터 없음" 이 아니라 "내 Owner 전체"다. */
  planGroupNames: string[];
  /** 'Y' | 'N' | 'ALL'. payload 로 나갈 때 'ALL' -> '' 로 바꾼다. */
  validYn: string;
}
