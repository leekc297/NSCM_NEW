import { toggleClass } from '@mescius/wijmo';
import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { CategoryRow } from '../sms-setup.types';
import { canEditModuleKey, canEditSendTime } from '../sms-setup.util';
import { useSmsSetupStore } from '../useSmsSetupStore';

import styles from './SmsCategoryGrid.module.scss';

const MODULE_KEY_BINDINGS = new Set(['MODULE_CODE', 'SUB_MODULE_CODE']);

interface SmsCategoryGridProps {
  gridRef: MutableRefObject<FlexGrid<CategoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: CategoryRow[];
  onFocus?: () => void;
}

// AS-IS SCM0007 은 SCM0006(Mail)과 달리 SQL VIEW 컬럼/팝업이 없다 — Roslyn spCalls 에 SQL_TEXT
// 조회/저장 SP 가 존재하지 않아 확인됨(anti-simplification: 근거 없는 기능 추가 금지). 그래서 이 그리드는
// MailCategoryGrid 의 VIEW 버튼 렌더링 로직 없이 표준 DataGrid 만 사용한다.
export const SmsCategoryGrid = ({ gridRef, gridFilterRef, data, onFocus }: SmsCategoryGridProps) => {
  const { t } = useTranslation();

  const categoryColumns = useSmsSetupStore(state => state.categoryColumns);
  const selectCategory = useSmsSetupStore(state => state.selectCategory);
  const setAlert = useMessageStore(state => state.setAlert);

  // 행 선택 → Message / 수신자(SMS Group 할당) 디테일 조회 (AS-IS: Category 행 선택 시 두 탭 동시 갱신)
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

  // 편집 잠금(흰색 처리 + beginningEdit cancel) + 선행 컬럼 미선택 안내(GC1/GC2) + 파생 초기화
  // (cellEditEnded) — TactTimeMainGrid / SalesPlanGrid 의 beginningEdit·formatItem·cellEditEnded
  // 조합 패턴과 동일.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    // 잠금 판정 — MODULE_CODE/SUB_MODULE_CODE 는 기존 행(D4), SEND_TIME_TEXT 는 Main=DAY/RT(GC3).
    const isCellLocked = (binding: string, row: CategoryRow) => {
      if (MODULE_KEY_BINDINGS.has(binding)) return !canEditModuleKey(row);
      if (binding === 'SEND_TIME_TEXT') return !canEditSendTime(row.CYCLE_CLASS_CODE);
      return false;
    };

    // DataGrid 공통 wrapper(dataGridUtils.ts)가 DB 메타(INPUT_TP_CD) 기준으로 이미
    // 'wj-cell-editable'(노란색)을 붙여 둔 상태 — 여기서는 화면 업무 규칙으로 잠근 셀만 그 클래스를
    // 강제로 떼어 기본색(흰색)으로 되돌린다. SalesSiteGrid 등 잠금 예외가 없는 화면과 동일하게, 이 셀은
    // 별도 회색 처리를 두지 않는다(수정불가 = 흰색, 수정가능 = 노란색 2색 규약).
    const formatItemHandler = (sender: FlexGrid<CategoryRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding;
      if (!binding) return;
      const row = sender.rows[e.row]?.dataItem as CategoryRow | undefined;
      if (!row) return;
      if (isCellLocked(binding, row)) toggleClass(e.cell, 'wj-cell-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    const beginningEditHandler = (
      sender: FlexGrid<CategoryRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as CategoryRow | undefined;
      if (!row) return;

      // GC1 — SUB_MODULE_CODE 는 MODULE_CODE 선택 전엔 편집 진입 자체를 막고 안내한다(AS-IS MSG01451).
      if (binding === 'SUB_MODULE_CODE' && !row.MODULE_CODE) {
        e.cancel = true;
        void setAlert({ type: 'alert', content: t('MSG01451', '_모듈을 먼저 선택해 주세요.') });
        return;
      }
      // GC2 — DETAIL_CLASS_CODE 는 CYCLE_CLASS_CODE(Main) 선택 전엔 편집 진입을 막고 안내한다(AS-IS MSG01449).
      if (binding === 'DETAIL_CLASS_CODE' && !row.CYCLE_CLASS_CODE) {
        e.cancel = true;
        void setAlert({ type: 'alert', content: t('MSG01449', '_주기를 먼저 선택해 주세요.') });
        return;
      }

      if (isCellLocked(binding, row)) e.cancel = true;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    // GC4 — Main 변경 시 Sub1·Sub2 초기화, Sub1 변경 시 Sub2 초기화. 트리거 컬럼 편집으로 해당 행의
    // CRUD_TYPE 은 이미 'M' 이 찍혀 있어 리셋 대상 필드는 값만 지우면 저장 대상에 함께 포함된다.
    const cellEditEndedHandler = (sender: FlexGrid<CategoryRow>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as CategoryRow | undefined;
      if (!row) return;

      if (binding === 'CYCLE_CLASS_CODE') {
        row.DETAIL_CLASS_CODE = '';
        row.SEND_TIME_TEXT = '';
      } else if (binding === 'DETAIL_CLASS_CODE') {
        row.SEND_TIME_TEXT = '';
      } else {
        return;
      }
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);
    grid.pastedCell.addHandler(cellEditEndedHandler);

    return () => {
      grid.formatItem.removeHandler(formatItemHandler);
      grid.beginningEdit.removeHandler(beginningEditHandler);
      grid.cellEditEnded.removeHandler(cellEditEndedHandler);
      grid.pastedCell.removeHandler(cellEditEndedHandler);
    };
  }, [gridRef, categoryColumns, setAlert, t]);

  return (
    <div className={styles.gridSection}>
      <div className={styles.gridWrapper}>
        <DataGrid<CategoryRow>
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          itemsSource={data}
          staticColumns={categoryColumns}
          useSummaryTooltip={false}
          gotFocus={onFocus}
        />
      </div>
    </div>
  );
};
