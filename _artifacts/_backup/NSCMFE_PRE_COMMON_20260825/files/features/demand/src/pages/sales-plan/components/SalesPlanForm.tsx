import {
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
import type { KeyboardEvent } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

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

// AS-IS DMF0021 조회조건 10종 + Sum 체크박스 (UI분석서 v1.0 시트 3 전수 — Color/Include Internal Txn 삭제 확정).
//   ⭐ 2026-07-28 레이아웃 개편 — 확장영역(extraConditions) 폐지, 4줄 상시표시(size=3, 4개/줄):
//     Row1 Div/Team/End Customer/Sales Site / Row2 Biz Type/Plant Site/Item Type /
//     Row3 Period/Bucket/Project🔍/Model🔍(Bucket 우측) / Row4 Owner🔍/Sum 체크박스(Owner 우측).
//     Period = 카탈로그 PeriodField(datePickerFix 내장).
//   ⭐ 카탈로그(@master/searchFields): Division/Team/End Customer/Sales Site/Plant Site/
//     Project(40 비활성)/Model/Owner/Period.
//     Plant Site 는 활성 기준만 disabled prop 으로 덮는다(40 만 비활성. 카탈로그 기본 게이트는
//     81 전용이라 그대로 두면 AS-IS 82 활성과 어긋난다. BusinessPlanForm 과 동일 처리).
//     인라인 유지 필드(원천 스왑 사유): Biz Type(40=DmBizType 스왑) / Item Type / Bucket(D 포함 3종).
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
  //   End Customer = 카탈로그 EndCustomerField 가 직접 조회 ('EndCustomer' 단일 — 2026-08-22
  //                  콤보 통일. 종전 40 전용 'EndCustomerByDivision40' 스왑은 폐지)
  //   Sales Site   = 카탈로그 SalesSiteField 가 직접 조회 ('SalesSite' — 2026-08-22 콤보 통일.
  //                  종전 'SiteByEndCustomer' 서버 바인드는 폐지, cascade 는 클라이언트)
  //   Biz Type     = 'BizTypeByDivision'(81·82) / 'DmBizType'(40 — L445 스왑)
  //   Item Type    = 'ItemType' (SCM0001 ITEM_TYPE_CODE)
  //   Bucket       = 'BucketType' (DMF0003_GET_BUCKET_TYPE_CODE — full-word CODE)
  //   Plant Site   = 카탈로그 PlantSiteField 가 직접 조회 ('PlantSitebyEndCustomer' — 2026-08-22
  //                  SQL 개정으로 파라미터를 받지 않고 전량을 내려준다. cascade 는 클라이언트).
  // TeamField 의 전체 선택 해제 결과가 [], [''], ['ALL'] 등으로 내려올 수 있으므로
  // 실제 Team ID만 남기고 나머지는 '미선택'([])으로 통일한다.
  const normalizeDeptIds = (values: string[] | string | null | undefined): string[] => {
    const items = Array.isArray(values) ? values : String(values ?? '').split(',');

    return items
      .map(value => String(value).trim())
      .filter(value => value !== '' && value.toUpperCase() !== 'ALL');
  };

  const activeDeptIds = normalizeDeptIds(sc.deptIds);

  const [bizTypeByDivision, dmBizType, itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['BizTypeByDivision', 'DmBizType', 'ItemType', 'BucketType'],
  });

  // 멀티 옵션 헬퍼 — NUMBER→String + DIVISION_ID 토큰 필터 (카탈로그 toOptions 동등)
  const toOptions = (
    rows: Array<Record<string, unknown>> | undefined,
    divisionId?: string,
    deptIds?: string[]
  ) => {
    const arr = (rows ?? []) as unknown as Array<Record<string, string>>;
    const selectedDepts = new Set(deptIds ?? []);
    return [
      ...new Map(
        arr
          .filter(
            r =>
              (!divisionId || !r.DIVISION_ID || r.DIVISION_ID === divisionId) &&
              (selectedDepts.size === 0 || !r.DEPT_ID || selectedDepts.has(r.DEPT_ID))
          )
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

  const toMulti = (v: string | undefined): string[] =>
    String(v ?? '')
      .split(',')
      .filter(Boolean);

  // Project / Model(Nickname) 입력창에서 Enter를 누르면 기존 검색 버튼과 동일하게 모달을 연다.
  // 검색 버튼의 기존 click 로직을 재사용하므로 입력 중인 값도 그대로 모달 검색조건에 전달된다.
  const openFieldModalOnEnter = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key !== 'Enter' || event.nativeEvent.isComposing) return;
    if (!(event.target instanceof HTMLInputElement)) return;

    const searchButton = event.currentTarget.querySelector<HTMLButtonElement>(
      'button[aria-label*="search" i], button[title*="search" i], ' +
        'button[aria-label*="조회"], button[title*="조회"]'
    );
    const searchIconButton = event.currentTarget
      .querySelector<SVGElement>(
        'svg[data-testid="SearchIcon"], svg[data-testid="ManageSearchIcon"], ' +
          'svg[data-testid="FindInPageIcon"]'
      )
      ?.closest('button') as HTMLButtonElement | null;
    const buttons =
      event.currentTarget.querySelectorAll<HTMLButtonElement>('button:not(:disabled)');
    const fallbackButton = buttons.length > 0 ? buttons[buttons.length - 1] : null;
    const modalOpenButton = searchButton ?? searchIconButton ?? fallbackButton;

    if (!modalOpenButton) return;

    event.preventDefault();
    event.stopPropagation();
    modalOpenButton.click();
  };

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
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
                itemTypes: [],
                bucketType: BUCKET_TYPE.MONTHLY,
                sumYn: false,
              });
              onDivisionChange();
            }}
          />
          {/* searchGrid — 칩 다중선택(Team)이 컬럼 min-content 폭을 밀어 옆 필드를 침범하는 것 방지 */}
          <div className={styles.searchGrid}>
            <TeamField
              gridSize={3}
              value={activeDeptIds}
              onChange={v =>
                set({
                  deptIds: normalizeDeptIds(v),
                  endCustomers: [],
                  scmSiteIds: [],
                  plantSiteIds: [],
                  bizTypes: [],
                  projectCodes: [],
                  itemIds: [],
                  owners: [],
                  itemTypes: [],
                  bucketType: BUCKET_TYPE.MONTHLY,
                  sumYn: false,
                })
              }
              division={sc.divisionId}
            />
          </div>
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다.
              AS-IS clbCustomer_SelectedIndexChanged (L5084) — 변경 시 하위 Sales Site clear. */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: activeDeptIds, strict: true } }}
            debugLabel='DMF0021 sales-plan / End Customer'
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] })}
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0014 / DMF0044 와 동일한 매핑이다.
              DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                존재해 자르면 목록이 통째로 비어버린다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              DEPT_ID: { values: activeDeptIds, strict: true },
              PROJECT_CODE: sc.endCustomers,
            }}
            debugLabel='DMF0021 sales-plan / Sales Site'
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
          />
          {/* Row 2 — Biz Type(40 원천 스왑) / Item Type / Period* / Bucket* (1단 필수 조건 —
              2026-08-12 사용자 지시: 2단 접기/펼치기 표준(DMF0003/0082 파리티) 재배치.
              Plant Site 는 2단(Row 3)으로 이동) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Biz. Type')}
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
          <Grid size={3}>
            <FormItem
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.itemTypes.join(',')}
                  options={
                    itemType?.map((item: ComboResponse) => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => set({ itemTypes: toMulti(String(options ?? '')) })}
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
          {/* Row 3 (2단) — Project🔍(40 비활성) / Model🔍(Nickname) / Plant Site */}
          <div style={{ display: 'contents' }} onKeyDownCapture={openFieldModalOnEnter}>
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
          </div>
          <div style={{ display: 'contents' }} onKeyDownCapture={openFieldModalOnEnter}>
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
          </div>
          {/* Plant Site — 카탈로그 PlantSiteField. 콤보 'PlantSitebyEndCustomer' 는 파라미터를
              받지 않으므로 Division + End Customer cascade 는 카탈로그가 클라이언트에서 건다.
              disabled 를 명시 전달한다 — 카탈로그 기본 게이트는 81 계열 전용이라 그대로 두면
              AS-IS 에서 활성인 82 가 잠긴다. DMF0021 은 40 만 비활성이다. */}
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
            disabled={div40}
          />
          {/* Row 4 (2단) — Owner🔍 / Sum 체크박스(Owner 우측) */}
          <Grid size={3} className={commonStyles.customGrid}>
            <OwnerField
              gridSize={12}
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
            <FormItem
              className={commonStyles.formItem}
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox
                    labelText={t('LBL00687', '_Sum')}
                    checked={sc.sumYn}
                    sx={{ marginLeft: '15px' }}
                    onChange={checked => set({ sumYn: checked })}
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
