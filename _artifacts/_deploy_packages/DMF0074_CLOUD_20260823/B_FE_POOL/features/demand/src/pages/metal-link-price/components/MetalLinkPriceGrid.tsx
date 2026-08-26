import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { rebindFilterColumns } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MAIN_COLUMNS, type MainColumnMeta } from '../metal-link-price.constants';
import type { MetalLinkPriceRow } from '../metal-link-price.types';
import { useMetalLinkPriceStore } from '../useMetalLinkPriceStore';

interface MetalLinkPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<MetalLinkPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MetalLinkPriceRow[];
  // hook #92 — 조회 시점 division (searchParams 아닌 filters 기준 — 조회 전 컬럼 이동 방지)
  searchedDivision: string;
}

// 통합 column meta — admin staticColumns(정본) + MAIN_COLUMNS fallback (visible fallback 손실 금지)
interface MergedColumnMeta {
  binding: string;
  header: string;
  group: string; // 메탈 42 = SMALL_CLASS_LABEL_NAME / Base = '' (라벨과 동일 그룹 = flat)
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  // hook #92 개정 — DIVISION_ID 직접 사용. admin 경로 = 서버측 토큰 필터(fetch 시 divisionId 전달)
  //   완료분이므로 undefined / fallback 경로 = MAIN_COLUMNS 의 DIVISION_ID 스냅샷으로 로컬 필터
  divisionAllow?: string;
}

export const MetalLinkPriceGrid = ({
  gridRef,
  gridFilterRef,
  data,
  searchedDivision,
}: MetalLinkPriceGridProps) => {
  const staticColumn = useMetalLinkPriceStore(state => state.staticColumn);

  // ⭐ admin staticColumns 우선 + MAIN_COLUMNS fallback. Base/메탈 판정 = FIXED_FLAG (실측:
  //   Base 16 = 'Y' / 메탈 42 = 공란). 메탈 그룹 = sClsLblNm (Key/Period(Fr)/… — 라벨과 상이).
  const mergedColumns = useMemo<MergedColumnMeta[]>(() => {
    if (!staticColumn || staticColumn.length === 0) {
      return MAIN_COLUMNS.map<MergedColumnMeta>((c: MainColumnMeta) => ({
        binding: c.key,
        header: c.header,
        group: c.group ?? '',
        width: c.width ?? 100,
        align: c.align ?? 'C',
        visible: c.visible !== false && (c.width ?? 100) > 0,
        display: c._default === true,
        fixed: c.fixed === true,
        divisionAllow: c.divisionAllow,
      }));
    }
    return staticColumn.map(col => {
      const fb = MAIN_COLUMNS.find(m => m.key === col.colNm);
      const group =
        col.sClsLblNm && col.sClsLblNm !== col.colLblNm ? col.sClsLblNm : (fb?.group ?? '');
      return {
        binding: col.colNm,
        header: col.colLblNm || fb?.header || col.colNm,
        group,
        width: col.colWth ?? fb?.width ?? 100,
        align: col.horzAlgnCd ?? fb?.align ?? 'C',
        // AS-IS width 0 = 내부 hidden 컬럼 (DEPT_ID/PLANT_SITE_ID/FCST_TYPE_CODE)
        visible: col.visible !== false && (col.colWth ?? fb?.width ?? 100) > 0,
        display: col.display === true,
        fixed: col.fixed === true, // admin FIXED_FLAG 위임 (Base 16 'Y' — AS-IS Freeze 1:1)
        // ⭐ #92 개정 — 서버가 DIVISION_ID 토큰 필터 완료 (fetch 시 divisionId 전달) → 로컬 필터 불요
        divisionAllow: undefined,
      } as MergedColumnMeta;
    });
  }, [staticColumn]);

  // ⭐ hook #92 개정 — admin 경로는 서버측 DIVISION_ID 필터 완료(divisionAllow=undefined → 통과).
  //   본 로컬 필터는 fallback(MAIN_COLUMNS DIVISION_ID 스냅샷) 전용. 정확 토큰 일치 · 공란 = 항상 표시.
  //   PROJECT_CODE/PROJECT_NAME 토큰에 '40' 없음 → 소형(40) 조회 시 자동 미표시 (AS-IS 스왑 정책 1:1)
  const visibleColumns = useMemo(
    () =>
      mergedColumns.filter(c => {
        if (!c.display || !c.visible) return false;
        const allow = c.divisionAllow?.trim();
        if (!allow) return true;
        if (!searchedDivision) return true;
        return allow
          .split(',')
          .map(s => s.trim())
          .includes(searchedDivision);
      }),
    [mergedColumns, searchedDivision]
  );

  // Base (fixed) — flat staticColumns. 전 컬럼 읽기전용 'S' (AS-IS LockColumn 전셀 잠금 1:1)
  const baseStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns
        .filter(c => !c.group)
        .map(c => ({
          colNm: c.binding,
          colLblNm: c.header,
          colWth: c.width,
          horzAlgnCd: c.align,
          fixed: c.fixed,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })),
    [visibleColumns]
  );

  // ⭐ 메탈 42 — 2단 헤더 (상단 = SMALL_CLASS_LABEL_NAME 연속 run 그룹 / 하단 leaf = 원소 7).
  //   AS-IS CreateSheetHeaderColumn(2, dtTitle) 1:1. group+leaf visible:true 명시 +
  //   allowSorting/allowMerging false + height 24 (#93 2단 = 24×2 — rAF 정규화가 총 48 강제)
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const metal = visibleColumns.filter(c => c.group);
    if (metal.length === 0) return [];
    type Group = { label: string; leafs: FlexGridColumnConfig[] };
    const groups: Group[] = [];
    metal.forEach(c => {
      const leaf: FlexGridColumnConfig = {
        binding: c.binding,
        header: c.header,
        align: c.align === 'R' ? 'right' : c.align === 'L' ? 'left' : 'center',
        width: c.width,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 24,
        isReadOnly: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        _display: true,
      };
      const last = groups[groups.length - 1];
      if (last && last.label === c.group) last.leafs.push(leaf);
      else groups.push({ label: c.group, leafs: [leaf] });
    });
    return groups.map(g => ({
      header: g.label,
      align: 'center',
      allowMerging: false,
      allowSorting: false,
      visible: true,
      height: 24,
      columns: g.leafs,
    }));
  }, [visibleColumns]);

  const metalBindings = useMemo(
    () => new Set(visibleColumns.filter(c => c.group).map(c => c.binding)),
    [visibleColumns]
  );

  // grid 핸들러 — #108 No. 코너 + 헤더 중앙 + zebra (#95: 조회전용 = White+zebra, 전체회색 금지)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGrid<MetalLinkPriceRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        return;
      }
      // ⭐ #108 — rowHeader 순번 컬럼 TopLeft 에 'No.' 라벨 (setCellData 재귀 가드 —
      //   정본 DMF0020 ExchangeRateModal 1:1. 머지는 allowMerging='All' + 동일값 병합)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(e.row, e.col, false) !== 'No.') {
          e.panel.setCellData(e.row, e.col, 'No.');
        }
        e.cell.style.textAlign = 'center';
        e.cell.style.verticalAlign = 'middle';
      }
    };
    g.formatItem.addHandler(formatHandler);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, metalBindings]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 불변식 (customer-fcst-upload rAF 정규화 1:1 —
  //   인스턴스 교체 시 핸들러 이관 + 존재 행 높이 = 48/실제 행수 강제)
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<MetalLinkPriceRow> | null = null;
    const normalize = (g: FlexGrid<MetalLinkPriceRow>) => {
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

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (메탈 PIVOT 컬럼 필터 제외 — DMF0014 패턴)
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
    const cleaned = f.filterColumns.filter(b => !metalBindings.has(b));
    if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
    f.filterApplied.addHandler(onFilterApplied);

    // ⭐ [공통 UC-07, hook #133 §5] 재조회해도 사용자가 걸어둔 **필터가 유지**되어야 한다.
    //   이 화면은 조회마다 baseStaticColumns key 로 DataGrid 를 재마운트하고 메탈 42 dynamicColumns
    //   를 재생성하므로, FlexGridFilter 가 죽은 Column 객체를 붙든 채 남으면 "아이콘은 꺼졌는데
    //   행은 걸러진" 상태가 된다. 끊긴 필터만 재바인딩한다(끊긴 게 없으면 no-op — 유틸 내부 가드).
    //   정본 = business-plan/components/BusinessPlanGrid.tsx:715 (DMF0042).
    rebindFilterColumns(g as unknown as FlexGrid<WijmoRowItem>, f);

    return () => {
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [metalBindings, visibleColumns, gridRef, gridFilterRef]);

  return (
    <DataGrid<MetalLinkPriceRow>
      key={baseStaticColumns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      staticColumns={baseStaticColumns}
      dynamicColumns={dynamicColumns}
      itemsSource={data}
      autoGenerateColumns={false}
      allowSorting={true}
      allowMerging='All'
      isReadOnly={true}
    />
  );
};
