import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentLotSizeBatchModal } from './components/modals/ShipmentLotSizeBatchModal';
import { ShipmentLotSizeForm } from './components/ShipmentLotSizeForm';
import { ShipmentLotSizeGrid } from './components/ShipmentLotSizeGrid';
import { useShipmentLotSizeValidation } from './hooks/useShipmentLotSizeValidation';
import { LBL, LOT_SIZE_COLUMNS, MENU_ID, MSG, SHEETS } from './shipment-lot-size.constants';
import type { BatchMode, LotSizePopupRow, ShipmentLotSizeRow } from './shipment-lot-size.types';
import styles from './ShipmentLotSize.module.scss';
import { useShipmentLotSizeStore } from './useShipmentLotSizeStore';
import { buildColumns } from './utils/shipmentLotSize.columns';
import { isDefaultRevertRow } from './utils/shipmentLotSize.derive';
import { type LotSizeSaveRow, submitLotSizeSaveRequest } from './utils/shipmentLotSize.saveRequest';

interface InvalidCell {
  row: Record<string, unknown>;
  column: string;
}

// distinct 콤마 join — GET_INPUT / 삭제 파라미터용(빈값 제외, 중복 제거).
const csvDistinct = (rows: LotSizePopupRow[], field: string): string => {
  const seen = new Set<string>();
  for (const r of rows) {
    const v = safeString((r as Record<string, unknown>)[field]).trim();
    if (v) seen.add(v);
  }
  return [...seen].join(',');
};

// AS-IS GSCM.SCP.Forms.UIL SCP0028_Shipment_Lot_Size — 단일 그리드 마스터 편집 화면(domain SSP/Shipping).
//   설계: .atlas/gscm-design/SCP0028/design/00~03. 상세 매핑: __asis-mapping__.md.
//   버튼 파리티(design 01 §2, iter-2 재정합):
//     - 툴바 Insert = 무동작(R10, AS-IS InsertRow() 빈 구현) — 버튼은 노출, 클릭 시 no-op.
//     - 툴바 Delete = 신규행('I')만 removeRow(R4) — 기존행은 툴바 Delete 로 삭제 불가.
//     - 조회영역 커스텀 버튼 Input/Delete(btnInput/btnDelete) = 일괄입력/삭제 팝업(R5/R6) — 별도 어포던스.
//   편집은 NSCM 상시편집 표준(Edit 토글 미이식, 자매 SSP0025/SCP0005 동형) — INPUT_TP_CD 메타 화이트리스트로
//   4컬럼(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN)만 조회 직후 즉시 편집. hasButton('EDIT')은 권한 판정 전용.
export const ShipmentLotSize = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { validateRows } = useShipmentLotSizeValidation();
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집권한 판정 — 로드 시 1회(토글 아님). EDIT 권한 없으면 그리드 읽기전용, 있으면 4컬럼 조회 후 즉시 편집(G1).
  //   AS-IS Edit 버튼/편집모드 토글은 미이식(NSCM 상시편집 표준, memory editbutton-toggle-not-ported).
  const canEdit = hasButton('EDIT');

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useShipmentLotSizeStore(s => s.searchCondition);
  const setSearchCondition = useShipmentLotSizeStore(s => s.setSearchCondition);
  const filters = useShipmentLotSizeStore(s => s.filters);
  const setFilter = useShipmentLotSizeStore(s => s.setFilter);
  const openSearchArea = useShipmentLotSizeStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentLotSizeStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentLotSizeStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentLotSizeStore(s => s.fetchStaticColumns);
  const clearFilters = useShipmentLotSizeStore(s => s.clearFilters);
  const initialized = useShipmentLotSizeStore(s => s.initialized);

  // 일괄입력 후보(GET_INPUT) 로드 오버레이 — null 이면 메인 조회 결과 표시(design 01 R5).
  //   상시편집 표준(Edit 토글 미이식): 편집모드 state 없음. 편집가부는 컬럼 메타 화이트리스트만 판정.
  const [inputRows, setInputRows] = useState<ShipmentLotSizeRow[] | null>(null);
  const [invalidCells, setInvalidCells] = useState<InvalidCell[]>([]);
  const [itemModalOpen, setItemModalOpen] = useState(false);
  const [batchMode, setBatchMode] = useState<BatchMode | null>(null);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const mainRows = useMemo<ShipmentLotSizeRow[]>(() => data?.o_rc1 ?? [], [data]);
  // 일괄입력 후보가 로드돼 있으면 그리드는 후보를 보여준다(편집모드). 아니면 메인 조회 결과.
  const rows = useMemo<ShipmentLotSizeRow[]>(() => inputRows ?? mainRows, [inputRows, mainRows]);
  // 저장 필수검증용 컬럼셋 — 그리드와 동일하게 admin fetch 성공 시 admin authoritative, 실패/미등록 시 constants
  //   fallback(편집 4컬럼 INPUT_TP_CD='M'·'*' 라벨 방출). staticColumns 를 그대로 넘기면 fetch 실패 시 빈 배열이라
  //   useSaveWithValidation 필수검사가 통째로 건너뛰어진다(sheet-columns 이중경로 함정) — fallback 로 대칭 유지.
  const saveColumns = useMemo(
    () => buildColumns(LOT_SIZE_COLUMNS, staticColumns[SHEETS.MAIN]),
    [staticColumns]
  );

  useEffect(() => {
    // mount 시 filters 초기화 — AS-IS Form_Load 자동조회 없음(design 02 §4). keep-alive 잔존 filters 로
    //   stale 자동조회가 나가지 않게 진입마다 비워 명시 Search 전까지 막는다(nscm-patterns §5-7).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // cascade 상위(Division) 변경 = 하위 reset·콤보 재조회(store/Form) + Grid 비움(store 가 filters clear) +
  //   편집중 상태(신규 후보·CRUD 추적·위반셀) 초기화 — convert-core §5-5 / design 02 §3(G2 해소).
  //   store 가 filters 를 비우면 useTabProcQuery 키가 바뀌어 그리드가 비므로, 여기선 오버레이/추적만 초기화한다.
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    setInputRows(null);
    setInvalidCells([]);
    editTrackerRef.current?.clearChanges();
  }, [sc.divisionId]);

  const handleSearch = () => {
    // 필수 조회조건(design 01 R9) — Division 미선택(권한 0건 R1 포함) 시 조회 차단 + 안내.
    if (!safeString(sc.divisionId).trim()) {
      // MSG00429='{0} value is required.'(등록) — i18next 기본 보간자가 {{ }} 라 {0}은 t() 인자로 안 채워진다.
      //   자매 관례대로 .replace('{0}', 라벨)로 Division 삽입(memory i18n-zero-placeholder-needs-manual-replace).
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_{0} value is required.').replace(
          '{0}',
          t(LBL.DIVISION, 'Division')
        ),
      });
      return;
    }
    setInputRows(null); // 일괄입력 후보 오버레이 해제 — 메인 조회 결과 표시
    setInvalidCells([]);
    setFilter();
    void fetchStaticColumns();
  };

  // 툴바 Delete(design 01 R4) — 신규행('I')만 removeRow. 기존행은 툴바 Delete 로 삭제 불가(active_flag 화면).
  //   조건 미충족(선택행 없음/기존행) 시 GridAction.removeRow(true) 가 조용히 무동작(alert 없음).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid, true);
  };

  const submitSave = async (saveRows: LotSizeSaveRow[], isDelete: boolean) => {
    const result = await submitLotSizeSaveRequest(saveRows, sessionUserId ?? '', isDelete);
    if (!result.ok) {
      setToast({ type: 'error', message: result.message ?? t(MSG.SAVE_FAIL, '_Failed to save.') });
      return false;
    }
    setToast({
      type: 'success',
      message: isDelete
        ? t(MSG.DELETE_SUCCESS, '_Deleted successfully.')
        : t(MSG.SAVE_SUCCESS, '_Saved successfully.'),
    });
    editTrackerRef.current?.clearChanges();
    setInputRows(null);
    void refetch();
    return true;
  };

  // 편집행 → SAVE payload 행 (활성플래그 CRUD_TYPE 기반, 키/편집값 직송).
  const toSaveRow = (r: Record<string, unknown>): LotSizeSaveRow => ({
    activeFlag: r.CRUD_TYPE === 'I' ? 'I' : 'M',
    DIVISION_ID: r.DIVISION_ID,
    OPERATION_GROUP_ID: r.OPERATION_GROUP_ID,
    FROM_SITE: r.FROM_SITE,
    TO_SITE: r.TO_SITE,
    ITEM_ID: r.ITEM_ID,
    TRANS_MODE_CODE: r.TRANS_MODE_CODE,
    LOT_SIZE: r.LOT_SIZE,
    INCREMENT: r.INCREMENT,
    SPLIT_YN: r.SPLIT_YN,
    VALID_YN: r.VALID_YN,
  });

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // 기본값 회귀행(M & LOT=''&INC=''&VALID='Y'&SPLIT='N')은 변경취소로 제외(design 03 §3-13).
    const dirty = src.filter(r => r.CRUD_TYPE && !(r.CRUD_TYPE === 'M' && isDefaultRevertRow(r)));
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No modifications have been made.') });
      return;
    }
    setInvalidCells([]);
    // 저장검증 3종(design 03 §4.3): LOT<INC / 0값 (클라) → 통과 후 메타 필수검증(saveWithValidation) → SAVE.
    const v = validateRows(dirty);
    if (!v.ok) {
      setInvalidCells(v.invalidCells);
      return;
    }
    saveWithValidation(
      dirty as unknown as ShipmentLotSizeRow[],
      saveColumns,
      changed => void submitSave((changed as Record<string, unknown>[]).map(toSaveRow), false)
    );
  };

  // 일괄입력(btnInput, design 01 R5): 팝업 선택 후보 → GET_INPUT 재조회 → 후보행('I') 로드.
  //   상시편집이라 후보 4컬럼은 로드 즉시 편집 가능(AS-IS 자동 EditButton(R3) = 상시편집으로 흡수).
  const handleBatchInputConfirm = async (picked: LotSizePopupRow[]) => {
    setBatchMode(null);
    if (picked.length === 0) return;
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/INSERT/call-proc`,
        {
          divisionId: sc.divisionId,
          operationGroup: csvDistinct(picked, 'OPERATION_GROUP_ID'),
          fromSite: csvDistinct(picked, 'FROM_SITE'),
          toSite: csvDistinct(picked, 'TO_SITE'),
          itemId: csvDistinct(picked, 'ITEM_ID'),
          userId: sessionUserId ?? '',
        }
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Failed to load candidates.') });
        return;
      }
      const result = (res.data?.result ?? {}) as { o_rc1?: ShipmentLotSizeRow[] };
      // CRUD_TYPE 주입(구조 변환)이라 direct cast(as XxxRow[]) 대신 as unknown as 경유(convert-core §2.4).
      const candidates = (result.o_rc1 ?? []).map(r => ({ ...r, CRUD_TYPE: 'I' })) as unknown as ShipmentLotSizeRow[];
      setInputRows(candidates); // 후보 오버레이 로드(상시편집 — 4컬럼 즉시 편집)
    } catch {
      setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Failed to load candidates.') });
    }
  };

  // 일괄삭제(btnDelete, design 01 R6): 팝업 선택 후보 → active_flag='D'(lot/inc 0, valid 'N') SAVE → 재조회.
  //   SAVE SP 'D' 분기 삭제키 실측(ora.py PKG_SCP0028 body): DIVISION_ID/OPERATION_GROUP/FROM_SITE/TO_SITE/
  //   ITEM_ID 5키 — TRANS_MODE_CODE 는 삭제 WHERE 에 없다(G5 해소). POPUP SP O_RC1 이 이 5키를 전건 반환
  //   (실측: DIVISION_ID/OPERATION_GROUP_ID/FROM_SITE/TO_SITE/ITEM_ID)하므로 삭제키 공백 없음.
  const handleBatchDeleteConfirm = (picked: LotSizePopupRow[]) => {
    setBatchMode(null);
    if (picked.length === 0) return;
    const deleteRows: LotSizeSaveRow[] = picked.map(r => {
      const rec = r as Record<string, unknown>;
      return {
        activeFlag: 'D',
        DIVISION_ID: rec.DIVISION_ID,
        OPERATION_GROUP_ID: rec.OPERATION_GROUP_ID,
        FROM_SITE: rec.FROM_SITE,
        TO_SITE: rec.TO_SITE,
        ITEM_ID: rec.ITEM_ID,
        // TRANS_MODE_CODE 는 SAVE 'D' 삭제키가 아니라 POPUP 미반환이어도 무해(SP 가 5키로만 삭제, G5 실측).
        TRANS_MODE_CODE: rec.TRANS_MODE_CODE,
        LOT_SIZE: '0',
        INCREMENT: '0',
        SPLIT_YN: 'N',
        VALID_YN: 'N',
      };
    });
    void submitSave(deleteRows, true);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // Insert = 무동작(R10, AS-IS InsertRow() 빈 구현). 버튼은 노출하되 명시적 no-op — 숨김(false)/키생략 금지.
    //   수기 행추가 없음(신규행 유입은 조회영역 Input 팝업(R5)만). skill §3 hotkeyConfig NO-OP 배선.
    insert: hasButton('INSERT') ? () => undefined : false,
    // Delete = 신규행('I')만 removeRow(R4). 일괄삭제 팝업은 조회영역 커스텀 버튼(btnDelete, R6)이 별도 담당.
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
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
      {openSearchArea && (
        <ShipmentLotSizeForm
          onSearch={handleSearch}
          onItemSearch={() => setItemModalOpen(true)}
          onBatchInput={() => setBatchMode('I')}
          onBatchDelete={() => setBatchMode('D')}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentLotSize'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentLotSizeGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          canEdit={canEdit}
          invalidCells={invalidCells}
          onFocus={() => undefined}
        />
      </div>

      {/* Model(Item) 조회조건 팝업 — 공용 ItemByDivisionModal(SCM0002_ItembyDivisionPopup, design 02 §4.6) */}
      <ItemByDivisionModal
        open={itemModalOpen}
        modalClose={() => setItemModalOpen(false)}
        setSelectedValue={items => setSearchCondition({ itemId: items })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* 일괄입력/삭제 팝업 — SCM0002_ShipmentLotSizePopup (design 01 R5/R6) */}
      <ShipmentLotSizeBatchModal
        open={batchMode !== null}
        mode={batchMode ?? 'I'}
        divisionId={sc.divisionId}
        onClose={() => setBatchMode(null)}
        onConfirm={picked =>
          batchMode === 'D' ? handleBatchDeleteConfirm(picked) : void handleBatchInputConfirm(picked)
        }
      />
    </>
  );
};
