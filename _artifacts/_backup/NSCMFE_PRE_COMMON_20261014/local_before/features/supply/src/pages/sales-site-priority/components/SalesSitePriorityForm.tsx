import dayjs, { type Dayjs } from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, MENU_ID, SITE_TYPE } from '../sales-site-priority.constants';
import { useSalesSitePriorityStore } from '../useSalesSitePriorityStore';
import {
  filterByDivision,
  resolveSiteDivisionParam,
  toCascadeSource,
  toOptions,
} from '../utils/sales-site-priority.cascadeCombo';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toDivisionOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// design 02 조회조건 6논리조건(경계값=6, 접기 불필요 design 02 §5): Division(단일) / Plan Group(다중,
//   cascade) / Site(다중, cascade+기저필터) / Item ID(텍스트+MaterialByDivisionModal) /
//   Period(From~To) / Valid(단일).
export const SalesSitePriorityForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const [openItemModal, setOpenItemModal] = useState(false);

  const sc = useSalesSitePriorityStore(s => s.searchCondition);
  const set = useSalesSitePriorityStore(s => s.setSearchCondition);
  const openSearchArea = useSalesSitePriorityStore(s => s.openSearchArea);

  // Division 은 EE 포함(design 02 §2-1 comboCalls#1 code=false — GetDivisionWithoutEE 아님).
  //   Plan Group 은 全件 조회 후 클라 cascade 필터(design 02 §3 filterCalls#1, PlanGroup SQL_ID가
  //   DIVISION_ID 를 반환해 클라 필터 가능, ora.py 실측).
  //   Site(SiteMasterAll_SCP)는 CODE/NAME 만 반환하고 DIVISION_ID 컬럼이 없다(ora.py 실측,
  //   gap-audit iter-1 SCP0131-G01 — 미선택 상태에서 클라 DIVISION_ID 필터가 항상 0건이 되는
  //   데이터 계약 불일치). SQL 자체는 `@divisionId`(콤마 목록, INSTR 매칭) 서버 파라미터를 받으므로
  //   AS-IS RefreshSiteByDivision(.cs:254-268)과 동일하게 좁힌다 — division==='EE'일 때만 81/40/82
  //   합집합, 그 외에는 GetDivisionChecked 매핑값(EE_UC->81_UC 등) 단일값, 미선택 시엔 81/40/82
  //   전달(runtime-parity-gate SCP0131 v1 §3.3 — 이전엔 base3 교집합으로 비3종 division 전체가
  //   빈 필터로 새던 결함이 있었다).
  const siteDivisionParam = resolveSiteDivisionParam(sc.divisionId);
  const siteFilter: ComboParam = {
    comboId: COMBO.SITE,
    siteType: SITE_TYPE,
    divisionId: siteDivisionParam,
  };
  const [divisions, planGroups, sites, validYn] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP, siteFilter, COMBO.VALID],
  });

  const divisionOptions = toDivisionOptions(divisions);
  const planGroupOptions = toOptions(filterByDivision(toCascadeSource(planGroups), sc.divisionId));
  const siteOptions = toDivisionOptions(sites);
  const validOptions = toDivisionOptions(validYn);

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Division(단일, cascade 트리거 — design 02 §2-1) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    useClearIcon
                    sortBy='label'
                    value={sc.divisionId}
                    options={divisionOptions}
                    onChange={(_, picked) =>
                      // Division 변경 = Plan Group/Site cascade 초기화(design 02 §3 R7).
                      set({ divisionId: str(picked), planGroupIds: [], siteIds: [] })
                    }
                  />
                )}
              />
            </Grid>
            {/* Plan Group(다중, cascade 하위 — design 02 §2-2) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.planGroupIds.join(',')}
                    options={planGroupOptions}
                    onChange={(_, picked) => set({ planGroupIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Site(다중, cascade 하위 + 기저필터 81/40/82 — design 02 §2-3) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.SITE, '_Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.siteIds.join(',')}
                    options={siteOptions}
                    onChange={(_, picked) => set({ siteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Item ID — 텍스트 + 돋보기(MaterialByDivisionModal COM0013, design 02 §4.6).
                라벨 미등록(design 02 §4.5 확인 필요) — defaultValue 만 표기. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('MSG_ITEM_ID', { defaultValue: 'Item ID' })}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={sc.itemId}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => set({ itemId: e.target.value })}
                    onKeyDown={e => e.key === 'Enter' && onSearch()}
                  />
                )}
              />
            </Grid>
            {/* Period(From~To) — MSG01135(From>To) 검증은 저장/붙여넣기 시점(design 02 §2 검증#4). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PERIOD, '_Period')}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    value={sc.fromDate ? dayjs(sc.fromDate) : null}
                    onChange={
                      ((date: Dayjs | null) => set({ fromDate: date?.format('YYYYMMDD') ?? '' })) as never
                    }
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('MSG_PERIOD_TO', { defaultValue: 'To' })}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    value={sc.toDate ? dayjs(sc.toDate) : null}
                    onChange={
                      ((date: Dayjs | null) => set({ toDate: date?.format('YYYYMMDD') ?? '' })) as never
                    }
                  />
                )}
              />
            </Grid>
            {/* Valid(단일, 필수 — design 02 §2-4). ALL 센티널 없음(AS-IS 는 필수값 검사 대상). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALID, '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={sc.validYn}
                    options={validOptions}
                    onChange={(_, picked) => set({ validYn: str(picked) })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />
      {/* 조회영역 Item ID 팝업 — MaterialByDivisionModal(COM0013), division 컨텍스트 전달(design 02 §4.6).
          확인 필요: scpModuleType/operationGroup 등 실 파라미터 값은 AS-IS 원본 미확보로 잠정값. */}
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => set({ itemId: items })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
