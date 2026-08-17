import { useEffect, useMemo, useState } from 'react';

import { useQuery } from '@foundation/query-client';
import {
  type ColumnLayoutRow,
  type DualListColumn,
  ColorPickerButton,
  ColumnSelectDualList,
  CustomDialog,
} from '@shared/components';
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
  isVisibleColumn,
  overrideRows,
  parseWidth,
  reorderRows,
  toHiddenColumnSet,
} from './columnLayoutModal.utils';
import { fetchColumnMeta, fetchTitleSet } from './titleSet.api';

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

// MEASURE은 안보이게 처리
const HIDDEN_FROM_LIST = new Set(['MEASURE']);

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
    () => ({
      menuId,
      sheetName,
      columnType: columnType ?? sheetName,
      divisionId: divisionId ?? '40',
    }),
    [menuId, sheetName, columnType, divisionId]
  );

  // ⭐ 공용 조회 엔드포인트(fetchTitleSet) — 화면별 `{menuId}/titleSet/SEARCH/call-proc` 을 쓰면
  //   SCM_ADM_MNU_BTN_MPG_M 미등록 화면에서 403 No Permission 이 난다 (DMF0042 실측 2026-07-29).
  //   ⚠️ queryKey 첫 요소는 반드시 menuId — 각 화면이 저장 직후 invalidateQueries({queryKey:[MENU_ID]})
  //     로 이 캐시를 무효화한다(전역 staleTime=Infinity 라 invalidate 없이는 재조회가 안 된다).
  const { data, refetch, isLoading, isFetching } = useQuery({
    queryKey: [menuId, 'titleSet', 'SEARCH', filters],
    queryFn: () => fetchTitleSet(filters),
    enabled: open,
  });

  // ⭐ admin 노출 대상(VISIBLE_FLAG='Y')만 팝업 목록에 올린다 — SP 는 sheet 메타의 모든 컬럼을
  //   내려주므로 걸러내지 않으면 관리자가 뺀 컬럼까지 좌측 Invisible 에 쌓인다 (2026-07-29).
  const beRows = useMemo(() => (data ?? []).filter(isVisibleColumn), [data]);

  // ⭐ admin 노출 금지 컬럼(VISIBLE_FLAG='N' → visible:false) 제외 — 팝업이 메타를 직접 조회한다.
  //   화면마다 prop 으로 넘기지 않는 이유: 이 팝업을 쓰는 7개 화면 전부가 같은 처리를 필요로 하고,
  //   menuId/sheetName/divisionId 만 있으면 각 화면 store 와 동일한 메타를 얻을 수 있다.
  //   ⚠️ beRows 의 VISIBLE_FLAG 필터(isVisibleColumn)만으로는 부족하다. 저장된 개인화가 없어
  //     fallbackColumns 로 목록을 만드는 경로에는 admin 메타가 실려오지 않고(ColumnSettingFallback =
  //     key/header/width), initialSettings 도 visible/display 를 USER_FLAG 하나로 뭉갠다 (2026-07-29 실측).
  const {
    data: metaRows,
    isLoading: metaLoading,
    isFetching: metaFetching,
  } = useQuery({
    queryKey: [menuId, 'columnMeta', filters.sheetName, filters.divisionId],
    queryFn: () =>
      fetchColumnMeta({
        menuId,
        sheetName: filters.sheetName,
        divisionId: filters.divisionId,
      }),
    enabled: open,
  });

  const excluded = useMemo(() => toHiddenColumnSet(metaRows ?? []), [metaRows]);

  // ⚠️ 메타 조회도 loading 에 포함해야 한다 — 아래 latch 는 rows.length===0 일 때 1회만 돌므로,
  //   메타보다 titleSet 이 먼저 도착한 순간을 latch 하면 제외 대상이 그대로 좌측에 남는다.
  const loading = isLoading || isFetching || metaLoading || metaFetching;

  const initialRows = useMemo<ColumnLayoutRow[]>(
    () =>
      buildInitialRows(beRows, fallbackColumns, initialSettings).filter(
        r => !excluded.has(r.COLUMN_NAME)
      ),
    [beRows, fallbackColumns, initialSettings, excluded]
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

  const leftItems = useMemo(
    () => baseRows.filter(r => !HIDDEN_FROM_LIST.has(r.COLUMN_NAME)).map(toDualRow),
    [baseRows]
  );
  const rightItems = useMemo(
    () => userRows.filter(r => !HIDDEN_FROM_LIST.has(r.COLUMN_NAME)).map(toDualRow),
    [userRows]
  );

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
    const base = buildInitialRows(beRows, fallbackColumns).filter(
      r => !excluded.has(r.COLUMN_NAME)
    );
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
    // ⭐ HIDDEN_FROM_LIST(MEASURE) 는 dual list 에서 안 보여서 드래그로 순서를 못 옮긴다 — reorderRows
    //   가 orderedKeys 에 없는 행은 SORT_ORDER_NO 를 그대로 두므로, 방치하면 예전 순번이 남아
    //   다른 컬럼들 사이 임의 위치에 낀다. 항상 마지막(다른 표시 컬럼 전부 뒤)이라고 가정하고 저장한다.
    const visibleUserRows = userRows.filter(r => !HIDDEN_FROM_LIST.has(r.COLUMN_NAME));
    const trailingUserRows = userRows.filter(r => HIDDEN_FROM_LIST.has(r.COLUMN_NAME));
    // 우측(표시)을 화면 순서대로 1..n(+숨김목록 후행), 좌측(비표시)은 0 — ColumnSettingModal 저장 계약과 동일.
    onSave([
      ...visibleUserRows.map((r, i) => ({ ...r, SORT_ORDER_NO: i + 1 })),
      ...trailingUserRows.map((r, i) => ({
        ...r,
        SORT_ORDER_NO: visibleUserRows.length + i + 1,
      })),
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
