import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { ColumnInsertMergeManager } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MessageRow } from '../sms-setup.types';
import { canEditLanguageCode } from '../sms-setup.util';
import { useSmsSetupStore } from '../useSmsSetupStore';

import styles from './SmsTabGrid.module.scss';

// Category(CATEGORY_ID/CATEGORY_DESC) 는 F8 로 새 행을 추가해도 기존 행과 같은 값이라
// 계속 하나로 병합돼 보여야 한다. 공용 CustomMergeManager 는 Insert 행을 모든 컬럼에서
// 병합 대상에서 빼므로(ColumnInsertMergeManager 주석 참고), 이 두 컬럼만 예외로 둔다.
const CATEGORY_INSERT_MERGE_BINDINGS = new Set(['CATEGORY_ID', 'CATEGORY_DESC']);

interface SmsMessageGridProps {
  gridRef: MutableRefObject<FlexGrid<MessageRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MessageRow[];
  onOpenContent: (row: MessageRow) => void;
  onFocus?: () => void;
}

export const SmsMessageGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onOpenContent,
  onFocus,
}: SmsMessageGridProps) => {
  // SMS Content 셀 더블클릭 → 본문 편집/조회 다이얼로그 (AS-IS PopContent)
  const handleDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (grid.columns[hitTest.col]?.binding !== 'MESSAGE_CONTENT') return;

    const row = grid.rows[hitTest.row]?.dataItem as MessageRow | undefined;
    if (!row) return;

    onOpenContent(row);
  };

  const messageColumns = useSmsSetupStore(state => state.messageColumns);

  // LANGUAGE_CODE 는 신규 행(F8 Insert)만 편집 가능 — AS-IS SprMessage_CellClick(cs:1082-1085) 의
  // strState !== "I" 편집 취소와 동일 규칙. DB 컬럼 메타(inputTpCd)만으로는 오적재 사고에 취약하므로
  // SmsCategoryGrid 의 formatItem·beginningEdit 조합과 동일한 화면 레벨 방어선을 둔다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatItemHandler = (sender: FlexGrid<MessageRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding;
      if (binding !== 'LANGUAGE_CODE') return;
      const row = sender.rows[e.row]?.dataItem as MessageRow | undefined;
      if (!row) return;
      if (!canEditLanguageCode(row)) toggleClass(e.cell, 'wj-cell-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    const beginningEditHandler = (
      sender: FlexGrid<MessageRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'LANGUAGE_CODE') return;
      const row = sender.rows[e.row]?.dataItem as MessageRow | undefined;
      if (!row) return;
      if (!canEditLanguageCode(row)) e.cancel = true;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    return () => {
      grid.formatItem.removeHandler(formatItemHandler);
      grid.beginningEdit.removeHandler(beginningEditHandler);
    };
  }, [gridRef, messageColumns]);

  // Category 컬럼은 F8 로 추가한 신규 행도 병합돼 보여야 한다 — 공용 CustomMergeManager 기본값
  // (Insert 행은 전 컬럼 병합 제외)을 이 두 컬럼만 예외로 두는 ColumnInsertMergeManager 설치.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    if (grid.mergeManager instanceof ColumnInsertMergeManager) return;
    grid.mergeManager = new ColumnInsertMergeManager(grid, CATEGORY_INSERT_MERGE_BINDINGS);
  }, [gridRef, messageColumns]);

  return (
    <div className={styles.gridWrapper}>
      <DataGrid<MessageRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={messageColumns}
        useSummaryTooltip={false}
        dblClick={handleDoubleClick}
        gotFocus={onFocus}
        // AS-IS SCM0007_SMS_Setup.cs:231 FPMerge.Always — Category 는 항상 한 카테고리만 조회되므로
        // 화면에 보이는 모든 행이 같은 값이라 세로 병합된 한 칸으로 보인다. 신규 Insert 행까지
        // 병합하는 예외는 위 ColumnInsertMergeManager 설치 effect 가 담당한다.
        allowMerging={AllowMerging.Cells}
      />
    </div>
  );
};
