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
  BUCKET_TYPE} from '../production-plan-fix.constants';
import {
  COMBO,
  ELECTRODE_LOOKUP,
  LBL,
  PRESET_W26,
  PRESET_W52,
  W_LAST_HIDE_PERIOD,
} from '../production-plan-fix.constants';
import { useProductionPlanFixStore } from '../useProductionPlanFixStore';
import { isEeDivision } from '../utils/productionPlanFixEditLock';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // 기간 프리셋 — 부모(페이지)가 GetDayRange 등가 산정(offset=주×7-1)으로 dCalendar 구간을 세팅.
  onPreset: (weeks: number) => void;
  wLastPeriod: string; // btnWLast 텍스트 주차(=GetLastRange(division)). '52' 면 버튼 숨김(자매 SCP0022 선례).
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 인벤토리 C1~C13 + cascade 그래프(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / plantSite(F1/F2 필터) / line(F3/F4 클라 필터). electrode 독립 다중.
//   AS-IS CommonAll(전량) + DBUtils.Filter 를 반환컬럼 클라 필터로 재현(convert-core §2.6). SQL_ID 실측(design 02 §2).
//   EE/비EE pool 스왑: division EE 여부로 plant/line/opGroup 콤보 코드셋 선택(데이터 경계 EE=A,E / 비EE=P,A 실측).
//   스왑 트리거 원식 확정(gap-resolve iter-2): RefreshOperationGroup/PlantSite/Line 전건
//   `_division.Substring(0,2).Equals("EE")` 분기(cs:779/789/805) — division EE prefix 기준이 정확 재현.
export const ProductionPlanFixForm = ({ onSearch, onItemSearch, onPreset, wLastPeriod }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanFixStore(s => s.searchCondition);
  const set = useProductionPlanFixStore(s => s.setSearchCondition);
  const setDivision = useProductionPlanFixStore(s => s.setDivision);
  const openSearchArea = useProductionPlanFixStore(s => s.openSearchArea);

  const isEe = isEeDivision(sc.divisionId);
  const showWLast = wLastPeriod !== W_LAST_HIDE_PERIOD; // design 02 §7-4 (GetLastRange==52 면 숨김, 자매 SCP0022)

  // 콤보 — 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  //   opGroup/plantSite/line 은 EE 여부로 콤보 스왑(이름 대조 금지 — 별개 코드셋, convert-core §2.6).
  const [divisions, operationGroups, plantSites, lines, buckets] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      isEe ? COMBO.PLANT_SITE_EE : COMBO.PLANT_SITE,
      isEe ? COMBO.LINE_EE : COMBO.LINE,
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // Plant Site 클라 필터 F1/F2 (design 02 §2.4 — DIVISION_ID + OPERATION_GROUP). pool 반환 컬럼으로 좁힘.
  const inDivision = (r: ComboResponse): boolean =>
    !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId;
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(
      r => inDivision(r) && (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  // Line 클라 필터 F3/F4 — AS-IS RefreshLine 원식 확정(cs:801-817, gap-resolve iter-2):
  //   EE  = DIVISION_ID + OPERATION_GROUP + SITE_ID (cs:807)
  //   비EE = DIVISION_ID + SITE_ID (cs:812 — OPERATION_GROUP 미포함. 자매 SCP0013 비EE 술어와 동일)
  //   빈 선택값 컬럼은 필터 생략(GetAndFilterString isReturnEmptyString=true 계열). '-' sentinel 제외.
  const lineOptions = toOptions(
    (lines ?? []).filter(
      r =>
        str(r.CODE) !== '-' &&
        inDivision(r) &&
        (!isEe || !sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId) &&
        (sc.plantSiteIds.length === 0 || sc.plantSiteIds.includes(str(r.SITE_ID)))
    )
  );

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행 근사, design 02 §4).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS RefreshOperationGroup 기본 구성).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

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
            // 빈 배열(= 필터 없음)은 'ALL' sentinel 로 되돌려 넘긴다(전체선택 상태 왕복 — 자매 tact-time 규약).
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
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // Row0 (2단) — 필수 cascade: Division* / Operation Group* / Plant Site / Line.
      conditions={
        <>
          {single(t(LBL.DIVISION, '_Div'), sc.divisionId, divisionOptions, setDivision, true)}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation group'),
            sc.operationGroupId,
            operationGroupOptions,
            // OperationGroup 변경 = 하위 Plant/Line refresh(design 02 E2). stale 선택값이 조회 payload 로
            //   전파되지 않도록 plantSiteIds/lineIds 초기화(react-gap-audit C1) — PlantSite→lineIds 초기화와 동일 규약.
            v => set({ operationGroupId: v, plantSiteIds: [], lineIds: [] }),
            true
          )}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v, lineIds: [] })
          )}
          {multi(t(LBL.LINE, '_Line'), sc.lineIds, lineOptions, v => set({ lineIds: v }))}
        </>
      }
      // 3단째부터 extraConditions 분리(hook #52 — 2단 초과 접기/펼치기): Electrode / Item / Bucket / Period(+프리셋) / SUM.
      extraConditions={
        <>
          {/* Electrode — 비EE division 이면 값 비움+비활성(AS-IS SetChangedControl cs:833-841:
              `cboElectrode.ControlValues=""; Enabled=false`). 값 비움은 setDivision 의 electrodeTypes 리셋이 담당. */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM, '_Item')}
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
          {single(
            t(LBL.BUCKET, '_Bucket'),
            sc.bucket,
            bucketOptions,
            v => set({ bucket: v as BUCKET_TYPE })
          )}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          {/* 기간 프리셋 W26/W52/WLast (design 02 §C10~C12 / §7-4). btnWLast 는 GetLastRange(division) 주차를
              라벨/구간에 반영하고 '52'면 숨긴다(자매 SCP0022 선례). GetLastRange SP 미배선(convert-sp 후속)이라
              wLastPeriod='' → W26 fallback(react-gap-audit B1). */}
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
          {/* SUM 체크박스 — W_/M_ SUM 롤업 컬럼 가시성 토글(design 03 §2.4, 재조회 없음).
              라벨 = 실측 재사용 LBL(ora.py 2026-09-24: SCM_ADM_MSG_M LBL00687='Sum' EN/KO/CN 전건 존재) — 하드코딩 금지(Hook #87§L).
              (react-gap-audit SUMLBL: iter-3 역조회가 LANG_CD='en' 소문자로 0건 오판 → gap-resolve 에서 대문자 'EN' 재조회로 LBL00687 확정.) */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(LBL.SUM, '_Sum')}
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
