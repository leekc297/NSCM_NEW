import { useEffect, useMemo, useState } from 'react';

import { useQuery } from '@foundation/query-client';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

// ⭐ 2026-08-05 features/master/.../columnLayoutModal 에서 shared 공통 승격 —
//   같은 패키지 내부라 barrel(@shared/components) 순환을 피해 상대 경로로 import 한다.
import { ColorPickerButton } from '../../../molecules/colorPickerButton/ColorPickerButton';
import type { ColumnLayoutRow } from '../../../molecules/columnLayoutList/ColumnLayoutList';
import {
  ColumnSelectDualList,
  type DualListColumn,
} from '../../../molecules/columnSelectDualList/ColumnSelectDualList';
import { CustomDialog } from '../../../molecules/dialog/CustomDialog';
import { fetchColumnMeta, fetchTitleSet } from '../../../organisms/data-grid/titleSetApi';

import styles from './ColumnLayoutModal.module.scss';
import {
  buildDefaultRows,
  buildInitialRows,
  buildSavePayload,
  changeCellColor,
  changeTextColor,
  changeWidth,
  isVisibleColumn,
  overrideRows,
  parseWidth,
  reorderRows,
  serializeSavePayload,
  toHiddenColumnSet,
  toZeroWidthColumnSet,
  type ColumnSettingFallback,
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
//   (라벨 빨간색 강조는 USER_SELECTABLE_FLAG='N'(고정 컬럼) 여부로 판단하므로 별도 필드가 필요 없다 —
//    COLUMN_NAME 으로 keyColumns Set 을 조회한다. renderLabel 참조.)
type DualRow = {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  COL_WIDTH: number;
  CELL_COLOR: string;
  TEXT_COLOR: string;
  [key: string]: string | number;
};

// MEASURE은 안보이게 처리
const HIDDEN_FROM_LIST = new Set(['MEASURE']);

// 팝업이 쓰는 두 메타 쿼리의 캐시 정책 — 전역 기본값(staleTime:Infinity, 영속)을 끈다.
//   staleTime:0 = 팝업이 열려 쿼리가 enabled 되는 순간 항상 재조회.
//   재조회 중에는 loading 이 true 라 아래 latch 가 옛 캐시를 먼저 적재하지 않는다.
const ALWAYS_FRESH = { staleTime: 0, refetchOnMount: 'always' } as const;

const toDualRow = (r: ColumnLayoutRow): DualRow => ({
  COLUMN_NAME: r.COLUMN_NAME,
  COLUMN_LABEL_NAME: r.COLUMN_LABEL_NAME,
  COL_WIDTH: r.COL_WIDTH,
  CELL_COLOR: r.CELL_COLOR,
  TEXT_COLOR: r.TEXT_COLOR,
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
  const { data, isLoading, isFetching } = useQuery({
    queryKey: [menuId, 'titleSet', 'SEARCH', filters],
    queryFn: () => fetchTitleSet(filters),
    enabled: open,
    // 필수: 팝업을 열 때마다 새로 받는다. 전역 기본값이 staleTime:Infinity + gcTime 8h + IndexedDB
    //   영속이라, 이게 없으면 한 번 받은 컬럼 메타가 새로고침 후에도 8시간 동안 그대로 복원된다
    //   (admin UI Category Setup 에서 컬럼명을 바꿔도 그리드만 바뀌고 팝업은 옛 이름 — 2026-08-22 실측).
    //   그리드는 react-query 를 안 쓰고 Search 마다 직접 조회해서 이 문제가 없다.
    ...ALWAYS_FRESH,
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
    // titleSet 과 같은 이유 — 라벨/폭/플래그의 정본이므로 열 때마다 최신을 받는다.
    ...ALWAYS_FRESH,
  });

  const excluded = useMemo(() => toHiddenColumnSet(metaRows ?? []), [metaRows]);

  // ⭐ [2026-08-22 사용자 지시 · DMF0082] 관리자 기본 폭이 0 인 컬럼은 목록에서 감춘다.
  //   폭 0 은 그리드에서 실질적으로 안 보이는데 목록에는 남아 있어 "켰는데 안 나온다" 가 된다
  //   (실측 1,009행이 이 상태였다). 판정은 raw 응답의 `COLUMN_WIDTH` — `COL_WIDTH` 는 매핑 단계에서
  //   0→100 으로 정규화되므로 쓸 수 없다(utils `toZeroWidthColumnSet` 주석 참조).
  const zeroWidthColumns = useMemo(
    () => toZeroWidthColumnSet(data ?? [], fallbackColumns),
    [data, fallbackColumns]
  );
  /**
   * 목록(좌/우 dual list)에서 감출 컬럼 = ①`MEASURE`(HIDDEN_FROM_LIST) ②관리자 폭 0.
   * ⚠ `rows` 에서 빼지 않는다 — 저장 페이로드(`buildSavePayload`)가 이 집합을 후행 배치로
   *   보존하므로, 목록에서만 감추고 값은 그대로 유지된다.
   */
  const hiddenFromList = useMemo(
    () => new Set<string>([...HIDDEN_FROM_LIST, ...zeroWidthColumns]),
    [zeroWidthColumns]
  );

  // 고정 컬럼(좌우 이동 잠금) 판정 원본 = admin 메타의 USER_SELECTABLE_FLAG(personalizable).
  //   titleSet SP 커서에 이 플래그가 없을 수 있어 메타를 정본으로 덮어쓴다. 메타 조회 실패 시
  //   맵이 비므로 titleSet 행에서 파생한 값(deriveIsKey)이 그대로 남는다.
  const personalizableByName = useMemo(
    () =>
      new Map<string, boolean>(
        (metaRows ?? [])
          .filter(m => m.colNm && m.personalizable !== undefined)
          .map(m => [m.colNm, m.personalizable === true])
      ),
    [metaRows]
  );

  // 라벨 정본 = admin 컬럼 메타(COLUMN_LABEL_NAME) — 그리드 헤더와 같은 소스다.
  //   주의: titleSet 응답(mapBeRow)의 COLUMN_LABEL_NAME 을 그대로 두면, admin UI Category Setup 에서
  //   컬럼명을 바꿨을 때 그리드 헤더만 바뀌고 팝업 목록에는 옛 이름이 남는다 (2026-08-22 Sales Price 실측).
  //   Default 경로(buildDefaultRows)는 이미 메타 라벨로 덮어쓰므로 두 경로를 같은 규칙으로 맞춘다.
  const labelByName = useMemo(
    () =>
      new Map<string, string>(
        (metaRows ?? [])
          .filter(m => m.colNm && m.colLblNm !== undefined && m.colLblNm !== '')
          .map(m => [m.colNm, String(m.colLblNm)])
      ),
    [metaRows]
  );

  // ⚠️ 메타 조회도 loading 에 포함해야 한다 — 아래 latch 는 rows.length===0 일 때 1회만 돌므로,
  //   메타보다 titleSet 이 먼저 도착한 순간을 latch 하면 제외 대상이 그대로 좌측에 남는다.
  const loading = isLoading || isFetching || metaLoading || metaFetching;

  const initialRows = useMemo<ColumnLayoutRow[]>(
    () =>
      buildInitialRows(beRows, fallbackColumns, initialSettings)
        .filter(r => !excluded.has(r.COLUMN_NAME))
        .map(r => {
          const personalizable = personalizableByName.get(r.COLUMN_NAME);
          const label = labelByName.get(r.COLUMN_NAME);
          return {
            ...r,
            COLUMN_LABEL_NAME: label ?? r.COLUMN_LABEL_NAME,
            isKey: personalizable === undefined ? r.isKey : !personalizable,
          };
        }),
    [beRows, fallbackColumns, initialSettings, excluded, personalizableByName, labelByName]
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
    () => baseRows.filter(r => !hiddenFromList.has(r.COLUMN_NAME)).map(toDualRow),
    [baseRows]
  );
  const rightItems = useMemo(
    () => userRows.filter(r => !hiddenFromList.has(r.COLUMN_NAME)).map(toDualRow),
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
  //   고정 컬럼(USER_SELECTABLE_FLAG='N')도 표시로는 이동할 수 있다 — 비표시로 내리는 방향만 잠근다.
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

  // 비표시로 이동 — 고정 컬럼(USER_SELECTABLE_FLAG='N')은 제외한다.
  const hideColumns = (keys: Set<string>) => {
    setRows(prev =>
      prev.map(r =>
        r.USER_FLAG === 'Y' && keys.has(r.COLUMN_NAME) && !r.isKey
          ? { ...r, USER_FLAG: 'N' as const, SORT_ORDER_NO: 0 }
          : r
      )
    );
  };

  // 고정 컬럼을 비표시로 옮기려 할 때 안내 — 왜 안 움직이는지 알려준다.
  const FIXED_COLUMN_MSG = '고정 column 은 표시 상태를 변경할 수 없습니다.';

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
    if ([...checkedRight].every(k => keyColumns.has(k))) {
      void setAlert({ type: 'alert', content: FIXED_COLUMN_MSG });
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
      void setAlert({ type: 'alert', content: FIXED_COLUMN_MSG });
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

  // 라벨 빨간색 = 고정 컬럼(USER_SELECTABLE_FLAG='N', keyColumns) — 비표시로 옮길 수 없는 컬럼임을
  //   색으로 알린다. (2026-09-18 변경 전 기준: 라벨 끝 '*' 표기)
  const renderLabel = (row: DualRow) => (
    <span className={keyColumns.has(row.COLUMN_NAME) ? styles.keyLabel : undefined}>
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
    // 컬럼 기본 셋팅(admin 원본)으로 리셋 — 표시 여부/정렬/폭/색을 전부 초기화한다.
    //   금지: buildInitialRows 사용. mapBeRow 가 USER_* (개인화 저장값) 우선이라 개인화가 그대로 남는다.
    //   정본은 팝업이 이미 조회해 둔 admin 컬럼 메타(metaRows) — 폭/기본표시/고정/라벨을 모두 갖는다.
    const base = buildDefaultRows(beRows, fallbackColumns, metaRows ?? []).filter(
      r => !excluded.has(r.COLUMN_NAME)
    );
    // 메타 조회가 실패했을 때만 화면이 넘겨준 admin 원본(defaultSettings)으로 보정한다.
    setRows(
      metaRows?.length
        ? base
        : defaultSettings?.length
          ? overrideRows(base, defaultSettings).map(r => ({ ...r, CELL_COLOR: '', TEXT_COLOR: '' }))
          : base
    );
    setCheckedLeft(new Set());
    setCheckedRight(new Set());
  };

  const handleOk = () => {
    // 가드는 목록에 보이는 컬럼 기준 — 숨김 컬럼(MEASURE)만 남은 상태를 통과시키면 안 된다.
    if (rightItems.length === 0) {
      void setAlert({ type: 'alert', content: '최소 1개 column 은 표시 상태여야 합니다.' });
      return;
    }
    // 표시 1..n → 숨김 컬럼 후행 → 비표시 0. 숨김 컬럼은 항상 표시로 저장된다(buildSavePayload 주석).
    const payload = buildSavePayload(rows, hiddenFromList);
    // 변경 없음이면 저장/재조회를 건너뛰고 닫기만 한다 (2026-09-08 요청 — 무변경 저장이 각 화면
    //   onSave 의 titleSet 저장·invalidate·그리드 Reset 을 돌려 조회 결과를 비우던 동작 제거).
    //   비교 축은 저장에 실제로 반영되는 표시/순서/폭/색 — 팝업이 연 시점의 initialRows 를 기준값으로 둔다.
    if (serializeSavePayload(payload) === serializeSavePayload(buildSavePayload(initialRows, hiddenFromList))) {
      modalClose();
      return;
    }
    onSave(payload);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      // 헤더 드래그로 팝업 이동 (MeasureSelectModal 과 동일 — CustomDialog draggable 기본 true).
      //   draggable 이 켜지면 DraggablePaper 가 Paper 에 height 를 박고 리사이즈 핸들을 붙이므로
      //   (기본 50vh × DIALOG_SCALE=1.5 → 75vh), 종전 크기를 유지하려고 disableScale 로 배율을 끄고
      //   확대 후 실측값을 그대로 명시한다: 폭 900×1.5=1350, 높이 556 = 컨텐츠 460 + 헤더 48 + padding 48.
      size={1350}
      height={556}
      disableScale
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
