import { SearchArea } from '@shared/components';
import { Grid } from '@shared/mui';

import {
  BizTypeField,
  BucketField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PeriodField,
  PlantSiteField,
  ProjectField,
  SalesSiteField,
  SearchOverRangeField,
  TeamField,
  VersionField,
} from '../../../components';
import { useSalesFuturePriceValidation } from '../hooks/useSalesFuturePriceValidation';
import { BUCKET_TYPE } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';
import { thisWeekMonday, yyyymmddOf } from '../utils/futurePriceDate';

interface Props {
  onSearch: () => void;
  onVersionOpen: () => void;
  // AS-IS MSG00227 — 신규 입력('I') 행 존재 시 Bucket 변경 차단용.
  hasInsertRows?: boolean;
}

// AS-IS 캡쳐 (Doc/ui_cap/DMF0020_init.png) 1:1 layout + 사용자 사이즈 요구.
//
// ⭐ 2026-06-03 표준 카탈로그 (`@master/searchFields`) 사용 (사용자 명시 요구):
//   "조회조건의 경우에는 항목별로 rule 로 관리. 사이즈, 데이터 추출경로 등록.
//    화면별로 다 달라지는게 아니고 이전에 사용된 조회항목은 따로 요청하지 않아도 제대로 나와야"
//
//   카탈로그가 자동 적용: Grid size / FormItem / i18n LBL / combo 키 / popup modal /
//                         preSearchParams 6필드 'ALL' default / required.
//
// Layout (12 column):
//   Row 1: Div(4)        + Team(4)        + End Customer(4)
//   Row 2: Biz.Type(4)   + Period(8)
//   Row 3: Sales Site(4) + Project(4)     + Plant Site(4)
//   Row 4: Model/Nick(4) + Owner(4)       + Bucket(2) + SearchRange(2)
//   Row 5: Version(6)
export const SalesFuturePriceForm = ({ onSearch, onVersionOpen, hasInsertRows }: Props) => {
  const { t } = useTranslation();
  const validate = useSalesFuturePriceValidation();

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const set = useSalesFuturePriceStore(s => s.setSearchCondition);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // ⭐ 조회조건 순서 (2026-07-01 사용자 요구, gridSize={3} = 4개/단):
      //    1단(항상): Div / Team / End Customer / Biz.Type
      //    2단(항상): Sales Site / Project / Plant Site / Period
      //    3단(펼침): Model·Nickname / Owner / Bucket / Version
      //    4단(펼침): Search Over Range
      //    ⚠ Project 는 Division='40' 일 때 숨김 → 4개/단 유지 위해 빈 Grid 슬롯으로 대체.
      conditions={
        <>
          {/* 1단 */}
          {/* Division 변경 시 종속 필드 reset (AS-IS clbDivisions_SelectedIndexChanged) — 사용자 조작 시에만.
              복원/persist 로 divisionId 가 바뀔 때 복원값이 wipe 되지 않도록 useEffect 대신 onChange 에서 처리. */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={v =>
              set({
                divisionId: v,
                deptIds: [],
                endCustomers: [],
                scmSiteIds: [],
                plantSiteIds: [],
                bizTypes: [],
                projectCodes: [],
                itemIds: [],
                owners: [],
                bucketType: BUCKET_TYPE.WEEKLY,
                versionId: 'CURRENT',
                searchOverRange: true,
              })
            }
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
                bucketType: BUCKET_TYPE.WEEKLY,
                versionId: 'CURRENT',
                searchOverRange: true,
              })
            }
            division={sc.divisionId}
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다.
              변경 시 하위(Sales Site / Plant Site) 선택은 초기화한다 — 안 지우면 옵션에서
                사라진 값이 조회조건에 남아 서버로 나간다. */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: sc.deptIds, strict: true } }}
            debugLabel='DMF0020 sales-future-price / End Customer'
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] })}
          />
          <BizTypeField gridSize={3} value={sc.bizTypes} onChange={v => set({ bizTypes: v })} />

          {/* 2단 */}
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0014 / DMF0044 와 동일한 매핑이다.
              DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                존재해 자르면 목록이 통째로 비어버린다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              DEPT_ID: { values: sc.deptIds, strict: true },
              PROJECT_CODE: sc.endCustomers,
            }}
            debugLabel='DMF0020 sales-future-price / Sales Site'
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
          />
          {sc.divisionId !== '40' ? (
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
            />
          ) : (
            // Division='40' → Project 숨김. 4개/단 레이아웃 유지 위한 빈 슬롯 (사용자 명시 2026-06-27).
            <Grid size={3} />
          )}
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
          />
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
        </>
      }
      // 확장영역(펼치기) — 3단(Model/Owner/Bucket/Version) + 4단(Search Over Range).
      extraConditions={
        <>
          {/* 3단 */}
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
          <BucketField
            gridSize={3}
            value={sc.bucketType}
            onChange={v => {
              // AS-IS MSG00227 — 신규 입력('I') 행이 있을 때 Bucket 변경 차단 (동적 컬럼 재구성 방지).
              if (hasInsertRows && !validate.validateBucketChange('I').ok) return;
              set({ bucketType: v === 'M' ? BUCKET_TYPE.MONTHLY : BUCKET_TYPE.WEEKLY });
            }}
          />
          <VersionField gridSize={3} value={sc.versionId} onOpenPopup={onVersionOpen} />

          {/* 4단 */}
          <SearchOverRangeField
            gridSize={3}
            value={sc.searchOverRange}
            onChange={v => {
              // AS-IS usrDiscard_CheckedChanged — 체크 시 조회기간을 당주 월요일 ~ +52주로 자동 세팅.
              if (v) {
                const start = thisWeekMonday();
                const end = new Date(start);
                end.setDate(start.getDate() + 52 * 7);
                set({
                  searchOverRange: v,
                  startYyyymmdd: yyyymmddOf(start),
                  endYyyymmdd: yyyymmddOf(end),
                });
              } else {
                set({ searchOverRange: v });
              }
            }}
          />
        </>
      }
    />
  );
};
