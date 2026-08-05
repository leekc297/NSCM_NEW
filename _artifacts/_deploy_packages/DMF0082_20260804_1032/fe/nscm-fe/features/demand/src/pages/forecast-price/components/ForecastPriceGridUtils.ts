import type { FlexGrid } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import { isNonEditableDateColumn, type EditTracker } from '@foundation/utils';

dayjs.extend(isoWeek);

// AS-IS 권한 4분기 대상 measure (bEDIT_AUTH_SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ — .cs L119~122).
//   배분(divideBy*)은 MKT_FCST/SCM_FCST 만, LOC=allocate, VMI_In_Req=배분 없이 단일 셀 편집.
export const editableMeasures = new Set(['MKT_FCST', 'SCM_FCST', 'LOC', 'VMI_In_Req']);

// ⭐ 요일비트 정합 (SUN-first) — AS-IS BUCKET 및 PKG_DMF0082 GET_MAIN_DATA(BUCKET=SUN||MON||…||SAT, L3483)
//   는 일~토(index 0=SUN … 6=SAT) 규약. dayjs().day() (0=SUN..6=SAT) 로 조회해야 정합.
//   ⚠️ 구 코드는 isoWeekday()-1 (MON-first) 로 읽어 SP 의 SUN-first 버킷과 1일 어긋남 → 교정.
const dowSunFirst = (dateString: string): number => dayjs(dateString).day();
// Division 별 기본 배분요일(요일비트, SUN-first, AS-IS 기본값): 40=월요일 / 그 외=금요일.
const DEFAULT_BUCKET_40 = '0100000'; // MON (index1)
const DEFAULT_BUCKET_ETC = '0000010'; // FRI (index5)
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
  editTracker: EditTracker
) => {
  const monthlySum = toNumber(newValue);
  const bucketValue = dataItem['BUCKET'];
  let bucketBinary: string = bucketValue === null ? '' : String(bucketValue);

  if (bucketValue === '0000000' || bucketValue === null) {
    bucketBinary = dataItem['DIVISION_ID'] === '40' ? DEFAULT_BUCKET_40 : DEFAULT_BUCKET_ETC;
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
  editTracker: EditTracker
) => {
  let bucketDateCnt = 0;
  let allocOnlyLastDay = false;
  let lastAllocDateColumn = '';
  let firstDate = '';
  const weekValue = toNumber(newValue);
  const bucketValue = dataItem['BUCKET'];
  let bucketBinary: string = bucketValue === null ? '' : String(bucketValue);

  if ((bucketValue === '0000000' && dataItem['DIVISION_ID'] === '40') || bucketValue === null)
    bucketBinary = DEFAULT_BUCKET_40;
  else if (bucketValue === '0000000' || dataItem['DIVISION_ID'] !== '40')
    bucketBinary = DEFAULT_BUCKET_ETC;

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

        // 월요일
        if (dayValue === 0) {
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

// M+4 규칙 대상 measure — 월간 버킷에서 M+3 기준월 이하 M_ 컬럼 잠금 (AS-IS list_EDIT_Month_M4, .cs L9264~9278).
//   LOC 는 제외(당월 기준 별도) — foundation isNonEditableDateColumn 이 당월 이하 잠금 담당.
const M4_MEASURES = new Set(['MKT_FCST', 'SCM_FCST', 'VMI_In_Req']);

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
  const isNonEditableColumn = isNonEditableDateColumn(binding, weekMap);

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

  // non editable column일 시 수정 불가능 (기준주차 전)
  if (isNonEditableColumn) return true;

  if (condBucket === 'Monthly' && (binding.startsWith('W_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Weekly' && (binding.startsWith('M_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Daily' && (binding.startsWith('W_') || binding.startsWith('M_'))) return true;
  if (condBucket === 'Daily' && dataItem['MEASURE'] === 'LOC') return true;

  // ⭐ M+4 규칙 (AS-IS gate5, .cs L9267~9273) — 갭 #4:
  //   MKT/SCM/VMI 월간 M_ 컬럼은 M+3 기준월 초과(=M+4~)만 편집 가능. 기준월 이하 잠금.
  if (
    condBucket === 'Monthly' &&
    binding.startsWith('M_') &&
    m3CutoffYyyymm !== '' &&
    M4_MEASURES.has(measure) &&
    binding.slice(2, 8) <= m3CutoffYyyymm
  )
    return true;

  return false;
};
