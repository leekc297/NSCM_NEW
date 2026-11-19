// 그리드 행 · 셀 판정 유틸 — measure 묶음 키, 범위 초과 칸, 정적 칸 배경, 편집 가능 사업부.

// ===== measure 묶음 키 =====
// measure 그룹 식별 키 (SP GROUP BY = 아래 9키 + YYYYMMDD). PIVOT 결과는 행마다 키 컬럼 보유.
//   공용: 저장 payload 구성(siblingsOf) · 저장 후 스크롤 대상 탐색 · 그리드 기존행 실시간 형제 환율 재계산.
export const KEY_COLS = [
  'DIVISION_ID',
  'PROJECT_CODE',
  'SCM_SITE_ID',
  'PLANT_SITE_ID',
  'ITEM_ID',
  'CURRENCY',
  'DOM_EXP',
  'FCST_TYPE',
  'INCOTERMS',
] as const;

// no-base-to-string 회피: unknown 값을 안전하게 string 으로 (null/undefined → '').
export const toStr = (v: unknown): string => (v == null ? '' : String(v as string | number));

export const groupKeyOf = (r: Record<string, unknown>): string =>
  KEY_COLS.map(k => toStr(r[k])).join('|');

// 편집 전(조회 시점) 통화 기준 묶음 키. originals = EditTracker 가 그 행에 보관한 원본값.
//   기존 행 Currency 를 바꾸면 저장 전까지 현재 통화가 이웃 묶음과 같아질 수 있다(JPY 묶음을 USD 로 바꾸면
//   원래 USD 묶음과 groupKeyOf 가 같아진다). 그 상태에서 현재 값으로 형제를 찾으면 두 묶음이 섞여
//   KRW·USD 가 두 번씩 전송되고 저장 SP 가 통화 중복으로 거부한다. 원래 통화로 묶음을 가른다.
export const originalGroupKeyOf = (
  r: Record<string, unknown>,
  originals?: Record<string, unknown>
): string =>
  KEY_COLS.map(k =>
    toStr(k === 'CURRENCY' && originals && 'CURRENCY' in originals ? originals.CURRENCY : r[k])
  ).join('|');

// ===== 범위 초과 칸 (COL_LIST) =====
// AS-IS DMF0020_SalesFuturePrice.cs L1475~1488 [PJ20200138] "범위를 초과하는 YYYYMMDD"
//
//   string sColList = siMain.GetValue(iRow, ...ColList);        // "W_20260803,W_20260810,..."
//   foreach (col in sColList.Split(','))
//       siMain.SetBGColor2(iRow, iResultCol, iRow, iResultCol, Color.Pink);
//
// COL_LIST 는 SP(DMF0020_GET_SCM_MST_FUTURE_PRICE)가 P_OVER_RANGE='Y'(조회조건 Search over range)
// 일 때만 채운다. 판정은 LOC measure 기준으로 인접 주차 판가와 비교해
// |차이| > 기준가 x LIMIT_VAL(룩업 SALES_PRICE_RANGE_RATE 의 division 별 배율) 인 주차,
// 그리고 매출계획(DM_PLN_SALES_PLAN)이 있는 주차다.
//
// 주의: SP 의 LISTAGG GROUP BY 에 MEASURE 가 없다. 같은 품목(div/project/site/plant/item/
//   currency/domExp/fcstType/incoterms)의 4개 measure 행이 동일한 COL_LIST 를 받으므로
//   행마다 그대로 칠하면 AS-IS 처럼 4행이 통째로 분홍이 된다. FE 에서 별도 전파 로직 불필요.

// SP 가 "대상 없음"을 내려주는 표기 (standalone SP L835/L853 의 '-' 상수 분기).
const EMPTY_MARK = '-';

const parse = (raw: string): Set<string> => {
  const trimmed = raw.trim();
  if (trimmed === '' || trimmed === EMPTY_MARK) return new Set();
  return new Set(
    trimmed
      .split(',')
      .map(s => s.trim())
      .filter(s => s !== '' && s !== EMPTY_MARK)
  );
};

// formatItem 은 셀 하나당 한 번씩 호출된다. 행을 키로 파싱 결과를 캐시해 재파싱을 막는다.
//   (COL_LIST 문자열이 바뀌면 다시 파싱 - 재조회로 같은 행 객체가 갱신되는 경우 대비.)
const cache = new WeakMap<object, { raw: string; cols: Set<string> }>();

const EMPTY: Set<string> = new Set();

/** 행의 COL_LIST 를 파싱한 "범위 초과" 동적 컬럼 binding 집합. */
export const overRangeColsOf = (row: object | undefined | null): Set<string> => {
  if (!row) return EMPTY;
  const raw = (row as { COL_LIST?: unknown }).COL_LIST;
  if (typeof raw !== 'string') return EMPTY;

  const hit = cache.get(row);
  if (hit && hit.raw === raw) return hit.cols;

  const cols = parse(raw);
  cache.set(row, { raw, cols });
  return cols;
};

/** 해당 셀(행 x 동적 컬럼 binding)이 "범위 초과" 대상인지. */
export const isOverRangeCell = (row: object | undefined | null, binding: string): boolean =>
  overRangeColsOf(row).has(binding);

// ===== 정적 칸 배경 =====
// DMF0020 정적 컬럼 셀 배경 적용 (formatItem 전용).
//
// ⭐ 인라인 !important 금지 (2026-07-28) — Wijmo 는 셀의 선택 상태 클래스
//   (`wj-state-selected` / `wj-state-multi-selected`)를 className 에 실은 뒤 formatItem 을 호출한다.
//   인라인 !important 는 모든 스타일시트 !important 를 이기므로, formatItem 에서 배경을
//   인라인 !important 로 칠하면 foundation 의 선택 규칙
//   `.wj-cells .wj-cell.wj-state-selected { background:#b4faef !important }` (_grid.scss)이 무력화되어
//   INSERT 행 셀을 클릭해도 하늘색 포커스가 표시되지 않는다(사용자 보고: User 화면과 동작 불일치).
//   → 노란색(INSERT 편집셀)은 클래스로만 칠한다. `.grid :global(.is-insert-editable)` (specificity 0,2,0)이
//     모듈/전역 single-class 규칙(0,1,0)을 이기고, 선택 규칙(0,3,0)에는 지도록 설계됨.
//   → 개인화 Cell Color(동적 값이라 클래스화 불가)는 인라인으로 두되 priority 를 붙이지 않아
//     선택 규칙(!important)이 이기게 한다.
//   우선순위: 선택(하늘색) > INSERT 편집셀 Yellow > 개인화 Cell Color > 기본(제거).
export const applyStaticCellBackground = (
  cell: HTMLElement,
  { editableForInsert, cellColor }: { editableForInsert: boolean; cellColor?: string }
): void => {
  // INSERT 편집셀 Yellow 는 클래스(is-insert-editable / wj-cell-editable)가 담당 — 인라인 미사용.
  if (editableForInsert || !cellColor) {
    cell.style.removeProperty('background-color');
    return;
  }
  cell.style.setProperty('background-color', cellColor);
};

// ===== 편집 가능 사업부 =====
// DMF0020 편집가능 Division 판정 (메타/LOOKUP 구동 — 하드코딩 division 리터럴 제거).
//   원천 = CMBO 'SalesFuturePriceEditableDivision'(lookup DM_EDITABLE_DIVISION_ALLOW, SEGMENT1='DMF0020').
//   현행 업무규칙: 82(Power Tool)만 편집 가능. 40/81/81_UC/81_HM/81_ST/81_HD/81_HG = 편집제약.
//   정확일치 멤버십 — 미등재 division(81 계열 전부)은 자동 제약. (DMF0003 mkt-fcst.division.isEditableDivision 동등,
//   master 피처는 demand cross-import 금지로 로컬 사본.)
export const isEditableDivision = (divisionId: string, editableSet: ReadonlySet<string>): boolean =>
  editableSet.has((divisionId ?? '').trim());
