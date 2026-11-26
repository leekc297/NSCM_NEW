import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Checkbox } from '@shared/lges';
import { useMessageStore, useUIStore } from '@shared/stores';

import { EndingInventoryForm } from './components/EndingInventoryForm';
import { EndingInventoryGrid } from './components/EndingInventoryGrid';
import {
  DEVALUATION_AGE_LABEL,
  EXCEL_SHOW_COLUMNS,
  LBL,
  MENU_ID,
  MSG,
  SEARCH_MODE,
  SHEETS,
} from './ending-inventory.constants';
import { useEndingInventoryStore } from './useEndingInventoryStore';

// AS-IS: SCP0085_EndingInventory.cs — 조회 전용 Report. Find + Excel 실동작 / Edit·Save NO-OP.
export const EndingInventory = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [openItem, setOpenItem] = useState(false);

  const isOpenSearchArea = useEndingInventoryStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useEndingInventoryStore(state => state.setOpenSearchArea);
  const searchParams = useEndingInventoryStore(state => state.searchParams);
  const setSearchParams = useEndingInventoryStore(state => state.setSearchParams);
  // Condition(F6) 저장 제외 — 날짜(month/date)는 저장하지 않는다(사용자 결정 2026-10-21). 공통
  //   EXCLUDED_DATE_PARAM 은 'yyyymm'/'yyyymmdd' 키명만 잡아 SCP0085 의 'month'/'date' 키는 안 걸리므로
  //   SubTitle 로 넘기는 저장용 조건에서 직접 뺀다(복원도 저장분만 패치하므로 날짜는 기본값 유지).
  const conditionParam = useMemo(() => {
    const { month: _month, date: _date, ...rest } = searchParams;
    return rest;
  }, [searchParams]);
  const filters = useEndingInventoryStore(state => state.filters);
  const setFilters = useEndingInventoryStore(state => state.setFilters);
  const clearFilters = useEndingInventoryStore(state => state.clearFilters);
  const initialized = useEndingInventoryStore(state => state.initialized);
  const fetchStaticColumns = useEndingInventoryStore(state => state.fetchStaticColumns);
  const restoreSearchParams = useEndingInventoryStore(state => state.restoreSearchParams);
  const isHeaderViewDetail = useEndingInventoryStore(state => state.isHeaderViewDetail);
  const toggleHeaderViewDetail = useEndingInventoryStore(state => state.toggleHeaderViewDetail);
  const noDivisionAuth = useEndingInventoryStore(state => state.noDivisionAuth);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setProgress = useUIStore(state => state.setProgress);
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 조회 SP 이중화 — 모드별 시트로 갈라 각자 enabled 게이트(다른 SP·기간 파라미터키, design 02 §2.2).
  const { data: monthData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: dailyData } = useTabProcQuery<MENU_ID, SHEETS.DAILY>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAILY,
    tabId,
    filters: filters[SHEETS.DAILY],
    enabled: !!filters[SHEETS.DAILY],
  });

  // 표시 행 = 현재 모드의 조회결과. filters[mode] 가 비면(모드 전환 직후·초기) 빈 배열 —
  //   React Query 는 enabled=false 여도 직전 data 를 캐시로 들고 있어, filters 유무로 게이트하지
  //   않으면 모드 재전환 시 이전 결과가 stale 로 새어나온다(AS-IS ClearDataSource 재현, I4).
  const rows = useMemo(() => {
    if (searchParams.mode === SEARCH_MODE.DAILY) {
      return filters[SHEETS.DAILY] ? (dailyData?.o_rc1 ?? []) : [];
    }
    return filters[SHEETS.MAIN] ? (monthData?.o_rc1 ?? []) : [];
  }, [searchParams.mode, monthData, dailyData, filters]);

  const handleSearch = () => {
    // 조회 필수값 검증(AS-IS checkRequiredOfSearch, cs:405) — 활성 모드 기간 피커가 비면 조회 차단.
    //   일별=Date / 월마감=Month. MSG00429({0}=기간 라벨)로 안내하고 중단.
    const isDaily = searchParams.mode === SEARCH_MODE.DAILY;
    const periodValue = isDaily ? searchParams.date : searchParams.month;
    if (!periodValue) {
      const label = isDaily ? t(LBL.DATE, '_Date') : t(LBL.MONTH, '_Month');
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', label),
      });
      return;
    }
    setFilters();
    void fetchStaticColumns();
  };

  // Excel — AS-IS ExportExcelData(cs:666~683) 실동작. 조회 0건 시 MSG00100(→TO-BE MSG00719) 안내(design 03 §5-8).
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.EXCEL_NO_DATA, 'No data have been retrieved.') });
      return;
    }
    const g = gridRef.current;
    if (!g) return;
    // AS-IS 와 같이 CELL_CF 3컬럼을 엑셀에 포함한다(cs:925~953). 화면 컬럼은 그대로 둔다.
    //   excelDownload 가 시작 시점의 visible 을 읽으므로 호출 직전에 켜고, 끝나면 원래 값으로 되돌린다.
    const show = new Set(EXCEL_SHOW_COLUMNS);
    const saved: [string, boolean][] = [];
    for (const col of g.columns) {
      const b = col.binding ?? '';
      if (!show.has(b)) continue;
      saved.push([b, col.visible]);
      col.visible = true;
    }
    void GridAction.excelDownload(g, 'EndingInventory', setProgress).finally(() => {
      const prev = new Map(saved);
      for (const col of g.columns) {
        const v = prev.get(col.binding ?? '');
        if (v !== undefined) col.visible = v;
      }
    });
  };

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + 컬럼 메타 1회 fetch +
  //   F6 저장 조회조건 복원(탭당 1회) — 저장분 있으면 searchParams 에 적용, 없으면 기본값 유지.
  //   복원은 searchParams 만 패치하므로 clearFilters 로 빈 그리드 유지(재조회는 사용자 Search 로만).
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    void restoreSearchParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — 조회 전용 Report(01_layout §2 R4~R7):
  //   search = 실동작(hasButton('SEARCH') 게이트) / save = 미노출(save: false) — 저장 기능 없음.
  //     AS-IS SaveButton 은 NO-OP(노출+무동작)였으나 실제 저장 기능이 없어 버튼 제거(사용자 결정 2026-10-21).
  //   excel = 실동작(0건 가드) / insert·delete = 미노출(report — 기본 addRow/removeRow 핸들러 차단) /
  //   manual·upload = 미사용.
  //   AS-IS EditButton(NO-OP)은 NSCM 공용 툴바에 Edit 버튼 자체가 없어 대응 버튼 없음(파리티: 편집 불가 동일).
  //   R1(cs:188): MyDivision 0건이면 조회영역 전체 Enabled=false — 입력 disable(Form)에 더해 조회 액션도 차단.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    save: false,
    excel: handleExcel,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <EndingInventoryForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='EndingInventory'
        hotkeyConfig={hotkeyConfig}
        searchParam={conditionParam}
        // Devaluation Age(재고월령 컬럼 토글) — 조회조건 폼에서 그리드 건수 툴바로 이동(사용자 지시 2026-11-16).
        //   SCP0013 Weekly/Monthly Sum 과 동일하게 afterCount(건수 배지 오른쪽)에 렌더. 라벨 영어 고정.
        afterCount={
          <Checkbox
            labelText={DEVALUATION_AGE_LABEL}
            checked={searchParams.devaluationAge}
            disabled={noDivisionAuth}
            onChange={checked => setSearchParams({ devaluationAge: checked })}
          />
        }
      >
        {/* ERP 집계 안내문 — 모드(월마감/일별)에 따라 하나만 표시(사용자 지시 2026-11-16). 폰트 = FormItem label(0.8125rem). */}
        <span style={{ fontSize: '0.8125rem' }}>
          {searchParams.mode === SEARCH_MODE.DAILY
            ? t(
                MSG.DAILY_ERP_NOTICE,
                '_일별 기준 데이터는 매일 각 법인별 시업시간 기준 ERP(ZMMCMR6014) 재고를 가져옵니다.'
              )
            : t(
                MSG.MONTH_ERP_NOTICE,
                '_월마감 기준 데이터는 매월 본사 4 영업일에 집계하며, ERP(ZMMCMR6014) 전월말 재고를 가져옵니다.'
              )}
        </span>
      </SubTitle>
      <EndingInventoryGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        mode={searchParams.mode}
        divisionId={searchParams.divisionId}
        devaluationAge={searchParams.devaluationAge}
        isHeaderViewDetail={isHeaderViewDetail}
        onToggleDetail={toggleHeaderViewDetail}
      />
      {/* Material 검색 — 공용 MaterialByDivisionModal(SCM0002). 빈 반환 시 기존값 유지(AS-IS cs:444).
          multiDivision: 조회조건 Division 이 다중(콤마 결합, ALL 포함)이라 멀티 표시 모드로 연다. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        multiDivision
        multiCheckbox
        setSelectedValue={itemIds => {
          if (itemIds) setSearchParams({ itemId: itemIds });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: searchParams.itemId,
        }}
      />
    </>
  );
};
