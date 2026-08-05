import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useAuthApprovalStore } from '../useAuthApprovalStore';

interface Props {
  onSearch: () => void;
}

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

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={2}>
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
          {/* 공용 카탈로그 PeriodField(@master/searchFields) — 라벨만 'Request Date'로 오버라이드. */}
          <PeriodField
            gridSize={2}
            label={t('LBL00677', 'Request Date')}
            start={sc.startDate}
            end={sc.endDate}
            onChange={(start, end) => setSc({ startDate: start, endDate: end })}
          />
        </>
      }
    />
  );
};
