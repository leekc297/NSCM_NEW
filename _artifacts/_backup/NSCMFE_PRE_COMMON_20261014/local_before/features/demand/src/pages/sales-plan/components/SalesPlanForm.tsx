import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  buildComboOptions,
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
import {
  SEARCH_COMBO,
  resolveEndCustomerCodes,
  resolvePlantSiteComboId,
  resolveSalesSiteDeptIds,
} from '../utils/sales-plan.searchCombos';
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
//   카탈로그(@master/searchFields): Project(40 비활성) / Model / Owner / Period.
//   2026-08-28 콤보 재정비 — Division/Team/End Customer/Biz Type/Sales Site/Plant Site 는
//     카탈로그 필드를 걷어내고 필터(Filter 접두) 콤보 + 인라인 드롭다운으로 옮겼다.
//     문서 §1 이 이 6종을 전부 필터로 규정하고, AS-IS 는 같은 콤보라도 무엇을 바꿨느냐로
//     축이 달라져(팀 반영 여부·Plant Site 원천) 카탈로그의 단일 cascade 규칙으로는 재현이 안 된다.
//     원천·축·AS-IS 라인은 utils/sales-plan.searchCombos 참조.
export const SalesPlanForm = ({
  onSearch,
  onDivisionChange,
  hasPendingChanges,
  validation,
}: SalesPlanFormProps) => {
  const { t } = useTranslation();

  const sc = useSalesPlanStore(s => s.searchCondition);
  const set = useSalesPlanStore(s => s.setSearchCondition);
  const setBucketType = useSalesPlanStore(s => s.setBucketType);
  const openSearchArea = useSalesPlanStore(s => s.openSearchArea);
  const comboTrigger = useSalesPlanStore(s => s.comboTrigger);
  const plantSiteSource = useSalesPlanStore(s => s.plantSiteSource);

  const div40 = isDiv40(sc.divisionId);

  // 재조회로 남는 콤보 (SCM_ADM_CMBO_SQL_M 등록명 — UI분석서 시트 3 실측):
  //   Item Type = 'ItemType'   (SCM0001 ITEM_TYPE_CODE)
  //   Bucket    = 'BucketType' (DMF0003_GET_BUCKET_TYPE_CODE — full-word CODE)
  // 전체 선택 해제 결과가 [], [''], ['ALL'] 등으로 내려올 수 있으므로
  // 실제 Team ID만 남기고 나머지는 '미선택'([])으로 통일한다.
  const normalizeDeptIds = (values: string[] | string | null | undefined): string[] => {
    const items = Array.isArray(values) ? values : String(values ?? '').split(',');

    return items
      .map(value => String(value).trim())
      .filter(value => value !== '' && value.toUpperCase() !== 'ALL');
  };

  const activeDeptIds = normalizeDeptIds(sc.deptIds);

  /**
   * 조회조건 콤보 6종은 전부 필터다 (문서 §1). 파라미터 없이 전량을 한 번 받고 좁히는 일은
   * 화면이 한다 - 원천·축·AS-IS 라인은 utils/sales-plan.searchCombos 참조.
   * Item Type 과 Bucket 만 재조회이며 현행 콤보 ID 를 그대로 쓴다.
   */
  const [divisions, teams, endCustomers, bizType, salesSites, itemType, bucketTypeCombo] =
    useTabComboQueries({
      filters: [
        SEARCH_COMBO.division,
        SEARCH_COMBO.team,
        SEARCH_COMBO.endCustomer,
        SEARCH_COMBO.bizType,
        SEARCH_COMBO.salesSite,
        'ItemType',
        'BucketType',
      ],
    });

  /**
   * Plant Site 는 경로마다 원천이 다르다 - 진입은 고객 기준(:510), Division 변경 뒤로는
   * 사업부 기준(:5226)이다. 두 결과셋은 원본 SQL 이 달라 목록이 서로 다르다.
   * 이번에 쓸 1건만 조회하므로 반대편 원천은 호출되지 않는다.
   */
  const [plantSites] = useTabComboQueries({
    filters: [resolvePlantSiteComboId(plantSiteSource)],
  });

  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });

  /**
   * Biz.Type 도 필터로 통일한다. 종전에는 사업부별로 원천이 갈렸지만(40='DmBizType' 전역 lookup /
   * 그 외='BizTypeByDivision') FilterBizType(#3)이 두 갈래를 UNION 으로 합쳐 내려주고 40 행에는
   * DIVISION_ID='40' 이 박혀 있어 화면에서 한 축으로 좁히면 된다. AS-IS 도 두 분기가 같은
   * BigFilter case 를 부른다 (:5166 · :5188).
   */
  const bizTypeOptions = buildComboOptions(bizType, { division: sc.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 DEPT_ID 가 공란인
  //   행이 대다수라(SITE_ITEM LEFT OUTER JOIN) 관대하게 두면 Team 을 골라도 목록이 그대로다.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: sc.divisionId,
    narrow: { column: 'DEPT_ID', codes: activeDeptIds },
  });

  /**
   * Sales Site 는 Division + End Customer 로 좁히고, Team 변경 경로에서 40 등 사업부일 때만
   * DEPT_ID 가 추가로 걸린다. End Customer 는 고른 값만 쓰고 펼치지 않는다 - 이 화면은
   * dtCustomer 가 끝까지 null 이라 펼치기 경로가 없다. 근거는 utils/sales-plan.searchCombos.
   */
  const endCustomerCodes = resolveEndCustomerCodes(sc.endCustomers, endCustomerOptions);
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: sc.divisionId,
    narrow: [
      {
        column: 'DEPT_ID',
        codes: resolveSalesSiteDeptIds(comboTrigger, sc.divisionId, sc.deptIds),
      },
      { column: 'END_CUSTOMER', codes: endCustomerCodes },
    ],
  });

  /**
   * Plant Site 는 두 원천 모두 Division 으로만 좁힌다. End Customer 는 걸지 않는다.
   *
   * AS-IS 에서 고객 값이 실리는 경로가 없다.
   *   - End Customer 변경(:5124-5133)·Team 변경(:5337~) 핸들러는 Plant Site 를 다시 만들지 않는다.
   *   - 진입(:510)은 GetCheckedListValue(dtCustomer, ...) 인데 dtCustomer 가 :78 에서 null 로
   *     선언만 되고, 그 시점 고객은 전체선택 직후라 'ALL' -> 축 OFF 다.
   *   - Division 변경(:5226)은 원천이 UserPlantSiteByDivision 이라 고객 자리가 아예 없다.
   *
   * 데이터도 같은 결론이다 - FilterPlantSiteByEndCustomer(#6)는 SITE_TYPE='PLANT' 행이라
   * END_CUSTOMER 가 대부분 NULL 이고, 엄격 매칭으로 걸면 목록이 통째로 빈다(2026-08-29 실측).
   * 종전 구현은 진입 상태에서 고객을 고른 경우에만 축이 켜져 목록이 비는 잠재 결함이었다.
   */
  const plantSiteOptions = buildComboOptions(plantSites, { division: sc.divisionId });

  /**
   * 다중선택 조회조건 한 벌.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Division 만 단일선택이다.
   */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
    extra?: { sortBy?: 'label'; disabled?: boolean }
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
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, option) => {
                    set(
                      {
                        divisionId: String(option ?? ''),
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
                      },
                      'division'
                    );
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {/* searchGrid — 칩 다중선택(Team)이 컬럼 min-content 폭을 밀어 옆 필드를 침범하는 것 방지 */}
          <div className={styles.searchGrid}>
            {multiField(
              'LBL00044',
              'Team',
              sc.deptIds,
              teamOptions,
              v =>
                set(
                  {
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
                    sumYn: false,
                  },
                  'team'
                ),
              { sortBy: 'label' }
            )}
          </div>
          {/* 40 사업부는 이 칸의 실제 값이 Project Code 다 - FilterEndCustomerByDivision(#2)의
              40 분기가 PROJECT_CODE 를 CODE 로 쓴다(문서 §4-1). FilterSiteByEndCustomer(#4)의
              40 분기도 END_CUSTOMER 자리에 PROJECT_CODE 를 넣으므로 두 콤보는 맞물린다.
              AS-IS clbCustomer_SelectedIndexChanged (:5124) — 변경 시 하위 Sales Site clear. */}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            v => set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] }, 'endCustomer'),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00011',
            'Sales Site',
            sc.scmSiteIds,
            salesSiteOptions,
            v => set({ scmSiteIds: v }),
            { sortBy: 'label' }
          )}
          {/* Row 2 — Biz Type(40 원천 스왑) / Item Type / Period* / Bucket* (1단 필수 조건 —
              2026-08-12 사용자 지시: 2단 접기/펼치기 표준(DMF0003/0082 파리티) 재배치.
              Plant Site 는 2단(Row 3)으로 이동) */}
          {multiField(
            'LBL00085',
            'Biz. Type',
            sc.bizTypes,
            bizTypeOptions,
            v => set({ bizTypes: v }),
            { sortBy: 'label' }
          )}
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
                    // 변경분 존재 시 Bucket 변경 차단 (AS-IS cboBucketType_Click L5475 MSG00227)
                    if (!validation.validateBucketChange(hasPendingChanges()).ok) return;
                    // Daily 전환만 그리드 초기화 + 헤더를 일자까지 펼친다 (Weekly/Monthly 는 종전대로).
                    //   setSearchCondition 이 아니라 전용 액션 — 조건과 filters 를 한 번에 바꿔야
                    //   조건만 바뀌고 화면은 이전 버킷으로 남는 중간 상태가 생기지 않는다.
                    setBucketType(option as BUCKET_TYPE);
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
          {/* Plant Site — 40 만 비활성이다 (AS-IS :5178 vs :5200. 82 는 활성).
              원천은 진입/Division 변경으로 갈린다 - 위 plantSiteOptions 주석 참조. */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            v => set({ plantSiteIds: v }),
            { sortBy: 'label', disabled: div40 }
          )}
          {/* Row 4 (2단) — Owner🔍 / Sum 체크박스 */}
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
          <Grid size={9}>
            <FormItem
              label={t('LBL00687', '_Sum')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox checked={sc.sumYn} onChange={checked => set({ sumYn: checked })} />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
