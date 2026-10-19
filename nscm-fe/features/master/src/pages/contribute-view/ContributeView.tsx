import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import {
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  toColumnLayoutSettings,
} from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ContributeVersionModal } from './components/modals/ContributeVersionModal';
import {
  MENU_ID,
  SHEETS,
  TITLE_MENU_ID,
  TITLESET_COLUMN_TYPE,
  TITLESET_DIVISION,
  TITLESET_SHEET,
} from './contribute-view.constants';
import { useContributeViewValidation } from './hooks/useContributeViewValidation';
import type { SalesViewRow, ValidationCheckCount } from './types';
import { useContributeViewStore } from './useContributeViewStore';

// AS-IS DMF0043_Contribute_View — 기여율 조회 화면 (조회 전용)
//
// 핵심 보강 (2026-06-01 plan):
//   - 4축 100% 매핑 (Event 4 / API 3 / Validation 2 / Expression 2)
//   - POPUP 3종 (ContributeVersionModal / ColumnTitleSetModal / ContributeRatePopup 재사용)
//   - 룰 03/12/14/24/25/27/31 정합
//   - 메모리: no-type-cast / popup-asis-precision / pivot-frozen-columns / runtime-error-prevention 준수
export const ContributeView = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType<SalesViewRow> | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const filters = useContributeViewStore(s => s.filters);
  const searchParams = useContributeViewStore(s => s.searchParams);
  const setSearchParams = useContributeViewStore(s => s.setSearchParams);
  const setFilters = useContributeViewStore(s => s.setFilters);
  const clearFilters = useContributeViewStore(s => s.clearFilters);
  const initialized = useContributeViewStore(s => s.initialized);
  const fetchStaticColumns = useContributeViewStore(s => s.fetchStaticColumns);
  const openSearchArea = useContributeViewStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeViewStore(s => s.setOpenSearchArea);

  const versionPopupOpen = useContributeViewStore(s => s.versionPopupOpen);
  const setVersionPopupOpen = useContributeViewStore(s => s.setVersionPopupOpen);
  const columnSetPopupOpen = useContributeViewStore(s => s.columnSetPopupOpen);
  const setColumnSetPopupOpen = useContributeViewStore(s => s.setColumnSetPopupOpen);
  const staticColumns = useContributeViewStore(s => s.staticColumns[SHEETS.MAIN]);
  const originalStaticColumns = useContributeViewStore(s => s.originalStaticColumns[SHEETS.MAIN]);
  const applyColumnLayout = useContributeViewStore(s => s.applyColumnLayout);

  // ColumnLayoutModal 재진입 복원 — 현재 grid 상태(개인화 반영본).
  //   ⚠️ DB 응답이 우선이고 이 값은 BE 가 안 준 필드만 보완한다 (buildInitialRows 규칙).
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns ?? []),
    [staticColumns]
  );
  // Default 버튼 원복 기준 — 개인화 적용 전 admin 메타 원본.
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns ?? []),
    [originalStaticColumns]
  );
  // titleSet SP 가 0건일 때의 fallback — admin 메타로 목록을 채워 빈 팝업을 막는다.
  const columnFallback = useMemo(
    () =>
      (originalStaticColumns ?? []).map(c => ({
        key: c.colNm,
        header: c.colLblNm ?? c.colNm,
        width: c.colWth ?? 100,
      })),
    [originalStaticColumns]
  );

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateVersionSelected, validateSearchResultEmpty } = useContributeViewValidation();

  const { setAlert } = useMessageStore.getState();

  // AS-IS Form_Load + FindData (.cs L283): DMF0043_GET_CONTRIBUTION_SALES_LIST
  const {
    data: mainData,
    refetch: search,
    dataUpdatedAt,
  } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchParams.verSeq,
  });

  // AS-IS .cs L285~289: MSG00283 — Version 미선택 차단
  const handleSearch = async () => {
    // AS-IS 의 txtVersion 미선택 (= versionNo 빈 값) 차단
    const ok = await validateVersionSelected(searchParams.versionNo);
    if (!ok) return;
    setFilters();
    void fetchStaticColumns();
    void search();
  };

  // 화면 mount 시 admin SHEET_COLUMNS 동적 fetch (admin 변경 즉시 반영).
  useEffect(() => {
    if (initialized) {
      if (searchParams.versionNo) {
        setFilters();
      }
    } else {
      void fetchStaticColumns();
    }
  }, [initialized]);

  // AS-IS L466~470: VersionPopup 선택 → txtVersion.Text 채움
  const handleVersionSelect = (versionNo: string) => {
    setSearchParams({ versionNo });
  };

  // AS-IS L481~482: ColumnSet popup OK → InitSpread().
  //   Column 설정 저장 = Grid 초기화 의무 (사용자 요구 2026-08-05) — 저장 즉시 표시 컬럼이
  //   바뀌므로 이전 설정으로 조회해 둔 rows 를 그대로 두면 컬럼 구성과 데이터가 어긋난다.
  //   filters 무효화(enabled=false + queryKey 변경)로 그리드를 비우고 재조회는 Search 로만.
  //   removeQueries([tabId]) 필수 — queryKey 는 filters '값' 기반이라 동일 조건으로 다시
  //   Search 하면 전역 staleTime=Infinity 캐시가 이전 설정으로 받은 rows 를 그대로 돌려준다.
  const clearGridOnSettingChange = () => {
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
  };

  const rows = (mainData?.o_rc1 ?? []) as SalesViewRow[];
  const validCnt = (mainData?.o_rc3 ?? []) as unknown as ValidationCheckCount[];

  // AS-IS .cs L333~336: MSG00307 — 조회 결과 알림
  useEffect(() => {
    if (filters[SHEETS.MAIN] && mainData && rows.length === 0) {
      void validateSearchResultEmpty(rows);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  useEffect(() => {
    if (mainData) {
      if (searchParams.compatibilityYn === 'Y' && validCnt?.[0].CNT > 0) {
        void setAlert({
          type: 'alert',
          content: t('MSG00631', '_해외법인 기여도 미 맵핑된 마스터가 존재합니다.'),
        });
      }
    }
  }, [dataUpdatedAt]);

  // 화면 설계(DMF0043_01) = 조회 전용 화면 (AS-IS .cs L249 InsertRow / L276 SaveData 본문 있으나
  // 화면 의도 = 조회 전용 — 운영 결정에 따라 hotkeyConfig.insert/save = false 로 차단).
  // 권한 분기 (useTabBtnPermissions): admin USE_YN='N' 시 자동 무력화 (운영 결정 반영).
  //   F5  = 조회 (handleSearch)
  //   F3  = Sort           (default — SubTitle hotkey)
  //   F4  = Filter         (default)
  //   F6  = Condition      (default)
  //   F10 = ResetCondition (default)
  //   Excel = default
  //   기여율버전관리 : customButton (AS-IS btnCutOff_Click L444)
  //   컬럼표시설정 : customButton (AS-IS btnColumn_Click L473)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 사용자 요구 (2026-06-01):
  //   - "기여율 버전관리" → SubTitle 에서 제거, Form 의 아이콘 버튼으로 이동
  //   - "컬럼 표시 설정" → SubTitle 의 아이콘형 버튼으로 (Form ⊞ btnColumn 과 동일 아이콘)
  const customButtons = [
    {
      // Column Setting — 공용 Grid Column Setup 아이콘(↔ + 상/하 분할 2컬럼). @foundation/assets IcGridColumnSetup.
      label: t('LBL00605', 'Column Setting'),
      title: t('LBL00605', 'Column Setting'),
      action: () => setColumnSetPopupOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      {/* 제목·상단 경로·즐겨찾기는 이 화면의 메뉴 등록 ID(DMF0043_01 'Contribution Sales')로 그린다.
          MENU_ID(DMF0043)로 그리면 부모 메뉴 이름 'Contribution Rate Reg.' 가 경로에 떠 다른 화면으로 오인된다
          (통합테스트 지적 2026-10-08). 프로시저 호출·버튼 권한은 종전대로 MENU_ID — constants TITLE_MENU_ID 주석 참조. */}
      <MainTitle
        title={title}
        menuId={TITLE_MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ContributeViewForm
          onSearch={() => void handleSearch()}
          onOpenVersionPopup={() => setVersionPopupOpen(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeView'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />
      <ContributeViewGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
      <ContributeVersionModal
        open={versionPopupOpen}
        onClose={() => setVersionPopupOpen(false)}
        onSelect={handleVersionSelect}
      />
      {/* 컬럼 표시 설정 (AS-IS btnColumn_Click L473) — 공용 ColumnLayoutModal.
          표시/순서에 더해 Width / Cell·Text Color 개인화까지 제공 (mkt-fcst·forecast-price 선례 1:1). */}
      <ColumnLayoutModal
        open={columnSetPopupOpen}
        modalClose={() => setColumnSetPopupOpen(false)}
        menuId={MENU_ID}
        // ⚠️ 저장(saveTitleSet)·복원(fetchUserColumnLayout)과 반드시 같은 값 — 상수 한 곳에서만 가져온다.
        sheetName={TITLESET_SHEET}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={TITLESET_DIVISION}
        fallbackColumns={columnFallback}
        title={t('LBL00605', 'Column Setting')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // (0) 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다.
          clearGridOnSettingChange();
          // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns 에 적용 → grid 즉시 갱신.
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          // (2) titleSet 영구 저장 — 표시 column + 순서 + 폭/색 (공용 엔드포인트).
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: TITLESET_SHEET,
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            // 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
            if (!ok) {
              void setAlert({
                type: 'alert',
                content: t('MSG00618', '_An error occurred while saving.'),
              });
              return;
            }
            // ⭐ 팝업 titleSet 조회 캐시 무효화 (필수). 전역 staleTime=Infinity 라 invalidate 없이는
            //   재조회가 아예 안 일어나고, buildInitialRows 는 BE 응답을 화면 상태보다 우선하므로
            //   저장 전 값이 그대로 이겨서 재진입 시 원복된 것처럼 보인다.
            //   팝업 query 의 tabId = MENU_ID 이므로 이 prefix 로 매칭된다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />
    </>
  );
};
