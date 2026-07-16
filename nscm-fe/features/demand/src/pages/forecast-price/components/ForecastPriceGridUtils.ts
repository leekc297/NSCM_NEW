import type { FlexGrid } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import { isNonEditableDateColumn, type EditTracker } from '@foundation/utils';

dayjs.extend(isoWeek);

// AS-IS 권한 4분기 대상 measure (bEDIT_AUTH_SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ — .cs L119~122).
//   배분(divideBy*)은 MKT_FCST/SCM_FCST 만, LOC=allocate, VMI_In_Req=배분 없이 단일 셀 편집.
export const editableMeasures = new Set(['MKT_FCST', 'SCM_FCST', 'LOC', 'VMI_In_Req']);

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

// Month column 분배 로직
// 40인 경우
// 1. 각 주차 마다의 할당일자를 구함
// 2. 각 주차에 월에 할당된 값의 1/n을 할당, 마지막 주차에는 나머지 할당
// 3. 주차에 할당된 값의 1/n 만큼 각 bucket 일자에 할당, 마지막 일자에 나머지 할당
export const divideByMonth = (
  binding: string,
  dataItem: WijmoRowItem,
  newValue: WijmoPrimitive,
  monthMap: Map<string, Set<string>>,
  weekMap: Map<string, Set<string>>,
  editTracker: EditTracker
) => {
  const newValueNumber = toNumber(newValue);
  let dayCntMonth = 0;
  const bucketValue = dataItem['BUCKET'];
  let bucketBinary: string = bucketValue === null ? '' : String(bucketValue);
  const dividedByWeek: {
    week: string;
    dayCntWeek: number;
    bucketDates: string[];
  }[] = [];

  if (bucketValue === '0000000' || bucketValue === null) {
    if (dataItem['DIVISION_ID'] === '40') bucketBinary = '1000000';
    else bucketBinary = '0000100';
  }

  // 각 week에 속하는 할당 일자 구하기 -> dividedByWeek
  monthMap.get(binding)?.forEach(week => {
    let dayCntWeek: number = 0;
    const bucketDates: string[] = [];

    weekMap.get(week)?.forEach(dateColumn => {
      const dateString = dateColumn.split('_')[1];
      const dayValue = dayjs(dateString).isoWeekday() - 1;

      // 할당 일자인 경우 week의 bucket date로
      if (bucketBinary.charAt(dayValue) === '1') bucketDates.push(dateColumn);
      // 할당 일자가 아닌 경우 0 할당
      else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
      dayCntWeek += 1;
    });

    dayCntMonth += dayCntWeek;

    if (bucketDates.length > 0)
      dividedByWeek.push({
        week: week,
        dayCntWeek: dayCntWeek,
        bucketDates: bucketDates,
      });
    // 할당 일자가 없을 경우
    else {
      editTracker.storeChange(dataItem, week, dataItem[week], 0);
      dataItem[week] = 0;
    }
  });

  let monthRemained = newValueNumber;
  dividedByWeek.forEach((weekInfo, index) => {
    let weekValue = 1;
    // 마지막 주차인 경우 주차에 나머지 할당
    if (index === dividedByWeek.length - 1) weekValue = monthRemained;
    // 각 사업부에 따른 분배 할당
    // 40 사업부의 경우 bucket 일자의 비율대로 주차에 할당
    else if (dataItem['DIVISION_ID'] === '40')
      weekValue = Math.floor((newValueNumber / dayCntMonth) * weekInfo.dayCntWeek);
    // 나머지는 1/n
    else weekValue = Math.floor(newValueNumber / dividedByWeek.length);

    // week 할당
    editTracker.storeChange(dataItem, weekInfo.week, dataItem[weekInfo.week], weekValue);
    dataItem[weekInfo.week] = weekValue;
    monthRemained -= weekValue;

    let weekRemained = weekValue;
    const bucketDateCnt = weekInfo.bucketDates.length;

    for (let bucketDateIdx = 0; bucketDateIdx < bucketDateCnt; bucketDateIdx++) {
      const bucketDate = weekInfo.bucketDates[bucketDateIdx];
      let dateValue = 1;

      // 마지막 일자인 경우 주차에 해당된 값의 나머지 할당
      if (bucketDateIdx === bucketDateCnt - 1) dateValue = weekRemained;
      else dateValue = Math.floor(weekValue / bucketDateCnt);

      editTracker.storeChange(dataItem, bucketDate, dataItem[bucketDate], weekValue);
      dataItem[bucketDate] = dateValue;
      weekRemained -= dateValue;
    }
  });
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
    bucketBinary = '1000000';
  else if (bucketValue === '0000000' || dataItem['DIVISION_ID'] !== '40') bucketBinary = '0000100';

  // 할당이 필요한 일자 계산 및 마지막 할당 일자
  weekMap.get(binding)?.forEach(dateColumn => {
    const dateString = dateColumn.split('_')[1];
    const dayValue = dayjs(dateString).isoWeekday() - 1;

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
      const dayValue = dayjs(dateString).isoWeekday() - 1;
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
        const dayValue = dayjs(dateString).isoWeekday() - 1;

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
      const dayValue = dayjs(dateString).isoWeekday() - 1;
      // 월요일
      if (dayValue === 0) {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], newValue);
        dataItem[dateColumn] = newValue;
      } else {
        editTracker.storeChange(dataItem, dateColumn, dataItem[dateColumn], 0);
        dataItem[dateColumn] = 0;
      }
    });
  }
};

// cell 수정여부 판별 로직
export const isNonEditableCell = (
  sender: FlexGrid,
  binding: string,
  dataItem: WijmoRowItem,
  weekMap: Map<string, Set<string>>,
  condBucket: string
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

  // non editable column일 시 수정 불가능 (기준주차 전)
  if (isNonEditableColumn) return true;

  if (condBucket === 'Monthly' && (binding.startsWith('W_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Weekly' && (binding.startsWith('M_') || binding.startsWith('D_')))
    return true;
  if (condBucket === 'Daily' && (binding.startsWith('W_') || binding.startsWith('M_'))) return true;
  if (condBucket === 'Daily' && dataItem['MEASURE'] === 'LOC') return true;

  return false;
};
