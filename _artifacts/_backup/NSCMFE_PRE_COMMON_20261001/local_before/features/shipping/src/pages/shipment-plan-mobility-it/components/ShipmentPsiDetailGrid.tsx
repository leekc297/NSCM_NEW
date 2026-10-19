import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid, TabItem, TabWrapper } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  MSG,
  SHEETS,
  SO_GROUP_PROPAGATE_COLUMNS,
} from '../shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { DETAIL_SHEETS } from '../utils/shipment-plan-mobility-it.detailSheets';
import { isDetailCellEditable } from '../utils/shipment-plan-mobility-it.editLock';

interface Props {
  rowsBySheet: Partial<Record<SHEETS, WijmoRowItem[]>>;
  gridRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>;
  gridFilterRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridFilter | undefined>>>;
  editTrackerRefs: Partial<Record<SHEETS, MutableRefObject<EditTracker | undefined>>>;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // 편집 가능 = canEdit(hasButton('EDIT')) — AS-IS EditButton 토글 미이식(convert-core §2.4).
  editable: boolean;
  onConfirmDetail: (changeReqNo: string) => void; // CHANGE_REQ_NO 클릭(아이콘셀 popup)
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// detail 편집/읽기전용 시트 판정 (design 03 §1.E)
const EDITABLE_SHEETS = new Set<SHEETS>([SHEETS.CONFIRM_DETAIL, SHEETS.HOLD_STOCK, SHEETS.MES_STOCK]);

export const ShipmentPsiDetailGrid = ({
  rowsBySheet,
  gridRefs,
  gridFilterRefs,
  editTrackerRefs,
  staticColumns,
  editable,
  onConfirmDetail,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanMobilityItStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanMobilityItStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanMobilityItStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // Shipment Confirm Detail — 편집잠금 + ERP 게이트 + SO그룹 전파 (design 03 §3.A/§3.B)
  const confirmGridRef = gridRefs[SHEETS.CONFIRM_DETAIL];
  const confirmColumns = staticColumns[SHEETS.CONFIRM_DETAIL];
  useEffect(() => {
    const g = confirmGridRef?.current;
    if (!g) return;
    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);

    const gateHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable = isDetailCellEditable(SHEETS.CONFIRM_DETAIL, row, binding, editableRef.current);
      e.cancel = !cellEditable;
      if (!cellEditable && row && str(row.ERP_STATUS) === 'C' && editableRef.current) {
        void setAlert({
          type: 'alert',
          content: t(MSG.READONLY_SHEET, { defaultValue: '_This row cannot be changed.' }),
        });
      }
    };
    g.beginningEdit.addHandler(gateHandler);
    g.pastingCell.addHandler(gateHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.CONFIRM_DETAIL, row, binding, editableRef.current)
      );
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집마킹(EDIT_MAIN='Y'→CRUD_TYPE) + SO그룹 전파 (design 03 §3.B)
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!propagateSet.has(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const value = row[binding];
      const soNo = str(row.ERP_SO_NO).trim();

      if (binding === 'CHANGE_REASON_DETAIL') {
        const code = str(row.CHANGE_REASON_CODE).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          void setAlert({
            type: 'alert',
            content: t(MSG.REASON_CODE_FIRST, { defaultValue: '_Please enter Reason Code.' }),
          });
          sender.collectionView?.refresh();
          return;
        }
      }
      if (binding === 'CHANGE_REASON_CODE') {
        const code = str(value).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          if (soNo === '') {
            sender.collectionView?.refresh();
            return;
          }
        }
      }

      row.EDIT_MAIN = 'Y';
      if (soNo !== '') {
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        source.forEach(other => {
          if (other === row) return;
          if (str(other.ERP_SO_NO).trim() !== soNo) return;
          other[binding] = value;
          if (binding === 'CHANGE_REASON_CODE') other.CHANGE_REASON_DETAIL = row.CHANGE_REASON_DETAIL;
          other.EDIT_MAIN = 'Y';
          if (!str(other.CRUD_TYPE)) other.CRUD_TYPE = 'M';
        });
      }
      sender.collectionView?.refresh();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // paste 경로 날짜 파생 + SO그룹 전파 (AS-IS SSP0015_ShipmentPSI.cs L8995-9029 — gap-resolve I09).
    //   비대칭(design 03 §3.B): interactive 편집은 서버(SP)가 NEW_ETD/ETA 산정, paste 경로만 클라가 선산정.
    //   AS-IS 는 날짜를 "yyyy-MM-dd" 로 정규화(sDate)하고 NEW_ETA=sDate+NEW_LT_DAY 를 계산한 뒤,
    //   ERP_SO_NO 가 있으면 동일 SO 전행에, 없으면 편집행에만 5개 필드를 세팅한다.
    const pastedDateHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'SHIPMENT_DATE') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const raw = str(row.SHIPMENT_DATE).trim();
      if (raw === '') return;
      const iso = raw.length === 8 ? `${raw.slice(0, 4)}-${raw.slice(4, 6)}-${raw.slice(6, 8)}` : raw;
      const parsed = dayjs(iso);
      if (!parsed.isValid()) return;
      const sDate = parsed.format('YYYY-MM-DD'); // AS-IS "yyyy-MM-dd" 정규화
      const ltDay = Number(str(row.NEW_LT_DAY) || 0);
      const sEta = parsed.add(Number.isNaN(ltDay) ? 0 : ltDay, 'day').format('YYYY-MM-DD');
      const applyDerived = (target: Record<string, unknown>) => {
        target.SHIPMENT_DATE = sDate;
        target.NEW_ETD = sDate;
        target.NEW_ETA = sEta;
        target.NEW_SHIPMENT_DATE = sDate;
        target.EDIT_MAIN = 'Y';
        if (!str(target.CRUD_TYPE)) target.CRUD_TYPE = 'M';
      };
      const soNo = str(row.ERP_SO_NO).trim();
      if (soNo === '') {
        applyDerived(row);
      } else {
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        source.forEach(other => {
          if (str(other.ERP_SO_NO).trim() === soNo) applyDerived(other);
        });
      }
      sender.collectionView?.refresh();
    };
    g.pastedCell.addHandler(pastedDateHandler);

    // 아이콘셀 popup — CHANGE_REQ_NO 클릭(비공백 시 ConfirmDetail 팝업, design 03 §3.C·§4d #26·27).
    //   INCOTERMS 아이콘셀·ERP_SO_NO(OrderDetail SSP0300)·Comments sticky note 는 TO-BE 팝업 부재로
    //   미배선 — 04_react-gap.md 확인필요.
    const clickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'CHANGE_REQ_NO') return;
      const row = GridUtils.getRow(g, ht.row) as WijmoRowItem | undefined;
      const changeReqNo = str(row?.CHANGE_REQ_NO).trim();
      if (changeReqNo === '') return;
      onConfirmDetail(changeReqNo);
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(gateHandler);
        g.pastingCell?.removeHandler(gateHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(pastedDateHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [confirmColumns, rowsBySheet[SHEETS.CONFIRM_DETAIL]]);

  // Hold stock / MES Stock 편집 게이트 (design 03 §3.A — 전행 화이트리스트 컬럼).
  //   dep 은 변수로 추출(react-hooks/exhaustive-deps complex-expression 경고 회피).
  const holdCols = staticColumns[SHEETS.HOLD_STOCK];
  const mesCols = staticColumns[SHEETS.MES_STOCK];
  const holdRows = rowsBySheet[SHEETS.HOLD_STOCK];
  const mesRows = rowsBySheet[SHEETS.MES_STOCK];
  useEffect(() => {
    const cleanups: (() => void)[] = [];
    ([SHEETS.HOLD_STOCK, SHEETS.MES_STOCK] as const).forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      const gate = (sender: FlexGridType, e: { row: number; col: number; cancel: boolean }) => {
        const binding = sender.columns[e.col]?.binding ?? '';
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        e.cancel = !isDetailCellEditable(sheet, row, binding, editableRef.current);
      };
      g.beginningEdit.addHandler(gate);
      g.pastingCell.addHandler(gate);
      const fmt = (
        sender: FlexGridType,
        e: { panel: unknown; row: number; col: number; cell: HTMLElement }
      ) => {
        if (e.panel !== sender.cells) return;
        const binding = sender.columns[e.col]?.binding ?? '';
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        e.cell.classList.toggle(
          'wj-cell-editable',
          isDetailCellEditable(sheet, row, binding, editableRef.current)
        );
        // USER_MOD Blue (design 03 §3.C L3945/4506 — gap-resolve I15): MES Stock 의
        //   USER_MOD_RELEASE_DATE 가 사용자 수정값(2999-12-31 sentinel 아님·비공백)이면 파란 글씨.
        if (sheet === SHEETS.MES_STOCK && binding === 'USER_MOD_RELEASE_DATE') {
          const v = str(row?.USER_MOD_RELEASE_DATE).trim();
          if (v !== '' && v !== '2999-12-31' && v !== '29991231') e.cell.style.color = 'blue';
        }
      };
      g.formatItem.addHandler(fmt);
      cleanups.push(() => {
        try {
          g.beginningEdit?.removeHandler(gate);
          g.pastingCell?.removeHandler(gate);
          g.formatItem?.removeHandler(fmt);
        } catch {
          // unmount race
        }
      });
    });
    return () => cleanups.forEach(fn => fn());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [holdCols, mesCols, holdRows, mesRows]);

  const isReadOnlySheet = (sheet: SHEETS): boolean => !EDITABLE_SHEETS.has(sheet);

  return (
    <TabWrapper
      persist
      activeTabIndex={activeIndex}
      setActiveTabIndex={index => setActiveDetailSheet(DETAIL_SHEETS[index])}
    >
      {DETAIL_SHEETS.map(sheet => (
        <TabItem key={sheet} label={ADMIN_SHEET_NAME[sheet] ?? sheet}>
          <DataGrid
            gridRef={gridRefs[sheet]}
            gridFilterRef={gridFilterRefs[sheet]}
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? []}
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            allowMerging={AllowMerging.Cells}
            gotFocus={() => setActiveGrid('detail')}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};
