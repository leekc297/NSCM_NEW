import {
  DivisionField,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../sales-plan.constants';
import { useSalesPlanStore } from '../useSalesPlanStore';
import { isDiv40 } from '../utils/sales-plan.division';
import type { useSalesPlanValidation } from '../utils/sales-plan.validate';

import styles from './SalesPlanForm.module.scss';

interface SalesPlanFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset —
  //   재조회는 Search 버튼). 부모(SalesPlan.tsx)가 insertedRows/EditTracker/조회 게이트 reset 수행.
  onDivisionChange: () => void;
  // ⭐ Bucket 변경 가드 — 변경분(신규 행/수정 셀) 존재 시 MSG00227 차단 (AS-IS cboBucketType_Click L5475).
  //   EditTracker(ref, 비반응형)를 클릭 시점에 평가하도록 함수로 전달.
  hasPendingChanges: () => boolean;
  validation: ReturnType<typeof useSalesPlanValidation>;
}

// AS-IS DMF0021 조회조건 12종 + Sum 체크박스 (UI분석서 v1.0 시트 3 전수 — 컨트롤 20 중 dead/숨김 제외).
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 모든 객체 36px. Period = 카탈로그 PeriodField(datePickerFix 내장).
//   ⭐ 카탈로그(@master/searchFields): Division/Team/SalesSite/Project(40 비활성)/Model/Owner/Period.
//     인라인 유지 필드(원천 스왑·division 분기 사유): End Customer(40=EndCustomerByDivision40 스왑) /
//     Biz Type(40=DmBizType 스왑) / Plant Site(40 만 비활성 — 카탈로그 PlantSiteField 는 81 전용이라
//     AS-IS 82 활성과 상이 → 동일 CMBO 'PlantSitebyEndCustomer' 인라인) / Item Type / Bucket(D 포함 3종).
export const SalesPlanForm = ({
  onSearch,
  onDivisionChange,
  hasPendingChanges,
  validation,
}: SalesPlanFormProps) => {
  const { t } = useTranslation();

  const sc = useSalesPlanStore(s => s.searchCondition);
  const set = useSalesPlanStore(s => s.setSearchCondition);
  const openSearchArea = useSalesPlanStore(s => s.openSearchArea);

  const div40 = isDiv40(sc.divisionId);

  // ⭐ 인라인 콤보 원천 (SCM_ADM_CMBO_SQL_M 등록명 — UI분석서 시트 3 실측):
  //   End Customer = 'EndCustomer'(81·82) / 'EndCustomerByDivision40'(40 — AS-IS InitControls L452 스왑)
  //   Biz Type     = 'BizTypeByDivision'(81·82) / 'DmBizType'(40 — L445 스왑)
  //   Item Type    = 'ItemType' (SCM0001 ITEM_TYPE_CODE)
  //   Bucket       = 'BucketType' (DMF0003_GET_BUCKET_TYPE_CODE — full-word CODE)
  //   Plant Site   = 'PlantSitebyEndCustomer' (Division+EndCustomer 서버 바인드 + 값 quoting 의무)
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const [endCustomer, endCustomer40, bizTypeByDivision, dmBizType, itemType, bucketTypeCombo, plantSite] =
    useTabComboQueries({
      filters: [
        'EndCustomer',
        'EndCustomerByDivision40',
        // ⭐ 2026-07-23 AS-IS 정합(사용자 승인) — BIZ_TYPE_BPMS lookup(12종 고정) →
        //   AS-IS SCM0001_GET_BIZ_TYPE_BY_DIVISION 1:1 (SCM_MST_PROJECT division별 distinct, @divisionId 바인드).
        { comboId: 'BizTypeByDivision', divisionId: q(sc.divisionId) },
        'DmBizType',
        'ItemType',
        'BucketType',
        {
          comboId: 'PlantSitebyEndCustomer',
          divisionId: q(sc.divisionId),
          endCustomer: q(sc.endCustomers.join(',')),
        },
      ],
    });

  // 멀티 옵션 헬퍼 — NUMBER→String + DIVISION_ID 토큰 필터 (카탈로그 toOptions 동등)
  const toOptions = (rows: Array<Record<string, unknown>> | undefined, divisionId?: string) => {
    const arr = (rows ?? []) as unknown as Array<Record<string, string>>;
    return [
      ...new Map(
        arr
          .filter(r => !divisionId || !r.DIVISION_ID || r.DIVISION_ID === divisionId)
          .map(r => [`${r.DIVISION_ID ?? ''}|${r.CODE ?? ''}`, r] as const)
      ).values(),
    ].map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
  };

  // Bucket 옵션 — CMBO CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑 + 정적 fallback (DMF0003 동일)
  const bucketLabelKey: Record<string, string> = {
    [BUCKET_TYPE.DAILY]: 'LBL00682',
    [BUCKET_TYPE.WEEKLY]: 'LBL00683',
    [BUCKET_TYPE.MONTHLY]: 'LBL00684',
  };
  const bucketFallback = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0) as BUCKET_TYPE;
            return { label: t(bucketLabelKey[code] ?? '', String(item.NAME ?? code)), value: code };
          })
          .filter(
            o =>
              o.value === BUCKET_TYPE.DAILY ||
              o.value === BUCKET_TYPE.WEEKLY ||
              o.value === BUCKET_TYPE.MONTHLY
          )
      : bucketFallback;

  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);
  const toMulti = (v: string | undefined): string[] => String(v ?? '').split(',').filter(Boolean);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00691', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division* / Team / End Customer(40 원천 스왑) / Sales Site */}
          {/* ⭐ Division 변경 — 종속필드 전면 reset (AS-IS clbDivision_SelectedIndexChanged L5095:
              Team/BizType/EC/Site/Plant 재조회 + txtProject/txtItemId/txtOwner 클리어 + InitSpread) +
              Grid 초기화(onDivisionChange). */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={option => {
              set({
                divisionId: option,
                deptIds: [],
                endCustomers: [],
                scmSiteIds: [],
                plantSiteIds: [],
                bizTypes: [],
                projectCodes: [],
                itemIds: [],
                owners: [],
              });
              onDivisionChange();
            }}
          />
          <TeamField
            gridSize={3}
            value={sc.deptIds}
            onChange={v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] })}
            division={sc.divisionId}
            // ⭐ 2026-07-23 조회조건 AS-IS 정합 — Team 소스를 AS-IS BigFilter 1:1 등록본
            //   'UserTeamByDivision'(SITE_ITEM.OWNER 1번 토큰 사용자의 부서)으로 전환.
            //   공유 'TeambyDivision'(DEPT_ID 직접)과 차집합 35/64 실측 (hook #117).
            comboId='UserTeamByDivision'
          />
          <Grid size={3}>
            {/* ⭐ End Customer — 40 = 'EndCustomerByDivision40' 원천 스왑 (AS-IS InitControls L452 /
                clbDivision L5131). 변경 시 Sales Site 재조회 종속 clear (clbCustomer L5084). */}
            <FormItem
              label={t('LBL00503', 'End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.endCustomers.join(',')}
                  options={toOptions(
                    (div40 ? endCustomer40 : endCustomer) as never,
                    div40 ? undefined : sc.divisionId
                  )}
                  onChange={(_, options) =>
                    set({ endCustomers: toMulti(String(options ?? '')), scmSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>
          <SalesSiteField
            gridSize={3}
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
            division={sc.divisionId}
            // ⭐ 2026-07-23 AS-IS 정합(사용자 승인) — 'UserSiteByEndCustomer' 서버 바인드 전환:
            //   EndCustomer/Team cascade + 40 owner-team 필터 + OPERATION_GROUP 'W' 제외 (hook #117).
            comboId='UserSiteByEndCustomer'
            endCustomer={sc.endCustomers.join(',')}
            deptId={sc.deptIds.join(',')}
          />

          {/* Row 2 — Plant Site(40 비활성) / Biz Type(40 원천 스왑) / Period* / Bucket*(기본 Monthly) */}
          <Grid size={3}>
            {/* ⭐ Plant Site — AS-IS 40 만 비활성+클리어 (InitControls L455~460), 81·82 활성.
                카탈로그 PlantSiteField(81 전용 enable)와 상이 — 동일 CMBO 인라인 (shared prop 변경 금지). */}
            <FormItem
              label={t('LBL00509', 'Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={div40}
                  value={sc.plantSiteIds.join(',')}
                  options={((plantSite ?? []) as Array<Record<string, string>>).map(r => ({
                    label: String(r.NAME ?? r.CODE ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, options) => set({ plantSiteIds: toMulti(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            {/* ⭐ Biz Type — 40 = 'DmBizType' 원천 스왑 (AS-IS InitControls L445 / clbDivision L5124). */}
            <FormItem
              label={t('LBL00504', 'Biz.Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.bizTypes.join(',')}
                  options={toOptions(
                    (div40 ? dmBizType : bizTypeByDivision) as never,
                    div40 ? undefined : sc.divisionId
                  )}
                  onChange={(_, options) => set({ bizTypes: toMulti(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // ⭐ 변경분 존재 시 Bucket 변경 차단 (AS-IS cboBucketType_Click L5475 MSG00227)
                    if (!validation.validateBucketChange(hasPendingChanges()).ok) return;
                    set({ bucketType: option as BUCKET_TYPE });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Project🔍(40 비활성) / Model🔍 / Owner🔍 / Item Type */}
          {/* ⭐ Project — 40 비활성 (AS-IS btnProject 81·82 만 동작 L3491 + InitControls Disable L455). */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={div40}
            multiCheckbox
          />
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
          <Grid size={3}>
            <FormItem
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.itemTypes)}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => set({ itemTypes: toArr(option) })}
                />
              )}
            />
          </Grid>

          {/* Row 4 — 체크박스 Sum (Color 제거·Include Internal Txn 숨김 'N' 배선·Cell Qty dead 제외 —
              2026-07-14 사용자 확정 + AS-IS InternalYN Visible=false / cboCellQty 무배선) */}
          <Grid size={3}>
            <div className={styles.checkboxRow}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={sc.sumYn}
                  onChange={checked => set({ sumYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
