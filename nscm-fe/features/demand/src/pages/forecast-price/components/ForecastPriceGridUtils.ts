import type { FlexGrid } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import { type EditTracker } from '@foundation/utils';

import { isPastPeriodLocked } from '../utils/forecast-price.editLock';

dayjs.extend(isoWeek);

// AS-IS 권한 4분기 대상 measure (bEDIT_AUTH_SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ — .cs L119~122).
//   배분(divideBy*)은 MKT_FCST/SCM_FCST 만, LOC=allocate, VMI_In_Req=배분 없이 단일 셀 편집.
// 시간축 잠금 판정(isNonEditableCell)이 다루는 measure 화이트리스트.
//   AS_In_Req 는 2026-08-12 추가 — 현업 검수 41번(81 계열·82 + DM Planner(W/S) 입력 가능).
//   ⚠️ 실제 권한 판정은 `forecast-price.wsAuth.isMeasureEditableByAuth` 가 단독으로 한다.
//     이 집합은 "시간축 규칙을 적용할 대상인가"만 가른다.
export const editableMeasures = new Set(['MKT_FCST', 'SCM_FCST', 'LOC', 'VMI_In_Req', 'AS_In_Req']);

// ⭐ 요일비트 정합 (SUN-first) — AS-IS BUCKET 및 PKG_DMF0082 GET_MAIN_DATA(BUCKET=SUN||MON||…||SAT, L3483)
//   는 일~토(index 0=SUN … 6=SAT) 규약. dayjs().day() (0=SUN..6=SAT) 로 조회해야 정합.
//   ⚠️ 구 코드는 isoWeekday()-1 (MON-first) 로 읽어 SP 의 SUN-first 버킷과 1일 어긋남 → 교정.
const dowSunFirst = (dateString: string): number => dayjs(dateString).day();
// Division 별 기본 배분요일(요일비트, SUN-first, AS-IS 기본값): 40=월요일 / 그 외=금요일.
const DEFAULT_BUCKET_40 = '0100000'; // MON (index1)
const DEFAULT_BUCKET_ETC = '0000010'; // FRI (index5)

// ⭐ [2026-08-12 복원] AS-IS sDefaultDay switch(.cs L6024~6055) — 요일 코드('SUN'~'SAT')를 SUN-first
//   요일비트로 변환. 미지정/미매칭 폴백 = **월요일**(AS-IS switch default — 금요일 아님).
//   2026-08-08 수정분이 이후 리팩터링에서 유실됐던 것을 단위테스트(TS2305)로 적출해 재적용.
export const bucketBitsOfDay = (dayCode?: string): string => {
  switch ((dayCode ?? '').trim().toUpperCase()) {
    case 'SUN':
      return '1000000';
    case 'MON':
      return '0100000';
    case 'TUE':
      return '0010000';
    case 'WED':
      return '0001000';
    case 'THU':
      return '0000100';
    case 'FRI':
      return '0000010';
    case 'SAT':
      return '0000001';
    default:
      return '0100000'; // MON
  }
};
// LOC 는 버킷과 무관하게 월요일 고정 (.cs L6008~6012).
export const LOC_BUCKET_BITS = '0100000';
// SUN-first 기준 월요일 index (LOC 기준일).
const MON_IDX = 1;

const isPrimitive = (value: unknown): value is WijmoPrimitive => {
  return (
    value === null ||
    typeof value === 'string' ||
    typeof value === 'number' ||
    typeof value === 'boolean'
  );
};

export const isWijmoRowItem = (dataItem: unknown): dataItem is WijmoRowItem => {
  if (typeof dataItem !== 'object' || dataItem === null) return false;

  return Object.values(dataItem).every(isPrimitive);
};

// any to Number (formatted)
export const toNumber = (value: WijmoPrimitive): number => {
  if (value === null) return 0;
  if (typeof value === 'object') return 0;
  if (typeof value === 'number') return Number.isNaN(value) ? 0 : value;

  const stringifiedValue = String(value).trim();
  if (stringifiedValue === '') return 0;
  const n = Number(stringifiedValue.replaceAll(',', ''));
  return Number.isNaN(n) ? 0 : n;
};

// 배분 캘린더 정보 (GET drop4 = O_RC5 실측 — BASIS_YYYYMMDD/MONTH_DAY_CNT/WEEK_DAY_CNT).
//   key = 'D_YYYYMMDD' binding. 각 일자의 소속 월 전체 일수(MONTH_DAY_CNT)·소속 주 일수(WEEK_DAY_CNT).
export interface CalendarInfo {
  monthDayCnt: number;
  weekDayCnt: number;
}

// 주차 대표일(캘린더 조회 키) = weekMap set 의 최소 D_ binding.
const repDayOf = (dates: Set<string> | undefined): string => {
  let rep = '';
  dates?.forEach(d => {
    if (rep === '' || d < rep) rep = d;
  });
  return rep;
};

// Month column 분배 로직 — AS-IS spdMain_Changed (B-3, .cs L7112~L7398) 1:1.
//   step1 주간수량 = Truncate(월합 / MONTH_DAY_CNT) × WEEK_DAY_CNT (드릴다운 캘린더 drop4 기반, .cs L7222~7227)
//   step2 일자별 = Truncate(주간수량 / 버킷요일수), 각 주 마지막 버킷요일에 잔량 전액 (.cs L7230~7238)
//   step3 월 잔량(iRemnant>0) = 직전 버킷주 요일에 재분배 — 기존 셀값에 가산(+=) (.cs L7320~7365)
export const divideByMonth = (
  binding: string,
  dataItem: WijmoRowItem,
  newValue: WijmoPrimitive,
  monthMap: Map<string, Set<string>>,
  weekMap: Map<string, Set<string>>,
  calendarMap: Map<string, CalendarInfo>,
  editTracker: EditTracker,
  defaultBucket?: string
) => {
  const monthlySum = toNumber(newValue);
  const bucketValue = dataItem['BUCKET'];
  let bucketBinary: string = bucketValue == null ? '' : String(bucketValue);

  if (bucketValue == null || bucketValue === '' || bucketValue === '0000000') {
    bucketBinary =
      defaultBucket ?? (dataItem['DIVISION_ID'] === '40' ? DEFAULT_BUCKET_40 : DEFAULT_BUCKET_ETC);
  }

  // ── 각 주차의 버킷 일자 + 캘린더 조회용 대표일 수집 (비-버킷일은 0 초기화) ──
  const dividedByWeek: { week: string; bucketDates: string[]; repDay: string }[] = [];
  monthMap.get(binding)?.forEach(week => {
    const weekDates = weekMap.get(week);
    const bucketDates: string[] = [];

    weekDates?.forEach(dateColumn => {
      const dateString = dateColumn.split('_')[1];
      const dayValue = dowSunFirst(dateString);
      if (bucketBinary.charAt(dayValue) === '1') bucketDates.push(dateColumn);
      else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
    });

    if (bucketDates.length > 0) {
      bucketDates.sort();
      dividedByWeek.push({ week, bucketDates, repDay: repDayOf(weekDates) });
    }
    // 버킷 일자가 없는 주 = 주 합계 0
    else {
      editTracker.storeChange(dataItem, week, dataItem[week], 0);
      dataItem[week] = 0;
    }
  });

  // MONTH_DAY_CNT fallback = 월 전체 일자 수(캘린더 부재 시 weekMap 실측).
  let monthDayCntFallback = 0;
  monthMap.get(binding)?.forEach(week => {
    monthDayCntFallback += weekMap.get(week)?.size ?? 0;
  });

  // ── step1~2: 주간/일자 배분 ──
  let distributedSum = 0;
  dividedByWeek.forEach(weekInfo => {
    const cal = calendarMap.get(weekInfo.repDay);
    const monthDayCnt = cal?.monthDayCnt ?? monthDayCntFallback;
    const weekDayCnt =
      cal?.weekDayCnt ?? weekMap.get(weekInfo.week)?.size ?? weekInfo.bucketDates.length;
    const weeklyQty = monthDayCnt > 0 ? Math.trunc(monthlySum / monthDayCnt) * weekDayCnt : 0;

    editTracker.storeChange(dataItem, weekInfo.week, dataItem[weekInfo.week], weeklyQty);
    dataItem[weekInfo.week] = weeklyQty;

    let weekRemained = weeklyQty;
    const bucketDateCnt = weekInfo.bucketDates.length;
    weekInfo.bucketDates.forEach((bucketDate, bucketDateIdx) => {
      // 마지막 버킷 일자 = 주간 잔량 전액
      const dateValue =
        bucketDateIdx === bucketDateCnt - 1 ? weekRemained : Math.trunc(weeklyQty / bucketDateCnt);
      editTracker.storeChange(dataItem, bucketDate, dataItem[bucketDate], dateValue);
      dataItem[bucketDate] = dateValue;
      weekRemained -= dateValue;
    });

    distributedSum += weeklyQty;
  });

  // ── step3: 월 잔량 재분배 (직전 버킷주에 가산, .cs L7315~7365) ──
  const remnant = monthlySum - distributedSum;
  const lastWeek = dividedByWeek[dividedByWeek.length - 1];
  if (remnant > 0 && lastWeek) {
    const cnt = lastWeek.bucketDates.length;
    let rem = remnant;
    lastWeek.bucketDates.forEach((bucketDate, idx) => {
      const add = idx === cnt - 1 ? rem : Math.trunc(remnant / cnt);
      // 기존 셀값에 가산 (AS-IS L7349~7352)
      const newVal = toNumber(dataItem[bucketDate]) + add;
      editTracker.storeChange(dataItem, bucketDate, dataItem[bucketDate], newVal);
      dataItem[bucketDate] = newVal;
      rem -= add;
    });
    const newWeekVal = toNumber(dataItem[lastWeek.week]) + remnant;
    editTracker.storeChange(dataItem, lastWeek.week, dataItem[lastWeek.week], newWeekVal);
    dataItem[lastWeek.week] = newWeekVal;
  }
};

// Week column 분배 로직
// 40인 경우 default 월요일, 그 외는 default 금요일
// 할당이 없을 경우 마지막 일자에 전부 할당
export const divideByWeek = (
  binding: string,
  dataItem: WijmoRowItem,
  newValue: WijmoPrimitive,
  oldValue: WijmoPrimitive,
  weekMap: Map<string, Set<string>>,
  editTracker: EditTracker,
  defaultBucket?: string
) => {
  let bucketDateCnt = 0;
  let allocOnlyLastDay = false;
  let lastAllocDateColumn = '';
  let firstDate = '';
  const weekValue = toNumber(newValue);
  const bucketValue = dataItem['BUCKET'];
  let bucketBinary: string = bucketValue == null ? '' : String(bucketValue);

  // ⭐ [2026-08-12 결함 정정 — 재적용] 구 분기: `else if (bucketValue==='0000000' || DIVISION_ID!=='40')`
  //   → division 81*/82 는 **유효 요일비트('0001000' 등)도 FRI 로 덮어써** 배분 요일이 틀렸다
  //   (2026-08-08 발견·수정분이 리팩터링에서 유실 — 단위테스트 회귀 케이스로 적출).
  //   비트가 비어있거나 '0000000' 일 때만 기본값(파라미터 defaultBucket 우선, 없으면 division 기본).
  if (bucketValue == null || bucketValue === '' || bucketValue === '0000000')
    bucketBinary =
      defaultBucket ?? (dataItem['DIVISION_ID'] === '40' ? DEFAULT_BUCKET_40 : DEFAULT_BUCKET_ETC);

  // 할당이 필요한 일자 계산 및 마지막 할당 일자
  weekMap.get(binding)?.forEach(dateColumn => {
    const dateString = dateColumn.split('_')[1];
    const dayValue = dowSunFirst(dateString);

    if (bucketBinary.charAt(dayValue) === '1') {
      bucketDateCnt += 1;
      lastAllocDateColumn = dateColumn;
    }

    if (firstDate === '') firstDate = dateColumn;
  });

  // 할당일자 없을 경우
  if (bucketDateCnt === 0) {
    bucketDateCnt = 1;
    allocOnlyLastDay = true;
  }

  let weekRemained: number = weekValue;
  if (allocOnlyLastDay) {
    [...(weekMap.get(binding) ?? [])].forEach((dateColumn, index, array) => {
      // 마지막 date column인 경우 모두 할당
      if (index === array.length - 1) {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], weekRemained);
        dataItem[dateColumn] = weekValue;
      } else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
    });
  } else {
    weekMap.get(binding)?.forEach(dateColumn => {
      const dateString = dateColumn.split('_')[1];
      const dayValue = dowSunFirst(dateString);
      // 할당 일자
      if (bucketBinary.charAt(dayValue) === '1') {
        // 마지막 할당 일자에 나머지 할당
        if (dateColumn === lastAllocDateColumn) {
          editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], weekRemained);
          dataItem[dateColumn] = weekRemained;
        }
        // 그 외에는 할당일자 수 n만큼 나눈 값 할당
        else {
          editTracker.storeChange(
            dataItem,
            dateColumn,
            dataItem[dateColumn],
            Math.floor(weekValue / bucketDateCnt)
          );
          dataItem[dateColumn] = Math.floor(weekValue / bucketDateCnt);
          weekRemained -= dataItem[dateColumn];
        }
      }
      // 할당 일자가 아닌 경우
      else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
    });
  }

  // month에 diff 반영 (빈칸 0으로 취급)
  const newNum = toNumber(newValue);
  const oldNum = toNumber(oldValue);
  const diff = newNum - oldNum;
  const monthCol = `M_${dayjs(firstDate.split('_')[1]).format('YYYYMM')}`;
  dataItem[monthCol] = toNumber(dataItem[monthCol]) + diff;
};

// Date 로직 (diff 처리)
export const divideByDate = (
  binding: string,
  dataItem: WijmoRowItem,
  newValue: WijmoPrimitive,
  oldValue: WijmoPrimitive,
  editTracker: EditTracker
) => {
  // month에 diff 반영 (빈칸 0으로 취급)
  const newNum = toNumber(newValue);
  const oldNum = toNumber(oldValue);
  const diff = newNum - oldNum;
  const dateString = binding.split('_')[1];
  const isoWeek = String(dayjs(dateString).isoWeek()).padStart(2, '0');
  const weekColumn = `W_${dayjs(dateString).format('YYYYMM')}${isoWeek}`;
  const monthColumn = `M_${dayjs(dateString).format('YYYYMM')}`;
  const newWeekValue = toNumber(dataItem[weekColumn]) + diff;
  const newMonthValue = toNumber(dataItem[monthColumn]) + diff;

  editTracker.storeChange(dataItem, binding, oldValue, newValue);
  editTracker.storeChange(dataItem, weekColumn, dataItem[weekColumn], newWeekValue);
  editTracker.storeChange(dataItem, monthColumn, dataItem[monthColumn], newMonthValue);

  dataItem[weekColumn] = newWeekValue;
  dataItem[monthColumn] = newMonthValue;
};

// LOC 일괄할당 로직
// week -> 해당 주차 월요일에 할당, 나머지 0
// month -> 해당 월의 1일에 할당 + 각 주차의 월요일에 할당, 나머지 0
export const allocateLoc = (
  binding: string,
  dataItem: WijmoRowItem,
  newValue: WijmoPrimitive,
  monthMap: Map<string, Set<string>>,
  weekMap: Map<string, Set<string>>,
  editTracker: EditTracker
) => {
  if (binding?.startsWith('M_')) {
    monthMap.get(binding)?.forEach(week => {
      weekMap.get(week)?.forEach(dateColumn => {
        const dateString = dateColumn.split('_')[1];
        const dayValue = dowSunFirst(dateString);

        // ⭐ [2026-08-12 결함 정정 — 재적용] 월요일 = MON_IDX(1). 구 코드는 0(=SUN-first 의 **일요일**)
        //   이라 LOC 월 기준일이 일요일에 들어갔다(2026-08-08 발견분 유실 — W_ 경로만 고쳐져 있었음).
        if (dayValue === MON_IDX) {
          editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], newValue);
          dataItem[dateColumn] = newValue;
        } else {
          editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
          dataItem[dateColumn] = 0;
        }
      });

      // week column
      editTracker.storeChange(dataItem, week, dataItem[week], newValue);
      dataItem[week] = newValue;
    });

    // 1일
    const firstDateOfMonth = `${binding.replaceAll('M_', 'D_')}01`;
    editTracker.storeChange(dataItem, binding, dataItem[firstDateOfMonth], newValue);
    dataItem[firstDateOfMonth] = newValue;
  } else if (binding?.startsWith('W_')) {
    weekMap.get(binding)?.forEach(dateColumn => {
      const dateString = dateColumn.split('_')[1];
      const dayValue = dowSunFirst(dateString);
      // 월요일 (SUN-first index 1)
      if (dayValue === MON_IDX) {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], newValue);
        dataItem[dateColumn] = newValue;
      } else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
    });

    // ⭐ LOC 월합 = 값 있는 주차의 평균 (AS-IS L6716~6729 — FCST 는 합계, LOC 는 평균).
    //   주간 가격 편집 후 소속 월(M_) 셀을 재계산. (기존: M_ 미갱신 결함 — 갭 #3)
    const monthCol = `M_${binding.slice(2, 8)}`;
    let sum = 0;
    let cnt = 0;
    monthMap.get(monthCol)?.forEach(week => {
      const v = toNumber(dataItem[week]);
      if (v !== 0) {
        sum += v;
        cnt += 1;
      }
    });
    const avg = cnt > 0 ? sum / cnt : 0;
    editTracker.storeChange(dataItem, monthCol, dataItem[monthCol], avg);
    dataItem[monthCol] = avg;
  }
};

// M+4 규칙 대상 measure — M+3 기준월 이하 구간 잠금 (AS-IS list_EDIT_Month_M4, .cs L9264~9278).
//   LOC 는 제외(당월 기준 별도) — editLock.isPastPeriodLocked 가 당월 미만 잠금 담당.
const M4_MEASURES = new Set(['MKT_FCST', 'SCM_FCST', 'VMI_In_Req']);

/** 조회 버킷이 Monthly 인가 — 'M' / 'Monthly' 어느 표기로 와도 판정 (화면은 코드, 그리드는 이름을 쓴다). */
export const isMonthlyBucket = (bucket: string): boolean =>
  bucket.trim().toUpperCase().startsWith('M');

/**
 * M+4 동결 판정 — Monthly 조회 한정. binding 2~8 자리가 곧 소속 월(YYYYMM)이다:
 *   `M_YYYYMM` / `D_YYYYMMDD`. Monthly 조회에서도 저장은 D_ 일자 단위로 나가므로
 *   save/validate 가 넘기는 D_ binding 을 같은 식으로 판정해야 편집과 저장 범위가 맞는다.
 *
 * 적용 범위 = Monthly 조회뿐이다 (현업 검수 40번, 2026-08-13 교정):
 *   · Monthly : MKT_FCST[R+P]/SCM_FCST[R+P] 는 M+4 부터 입력 가능 (Unit Price(LOC) 는 M+0 —
 *               M4_MEASURES 에서 빠져 있어 여기 걸리지 않는다).
 *   · Weekly  : MKT_FCST[R+P] 는 W+0 부터 입력 가능 — 동결 없음.
 *   · Daily   : W+0 월요일부터 입력 가능 — 동결 없음 (Unit Price(LOC) 는 별도 게이트로 입력 불가).
 *   AS-IS 도 같다 — list_EDIT_Month_M4(.cs L9264~9278)는 M_ 컬럼만 순회한다.
 *
 *   회귀 이력: 한때 `!isDailyBucket(bucket)` 로 판정해 Weekly 까지 동결이 걸렸다. 그러면
 *   W_ binding 의 소속월이 M+3 기준월 이하라는 이유로 당주부터 넉 달치 주 컬럼이 통째로 잠겨
 *   "Weekly 조회 시 MKT_FCST 가 4개월 뒤부터만 입력 가능" 해진다 (2026-08-13 리포트).
 *
 * 저장이 D_ 일자 단위라 Weekly/Daily 에서 열어두면 Monthly 가 잠근 것과 같은 데이터를 고칠 수 있다
 *   (= Bucket 전환으로 동결 우회). 그 경로는 실재하지만 현업 요구이므로 의도된 허용으로 둔다.
 *
 * 필수: 편집(isNonEditableCell)과 저장(save.buildSaveRows / validate V2)이 같은 bucket 을 넘겨야
 *   한다. 한쪽만 열리면 "입력은 되는데 저장은 안 되는"(또는 반대) 불일치가 난다.
 * 주의: cutoff 미수신('') 이면 판정을 건너뛴다 — GET drop1 이 늦거나 없을 때 전 구간을 잠가버리면
 *   화면이 못 쓰게 되므로 fail-open 을 유지한다.
 */
export const isM4Locked = (
  measure: string,
  binding: string,
  m3CutoffYyyymm: string,
  bucket = ''
): boolean =>
  isMonthlyBucket(bucket) &&
  m3CutoffYyyymm !== '' &&
  M4_MEASURES.has(measure) &&
  binding.slice(2, 8) <= m3CutoffYyyymm;

/**
 * 신규(Insert) 행 판정 — 필수: `CRUD_TYPE === 'I'` 이어야 한다.
 *
 * 회귀 방지 (2026-07-31 리포트): 예전 판정은 `CRUD_TYPE != null` (존재 여부)이었다.
 *   그런데 foundation EditTracker.storeChange(editTracker.ts L41~43)가 셀을 하나라도 고치면
 *   기존 조회행에 `CRUD_TYPE='M'`(MODIFY) 를 찍는다. 즉 오른쪽 금액을 한 번 수정한 순간
 *   그 행이 Insert 로 오판돼 Model/Nick Name 등 키 정적 컬럼이 통째로 열렸다
 *   (편집 개방 + 노란 배경 + Delete 키 clear 까지). 키 컬럼이 바뀌면 저장 시
 *   DMF0082_SAVE_MAIN_DATA 의 MERGE 가 다른 행에 매치되어 남의 데이터를 덮어쓴다.
 *   'D'(삭제 마킹) 행도 키를 편집할 수 없으므로 함께 배제된다.
 */
export const isInsertRow = (dataItem: WijmoRowItem | undefined | null): boolean =>
  dataItem?.['CRUD_TYPE'] === 'I';

// cell 수정여부 판별 로직
export const isNonEditableCell = (
  sender: FlexGrid,
  binding: string,
  dataItem: WijmoRowItem,
  weekMap: Map<string, Set<string>>,
  condBucket: string,
  // ⭐ M+3 기준월 'YYYYMM' (GET drop1 = O_RC2 M3_CUTOFF_DATE 앞 6자리). M+4 규칙(#4) 입력.
  m3CutoffYyyymm = ''
) => {
  // Edit flag = N 수정 불가능
  if (dataItem?.EDIT_FLAG === 'N') return true;
  // edit mode 비활성화시 수정 불가능
  if (sender.isReadOnly) return true;
  // editable measure가 아닐 시 수정 불가능
  const measure = dataItem['MEASURE'];
  if (typeof measure !== 'string') return true;
  if (!editableMeasures.has(measure)) return true;

  // ⭐ SCM_FCST × RMA 잠금 (AS-IS gate3, .cs L9239) — 갭 #5
  if (measure === 'SCM_FCST' && dataItem['FCST_TYPE'] === 'RMA') return true;

  // 과거 구간 잠금 — 월 컬럼은 당월 전, 주·일 컬럼은 금주 월요일 전.
  //   사유·기준은 forecast-price.editLock.isPastPeriodLocked 주석이 단일 출처
  //   (공용 isNonEditableDateColumn 은 파싱 버그로 항상 false 라 쓰지 않는다).
  if (isPastPeriodLocked(binding, weekMap)) return true;

  if (condBucket === 'Monthly' && (binding.startsWith('W_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Weekly' && (binding.startsWith('M_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Daily' && (binding.startsWith('W_') || binding.startsWith('M_'))) return true;
  if (condBucket === 'Daily' && dataItem['MEASURE'] === 'LOC') return true;

  // M+4 규칙 (AS-IS gate5, .cs L9267~9273) — 갭 #4:
  //   Monthly 조회에서 MKT/SCM/VMI 는 M+3 기준월 초과(=M+4~)만 편집 가능. 기준월 이하 잠금.
  //   Weekly(W+0~)·Daily(W+0 월요일~)는 동결 대상이 아니다 — 범위·이력은 isM4Locked 주석이 단일 출처.
  if (isM4Locked(measure, binding, m3CutoffYyyymm, condBucket)) return true;

  return false;
};
