// ⭐ DMF0003 Phase 2c — 입력 시 재계산 cascade (일↔주↔월) + SSP 동기화 보정.
//   근거(라인 = AS-IS DMF0003_MktFcst.cs):
//     · Daily 입력  (D_): 주합(L3362~3386) + 월합(L3388~3410).
//     · Weekly 입력 (W_): Bucket 요일 균등분배(L3458~3522) + Div40 동기화 보정(L3436~3518) + 분배(L3617~3743).
//     · Monthly 입력(M_): 이전월(이번주월요일 이전) 주합 제외 후 분배(L3770~4096).
//     · 주/월 버킷 + D_ 직접입력: 일→주합·월합 재집계(L4117~4175, Div40).
//   요일플래그 BUCKET(7자리) = V_SUN||V_MON||…||V_SAT (사내 Oracle 실측, SP L3859~3867).
//     → 인덱스 0=일 … 6=토. JS Date.getUTCDay()(일=0) ≡ .NET DayOfWeek ≡ getDayOfWeek (.cs L5766~5772).
//   정수 분배: iDailyQty = sum / dayCnt, iRemnant = sum % dayCnt, 나머지는 "마지막 분배일"에 가산 (.cs L3630~3633).
//   ⚠️ SSP 동기화(PaleGreen=A) 셀은 주→일 분배에서 제외 + iWeeklySum<iWkSum_Sync 강제상향 (.cs L3440~3518) — Div40 & MKT_FCST_RP.
//   무한루프 방지: 호출측(MktFcstGrid)에서 CanModelChange ref 로 재진입 차단 (.cs L2885).
import { BUCKET_TYPE, DIVISION } from '../mkt-fcst.constants';

import { dynKindOf } from './mkt-fcst.editLock';
import type { SspSyncState } from './mkt-fcst.sspSync';

// ── 셀 값 입출력 추상화 (grid setText/getText ≡ row[binding]) ───────────────
//   AS-IS: siMain.GetText/SetText (문자열). 본 util 은 number 로 정규화 후 셋.
export interface RecalcAccessor {
  // 정렬된 동적 컬럼 binding 목록 (좌→우). AS-IS iCol walk 순서와 동일해야 함.
  dynBindings: string[];
  // 현재 값 (없으면 '' → 0). AS-IS GetText().Replace(",","").
  get: (binding: string) => number | null;
  // 값 셋 (null = 빈 셀로 clear, AS-IS SetValue("")). 변경 셀은 onChange 로 통지.
  set: (binding: string, value: number | null) => void;
  // BUCKET 7자리 요일플래그 (V_SUN..V_SAT). 미존재 = 'I-Row' 기본 금요일 '0000010' (.cs L3263).
  bucket: string;
  // SSP 동기화 상태 조회 (D_ binding). Div40 & MKT_FCST_RP 외엔 항상 null.
  sspSyncOf: (binding: string) => SspSyncState;
  // 이번주 월요일 yyyymmdd (sResultDate, .cs L3792~3793 / 과거주 제외 기준).
  thisMondayYmd: string;
}

const isD = (b: string): boolean => dynKindOf(b) === 'D';
const isW = (b: string): boolean => dynKindOf(b) === 'W';
const isM = (b: string): boolean => dynKindOf(b) === 'M';

// D_YYYYMMDD → JS getUTCDay (일=0..토=6). AS-IS getDayOfWeek (.cs L5766~5772).
const dayOfWeekOf = (binding: string): number => {
  const d = binding.slice(2); // 'D_' 제거
  const dt = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
  return dt.getUTCDay();
};

// BUCKET 요일플래그 — 해당 D_ 컬럼이 분배 대상 요일인지 (.cs L3471/3478 dBucket[getDayOfWeek(iCol)]).
const bucketAllows = (bucket: string, binding: string): boolean => {
  const idx = dayOfWeekOf(binding); // 0=일..6=토
  return bucket.length > idx && bucket.charAt(idx) === '1';
};

const numOr0 = (v: number | null): number => (v == null ? 0 : v);
const ymd8 = (binding: string): string => binding.slice(2, 10);

// ============================================================================
// 1) Daily 입력 → 주합 + 월합 (AS-IS L3362~3410)
// ============================================================================
//   editedBinding(D_) 기준: 좌측 최근접 W_ 다음(iStartCol) 부터 다음 W_/M_ 전까지 D_ 합 → 그 W_ 셀.
//   이어서 좌측 최근접 M_ 다음부터 다음 M_ 전까지 W_ 합 → 그 M_ 셀.
export const recalcDailyToWeekMonth = (acc: RecalcAccessor, editedBinding: string): void => {
  const cols = acc.dynBindings;
  const ei = cols.indexOf(editedBinding);
  if (ei < 0) return;

  // ── Weekly Sum (.cs L3362~3386) ──
  // 좌측 최근접 W_ 찾기 → iStartCol = 그 다음 (.cs L3363~3371)
  let wStart = 0;
  for (let i = ei; i >= 0; i--) {
    if (isW(cols[i])) {
      wStart = i + 1;
      break;
    }
  }
  let weeklySum = 0;
  for (let i = wStart; i < cols.length; i++) {
    if (isD(cols[i])) weeklySum += numOr0(acc.get(cols[i])); // (.cs L3375~3378)
    if (isM(cols[i]) || isW(cols[i])) {
      // 경계 → 직전 W_(wStart-1) 에 합 기록 (.cs L3380~3385)
      if (wStart - 1 >= 0) acc.set(cols[wStart - 1], weeklySum);
      break;
    }
    if (i === cols.length - 1 && wStart - 1 >= 0) acc.set(cols[wStart - 1], weeklySum);
  }

  // ── Monthly Sum (.cs L3388~3410) ──
  let mStart = 0;
  for (let i = ei; i >= 0; i--) {
    if (isM(cols[i])) {
      mStart = i + 1;
      break;
    }
  }
  let monthlySum = 0;
  for (let i = mStart; i < cols.length; i++) {
    if (isW(cols[i]) && acc.get(cols[i]) != null) monthlySum += numOr0(acc.get(cols[i])); // (.cs L3400~3403)
    if (isM(cols[i])) {
      if (mStart - 1 >= 0) acc.set(cols[mStart - 1], monthlySum); // (.cs L3405~3408)
      break;
    }
  }
};

// ============================================================================
// 2) Weekly 입력 → 일 분배 (+ Div40 SSP 동기화 보정) (AS-IS L3423~3768)
// ============================================================================
//   반환 forceWeekly: iWeeklySum<iWkSum_Sync 강제상향 발생 시 그 값 (호출측이 W_ 셀 재셋 후 재진입).
export interface WeeklySplitResult {
  forceWeeklyValue: number | null; // null = 정상, number = W_ 셀을 이 값으로 재셋(동기화 강제상향, .cs L3451~3455)
}

export const recalcWeeklyToDaily = (
  acc: RecalcAccessor,
  editedBinding: string,
  divisionId: string,
  measure: string
): WeeklySplitResult => {
  const cols = acc.dynBindings;
  const ei = cols.indexOf(editedBinding);
  if (ei < 0) return { forceWeeklyValue: null };

  const startCol = ei + 1; // (.cs L3425)
  let weeklySum = numOr0(acc.get(editedBinding)); // (.cs L3426~3433)

  const isDiv40Sync = divisionId === DIVISION.MOBILITY && measure === 'MKT_FCST_RP';

  // ── iWkSum_Sync (PaleGreen 동기화 셀 합) (.cs L3435~3456) ──
  let wkSumSync = 0;
  if (isDiv40Sync) {
    for (let i = startCol; i < cols.length; i++) {
      if (isD(cols[i]) && acc.sspSyncOf(cols[i]) === 'A') {
        wkSumSync += numOr0(acc.get(cols[i])); // (.cs L3440~3443)
      }
      if (isM(cols[i]) || isW(cols[i]) || i === cols.length - 1) break; // (.cs L3445~3448)
    }
    if (weeklySum < wkSumSync) {
      // 사용자 입력이 동기화 합보다 작으면 강제 상향 후 재진입 (.cs L3451~3455)
      return { forceWeeklyValue: wkSumSync };
    }
  }

  // ── Daily Split 준비 — 분배 요일수 + remnant (.cs L3458~3522) ──
  let dayCnt = 0;
  let daySyncCnt = 0;
  let dailyQty = 0;
  let remnant = 0;
  let weekAll = false;

  for (let i = startCol; i < cols.length; i++) {
    if (isD(cols[i]) && bucketAllows(acc.bucket, cols[i]) && acc.sspSyncOf(cols[i]) === 'A') {
      daySyncCnt += 1; // (.cs L3468~3475)
    }
    if (isD(cols[i]) && bucketAllows(acc.bucket, cols[i])) {
      dayCnt += 1; // (.cs L3477~3481)
    }
    if (isM(cols[i]) || isW(cols[i]) || i === cols.length - 1) {
      if (dayCnt === 0) {
        weekAll = true; // Bucket 요일 없음 → 특정일(sDefaultDay) 1개에 (.cs L3485~3495)
        dayCnt = 1;
      }
      dailyQty = Math.trunc(weeklySum / dayCnt);
      remnant = weeklySum % dayCnt;
      // SSP 동기화 보정 (.cs L3500~3518)
      if (isDiv40Sync && wkSumSync !== 0) {
        dayCnt = dayCnt - daySyncCnt; // 동기화일 제외 (.cs L3504)
        if (weeklySum > wkSumSync) {
          weeklySum = weeklySum - wkSumSync; // (.cs L3506~3511)
          dailyQty = dayCnt > 0 ? Math.trunc(weeklySum / dayCnt) : 0;
          remnant = dayCnt > 0 ? weeklySum % dayCnt : 0;
        } else {
          weeklySum = 0; // (.cs L3512~3517)
          dailyQty = 0;
          remnant = 0;
        }
      }
      break;
    }
  }

  // ── 분배 적용 (.cs L3617~3743) ──
  if (!weekAll) {
    let check = 0;
    for (let i = startCol; i < cols.length; i++) {
      const b = cols[i];
      if (isD(b) && bucketAllows(acc.bucket, b) && acc.sspSyncOf(b) !== 'A') {
        // 버킷 요일 & 비동기화(PaleGreen 제외) → 분배 (.cs L3621~3650)
        check += 1;
        let q = dailyQty;
        if (dayCnt <= check && remnant > 0) q = dailyQty + remnant; // 마지막날 나머지 (.cs L3628~3633)
        acc.set(b, q);
      } else if (isD(b) && !bucketAllows(acc.bucket, b) && acc.sspSyncOf(b) !== 'A') {
        // 버킷 비요일 & 비동기화 → clear (.cs L3651~3677)
        if (dayCnt <= check && remnant > 0) dailyQty = dailyQty + remnant;
        acc.set(b, null);
      }
      if (!isD(b)) break; // (.cs L3679~3682)
    }
  } else {
    // bWeekAll — 일자 전부 삭제 후 sDefaultDay(=마지막 분배일) 1개에 (.cs L3685~3743)
    for (let i = startCol; i < cols.length; i++) {
      const b = cols[i];
      if (isD(b) && acc.get(b) != null && acc.sspSyncOf(b) !== 'A') acc.set(b, null);
      if (!isD(b)) break;
    }
    // ⭐ 룰2 정합(2026-07-21 공통 배분 룰) — 적용요일 없음 폴백 = "월요일" D_ 셀에 전량.
    //   주 범위에 월요일이 없거나(월경계 분할 주) 월요일이 SSP 동기화('A') 셀이면 첫 비동기화 D_ 로 폴백.
    //   (구 코드 = 첫 비동기화 D_ 근사 / AS-IS 는 마스터 DefaultBucketDay(.cs L1449) — 룰 확정으로 월요일 표준화.)
    let mondayIdx = -1;
    let firstIdx = -1;
    for (let i = startCol; i < cols.length; i++) {
      const b = cols[i];
      if (!isD(b)) break;
      if (acc.sspSyncOf(b) === 'A') continue;
      if (firstIdx < 0) firstIdx = i;
      if (dayOfWeekOf(b) === 1) {
        mondayIdx = i;
        break;
      }
    }
    const targetIdx = mondayIdx >= 0 ? mondayIdx : firstIdx;
    if (targetIdx >= 0) acc.set(cols[targetIdx], dailyQty);
  }

  // ── Monthly Sum 재집계 (.cs L3746~3768) ──
  let mStart = 0;
  for (let i = ei; i >= 0; i--) {
    if (isM(cols[i])) {
      mStart = i + 1;
      break;
    }
  }
  let monthlySum = 0;
  for (let i = mStart; i < cols.length; i++) {
    if (isW(cols[i]) && acc.get(cols[i]) != null) monthlySum += numOr0(acc.get(cols[i]));
    if (isM(cols[i])) {
      if (mStart - 1 >= 0) acc.set(cols[mStart - 1], monthlySum);
      break;
    }
  }

  return { forceWeeklyValue: null };
};

// ============================================================================
// 3) Monthly 입력 → 일 분배 (이번주 월요일 이전 = 이미 확정된 과거 일자 제외) (AS-IS L3770~4096)
// ============================================================================
//   반환 belowActual: 실적(과거 주합)보다 작으면 true (호출측이 MSG00225 alert + 미적용, .cs L3842~3846).
export interface MonthlySplitResult {
  belowActual: boolean;
}

export const recalcMonthlyToDaily = (
  acc: RecalcAccessor,
  editedBinding: string
): MonthlySplitResult => {
  const cols = acc.dynBindings;
  const ei = cols.indexOf(editedBinding);
  if (ei < 0) return { belowActual: false };

  const startCol = ei + 2; // M_ 다음다음(SUM/W_ 건너뜀) (.cs L3773)
  const monthlySum = numOr0(acc.get(editedBinding)); // (.cs L3777~3784)
  const resultDate = +acc.thisMondayYmd; // sResultDate (.cs L3792~3793)

  let dayCnt = 0;
  let dailyQty = 0;
  let remnant = 0;
  let lastWeeklySum = 0; // 과거(이번주월요일 이전) 일자 합 (.cs L3790)

  // ── 분배 요일수 + 과거 합 (.cs L3797~3853) ──
  for (let i = startCol; i < cols.length; i++) {
    const b = cols[i];
    if (isD(b)) {
      if (resultDate > +ymd8(b)) {
        if (acc.get(b) != null) lastWeeklySum += numOr0(acc.get(b)); // (.cs L3802~3810)
        continue;
      }
    }
    if (isD(b) && bucketAllows(acc.bucket, b)) {
      if (resultDate <= +ymd8(b)) dayCnt += 1; // (.cs L3822~3828)
    }
    if (isM(b) || i === cols.length - 1) {
      if (dayCnt === 0) dayCnt = 1; // bMonthAll 근사 (.cs L3833~3838; AS-IS=iMonthCnt sDefaultDay)
      if (lastWeeklySum > 0 && monthlySum - lastWeeklySum <= 0) {
        return { belowActual: true }; // MSG00225 (.cs L3840~3847)
      }
      dailyQty = Math.trunc((monthlySum - lastWeeklySum) / dayCnt); // (.cs L3849~3850)
      remnant = (monthlySum - lastWeeklySum) % dayCnt;
      break;
    }
  }

  // ── 분배 적용 (.cs L3949~4020) ──
  let check = 0;
  for (let i = startCol; i < cols.length; i++) {
    const b = cols[i];
    if (isD(b) && bucketAllows(acc.bucket, b)) {
      if (resultDate > +ymd8(b)) continue; // 과거 일자 보존 (.cs L3957~3960)
      check += 1;
      let q = dailyQty;
      if (dayCnt === check && remnant > 0) q = dailyQty + remnant; // (.cs L3964~3969)
      acc.set(b, q);
    } else if (isD(b) && !bucketAllows(acc.bucket, b)) {
      if (resultDate > +ymd8(b)) continue; // (.cs L3989~3992)
      acc.set(b, null); // 비요일 clear (.cs L4000/4009)
    }
    if (isM(b) || i === cols.length - 1) break; // (.cs L4016~4019)
  }

  return { belowActual: false };
};

// ============================================================================
// 4) 주/월 버킷에서 D_ 직접 입력 → 주합·월합 재집계 (AS-IS L4117~4175, Div40)
// ============================================================================
//   Daily→Week/Month 합산과 동일 구조 (Div40 한정 분기지만 합 재집계는 동치).
export const recalcDailyEditUnderWeekMonth = (acc: RecalcAccessor, editedBinding: string): void => {
  // 합산 로직은 Daily 입력과 동일 (.cs L4121~4175 ≡ L3362~3410).
  recalcDailyToWeekMonth(acc, editedBinding);
};

// ============================================================================
// 진입 dispatcher — bucket 모드 + 편집 셀 종류로 분기 (AS-IS L3282/L3423/L3770/L4117).
// ============================================================================
export type RecalcOutcome =
  | { kind: 'ok' }
  | { kind: 'forceWeekly'; binding: string; value: number } // W_ 강제상향 재셋 후 재진입 (.cs L3451~3455)
  | { kind: 'belowActual' }; // MSG00225 (.cs L3842~3846)

export const dispatchRecalc = (params: {
  acc: RecalcAccessor;
  editedBinding: string;
  bucketType: BUCKET_TYPE;
  divisionId: string;
  measure: string;
}): RecalcOutcome => {
  const { acc, editedBinding, bucketType, divisionId, measure } = params;
  const kind = dynKindOf(editedBinding);
  if (!kind) return { kind: 'ok' };

  // 일버킷 + 일 수정 (.cs L3282)
  if (bucketType === BUCKET_TYPE.DAILY && kind === 'D') {
    recalcDailyToWeekMonth(acc, editedBinding);
    return { kind: 'ok' };
  }
  // 주버킷 + 주 수정 (.cs L3423)
  if (bucketType === BUCKET_TYPE.WEEKLY && kind === 'W') {
    const r = recalcWeeklyToDaily(acc, editedBinding, divisionId, measure);
    if (r.forceWeeklyValue != null) {
      return { kind: 'forceWeekly', binding: editedBinding, value: r.forceWeeklyValue };
    }
    return { kind: 'ok' };
  }
  // 월버킷 + 월 수정 (.cs L3770)
  if (bucketType === BUCKET_TYPE.MONTHLY && kind === 'M') {
    const r = recalcMonthlyToDaily(acc, editedBinding);
    return r.belowActual ? { kind: 'belowActual' } : { kind: 'ok' };
  }
  // 주/월 버킷 + 일 수정 (.cs L4117)
  if ((bucketType === BUCKET_TYPE.WEEKLY || bucketType === BUCKET_TYPE.MONTHLY) && kind === 'D') {
    recalcDailyEditUnderWeekMonth(acc, editedBinding);
    return { kind: 'ok' };
  }
  return { kind: 'ok' };
};
