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

import styles from './ColumnSettingModal.module.scss';

// 공용 Column Setting popup (사용자 명시 2026-06-03):
//   - AS-IS DM0002_TitleSetForm_Popup.cs 동등 동작 (Base/User dual grid + 이동 + Sort combo)
//   - 화면별 props 로 menuId / sheetName / columnType / divisionId 전달
//   - SP DMF0002_GET_TITLESET_POPUP 호출 (BE PROC_M COL_NM auto-fill)
//   - BE 결과 없으면 fallbackColumns 사용 (Hybrid Option C)
//
// 사용 화면: DMF0020 (Sales Future Price) / DMF0043_01 (Contribute View)

export interface ColumnSettingFallback {
  key: string;
  header: string;
  width?: number;
}

export interface ColumnSettingRow {
  COLUMN_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  COLUMN_LABEL_NAME: string;
  USER_FLAG: 'Y' | 'N';
  USER_SORT_METHOD_CODE: 'ASC' | 'DESC' | '';
  SUB_TOTAL_FLAG: 'Y' | 'N';
  SORT_ORDER_NO: number;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 화면 메뉴 ID — SP `programId` 인자 */
  menuId: string;
  /** SP 의 sheetName 인자 (예: 'main', 'ContributeSalesList') */
  sheetName: string;
  /** SP 의 columnType 인자 (예: 'main', 'C') — 기본 sheetName 과 동일 */
  columnType?: string;
  /** SP 의 divisionId 인자 */
  divisionId?: string;
  /** BE 결과 없을 때 fallback (FE column meta) */
  fallbackColumns?: ColumnSettingFallback[];
  /** OK 클릭 시 callback — User flag='Y' rows + sort order + Sort method */
  onSave: (settings: ColumnSettingRow[]) => void;
  /** popup title (기본: 'Column Setting') */
  title?: string;
}

export const ColumnSettingModal = ({
  open,
  modalClose,
  menuId,
  sheetName,
  columnType,
  divisionId,
  fallbackColumns = [],
  onSave,
  title = 'Column Setting',
}: Props) => {
  const setAlert = useMessageStore.getState().setAlert;
  const baseGridRef = useRef<FlexGridType<ColumnSettingRow> | null>(null);
  const userGridRef = useRef<FlexGridType<ColumnSettingRow> | null>(null);

  // SP 호출 — filters useMemo 안정화 (refetch loop 방지)
  const filters = useMemo(
    () => ({
      programId: menuId,
      sheetName,
      columnType: columnType ?? sheetName,
      divisionId: divisionId ?? '40',
    } as never),
    [menuId, sheetName, columnType, divisionId],
  );

  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId,
    sheetName: 'titleSet',
    tabId: menuId,
    filters,
    enabled: open,
  });

  // BE 동적 컬럼 응답은 string 으로 직렬화 (eslint no-base-to-string 회피)
  const beRows = useMemo(() => (data?.o_rc1 ?? []) as unknown as Record<string, string>[], [data]);
  const loading = isLoading || isFetching;

  // BE rows → ColumnSettingRow 정규화 + fallback (fallbackColumns)
  const initialRows = useMemo<ColumnSettingRow[]>(() => {
    if (beRows.length > 0) {
      return beRows.map((r, i) => ({
        COLUMN_NAME: String(r.COLUMN_NAME ?? ''),
        LARGE_CLASS_LABEL_NAME: String(r.LARGE_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
        SMALL_CLASS_LABEL_NAME: String(r.SMALL_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
        COLUMN_LABEL_NAME: String(r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
        USER_FLAG: (String(r.USER_FLAG ?? r.VISIBLE_FLAG ?? 'Y') === 'Y' ? 'Y' : 'N'),
        USER_SORT_METHOD_CODE: ((['ASC', 'DESC'].includes(String(r.USER_SORT_METHOD_CODE ?? ''))
          ? r.USER_SORT_METHOD_CODE
          : 'ASC') as 'ASC' | 'DESC'),
        SUB_TOTAL_FLAG: (String(r.SUB_TOTAL_FLAG ?? 'N') === 'Y' ? 'Y' : 'N'),
        SORT_ORDER_NO: Number(r.SORT_ORDER_NO ?? i + 1),
      }));
    }
    // fallbackColumns 사용 — 모두 USER_FLAG='Y'
    return fallbackColumns.map((c, i) => ({
      COLUMN_NAME: c.key,
      LARGE_CLASS_LABEL_NAME: c.header,
      SMALL_CLASS_LABEL_NAME: c.header,
      COLUMN_LABEL_NAME: c.header,
      USER_FLAG: 'Y',
      USER_SORT_METHOD_CODE: 'ASC',
      SUB_TOTAL_FLAG: 'N',
      SORT_ORDER_NO: i + 1,
    }));
  }, [beRows, fallbackColumns]);

  const [rows, setRows] = useState<ColumnSettingRow[]>([]);
  const [baseSel, setBaseSel] = useState<ColumnSettingRow | null>(null);
  const [userSel, setUserSel] = useState<ColumnSettingRow | null>(null);

  useEffect(() => {
    if (open) setRows(initialRows);
  }, [open, initialRows]);

  const baseRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.USER_FLAG === 'Y').sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO),
    [rows],
  );

  const moveToUser = () => {
    if (!baseSel) {
      void setAlert({ type: 'alert', content: '좌측 column 선택' });
      return;
    }
    setRows(prev => {
      const maxSeq = Math.max(0, ...prev.filter(r => r.USER_FLAG === 'Y').map(r => r.SORT_ORDER_NO));
      return prev.map(r =>
        r.COLUMN_NAME === baseSel.COLUMN_NAME ? { ...r, USER_FLAG: 'Y', SORT_ORDER_NO: maxSeq + 1 } : r,
      );
    });
    setBaseSel(null);
  };

  const moveToBase = () => {
    if (!userSel) {
      void setAlert({ type: 'alert', content: '우측 column 선택' });
      return;
    }
    setRows(prev =>
      prev.map(r => (r.COLUMN_NAME === userSel.COLUMN_NAME ? { ...r, USER_FLAG: 'N', SORT_ORDER_NO: 0 } : r)),
    );
    setUserSel(null);
  };

  const handleDefault = () => { void refetch?.(); };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: '최소 1개 column 은 표시 상태여야 합니다.' });
      return;
    }
    onSave(userRows);
    modalClose();
  };

  const sortMap = useMemo(() => new DataMap(['ASC', 'DESC']), []);

  // LargeClass/SmallClass 같은 값 row vertical merge (AS-IS FPMerge.Always)
  class TitleSetMerge extends MergeManager {
    getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
      if (panel.cellType !== CellType.Cell) return null;
      const col = panel.columns[c];
      const binding = col?.binding ?? '';
      if (binding !== 'LARGE_CLASS_LABEL_NAME' && binding !== 'SMALL_CLASS_LABEL_NAME') return null;
      const view = panel.rows;
      const ri = (i: number): ColumnSettingRow | undefined =>
        (view[i] as unknown as { dataItem?: ColumnSettingRow })?.dataItem;
      const cur = ri(r);
      if (!cur) return null;
      const key = binding;
      const sameRow = (a: number, b: number): boolean => {
        const ra = ri(a);
        const rb = ri(b);
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
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>{title}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container}>
          <div className={styles.dualGrid}>
            {/* 좌측 Base grid */}
            <div className={styles.sideGrid}>
              <FlexGrid
                initialized={(g: FlexGridType<ColumnSettingRow>) => {
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
                initialized={(g: FlexGridType<ColumnSettingRow>) => {
                  userGridRef.current = g;
                  g.allowMerging = AllowMerging.Cells;
                  for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
                  g.mergeManager = new TitleSetMerge();
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
                  const item = s.rows[e.row]?.dataItem as ColumnSettingRow | undefined;
                  if (!item) return;
                  setRows(prev =>
                    prev.map(r =>
                      r.COLUMN_NAME === item.COLUMN_NAME
                        ? { ...r, USER_SORT_METHOD_CODE: item.USER_SORT_METHOD_CODE }
                        : r,
                    ),
                  );
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
