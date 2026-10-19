import { PeriodField } from 'features/master/src/components/searchFields';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, ELECTRODE_LOOKUP_TYPE } from '../shipment-plan-fg.constants';
import { useShipmentPlanFgStore } from '../useShipmentPlanFgStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  onProjectSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 combo — 18개 상호작용 컨트롤, 16 comboCalls + 2 팝업.
//   division EE 여부/40 여부/Team 81·82 여부에 따라 실제로 호출하는 SQL_ID 자체가 분기된다(§2).
//   방식: 대부분 "화면 전용 필터"(SP 전량 반환 + 클라 필터, §3) — 서버 파라미터 승격 없이 AS-IS 그대로
//   클라 필터로 재현한다(§3 옵션 (a)).
export const ShipmentPlanFgForm = ({ onSearch, onItemSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useShipmentPlanFgStore(s => s.searchCondition);
  const set = useShipmentPlanFgStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentPlanFgStore(s => s.openSearchArea);
  const setLatestPlanSeq = useShipmentPlanFgStore(s => s.setLatestPlanSeq);

  const isEE = sc.divisionId.startsWith('EE');
  const is81Series = sc.divisionId.includes('81');

  // ToSite 원천 3분기(design 02 §2.4): EE* -> ToSiteShipmentPlanFG1_SCP_ALL / EE_UC -> SaleSiteByDivision1_SCP_ALL
  //   / 그 외 -> AllPlantSiteDescription_SCP(FromSite 와 동일 원천 재사용).
  const toSiteComboId = isEE
    ? COMBO.TO_SITE_EE
    : sc.divisionId === 'EE_UC'
      ? COMBO.TO_SITE_EE_UC
      : COMBO.FROM_SITE;

  const [divisions, operationGroups, fromSites, toSites] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      // BizType(OperationGroup) — division EE 여부로 SQL_ID 자체 분기(design 02 §2.2)
      isEE ? COMBO.OPERATION_GROUP_EE : COMBO.OPERATION_GROUP,
      COMBO.FROM_SITE,
      toSiteComboId,
    ],
  });
  // Team — division 파라미터 재조회(design 02 §2.5, TeambyDivision division='40' 내부 UNION 분기)
  const [teams] = useTabComboQueries({
    filters: [{ comboId: COMBO.TEAM, divisionId: sc.divisionId || 'ALL' }],
  });
  // EndCustomer/ToSite2차 — Team 값 기준 division 81/82 vs 그외 2갈래(design 02 §2.6)
  const endCustomerComboId = is81Series ? COMBO.END_CUSTOMER_DEPT : COMBO.END_CUSTOMER_40;
  const [endCustomers] = useTabComboQueries({
    filters: [{ comboId: endCustomerComboId, divisionId: sc.divisionId, deptId: sc.teamIds.join(',') || 'ALL' }],
  });
  // ToSite 2차 재조회(Team 변경 시, design 02 §2.6) — clbTeam_SelectedIndexChanged 가 EndCustomer 와
  // 함께 clbToSite 를 SiteByEndCustomer(81/82)/SiteByEndCustomer40(그 외)로 다시 채운다(gap-audit NEW2).
  const siteByEndCustomerComboId = is81Series ? COMBO.SITE_BY_END_CUSTOMER : COMBO.SITE_BY_END_CUSTOMER_40;
  const [toSitesByTeam] = useTabComboQueries({
    filters: [
      {
        comboId: siteByEndCustomerComboId,
        divisionId: sc.divisionId,
        endCustomer: sc.endCustomerIds.join(',') || 'ALL',
        deptId: sc.teamIds.join(',') || 'ALL',
        projectCode: sc.projectCode || 'ALL',
      },
    ],
  });
  // Electrode — 초기 1회 로드, division EE 여부로 Enabled 만 토글(값 재조회 없음, design 02 §2.7)
  const [electrodes] = useTabComboQueries({
    filters: [{ comboId: COMBO.ELECTRODE, lookupType: ELECTRODE_LOOKUP_TYPE }],
  });
  // PlanDate->PlanType->PlanSeq 3단 cascade(design 02 §2.8, 전량+클라 필터)
  const [planDates] = useTabComboQueries({ filters: [COMBO.PLAN_DATE] });
  const [planTypes] = useTabComboQueries({ filters: [COMBO.PLAN_TYPE] });
  const [planSeqs] = useTabComboQueries({ filters: [COMBO.PLAN_SEQ] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  // FromSite 클라 필터(design 02 §2.3, 3갈래)
  const fromSiteFilterDivisionIds = (): string[] => {
    if (sc.divisionId === 'EE_UC') return ['81_UC'];
    if (isEE) return divisionOptions.map(o => o.value).filter(v => !v.startsWith('EE'));
    return [sc.divisionId];
  };
  const fromSiteDivisionIds = new Set(fromSiteFilterDivisionIds());
  const fromSiteOptions = toOptions(
    (fromSites ?? []).filter(
      r =>
        fromSiteDivisionIds.has(str(r.DIVISION_ID)) &&
        (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  // ToSite 클라 필터(design 02 §2.4) — EE_UC 는 division 단독(OPERATION_GROUP 없음), 그 외는 division 단독
  // Team 이 선택되면 §2.6 2차 캐스케이드(SiteByEndCustomer/40)가 §2.4 초기 목록을 대체한다.
  const toSiteOptions =
    sc.teamIds.length > 0
      ? toOptions(toSitesByTeam)
      : toOptions(
          (toSites ?? []).filter(r => {
            if (sc.divisionId === 'EE_UC') return str(r.DIVISION_ID) === '81_UC';
            if (isEE)
              return (
                str(r.DIVISION_ID) === sc.divisionId &&
                (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
              );
            return str(r.DIVISION_ID) === sc.divisionId;
          })
        );
  const teamOptions = toOptions(teams);
  const endCustomerOptions = toOptions(endCustomers);
  const electrodeOptions = toOptions(electrodes);
  // PlanDate 클라 필터(division), PlanType 클라 필터(division+planDate, 자동 최신행), PlanSeq(+planType)
  const planDateOptions = toOptions(
    (planDates ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  const planTypeOptions = toOptions(
    (planTypes ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (!sc.planStartYyyymmdd || str(r.PLANDATE) === sc.planStartYyyymmdd)
    )
  );
  const planSeqOptions = toOptions(
    (planSeqs ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (!sc.planStartYyyymmdd || str(r.PLANDATE) === sc.planStartYyyymmdd) &&
        (!sc.planType || str(r.PLANTYPE) === sc.planType)
    )
  );
  // PlanType 자동 최신행 선택(design 02 §2.8 RefreshPlanType — dtPlanType 마지막 행)
  const latestPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (latestPlanType && sc.planType !== latestPlanType && !planTypeOptions.some(o => o.value === sc.planType)) {
      set({ planType: latestPlanType });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [latestPlanType]);

  // Plan Seq 콤보 후보 중 최댓값 — Fix/Unfix 버튼 disabled 판정(design 01 §2 #2 Set_FixButtonEnabled,
  //   'curPlanSeq==maxSeq' AND 조건)에 페이지 레벨(ShipmentPlanFg.tsx)이 쓸 수 있게 store 로 올린다
  //   (gap-resolve iter-1 NEW7 — 이전 구현은 이 값이 Form 컴포넌트 로컬에 갇혀 있었다).
  const latestPlanSeq = planSeqOptions[planSeqOptions.length - 1]?.value ?? '';
  useEffect(() => {
    setLatestPlanSeq(latestPlanSeq);
  }, [latestPlanSeq, setLatestPlanSeq]);

  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            disabled={disabled}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(String(picked ?? '').split(',').filter(v => v !== '' && v.toUpperCase() !== 'ALL'))
            }
          />
        )}
      />
    </Grid>
  );

  const single = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: Option[],
    onPick: (v: string) => void,
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown value={value} options={options} onChange={(_, picked) => onPick(String(picked ?? ''))} />
        )}
      />
    </Grid>
  );

  // W26/W52/WLast 프리셋 — 보조 SP(SCM0001_GET_SCP_DAY_PERIOD/_DAILY_PLAN_PERIOD) TO-BE 미배포
  //   (goal.md ②, design 02 §2.9) — convert-sp 후속. 클릭 시 배포 대기 안내만 표시.
  const handlePeriodPreset = () => {
    void setAlert({
      type: 'alert',
      content: t('MSG00000', { defaultValue: '_Period preset SP not deployed yet (convert-sp pending).' }),
    });
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 필드 12건, Grid size 합계(3*10+4+2=36)가 2단(24) 초과 — hook #52(search-area-extra-conditions)
      //   기준 우선순위대로 필수(*)+Period 만 conditions 에 두고, 나머지(cascade 종속/보조 필터)는
      //   extraConditions 로 분리한다(nscm-patterns.md §6 조회조건 "2줄+ 접기/펼치기").
      conditions={
        <>
          {/* Division* — 무필터, EE 제외 없음(design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // Division 변경 = 하위 7개 콤보 cascade 초기화(design 02 §6)
                    set({
                      divisionId: String(picked ?? ''),
                      operationGroupId: '',
                      fromSiteIds: [],
                      toSiteIds: [],
                      teamIds: [],
                      endCustomerIds: [],
                      electrodeTypeIds: [],
                      planStartYyyymmdd: '',
                      planType: '',
                      planSeq: '',
                    })
                  }
                />
              )}
            />
          </Grid>
          {single('LBL00027', 'Operation Group', sc.operationGroupId, operationGroupOptions, v =>
            set({ operationGroupId: v })
          , true)}
          {single('LBL00039', 'Plan Date', sc.planStartYyyymmdd, planDateOptions, v =>
            set({ planStartYyyymmdd: v, planType: '', planSeq: '' })
          , true)}
          {single('LBL00040', 'Plan Type', sc.planType, planTypeOptions, v =>
            set({ planType: v, planSeq: '' })
          , true)}
          {single('LBL00768', 'Seq', sc.planSeq, planSeqOptions, v => set({ planSeq: v }), true)}

          {/* Period(dCalendar)* — design 02 §2.9. From/To + W26/W52/WLast 프리셋(SP 미배포). */}
          <PeriodField
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(from, end) => set({ fromYyyymmdd: from, toYyyymmdd: end })}
            gridSize={4}
            label={t('LBL00013', { defaultValue: 'Period' })}
          />
          <Grid size={2}>
            <Button appearance='outlined' priority='normal' onClick={handlePeriodPreset}>
              W26
            </Button>
            <Button appearance='outlined' priority='normal' onClick={handlePeriodPreset}>
              W52
            </Button>
            <Button appearance='outlined' priority='normal' onClick={handlePeriodPreset}>
              WLast
            </Button>
          </Grid>
        </>
      }
      extraConditions={
        <>
          {multi('LBL00022', 'From Site', sc.fromSiteIds, fromSiteOptions, fromSiteIds => set({ fromSiteIds }))}
          {multi('LBL00023', 'To Site', sc.toSiteIds, toSiteOptions, toSiteIds => set({ toSiteIds }))}
          {multi('LBL00044', 'Team', sc.teamIds, teamOptions, teamIds =>
            // Team 변경 = EndCustomer/ToSite2차 재조회 트리거(design 02 §2.6)
            set({ teamIds, endCustomerIds: [] })
          )}
          {multi('LBL00080', 'End Customer', sc.endCustomerIds, endCustomerOptions, endCustomerIds =>
            set({ endCustomerIds })
          )}
          {multi(
            'LBL00038',
            'Electrode',
            sc.electrodeTypeIds,
            electrodeOptions,
            electrodeTypeIds => set({ electrodeTypeIds }),
            !isEE // division EE 여부로 Enabled 만 토글(design 02 §2.7) — 비활성 시 선택값 유지 안 함
          )}

          {/* Project — txtProject + btnProject -> ProjectByDivisionModal(design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00617', { defaultValue: 'Project' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.projectCode}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onProjectSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ projectCode: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model — txtItem_Id + btnItem_Id -> ItemByDivisionModal(design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', { defaultValue: 'Model' })}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* chkAll/chkSum/cboBucketType/btnColumn/btnMeasure — design 00_checklist §1 area=3(그리드)
              분류(design 02 §1 주 참조) — 여기 배치하지 않는다. ShipmentPlanFgGrid 툴바에 있다. */}
        </>
      }
    />
  );
};
