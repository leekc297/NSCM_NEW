import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  DIVISION_CASCADE_CLEAR,
  LOOKUP,
  MAIN_COLUMNS,
  MENU_ID,
  MSG,
} from '../shipment-master-electrode.constants';
import type { MainRow } from '../shipment-master-electrode.types';
import { buildColumns } from '../utils/shipmentMasterElectrodeColumns';
import {
  isCellEditable,
  isInlineEditable,
  isInsertRow,
  isMaterialPopupColumn,
} from '../utils/shipmentMasterElectrodeEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  isEditMode: boolean;
  adminColumns?: RawFlexGridColumnConfig[];
  // MATERIAL_ID 셀 더블클릭 -> 페이지가 팝업 오픈(대상 신규행 기억). design 03 §3.2.
  onMaterialCellDblClick: (row: Record<string, unknown>) => void;
  onFocus: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 편집 가능 셀 배경(자매 shipment-requestor-pic 과 동일 값).
const EDITABLE_CELL_BG = '#FFFDE7';

// AS-IS spdMain "Ship Master Elec" (단일 그리드 25열). 조회=전체 lock, Edit/Insert=지정칸만 편집(editLock).
//   셀 콤보 5종은 공용 DataGrid 가 admin 메타(cellCboDataTp + PARAM2/9/10)로 자동 배선(useRowParamCombos).
//   화면은 (a) 모드×행상태 편집잠금(beginningEdit) (b) MATERIAL 셀팝업 (c) 파생·cascade 클리어(cellEditEnded)만 담당.
export const ShipmentMasterElectrodeGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  isEditMode,
  adminColumns,
  onMaterialCellDblClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 셀 콤보 @토큰(@mnuId·@divisionId) 해소 — 행파라미터 콤보(PARAM10='D')는 행 값을 쓰나, 비-행 콤보/
  //   기본 division 스코프용으로 화면 division 도 함께 실어 준다. 인용은 getCombo funnel(nscm-patterns §3.3).
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // POST_OPER -> POST_OPER_LT 파생 원천 (design 03 §1.2/§3.2 cs:615~623).
  //   ELECTRODE_POST_OPER_CODE lookup: SEGMENT1=DIVISION_ID / SEGMENT2=CODE(POST_OPER) / SEGMENT5=LT.
  const [postOperLookup] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.POST_OPER }] });
  const postOperLtMap = useMemo(() => {
    const m = new Map<string, string>();
    (postOperLookup ?? []).forEach(r => {
      const div = str(r.SEGMENT1);
      const code = str(r.SEGMENT2);
      if (code) m.set(`${div}|${code}`, str(r.SEGMENT5));
    });
    return m;
  }, [postOperLookup]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 게이트 — 모드×행상태 판정(editLock). MATERIAL_ID 는 팝업 전용이라 인라인 편집 취소(nscm-patterns §5-16).
    //   공용 DataGrid defaultEditHandler(INPUT_TP_CD='S')가 먼저 cancel 하고, 화면이 나중 실행돼 최종 재지정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const editable = isInlineEditable(binding, row, isEditMode);
      // DIVISION_ID 가 비면 그 행의 다른 칸은 편집 불가(AS-IS CellClick cs:541~546 — MSG00093 "Division").
      //   직전 구현은 MATERIAL 팝업 경로에만 이 가드가 있었다(gap-resolve iter-1 G7). 편집 가능했을 셀에서만
      //   알려 잠긴 셀 클릭마다 알림이 뜨지 않게 한다.
      if (editable && binding !== 'DIVISION_ID' && !str(row?.DIVISION_ID)) {
        e.cancel = true;
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
        });
        return;
      }
      e.cancel = !editable;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 — 공용 DataGrid 는 pastingCell 에도 defaultEditHandler(INPUT_TP_CD 기준)를 건다
    //   (packages/shared/.../dataGridUtils.ts:372). 이 화면은 INPUT_TP_CD 가 전건 'S'(SEARCH_ONLY)라
    //   그대로 두면 **모든 붙여넣기가 취소**되고, 그 결과 아래 pastedCell 파생·클리어가 영영 실행되지
    //   않는다(AS-IS ClipboardPasted cs:659~727 미구현). beginningEdit 과 같은 방식으로 editLock 이
    //   최종 판정하도록 재지정한다.
    //   인라인 편집과 달리 MATERIAL_ID 도 붙여넣기 대상이다 — AS-IS 는 KeyPress(cs:646~657)로 키입력만
    //   막고 신규행 LockRange(cs:385~389)에 MATERIAL_ID 를 넣지 않는다. 그래서 isInlineEditable 이 아니라
    //   isCellEditable 을 쓴다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !isCellEditable(binding, row, isEditMode);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집 가능 셀 배경 강조 — 공용 formatEditableColumns 의 'wj-cell-editable' 은 INPUT_TP_CD 기준이라
    //   전건 'S' 인 이 화면에서는 항상 꺼진다(dataGridUtils.ts:303). AS-IS FpSpread 의 잠금/해제 색 대비를
    //   editLock 기준으로 재현한다(자매 shipment-requestor-pic 동일 패턴).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cell.style.backgroundColor =
        row && isCellEditable(binding, row, isEditMode) ? EDITABLE_CELL_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 파생·cascade — 콤보/값 변경 종료 시 (design 03 §3.2 SetValue 규칙).
    const applyDerivations = (
      sender: FlexGridType,
      e: { row: number; col: number }
    ): void => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const setCell = (key: string, value: string): void => {
        const prev = row[key];
        if (str(prev) === value) return;
        editTrackerRef.current?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      if (binding === 'DIVISION_ID' && isInsertRow(row)) {
        // 신규행 DIVISION 변경 -> 종속 7칸 클리어(cs:630~636).
        DIVISION_CASCADE_CLEAR.forEach(k => setCell(k, ''));
      } else if (binding === 'PLANT_SITE_ID') {
        // PLANT_SITE_ID -> PLANT_SITE_CODE 동기(cs:640).
        setCell('PLANT_SITE_CODE', str(row.PLANT_SITE_ID));
      } else if (binding === 'POST_OPER') {
        // POST_OPER -> POST_OPER_LT (lookup SEGMENT5, division별 cs:615~623).
        const lt = postOperLtMap.get(`${str(row.DIVISION_ID)}|${str(row.POST_OPER)}`) ?? '';
        setCell('POST_OPER_LT', lt);
      } else if (binding === 'BUILDING') {
        // BUILDING -> BUILDING_DESC (FACTORY_NAME, 선택 코드의 콤보 표시값 cs:605 / 07_human-doc §2).
        const col = sender.columns.getColumn('BUILDING');
        const name = col?.dataMap ? str(col.dataMap.getDisplayValue(row.BUILDING)) : '';
        setCell('BUILDING_DESC', name || str(row.BUILDING));
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(applyDerivations);
    g.pastedCell.addHandler(applyDerivations);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(applyDerivations);
        g.pastedCell?.removeHandler(applyDerivations);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, isEditMode, postOperLtMap]);

  // MATERIAL_ID 셀 더블클릭 -> 팝업. 신규행 + PLANT_SITE_CODE 있을 때만(design 03 §3.4 cs:553~558).
  //   Division 미선택 시 다른 칸 편집 차단 가드(MSG00097). 팝업 전용(키입력은 beginningEdit 이 차단).
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!isMaterialPopupColumn(binding)) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row || !isInsertRow(row)) return;
    if (!str(row.DIVISION_ID)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    if (!str(row.PLANT_SITE_CODE)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} value is required.\', 0: \'Plant Site'),
      });
      return;
    }
    onMaterialCellDblClick(row);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={false}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      dblClick={handleDblClick}
      gotFocus={onFocus}
    />
  );
};
