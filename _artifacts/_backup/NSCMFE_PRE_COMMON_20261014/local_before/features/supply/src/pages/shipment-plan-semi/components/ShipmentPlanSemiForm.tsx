import { PeriodField } from 'features/master/src/components/searchFields';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField, Button } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, ELECTRODE_LOOKUP_TYPE, LBL, OPERATION_GROUP_LOOKUP_TYPE } from '../shipment-plan-semi.constants';
import { useShipmentPlanSemiStore } from '../useShipmentPlanSemiStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 combo — 14개 상호작용 컨트롤, 12 comboCalls 전건.
//   모든 콤보가 "화면 전용 필터"(SP 전량 반환 + 클라 필터, design 02 §3) — BigFilter 미적용.
export const ShipmentPlanSemiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanSemiStore(s => s.searchCondition);
  const set = useShipmentPlanSemiStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentPlanSemiStore(s => s.openSearchArea);

  const isEE = sc.divisionId.startsWith('EE');
  const isEEUC = sc.divisionId === 'EE_UC';

  // OperationGroup — division EE 여부로 lookupType 자체가 분기(design 02 §2.2, base LookupCommon 공용 SQL).
  const operationGroupLookupType = isEE ? OPERATION_GROUP_LOOKUP_TYPE.EE : OPERATION_GROUP_LOOKUP_TYPE.NORMAL;

  // ToSite 2원천 분기(design 02 §2.4): EE_UC 또는 그 외(81/82/40 등) -> TO_SITE_ALL,
  //   EE(UC 제외) -> TO_SITE_EE_LOOKUP. SCP0009 유사이름 콤보와 절대 혼동 금지(convert-core §2.6).
  const toSiteComboId = isEE && !isEEUC ? COMBO.TO_SITE_EE_LOOKUP : COMBO.TO_SITE_ALL;

  const [divisions, operationGroups, fromSites, toSites] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.OPERATION_GROUP, lookupType: operationGroupLookupType },
      COMBO.FROM_SITE,
      toSiteComboId,
    ],
  });
  // Electrode — 초기 1회 로드, division EE 여부로 Enabled 만 토글(값 재조회 없음, design 02 §2.5).
  const [electrodes] = useTabComboQueries({
    filters: [{ comboId: COMBO.ELECTRODE, lookupType: ELECTRODE_LOOKUP_TYPE }],
  });
  // PlanDate->PlanType->PlanSeq 3단 cascade(design 02 §2.6, 전량+클라 필터)
  const [planDates] = useTabComboQueries({ filters: [COMBO.PLAN_DATE] });
  const [planTypes] = useTabComboQueries({ filters: [COMBO.PLAN_TYPE] });
  const [planSeqs] = useTabComboQueries({ filters: [COMBO.PLAN_SEQ] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);

  // FromSite 클라 필터(design 02 §2.3, 3갈래: EE_UC/EE(UC제외)/그외)
  const fromSiteFilterDivisionIds = (): string[] => {
    if (isEEUC) return ['81_UC'];
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
  // ToSite 클라 필터(design 02 §2.4) — EE_UC 는 '81_UC' 고정, 그 외는 division 그대로.
  const toSiteFilterDivisionIds = (): string[] => (isEEUC ? ['81_UC'] : [sc.divisionId]);
  const toSiteDivisionIds = new Set(toSiteFilterDivisionIds());
  const toSiteOptions = toOptions(
    (toSites ?? []).filter(
      r =>
        toSiteDivisionIds.has(str(r.DIVISION_ID)) &&
        (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  const electrodeOptions = toOptions(electrodes);
  // PlanDate 클라 필터(division), PlanType 클라 필터(division+planDate, 자동 최신행), PlanSeq(+planType, DESC 자동최대값)
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
  // PlanType 자동 최신행 선택(design 02 §2.6 RefreshPlanType — dtPlanType 마지막 행)
  const latestPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (latestPlanType && sc.planType !== latestPlanType && !planTypeOptions.some(o => o.value === sc.planType)) {
      set({ planType: latestPlanType });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [latestPlanType]);
  // PlanSeq 는 SQL DESC 정렬로 첫 행이 최댓값 — cboPlanType 확정 후 자동선택(design 02 §2.6).
  const maxPlanSeq = planSeqOptions[0]?.value ?? '';
  useEffect(() => {
    if (maxPlanSeq && sc.planSeq !== maxPlanSeq && !planSeqOptions.some(o => o.value === sc.planSeq)) {
      set({ planSeq: maxPlanSeq });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [maxPlanSeq]);

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
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown value={value} options={options} onChange={(_, picked) => onPick(String(picked ?? ''))} />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 필드 9건, hook #52(search-area-extra-conditions) 기준 필수(*)+Period 만 conditions 에 두고
      //   나머지(cascade 종속/보조 필터)는 extraConditions 로 분리(nscm-patterns.md §6).
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
                    // Division 변경 = 하위 콤보 cascade 초기화(design 02 §6)
                    set({
                      divisionId: String(picked ?? ''),
                      operationGroupId: '',
                      fromSiteIds: [],
                      toSiteIds: [],
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
          {single(LBL.OPERATION_GROUP, '_Operation Group', sc.operationGroupId, operationGroupOptions, v =>
            set({ operationGroupId: v })
          , true)}
          {/* defaultValue 는 i18n 리소스 로드 실패 시에만 쓰이는 fallback 문구 — 정상 로드 시엔
              t() 가 LBL00039/40 의 DB 등록값("Plan Date"/"Plan Type")을 그대로 반환한다(design 02
              §4.5 재실측, KO/EN/CN 전부 공백 표기 확인). fallback 문구도 DB 값과 동일하게 맞춘다
              — 하이픈 표기("Plan-date"/"Plan-type")는 등록값과 다른 문구라 fallback 경로에서만
              드러나는 드리프트였다(iter-2 gap-audit SCP0010-G-10). 신규 채번은 하지 않는다(등록값
              재사용 — 사용자가 별도로 하이픈 표기 확정을 요구하면 그때 신규 LBL 을 채번한다). */}
          {single(LBL.PLAN_DATE, '_Plan Date', sc.planStartYyyymmdd, planDateOptions, v =>
            set({ planStartYyyymmdd: v, planType: '', planSeq: '' })
          , true)}
          {single(LBL.PLAN_TYPE, '_Plan Type', sc.planType, planTypeOptions, v =>
            set({ planType: v, planSeq: '' })
          , true)}
          {single(LBL.SEQ, '_Seq', sc.planSeq, planSeqOptions, v => set({ planSeq: v }), true)}

          {/* Period(dCalendar)* — design 02 §2.7. From/To 만(§4 검증에서 실질 제외, W26/52/Last SP 미배포) */}
          <PeriodField
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(from, end) => set({ fromYyyymmdd: from, toYyyymmdd: end })}
            gridSize={6}
            label={t(LBL.PERIOD, '_Period')}
          />
        </>
      }
      extraConditions={
        <>
          {multi(LBL.FROM_SITE, '_From Site', sc.fromSiteIds, fromSiteOptions, fromSiteIds => set({ fromSiteIds }))}
          {multi(LBL.TO_SITE, '_To Site', sc.toSiteIds, toSiteOptions, toSiteIds => set({ toSiteIds }))}
          {multi(
            LBL.ELECTRODE,
            '_Electrode',
            sc.electrodeTypeIds,
            electrodeOptions,
            electrodeTypeIds => set({ electrodeTypeIds }),
            !isEE // division EE 여부로 Enabled 만 토글(design 02 §2.5) — 비활성 시 선택값 미유지
          )}

          {/* Model — txtItemId + btnItem_Id -> ItemByDivisionModal(design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
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

          {/* chkSum/cboBucketType/btnMeasure — design 00_checklist §1 area=3(그리드) 분류.
              여기 배치하지 않는다. ShipmentPlanSemiGrid 툴바에 있다. */}
        </>
      }
    />
  );
};
