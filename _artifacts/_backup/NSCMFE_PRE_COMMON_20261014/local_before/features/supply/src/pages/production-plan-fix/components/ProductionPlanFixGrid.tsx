import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { BUCKET_TYPE } from '../production-plan-fix.constants';
import { WEEKEND_COLOR } from '../production-plan-fix.constants';
import type { MainRow } from '../production-plan-fix.types';
import { buildFixedColumns, buildPivotColumns } from '../utils/productionPlanFixColumns';
import { isoWeek } from '../utils/productionPlanFixDerive';
import { pivotKind, type VisibilityContext } from '../utils/productionPlanFixEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  bucket: BUCKET_TYPE;
  chkSum: boolean;
  visibilityCtx: VisibilityContext;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

const pivotTag = (binding: string): string => binding.slice(2).replace(/[^0-9]/g, '');

// AS-IS GSCM.SCP.Analysis.UIL SCP0024 spdMain — 12 고정(정보/키·MEASURE frozen) + D_/W_/M_ 동적 pivot(3단 헤더).
//   measure=행 축(Prod Plan 위 / Fix Reason 아래). 전 셀 읽기전용 — AS-IS ReadOnlySheetList(cs:415) 재현
//   (사용자 결정 2026-09-26, gap-resolve G20: 편집 band·Fix 저장 경로 제거). 쓰기는 Unfix(선택 셀 기반)뿐.
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M 2행(main/SEARCH·main/SAVE) 등록(05_register.sql). PKG_SCP0024 VALID.
export const ProductionPlanFixGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  bucket,
  chkSum,
  visibilityCtx,
  adminColumns,
  onFocus,
}: Props) => {
  const fixedColumns = useMemo(
    () => buildFixedColumns(adminColumns, visibilityCtx),
    [adminColumns, visibilityCtx]
  );
  const pivotColumns = useMemo(
    () => buildPivotColumns(rows as unknown as Record<string, unknown>[], bucket, chkSum),
    [rows, bucket, chkSum]
  );

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 전 셀 읽기전용 — AS-IS ReadOnlySheetList(cs:415) 엄격 재현(사용자 결정 2026-09-26, gap-resolve G20:
    //   편집 band·Fix 저장 경로 제거). 공용 setEditableColumns 의 cancel 에 더해 양방향으로 확정하고,
    //   Excel 붙여넣기(pastingCell)도 동일하게 차단한다. 화면의 유일한 쓰기는 Unfix(선택 셀 기반 — 편집 불요).
    const readOnlyHandler = (_sender: FlexGridType, e: { cancel: boolean }) => {
      e.cancel = true;
    };
    g.beginningEdit.addHandler(readOnlyHandler);
    g.pastingCell.addHandler(readOnlyHandler);

    // 요일 헤더 색(design 03 §2.1 R-A — 토 Blue / 일 Red).
    //   과거 실적 구간 회색은 AS-IS 근거 부재(react-gap-audit E1, design 03 §2.5 는 "근접"·§6 #6 미확정)라 제거 — 확인필요.
    const formatHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';
      if (ev.panel.cellType === CellType.ColumnHeader) {
        if (pivotKind(binding) !== 'D') return;
        const d = pivotTag(binding);
        if (d.length < 8) return;
        const date = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        const dow = date.getUTCDay();
        if (dow === 6) ev.cell.style.color = WEEKEND_COLOR.SATURDAY; // 토 Blue
        else if (dow === 0) ev.cell.style.color = WEEKEND_COLOR.SUNDAY; // 일 Red
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 기간 헤더 더블클릭 드릴다운 — AS-IS SetDblClickColumnShowHide(SpreadInfo.cs:10838-10885) 재현
    //   (gap-resolve iter-2 G6 — 화면 cs:1130-1143 SpdMain_CellDoubleClick 이 헤더 더블클릭 시 호출).
    //   M_(월 SUM) 헤더: 같은 월의 W_ 컬럼 visible 토글 + 보이는 D_ 컬럼 숨김(cs:10844-10865).
    //   W_(주) 헤더: 같은 ISO 주의 D_ 컬럼 visible 토글(cs:10869-10883).
    //   AS-IS 는 클릭 컬럼부터 다음 M_/W_ 앞까지 블록 순회 — TO-BE 는 같은 월(ym)/주 멤버십으로 등가 판정.
    //   토글 상태는 AS-IS 와 동일하게 비영속(bucket/chkSum 변경·재조회 시 SetSpreadColumn 등가 재계산으로 리셋).
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const kind = pivotKind(binding);
      if (kind !== 'M' && kind !== 'W') return;
      const tag = pivotTag(binding);
      if (kind === 'M') {
        const ym = tag.slice(0, 6);
        for (let i = 0; i < g.columns.length; i++) {
          const b = g.columns[i].binding ?? '';
          const k = pivotKind(b);
          if (k === 'W' && pivotTag(b).slice(0, 6) === ym) {
            g.columns[i].visible = !g.columns[i].visible;
          } else if (k === 'D' && pivotTag(b).slice(0, 6) === ym && g.columns[i].visible) {
            g.columns[i].visible = false;
          }
        }
      } else {
        const year = tag.slice(0, 4);
        const weekNum = Number(tag.slice(6)) || Number(tag.slice(4, 6));
        for (let i = 0; i < g.columns.length; i++) {
          const b = g.columns[i].binding ?? '';
          if (pivotKind(b) !== 'D') continue;
          const d = pivotTag(b);
          if (d.slice(0, 4) === year && isoWeek(d) === weekNum) {
            g.columns[i].visible = !g.columns[i].visible;
          }
        }
      }
    };
    g.hostElement?.addEventListener('dblclick', dblClickHandler);

    // 정보/키 컬럼 세로 병합 — AS-IS siMain.SmartColMerge (gridSignals #18/#28, design 03 R-F).
    //   공용 CustomMergeManager 가 좌측 누적 키로 정보/키 12열만 계층 병합(신규행 제외).
    //   pivot 컬럼(D_/W_/M_)은 병합 대상 아님(buildPivotColumns allowMerging=false).
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      g.columns[i].allowMerging = pivotKind(b) === null;
    }
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(readOnlyHandler);
        g.pastingCell?.removeHandler(readOnlyHandler);
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fixedColumns, pivotColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={fixedColumns}
      dynamicColumns={pivotColumns}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
