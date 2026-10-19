import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useCallback, useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ProjectRouteWarrantyForm } from './components/ProjectRouteWarrantyForm';
import { ProjectRouteWarrantyGrid } from './components/ProjectRouteWarrantyGrid';
import { useProjectRouteWarrantyValidation } from './hooks/useProjectRouteWarrantyValidation';
import {
  INSERT_BLOCKED_OPERATION_GROUPS,
  isSalesSitePopupDivision,
  LBL,
  MENU_ID,
  MSG,
  NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
  NEW_ROW_DEFAULT_PRIORITY,
  NEW_ROW_DEFAULT_PROJECT_CODE,
  NEW_ROW_DEFAULT_SCM_SITE_ID,
  NEW_ROW_DEFAULT_VALID_YN,
  OPERATION_GROUP_WARRANTY,
  RESPONSE_SET,
  SHEETS,
} from './project-route-warranty.constants';
import type { MainRow } from './project-route-warranty.types';
import { useProjectRouteWarrantyStore } from './useProjectRouteWarrantyStore';
import { submitWarrantySaveRequest } from './utils/projectRouteWarranty.saveRequest';

export const ProjectRouteWarranty = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);

  const gridRef = useRef<FlexGrid<MainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<MainRow>>();

  const initialized = useProjectRouteWarrantyStore(s => s.initialized);
  const filters = useProjectRouteWarrantyStore(s => s.filters);
  const searchParams = useProjectRouteWarrantyStore(s => s.searchParams);
  const staticColumns = useProjectRouteWarrantyStore(s => s.staticColumns);
  const openSearchArea = useProjectRouteWarrantyStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRouteWarrantyStore(s => s.setOpenSearchArea);
  const setFilters = useProjectRouteWarrantyStore(s => s.setFilters);
  const fetchStaticColumns = useProjectRouteWarrantyStore(s => s.fetchStaticColumns);
  const reset = useProjectRouteWarrantyStore(s => s.reset);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateWarrantySave } = useProjectRouteWarrantyValidation();
  const { saveWithValidation } = useSaveWithValidation();

  // Edit 토글(design/03 R-L1) — 기본 조회상태는 전잠금, Edit 버튼으로 전행 편집 on/off.
  const [editMode, setEditMode] = useState(false);

  // ITEM_ID / Sales Site 셀 팝업(R-D6/R-D8). 어느 행·어느 용도로 열렸는지 추적한다.
  //   AS-IS 는 두 셀 모두 같은 팝업(SCP0048_ItembyDivisionPopupEx = COM0008)을 열되 되돌려 받는
  //   컬럼만 다르다(ITEM_ID vs SCM_SITE_ID+PROJECT_CODE). 그래서 모달은 1개, mode 로 write-back 을 가른다.
  const [popupTarget, setPopupTarget] = useState<{
    row: MainRow;
    mode: 'item' | 'salesSite';
  } | null>(null);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const mainRows = mainData?.[RESPONSE_SET.MAIN] ?? [];

  // mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Search(F5) — filters 커밋 + 컬럼 메타 재조회. 조회 후 Edit 모드는 해제(R-L4 조회직후 잠금).
  const handleSearch = useCallback(() => {
    setFilters();
    void fetchStaticColumns();
    setEditMode(false);
  }, [setFilters, fetchStaticColumns]);

  // Edit(design/03 §3.5 R-G2) — 조회 데이터 없으면 차단(MSG.EDIT_NO_DATA=MSG00662), 있으면 편집 토글 on.
  const handleEditToggle = () => {
    if (editMode) {
      setEditMode(false);
      return;
    }
    if (mainRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.EDIT_NO_DATA, '_조회 후 수정모드로 가능합니다.') });
      return;
    }
    setEditMode(true);
  };

  // Insert(design/03 §4.1) — Warranty 화면이라 opGroup∈{P,A} 신규행은 무언 차단(Insert 가드).
  //   신규행 기본값 세팅. DIVISION_ID 는 조회조건 division(len!=2 → "")으로 채운다.
  const handleInsert = () => {
    if (!editMode) return;
    const blocked: readonly string[] = INSERT_BLOCKED_OPERATION_GROUPS;
    if (blocked.includes(searchParams.operationGroup)) return;
    const grid = gridRef.current;
    if (!grid) return;
    const div = searchParams.divisionId.length === 2 ? searchParams.divisionId : '';
    GridAction.addRow(grid, {
      DIVISION_ID: div,
      OPERATION_GROUP: OPERATION_GROUP_WARRANTY,
      OPERATION_GROUP_NAME: NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
      VALID_YN: NEW_ROW_DEFAULT_VALID_YN,
      SCM_SITE_ID: NEW_ROW_DEFAULT_SCM_SITE_ID,
      PROJECT_CODE: NEW_ROW_DEFAULT_PROJECT_CODE,
      PRIORITY: NEW_ROW_DEFAULT_PRIORITY,
    });
  };

  // Delete(design/03 R-G1) — 신규행('I')만 removeRow. 기존행은 무반응(alert 없음).
  const handleDelete = () => {
    const grid = gridRef.current;
    const sel = grid?.selectedItems?.[0] as MainRow | undefined;
    if (!grid || !sel || sel.CRUD_TYPE !== 'I') return;
    GridAction.removeRow(grid);
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3.4). dataItem 참조로 식별해 grid.formatItem 이 스크롤·
  //   재도색 때마다 다시 칠하도록 상태로 보관한다(뷰행 index DOM 직접칠은 스크롤 시 재활용돼 어긋난다).
  const [invalidCells, setInvalidCells] = useState<{ row: MainRow; column: string }[]>([]);

  // 실제 SAVE 호출(payload 조립 + false-success 판별). saveWithValidation 메타 필수검증 통과 후 호출.
  const submitSave = async (changed: MainRow[]) => {
    const result = await submitWarrantySaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({
        type: 'alert',
        content: result.message ?? t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
    editTrackerRef.current?.clearChanges();
    handleSearch();
  };

  // Save(design/03 §4.3) — 검증 N1~N11 통과 후 ^-delim CLOB SAVE. 공통 saveWithValidation 로
  //   메타 필수(INPUT_TP_CD) 는 SCP0048 전건 'S' 라 커스텀 N1~N11 이 주 검증(design/03 §6-2).
  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as MainRow[];
    const changed = source.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    const v = validateWarrantySave(source);
    if (!v.ok) {
      setInvalidCells(v.invalidCells);
      // N8-a(FROM/TO 공백)는 AS-IS 가 메시지 없이 조용히 저장을 막는 분기 — alert 생략.
      if (!v.silent) {
        void setAlert({ type: 'alert', content: t(v.msgId ?? MSG.SAVE_ERROR, '_저장 검증 실패') });
      }
      return;
    }
    // 검증 통과 → 이전 하이라이트 제거.
    setInvalidCells([]);

    saveWithValidation(changed, staticColumns[RESPONSE_SET.MAIN], rows => void submitSave(rows));
  };

  // Reset Condition(F10) — 공용 동작(검색조건 삭제 + store initState). SCP0048 은 보존할 기간
  //   조건이 없어 기본 reset 을 그대로 쓴다.
  const handleResetCondition = () => {
    void (async () => {
      if (
        await setAlert({
          type: 'confirm',
          content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
        })
      ) {
        await GridAction.resetPersonalizedCondition(MENU_ID).then(() => {
          void setAlert({ type: 'alert', content: t('MSG00011', '_검색조건이 초기화 되었습니다.') });
          reset();
        });
      }
    })();
  };

  const handleExcelDownload = () => {
    const grid = gridRef.current;
    if (!grid) return;
    void GridAction.excelDownload(grid, 'ProjectRouteWarranty', setProgress);
  };

  // ITEM_ID 셀 더블클릭 → Item 팝업(R-D8). division 공백이면 MSG00093(R-G4).
  const handleItemCellDblClick = (row: MainRow) => {
    if (!String(row.DIVISION_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
      });
      return;
    }
    setPopupTarget({ row, mode: 'item' });
  };

  // div=81 SCM_SITE_ID/PROJECT_CODE 셀 더블클릭 → SalesSite 팝업(R-D6). AS-IS(cs:760-793)는 신규행
  //   (action=='I')·division=='81' 에서 SCP0048_ItembyDivisionPopupEx 를 열어 SCM_SITE_ID/PROJECT_CODE
  //   를 되돌려 받는다. Ex 팝업은 COM0008 백엔드라 base ItemByDivisionModal 을 mode='salesSite' 로 재사용한다.
  const handleSalesSiteCellDblClick = (row: MainRow) => {
    if (!isSalesSitePopupDivision(String(row.DIVISION_ID ?? ''))) return;
    if (!String(row.DIVISION_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
      });
      return;
    }
    setPopupTarget({ row, mode: 'salesSite' });
  };

  // ITEM_ID 팝업 확정 — 선택 품번을 해당 행에 반영(.toUpperCase). NICK_NAME(R-D2)은 팝업이 실어 준
  //   nickName 을 즉시 반영한다(AS-IS 는 선택 즉시 화면 표시). 저장 SP 도 FN_GET_ITEM_NICKNAME 로
  //   재계산하지만, 화면 표시 지연을 없애기 위해 클라에서도 파생한다.
  const handleItemSelected = (itemId: string, nickName?: string) => {
    const target = popupTarget;
    setPopupTarget(null);
    const grid = gridRef.current;
    if (!target || target.mode !== 'item' || !grid) return;
    const row = target.row;
    const rec = row as Record<string, unknown>;
    const next = itemId.toUpperCase();
    editTrackerRef.current?.storeChange(row, 'ITEM_ID', rec.ITEM_ID as string, next);
    rec.ITEM_ID = next;
    if (nickName !== undefined) {
      editTrackerRef.current?.storeChange(row, 'NICK_NAME', rec.NICK_NAME as string, nickName);
      rec.NICK_NAME = nickName;
    }
    grid.collectionView?.refresh();
  };

  // Sales Site 팝업 확정(div=81) — AS-IS(cs:788-789) siMain.SetText(SCM_SITE_ID, popItem.ScmSiteId)
  //   + SetText(PROJECT_CODE, popItem.Project). 두 셀을 한 번에 반영한다.
  const handleSalesSiteSelected = (scmSiteId?: string, projectCode?: string) => {
    const target = popupTarget;
    setPopupTarget(null);
    const grid = gridRef.current;
    if (!target || target.mode !== 'salesSite' || !grid) return;
    const row = target.row;
    const rec = row as Record<string, unknown>;
    if (scmSiteId !== undefined) {
      editTrackerRef.current?.storeChange(row, 'SCM_SITE_ID', rec.SCM_SITE_ID as string, scmSiteId);
      rec.SCM_SITE_ID = scmSiteId;
    }
    if (projectCode !== undefined) {
      editTrackerRef.current?.storeChange(
        row,
        'PROJECT_CODE',
        rec.PROJECT_CODE as string,
        projectCode
      );
      rec.PROJECT_CODE = projectCode;
    }
    grid.collectionView?.refresh();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    resetCondition: handleResetCondition,
    excel: handleExcelDownload,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <ProjectRouteWarrantyForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ProjectRouteWarranty'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          // Edit 토글(design/03 R-L1) — 자매 SCP0006 엔 없는 SCP0048 고유 버튼.
          //   전사 공통 등록코드 사용: LBL00414=Edit/수정, LBL00394=Cancel/취소(3언어 등록, G-7).
          {
            label: editMode ? t(LBL.CANCEL, '_Cancel') : t(LBL.EDIT, '_Edit'),
            action: handleEditToggle,
          },
        ]}
      />
      <ProjectRouteWarrantyGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={mainRows}
        staticColumns={staticColumns[RESPONSE_SET.MAIN]}
        divisionId={searchParams.divisionId}
        editMode={editMode}
        invalidCells={invalidCells}
        onItemCellDblClick={handleItemCellDblClick}
        onSalesSiteCellDblClick={handleSalesSiteCellDblClick}
      />

      {/* ITEM_ID / Sales Site 셀 팝업 — base ItemByDivisionModal(COM0008). AS-IS Ex 팝업과 동일 백엔드.
          mode 로 write-back 컬럼을 가른다: item→ITEM_ID(+NICK_NAME), salesSite→SCM_SITE_ID+PROJECT_CODE. */}
      <ItemByDivisionModal
        open={popupTarget !== null}
        modalClose={() => setPopupTarget(null)}
        setSelectedValue={(items, _n, _c, _t, nickName, _d, _dn, _ec, scmSiteId, projectCode) => {
          if (popupTarget?.mode === 'salesSite') handleSalesSiteSelected(scmSiteId, projectCode);
          else handleItemSelected(items, nickName);
        }}
        preSearchParams={{
          divisionId: String(popupTarget?.row.DIVISION_ID ?? ''),
          // Sales Site 호출은 AS-IS(cs:786)처럼 행의 SCM_SITE_ID/PROJECT_CODE(하이픈 제거)·ITEM_ID 를 실어 좁힌다.
          salesSite:
            popupTarget?.mode === 'salesSite'
              ? String(popupTarget.row.SCM_SITE_ID ?? '').replace(/-/g, '') || undefined
              : undefined,
          projectCode:
            popupTarget?.mode === 'salesSite'
              ? String(popupTarget.row.PROJECT_CODE ?? '').replace(/-/g, '') || undefined
              : undefined,
          itemId: String(popupTarget?.row.ITEM_ID ?? ''),
        }}
        callFromCell
      />
    </>
  );
};
