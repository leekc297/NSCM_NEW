import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useStreamProcQuery,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  BOD_EXCLUDED_COLUMN,
  BOD_ITEM_COLUMN,
  MENU_ID,
  MSG,
  RANGE,
  SHEET_BY_INDEX,
  SHEET_INDEX,
  SHEETS,
} from './bod-item.constants';
import type { BodExcludedRow, BodItemRow, BodPopupRow } from './bod-item.types';
import styles from './BodItem.module.scss';
import { BodExcludedGrid } from './components/BodExcludedGrid';
import { BodItemForm } from './components/BodItemForm';
import { BodItemGrid } from './components/BodItemGrid';
import { GetBodItemModal } from './components/modals/GetBodItemModal';
import { useBodItemStore } from './useBodItemStore';
import { isBlank, toDateOnly, toSelectedCodes, validateExcludedDates } from './utils/bod-item.util';

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
  // 편집모드 상시 활성 — 현 시스템은 Edit 모드가 기본이라 별도 Edit 버튼/토글을 두지 않는다(사용자 지시).
  //   편집 가능 셀은 여전히 화이트리스트(BOD_ITEM_EDITABLE / BOD_EXCLUDED_EDITABLE)로 제한된다.
  const isEditMode = true;
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

  const queryClient = useQueryClient();

  // [E20261015-STREAMPROC] BOD ITEM 은 대량(조건 ALL 28.9만 행)이라 스트리밍 조회 — 첫 묶음(약 1,000행)부터
  //   그리드에 표시하고 나머지는 수신되는 대로 이어 붙인다(전량 대기 50~85초 → 첫 표시 약 3초).
  //   From/To(FROM_YYYYMMDD·TO_YYYYMMDD)는 FPDateText 라 BE 의 datetime 을 date-only 로 정규화(기존과 동일).
  const bodItemStream = useStreamProcQuery<BodItemRow>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_ITEM,
    gridRef: gridRefs[SHEET_INDEX.BOD_ITEM],
    transformRow: row => ({
      ...row,
      [BOD_ITEM_COLUMN.FROM_YYYYMMDD]: toDateOnly(row[BOD_ITEM_COLUMN.FROM_YYYYMMDD]),
      [BOD_ITEM_COLUMN.TO_YYYYMMDD]: toDateOnly(row[BOD_ITEM_COLUMN.TO_YYYYMMDD]),
    }),
    onError: error =>
      void setAlert({ type: 'alert', content: error.message || t('', '_데이터 조회 실패.') }),
  });
  const startBodItemStream = bodItemStream.start;
  const isBodItemStreaming = bodItemStream.isStreaming;
  // Search(=setFilters 가 새 filters 객체를 만듦)마다 재조회 — 기존 useTabProcQuery(filters 참조 변경 시 조회)와 같은 규약.
  const bodItemFilter = filters[SHEETS.BOD_ITEM];
  useEffect(() => {
    if (bodItemFilter) startBodItemStream(bodItemFilter);
  }, [bodItemFilter, startBodItemStream]);

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
    // 기본 onSuccess(탭 쿼리 무효화 + 성공 토스트)와 같고, BOD ITEM 은 스트리밍 조회라 같은 조건으로 다시 받는다.
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      if (bodItemFilter) startBodItemStream(bodItemFilter);
      void setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    },
  });
  const { mutate: mutateExcluded } = useProcMutation<MENU_ID, SHEETS.BOD_EXCLUDED>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD_EXCLUDED,
    tabId,
  });

  // 그리드 재조회·리셋은 Search(새 excludedData/bodItemData 도착)로만 일어난다 — useBodItemStore.
  //   setSearchParams 주석과 동일 규약(자매화면 SCP0007). 조회조건 Division 체크박스를 토글하는
  //   것만으로는(Search 를 누르기 전) 그리드를 건드리지 않는다. 과거 여기 deps 에 섞여 있던
  //   searchParams.divisionId 가 체크 즉시 새 배열 참조를 만들어 DataGrid itemsSource 를
  //   바꿔치기했고, 그 결과 편집·Insert 중인 행이 화면에서 사라졌다(사용자 리포트 2026-10-06).
  // BOD ITEM 행 = 스트리밍 훅이 들고 있는 배열(첫 묶음 이후 같은 배열에 이어 붙임 → 참조 불변, 재바인딩 없음).
  const bodItemRows = bodItemStream.data;
  const excludedRows = useMemo(
    // From/To(BOD_EX_FROM/TO_YYYYMMDD)는 FPDateText 라 BE datetime 을 date-only 로 정규화(마스크·저장 계약 정합).
    () =>
      (excludedData?.o_rc1 ?? []).map(row => ({
        ...row,
        [BOD_EXCLUDED_COLUMN.BOD_EX_FROM_YYYYMMDD]: toDateOnly(
          row[BOD_EXCLUDED_COLUMN.BOD_EX_FROM_YYYYMMDD]
        ),
        [BOD_EXCLUDED_COLUMN.BOD_EX_TO_YYYYMMDD]: toDateOnly(
          row[BOD_EXCLUDED_COLUMN.BOD_EX_TO_YYYYMMDD]
        ),
      })),
    [excludedData]
  );

  const rowCountByTab: Record<number, number> = {
    [SHEET_INDEX.BOD_ITEM]: bodItemStream.loadedCount,
    [SHEET_INDEX.BOD_EXCLUDED]: excludedRows.length,
  };

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // 신규행은 Excluded 시트에서만 추가(bodItem 은 Insert 비활성, L4). 기본값 VALID_YN='Y'.
  // DIVISION_ID: 조회조건 Division 이 단일 선택이면 그 값으로 채우고, 2개 이상(또는 전체/미선택)이면
  //   공백으로 둔다(사용자 지시 2026-09-29) — 대상 division 이 하나로 확정될 때만 미리 채운다.
  // PRE_KEY_VALUES='': SAVE SP(PKG_SCP0030.P_SCP0030_SAVE_BOD_EXCLUDED_ITEM)의 JSON_TABLE 이 ERROR ON ERROR +
  //   PATH '$."PRE_KEY_VALUES"' 라 키가 아예 없으면 ORA-40462 로 실패한다. SP 는 CRUD='I' 를 null 로
  //   정상 처리하므로 값은 공백이면 되고, 키 자체를 심어 준다(기존행은 GET 이 실어 보냄).
  const handleInsert = () => {
    if (activeTab !== SHEET_INDEX.BOD_EXCLUDED) return;
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!grid) return;
    const divisionCodes = toSelectedCodes(searchParams.divisionId);
    const defaultDivision = divisionCodes.length === 1 ? divisionCodes[0] : '';
    GridAction.addRow(grid, {
      [BOD_EXCLUDED_COLUMN.VALID_YN]: 'Y',
      [BOD_EXCLUDED_COLUMN.DIVISION_ID]: defaultDivision,
      [BOD_EXCLUDED_COLUMN.PRE_KEY_VALUES]: '',
    } as Partial<BodExcludedRow>);
  };

  // 삭제 = AS-IS DeleteButton(cs:239-245) 재현.
  //   메인(BOD Item): action != 'I' 면 즉시 return하고, InsertButton(cs:247~)은 본문 전건 주석("insert 없음",
  //     PJ20209642)이라 'I'(신규)행이 생길 수 없다 → 삭제가 구조적으로 불가능하다. 그래서 DELETE 버튼을
  //     BOD Item 탭에서는 노출하지 않는다(Insert 게이트와 동일 — hotkeyConfig delete). handleDelete 는 Excluded 탭에서만 호출된다.
  //   Excluded: 무조건 물리삭제 — 기존행도 CRUD='D' 마킹 → SAVE SP D 브랜치 물리삭제.
  //   removeRow(grid, false): 신규행 제거 + 기존행 'D' 마킹(저장 payload 유지).
  const handleDelete = () => {
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!grid) return;
    GridAction.removeRow(grid, false);
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
    saveWithValidation(dirty, staticColumns[SHEETS.BOD_ITEM], rows => mutateBodItem(rows));
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
    saveWithValidation(dirty, staticColumns[SHEETS.BOD_EXCLUDED], rows => mutateExcluded(rows));
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
  };

  // Excluded ITEM_ID 셀 팝업(MaterialByDivisionModal) 선택 → 그 행 ITEM_ID 채움(03 §3-C value 파생).
  //   AS-IS SCM0002_MaterialByDivisionPopup(cs 셀 더블클릭) 등가 — 공용 모달이 넘기는 첫 인자가 ITEM_ID.
  const handleItemCellSelect = (itemCode: string) => {
    const { row, rowIndex } = itemPopup;
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!row || rowIndex === undefined || !itemCode || !grid) return;
    const target = row as unknown as WijmoRowItem;
    target[BOD_EXCLUDED_COLUMN.ITEM_ID] = itemCode;
    if (!target.CRUD_TYPE) target.CRUD_TYPE = 'M';
    grid.collectionView?.refresh();
  };

  // Excluded BOD_ID 셀 팝업 선택(다건) → cascade 채움(03 §3-C #57-64, AS-IS retList 다건 → 다행).
  //   첫 건은 더블클릭한 행에, 나머지 건은 Division/Item/Valid 를 복제한 신규행으로 추가한다.
  const handleBodSelect = (rows: BodPopupRow[]) => {
    const { row, rowIndex } = bodPopup;
    const grid = gridRefs[SHEET_INDEX.BOD_EXCLUDED].current;
    if (!row || rowIndex === undefined || rows.length === 0 || !grid) return;
    const applyCascade = (dest: WijmoRowItem, picked: BodPopupRow) => {
      dest[BOD_EXCLUDED_COLUMN.BOD_ID] = String(picked.BOD_ID ?? '');
      dest[BOD_EXCLUDED_COLUMN.FROM_SITE_NAME] = String(picked.FROM_SITE_NAME ?? '');
      dest[BOD_EXCLUDED_COLUMN.TO_SITE_NAME] = String(picked.TO_SITE_NAME ?? '');
      dest[BOD_EXCLUDED_COLUMN.INCOTERMS] = String(picked.INCOTERMS ?? '');
      dest[BOD_EXCLUDED_COLUMN.TRANSPORT_MODE] = String(picked.TRANSPORT_MODE ?? '');
    };
    const target = row as unknown as WijmoRowItem;
    applyCascade(target, rows[0]);
    if (!target.CRUD_TYPE) target.CRUD_TYPE = 'M';

    const extras = rows.slice(1).map(picked => {
      const newRow = {
        [BOD_EXCLUDED_COLUMN.DIVISION_ID]: target[BOD_EXCLUDED_COLUMN.DIVISION_ID],
        [BOD_EXCLUDED_COLUMN.ITEM_ID]: target[BOD_EXCLUDED_COLUMN.ITEM_ID],
        [BOD_EXCLUDED_COLUMN.VALID_YN]: target[BOD_EXCLUDED_COLUMN.VALID_YN] ?? 'Y',
        // 신규행이라 PRE_KEY_VALUES 키를 공백으로 심는다(SAVE SP JSON_TABLE ERROR ON ERROR 회피 — handleInsert 주석 참조).
        [BOD_EXCLUDED_COLUMN.PRE_KEY_VALUES]: '',
      } as WijmoRowItem;
      applyCascade(newRow, picked);
      return newRow as unknown as Partial<BodExcludedRow>;
    });
    if (extras.length > 0) GridAction.addRowSet(grid, extras, 'below');
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
    //   편집모드 상시 활성이라 Edit 진입 없이 그대로 노출한다(사용자 지시). INSERT 는 Excluded 시트에서만(L4).
    insert: canSave && activeTab === SHEET_INDEX.BOD_EXCLUDED ? handleInsert : false,
    // DELETE 도 Excluded 전용 — BOD Item 은 Insert 없음 → 신규행 없음 → AS-IS DeleteButton(action!='I' return)상 삭제 불가(cs:239-245).
    delete: canSave && activeTab === SHEET_INDEX.BOD_EXCLUDED ? handleDelete : false,
    // 스트리밍 수신 중(BOD ITEM)에는 데이터가 아직 불완전 → 저장·엑셀을 잠시 막는다(수신 완료 시 자동 복귀).
    save: canSave && !(activeTab === SHEET_INDEX.BOD_ITEM && isBodItemStreaming) ? handleSave : false,
    ...(activeTab === SHEET_INDEX.BOD_ITEM && isBodItemStreaming ? { excel: false } : {}),
    manual: false,
    upload: false,
  };

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
      <BodItemForm
        onSearch={handleSearch}
        onOpenItemSearch={() => setItemSearchOpen(true)}
        showPlanGroup={activeTab === SHEET_INDEX.BOD_EXCLUDED}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={rowCountByTab[activeTab] ?? 0}
        excelFileName='BOD Item'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {activeTab === SHEET_INDEX.BOD_ITEM && isBodItemStreaming && (
        <div className={styles.streamStatus}>
          {t('', '_데이터 수신 중입니다. 표시된 행부터 조회할 수 있으며, 수신이 끝나면 저장·엑셀이 가능합니다. ({0}건)').replace(
            '{0}',
            bodItemStream.loadedCount.toLocaleString()
          )}
        </div>
      )}
      <div className={styles.gridWrapper}>
        <TabWrapper persist activeTabIndex={activeTab} setActiveTabIndex={handleTabChange}>
          <TabItem label='BOD ITEM'>
            <BodItemGrid
              gridRef={gridRefs[SHEET_INDEX.BOD_ITEM]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.BOD_ITEM]}
              data={bodItemRows}
              isEditMode={isEditMode}
              divisionId={divisionId}
            />
          </TabItem>
          <TabItem label='Excluded Item'>
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

      {/* Model/Nickname 조회조건 검색 팝업 — 사용자 지시(2026-09-29): 메1 MaterialByDivisionModal(COM0013)로
          교체 + multiDivision(여러 Division 멀티 선택). 선택 → itemId 채움(멀티 시 ITEM_ID 콤마 결합).
          조회 SP = PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION (P_DIVISION_ID 콤마 split 지원). */}
      <MaterialByDivisionModal
        open={itemSearchOpen}
        modalClose={() => setItemSearchOpen(false)}
        multiDivision
        setSelectedValue={code => setSearchParams({ itemId: code })}
        preSearchParams={{
          divisionId: electrodeDivision,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: searchParams.itemId,
        }}
      />
      {/* Excluded ITEM_ID 셀 더블클릭 — AS-IS SCM0002_MaterialByDivisionPopup → COM0013 공용 팝업
          (PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION, 배포·배선 VALID). 선택 ITEM_ID 를 그 행에 채운다. */}
      <MaterialByDivisionModal
        open={itemPopup.open}
        modalClose={() => setItemPopup({ open: false })}
        setSelectedValue={handleItemCellSelect}
        preSearchParams={{
          divisionId: String(itemPopup.row?.[BOD_EXCLUDED_COLUMN.DIVISION_ID] ?? electrodeDivision),
          scpModuleType: MENU_ID,
          operationGroup: '',
          // AS-IS 등가: 셀의 현재 ITEM_ID 를 Material 검색어로 실어 보내지 않고 공백으로 연다.
          itemId: '',
        }}
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
