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

import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import {
  BUCKET_TYPE,
  BUCKET2_TYPE,
  GUBUN,
  type Gubun,
} from '../demand-plan-waterfall.constants';
import { gubunResetParams, useDemandPlanWaterfallStore } from '../useDemandPlanWaterfallStore';

import styles from './DemandPlanWaterfallForm.module.scss';
import { WaterfallVersionModal } from './WaterfallVersionModal';

// 조회조건 = @master searchFields 카탈로그 의무(hook #112 계보) + 2단 구성 표준.
//   conditions(상시 2단): Gubun/Div/Team/End Customer + Sales Site/Ver/Period/Bucket
//   extraConditions(펼침): 체크박스·환산·Sender/PJT/Model/Item Type/Biz Type/Plant Site/Owner
//   Color 체크박스 = 사용자 지시(2026-08-06)로 제거.

interface DemandPlanWaterfallFormProps {
  onSubmit: () => void;
}

// GUBUN 콤보 — 통합 UI 고유 상수 (DMF0044 REPORT_TYPE as-const 선례). 초기값 MKT_FCST (사용자 확정).
const GUBUN_OPTIONS: Array<{ value: Gubun; label: string }> = [
  { value: GUBUN.MKT_FCST, label: 'MKT FCST' },
  { value: GUBUN.SALES_PLAN, label: 'SALES PLAN' },
  { value: GUBUN.BIZ_PLAN, label: 'BIZ PLAN' },
];

// 환산 배수 fallback — AS-IS SelectedIndex 0~3 = ÷1/1,000/1,000,000/100,000,000 (0022 .cs:2386-2460)
const DIVISOR_OPTIONS = [
  { value: '1', label: '1' },
  { value: '1000', label: '1,000' },
  { value: '1000000', label: '1,000,000' },
  { value: '100000000', label: '100,000,000' },
];

// BIZ 버킷 fallback — AS-IS LOOKUP 'BUCKET2_TYPE_CODE' 실측 3계층
const BUCKET2_OPTIONS = [
  { value: BUCKET2_TYPE.MONTHLY, label: 'MONTHLY' },
  { value: BUCKET2_TYPE.QUARTERLY, label: 'QUARTERLY' },
  { value: BUCKET2_TYPE.YEARLY, label: 'YEARLY' },
];

export const DemandPlanWaterfallForm = ({ onSubmit }: DemandPlanWaterfallFormProps) => {
  const { t } = useTranslation();

  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useDemandPlanWaterfallStore(state => state.setSearchParams);
  const isOpenSearchArea = useDemandPlanWaterfallStore(state => state.isOpenSearchArea);

  const [openVersionModal, setOpenVersionModal] = useState<boolean>(false);

  const gubun = searchParams.gubun;
  const isMkt = gubun === GUBUN.MKT_FCST;
  const isSales = gubun === GUBUN.SALES_PLAN;
  const isBiz = gubun === GUBUN.BIZ_PLAN;
  const isDivision40 = searchParams.divisionId === '40';
  const isDivision81 = searchParams.divisionId === '81'; // EDI Sender — '81' 정확일치 (AS-IS .cs:350-359)

  // ONLY_WEEKLY 시 Sum 강제 해제 (AS-IS .cs:504-507)
  useEffect(() => {
    if (searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY && searchParams.isSumChecked) {
      setSearchParams({ isSumChecked: false });
    }
  }, [searchParams.bucket, searchParams.isSumChecked, setSearchParams]);

  // div40 이탈 시 Cell Qty 해제 (AS-IS .cs:1571-1572)
  useEffect(() => {
    if (!isDivision40 && searchParams.isCellQtyChecked) {
      setSearchParams({ isCellQtyChecked: false });
    }
  }, [isDivision40, searchParams.isCellQtyChecked, setSearchParams]);

  const [senderCode, itemType, reportBucketType, bucketType2, qtyType] = useTabComboQueries({
    filters: ['SenderCode', 'ItemType', 'ReportBucketType', 'BucketType2', 'QtyType'],
  });

  const comboOr = (
    rows: Array<{ CODE: string; NAME: string }> | undefined,
    fallback: Array<{ value: string; label: string }>
  ) =>
    rows && rows.length > 0
      ? rows.map(item => ({ label: item.NAME, value: item.CODE }))
      : fallback;

  const bucketOptions = isBiz
    ? comboOr(bucketType2, BUCKET2_OPTIONS)
    : comboOr(reportBucketType, []);
  const qtyOptions = comboOr(qtyType, DIVISOR_OPTIONS);

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00691', 'Search')}
        isHidden={!isOpenSearchArea}
        onSearch={onSubmit}
        // 펼침(3단) 시 flex 축소로 내용이 SubTitle 위에 겹치는 것 방지 — 검색영역은 원 높이 유지,
        // 나머지(그리드)가 flex:1 로 줄어든다 (ViewContainer flex column 구조)
        sx={{ flexShrink: 0 }}
        conditions={
          <>
            {/* Row 1 — Waterfall Type(구 Gubun — 명칭 사용자 확정 2026-08-06) / Div* / Team / End Customer */}
            <Grid size={3}>
              <FormItem
                label={t('', 'Waterfall Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={gubun}
                    options={GUBUN_OPTIONS}
                    onChange={(_, option) => {
                      // GUBUN 전환 = 시트 전환 — 버킷 체계 스왑 + 버전·전용 조건 클리어
                      setSearchParams(gubunResetParams(option as Gubun));
                    }}
                  />
                )}
              />
            </Grid>
            <DivisionField
              gridSize={3}
              value={searchParams.divisionId}
              onChange={option =>
                // Division cascade + 팝업류 클리어 (AS-IS .cs:1609-1612)
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
                  senderCodes: [],
                })
              }
            />
            <TeamField
              gridSize={3}
              value={searchParams.deptIds}
              onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })}
              division={searchParams.divisionId}
            />
            <EndCustomerField
              gridSize={3}
              value={searchParams.endCustomers}
              onChange={v => setSearchParams({ endCustomers: v, salesSiteIds: [] })}
              division={searchParams.divisionId}
            />
            {/* Row 2 — Sales Site / Ver. / Period* / Bucket */}
            <SalesSiteField
              gridSize={3}
              value={searchParams.salesSiteIds}
              onChange={v => setSearchParams({ salesSiteIds: v })}
              division={searchParams.divisionId}
              comboId='UserSiteByEndCustomer'
              endCustomer={searchParams.endCustomers.join(',')}
              deptId={searchParams.deptIds.join(',')}
            />
            <Grid size={3}>
              <FormItem
                label={t('LBL00031', 'Ver.')}
                labelAlign='right'
                required={!isMkt} // MKT 만 비필수(''=CURRENT) — SALES/BIZ 필수 (통합분석 §4.3)
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.version}
                    onChange={event => setSearchParams({ version: event.target.value })}
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
                    onDoubleClick={() => setOpenVersionModal(true)}
                  />
                )}
              />
            </Grid>
            <PeriodField
              gridSize={3}
              start={searchParams.startYyyymmdd}
              end={searchParams.endYyyymmdd}
              onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
            />
            <Grid size={3}>
              <FormItem
                label={t('LBL00710', 'Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.bucket}
                    options={bucketOptions}
                    onChange={(_, option) => {
                      setSearchParams({ bucket: option });
                    }}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <>
            {/* Row 3 — QTY / (SALES·BIZ) KRW/USD/LOC / (MKT) Sender Code */}
            <Grid size={3}>
              <FormItem
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
            {!isMkt && (
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('', 'KRW')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        isInput={false}
                        value={searchParams.krw}
                        options={DIVISOR_OPTIONS}
                        onChange={(_, option) => setSearchParams({ krw: option })}
                      />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('', 'USD')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        isInput={false}
                        value={searchParams.usd}
                        options={DIVISOR_OPTIONS}
                        onChange={(_, option) => setSearchParams({ usd: option })}
                      />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('', 'LOC')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        isInput={false}
                        value={searchParams.loc}
                        options={DIVISOR_OPTIONS}
                        onChange={(_, option) => setSearchParams({ loc: option })}
                      />
                    )}
                  />
                </Grid>
              </>
            )}
            {/* Sender Code — MKT 전용, div '81' 정확일치 시만 활성 */}
            {isMkt && (
              <Grid size={3}>
                <FormItem
                  label={t('LBL00090', 'Sender Code')}
                  labelAlign='right'
                  render={() => (
                    <CustomDropdown
                      multiple
                      allOption
                      useClearIcon
                      limitTags={1}
                      disabled={!isDivision81}
                      value={searchParams.senderCodes.join(',')}
                      options={
                        senderCode
                          ?.filter(
                            item => !item.DIVISION_ID || item.DIVISION_ID === searchParams.divisionId
                          )
                          .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                      }
                      onChange={(_, options) =>
                        setSearchParams({
                          senderCodes: String(options ?? '')
                            .split(',')
                            .filter(Boolean),
                        })
                      }
                    />
                  )}
                />
              </Grid>
            )}
            {/* Row 4 — PJT / Model·Nickname / Item Type / Biz.Type */}
            <ProjectField
              gridSize={3}
              value={searchParams.projectCodes}
              onChange={v => setSearchParams({ projectCodes: v })}
              division={searchParams.divisionId}
              deptIds={searchParams.deptIds}
              endCustomers={searchParams.endCustomers}
              scmSiteIds={searchParams.salesSiteIds}
              projectCodes={searchParams.projectCodes}
              disabled={isDivision40} // div40 Project disable (AS-IS .cs:348-357)
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
                label={t('', 'Item Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.itemTypes.join(',')}
                    options={
                      itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
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
            <BizTypeField
              gridSize={3}
              value={searchParams.bizTypes}
              onChange={v => setSearchParams({ bizTypes: v })}
              division={searchParams.divisionId}
            />
            {/* Row 5 — Plant Site / Owner */}
            <PlantSiteField
              gridSize={3}
              value={searchParams.plantSiteIds}
              onChange={v => setSearchParams({ plantSiteIds: v })}
              division={searchParams.divisionId}
              endCustomer={searchParams.endCustomers.join(',')}
            />
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
            {/* Row 6(최하단) — 체크박스 그룹 (사용자 지시 2026-08-06: Owner 뒤 + 라벨이 아닌
                입력 박스 시작점 정렬). 빈 문자열 라벨은 FormItem 이 라벨 칸 자체를 접어
                체크박스가 맨 앞에 붙으므로 NBSP 라벨로 라벨 칸 폭을 유지한다. */}
            <Grid size={3}>
              <FormItem
                label={' '}
                labelAlign='right'
                render={() => (
                  <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                    <Checkbox
                      labelText={t('LBL00687', 'Sum')}
                      checked={searchParams.isSumChecked}
                      disabled={searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY}
                      onChange={checked => setSearchParams({ isSumChecked: checked })}
                    />
                    {/* Cell Qty — MKT·BIZ div40 만. SALES 는 AS-IS Visible=false 라 미표시 */}
                    {!isSales && (
                      <Checkbox
                        labelText={t('', 'Cell Qty')}
                        checked={searchParams.isCellQtyChecked}
                        disabled={!isDivision40}
                        onChange={checked => setSearchParams({ isCellQtyChecked: checked })}
                      />
                    )}
                    {/* Qty≠0 — BIZ 전용 (p_qty_yn) */}
                    {isBiz && (
                      <Checkbox
                        labelText={t('', 'Qty≠0')}
                        checked={searchParams.isQtyNotZeroChecked}
                        onChange={checked => setSearchParams({ isQtyNotZeroChecked: checked })}
                      />
                    )}
                  </Stack>
                )}
              />
            </Grid>
          </>
        }
      />
      <WaterfallVersionModal
        open={openVersionModal}
        modalClose={() => setOpenVersionModal(false)}
        gubun={gubun}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        onApply={versionIds => setSearchParams({ version: versionIds })}
      />
    </>
  );
};
