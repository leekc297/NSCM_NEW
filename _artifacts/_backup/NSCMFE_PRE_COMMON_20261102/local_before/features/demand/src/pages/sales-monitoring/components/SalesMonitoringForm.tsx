import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  buildComboOptions,
  toSelectedCodes,
} from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE } from '../sales-monitoring.constants';
import { useSalesMonitoringStore } from '../useSalesMonitoringStore';
import { isDiv40, isPlantSiteDisabled } from '../utils/sales-monitoring.combos';

interface SalesMonitoringFormProps {
  onSearch: () => void;
}

// AS-IS DMF0048_SalesMonitoring 조회조건 (화면 설계 1:1):
//   Row1: Div* / Team / End Customer / Sales Site
//   Row2: Period* / Bucket* / 체크박스(Sum·Color·Include Internal Txn) / Search(F5)
//   확장 : Item Type / Biz. Type / PJT🔍 / Model·Nickname🔍 + Plant Site / Owner🔍 / Sum 체크
//   TO-BE 배치: conditions 는 한 줄 4칸 x 2단(8칸)까지라 표시 옵션 체크박스(Sum)는
//   extraConditions 끝에 둔다(Doc/new_rules/screen/search-combo.md SRCH 8칸 기준). Color 체크박스는
//   화면에서 제거됐고(그리드가 무조건 그린다), Include Internal Txn 은 아직 조회조건에 없다.
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 모든 객체 36px. DatePicker = .datePickerFix wrapper.
//   콤보 = 사내 CMBO 레지스트리 등록명 (mkt-fcst 검증 완료 ID 재사용 — 임의 발명 금지).
//   (통화 콤보 KRW/USD/LOC 제외 — AS-IS 데드코드, 사용자 확정 2026-07-04)
// 2026-08-22 콤보 통일 — Div / Team / End Customer / Sales Site 는 인라인 CustomDropdown 을
//   걷어내고 카탈로그 필드(@master/searchFields)로 옮겼다. 콤보 ID 는 종전과 같고
//   (MyDivision / TeambyDivision / EndCustomer / SalesSite), 파라미터 quoting 과 cascade 규칙은
//   카탈로그가 단일 진실원으로 관리한다.

export const SalesMonitoringForm = ({ onSearch }: SalesMonitoringFormProps) => {
  const { t } = useTranslation();

  const sc = useSalesMonitoringStore(s => s.searchCondition);
  const set = useSalesMonitoringStore(s => s.setSearchCondition);
  const openSearchArea = useSalesMonitoringStore(s => s.openSearchArea);
  const plantSiteSource = useSalesMonitoringStore(s => s.plantSiteSource);

  /**
   * 조회조건 콤보 (Doc/Combo/DMF0048_콤보구성.md §1).
   *
   *   Filter 콤보                     목록 구성 조건            AS-IS 근거
   *   FilterMyDivision                없음                      InitControls :323
   *   FilterTeambyDivision            Division                  :331 / :1848
   *   FilterEndCustomerByDivision     Division + Team           :349·:369 / :1866·:1887 / :2034·:2048
   *   FilterBizType                   Division                  :343·:363 / :1860·:1881
   *   FilterSiteByEndCustomer         Division + End Customer   :392 / :1824 / :1910 / :2041·:2056
   *   FilterPlantSiteByEndCustomer    Division + End Customer   :398  (진입)
   *   FilterFromSiteByDivision        Division                  :1916 (Division 변경)
   *
   * 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다 - 규칙은
   * features/master/src/components/searchFields/bigFilterCombo 참조.
   *
   * Item Type 과 Bucket 은 재조회다. 현행 콤보 ID 를 그대로 쓴다(사용자 확정).
   */
  const [divisions, teams, endCustomers, salesSites, itemType] = useTabComboQueries({
    filters: [
      'FilterMyDivision',
      'FilterTeambyDivision',
      'FilterEndCustomerByDivision',
      'FilterSiteByEndCustomer',
      'ItemType',
    ],
  });

  // Biz.Type 도 필터로 통일한다. 종전에는 division 별로 원천이 갈렸지만(40='BizType' 전역 lookup /
  //   그 외='BizTypeByDivision') FilterBizType(#3)이 두 갈래를 UNION 으로 합쳐 내려주고
  //   DIVISION_ID 로 구분되므로 화면에서 한 축으로 좁히면 된다.
  const [bizType] = useTabComboQueries({ filters: ['FilterBizType'] });

  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });
  const bizTypeOptions = buildComboOptions(bizType, { division: sc.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 공란 행이 많아
  //   관대하게 두면 Team 을 골라도 목록이 그대로다.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: sc.divisionId,
    narrow: { column: 'DEPT_ID', codes: sc.deptIds },
  });

  /**
   * Sales Site 는 팀을 걸지 않는다 - AS-IS 가 :392 · :1824 · :1910 · :2041 에서 팀 자리를 비운다.
   * (:2056 만 40 사업부 Team 변경 경로에서 팀을 넘기는데, 같은 콤보가 무엇을 바꿨느냐에 따라
   *  달라지는 AS-IS 결함이라 문서 §3-3 이 확인 대상으로 지목했다. 여기서는 한 규칙으로 둔다.)
   *
   * 대신 End Customer 미선택은 그 시점 End Customer 목록 전체로 펼친다 - AS-IS
   * CString.GetCheckedListValue 재현이며, 위 목록이 이미 Division + Team 으로 좁혀져 있으므로
   * 이 경로로 Team 이 Sales Site 까지 반영된다.
   */
  const selectedEndCustomers = toSelectedCodes(sc.endCustomers);
  const endCustomerCodes =
    selectedEndCustomers.length > 0
      ? selectedEndCustomers
      : endCustomerOptions.map(option => option.value);
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: sc.divisionId,
    narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
  });

  /**
   * Plant Site 는 경로마다 원천이 다르다 (문서 §3-2).
   *
   *   진입          FilterPlantSiteByEndCustomer  Division + End Customer  :398
   *   Division 변경  FilterFromSiteByDivision      Division                 :1916
   *
   * 두 결과셋은 원본 SQL 이 달라 조작 순서에 따라 목록이 달라진다 - AS-IS 동작 그대로다.
   * FilterFromSiteByDivision(#5)은 END_CUSTOMER 컬럼이 없어 Division 으로만 좁힌다.
   *
   * 이번에 쓸 1건만 조회하므로 반대편 원천은 호출되지 않는다.
   */
  const byDivisionSource = plantSiteSource === 'division';
  const [plantSites] = useTabComboQueries({
    filters: [byDivisionSource ? 'FilterFromSiteByDivision' : 'FilterPlantSiteByEndCustomer'],
  });
  const plantSiteOptions = byDivisionSource
    ? buildComboOptions(plantSites, { division: sc.divisionId })
    : buildComboOptions(plantSites, {
        division: sc.divisionId,
        narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
      });

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

  // AS-IS L338/1855 — Division '40' 은 Project 비활성.
  const div40 = isDiv40(sc.divisionId);

  // Bucket — AS-IS DMF0003_GET_BUCKET_TYPE_CODE 실측 (CODE=DAILY/WEEKLY/MONTHLY, 2026-07-04 스모크)
  const bucketOptions = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];

  // 멀티 select dropdown 값 (콤마 delim string[] ↔ 단일 string). 단일선택 + ALL 패턴 (mkt-fcst 동일)
  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);
  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Div* / Team / End Customer / Sales Site (화면 설계 Row1 1:1) */}
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
                  onChange={(_, option) =>
                    // AS-IS clbDivision_SelectedIndexChanged(SetChangeControl) — 하위 조건 cascade clear
                    set(
                      {
                        divisionId: String(option ?? ''),
                        deptIds: [],
                        endCustomers: [],
                        scmSiteIds: [],
                        bizTypes: [],
                        plantSiteIds: [],
                        itemTypes: [],
                        projectCodes: [],
                        itemIds: [],
                        owners: [],
                        bucketType: BUCKET_TYPE.MONTHLY,
                        sumYn: false,
                        colorYn: false,
                        internalYn: false,
                      },
                      'division'
                    )
                  }
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
              // AS-IS clbTeam_SelectedIndexChanged — 하위(End Customer/Sales Site) cascade clear
              set({
                deptIds,
                endCustomers: [],
                scmSiteIds: [],
                bizTypes: [],
                plantSiteIds: [],
                itemTypes: [],
                projectCodes: [],
                itemIds: [],
                owners: [],
                bucketType: BUCKET_TYPE.MONTHLY,
                sumYn: false,
                colorYn: false,
                internalYn: false,
              }),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site/Plant Site) cascade clear
            endCustomers => set({ endCustomers, scmSiteIds: [], plantSiteIds: [] }),
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

          {/* Row 2 — Period* / Bucket* / 체크박스 3종 (화면 설계 Row2 1:1 — Search 버튼은 SearchArea 자체) */}
          {/* 공용 카탈로그 PeriodField(@master/searchFields) — SalesPrice 등 타 화면과 동일 DateRange. */}
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
                  onChange={(_, option) => set({ bucketType: option as BUCKET_TYPE })}
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
                  limitTags={1}
                  allOption
                  useClearIcon
                  value={firstOr(sc.itemTypes)}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => set({ itemTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Biz. Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  limitTags={1}
                  allOption
                  useClearIcon
                  sortBy='label'
                  value={firstOr(sc.bizTypes)}
                  options={bizTypeOptions}
                  onChange={(_, option) => set({ bizTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 확장 Row PJT🔍 / Model·Nickname🔍 (화면 설계 확장영역 1:1) */}
          {/* PJT / Model·Nickname — 조회조건 표준 카탈로그(@master/searchFields) + 체크박스 멀티선택 popup
              (AS-IS txtProject+btnProject / txtItemId+btnItemId 1:1 — popup 은 카탈로그 필드 자체 관리) */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            multiCheckbox
            disabled={div40} // AS-IS: Division 40 → Project 비활성
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

          {/* 확장 Row 4 — Plant Site / Owner🔍 (AS-IS clbPlantSite / txtOwner+btnOwner 1:1) */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            plantSiteIds => set({ plantSiteIds }),
            { sortBy: 'label', disabled: isPlantSiteDisabled(sc.divisionId) }
          )}
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

          {/* Sum — 상위 합계 칸 표시 토글 (AS-IS chkSum_CheckedChanged L1587 → SetSpreadColumn).
              Weekly 조회 시 월(M_) 합계 칸, Daily 조회 시 주(W_)·월(M_) 합계 칸을 함께 보인다.
              기본 해제(AS-IS InitControls L283 chkSum.Checked=false — Designer 초기값 true 를 덮는다).
              재조회 없이 즉시 반영된다 — 그리드 applyDynVisibility 가 sumYn 을 보고 visible 만 바꾼다. */}
          {/* 아래줄 첫 칸(Project 바로 밑). Sales Plan 과 같은 형태 — "Sum" 라벨은 FormItem 라벨 칸에
              두어 윗줄 Project 라벨과 세로로 맞추고, 체크 상자는 입력 칸에 둔다(사용자 확정 2026-10-06).
              라벨 없는 customGrid 칸으로 두면 체크 상자가 칸 왼쪽 끝에 붙어 다른 조건들과 열이 어긋난다. */}
          <Grid size={3}>
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
