import { SearchArea } from '@shared/components';

import {
  BucketField,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  SearchOverRangeField,
  useCascadeFields,
  VersionField,
} from '../../../components';
import { useSalesFuturePriceValidation } from '../hooks/useSalesFuturePriceValidation';
import {
  BIZ_TYPE_CASCADE_COMBO_ID,
  BUCKET_TYPE,
  DIVISION,
  PLANT_SITE_CASCADE_COMBO_ID,
  SEARCH_CASCADE_COMBO_ID,
} from '../sales-future-price.constants';
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
// 조회조건 순서 (2026-07-01 사용자 요구, gridSize={3} = 4개/단):
//   1단(항상): Div / Team / End Customer / Biz.Type
//   2단(항상): Sales Site / Project / Plant Site / Period
//   3단(펼침): Model·Nickname / Owner / Bucket / Version
//   4단(펼침): Search Over Range
//   주의: Project 는 Division='40' 일 때 비활성(칸은 유지) — 4개/단 레이아웃은 그대로다.
//
// 콤보 조회 방식은 MktFcst(DMF0003)와 같게 맞췄다 (2026-08-24). 단계마다 콤보를 따로 조회하고
// 클라이언트에서 서로 필터링하던 카탈로그(DivisionField / TeamField / EndCustomerField /
// SalesSiteField / PlantSiteField / BizTypeField) 대신, 조인 콤보 1건을 읽는 cascade 를 쓴다.
//   - 한 SQL 결과라 모든 행에 모든 단계 컬럼이 차 있어 strict / 관대 분기가 없어진다
//     (종전 EndCustomer 콤보의 DEPT_ID 공란 행 문제, Sales Site 콤보의 End Customer 를
//      PROJECT_CODE 자리로 읽던 매핑이 모두 사라진다).
//   - 하위 단계 값 초기화는 cascade 가 하고, 화면 고유 조회조건 초기화만 onChange 에서 얹는다.
// prop 설명과 콤보 SQL 규약은 CascadeFields.tsx 파일 헤더 참조.
export const SalesFuturePriceForm = ({ onSearch, onVersionOpen, hasInsertRows }: Props) => {
  const { t } = useTranslation();
  const validate = useSalesFuturePriceValidation();

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const set = useSalesFuturePriceStore(s => s.setSearchCondition);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);

  // Div - Team - End Customer - Sales Site. Biz.Type 이 End Customer 와 Sales Site 사이에 끼어
  // 배치가 찢어지므로 컴포넌트가 아니라 훅으로 받아 필요한 자리에 하나씩 꽂는다.
  // cascade 계산은 levels 배열 순서를 따르고 렌더 위치와 무관하다.
  //
  // Division / Team 변경 시 종속 필드 reset 은 AS-IS clbDivisions_SelectedIndexChanged 정합이다.
  // 복원/persist 로 divisionId 가 바뀔 때 복원값이 wipe 되지 않도록 useEffect 가 아니라 여기서
  // 처리한다 — 사용자 조작일 때만 불린다.
  const cascade = useCascadeFields({
    comboId: SEARCH_CASCADE_COMBO_ID,
    gridSize: 3,
    // field 는 스토어 필드명 — value 로 넘긴 sc 의 키와 대조돼 오타가 컴파일에서 잡힌다.
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team', field: 'deptIds', sortBy: 'label' },
      { key: 'endCustomer', field: 'endCustomers', sortBy: 'label' },
      { key: 'salesSite', field: 'scmSiteIds', sortBy: 'label' },
    ],
    value: sc,
    onChange: (next, changed) => {
      if (changed === 'division' || changed === 'team') {
        // 하위 단계(Team / End Customer / Sales Site) 초기화는 next 에 이미 들어 있다.
        // 별개 콤보인 Plant Site / Biz.Type 과 popup 계열은 여기서 직접 비운다.
        set({
          ...next,
          plantSiteIds: [],
          bizTypes: [],
          projectCodes: [],
          itemIds: [],
          owners: [],
          bucketType: BUCKET_TYPE.WEEKLY,
          versionId: 'Current',
          // Search over range 는 기본값 unchecked — division/team 변경 시 함께 해제한다
          //   (사용자 요구 2026-08-25). 종전 true 는 division 만 바꿔도 조회기간이 52주로
          //   자동 확장된 것처럼 보이게 했다.
          searchOverRange: false,
        });
        return;
      }
      // Plant Site 는 별개 콤보(plantSiteCascade)라 이 cascade 가 하위로 안 비운다.
      // End Customer 가 바뀌면 여기서 직접 비운다 — 안 지우면 옵션에서 사라진 값이
      // 조회조건에 남아 서버로 나간다.
      if (changed === 'endCustomer') {
        set({ ...next, plantSiteIds: [] });
        return;
      }
      set(next);
    },
  });

  // Biz.Type 은 Division 에서 갈라지는 별개 가지다. 2단(Div - Biz Type)이라 단계는 짧지만
  // 구조는 아래 Plant Site 와 같다 — division 은 필터로만 쓰고 마지막 단계만 렌더한다.
  // 주의: 종전 이 화면의 BizTypeField 는 전역 lookup('BizType')을 Division 구분 없이 그대로
  // 보여줬다. 이 콤보로 바꾸면 Division 에 해당하는 Biz Type 만 나온다 (MktFcst 와 같은 동작).
  const bizTypeCascade = useCascadeFields({
    comboId: BIZ_TYPE_CASCADE_COMBO_ID,
    gridSize: 3,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'bizType', field: 'bizTypes' },
    ],
    value: sc,
    onChange: next => set(next),
  });

  // Plant Site 도 Sales Site 의 하위가 아니라 Div - Team - End Customer 에서 갈라지는 별개
  // 가지다. 콤보도 따로 등록돼 있고(4단 조인 형태는 같다) 상위 3단 값만 공유한다.
  //   - 상위 3단은 필터로만 쓰고 렌더하지 않는다. 화면에는 마지막 단계만 꽂는다.
  //   - 활성 기준은 81 계열 전용 — 종전 PlantSiteField 기본 게이트와 같다
  //     (이 화면 상수는 DIVISION.ESS = '81' 이다 - MktFcst 쪽 명칭과 다르니 값 기준으로 본다).
  const plantSiteEnabled = sc.divisionId.startsWith(DIVISION.ESS);
  const plantSiteCascade = useCascadeFields({
    comboId: PLANT_SITE_CASCADE_COMBO_ID,
    gridSize: 3,
    enabled: plantSiteEnabled,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team', field: 'deptIds' },
      { key: 'endCustomer', field: 'endCustomers' },
      { key: 'plantSite', field: 'plantSiteIds', disabled: !plantSiteEnabled, sortBy: 'label' },
    ],
    value: sc,
    onChange: next => set(next),
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 */}
          {cascade.field('division')}
          {cascade.field('team')}
          {cascade.field('endCustomer')}
          {bizTypeCascade.field('bizType')}

          {/* 2단 */}
          {cascade.field('salesSite')}
          {/* Project — Division='40' 도 칸은 그대로 두고 비활성만 한다 (사용자 요구 2026-08-26).
              40 은 프로젝트 역할을 END_CUSTOMER40 이 대신해 조회 키로 쓰지 않지만, 숨기면 division 을
              오갈 때 조회조건 자리가 통째로 바뀌어 다른 화면처럼 보인다. Plant Site 의 비활성 처리와 같은 방식.
              종전에는 빈 Grid 슬롯으로 대체했다. */}
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
            disabled={sc.divisionId === DIVISION.MOBILITY}
          />
          {plantSiteCascade.field('plantSite')}
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
