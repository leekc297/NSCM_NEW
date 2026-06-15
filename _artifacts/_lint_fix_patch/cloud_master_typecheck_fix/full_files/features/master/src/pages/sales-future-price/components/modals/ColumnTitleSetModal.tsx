import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MAIN_COLUMNS, MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './ColumnTitleSetModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  onSave: (settings: TitleSetRow[]) => void;
}

interface TitleSetRow {
  COLUMN_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  COLUMN_LABEL_NAME: string;
  USER_FLAG: 'Y' | 'N';
  USER_SORT_METHOD_CODE: 'ASC' | 'DESC' | '';
  SUB_TOTAL_FLAG: 'Y' | 'N';
  SORT_ORDER_NO: number;
}

// AS-IS DM0002_TitleSetForm_Popup.cs L170~211 (dual grid + 이동 버튼 + Sort combo)
//   캡쳐 Doc/ui_cap/DMF0020_Grid_Column.png 1:1 매핑
//   SP: DMF0002_GET_TITLESET_POPUP (5 IN: program_id, sheet_name, column_type, user_id, division_id)
//   동작:
//     ① SP 결과 → USER_FLAG 'Y' (우측 User grid) / 'N' (좌측 Base grid) 분할
//     ② → 버튼: 좌 selected → 우측 끝 추가 (USER_FLAG='Y')
//     ③ ← 버튼: 우 selected → 좌측 끝 추가 (USER_FLAG='N')
//     ④ Sort column: User grid 에서 ASC/DESC dropdown
//     ⑤ Default: 초기 SP 결과로 reset
//     ⑥ OK: onSave (USER_FLAG='Y' rows + 순서 + Sort)
export const ColumnTitleSetModal = ({ open, modalClose, onSave }: Props) => {
  const setAlert = useMessageStore.getState().setAlert;
  const baseGridRef = useRef<FlexGridType<TitleSetRow> | null>(null);
  const userGridRef = useRef<FlexGridType<TitleSetRow> | null>(null);

  // SP 호출 — filters 안정화
  const filters = useMemo(
    () => ({ programId: MENU_ID, sheetName: 'main', columnType: 'main', divisionId: '40' } as never),
    [],
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.TITLE_SET,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });

  const beRows = useMemo(() => (data?.o_rc1 ?? []) as unknown as Record<string, string>[], [data]);
  const loading = isLoading || isFetching;

  // BE rows → TitleSetRow 정규화 + fallback (MAIN_COLUMNS)
  const initialRows = useMemo<TitleSetRow[]>(() => {
    if (beRows.length > 0) {
      return beRows.map((r, i) => ({
        COLUMN_NAME: String(r.COLUMN_NAME ?? ''),
        LARGE_CLASS_LABEL_NAME: String(r.LARGE_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? ''),
        SMALL_CLASS_LABEL_NAME: String(r.SMALL_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? ''),
        COLUMN_LABEL_NAME: String(r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
        USER_FLAG: (String(r.USER_FLAG ?? r.VISIBLE_FLAG ?? 'Y') === 'Y' ? 'Y' : 'N'),
        USER_SORT_METHOD_CODE: ((['ASC', 'DESC'].includes(String(r.USER_SORT_METHOD_CODE ?? '')) ? r.USER_SORT_METHOD_CODE : 'ASC') as 'ASC' | 'DESC'),
        SUB_TOTAL_FLAG: (String(r.SUB_TOTAL_FLAG ?? 'N') === 'Y' ? 'Y' : 'N'),
        SORT_ORDER_NO: Number(r.SORT_ORDER_NO ?? i + 1),
      }));
    }
    // fallback (MAIN_COLUMNS) — 14 main visible cols 모두 'Y'
    return MAIN_COLUMNS.map((c, i) => ({
      COLUMN_NAME: c.key,
      LARGE_CLASS_LABEL_NAME: c.header,
      SMALL_CLASS_LABEL_NAME: c.header,
      COLUMN_LABEL_NAME: c.header,
      USER_FLAG: 'Y',
      USER_SORT_METHOD_CODE: 'ASC',
      SUB_TOTAL_FLAG: 'N',
      SORT_ORDER_NO: i + 1,
    }));
  }, [beRows]);

  const [rows, setRows] = useState<TitleSetRow[]>([]);
  const [baseSel, setBaseSel] = useState<TitleSetRow | null>(null);
  const [userSel, setUserSel] = useState<TitleSetRow | null>(null);

  useEffect(() => {
    if (open) setRows(initialRows);
  }, [open, initialRows]);

  const baseRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'N'), [rows]);
  const userRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'Y').sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO), [rows]);

  // → 버튼: 좌 selected → 우측 끝
  const moveToUser = () => {
    if (!baseSel) {
      void setAlert({ type: 'alert', content: '[MSG00099] 좌측 column 선택' });
      return;
    }
    setRows(prev => {
      const maxSeq = Math.max(0, ...prev.filter(r => r.USER_FLAG === 'Y').map(r => r.SORT_ORDER_NO));
      return prev.map(r => r.COLUMN_NAME === baseSel.COLUMN_NAME
        ? { ...r, USER_FLAG: 'Y', SORT_ORDER_NO: maxSeq + 1 }
        : r,
      );
    });
    setBaseSel(null);
  };

  // ← 버튼: 우 selected → 좌측 끝
  const moveToBase = () => {
    if (!userSel) {
      void setAlert({ type: 'alert', content: '[MSG00099] 우측 column 선택' });
      return;
    }
    setRows(prev => prev.map(r => r.COLUMN_NAME === userSel.COLUMN_NAME
      ? { ...r, USER_FLAG: 'N', SORT_ORDER_NO: 0 }
      : r,
    ));
    setUserSel(null);
  };

  const handleDefault = () => { refetch?.(); };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: '[MSG00002] 최소 1개 column 은 표시 상태여야 합니다.' });
      return;
    }
    onSave(userRows);
    modalClose();
  };

  const sortMap = useMemo(() => new DataMap(['ASC', 'DESC']), []);

  // LargeClass / SmallClass 같은 값 row 머지 (AS-IS FPMerge.Always)
  class TitleSetMerge extends MergeManager {
    getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
      if (panel.cellType !== CellType.Cell) return null;
      const col = panel.columns[c];
      const binding = col?.binding ?? '';
      if (binding !== 'LARGE_CLASS_LABEL_NAME' && binding !== 'SMALL_CLASS_LABEL_NAME') return null;
      const view = panel.rows;
      const ri = (i: number): TitleSetRow | undefined =>
        (view[i] as unknown as { dataItem?: TitleSetRow })?.dataItem;
      const cur = ri(r);
      if (!cur) return null;
      const key = binding === 'LARGE_CLASS_LABEL_NAME' ? 'LARGE_CLASS_LABEL_NAME' : 'SMALL_CLASS_LABEL_NAME';
      const sameRow = (a: number, b: number): boolean => {
        const ra = ri(a); const rb = ri(b);
        return !!ra && !!rb && (ra as unknown as Record<string, unknown>)[key] === (rb as unknown as Record<string, unknown>)[key];
      };
      let r1 = r, r2 = r;
      while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
      while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
      if (r1 === r2) return null;
      return new CellRange(r1, c, r2, c);
    }
  }

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 14, height: 14, background: '#1976d2', borderRadius: '50%', color: '#fff', textAlign: 'center', fontSize: 9, lineHeight: '14px' }}>S</div>
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>Column Setting</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container}>
          {/* dual grid + 중앙 버튼 (AS-IS spdBase + → / ← + spdUser) */}
          <div className={styles.dualGrid}>
            {/* 좌측 Base grid */}
            <div className={styles.sideGrid}>
              <FlexGrid
                initialized={(g: FlexGridType<TitleSetRow>) => {
                  baseGridRef.current = g;
                  g.allowMerging = AllowMerging.Cells;
                  for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
                  g.mergeManager = new TitleSetMerge();
                }}
                itemsSource={baseRows}
                autoGenerateColumns={false}
                selectionMode={1}
                selectionChanged={(_s, e) => {
                  setBaseSel(baseRows[e.row] ?? null);
                }}
                style={{ height: '100%' }}
              >
                <FlexGridColumn binding='LARGE_CLASS_LABEL_NAME' header='LargeClass' width={80}  align='left' isReadOnly />
                <FlexGridColumn binding='SMALL_CLASS_LABEL_NAME' header='SmallClass' width={80}  align='left' isReadOnly />
                <FlexGridColumn binding='COLUMN_LABEL_NAME'      header='Column'     width={120} align='left' isReadOnly />
              </FlexGrid>
            </div>

            {/* 중앙 이동 버튼 */}
            <div className={styles.centerBtns}>
              <button type='button' onClick={moveToUser} className={styles.arrowBtn} title='우측 추가'>▶</button>
              <button type='button' onClick={moveToBase} className={styles.arrowBtn} title='좌측 제거'>◀</button>
            </div>

            {/* 우측 User grid (Sort combo 포함) */}
            <div className={styles.sideGrid}>
              <FlexGrid
                initialized={(g: FlexGridType<TitleSetRow>) => {
                  userGridRef.current = g;
                  g.allowMerging = AllowMerging.Cells;
                  for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
                  g.mergeManager = new TitleSetMerge();
                  // Sort 컬럼에 DataMap (ASC/DESC)
                  const sortCol = g.columns.getColumn('USER_SORT_METHOD_CODE');
                  if (sortCol) sortCol.dataMap = sortMap;
                }}
                itemsSource={userRows}
                autoGenerateColumns={false}
                selectionMode={1}
                selectionChanged={(_s, e) => {
                  setUserSel(userRows[e.row] ?? null);
                }}
                cellEditEnded={(s, e) => {
                  const item = s.rows[e.row]?.dataItem as TitleSetRow | undefined;
                  if (!item) return;
                  setRows(prev => prev.map(r => r.COLUMN_NAME === item.COLUMN_NAME
                    ? { ...r, USER_SORT_METHOD_CODE: item.USER_SORT_METHOD_CODE }
                    : r,
                  ));
                }}
                style={{ height: '100%' }}
              >
                <FlexGridColumn binding='LARGE_CLASS_LABEL_NAME' header='LargeClass' width={120} align='left' isReadOnly />
                <FlexGridColumn binding='SMALL_CLASS_LABEL_NAME' header='SmallClass' width={120} align='left' isReadOnly />
                <FlexGridColumn binding='COLUMN_LABEL_NAME'      header='Column'     width={130} align='left' isReadOnly />
                <FlexGridColumn binding='USER_SORT_METHOD_CODE'  header='Sort'       width={80}  align='center' cssClass={styles.sortCell} />
              </FlexGrid>
            </div>
          </div>

          {/* 하단 Default / OK / Cancel */}
          <div className={styles.bottomRow}>
            <span className={styles.hint}>
              {loading ? '⏳ 조회 중...' : `${baseRows.length} hidden / ${userRows.length} visible`}
            </span>
            <button type='button' onClick={handleDefault} className={styles.defaultBtn} disabled={loading}>
              ✓ Default
            </button>
            <button type='button' onClick={handleOk} className={styles.okBtn}>
              ✓ OK
            </button>
            <button type='button' onClick={modalClose} className={styles.cancelBtn}>
              ❌ Cancel
            </button>
          </div>
        </div>
      }
    />
  );
};
