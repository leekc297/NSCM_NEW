import { toggleClass } from '@mescius/wijmo';
import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  CODE_DISPLAY_COLUMNS,
  GRID_COMBO_PARAMS,
  INSERT_EDITABLE_COLUMNS,
  MAIN_COLUMNS,
} from '../cust-psi-upload.constant';
import type { CustPsiUploadRow, SpreadTitleRow } from '../cust-psi-upload.types';
import { useCustPsiUploadStore } from '../useCustPsiUploadStore';

interface CustPsiUploadGridProps {
  gridRef: MutableRefObject<FlexGrid<CustPsiUploadRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  // 그리드 공용 EditTracker 노출 — 저장 시 변경 셀의 단일 진실원으로 사용 (메인이 payload 도출)
  editTrackerRef: MutableRefObject<EditTracker<CustPsiUploadRow> | undefined>;
  data: CustPsiUploadRow[];
  // 공유 SP DM.DMF0014_GET_SPREAD_TITLE o_rc1 — 동적 D_ 기간 컬럼 (라벨/그룹) 정본
  spreadTitle: SpreadTitleRow[];
  // 편집된 D_ 셀 통지 — 메인이 spdMain_Changed 필수 11건 검증 + SetSaveData 수집 (AS-IS 1:1)
  onCellEdited: (item: CustPsiUploadRow, binding: string) => void;
}

// FlexGridColumn 렌더링용 통합 column meta
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

// 신규행(CRUD_TYPE='I') 판정 — AS-IS InsertRow 로 삽입된 행 (원장 §E12).
const isInsertRow = (item?: CustPsiUploadRow): boolean => item?.CRUD_TYPE === CRUD_TYPE.INSERT;

// 셀 편집 가능 판정 — 색(formatItem)·게이트(beginningEdit) 공통.
//   1) 동적 D_ 기간 셀: 서버 EDIT_FLAG='Y' 행 또는 신규행(AS-IS EditButton + InsertRow 수량 개방).
//   2) 신규행 속성 셀: INSERT_EDITABLE_COLUMNS 만. PLANT_SITE_ID 는 Division=="81" 일 때만
//      (AS-IS InsertRow L627~633 + ComboSelChange L954~956 Division81 분기). 그 외 속성 셀·기존 행은 잠금.
const isEditableCell = (
  item: CustPsiUploadRow | undefined,
  binding: string,
  isDynamic: boolean
): boolean => {
  if (!item) return false;
  if (isDynamic) return item.EDIT_FLAG === 'Y' || isInsertRow(item);
  if (!isInsertRow(item)) return false;
  if (!INSERT_EDITABLE_COLUMNS.includes(binding)) return false;
  // Division-81 PlantSite 게이트 (portspec §8-2) — non-81 신규행은 PlantSite 잠금.
  if (binding === 'PLANT_SITE_ID') return String(item.DIVISION_ID) === '81';
  return true;
};

export const CustPsiUploadGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  spreadTitle,
  onCellEdited,
}: CustPsiUploadGridProps) => {
  const staticColumn = useCustPsiUploadStore(state => state.staticColumn);

  // admin staticColumns 우선 + MAIN_COLUMNS fallback (BE 미응답 시 작동 보장)
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    if (!staticColumn || staticColumn.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>(c => ({
        binding: c.key,
        header: c.header,
        width: c.width ?? 100,
        align: c.align ?? 'L',
        visible: c.visible !== false,
        display: c._default === true,
        // AS-IS Freeze(0..EditFlag) — 식별 컬럼 전체 고정
        fixed: c.visible !== false,
        cellCboDataTp: c._comboKey,
        cellCtrlObjTpCd: c._comboKey
          ? CELL_CONTROL_TYPE.COMBO
          : (c._ctrlType as CELL_CONTROL_TYPE | undefined),
      }));
    }
    return staticColumn.map(col => {
      const fb = MAIN_COLUMNS.find(m => m.key === col.colNm);
      const comboKey = CODE_DISPLAY_COLUMNS.includes(col.colNm)
        ? undefined
        : col.cellCboDataTp?.trim() || fb?._comboKey;
      return {
        binding: col.colNm,
        header: col.colLblNm || fb?.header || col.colNm,
        width: col.colWth ?? fb?.width ?? 100,
        align: col.horzAlgnCd ?? fb?.align ?? 'L',
        visible: col.visible !== false,
        display: col.display === true,
        fixed: col.fixed === true,
        cellCboDataTp: comboKey,
        cellCtrlObjTpCd: comboKey ? CELL_CONTROL_TYPE.COMBO : col.cellCtrlObjTpCd,
      } as MergedColumnMeta;
    });
  }, [staticColumn]);

  const visibleColumns = useMemo(
    () => mergedColumns.filter(c => c.display && c.visible),
    [mergedColumns]
  );

  // 식별 컬럼 — 기존(조회) 행은 항상 읽기전용. 신규행에서만 개방되는 속성 컬럼(INSERT_EDITABLE_COLUMNS)은
  //   컬럼 단위로 OPTIONAL 선언(에디터 오픈 허용)하되, beginningEdit 이 신규행이 아니면 취소한다
  //   (DMF0043 wrapper-readonly override 패턴의 역방향: 편집형 선언 + 행 단위 취소).
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
        // IO(OPTIONAL_INSERT_ONLY) = 신규행에서만 편집 개방하는 표준 타입 — 기존 조회 행은 자동 잠금.
        //   PLANT_SITE_ID 는 IO 로 신규행 전체 개방 후 beginningEdit 이 Division!="81" 을 추가 취소한다.
        inputTpCd: INSERT_EDITABLE_COLUMNS.includes(c.binding)
          ? CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY
          : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        // 콤보 메타 승계 -> 공용 DataGrid 자동 dataMap (AS-IS AddComboColumn CODE -> NAME 표시 + 신규행 편집 드롭다운).
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // 동적 D_ 기간 컬럼 — 2단 헤더 (상단 = SMALL_LABEL_NAME 연속 run 그룹 스팬 / 하단 leaf = COLUMN_LABEL).
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
        width: 100,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // 편집 가부는 beginningEdit 행 단위 판정 (EDIT_FLAG='Y' 또는 신규행) — 컬럼은 편집형 선언
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

    const formatHandler = (_s: FlexGrid<CustPsiUploadRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // AS-IS 상단 그룹 라벨 색 — SAT=Blue / SUN=Red (DAILY 버킷 요일)
        const text = (e.cell.textContent ?? '').trim();
        if (text === 'SAT') e.cell.style.color = '#1e56c8';
        else if (text === 'SUN') e.cell.style.color = '#c0392b';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!binding) return;

      // 편집 가능 셀만 Yellow (D_ 기간 셀 × 편집행 + 신규행 속성 셀), 그 외 White
      const item = (e.panel.rows[e.row] as { dataItem?: CustPsiUploadRow }).dataItem;
      const editable = isEditableCell(item, binding, dynBindings.has(binding));
      toggleClass(e.cell, 'wj-cell-editable', editable);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 가드 — isEditableCell 로 D_ 기간 셀(편집행/신규행) + 신규행 속성 셀만 허용, 그 외 취소.
    const beginningEditHandler = (
      _s: FlexGrid<CustPsiUploadRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      const item = (_s.rows[e.row] as { dataItem?: CustPsiUploadRow }).dataItem;
      if (!isEditableCell(item, binding, dynBindings.has(binding))) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // spdMain_Changed(CellsUpdated) 1:1 — 편집 종료 D_ 셀을 메인으로 통지 (검증+수집은 메인 소관)
    const cellEditEndedHandler = (_s: FlexGrid<CustPsiUploadRow>, e: CellRangeEventArgs) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      if (!dynBindings.has(binding)) return;
      const item = (_s.rows[e.row] as { dataItem?: CustPsiUploadRow }).dataItem;
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

  // 다단 헤더 총높이 48px 불변식 (rAF 상시 감시 — 인스턴스 교체 시 핸들러 이관 + 존재 행 높이 강제)
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<CustPsiUploadRow> | null = null;
    const normalize = (g: FlexGrid<CustPsiUploadRow>) => {
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

  // F4 Filter — 피처 소유 FlexGridFilter
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
    <DataGrid<CustPsiUploadRow>
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      editTrackerRef={editTrackerRef}
      staticColumns={mainStaticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={GRID_COMBO_PARAMS}
      itemsSource={data}
      autoGenerateColumns={false}
      // allowSorting prop 은 넘기지 않는다 - grid.allowSorting 이 truthy 면 wijmo
      //   _MouseHandler._mousedown 이 헤더 클릭 시 열 전체 선택(_mouseSelect)을 건너뛴다.
      //   공용 정렬(F3 스위치 + 헤더 클릭 + 아이콘)은 이 prop 없이도 그대로 동작한다.
    />
  );
};
