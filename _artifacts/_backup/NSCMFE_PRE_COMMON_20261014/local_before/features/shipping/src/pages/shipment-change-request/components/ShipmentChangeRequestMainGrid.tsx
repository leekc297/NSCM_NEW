import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  DIVISION_EXCLUSIVE,
  EE_DIVISION,
  FIXED_DIVISION,
  ITEM_POPUP_COLUMN,
  MENU_ID,
  PLAN_TYPE_PLAN,
  PROJECT_POPUP_COLUMN,
} from '../shipment-change-request.constants';
import type { MainRow } from '../shipment-change-request.types';
import { buildColumns } from '../utils/shipmentChangeRequestColumns';
import {
  applyChangeReasonCode,
  EDIT_MAIN_TRIGGER_COLUMNS,
  isReasonCodeMissing,
  setEditMain,
  soGroupRows,
} from '../utils/shipmentChangeRequestDerive';
import {
  isCellEditable,
  isEndCustomerDivision,
  isInsertedRow,
} from '../utils/shipmentChangeRequestEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  changeType: string;
  isGridEditable: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  // 이미지셀(ITEM_ID/PROJECT_CODE) 더블클릭 -> 페이지가 팝업 오픈(row/binding 기억). design 03 §1.1.
  onPopupCellDblClick: (row: Record<string, unknown>, binding: string) => void;
  // erp_status='C' 등 변경 차단 시 alert (MSG00189).
  onBlockedEdit: (msgKey: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const POPUP_COLUMNS = new Set<string>([ITEM_POPUP_COLUMN, PROJECT_POPUP_COLUMN]);

// AS-IS spdMain "Shipment Change Request" (65열). 조회=전체 lock, Edit=SwitchLock 후 화이트리스트 편집.
export const ShipmentChangeRequestMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  changeType,
  isGridEditable,
  adminColumns,
  onPopupCellDblClick,
  onBlockedEdit,
}: Props) => {
  const columns = useMemo(() => buildColumns(adminColumns, false), [adminColumns]);

  // 셀콤보(A 메타 4종 + B 재조회 6종)의 @토큰 해소 — divisionId 는 40 고정. per-row 좁힘(PARAM2)·
  //   재조회(PARAM10='D')는 admin 메타 구동(useRowParamCombos). CN-3: AS-IS PARAM2/9/10 NULL 이라
  //   메타 미보강 시 후보 좁힘이 재현되지 않음(05_register.sql / 확인필요).
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 게이트 — 화이트리스트(§3.1) + 팝업셀 인라인 편집 취소(nscm-patterns §5-16).
    //   beginningEdit(키인)와 pastingCell(붙여넣기)에 동일 적용. GAP-04: INPUT_TP_CD 전건 'S'라
    //   공용 DataGrid 기본 pastingCell(GridUtils.isEditableCell)이 붙여넣기 전량 취소하므로,
    //   화면이 화이트리스트 기준으로 pastingCell 을 재지정한다(memory sheet-columns-input-tp-all,
    //   공용 핸들러가 먼저 등록되고 이 화면 핸들러가 뒤에 등록돼 e.cancel 을 최종 결정).
    const editGate = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) {
        e.cancel = true;
        return;
      }
      // erp_status='C' 변경 차단(MSG00189) — 편집모드여도 잠금.
      if (str(row.ERP_STATUS) === 'C') {
        e.cancel = true;
        return;
      }
      // 팝업셀(ITEM_ID/PROJECT_CODE)은 더블클릭 팝업 전용 — 인라인 편집/붙여넣기 취소.
      if (POPUP_COLUMNS.has(binding)) {
        e.cancel = true;
        return;
      }
      e.cancel = !isCellEditable(row, binding, isGridEditable);
    };
    g.beginningEdit.addHandler(editGate);
    g.pastingCell.addHandler(editGate);

    // 편집 후 파생 — EDIT_MAIN 플래그 + SO No 그룹 전파 + Reason Code/Detail 가드(§3.2).
    const cellEditEndedHandler = (
      sender: FlexGridType,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;

      if (binding === 'CHANGE_REASON_CODE') {
        applyChangeReasonCode(row, str(row.CHANGE_REASON_CODE));
      } else if (binding === 'CHANGE_REASON_DETAIL') {
        // Reason Detail 입력 전 Reason Code 선행 필수(MSG00287) — 누락 시 값 리셋.
        if (isReasonCodeMissing(row)) {
          row.CHANGE_REASON_DETAIL = '';
          onBlockedEdit('REASON_CODE_REQUIRED');
          sender.invalidate();
          return;
        }
        setEditMain(row, 'Y');
      } else if (EDIT_MAIN_TRIGGER_COLUMNS.has(binding)) {
        setEditMain(row, 'Y');
      }

      // SO No 그룹 전파 — 같은 ERP_SO_NO 전행에 EDIT_MAIN='Y' 복제(design 03 §3.2).
      if (EDIT_MAIN_TRIGGER_COLUMNS.has(binding) || binding === 'CHANGE_REASON_DETAIL') {
        for (const groupRow of soGroupRows(
          (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[],
          row
        )) {
          if (groupRow !== row) setEditMain(groupRow, 'Y');
        }
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // 조건부 포맷 — 잠금 회색 / 편집 노랑(hook #95 3색) + 동적 컬럼 토글(changeType='P').
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      // 편집 가능 셀 = 편집색(노랑), 그 외 = 잠금색(회색). 수정행 강조는 StringAction/EDIT_MAIN.
      const editable = isCellEditable(row, binding, isGridEditable);
      e.cell.classList.toggle('wj-cell-editable', editable);
      e.cell.classList.toggle('wj-cell-locked', !editable);
    };
    g.formatItem.addHandler(formatItemHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(editGate);
        g.pastingCell?.removeHandler(editGate);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, isGridEditable, editTrackerRef]);

  // 동적 컬럼/헤더 토글 — changeType='P'(Plan): ERP_SO_NO/CONFIRM_ID 폭 0, Qty 라벨 변경(design 03 §2 #1).
  //   GAP-05: Division 40/EE 상호배타(design 03 §2 #2) — 40/EE 면 END_CUSTOMER visible·PROJECT_CODE/NAME
  //   hidden, 그 외면 반대. Division 은 '40' 고정(R3)이라 상시 END_CUSTOMER 노출·PROJECT_* 숨김이 정상.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const isPlan = changeType === PLAN_TYPE_PLAN;
    const isEndCustomerDiv = division === FIXED_DIVISION || division === EE_DIVISION;
    for (const c of g.columns) {
      if (c.binding === 'ERP_SO_NO' || c.binding === 'CONFIRM_ID') {
        c.visible = !isPlan;
      }
      if (c.binding === 'SHIPMENT_CONFIRM_QTY') {
        c.header = isPlan ? 'Shipment Plan Qty*' : 'Shipment Confirm Qty*';
      }
      if (c.binding === DIVISION_EXCLUSIVE.END_CUSTOMER) c.visible = isEndCustomerDiv;
      if (
        c.binding === DIVISION_EXCLUSIVE.PROJECT_CODE ||
        c.binding === DIVISION_EXCLUSIVE.PROJECT_NAME
      ) {
        c.visible = !isEndCustomerDiv;
      }
    }
    g.invalidate();
  }, [changeType, division, columns, gridRef]);

  // 이미지셀(ITEM_ID/PROJECT_CODE) 더블클릭 -> 팝업. 신규행/40·EE 배타는 편집 화이트리스트가 판정.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g || !isGridEditable) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!POPUP_COLUMNS.has(binding)) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    // 신규행에서만 팝업 편집(ITEM_ID/PROJECT_CODE). PROJECT_CODE 는 40/EE 아닌 division 만.
    if (!isInsertedRow(row)) return;
    if (binding === PROJECT_POPUP_COLUMN && isEndCustomerDivision(row)) return;
    onPopupCellDblClick(row, binding);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={!isGridEditable}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // GAP-03 셀 병합(AS-IS SmartColMerge 5건, design 03 §3.5) — 공용 DataGrid allowMerging=Cells +
      //   CustomMergeManager(좌측 누적 키 계층 병합, 신규행 CRUD_TYPE='I' 제외, grid-behavior-parity §1.3).
      allowMerging={AllowMerging.Cells}
      dblClick={handleDblClick}
    />
  );
};
