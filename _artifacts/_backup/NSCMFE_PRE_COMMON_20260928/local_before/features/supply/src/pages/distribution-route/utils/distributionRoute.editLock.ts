// SCP0005 편집잠금 white-list (design 03 §3.2 / §1 편집가능(조건)) + Insert 기본값 (design 03 R6/§4.2).
//   순수 함수 — beginningEdit 에서 셀별 편집가부 판정.
//   NSCM 표준(sister screen SCP0020 TactTime 선례): 그리드는 상시 편집이며 별도 Edit(F2) 토글이 없다.
//   AS-IS M1~M4 의 "조회 후 전체 read-only -> Edit 진입 unlock -> 지정 컬럼 재잠금" 상태머신은
//   "상시 편집 + 아래 항상-잠금 컬럼 white-list" 로 이관한다(design 01 §4 대비 의도적 변경 — 04_react-gap 기록).

type Row = Record<string, unknown>;

// 편집모드라도 항상 잠금(키/파생명/합계/감사) — design 03 §1 "불가"(R3/R4/R5 always-lock 컬럼).
//   ROUTE_ID(PK·서버채번) / FROM_CITY_NAME·TO_CITY_NAME(도시팝업 파생) / LT_SUM(합계 파생) / 감사 4.
export const ALWAYS_LOCKED = new Set<string>([
  'ROUTE_ID',
  'FROM_CITY_NAME',
  'TO_CITY_NAME',
  'LT_SUM',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
]);

// 항상-잠금 외 전 컬럼 편집 가능(design 03 §1 — 나머지 칼럼만 편집 가능).
export const isRouteCellEditable = (binding: string): boolean => !ALWAYS_LOCKED.has(binding);

// Insert 기본값 (design 03 R6 — 신규행 VALID_YN='Y', 나머지 공백. ROUTE_ID 는 저장 시 서버채번).
export const routeInsertDefaults = (): Row => ({ VALID_YN: 'Y' });
