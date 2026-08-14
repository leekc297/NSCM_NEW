import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { colorTypeColumnOf, MODAL_ATTR, TAG_ATTR } from '../project-reg.constants';
import type { Tab2Row } from '../project-reg.types';
import styles from '../ProjectReg.module.scss';
import { toDisplayDate } from '../utils/project-reg.validate';

// ⭐ SDM1010 TAB2 '나의 프로젝트 현황' 그리드 — 정적 36컬럼(§5 신본 커서) admin 메타 주도, 조회 전용.
//   MY_WORK 셀(FPModal/ATTRIBUTE1='MyWorkModal' — Search 아이콘) 클릭 → MyWorkModal.
//   TAG 렌더는 TAB1 과 동일 규약 (색 = 커서 `*_COLOR_TYPE` 데이터 주도 — 계약 결정 7).
//   DATE 원형 커서 컬럼(SOP_DATE/REG_COMP_DATE) = 'YYYY.MM.DD' 표시 (계약 결정 8).

interface Props {
  rows: Tab2Row[];
  gridRef: Ref<FlexGridType<Tab2Row>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns?: RawFlexGridColumnConfig[];
  onMyWorkCellClick?: (row: Tab2Row) => void;
}

export const ProjectRegTab2Grid = ({
  rows,
  gridRef,
  gridFilterRef,
  staticColumns,
  onMyWorkCellClick,
}: Props) => {
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const staticBindingSet = useMemo(() => new Set(visibleColumns.map(c => c.colNm)), [visibleColumns]);
  const colMetaRef = useRef<Map<string, RawFlexGridColumnConfig>>(new Map());
  colMetaRef.current = new Map(visibleColumns.map(c => [c.colNm, c]));

  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<Tab2Row> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)

    const formatHandler = (_s: FlexGridType<Tab2Row>, e: FormatItemEventArgs) => {
      if (e.panel === g.topLeftCells) {
        e.cell.style.textAlign = 'center'; // No. 코너 (hook #108 — 공용 'No' 승계)
        return;
      }
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return;
      const rowItem = g.rows[e.row]?.dataItem as Tab2Row | undefined;
      const meta = colMetaRef.current.get(binding);
      if (!rowItem || !meta) return;

      // TAG pill — TAB1 동일 규약 (색 = 커서 `*_COLOR_TYPE` 컬럼 소비 — 데이터 주도)
      if (meta.attribute1 === TAG_ATTR) {
        const text = String(rowItem[binding] ?? '');
        const colorType = String(rowItem[colorTypeColumnOf(binding)] ?? '');
        e.cell.textContent = '';
        if (text !== '') {
          const pill = document.createElement('span');
          pill.className = `${styles.tag} ${styles[`tag${colorType}`] ?? styles.tagGray}`;
          pill.textContent = text;
          e.cell.appendChild(pill);
        }
        return;
      }

      // ⭐ DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (FPDate* 메타 — 계약 결정 8)
      const ctrlType = (meta.cellCtrlObjTpCd as unknown as string) ?? '';
      if (ctrlType.startsWith('FPDate')) {
        const text = toDisplayDate(rowItem[binding]);
        if (e.cell.textContent !== text) e.cell.textContent = text;
        return;
      }

      // MY_WORK 팝업 셀 — 전용 span 아이콘 + pointer (조회 전용 그리드라 편집색 없음)
      if ((meta.cellCtrlObjTpCd as unknown as string) === 'FPModal') {
        e.cell.classList.remove('wj-cell-popup');
        e.cell.style.cursor = 'pointer';
        e.cell.style.paddingRight = '20px';
        if (!e.cell.querySelector('.popup-icon')) {
          const icon = document.createElement('span');
          icon.className = `popup-icon ${styles.popupIcon}`;
          e.cell.appendChild(icon);
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const meta = colMetaRef.current.get(binding);
      if ((meta?.cellCtrlObjTpCd as unknown as string) !== 'FPModal') return;
      const row = g.rows[ht.row]?.dataItem as Tab2Row | undefined;
      if (!row) return;
      if (meta?.attribute1 === MODAL_ATTR.MY_WORK) onMyWorkCellClick?.(row);
    };
    g.hostElement.addEventListener('click', clickHandler);

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, onMyWorkCellClick]);

  // hook #93 — 헤더 총 48px
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<Tab2Row> | null } | null)?.current;
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
  }, [visibleColumns, gridRef]);

  return (
    <DataGrid
      key={visibleColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      staticColumns={visibleColumns}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowSorting={true}
      isReadOnly={true}
    />
  );
};
