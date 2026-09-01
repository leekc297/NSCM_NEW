import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { FlexGridColumnConfig } from '@foundation/models';

dayjs.extend(isoWeek);

const defaultUpperColumnProps: FlexGridColumnConfig = {
  header: '',
  align: 'center',
  columns: [],
};

const defaultLowerColumnProps: FlexGridColumnConfig = {
  binding: '',
  header: '',
  align: 'center',
  allowDragging: true,
  allowMerging: false,
  allowResizing: true,
  allowSorting: false,
  width: 70,
  visible: true,
  _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  _ctrlType: CELL_CONTROL_TYPE.COMBO,
  _display: true,
  dataMap: ['Y', 'N'],
  isRequired: false,
};

export const getFcstRangeByBucket = (bucket: string) => {
  const dateColumnGroups: FlexGridColumnConfig[] = [];
  let startDate = dayjs();
  if (bucket === 'DAILY') {
    const endDate = dayjs().add(12, 'month');

    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: startDate.format('ddd').toUpperCase(),
        columns: [
          {
            ...defaultLowerColumnProps,
            header: startDate.format('M/D'),
            binding: `D_${startDate.format('YYYYMMDD')}`,
          },
        ],
      });
      startDate = startDate.add(1, 'day');
    }
  } else if (bucket === 'WEEKLY') {
    const endDate = dayjs().add(30, 'month');

    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: `${startDate.isoWeekYear()}${String(startDate.isoWeek()).padStart(2, '0')}`,
        columns: [
          {
            ...defaultLowerColumnProps,
            header: startDate.startOf('isoWeek').format('M/D'),
            binding: `D_${startDate.startOf('isoWeek').format('YYYYMMDD')}`,
          },
        ],
      });
      startDate = startDate.add(1, 'week');
    }
  } else if (bucket === 'MONTHLY') {
    const endDate = dayjs().add(30, 'month');

    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: startDate.format('YYYY-MM'),
        columns: [
          {
            ...defaultLowerColumnProps,
            header: startDate.startOf('month').format('M/D'),
            binding: `D_${startDate.startOf('month').format('YYYYMMDD')}`,
          },
        ],
      });
      startDate = startDate.add(1, 'month');
    }
  }

  return dateColumnGroups;
};
