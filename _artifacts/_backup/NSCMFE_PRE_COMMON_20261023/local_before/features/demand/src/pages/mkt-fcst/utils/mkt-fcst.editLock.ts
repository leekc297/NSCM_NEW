// ⭐ DMF0003 Phase 2b — 편집/잠금 Matrix(measure × bucket × division × date) + 과거 cutoff 산출
//   (보강스펙 §1/§5/§6/§7). 근거: AS-IS DMF0003_MktFcst.cs
//     L857  이번주 월요일 sYYYYMMDD(과거 cutoff 기준)
//     L862~1019 1차 컬럼 cutoff 루프 — bucket(Daily=D_/Weekly=W_+현재월 M_/Monthly=현재월 M_)·
//               division(40 Monthly 8주 L974~981) 별 활성/잠금. measure 무관(컬럼 차원).
//     L1021~1158 2차 row(measure) 루프 — L1034 `EditFlag != 'Y'` = 비편집 measure 행이면 데이터
//               컬럼 전체 잠금(기존행 L1037) / 신규행(Action=='I' L1038)은 cutoff 만 적용.
//   measure 차원 = SP 산출 EDIT_FLAG(행별, measure×division×bucket). measure 메타에 편집 플래그
//   부재(SCM_MST_SHEET_MEASURE ATTRIBUTE 전부 공란, 실측 23행) → AS-IS 와 동일하게 EDIT_FLAG 단일 출처.
//   동일 cutoff 를 formatItem(배경색) 과 beginningEdit(편집 cancel) 두 곳에서 공유 (DMF0020 패턴).
import { BUCKET_TYPE, DIVISION } from '../mkt-fcst.constants';
import type { MktFcstRow } from '../mkt-fcst.types';
import type { BucketInfo, CurrentWeekInfo } from '../useMktFcstStore';

// ⭐ Weekly 과거 판정 = "현재 주 컬럼(초록 강조)의 위치보다 앞이면 과거" — binding 파싱 전면 폐기.
//   [왜 파싱을 버렸나 — 2026-07-24 실측 확정]
//   Weekly binding 은 SP GET_SPREAD_TITLE L1961 `'W_' || BASIS_YYYYMM || ISO_WEEK` 인데,
//   SCM_SYS_CALENDAR_M.ISO_WEEK 실데이터가 숫자 2자리가 아니라 **'W30' 문자열**이다(CSV 실측).
//   → 실제 binding = 'W_202607W30' (중간에 문자 W 포함). 기존 `\d` 기반 정규식
//     (/^W_\d+$/ · /^W_\d{7,9}$/ · /^W_\d{8}$/) 이 **전부 불일치**하여 어떤 비교 로직을 넣어도
//     그 코드에 도달조차 못 했다(= Daily/Monthly 는 순수 숫자라 정상, Weekly 만 실패한 진짜 원인).
//   [대신 쓰는 기준 — 이미 화면에서 검증된 것]
//   헤더 초록 Bold 강조(MktFcstGrid formatItem L608~626)는 O_RC3 `THIS_YYYYMMWW` 와 컬럼 binding 을
//   **문자열 그대로 비교**한다. THIS_YYYYMMWW 는 헤더 컬럼과 완전히 동일한 식
//   (`'W_' || BASIS_YYYYMM || ISO_WEEK`, 08_procedures_01.sql:9411) 으로 생성되므로 일치가 보장된다.
//   컬럼 순서는 SP SORT_ORDER_NO(=BASIS_START_DATE) 정렬 = 시간순 → 현재 주 index 앞 = 과거.
//   ⇒ 형식이 바뀌어도 깨지지 않는다(파싱 0). 사용자 지시(2026-07-24): "초록색 체크하는 기준에 맞춰라".
//   [정정 2026-10-02] 위 'W30' 전제는 현행 실데이터와 불일치한다 — DMF0021/DMF0003 전 테스트
//     리터럴(W_2026081, W_20260940 등)이 전부 순수 숫자다. 과거 판정의 1차 기준은 여전히 아래
//     index(초록강조) 비교지만, 월경계 파셜주차 예외(isSamePartialWeek, isPastDynColumn W_ 분기)에
//     한해 ISO 주차 숫자 파싱을 쓴다. 파셜 두 조각은 index 가 인접하면서 같은 ISO 주라 index 만으로는
//     앞달 조각을 과거로 오판하기 때문이다.
const weekIndexOf = (binding: string, weekBindings: readonly string[]): number =>
  weekBindings.indexOf(binding);

// 파셜주차 동일주 판정 — 같은 ISO 주(주차번호 동일)가 월경계로 두 컬럼(W_yyyymm+ISO_WEEK)으로
//   쪼개진 경우, 앞달 조각을 당주(뒷달) 조각과 "같은 주"로 본다 (DMF0021 1d089bf93 해석 B 이식).
//   근거: GET_SPREAD_TITLE 커서 W_ = 'W_'||BASIS_YYYYMM||ISO_WEEK, GROUP BY BASIS_YYYYMM,ISO_WEEK
//   (PKG_DMF0003 body L1674~1693). 파셜 두 조각(PARTIAL_WEEK_NAME A/B)은 ISO_WEEK 가 같고
//   BASIS_YYYYMM 만 직전/직후 월로 다르며 SORT_ORDER_NO 가 동일해 항상 인접한다.
//   ISO_WEEK 는 숫자 실데이터(테스트 리터럴 W_2026081 등 전부 숫자) → yyyymm+주차번호로 파싱한다.
//   한정: 주차번호 동일 + a 의 yyyymm 이 b 의 직전 월일 때만(다음 해 같은 주차 오판정 방지).
interface WeekTag {
  ym: string; // yyyymm
  wk: number; // ISO week
}
const parseWeekTag = (binding: string): WeekTag | null => {
  const t = binding.replace(/^W_/, '').trim();
  if (!/^\d{7,10}$/.test(t)) return null;
  return { ym: t.slice(0, 6), wk: Number(t.slice(6)) };
};
const prevMonth = (yyyymm: string): string => {
  if (!/^\d{6}$/.test(yyyymm)) return yyyymm;
  const total = Number(yyyymm.slice(0, 4)) * 12 + (Number(yyyymm.slice(4, 6)) - 1) - 1;
  const y = Math.floor(total / 12);
  const m = (total % 12) + 1;
  return `${y}${String(m).padStart(2, '0')}`;
};
// a(앞달 조각)가 b(당주)의 같은 ISO 주 직전 월 조각인가.
const isSamePartialWeek = (a: WeekTag, b: WeekTag): boolean =>
  a.wk === b.wk && a.ym !== b.ym && a.ym === prevMonth(b.ym);

// 주어진 W_ binding 이 당주(thisWeekBinding) 의 월경계 파셜 앞달 조각인지 판정 (해석 B).
//   당주 강조(초록 레일·헤더 Bold)가 뒷달 조각만 가리킬 때, 같은 ISO 주 앞달 조각도 "당주"로
//   보아 함께 강조하기 위한 공개 헬퍼. isPastDynColumn 의 파셜 예외와 동일 기준을 재사용한다.
export const isPartialWeekPartnerOfCurrent = (
  binding: string,
  thisWeekBinding: string | null | undefined
): boolean => {
  if (!binding || !thisWeekBinding) return false;
  const w = parseWeekTag(binding);
  const tw = parseWeekTag(thisWeekBinding);
  return !!w && !!tw && isSamePartialWeek(w, tw);
};

// 이번 주 월요일 — AS-IS L857 (Sunday=0 → -6, 그 외 -(d-1)). JS getDay(Sun=0) ≡ .NET DayOfWeek.
export const thisWeekMondayYmd = (today = new Date()): string => {
  const d = new Date(today);
  d.setHours(0, 0, 0, 0);
  const dow = d.getDay();
  d.setDate(d.getDate() + (dow === 0 ? -6 : -(dow - 1)));
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
};

// 오늘(당일) yyyymmdd — cutoff.month(당월) 산출용. (Daily 잠금은 cutoff.week=이번 주 월요일 기준.)
const todayYmd = (today = new Date()): string => {
  const d = new Date(today);
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
};

// 동적 PIVOT binding 종류 — M_/W_/D_ + tag(접두어 제거 값).
export type DynKind = 'M' | 'W' | 'D' | null;
export const dynKindOf = (binding: string): DynKind => {
  if (binding.startsWith('M_')) return 'M';
  if (binding.startsWith('W_')) return 'W';
  if (binding.startsWith('D_')) return 'D';
  return null;
};

// ⭐ cutoff 묶음 — 모든 잠금 판정의 기준값(메모이즈 1회 산출).
//   week  : 이번주 월요일 yyyymmdd (Daily=일별 / Weekly=주 시작일 비교)
//   month : 이번 달 yyyymm (Monthly 일반 잠금)
//   div40MonthCutoff : Division 40 Monthly 의 8주차(7주후 주) 시작월 — O_RC2.BASIS_YYYYMM.
//                      이 월 이전 M_ 컬럼은 Div40 에서 잠금 (보강스펙 §5, AS-IS L974~981).
//   thisMonthBinding : 'M_yyyymm' 현재 월 binding (O_RC3 THIS_YYYYMM) — 보관용(현재 판정 미사용).
//                      Monthly 는 cutoff.month(yyyymm) 로 과거월 판정, Weekly 는 M_ 자체가 비활성이므로
//                      본 binding 을 읽지 않는다. O_RC3 계약 보존을 위해 struct field 는 유지.
export interface EditCutoff {
  today: string; // yyyymmdd (오늘/당일 — month 산출용 보관)
  week: string; // yyyymmdd (이번 주 월요일 — Daily 과거 잠금 기준)
  month: string; // yyyymm (이번 달)
  div40MonthCutoff: string | null; // yyyymm (O_RC2)
  thisMonthBinding: string | null; // 'M_yyyymm' (O_RC3)
  // ⭐ Weekly 잠금 기준 2종 (헤더 초록 강조와 동일 출처 — 파싱 없음).
  thisWeekBinding: string | null; // 'W_yyyymm+ISO_WEEK' 원문 (O_RC3 THIS_YYYYMMWW)
  weekBindings: readonly string[]; // 화면에 그려진 W_ 컬럼 시간순 목록 (SP SORT_ORDER_NO 정렬)
  thisWeekIndex: number; // weekBindings 내 현재 주 위치 (-1 = 미상 → Weekly 잠금 미적용)
}

export const buildEditCutoff = (
  bucketInfo: BucketInfo | null,
  currentWeekInfo: CurrentWeekInfo | null,
  now = new Date(),
  weekBindings: readonly string[] = []
): EditCutoff => {
  const mondayYmd = thisWeekMondayYmd(now);
  const thisWeekBinding = (currentWeekInfo?.THIS_YYYYMMWW ?? '').trim() || null;
  return {
    today: todayYmd(now),
    week: mondayYmd,
    // ⭐ month = 오늘(당일) 기준 yyyymm (이번 달). 이번 주 월요일이 지난달일 때도 '이번 달'이 정확하도록
    //   mondayYmd.slice 가 아닌 todayYmd 로 산출 (2026-07-23 — 당일 포함 이후만 편집 규칙).
    month: todayYmd(now).slice(0, 6),
    div40MonthCutoff: (bucketInfo?.BASIS_YYYYMM ?? '').trim() || null,
    thisMonthBinding: (currentWeekInfo?.THIS_YYYYMM ?? '').trim() || null,
    thisWeekBinding,
    weekBindings,
    // 현재 주 컬럼 위치 = 초록 강조가 켜지는 그 컬럼. 못 찾으면 -1 → 과거 판정 자체를 하지 않는다
    //   (SP 미응답/조회구간 밖 등에서 전 주차를 잘못 잠그는 것보다 열어두는 편이 안전 — AS-IS 기본 개방).
    thisWeekIndex: thisWeekBinding ? weekBindings.indexOf(thisWeekBinding) : -1,
  };
};

// 동적 binding 의 비교용 tag — M_yyyymm → 'yyyymm', W_/D_ → 접두 제거값(yyyymm[+ww] / yyyymmdd).
//   주차(W_yyyymm+ISO_WEEK, 가변 7~9자리) 는 앞 6자리(yyyymm)로 과거 월 판정 (주 단위 정밀 비교는
//   8자리 W_yyyymmdd 데이터 row fallback 형식에 한해 가능). 보강스펙 §1 Weekly 잠금 = 시트잠금/상한 기준.
const tagOf = (binding: string): string => binding.slice(2);

/**
 * 컬럼(기간) 단위 과거(실적) 판정 — 행(measure)·division 편집허용과 무관하게 "그 컬럼이 실적
 * 구간인가" 만 본다. DMF0020(forecast-price) isPastPeriodLocked 와 같은 축이며, 실적 구간 회색
 * (wj-cell-non-editable) 의 단일 출처다.
 *
 * evalDynCell 과 나누어 쓰는 이유: evalDynCell 은 편집 가능 여부를 내는 함수라 division 편집제약,
 * 행 EDIT_FLAG != 'Y', 비활성 bucket 을 만나면 날짜를 보기도 전에 되돌아온다(그 셀들은 "과거라서"
 * 잠긴 게 아니므로 isPast=false 가 맞다). 그 결과 실적 구간 회색을 evalDynCell.isPast 로 칠하면
 * 읽기전용 measure 행(RTF/SCM FCST 등)만 흰색으로 남아 컬럼이 얼룩진다 — DMF0020 은 컬럼 하나로
 * 판정하므로 실적 구간 전체가 고르게 회색이다. 색은 이 함수, 편집 차단은 evalDynCell 이 맡는다.
 *
 * 기준(evalDynCell 의 날짜 판정과 동일):
 *   D_yyyymmdd     : 오늘(당일) 이전
 *   W_yyyymm+ISO_WEEK : 현재 주 컬럼(헤더 초록 강조)보다 앞 위치. 현재 주 미검출(-1)이면 판정 안 함
 *   M_yyyymm       : 당월 이전 (+Division 40 은 O_RC2 8주차 이전 월도 실적 취급)
 * bucket 은 보지 않는다 — Sum 체크박스/헤더 드릴로 상위·하위 버킷 컬럼이 함께 보일 때도 그 컬럼의
 * 실적 여부는 같기 때문이다.
 */
export const isPastDynColumn = (params: {
  binding: string;
  divisionId: string;
  cutoff: EditCutoff;
}): boolean => {
  const { binding, divisionId, cutoff } = params;
  const kind = dynKindOf(binding);
  if (!kind) return false;
  const tag = tagOf(binding);

  // Daily 과거 잠금 = 이번 주 월요일 이전 일자 (AS-IS L857/L870 sYYYYMMDD = 이번 주 월요일 기준).
  //   월요일 포함 이후만 편집. (2026-07-23 '당일 기준' 으로 바꿨던 것을 AS-IS 정합으로 되돌림.)
  if (kind === 'D') return tag < cutoff.week;

  if (kind === 'W') {
    if (cutoff.thisWeekIndex < 0) return false;
    // 파셜주차 예외(DMF0021 해석 B) — 당주가 월경계 파셜이면 앞달 조각(예: 당주 W_20261040 의
    //   W_20260940)도 당주와 같은 ISO 주이므로 과거가 아니다. index 비교(앞달 조각은 당주 index
    //   바로 앞이라 과거로 잠김)보다 먼저 가려낸다. thisWeekBinding 과 ISO 주차를 대조한다.
    const w = parseWeekTag(binding);
    const tw = cutoff.thisWeekBinding ? parseWeekTag(cutoff.thisWeekBinding) : null;
    if (w && tw && isSamePartialWeek(w, tw)) return false;
    const idx = weekIndexOf(binding, cutoff.weekBindings);
    // 목록에 없는 W_ 컬럼(-1)은 판정 불가 -> 실적 아님(안전측 개방).
    return idx >= 0 && idx < cutoff.thisWeekIndex;
  }

  const isPastMonth = tag < cutoff.month;
  // Division 40 — 8주차(O_RC2 BASIS_YYYYMM) 이전 월 추가 잠금 (보강스펙 5, AS-IS L974~981).
  const isBefore8Week =
    divisionId === DIVISION.MOBILITY &&
    cutoff.div40MonthCutoff !== null &&
    tag < cutoff.div40MonthCutoff;
  return isPastMonth || isBefore8Week;
};

// ⭐ 동적 셀(M_/W_/D_) 편집 가능 여부 — bucket × division × measure × past 종합 (보강스펙 §1).
//   반환 true = 편집 가능(Yellow) / false = 잠금(과거=Gray, 비활성 bucket=White 비편집).
//   isPast 만 별도 반환하여 formatItem 이 "과거 Gray" 와 "비활성 bucket White" 를 구분 가능하게 함.
export interface DynCellState {
  editable: boolean; // 최종 편집 가능 여부
  isPast: boolean; // 과거 cutoff(이번주 월요일/이번달/Div40 8주) 이전 → Gray 대상
}

export const evalDynCell = (params: {
  binding: string;
  row: MktFcstRow | undefined;
  divisionId: string;
  bucketType: BUCKET_TYPE;
  cutoff: EditCutoff;
  editable: boolean; // ⭐ division 편집허용(메타 구동). false = 편집제약 division → 전 동적 셀 잠금.
}): DynCellState => {
  const { binding, row, divisionId, bucketType, cutoff, editable } = params;
  // ⭐ (−1) division 편집허용 게이트 — 편집가능 division(현행 82)만 편집. 그 외(40/81/81_*/EE*)는
  //   measure(EDIT_FLAG)·bucket·date 판정 이전에 전 동적 셀 잠금(셀 편집불가). isEditableDivision 결과 주입.
  if (!editable) return { editable: false, isPast: false };
  const kind = dynKindOf(binding);
  if (!kind) return { editable: false, isPast: false };

  // (0) 행(=measure) 단위 잠금 — AS-IS L1021~1158 EditButton 루프 정밀 재현.
  //   • L1034 `if (EditFlag != 'Y')` 가 measure 차원의 편집 가능 판정. EDIT_FLAG 는 GET SP 가
  //     measure × division × bucket 조합으로 행마다 계산해 반환하는 "이 measure 행이 입력 가능한가"
  //     플래그(예 MKT_FCST/MKT_FCST_RP=입력, RTF/CUST_FCST/PSI/VMI/BALANCE 등=read-only).
  //     measure 메타(SCM_MST_SHEET_MEASURE)에는 편집허용 플래그가 없으므로(ATTRIBUTE 전부 공란, 실측 23행)
  //     AS-IS 와 동일하게 SP 산출 EDIT_FLAG 를 단일 출처로 사용한다(하드코딩 measure 집합 금지).
  //   • 기존행(CRUD_TYPE≠'I'): L1036~1037 `Action` 공란 → `LockRange(Measure+1 ~ max, true)` = 데이터
  //     컬럼 전체 잠금. 따라서 EDIT_FLAG 가 'Y' 가 아니면(='N'/공란/null/기타) 전 데이터 셀 잠금.
  //     잠금만 하고 색은 안 칠함(과거 Gainsboro 는 cutoff 셀 한정 L1108/1164) → White(#95 무색).
  //   • 신규행(CRUD_TYPE='I'): L1038 Action=='I' 분기 → EDIT_FLAG 와 무관하게 bucket×date cutoff 만
  //     적용(사용자가 고른 measure 는 입력 대상). 따라서 insert 행은 measure 게이트를 통과시킨다.
  const isInsert = (row as Record<string, unknown> | undefined)?.CRUD_TYPE === 'I';
  if (!isInsert) {
    const editFlagRaw = (row as Record<string, unknown> | undefined)?.EDIT_FLAG;
    const editFlag = typeof editFlagRaw === 'string' ? editFlagRaw.trim().toUpperCase() : '';
    // AS-IS L1034 `!= 'Y'` — 'Y' 외 전부 잠금(과거색 아님 → White).
    if (editFlag !== 'Y') return { editable: false, isPast: false };
  }

  // (1) bucket 별 활성 컬럼 분기 (보강스펙 §1) —
  //     Daily   : D_ 만 활성 / W_·M_ 비활성(White).
  //     Weekly  : W_ + 현재월 M_ 활성 / D_ 비활성.
  //     Monthly : 현재월 M_ 활성 / D_·W_ 비활성.
  if (bucketType === BUCKET_TYPE.DAILY) {
    if (kind !== 'D') return { editable: false, isPast: false };
    // 과거일 잠금 = 이번 주 월요일 이전 일자 (AS-IS L857/L870 정합). 판정은 isPastDynColumn 단일 출처.
    const isPast = isPastDynColumn({ binding, divisionId, cutoff });
    return { editable: !isPast, isPast };
  }

  if (bucketType === BUCKET_TYPE.WEEKLY) {
    // ⭐ AS-IS parity (재대조 L862~1019 컬럼 cutoff + L1144~1158 insert Lock Column 루프):
    //   Weekly bucket 에서 활성(편집) 컬럼은 W_ 만이다. D_/M_ 는 전부 잠금(White, 과거 아님).
    //   • L1010~1019(else 블록): W_ 가 아닌 컬럼(D_·M_)은 분기 끝에서 무조건 `LockColumn(iCol,iCol,true)`.
    //     M_ 의 `iResultMonth` 마킹은 결과셀(집계 write) 표시일 뿐 편집 허용이 아니다.
    //   • L1148~1150(insert 행 Lock Column 루프): `if (W_ != 0) LockRange true` → W_ 외 전부 잠금.
    //   따라서 현재월 M_ 라도 Weekly 에서는 편집 불가(노랑 금지) = White. (구현이 현재월 M_ 를 노랑으로
    //   칠하던 것은 AS-IS·프롬프트 스펙("Weekly=W_") 모두와 불일치 → 교정.)
    if (kind === 'D' || kind === 'M') return { editable: false, isPast: false };
    // ⭐ W_ 과거 주 잠금 = 헤더 초록 강조 컬럼(현재 주)보다 앞 위치 (2026-07-24 사용자 지시).
    //   binding 파싱을 하지 않는다 — 실 binding 이 'W_202607W30'(중간에 문자 W) 이라 숫자 기반 파싱이
    //   전부 불일치했던 것이 기존 실패 원인. 대신 화면이 이미 정확히 맞히고 있는 초록 기준
    //   (O_RC3 THIS_YYYYMMWW 문자열 일치)의 컬럼 위치를 그대로 재사용한다.
    //   컬럼 배열은 SP SORT_ORDER_NO(BASIS_START_DATE) 정렬 = 시간순이므로 index 비교로 과거가 확정된다.
    //   thisWeekIndex < 0(현재 주 컬럼 미검출)이면 잠그지 않는다 — 오탐 잠금 방지.
    if (cutoff.thisWeekIndex < 0) return { editable: true, isPast: false };
    // 목록에 없는 W_ 컬럼(-1)은 판정 불가 → 개방(위와 동일 안전측) — isPastDynColumn 이 담당.
    const isPast = isPastDynColumn({ binding, divisionId, cutoff });
    return { editable: !isPast, isPast };
  }

  // Monthly
  if (kind !== 'M') return { editable: false, isPast: false };
  // 일반 과거월 잠금 + Division 40 8주차(O_RC2) 이전 월 — 판정은 isPastDynColumn 단일 출처.
  const isPast = isPastDynColumn({ binding, divisionId, cutoff });
  return { editable: !isPast, isPast };
};
