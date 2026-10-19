import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import {
  COMBO,
  ELECTRODE_LOOKUP,
  LABEL,
  PRESET_W26,
  PRESET_W52,
  W_LAST_HIDE_PERIOD,
} from '../production-plan-line.constants';
import type { BUCKET_TYPE } from '../production-plan-line.constants';
import { useProductionPlanLineStore } from '../useProductionPlanLineStore';
import {
  isCellTypeExtraSpecEnabled,
  isEeDivision,
  isElectrodeEnabled,
} from '../utils/productionPlanLineEditLock';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // 기간 프리셋 — 부모(페이지)가 GetDayRange 등가 산정으로 dCalendar 구간을 세팅.
  onPreset: (weeks: number) => void;
  wLastPeriod: string; // btnWLast 텍스트 주차(=GetLastRange(division)). '52' 면 버튼 숨김.
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 21 컨트롤 + cascade 그래프(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / plantSite / line / planDate→Type→Seq / cellTypeGr·extraSpec(div=40).
//   AS-IS CommonAll(전량) + DBUtils.Filter 를 반환컬럼 클라 필터로 재현(convert-core §2.6). 콤보 등록 실측(design 02 §2.4).
export const ProductionPlanLineForm = ({ onSearch, onItemSearch, onPreset, wLastPeriod }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanLineStore(s => s.searchCondition);
  const set = useProductionPlanLineStore(s => s.setSearchCondition);
  const setDivision = useProductionPlanLineStore(s => s.setDivision);
  const openSearchArea = useProductionPlanLineStore(s => s.openSearchArea);

  const isEe = isEeDivision(sc.divisionId);
  const cellTypeEnabled = isCellTypeExtraSpecEnabled(sc.divisionId);
  const electrodeEnabled = isElectrodeEnabled(sc.operationGroupId);
  const showWLast = wLastPeriod !== W_LAST_HIDE_PERIOD; // design 01 A3

  // 콤보 — 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  //   operationGroup 은 EE 여부로 콤보 스왑(이름 대조 금지 — 별개 코드셋, convert-core §2.6).
  const [
    divisions,
    operationGroups,
    plantSites,
    lines,
    cellTypeGrs,
    planDates,
    planTypes,
    planSeqs,
    buckets,
  ] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      COMBO.PLANT_SITE,
      COMBO.LINE,
      COMBO.CELL_TYPE_GR,
      COMBO.PLAN_DATE,
      COMBO.PLAN_TYPE,
      COMBO.PLAN_SEQ,
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);
  const cellTypeGrOptions = toOptions(cellTypeGrs);
  // electrode 는 lookup(LookupResponse — index signature) — CODE/NAME 로 직접 매핑(tact-time 규약).
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // division 하위 클라 필터 (AS-IS DBUtils.Filter DIVISION_ID, design 02 §2.3).
  const inDivision = (r: ComboResponse): boolean =>
    !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId;
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(
      r => inDivision(r) && (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  // line: division + 선택 plantSite(SITE_ID) 하위. '-' sentinel 제외(design 02 §2.1).
  const lineOptions = toOptions(
    (lines ?? []).filter(
      r =>
        str(r.CODE) !== '-' &&
        inDivision(r) &&
        (sc.plantSiteIds.length === 0 || sc.plantSiteIds.includes(str(r.SITE_ID)))
    )
  );
  const planDateOptions = toOptions((planDates ?? []).filter(inDivision));
  const planTypeOptions = toOptions(
    (planTypes ?? []).filter(
      r =>
        inDivision(r) &&
        (sc.planStartYyyymmdds.length === 0 ||
          sc.planStartYyyymmdds.includes(str(r.PLANDATE)))
    )
  );
  const planSeqOptions = toOptions(
    (planSeqs ?? []).filter(
      r =>
        inDivision(r) &&
        (sc.planStartYyyymmdds.length === 0 || sc.planStartYyyymmdds.includes(str(r.PLANDATE))) &&
        (sc.planTypes.length === 0 || sc.planTypes.includes(str(r.PLANTYPE)))
    )
  );

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행 근사, design 02 §4.3).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetChangedControl 기본 구성).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  // planType 기본 = 마지막 행(design 02 §4.3 RefreshPlanType), planSeq 기본 = 첫 항목(최신).
  const lastPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (lastPlanType && sc.planTypes.length === 0) set({ planTypes: [lastPlanType] });
  }, [lastPlanType, sc.planTypes.length, set]);
  const firstPlanSeq = planSeqOptions[0]?.value ?? '';
  useEffect(() => {
    if (firstPlanSeq && sc.planSeqs.length === 0) set({ planSeqs: [firstPlanSeq] });
  }, [firstPlanSeq, sc.planSeqs.length, set]);

  // opGroup A/P → electrode ALL 고정 + disable (design 01 C1).
  useEffect(() => {
    if (!electrodeEnabled && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [electrodeEnabled, sc.electrodeTypes.length, set]);
  // div!=40 → cellTypeGr/extraSpec clear (design 01 B2).
  useEffect(() => {
    if (!cellTypeEnabled && (sc.cellTypeGrs.length > 0 || sc.extraSpecs.length > 0))
      set({ cellTypeGrs: [], extraSpecs: [] });
  }, [cellTypeEnabled, sc.cellTypeGrs.length, sc.extraSpecs.length, set]);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
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
              // 'ALL' sentinel 은 빈 배열로 정규화(하위 cascade 오매칭 방지 — tact-time 규약).
              onPick(String(picked ?? '').split(',').filter(v => v !== '' && v.toUpperCase() !== 'ALL'))
            }
          />
        )}
      />
    </Grid>
  );

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
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
      searchButtonLabel={t('LBL00664', { defaultValue: LABEL.SEARCH })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row0 — Division* / Operation Group* / Cell Type Gr / Electrode / Extra Spec */}
          {single(t('LBL00641', { defaultValue: LABEL.DIVISION }), sc.divisionId, divisionOptions, setDivision, true)}
          {single(
            t('LBL00027', { defaultValue: LABEL.OPERATION_GROUP }),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {multi(t('LBL00000', { defaultValue: LABEL.CELL_TYPE_GR }), sc.cellTypeGrs, cellTypeGrOptions, v => set({ cellTypeGrs: v }), !cellTypeEnabled)}
          {multi(t('LBL00000', { defaultValue: LABEL.ELECTRODE }), sc.electrodeTypes, electrodeOptions, v => set({ electrodeTypes: v }), !electrodeEnabled)}
          {/* Extra Spec — TO-BE 전용 콤보 미탐(design 02 §7), 옵션 미공급. div=40 에서만 enable. */}
          {multi(t('LBL00000', { defaultValue: LABEL.EXTRA_SPEC }), sc.extraSpecs, [], v => set({ extraSpecs: v }), !cellTypeEnabled)}

          {/* Row1 — Plant Site / Line / Model / Material(🔍) / Nick Name / Line Assign */}
          {multi(t('LBL00005', { defaultValue: LABEL.PLANT_SITE }), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v, lineIds: [] })
          )}
          {multi(t('LBL00010', { defaultValue: LABEL.LINE }), sc.lineIds, lineOptions, v => set({ lineIds: v }))}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', { defaultValue: LABEL.MODEL })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.modelId}
                  onChange={e => set({ modelId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00000', { defaultValue: LABEL.MATERIAL })}
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
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00000', { defaultValue: LABEL.NICK_NAME })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  onChange={e => set({ nickName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Row2 — Plan-date* / Plan-type* / Seq* / Period*(+프리셋) / Bucket / 체크박스 */}
          {multi(t('LBL00000', { defaultValue: LABEL.PLAN_DATE }), sc.planStartYyyymmdds, planDateOptions, v =>
            set({ planStartYyyymmdds: v, planTypes: [], planSeqs: [] })
          )}
          {multi(t('LBL00000', { defaultValue: LABEL.PLAN_TYPE }), sc.planTypes, planTypeOptions, v =>
            set({ planTypes: v, planSeqs: [] })
          )}
          {multi(t('LBL00000', { defaultValue: LABEL.SEQ }), sc.planSeqs, planSeqOptions, v => set({ planSeqs: v }))}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t('LBL00505', { defaultValue: LABEL.PERIOD })}
          />
          {single(
            t('LBL00000', { defaultValue: LABEL.BUCKET }),
            sc.bucket,
            bucketOptions,
            v => set({ bucket: v as BUCKET_TYPE })
          )}

          {/* 기간 프리셋 W26/W52/WLast (design 01 H5 / A3) */}
          <Grid size={3} className={commonStyles.customGrid}>
            <Stack direction='row' spacing={1} alignItems='center'>
              <Button appearance='outlined' priority='normal' onClick={() => onPreset(PRESET_W26)}>
                W26
              </Button>
              <Button appearance='outlined' priority='normal' onClick={() => onPreset(PRESET_W52)}>
                W52
              </Button>
              {showWLast && (
                <Button appearance='outlined' priority='normal' onClick={() => onPreset(Number(wLastPeriod) || PRESET_W26)}>
                  {`W${wLastPeriod || ''}`}
                </Button>
              )}
            </Stack>
          </Grid>

          {/* 체크박스 — ALL(daily 분배) / Line Assign(Material 필수) / Sum(SUM 컬럼 토글) */}
          <Grid size={6} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00000', { defaultValue: LABEL.ALL })}
                  checked={sc.chkAll}
                  onChange={checked => set({ chkAll: checked })}
                />
                <Checkbox
                  labelText={t('LBL00000', { defaultValue: LABEL.LINE_ASSIGN })}
                  checked={sc.chkLineAssign}
                  onChange={checked => set({ chkLineAssign: checked })}
                />
                <Checkbox
                  labelText={t('LBL00687', { defaultValue: LABEL.SUM })}
                  checked={sc.chkSum}
                  onChange={checked => set({ chkSum: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
