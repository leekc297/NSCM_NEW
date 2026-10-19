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

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../business-plan.constants';
import { useBusinessPlanStore } from '../useBusinessPlanStore';
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
//   ⭐ 카탈로그(@master/searchFields): Division/Team/End Customer/Sales Site/Plant Site/
//     Project(40 비활성)/Model/Owner/Period. Plant Site 는 활성 기준만 disabled prop 으로 덮는다
//     (40 만 비활성 — 카탈로그 기본 게이트는 81 전용이라 그대로 두면 AS-IS 82 활성과 어긋난다).
//     인라인 유지 필드(원천 스왑 사유): Biz Type(40=DmBizType 스왑 — AS-IS DM_BIZ_TYPE 공통 대응) /
//     Item Type / Bucket(M/Q/Y — 'BucketType2' P5 신설).
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

  // 인라인 콤보 원천 (SCM_ADM_CMBO_SQL_M 등록명 — 2026-07-15 실측):
  //   Item Type    = 'ItemType' (ITEM_TYPE_CODE)
  //   Bucket       = 'BucketType2' (BUCKET2_TYPE_CODE — MONTHLY/QUARTERLY/YEARLY. P5 신설)
  // 카탈로그 필드가 직접 조회하는 조회조건 (2026-08-22 콤보 통일):
  //   Div / Team / End Customer / Sales Site / Plant Site =
  //     MyDivision / TeambyDivision / EndCustomer / SalesSite / PlantSitebyEndCustomer.
  //     'PlantSitebyEndCustomer' 는 SQL 개정으로 파라미터를 받지 않고 전량을 내려준다
  //     — cascade 는 클라이언트(카탈로그)에서 건다.
  //     종전 40 전용 'EndCustomerByDivision40' 스왑은 폐지했다.
  //   Biz Type = BizTypeField(comboId='BizTypebyDivision') — 통일 대상 아님, 종전 그대로.
  // TeamField 의 전체 선택 해제 결과가 [], [''], ['ALL'] 등으로 내려올 수 있으므로
  // 실제 Team ID만 남기고 나머지는 '미선택'([])으로 통일한다. (DMF0021 SalesPlanForm 1:1)
  const normalizeDeptIds = (values: string[] | string | null | undefined): string[] => {
    const items = Array.isArray(values) ? values : String(values ?? '').split(',');

    return items
      .map(value => String(value).trim())
      .filter(value => value !== '' && value.toUpperCase() !== 'ALL');
  };

  const activeDeptIds = normalizeDeptIds(sc.deptIds);

  // End Customer / Sales Site 는 카탈로그 필드가 직접 조회한다 (2026-08-22 콤보 통일 —
  //   'EndCustomer' / 'SalesSite'). 종전 'EndCustomerByDivision' + 'UserSiteByEndCustomer' 는 폐지.
  //   'EndCustomer' 는 DEPT_ID 가 NULL 인 행이 섞이므로 Team cascade 를 반드시 strict 로 건다 —
  //   관대로 두면 Team 축소가 AS-IS 보다 헐거워진다(2026-08-21 실측: 81 ESG팀에서 AS-IS 2건 대비 과다).
  const [itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['ItemType', 'BucketType2'],
  });

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
                bucketType: BUCKET_TYPE.MONTHLY,
                // ⭐ 2026-08-20 교정 — AS-IS Designer.cs 실측(chkSum.Checked=true / cboQty 미지정=false)
                sumYn: true,
                qtyYn: false,
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
                bucketType: BUCKET_TYPE.MONTHLY,
                // ⭐ 2026-08-20 교정 — 위 Division 변경 reset 과 같은 값
                sumYn: true,
                qtyYn: false,
              })
            }
            division={sc.divisionId}
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 위 콤보 주석의 2026-08-21 실측 근거 그대로다 — 관대 매칭이면 Team 을
                골라도 목록이 그대로 보인다.
              AS-IS clbCustomer_SelectedIndexChanged (L1535) — 변경 시 하위 Sales Site clear. */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: activeDeptIds, strict: true } }}
            debugLabel='DMF0042 business-plan / End Customer'
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] })}
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0014 / DMF0044 와 동일한 매핑이다.
              DEPT_ID 는 엄격 — 종전 'UserSiteByEndCustomer' 의 @deptId 브랜치가 하던 40 팀 축소를
                여기서 대신한다(2026-08-21 실측: 안 걸면 40 에서 다른 팀 사이트까지 남았다).
              PROJECT_CODE 는 관대 — 이 컬럼이 NULL 인 행이 정상적으로 존재해 자르면 목록이 빈다.
              deptId 는 정규화본(activeDeptIds)을 넘긴다 — 원본은 '' · 'ALL' 이 섞여 있다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              DEPT_ID: { values: activeDeptIds, strict: true },
              PROJECT_CODE: sc.endCustomers,
            }}
            debugLabel='DMF0042 business-plan / Sales Site'
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
          />

          {/* Row 2 — Plant Site(40 비활성) / Biz Type(40 원천 스왑) / Period* / Bucket*(기본 Monthly — M/Q/Y) */}
          {/* Plant Site — 카탈로그 PlantSiteField ('PlantSitebyEndCustomer', Division+EndCustomer
              클라이언트 cascade — 콤보는 파라미터 없이 전량을 내려준다). fetch 만 비활성 시 건너뛴다.
              ⚠ disabled 를 명시 전달한다 — 카탈로그 기본 게이트는 81 계열 전용(40·82 비활성)이라
                그대로 두면 82 가 잠긴다. DMF0042 는 40 만 비활성이고 81 계열·82 는 활성이다
                (AS-IS InitControls L259~261 / 설계서 [사업부별 분기] Plant Site 행). */}
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.join(',')}
            disabled={div40}
          />
          {/* Biz Type — 40/비40 을 한 콤보로 덮는 'BizTypebyDivision' (MktFcstForm 1:1).
              DM_BIZ_TYPE(40) UNION SCM_MST_PROJECT BIZ_TYPE(비40) 이며 DIVISION_ID 를 반환하므로
              카탈로그가 division 으로 거른다. 구 'DmBizType'(40) / 'BizTypeByDivision'(비40)
              2종 스왑에서 교체 — 두 원천은 값 집합이 서로 달랐다. */}
          <BizTypeField
            gridSize={3}
            value={sc.bizTypes}
            onChange={v => set({ bizTypes: v })}
            division={sc.divisionId}
            comboId='BizTypebyDivision'
          />
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
                      // ?? false — 기본값이 해제(Designer.cs cboQty 미체크)라 persist 구버전 shape 에
                      //   qtyYn 키가 없을 때의 대체값도 해제여야 한다. setFilter 는 initSearch 머지로
                      //   'N' 을 보내므로 true 로 두면 표시와 전송값이 어긋난다.
                      checked={sc.qtyYn ?? false}
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
