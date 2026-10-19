import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  buildComboOptions,
  toSelectedCodes,
} from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE, QTY_DIVISOR_OPTIONS } from '../cust-fcst-waterfall.constants';
import { useCustFcstWaterfallStore } from '../useCustFcstWaterfallStore';
import {
  SEARCH_COMBO,
  isProjectEnabled as resolveProjectEnabled,
  resolveSalesSiteDeptIds,
  resolveSalesSiteEndCustomers,
} from '../utils/cust-fcst-waterfall.searchCombos';

// DMF0053 조회조건 — #112 카탈로그 'Customer FCST Waterfall' 17행 전 행 대조 (Cascade_Filter_전수.md §1).
//   conditions(상시 2단): Div.*/Team/End Customer/Sales Site + Biz.Type/Input Date*/Period*/Bucket
//   extraConditions(펼침): PJT/Model·Nickname/Plant Site/Item Type + Owner/QTY/Sum
//   Version(Date*) 칸 = AS-IS btnVersion 숨김 + Figma·카탈로그 부재 → 미구현 (E21/E22/D-01).
//   division cascade = AS-IS cboDivision_SelectedIndexChanged L928~1028 (하위 클리어 + 텍스트 클리어).
// 2026-09-01 콤보 통일 — Div / Team / End Customer / Sales Site / Biz.Type / Plant Site 여섯 칸을
//   필터 콤보로 옮겼다(원천·축은 utils/cust-fcst-waterfall.searchCombos). PJT / Model·Nickname /
//   Owner / Period 는 카탈로그 필드(@master/searchFields) 그대로다.

interface CustFcstWaterfallFormProps {
  onSubmit: () => void;
  /** UM-01 — Division 변경 = Grid 초기화(#59 §1.4, AS-IS cboDivision_SelectedIndexChanged → InitSpread L935) */
  onDivisionChange?: () => void;
  /** UM-08 — bucket 전환 (경계 판정·InitSpread 등가는 페이지가 담당) */
  onBucketChange?: (prev: string, next: string) => void;
}

export const CustFcstWaterfallForm = ({
  onSubmit,
  onDivisionChange,
  onBucketChange,
}: CustFcstWaterfallFormProps) => {
  const { t } = useTranslation();

  const searchParams = useCustFcstWaterfallStore(state => state.searchParams);
  const setSearchParams = useCustFcstWaterfallStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustFcstWaterfallStore(state => state.isOpenSearchArea);

  // AS-IS B-04 (cboDivision L951~983): 81 계열·82 = PJT·Plant Site 활성 / 그 외(40) = 비활성
  const isProjectEnabled = resolveProjectEnabled(searchParams.divisionId);

  /**
   * 조회조건 콤보 6종은 전부 필터다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다.
   * 원천과 축은 utils/cust-fcst-waterfall.searchCombos 참조.
   *
   * 종전에는 카탈로그 필드(DivisionField/TeamField/...)의 기본 콤보와 서버 바인드 경로를 썼다.
   * 그 경로는 Biz.Type 처럼 DIVISION_ID 컬럼이 없는 전역 lookup 이 섞여 있어 division 을 넘겨도
   * 목록이 좁혀지지 않았고, Sales Site / Plant Site 는 선택이 바뀔 때마다 SQL 이 다시 나갔다.
   */
  const [divisions, teams, endCustomers, bizType, salesSites, plantSites] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division,
      SEARCH_COMBO.team,
      SEARCH_COMBO.endCustomer,
      SEARCH_COMBO.bizType,
      SEARCH_COMBO.salesSite,
      SEARCH_COMBO.plantSite,
    ],
  });

  const [reportBucketType, qtyType, itemType] = useTabComboQueries({
    filters: ['ReportBucketType', 'QtyType', 'ItemType'],
  });

  // 전체선택('ALL')과 전체해제는 필터상 같다 - 둘 다 그 축이 미적용된다.
  const deptIds = toSelectedCodes(searchParams.deptIds);
  const endCustomerCodes = toSelectedCodes(searchParams.endCustomers);

  // FilterMyDivision(#0)은 DIVISION_ID 컬럼이 없다 - 축을 걸지 않는다.
  const divisionOptions = buildComboOptions(divisions);
  const teamOptions = buildComboOptions(teams, { division: searchParams.divisionId });
  const bizTypeOptions = buildComboOptions(bizType, { division: searchParams.divisionId });

  /**
   * End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 DEPT_ID 가 공란인
   * 행이 대다수라(lookup-only UNION 분기) 관대하게 두면 Team 을 골라도 목록이 그대로다.
   * 40 은 CODE 자리에 PROJECT_CODE 가 들어온다(#2 주석) - 라벨만 End Customer 다.
   */
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: searchParams.divisionId,
    narrow: { column: 'DEPT_ID', codes: deptIds },
  });

  /**
   * Sales Site = Division + Team + End Customer.
   *
   * 팀은 두 갈래로 전달된다 - 40 은 DEPT_ID 축을 직접 걸고, 비40 은 그 분기가 DEPT_ID 를 빈
   * 문자열로 고정해 내려주므로 축을 걸 수 없다(걸면 전 행 탈락). 그래서 비40 은 End Customer
   * 축을 통해 반영한다. 규칙과 근거는 utils/cust-fcst-waterfall.searchCombos 참조.
   */
  const salesSiteDeptIds = resolveSalesSiteDeptIds(searchParams.divisionId, deptIds);
  const salesSiteEndCustomers = resolveSalesSiteEndCustomers(endCustomerCodes, endCustomerOptions);
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: searchParams.divisionId,
    narrow: [
      { column: 'DEPT_ID', codes: salesSiteDeptIds },
      { column: 'END_CUSTOMER', codes: salesSiteEndCustomers },
    ],
  });

  // Plant Site = Division 단독. FilterFromSiteByDivision(#5)에는 END_CUSTOMER 컬럼이 아예 없다.
  const plantSiteOptions = buildComboOptions(plantSites, { division: searchParams.divisionId });

  /**
   * 다중선택 조회조건 한 벌.
   *
   * 조회조건 드롭다운은 전부 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라
   * 콤보 SQL 의 ORDER BY 보다 이쪽이 낫다는 사용자 확정(2026-08-28). Division 만 단일선택이다.
   */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
    extra?: { disabled?: boolean }
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
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

  const comboOr = (
    rows: Array<{ CODE: string; NAME: string }> | undefined,
    fallback: Array<{ value: string; label: string }>
  ) =>
    rows && rows.length > 0 ? rows.map(item => ({ label: item.NAME, value: item.CODE })) : fallback;

  const bucketOptions = comboOr(reportBucketType, []);
  const qtyOptions = comboOr(qtyType, QTY_DIVISOR_OPTIONS);

  // ONLY_WEEKLY = Sum 비활성·강제 해제 (AS-IS InitSpread L394~398)
  useEffect(() => {
    if (searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY && searchParams.isSumChecked) {
      setSearchParams({ isSumChecked: false });
    }
  }, [searchParams.bucket, searchParams.isSumChecked, setSearchParams]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSubmit}
      sx={{ flexShrink: 0 }}
      conditions={
        <>
          {/* Row 1 — Div.* / Team / End Customer / Sales Site */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', 'Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    const picked = String(option ?? '');
                    if (picked === searchParams.divisionId) return;
                    // AS-IS E02 (L1020~1025): 하위 cascade 클리어 + 텍스트 3칸(PJT/Model/Owner) 클리어
                    setSearchParams({
                      divisionId: picked,
                      deptIds: [],
                      endCustomers: [],
                      salesSiteIds: [],
                      bizTypes: [],
                      plantSiteIds: [],
                      projectCodes: [],
                      itemIds: [],
                      owners: [],
                    });
                    // UM-01 — AS-IS L935 InitSpread(): 남은 조회 결과는 새 division 과 어긋나므로 비운다
                    onDivisionChange?.();
                  }}
                />
              )}
            />
          </Grid>
          {multiField('LBL00502', 'Team', searchParams.deptIds, teamOptions, v =>
            setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })
          )}
          {/* UM-02 — Team → End Customer cascade (AS-IS clbTeam_SelectedIndexChanged L1030~1065:
              EndCustomerByDivision(division, team) 재적재). DEPT_ID 축은 사업부를 가리지 않는다 -
              종전 40 한정 분기는 서버 바인드 콤보의 DEPT_ID 공란 행 때문에 두었던 것이고,
              FilterEndCustomerByDivision(#2)은 두 갈래 모두 DEPT_ID 를 실어 내려준다. */}
          {multiField(
            'LBL00080',
            'End Customer',
            searchParams.endCustomers,
            endCustomerOptions,
            v => setSearchParams({ endCustomers: v, salesSiteIds: [] })
          )}
          {/* AS-IS L1042/L1054 — Sales Site 의 team 축: 81 계열·82 는 빈 값 고정 / 40 만 team */}
          {multiField('LBL00506', 'Sales Site', searchParams.salesSiteIds, salesSiteOptions, v =>
            setSearchParams({ salesSiteIds: v })
          )}
          {/* Row 2 — Biz.Type / Input Date* / Period* / Bucket */}
          {multiField('LBL00085', 'Biz.Type', searchParams.bizTypes, bizTypeOptions, v =>
            setSearchParams({ bizTypes: v })
          )}
          <PeriodField
            gridSize={3}
            label={t('LBL00302', 'Input Date')}
            start={searchParams.fromCreateYyyymmdd}
            end={searchParams.toCreateYyyymmdd}
            onChange={(start, end) =>
              setSearchParams({ fromCreateYyyymmdd: start, toCreateYyyymmdd: end })
            }
          />
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00710', 'Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucket}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // UM-08 — 컬럼 가시성은 즉시 반응(Grid bucketPrefix), 경계 전환은 페이지가 InitSpread 등가 처리
                    const prev = searchParams.bucket;
                    setSearchParams({ bucket: option });
                    if (prev !== option) onBucketChange?.(prev, option);
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — PJT / Model·Nickname / Plant Site / Item Type */}
          <ProjectField
            gridSize={3}
            value={searchParams.projectCodes}
            onChange={v => setSearchParams({ projectCodes: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
            disabled={!isProjectEnabled} // AS-IS B-04 — 40 은 PJT 비활성 (81*/82 활성)
          />
          <ItemField
            gridSize={3}
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
          />
          {multiField(
            'LBL00005',
            'Plant Site',
            searchParams.plantSiteIds,
            plantSiteOptions,
            v => setSearchParams({ plantSiteIds: v }),
            { disabled: !isProjectEnabled } // AS-IS B-04 — 40 은 Plant Site 비활성
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00068', 'Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.itemTypes.join(',')}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) =>
                    setSearchParams({
                      itemTypes: String(options ?? '')
                        .split(',')
                        .filter(Boolean),
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* Row 4 — Owner / QTY / Sum */}
          <OwnerField
            gridSize={3}
            value={searchParams.owners}
            onChange={v => setSearchParams({ owners: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('', 'QTY')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.qty}
                  options={qtyOptions}
                  onChange={(_, option) => setSearchParams({ qty: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={' '}
              labelAlign='right'
              render={() => (
                <Checkbox
                  labelText={t('LBL00687', 'Sum')}
                  checked={searchParams.isSumChecked}
                  disabled={searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY}
                  onChange={checked => setSearchParams({ isSumChecked: checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
