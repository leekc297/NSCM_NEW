import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { useWarehouseCapacityStore } from '../useWarehouseCapacityStore';
import { matchSiteByDivision } from '../utils/warehouseCapacityEditLock';
import { COMBO, LBL, STAGE_LOOKUP_TYPE, VALID_COMBO_ID } from '../warehouse-capacity.constants';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
  // 활성 시트(0=Warehouse Capacity, 1=Warehouse Item Mapping). AS-IS SpdMain_ActiveSheetChanged
  //   (.cs:1414) 처럼 시트별로 조회조건 가시성이 다르다: WhCapa 탭은 WH Name+Period 표시/Model 숨김,
  //   Item Mapping 탭은 Model 표시/WH Name+Period 숨김. 공통: Div/SCM Site/Stage/Valid/Plan Group.
  activeSheet: number;
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
export const WarehouseCapacityForm = ({ onSearch, onItemSearch, activeSheet }: Props) => {
  const { t } = useTranslation();

  const sc = useWarehouseCapacityStore(s => s.searchCondition);
  const set = useWarehouseCapacityStore(s => s.setSearchCondition);
  const setDivision = useWarehouseCapacityStore(s => s.setDivision);
  const openSearchArea = useWarehouseCapacityStore(s => s.openSearchArea);

  const tabId = useTabid();

  const [divisions, planGroups, sites, warehouses] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP, COMBO.SITE, COMBO.WAREHOUSE],
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

  // Site — 'Site' 콤보가 DIVISION_ID 컬럼을 전량 반환(ora.py SQL 실측, @token 없음) → 선택
  //   division 으로 클라 필터. 단 AS-IS RefreshSiteByDivision 의 EE 분기(EE→81/40/82, EE_*→81_*)를
  //   재현해야 하므로 단순 동등비교가 아니라 matchSiteByDivision 을 쓴다(A1 해소, PlanGroup 과 달리
  //   EE 특수분기 — memory scp-site-combo-ee-branch-not-global-base-filter).
  const siteOptions = useMemo(() => {
    const opts = toOptions(
      (sites ?? []).filter(r => matchSiteByDivision(r.DIVISION_ID, sc.divisionId))
    );
    // AS-IS CopyPlantSite() 의 DISTINCT CODE/NAME 재현 — 'Site' 콤보는 GET_SEARCH_INFO 의
    //   #SCM_SITE LEFT JOIN SCP_OPMZ_WAREHOUSE_CAPACITY 구조라 한 사이트가 plan group 수만큼
    //   중복 행으로 온다(EE 조회 시 2602행 중 45행 중복, 고유 2557). value(CODE) 기준 중복 제거.
    const seen = new Set<string>();
    return opts.filter(o => {
      if (seen.has(o.value)) return false;
      seen.add(o.value);
      return true;
    });
  }, [sites, sc.divisionId]);

  // Stage 후보 — lookup API(/admin/lookup, OPMZ_STAGE_CD) 응답은 원시 SEGMENT/ATTRIBUTE 가 아니라
  //   lookup 컬럼 라벨로 매핑돼 온다: SEGMENT1→DIVISION, SEGMENT3→CODE, ATTRIBUTE1→NAME(실측
  //   responseBody). 과거엔 SEGMENT1/SEGMENT3/ATTRIBUTE1 로 읽어 division 필터가 전부 불일치 →
  //   Stage 가 항상 빈값이었다(2026-10-22 수정). DIVISION 으로 좁히고 CODE/NAME 쌍을 만든다.
  const stageDropdownOptions: Option[] = useMemo(() => {
    const rows = stageLookup ?? [];
    const filtered = sc.divisionId
      ? rows.filter(r => str(r.DIVISION) === sc.divisionId)
      : rows;
    const map = new Map<string, string>();
    filtered.forEach(r => {
      const code = str(r.CODE);
      if (code) map.set(code, str(r.NAME) || code);
    });
    return [...map.entries()].map(([value, label]) => ({ label, value }));
  }, [stageLookup, sc.divisionId]);

  const validOptions = useMemo(() => toOptions(validRows), [validRows]);

  // Warehouse(Name) — AS-IS RefreshWarehouse(.cs:384-407) 재현: 'Warehose' 콤보(전량 반환)를
  //   division = 선택 division(EE 확장 없음 — 저장테이블이 'EE' 를 그대로 보유) + plan group 선택 시
  //   OPMZ_PLAN_GR_ID 포함으로 클라 필터. 같은 WH_NM 이 plan group/site/stage 조합마다 중복 행으로
  //   오므로 value(WH_NM) 기준 중복 제거(AS-IS 체크리스트는 중복을 그대로 노출하나 다중선택 콤보에선
  //   중복 value 가 불안정하므로 dedup).
  const warehouseOptions = useMemo(() => {
    const rows = (warehouses ?? []).filter(
      r =>
        str(r.DIVISION_ID) === sc.divisionId &&
        (sc.planGroupIds.length === 0 || sc.planGroupIds.includes(str(r.OPMZ_PLAN_GR_ID)))
    );
    const opts = toOptions(rows);
    const seen = new Set<string>();
    return opts.filter(o => {
      if (seen.has(o.value)) return false;
      seen.add(o.value);
      return true;
    });
  }, [warehouses, sc.divisionId, sc.planGroupIds]);

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
              // 사용자 요청(2026-10-22): AS-IS lblDivision "Div*" 정합. DB에 정확한 'Div'(마침표 없음)
              //   라벨 코드가 없어(LBL00001='Div.'만 존재, 임의 등록 금지 MSG-05) 리터럴 'Div' 를 쓰고,
              //   required 로 '*' 필수표시를 붙인다. 정식 'Div' 라벨이 등록되면 t() 로 교체.
              label='Div'
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE
                    //   공통 요건 apply-division-reset). 편집중(dirty)이면 MSG00704 confirm 후에만
                    //   실행하고, 취소 시 controlled 콤보가 이전 Div 로 자동 복귀(commit 51d4e9fa 패턴).
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(String(picked ?? ''));
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* 순서 = AS-IS 배치(SCP0133_WarehouseCapacity.Designer.cs / 스크린샷) 정합:
              1행 Div·SCM Site·Stage·Valid(Active) / 2행 Plan Group·Name(WH Name)·Period */}

          {/* Site — 다중, cascade 이중경로(design 02 §2.5, 확인 필요) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SITE, '_SCM Site')}
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

          {/* Stage — 단일선택(AS-IS cboStage UsrComboBox, FindData_Main cboStage.SelectedValue).
              lookup OPMZ_STAGE_CD, division 으로 좁힘. Valid 와 동형의 단일 CustomDropdown. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.STAGE, '_Stage')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={sc.stage}
                  options={stageDropdownOptions}
                  onChange={(_, picked) => set({ stage: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Valid — 확정(design 02 §2.1, SQL_ID YesOrNo) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Active')}
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

          {/* WH Name + Period — Warehouse Capacity 탭(activeSheet 0)에서만 표시(AS-IS .cs:1425-1426).
              Item Mapping 탭에서는 숨기고 대신 Model/Nickname 을 표시한다. */}
          {activeSheet === 0 && (
            <>
              {/* Warehouse(WH Name) — 다중선택 콤보. AS-IS RefreshWarehouse(체크리스트, .cs:384-407)
                  재현 — 'Warehose' 콤보(저장테이블 DISTINCT WH_NM)를 division+plan group 으로 클라 필터. */}
              <Grid size={3}>
                <FormItem
                  className={commonStyles.formItem}
                  label={t(LBL.WAREHOUSE, '_WH Name')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      multiple
                      allOption
                      useClearIcon
                      limitTags={1}
                      sortBy='label'
                      value={toMultiValue(sc.warehouses.join(','))}
                      options={warehouseOptions}
                      onChange={(_, picked) => set({ warehouses: toMultiArray(picked) })}
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
            </>
          )}

          {/* Model/Nickname(Item) — Warehouse Item Mapping 탭(activeSheet 1)에서만 표시
              (AS-IS .cs:1437-1439). 팝업 결과 수신(design 02 §4.6, MaterialByDivisionModal). */}
          {activeSheet === 1 && (
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
          )}
        </>
      }
    />
  );
};
