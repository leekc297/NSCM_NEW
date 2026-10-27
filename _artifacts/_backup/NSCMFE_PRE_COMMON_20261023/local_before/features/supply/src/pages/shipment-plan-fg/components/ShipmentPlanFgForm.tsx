import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Label } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { type BUCKET_TYPE, COMBO, ELECTRODE_LOOKUP_TYPE, LBL } from '../shipment-plan-fg.constants';
import { getDayRange, useShipmentPlanFgStore } from '../useShipmentPlanFgStore';

interface Props {
  onSearch: () => void;
  onChangeBucketType: (bucketType: BUCKET_TYPE) => void;
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
export const ShipmentPlanFgForm = ({ onSearch, onChangeBucketType, onItemSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();
  const tabId = useTabid();

  const sc = useShipmentPlanFgStore(s => s.searchCondition);
  const set = useShipmentPlanFgStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentPlanFgStore(s => s.openSearchArea);
  const setLatestPlanSeq = useShipmentPlanFgStore(s => s.setLatestPlanSeq);
  const clearFilters = useShipmentPlanFgStore(s => s.clearFilters);

  const isEE = sc.divisionId.startsWith('EE');
  // AS-IS clbTeam_SelectedIndexChanged 의 분기 조건(division == "81" || "82", cs:4731 부근). 81_UC 등 하위 코드는 포함하지 않는다.
  const isDeptCustomerDivision = sc.divisionId === '81' || sc.divisionId === '82';

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
  // ToSite 2차 재조회(Team 변경 시, design 02 §2.6) — clbTeam_SelectedIndexChanged 가 clbToSite 를
  // SiteByEndCustomer(81/82)/SiteByEndCustomer40(그 외)로 다시 채운다(gap-audit NEW2).
  // AS-IS 의 End Customer 컨트롤(clbCustomer)은 Visibility=Never 숨김이라 조회조건으로 두지 않는다. 다만 81/82 는
  //   Team 의 End Customer 후보 전체를 endCustomer 로 넘겨 To Site 를 좁힌다(SiteByEndCustomer 에는 deptId 가 없어
  //   'ALL' 로는 Team 이 반영되지 않는다). 그 외 division 은 AS-IS 도 'ALL' 을 그대로 넘긴다.
  const hasTeam = sc.teamIds.length > 0;
  const [endCustomersByTeam] = useTabComboQueries({
    filters: [{ comboId: COMBO.END_CUSTOMER_DEPT, divisionId: sc.divisionId, deptId: sc.teamIds.join(',') }],
    enabled: isDeptCustomerDivision && hasTeam,
  });
  const endCustomerParam = isDeptCustomerDivision
    ? (endCustomersByTeam ?? []).map(r => str(r.CODE)).join(',') || 'ALL'
    : 'ALL';
  const siteByEndCustomerComboId = isDeptCustomerDivision ? COMBO.SITE_BY_END_CUSTOMER : COMBO.SITE_BY_END_CUSTOMER_40;
  const [toSitesByTeam] = useTabComboQueries({
    filters: [
      {
        comboId: siteByEndCustomerComboId,
        divisionId: sc.divisionId,
        endCustomer: endCustomerParam,
        deptId: sc.teamIds.join(',') || 'ALL',
        projectCode: sc.projectCode || 'ALL',
      },
    ],
    // 81/82 는 후보 로드 후에 조회해 'ALL' 로 한 번 더 조회하는 중복 호출을 막는다.
    enabled: hasTeam && (!isDeptCustomerDivision || endCustomerParam !== 'ALL'),
  });
  // Electrode — 초기 1회 로드, division EE 여부로 Enabled 만 토글(값 재조회 없음, design 02 §2.7)
  const [electrodes] = useTabComboQueries({
    filters: [{ comboId: COMBO.ELECTRODE, lookupType: ELECTRODE_LOOKUP_TYPE }],
  });
  // PlanDate->PlanType->PlanSeq 3단 cascade(design 02 §2.8, 전량+클라 필터)
  const [planDates] = useTabComboQueries({ filters: [COMBO.PLAN_DATE] });
  const [planTypes] = useTabComboQueries({ filters: [COMBO.PLAN_TYPE] });
  const [planSeqs] = useTabComboQueries({ filters: [COMBO.PLAN_SEQ] });
  const [buckets] = useTabComboQueries({ filters: [COMBO.BUCKET] });
  const bucketOptions = toOptions(buckets);

  // Division 81->40->기타 수동정렬(gap-resolve iter-1 CONF-1 해소) — AS-IS
  //   SCP0009_Shipment_Plan_FG.cs:473-488 "2021.10.22 : DIV 순서 변경"이 CODE='81'을 SORT_ORDER=1,
  //   '40'을 2, 그 외 전부 3으로 부여해 재정렬한다(동순위 내부 상대순서는 원 목록 순서 유지,
  //   Array.sort 안정정렬로 재현 — AS-IS는 InsertAt(0) 반복이라 3순위 내부가 역순이 되는 미세한
  //   차이가 있으나 핵심 요구사항(81/40 선두 승격)은 동일하게 재현한다).
  const divisionSortRank = (code: string): number => (code === '81' ? 1 : code === '40' ? 2 : 3);
  const divisionOptions = toOptions(divisions).sort(
    (a, b) => divisionSortRank(a.value) - divisionSortRank(b.value)
  );
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
  // 단일선택 콤보 기본선택 — AS-IS 는 콤보 DataSource 바인딩 시 WinForms 가 첫 행을 자동 선택한다
  //   (CControl.setListBox(ComboBox) 가 Items 가 있으면 SelectedIndex=0, DataSource 바인딩도 동일).
  //   Division(InitControls 497행) -> OperationGroup/PlanDate(SetChangedControl 552/555행)는 첫 행,
  //   PlanType 은 마지막 행(RefreshPlanType 453-454행), PlanSeq 는 첫 행(CboPlanType_SelectedIndexChanged
  //   1246행 SelectedIndex=0). 값이 비었거나 목록에 없을 때만 채워 사용자가 고른 값은 건드리지 않는다.
  const firstDivision = divisionOptions[0]?.value ?? '';
  useEffect(() => {
    if (firstDivision && !sc.divisionId) set({ divisionId: firstDivision });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDivision, sc.divisionId]);

  const firstOperationGroup = operationGroupOptions[0]?.value ?? '';
  useEffect(() => {
    if (sc.divisionId && firstOperationGroup && !operationGroupOptions.some(o => o.value === sc.operationGroupId)) {
      set({ operationGroupId: firstOperationGroup });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.operationGroupId, firstOperationGroup]);

  const firstPlanDate = planDateOptions[0]?.value ?? '';
  useEffect(() => {
    if (sc.divisionId && firstPlanDate && !planDateOptions.some(o => o.value === sc.planStartYyyymmdd)) {
      // Period(dCalendar)는 PlanDate 선택 시 W52 재설정(AS-IS CboPlanDate_SelectedIndexChanged → GetDayRange(W52)).
      set({
        planStartYyyymmdd: firstPlanDate,
        planType: '',
        planSeq: '',
        ...getDayRange(dayjs(firstPlanDate, 'YYYYMMDD'), 52),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.planStartYyyymmdd, firstPlanDate]);

  // PlanType 자동 최신행 선택(design 02 §2.8 RefreshPlanType — dtPlanType 마지막 행). AS-IS 는
  //   division+planDate 로 필터한 목록의 마지막 행이므로 planDate 가 정해진 뒤에만 선택한다. 의존성에
  //   sc.planType 이 빠지면 planType 이 ''로 리셋돼도 latestPlanType 문자열이 같을 때 effect 가 재실행되지
  //   않아 자동선택이 누락된다(fcea709a 회귀 수정).
  const latestPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (sc.planStartYyyymmdd && latestPlanType && !planTypeOptions.some(o => o.value === sc.planType)) {
      set({ planType: latestPlanType, planSeq: '' });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.planStartYyyymmdd, sc.planType, latestPlanType]);

  const firstPlanSeq = planSeqOptions[0]?.value ?? '';
  useEffect(() => {
    if (sc.planType && firstPlanSeq && !planSeqOptions.some(o => o.value === sc.planSeq)) {
      set({ planSeq: firstPlanSeq });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.planType, sc.planSeq, firstPlanSeq]);

  // Plan Seq 콤보 후보 중 최댓값 — Fix/Unfix 버튼 disabled 판정(design 01 §2 #2 Set_FixButtonEnabled,
  //   'curPlanSeq==maxSeq' AND 조건)에 페이지 레벨(ShipmentPlanFg.tsx)이 쓸 수 있게 store 로 올린다
  //   (gap-resolve iter-1 NEW7 — 이전 구현은 이 값이 Form 컴포넌트 로컬에 갇혀 있었다).
  //   AS-IS `dtPlanSeq.Max(CODE)`(.cs:3990)와 같게 숫자 최댓값을 쓴다. 콤보 SQL 이 plan_seq DESC 정렬이라
  //   마지막 옵션은 최솟값이다(기본 선택은 첫 옵션=최댓값).
  const latestPlanSeq = planSeqOptions.reduce(
    (max, o) => (max === '' || Number(o.value) > Number(max) ? o.value : max),
    ''
  );
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
        label={t(labelCode, labelEn)}
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
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
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
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // Division 변경 = 하위 7개 콤보 cascade 초기화(design 02 §6). 편집중(dirty)이면 MSG00704
                    //   confirm 후에만 적용 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를 콤보 변경에도
                    //   동일 적용(shipment-plan-fix 자매 화면과 같은 패턴, commit 51d4e9fa). controlled 콤보라
                    //   취소 시 이전 Division 으로 자동 복귀.
                    // 그리드 비우기(AS-IS CboPlanDate_SelectedIndexChanged 의 SpreadInfo.ClearDataSource 파리티) —
                    //   Division 변경이 Plan Date 를 비우면서 AS-IS 는 그 연쇄로 그리드도 비운다. TO-BE 는
                    //   searchCondition 과 filters(그리드 조회조건)가 분리돼 있어 명시적으로 같이 비워야
                    //   한다(2026-10-13 실측 — 안 비우면 이전 Division 그리드가 그대로 남는다).
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      set({
                        divisionId: String(picked ?? ''),
                        operationGroupId: '',
                        fromSiteIds: [],
                        toSiteIds: [],
                        teamIds: [],
                        electrodeTypeIds: [],
                        planStartYyyymmdd: '',
                        planType: '',
                        planSeq: '',
                      });
                      clearFilters();
                    })
                  }
                />
              )}
            />
          </Grid>
          {single(LBL.OPERATION_GROUP, '_Operation Group', sc.operationGroupId, operationGroupOptions, v =>
            set({ operationGroupId: v })
          , true)}
          {single(LBL.PLAN_DATE, '_Plan Date', sc.planStartYyyymmdd, planDateOptions, v =>
            // PlanDate 변경 = PlanType/Seq 리셋 + Period(dCalendar) W52 재설정(design 02 §3 cascade,
            //   AS-IS CboPlanDate_SelectedIndexChanged → GetDayRange(W52) anchor=선택 PlanDate).
            set({
              planStartYyyymmdd: v,
              planType: '',
              planSeq: '',
              ...(v ? getDayRange(dayjs(v, 'YYYYMMDD'), 52) : {}),
            })
          , true)}
          {single(LBL.PLAN_TYPE, '_Plan Type', sc.planType, planTypeOptions, v =>
            set({ planType: v, planSeq: '' })
          , true)}
          {single(LBL.SEQ, '_Seq', sc.planSeq, planSeqOptions, v => set({ planSeq: v }), true)}

          {/* Period(dCalendar)* — design 02 §2.9. 기간 프리셋(W26/W52/W82)은 PeriodRangePicker 팝업에 내장돼 있다. */}
          <Grid size={3}>
            <PeriodRangePicker
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(from, end) => set({ fromYyyymmdd: from, toYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
              required
              className={commonStyles.formItem}
              quickWeeks={[26, 52, 82]}
            />
          </Grid>

          {/* Bucket(cboBucketType)->ALL(chkAll)->Sum(chkSum) — Period 오른쪽 배치(AS-IS 조회조건 영역). AS-IS 에는
              chkAll 의 CheckedChanged 핸들러가 없어 ALL 체크와 무관하게 Bucket 을 바꿀 수 있다(Daily 강제는 조회 시 서버 SP 가 수행). */}
          {single(LBL.BUCKET, '_Bucket', sc.bucketType, bucketOptions, v => onChangeBucketType(v as BUCKET_TYPE))}
          {/* ALL(chkAll)은 화면에 노출하지 않는다 — 스토어 기본값(true) 고정으로 서버에 P_CHK_ALL='Y' 를 보낸다. */}
          {/* Sum 은 Plan Type 입력칸과 같은 x 에서 시작해야 한다. 빈 라벨 FormItem 으로 라벨 트랙을 확보한다
              (label='' 은 falsy 라 트랙이 생기지 않아 NBSP 를 쓴다 — business-plan 폼 동일 패턴). */}
          <Grid size={3}>
            <FormItem
              label={' '}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox checked={sc.chkSum} onChange={checked => set({ chkSum: checked })} />
                  <Label labelText={t(LBL.SUM, '_Sum')} depth='sub' />
                </div>
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {multi(LBL.FROM_SITE, '_From Site', sc.fromSiteIds, fromSiteOptions, fromSiteIds => set({ fromSiteIds }))}
          {multi(LBL.TO_SITE, '_To Site', sc.toSiteIds, toSiteOptions, toSiteIds => set({ toSiteIds }))}
          {multi(LBL.TEAM, '_Team', sc.teamIds, teamOptions, teamIds =>
            // Team 변경 = ToSite 2차 재조회 트리거(design 02 §2.6)
            set({ teamIds })
          )}
          {multi(
            LBL.ELECTRODE,
            '_Electrode',
            sc.electrodeTypeIds,
            electrodeOptions,
            electrodeTypeIds => set({ electrodeTypeIds }),
            !isEE // division EE 여부로 Enabled 만 토글(design 02 §2.7) — 비활성 시 선택값 유지 안 함
          )}

          {/* Project — txtProject + btnProject -> ProjectByDivisionModal(design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PROJECT, '_PJT')}
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
              label={t(LBL.MODEL, '_Model/Nickname')}
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
        </>
      }
    />
  );
};
