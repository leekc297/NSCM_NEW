import dayjs, { type Dayjs } from 'dayjs';
import { useMemo } from 'react';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useAuthApprovalStore } from '../useAuthApprovalStore';

import styles from './AuthApprovalForm.module.scss';

interface Props {
  onSearch: () => void;
}

const toDayjs = (yyyymmdd: string): Dayjs =>
  yyyymmdd && yyyymmdd.length === 8
    ? dayjs(`${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}-${yyyymmdd.slice(6, 8)}`)
    : dayjs();

// SYS0012 조회조건 5종 (AS-IS SCM0009 이미지 기준 + NSCM 표준 4/행, 사용자 요구 2026-06-28):
//   Div / User ID(Name) / Department / Request Date / Approval Result
export const AuthApprovalForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const sc = useAuthApprovalStore(s => s.searchCondition);
  const setSc = useAuthApprovalStore(s => s.setSearchCondition);
  const openSearchArea = useAuthApprovalStore(s => s.openSearchArea);

  // Div 드롭다운 — 공용 콤보 MyDivision 재사용 (SCM_ADM_CMBO_SQL_M)
  const [divData] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo(
    () =>
      (divData ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code} (${name})`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [divData]
  );

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
              label={t('LBL00675', 'Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  options={divisionOptions}
                  value={sc.divisionId}
                  onChange={(_, value) =>
                    setSc({ divisionId: typeof value === 'string' ? value : 'ALL' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              label={t('LBL00339', 'User ID(Name)')}
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
          <Grid size={2}>
            <FormItem
              label={t('LBL00676', 'Department')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.department}
                  onChange={e => setSc({ department: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={2}>
            <FormItem
              label={t('LBL00678', 'Approval Result')}
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
          <Grid size={2}>
            <FormItem
              label={t('LBL00677', 'Request Date')}
              labelAlign='right'
              required
              render={() => (
                // hook #94 — DatePicker 높이 36px 동일화 (wrapper 전레벨 강제)
                <div className={styles.datePickerFix}>
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
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
