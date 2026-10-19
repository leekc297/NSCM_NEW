// SHIP_PLAN_AMEND 행 셀단위 편집가능 판정 — AS-IS BlockCellsChecking 이식.
//   근거: .atlas/gscm-design/SCP0009/design/03_grid-columns.md §3.1 R-K (cs:2298-2566 전문).
//   이 화면의 유일한 편집 경로다(§0 — 정보컬럼 80개는 전건 INPUT_TP_CD='S' 읽기전용).
//   AS-IS 는 매 렌더마다 컬럼 배열을 인덱스로 순회해 판정하지만, TO-BE 는 행 렌더 시점에
//   editableColumnRange 를 미리 계산해 O(1) 판정한다(design 03 §3.1 TO-BE 구현 지침).
import { MEASURE } from '../shipment-plan-fg.constants';

export type DynColKind = 'D' | 'W' | 'M';

export const dynColKindOf = (binding: string): DynColKind | null => {
  if (/^D_\d{8}$/.test(binding)) return 'D';
  if (/^W_\d{7,10}$/.test(binding)) return 'W';
  if (/^M_\d{6}$/.test(binding)) return 'M';
  return null;
};

// binding 에서 비교용 yyyymmdd 를 뽑는다. D_ 는 그 자체가 일자, W_/M_ 은 주/월 시작일을
//   calendarWeekStart 맵(design 03 §2.2 BASIS_START_DATE)에서 조회한다 — 없으면 binding 의 앞 8자리
//   숫자(YYYYMMDD 근사)로 폴백한다(확인 필요 — W_/M_ 대표일 산정 방식은 design 문서가 명시하지 않음).
export const dynColRepDate = (
  binding: string,
  kind: DynColKind,
  weekOrMonthStart: Map<string, string>
): string => {
  const mapped = weekOrMonthStart.get(binding);
  if (mapped) return mapped;
  if (kind === 'D') return binding.slice(2);
  if (kind === 'M') return `${binding.slice(2, 8)}01`;
  return binding.slice(2, 9); // W_ 는 대표일 미상 — 확인 필요
};

export interface EditableRange {
  from: string; // yyyymmdd(포함)
  to: string; // yyyymmdd(포함)
}

// division 에 '81' 포함(81/81_UC 등) 여부 — design 03 §3.1 "division에 81 포함" 조건 재현.
export const isDivision81Series = (division: string): boolean => division.includes('81');

// 'YYYY-MM-DD'/'YYYYMMDD' 를 'YYYYMMDD' 로 통일한다. 8자리 날짜가 아니면('-', 빈 값 등) 빈 문자열.
//   SP 는 SHIP_FROZEN 을 'YYYY-MM-DD' 로, 없는 BOD 를 '-' 로 준다(PKG_SCP0009). AS-IS 는 SHIP_FROZEN 을
//   ToDateTime 으로(cs:2369), BOD 는 길이 8 검사로(cs:2323/2332) 읽는다.
export const toYyyymmdd = (v: unknown): string => {
  const digits = typeof v === 'string' ? v.replace(/-/g, '') : '';
  return /^\d{8}$/.test(digits) ? digits : '';
};

// SHIP_PLAN_AMEND 행 1건의 편집가능 구간 계산 (design 03 §3.1 blockStartDate/BOD 3패턴).
//   반환 null = 전체 잠금(SHIP_FROZEN 없음, 또는 이 행이 편집대상 Measure 가 아님/상위에서 이미 배제).
export const computeEditableRange = (params: {
  division: string;
  shipFrozen: string; // row.SHIP_FROZEN
  bodFromYyyymmdd: string; // row.BOD_FROM_YYYYMMDD (행별, 없으면 조회기간으로 대체)
  bodToYyyymmdd: string; // row.BOD_TO_YYYYMMDD
  planStartYyyymmdd: string; // 조회조건 cboPlanDate 선택값
  queryFromYyyymmdd: string; // 조회기간 시작(BOD 없을 때 대체)
  queryToYyyymmdd: string; // 조회기간 종료(blockEndLast 패턴의 끝)
}): EditableRange | null => {
  const {
    division,
    shipFrozen,
    bodFromYyyymmdd,
    bodToYyyymmdd,
    planStartYyyymmdd,
    queryFromYyyymmdd,
    queryToYyyymmdd,
  } = params;

  if (!shipFrozen) return null; // L2360-2366 — SHIP_FROZEN 비면 전체 잠금

  // L2377-2383 — division 81계열/40은 BOD 3-way 분기(L2386-2408, else 블록) 자체를 타지 않고
  //   sBlockType 기본값("blockEndLast")이 그대로 유지된다 — 즉 BOD_TO_YYYYMMDD 와 무관하게
  //   planStartDate ~ 조회기간 끝까지 항상 편집 가능하다(gap-resolve iter-1 NEW5: 이전 구현은
  //   이 분기에도 BOD_TO 비교를 적용해 81/40에서 편집 가능 구간이 부당하게 좁아지는 결함이 있었다).
  if (isDivision81Series(division) || division === '40') {
    if (!planStartYyyymmdd) return null;
    return { from: planStartYyyymmdd, to: queryToYyyymmdd };
  }

  // L2386-2408 — 그 외 division 은 frozenDate/BOD 3-way 비교로 blockStartDate·구간을 재계산한다.
  //   1) frozenDate >= bodTo            → blockEndLast(frozenDate ~ 조회종료)
  //   2) bodFrom >= frozenDate          → blockFromTo(bodFrom ~ bodTo)
  //   3) bodFrom <= frozenDate <= bodTo → blockFromTo(frozenDate ~ bodTo)
  // case 2/3 은 AS-IS 가 `GetColumnIndex("D_"+bodTo)<0`(그리드에 그 날짜 컬럼이 없음, 즉 bodTo 가
  //   조회기간 밖)이면 blockEndLast 로 강등한다(L2398-2399/2405-2406) — bodTo 가 조회기간을
  //   벗어나면 컬럼 자체가 없어 "bodTo 까지"가 무의미하므로 조회기간 끝까지로 넓힌다.
  // BOD 가 없으면(빈 값 — 호출부가 '-' 를 빈 값으로 정규화) AS-IS 대체값을 쓴다:
  //   bodFrom = 플랜 시작일 plantDdate(L2329), bodTo = 조회 종료일 periodTo(L2338).
  const bodFrom = bodFromYyyymmdd || planStartYyyymmdd;
  const bodTo = bodToYyyymmdd || queryToYyyymmdd;

  if (shipFrozen >= bodTo) {
    return { from: shipFrozen, to: queryToYyyymmdd };
  }
  const from = bodFrom >= shipFrozen ? bodFrom : shipFrozen;
  const bodToHasColumn = bodTo >= queryFromYyyymmdd && bodTo <= queryToYyyymmdd;
  return { from, to: bodToHasColumn ? bodTo : queryToYyyymmdd };
};

export interface MainEditContext {
  bucketType: string; // BUCKET_TYPE
  division: string;
  planStartYyyymmdd: string;
  queryFromYyyymmdd: string;
  queryToYyyymmdd: string;
  weekOrMonthStart: Map<string, string>; // binding -> 대표일(yyyymmdd), calendar SP 결과에서 구성
}

// spdMain 셀 1개의 편집가능 여부 — 행렌더 시 계산해 캐시하는 O(1) 판정 함수.
export const isMainCellEditable = (
  binding: string,
  row: Record<string, unknown>,
  ctx: MainEditContext
): boolean => {
  const kind = dynColKindOf(binding);
  if (!kind) return false; // 정보컬럼(§0) — 전건 항상 잠금(R-J)

  const measure = typeof row.MEASURE === 'string' ? row.MEASURE : '';
  if (measure !== MEASURE.SHIP_PLAN_AMEND) return false; // 규칙1 — SHIP_PLAN_AMEND 행만 편집후보

  // W_/M_ SUM 컬럼은 판정과 무관하게 항상 잠금(design 03 §3.1) — M_ 은 전 Bucket 에서 항상 잠금,
  //   W_ 는 Bucket=Weekly + 81계열일 때만 편집후보(그 외 Bucket 조합은 전부 잠금).
  if (kind === 'M') return false;
  if (kind === 'W') {
    if (ctx.bucketType !== 'WEEKLY') return false;
    if (!isDivision81Series(ctx.division)) return false; // 규칙2 — 81계열만 Weekly 편집 허용
  }
  if (kind === 'D' && ctx.bucketType !== 'DAILY') return false;

  const range = computeEditableRange({
    division: ctx.division,
    shipFrozen: toYyyymmdd(row.SHIP_FROZEN),
    bodFromYyyymmdd: toYyyymmdd(row.BOD_FROM_YYYYMMDD),
    bodToYyyymmdd: toYyyymmdd(row.BOD_TO_YYYYMMDD),
    planStartYyyymmdd: ctx.planStartYyyymmdd,
    queryFromYyyymmdd: ctx.queryFromYyyymmdd,
    queryToYyyymmdd: ctx.queryToYyyymmdd,
  });
  if (!range) return false;

  const repDate = dynColRepDate(binding, kind, ctx.weekOrMonthStart);
  return repDate >= range.from && repDate <= range.to;
};

// 저장 값 검증(design 03 §4.3, design 00 §4e #10-11 — MSG00084/MSG00317).
//   주의: MSG00084 문구는 "0보다 큰 정수"이나 AS-IS 실제 로직은 `<0` 만 차단(0 허용) — 문구/로직
//   불일치를 그대로 재현한다(§6#10, 사용자 확인 전까지 AS-IS 동작 우선 — 임의 정정 금지).
export const isQtyInRange = (qty: number, min: number, max: number): boolean =>
  Number.isFinite(qty) && qty >= min && qty <= max;
