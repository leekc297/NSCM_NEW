import {
  DivisionField,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../business-plan.constants';
import { BUSINESS_PLAN_INIT_PERIOD, useBusinessPlanStore } from '../useBusinessPlanStore';
import { isDiv40 } from '../utils/business-plan.division';
import type { useBusinessPlanValidation } from '../utils/business-plan.validate';

import styles from './BusinessPlanForm.module.scss';

interface BusinessPlanFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset —
  //   재조회는 Search 버튼). 부모(BusinessPlan.tsx)가 insertedRows/EditTracker/조회 게이트 reset 수행.
  onDivisionChange: () => void;
  // ⭐ Bucket 변경 가드 — 변경분 존재 시 MSG00227 차단 (AS-IS cboBucketType_Click L2963~2973).
  hasPendingChanges: () => boolean;
  validation: ReturnType<typeof useBusinessPlanValidation>;
}

// AS-IS DMF0042 조회조건 14종 + Sum/Qty≠0 체크박스 (상세동작 md §3 컨트롤 15 전수 — cboClosed dead 제외).
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 모든 객체 36px. Period = 카탈로그 PeriodField(datePickerFix 내장).
//   ⭐ 카탈로그(@master/searchFields): Division/Team/SalesSite/Project(40 비활성)/Model/Owner/Period.
//     인라인 유지 필드(원천 스왑·division 분기 사유): End Customer(40=EndCustomerByDivision40 스왑) /
//     Biz Type(40=DmBizType 스왑 — AS-IS DM_BIZ_TYPE 공통 대응) / Plant Site(40 만 비활성 —
//     동일 CMBO 'PlantSitebyEndCustomer' 인라인) / Item Type / Bucket(M/Q/Y — 'BucketType2' P5 신설).
export const BusinessPlanForm = ({
  onSearch,
  onDivisionChange,
  hasPendingChanges,
  validation,
}: BusinessPlanFormProps) => {
  const { t } = useTranslation();

  const sc = useBusinessPlanStore(s => s.searchCondition);
  const set = useBusinessPlanStore(s => s.setSearchCondition);
  const openSearchArea = useBusinessPlanStore(s => s.openSearchArea);

  const div40 = isDiv40(sc.divisionId);

  // ⭐ 인라인 콤보 원천 (SCM_ADM_CMBO_SQL_M 등록명 — 2026-07-15 실측):
  //   End Customer = 'EndCustomer'(81·82) / 'EndCustomerByDivision40'(40 — AS-IS InitControls 스왑)
  //   Biz Type     = 'BizTypeByDivision'(81·82 — GetBizTypebyDivision) / 'DmBizType'(40 — DM_BIZ_TYPE)
  //   Item Type    = 'ItemType' (ITEM_TYPE_CODE)
  //   Bucket       = 'BucketType2' (BUCKET2_TYPE_CODE — MONTHLY/QUARTERLY/YEARLY. P5 신설)
  //   Plant Site   = 'PlantSitebyEndCustomer' (Division+EndCustomer 서버 바인드 + 값 quoting 의무)
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const [
    endCustomer,
    endCustomer40,
    bizTypeByDivision,
    dmBizType,
    itemType,
    bucketTypeCombo,
    plantSite,
  ] = useTabComboQueries({
    filters: [
      'EndCustomer',
      'EndCustomerByDivision40',
      // ⭐ 2026-07-23 AS-IS 정합(사용자 승인) — BIZ_TYPE_BPMS lookup(12종 고정) →
      //   AS-IS SCM0001_GET_BIZ_TYPE_BY_DIVISION 1:1 (SCM_MST_PROJECT division별 distinct, @divisionId 바인드).
      { comboId: 'BizTypeByDivision', divisionId: q(sc.divisionId) },
      'DmBizType',
      'ItemType',
      'BucketType2',
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

  // Bucket 옵션 — CMBO CODE 풀워드(MONTHLY/QUARTERLY/YEARLY) → 첫 글자 enum 매핑 + 정적 fallback
  const bucketFallback = [
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
    { label: 'Quarterly', value: BUCKET_TYPE.QUARTERLY },
    { label: 'Yearly', value: BUCKET_TYPE.YEARLY },
  ];
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0) as BUCKET_TYPE;
            return { label: String(item.NAME ?? code), value: code };
          })
          .filter(
            o =>
              o.value === BUCKET_TYPE.MONTHLY ||
              o.value === BUCKET_TYPE.QUARTERLY ||
              o.value === BUCKET_TYPE.YEARLY
          )
      : bucketFallback;

  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);
  const toMulti = (v: string | undefined): string[] =>
    String(v ?? '')
      .split(',')
      .filter(Boolean);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division* / Team / End Customer(40 원천 스왑) / Sales Site */}
          {/* ⭐ Division 변경 — 종속필드 전면 reset (AS-IS cboDivision_SelectedIndexChanged L1422~1507:
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
                itemTypes: [],
                startYyyymmdd: BUSINESS_PLAN_INIT_PERIOD.start,
                endYyyymmdd: BUSINESS_PLAN_INIT_PERIOD.end,
                bucketType: BUCKET_TYPE.MONTHLY,
                sumYn: false,
                qtyYn: true,
              });
              onDivisionChange();
            }}
          />
          <TeamField
            gridSize={3}
            value={sc.deptIds}
            onChange={v =>
              set({
                deptIds: v,
                endCustomers: [],
                scmSiteIds: [],
                plantSiteIds: [],
                bizTypes: [],
                projectCodes: [],
                itemIds: [],
                owners: [],
                itemTypes: [],
                startYyyymmdd: BUSINESS_PLAN_INIT_PERIOD.start,
                endYyyymmdd: BUSINESS_PLAN_INIT_PERIOD.end,
                bucketType: BUCKET_TYPE.MONTHLY,
                sumYn: false,
                qtyYn: true,
              })
            }
            division={sc.divisionId}
          />
          <Grid size={3}>
            {/* ⭐ End Customer — 40 = 'EndCustomerByDivision40' 원천 스왑 (AS-IS InitControls L252~262).
                변경 시 Sales Site 재조회 종속 clear (clbCustomer L1535). */}
            <FormItem
              label={t('LBL00503', 'End Customer')}
              labelAlign='right'
              className={commonStyles.formItem}
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

          {/* Row 2 — Plant Site(40 비활성) / Biz Type(40 원천 스왑) / Period* / Bucket*(기본 Monthly — M/Q/Y) */}
          <Grid size={3}>
            {/* ⭐ Plant Site — AS-IS 40 만 비활성 (InitControls L259~261), 81·82 활성. */}
            <FormItem
              label={t('LBL00509', 'Plant Site')}
              labelAlign='right'
              className={commonStyles.formItem}
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
            {/* ⭐ Biz Type — 40 = 'DmBizType' 원천 스왑 (AS-IS InitControls L252 DM_BIZ_TYPE). */}
            <FormItem
              label={t('LBL00504', 'Biz.Type')}
              labelAlign='right'
              className={commonStyles.formItem}
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
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // ⭐ 변경분 존재 시 Bucket 변경 차단 (AS-IS cboBucketType_Click L2969 MSG00227)
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
          {/* ⭐ Project — 40 비활성 (AS-IS btnProject 81·82 전용 L2762 + InitControls Disable L259). */}
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
              className={commonStyles.formItem}
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

          {/* Row 4 — 체크박스 Sum / Qty≠0 (cboClosed dead 제외 — 파리티). 좌측 첫 열 배치.
              ⭐ Qty≠0 = P_QTY_YN 조회 파라미터 (기본 체크 — Search 시 반영. Sum 과 달리 즉시 토글 아님).
                 라벨 = AS-IS 화면 리터럴 'Qty≠0' (신규 LBL 채번 금지 규약 — 기존 LBL00689 는
                 '_Qty ≥ 0' 문구라 DMF0042 AS-IS 와 불일치해 미사용. 2026-08-06 사용자 지시). */}
          <Grid size={3}>
            {/* ⭐ 시작 위치 정렬 (2026-08-06 사용자 요청) — 빈 라벨 FormItem 으로 감싼다.
                FormItem 은 `grid-template-columns: {labelWidth}px auto`(labelSize 기준 고정 px) 라
                라벨 트랙만 확보되면 콘텐츠가 위 조건들의 입력 박스와 같은 x 에서 시작한다.
                ⚠ label='' 은 falsy 라 라벨 트랙이 생성되지 않아 정렬이 안 됐음 → NBSP 사용.
                   보이지는 않으면서 truthy 라 트랙이 잡힌다. */}
            <FormItem
              label={' '}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <div className={styles.checkboxRow}>
                  <Stack direction='row' spacing={2} alignItems='center'>
                    <Checkbox
                      labelText={t('LBL00687', '_Sum')}
                      checked={sc.sumYn}
                      onChange={checked => set({ sumYn: checked })}
                    />
                    <Checkbox
                      labelText='Qty≠0'
                      // ?? true — persist(sessionStorage) 구버전 shape 에는 qtyYn 키가 없어 표시가
                      //   해제로 보이는 반면 setFilter 는 initSearch 머지로 'Y' 를 보내 어긋남 (store 동일 방어)
                      checked={sc.qtyYn ?? true}
                      onChange={checked => set({ qtyYn: checked })}
                    />
                  </Stack>
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
