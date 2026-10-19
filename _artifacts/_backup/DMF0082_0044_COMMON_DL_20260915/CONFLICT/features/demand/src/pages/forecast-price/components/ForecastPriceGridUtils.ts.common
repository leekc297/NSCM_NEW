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

// LOC 대표일(anchor) = (부분)주차의 월요일, 없으면 그 부분주의 첫 일자.
//   weekMap 은 월경계로 쪼갠 부분주(W40A/W40B) 단위라 월요일이 없는 뒷쪽 부분주가 존재한다.
//   월요일 고정 조건만 쓰면 그런 부분주는 전 일자가 0 이 되어 SP 가 삭제로 전도된다.
const locWeekAnchor = (dayColumns: string[]): string | undefined => {
  if (dayColumns.length === 0) return undefined;
  const monday = dayColumns.find(c => dowSunFirst(c.split('_')[1]) === MON_IDX);
  // D_YYYYMMDD 는 사전순 = 날짜순 → 월요일이 없으면 그 부분주의 첫 일자.
  return monday ?? [...dayColumns].sort()[0];
};

// LOC 일괄할당 로직
// week -> 해당 (부분)주차 대표일(anchor)에 할당, 나머지 0
// month -> 해당 월의 각 주차 대표일(anchor)에 할당 + week column 갱신, 나머지 0
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
      // 부분주 대표일(anchor)에만 값을 넣고 나머지는 0.
      //   월요일 고정 시 월요일 없는 부분주(W40B 등)가 전 일자 0 → SP 삭제 전도.
      const dayColumns = [...(weekMap.get(week) ?? [])];
      const anchor = locWeekAnchor(dayColumns);
      dayColumns.forEach(dateColumn => {
        const cellValue = dateColumn === anchor ? newValue : 0;
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], cellValue);
        dataItem[dateColumn] = cellValue;
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
    // 부분주 대표일(anchor)에만 값을 넣고 나머지는 0.
    //   월요일 고정 시 월요일 없는 부분주(W40B 등)가 전 일자 0 → SP 삭제 전도.
    const dayColumns = [...(weekMap.get(binding) ?? [])];
    const anchor = locWeekAnchor(dayColumns);
    dayColumns.forEach(dateColumn => {
      const cellValue = dateColumn === anchor ? newValue : 0;
      editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], cellValue);
      dataItem[dateColumn] = cellValue;
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

/**
 * 그리드 행 표시 정렬 비교자 — 1순위 표시 키 컬럼(개인화 순서), 동순위(같은 키의 메저 행들)는
 * Measure 설정 팝업 순서를 따른다.
 *
 * 왜 메저 tiebreaker 인가 (사용자 신고 2026-09-04): 조회 SP(GET_MAIN_DATA)는 메저를 자체 SORT_KEY 로
 *   내려주는데, 그 순서가 팝업(Measure 설정)의 개인화 순서와 무관해 "그리드 메저 순서가 팝업과 다르다"는
 *   신고가 났다. 팝업 순서는 사용자별 개인화(titleSet 'M' SORT_ORDER_NO → staticMeasures 배열 순서)라
 *   고정 SP ORDER BY 로는 따라갈 수 없어 FE 에서 맞춘다.
 *
 * measureOrder = staticMeasures(= /admin/menu/DMF0082/measure, 개인화 반영) 의 MEASURE 코드→인덱스 맵.
 *   맵이 비어 있으면(조회 시점에 아직 미도착) 두 행 모두 MAX 로 떨어져 차가 0 → **SP 원 순서 보존**
 *   (로딩 중 재정렬로 화면이 튀지 않게 한다). 맵에 없는 메저는 MAX 로 뒤에 둔다(미등록 방어).
 *
 * 필수: MEASURE 컬럼은 제네릭 키 비교에서 **제외**한다. sortCols(=그리드 visible 컬럼)에는 MEASURE 도
 *   들어 있는데, 여기서 문자열 비교하면 메저 **코드 알파벳순**(LOC<MKT_FCST<…)으로 정렬돼 팝업 순서와
 *   어긋난다(이번 신고의 원인 중 하나). 메저 순서는 오직 measureOrder(팝업/개인화)로만 결정한다.
 * 필수: MEASURE 외 표시 키 비교는 기존과 동일하게 UTF-16 코드단위(`<`/`>`) — localeCompare 미사용
 *   (SP binary 정렬과 동일 결과 유지). ForecastPrice.tsx gridRows 정렬이 이 함수를 그대로 쓴다.
 */
export const compareForecastRows = (
  a: WijmoRowItem,
  b: WijmoRowItem,
  sortCols: readonly string[],
  measureOrder: ReadonlyMap<string, number>
): number => {
  for (const col of sortCols) {
    if (col === 'MEASURE') continue; // 메저는 measureOrder(팝업 순서)로만 — 아래 tiebreaker 참조
    const av = String(a[col] ?? '');
    const bv = String(b[col] ?? '');
    if (av < bv) return -1;
    if (av > bv) return 1;
  }
  const am = measureOrder.get(String(a['MEASURE'] ?? '')) ?? Number.MAX_SAFE_INTEGER;
  const bm = measureOrder.get(String(b['MEASURE'] ?? '')) ?? Number.MAX_SAFE_INTEGER;
  return am - bm;
};

/** 그룹 판정 입력 — 그리드 **표시 순서 그대로**의 컬럼 정보. */
export interface GroupKeyColumn {
  binding: string;
  visible: boolean;
}

const isDynamicBinding = (binding: string): boolean => /^[MWD]_/.test(binding);

/**
 * 머지 범위를 가르는 키 컬럼 — 표시 순서에서 **0번부터 클릭한 컬럼까지**의 정적 컬럼.
 *
 * 근거: 공용 `CustomMergeManager` 의 셀 병합은 계층형이다. 머지키가
 *   `col0값 | col1값 | … | colN값`(foundation/utils/mergeManager.ts `_getMergeKey`)이라
 *   어떤 컬럼의 셀이 위아래로 붙어 보이려면 **그 왼쪽 컬럼이 전부 같아야** 한다.
 *   ⇒ 컬럼 c 의 병합 범위 = `0..c` 값이 모두 같은 연속 행. 키 목록도 `0..클릭컬럼` 이다.
 *
 * 사용자 요구(2026-08-17): "선택한 값의 병합한 데이터 위로" — 즉 **누른 병합 셀이 덮는 범위**가
 *   곧 위로 보낼 범위다. Sales Site 셀은 그 안의 여러 Model 블록을, Model 셀은 그 안의 Incoterms
 *   블록을, Incoterms 셀은 다시 measure 블록만 덮는다.
 *
 * 주의(설계상 당연한 귀결, 버그 아님): 조회 결과가 그 컬럼 값 하나로만 이뤄져 있으면 병합 블록이
 *   곧 그리드 전체라 신규행이 맨 위로 간다. 범위를 좁히려면 더 오른쪽 컬럼을 누르면 된다.
 *
 * 필수: 기준을 **컬럼 인덱스**로 받는다(binding 문자열 역탐색 금지). `g.selection.col` 이 곧
 *   `g.columns` 의 인덱스라 그대로 쓰면 어긋날 여지가 없다. 이름으로 되찾는 방식은 표시/비표시
 *   목록을 따로 만드는 순간 인덱스가 밀려 조용히 폴백으로 떨어진다(2026-08-17 Sales Site 사고).
 *
 * 클릭 컬럼이 병합 축이 못 되면(MEASURE 자신 · 동적 기간 컬럼 · 비표시 · 범위 밖) **MEASURE 직전**
 *   까지를 기준으로 폴백한다 = 통합테스트 35번의 "data Group"(키가 모두 같고 measure 만 다른 블록).
 *
 * 주의: **비표시 컬럼은 키에서 뺀다.** admin 메타상 `EDIT_FLAG`/`BUCKET`/`MEASURE_GROUP`/
 *   `SORT_KEY` 같은 내부 컬럼은 measure 행마다 값이 달라, 키에 넣으면 모든 블록이 1행으로 쪼개져
 *   그룹 판정이 무력화된다. 화면 오른쪽 끝이라 왼쪽 표시 컬럼들의 실제 병합에는 영향이 없다.
 */
export const groupKeyBindings = (
  columnsInOrder: readonly GroupKeyColumn[],
  clickedIndex: number
): string[] => {
  const usable = (column: GroupKeyColumn | undefined): boolean =>
    !!column && column.visible && !!column.binding && !isDynamicBinding(column.binding);

  const clicked = columnsInOrder[clickedIndex];
  let end: number;
  if (usable(clicked) && clicked?.binding !== 'MEASURE') {
    end = clickedIndex + 1;
  } else {
    const measureIndex = columnsInOrder.findIndex(column => column.binding === 'MEASURE');
    end = measureIndex < 0 ? columnsInOrder.length : measureIndex;
  }

  const keys: string[] = [];
  for (let i = 0; i < end && i < columnsInOrder.length; i++) {
    const column = columnsInOrder[i];
    if (usable(column)) keys.push(column.binding);
  }
  return keys;
};

/**
 * 선택한 셀이 속한 머지 블록의 **첫 행 인덱스** — Insert 가 그 블록 맨 위에 행을 넣기 위한 앵커.
 *
 * 요구(통합테스트 35번): "라인추가할 때 data Group 제일 위로 추가해야함. 선택된 위치에 따라서
 *   measure 중간에 라인이 추가됨." + 사용자 추가 요구(2026-08-17): "선택한 값 그 그룹의 젤 위".
 *
 * 위로 훑다가 멈추는 조건 2가지:
 *   1. 키 컬럼 값이 하나라도 다르면 = 다른 그룹.
 *   2. 신규행(CRUD_TYPE='I') 이면 = 병합이 끊기는 자리다. `_getCellMergedRange` 가 신규행을
 *      병합에서 빼므로(mergeManager.ts) 화면상으로도 거기서 블록이 갈린다. 앞서 추가한 신규행은
 *      시드로 키를 복사받아 값이 같으므로, 이 가드가 없으면 그 위까지 타고 올라가 버린다.
 *
 * 그룹을 못 찾거나 신규행에서 눌렀으면 `index` 를 그대로 돌려준다(= 포커스 행 바로 위).
 */
export const findGroupTopIndex = (
  rows: readonly (WijmoRowItem | undefined)[],
  index: number,
  keyBindings: readonly string[]
): number => {
  const target = rows[index];
  if (!target || keyBindings.length === 0 || isInsertRow(target)) return index;

  const cell = (row: WijmoRowItem, binding: string): string => {
    const value = row[binding];
    return value === null || value === undefined ? '' : String(value);
  };
  const isSameGroup = (row: WijmoRowItem): boolean =>
    keyBindings.every(binding => cell(row, binding) === cell(target, binding));

  let top = index;
  while (top > 0) {
    const prev = rows[top - 1];
    if (!prev || isInsertRow(prev) || !isSameGroup(prev)) break;
    top--;
  }
  return top;
};

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
