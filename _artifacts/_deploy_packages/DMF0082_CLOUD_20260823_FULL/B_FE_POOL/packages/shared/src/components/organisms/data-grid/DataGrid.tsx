import { type Control, type EventArgs } from '@mescius/wijmo';
import {
  AllowDragging,
  AllowMerging,
  AllowResizing,
  AllowSorting,
  Column,
  DataMap,
  _EditHandler,
  SelectionMode,
  type FlexGrid as TFlexGrid,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid, type FlexGridProps } from '@mescius/wijmo.react.grid';
import {
  memo,
  type MutableRefObject,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import { type FlexGridColumnConfig, type RawFlexGridColumnConfig } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import {
  captureGridFilter,
  CustomMergeManager,
  EditTracker,
  ensureTopLeftMergeManager,
  fillEmptyCellWithZero,
  findStaleComboCells,
  GridAction,
  GridUtils,
  mapRawColumnsToWijmoColumns,
  normalizeDynamicColumns,
  rebindFilterColumns,
  restoreGridFilter,
  revertRowChanges,
} from '@foundation/utils';
import { useTabComboQueries } from '@shared/hooks';
import {
  DialogScopeContext,
  registerDirtyCheck,
  registerDirtyReset,
  scopeDirtyKey,
  tabDirtyKey,
  useDialogStore,
  useMessageStore,
  useTabid,
  useUIStore,
} from '@shared/stores';

// 컬럼 설정 팝업 — 표시/숨김·순서·폭·색 편집. barrel 순환을 피해 상대 경로 import.
import type { ColumnLayoutRow } from '../../molecules/columnLayoutList/ColumnLayoutList';
import { ColumnLayoutModal } from '../../templates/modals/column-layout-modal/ColumnLayoutModal';
import { toColumnLayoutSettings } from '../../templates/modals/column-layout-modal/columnLayoutModal.utils';

import { useDataGridUtils } from './dataGridUtils';
import { attachGridContextMenu, type GridContextMenuItem } from './gridContextMenu';
import {
  applyGridLayout,
  fetchGridLayout,
  saveTitleSet,
  type GridLayoutKey,
  type GridLayoutRow,
  type TitleSetSaveRow,
} from './titleSetApi';

const initialIndexRowHeaderWidth = 50;

/**
 * 그리드 셀 콤보 드롭다운의 휠 스크롤을 항목 단위로 바꾼다.
 *
 * Wijmo 는 _CellEditHandler._createListBox 에서 목록 높이를 `4 * row.renderHeight`(약 84px)로
 * 고정하는데, 브라우저 휠 한 칸은 약 100px 이라 한 번 굴리면 한 화면보다 더 내려간다. 그래서
 * 중간 항목이 화면에 한 번도 안 뜨고 건너뛰어진다 (2026-08-19 Sales Plan Model 콤보 9건 중
 * 5번째가 안 보임 — 목록에는 9건이 다 들어 있었다). CSS scroll-snap 으로는 못 고친다.
 * 스냅은 멈출 경계만 고를 뿐 한 화면 넘게 내려가는 것 자체를 막지 못한다.
 *
 * 한 번에 (보이는 항목 수 - 1) 만큼만 내려 최소 한 항목이 겹치게 한다.
 * 드롭다운 패널은 그리드 밖(body)에 생성되므로 document 에 1회만 건다.
 */
let gridListBoxWheelInstalled = false;
const installGridListBoxWheelStep = () => {
  if (gridListBoxWheelInstalled) return;
  gridListBoxWheelInstalled = true;
  document.addEventListener(
    'wheel',
    event => {
      const target = event.target instanceof HTMLElement ? event.target : null;
      const box = target?.closest<HTMLElement>('.wj-grid-listbox') ?? null;
      if (!box) return;
      const item = box.querySelector('.wj-listbox-item');
      const step = item instanceof HTMLElement ? item.offsetHeight : 0;
      if (step <= 0) return;
      const visible = Math.max(1, Math.floor(box.clientHeight / step));
      event.preventDefault();
      box.scrollTop += Math.sign(event.deltaY) * step * Math.max(1, visible - 1);
    },
    { passive: false, capture: true }
  );
};

/**
 * 편집기 텍스트를 드롭다운 원본 표기로 되돌린다 (대소문자만 다를 때).
 * 방향키로 옮긴 선택이 있으면 그 값이 우선이고, 없으면 후보 목록에서 앞부분 일치로 찾는다.
 * 콤보가 아닌 컬럼은 _lbx/_list 가 없어 그대로 통과한다.
 */
const restoreCanonicalComboText = (editHandler: _EditHandler) => {
  const editor = editHandler._edt;
  const typed = editor?.value;
  if (!editor || !typed) return;
  // 목록 밖 값을 허용하는 DataMap(isEditable)은 친 그대로가 곧 입력값이라 되돌리지 않는다.
  if (editHandler._map?.isEditable) return;

  const selectedValue: unknown = editHandler._lbx?.selectedValue;
  const candidates = [
    ...(typeof selectedValue === 'string' ? [selectedValue] : []),
    ...((editHandler._list as unknown[] | null) ?? []),
  ];

  const lowerTyped = typed.toLowerCase();
  const canonical = candidates.find(
    (candidate): candidate is string =>
      typeof candidate === 'string' && candidate.toLowerCase().startsWith(lowerTyped)
  );
  if (canonical && !canonical.startsWith(typed)) editor.value = canonical;
};

/**
 * 그리드 셀 콤보의 타이핑 검색을 대소문자 구분 없이 한다 (표기는 사용자가 친 그대로 유지).
 *
 * wijmo 는 DataMap.search 콜백이 없으면 _EditHandler._keypress 에서 먼저 대소문자를 구분해
 * 찾고(_findString(list, text, true)), 거기서 못 찾을 때만 caseSensitiveSearch(기본 false)를 보고
 * 무시 검색으로 되돌아간다. 그래서 "ACE KR" 과 "acer" 가 함께 있는 목록에서 `ace` 를 치면 구분
 * 검색이 먼저 "acer" 를 잡아버려 "ACE KR" 로는 영영 갈 수 없다 (2026-08-22 리포트).
 * grid.caseSensitiveSearch 로는 못 고친다 - 이미 false 이고, 그 값은 구분 검색이 실패한 뒤에만 쓰인다.
 *
 * 세 군데를 함께 손봐야 한 동작이 된다.
 *
 * 1) 후보 찾기 - DataMap.search. 지정되면 wijmo 가 후보를 그 콜백으로만 훑는 공식 훅이라, 여기에
 *    무시 비교를 걸어 목록 순서대로 첫 일치 항목을 고르게 한다. prototype 에 걸어 화면이 직접 만든
 *    DataMap 까지 한 번에 적용하고, 인스턴스에 search 를 지정한 DataMap 은 그 값이 우선한다.
 *    주의: useFilter=true 인 DataMap 은 wijmo 가 후보를 객체째 넘겨 text 가 "[object Object]" 로
 *    들어오므로(현재 코드베이스에는 없음) 그런 DataMap 에는 인스턴스 search 를 따로 지정해야 한다.
 *
 * 2) 표시 - wijmo 는 일치 항목을 찾으면 편집기 값을 원본 표기로 통째로 덮어쓴다(`t.value = _`).
 *    그래서 `ace` 를 쳐도 `ACE KR` 로 바뀌어 보인다. 사용자가 친 앞부분은 친 표기 그대로 두고
 *    자동완성으로 붙는 뒷부분만 원본 표기로 남긴다 (브라우저 주소창과 같은 방식).
 *
 * 3) 커밋 - wijmo 는 편집기 텍스트가 드롭다운 선택값과 **대소문자까지 같을 때만** 그 항목의 키를
 *    셀에 넣는다(_keydown Enter / finishEditing 의 `sv.indexOf(t.value) == 0` 가드).
 *    2) 로 표기를 남겨두면 이 가드가 깨져 값이 안 들어가므로, 커밋 직전에 편집기 텍스트만 원본
 *    표기로 되돌린다. Enter/Tab/포커스이동/다른 셀 클릭이 모두 finishEditing 을 지나므로 여기 한
 *    곳이면 충분하다 (Enter 는 그 전에 드롭다운을 닫아 _lbx 가 없어지므로 _list 로도 찾는다).
 */
let comboCaseInsensitiveSearchInstalled = false;
const installComboCaseInsensitiveSearch = () => {
  if (comboCaseInsensitiveSearchInstalled) return;
  comboCaseInsensitiveSearchInstalled = true;

  // 1) 후보 찾기
  DataMap.prototype.search = (
    text: string | null | undefined,
    searchText: string | null | undefined
  ) => (text ?? '').toLowerCase().startsWith((searchText ?? '').toLowerCase());

  // 2) 표시
  // 원본을 보관해 감싸는 것이므로 언바운드 참조가 맞다 - 호출은 항상 .call(this, ...) 로 한다.
  // eslint-disable-next-line @typescript-eslint/unbound-method
  const originalKeypress = _EditHandler.prototype._keypress;
  _EditHandler.prototype._keypress = function (this: _EditHandler, event: KeyboardEvent) {
    const editor = this._edt;
    // wijmo 가 검색어로 쓰는 값과 같은 계산 - 커서 앞 텍스트 + 방금 친 문자.
    //   셀 선택 상태에서 바로 타이핑해 편집이 시작된 첫 글자는 이벤트 대상이 편집기가 아니고
    //   그 글자가 이미 편집기 값에 들어 있다(_KeyboardHandler._keypress). 그때는 붙이지 않는다.
    const typed =
      editor && event.key?.length === 1
        ? editor.value.slice(0, editor.selectionStart ?? editor.value.length) +
          (event.target === editor ? event.key : '')
        : null;

    const beforeKeypress = editor?.value ?? null;
    originalKeypress.call(this, event);

    // wijmo 가 자동완성으로 편집기 값을 덮어쓴 경우에만 손댄다. 일치 항목이 없으면 값이 그대로라
    // (문자는 그 뒤 브라우저가 넣는다) 여기서 걸러지고, 일반 텍스트 컬럼도 같은 이유로 안 걸린다.
    if (typed === null || !editor || editor.value === beforeKeypress) return;
    const completed = editor.value;
    if (completed.startsWith(typed)) return; // 표기가 이미 같으면(=구분 일치) 손대지 않는다
    if (!completed.toLowerCase().startsWith(typed.toLowerCase())) return;

    editor.value = typed + completed.slice(typed.length);
    editor.setSelectionRange(typed.length, editor.value.length);
  };

  // 3) 커밋
  // eslint-disable-next-line @typescript-eslint/unbound-method -- 위 2) 와 같은 이유
  const originalFinishEditing = _EditHandler.prototype.finishEditing;
  _EditHandler.prototype.finishEditing = function (this: _EditHandler, cancel?: boolean) {
    if (!cancel) restoreCanonicalComboText(this);
    return originalFinishEditing.call(this, cancel);
  };
};

interface DataGridProps<T extends WijmoRowItem = WijmoRowItem> extends FlexGridProps {
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  gridRef?: MutableRefObject<TFlexGrid | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<T> | undefined>;
  itemsSource?: T[];
  staticColumns?: RawFlexGridColumnConfig[];
  dynamicColumns?: FlexGridColumnConfig[];
  useSummaryTooltip?: boolean;
  useCellTooptip?: boolean;
  useCheckbox?: boolean;
  useResultColumns?: boolean;
  useAggregationRow?: boolean;
  aggregationRowPlacement?: 'above' | 'below';
  /**
   * 편집 종료 시 비어 있는 셀을 '0' 으로 채울 컬럼 판정 (AS-IS spdMain_Changed L1295~1302 파리티).
   * binding 을 받아 true 면 채운다. 미지정이면 아무 동작 없음(기본).
   *
   * 화면이 직접 cellEditEnded 에 붙이지 말 것 — 이 처리는 **EditTracker 뒤에** 실행되어야 하고,
   * 화면 핸들러는 mount 후 등록이라 순서가 어긋나면 원복해도 수정상태(M)가 안 풀린다.
   * 그 순서 보장이 이 prop 의 존재 이유다 (foundation fillEmptyCellWithZero 주석 참고).
   */
  emptyCellAsZero?: (binding: string) => boolean;
  /**
   * 자동 콤보(cellCtrlObjTpCd=COMBO)의 SQL 바인드 파라미터(@mnuId / @divisionId 등) 해소용 공통 파라미터.
   * comboId 와 함께 admin/combo 로 전달되어 @키 치환에 사용됨.
   * ⚠ BE makeComboQuery 는 raw 치환이므로 **문자열 리터럴 값은 작은따옴표로 감싸 전달**해야 함
   *   (예: { mnuId: "'DMF0048'" } → PROGRAM_ID = 'DMF0048'). BE resolveComboBoxDataMaps 와 동일 규약.
   * 미지정 시 기존 동작(파라미터 없는 콤보만 정상) — 회귀 0. 미사용 콤보는 여분 파라미터를 무시(무해).
   */
  comboParams?: Record<string, string>;
  /**
   * 다단(2단/3단) 헤더 행 높이(px). 미지정(default)이면 Wijmo 기본 동작 — 기존 화면 무영향(회귀 0).
   * 지정 시 columnHeaders 의 모든 헤더 row 를 이 높이로 강제(예: 3단 헤더 총높이 48px → 16 전달).
   * 화면 useEffect/CSS 로는 wrapper 의 columnGroups 재적용에 덮여 무효 → wrapper-level 적용만 유효.
   */
  headerRowHeight?: number;
  /**
   * 미저장 변경(dirty) 집계에서 이 그리드를 제외한다.
   * 조회 전용인데도 코드가 CRUD_TYPE 를 임의로 세팅하는 등 오탐이 나는 그리드에만 사용.
   * (편집 불가 그리드는 CRUD_TYPE 이 생기지 않아 원칙적으로 지정할 필요가 없다.)
   */
  excludeFromDirtyCheck?: boolean;
  /** 공통 컨텍스트(우클릭) 메뉴 사용 여부 (기본 true) */
  useContextMenu?: boolean;
  /**
   * 그리드 레이아웃 개인화(컬럼 표시/순서/폭) 활성화 키 — GSCM TitleSet 승계(opt-in).
   * 지정 시: 진입할 때 저장된 레이아웃 자동 적용 + 컨텍스트 메뉴에 Save/Load/Reset Layout 항목.
   * ⚠️ sheetName 은 admin SHEET_NAME(컬럼 메타 조회 sheetNm 과 동일 값).
   * ⚠️ titleSet 을 자체 구현한 화면(sales-future-price 등)은 지정하지 말 것 — 이중 적용된다.
   */
  layoutKey?: GridLayoutKey;
  /** 컨텍스트 메뉴 하단에 붙는 화면 전용 항목 */
  contextMenuItems?: GridContextMenuItem[];
  /** 컨텍스트 메뉴 Export 파일명 (SubTitle 의 excelFileName 과 동일 용도, 기본 'Excel File') */
  excelFileName?: string;
  /**
   * @deprecated
   * Wijmo 'Initialized' property is hard to handle rendering of component with other states or properties.
   * Add and remove handler with useEffect to set handler for wijmo component.
   */
  initialized?: (grid: TFlexGrid) => void;
  dblClick?: (mouseEvent: MouseEvent) => void;
  click?: (mouseEvent: MouseEvent) => void;
  gotFocus?: (sender: Control, args: EventArgs) => void;
}

const DataGridComp = <T extends WijmoRowItem = WijmoRowItem>({
  gridFilterRef,
  gridRef,
  editTrackerRef,
  itemsSource = [],
  staticColumns = [],
  dynamicColumns = [],
  useSummaryTooltip = true,
  useCellTooptip = true,
  useCheckbox = false,
  useResultColumns = false,
  useAggregationRow = false,
  aggregationRowPlacement = 'below',
  emptyCellAsZero,
  excludeFromDirtyCheck = false,
  useContextMenu = true,
  contextMenuItems,
  excelFileName,
  layoutKey,
  comboParams = {},
  allowMerging = AllowMerging.ColumnHeaders,
  selectionMode = SelectionMode.MultiRange,
  initialized,
  headerRowHeight,
  dblClick,
  click,
  ...gridProps
}: DataGridProps<T>) => {
  const dblClickRef = useRef(dblClick);
  const clickRef = useRef(click);
  dblClickRef.current = dblClick;
  clickRef.current = click;
  // 컨텍스트 메뉴가 이벤트 시점에 참조할 최신값 (initialized 1회 closure 보완)
  const contextMenuItemsRef = useRef(contextMenuItems);
  contextMenuItemsRef.current = contextMenuItems;
  const excelFileNameRef = useRef(excelFileName);
  excelFileNameRef.current = excelFileName;
  const detachContextMenuRef = useRef<() => void>();
  // headerRowHeight 는 매 렌더 변경 가능 → ref 로 최신값 유지 (handleInitialized 1회 closure 보완).
  const headerRowHeightRef = useRef(headerRowHeight);
  headerRowHeightRef.current = headerRowHeight;
  const emptyCellAsZeroRef = useRef(emptyCellAsZero);
  emptyCellAsZeroRef.current = emptyCellAsZero;

  // 정렬 사용 여부 — 화면이 allowSorting 을 false/None 으로 주면 정렬 자체를 막는다.
  // wijmo 기본 정렬은 handleInitialized 에서 항상 None 이고 실제 정렬은 공용 헤더 클릭
  // 핸들러(setSortableColumnHeaderClick)가 담당하므로, 그 등록 여부가 곧 정렬 가능 여부다.
  // 주의: 컬럼 객체의 allowSorting 은 화면이 아니라 사용자가 F3 로 켜는 정렬 스위치라 여기 판정에 쓰지 않는다.
  //   정적 컬럼은 toLeafColumn 이 allowSorting:false 로 만들어 주므로 F3 전에는 꺼진 상태로 시작한다.
  const sortingEnabled =
    gridProps.allowSorting !== false && gridProps.allowSorting !== AllowSorting.None;

  // 다이얼로그(팝업) 안이면 그 스코프 id, 페이지 최상위면 null. 팝업일 때만 F3/F4를 자동 등록한다.
  const scopeId = useContext(DialogScopeContext);
  const tabId = useTabid();
  // 스코프 단축키 핸들러가 이벤트 시점에 참조할 grid/filter 인스턴스.
  const internalGridRef = useRef<TFlexGrid<T>>();
  const internalFilterRef = useRef<FlexGridFilter>();
  // 되돌리기(discardChanges)가 셀 원본값을 읽어야 하므로, 화면이 editTrackerRef 를 안 넘겨도 보관한다.
  const internalEditTrackerRef = useRef<EditTracker<T>>();

  // 미저장 변경(dirty) 집계에 자동 등록 — 화면 코드 수정 없이 모든 그리드가 이탈 가드 대상이 된다.
  // 탭 키에는 항상, 다이얼로그 안이면 스코프 키에도 등록(다이얼로그 닫기 가드용).
  // 판정(check)과 함께 되돌리기(reset)도 등록한다 — confirm 에서 "확인"(버리고 진행)을 누르면
  // 실제로 편집분을 되돌려야 한다. 되돌리지 않으면 itemsSource 배열에 남아 재오픈 시 되살아난다.
  useEffect(() => {
    if (excludeFromDirtyCheck) return;
    const keys = [tabDirtyKey(tabId)];
    if (scopeId !== null) keys.push(scopeDirtyKey(scopeId));
    const unregisterCheck = registerDirtyCheck(keys, () =>
      GridUtils.isDirty(internalGridRef.current)
    );
    const unregisterReset = registerDirtyReset(keys, () => {
      GridAction.discardChanges(internalGridRef.current, internalEditTrackerRef.current);
    });
    return () => {
      unregisterCheck();
      unregisterReset();
    };
  }, [tabId, scopeId, excludeFromDirtyCheck]);

  /**
   * 언마운트 시 남아 있는 편집분 되돌리기 — confirm 을 거치지 않는 닫기 경로까지 덮는 안전망.
   *
   * 그리드가 언마운트되는 경우는 팝업이 닫혔거나 MDI 탭이 닫힌 순간, 이 둘뿐이다
   * (탭 전환은 ViewContainer 가 display 토글로만 숨기고, 조건부로 그리드를 렌더하는 화면은 없다).
   * 둘 다 "화면이 사라진다" = 편집분을 버린다는 뜻이므로 되돌리는 것이 맞다. 취소를 누른 경우엔
   * 애초에 닫히지 않아 언마운트도 없다.
   *
   * 되돌리지 않으면 화면이 넘긴 배열(화면 useMemo 결과 · react-query 캐시 배열)이 오염된 채
   * 남아 팝업 재오픈·탭 재진입 때 신규행이 되살아난다. 팝업의 자체 Close 버튼처럼 CustomDialog
   * 가드를 지나치는 경로는 confirm 이 없으므로 이 안전망이 유일한 정리 지점이다.
   *
   * 그리드가 아니라 배열·EditTracker 만으로 되돌린다 — 이 시점엔 wijmo 컨트롤이 이미 파괴됐을 수 있다.
   */
  const itemsSourceRef = useRef(itemsSource);
  itemsSourceRef.current = itemsSource;
  const excludeFromDirtyCheckRef = useRef(excludeFromDirtyCheck);
  excludeFromDirtyCheckRef.current = excludeFromDirtyCheck;
  useEffect(
    () => () => {
      if (excludeFromDirtyCheckRef.current) return;
      revertRowChanges(itemsSourceRef.current, internalEditTrackerRef.current);
    },
    []
  );

  // ⭐ 그리드 레이아웃 개인화 (layoutKey opt-in) — 진입 시 저장된 TitleSet 조회 후
  //   admin 컬럼 메타 위에 표시/순서/폭을 덮어써 렌더한다 (GSCM: 열 때 자동 적용).
  const [gridLayout, setGridLayout] = useState<GridLayoutRow[] | null>(null);
  const layoutKeyRef = useRef(layoutKey);
  layoutKeyRef.current = layoutKey;
  useEffect(() => {
    if (!layoutKey) return;
    let cancelled = false;
    void fetchGridLayout(layoutKey).then(layout => {
      if (!cancelled) setGridLayout(layout);
    });
    return () => {
      cancelled = true;
    };
    // 객체 리터럴 prop 재생성으로 매 렌더 refetch 되지 않도록 개별 필드를 deps 로 쓴다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [layoutKey?.menuId, layoutKey?.sheetName, layoutKey?.columnType, layoutKey?.divisionId]);

  // 컨텍스트 메뉴 Hide Column 으로 숨긴 컬럼(런타임) — 재렌더에도 유지되도록 파이프라인에서 적용.
  //   layoutKey 화면은 Save Layout 시 이 상태까지 함께 저장된다(표시 목록에서 빠짐 = 숨김).
  const [hiddenColumns, setHiddenColumns] = useState<ReadonlySet<string>>(new Set());
  useEffect(() => {
    // 컬럼 메타가 바뀌면(division 전환/컬럼설정 저장) 런타임 숨김은 초기화 — 메타/레이아웃이 우선
    setHiddenColumns(new Set());
  }, [staticColumns]);

  const layoutAppliedColumns = useMemo(() => {
    const applied = applyGridLayout(staticColumns, layoutKey ? gridLayout : null);
    if (hiddenColumns.size === 0) return applied;
    return applied.map(column =>
      hiddenColumns.has(column.colNm) ? { ...column, visible: false } : column
    );
  }, [staticColumns, gridLayout, layoutKey, hiddenColumns]);
  const layoutAppliedRef = useRef(layoutAppliedColumns);
  layoutAppliedRef.current = layoutAppliedColumns;
  const staticColumnsRef = useRef(staticColumns);
  staticColumnsRef.current = staticColumns;
  const hiddenColumnsRef = useRef(hiddenColumns);
  hiddenColumnsRef.current = hiddenColumns;

  /**
   * 사용자가 드래그로 조정한 컬럼 폭 (binding → px).
   *
   * wijmo 의 `set columnGroups(e){ this.columns.clear(); ... }` 는 대입할 때마다 Column 객체를
   * **통째로 재생성**한다. 그런데 아래 render 는 `columnGroups={[...a, ...b]}` 로 **매 렌더 새 배열**을
   * 넘기므로, react wrapper 의 참조 비교(`!==`)가 항상 성립해 재대입이 일어난다.
   * 결과: 드래그로 줄인 폭이 다음 리렌더에 설정값(colWth)으로 되돌아간다. colWth 가 라벨에 맞춰진
   *   값이면 "라벨 폭보다 더 줄일 수 없다" 로 보인다 (2026-08-04 리포트).
   * 헤더 행 높이·MEASURE dataMap 이 쓰는 것과 동일한 처방 — updatedLayout 마다 다시 적용한다.
   *
   * 컬럼 메타(staticColumns)가 바뀌면 비운다 — division 전환·컬럼셋팅 저장처럼 폭을 새로 정하는
   * 경우엔 설정값이 우선이어야 하기 때문. (조회로는 바뀌지 않아 조회 후에도 폭이 유지된다.)
   *
   * 선언 위치 주의: 아래 handleColumnSettingsSave / buildLayoutMenuItems 가 이 ref 를 참조하므로
   *   반드시 그보다 위에 있어야 한다 (@typescript-eslint/no-use-before-define).
   */
  const userColumnWidthsRef = useRef<Map<string, number>>(new Map());
  useEffect(() => {
    userColumnWidthsRef.current.clear();
  }, [staticColumns]);

  // 컬럼 설정 팝업 (컨텍스트 메뉴 Column Settings…) — 표시/숨김·순서·폭·색 편집
  const [columnSettingsOpen, setColumnSettingsOpen] = useState(false);
  const queryClient = useQueryClient();

  // 팝업 OK — titleSet 저장(표시 컬럼만 1..n) 후 레이아웃 재조회·적용
  const handleColumnSettingsSave = (settings: ColumnLayoutRow[]) => {
    const key = layoutKeyRef.current;
    if (!key) return;
    const visibleRows = settings.filter(s => s.USER_FLAG === 'Y');
    void (async () => {
      const ok = await saveTitleSet({
        menuId: key.menuId,
        sheetName: key.sheetName,
        columnType: key.columnType ?? 'C',
        rows: visibleRows.map((s, i) => ({
          name: s.COLUMN_NAME,
          sortOrderNo: i + 1,
          colWidth: s.COL_WIDTH,
          cellColor: s.CELL_COLOR,
          textColor: s.TEXT_COLOR,
        })),
      });
      const { setToast, setAlert } = useMessageStore.getState();
      if (!ok) {
        void setAlert({
          type: 'alert',
          content: t('MSG_LAYOUT_SAVE_FAILED', '_레이아웃 저장에 실패했습니다.'),
        });
        return;
      }
      // 팝업의 titleSet 캐시(staleTime Infinity) 무효화 — 재진입 시 저장본이 보이도록
      void queryClient.invalidateQueries({ queryKey: [key.menuId, 'titleSet'] });
      userColumnWidthsRef.current.clear();
      setGridLayout(await fetchGridLayout(key));
      setToast({ message: t('MSG_LAYOUT_SAVED', '_레이아웃이 저장되었습니다.'), type: 'success' });
    })();
  };

  // 컨텍스트 메뉴의 Column Settings…/Save/Load/Reset Layout 항목 (layoutKey 지정 시에만).
  //   initialized 1회 closure 에서 호출되므로 렌더 가변값은 전부 ref 로 참조한다.
  const buildLayoutMenuItems = (): GridContextMenuItem[] | undefined => {
    const key = layoutKeyRef.current;
    if (!key) return undefined;

    const columnType = key.columnType ?? 'C';
    const { setToast, setAlert } = useMessageStore.getState();
    const fail = (message: string) => void setAlert({ type: 'alert', content: message });

    // 현재 그리드 상태 → 저장 rows. 계약(GSCM 원형 = 기존 화면들과 동일):
    //   **표시 컬럼만** 1..n 으로 저장 — 행 존재 = 표시. 폭은 실제 렌더 폭(드래그 반영).
    const collectRows = (
      columns: RawFlexGridColumnConfig[],
      useRenderWidth: boolean
    ): TitleSetSaveRow[] => {
      const grid = internalGridRef.current;
      const widthOf = (column: RawFlexGridColumnConfig): number | undefined => {
        if (useRenderWidth) {
          const wijmoColumn = grid?.getColumn(column.colNm);
          if (wijmoColumn) return Math.round(wijmoColumn.renderWidth);
        }
        return column.colWth;
      };
      return columns
        .filter(column => Boolean(column.display) && column.visible !== false)
        .map((column, i) => ({
          name: column.colNm,
          sortOrderNo: i + 1,
          colWidth: widthOf(column),
          cellColor: column.cellColor ?? '',
          textColor: column.textColor ?? '',
        }));
    };

    const persist = async (rows: TitleSetSaveRow[]): Promise<boolean> =>
      saveTitleSet({ menuId: key.menuId, sheetName: key.sheetName, columnType, rows });

    return [
      {
        label: t('CTX_COLUMN_SETTINGS', 'Column Settings…'),
        action: () => setColumnSettingsOpen(true),
      },
      {
        label: t('CTX_SAVE_LAYOUT', 'Save Layout'),
        separatorBefore: true,
        action: () => {
          void (async () => {
            const ok = await persist(collectRows(layoutAppliedRef.current, true));
            if (!ok) return fail(t('MSG_LAYOUT_SAVE_FAILED', '_레이아웃 저장에 실패했습니다.'));
            // 저장본을 다시 읽어 적용 상태와 동기화 (다음 진입과 동일한 값을 보게 됨)
            setGridLayout(await fetchGridLayout(key));
            setToast({
              message: t('MSG_LAYOUT_SAVED', '_레이아웃이 저장되었습니다.'),
              type: 'success',
            });
          })();
        },
      },
      {
        label: t('CTX_LOAD_LAYOUT', 'Load Layout'),
        action: () => {
          void (async () => {
            const layout = await fetchGridLayout(key);
            if (!layout) return fail(t('MSG_LAYOUT_NONE', '_저장된 레이아웃이 없습니다.'));
            userColumnWidthsRef.current.clear(); // 드래그 폭 기억보다 불러온 레이아웃 폭이 우선
            setGridLayout(layout);
            setToast({
              message: t('MSG_LAYOUT_LOADED', '_레이아웃을 불러왔습니다.'),
              type: 'success',
            });
          })();
        },
      },
      {
        label: t('CTX_RESET_LAYOUT', 'Reset Layout (Default)'),
        action: () => {
          void (async () => {
            // BE 에 사용자행 삭제 SP 가 없어 admin 기본값 세트를 그대로 저장한다
            //   (GSCM SET_DEFAULT_TITLESET 과 동일 효과 — 값이 기본과 같아져 원복된다).
            const ok = await persist(collectRows(staticColumnsRef.current, false));
            if (!ok) return fail(t('MSG_LAYOUT_RESET_FAILED', '_레이아웃 초기화에 실패했습니다.'));
            userColumnWidthsRef.current.clear();
            setGridLayout(null);
            setToast({
              message: t('MSG_LAYOUT_RESET', '_레이아웃이 기본값으로 초기화되었습니다.'),
              type: 'success',
            });
          })();
        },
      },
    ];
  };

  useEffect(
    () => () => {
      detachContextMenuRef.current?.();
      if (gridRef) gridRef.current = undefined;
      if (gridFilterRef) gridFilterRef.current = undefined;
      if (editTrackerRef) editTrackerRef.current = undefined;
      internalEditTrackerRef.current = undefined;
    },
    [gridRef, gridFilterRef, editTrackerRef]
  );

  const {
    setSummaryTooltip,
    setCellTooltip,
    setAggregationRow,
    setCheckbox,
    formatEditableColumns,
    formatSortableColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
  } = useDataGridUtils<T>();

  // 자동 콤보 필터 — comboId + comboParams(@mnuId/@divisionId 등) 를 함께 전달해 파라미터 콤보 해소.
  //   (기존엔 comboId 만 전달 → @mnuId 필요 콤보가 빈 결과가 되던 문제 fix. comboParams 미지정 시 종전과 동일)
  //
  // 여러 컬럼이 같은 콤보(cellCboDataTp)를 쓰면 동일 queryKey 가 useQueries 에 중복 전달되어
  //   [QueriesObserver]: Duplicate Queries 경고 발생 → 중복 제거 필수.
  //   ⚠ 중복 제거는 반드시 문자열 comboId 단계에서 끝내고 그 뒤에 객체로 만든다.
  //     객체 상태에서 Set 을 쓰면 매번 새 참조라 하나도 걸러지지 않아 버그가 조용히 되살아난다.
  const comboFilters = [
    ...new Set(
      layoutAppliedColumns
        .filter(
          column =>
            column.display &&
            column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
            column.cellCboDataTp
        )
        .map(column => String(column.cellCboDataTp))
    ),
  ].map(comboId => ({ comboId, ...comboParams }));

  const comboQueries = useTabComboQueries({ filters: comboFilters });
  const comboQueryMap = Object.fromEntries(
    comboFilters.map((filter, i) => [filter.comboId, comboQueries[i]])
  );
  // 상위 콤보 변경 시 하위 셀 정리용 — 핸들러는 grid 생성 시 한 번만 걸리므로 ref 로 최신값을 본다.
  const comboQueryMapRef = useRef(comboQueryMap);
  comboQueryMapRef.current = comboQueryMap;

  const mappedStaticColumns = mapRawColumnsToWijmoColumns(
    layoutAppliedColumns
      .filter(column => column.display)
      .map(column => ({
        ...column,
        dataMap:
          column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO && column.cellCboDataTp
            ? comboQueryMap[column.cellCboDataTp]
            : undefined,
      }))
  ).map(col => ({
    ...col,
    allowMerging: allowMerging !== AllowMerging.None,
  }));

  // 화면이 직접 만든 동적(주차/월/일) 컬럼을 공용 규약에 맞춘다 —
  //   Delete 키가 먹도록 isRequired 기본값(false)을 채우고, 정적 컬럼과 구분되게 _dynamic 을 표식한다.
  const normalizedDynamicColumns = useMemo(
    () => normalizeDynamicColumns(dynamicColumns),
    [dynamicColumns]
  );

  // 2단/3단 헤더(TWO_DEPTH/THREE_DEPTH)에서는 mappedStaticColumns 최상위가 그룹 wrapper라 _fixed가
  //   leaf(columns 내부)에만 있음 — GridUtils.getColumn과 동일한 2단 flatMap으로 leaf까지 펼쳐서 찾는다.
  const flatStaticColumns = mappedStaticColumns
    .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
    .flatMap(smallGroup => smallGroup.columns ?? [smallGroup]);
  const frozenColumns = flatStaticColumns.findLastIndex(column => column._fixed) + 1;

  const handleInitialized = (grid: TFlexGrid<T>) => {
    if (gridRef) gridRef.current = grid;
    internalGridRef.current = grid;

    installGridListBoxWheelStep();
    installComboCaseInsensitiveSearch();

    /**
     * 재조회로 데이터가 다시 실려도 사용자가 건 컬럼 필터를 유지한다.
     *
     * wijmo 기본 동작은 반대다 — FlexGridFilter 생성자가 itemsSourceChanged 에 clear 를 직접
     * 걸어 데이터가 새로 실리면 필터를 통째로 비운다. Event 핸들러는 등록 순서대로 호출되므로
     * 비우기 전에 뜨는 핸들러를 FlexGridFilter 생성 **앞에**, 되돌리는 핸들러를 **뒤에** 건다.
     * 이 순서가 이 코드 위치의 이유다. 순서가 어긋나면 뜨는 시점에 이미 비워져 복원할 게 없다.
     *
     * 조회 결과가 직전과 완전히 같으면 react-query 구조 공유로 배열 참조가 그대로라
     * itemsSourceChanged 자체가 안 나는데, 그때는 필터도 그대로 남아 결과가 같다.
     */
    const getGridFilter = () => gridFilterRef?.current ?? internalFilterRef.current;
    const gridWithAddedRows = grid as TFlexGrid<T> & { _newAddedRowsSet?: WeakSet<object> | null };
    let filterBeforeReload: string | null = null;
    // 필터 예외로 등록된 신규행 집합(keepRowVisibleUnderFilter)도 함께 뜬다.
    //   wijmo 의 clear()/apply() 가 이 집합을 null 로 비우는데, 아래 복원이 곧 apply() 라
    //   되돌려 놓지 않으면 "필터는 살아났는데 방금 추가한 신규행만 사라지는" 상태가 된다.
    let addedRowsBeforeReload: WeakSet<object> | null | undefined = null;
    grid.itemsSourceChanged.addHandler(() => {
      filterBeforeReload = captureGridFilter(getGridFilter());
      addedRowsBeforeReload = gridWithAddedRows._newAddedRowsSet;
    });

    if (gridFilterRef)
      gridFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });
    // 팝업(다이얼로그 스코프)인데 외부 filter ref가 없으면 F4용 filter를 내부 생성.
    else if (scopeId !== null)
      internalFilterRef.current = new FlexGridFilter(grid, {
        filterColumns: [''],
      });

    // wijmo 가 비운 필터를 새로 실린 데이터 위에 되돌린다 (위 캡처 핸들러 주석 참고).
    grid.itemsSourceChanged.addHandler(() => {
      const restored = restoreGridFilter(grid, getGridFilter(), filterBeforeReload);
      // 복원(=apply)이 비운 신규행 예외 집합을 되돌리고 판정만 다시 시킨다.
      if (restored && addedRowsBeforeReload) {
        gridWithAddedRows._newAddedRowsSet = addedRowsBeforeReload;
        grid.collectionView?.refresh();
      }
      filterBeforeReload = null;
      addedRowsBeforeReload = null;
    });

    const editTracker = new EditTracker(grid);
    internalEditTrackerRef.current = editTracker;
    if (editTrackerRef) editTrackerRef.current = editTracker;

    // 빈 셀 '0' 채우기 — 반드시 EditTracker **직후**에 건다(Wijmo Event 는 등록 순서대로 호출).
    //   화면 useEffect 에서 붙이면 순서는 같지만 화면마다 중복 구현 + 순서 실수의 여지가 남는다.
    const emptyCellAsZeroHandler = (sender: TFlexGrid<T>, event: { row: number; col: number }) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      if (!emptyCellAsZeroRef.current?.(binding)) return;
      const row = sender.rows[event.row]?.dataItem as T | undefined;
      if (!row) return;
      if (row[binding] == null || row[binding] === '')
        fillEmptyCellWithZero(row, binding, editTracker);
    };
    grid.cellEditEnded.addHandler(emptyCellAsZeroHandler as never);
    grid.pastedCell.addHandler(emptyCellAsZeroHandler as never);

    // 상위 콤보를 바꿔 하위 셀 값이 드롭다운 후보 밖이 되면 비운다 (컬럼 메타 ATTRIBUTE2 종속 기준).
    //   판정은 표시(getDataMap)와 같은 규칙 — "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값" 불변식.
    //   EditTracker 직후에 걸어야 원본이 이미 기록된 상태라 storeChange 가 되돌림까지 정확히 판정한다.
    const clearStaleComboCellsHandler = (
      sender: TFlexGrid<T>,
      event: { row: number; col: number }
    ) => {
      const changedBinding = sender.columns[event.col]?.binding ?? '';
      if (!changedBinding) return;
      const row = sender.rows[event.row]?.dataItem as T | undefined;
      if (!row) return;

      const stale = findStaleComboCells(
        layoutAppliedRef.current,
        comboQueryMapRef.current,
        row,
        changedBinding
      );
      if (stale.length === 0) return;

      stale.forEach(({ binding, previousValue }) => {
        editTracker.storeChange(row, binding, previousValue, '');
        (row as WijmoRowItem)[binding] = '';
      });
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(clearStaleComboCellsHandler as never);
    grid.pastedCell.addHandler(clearStaleComboCellsHandler as never);

    grid.allowDragging = AllowDragging.None;
    grid.allowSorting = AllowSorting.None;
    // ⭐ Overflow 비트(8) 필수 — 없으면(ColumnsAllCells = 5) wijmo _MouseHandler._handleResizing 의
    //   `isFrozen(col) || !_canResizeOverflow()` 가드가 **항상 참**이 되어, 드래그 중 포인터가
    //   그리드 좌/우 경계를 벗어나는 순간 계산된 새 너비가 버려지고 현재 폭으로 고정된다
    //   (`a = Math.max(col.renderWidth + e, 0)`). deferResizing 이라 이 고정값이 mouseup 에
    //   그대로 커밋 → "컬럼 사이즈가 안 줄어든다" (2026-08-04 리포트).
    //   특히 우측 끝 컬럼은 핸들이 경계 ~5px+스크롤바 폭 안에 있어 시작부터 걸린다.
    //   ColumnsAllCellsOverflow(13) = 리사이즈가 그리드 폭을 넘어도 허용(가로 스크롤로 처리).
    grid.allowResizing = AllowResizing.ColumnsAllCellsOverflow;
    grid.deferResizing = true;
    grid.selectionMode = selectionMode as SelectionMode;
    // 세로 병합 셀 복사/붙여넣기 보정
    grid.expandSelectionOnCopyPaste = false;
    if (allowMerging !== AllowMerging.None && !gridProps.mergeManager)
      grid.mergeManager = new CustomMergeManager(grid);
    // ⭐ rowHeader corner(No/Status) 세로병합 — 화면이 mergeManager 를 커스텀으로 덮어써도
    //   기존 매니저를 감싸 TopLeft 병합만 보강(위임 데코레이터). 공통 grid 전체 corner 병합 일관.
    ensureTopLeftMergeManager(grid);

    grid.formatItem.addHandler(formatEditableColumns);
    grid.formatItem.addHandler(formatSortableColumns);

    setEditableColumns(grid);
    setMoveCellByTab(grid);
    if (sortingEnabled) setSortableColumnHeaderClick(grid);
    setMoveByMetakey(grid, staticColumns.length);
    setHandleUppercase(grid);

    if (useSummaryTooltip) setSummaryTooltip(grid);
    if (useCellTooptip) setCellTooltip(grid);
    if (useAggregationRow) setAggregationRow(grid, aggregationRowPlacement);
    if (useCheckbox) setCheckbox(grid);
    if (useResultColumns) setResultColumn(grid);

    if (!gridProps.isReadOnly) grid.rowHeaders.columns.push(new Column({ align: 'center' }));
    grid.rowHeaders.columns[0].width = initialIndexRowHeaderWidth;
    /**
     * TODO: wijmo 객체와 hostElement의 렌더링 시점 차이로 인해 hostElement 등에 핸들러를 추가하는 경우 다음과 같이 ref로 적용하였음.
     * keyboard event, mouse event 등은 다음과 같이 새로 추가하여 ref로 관리하는 방식 사용 필요 - 강민재
     */
    grid.hostElement.addEventListener('dblclick', e => dblClickRef.current?.(e));
    grid.hostElement.addEventListener('click', e => clickRef.current?.(e));

    // ⭐ 공통 컨텍스트(우클릭) 메뉴 — 헤더: Pin/Filter/Sort/Autosize, 바디: Copy/Export.
    //   화면 전용 항목은 contextMenuItems prop 으로 주입 (ref 로 최신값 참조).
    if (useContextMenu) {
      detachContextMenuRef.current = attachGridContextMenu(grid as TFlexGrid, {
        getFilter: () => gridFilterRef?.current ?? internalFilterRef.current,
        onExport: () =>
          void GridAction.excelDownload(
            grid,
            excelFileNameRef.current ?? 'Excel File',
            useUIStore.getState().setProgress
          ),
        getCustomItems: () => contextMenuItemsRef.current,
        getLayoutItems: buildLayoutMenuItems,
        // Autosize 결과를 사용자 폭 기억에 반영 — columnGroups 재대입 시에도 폭 유지 (위 주석 참조)
        onWidthChanged: (binding, width) => userColumnWidthsRef.current.set(binding, width),
        // 컬럼 숨기기 — 런타임 상태로 파이프라인에서 적용. layoutKey 화면은 Save Layout 시 함께 저장.
        onHideColumn: binding => setHiddenColumns(prev => new Set([...prev, binding])),
        onUnhideAllColumns: () => setHiddenColumns(new Set()),
        hasHiddenColumns: () => hiddenColumnsRef.current.size > 0,
      });
    }

    // 드래그로 확정된 폭을 기억해 둔다 (위 userColumnWidthsRef 주석 참고).
    //   rowHeaders 의 No/상태 컬럼은 binding 이 없어 자연히 제외된다.
    grid.resizedColumn.addHandler((_sender, e) => {
      const column = e.getColumn();
      if (column?.binding == null) return;
      userColumnWidthsRef.current.set(column.binding, column.renderWidth);
    });

    // ⭐ 다단 헤더 행 높이 — columnGroups 재적용으로 헤더 row 높이가 리셋되므로
    //   updatedLayout(매 layout refresh 후)에 재적용. 미지정(undefined) 화면은 무영향(회귀 0).
    //   guard: 이미 목표 높이면 skip → 무한 루프 방지.
    grid.updatedLayout.addHandler(() => {
      ensureTopLeftMergeManager(grid);

      // columnGroups 재대입으로 끊어진 필터-컬럼 연결 복구 (rebindFilterColumns 주석 참고).
      //   끊어진 필터가 있을 때만 동작하므로 매 레이아웃 갱신마다 불러도 안전하다.
      rebindFilterColumns(grid, getGridFilter());

      // columnGroups 재대입으로 되돌아간 폭을 사용자가 조정한 값으로 복원.
      //   guard: 이미 목표 폭이면 skip → updatedLayout 무한 루프 방지.
      userColumnWidthsRef.current.forEach((width, binding) => {
        const column = grid.getColumn(binding);
        if (column && column.width !== width) column.width = width;
      });

      const h = headerRowHeightRef.current;
      if (h == null) return;
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      if (Math.round(headerRows.defaultSize) === h) return;
      headerRows.defaultSize = h;
    });

    // 상위에서 넘긴 initialized 는 내부 설정이 모두 끝난 뒤 마지막에 호출한다.
    initialized?.(grid as TFlexGrid);
  };

  // 팝업(다이얼로그 스코프) 안의 그리드에만 F3(Sort)/F4(Filter)를 자동 등록.
  // 메인화면 그리드는 scopeId === null 이라 등록하지 않는다(SubTitle이 담당).
  useEffect(() => {
    if (scopeId === null) return;

    const hotkeyHandler = (keyboardEvent: KeyboardEvent) => {
      // 현재 활성(최상위) 다이얼로그의 그리드에서, 그리고 그 그리드가 포커스일 때만 동작.
      if (!useDialogStore.getState().isActiveScope(scopeId)) return;
      const grid = internalGridRef.current;
      if (!grid?.containsFocus()) return;

      if (keyboardEvent.key === 'F3') {
        GridAction.toggleColumnSort(grid);
      } else if (keyboardEvent.key === 'F4') {
        const filter = gridFilterRef?.current ?? internalFilterRef.current;
        if (!filter) return;
        // F4에서 wijmo 기본 동작(datamap)이 열리므로 캡처 단계에서 차단 (SubTitle과 동일)
        keyboardEvent.preventDefault();
        keyboardEvent.stopImmediatePropagation();
        GridAction.toggleColumnFilter(grid, filter);
      }
    };

    globalThis.window.addEventListener('keydown', hotkeyHandler, true);
    return () => globalThis.window.removeEventListener('keydown', hotkeyHandler, true);
  }, [scopeId, gridFilterRef]);

  return (
    <>
      <FlexGrid
        style={{
          // flex 부모(페이지 .view 등) 안에서는 flex:1 1 0 이 우선 적용되어 "남은 높이"를 채우고,
          // block 부모(모달의 고정 높이 wrapper 등) 안에서는 flex 가 무시되고 height:100% 가 적용된다.
          // minHeight:0 은 flex 컨테이너에서 내용만큼 늘어나 페이지가 스크롤되는 것을 방지(스크롤은 그리드 내부에).
          height: '100%',
          flex: '1 1 0%',
          minHeight: 0,
        }}
        itemsSource={itemsSource}
        frozenColumns={frozenColumns}
        cloneFrozenCells
        columnGroups={[...mappedStaticColumns, ...normalizedDynamicColumns]}
        initialized={handleInitialized}
        allowMerging={allowMerging}
        {...gridProps}
      />
      {/* 컬럼 설정 팝업 — 컨텍스트 메뉴 Column Settings… (layoutKey 지정 그리드만) */}
      {layoutKey && (
        <ColumnLayoutModal
          open={columnSettingsOpen}
          modalClose={() => setColumnSettingsOpen(false)}
          menuId={layoutKey.menuId}
          sheetName={layoutKey.sheetName}
          columnType={layoutKey.columnType ?? 'C'}
          divisionId={layoutKey.divisionId}
          fallbackColumns={staticColumns
            .filter(column => column.visible !== false)
            .map(column => ({
              key: column.colNm,
              header: column.colLblNm ?? column.colNm,
              width: column.colWth,
            }))}
          // Default 원복 기준 = admin 메타 원본 (개인화 미적용 staticColumns)
          defaultSettings={toColumnLayoutSettings(staticColumns)}
          leftTitle='Invisible'
          rightTitle='Visible'
          onSave={handleColumnSettingsSave}
        />
      )}
    </>
  );
};

export const DataGrid = memo(DataGridComp) as typeof DataGridComp;
