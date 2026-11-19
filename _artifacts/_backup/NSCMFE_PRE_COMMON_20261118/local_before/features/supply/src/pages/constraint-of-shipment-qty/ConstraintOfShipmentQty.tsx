import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ConstraintOfShipmentQtyForm } from './components/ConstraintOfShipmentQtyForm';
import { ConstraintOfShipmentQtyGrid } from './components/ConstraintOfShipmentQtyGrid';
import { MENU_ID, MSG, SHEETS } from './constraint-of-shipment-qty.constants';
import type { ConstraintOfShipmentQtyRow } from './constraint-of-shipment-qty.types';
import { useConstraintOfShipmentQtyValidation } from './hooks/useConstraintOfShipmentQtyValidation';
import { useConstraintOfShipmentQtyStore } from './useConstraintOfShipmentQtyStore';
import { insertDefaults, s } from './utils/constraint-of-shipment-qty.editLock';
import { submitConstraintOfShipmentQtySave } from './utils/constraintOfShipmentQtySaveRequest';

// AS-IS GSCM.SCP.Forms.UIL.Master SCP0132_ConstraintOfShipmentQty — 단일 그리드 마스터 CRUD(pivot 없음).
//   설계: .atlas/gscm-design/SCP0132/design/00~03. 상세 매핑: __asis-mapping__.md.
//   TO-BE 공통 결정으로 AS-IS Edit 잠금(SwitchLock/IsLock) 토글은 이식하지 않는다(convert-core §2.4) —
//   조회 직후 그리드가 바로 편집 가능하다. 편집 가능 여부는 canEdit = hasButton('EDIT')(mount 1회
//   권한)로만 갈리고 grid isEditMode prop 은 그 값을 받는다. Division·VAL_TP_CD~PRE_KEY_VALUES 구간
//   항상잠금·신규행 부분편집은 그대로 유효(editLock.isCellEditable).
//   저장: SAVE SP 24개 IN 이 전부 CLOB 이라 공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼
//   조용히 no-op 된다(저장 토스트는 뜨는데 DB 미반영) — 전용 조립 util 로 ^-fold payload 를 직접 POST
//   한다(submitConstraintOfShipmentQtySave, 자매 SCP0127/SCP0006/SCP0011 정본 패턴).
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
  const restoreSearchConditions = useConstraintOfShipmentQtyStore(st => st.restoreSearchConditions);
  const setDefaultPeriod = useConstraintOfShipmentQtyStore(st => st.setDefaultPeriod);
  const initialized = useConstraintOfShipmentQtyStore(st => st.initialized);
  const searchCondition = useConstraintOfShipmentQtyStore(st => st.searchCondition);

  const sessionUserId = useSessionStore(st => st.session.userId);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<ConstraintOfShipmentQtyRow[]>(() => data?.o_rc1 ?? [], [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  //   F6 저장 조회조건 복원도 mount 1회(conditionsRestored 가드). 새로고침 시 새 store → 재복원.
  //   Period 기본값(AS-IS setPeriod)은 복원이 끝난 뒤 적용해야 복원값을 덮지 않는다(비어 있을 때만 채움).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    void restoreSearchConditions().finally(setDefaultPeriod);
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

  // InsertButton(design 01 §2#5·03 §3 #8 — Insert()+SetValue+LockRange 조합으로 실동작 방향성 확정).
  //   AS-IS Insert_Row(.cs:556~574) 는 조회 선행 가드가 없다 — IsLock==false 면 바로 삽입하고
  //   division 은 그 시점 cboDivision 값(신규행 기본값)으로 읽는다. 사용자 결정(2026-10-13): AS-IS 파리티로
  //   조회(filters) 완료 여부와 무관하게 조회조건 division(searchCondition)만 단일 선택돼 있으면 행추가 허용.
  const handleInsert = () => {
    if (!canEdit) return;
    const grid = gridRef.current;
    if (!grid) return;
    const division = s(searchCondition.divisionId);
    if (division === '' || division.includes(',')) {
      // Division 은 단일 선택(design 02 §1) — 미선택/콤마 다중이면 신규행 기본값 확정 불가.
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

  // 조립된 ^-fold payload 를 SAVE call-proc 로 직접 보내고 결과를 판정한다. SAVE SP 의 24개 IN 은 전부
  //   CLOB(JVARCHAR 아님)이라 공용 useProcMutation({data:[rows]}) 로는 BE 가 top-level camelCase 키를
  //   못 찾아 전부 null 바인딩 → 루프 0회 → SUCCESS 반환하나 DB 미반영(조용한 no-op)이었다. 전용
  //   조립 util 로 보내야 실제 저장된다(utils/constraintOfShipmentQtySaveRequest.ts).
  const submitSave = async (dirtyRows: ConstraintOfShipmentQtyRow[]) => {
    const result = await submitConstraintOfShipmentQtySave(
      dirtyRows,
      editTrackerRef.current,
      sessionUserId ?? ''
    );
    if (!result.ok) {
      void setAlert({
        type: 'alert',
        content: result.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
      return;
    }
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    editTrackerRef.current?.clearChanges();
    void refetch();
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
    //   판정 영역이라 이 회차 미검증(확인 필요, __asis-mapping__.md).
    const vr = validateSaveRows(src);
    if (!vr.ok) return;
    // 필수 컬럼 메타검증 통과 시 전용 submitSave 로 라우팅(공용 mutate 는 CLOB no-op 이라 미사용).
    saveWithValidation(
      dirty as unknown as ConstraintOfShipmentQtyRow[],
      staticColumns[SHEETS.MAIN],
      rows => void submitSave(rows as unknown as ConstraintOfShipmentQtyRow[])
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
