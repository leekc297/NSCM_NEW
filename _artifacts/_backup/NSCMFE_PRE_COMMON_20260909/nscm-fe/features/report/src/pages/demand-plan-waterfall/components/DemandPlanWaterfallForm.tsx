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
  /** UM-01 — Division 변경 = Grid 초기화(#59 §1.4, AS-IS cboDivision_SelectedIndexChanged → InitSpread .cs:1397) */
  onDivisionChange?: () => void;
  /** UM-08 — bucket 전환 (경계 판정·InitSpread 등가는 페이지가 담당) */
  onBucketChange?: (prev: string, next: string) => void;
  /** Waterfall Type(GUBUN) 전환 = 시트·메타 축 전환 → Grid 초기화 (사용자 지시 2026-09-04) */
  onGubunChange?: () => void;
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

export const DemandPlanWaterfallForm = ({
  onSubmit,
  onDivisionChange,
  onBucketChange,
  onGubunChange,
}: DemandPlanWaterfallFormProps) => {
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
  // UM-03 — AS-IS cboDivision_SelectedIndexChanged .cs:1417~1423: 81 계열·82 = Project/Plant Site 활성, 그 외(40) 비활성
  const isProjectPlantEnabled =
    searchParams.divisionId.startsWith('81') || searchParams.divisionId === '82';

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

  // [E20260831-NOONLYWEEKLY] 조회조건 BUCKET 에서 ONLY_WEEKLY 제거 (사용자 지시 2026-08-31)
  const bucketOptions = (
    isBiz ? comboOr(bucketType2, BUCKET2_OPTIONS) : comboOr(reportBucketType, [])
  ).filter(option => option.value !== BUCKET_TYPE.ONLY_WEEKLY);
  const qtyOptions = comboOr(qtyType, DIVISOR_OPTIONS);

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!isOpenSearchArea}
        onSearch={onSubmit}
        // 펼침(3단) 시 flex 축소로 내용이 SubTitle 위에 겹치는 것 방지 — 검색영역은 원 높이 유지,
        // 나머지(그리드)가 flex:1 로 줄어든다 (ViewContainer flex column 구조)
        sx={{ flexShrink: 0 }}
        conditions={
          <>
            {/* Row 1 — Div* / Team / End Customer / Sales Site (Waterfall Type 은 Bucket 뒤 — 사용자 지시 2026-08-27) */}
            <DivisionField
              gridSize={3}
              value={searchParams.divisionId}
              onChange={option => {
                if (option === searchParams.divisionId) return;
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
                });
                // UM-01 — AS-IS .cs:1397 InitSpread(): 남은 조회 결과는 새 division 과 어긋나므로 비운다
                onDivisionChange?.();
              }}
            />
            <TeamField
              gridSize={3}
              value={searchParams.deptIds}
              onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })}
              division={searchParams.divisionId}
            />
            {/* UM-02 — Team → End Customer cascade (AS-IS clbTeam_SelectedIndexChanged .cs:339/366:
                EndCustomerByDivision(division, team) 재적재). 공용 필드 cascade(DEPT_ID) 로 팀 선택 시 좁힌다.
                [E20260831-UM02FIX] 기본 콤보('EndCustomer')는 DEPT_ID 속성이 없어 strict cascade 가 팀 선택 시
                전 행을 탈락시켰다(40 실측 0행 — 사용자 신고 2026-08-31). 정본 콤보 'EndCustomerByDivision'
                (40=SITE_ITEM owner-dept 축 DEPT_ID 보유 + lookup UNION) 로 교체. DEPT_ID 는 40 축에만 실리므로
                cascade 는 40 한정(타 division 은 lookup 축 = 팀 무관 — AS-IS 등가). */}
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
            {/* AS-IS .cs:1440 — Sales Site 재적재의 team 파라미터: 81 계열·82 는 string.Empty / 40 은 team */}
            <SalesSiteField
              gridSize={3}
              value={searchParams.salesSiteIds}
              onChange={v => setSearchParams({ salesSiteIds: v })}
              division={searchParams.divisionId}
              comboId='UserSiteByEndCustomer'
              endCustomer={searchParams.endCustomers.join(',')}
              deptId={isProjectPlantEnabled ? '' : searchParams.deptIds.join(',')}
            />
            {/* Row 2 — Ver. / Period* / Bucket / Waterfall Type(구 Gubun — 명칭 사용자 확정 2026-08-06) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00031', 'Ver.')}
                labelAlign='right'
                required // [E20260831-VERREQ] 전 waterfall type 필수 (사용자 지시 2026-08-31 — 구 'MKT 비필수' 폐기. 기본값 CURRENT)
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
                className={commonStyles.formItem}
                label={t('LBL00710', 'Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.bucket}
                    options={bucketOptions}
                    onChange={(_, option) => {
                      // UM-08 — 컬럼 가시성은 즉시 반응(Grid visiblePrefixes), 경계 전환은 페이지가 InitSpread 등가 처리
                      const prev = searchParams.bucket;
                      setSearchParams({ bucket: option });
                      if (prev !== option) onBucketChange?.(prev, option);
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('', 'Waterfall Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={gubun}
                    options={GUBUN_OPTIONS}
                    onChange={(_, option) => {
                      if (option === gubun) return;
                      // GUBUN 전환 = 시트 전환 — 버킷 체계 스왑 + 버전·전용 조건 클리어
                      setSearchParams(gubunResetParams(option as Gubun));
                      // 남은 조회 결과는 이전 TYPE 의 컬럼·메저 구성이라 새 TYPE 과 어긋난다 → 비운다
                      //   (Division 변경과 동일 규약 — 재조회는 Search 버튼)
                      onGubunChange?.();
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
            {!isMkt && (
              <>
                <Grid size={3}>
                  <FormItem
                    className={commonStyles.formItem}
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
                    className={commonStyles.formItem}
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
                    className={commonStyles.formItem}
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
                  className={commonStyles.formItem}
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
              disabled={!isProjectPlantEnabled} // UM-03 — 81 계열·82 만 활성 (AS-IS .cs:1417~1423 / 348-357)
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
              disabled={!isProjectPlantEnabled} // UM-03 — AS-IS .cs:1421 lblPlantSite.Enabled = 81 계열·82 만
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
                className={commonStyles.formItem}
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
