import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ConstraintOfShipmentQtyForm } from './components/ConstraintOfShipmentQtyForm';
import { ConstraintOfShipmentQtyGrid } from './components/ConstraintOfShipmentQtyGrid';
import { MENU_ID, MSG, SHEETS } from './constraint-of-shipment-qty.constants';
import type { ConstraintOfShipmentQtyRow } from './constraint-of-shipment-qty.types';
import { useConstraintOfShipmentQtyValidation } from './hooks/useConstraintOfShipmentQtyValidation';
import { useConstraintOfShipmentQtyStore } from './useConstraintOfShipmentQtyStore';
import { insertDefaults, s } from './utils/constraint-of-shipment-qty.editLock';

// AS-IS GSCM.SCP.Forms.UIL.Master SCP0132_ConstraintOfShipmentQty — 단일 그리드 마스터 CRUD(pivot 없음).
//   설계: .atlas/gscm-design/SCP0132/design/00~03. 상세 매핑: __asis-mapping__.md.
//   TO-BE 공통 결정으로 AS-IS Edit 잠금(SwitchLock/IsLock) 토글은 이식하지 않는다(convert-core §2.4) —
//   조회 직후 그리드가 바로 편집 가능하다. 편집 가능 여부는 canEdit = hasButton('EDIT')(mount 1회
//   권한)로만 갈리고 grid isEditMode prop 은 그 값을 받는다. Division·VAL_TP_CD~PRE_KEY_VALUES 구간
//   항상잠금·신규행 부분편집은 그대로 유효(editLock.isCellEditable).
export const ConstraintOfShipmentQty = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSaveRows } = useConstraintOfShipmentQtyValidation();
  // 필수 컬럼(메타 M/IM) 저장검증 — 전 화면 공통. 이 화면 INPUT_TP_CD 전 'S' 라 필수는 validateSaveRows 가 병행.
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // TO-BE 공통: Edit 모드 토글 미채용 — "누가 편집할 수 있는가"만 이 권한(MNU_BTN_CD='EDIT')이 정한다.
  //   권한이 없으면 grid isEditMode prop 이 false 라 (신규행 외) 전 셀 잠긴다(convert-core §2.4).
  const canEdit = hasButton('EDIT');

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const filters = useConstraintOfShipmentQtyStore(st => st.filters);
  const setFilter = useConstraintOfShipmentQtyStore(st => st.setFilter);
  const clearFilters = useConstraintOfShipmentQtyStore(st => st.clearFilters);
  const openSearchArea = useConstraintOfShipmentQtyStore(st => st.openSearchArea);
  const setOpenSearchArea = useConstraintOfShipmentQtyStore(st => st.setOpenSearchArea);
  const staticColumns = useConstraintOfShipmentQtyStore(st => st.staticColumns);
  const fetchStaticColumns = useConstraintOfShipmentQtyStore(st => st.fetchStaticColumns);
  const initialized = useConstraintOfShipmentQtyStore(st => st.initialized);
  const searchCondition = useConstraintOfShipmentQtyStore(st => st.searchCondition);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo<ConstraintOfShipmentQtyRow[]>(() => data?.o_rc1 ?? [], [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division 필수(design 03 §3.1 #2 필수값 8종에 포함, cascade 트리거이자 GET SP 필수 파라미터).
    if (searchCondition.divisionId === '') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // InsertButton(design 01 §2#5·03 §3 #8 — Insert()+SetValue+LockRange 조합으로 실동작 방향성 확정,
  //   단 사전조건 가드 유무는 미확정). 확정된 조회조건 division 기준 신규행 기본값(design 03 §1 #1각주).
  //   미조회 상태 빈 행 삽입 금지(tact-time SCP0020 실사고 재발 방지) — 조회(filters) 선행 필수.
  const handleInsert = () => {
    if (!canEdit) return;
    const grid = gridRef.current;
    if (!grid) return;
    const f = filters[SHEETS.MAIN];
    if (!f) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    const division = s((f as Record<string, unknown>).divisionId);
    if (division === '' || division.includes(',')) {
      // Division 은 단일 선택(design 02 §1) — 콤마 다중이면 신규행 기본값 확정 불가.
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    GridAction.addRow(grid, insertDefaults(division));
  };

  // 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시.
  //   잠금상태 변화 없음(SwitchLock 은 EditButton 소속으로 정정 귀속, design 01 §5#5).
  const handleDelete = () => {
    if (!canEdit) return;
    const grid = gridRef.current;
    if (!grid) return;
    const selected = grid.selectedItems[0] as Record<string, unknown> | undefined;
    if (!selected) return;
    GridAction.removeRow(grid);
  };

  const handleSave = () => {
    if (!canEdit) return;
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 필수값 8종 + 수량/날짜 게이트(design 03 §3.1) — Item 존재/Sales Site Priority 게이트는 서버(SP)
    //   판정 영역이라 PKG_SCP0132 미배포 상태에선 이 회차 미검증(확인 필요, __asis-mapping__.md).
    if (!validateSaveRows(src).ok) return;
    // 필수 컬럼 메타검증 통과 시 mutate(저장 성공/실패 toast·재조회는 useProcMutation 표준 onSuccess).
    saveWithValidation(
      dirty as unknown as ConstraintOfShipmentQtyRow[],
      staticColumns[SHEETS.MAIN],
      mutate
    );
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
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
      {openSearchArea && <ConstraintOfShipmentQtyForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ConstraintOfShipmentQty'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <ConstraintOfShipmentQtyGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        adminColumns={staticColumns[SHEETS.MAIN]}
        isEditMode={canEdit}
        onFocus={() => undefined}
      />
    </>
  );
};
