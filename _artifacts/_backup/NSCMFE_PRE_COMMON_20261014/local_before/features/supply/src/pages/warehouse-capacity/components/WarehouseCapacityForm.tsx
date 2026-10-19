import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useWarehouseCapacityStore } from '../useWarehouseCapacityStore';
import { COMBO, LBL, STAGE_LOOKUP_TYPE, VALID_COMBO_ID } from '../warehouse-capacity.constants';

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

const toMultiValue = (v: string): string => v;
const toMultiArray = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// design 02(02_search-combo.md) 조회조건 10항목 — Division/PlanGroup/Site/Stage/Warehouse 5개
//   콤보는 전부 "확인 필요"(GSCM 원본 미확보 + AS-IS DB 접속 불가, design 02 §7 15건). 이 화면은
//   확정된 강한 후보로 배선하되, cascade 는 클라 필터(전량 조회 후 division 좁힘)로 잠정 구현한다
//   (design 02 §3 "필터방식으로 잠정 추정" — 재조회방식으로 확정되면 comboId 파라미터화가 필요).
//   Warehouse 는 전용 콤보/lookup 원천이 DB에 없어(design 02 §2.6 확인 필요) 옵션 없이 자유 입력
//   텍스트로만 남긴다 — 추측으로 원천을 만들지 않는다(anti-simplification §1).
export const WarehouseCapacityForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useWarehouseCapacityStore(s => s.searchCondition);
  const set = useWarehouseCapacityStore(s => s.setSearchCondition);
  const openSearchArea = useWarehouseCapacityStore(s => s.openSearchArea);

  const [divisions, planGroups, sites] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP, COMBO.SITE],
  });

  // Stage — lookup master(OPMZ_STAGE_CD, design 02 §2.4 강한 후보·확인 필요). SEGMENT1=division,
  //   SEGMENT3=코드, ATTRIBUTE1=코드 복제(명칭 컬럼 미상 — 확인 필요, 임시로 SEGMENT3 를 라벨로도 사용).
  const { data: stageLookup } = useTabLookupQuery({ filters: { lookupType: STAGE_LOOKUP_TYPE } });

  const [validRows] = useTabComboQueries({ filters: [VALID_COMBO_ID] });

  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);

  // PlanGroup — PlanGroup_SCP_ALL 은 전량 조회 + DIVISION_ID 컬럼 반환(design 02 §2.3) → 클라에서
  //   선택된 division 으로 좁힌다(AS-IS DBUtils.Filter 재현, filterCalls#1).
  const planGroupOptions = useMemo(() => {
    const rows = (planGroups ?? []);
    const filtered = sc.divisionId
      ? rows.filter(r => str(r.DIVISION_ID) === sc.divisionId)
      : rows;
    return toOptions(filtered);
  }, [planGroups, sc.divisionId]);

  // Site — SiteMasterAll_SCP 는 서버 @divisionId 파라미터를 갖지만 이 화면 cascade 축(design 02 §2.5)이
  //   Division+PlanGroup 이중 경로로 확인 필요 상태라, 우선 division 단일 파라미터로만 서버 필터한다.
  const siteOptions = useMemo(() => toOptions(sites), [sites]);

  // Stage 후보 — SEGMENT1(division)로 좁힌 뒤 SEGMENT3(코드)/ATTRIBUTE1(명칭 대용, design 02 §2.4
  //   확인 필요 — 정식 명칭 컬럼 미상이라 코드로 대체) 로 CODE/NAME 쌍을 만든다.
  const stageDropdownOptions: Option[] = useMemo(() => {
    const rows = stageLookup ?? [];
    const filtered = sc.divisionId
      ? rows.filter(r => str(r.SEGMENT1) === sc.divisionId)
      : rows;
    const map = new Map<string, string>();
    filtered.forEach(r => {
      const code = str(r.SEGMENT3);
      if (code) map.set(code, str(r.ATTRIBUTE1) || code);
    });
    return [...map.entries()].map(([value, label]) => ({ label, value }));
  }, [stageLookup, sc.divisionId]);

  const validOptions = useMemo(() => toOptions(validRows), [validRows]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — 확인 필요(design 02 §2.2, comboId 3후보 중 미확정, 현재 Division_SCP 배선) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // Division 변경 = 하위 cascade(PlanGroup/Site/Stage/Warehouse) 초기화(design 02 §3)
                    set({
                      divisionId: String(picked ?? ''),
                      planGroupIds: [],
                      siteIds: [],
                      stages: [],
                      warehouses: [],
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Plan Group — 다중, cascade 1단(design 02 §2.3, 강한 후보) */}
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
                  value={toMultiValue(sc.planGroupIds.join(','))}
                  options={planGroupOptions}
                  onChange={(_, picked) => set({ planGroupIds: toMultiArray(picked) })}
                />
              )}
            />
          </Grid>

          {/* Site — 다중, cascade 이중경로(design 02 §2.5, 확인 필요) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SITE, '_Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={toMultiValue(sc.siteIds.join(','))}
                  options={siteOptions}
                  onChange={(_, picked) => set({ siteIds: toMultiArray(picked) })}
                />
              )}
            />
          </Grid>

          {/* Stage — 다중, lookup OPMZ_STAGE_CD(design 02 §2.4, 강한 후보·확인 필요) */}
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
                  value={toMultiValue(sc.stages.join(','))}
                  options={stageDropdownOptions}
                  onChange={(_, picked) => set({ stages: toMultiArray(picked) })}
                />
              )}
            />
          </Grid>

          {/* Warehouse — 전용 원천 없음(design 02 §2.6 확인 필요, 전용 마스터/lookup 0건 실측 확인).
              추측 콤보 등록 금지 — 콤마 구분 자유 입력 텍스트로만 남긴다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00319', '_Warehouse')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.warehouses.join(',')}
                  onChange={e =>
                    set({
                      warehouses: e.target.value
                        .split(',')
                        .map(v => v.trim())
                        .filter(Boolean),
                    })
                  }
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Valid — 확정(design 02 §2.1, SQL_ID YesOrNo) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={sc.validYn}
                  options={validOptions}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Period(From~To) — DB 무관, 확정(design 02 §1 #7) */}
          <PeriodField
            gridSize={6}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
          />

          {/* Item ID — 팝업 결과 수신(design 02 §4.6, MaterialByDivisionModal 확정) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM_ID, '_Item ID')}
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
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                        }
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
