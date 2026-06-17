import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { SearchArea } from '@shared/components';
import { useSessionStore } from '@shared/stores';

import {
  BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField,
  OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField,
  SearchOverRangeField, TeamField, VersionField,
} from '../../../components';
import { BUCKET_TYPE } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';

interface Props {
  onSearch: () => void;
  onVersionOpen: () => void;
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
export const SalesFuturePriceForm = ({ onSearch, onVersionOpen }: Props) => {
  const { t } = useTranslation();

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const set = useSalesFuturePriceStore(s => s.setSearchCondition);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);
  const userId = useSessionStore(state => state.session.userId);

  useEffect(() => { set({ userId } as never); }, [userId]);

  // Division 변경 시 종속 reset (AS-IS clbDivisions_SelectedIndexChanged)
  useEffect(() => {
    set({ deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [], bizTypes: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — 기본 1단 (Division / Team / End Customer) */}
          <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v })} />
          <TeamField value={sc.deptIds} onChange={v => set({ deptIds: v })} division={sc.divisionId} />
          <EndCustomerField value={sc.endCustomers} onChange={v => set({ endCustomers: v })} division={sc.divisionId} />

          {/* Row 2 — 기본 2단 (Biz Type / Period) */}
          <BizTypeField value={sc.bizTypes} onChange={v => set({ bizTypes: v })} />
          <PeriodField
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
        </>
      }
      // ⭐ 2026-06-16 — 2단 초과 영역은 extraConditions 로 분리.
      //   SearchArea 가 Search 버튼 우측에 아래 화살표 표시 → 클릭 시 확대/축소 (DMF0006 sample 패턴)
      extraConditions={
        <>
          {/* Row 3 — Sales Site / Project / Plant Site */}
          <SalesSiteField value={sc.scmSiteIds} onChange={v => set({ scmSiteIds: v })} division={sc.divisionId} />
          <ProjectField
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
          />
          <PlantSiteField value={sc.plantSiteIds} onChange={v => set({ plantSiteIds: v })} division={sc.divisionId} />

          {/* Row 4 — Item / Owner / Bucket / SearchOverRange */}
          <ItemField
            value={sc.itemIds}
            onChange={v => set({ itemIds: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            itemIds={sc.itemIds}
          />
          <OwnerField
            value={sc.owners}
            onChange={v => set({ owners: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            owners={sc.owners}
          />
          <BucketField
            value={sc.bucketType}
            onChange={v => set({ bucketType: v === 'M' ? BUCKET_TYPE.MONTHLY : BUCKET_TYPE.WEEKLY })}
          />
          <SearchOverRangeField value={sc.searchOverRange} onChange={v => set({ searchOverRange: v })} />

          {/* Row 5 — Version */}
          <VersionField value={sc.versionId} onOpenPopup={onVersionOpen} />
        </>
      }
    />
  );
};
