import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { CellType, Column, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { memo, type MutableRefObject, type Ref, useCallback, useEffect, useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { toDisplayDate } from '../../../lib/date';
import { restoreMultiRangeSelection } from '../../../lib/grid';
import type { DemandRow } from '../production-request.types';

import styles from './SampleDemandGrid.module.scss';

// ⭐ SDM2010 샘플 수요 등록 그리드 — 설계서 GRID RIGHT 시트. admin 메타 100% 주도 (컬럼 하드코딩 금지).
//   - 셀 콤보(용도 구분/요청 공정/처리 유형 등) : 메타 FPComboBox + cellCboDataTp 기반 dataMap
//     (CODE→NAME 표시). division 종속 콤보 대비 divisionId 따옴표 전달 — 토큰 없는 콤보는 무해
//     (SDM1020 ProjectListGrid 관례).
//   - DATE 원형 커서 컬럼(출하 필요일/처리 예정일 — FPDate* 메타) : 'YYYY.MM.DD' 표시.
//   - 체크박스 선택(useCheckbox) = 삭제(F9) 대상 수집.

const quoteCombo = (value?: string): string => `'${value && value.trim() !== '' ? value : 'ALL'}'`;

interface Props {
  rows: DemandRow[];
  gridRef: Ref<FlexGridType<DemandRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  divisionId: string;
  staticColumns?: RawFlexGridColumnConfig[];
  /** 프로젝트 단위 쓰기/수정 가능 권한 판단 변수 */
  isEditable: boolean;
}

export const SampleDemandGrid = memo(function SampleDemandGrid({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  divisionId,
  staticColumns,
  isEditable,
}: Props) {
  const { t } = useTranslation();

  // 정적 컬럼 — admin 메타 100% 주도 (visible/display 2 boolean 만. FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );

  // ===== Grid 콤보 — 메타(FPComboBox + cellCboDataTp) 기반 =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(c => String(c.cellCtrlObjTpCd) === 'FPComboBox' && !!c.cellCboDataTp),
    [visibleColumns]
  );
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(
      (c): ComboParam => ({
        comboId: c.cellCboDataTp as string,
        divisionId: quoteCombo(divisionId),
      })
    ),
  });
  // ⚠ division 을 시그니처에 포함 — 미포함 시 division 전환 후 행수가 우연히 같으면
  //   이전 division 의 dataMap 이 잔존한다 (DMF0042 실측 계보)
  const comboSig = comboColumns
    .map((c, i) => `${c.colNm}@${divisionId}#${comboResults?.[i]?.length ?? 0}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      m[c.colNm] = new DataMap(arr.length > 0 ? arr : [{ CODE: '', NAME: '' }], 'CODE', 'NAME');
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, comboColumns, comboResults]);

  const formatRowHeader = useCallback(
    (grid: FlexGridType<DemandRow>, event: FormatItemEventArgs) => {
      if (event.panel.cellType === CellType.RowHeader && event.col === 1) {
        delete event.cell.dataset.status;
        event.cell.textContent = String(event.row + 1);
      } else if (event.panel.cellType === CellType.RowHeader && event.col === 2) {
        delete event.cell.dataset.status;
        event.cell.textContent = '';
        const row = grid.rows[event.row]?.dataItem as DemandRow | undefined;
        if (row?.CRUD_TYPE) event.cell.dataset.status = String(row.CRUD_TYPE);
      } else if (event.panel.cellType === CellType.TopLeft && event.col === 1) {
        event.cell.textContent = t('LBL00674', '_No');
        event.cell.style.textAlign = 'center';
      }
    },
    [t]
  );

  const handleLoadedRows = useCallback(
    (grid: FlexGridType<DemandRow>) => {
      // loadedRows가 DataGrid initialized 완료 전에 올 수 있어 Selector/상태 컬럼 생성 뒤로 미룬다.
      globalThis.queueMicrotask(() => {
        if (
          !grid.hostElement ||
          !grid.hostElement.isConnected ||
          grid.rowHeaders.columns.length < 2
        )
          return;
        if (grid.rowHeaders.columns.length === 2) {
          grid.rowHeaders.columns.insert(1, new Column({ align: 'center', width: 40 }));
        }
        grid.rowHeaders.columns[1].width = 40;
        grid.rowHeaders.columns[2].width = 24;
        grid.formatItem.removeHandler(formatRowHeader);
        grid.formatItem.addHandler(formatRowHeader);
        grid.invalidate(true);
      });
    },
    [formatRowHeader]
  );

  // DATE 원형(ISO 직렬화) 커서 컬럼 표시 — 'YYYY.MM.DD' (FPDate* 메타 — 하드코딩 목록 금지)
  const colMetaByBinding = useMemo(
    () => new Map(visibleColumns.map(c => [c.colNm, c])),
    [visibleColumns]
  );
  const handleFormatItem = useCallback(
    (grid: FlexGridType<DemandRow>, event: FormatItemEventArgs) => {
      if (event.panel.cellType !== CellType.Cell) return;
      const binding = grid.columns[event.col]?.binding ?? '';
      const meta = colMetaByBinding.get(binding);
      if (!meta) return;
      const isEditing = grid.editRange?.contains(event.row, event.col) ?? false;
      const ctrlType = String(meta.cellCtrlObjTpCd ?? '');
      if (ctrlType.startsWith('FPDate') && !isEditing) {
        const row = grid.rows[event.row]?.dataItem as DemandRow | undefined;
        const text = toDisplayDate(row?.[binding]);
        if (event.cell.textContent !== text) event.cell.textContent = text;
      }
    },
    [colMetaByBinding]
  );

  // combo dataMap 적용 — 컬럼 재생성(itemsSource/메타 변경) 후에도 유지 (SDM1020 관례)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<DemandRow> | null } | null)?.current;
    if (!g || !g.columns) return;
    // 쓰기 권한이 없으면 그리드 자체를 ReadOnly 모드로 제어
    g.isReadOnly = !isEditable;

    const applyDataMaps = () => {
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
    };
    g.updatedLayout.addHandler(applyDataMaps);
    applyDataMaps();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDataMaps);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, dataMaps, gridRef, isEditable]);

  return (
    <DataGrid
      key={visibleColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      staticColumns={visibleColumns}
      itemsSource={(rows ?? []) as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowSorting={true}
      // 쓰기 권한이 있을 때만 체크박스 노출
      useCheckbox={isEditable}
      initialized={restoreMultiRangeSelection}
      loadedRows={handleLoadedRows}
      formatItem={handleFormatItem}
    />
  );
});
