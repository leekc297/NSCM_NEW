import dayjs, { type Dayjs } from 'dayjs';

import { CustomDropdown, SearchArea } from '@shared/components';
import { DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useAuthApprovalStore } from '../useAuthApprovalStore';

interface Props {
  onSearch: () => void;
}

const toDayjs = (yyyymmdd: string): Dayjs =>
  yyyymmdd && yyyymmdd.length === 8
    ? dayjs(`${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}-${yyyymmdd.slice(6, 8)}`)
    : dayjs();

export const AuthApprovalForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const sc = useAuthApprovalStore(s => s.searchCondition);
  const setSc = useAuthApprovalStore(s => s.setSearchCondition);
  const openSearchArea = useAuthApprovalStore(s => s.openSearchArea);

  const STATUS_OPTIONS = [
    { label: t('LBL00632', 'All'), value: 'ALL' },
    { label: t('LBL00633', 'Request'), value: 'REQUEST' },
    { label: t('LBL00634', 'Approved'), value: 'APPROVED' },
    { label: t('LBL00635', 'Rejected'), value: 'REJECTED' },
  ];

  const periodValue: [Dayjs, Dayjs] = [toDayjs(sc.startDate), toDayjs(sc.endDate)];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00629', 'User ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.userId}
                  onChange={e => setSc({ userId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00630', 'Period')}
              labelAlign='right'
              required
              render={() => (
                <DatePickerCalendar
                  usecase='date-range-multi'
                  elevation
                  size='small'
                  value={periodValue}
                  onChange={
                    ((date: [Dayjs, Dayjs]) => {
                      setSc({
                        startDate: date[0]?.format('YYYYMMDD') ?? '',
                        endDate: date[1]?.format('YYYYMMDD') ?? '',
                      });
                    }) as never
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00631', 'Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.status}
                  options={STATUS_OPTIONS}
                  onChange={(_, value) =>
                    setSc({ status: typeof value === 'string' ? value : 'ALL' })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
