import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BOD_EXCLUDED_COLUMN,
  BOD_ITEM_COLUMN,
  LBL,
  MENU_ID,
  MSG,
  RANGE,
  SHEET_BY_INDEX,
  SHEET_INDEX,
  SHEETS,
} from './bod-item.constants';
import type { BodExcludedRow, BodItemRow, BodPopupRow, ItemPopupRow } from './bod-item.types';
import styles from './BodItem.module.scss';
import { BodExcludedGrid } from './components/BodExcludedGrid';
import { BodItemForm } from './components/BodItemForm';
import { BodItemGrid } from './components/BodItemGrid';
import { GetBodItemModal } from './components/modals/GetBodItemModal';
import { ItemByDivisionModal } from './components/modals/ItemByDivisionModal';
import { useBodItemStore } from './useBodItemStore';
import { isBlank, toSelectedCodes, validateExcludedDates } from './utils/bod-item.util';

type ItemPopupState = { open: boolean; row?: BodExcludedRow; rowIndex?: number };
type BodPopupState = { open: boolean; row?: BodExcludedRow; rowIndex?: number };

export const BodItem = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 두 시트 그리드 ref — 공용 FlexGrid(=FlexGrid<any>)로 두고 시트별 그리드 컴포넌트에 전달(SalesSite 표준).
  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()] as const;
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()] as const;

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.BOD_ITEM);
  // Edit 버튼 = 편집모드 토글(AS-IS SwitchLock, L3). 조회/저장 성공 시 false 리셋(L2/L5).
  const [isEditMode, setIsEditMode] = useState(false);
  const [itemPopup, setItemPopup] = useState<ItemPopupState>({ open: false });
  const [itemSearchOpen, setItemSearchOpen] = useState(false);
  const [bodPopup, setBodPopup] = useState<BodPopupState>({ open: false });

  const initialized = useBodItemStore(state => state.initialized);
  const isOpenSearchArea = useBodItemStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useBodItemStore(state => state.setOpenSearchArea);
  const filters = useBodItemStore(state => state.filters);
  const setFilters = useBodItemStore(state => state.setFilters);
  const setSearchParams = useBodItemStore(state => state.setSearchParams);
  const fetchStaticColumns = useBodItemStore(state => state.fetchStaticColumns);
  const staticColumns = useBodItemStore(state => state.staticColumns);
  const searchParams = useBodItemStore(state => state.searchParams);

  const { data: bodItemData } = useTabProcQuery<MENU_ID, SHEETS.BOD_ITEM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM,
    tabId,
    filters: filters[SHEETS.BOD_ITEM],
    enabled: !!filters[SHEETS.BOD_ITEM],
  });
  const { data: excludedData } = useTabProcQuery<MENU_ID, SHEETS.BOD_EXCLUDED>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_EXCLUDED,
    tabId,
    filters: filters[SHEETS.BOD_EXCLUDED],
    enabled: !!filters[SHEETS.BOD_EXCLUDED],
  });

  const { mutate: mutateBodItem } = useProcMutation<MENU_ID, SHEETS.BOD_ITEM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM,
    tabId,
  });
  const { mutate: mutateExcluded } = useProcMutation<MENU_ID, SHEETS.BOD_EXCLUDED>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_EXCLUDED,
    tabId,
  });

  // division 변경 시 새 [] 참조로 그리드 리셋(#5) — 데이터 재조회는 Search 로만.
  const bodItemRows = useMemo(
    () => bodItemData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [bodItemData, searchParams.divisionId]
  );
  const excludedRows = useMemo(
    () => excludedData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [excludedData, searchParams.divisionId]
  );

  const rowCountByTab: Record<number, number> = {
    [SHEET_INDEX.BOD_ITEM]: bodItemRows.length,
    [SHEET_INDEX.BOD_EXCLUDED]: excludedRows.length,
  };

  const handleSearch = () => {
    setIsEditMode(false);
    setFilters();
    void fetchStaticColumns();
  };

  // 신규행은 Excluded 시트에서만 추가(bodItem 은 Insert 비활성, L4). 기본값 VALID_YN='Y',
  // DIVISION_ID=확정 division(단일 2자리 선택 시만, 그 외 '' — 팝업/직접입력으로 채움).
  const handleInsert = () => {
    if (activeTab !== SHEET_INDEX.BOD_EXCLUDED) return;
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!grid) return;
    const codes = toSelectedCodes(searchParams.divisionId);
    const divisionId = codes.length === 1 ? codes[0] : '';
    GridAction.addRow(grid, {
      [BOD_EXCLUDED_COLUMN.VALID_YN]: 'Y',
      [BOD_EXCLUDED_COLUMN.DIVISION_ID]: divisionId,
    } as Partial<BodExcludedRow>);
  };

  // 삭제 = 신규행('I')만 removeRow, 기존행은 VALID_YN 편집(#138). 두 시트 공통.
  const handleDelete = () => {
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    GridAction.removeRow(grid, true);
  };

  const handleSaveBodItem = () => {
    const grid = gridRefs[SHEET_INDEX.BOD_ITEM].current;
    if (!grid) return;
    grid.finishEditing();
    const src = (grid.collectionView?.sourceCollection ?? []) as unknown as BodItemRow[];
    const dirty = src.filter(row => (row as WijmoRowItem).CRUD_TYPE);
    if (dirty.length === 0) {
      void setToast({ type: 'error', message: t(CRUD_MSG.NO_CHANGES.id, CRUD_MSG.NO_CHANGES.fallback) });
      return;
    }
    // 숫자 범위 검증(PRIORITY 0~99 / SAFETY_STOCK 0~100, 03 §3-D).
    for (const row of dirty as WijmoRowItem[]) {
      const priority = row[BOD_ITEM_COLUMN.PRIORITY];
      if (!isBlank(priority) && (Number(priority) < 0 || Number(priority) > RANGE.PRIORITY_MAX)) {
        void setAlert({ type: 'alert', content: t('MSG00085', '_{0} 범위의 값만 입력 가능합니다.').replace('{0}', `Priority : 0 ~ ${RANGE.PRIORITY_MAX}`) });
        return;
      }
      const safety = row[BOD_ITEM_COLUMN.SAFETY_STOCK];
      if (!isBlank(safety) && (Number(safety) < 0 || Number(safety) > RANGE.SAFETY_STOCK_MAX)) {
        void setAlert({ type: 'alert', content: t('MSG00085', '_{0} 범위의 값만 입력 가능합니다.').replace('{0}', `Safety Stock : 0 ~ ${RANGE.SAFETY_STOCK_MAX}`) });
        return;
      }
    }
    // 날짜 6검증(N1~N8, 03 §3-B)은 저장 차단으로 재현하지 않는다 — AS-IS SaveData_Main(cs:937-942)에서
    // checkValidN1~N8 호출이 전건 주석 처리("BOD LT 2단계 개발 - FROM, TO 저장 BOD UI 에서 관리")돼 있어
    // 런타임 저장 검증은 checkRequiredOfSpread(cs:929, 필수값)뿐이다. 필수값은 useSaveWithValidation 이 담당.
    // 상세: design/04_react-gap.md G-VALIDATION-REDERIVED.
    saveWithValidation(dirty, staticColumns[SHEETS.BOD_ITEM], rows =>
      mutateBodItem(rows, {
        onSuccess: () => setIsEditMode(false),
      })
    );
  };

  const handleSaveExcluded = () => {
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!grid) return;
    grid.finishEditing();
    const src = (grid.collectionView?.sourceCollection ?? []) as unknown as BodExcludedRow[];
    const dirty = src.filter(row => (row as WijmoRowItem).CRUD_TYPE);
    if (dirty.length === 0) {
      void setToast({ type: 'error', message: t(CRUD_MSG.NO_CHANGES.id, CRUD_MSG.NO_CHANGES.fallback) });
      return;
    }
    // 화면 고유 날짜검증(03 §4-C) — AS-IS SaveData_Sub(cs:1114-1136) 라이브 검증 재현: FROM>TO 역전 차단
    //   (MSG00219). 형식검증(MSG00046)은 FPDate 셀이 구조적으로 보장. 필수값은 useSaveWithValidation.
    const dateError = validateExcludedDates(dirty as WijmoRowItem[]);
    if (dateError) {
      void setAlert({ type: 'alert', content: t(dateError.id, dateError.fallback) });
      return;
    }
    saveWithValidation(dirty, staticColumns[SHEETS.BOD_EXCLUDED], rows =>
      mutateExcluded(rows, { onSuccess: () => setIsEditMode(false) })
    );
  };

  const handleSave = () => {
    if (activeTab === SHEET_INDEX.BOD_ITEM) handleSaveBodItem();
    else handleSaveExcluded();
  };

  // 시트 전환 가드 — 떠나는 시트에 미저장 변경(CRUD_TYPE)이 있으면 전환 차단 + MSG00129(L8, 03 §3-G).
  const handleTabChange = (nextIndex: number) => {
    const leavingGrid = gridRefs[activeTab].current;
    const dirty = ((leavingGrid?.collectionView?.sourceCollection ?? []) as WijmoRowItem[]).some(
      row => row.CRUD_TYPE
    );
    if (dirty) {
      const sheetName = ADMIN_SHEET_NAME[SHEET_BY_INDEX[activeTab]];
      void setAlert({
        type: 'alert',
        content: t(MSG.SHEET_LOCKED, '_{0}를 수정 중이어서 시트를 변경할 수 없습니다.').replace('{0}', sheetName),
      });
      return;
    }
    setActiveTab(nextIndex as SHEET_INDEX);
    setIsEditMode(false);
  };

  // btnItemId 팝업 선택(다건) → ItemID CSV 를 조회조건 Model 에 채움(02 §4.6).
  const handleItemSearchSelect = (rows: ItemPopupRow[]) => {
    const itemIds = rows
      .map(row => String(row.ITEM_ID ?? '').trim())
      .filter(id => id !== '');
    if (itemIds.length > 0) setSearchParams({ itemId: itemIds.join(',') });
  };

  // Excluded ITEM_ID 셀 팝업 선택(단건) → 그 행 ITEM_ID 채움(03 §3-C value 파생).
  const handleItemCellSelect = (rows: ItemPopupRow[]) => {
    const { row, rowIndex } = itemPopup;
    const picked = rows[0];
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!row || rowIndex === undefined || !picked || !grid) return;
    const target = row as unknown as WijmoRowItem;
    target[BOD_EXCLUDED_COLUMN.ITEM_ID] = String(picked.ITEM_ID ?? '');
    if (!target.CRUD_TYPE) target.CRUD_TYPE = 'M';
    grid.collectionView?.refresh();
  };

  // Excluded BOD_ID 셀 팝업 선택(다건) → 신규행 cascade 채움(03 §3-C #57-64).
  const handleBodSelect = (rows: BodPopupRow[]) => {
    const { row, rowIndex } = bodPopup;
    const picked = rows[0];
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!row || rowIndex === undefined || !picked || !grid) return;
    const target = row as unknown as WijmoRowItem;
    target[BOD_EXCLUDED_COLUMN.BOD_ID] = String(picked.BOD_ID ?? '');
    target[BOD_EXCLUDED_COLUMN.FROM_SITE_NAME] = String(picked.FROM_SITE_NAME ?? '');
    target[BOD_EXCLUDED_COLUMN.TO_SITE_NAME] = String(picked.TO_SITE_NAME ?? '');
    target[BOD_EXCLUDED_COLUMN.INCOTERMS] = String(picked.INCOTERMS ?? '');
    target[BOD_EXCLUDED_COLUMN.TRANSPORT_MODE] = String(picked.TRANSPORT_MODE ?? '');
    if (!target.CRUD_TYPE) target.CRUD_TYPE = 'M';
    grid.collectionView?.refresh();
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // mount(탭 최초 진입) 1회 컬럼 메타 로드 — initialized 가드로 재실행 방지(SalesSite/Bod 표준).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const canSave = hasButton('SAVE');
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // INSERT/DELETE MNU_BTN_CD 미등록(DB 실측) — 자매 SCP0007 규약대로 update 권한(SAVE)으로 게이트.
    insert: canSave && isEditMode && activeTab === SHEET_INDEX.BOD_EXCLUDED ? handleInsert : false,
    delete: canSave && isEditMode ? handleDelete : false,
    save: canSave ? handleSave : false,
    manual: false,
    upload: false,
  };

  // Edit 버튼 — F2 는 hotkeyConfig 미지원이라 customButton 으로 노출(SwitchLock 토글, L3).
  const customButtons = canSave
    ? [
        {
          label: t(LBL.EDIT, 'Edit'),
          title: t(LBL.EDIT, 'Edit'),
          action: () => setIsEditMode(prev => !prev),
        },
      ]
    : [];

  const divisionId = searchParams.divisionId;
  // 팝업 입력 division. AS-IS btnItemId_Click(cs:1639)은 UIUtils.GetAllDivisionCheckedElectrode(clbDivision)
  // 으로 선택 사업부 + 대응 전극(EE) 사업부를 함께 전달한다. TO-BE 는 division 드롭다운이 EE 를 제외(02 §2.2)
  // 하고 전극 매핑(사업부→전극) 원천이 없어 그대로 재현 불가 — 선택값만 전달한다(04_react-gap.md
  // C-ELECTRODE-DIVISION, 업무 확정 대기).
  const electrodeDivision = divisionId;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <BodItemForm onSearch={handleSearch} onOpenItemSearch={() => setItemSearchOpen(true)} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={rowCountByTab[activeTab] ?? 0}
        excelFileName='BOD Item'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />
      <div className={styles.gridWrapper}>
        <TabWrapper persist activeTabIndex={activeTab} setActiveTabIndex={handleTabChange}>
          <TabItem label={t('LBL01057', '_BOD ITEM')}>
            <BodItemGrid
              gridRef={gridRefs[SHEET_INDEX.BOD_ITEM]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.BOD_ITEM]}
              data={bodItemRows}
              isEditMode={isEditMode}
              divisionId={divisionId}
            />
          </TabItem>
          <TabItem label={t('LBL01058', '_Excluded Item')}>
            <BodExcludedGrid
              gridRef={gridRefs[SHEET_INDEX.BOD_EXCLUDED]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.BOD_EXCLUDED]}
              data={excludedRows}
              isEditMode={isEditMode}
              divisionId={divisionId}
              onItemCellDblClick={(row, rowIndex) => setItemPopup({ open: true, row, rowIndex })}
              onBodCellDblClick={(row, rowIndex) => setBodPopup({ open: true, row, rowIndex })}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* btnItemId 조회조건 Item 검색(다건) */}
      <ItemByDivisionModal
        open={itemSearchOpen}
        modalClose={() => setItemSearchOpen(false)}
        callFromCell={false}
        preSearchParams={{
          divisionId: electrodeDivision,
          scmSite: searchParams.fromSite,
          itemId: searchParams.itemId,
        }}
        setSelectedValue={handleItemSearchSelect}
      />
      {/* Excluded ITEM_ID 셀 더블클릭(단건) */}
      <ItemByDivisionModal
        open={itemPopup.open}
        modalClose={() => setItemPopup({ open: false })}
        callFromCell
        preSearchParams={{
          divisionId: electrodeDivision,
          scmSite: searchParams.fromSite,
          itemId: String(itemPopup.row?.[BOD_EXCLUDED_COLUMN.ITEM_ID] ?? ''),
        }}
        setSelectedValue={handleItemCellSelect}
      />
      {/* Excluded BOD_ID 셀 더블클릭 cascade */}
      <GetBodItemModal
        open={bodPopup.open}
        modalClose={() => setBodPopup({ open: false })}
        preSearchParams={{
          divisionId: String(bodPopup.row?.[BOD_EXCLUDED_COLUMN.DIVISION_ID] ?? divisionId),
          itemId: String(bodPopup.row?.[BOD_EXCLUDED_COLUMN.ITEM_ID] ?? ''),
          planGroup: String(bodPopup.row?.[BOD_EXCLUDED_COLUMN.OPMZ_PLAN_GR_NAME] ?? ''),
        }}
        setSelectedValue={handleBodSelect}
      />
    </>
  );
};
