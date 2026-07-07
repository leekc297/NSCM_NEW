import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ColumnSettingModal } from '../../components';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ContributeVersionModal } from './components/modals/ContributeVersionModal';
import { MENU_ID, SHEETS } from './contribute-view.constants';
import styles from './ContributeView.module.scss';
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
  const initialized = useContributeViewStore(s => s.initialized);
  const fetchStaticColumns = useContributeViewStore(s => s.fetchStaticColumns);
  const openSearchArea = useContributeViewStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeViewStore(s => s.setOpenSearchArea);

  const versionPopupOpen = useContributeViewStore(s => s.versionPopupOpen);
  const setVersionPopupOpen = useContributeViewStore(s => s.setVersionPopupOpen);
  const columnSetPopupOpen = useContributeViewStore(s => s.columnSetPopupOpen);
  const setColumnSetPopupOpen = useContributeViewStore(s => s.setColumnSetPopupOpen);
  const visibleBaseColumns = useContributeViewStore(s => s.visibleBaseColumns);
  const setVisibleBaseColumns = useContributeViewStore(s => s.setVisibleBaseColumns);

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

  // AS-IS L481~482: ColumnSet popup OK → InitSpread() (= title sheet refetch via setFilters)
  const handleColumnApply = () => {
    setFilters();
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

  // Figma DMF0043_01 = 조회 전용 화면 (AS-IS .cs L249 InsertRow / L276 SaveData 본문 있으나
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
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
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
      <div className={styles.gridContainer}>
        <ContributeViewGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
      </div>
      <ContributeVersionModal
        open={versionPopupOpen}
        onClose={() => setVersionPopupOpen(false)}
        onSelect={handleVersionSelect}
      />
      <ColumnSettingModal
        open={columnSetPopupOpen}
        modalClose={() => setColumnSetPopupOpen(false)}
        menuId={MENU_ID}
        sheetName='ContributeSalesList'
        columnType='C'
        divisionId='40'
        initialVisibleKeys={visibleBaseColumns}
        onSave={settings => {
          setVisibleBaseColumns(settings.map(s => s.COLUMN_NAME));
          handleColumnApply();
        }}
      />
    </div>
  );
};
