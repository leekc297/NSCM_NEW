import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  buildComboOptions,
  toSelectedCodes,
} from 'features/master/src/components';
import { useEffect, useState } from 'react';
// import { useMemo } from 'react'; // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조)

import commonStyles from '@foundation/styles/common-styles.module.scss';
// import { clsx } from '@shared/clsx'; // Ver. 필드가 PopupSearchInput 레이아웃으로 바뀌며 미사용 (구현은 아래 주석 참조)
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
// import { useTabProcQuery } from '@shared/hooks'; // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조)
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
// import { useSessionStore } from '@shared/stores'; // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조)

import { BUCKET_TYPE, QTY_DIVISOR_OPTIONS } from '../mkt-fcst-comparison.constants';
// import { MENU_ID, SHEETS } from '../mkt-fcst-comparison.constants'; // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조)
import { useMktFcstComparisonStore } from '../useMktFcstComparisonStore';
import {
  SEARCH_COMBO,
  isDiv40,
  isDiv82,
  resolveSalesSiteDeptIds,
  resolveSalesSiteEndCustomers,
} from '../utils/mkt-fcst-comparison.searchCombos';

import { ComparisonVersionModal } from './ComparisonVersionModal';
// import styles from './MktFcstComparisonForm.module.scss'; // Ver. 필드가 PopupSearchInput 레이아웃으로 바뀌며 미사용 (구현은 아래 주석 참조)

// DMF0040 조회조건 — AS-IS Designer 실측 17종 (Cascade_Filter_전수.md §1, Cell Qty 는 AS-IS 미노출로 제외).
//   conditions(상시 2단): Div*/Team/End Customer/Sales Site + Biz.Type/Plant Site/Period*/Bucket
//   extraConditions(펼침): Project/Model·Nickname/Item Type/Owner + Version*/QTY/Sum·Diff.Only
//   division cascade = AS-IS cboDivision_SelectedIndexChanged L943~1042 (하위 클리어 + 기본 Version 재세팅).
// 2026-09-01 콤보 통일 — Div / Team / End Customer / Sales Site / Biz.Type / Plant Site 여섯 칸을
//   필터 콤보로 옮겼다(원천·축은 utils/mkt-fcst-comparison.searchCombos). Project / Model·Nickname /
//   Owner / Period 는 카탈로그 필드(@master/searchFields) 그대로다.

interface MktFcstComparisonFormProps {
  onSubmit: () => void;
  /** UM-01 — Division 변경 = Grid 초기화(#59 §1.4, AS-IS cboDivision_SelectedIndexChanged → InitSpread L954) */
  onDivisionChange?: () => void;
  /** UM-08 — bucket 전환 (경계 판정·InitSpread 등가는 페이지가 담당) */
  onBucketChange?: (prev: string, next: string) => void;
}

export const MktFcstComparisonForm = ({
  onSubmit,
  onDivisionChange,
  onBucketChange,
}: MktFcstComparisonFormProps) => {
  const { t } = useTranslation();
  // const session = useSessionStore(state => state.session); // Ver. 자동설정 기능 주석처리(2026-09-09 사용자 지정)로 미사용 (구현은 아래 주석 참조)

  const searchParams = useMktFcstComparisonStore(state => state.searchParams);
  const setSearchParams = useMktFcstComparisonStore(state => state.setSearchParams);
  const isOpenSearchArea = useMktFcstComparisonStore(state => state.isOpenSearchArea);

  const [openVersionModal, setOpenVersionModal] = useState<boolean>(false);

  // AS-IS D-04 (cboDivision L968): division 40 = Project·Plant Site 비활성 (81 계열·82 = 활성)
  const isDivision40 = isDiv40(searchParams.divisionId);
  // 82(ESS Battery) 도 Plant Site 비활성 — 사용자 지정 추가 요건(2026-09-09), AS-IS 범위 밖
  const isPlantSiteDisabled = isDivision40 || isDiv82(searchParams.divisionId);

  /**
   * 조회조건 콤보 6종은 전부 필터다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다.
   * 원천과 축은 utils/mkt-fcst-comparison.searchCombos 참조.
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
   * 축을 통해 반영한다. 규칙과 근거는 utils/mkt-fcst-comparison.searchCombos 참조.
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

  // Ver. 자동설정 기능 주석처리 (2026-09-09 사용자 지정) — division 선택 시 Version 이 자동으로
  // 채워지지 않게 한다. 사용자가 모달(ComparisonVersionModal)로 직접 골라야 한다.
  // ── 기본 Version = 최근 MF_W 2개, 'Current' 제외 (AS-IS GetDefaultVersion L1832~1875 1:1) ──
  //   division 변경(→ version '' 클리어) 시 재산출. 사용자가 모달로 고른 값은 덮지 않는다.
  //   필수: useMemo. useTabProcQuery 의 캐시 정리 effect 는 filters 를 **참조로** 비교하고
  //   (prevKeyRef.current === filters), 값이 같으면 removeQueries 로 캐시를 지운다. 매 렌더
  //   새 객체를 넘기면 "참조는 다른데 값은 같다" 가 되어 캐시 삭제 -> 재조회 -> 렌더 -> 다시
  //   새 객체가 되어 call-proc 이 무한히 돈다 (2026-09-01 실사고. version 이 비어 있는 동안 계속).
  //   같은 파일의 ComparisonVersionModal 이 filters 를 memo 하는 것도 같은 이유다.
  // const defaultVersionFilters = useMemo(
  //   () =>
  //     searchParams.divisionId && !searchParams.version
  //       ? {
  //           startYyyymmdd: searchParams.startYyyymmdd,
  //           endYyyymmdd: searchParams.endYyyymmdd,
  //           createdBy: session.userId ?? '',
  //           divisionId: searchParams.divisionId,
  //           versionType: 'MF_W',
  //           versionNo: '',
  //         }
  //       : undefined,
  //   [
  //     searchParams.divisionId,
  //     searchParams.version,
  //     searchParams.startYyyymmdd,
  //     searchParams.endYyyymmdd,
  //     session.userId,
  //   ]
  // );
  // const defaultVersionQuery = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
  //   menuId: MENU_ID,
  //   sheetName: SHEETS.VERSION,
  //   tabId: MENU_ID,
  //   filters: defaultVersionFilters,
  //   enabled: !!defaultVersionFilters,
  // });
  // useEffect(() => {
  //   if (searchParams.version) return;
  //   const rows = (defaultVersionQuery.data?.o_rc1 ?? []) as Array<{ VERSION_NO: string }>;
  //   if (rows.length === 0) return;
  //   const picked = rows
  //     .map(r => String(r.VERSION_NO ?? ''))
  //     .filter(v => v && v.toUpperCase() !== 'CURRENT')
  //     .slice(0, 2);
  //   if (picked.length > 0) setSearchParams({ version: picked.join(',') });
  // }, [defaultVersionQuery.data, searchParams.version, setSearchParams]);

  // ONLY_WEEKLY = Sum 비활성·강제 해제 (AS-IS InitSpread L391~397)
  useEffect(() => {
    if (searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY && searchParams.isSumChecked) {
      setSearchParams({ isSumChecked: false });
    }
  }, [searchParams.bucket, searchParams.isSumChecked, setSearchParams]);

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!isOpenSearchArea}
        onSearch={onSubmit}
        sx={{ flexShrink: 0 }}
        conditions={
          <>
            {/* Row 1 — Div* / Team / End Customer / Sales Site */}
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
                      // AS-IS L1032~1041: 하위 cascade 클리어 + 텍스트 4종 클리어 + 기본 Version 재세팅('' → effect)
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
                        version: '',
                      });
                      // UM-01 — AS-IS L954 InitSpread(): 남은 조회 결과는 새 division 과 어긋나므로 비운다
                      onDivisionChange?.();
                    }}
                  />
                )}
              />
            </Grid>
            {multiField('LBL00502', 'Team', searchParams.deptIds, teamOptions, v =>
              setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })
            )}
            {/* UM-02 — Team → End Customer cascade (AS-IS clbTeam_SelectedIndexChanged L1046~1083:
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
            {/* AS-IS L1047/L1059 — Sales Site 의 team 축: 81 계열·82 는 빈 값 고정 / 40 만 team */}
            {multiField('LBL00506', 'Sales Site', searchParams.salesSiteIds, salesSiteOptions, v =>
              setSearchParams({ salesSiteIds: v })
            )}
            {/* Row 2 — Biz.Type / Plant Site / Period* / Bucket */}
            {multiField('LBL00085', 'Biz.Type', searchParams.bizTypes, bizTypeOptions, v =>
              setSearchParams({ bizTypes: v })
            )}
            {multiField(
              'LBL00005',
              'Plant Site',
              searchParams.plantSiteIds,
              plantSiteOptions,
              v => setSearchParams({ plantSiteIds: v }),
              { disabled: isPlantSiteDisabled } // 40(AS-IS D-04) · 82(ESS Battery, 신규 요건) 비활성
            )}
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
            {/* Row 3 — Project / Model·Nickname / Item Type / Owner */}
            <ProjectField
              gridSize={3}
              value={searchParams.projectCodes}
              onChange={v => setSearchParams({ projectCodes: v })}
              division={searchParams.divisionId}
              deptIds={searchParams.deptIds}
              endCustomers={searchParams.endCustomers}
              scmSiteIds={searchParams.salesSiteIds}
              projectCodes={searchParams.projectCodes}
              disabled={isDivision40} // AS-IS D-04 — 40 은 Project 비활성
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
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('', 'Item Type')}
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
            {/* Row 4 — Version* (모달 전용 — AS-IS G-01: 직접 타이핑 차단) / QTY / 체크박스 */}
            {/* Project 와 동일 폭(size 3) — Version 밑에 QTY 는 Model/Nickname, 체크박스는 Item Type 아래로 정렬 */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00031', 'Ver.')}
                labelAlign='right'
                required
                render={() => (
                  // Project/Model·Nickname 과 동일한 PopupSearchInput 레이아웃(입력 + 별도 버튼 flex row) —
                  // 종전 endAdornment absolute 배치(right:-40px)는 폭이 달라 보이는 원인이라 아래 구현으로 교체.
                  // 구 구현(참고용, 미사용):
                  // <InputField
                  //   fullWidth
                  //   className={clsx(styles.inputWithSearch, styles.input)}
                  //   value={searchParams.version}
                  //   inputProps={{ readOnly: true }}
                  //   InputProps={{
                  //     endAdornment: (
                  //       <Button
                  //         appearance='outlined'
                  //         priority='normal'
                  //         iconComponent={
                  //           <FunctionSearchIcon
                  //             appearance='lined'
                  //             onClick={() => setOpenVersionModal(true)}
                  //           />
                  //         }
                  //       />
                  //     ),
                  //   }}
                  //   onClick={() => setOpenVersionModal(true)}
                  //   onKeyDown={() => setOpenVersionModal(true)} // AS-IS txtVersion_KeyDown L1670 — 키 = 팝업
                  // />
                  <Stack direction='row' spacing={0.5} alignItems='stretch' sx={{ width: '100%' }}>
                    <InputField
                      fullWidth
                      value={searchParams.version}
                      inputProps={{ readOnly: true }}
                      onClick={() => setOpenVersionModal(true)}
                      onKeyDown={() => setOpenVersionModal(true)} // AS-IS txtVersion_KeyDown L1670 — 키 = 팝업
                    />
                    <Button
                      appearance='outlined'
                      priority='normal'
                      iconComponent={<FunctionSearchIcon appearance='lined' />}
                      onClick={() => setOpenVersionModal(true)}
                    />
                  </Stack>
                )}
              />
            </Grid>
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
                  <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                    <Checkbox
                      labelText={t('LBL00687', 'Sum')}
                      checked={searchParams.isSumChecked}
                      disabled={searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY}
                      onChange={checked => setSearchParams({ isSumChecked: checked })}
                    />
                    {/* AS-IS cboDiff "Diff.Only" (Designer L1014) — p_diff_only */}
                    <Checkbox
                      labelText={t('', 'Diff.Only')}
                      checked={searchParams.isDiffOnly}
                      onChange={checked => setSearchParams({ isDiffOnly: checked })}
                    />
                  </Stack>
                )}
              />
            </Grid>
          </>
        }
      />
      <ComparisonVersionModal
        open={openVersionModal}
        modalClose={() => setOpenVersionModal(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        onApply={(versionIds, period) =>
          // AS-IS L1663~1665: txtVersion + drpPeriod.InitValue = 팝업 기간 (sPeriod 반영)
          setSearchParams({
            version: versionIds,
            startYyyymmdd: period.start,
            endYyyymmdd: period.end,
          })
        }
      />
    </>
  );
};
