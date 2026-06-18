import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ColumnSettingModal } from '../../components';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ContributeVersionModal } from './components/modals/ContributeVersionModal';
import { BASE_COLUMN_COUNT, MENU_ID, SHEETS } from './contribute-view.constants';
import styles from './ContributeView.module.scss';
import { useContributeViewValidation } from './hooks/useContributeViewValidation';
import type { SalesViewRow } from './types';
import { useContributeViewStore } from './useContributeViewStore';

// AS-IS DMF0043_Contribute_View — 기여율 조회 화면 (조회 전용)
//
// 핵심 보강 (2026-06-01 plan):
//   - 4축 100% 매핑 (Event 4 / API 3 / Validation 2 / Expression 2)
//   - POPUP 3종 (ContributeVersionModal / ColumnTitleSetModal / ContributeRatePopup 재사용)
//   - 룰 03/12/14/24/25/27/31 정합
//   - 메모리: no-type-cast / popup-asis-precision / pivot-frozen-columns / runtime-error-prevention 준수
export const ContributeView = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesViewRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useContributeViewStore(s => s.filters);
  const searchCondition = useContributeViewStore(s => s.searchCondition);
  const setSearchCondition = useContributeViewStore(s => s.setSearchCondition);
  const setFilter = useContributeViewStore(s => s.setFilter);
  const openSearchArea = useContributeViewStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeViewStore(s => s.setOpenSearchArea);

  const versionPopupOpen = useContributeViewStore(s => s.versionPopupOpen);
  const setVersionPopupOpen = useContributeViewStore(s => s.setVersionPopupOpen);
  const columnSetPopupOpen = useContributeViewStore(s => s.columnSetPopupOpen);
  const setColumnSetPopupOpen = useContributeViewStore(s => s.setColumnSetPopupOpen);
  const setVisibleBaseColumns = useContributeViewStore(s => s.setVisibleBaseColumns);

  const setAlert = useMessageStore(s => s.setAlert);

  // ⭐ master hook §3 / menu-button-dynamic-fetch §2.1 —
  //   admin SYS0009 Menu Button (SCM_ADM_MNU_BTN_MPG_M USE_YN + USER_GR_MNU_BTN_MPG_M 권한) 동적 fetch.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { validateVersionSelected, validateSearchResultEmpty } = useContributeViewValidation();

  // AS-IS Form_Load + FindData (.cs L283): DMF0043_GET_CONTRIBUTION_SALES_LIST
  const { data: mainData, refetch: search } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchCondition.verSeq,
  });

  // ⭐ 2026-06-17 fix — ColumnSettingModal fallbackColumns 전달 위해 title 메타 별도 fetch.
  //   ContributeViewGrid 가 동일 SP (DMF0043_GET_SALES_LIST_SPREAD_TITLE) 를 호출하므로
  //   react-query 가 cache 로 dedupe → 중복 호출 부담 없음.
  //   목적: BE SP DMF0002_GET_TITLESET_POPUP 가 빈 결과 반환해도 popup 의 grid 가 채워지도록.
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.MAIN_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_TITLE,
    tabId,
    filters: filters[SHEETS.MAIN_TITLE],
    enabled: !!filters[SHEETS.MAIN_TITLE],
  });

  // ⭐ 2026-06-17 사용자 명시 — 동적 생성 column 은 ColumnSetting 대상에서 제외.
  //   buildColumnMeta() 의 isBase = i < BASE_COLUMN_COUNT (= 9 base columns).
  //   동적 컬럼 (Y#/M#/period × leaf) 은 SP 응답 순서상 BASE_COLUMN_COUNT 이후에 위치.
  //   slice(0, BASE_COLUMN_COUNT) 로 base 9개만 fallback 으로 사용.
  //
  // ⭐ 2026-06-17 보완 — popup 재진입 시 이전 이동 내역 복원:
  //   store.visibleBaseColumns 에 기록된 visible list 와 매칭하여 fallback 의 visible flag 설정.
  //   - 빈 array (default) = 모두 visible (첫 진입)
  //   - 값 있음 = list 에 포함되지 않은 column 은 visible=false → popup 의 좌측 (hidden) grid 에 표시
  const visibleBaseColumnsList = useContributeViewStore(s => s.visibleBaseColumns);
  const fallbackColumns = useMemo(() => {
    const titleRows = (titleData?.o_rc1 ?? []) as Array<{
      COLUMN_NAME?: string;
      COLUMN_LABEL_NAME?: string;
    }>;
    const visibleSet =
      visibleBaseColumnsList.length > 0 ? new Set(visibleBaseColumnsList) : null;
    return titleRows
      .slice(0, BASE_COLUMN_COUNT)
      .filter(r => r.COLUMN_NAME && !r.COLUMN_NAME.includes('B_'))
      .map(r => ({
        key: r.COLUMN_NAME ?? '',
        header: r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? '',
        // visibleSet 가 null (첫 진입) → 모두 visible.
        // visibleSet 있음 → list 에 포함된 column 만 visible.
        visible: visibleSet === null ? true : visibleSet.has(r.COLUMN_NAME ?? ''),
      }));
  }, [titleData, visibleBaseColumnsList]);

  // AS-IS .cs L285~289: MSG00283 — Version 미선택 차단
  const handleSearch = async () => {
    // AS-IS 의 txtVersion 미선택 (= versionNo 빈 값) 차단
    const ok = await validateVersionSelected(searchCondition.versionNo);
    if (!ok) return;
    setFilter();
    void search();
  };

  // AS-IS L466~470: VersionPopup 선택 → txtVersion.Text 채움
  const handleVersionSelect = (versionNo: string) => {
    setSearchCondition({ versionNo });
  };

  // AS-IS L481~482: ColumnSet popup OK → InitSpread() (= title sheet refetch via setFilter)
  const handleColumnApply = () => {
    setFilter();
  };

  // AS-IS Form_Load + Year 자동 선택 직후 자동 조회 trigger
  // useEffect(() => {
  //   if (searchCondition.verSeq && !filters[SHEETS.MAIN]) {
  //     setFilter();
  //   }
  // }, [searchCondition.verSeq]);

  const rows = (mainData?.p_cursor_main ?? []) as SalesViewRow[];

  // AS-IS .cs L333~336: MSG00307 — 조회 결과 알림
  useEffect(() => {
    if (filters[SHEETS.MAIN] && mainData && rows.length === 0) {
      void validateSearchResultEmpty(rows);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  // As-Is .cs L249 InsertButton → InsertRow() 본문 있음 — 화면 의도는 조회 전용 (Figma DMF0043_01) 이지만
  // 룰 25 §1.5.1: As-Is 본문 있음 → function (TODO placeholder). silent fail 방지.
  const handleInsert = () => {
    void setAlert({
      type: 'alert',
      content:
        '미구현 — As-Is DMF0043_Contribute_View.cs L249 InsertRow() 참조. 화면 의도(조회 전용) 와 As-Is 본문 (Insert 가능) 충돌 — 운영 결정 필요.',
    });
  };

  // As-Is .cs L276 SaveButton → SaveData() 본문 있음 — Insert 와 동일 정책
  const handleSave = () => {
    void setAlert({
      type: 'alert',
      content:
        '미구현 — As-Is DMF0043_Contribute_View.cs L276 SaveData() 참조. 화면 의도(조회 전용) 와 As-Is 본문 (Save 가능) 충돌 — 운영 결정 필요.',
    });
  };

  // Figma SVG (DMF0043_01.svg + DMF0043_01_Table.svg) + figma_link.md + AS-IS button:
  //   F5  = 조회 (handleSearch)
  //   F3  = Sort           (default — SubTitle hotkey)
  //   F4  = Filter         (default)
  //   F6  = Condition      (default — As-Is UsrConditionPanel 존재)
  //   F10 = ResetCondition (default — As-Is UsrConditionPanel 존재)
  //   Excel = default
  //   F7  (save) : As-Is .cs L276 SaveData() 본문 있음 → placeholder (조회 전용 의도 vs As-Is 본문 충돌)
  //   F8 (insert) : As-Is .cs L249 InsertRow() 본문 있음 → placeholder
  //   F9 (delete) : As-Is .cs L254 본문 주석만 (빈) → false
  //   기여율버전관리 : customButton (AS-IS btnCutOff_Click L444)
  //   컬럼표시설정 : customButton (AS-IS btnColumn_Click L473)
  // ⭐ master hook §3 — `hasButton(BTN_CD)` 조건부 callback. admin USE_YN='N' 즉시 비활성.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: false,
    manual: false,
    upload: false,
  };

  // ⭐ 사용자 명시 — '⊞ 컬럼 표시 설정' 버튼 항상 노출.
  //   admin 메타 등록 전후 무관 default visible (DMF0043 동일 정책).
  const customButtons = useMemo(
    () => [
      {
        label: '⊞',
        title: '컬럼 표시 설정',
        action: () => setColumnSetPopupOpen(true),
      },
    ],
    [setColumnSetPopupOpen]
  );

  // 탭을 열 때 컬럼을 보여줄 수 있도록 처리
  // useEffect(() => {
  //   void setFilter();
  // }, [tabId]);

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
        searchParam={searchCondition}
        customButtons={customButtons}
      />
      <div className={styles.gridContainer}>
        <ContributeViewGrid gridRef={gridRef} data={rows} />
      </div>
      <ContributeVersionModal
        open={versionPopupOpen}
        onClose={() => setVersionPopupOpen(false)}
        onSelect={handleVersionSelect}
      />
      <ColumnSettingModal
        open={columnSetPopupOpen}
        modalClose={() => setColumnSetPopupOpen(false)}
        menuId='DMF0043_01'
        sheetName='ContributeSalesList'
        columnType='C'
        divisionId='40'
        fallbackColumns={fallbackColumns}
        onSave={settings => {
          // ⭐ ColumnSettingModal 은 USER_FLAG='Y' rows (= 우측 grid = visible) 만 전달.
          //   사용자가 좌측으로 이동한 column = settings 에 미포함 → grid 에서 숨김.
          setVisibleBaseColumns(settings.map(s => s.COLUMN_NAME));
          handleColumnApply();
        }}
      />
    </div>
  );
};
