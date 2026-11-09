import dayjs, { type Dayjs } from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LABEL, MENU_ID } from '../scheduled-receipt-information.constants';
import { useScheduledReceiptInformationStore } from '../useScheduledReceiptInformationStore';

const VALID_OPTIONS = [
  { label: 'All', value: 'All' },
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
];

// YYYYMMDD → Dayjs (ISO 문자열 조립 — customParseFormat 플러그인 비의존, ending-inventory 선례).
//   bare `dayjs('20261019')` 는 브라우저에서 비ISO 문자열이라 Invalid Date → DatePicker 가 빈칸으로
//   렌더된다. 저장값(thisWeekMonday, AS-IS setDatePicker 재현)이 안 보이던 원인.
const ymdToDayjs = (ymd: string): Dayjs | null =>
  /^\d{8}$/.test(ymd) ? dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`) : null;

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 7논리조건(Division/PlanGroup/Site/
 * ChildMaterial/Valid/FromDate/ItemId), §5 TO-BE 매핑.
 *
 * 2행 7필드(design 01 §3 pnlCondition 배치): Row1(Division/Site/ItemId+팝업/Valid),
 * Row2(PlanGroup/ChildMaterial/FromDate). 7필드는 2단(8칸) 이내라 전부 conditions 로 두어
 * 두 줄이 항상 보이게 한다(SRCH-02 2026-09-30 결정 — 8칸 초과일 때만 extraConditions 분리).
 *
 * Division 변경 = 하위(PlanGroup/Site/ChildMaterial) 클라 필터 초기화(design 02 §3 필터방식,
 * 서버 재조회 없음). Site/ChildMaterial 콤보(SCP0130-03, react-gap-audit iter-5 해소)는 등록
 * 콤보 PlantSiteSir/ItemIdChild 를 재사용하되, AS-IS RefreshSiteByDivision/RefreshDivisionByItem
 * 처럼 Division 단일 필터 + CODE 중복제거로 좁힌다(아래 buildDivisionOptions).
 */
interface Props {
  // 활성 시트(SCP0130-08) — Virtual Bom 에서만 Item ID 조회조건을 노출하고, Child Material 라벨을
  //   시트별로 스왑한다(AS-IS SpdMain_ActiveSheetChanged .cs:1466-1507).
  isVirtualBom: boolean;
}

export const ScheduledReceiptInformationForm = ({ isVirtualBom }: Props) => {
  const { t } = useTranslation();

  const searchParams = useScheduledReceiptInformationStore(state => state.searchParams);
  const setSearchParams = useScheduledReceiptInformationStore(state => state.setSearchParams);
  const setDivision = useScheduledReceiptInformationStore(state => state.setDivision);
  const setFilters = useScheduledReceiptInformationStore(state => state.setFilters);
  const fetchStaticColumns = useScheduledReceiptInformationStore(state => state.fetchStaticColumns);
  const openSearchArea = useScheduledReceiptInformationStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // Plan Group 조회콤보는 활성 시트별로 원천이 다르다(SCP0130-08/AS-IS .cs:1479/1500):
  //   Virtual Bom = 전체(PlanGroup_SCP_ALL) / Scheduled Receipt = 가상BOM 등록분(PlanGroupVirtualBom).
  const [planGroupsAll] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const [planGroupsVbom] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP_VBOM] });
  const [sitesAll] = useTabComboQueries({ filters: [COMBO.SITE] });
  const [childMaterialsAll] = useTabComboQueries({ filters: [COMBO.CHILD_MATERIAL] });

  // Division 기본값 — AS-IS InitControls `setListBox(dtMyDivision, cboDivision, false, ...)`(.cs:177)는
  //   권한 사업부 목록의 첫 항목을 기본 선택한다. TO-BE 도 divisionId 가 비어 있고 목록이 로드되면
  //   첫 CODE 로 채운다(형제 opt-capa/demand-group-master 파리티). 개인화 복원(restoreSearchConditions)
  //   이 값을 넣었으면 가드로 건너뛴다. 초기 채움이라 cascade(setDivision) 아닌 setSearchParams 직접.
  useEffect(() => {
    if (searchParams.divisionId || !divisions?.length) return;
    setSearchParams({ divisionId: divisions[0].CODE });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, searchParams.divisionId]);

  // Division 필터방식(재조회 없음, design 02 §3) — 활성 시트별 원천을 전량 로드 후 DIVISION_ID 로 좁힌다.
  const planGroupSource = isVirtualBom ? planGroupsAll : planGroupsVbom;
  const planGroupOptions = (planGroupSource ?? []).filter(
    row => !searchParams.divisionId || row.DIVISION_ID === searchParams.divisionId
  );

  // Site 콤보 전용 사업부 확장 — AS-IS GetDivisionChecked(.cs:257-291) + RefreshSiteByDivision
  //   EE 분기(.cs:354-362): EE 집계 사업부는 Site 를 구성 사업부로 확장한다(EE→81/40/82,
  //   EE_xx→81_xx). PlanGroup/ChildMaterial 은 AS-IS 가 원값 필터라 확장 대상이 아니다.
  const siteDivisionFilter = (divisionId: string): string[] => {
    if (!divisionId) return [];
    const EXPAND: Record<string, string[]> = {
      EE: ['81', '82', '40'],
      EE_UC: ['81_UC'],
      EE_HM: ['81_HM'],
      EE_ST: ['81_ST'],
      EE_HD: ['81_HD'],
      EE_HG: ['81_HG'],
    };
    return EXPAND[divisionId] ?? [divisionId];
  };

  // Site/Child Material(SCP0130-03) — AS-IS RefreshSiteByDivision/RefreshDivisionByItem 재현:
  //   Division 필터 + CODE 중복제거(CopyPlantSite 의 Distinct(CODE,NAME)). 등록 콤보가
  //   (site×plangroup)/(child×plangroup×site…) 조합마다 행을 내려주므로 CODE 기준 first-wins 로
  //   합친다(dev-manual 04 §4.5). allowedDivisions 가 비면 전량, 있으면 그 DIVISION_ID 만.
  const buildDivisionOptions = (rows: ComboResponse[], allowedDivisions: string[]) => {
    const seen = new Set<string>();
    const out: { label: string; value: string }[] = [];
    for (const row of rows) {
      if (allowedDivisions.length && !allowedDivisions.includes(row.DIVISION_ID)) continue;
      if (seen.has(row.CODE)) continue;
      seen.add(row.CODE);
      out.push({ label: row.NAME, value: row.CODE });
    }
    return out;
  };
  const rawDivisions = searchParams.divisionId ? [searchParams.divisionId] : [];
  const siteOptions = buildDivisionOptions(
    sitesAll ?? [],
    siteDivisionFilter(searchParams.divisionId)
  );
  const childMaterialOptions = buildDivisionOptions(childMaterialsAll ?? [], rawDivisions);

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Row1(AS-IS Designer y=0): Division(x0)/Plant Site(x260)/Valid(x540)/Parent Model(x730). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.DIVISION, '_Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀(commit 51d4e9fa 패턴).
                    onChange={(_, option) => {
                      const next = option ?? '';
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(next);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Site(SCP0130-03) — 등록 콤보 PlantSiteSir, Division 단일필터 + CODE dedup. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.SITE, '_Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.siteIds}
                    options={siteOptions}
                    onChange={(_, value) => setSearchParams({ siteIds: value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.VALID, '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.valid}
                    options={VALID_OPTIONS}
                    onChange={(_, option) => setSearchParams({ valid: option ?? 'All' })}
                  />
                )}
              />
            </Grid>
            {/* Parent Model(Item ID) — Row1 맨 끝(AS-IS Designer lblItemId x=730, Valid x=540 뒤).
                Virtual Bom 시트에서만 노출(SCP0130-08, AS-IS btnItemId.Visible .cs:1473/1488);
                Scheduled Receipt 시트에서는 조회조건 자체를 숨긴다(itemId 파라미터도 store 에서 ''). */}
            {isVirtualBom && (
              <Grid size={3}>
                <FormItem
                  className={commonStyles.formItem}
                  label={t(LABEL.ITEM_ID, '_Item')}
                  labelAlign='right'
                  render={() => (
                    <InputField
                      fullWidth
                      className={commonStyles.popupSearchField}
                      value={searchParams.itemId}
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
                      onChange={e => setSearchParams({ itemId: e.target.value })}
                    />
                  )}
                />
              </Grid>
            )}
            {/* Row2(design 01 §1 y=29/41 행): PlanGroup/ChildMaterial/FromDate. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupIds}
                    options={planGroupOptions.map(item => ({ label: item.NAME, value: item.CODE }))}
                    onChange={(_, value) => setSearchParams({ planGroupIds: value })}
                  />
                )}
              />
            </Grid>
            {/* Child Material(SCP0130-03) — 등록 콤보 ItemIdChild, Division 단일필터 + CODE dedup. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={
                  isVirtualBom
                    ? t(LABEL.CHILD_MATERIAL, '_Child Material')
                    : t(LABEL.MATERIAL, '_Material')
                }
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.childMaterialIds}
                    options={childMaterialOptions}
                    onChange={(_, value) => setSearchParams({ childMaterialIds: value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.FROM_DATE, '_From Date')}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    value={ymdToDayjs(searchParams.fromDate)}
                    onChange={
                      ((date: Dayjs | null) => {
                        setSearchParams({ fromDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                )}
              />
            </Grid>
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: MENU_ID }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
