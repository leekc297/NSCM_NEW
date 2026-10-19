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

/**
 * 날짜 칸 구간 — 조회 SP(PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA L132~198, P_PLAN_WEEK 미지정 시)와 같다.
 *   DAILY   : 당주 월요일(오늘이 속한 ISO 주의 첫날) ~ 오늘+12개월(그날 포함)
 *   WEEKLY  : 당주(ISO 주) ~ 오늘+30개월이 속한 주(그 주 포함)
 *   MONTHLY : 당월 ~ 오늘+30개월이 속한 달(그 달 포함)
 * 종전엔 DAILY 가 오늘부터 시작해 당주의 지난 요일 칸이 없었고, WEEKLY 는 오늘 요일 기준으로 1주씩 더해
 * 오늘+30개월이 같은 주의 앞 요일이면 마지막 주가 빠졌다(2026-10-07 리포트: 09-19 기준 Daily 366/Weekly 131칸,
 * SP 는 371/132칸). 구간 경계를 모두 주·월의 첫날로 맞춰 비교하면 SP 와 같은 칸 수가 된다.
 * 주의: SP 는 DB 서버 시각(CURRENT_TIMESTAMP), 화면은 브라우저 로컬 날짜를 쓴다. 자정 전후나 시간대가
 *   다르면 하루 차이가 날 수 있는데 이는 종전에도 같았다.
 */
export const getFcstRangeByBucket = (bucket: string) => {
  const dateColumnGroups: FlexGridColumnConfig[] = [];
  const today = dayjs();
  let startDate = today;
  if (bucket === 'DAILY') {
    startDate = today.startOf('isoWeek');
    const endDate = today.add(12, 'month');

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
    // 양 끝을 주의 첫날(월요일)로 맞춰 비교한다 — 오늘+30개월이 속한 주까지 포함(SP ISO_YYYYWW <= 종료주).
    startDate = today.startOf('isoWeek');
    const endDate = today.add(30, 'month').startOf('isoWeek');

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
    // 양 끝을 달의 첫날로 맞춰 비교한다 — 오늘+30개월이 속한 달까지 포함(SP BASIS_YYYYMM <= 종료월).
    startDate = today.startOf('month');
    const endDate = today.add(30, 'month').startOf('month');

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
