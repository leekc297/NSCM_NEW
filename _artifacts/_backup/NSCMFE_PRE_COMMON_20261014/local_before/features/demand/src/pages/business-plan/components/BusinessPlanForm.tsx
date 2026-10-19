import {
  BizTypeField,
  buildComboOptions,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
} from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../business-plan.constants';
import { useBusinessPlanStore } from '../useBusinessPlanStore';
import { isDiv40 } from '../utils/business-plan.division';
import {
  buildEndCustomerComboParam,
  buildPlantSiteComboParam,
  buildSalesSiteComboParam,
} from '../utils/business-plan.searchCombos';
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
  const comboTrigger = useBusinessPlanStore(s => s.comboTrigger);

  // 인라인 콤보 원천 (SCM_ADM_CMBO_SQL_M 등록명 — 2026-07-15 실측):
  //   Item Type    = 'ItemType' (ITEM_TYPE_CODE)
  //   Bucket       = 'BucketType2' (BUCKET2_TYPE_CODE — MONTHLY/QUARTERLY/YEARLY. P5 신설)
  // 카탈로그 필드가 직접 조회하는 조회조건 (2026-08-22 콤보 통일):
  //   Div / Team / End Customer / Sales Site / Plant Site =
  //     MyDivision / TeambyDivision / EndCustomer / SalesSite / PlantSitebyEndCustomer.
  //     'PlantSitebyEndCustomer' 는 SQL 개정으로 파라미터를 받지 않고 전량을 내려준다
  //     — cascade 는 클라이언트(카탈로그)에서 건다.
  //     종전 40 전용 'EndCustomerByDivision40' 스왑은 폐지했다.
  //   Biz Type = BizTypeField — 40 은 전역 lookup 'BizType', 그 외는 'BizTypebyDivision'.
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
  /**
   * Division 과 Team 은 필터 방식이다 (사용자 확정) - Filter 접두 콤보를 파라미터 없이 받고
   * 좁히는 일은 화면이 한다. 규칙은 features/master/src/components/searchFields/bigFilterCombo 참조.
   * 문서(§0)상 이 화면 AS-IS 는 BigFilter 미적용이지만 두 콤보는 전 화면 공통으로 필터를 쓴다.
   */
  const [divisions, teams, itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['FilterMyDivision', 'FilterTeambyDivision', 'ItemType', 'BucketType2'],
  });
  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });

  /**
   * End Customer / Sales Site / Plant Site 는 재조회다 (문서 §0·§1). 조회조건을 파라미터로
   * 실으므로 값이 바뀌면 SQL 이 다시 나간다. 원천 선택 규칙과 AS-IS 근거는
   * utils/business-plan.searchCombos 참조. 이번에 부를 1건씩만 조립하므로 반대편은 호출되지 않는다.
   */
  const [endCustomers, plantSites] = useTabComboQueries({
    filters: [
      buildEndCustomerComboParam({ divisionId: sc.divisionId, deptIds: activeDeptIds }),
      buildPlantSiteComboParam({ divisionId: sc.divisionId }),
    ],
  });

  // 재조회 응답은 서버가 이미 좁혀 CODE / NAME 만 내려준다 - 축을 걸면 전 행이 잘린다.
  const endCustomerOptions = buildComboOptions(endCustomers);
  const plantSiteOptions = buildComboOptions(plantSites);

  /**
   * Sales Site 는 End Customer 를 파라미터로 받는다. 선택된 값만 넘기고, 미선택(ALL)은
   * buildSalesSiteComboParam 안에서 'ALL' 센티널로 보낸다 - 등록 SQL 이 @endCustomer='ALL' 을
   * 직접 처리한다. 종전에는 미선택을 End Customer 목록 전체로 펼쳐 넘겼으나(AS-IS
   * GetCheckedListValue 재현), 그 값이 4000byte 를 넘겨 ORA-01704 로 실패해 'ALL' 방식으로 바꿨다.
   */
  const [salesSites] = useTabComboQueries({
    filters: [
      buildSalesSiteComboParam(comboTrigger, {
        divisionId: sc.divisionId,
        deptIds: activeDeptIds,
        endCustomers: sc.endCustomers,
      }),
    ],
  });
  const salesSiteOptions = buildComboOptions(salesSites);

  /**
   * 다중선택 조회조건 한 벌.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Team 도 예외가 아니다.
   * Division 만 단일선택이다. */
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
                  onChange={(_, picked) => {
                    set(
                      {
                        divisionId: String(picked ?? ''),
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
                        // 2026-08-20 교정 — AS-IS Designer.cs 실측(chkSum=true / cboQty 미지정=false)
                        sumYn: true,
                        qtyYn: false,
                      },
                      'division'
                    );
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            sc.deptIds,
            teamOptions,
            deptIds =>
              set(
                {
                  deptIds,
                  endCustomers: [],
                  scmSiteIds: [],
                  plantSiteIds: [],
                  bizTypes: [],
                  projectCodes: [],
                  itemIds: [],
                  owners: [],
                  itemTypes: [],
                  bucketType: BUCKET_TYPE.MONTHLY,
                  // 2026-08-20 교정 — 위 Division 변경 reset 과 같은 값
                  sumYn: true,
                  qtyYn: false,
                },
                'team'
              ),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            // AS-IS clbCustomer_SelectedIndexChanged (L1535) — 하위 Sales Site clear
            endCustomers => set({ endCustomers, scmSiteIds: [], plantSiteIds: [] }, 'endCustomer'),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00011',
            'Sales Site',
            sc.scmSiteIds,
            salesSiteOptions,
            scmSiteIds => set({ scmSiteIds }),
            {
              sortBy: 'label',
            }
          )}

          {/* Row 2 — Plant Site(40 비활성) / Biz Type(40 원천 스왑) / Period* / Bucket*(기본 Monthly — M/Q/Y) */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            plantSiteIds => set({ plantSiteIds }),
            // 40 만 비활성. 81 계열·82 는 활성이다 (AS-IS InitControls L259~261).
            { sortBy: 'label', disabled: div40 }
          )}
          <BizTypeField
            gridSize={3}
            value={sc.bizTypes}
            onChange={v => set({ bizTypes: v })}
            // AS-IS 40 은 전역 lookup(DM_BIZ_TYPE), 그 외는 division 기준 (문서 §1).
            //   40 에는 division 을 넘기지 않는다 - 전역 목록이라 걸 컬럼이 없다.
            comboId={div40 ? 'BizType' : 'BizTypebyDivision'}
            division={div40 ? undefined : sc.divisionId}
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
          {multiField(
            'LBL00068',
            '_Item Type',
            sc.itemTypes,
            itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [],
            itemTypes => set({ itemTypes }),
            { sortBy: 'label' }
          )}

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
