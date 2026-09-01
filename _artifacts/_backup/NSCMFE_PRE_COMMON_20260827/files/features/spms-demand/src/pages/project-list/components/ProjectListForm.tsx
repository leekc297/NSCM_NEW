import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LOOKUP } from '../project-list.constants';
import { useProjectListStore } from '../useProjectListStore';

interface ProjectListFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = 고객 ALL reset + 그리드 비움 + CRUD pending reset + 컬럼 메타 재조회 (P-26
  //   — memory feedback_division_change_grid_reset. 자동 재조회 금지, 재조회는 Search 버튼만)
  onDivisionChange: () => void;
}

// SDM1020 조회조건 5종 (hook #112/#94/#120 — 1단 4개 · 높이 36px · Search 라벨 = LBL00112 고정):
//   Row1: 사업부*(MyDivision Single — 첫 값 기본, LBL00001) /
//         고객(EndCustomerByDivision Multi 검색+ALL — 사업부 종속, LBL00643) /
//         나의 권한(lookup SPMS_DPJT_AUTH_TYPE Multi, LBL00855) /
//         등록 상태(lookup SPMS_DPJT_REG_STATUS Multi, LBL00856)
//   Row2: 등록 완료일*(From~To — 기본 M-1~Today, LBL00857. PeriodField 표준 — yyyymmdd)
//   멀티 = 콤마 구분 string, 'ALL' = 전체 (CustomDropdown 계약). 계약 ③ LBL 전부 재사용 (신규 채번 0)
export const ProjectListForm = ({ onSearch, onDivisionChange }: ProjectListFormProps) => {
  const { t } = useTranslation();

  const sc = useProjectListStore(s => s.searchCondition);
  const set = useProjectListStore(s => s.setSearchCondition);
  const openSearchArea = useProjectListStore(s => s.openSearchArea);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  // ⭐ 고객 콤보 — division 종속(CF-02). BE makeComboQuery 는 raw 치환이라 **따옴표 포함 전달** 계약
  //   (미따옴표 = 식별자 해석 ORA 오류. division 변경 = 쿼리키 변경 = 자동 재적재).
  //   EndCustomerByDivision 은 @sesUserId 주입 필요 콤보 — 단건 `/admin/combo` 경로(useTabComboQueries)
  //   가 세션 주입 (combo-muti 비대칭 주의 계보)
  const [endCustomers] = useTabComboQueries({
    filters: [{ comboId: 'EndCustomerByDivision', divisionId: `'${sc.divisionId}'` }],
  });
  const [authTypes, regStatuses] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.AUTH_TYPE }, { lookupType: LOOKUP.REG_STATUS }],
  });

  const divisionOptions = useMemo(
    () => (divisions ?? []).map(item => ({ label: String(item.NAME), value: String(item.CODE) })),
    [divisions]
  );

  const toOptions = (rows: Array<Record<string, string>> | undefined) =>
    (rows ?? []).map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row1 — 사업부* / 고객 / 나의 권한 / 등록 상태 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    // 고객은 division 종속(CF-02) — 변경 시 ALL reset (P-26)
                    set({ divisionId: String(option ?? ''), endCustomers: 'ALL' });
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.endCustomers}
                  options={toOptions(endCustomers as never)}
                  onChange={(_, options) =>
                    set({ endCustomers: String(options ?? 'ALL') || 'ALL' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00879', '_My Authority')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.dpjtAuthTypes}
                  options={toOptions(authTypes as never)}
                  onChange={(_, options) =>
                    set({ dpjtAuthTypes: String(options ?? 'ALL') || 'ALL' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00878', '_Reg Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.dpjtRegStatuses}
                  options={toOptions(regStatuses as never)}
                  onChange={(_, options) =>
                    set({ dpjtRegStatuses: String(options ?? 'ALL') || 'ALL' })
                  }
                />
              )}
            />
          </Grid>

          {/* Row2 — 등록 완료일* (표준 PeriodField — yyyymmdd. 기본값 = M-1~Today, 페이지 레벨 주입.
              필수 — 빈 값/역전 = MSG00108 (P-10, validate 차단)) */}
          <PeriodField
            gridSize={6}
            label={t('LBL00877', '_Reg Complete Date')}
            start={sc.regCompDateFr}
            end={sc.regCompDateTo}
            onChange={(start, end) => set({ regCompDateFr: start, regCompDateTo: end })}
          />
        </>
      }
    />
  );
};
