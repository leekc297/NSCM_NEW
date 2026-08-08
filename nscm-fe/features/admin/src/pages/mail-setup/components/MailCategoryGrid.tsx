import { CellType, DataMap, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { COMBO_ID, CYCLE_DETAIL_PARENT } from '../mail-setup.constants';
import type { CategoryRow, ComboOption } from '../mail-setup.types';
import {
  canEditSendMinTime,
  canEditSendTime,
  filterCycleDetail,
  resolveSendTimeParent,
} from '../mail-setup.util';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailCategoryGrid.module.scss';

interface MailCategoryGridProps {
  gridRef: MutableRefObject<FlexGrid<CategoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<CategoryRow> | undefined>;
  data: CategoryRow[];
  onGridClick: () => void;
  onOpenSqlDialog: (row: CategoryRow) => void;
}

/** 편집 진입 시 dataMap 스왑 대상 (hook #59 §5-G — 정본 SalesPlanGrid) */
const SWAP_BINDINGS = new Set([
  'SUB_MODULE_CODE',
  'DETAIL_CLASS_CODE',
  'SEND_TIME_TEXT',
  'SEND_MIN_TIME_TEXT',
]);

export const MailCategoryGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  onGridClick,
  onOpenSqlDialog,
}: MailCategoryGridProps) => {
  const { t } = useTranslation();

  const categoryColumns = useMailSetupStore(state => state.categoryColumns);
  const selectCategory = useMailSetupStore(state => state.selectCategory);
  const setAlert = useMessageStore(state => state.setAlert);

  // 콤보 원천 — MailSendCycleDetail(Sub1~3)/MailSubModule 은 PARENT_CODE 를 포함해 내려온다 (CMBO 실측)
  const [cycleDetails, subModules] = useTabComboQueries({
    filters: [COMBO_ID.CYCLE_DETAIL, COMBO_ID.SUB_MODULE],
  });
  const cycleDetailRowsRef = useRef<ComboOption[]>([]);
  cycleDetailRowsRef.current = (cycleDetails as ComboOption[] | undefined) ?? [];
  const subModuleRowsRef = useRef<ComboOption[]>([]);
  subModuleRowsRef.current = (subModules as ComboOption[] | undefined) ?? [];

  // 행 선택 → Message / 수신자 디테일 조회 (AS-IS: Category 행 선택 시 두 탭 동시 갱신)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleSelectionChanged = (sender: FlexGrid<CategoryRow>) => {
      const row = sender.selectedItems?.[0] as CategoryRow | undefined;
      selectCategory(row);
    };

    grid.selectionChanged.addHandler(handleSelectionChanged);
    return () => grid.selectionChanged.removeHandler(handleSelectionChanged);
  }, [gridRef, selectCategory, categoryColumns]);

  // ===== Period cascade — 편집 진입 dataMap 스왑 + 선행값 차단 / 편집 종료 원복 + 하위 클리어 =====
  //   (AS-IS E08/E09 — C2~C7. 정본 SalesPlanGrid beginningEdit/cellEditEnded hook #59 §5-G)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // 스왑 전 원본 dataMap 백업 — 원복 누락 시 필터 밖 CODE 보유 타 행의 명칭 변환이 파손된다
    const originalMaps: Record<string, DataMap | null | undefined> = {};

    const beginningEdit = (
      s: FlexGrid<CategoryRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      // wrapper(setEditableColumns)가 이미 차단한 셀('IM' 기존 행 등)은 그대로 둔다
      if (e.cancel) return;
      const col = s.columns[e.col];
      const binding = col?.binding ?? '';
      if (!SWAP_BINDINGS.has(binding)) return;
      const row = s.rows[e.row]?.dataItem as CategoryRow | undefined;
      if (!row) return;

      const cancelWith = (msgId?: string, fallback?: string) => {
        e.cancel = true;
        if (msgId) void setAlert({ type: 'alert', content: t(msgId, fallback ?? '') });
      };
      const swap = (options: ComboOption[]) => {
        if (originalMaps[binding] === undefined) originalMaps[binding] = col.dataMap ?? null;
        col.dataMap = new DataMap(options, 'CODE', 'NAME');
      };

      switch (binding) {
        // C2 — Module 미선택 시 차단(MSG00692), 선택 시 SubModule 콤보를 해당 Module 로 필터
        case 'SUB_MODULE_CODE': {
          if (!row.MODULE_CODE) {
            cancelWith('MSG00692', '_Select a module first!');
            return;
          }
          swap(filterCycleDetail(subModuleRowsRef.current, row.MODULE_CODE));
          return;
        }
        // C3 — Main(주기) 미선택 시 차단(MSG00693), 선택 시 Sub1 콤보를 CYCLE=Main 으로 필터
        case 'DETAIL_CLASS_CODE': {
          if (!row.CYCLE_CLASS_CODE) {
            cancelWith('MSG00693', '_Select Period first!');
            return;
          }
          swap(filterCycleDetail(cycleDetailRowsRef.current, row.CYCLE_CLASS_CODE));
          return;
        }
        // C4 — Main=RT 편집 차단 / Sub1 미선택 차단 / M*·W* → 시각(DAY) 목록, 그 외 → 분(HOUR) 목록
        case 'SEND_TIME_TEXT': {
          if (!canEditSendTime(row.CYCLE_CLASS_CODE)) {
            cancelWith();
            return;
          }
          if (!row.DETAIL_CLASS_CODE) {
            cancelWith('MSG00693', '_Select Period first!');
            return;
          }
          swap(
            filterCycleDetail(
              cycleDetailRowsRef.current,
              resolveSendTimeParent(row.DETAIL_CLASS_CODE)
            )
          );
          return;
        }
        // C5 — Main=DAY/RT 편집 차단 (분 단위는 MONTH/WEEK 만), 후보 = 분(HOUR) 목록
        case 'SEND_MIN_TIME_TEXT': {
          if (!canEditSendMinTime(row.CYCLE_CLASS_CODE)) {
            cancelWith();
            return;
          }
          swap(filterCycleDetail(cycleDetailRowsRef.current, CYCLE_DETAIL_PARENT.MINUTE_LIST));
          return;
        }
        default:
          return;
      }
    };

    const cellEditEnded = (
      s: FlexGrid<CategoryRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const col = s.columns[e.col];
      const binding = col?.binding ?? '';

      // ⭐ 스왑 원복 (취소 포함 — hook #59 §5-G)
      if (SWAP_BINDINGS.has(binding) && originalMaps[binding] !== undefined) {
        col.dataMap = originalMaps[binding] ?? null;
      }

      const row = s.rows[e.row]?.dataItem as CategoryRow | undefined;
      if (!row) return;
      const oldValue = e.data;
      const newValue = row[binding as keyof CategoryRow];
      if (oldValue === newValue) return;

      // cascade clear — Main→Sub1·2·3 / Sub1→Sub2·3 / Sub2→Sub3 / Module→SubModule (C6/C7·C2)
      switch (binding) {
        case 'MODULE_CODE':
          row.SUB_MODULE_CODE = '';
          break;
        case 'CYCLE_CLASS_CODE':
          row.DETAIL_CLASS_CODE = '';
          row.SEND_TIME_TEXT = '';
          row.SEND_MIN_TIME_TEXT = '';
          break;
        case 'DETAIL_CLASS_CODE':
          row.SEND_TIME_TEXT = '';
          row.SEND_MIN_TIME_TEXT = '';
          break;
        case 'SEND_TIME_TEXT':
          row.SEND_MIN_TIME_TEXT = '';
          break;
        default:
          return;
      }
      s.invalidate(true);
    };

    grid.beginningEdit.addHandler(beginningEdit);
    grid.cellEditEnded.addHandler(cellEditEnded);
    return () => {
      grid.beginningEdit.removeHandler(beginningEdit);
      grid.cellEditEnded.removeHandler(cellEditEnded);
    };
  }, [gridRef, categoryColumns, setAlert, t]);

  // SQL VIEW 셀 더블클릭 → PopSQL (AS-IS: CATEGORY_ID 가 있는 저장된 행만)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (grid.columns[hitTest.col]?.binding !== 'VIEW') return;

    const row = grid.rows[hitTest.row]?.dataItem as CategoryRow | undefined;
    if (!row?.CATEGORY_ID) return;

    onOpenSqlDialog(row);
  };

  return (
    <div className={styles.gridSection}>
      <div className={styles.gridWrapper}>
        <DataGrid<CategoryRow>
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          itemsSource={data}
          staticColumns={categoryColumns}
          useSummaryTooltip={false}
          dblClick={handleDoubleClick}
          click={onGridClick}
        />
      </div>
    </div>
  );
};
