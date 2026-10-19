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

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE } from '../sales-monitoring.constants';
import { useSalesMonitoringStore } from '../useSalesMonitoringStore';
import {
  bizTypeComboFilterOf,
  isDiv40,
  isPlantSiteDisabled,
} from '../utils/sales-monitoring.combos';

interface SalesMonitoringFormProps {
  onSearch: () => void;
}

// AS-IS DMF0048_SalesMonitoring 조회조건 (Figma Doc/_figma/DMF0048/DMF0048.png 1:1):
//   Row1: Div* / Team / End Customer / Sales Site
//   Row2: Period* / Bucket* / 체크박스(Sum·Color·Include Internal Txn) / Search(F5)
//   확장 : Item Type / Biz. Type / PJT🔍 / Model·Nickname🔍 + Plant Site / Owner🔍
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

  // 조회조건 콤보 — 사내 SCM_ADM_CMBO_SQL_M 등록명.
  //   Div / Team / End Customer / Sales Site 는 SearchFields 카탈로그 필드가 각자 조회한다
  //   (콤보 통일 — MyDivision / TeambyDivision / EndCustomer / SalesSite).
  //   react-query 키가 같아 캐시를 공유하므로 네트워크 호출은 늘지 않는다.
  //   Biz Type 은 division 별로 콤보 원천 자체가 다르다 — 40='BizType'(전역 lookup) / 그 외='BizTypeByDivision'.
  //     bizTypeComboFilterOf 가 단일 진실원 (AS-IS InitControls L338 분기 1:1).
  //     아래 클라이언트 DIVISION_ID 필터는 안전망으로 그대로 유지 (콤보 SQL 이 @divisionId 미사용이어도 회귀 0).
  const [bizType, itemType] = useTabComboQueries({
    filters: [bizTypeComboFilterOf(sc.divisionId), 'ItemType'],
  });

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
          {/* Row 1 — Div* / Team / End Customer / Sales Site (Figma Row1 1:1) */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={option =>
              // AS-IS clbDivision_SelectedIndexChanged(SetChangeControl) — 하위 조건 cascade clear
              set({
                divisionId: option,
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
              })
            }
          />
          <TeamField
            gridSize={3}
            division={sc.divisionId}
            value={sc.deptIds}
            onChange={v =>
              // AS-IS clbTeam_SelectedIndexChanged — 하위(End Customer/Sales Site) cascade clear
              set({
                deptIds: v,
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
              })
            }
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다. 종전 인라인 필터는
                관대(`!item.DEPT_ID ||`)라 Team 이 목록을 못 좁혔다 — 통일 규칙대로 엄격으로 바꿈. */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: sc.deptIds, strict: true } }}
            debugLabel='DMF0048 sales-monitoring / End Customer'
            value={sc.endCustomers}
            onChange={v =>
              // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site/Plant Site) cascade clear
              set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] })
            }
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0003 / DMF0014 와 동일한 매핑이다.
              DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                존재해 자르면 목록이 통째로 비어버린다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              DEPT_ID: { values: sc.deptIds, strict: true },
              PROJECT_CODE: sc.endCustomers,
            }}
            debugLabel='DMF0048 sales-monitoring / Sales Site'
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
          />

          {/* Row 2 — Period* / Bucket* / 체크박스 3종 (Figma Row2 1:1 — Search 버튼은 SearchArea 자체) */}
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
                  value={firstOr(sc.bizTypes)}
                  options={
                    bizType
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ bizTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 확장 Row PJT🔍 / Model·Nickname🔍 (Figma 확장영역 1:1) */}
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
          {/* Plant Site — 카탈로그 기본 콤보 'PlantSitebyEndCustomer' (2026-08-22 콤보 통일).
              활성 기준만 AS-IS 대로 40 만 비활성 (카탈로그 기본 게이트 81 전용을 덮어쓴다). */}
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
            disabled={isPlantSiteDisabled(sc.divisionId)}
            debugLabel='DMF0048 sales-monitoring / Plant Site'
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
        </>
      }
    />
  );
};
