import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../production-plan-waterfall.constants';
import {
  COMBO,
  ELECTRODE_LOOKUP,
  isEeDivision,
  LBL,
  MENU_ID,
  MSG,
} from '../production-plan-waterfall.constants';
import { useProductionPlanWaterfallStore } from '../useProductionPlanWaterfallStore';

interface Props {
  onSearch: () => void;
  onModelSearch: () => void; // Model 팝업(ItemByDivisionModal) 오픈 — 페이지 소유
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 12 컨트롤 + cascade 재조회(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / plantSite / line / version + electrode(enable). 부모값을 콤보
//   파라미터로 실어 하위 콤보 재조회(react-query 키에 부모값 포함, convert-core §2.6 의미 패리티).
//   PlantSite 수동변경 시 Line 재조회 안 함(design 02 §3 파리티 — Line 재조회 키 = {division, opGroup}).
export const ProductionPlanWaterfallForm = ({ onSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanWaterfallStore(s => s.searchParams);
  const set = useProductionPlanWaterfallStore(s => s.setSearchParams);
  const setDivision = useProductionPlanWaterfallStore(s => s.setDivision);
  const setVersions = useProductionPlanWaterfallStore(s => s.setVersions);
  const setChkAll = useProductionPlanWaterfallStore(s => s.setChkAll);
  const openSearchArea = useProductionPlanWaterfallStore(s => s.openSearchArea);
  const setNoDivisionAuth = useProductionPlanWaterfallStore(s => s.setNoDivisionAuth);
  const setAlert = useMessageStore.getState().setAlert;

  const isEe = isEeDivision(sc.divisionId);

  // 콤보 — 부모값 파라미터 재조회(cascade). isEe 로 opGroup/plantSite/line SQL_ID 스왑(별개 코드셋, 이름 대조 금지).
  //   Line 파라미터에 plantSite 미포함(design 02 §3 파리티 — 수동 plantSite 변경 시 Line 재조회 금지).
  const [divisions, operationGroups, plantSites, lines, versions, buckets] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      isEe
        ? { comboId: COMBO.PLANT_SITE_EE, attribute2: sc.divisionId, segment2: sc.operationGroupId }
        : { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId, operationGroup: sc.operationGroupId },
      isEe
        ? { comboId: COMBO.LINE_EE, attribute2: sc.divisionId, operationGroup: sc.operationGroupId }
        : { comboId: COMBO.LINE, divisionId: sc.divisionId },
      { comboId: COMBO.VERSION, divisionId: sc.divisionId },
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const plantSiteOptions = toOptions(plantSites);
  // Line 옵션 — '-' sentinel 제외(조회 파라미터에서 '' 치환은 store, design 02 §2 #4).
  const lineOptions = toOptions((lines ?? []).filter(r => str(r.CODE) !== '-'));
  const versionOptions = toOptions(versions);
  const bucketOptions = toOptions(buckets);
  // electrode 는 lookup(LookupResponse — index signature) — CODE/NAME 직접 매핑.
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // Division 권한 게이트(design 01 L1, SetDivisionAuthCheck cs:211~212) — 권한 Division 0건이면 조회영역
  //   입력 disable + 조회 미발사 + 권한없음 안내 1회. divisions 로드 완료(undefined 아님) 후에만 판정해
  //   콤보 조회 중 오차단 방지. 메시지 = MSG00667('No authority assigned.', AS-IS MSG00097 의도 매칭 TO-BE
  //   코드, Hook #114 — 자매 inventory-trend 선례). MyDivisionInEE_SCP 는 EE 미제외라 클라 추가 필터 없음.
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_No authority assigned.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 조회영역 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle/Search)도 막도록 store 로 승계.
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행, design 02 §4.4).
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

  // 비EE division → Electrode 값 clear + disable (design 01 L8 / 02 §4.5).
  useEffect(() => {
    if (!isEe && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [isEe, sc.electrodeTypes.length, set]);

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
            disabled={disabled || noDivisionAuth}
            value={value.length ? value.join(',') : 'ALL'}
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
          <CustomDropdown
            value={value}
            options={options}
            disabled={noDivisionAuth}
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
      conditions={
        <>
          {/* Row0 — Division* / Operation Group* / Plant Site / Line / Version* / Electrode */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            setDivision,
            true
          )}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v })
          )}
          {multi(t(LBL.LINE, '_Line'), sc.lineIds, lineOptions, v =>
            set({ lineIds: v })
          )}
          {/* Version — AS-IS 체크리스트 단일 UI 이나 Gap 시 2건 필요(design 02 §7-3) → 다중 허용.
              변경 시 Period 재산정(AS-IS CboVersion_SelectedIndexChanged → GetDayRange, G2) — setVersions 경유. */}
          {multi(t(LBL.VERSION, '_Version'), sc.versionNos, versionOptions, v =>
            setVersions(v)
          )}
          {/* Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 L8). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}
        </>
      }
      extraConditions={
        <>
          {/* Row1 — Bucket / Period* / Model(팝업) / Nick Name */}
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, bucketOptions, v =>
            set({ bucket: v as BUCKET_TYPE })
          )}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onModelSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ modelId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  disabled={noDivisionAuth}
                  onChange={e => set({ nickName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Row2 — 체크박스 Gap / All / Sum */}
          <Grid size={6} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t(LBL.GAP, '_Gap')}
                  checked={sc.chkGap}
                  onChange={checked => set({ chkGap: checked })}
                />
                {/* All(전체기간) — 토글 시 AS-IS ChkAll_CheckedChanged 등가로 그리드 비움(재조회 요구, G1). */}
                <Checkbox
                  labelText={t(LBL.ALL, '_All')}
                  checked={sc.chkAll}
                  onChange={checked => setChkAll(checked)}
                />
                <Checkbox
                  labelText={t(LBL.SUM, '_Sum')}
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
