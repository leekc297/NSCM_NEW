import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, INIT_SET, LBL, MENU_ID, SHEETS } from '../constraint-of-shipment-qty.constants';
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

// design 02 조회조건 9필드 — 사용자 지시(2026-10-13)로 접힘(extraConditions) 없이 9칸 전부 항상 보이는
//   conditions 에 둔다(4열×3줄: Division/PlanGroup/ItemId/Stage/ModelGroup/FromSite/ToSite/Period/Valid).
//   extraConditions 미사용이라 SearchArea 더보기(chevron) 버튼도 뜨지 않는다.
//   Division 트리거 -> PlanGroup/FromSite/ToSite/Stage/ModelGroup 5갈래 fan-out 동시 갱신(design 02 §3, 순차 아님).
export const ConstraintOfShipmentQtyForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const [openItemModal, setOpenItemModal] = useState(false);

  const sc = useConstraintOfShipmentQtyStore(s => s.searchCondition);
  const set = useConstraintOfShipmentQtyStore(s => s.setSearchCondition);
  const setDivision = useConstraintOfShipmentQtyStore(s => s.setDivision);
  const openSearchArea = useConstraintOfShipmentQtyStore(s => s.openSearchArea);

  const tabId = useTabid();

  // CMBO 원천은 Division/Valid 둘뿐(design 02 §2.1/§2.2, AS-IS BLUtils.GetDivision / Data.Type.YesOrNo).
  const [divisions, validYn] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.VALID],
  });

  // init(GET_SEARCH_INFO) — PlanGroup/ToSite/FromSite/Stage/ModelGroup(+Item) 다중커서 원천.
  //   AS-IS 는 GetSearchInfo("81") 로 전사 로드 후 DBUtils.Filter 로 Division cascade(.cs:265~306) —
  //   FE 는 division 빈 값으로 1회 호출하고 아래에서 클라 필터로 재현한다(자매 SCP0128 init 동형).
  const initFilters = useMemo(() => ({ divisionId: '', scmSiteId: '' }), []);
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: initFilters,
    enabled: true,
  });

  const divisionOptions = toDivisionOptions(divisions);
  // Division 조회조건 기본값 — 사용자 지시(2026-10-13): 클리어(X) 없이 첫 번째 값을 기본 선택한다.
  //   현재 divisionId 가 옵션에 없을 때(빈값 또는 F10 리셋 직후)만 첫 값으로 채운다. hasDivision(현재 값이
  //   옵션에 있는가)을 effect 밖에서 계산해 deps 에 넣어야 리셋으로 값만 비워도 재발화한다
  //   ([[f10-reset-default-reselect-needs-has-value-flag-in-deps]]). cascade/그리드 초기화 부작용과 F6 복원값
  //   보존을 위해 setDivision 이 아니라 set({divisionId}) 로 직접 채운다(진입 첫 세팅은 이미 빈 상태라 부작용 없음).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) set({ divisionId: firstDivision });
  }, [firstDivision, hasDivision, set]);
  // 하위 5콤보 — init 커서 소스를 Division cascade 로 좁힌다(AS-IS Refresh*ByDivision). 정렬 없음:
  //   AS-IS setListBox 가 SP 반환 순서 그대로 바인딩하므로 sortBy 를 걸지 않는다(SP 순서 = 정본).
  const planGroupOptions = toOptions(
    filterByDivision(toCascadeSource(initData?.[INIT_SET.PLAN_GROUP]), sc.divisionId)
  );
  const fromSiteOptions = toOptions(
    filterByDivision(filterSiteBase(toCascadeSource(initData?.[INIT_SET.FROM_SITE])), sc.divisionId)
  );
  const toSiteOptions = toOptions(
    filterByDivision(filterSiteBase(toCascadeSource(initData?.[INIT_SET.TO_SITE])), sc.divisionId)
  );
  const stageOptions = toOptions(
    filterByDivision(toCascadeSource(initData?.[INIT_SET.STAGE]), sc.divisionId)
  );
  const modelGroupOptions = toOptions(
    filterByDivision(toCascadeSource(initData?.[INIT_SET.MODEL_GROUP]), sc.divisionId)
  );
  const validOptions = toDivisionOptions(validYn);

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search(F5)')}
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
                    value={sc.planGroupIds.join(',')}
                    options={planGroupOptions}
                    onChange={(_, picked) => set({ planGroupIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Item ID — 텍스트(읽기전용, 팝업 결과 바인딩) + 돋보기(MaterialByDivisionModal, design 02 §4.6).
                라벨은 AS-IS Model/Nickname(LBL.ITEM_ID=LBL00618). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ITEM_ID, '_Model/Nickname')}
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
                    value={sc.fromSiteIds.join(',')}
                    options={fromSiteOptions}
                    onChange={(_, picked) => set({ fromSiteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* To Site(다중, cascade 하위 + 기저필터 81/40/82 — design 02 §2.3/§3).
                사용자 지시(2026-10-13): 접히는 영역이 아니라 항상 보이는 조회조건(conditions)에 둔다. */}
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
                    value={sc.toSiteIds.join(',')}
                    options={toSiteOptions}
                    onChange={(_, picked) => set({ toSiteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Period(From~To) — AS-IS UsrDateRangePicker3(dCalendar) 단일 기간 컨트롤, lblPeriod "Period*".
                From Date/To Date 2분할이 아니라 하나의 범위 선택기다(.Designer.cs:520~527).
                사용자 지시(2026-10-13): To Site 와 함께 항상 보이는 조회조건(conditions)에 둔다. */}
            <Grid size={3}>
              <PeriodRangePicker
                className={commonStyles.formItem}
                label={t(LBL.PERIOD, '_Period')}
                start={sc.fromDate}
                end={sc.toDate}
                onChange={(fromDate, toDate) => set({ fromDate, toDate })}
              />
            </Grid>
            {/* Valid(단일) — AS-IS cboValid.DataBind(Data.Type.YesOrNo, true)(.cs:171): isAddALL=true 라
                콤보가 [ALL, Y, N] 3행이고 기본 선택이 ALL 이다. allOption 으로 ALL 항목을 서버 Y/N 2행
                앞에 얹어 AS-IS 와 1:1 재현한다(기본값은 store VALID_DEFAULT='ALL'). 조회 시 ALL → 빈
                문자열 변환은 setFilter 가 담당(AS-IS .cs:452). 라벨은 AS-IS Active(LBL.VALID=LBL00007). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALID, '_Active')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
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
