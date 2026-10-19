import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  BucketField,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  SearchOverRangeField,
  VersionField,
} from '../../../components';
import { useSalesFuturePriceValidation } from '../hooks/useSalesFuturePriceValidation';
import { BUCKET_TYPE, DIVISION } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';
import { thisWeekMonday, yyyymmddOf } from '../utils/futurePriceDate';
import { SEARCH_COMBO, buildComboOptions, toSelectedCodes } from '../utils/searchCombos';

interface Props {
  onSearch: () => void;
  onVersionOpen: () => void;
  // AS-IS MSG00227 — 신규 입력('I') 행 존재 시 Bucket 변경 차단용.
  hasInsertRows?: boolean;
}

// AS-IS 캡쳐 (Doc/ui_cap/DMF0020_init.png) 1:1 layout + 사용자 사이즈 요구.
//
// 조회조건 순서 (2026-07-01 사용자 요구, 4개/단 — gridSize={3} 균등이 기본):
//   1단(항상): Div / Team / End Customer / Biz.Type
//   2단(항상): Sales Site / Project / Period(4) / Plant Site(2)
//   3단(펼침): Model·Nickname / Owner / Bucket / Version
//   4단(펼침): Search Over Range
//   주의: Project 는 Division='40' 일 때 비활성(칸은 유지) — 4개/단 레이아웃은 그대로다.
//
//   Period/Plant Site 만 3:3 대신 4:2 — Period 내부 시작일/종료일 DatePicker 2개(각 110px
//   고정폭, 줄어들지 않음)가 균등폭(gridSize=3)에서 라벨(140px 고정)과 합쳐 그리드 폭을
//   넘겨 SearchArea 의 Search/화살표 버튼 위로 겹쳐 보였다(2026-09-08). Plant Site 는
//   81 계열 전용 게이트 필드라 대부분 ALL/비활성으로 표시돼 폭 축소 영향이 가장 적어 좁은
//   칸을 맡는다. Period 를 Plant Site 보다 앞(3번째)에 둔 것은 사용자 요구(2026-09-08) —
//   넓은 칸과 좁은 칸이 바로 붙어 있으면 어색해 보여, 좁은 Plant Site 를 맨 끝(4번째)으로
//   옮겼다.
//
// 조회조건 콤보는 6종 모두 필터 방식이다 (Doc/Combo/DMF0020_콤보구성.md §1). Filter 접두가
// 그 표시이며 파라미터 없이 전량을 한 번 받고, 좁히는 일은 화면이 한다. 원천 / 반환 컬럼 /
// 단계별 규칙은 utils/searchCombos 헤더 참조.
//   - 하위 단계 값 초기화는 각 onChange 에서 직접 한다. 목록이 다시 만들어지므로 안 풀면
//     옵션에서 사라진 값이 조회조건에 남아 그대로 서버로 나간다.
//   - Plant Site 는 81 계열 전용이라 조회 자체를 게이트한다(칸은 그리되 비활성).
export const SalesFuturePriceForm = ({ onSearch, onVersionOpen, hasInsertRows }: Props) => {
  const { t } = useTranslation();
  const validate = useSalesFuturePriceValidation();

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const set = useSalesFuturePriceStore(s => s.setSearchCondition);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);

  // 콤보는 전부 필터 방식이다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은 아래에서 한다.
  //   원천과 반환 컬럼은 utils/searchCombos 헤더 참조.
  const [divisions, teams, endCustomers, bizTypes, salesSites] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division,
      SEARCH_COMBO.team,
      SEARCH_COMBO.endCustomer,
      SEARCH_COMBO.bizType,
      SEARCH_COMBO.salesSite,
    ],
  });

  // Plant Site 는 81 계열 전용이라 조회 자체를 게이트한다. 칸은 그리되 비활성만 하는 것과 구분된다.
  const plantSiteEnabled = sc.divisionId.startsWith(DIVISION.ESS);
  const [plantSites] = useTabComboQueries({
    filters: [SEARCH_COMBO.plantSite],
    enabled: plantSiteEnabled,
  });

  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });
  const bizTypeOptions = buildComboOptions(bizTypes, { division: sc.divisionId });
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: sc.divisionId,
    narrow: { column: 'DEPT_ID', codes: sc.deptIds },
  });

  /**
   * Sales Site 는 Division + End Customer 로 좁힌다. Team 은 걸지 않는다 - AS-IS 가 네 호출부
   * 전부 팀 자리에 빈 값을 고정으로 넣는다(콤보구성 문서 §1 "팀은 빈 값 고정").
   *
   * 고른 End Customer 만 쓰고 미선택을 목록 전체로 펼치지 않는다. 그 목록은 이미 DEPT_ID 로
   * 좁혀져 있어 펼치면 팀 조건이 우회로로 되살아난다.
   */
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: sc.divisionId,
    narrow: { column: 'END_CUSTOMER', codes: toSelectedCodes(sc.endCustomers) },
  });

  /**
   * Plant Site 는 Division 으로만 좁힌다. End Customer 는 걸지 않는다.
   *
   * AS-IS 는 이 목록을 화면 진입(:358)과 Division 변경(:2278) 두 곳에서만 다시 만든다.
   * End Customer 변경 핸들러(:3163)는 Sales Site 만 건드리고 Plant Site 는 손대지 않는다.
   * 문서 §1 의 "목록 구성 조건 = Division + End Customer" 는 Division 을 바꾸는 그 시점의
   * End Customer 값으로 만든다는 뜻이지, 고를 때마다 갱신한다는 뜻이 아니다.
   *
   * Division 을 바꾸면 End Customer 가 초기화되므로 결과적으로 그 시점 값이 반영된다.
   */
  const plantSiteOptions = buildComboOptions(plantSites, { division: sc.divisionId });

  /**
   * 한 단계를 바꾸면 그 아래 단계 선택을 전부 푼다. 목록이 다시 만들어지므로 안 풀면 옵션에서
   * 사라진 값이 조회조건에 남아 그대로 서버로 나간다. Division / Team 변경 시 popup 계열까지
   * 비우는 것은 AS-IS clbDivisions_SelectedIndexChanged 정합이다.
   */
  const resetBelowDivision = {
    deptIds: [],
    endCustomers: [],
    scmSiteIds: [],
    plantSiteIds: [],
    bizTypes: [],
    projectCodes: [],
    itemIds: [],
    owners: [],
    bucketType: BUCKET_TYPE.WEEKLY,
    versionId: 'Current',
    // Search over range 는 기본값 unchecked - division/team 변경 시 함께 해제한다
    //   (사용자 요구 2026-08-25). 종전 true 는 division 만 바꿔도 조회기간이 52주로
    //   자동 확장된 것처럼 보이게 했다.
    searchOverRange: false,
  };

  /**
   * 다중선택 드롭다운 한 벌. 이 화면 조회조건은 Division 만 빼고 모양이 같다.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Team 도 예외가 아니다.
   */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
    extra?: { sortBy?: 'label'; disabled?: boolean; gridSize?: number }
  ) => (
    <Grid size={extra?.gridSize ?? 3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy={extra?.sortBy}
            disabled={extra?.disabled}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', { defaultValue: 'Div' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, picked) =>
                    set({ divisionId: String(picked ?? ''), ...resetBelowDivision })
                  }
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            sc.deptIds,
            teamOptions,
            deptIds => set({ ...resetBelowDivision, deptIds }),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            endCustomers => set({ endCustomers, scmSiteIds: [], plantSiteIds: [] }),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00085',
            'Biz.Type',
            sc.bizTypes,
            bizTypeOptions,
            bizTypes => set({ bizTypes }),
            {
              sortBy: 'label',
            }
          )}

          {/* 2단 */}
          {multiField(
            'LBL00011',
            'Sales Site',
            sc.scmSiteIds,
            salesSiteOptions,
            scmSiteIds => set({ scmSiteIds }),
            { sortBy: 'label' }
          )}
          {/* Project — Division='40' 도 칸은 그대로 두고 비활성만 한다 (사용자 요구 2026-08-26).
              40 은 프로젝트 역할을 END_CUSTOMER40 이 대신해 조회 키로 쓰지 않지만, 숨기면 division 을
              오갈 때 조회조건 자리가 통째로 바뀌어 다른 화면처럼 보인다. Plant Site 의 비활성 처리와 같은 방식.
              종전에는 빈 Grid 슬롯으로 대체했다. */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            multiCheckbox
            disabled={sc.divisionId === DIVISION.MOBILITY}
          />
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            plantSiteIds => set({ plantSiteIds }),
            { sortBy: 'label', disabled: !plantSiteEnabled }
          )}
        </>
      }
      // 확장영역(펼치기) — 3단(Model/Owner/Bucket/Version) + 4단(Search Over Range).
      extraConditions={
        <>
          {/* 3단 */}
          <ItemField
            gridSize={3}
            value={sc.itemIds}
            onChange={v => set({ itemIds: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            itemIds={sc.itemIds}
            multiCheckbox
          />
          <OwnerField
            gridSize={3}
            value={sc.owners}
            onChange={v => set({ owners: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            owners={sc.owners}
            multiCheckbox
          />
          <BucketField
            gridSize={3}
            value={sc.bucketType}
            onChange={v => {
              // AS-IS MSG00227 — 신규 입력('I') 행이 있을 때 Bucket 변경 차단 (동적 컬럼 재구성 방지).
              if (hasInsertRows && !validate.validateBucketChange('I').ok) return;
              set({ bucketType: v === 'M' ? BUCKET_TYPE.MONTHLY : BUCKET_TYPE.WEEKLY });
            }}
          />
          <VersionField gridSize={3} value={sc.versionId} onOpenPopup={onVersionOpen} />

          {/* 4단 */}
          <SearchOverRangeField
            gridSize={3}
            value={sc.searchOverRange}
            onChange={v => {
              // AS-IS usrDiscard_CheckedChanged — 체크 시 조회기간을 당주 월요일 ~ +52주로 자동 세팅.
              if (v) {
                const start = thisWeekMonday();
                const end = new Date(start);
                end.setDate(start.getDate() + 52 * 7);
                set({
                  searchOverRange: v,
                  startYyyymmdd: yyyymmddOf(start),
                  endYyyymmdd: yyyymmddOf(end),
                });
              } else {
                set({ searchOverRange: v });
              }
            }}
          />
        </>
      }
    />
  );
};
