import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PeriodField,
  PlantSiteField,
  ProjectField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  MENU_ID,
  QTY_DIVISOR_OPTIONS,
  SHEETS,
} from '../mkt-fcst-comparison.constants';
import { useMktFcstComparisonStore } from '../useMktFcstComparisonStore';

import { ComparisonVersionModal } from './ComparisonVersionModal';
import styles from './MktFcstComparisonForm.module.scss';

// DMF0040 조회조건 — AS-IS Designer 실측 17종 (Cascade_Filter_전수.md §1, Cell Qty 는 AS-IS 미노출로 제외).
//   conditions(상시 2단): Div*/Team/End Customer/Sales Site + Biz.Type/Plant Site/Period*/Bucket
//   extraConditions(펼침): Project/Model·Nickname/Item Type/Owner + Version*/QTY/Sum·Diff.Only
//   division cascade = AS-IS cboDivision_SelectedIndexChanged L943~1042 (하위 클리어 + 기본 Version 재세팅).

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
  const session = useSessionStore(state => state.session);

  const searchParams = useMktFcstComparisonStore(state => state.searchParams);
  const setSearchParams = useMktFcstComparisonStore(state => state.setSearchParams);
  const isOpenSearchArea = useMktFcstComparisonStore(state => state.isOpenSearchArea);

  const [openVersionModal, setOpenVersionModal] = useState<boolean>(false);

  // AS-IS D-04 (cboDivision L968): division 40 = Project·Plant Site 비활성 (81 계열·82 = 활성)
  const isDivision40 = searchParams.divisionId === '40';

  const [reportBucketType, qtyType, itemType] = useTabComboQueries({
    filters: ['ReportBucketType', 'QtyType', 'ItemType'],
  });

  const comboOr = (
    rows: Array<{ CODE: string; NAME: string }> | undefined,
    fallback: Array<{ value: string; label: string }>
  ) =>
    rows && rows.length > 0
      ? rows.map(item => ({ label: item.NAME, value: item.CODE }))
      : fallback;

  const bucketOptions = comboOr(reportBucketType, []);
  const qtyOptions = comboOr(qtyType, QTY_DIVISOR_OPTIONS);

  // ── 기본 Version = 최근 MF_W 2개, 'Current' 제외 (AS-IS GetDefaultVersion L1832~1875 1:1) ──
  //   division 변경(→ version '' 클리어) 시 재산출. 사용자가 모달로 고른 값은 덮지 않는다.
  const defaultVersionFilters =
    searchParams.divisionId && !searchParams.version
      ? {
          startYyyymmdd: searchParams.startYyyymmdd,
          endYyyymmdd: searchParams.endYyyymmdd,
          createdBy: session.userId ?? '',
          divisionId: searchParams.divisionId,
          versionType: 'MF_W',
          versionNo: '',
        }
      : undefined;
  const defaultVersionQuery = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: defaultVersionFilters,
    enabled: !!defaultVersionFilters,
  });
  useEffect(() => {
    if (searchParams.version) return;
    const rows = (defaultVersionQuery.data?.o_rc1 ?? []) as Array<{ VERSION_NO: string }>;
    if (rows.length === 0) return;
    const picked = rows
      .map(r => String(r.VERSION_NO ?? ''))
      .filter(v => v && v.toUpperCase() !== 'CURRENT')
      .slice(0, 2);
    if (picked.length > 0) setSearchParams({ version: picked.join(',') });
  }, [defaultVersionQuery.data, searchParams.version, setSearchParams]);

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
            <DivisionField
              gridSize={3}
              value={searchParams.divisionId}
              onChange={option => {
                if (option === searchParams.divisionId) return;
                // AS-IS L1032~1041: 하위 cascade 클리어 + 텍스트 4종 클리어 + 기본 Version 재세팅('' → effect)
                setSearchParams({
                  divisionId: option,
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
            <TeamField
              gridSize={3}
              value={searchParams.deptIds}
              onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })}
              division={searchParams.divisionId}
            />
            {/* UM-02 — Team → End Customer cascade (AS-IS clbTeam_SelectedIndexChanged L1046~1083:
                EndCustomerByDivision(division, team) 재적재). 공용 필드 cascade(DEPT_ID) 로 팀 선택 시 좁힌다.
                [E20260831-UM02FIX] 기본 콤보는 DEPT_ID 속성 부재 → strict cascade 가 팀 선택 시 전 행 탈락
                (DMF0035 와 동일 family — 사용자 신고 2026-08-31). 정본 'EndCustomerByDivision' + 40 한정 cascade. */}
            <EndCustomerField
              gridSize={3}
              value={searchParams.endCustomers}
              onChange={v => setSearchParams({ endCustomers: v, salesSiteIds: [] })}
              division={searchParams.divisionId}
              comboId='EndCustomerByDivision'
              cascade={
                searchParams.divisionId === '40'
                  ? { DEPT_ID: { values: searchParams.deptIds, strict: true } }
                  : undefined
              }
            />
            {/* AS-IS L1047/L1059 — Sales Site 재적재의 team 파라미터: 81 계열·82 는 '' / 40 은 team */}
            <SalesSiteField
              gridSize={3}
              value={searchParams.salesSiteIds}
              onChange={v => setSearchParams({ salesSiteIds: v })}
              division={searchParams.divisionId}
              comboId='UserSiteByEndCustomer'
              endCustomer={searchParams.endCustomers.join(',')}
              deptId={isDivision40 ? searchParams.deptIds.join(',') : ''}
            />
            {/* Row 2 — Biz.Type / Plant Site / Period* / Bucket */}
            <BizTypeField
              gridSize={3}
              value={searchParams.bizTypes}
              onChange={v => setSearchParams({ bizTypes: v })}
              division={searchParams.divisionId}
            />
            <PlantSiteField
              gridSize={3}
              value={searchParams.plantSiteIds}
              onChange={v => setSearchParams({ plantSiteIds: v })}
              division={searchParams.divisionId}
              endCustomer={searchParams.endCustomers.join(',')}
              disabled={isDivision40} // AS-IS D-04 — 40 은 Plant Site 비활성
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
            {/* 버전 2개 비교 화면 — 선택한 두 버전명이 모두 보이도록 조회조건 2칸 폭(size 6) */}
            <Grid size={6}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00031', 'Ver.')}
                labelAlign='right'
                required
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.version}
                    inputProps={{ readOnly: true }}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenVersionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onClick={() => setOpenVersionModal(true)}
                    onKeyDown={() => setOpenVersionModal(true)} // AS-IS txtVersion_KeyDown L1670 — 키 = 팝업
                  />
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
