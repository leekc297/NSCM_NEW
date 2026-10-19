import { toggleClass } from '@mescius/wijmo';
import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { CODE_DISPLAY_COLUMNS, GRID_COMBO_PARAMS } from '../customer-fcst-upload.constant';
import type { CustomerFcstUploadRow, SpreadTitleRow } from '../customer-fcst-upload.types';
import { useCustomerFcstUploadStore } from '../useCustomerFcstUploadStore';

interface CustomerFcstUploadGridProps {
  gridRef: MutableRefObject<FlexGrid<CustomerFcstUploadRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  // 그리드 공용 EditTracker 노출 — 저장 시 변경 셀의 단일 진실원으로 사용 (메인이 payload 도출)
  editTrackerRef: MutableRefObject<EditTracker<CustomerFcstUploadRow> | undefined>;
  data: CustomerFcstUploadRow[];
  // PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE o_rc1 — 동적 D_ 기간 컬럼 (라벨/그룹) 정본
  spreadTitle: SpreadTitleRow[];
  // 편집된 D_ 셀 통지 — 메인이 spdMain_Changed 필수 11건 검증 + SetSaveData 수집 (AS-IS 1:1)
  onCellEdited: (item: CustomerFcstUploadRow, binding: string) => void;
}

// FlexGridColumn 렌더링용 통합 column meta (sales-monitoring MergedColumnMeta 패턴)
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  // admin CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE — 공용 DataGrid 자동 콤보 dataMap 트리거.
  //   COMBO + comboId 면 DataGrid 가 useTabComboQueries 로 CODE -> NAME 표시 매핑을 붙인다.
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

export const CustomerFcstUploadGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  spreadTitle,
  onCellEdited,
}: CustomerFcstUploadGridProps) => {
  const staticColumn = useCustomerFcstUploadStore(state => state.staticColumn);

  // 컬럼 메타 정본 = admin `/column` 응답(SCM_MST_SHEET_COLUMNS) 단일 원천.
  //   admin UI Category Setup 변경이 코드 수정 없이 그대로 반영된다.
  const mergedColumns = useMemo<MergedColumnMeta[]>(
    () =>
      (staticColumn ?? []).map(col => {
        // 콤보 SQL_ID = admin 메타 CELL_COMBO_DATA_TYPE.
        //   단 CODE_DISPLAY_COLUMNS(Division)는 등재돼 있어도 코드 표기를 유지한다.
        const comboKey = CODE_DISPLAY_COLUMNS.includes(col.colNm)
          ? undefined
          : col.cellCboDataTp?.trim();
        return {
          binding: col.colNm,
          header: col.colLblNm || col.colNm,
          width: col.colWth ?? 100,
          align: col.horzAlgnCd ?? 'L',
          visible: col.visible !== false,
          display: col.display === true, // BE 계산값 (개인화 있으면 개인화 / 없으면 DEFAULT_FLAG)
          fixed: col.fixed === true, // admin FIXED_FLAG 위임 (등재값 'Y' — AS-IS Freeze 1:1)
          cellCboDataTp: comboKey,
          // 콤보 SQL_ID 가 잡히면 COMBO 로 승격한다 — admin 메타의 CELL_CONTROL_OBJECT_TYPE_CODE 가
          //   'FPText'/공란으로 등재돼 있어도 표시 매핑이 살아야 하기 때문이다. 이 화면 식별 컬럼은
          //   전부 읽기전용('S')이라 COMBO 선언은 CODE -> NAME 표시 스위치로만 작동한다(편집화 아님).
          cellCtrlObjTpCd: comboKey ? CELL_CONTROL_TYPE.COMBO : col.cellCtrlObjTpCd,
        } as MergedColumnMeta;
      }),
    [staticColumn]
  );

  // 표시 판정 — display(BE DEFAULT/개인화) && visible(VISIBLE_FLAG — EDIT_FLAG/EDIT_YN='N' 숨김)
  const visibleColumns = useMemo(
    () => mergedColumns.filter(c => c.display && c.visible),
    [mergedColumns]
  );

  // 식별 컬럼 — 항상 읽기전용 'S' (AS-IS: 기존 행 식별 셀 상시 잠금 — InsertRow 차단으로 신규행 경로 없음)
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        colNm: c.binding,
        colLblNm: c.header,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        // 콤보 메타 승계 -> 공용 DataGrid 자동 dataMap (AS-IS AddComboColumn 컬럼 CODE -> NAME 표시).
        //   inputTpCd='S'(읽기전용)여도 dataMap 은 표시 매핑만 담당하며, 셀에 남는 값과 저장 payload 는
        //   변함없이 CODE 원문이다 (handleSave 는 row 값을 그대로 읽는다).
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // ⭐ 동적 D_ 기간 컬럼 — 2단 헤더 (AS-IS InitSpread L382~405 1:1: 상단 = SMALL_LABEL_NAME 연속
  //   run 그룹 스팬 / 하단 leaf = COLUMN_LABEL). 전 버킷 D_ 접두 (WEEKLY=주 시작일 — 스모크 실측).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const rows = (spreadTitle ?? []).filter(r => /^D_\d{8}$/.test(r.COLUMN_NAME ?? ''));
    if (rows.length === 0) return [];
    type Group = { label: string; leafs: FlexGridColumnConfig[] };
    const groups: Group[] = [];
    rows.forEach(r => {
      const label = (r.SMALL_LABEL_NAME ?? '').trim() || ' ';
      const last = groups[groups.length - 1];
      const leaf: FlexGridColumnConfig = {
        binding: r.COLUMN_NAME,
        header: r.COLUMN_LABEL || r.COLUMN_NAME.slice(2),
        align: 'right',
        format: 'n0', // AS-IS Convert.ToInt32 정수 수량 1:1
        width: 100, // AS-IS AddNumTextColumn w50 FarPoint ×2 px 환산
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // 편집 가부는 beginningEdit 행 단위 판정 (EDIT_FLAG='Y' 행만) — 컬럼은 편집형 선언
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _ctrlType: CELL_CONTROL_TYPE.NUMBER,
        _display: true,
      };
      if (last && last.label === label) last.leafs.push(leaf);
      else groups.push({ label, leafs: [leaf] });
    });
    return groups.map(g => ({
      header: g.label,
      align: 'center',
      columns: g.leafs,
    }));
  }, [spreadTitle]);

  const dynBindings = useMemo(
    () => new Set((spreadTitle ?? []).map(r => r.COLUMN_NAME)),
    [spreadTitle]
  );

  // grid 핸들러 등록 — 편집 가드 + 셀 색 + 편집 수집
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGrid<CustomerFcstUploadRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // ⭐ AS-IS L399~402 1:1 — SAT=Blue / SUN=Red (DAILY 버킷 상단 그룹 라벨 = 요일)
        const text = (e.cell.textContent ?? '').trim();
        if (text === 'SAT') e.cell.style.color = '#1e56c8';
        else if (text === 'SUN') e.cell.style.color = '#c0392b';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!binding) return;

      // #95 — 편집 가능 셀만 Yellow (D_ 기간 셀 × EDIT_FLAG='Y' 행), 그 외 White + zebra
      if (dynBindings.has(binding)) {
        const item = (e.panel.rows[e.row] as { dataItem?: CustomerFcstUploadRow }).dataItem;
        const editable = item?.EDIT_FLAG === 'Y';
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        return;
      }
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // ⭐ 편집 가드 — D_ 기간 셀 × EDIT_FLAG='Y' 행만 허용 (AS-IS FindData 전체 잠금 → EditButton
    //   에서 'Y' 행 식별 컬럼만 잠금 유지 1:1. F2 토글은 TO-BE 표준(mkt-fcst)대로 상시 판정으로 대체)
    const beginningEditHandler = (
      _s: FlexGrid<CustomerFcstUploadRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      if (!dynBindings.has(binding)) {
        e.cancel = true;
        return;
      }
      const item = (_s.rows[e.row] as { dataItem?: CustomerFcstUploadRow }).dataItem;
      if (item?.EDIT_FLAG !== 'Y') e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // ⭐ spdMain_Changed(CellsUpdated) 1:1 — 편집 종료 셀을 메인으로 통지 (검증+수집은 메인 소관)
    const cellEditEndedHandler = (_s: FlexGrid<CustomerFcstUploadRow>, e: CellRangeEventArgs) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      if (!dynBindings.has(binding)) return;
      const item = (_s.rows[e.row] as { dataItem?: CustomerFcstUploadRow }).dataItem;
      if (item) onCellEdited(item, binding);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, onCellEdited]);

  // ⭐ hook #93 P-B v2 — 다단 헤더 총높이 48px "불변식" (sales-monitoring 검증분 1:1 —
  //   rAF 상시 감시: 인스턴스 교체 시 핸들러 이관 + 존재 행 높이 = 48/실제 행수 강제.
  //   wrapper headerRowHeight prop 단독(defaultSize만)은 정적 잔여로 무효 — #93 명시)
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<CustomerFcstUploadRow> | null = null;
    const normalize = (g: FlexGrid<CustomerFcstUploadRow>) => {
      const hdr = g.columnHeaders?.rows;
      if (!hdr || hdr.length === 0) return;
      const per = Math.max(1, Math.round(48 / hdr.length));
      let changed = false;
      if (Math.round(hdr.defaultSize) !== per) {
        hdr.defaultSize = per;
        changed = true;
      }
      for (let i = 0; i < hdr.length; i++) {
        if (Math.round(hdr[i].height ?? 0) !== per) {
          hdr[i].height = per;
          changed = true;
        }
      }
      if (changed) g.invalidate(false);
    };
    const onLayout = () => {
      if (attached) normalize(attached);
    };
    const tick = () => {
      const g = gridRef.current ?? null;
      if (g && g !== attached) {
        try {
          attached?.updatedLayout?.removeHandler(onLayout);
        } catch {
          /* dead instance */
        }
        g.updatedLayout.addHandler(onLayout);
        attached = g;
      }
      if (g) normalize(g);
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout?.removeHandler(onLayout);
      } catch {
        /* dead instance */
      }
    };
  }, [gridRef]);

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const onFilterApplied = () => g.invalidate(true);

    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, gridFilterRef]);

  return (
    <DataGrid<CustomerFcstUploadRow>
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      editTrackerRef={editTrackerRef}
      staticColumns={mainStaticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={GRID_COMBO_PARAMS}
      itemsSource={data}
      autoGenerateColumns={false}
      allowSorting={true}
    />
  );
};
