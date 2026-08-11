import { useEffect, useMemo, useState } from 'react';

import {
  type ColumnLayoutRow,
  type DualListColumn,
  ColorPickerButton,
  ColumnSelectDualList,
  CustomDialog,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { type ColumnSettingFallback } from '../columnSettingModal/ColumnSettingModal';

import styles from './ColumnLayoutModal.module.scss';
import {
  buildInitialRows,
  changeCellColor,
  changeTextColor,
  changeWidth,
  overrideRows,
  parseWidth,
  reorderRows,
} from './columnLayoutModal.utils';

// 컬럼 개인화(Layout) 팝업 — AS-IS ColumnSettingModal 과 동일한 dual list 구조 위에
//   To-Be 개인화(Width / Cell·Text Color)를 우측에 얹은 형태.
//     좌 = 미표시 컬럼 목록 / 우 = 표시 컬럼 + 개인화 설정.
//   ⭐ Display Y/N 컬럼 없음 (2026-07-27 요청) — 우측 목록에 있다는 것 자체가 '표시'다.
//     따라서 표시/비표시는 ▶◀ 이동(또는 행 더블클릭)으로만 바꾼다.
//   데이터 흐름(SP titleSet + fallback)과 onSave 계약은 종전과 동일.
//   설계서: docs/superpowers/specs/2026-07-20-column-layout-modal-design.md

// ColumnSelectDualList 의 제네릭 제약은 Record<string, string | number> 다.
//   ColumnLayoutRow 는 interface + isKey:boolean 이라 그대로 넣을 수 없어 표시용 row 로 투영한다.
//   (isKey 는 IS_KEY 'Y'/'N' 문자열로 옮겨 라벨 강조에만 쓴다 — 이동 가드는 원본 rows 로 판단.)
type DualRow = {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  COL_WIDTH: number;
  CELL_COLOR: string;
  TEXT_COLOR: string;
  IS_KEY: 'Y' | 'N';
  [key: string]: string | number;
};

const toDualRow = (r: ColumnLayoutRow): DualRow => ({
  COLUMN_NAME: r.COLUMN_NAME,
  COLUMN_LABEL_NAME: r.COLUMN_LABEL_NAME,
  COL_WIDTH: r.COL_WIDTH,
  CELL_COLOR: r.CELL_COLOR,
  TEXT_COLOR: r.TEXT_COLOR,
  IS_KEY: r.isKey ? 'Y' : 'N',
});

interface Props {
  open: boolean;
  modalClose: () => void;
  menuId: string;
  sheetName: string;
  columnType?: string;
  divisionId?: string;
  fallbackColumns?: ColumnSettingFallback[];
  /** 재진입 시 이전 저장 상태 복원 (visible+width+color+order) */
  initialSettings?: ColumnLayoutRow[];
  defaultSettings?: ColumnLayoutRow[];
  /** OK 시 전체 컬럼 반환 — 우측(USER_FLAG='Y')이 표시 순서대로 앞에 온다. */
  onSave: (settings: ColumnLayoutRow[]) => void;
  title?: string;
  /** dual list 좌측 상단 라벨 (예: 'Invisible') */
  leftTitle?: string;
  /** dual list 우측 상단 라벨 (예: 'Visible') */
  rightTitle?: string;
}

export const ColumnLayoutModal = ({
  open,
  modalClose,
  menuId,
  sheetName,
  columnType,
  divisionId,
  fallbackColumns = [],
  initialSettings,
  defaultSettings,
  onSave,
  title = 'Column Setting',
  leftTitle,
  rightTitle,
}: Props) => {
  const setAlert = useMessageStore.getState().setAlert;

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

  const initialRows = useMemo<ColumnLayoutRow[]>(
    () => buildInitialRows(beRows, fallbackColumns, initialSettings),
    [beRows, fallbackColumns, initialSettings]
  );

  const [rows, setRows] = useState<ColumnLayoutRow[]>([]);
  // 체크박스 다중선택 — 체크된 행을 ▶/◀ 로 이동 (ColumnSettingModal 동일).
  const [checkedLeft, setCheckedLeft] = useState<Set<string>>(new Set());
  const [checkedRight, setCheckedRight] = useState<Set<string>>(new Set());

  // popup 닫히면 reset
  useEffect(() => {
    if (!open) {
      setRows([]);
      setCheckedLeft(new Set());
      setCheckedRight(new Set());
    }
  }, [open]);

  // open + 데이터 도착 시 1회만 초기화 (사용자 편집 보존)
  // ⚠️ loading 가드 필수 — 재진입 시 React Query 가 직전(저장 전) 캐시를 즉시 돌려준다. 그걸 먼저
  //   latch 하면 뒤이어 도착한 최신 응답을 rows.length>0 가드가 막아, 방금 저장한 표시상태가
  //   원복된 것처럼 보인다(2026-07-27 실측). fetch 가 끝난 뒤의 데이터만 적재한다.
  useEffect(() => {
    if (open && !loading && rows.length === 0 && initialRows.length > 0) {
      setRows(initialRows);
    }
  }, [open, loading, initialRows, rows.length]);

  const baseRows = useMemo(() => rows.filter(r => r.USER_FLAG === 'N'), [rows]);
  const userRows = useMemo(
    () => rows.filter(r => r.USER_FLAG === 'Y').sort((a, b) => a.SORT_ORDER_NO - b.SORT_ORDER_NO),
    [rows]
  );

  const leftItems = useMemo(() => baseRows.map(toDualRow), [baseRows]);
  const rightItems = useMemo(() => userRows.map(toDualRow), [userRows]);

  const keyColumns = useMemo(
    () => new Set(rows.filter(r => r.isKey).map(r => r.COLUMN_NAME)),
    [rows]
  );

  const toggleLeft = (key: string) =>
    setCheckedLeft(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  const toggleRight = (key: string) =>
    setCheckedRight(prev => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  const toggleAllLeft = (checked: boolean) =>
    setCheckedLeft(checked ? new Set(baseRows.map(r => r.COLUMN_NAME)) : new Set());
  const toggleAllRight = (checked: boolean) =>
    setCheckedRight(checked ? new Set(userRows.map(r => r.COLUMN_NAME)) : new Set());

  // 표시로 이동 — 우측 맨 뒤에 붙인다(기존 순서 보존).
  const showColumns = (keys: Set<string>) => {
    setRows(prev => {
      let maxSeq = Math.max(0, ...prev.filter(r => r.USER_FLAG === 'Y').map(r => r.SORT_ORDER_NO));
      return prev.map(r => {
        if (r.USER_FLAG === 'N' && keys.has(r.COLUMN_NAME)) {
          maxSeq += 1;
          return { ...r, USER_FLAG: 'Y' as const, SORT_ORDER_NO: maxSeq };
        }
        return r;
      });
    });
  };

  // 비표시로 이동 — key 컬럼(라벨 끝 '*')은 항상 표시라 제외한다.
  const hideColumns = (keys: Set<string>) => {
    setRows(prev =>
      prev.map(r =>
        r.USER_FLAG === 'Y' && keys.has(r.COLUMN_NAME) && !r.isKey
          ? { ...r, USER_FLAG: 'N' as const, SORT_ORDER_NO: 0 }
          : r
      )
    );
  };

  const moveToUser = () => {
    if (checkedLeft.size === 0) {
      void setAlert({ type: 'alert', content: '좌측 column 선택' });
      return;
    }
    showColumns(checkedLeft);
    setCheckedLeft(new Set());
  };

  const moveToBase = () => {
    if (checkedRight.size === 0) {
      void setAlert({ type: 'alert', content: '우측 column 선택' });
      return;
    }
    // 선택이 전부 key 컬럼이면 아무것도 안 옮겨진다 — 왜 안 되는지 알려준다.
    if ([...checkedRight].every(k => keyColumns.has(k))) {
      void setAlert({ type: 'alert', content: '필수 column 은 비표시로 옮길 수 없습니다.' });
      return;
    }
    hideColumns(checkedRight);
    setCheckedRight(new Set());
  };

  // 더블클릭 — 해당 행 1개만 이동 (▶/◀ 와 동일 동작, 체크상태 무관)
  const moveOneToUser = (key: string) => {
    showColumns(new Set([key]));
    setCheckedLeft(prev => {
      const next = new Set(prev);
      next.delete(key);
      return next;
    });
  };

  const moveOneToBase = (key: string) => {
    if (keyColumns.has(key)) {
      void setAlert({ type: 'alert', content: '필수 column 은 비표시로 옮길 수 없습니다.' });
      return;
    }
    hideColumns(new Set([key]));
    setCheckedRight(prev => {
      const next = new Set(prev);
      next.delete(key);
      return next;
    });
  };

  // 행 클릭이 체크 토글/더블클릭 이동을 일으키므로, 입력 컨트롤에서는 전파를 끊는다.
  const stopRowEvents = {
    onClick: (e: { stopPropagation: () => void }) => e.stopPropagation(),
    onDoubleClick: (e: { stopPropagation: () => void }) => e.stopPropagation(),
  };

  const renderLabel = (row: DualRow) => (
    <span className={row.IS_KEY === 'Y' ? styles.keyLabel : undefined}>
      {row.COLUMN_LABEL_NAME}
    </span>
  );

  const LEFT_COLUMNS: DualListColumn<DualRow>[] = [
    { key: 'COLUMN_LABEL_NAME', header: 'Column', align: 'left', render: renderLabel },
  ];

  const RIGHT_COLUMNS: DualListColumn<DualRow>[] = [
    { key: 'COLUMN_LABEL_NAME', header: 'Column', align: 'left', render: renderLabel },
    {
      key: 'COL_WIDTH',
      header: 'Width',
      width: 80,
      align: 'center',
      render: (row, rowKey) => (
        <span {...stopRowEvents}>
          <input
            type='number'
            min={0}
            className={styles.widthInput}
            value={row.COL_WIDTH}
            onChange={e =>
              setRows(prev => changeWidth(prev, rowKey, parseWidth(e.target.value, row.COL_WIDTH)))
            }
          />
        </span>
      ),
    },
    {
      key: 'CELL_COLOR',
      header: 'Cell Color',
      width: 80,
      align: 'center',
      render: (row, rowKey) => (
        <span {...stopRowEvents}>
          <ColorPickerButton
            value={row.CELL_COLOR}
            onChange={hex => setRows(prev => changeCellColor(prev, rowKey, hex))}
            title='Cell Color'
            autoColor='#ffffff'
          />
        </span>
      ),
    },
    {
      key: 'TEXT_COLOR',
      header: 'Text Color',
      width: 80,
      align: 'center',
      render: (row, rowKey) => (
        <span {...stopRowEvents}>
          <ColorPickerButton
            value={row.TEXT_COLOR}
            onChange={hex => setRows(prev => changeTextColor(prev, rowKey, hex))}
            title='Text Color'
          />
        </span>
      ),
    },
  ];

  const handleDefault = () => {
    // ⭐ 관리자 기본값으로 원복 — 저장된 개인화(BE 응답)를 defaultSettings 로 강제로 덮는다.
    //   buildInitialRows 는 DB 우선이라 그대로 쓰면 개인화가 그대로 남으므로 overrideRows 를 쓴다.
    //   Cell/Text Color 는 '' = 자동(기본색) 이므로 항상 비운다 (2026-07-27 요청).
    const base = buildInitialRows(beRows, fallbackColumns);
    const reverted = defaultSettings?.length ? overrideRows(base, defaultSettings) : base;
    setRows(reverted.map(r => ({ ...r, CELL_COLOR: '', TEXT_COLOR: '' })));
    setCheckedLeft(new Set());
    setCheckedRight(new Set());
    void refetch?.();
  };

  const handleOk = () => {
    if (userRows.length === 0) {
      void setAlert({ type: 'alert', content: '최소 1개 column 은 표시 상태여야 합니다.' });
      return;
    }
    // 우측(표시)을 화면 순서대로 1..n, 좌측(비표시)은 0 — ColumnSettingModal 저장 계약과 동일.
    onSave([
      ...userRows.map((r, i) => ({ ...r, SORT_ORDER_NO: i + 1 })),
      ...baseRows.map(r => ({ ...r, SORT_ORDER_NO: 0 })),
    ]);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={900}
      draggable={false}
      handleClose={modalClose}
      disableButtonCancel
      title={title}
      customContentArea={
        <div className={styles.container}>
          <ColumnSelectDualList<DualRow>
            leftItems={leftItems}
            rightItems={rightItems}
            leftColumns={LEFT_COLUMNS}
            rightColumns={RIGHT_COLUMNS}
            leftTitle={leftTitle}
            rightTitle={rightTitle}
            itemKey='COLUMN_NAME'
            checkedLeft={checkedLeft}
            checkedRight={checkedRight}
            onToggleLeft={toggleLeft}
            onToggleRight={toggleRight}
            onToggleAllLeft={toggleAllLeft}
            onToggleAllRight={toggleAllRight}
            onMoveRight={moveToUser}
            onMoveLeft={moveToBase}
            onReorderRight={orderedKeys => setRows(prev => reorderRows(prev, orderedKeys))}
            onRowDoubleClickLeft={moveOneToUser}
            onRowDoubleClickRight={moveOneToBase}
          />

          <div className={styles.actionBar}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Default'
              onClick={handleDefault}
              disabled={loading}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
