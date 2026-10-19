import dayjs, { type Dayjs } from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LBL, MENU_ID } from '../constraint-of-shipment-qty.constants';
import { useConstraintOfShipmentQtyStore } from '../useConstraintOfShipmentQtyStore';
import {
  filterByDivision,
  filterSiteBase,
  toCascadeSource,
  toOptions,
} from '../utils/constraint-of-shipment-qty.cascadeCombo';

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

// design 02 조회조건 9필드(2단 초과, hook #52) — conditions 6칸(Division/PlanGroup/ItemId+검색버튼/
//   Stage/ModelGroup/FromSite) + extraConditions 3칸(ToSite/Period/Valid). Division 트리거 ->
//   PlanGroup/FromSite/ToSite/Stage/ModelGroup 5갈래 fan-out 동시 갱신(design 02 §3, 순차 아님).
export const ConstraintOfShipmentQtyForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const [openItemModal, setOpenItemModal] = useState(false);

  const sc = useConstraintOfShipmentQtyStore(s => s.searchCondition);
  const set = useConstraintOfShipmentQtyStore(s => s.setSearchCondition);
  const setDivision = useConstraintOfShipmentQtyStore(s => s.setDivision);
  const openSearchArea = useConstraintOfShipmentQtyStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Division 은 §2.1 판정 대기(Division_SCP 잠정) — AS-IS 대조 완료 전까지 잠정 배선.
  //   PlanGroup/FromSite/ToSite/Stage/ModelGroup 은 §2.3 미등록 상태라 이번 회차엔 빈 후보로
  //   렌더된다(확인 필요, 05_register.sql 참조). Valid 는 확정 재사용.
  const [divisions, planGroups, fromSites, toSites, stages, modelGroups, validYn] =
    useTabComboQueries({
      filters: [
        COMBO.DIVISION,
        COMBO.PLAN_GROUP,
        COMBO.FROM_SITE,
        COMBO.TO_SITE,
        COMBO.STAGE,
        COMBO.MODEL_GROUP,
        COMBO.VALID,
      ],
    });

  const divisionOptions = toDivisionOptions(divisions);
  const planGroupOptions = toOptions(filterByDivision(toCascadeSource(planGroups), sc.divisionId));
  const fromSiteOptions = toOptions(
    filterByDivision(filterSiteBase(toCascadeSource(fromSites)), sc.divisionId)
  );
  const toSiteOptions = toOptions(
    filterByDivision(filterSiteBase(toCascadeSource(toSites)), sc.divisionId)
  );
  const stageOptions = toOptions(filterByDivision(toCascadeSource(stages), sc.divisionId));
  const modelGroupOptions = toOptions(filterByDivision(toCascadeSource(modelGroups), sc.divisionId));
  const validOptions = toDivisionOptions(validYn);

  return (
    <>
      <SearchArea
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Division(단일, cascade 트리거 — design 02 §2.1) */}
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
                    onChange={(_, picked) => {
                      // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                      //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                      //   복귀(commit 51d4e9fa 패턴). design 02 §3 의 5갈래 fan-out cascade 초기화는 setDivision 이
                      //   상위집합으로 포함(item/valid·그리드까지 함께 초기화).
                      const v = str(picked);
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(v);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Plan Group(다중, cascade 하위 — design 02 §2.3) */}
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
            {/* Item ID — 텍스트(읽기전용, 팝업 결과 바인딩) + 돋보기(MaterialByDivisionModal, design 02 §4.6). */}
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
                      readOnly: true,
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
                    onChange={() => undefined}
                  />
                )}
              />
            </Grid>
            {/* Stage(다중, cascade 하위 — design 02 §2.3, TO-BE 미배포 확인 필요) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.STAGE, '_Stage')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.stageIds.join(',')}
                    options={stageOptions}
                    onChange={(_, picked) => set({ stageIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Model Group(다중, cascade 하위 — design 02 §2.3, TO-BE 미배포 확인 필요) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL_GROUP, '_Model Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.modelGroupIds.join(',')}
                    options={modelGroupOptions}
                    onChange={(_, picked) => set({ modelGroupIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* From Site(다중, cascade 하위 + 기저필터 81/40/82 — design 02 §2.3/§3) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.FROM_SITE, '_From Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.fromSiteIds.join(',')}
                    options={fromSiteOptions}
                    onChange={(_, picked) => set({ fromSiteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <>
            {/* To Site(다중, cascade 하위 + 기저필터 81/40/82 — design 02 §2.3/§3) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.TO_SITE, '_To Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.toSiteIds.join(',')}
                    options={toSiteOptions}
                    onChange={(_, picked) => set({ toSiteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Period(From~To) — design 02 §1 #8, To Date 라벨 미등록(확인 필요). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.FROM_DATE, '_From Date')}
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
                label={t('MSG_TO_DATE', { defaultValue: 'To Date' })}
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
            {/* Valid(단일, 필수 — design 03 §3.1 #2 필수값 8종 중 하나). ALL 센티널 없음. */}
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
      {/* 조회영역 Item ID 팝업 — MaterialByDivisionModal, division 컨텍스트 전달(design 02 §4.6). */}
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
