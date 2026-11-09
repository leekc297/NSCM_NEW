import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS, type BohMode } from '../shipment-request-electrode.constants';
import type { SearchParamProps, ShipmentPsiRow } from '../shipment-request-electrode.types';
import {
  bohSumColumnVisibility,
  isDynamicColumnVisible,
  parseDynamicColumnTag,
} from '../utils/shipment-request-electrode.dynamicColumn';
import {
  buildDynamicColumns,
  buildDynColMetas,
  buildWeekendColorByBinding,
  type DynColMeta,
  dynKindOf,
  SpreadHeaderMergeManager,
  type SpreadTitleRow,
} from '../utils/shipment-request-electrode.spreadHeader';

interface Props {
  rows: ShipmentPsiRow[];
  gridRef: MutableRefObject<FlexGridType<ShipmentPsiRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  bohMode: BohMode;
  bucketType: SearchParamProps['bucketType'];
  sumChecked: boolean;
  pastPeriodChecked: boolean;
  planDate: string;
  // GET_SHEET_CALENDAR_3SPAN(배포됨) 동적 pivot 헤더 메타 — 3단 병합 헤더(년월/주차/일) 라벨 소스.
  //   BOH축(X/Y/Z)·버킷(D/W/M) 전체를 캘린더 기반으로 반환. 미전달이면 조회 row 의 동적 키에서 파생.
  spreadTitle?: SpreadTitleRow[];
  onFocus: () => void;
  onCellDoubleClick?: (row: ShipmentPsiRow) => void;
}

/**
 * spdMain(siMain) — Shipment Request(Electrode) pivot 메인그리드. 표시전용(design 03 §1.1, isReadOnly).
 * 동적 pivot 컬럼은 GET_SHEET_CALENDAR_3SPAN(spreadTitle)이 주는 3단(년월/주차/일) 구조를 공용 DataGrid
 * 중첩 columnGroups + SpreadHeaderMergeManager 로 재현한다(자매 SSP0026 ShipmentRequestPackMainGrid 동일 체계).
 * 표시 대상 컬럼은 AS-IS SetSpreadColumn(cs:1895-2092) 규칙 — BOH축(bohMode→X/Y/Z) 1세트 + 버킷(D/W/M)
 * + chkSum + pastPeriod — 을 isDynamicColumnVisible 로 걸러 넘긴 메타만 렌더한다.
 */
export const ShipmentRequestElectrodeMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  staticColumns,
  bohMode,
  bucketType,
  sumChecked,
  pastPeriodChecked,
  planDate,
  spreadTitle,
  onFocus,
  onCellDoubleClick,
}: Props) => {
  // 9칼럼 3-way BOH(UOM Type) 표시모드 토글(design 01 R4) — staticColumns 배열을 새로 만들어 넘기면
  //   UOM Type 변경마다 staticColumns prop 참조가 바뀌어 columnGroups 가 재생성되고 다단 헤더가 부풀었다
  //   줄어든다. 그래서 배열은 그대로 넘기고(참조 유지) 활성 세트의 visible 만 런타임으로 g.columns 에
  //   토글한다(동적 컬럼 applyDynVisibility 와 동일 원리 — 재빌드 없이 visible 만).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyBohSumVisibility = () => {
      const sumVisibility = bohSumColumnVisibility(bohMode);
      let changed = false;
      for (const colNm of Object.keys(sumVisibility)) {
        const col = g.getColumn(colNm);
        if (col && col.visible !== sumVisibility[colNm]) {
          col.visible = sumVisibility[colNm];
          changed = true;
        }
      }
      if (changed) g.invalidate();
    };
    g.updatedLayout.addHandler(applyBohSumVisibility);
    applyBohSumVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyBohSumVisibility);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [bohMode, staticColumns]);

  // 동적 메타 — spreadTitle(캘린더) 우선, 없으면 조회 row 의 동적 키에서 파생(SP 미응답 fallback).
  //   fallback 은 rows 참조가 아니라 '동적 키 서명'에만 의존 — 행추가/재조회마다 columnGroups 재생성(깜빡임) 방지
  //   ([[dynamic-columns-memo-on-data-identity-rebuilds-header-flash]]).
  const rowDynKeySig = useMemo(() => {
    if ((spreadTitle?.length ?? 0) > 0) return ''; // spreadTitle 우선 경로 — rows 미참조
    const set = new Set<string>();
    rows.forEach(row => {
      Object.keys(row as Record<string, unknown>).forEach(key => {
        if (parseDynamicColumnTag(key)) set.add(key);
      });
    });
    return [...set].sort().join(',');
  }, [spreadTitle, rows]);

  // 드릴다운 지원(AS-IS SetSpreadColumn + 헤더 더블클릭, 자매 SSP0026 체계 이식) — 활성 버킷만 남기지
  //   않고, 활성 BOH축에서 '언젠가 보일 수 있는' 전 버킷(M/W/D) 컬럼을 모두 만든다. 자기 버킷 기준
  //   isDynamicColumnVisible 로 걸러(BOH축 접두·D_ pastPeriod 반영) 렌더 대상 메타를 정한다 →
  //   표시/숨김은 아래 applyDynVisibility 가 base(현재 버킷 규칙) + 드릴 오버라이드로 제어한다.
  //   (활성 버킷만 만들던 종전 구현은 Monthly 에서 W_/D_ 컬럼 자체가 없어 드릴 대상이 없었다.)
  //   컬럼 '존재'는 조회 결과(spreadTitle/동적 키)에만 의존시킨다 — BOH축(UOM Type)·버킷·chkSum·
  //   pastPeriod 는 전부 '표시' 문제라 baseVisible·applyDynVisibility 가 visible 로만 처리한다. 이렇게
  //   해야 UOM Type 라디오·Bucket·Including Past Period 토글이 columnGroups 를 재생성하지 않아(참조 유지)
  //   다단 헤더가 부풀었다 줄어드는 깜빡임이 없다(dynamic-columns-memo-on-data-identity-rebuilds-header-flash).
  //   전 축(X/Y/Z)을 함께 빌드하므로 월 그룹키에 축 접두를 포함한다(spreadHeader buildDynamicColumns).
  const renderMetas = useMemo(
    () => buildDynColMetas(spreadTitle, rowDynKeySig ? rowDynKeySig.split(',') : []),
    [spreadTitle, rowDynKeySig]
  );

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns(renderMetas),
    [renderMetas]
  );

  // 주말 D_ leaf 헤더 색(토 파랑 / 일 빨강, AS-IS cs:767) — formatItem(헤더)이 ref 로 최신 맵을 읽는다.
  const weekendColorRef = useRef<Map<string, string>>(new Map());
  weekendColorRef.current = useMemo(() => buildWeekendColorByBinding(renderMetas), [renderMetas]);

  // 기본 표시(base) 맵 — 현재 버킷/chkSum/pastPeriod 규칙(isDynamicColumnVisible). 드릴 오버라이드가
  //   없으면 이 값이 그대로 col.visible 이 된다.
  const dynBindings = useMemo(() => renderMetas.map(m => m.binding), [renderMetas]);
  const baseVisible = useMemo(() => {
    const map = new Map<string, boolean>();
    renderMetas.forEach(m =>
      map.set(
        m.binding,
        isDynamicColumnVisible(m.binding, {
          bohMode,
          bucketType,
          sumChecked,
          pastPeriodChecked,
          planDateYyyymmdd: planDate,
        })
      )
    );
    return map;
  }, [renderMetas, bohMode, bucketType, sumChecked, pastPeriodChecked, planDate]);
  const baseVisibleRef = useRef(baseVisible);
  baseVisibleRef.current = baseVisible;
  const dynBindingsRef = useRef(dynBindings);
  dynBindingsRef.current = dynBindings;
  // 드릴 매칭용 binding→meta 맵(월키·주차명 기준 그룹핑). 정렬 순서에 의존하지 않는다.
  const metaByBindingRef = useRef<Map<string, DynColMeta>>(new Map());
  metaByBindingRef.current = useMemo(
    () => new Map(renderMetas.map(m => [m.binding, m] as const)),
    [renderMetas]
  );
  // 드릴 오버라이드(binding → visible). bucket/조회/조건 변경 시 리셋(AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3) — [[grid-two-tier-header-row-height-per-row]].
  //   DataGrid 의 headerRowHeight prop(defaultSize 만)은 전역 조밀 행높이에 덮이므로 updatedLayout 에서 강제.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynamicColumns, staticColumns]);

  // spdMain 병합(AS-IS SmartColMerge + 월 SUM 헤더 세로병합) — 좌측 정적 컬럼 데이터셀 계층 세로병합 +
  //   정적 헤더 세로 span + 월(M_) SUM 세로병합. 동적·MEASURE 데이터셀은 비병합. columnGroups 재대입이
  //   allowMerging 을 리셋하므로 컬럼 변경마다 재적용(SSP0026 동일).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fixed = new Set(staticColumns.map(c => c.colNm));
    g.mergeManager = new SpreadHeaderMergeManager(staticColumns.map(c => c.colNm));
    for (let i = 0; i < g.columns.length; i++) {
      g.columns[i].allowMerging = fixed.has(g.columns[i].binding ?? '');
    }
    g.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynamicColumns, staticColumns]);

  // 주말 D_ leaf 헤더 글자색(토 파랑 / 일 빨강). 헤더 최하단(leaf) 행만 대상.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fmt = (_s: FlexGridType<ShipmentPsiRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.ColumnHeader) return;
      const isLeafHeaderRow = e.row === e.panel.rows.length - 1;
      if (!isLeafHeaderRow) return;
      const headerBinding = e.panel.columns[e.col]?.binding;
      const color = headerBinding ? weekendColorRef.current.get(headerBinding) : undefined;
      if (color) e.cell.style.setProperty('color', color, 'important');
    };
    g.formatItem.addHandler(fmt);
    g.invalidate();
    return () => {
      try {
        g.formatItem?.removeHandler(fmt);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynamicColumns]);

  // 동적 컬럼 visible 적용 — base(현재 버킷 규칙) 기본, 드릴 오버라이드(drillVisRef) 우선.
  //   columnGroups 재대입마다(updatedLayout) 되돌아가므로 매번 재적용. bucket/조건 변경 = 드릴 리셋.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    drillVisRef.current.clear(); // bucket/BOH/chkSum/pastPeriod/조회 변경 = 드릴 상태 리셋
    const dynSet = new Set(dynBindingsRef.current);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const base = baseVisibleRef.current.get(b) ?? false;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynBindings, bucketType, sumChecked, pastPeriodChecked, bohMode, planDate, staticColumns]);

  // 헤더 더블클릭 드릴다운(AS-IS SetSpreadColumn 더블클릭). M_(SUM) 헤더: 그 달 주차(W_) 토글 +
  //   일(D_) 접기. W_ 헤더: 그 주 일(D_) 토글. **정렬 순서에 의존하지 않고 월키(YYYYMM)·주차명(small)
  //   그룹 매칭으로 대상 선정** — 이 화면의 3SPAN SP 는 SORT_ORDER_NO 가 문자열('X_날짜_접미')이라
  //   buildDynColMetas 의 Number() 가 NaN → 정렬이 binding 문자열(종류 D/M/W 별)로 뭉쳐, SSP0026 식
  //   선형 인접스캔이 동작하지 못했다(월 블록이 안 묶임). 데이터셀 더블클릭(MEASURE 팝업)은 아래
  //   handleDblClick(DataGrid dblClick prop)이 따로 담당한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = dynKindOf(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const head = metaByBindingRef.current.get(hb);
      if (!head) return;
      const metas = [...metaByBindingRef.current.values()];
      // 축+월키 — 전 축을 함께 빌드하므로 축 접두(X_/Y_/Z_, 2글자)까지 포함해야 다른 축의 같은 달을
      //   건드리지 않는다. 접두 2글자 + 버킷 2글자(4) 뒤 6자리가 년월.
      const axisMonth = (b: string) => b.slice(0, 2) + b.slice(4, 10);
      const monthKey = axisMonth(hb);
      const isHidden = (b: string) => !g.getColumn(b)?.visible;
      const setVis = (targets: DynColMeta[], visible: boolean) =>
        targets.forEach(m => drillVisRef.current.set(m.binding, visible));
      if (hk === 'M') {
        // 그 달 주차(W_) 토글 — 하나라도 숨어 있으면 전부 펴기, 아니면 전부 접기. 일(D_)은 항상 접기.
        const weeks = metas.filter(m => m.kind === 'W' && axisMonth(m.binding) === monthKey);
        const days = metas.filter(m => m.kind === 'D' && axisMonth(m.binding) === monthKey);
        setVis(weeks, weeks.some(m => isHidden(m.binding)));
        setVis(days, false);
      } else {
        // 그 주 일(D_) 토글 — 같은 달·같은 주차명(small)인 D_ 가 그 주 소속(buildDynamicColumns 2단 묶음 기준).
        const days = metas.filter(
          m => m.kind === 'D' && axisMonth(m.binding) === monthKey && m.small === head.small
        );
        setVis(days, days.some(m => isHidden(m.binding)));
      }
      applyDynVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);
    return () => {
      try {
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // AS-IS SpdMain_CellDoubleClick(cs:1362-1420) — MEASURE-1 컬럼 더블클릭 시 ShipmentRequestPopup 오픈
  //   (bRealFlag 가드). 팝업 자체는 이번 회차 미착수(04 미완 항목).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (dataItem) onCellDoubleClick?.(dataItem);
  };

  return (
    <DataGrid<ShipmentPsiRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
      allowMerging={AllowMerging.All}
      isReadOnly
      gotFocus={onFocus}
      dblClick={handleDblClick}
    />
  );
};
