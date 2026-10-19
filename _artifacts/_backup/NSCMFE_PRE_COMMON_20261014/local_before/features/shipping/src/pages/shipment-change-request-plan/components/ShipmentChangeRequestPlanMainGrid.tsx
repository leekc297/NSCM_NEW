import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type {
  EndCustomerKeys,
  TransModeKeys,
} from '../hooks/useShipmentChangeRequestPlanCellCombos';
import { isShipmentDateBelowBase } from '../hooks/useShipmentChangeRequestPlanValidation';
import {
  CHANGE_REQ_NO_POPUP_COLUMN,
  COLUMN,
  ITEM_POPUP_COLUMN,
  MENU_ID,
  MSG,
  PROJECT_POPUP_COLUMN,
  SO_NO_POPUP_COLUMN,
  SO_PROPAGATE_IGNORE_SINGLE_COLUMNS,
  SO_PROPAGATE_STATUS_COLUMNS,
  SO_PROPAGATE_VALUE_COLUMNS,
} from '../shipment-change-request-plan.constants';
import type { MainRow } from '../shipment-change-request-plan.types';
import { isEndCustomerDivision } from '../utils/shipmentChangeRequestPlanColumns';
import {
  applyChangeReasonCode,
  clearBodDerived,
  EDIT_MAIN_TRIGGER_COLUMNS,
  incotermsPrerequisiteMissing,
  isReasonCodeMissing,
  markPropagated,
  propagateChangeReason,
  qtyScaleOf,
  setEditMain,
  shipmentDateDerivedOf,
  soGroupRows,
  str,
  trackedWriter,
  transportModePrerequisiteMissing,
  writeShipmentDateDerived,
  type CellWriter,
  type GridRowData,
} from '../utils/shipmentChangeRequestPlanDerive';
import {
  isErpConfirmed,
  isInsertedRow,
  isRowEditable,
} from '../utils/shipmentChangeRequestPlanEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  singleProcess: boolean;
  /** 화면 오픈 시 1회 결정되는 권한(편집모드 기본 ON — 모드토글 미이식, convert-core §2.4). */
  canEdit: boolean;
  /**
   * 파생 완료된 컬럼셋. 페이지가 만들어 내려준다 — 그리드 로컬 useMemo 로 두면 같은 컬럼셋이
   * `useSaveWithValidation` 에 닿지 않아 숨긴 필수컬럼까지 검증 대상이 된다
   * (메모리 dynamic-collbl-required-never-reaches-savevalidation 의 역방향).
   */
  columns: RawFlexGridColumnConfig[];
  /** 화면 주입 dataMap — 컬럼ID -> 후보행(§1.3 D-1/D-2 해소). */
  dataMaps: Record<string, ComboResponse[] | undefined>;
  /** CHANGE_REQ_DAY 기준일수(음수). undefined 면 출하일 하한 검증을 수행하지 않는다. */
  changeReqDay?: number;
  loadTransMode: (keys: TransModeKeys) => Promise<void>;
  loadEndCustomer: (keys: EndCustomerKeys) => Promise<ComboResponse[] | undefined>;
  isTransModeLoaded: (keys: TransModeKeys) => boolean;
  onPopupCellDblClick: (row: GridRowData, binding: string) => void;
  onDrillDown: (row: GridRowData, binding: string) => void;
  onBlocked: (msgId: string, defaultText: string, arg?: string) => void;
}

const POPUP_COLUMNS = new Set<string>([ITEM_POPUP_COLUMN, PROJECT_POPUP_COLUMN]);
const DRILLDOWN_COLUMNS = new Set<string>([CHANGE_REQ_NO_POPUP_COLUMN, SO_NO_POPUP_COLUMN]);
// 동일 SO 전파 트리거 2종 — 값까지 전파 / 행상태만 전파(design 03 §3.2 R-20·R-21·R-22·R-24).
const VALUE_PROPAGATION = new Set<string>(SO_PROPAGATE_VALUE_COLUMNS);
const STATUS_PROPAGATION = new Set<string>(SO_PROPAGATE_STATUS_COLUMNS);
// chkSingleProcess 를 보지 않는 경로(AS-IS SpdMain_ComboSelChange 에 체크박스 조건이 없다).
const IGNORE_SINGLE_PROCESS = new Set<string>(SO_PROPAGATE_IGNORE_SINGLE_COLUMNS);

/**
 * TransMode 후보 조회 키 — 신규행은 Description 열, 기존행은 코드 열을 쓴다(AS-IS cs:5449~5455
 *   `if (action != "I")` 분기 그대로). 두 축을 섞으면 후보가 조용히 0행이 된다.
 */
const transModeKeysOf = (row: GridRowData): TransModeKeys => {
  const inserted = isInsertedRow(row);
  return {
    divisionId: str(row[COLUMN.DIVISION_ID]),
    fromSite: str(row[inserted ? COLUMN.FROM_SITE_DESCRIPTION : COLUMN.FROM_SITE]),
    toSite: str(row[inserted ? COLUMN.TO_SITE_DESCRIPTION : COLUMN.TO_SITE]),
    incoterms: str(row[COLUMN.INCOTERMS]),
  };
};

/** EndCustomer 후보 조회 키 — AS-IS setEndCustomer(cs:6650)는 항상 Description 열을 쓴다. */
const endCustomerKeysOf = (row: GridRowData): EndCustomerKeys => ({
  divisionId: str(row[COLUMN.DIVISION_ID]),
  scmSiteId: str(row[COLUMN.TO_SITE_DESCRIPTION]),
  itemId: str(row[COLUMN.ITEM_ID]),
});

/**
 * spdMain "Shipment Change Request" (메타 68열 / display=Y 44열, frozen 경계 = SHIPMENT_STATUS).
 *   display='N' 24열은 컬럼을 만들지 않고 row 객체로만 읽는다(CP-17).
 *   열 단위 잠금의 원천은 INPUT_TP_CD 메타다 — 여기서는 행 조건만 건다(hook #130).
 */
export const ShipmentChangeRequestPlanMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  singleProcess,
  canEdit,
  columns,
  dataMaps,
  changeReqDay,
  loadTransMode,
  loadEndCustomer,
  isTransModeLoaded,
  onPopupCellDblClick,
  onDrillDown,
  onBlocked,
}: Props) => {
  // 그리드 단위 콤보 파라미터. 인용은 화면이 아니라 getCombo 가 처리한다 —
  //   `quoteComboParams` 가 mnuId 의 겉 홑따옴표를 벗겨 raw 로 통일하므로 여기서 감싸면 표기만 갈린다.
  //   조회조건 쪽(`ShipmentChangeRequestPlanForm.tsx`)과 같은 raw 표기로 맞춘다(설계 §6.1).
  const comboParams = useMemo(() => ({ mnuId: MENU_ID }), []);

  /**
   * EndCustomer 후보 재조회 + 자동선택 (AS-IS setEndCustomer cs:6650~6685).
   *   후보가 정확히 1행이면 그 코드를 셀에 넣는다. 0행이면 훅이 '-' 단일행을 합성한다.
   *   3키 중 하나라도 비면 조회하지 않는다(AS-IS 동일 가드).
   */
  const applyEndCustomer = useCallback(
    async (row: GridRowData, write: CellWriter, grid: FlexGridType) => {
      const keys = endCustomerKeysOf(row);
      if (!keys.divisionId || !keys.scmSiteId || !keys.itemId) return;
      const candidates = await loadEndCustomer(keys);
      if (candidates?.length === 1) {
        write(row, COLUMN.END_CUSTOMER, str(candidates[0].CODE));
        grid.invalidate();
      }
    },
    [loadEndCustomer]
  );

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // 편집 진입 게이트 — 행 조건 + 팝업셀 인라인 편집 취소(nscm-patterns §5-16).
    //   컬럼 축(INPUT_TP_CD)은 공용 DataGrid 가 이미 판정하므로 여기서 다시 화이트리스트를 두지 않는다.
    const editGate = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as GridRowData | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      if (POPUP_COLUMNS.has(binding) || DRILLDOWN_COLUMNS.has(binding)) {
        e.cancel = true;
        return;
      }
      // §4e #66(AS-IS MSG00293 -> TO-BE MSG01296) — Trans Mode 후보가 **조회 결과 없음** 일 때만
      //   안내 후 진입을 막는다. AS-IS 는 `dtTransMode == null`(= 조회했는데 못 채운 상태)을 본다.
      //   아직 조회 전이면 조용히 조회만 걸고 편집 진입만 취소한다 — 매 클릭 alert 는 AS-IS 에 없다.
      if (binding === COLUMN.TRANSPORT_MODE) {
        const keys = transModeKeysOf(row);
        // Incoterms 미선택은 후보 조회 자체가 불가하다 — AS-IS 도 같은 자리에서 MSG00098 을 띄운다
        //   (cs:5473~5479 "먼저 {0}을(를) 선택하십시오", {0}=Incoterms).
        if (!keys.incoterms) {
          onBlocked(MSG.PREREQUISITE_REQUIRED, 'Please select the {0} first.', 'Incoterms');
          e.cancel = true;
          return;
        }
        if (!isTransModeLoaded(keys)) {
          void loadTransMode(keys);
          e.cancel = true;
          return;
        }
        if (!dataMaps[COLUMN.TRANSPORT_MODE]?.length) {
          onBlocked(MSG.BOD_INVALID, 'BOD (Trans mode) information is not available.');
          e.cancel = true;
          return;
        }
      }
      if (!isRowEditable(row, canEdit)) {
        // ERP 확정행이면 사유를 알린다(R-25 / CP-13). 그 외(권한/상태)는 조용히 차단이 AS-IS 패리티다.
        if (isErpConfirmed(row)) {
          onBlocked(MSG.ERP_DO_CREATED, 'In ERP, DO is created and can not request change.');
        }
        e.cancel = true;
      }
    };
    grid.beginningEdit.addHandler(editGate);
    grid.pastingCell.addHandler(editGate);

    // 편집 후 파생 — §3.2 R-14~R-24 / CP-10~CP-12.
    //   파생·전파도 EditTracker 를 경유한다(직접 대입하면 그 셀만 "원복 시 M 해제" 가 안 된다).
    const onCellEditEnded = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as GridRowData | undefined;
      if (!row) return;
      const all = (sender.collectionView?.sourceCollection ?? []) as GridRowData[];
      const write = trackedWriter(editTrackerRef.current);
      // SHIPMENT_DATE 파생값은 **편집 행에서 한 번** 구해 전파 대상에도 그대로 쓴다(cs:6354~6361).
      let dateDerived: ReturnType<typeof shipmentDateDerivedOf> = null;

      switch (binding) {
        case COLUMN.FROM_SITE_DESCRIPTION:
        case COLUMN.TO_SITE_DESCRIPTION: {
          // R-14 — ITEM_ID 가 있을 때만 하위 3열 초기화. FindData_BOD 는 SP 미이관이라 재조회는 없다.
          if (str(row[COLUMN.ITEM_ID])) clearBodDerived(row, write);
          // To Site 가 바뀌면 EndCustomer 후보 키가 바뀐다(AS-IS cs:5623 setEndCustomer).
          if (binding === COLUMN.TO_SITE_DESCRIPTION) void applyEndCustomer(row, write, sender);
          setEditMain(row, 'Y');
          break;
        }
        case COLUMN.ITEM_ID: {
          // AS-IS cs:5145 — Model 확정 시 EndCustomer 후보 재조회(div 40/EE 분기에서만 열이 보인다).
          //   EDIT_MAIN 마킹은 하지 않는다: R-19 신호 19건에 ITEM_ID 가 없고, 이 열은 신규행에서만
          //   편집되므로 EDIT_MAIN 축(기존행 수정 표시)과 무관하다.
          void applyEndCustomer(row, write, sender);
          break;
        }
        case COLUMN.INCOTERMS: {
          // R-15 — 4중 선행값 가드. 위반 시 값을 되돌린다.
          if (incotermsPrerequisiteMissing(row)) {
            write(row, COLUMN.INCOTERMS, '');
            onBlocked(MSG.PREREQUISITE_REQUIRED, 'Please select the preceding values first.');
            sender.invalidate();
            return;
          }
          // R-16 — 통과 시 TRANSPORT_MODE/BOD_ID 초기화.
          write(row, COLUMN.TRANSPORT_MODE, '');
          write(row, COLUMN.BOD_ID, '');
          setEditMain(row, 'Y');
          break;
        }
        case COLUMN.TRANSPORT_MODE: {
          // R-17 — SHIPMENT_DATE / INCOTERMS 선행 필수. 위반 시 되돌림.
          if (transportModePrerequisiteMissing(row)) {
            write(row, COLUMN.TRANSPORT_MODE, '');
            write(row, COLUMN.BOD_ID, '');
            onBlocked(MSG.PREREQUISITE_REQUIRED, 'Please select the preceding values first.');
            sender.invalidate();
            return;
          }
          // R-23 — AS-IS 는 NEW_* 9열 대입이 전부 주석이라 미동작. 전파 + EDIT_MAIN 만이 패리티다.
          setEditMain(row, 'Y');
          break;
        }
        case COLUMN.SHIPMENT_DATE: {
          // 하한 위반이면 값을 지우고 파생·전파를 하지 않는다(cs:6313~6326 — MSG00194 -> TO-BE MSG01206).
          //   기준일수는 CHANGE_REQ_DAY lookup 실측값이다(하드코딩 금지).
          if (isShipmentDateBelowBase(row[COLUMN.SHIPMENT_DATE], changeReqDay)) {
            write(row, COLUMN.SHIPMENT_DATE, '');
            onBlocked(
              MSG.SHIPMENT_DATE_UNDER_BASE,
              'Change requests are possible from the current D + {0} ship date.',
              String(changeReqDay ?? '')
            );
            sender.invalidate();
            return;
          }
          // R-22 / CP-10 — NEW_LT_DAY 가 공백이면 파생이 없다. AS-IS 는 그 자리에서 return 하므로
          //   EDIT_MAIN 마킹도 하지 않는다(cs:6328) — 마킹만 남기면 저장 대상이 AS-IS 보다 넓어진다.
          dateDerived = shipmentDateDerivedOf(row, str(row[COLUMN.SHIPMENT_DATE]));
          if (!dateDerived) {
            sender.invalidate();
            return;
          }
          writeShipmentDateDerived(row, dateDerived, write);
          setEditMain(row, 'Y');
          break;
        }
        case COLUMN.CHANGE_REASON_CODE: {
          applyChangeReasonCode(row, str(row[COLUMN.CHANGE_REASON_CODE]), write);
          break;
        }
        case COLUMN.CHANGE_REASON_DETAIL: {
          if (isReasonCodeMissing(row)) {
            write(row, COLUMN.CHANGE_REASON_DETAIL, '');
            onBlocked(MSG.REASON_CODE_REQUIRED, 'Please select the Change Reason first.');
            sender.invalidate();
            return;
          }
          setEditMain(row, 'Y');
          break;
        }
        default: {
          if (EDIT_MAIN_TRIGGER_COLUMNS.has(binding)) setEditMain(row, 'Y');
        }
      }

      // 동일 SO 전파 — AS-IS 전파 경로만 옮긴다(R-20/R-21/R-22/R-24).
      //   편집 컬럼 전건을 전파하면 AS-IS 가 손대지 않는 행까지 수정행으로 마킹돼 저장 대상에 들어간다.
      //   chkSingleProcess 가 체크돼 있으면 자기 행만(CP-11) — 단 TRANSPORT_MODE 는 예외다:
      //   유일한 live 경로(SpdMain_ComboSelChange cs:5817)에 체크박스 조건이 없다.
      const propagatesValue = VALUE_PROPAGATION.has(binding);
      const propagatesStatus = STATUS_PROPAGATION.has(binding);
      if (propagatesValue || propagatesStatus) {
        const respectSingle = singleProcess && !IGNORE_SINGLE_PROCESS.has(binding);
        for (const target of soGroupRows(all, row, respectSingle)) {
          if (target === row) continue;
          let markChanged = true;
          if (binding === COLUMN.TRANSPORT_MODE) {
            write(target, COLUMN.TRANSPORT_MODE, row[binding]);
          } else if (binding === COLUMN.CHANGE_REASON_CODE) {
            // '-'/공백 전파는 대상 행도 EDIT_MAIN='N' + 변경행 마킹 없음(cs:5892~5899).
            markChanged = propagateChangeReason(
              target,
              str(row[binding]),
              str(row[COLUMN.CHANGE_REASON_DETAIL]),
              write
            );
          } else if (binding === COLUMN.CHANGE_REASON_DETAIL) {
            // 직접 입력 경로도 상세 텍스트를 동일 SO 에 복사한다(cs:6590~6609).
            write(target, COLUMN.CHANGE_REASON_DETAIL, row[binding]);
          } else if (binding === COLUMN.SHIPMENT_DATE) {
            // 파생이 불가한 입력(LT 공백 등)이면 AS-IS 도 그 자리에서 return 해 전파가 없다.
            if (!dateDerived) continue;
            writeShipmentDateDerived(target, dateDerived, write);
          }
          // R-21 은 값이 아니라 행상태만 'M' 으로 강제하는 경로다.
          if (markChanged) markPropagated(target);
        }
      }
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(onCellEditEnded);

    // 셀 표시 — 편집 가능 여부 색 + 행별 수량 소수자리(§2.3 S1 / CP-6) + 액션 아이콘 렌더 게이트.
    const onFormatItem = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as GridRowData | undefined;
      if (!row) return;

      const editable = isRowEditable(row, canEdit);
      e.cell.classList.toggle('wj-cell-editable', editable);
      e.cell.classList.toggle('wj-cell-locked', !editable);

      // 수량 소수자리는 행 OPERATION_GROUP 으로 갈린다 — 컬럼 단위 scale 로는 표현할 수 없다.
      if (binding === COLUMN.SHIPMENT_CONFIRM_QTY) {
        const value = row[COLUMN.SHIPMENT_CONFIRM_QTY];
        if (value !== null && value !== undefined && value !== '') {
          const numeric = Number(value);
          if (Number.isFinite(numeric)) {
            e.cell.textContent = numeric.toLocaleString(undefined, {
              minimumFractionDigits: qtyScaleOf(row),
              maximumFractionDigits: qtyScaleOf(row),
            });
          }
        }
      }

      // 액션 아이콘은 클릭 핸들러뿐 아니라 렌더 자체를 게이트한다(CP-18) —
      //   살아 보이는 죽은 버튼을 남기지 않는다.
      if (POPUP_COLUMNS.has(binding)) {
        const openable =
          editable &&
          isInsertedRow(row) &&
          !(binding === PROJECT_POPUP_COLUMN && isEndCustomerDivision(str(row[COLUMN.DIVISION_ID])));
        e.cell.classList.toggle('wj-cell-popup', openable);
      }
    };
    grid.formatItem.addHandler(onFormatItem);

    return () => {
      try {
        grid.beginningEdit?.removeHandler(editGate);
        grid.pastingCell?.removeHandler(editGate);
        grid.cellEditEnded?.removeHandler(onCellEditEnded);
        grid.formatItem?.removeHandler(onFormatItem);
      } catch {
        /* unmount race */
      }
    };
  }, [
    columns,
    canEdit,
    singleProcess,
    gridRef,
    editTrackerRef,
    onBlocked,
    dataMaps,
    changeReqDay,
    loadTransMode,
    isTransModeLoaded,
    applyEndCustomer,
  ]);

  // 팝업/드릴다운 — ITEM_ID·PROJECT_CODE 는 신규행에서만, ERP_SO_NO·CHANGE_REQ_NO 는 값이 있을 때만.
  const handleDblClick = useCallback(
    (e: MouseEvent) => {
      const grid = gridRef.current;
      if (!grid) return;
      const hit = grid.hitTest(e);
      if (hit.cellType !== CellType.Cell) return;
      const binding = grid.columns[hit.col]?.binding ?? '';
      const row = GridUtils.getRow(grid, hit.row) as GridRowData | undefined;
      if (!row) return;

      if (binding === SO_NO_POPUP_COLUMN) {
        // SSP0300_OrderDetailPopup — 값이 있을 때만, action 무관(조회 전용 드릴다운).
        if (str(row[SO_NO_POPUP_COLUMN])) onDrillDown(row, binding);
        return;
      }
      if (!POPUP_COLUMNS.has(binding)) return;
      if (!isRowEditable(row, canEdit) || !isInsertedRow(row)) return;
      if (binding === PROJECT_POPUP_COLUMN && isEndCustomerDivision(str(row[COLUMN.DIVISION_ID]))) {
        return;
      }
      onPopupCellDblClick(row, binding);
    },
    [gridRef, canEdit, onPopupCellDblClick, onDrillDown]
  );

  // CHANGE_REQ_NO 는 단일 클릭 드릴다운이다(cs:5564 — 더블클릭 아님).
  //   TRANSPORT_MODE 는 같은 CellClick 에서 행 파라미터 콤보를 조회한다(cs:5449~5470) —
  //   드롭다운을 열기 전에 후보가 채워져 있어야 AS-IS 와 같은 조작감이 된다.
  const handleClick = useCallback(
    (e: MouseEvent) => {
      const grid = gridRef.current;
      if (!grid) return;
      const hit = grid.hitTest(e);
      if (hit.cellType !== CellType.Cell) return;
      const binding = grid.columns[hit.col]?.binding ?? '';
      const row = GridUtils.getRow(grid, hit.row) as GridRowData | undefined;
      if (!row) return;
      if (binding === COLUMN.TRANSPORT_MODE) {
        void loadTransMode(transModeKeysOf(row));
        return;
      }
      if (binding !== CHANGE_REQ_NO_POPUP_COLUMN) return;
      if (!str(row[CHANGE_REQ_NO_POPUP_COLUMN])) return;
      onDrillDown(row, binding);
    },
    [gridRef, onDrillDown, loadTransMode]
  );

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      dblClick={handleDblClick}
      click={handleClick}
    />
  );
};
