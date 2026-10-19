import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import type {
  BUCKET_TYPE} from '../shipment-plan-fix.constants';
import {
  COMBO,
  ELECTRODE_LOOKUP,
  LABEL,
  PRESET_W26,
  PRESET_W52,
  W_LAST_HIDE_PERIOD,
} from '../shipment-plan-fix.constants';
import { useShipmentPlanFixStore } from '../useShipmentPlanFixStore';
import { isEeDivision } from '../utils/shipmentPlanFixVisibility';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // 기간 프리셋 — 부모(페이지)가 GetDayRange 등가 산정(offset=주×7-1)으로 dCalendar 구간을 세팅.
  onPreset: (weeks: number) => void;
  wLastPeriod: string; // btnWLast 텍스트 주차(=GetLastRange(division)). '52' 면 버튼 숨김(자매 SCP0024 선례).
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 인벤토리 C1~C12 + cascade 그래프(§3).
//   cboDivision(최상위) → cboBizType(EE 여부로 OperationGroup(EE)_SCP 스왑, 재조회형). clbElecType 독립 다중.
//   SCP0024 와 달리 Plant Site/Line 콤보·클라 필터 없음(filterCalls 0, design 02 §2 주). cascade 는 Division→OperationGroup 1단.
//   EE 판정 = division ∈ FN_GET_DIVISION_DIV('EE') 목록(design 03 §2.7 실측) → 콤보 코드셋 선택(이름 대조 금지, convert-core §2.6).
export const ShipmentPlanFixForm = ({ onSearch, onItemSearch, onPreset, wLastPeriod }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanFixStore(s => s.searchCondition);
  const set = useShipmentPlanFixStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanFixStore(s => s.setDivision);
  const openSearchArea = useShipmentPlanFixStore(s => s.openSearchArea);

  const isEe = isEeDivision(sc.divisionId);
  const showWLast = wLastPeriod !== W_LAST_HIDE_PERIOD; // design 02 §7-8 (GetLastRange==52 면 숨김, 자매 SCP0024)

  // 콤보 — Division / OperationGroup(EE 스왑) / Bucket. cboBizType 는 EE 여부로 코드셋 스왑(별개 콤보, convert-core §2.6).
  const [divisions, operationGroups, buckets] = useTabComboQueries({
    filters: [COMBO.DIVISION, isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP, COMBO.BUCKET],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행 근사, design 02 §4).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetOperationGroupByDivision 기본 구성).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void
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
            // 빈 배열(= 필터 없음)은 'ALL' sentinel 로 되돌려 넘긴다(전체선택 상태 왕복 — 자매 규약).
            value={value.length ? value.join(',') : 'ALL'}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
              )
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
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: LABEL.SEARCH })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // Row0 (2단, 항상 노출): Division* / Operation Group / Item / Electrode.
      conditions={
        <>
          {single(t('LBL00641', { defaultValue: LABEL.DIVISION }), sc.divisionId, divisionOptions, setDivision, true)}
          {single(
            t('LBL00027', { defaultValue: LABEL.OPERATION_GROUP }),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            // Operation Group(bizType)은 GET SP 필수 등식(`AND A.BIZ_TYPE = :BIZ_TYPE`, null-branch 없음, SP body 실측)
            //   이라 Division 과 동일 필수 — required 표기로 방어 비대칭 해소(react-gap-audit GAP-07). 옵션 로드 시 첫옵션 자동선택.
            true
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01142', { defaultValue: LABEL.ITEM })}
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
          {multi(t('LBL00038', { defaultValue: LABEL.ELECTRODE }), sc.electrodeTypes, electrodeOptions, v =>
            set({ electrodeTypes: v })
          )}
        </>
      }
      // 3단째부터 extraConditions 분리(hook #52 — 2단 초과 접기/펼치기): Bucket / Period(+프리셋) / SUM.
      extraConditions={
        <>
          {single(
            t('LBL00710', { defaultValue: LABEL.BUCKET }),
            sc.bucket,
            bucketOptions,
            v => set({ bucket: v as BUCKET_TYPE })
          )}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t('LBL00013', { defaultValue: LABEL.PERIOD })}
          />
          {/* 기간 프리셋 W26/W52/WLast (design 02 C9~C11 / §7-8). btnWLast 는 GetLastRange(division) 주차를
              라벨/구간에 반영하고 '52'면 숨긴다(자매 SCP0024 선례). GetLastRange SP 미배선(convert-sp 후속)이라
              wLastPeriod='' → W26 fallback. */}
          <Grid size={3} className={commonStyles.customGrid}>
            <Stack direction='row' spacing={1} alignItems='center'>
              <Button appearance='outlined' priority='normal' onClick={() => onPreset(PRESET_W26)}>
                W26
              </Button>
              <Button appearance='outlined' priority='normal' onClick={() => onPreset(PRESET_W52)}>
                W52
              </Button>
              {showWLast && (
                <Button
                  appearance='outlined'
                  priority='normal'
                  onClick={() => onPreset(Number(wLastPeriod) || PRESET_W26)}
                >
                  {`W${wLastPeriod || 'Last'}`}
                </Button>
              )}
            </Stack>
          </Grid>
          {/* SUM 체크박스 — W_/M_ SUM 롤업 컬럼 가시성 토글(design 03 §2.6, 재조회 없음). 전용 LBL 미탐 → 영문 fallback. */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={LABEL.SUM}
                checked={sc.chkSum}
                onChange={checked => set({ chkSum: checked })}
              />
            </div>
          </Grid>
        </>
      }
    />
  );
};
