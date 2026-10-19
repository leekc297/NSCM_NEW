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

import { ProjectRouteElectrodeForm } from './components/ProjectRouteElectrodeForm';
import { ProjectRouteElectrodeGrid } from './components/ProjectRouteElectrodeGrid';
import { useProjectRouteElectrodeValidation } from './hooks/useProjectRouteElectrodeValidation';
import {
  INSERT_BLOCKED_OPERATION_GROUPS,
  MENU_ID,
  MSG,
  NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
  NEW_ROW_DEFAULT_PROJECT_CODE,
  NEW_ROW_DEFAULT_SCM_SITE_ID,
  NEW_ROW_DEFAULT_VALID_YN,
  OPERATION_GROUP_ELECTRODE,
  RESPONSE_SET,
  SHEETS,
} from './project-route-electrode.constants';
import type { MainRow } from './project-route-electrode.types';
import { useProjectRouteElectrodeStore } from './useProjectRouteElectrodeStore';
import { submitElectrodeSaveRequest } from './utils/projectRouteElectrode.saveRequest';

export const ProjectRouteElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore.getState();
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);

  const gridRef = useRef<FlexGrid<MainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<MainRow>>();

  const initialized = useProjectRouteElectrodeStore(s => s.initialized);
  const filters = useProjectRouteElectrodeStore(s => s.filters);
  const searchParams = useProjectRouteElectrodeStore(s => s.searchParams);
  const staticColumns = useProjectRouteElectrodeStore(s => s.staticColumns);
  const openSearchArea = useProjectRouteElectrodeStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRouteElectrodeStore(s => s.setOpenSearchArea);
  const setFilters = useProjectRouteElectrodeStore(s => s.setFilters);
  const fetchStaticColumns = useProjectRouteElectrodeStore(s => s.fetchStaticColumns);
  const reset = useProjectRouteElectrodeStore(s => s.reset);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateElectrodeSave } = useProjectRouteElectrodeValidation();
  const { saveWithValidation } = useSaveWithValidation();

  // 편집 권한 — mount 1회 판정(convert-core §2.4 / 선례 SCP0120·SSP0025). AS-IS Edit 잠금 토글은
  //   미채용: 권한 있으면 조회 직후 바로 편집 가능, 없으면 읽기전용. Edit 버튼 자체를 없앤다.
  const canEdit = hasButton('EDIT');

  // ITEM_ID 셀 팝업(R-DBLCLICK) — ElectrodeItembyDivisionPopup. 어느 행에서 열렸는지 추적한다.
  //   전극 전용 화면이라 SalesSite(div=81) 셀 팝업은 없다(자매 SCP0048 과 다른 지점).
  const [popupRow, setPopupRow] = useState<MainRow | null>(null);

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

  // Search(F5) — filters 커밋 + 컬럼 메타 재조회. (편집모드 토글 미채용이라 조회 후 해제 단계 없음.)
  const handleSearch = useCallback(() => {
    setFilters();
    void fetchStaticColumns();
  }, [setFilters, fetchStaticColumns]);

  // Insert(design/01 §2.4 R-INS) — 전극 전용 화면이라 opGroup∈{P,A} 신규행은 무언 차단(Insert 가드).
  //   신규행 기본값 6종. DIVISION_ID 는 조회조건 division(len!=2 → "")으로 채운다. PRIORITY 기본값 없음.
  const handleInsert = () => {
    if (!canEdit) return;
    const blocked: readonly string[] = INSERT_BLOCKED_OPERATION_GROUPS;
    if (blocked.includes(searchParams.operationGroup)) return;
    const grid = gridRef.current;
    if (!grid) return;
    const div = searchParams.divisionId.length === 2 ? searchParams.divisionId : '';
    GridAction.addRow(grid, {
      DIVISION_ID: div,
      OPERATION_GROUP: OPERATION_GROUP_ELECTRODE,
      OPERATION_GROUP_NAME: NEW_ROW_DEFAULT_OPERATION_GROUP_NAME,
      VALID_YN: NEW_ROW_DEFAULT_VALID_YN,
      SCM_SITE_ID: NEW_ROW_DEFAULT_SCM_SITE_ID,
      PROJECT_CODE: NEW_ROW_DEFAULT_PROJECT_CODE,
    });
  };

  // Delete(design/01 §2.5 R-DEL) — 신규행('I')만 removeRow. 기존행은 무반응(alert 없음).
  const handleDelete = () => {
    const grid = gridRef.current;
    const sel = grid?.selectedItems?.[0] as MainRow | undefined;
    if (!grid || !sel || sel.CRUD_TYPE !== 'I') return;
    GridAction.removeRow(grid);
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3-4). dataItem 참조로 식별해 grid.formatItem 이 스크롤·
  //   재도색 때마다 다시 칠하도록 상태로 보관한다(뷰행 index DOM 직접칠은 스크롤 시 재활용돼 어긋난다).
  const [invalidCells, setInvalidCells] = useState<{ row: MainRow; column: string }[]>([]);

  // 실제 SAVE 호출(payload 조립 + false-success 판별). saveWithValidation 메타 필수검증 통과 후 호출.
  const submitSave = async (changed: MainRow[]) => {
    const result = await submitElectrodeSaveRequest(changed, sessionUserId ?? '');
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

  // Save(design/03 §4) — 검증 N0~N9 통과 후 ^-delim CLOB SAVE. 공통 saveWithValidation 로 메타 필수
  //   (INPUT_TP_CD) 는 SCP0027 전건 'S' 라 커스텀 N0~N9 이 주 검증(design/03 §5).
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

    // N1~N6(중첩·연속성)·N9 는 같은 그룹의 기존행까지 함께 봐야 AS-IS SaveData 와 동치이므로
    //   변경행이 아니라 전체 source 를 넘긴다(내부에서 VALID_YN='Y' 로 좁힌다). 자매 SCP0048 동일.
    const v = validateElectrodeSave(source);
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

  // Reset Condition(F10) — 공용 동작(검색조건 삭제 + store initState). 보존할 기간조건이 없어 기본 reset.
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
    void GridAction.excelDownload(grid, 'ProjectRouteElectrode', setProgress);
  };

  // ITEM_ID 셀 더블클릭 → ElectrodeItembyDivisionPopup(R-DBLCLICK). division 공백이면 MSG(R-FIND).
  const handleItemCellDblClick = (row: MainRow) => {
    if (!String(row.DIVISION_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
      });
      return;
    }
    setPopupRow(row);
  };

  // ITEM_ID 팝업 확정 — 선택 품번을 해당 행에 반영(.toUpperCase). NICK_NAME(R-ITEM-NICK)은 팝업이
  //   실어 준 nickName 을 즉시 반영한다(AS-IS 는 선택 즉시 화면 표시). DIVISION_ID 도 팝업 반환
  //   division 으로 세팅(R-DBLCLICK, cs:728~730). 저장 SP 도 FN_GET_ITEM_NICKNAME 로 재계산하지만
  //   화면 표시 지연을 없애기 위해 클라에서도 파생한다.
  const handleItemSelected = (itemId: string, nickName?: string) => {
    const row = popupRow;
    setPopupRow(null);
    const grid = gridRef.current;
    if (!row || !grid) return;
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

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: canEdit && hasButton('INSERT') ? handleInsert : false,
    save: canEdit && hasButton('SAVE') ? handleSave : false,
    delete: canEdit && hasButton('DELETE') ? handleDelete : false,
    resetCondition: handleResetCondition,
    excel: hasButton('EXCEL') ? handleExcelDownload : false,
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
      {openSearchArea && <ProjectRouteElectrodeForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ProjectRouteElectrode'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <ProjectRouteElectrodeGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={mainRows}
        staticColumns={staticColumns[RESPONSE_SET.MAIN]}
        divisionId={searchParams.divisionId}
        editMode={canEdit}
        invalidCells={invalidCells}
        onItemCellDblClick={handleItemCellDblClick}
      />

      {/* ITEM_ID 셀 팝업 — SCM0002_ElectrodeItembyDivisionPopup(base ItemByDivisionModal 재사용).
          되돌림: ITEM_ID(+NICK_NAME) + DIVISION_ID. 전극 아이템만 좁혀 조회(preSearchParams 로 행 컨텍스트 전달). */}
      <ItemByDivisionModal
        open={popupRow !== null}
        modalClose={() => setPopupRow(null)}
        setSelectedValue={(items, _n, _c, _t, nickName) => handleItemSelected(items, nickName)}
        preSearchParams={{
          divisionId: String(popupRow?.DIVISION_ID ?? ''),
          itemId: String(popupRow?.ITEM_ID ?? ''),
        }}
        callFromCell
      />
    </>
  );
};
