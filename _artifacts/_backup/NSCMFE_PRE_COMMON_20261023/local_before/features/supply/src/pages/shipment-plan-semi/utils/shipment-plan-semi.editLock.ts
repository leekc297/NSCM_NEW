// SHIP_PLAN_AMEND 행 셀단위 편집가능 판정 — AS-IS BlockCellsChecking/BlockCellsChecking_2 이식.
//   근거: .atlas/gscm-design/SCP0010/design/03_grid-columns.md §3.1 R-K (cs:3045-3508 전문).
//   SCP0009 와 분기 조건이 다르다(division 81/81_UC 전용 vs 그 외+Dept Day 등록여부) — 복붙 금지.
//   이 화면의 유일한 편집 경로다(정보컬럼 27개는 전건 INPUT_TP_CD='S' 읽기전용).
import { BUCKET_TYPE, MEASURE } from '../shipment-plan-semi.constants';

export type DynColKind = 'D' | 'W' | 'M';

// o_rc1 응답 키 대소문자 방어 — GET SP(PKG_SCP0010) 의 출력 컬럼 alias 가 2026-10(AJS) 소문자→대문자로
//   바뀌어 이 화면 로직의 소문자 읽기(measure/Dept_Day/division_id 등)가 전부 undefined 가 됐다(편집잠금·
//   저장 payload·회색밴드·INVENTORY 전부 깨짐). cursor o_rc1 대소문자 사건과 동류이고 재변경 이력이 잦아,
//   대문자 우선 + 소문자 폴백으로 양쪽 계약을 견딘다. 읽기 전용 접근자.
export const pickField = (row: Record<string, unknown>, upperKey: string): unknown =>
  row[upperKey] ?? row[upperKey.toLowerCase()];

export const dynColKindOf = (binding: string): DynColKind | null => {
  if (/^D_\d{8}$/.test(binding)) return 'D';
  if (/^W_\d{7,10}$/.test(binding)) return 'W';
  if (/^M_\d{6}$/.test(binding)) return 'M';
  return null;
};

// binding 에서 비교용 yyyymmdd 를 뽑는다. D_ 는 그 자체가 일자, W_/M_ 은 주/월 시작일을
//   calendarWeekStart 맵(design 03 §2.2 BASIS_START_DATE)에서 조회한다 — 없으면 근사치로 폴백한다
//   (shipment-plan-fg.editLock.ts 와 동일한 확인필요 축, W_ 대표일 산정 방식 미상).
export const dynColRepDate = (
  binding: string,
  kind: DynColKind,
  weekOrMonthStart: Map<string, string>
): string => {
  const mapped = weekOrMonthStart.get(binding);
  if (mapped) return mapped;
  if (kind === 'D') return binding.slice(2);
  if (kind === 'M') return `${binding.slice(2, 8)}01`;
  return binding.slice(2, 9); // W_ 는 대표일 미상 — 확인 필요(shipment-plan-fg 동일 이슈)
};

export interface EditableRange {
  from: string; // yyyymmdd(포함)
  to: string; // yyyymmdd(포함)
}

// division 이 81/81_UC(자동차 계열) 인지 — design 03 §3.1 "BlockCellsChecking() 전용" 분기 재현.
export const isDivision81Series = (division: string): boolean => division === '81' || division === '81_UC';

// Weekly "동일 주차 반복 컬럼" 방어 잠금 — AS-IS BlockCellsChecking() 전용(division 81/81_UC 만,
//   .cs:3218-3243, LockRange2 .cs:3447 이 아니라 이 블록이 정본. iter-2 gap-audit SCP0010-G-06
//   이 "재현조건 미상"으로 남긴 항목을 AS-IS 원문 재독으로 확정했다).
//
// 원인: 헤더 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)의 W_ 컬럼은
//   'W_'||BASIS_YYYYMM||ISO_WEEK 로 GROUP BY BASIS_YYYYMM, ISO_WEEK 한다 — 한 ISO 주가 월 경계를
//   걸치면 같은 ISO_WEEK 값(마지막 2자리)을 가진 W_ 컬럼이 연속 2개 생긴다. AS-IS 는 컬럼 Tag의
//   마지막 2자리(ISO_WEEK)가 바로 앞 W_ 컬럼과 같으면(aft_colName==bef_colName) 그 컬럼부터
//   행끝까지 잠그고 배경을 White 로 되돌린다 — "중복 주차"가 아니라 "이후 컬럼 전체를 방어적으로
//   잠근다"는 뜻(.cs:3230 LockRange(..., true) 는 그 컬럼부터 ColumnCount-1 까지 통째로 잠금).
//   division 81/81_UC 가 아니거나 Bucket 이 Weekly 가 아니면 이 로직 자체가 미실행(AS-IS 조건문
//   `cboBucketType==Weekly && (division in 81,81_UC)`, .cs:3218-3219).
//
// weekBindings 는 오름차순(BASIS_START_DATE 순) W_ binding 목록 — 그리드가 dynColMetas 정렬 순서로
//   넘긴다. 반환값은 "이 binding 부터는 잠금"의 시작 binding(첫 중복 발견 지점) — 없으면 null.
export const findDuplicateWeekLockStart = (
  weekBindings: string[] // 오름차순 'W_'+YYYYMM+ISOWEEK
): string | null => {
  let prevSuffix = '';
  for (const binding of weekBindings) {
    const suffix = binding.slice(-2);
    if (suffix !== '' && suffix === prevSuffix) return binding;
    prevSuffix = suffix;
  }
  return null;
};

// SHIP_PLAN_AMEND 행 1건의 편집가능 구간 계산 — division 40/81 은 Plan Date 기준, 그 외는
//   SHIP_FROZEN 기준(design 03 §3.1 blockStartDate). BOD 2단계 구간과의 대소로 2패턴 중 하나 결정.
export const computeEditableRange = (params: {
  division: string;
  shipFrozen: string; // row.SHIP_FROZEN
  bodFromYyyymmdd: string; // row.BOD_FROM_YYYYMMDD(행별, 없으면 조회기간으로 대체)
  bodToYyyymmdd: string; // row.BOD_TO_YYYYMMDD
  planStartYyyymmdd: string; // 조회조건 cboPlanDate 선택값
  queryToYyyymmdd: string; // 조회기간 종료(blockEndLast 패턴의 끝)
}): EditableRange | null => {
  const { division, shipFrozen, bodToYyyymmdd, planStartYyyymmdd, queryToYyyymmdd } = params;

  if (!shipFrozen) return null; // SHIP_FROZEN 비면 전체 잠금

  const blockStartDate = division === '40' || division === '81' || isDivision81Series(division)
    ? planStartYyyymmdd
    : shipFrozen;
  if (!blockStartDate) return null;

  const bodTo = bodToYyyymmdd || queryToYyyymmdd;

  // blockStartDate > bodTo 면 blockEndLast(blockStartDate~조회종료), 그 외는 blockFromTo(blockStartDate~bodTo).
  if (blockStartDate > bodTo) {
    return { from: blockStartDate, to: queryToYyyymmdd };
  }
  return { from: blockStartDate, to: bodTo };
};

export interface MainEditContext {
  bucketType: BUCKET_TYPE;
  division: string;
  planStartYyyymmdd: string;
  queryToYyyymmdd: string;
  // plan-level 편집가능 게이트 — GET SP o_rc2 의 IS_EDITABLE(='Y' 면 편집가능). SP 산출식은
  //   "플랜 시작주(월) < 이번주 월요일 → 'N'"(PKG_SCP0010 L2951) = 과거주 플랜 전면 잠금. AS-IS
  //   Get_IsSaveYn/grid 잠금 상당. 'N' 이면 BlockCellsChecking 통과 여부와 무관하게 전 셀 편집불가.
  planEditable: boolean;
  weekOrMonthStart: Map<string, string>; // binding -> 대표일(yyyymmdd), calendar SP 결과에서 구성
  // Weekly 동일 주차 반복 컬럼 방어(design 03 §6#7, iter-3 확정) — division 81/81_UC 전용
  //   (BlockCellsChecking() 만 이 로직을 가짐, BlockCellsChecking_2 는 없음). calendar SP 결과의
  //   W_ binding 을 BASIS_START_DATE(대표일) 오름차순으로 미리 정렬해 그리드가 넘긴다.
  weekBindingsAsc?: string[];
}

// SHIP_PLAN_AMEND 행 1건의 Dept Day 등록 여부(design 03 §1 #27, §3.1 BlockCellsChecking_2) —
//   'X' = 미등록, 그 외 요일값 = 등록.
export const isDeptDayRegistered = (deptDay: string): boolean => deptDay !== '' && deptDay !== 'X';

// spdMain 셀 1개의 편집가능 여부 — 행렌더 시 계산해 캐시하는 O(1) 판정 함수.
//   요약표(design 03 §3.1):
//   Monthly            -> 전체 잠금
//   Daily              -> D_(구간내), W_/M_ 항상 잠금(전 division)
//   Weekly, 81/81_UC   -> W_(구간내), M_ 잠금, D_ 비노출
//   Weekly, 그외+등록  -> W_(구간내), M_ 잠금, D_ 비노출
//   Weekly, 그외+미등록 -> 전부 잠금(W_/M_ 포함)
export const isMainCellEditable = (
  binding: string,
  row: Record<string, unknown>,
  ctx: MainEditContext
): boolean => {
  if (!ctx.planEditable) return false; // plan-level 게이트 — IS_EDITABLE='N'(과거주 플랜 등)이면 전 셀 잠금
  const kind = dynColKindOf(binding);
  if (!kind) return false; // 정보컬럼(design 03 §0) — 전건 항상 잠금(R-J)

  const measureVal = pickField(row, 'MEASURE');
  const measure = typeof measureVal === 'string' ? measureVal : '';
  if (measure !== MEASURE.SHIP_PLAN_AMEND) return false; // 규칙1 — SHIP_PLAN_AMEND 행만 편집후보

  if (ctx.bucketType === BUCKET_TYPE.MONTHLY) return false; // Monthly — 항상 전체 잠금

  if (kind === 'M') return false; // M_ — 전 Bucket 항상 잠금

  const division = ctx.division;
  const is81 = isDivision81Series(division);
  const deptDayVal = pickField(row, 'DEPT_DAY');
  const deptDay = typeof deptDayVal === 'string' ? deptDayVal : 'X';
  const deptDayOk = isDeptDayRegistered(deptDay);

  if (kind === 'W') {
    if (ctx.bucketType !== BUCKET_TYPE.WEEKLY) return false;
    if (!is81 && !deptDayOk) return false; // 규칙2 — 81계열 아니고 Dept Day 미등록이면 Weekly 전부 잠금
  }
  if (kind === 'D' && ctx.bucketType !== BUCKET_TYPE.DAILY) return false;

  const range = computeEditableRange({
    division,
    shipFrozen: typeof row.SHIP_FROZEN === 'string' ? row.SHIP_FROZEN : '',
    bodFromYyyymmdd: typeof row.BOD_FROM_YYYYMMDD === 'string' ? row.BOD_FROM_YYYYMMDD : '',
    bodToYyyymmdd: typeof row.BOD_TO_YYYYMMDD === 'string' ? row.BOD_TO_YYYYMMDD : '',
    planStartYyyymmdd: ctx.planStartYyyymmdd,
    queryToYyyymmdd: ctx.queryToYyyymmdd,
  });
  if (!range) return false;

  const repDate = dynColRepDate(binding, kind, ctx.weekOrMonthStart);
  if (repDate < range.from || repDate > range.to) return false;

  // Weekly 동일 주차 반복 컬럼 방어(design 03 §3.1 BlockCellsChecking, .cs:3218-3243) — 81/81_UC
  //   전용. 월 경계에 걸친 ISO 주가 W_ 컬럼 2개로 쪼개질 때 두 번째(및 이후 전체 컬럼)를 잠근다.
  if (kind === 'W' && is81 && ctx.weekBindingsAsc && ctx.weekBindingsAsc.length > 0) {
    const lockStart = findDuplicateWeekLockStart(ctx.weekBindingsAsc);
    if (lockStart) {
      const lockStartIdx = ctx.weekBindingsAsc.indexOf(lockStart);
      const thisIdx = ctx.weekBindingsAsc.indexOf(binding);
      if (thisIdx >= 0 && thisIdx >= lockStartIdx) return false;
    }
  }

  return true;
};

// 저장 값 검증(design 03 §4.3, design 00 §4e #4-5).
//   AS-IS MSG00084(TO-BE 미등록, gap-resolve iter-1 실측)는 TO-BE 에서 MSG00225("Quantity must be
//   0 or greater.")로 미러링했다 — 실제 로직(`<0`만 차단, 0 허용)과 문구가 정확히 일치한다.
export const isQtyInRange = (qty: number, min: number, max: number): boolean =>
  Number.isFinite(qty) && qty >= min && qty <= max;

