import dayjs, { type Dayjs } from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

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
  const clearGrid = useScheduledReceiptInformationStore(state => state.clearGrid);
  const setFilters = useScheduledReceiptInformationStore(state => state.setFilters);
  const fetchStaticColumns = useScheduledReceiptInformationStore(state => state.fetchStaticColumns);
  const openSearchArea = useScheduledReceiptInformationStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  const [openItemModal, setOpenItemModal] = useState(false);

  // Division 변경 confirm 취소 시 콤보 표시 강제 복귀용 키(#8). CustomDropdown 단일선택은 inputValue 를
  //   제어하지 않아, controlled value(이전 Div)가 그대로여도 MUI 가 방금 고른(거부된) 옵션 텍스트를 붙들고
  //   blur 로도 복귀하지 않는다(실측 2026-11-09: 값=81인데 칸=40 유지). 취소 시 이 키를 올려 Division
  //   CustomDropdown 을 remount → value 라벨로 표시를 되돌린다(그리드와 일치).
  const [divisionRevertKey, setDivisionRevertKey] = useState(0);

  // From Date 빈값 거부·직전값 복원(#15). AS-IS 공용 컨트롤 UsrDatePicker 의 nullValueYN=false 재현:
  //   From Date 를 지우고 포커스아웃하면 컨트롤이 직전 유효값으로 되돌린다(SCP0130_ScheduledRecieptInformation.
  //   Designer.cs:342). TO-BE 공용 DatePickerCalendar 에는 빈값불허 프롭이 없다.
  //   복원은 반드시 blur(포커스아웃) 시점에만 — onChange 에서 remount 하면 키인 도중 미완성값(null)마다
  //   리셋돼 타이핑이 깨진다(공용 MUI DatePicker 는 섹션 편집 중 null 을 반복 발생). 그래서:
  //   onChange 는 유효값만 저장하고 빈값/미완성은 ref 플래그만 세운 뒤, 래퍼 div 의 onBlur(focusout 버블)에서
  //   플래그가 서 있으면 remount 로 controlled value(직전 fromDate) 표시를 복원한다.
  const [fromDateRevertKey, setFromDateRevertKey] = useState(0);
  const fromDateClearedRef = useRef(false);

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
  const buildDivisionOptions = (
    rows: ComboResponse[],
    allowedDivisions: string[],
    allowedPlanGroups?: string[]
  ) => {
    const seen = new Set<string>();
    const out: { label: string; value: string }[] = [];
    for (const row of rows) {
      if (allowedDivisions.length && !allowedDivisions.includes(row.DIVISION_ID)) continue;
      if (allowedPlanGroups && !allowedPlanGroups.includes(row.OPMZ_PLAN_GR_ID)) continue;
      if (seen.has(row.CODE)) continue;
      seen.add(row.CODE);
      out.push({ label: row.NAME, value: row.CODE });
    }
    return out;
  };
  const rawDivisions = searchParams.divisionId ? [searchParams.divisionId] : [];
  // Site 콤보 2단 축소(SCP0130-03) — AS-IS RefreshSiteByPlanGroup(.cs:333-349): Scheduled Receipt 시트에서는
  //   Site 를 선택 Plan Group 으로도 좁힌다(Plan Group=ALL 이면 축소 없음). Virtual Bom 시트는 Division 필터만
  //   (RefreshSiteByDivision). 활성 시트(isVirtualBom)로 분기한다.
  const sitePlanGroupFilter =
    !isVirtualBom && searchParams.planGroupIds !== 'ALL'
      ? searchParams.planGroupIds.split(',')
      : undefined;
  const siteOptions = buildDivisionOptions(
    sitesAll ?? [],
    siteDivisionFilter(searchParams.divisionId),
    sitePlanGroupFilter
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
            {/* 조회조건 순서 — 논리 그룹 기준(사용자 지시 2026-11-17): Division(①데이터기준) →
                Plan Group·Site(②조직·거점: 상위조직이 모델·자재보다 앞, Site 는 Plan Group 에 종속) →
                Parent Model·Material(③제품·대상: BOM 부모→자식) → From Date(④기간) → Valid(⑤상태·표시, 마지막).
                AS-IS Designer 절대좌표(Row1 Division/Site/Valid/ParentModel, Row2 PlanGroup/Material/FromDate)
                에서 의도적 deviation. Grid size={3} = 4칸/행 → Virtual Bom(7필드) Row1 Division/PlanGroup/Site/
                ParentModel · Row2 Material/FromDate/Valid. Scheduled Receipt(ParentModel 숨김)은 placeholder
                로 자리 유지. */}
            {/* ① Division */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.DIVISION, '_Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    // 취소 시 remount 로 표시를 controlled value 로 되돌린다(#8, 위 divisionRevertKey 주석).
                    key={divisionRevertKey}
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행. 취소(ok=false)면 setDivision 미호출로
                    //   값은 이전 Div 유지되지만, 콤보 표시는 MUI 가 거부된 선택을 붙들어 어긋나므로(실측)
                    //   divisionRevertKey 를 올려 remount 로 표시를 강제 복귀시킨다.
                    onChange={(_, option) => {
                      const next = option ?? '';
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(next);
                        else setDivisionRevertKey(k => k + 1);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* ② Plan Group(조직) — Site 보다 앞(Site 가 Plan Group 에 종속, sitePlanGroupFilter). */}
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
                    // AS-IS CboPlanGroup_SelectedIndexChanged(.cs:1299-1306): Plan Group 변경 시 그리드를
                    //   비운다(ClearDataSource). 편집중(dirty)이면 확인 후에만 — 취소 시 controlled 콤보가
                    //   이전 값으로 복귀(Division 변경과 동일 가드). 조건은 유지하고 그리드만 비운다(clearGrid).
                    onChange={(_, value) => {
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (!ok) return;
                        setSearchParams({ planGroupIds: value });
                        clearGrid();
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* ② Site(거점, SCP0130-03) — 등록 콤보 PlantSiteSir, Division 단일필터 + CODE dedup. */}
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
            {/* ③ Parent Model(Item ID) — 제품·대상 그룹 첫 필드(BOM 부모, Material 앞).
                Virtual Bom 시트에서만 노출(SCP0130-08, AS-IS btnItemId.Visible .cs:1473/1488);
                Scheduled Receipt 시트에서는 조회조건 자체를 숨긴다(itemId 파라미터도 store 에서 ''). */}
            {isVirtualBom ? (
              <Grid size={3}>
                <FormItem
                  className={commonStyles.formItem}
                  label={t(LABEL.ITEM_ID, '_Parent Item')}
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
            ) : (
              // Scheduled Receipt 탭: Parent Model 숨김으로 비는 Row1 4번째 칸을 빈 placeholder 로 채운다.
              //   없으면 Grid auto-flow 로 Material 이 1행 4번째로 올라가 배치가 어긋난다(#13). placeholder 로
              //   Material/From Date/Valid 를 2행에 고정해 Virtual Bom 과 같은 그룹 순서를 유지한다.
              <Grid size={3} />
            )}
            {/* ③ Child Material(SCP0130-03) — BOM 자식, Parent Model 뒤. 등록 콤보 ItemIdChild, Division
                단일필터 + CODE dedup. 라벨은 두 탭 모두 'Material'(LBL00021) 표준으로 통일(SCP0130-#10).
                AS-IS 는 Virtual Bom 탭에서만 'Child Material'(.cs:1477)로 달랐으나, item_id_child/material
                조회조건의 전 화면 공통 표준이 'Material'(LBL00021)이고 'Child Material'(LBL01062)은 SCP0130
                고유라, 표준으로 맞춘다(asis-parity-default-keep-common-standardization). 탭별 스왑 제거. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.MATERIAL, '_Material')}
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
            {/* ④ From Date(기간) — 제품·대상 뒤, 상태·표시(Valid) 앞. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.FROM_DATE, '_From Date')}
                labelAlign='right'
                render={() => (
                  // onBlur(focusout)는 버블링되므로 래퍼 div 에서 포커스아웃을 받는다(#15, 위 주석).
                  //   공용 DatePickerCalendar 의 slotProps.textField 를 직접 넘기면 내부 하드코딩 textField
                  //   (달력아이콘·inputRef·내부 onChange)를 덮어써 깨지므로, 래퍼 div 경유로 처리한다.
                  <div
                    style={{ display: 'contents' }}
                    onBlur={() => {
                      if (!fromDateClearedRef.current) return;
                      fromDateClearedRef.current = false;
                      // 비운 채 포커스아웃 → remount 로 직전 유효값(controlled value) 표시 복원.
                      setFromDateRevertKey(k => k + 1);
                    }}
                  >
                    <DatePickerCalendar
                      key={fromDateRevertKey}
                      usecase='date'
                      elevation
                      size='small'
                      value={ymdToDayjs(searchParams.fromDate)}
                      onChange={
                        ((date: Dayjs | null) => {
                          // 유효값만 저장. 빈값/미완성은 타이핑 중일 수 있어 여기선 복원하지 않고
                          //   플래그만 세운다(실제 복원은 위 onBlur 에서). AS-IS nullValueYN=false 재현.
                          if (date?.isValid()) {
                            fromDateClearedRef.current = false;
                            setSearchParams({ fromDate: date.format('YYYYMMDD') });
                            return;
                          }
                          fromDateClearedRef.current = true;
                        }) as never
                      }
                    />
                  </div>
                )}
              />
            </Grid>
            {/* ⑤ Valid(상태·표시) — 조회 결과 필터링 옵션이라 맨 마지막. */}
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
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        // 조회조건 Parent Model(itemId) 입력값을 팝업 초기 검색어로 연동 — 형제 화면
        //   (project-route/formation/workbench 등)과 동일 계약. 빠지면 값이 있어도 팝업 Material 이 빈칸.
        preSearchParams={{
          divisionId: searchParams.divisionId,
          scpModuleType: MENU_ID,
          itemId: searchParams.itemId,
        }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
