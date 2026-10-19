import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  COMBO,
  LBL,
  LOOKUP,
  OPERATION_GROUP_WARRANTY_CODE,
  OPERATION_GROUP_WARRANTY_NAME,
} from '../shipment-model-pic.constants';
import { useShipmentModelPicStore } from '../useShipmentModelPicStore';

interface Option {
  label: string;
  value: string;
}

interface Props {
  // SEARCH 권한이 없으면 페이지가 **undefined 를 넘긴다** — 공용 SearchArea 는 onSearch 가 없으면
  //   조회 버튼을 그리지 않고 F5 리스너도 걸지 않으므로(SearchArea.tsx:113·F5 절) 권한 게이트가
  //   버튼·단축키 양쪽에 동시에 적용된다. optional 이 곧 권한 표현이다(A-3).
  onSearch?: () => void;
  onItemSearch: () => void;
  // Division 옵션은 페이지가 만든다 — 권한 0건 게이트(무권한 판정)와 같은 집합이어야 하기 때문.
  divisionOptions: Option[];
  // 권한 Division 0건이면 조회조건 전체 비활성 (AS-IS SetDivisionAuthCheck, design 01 §2 R2).
  disabled: boolean;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 2행 6조건:
//   Row1 Division*(단일,필수,EE 제외) / Operation Group(단일+ALL, P/A/E + 클라 W) / From Site(다중+ALL) / Valid(단일+ALL)
//   Row2 Model(입력+SCM0002 팝업, 다건) / User ID(Name)(LIKE 텍스트)
export const ShipmentModelPicForm = ({
  onSearch,
  onItemSearch,
  divisionOptions,
  disabled,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentModelPicStore(s => s.searchCondition);
  const set = useShipmentModelPicStore(s => s.setSearchCondition);
  const clearFilters = useShipmentModelPicStore(s => s.clearFilters);
  const openSearchArea = useShipmentModelPicStore(s => s.openSearchArea);

  // Model/User 입력칸 Enter 는 SearchArea 버튼 경로를 타지 않으므로 **여기서** 같은 두 가드를 건다(A-3):
  //   ① 권한(onSearch 가 undefined 면 아무 동작 없음) ② 미저장 변경 confirm.
  //   ②가 없으면 Enter 만 편집분을 조용히 덮어쓴다(버튼·F5 는 SearchArea 가 이미 감싼다 — SearchArea.tsx:113).
  //   dirtyKey 는 페이지 화면이라 항상 tab 스코프다(팝업 안이면 scopeDirtyKey 지만 이 화면은 페이지).
  //   공용 `handleSearch` 에는 confirm 을 넣지 않는다 — 버튼 경로에서 확인창이 두 번 뜬다.
  const tabId = useTabid();
  const handleEnterSearch = onSearch
    ? () => {
        void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
          if (ok) onSearch();
        });
      }
    : undefined;

  // From Site = PlantSiteByDivision @divisionId. 선택 division 을 넘겨 서버 cascade(design 02 §3
  //   재조회 방식). division 변경 시 param 이 바뀌어 자동 재조회. 값 raw, 인용은 getCombo funnel.
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };

  const [fromSites, validYnRows] = useTabComboQueries({
    filters: [fromSiteFilter, COMBO.VALID],
  });
  // Operation Group = LookupCommon lookupType='OPERATION_GROUP'(P/A/E). W 는 lookup 에 없어 클라 추가.
  const [operationGroupData] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.OPERATION_GROUP }],
  });

  const fromSiteOptions = toOptions(fromSites);
  const validOptions = toOptions(validYnRows);
  // P/A/E(lookup NAME) + 클라 W=Warranty (design 02 §2.2 — 코드/표시 그리드와 일치).
  //   정렬: AS-IS 는 lookup 결과를 `.OrderBy(CODE)` 로 재정렬한 뒤 W 를 append 한다
  //   (DataService.cs:5210 + cs:183~187) → 최종 A,E,P,W. TO-BE lookup 은 DISPLAY_SEQ 순(P,A,E)
  //   이라 그대로 두면 순서가 다르다(design 02 §6 F-2). `LookupCommon` 은 전 도메인 공용이라
  //   lookup DISPLAY_SEQ·CMBO 본문을 고치지 않고 화면에서 재현한다(convert-core §2.6 ②, hook #117).
  const operationGroupOptions: Option[] = [
    ...(operationGroupData ?? [])
      .map(r => ({ label: str(r.NAME), value: str(r.CODE) }))
      .sort((a, b) => a.value.localeCompare(b.value)),
    { label: OPERATION_GROUP_WARRANTY_NAME, value: OPERATION_GROUP_WARRANTY_CODE },
  ];

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수, 기본포커스 — design 02 §2.1). 변경 시 나머지 조회조건 전부 기본값으로
              초기화(From Site cascade 포함, §3) + 그리드도 초기화(clearFilters — 옛 division 행 잔존 방지,
              DMF0004 sales-site 와 동일 요건). 그리드가 편집/추가중(dirty)이면 공통 confirm(MSG00704) 후에만
              바꾼다 — 조회 버튼이 타는 공통 가드 confirmIfDirtyKey(..., 'search')를 Div 콤보에도 동일 적용
              (DMF0004 선례, 사용자 지시 2026-10-12). controlled 콤보(value=sc.divisionId)라 취소 시 이전 Div 로 복귀. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    const next = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      set({
                        divisionId: next,
                        operationGroup: 'ALL',
                        fromSiteIds: [],
                        validYn: 'ALL',
                        itemId: '',
                        userId: '',
                      });
                      clearFilters(); // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Operation Group (단일 + ALL) — P/A/E + 클라 W. AS-IS OperationGroup cascade 는 주석처리(부활 금지). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.OPERATION_GROUP, '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  allOption
                  value={sc.operationGroup}
                  options={operationGroupOptions}
                  onChange={(_, picked) => set({ operationGroup: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — division 하위 PLANT (서버 @divisionId cascade). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      fromSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Valid (단일 + ALL) — YesOrNo. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  allOption
                  value={sc.validYn}
                  options={validOptions}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model/Nickname — 입력 + 돋보기(공용 MaterialByDivisionModal COM0013, SCP0013 정합). 다건(콤마).
              팝업 선택 결과 ITEM_ID 를 itemId(GET P_ITEM_ID)로 채운다. SSP0014 GET SP 에는 nick_name 파라미터가
              없어 서버 필터는 itemId 단일이며, 라벨만 Model/Nickname 으로 표기(사용자 지시 2026-10-12). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  disabled={disabled}
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && handleEnterSearch?.()}
                />
              )}
            />
          </Grid>

          {/* User ID(Name) — LIKE 텍스트(GET SP 6필드 OR, design 02 §2.5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.USER_ID_NAME, '_User ID(Name)')}
              labelAlign='right'
              render={() => (
                <InputField
                  disabled={disabled}
                  fullWidth
                  value={sc.userId}
                  onChange={e => set({ userId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && handleEnterSearch?.()}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
