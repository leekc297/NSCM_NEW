import dayjs from 'dayjs';
import type { Dayjs } from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';

import type { FlexGridColumnConfig } from '@foundation/models';

dayjs.extend(isoWeek);

const defaultDynamicColumnProps: FlexGridColumnConfig = {
  align: 'right',
  allowDragging: false,
  allowMerging: false,
  allowSorting: false,
  aggregate: 'Sum',
  format: 'n3',
  binding: '',
  header: '',
};

const today = dayjs();

export const DynamicColumnManager = {
  // return column collection
  // [ date1, date2, ... ]
  // dateN: dYYYYMMDD
  getDateColumns: (
    startDateInput: Dayjs | string,
    endDateInput: Dayjs | string,
    defaultProps: FlexGridColumnConfig = defaultDynamicColumnProps
  ): FlexGridColumnConfig[] => {
    const columns: FlexGridColumnConfig[] = [];
    const startDate = typeof startDateInput === 'string' ? dayjs(startDateInput) : startDateInput;
    const endDate = typeof endDateInput === 'string' ? dayjs(endDateInput) : endDateInput;
    let dayCursor: Dayjs = startDate;

    while (dayCursor.isBefore(endDate) || dayCursor.isSame(endDate)) {
      const dayColumn: FlexGridColumnConfig = {
        ...defaultProps,
        binding: `D_${dayCursor.format('YYYYMMDD')}`,
        header: String(dayCursor.date()).padStart(2, '0'),
      };

      columns.push(dayColumn);
      dayCursor = dayCursor.add(1, 'day');
    }

    return columns;
  },

  // return 3-depth column group collection
  // example return array
  // [ month1, month2, month3, ... ]
  //   ㄴ [ week1, week2, week3, ...]
  //        ㄴ [ date1, date2, date3, ...]
  // monthN: mYYYYMM
  // weekN: wYYYYMMWW
  // dateN: dYYYYMMDD
  getDateColumnsWithAggregation: (
    startDateInput: Dayjs | string,
    endDateInput: Dayjs | string,
    defaultProps: FlexGridColumnConfig = defaultDynamicColumnProps,
    monthMap: Map<string, Set<string>> = new Map(), // 필요한 경우 'month - week' map
    weekMap: Map<string, Set<string>> = new Map() // 필요한 경우, 'week - date' map
  ): FlexGridColumnConfig[] => {
    monthMap?.clear();
    weekMap?.clear();

    const columns: FlexGridColumnConfig[] = [];
    const startDate = typeof startDateInput === 'string' ? dayjs(startDateInput) : startDateInput;
    const endDate = typeof endDateInput === 'string' ? dayjs(endDateInput) : endDateInput;
    let cur = startDate.startOf('month');
    const end = endDate.startOf('month');

    while (cur.isBefore(end) || cur.isSame(end, 'month')) {
      const monthColumnGroups: FlexGridColumnConfig[] = [];
      const yyyy = cur.year();
      const mm = cur.month() + 1;
      const monthSumHeader = `${yyyy}${String(mm).padStart(2, '0')}`;
      const monthSumBinding = `M_${monthSumHeader}`;
      let dayCursor: Dayjs = dayjs(cur);

      if (!monthMap?.has(monthSumBinding)) monthMap?.set(monthSumBinding, new Set());

      monthColumnGroups.push({
        ...defaultProps,
        header: 'MONTH',
        binding: monthSumBinding,
      });

      const monthGroup: FlexGridColumnConfig = {
        ...defaultProps,
        header: monthSumHeader,
        binding: monthSumBinding,
        collapseTo: monthSumBinding,
        columns: monthColumnGroups,
      };

      while (
        dayCursor.isBefore(cur.endOf('month')) ||
        dayCursor.isSame(cur.endOf('month'), 'day')
      ) {
        if (dayCursor.isBefore(startDate) || dayCursor.isAfter(endDate)) {
          dayCursor = dayCursor.add(1, 'day');
          continue;
        }
        const isoWeek = dayCursor.isoWeek();
        const weekSumCol = `W_${monthSumHeader}${String(isoWeek).padStart(2, '0')}`;

        monthMap?.get(monthSumBinding)?.add(weekSumCol);
        if (!weekMap?.has(weekSumCol)) weekMap?.set(weekSumCol, new Set());

        weekMap?.get(weekSumCol)?.add(`D_${dayCursor.format('YYYYMMDD')}`);

        let weekGroup: FlexGridColumnConfig | undefined = monthGroup.columns?.find(
          w => w.header === `W${String(isoWeek).padStart(2, '0')}`
        );
        if (!weekGroup) {
          const weekColumnGroups: FlexGridColumnConfig[] = [];
          weekColumnGroups.push({
            ...defaultProps,
            header: 'WEEK',
            binding: weekSumCol,
          });
          weekGroup = {
            ...defaultProps,
            header: `W${String(isoWeek).padStart(2, '0')}`,
            binding: weekSumCol,
            collapseTo: weekSumCol,
            columns: weekColumnGroups,
          };

          monthGroup.columns?.push(weekGroup);
        }

        weekGroup.columns?.push({
          ...defaultDynamicColumnProps,
          binding: `D_${dayCursor.format('YYYYMMDD')}`,
          header: String(dayCursor.date()).padStart(2, '0'),
        });

        dayCursor = dayCursor.add(1, 'day');
      }

      if (monthGroup.columns && monthGroup.columns.length > 0) columns.push(monthGroup);

      cur = cur.add(1, 'month');
    }

    return columns;
  },
};

export const isNonEditableDateColumn = (
  colBinding: string,
  weekMap: Map<string, Set<string>>
): boolean => {
  const colType = colBinding.charAt(0);

  let returnFlag = false;
  switch (colType) {
    case 'M': {
      const colMonth = dayjs(colBinding.substring(1), 'YYYYMM');
      if (colMonth.isBefore(today) || colMonth.isSame(today)) returnFlag = true;

      break;
    }
    case 'W': {
      let minDate = '';
      weekMap.get(colBinding)?.forEach(date => {
        if (minDate === '' || minDate > date) minDate = date;
      });

      const firstDateOfThisWeek = today.startOf('isoWeek');
      const firstDateOfColWeek = dayjs(minDate.substring(1), 'YYYYMMDD');

      if (firstDateOfColWeek.isBefore(firstDateOfThisWeek)) returnFlag = true;

      break;
    }
    case 'D': {
      const colDate = dayjs(colBinding.substring(1), 'YYYYMMDD');
      const colWeek = colDate.startOf('isoWeek');
      const thisWeek = today.startOf('isoWeek');

      if (colWeek.isBefore(thisWeek)) returnFlag = true;

      break;
    }
  }

  return returnFlag;
};
