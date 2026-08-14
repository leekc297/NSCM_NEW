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
const weekIndexOf = (binding: string, weekBindings: readonly string[]): number =>
  weekBindings.indexOf(binding);

// 이번 주 월요일 — AS-IS L857 (Sunday=0 → -6, 그 외 -(d-1)). JS getDay(Sun=0) ≡ .NET DayOfWeek.
export const thisWeekMondayYmd = (today = new Date()): string => {
  const d = new Date(today);
  d.setHours(0, 0, 0, 0);
  const dow = d.getDay();
  d.setDate(d.getDate() + (dow === 0 ? -6 : -(dow - 1)));
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
};

// 오늘(당일) yyyymmdd — Daily 잠금 기준(당일 포함 이후만 편집, 2026-07-23 사용자 지시).
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
  today: string; // yyyymmdd (오늘/당일 — Daily 잠금 기준)
  week: string; // yyyymmdd (이번 주 월요일 — 파생 계산용 보관)
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

  const tag = tagOf(binding);

  // (1) bucket 별 활성 컬럼 분기 (보강스펙 §1) —
  //     Daily   : D_ 만 활성 / W_·M_ 비활성(White).
  //     Weekly  : W_ + 현재월 M_ 활성 / D_ 비활성.
  //     Monthly : 현재월 M_ 활성 / D_·W_ 비활성.
  if (bucketType === BUCKET_TYPE.DAILY) {
    if (kind !== 'D') return { editable: false, isPast: false };
    // ⭐ 과거일 잠금 = 오늘(당일) 이전 일자 (2026-07-23 사용자 지시 — 당일 포함 이후만 편집).
    //   기존 '이번 주 월요일' 기준은 이번 주 월~어제까지도 편집 허용 → 요구(오늘부터)와 불일치하여 today 로 교정.
    const isPast = tag < cutoff.today;
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
    const idx = weekIndexOf(binding, cutoff.weekBindings);
    // 목록에 없는 W_ 컬럼(-1)은 판정 불가 → 개방(위와 동일 안전측).
    const isPast = idx >= 0 && idx < cutoff.thisWeekIndex;
    return { editable: !isPast, isPast };
  }

  // Monthly
  if (kind !== 'M') return { editable: false, isPast: false };
  // 일반 과거월 잠금.
  const isPastMonth = tag < cutoff.month;
  // Division 40 — 8주차(O_RC2 BASIS_YYYYMM) 이전 월 추가 잠금 (보강스펙 §5, AS-IS L974~981).
  const isDiv40 = divisionId === DIVISION.MOBILITY;
  const isBefore8Week =
    isDiv40 && cutoff.div40MonthCutoff !== null && tag < cutoff.div40MonthCutoff;
  const isPast = isPastMonth || isBefore8Week;
  return { editable: !isPast, isPast };
};
