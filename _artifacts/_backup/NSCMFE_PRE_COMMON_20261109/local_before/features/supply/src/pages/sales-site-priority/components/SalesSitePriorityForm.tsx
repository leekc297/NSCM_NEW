import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useState } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LBL, MENU_ID } from '../sales-site-priority.constants';
import { useSalesSitePriorityStore } from '../useSalesSitePriorityStore';
import {
  filterByDivision,
  filterSiteByDivision,
  toCascadeSource,
  toOptions,
} from '../utils/sales-site-priority.cascadeCombo';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toDivisionOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// design 02 조회조건 6논리조건(경계값=6, 접기 불필요 design 02 §5): Division(단일) / Plan Group(다중,
//   cascade) / Site(다중, cascade+기저필터) / Item ID(텍스트+MaterialByDivisionModal) /
//   Period(From~To) / Valid(단일).
export const SalesSitePriorityForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const [openItemModal, setOpenItemModal] = useState(false);

  const sc = useSalesSitePriorityStore(s => s.searchCondition);
  const set = useSalesSitePriorityStore(s => s.setSearchCondition);
  const setDivision = useSalesSitePriorityStore(s => s.setDivision);
  const openSearchArea = useSalesSitePriorityStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Division 은 EE 포함(design 02 §2-1 comboCalls#1 code=false — GetDivisionWithoutEE 아님).
  //   Plan Group 은 全件 조회 후 클라 cascade 필터(design 02 §3 filterCalls#1, PlanGroup SQL_ID가
  //   DIVISION_ID 를 반환해 클라 필터 가능, ora.py 실측).
  //   Site(ScmSite)는 AS-IS SCP0128 결과셋#2(SALES VALID + PLANT 전체)를 포팅한 콤보로 DIVISION_ID 를
  //   반환하므로 全件 조회 후 클라 cascade 필터로 좁힌다(filterSiteByDivision) — AS-IS RefreshSiteByDivision
  //   (.cs:254-268)과 동일: division==='EE'면 81/40/82 합집합, 그 외엔 GetDivisionChecked 매핑값.
  //   그리드 셀 콤보(CELL_COMBO_DATA_TYPE='ScmSite')와 동일 소스라 AS-IS(dtScmSiteAll 단일 소스가
  //   리스트박스+셀 공용)와 등가. iter-2 에서 SiteMasterAll_SCP(@siteType='SALES', PLANT 누락)로
  //   배선됐던 조회조건 콤보를 ScmSite 로 되돌려 PLANT 사이트(HQ06-A/NJ01-A)를 복원한다(갭 항목 B).
  const siteFilter: ComboParam = { comboId: COMBO.SITE };
  const [divisions, planGroups, sites, validYn] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP, siteFilter, COMBO.VALID],
  });

  const divisionOptions = toDivisionOptions(divisions);

  // Division 기본값 — AS-IS 는 DataSource 바인딩 첫 행이 자동 선택된다(setListBox, 권한 목록 첫 항목).
  //   저장된 조회조건 복원(restoreSearchCondition)이 먼저 값을 채웠으면 건너뛴다.
  const firstDivision = divisionOptions[0]?.value;
  useEffect(() => {
    if (!sc.divisionId && firstDivision) set({ divisionId: firstDivision });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDivision, sc.divisionId]);
  const planGroupOptions = toOptions(filterByDivision(toCascadeSource(planGroups), sc.divisionId));
  const siteOptions = toOptions(filterSiteByDivision(toCascadeSource(sites), sc.divisionId));
  const validOptions = toDivisionOptions(validYn);

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Division(단일, cascade 트리거 — design 02 §2-1) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    useClearIcon
                    sortBy='label'
                    value={sc.divisionId}
                    options={divisionOptions}
                    onChange={(_, picked) => {
                      // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                      //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                      //   복귀(commit 51d4e9fa 패턴). design 02 §3 R7 의 Plan Group/Site cascade 초기화는
                      //   setDivision 이 상위집합으로 포함(item/valid·그리드까지 함께 초기화).
                      const v = str(picked);
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(v);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Plan Group(다중, cascade 하위 — design 02 §2-2) */}
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
                    value={sc.planGroupIds.join(',')}
                    options={planGroupOptions}
                    onChange={(_, picked) => set({ planGroupIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Site(다중, cascade 하위 + 기저필터 81/40/82 — design 02 §2-3) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label='SCM Site'
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={sc.siteIds.join(',')}
                    options={siteOptions}
                    onChange={(_, picked) => set({ siteIds: pickMulti(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Item ID — 텍스트 + 돋보기(MaterialByDivisionModal COM0013, design 02 §4.6).
                SCP0131.md 조회조건 정리(v0.5) 유형 '텍스트/다중': AS-IS btnItemId_Click 이 팝업을
                Form_Load(true,...) 다중선택으로 열어 여러 ITEM_ID 를 멀티라인 txtItemId 에 채운다
                (SCP0131.cs:961, 형제 SCP0013 동일). TO-BE GET SP 도 STRING_SPLIT(p_item_id, ',') 로
                콤마 다건 분해(PKG_SCP0131 조회 proc). 입력은 다건(개행/콤마) — SCP0018 선례와 동일.
                라벨 미등록 — 스펙 명칭(Model/Nickname) defaultValue 만 표기. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label='Model/Nickname'
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    multiline
                    maxRows={3}
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
            {/* Period — 공통 PeriodRangePicker(스펙: 달력 단일 컨트롤, YYYY-MM-DD 표기). MSG01135(From>To) 검증은 저장/붙여넣기 시점(design 02 §2 검증#4). */}
            <Grid size={3}>
              <PeriodRangePicker
                className={commonStyles.formItem}
                label={t(LBL.PERIOD, '_Period')}
                start={sc.fromDate}
                end={sc.toDate}
                onChange={(start, end) => set({ fromDate: start, toDate: end })}
              />
            </Grid>
            {/* Active(Valid, 단일) — AS-IS cboValid 는 Y/N/ALL 이고 기본 ALL(.cs:170-171, SelectedValue="Y"
                주석처리). allOption 으로 ALL(값 '') 포함·기본 '' = ALL, 검색은 ALL→'' 로 전체 조회(setFilter). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label='Active'
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
      {/* 조회영역 Item ID 팝업 — MaterialByDivisionModal(COM0013), division 컨텍스트 전달(design 02 §4.6).
          다건 선택(multiCheckbox) → ITEM_ID csv 를 itemId 로 채운다(AS-IS Form_Load(true,...) 다중선택
          등가, SCP0018 선례와 동일). GET SP 가 STRING_SPLIT(',') 로 다건 분해해 LIKE 조회. */}
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => set({ itemId: items })}
        multiCheckbox
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
