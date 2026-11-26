import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { COMBO, LBL, MENU_ID, MSG } from '../constraint-of-shipment-qty.constants';
import { useConstraintOfShipmentQtyStore } from '../useConstraintOfShipmentQtyStore';
import { buildSearchOptions } from '../utils/constraint-of-shipment-qty.cascadeCombo';

interface Props {
  initData: Parameters<typeof buildSearchOptions>[0];
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const PERIOD_ALERT_DELAY_MS = 300;

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
export const ConstraintOfShipmentQtyForm = ({ initData, onSearch }: Props) => {
  const { t } = useTranslation();
  const [openItemModal, setOpenItemModal] = useState(false);
  // Div 확인창 Cancel 때 콤보 표시 원복용 key(갭분석 C-01). 선택 칸은 value 가 그대로여도 입력란 글자를
  //   클릭한 항목으로 바꿔 두므로 Cancel 이면 key 를 바꿔 다시 그려 store 의 이전 Div 로 되돌린다.
  const [divisionKey, setDivisionKey] = useState(0);
  // Period 없는 날짜를 거부할 때 입력란을 store 값으로 되돌리는 key(갭분석 G-15).
  const [periodKey, setPeriodKey] = useState(0);

  const sc = useConstraintOfShipmentQtyStore(s => s.searchCondition);
  const set = useConstraintOfShipmentQtyStore(s => s.setSearchCondition);
  const setDivision = useConstraintOfShipmentQtyStore(s => s.setDivision);
  const openSearchArea = useConstraintOfShipmentQtyStore(s => s.openSearchArea);

  const tabId = useTabid();

  // CMBO 원천은 Division/Valid 둘뿐(design 02 §2.1/§2.2, AS-IS BLUtils.GetDivision / Data.Type.YesOrNo).
  const [divisions, validYn] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.VALID],
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
  //   From/To Site 는 Div 를 사이트 사업부로 바꿔 거른다(EE → 81·40·82 등, 갭분석 C-03).
  const {
    planGroup: planGroupOptions,
    fromSite: fromSiteOptions,
    toSite: toSiteOptions,
    stage: stageOptions,
    modelGroup: modelGroupOptions,
  } = useMemo(() => buildSearchOptions(initData, sc.divisionId), [initData, sc.divisionId]);
  const validOptions = toDivisionOptions(validYn);

  // Period 커밋 — 공용 기간 칸은 없는 날짜(20260230)도 그대로 넘긴다. 달력에 없는 날짜는 안내 후 이전 값으로
  //   되돌려 표시와 조회 값이 어긋나지 않게 한다(갭분석 G-15).
  const handlePeriodChange = (fromDate: string, toDate: string) => {
    const invalid = [fromDate, toDate].some(
      v => v.length === 8 && !dayjs(v, 'YYYYMMDD', true).isValid()
    );
    if (invalid) {
      setPeriodKey(k => k + 1);
      // Enter 로 커밋하면 키를 떼는 순간 안내창이 바로 닫히므로 키를 뗀 뒤에 띄운다.
      window.setTimeout(() => {
        void useMessageStore.getState().setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_DATE_INVALID, '_Invalid date format. (YYYYMMDD)'),
        });
      }, PERIOD_ALERT_DELAY_MS);
      return;
    }
    set({ fromDate, toDate });
  };

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
                    key={divisionKey}
                    value={sc.divisionId}
                    options={divisionOptions}
                    onChange={(_, picked) => {
                      // Division 변경 = 검색조건(Div·기간·Active 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                      //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 key 를 바꿔 콤보를 이전 Div 로
                      //   다시 그린다(갭분석 C-01). design 02 §3 의 5갈래 fan-out cascade 초기화는 setDivision 이
                      //   상위집합으로 포함(item·그리드까지 함께 초기화).
                      const v = str(picked);
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(v);
                        else setDivisionKey(k => k + 1);
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
            {/* Item ID — 직접 입력 · 지우기 + 돋보기(MaterialByDivisionModal, design 02 §4.6). AS-IS txtItemId 텍스트
                칸(갭분석 C-06·표-06). 입력값은 조회 조건이자 찾기 창 초기 조건. 라벨은 표준화 예외로
                Model(LBL.ITEM_ID=LBL00669) — 조회 내용에 Nickname 이 없다(고객 테스트 요청 2026-11-23). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ITEM_ID, '_Model')}
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
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => setOpenItemModal(true)}
                        />
                      ),
                    }}
                    onChange={e => set({ itemId: e.target.value })}
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
            {/* Item Group(라벨 표기, 다중 cascade 하위 — design 02 §2.3). 사용자 지시(2026-11-05)로
                조회조건 명칭을 "Model Group" -> "Item Group"(LBL00063)로 변경. backing 데이터는
                모델그룹(MDL_GR_NM)/INIT_SET.MODEL_GROUP 그대로이며 라벨 표기만 바뀐다. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ITEM_GROUP, '_Item Group')}
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
                key={periodKey}
                className={commonStyles.formItem}
                label={t(LBL.PERIOD, '_Period')}
                start={sc.fromDate}
                end={sc.toDate}
                onChange={handlePeriodChange}
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
