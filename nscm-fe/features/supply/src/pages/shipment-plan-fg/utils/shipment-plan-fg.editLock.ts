// SHIP_PLAN_AMEND 행 셀단위 편집가능 판정 — AS-IS BlockCellsChecking 이식.
//   근거: .atlas/gscm-design/SCP0009/design/03_grid-columns.md §3.1 R-K (cs:2298-2566 전문).
//   이 화면의 유일한 편집 경로다(§0 — 정보컬럼 80개는 전건 INPUT_TP_CD='S' 읽기전용).
//   AS-IS 는 매 렌더마다 컬럼 배열을 인덱스로 순회해 판정하지만, TO-BE 는 행 렌더 시점에
//   editableColumnRange 를 미리 계산해 O(1) 판정한다(design 03 §3.1 TO-BE 구현 지침).
import { MEASURE } from '../shipment-plan-fg.constants';
import type { PlanStatusRow } from '../shipment-plan-fg.types';

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

// PLAN_TYPE -> 다음 단계 조회용 PLAN_TYPE_SEQ(AS-IS 주석 "PR:0/MA:1/SE:2/FN:3") — PR 이 생성되면
//   plan_type_seq=1(=MA) 가 있는지 보는 식으로 "바로 다음 단계"를 찾는다. SE 의 다음은 FN(3).
const NEXT_PLAN_TYPE_SEQ: Record<string, string> = { PR: '1', MA: '2', SE: '3' };

const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// Plan 전체 편집가능 게이트 — AS-IS GetIsEditable(.cs:3527-3658) 이식. SHIP_PLAN_AMEND 행 단위 날짜
//   판정(위 computeEditableRange)보다 앞서 통과해야 하는 더 상위 게이트다: 더 나중 단계 Plan
//   (PR→MA→SE→FN 순서)이 이미 생성되어 있고 그 PLAN_STATUS 가 '실패'(-1)가 아니면, 현재 선택된
//   (더 이전 단계) Plan 은 전체 잠금된다(= 최신 단계 버전일 때만 입력 가능). rows 는 O_RC2
//   (Weekly/Monthly 조회일 때만 non-empty — SP 의 P_BUCKET 조건). 빈 rows 는 AS-IS 처럼 'N'(L3531)이며,
//   O_RC2 가 비었을 때 판정값을 갱신하지 않고 직전 값을 유지하는 것(cs:1568)은 호출측(그리드)이 맡는다.
//   SP 의 IS_EDITABLE 은 상수 'Y'(PKG_SCP0009 실측 2026-11-23)지만 AS-IS L3544 대로 함께 본다.
export const computeIsEditable = (rows: PlanStatusRow[], curPlanType: string, curPlanSeq: string): boolean => {
  if (rows.length === 0) return false; // L3531 — dtEditable 비어있으면 'N'
  if (str(rows[0].IS_EDITABLE) === 'N') return false; // L3544-3546
  if (curPlanType === 'FN' || curPlanType === 'TE') return false; // L3546 — 최종/임시 단계는 항상 잠금

  const nextSeq = NEXT_PLAN_TYPE_SEQ[curPlanType];
  if (!nextSeq) return false; // PR/MA/SE/FN/TE 외 미지 PLAN_TYPE — AS-IS 도 분기 없이 기본값 'N'

  // 이후 단계가 하나라도 존재하면 상태와 무관하게 잠금 — AS-IS 는 주석상 "-1(실패)이면 수정가능"이지만 코드가
  //   ret='N' 에서 시작해 Y 로 바꾸는 분기가 없어 실제로는 항상 'N'(L3571-3582/3611-3619/3642-3650). 실동작 기준.
  //   AS-IS 코드는 "바로 다음" seq 만 보지만, 81 계열은 SE 없이 MA 다음에 FN 이 생긴다(DB 실측 2026-11-23).
  //   AS-IS 주석 L3560 "FN 모두 수정불가" 의도대로 바로 다음뿐 아니라 이후 단계 전체를 본다(사용자 지시).
  if (rows.some(r => str(r.PLAN_TYPE_SEQ) !== '' && Number(r.PLAN_TYPE_SEQ) >= Number(nextSeq))) return false;

  // 다음 단계 미생성 — PR/SE 는 무조건 Y(190604 PR 확인, SE 는 원래부터 confirm_yn 체크 없음).
  //   MA 만 현재(planType=MA, planSeq=curPlanSeq) 행의 CONFIRM_YN 을 본다(L3622-3631).
  if (curPlanType !== 'MA') return true;
  const current = rows.find(r => r.PLAN_TYPE === 'MA' && str(r.PLAN_SEQ) === curPlanSeq);
  return current?.CONFIRM_YN === 'Y';
};

export interface MainEditContext {
  bucketType: string; // BUCKET_TYPE
  division: string;
  planStartYyyymmdd: string;
  queryFromYyyymmdd: string;
  queryToYyyymmdd: string;
  weekOrMonthStart: Map<string, string>; // binding -> 대표일(yyyymmdd), calendar SP 결과에서 구성
  isEditable: boolean; // computeIsEditable 결과(페이지가 1회 계산해 전달) — false 면 전체 잠금
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

  if (!ctx.isEditable) return false; // computeIsEditable 게이트(AS-IS EditBlockChecking(2)) — 전체 잠금

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
