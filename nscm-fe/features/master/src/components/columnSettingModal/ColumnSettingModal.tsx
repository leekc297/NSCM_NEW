import { useEffect, useMemo, useState } from 'react';

import {
  type DualListColumn,
  ColumnSelectDualList,
  CustomDialog,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import styles from './ColumnSettingModal.module.scss';

// 공용 Column Setting popup (사용자 명시 2026-06-03):
//   - AS-IS DM0002_TitleSetForm_Popup.cs 동등 동작 (Base/User dual list + 이동 + Sort)
//   - 화면별 props 로 menuId / sheetName / columnType / divisionId 전달
//   - SP DMF0002_GET_TITLESET_POPUP 호출 (BE PROC_M COL_NM auto-fill)
//   - BE 결과 없으면 fallbackColumns 사용 (Hybrid Option C)
//
// 사용 화면: DMF0020 (Sales Future Price) / DMF0043_01 (Contribute View)
//
// 2026-06-20: wijmo FlexGrid + CustomDialog 조합에서 selection 사고 (click row N → row 0 강제)
//   해소를 위해 신규 공용 컴포넌트 `ColumnSelectDualList` (@shared/components/molecules)
//   생성 후 사용. HTML <table> 기반 — wijmo 의존 0.

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
  USER_FLAG: string;
  USER_SORT_METHOD_CODE: string;
  SUB_TOTAL_FLAG: string;
  SORT_ORDER_NO: number;
  [key: string]: string | number;
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
  /** 이전에 OK 했던 visible column 키 목록 (popup 재진입 시 좌/우 상태 복원) */
  initialVisibleKeys?: string[];
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
  initialVisibleKeys,
}: Props) => {
  const setAlert = useMessageStore.getState().setAlert;

  // SP 호출 — filters useMemo 안정화 (refetch loop 방지)
  const filters = useMemo(
    () =>
      ({
        programId: menuId,
        sheetName,
        columnType: columnType ?? sheetName,
        divisionId: divisionId ?? '40',
      }) as never,
    [menuId, sheetName, columnType, divisionId]
  );

  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId,
    sheetName: 'titleSet',
    tabId: menuId,
    filters,
    enabled: open,
  });

  const beRows = useMemo(() => (data?.o_rc1 ?? []) as unknown as Record<string, string>[], [data]);
  const loading = isLoading || isFetching;

  const initialRows = useMemo<ColumnSettingRow[]>(() => {
    // initialVisibleKeys 가 있으면 USER_FLAG 강제 override — 이전 OK 상태 복원
    const hasVisibleOverride = !!initialVisibleKeys && initialVisibleKeys.length > 0;
    const computeFlag = (colName: string, beFlag: string): string => {
      if (hasVisibleOverride) {
        return initialVisibleKeys.includes(colName) ? 'Y' : 'N';
      }
      return beFlag === 'Y' ? 'Y' : 'N';
    };

    if (beRows.length > 0) {
      return beRows.map((r, i) => {
        const colName = String(r.COLUMN_NAME ?? '');
        const beFlag = String(r.USER_FLAG ?? r.VISIBLE_FLAG ?? 'Y');
        return {
          COLUMN_NAME: colName,
          LARGE_CLASS_LABEL_NAME: String(
            r.LARGE_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''
          ),
          SMALL_CLASS_LABEL_NAME: String(
            r.SMALL_CLASS_LABEL_NAME ?? r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''
          ),
          COLUMN_LABEL_NAME: String(r.COLUMN_LABEL_NAME ?? r.COLUMN_NAME ?? ''),
          USER_FLAG: computeFlag(colName, beFlag),
          USER_SORT_METHOD_CODE: ['ASC', 'DESC'].includes(String(r.USER_SORT_METHOD_CODE ?? ''))
            ? String(r.USER_SORT_METHOD_CODE)
            : 'ASC',
          SUB_TOTAL_FLAG: String(r.SUB_TOTAL_FLAG ?? 'N') === 'Y' ? 'Y' : 'N',
          SORT_ORDER_NO: Number(r.SORT_ORDER_NO ?? i + 1),
        };
      });
    }
    return fallbackColumns.map((c, i) => ({
      COLUMN_NAME: c.key,
      LARGE_CLASS_LABEL_NAME: c.header,
      SMALL_CLASS_LABEL_NAME: c.header,
      COLUMN_LABEL_NAME: c.header,
      USER_FLAG: computeFlag(c.key, 'Y'),
      USER_SORT_METHOD_CODE: 'ASC',
      SUB_TOTAL_FLAG: 'N',
      SORT_ORDER_NO: i + 1,
    }));
  }, [beRows, fallbackColumns, initialVisibleKeys]);

  const [rows, setRows] = useState<ColumnSettingRow[]>([]);

  // popup 닫힐 때 rows reset
  useEffect(() => {
    if (!open) setRows([]);
  }, [open]);

  // popup open + BE 응답 도착 시점 1회만 setRows (사용자 변경 보존)
  // initialRows reference 변경 시 무조건 setRows 시 사용자 이동 결과 원복 사고.
  useEffect(() => {
    if (open && rows.length === 0 && initialRows.length > 0) {
      setRows(initialRows);
    }
  }, [open, initialRows, rows.length]);

  const baseRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.USER_FLAG === 'Y').sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO),
    [rows]
  );

  const [selectedBaseCol, setSelectedBaseCol] = useState<string | null>(null);
  const [selectedUserCol, setSelectedUserCol] = useState<string | null>(null);

  const toggleSort = (rowKey: string) => {
    setRows(prev =>
      prev.map(r =>
        r.COLUMN_NAME === rowKey
          ? { ...r, USER_SORT_METHOD_CODE: r.USER_SORT_METHOD_CODE === 'DESC' ? 'ASC' : 'DESC' }
          : r
      )
    );
  };

  const BASE_COLUMNS: DualListColumn<ColumnSettingRow>[] = [
    { key: 'LARGE_CLASS_LABEL_NAME', header: 'LargeClass', width: 80, align: 'left' },
    { key: 'SMALL_CLASS_LABEL_NAME', header: 'SmallClass', width: 80, align: 'left' },
    { key: 'COLUMN_LABEL_NAME', header: 'Column', width: 120, align: 'left' },
  ];

  const USER_COLUMNS: DualListColumn<ColumnSettingRow>[] = [
    { key: 'LARGE_CLASS_LABEL_NAME', header: 'LargeClass', width: 120, align: 'left' },
    { key: 'SMALL_CLASS_LABEL_NAME', header: 'SmallClass', width: 120, align: 'left' },
    { key: 'COLUMN_LABEL_NAME', header: 'Column', width: 130, align: 'left' },
    {
      key: 'USER_SORT_METHOD_CODE',
      header: 'Sort',
      width: 80,
      align: 'center',
      render: (row, rowKey) => (
        <button
          type='button'
          onClick={e => {
            e.stopPropagation();
            toggleSort(rowKey);
          }}
          className={styles.sortToggleBtn}
        >
          {row.USER_SORT_METHOD_CODE}
        </button>
      ),
    },
  ];

  const moveToUser = () => {
    if (!selectedBaseCol) {
      void setAlert({ type: 'alert', content: '좌측 column 선택' });
      return;
    }
    setRows(prev => {
      const maxSeq = Math.max(
        0,
        ...prev.filter(r => r.USER_FLAG === 'Y').map(r => r.SORT_ORDER_NO)
      );
      return prev.map(r =>
        r.COLUMN_NAME === selectedBaseCol
          ? { ...r, USER_FLAG: 'Y', SORT_ORDER_NO: maxSeq + 1 }
          : r
      );
    });
    setSelectedBaseCol(null);
  };

  const moveToBase = () => {
    if (!selectedUserCol) {
      void setAlert({ type: 'alert', content: '우측 column 선택' });
      return;
    }
    setRows(prev =>
      prev.map(r =>
        r.COLUMN_NAME === selectedUserCol ? { ...r, USER_FLAG: 'N', SORT_ORDER_NO: 0 } : r
      )
    );
    setSelectedUserCol(null);
  };

  const handleDefault = () => {
    void refetch?.();
  };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: '최소 1개 column 은 표시 상태여야 합니다.' });
      return;
    }
    onSave(userRows);
    modalClose();
  };

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
          <div
            style={{
              width: 14,
              height: 14,
              background: '#1976d2',
              borderRadius: '50%',
              color: '#fff',
              textAlign: 'center',
              fontSize: 9,
              lineHeight: '14px',
            }}
          >
            S
          </div>
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>{title}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container}>
          <ColumnSelectDualList<ColumnSettingRow>
            leftItems={baseRows}
            rightItems={userRows}
            leftColumns={BASE_COLUMNS}
            rightColumns={USER_COLUMNS}
            itemKey='COLUMN_NAME'
            selectedLeftKey={selectedBaseCol}
            selectedRightKey={selectedUserCol}
            onSelectLeft={setSelectedBaseCol}
            onSelectRight={setSelectedUserCol}
            onMoveRight={moveToUser}
            onMoveLeft={moveToBase}
            leftTitle='Hidden'
            rightTitle='Visible'
          />

          <div className={styles.bottomRow}>
            <span className={styles.hint}>
              {loading ? '⏳ 조회 중...' : `${baseRows.length} hidden / ${userRows.length} visible`}
            </span>
            <button
              type='button'
              onClick={handleDefault}
              className={styles.defaultBtn}
              disabled={loading}
            >
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
