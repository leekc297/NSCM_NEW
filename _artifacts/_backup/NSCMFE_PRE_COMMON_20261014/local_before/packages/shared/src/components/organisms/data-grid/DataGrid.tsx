import {
  type Control,
  type EventArgs,
  type ObservableArray,
  type SortDescription,
} from '@mescius/wijmo';
import {
  AllowDragging,
  AllowMerging,
  AllowResizing,
  AllowSorting,
  CellRange,
  Column,
  DataMap,
  _EditHandler,
  SelectionMode,
  type CellEditEndingEventArgs,
  type CellRangeEventArgs,
  type FlexGrid as TFlexGrid,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGrid, type FlexGridProps } from '@mescius/wijmo.react.grid';
import {
  memo,
  type MutableRefObject,
  useCallback,
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
  buildLeafColumnDataMap,
  captureGridFilter,
  captureGridSort,
  CustomMergeManager,
  EditTracker,
  ensureTopLeftMergeManager,
  fillEmptyCellWithZero,
  findStaleComboCells,
  findStaleRowParamComboCells,
  GridAction,
  insertComboId,
  installInsertPinConverter,
  isRowParamCombo,
  isTypingAllowed,
  isValueAllowed,
  GridUtils,
  mapRawColumnsToWijmoColumns,
  normalizeDynamicColumns,
  type NumberInputRule,
  parseComboFilterBindings,
  rebindFilterColumns,
  restoreGridFilter,
  restoreGridSort,
  revertRowChanges,
  safeString,
} from '@foundation/utils';
import { useTabComboQueryResults } from '@shared/hooks';
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
import { GRID_COMBO_SRC } from './gridComboSrc';
import { attachGridContextMenu, type GridContextMenuItem } from './gridContextMenu';
import {
  applyGridLayout,
  fetchGridLayout,
  saveTitleSet,
  type GridLayoutKey,
  type GridLayoutRow,
  type TitleSetSaveRow,
} from './titleSetApi';
import { useRowParamCombos } from './useRowParamCombos';

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
/**
 * 한글 조합 중 마지막 음절에서 종성을 뗀 형태. 종성이 없으면 null.
 *
 * 조합 문자열은 "파워" 를 칠 때 파 -> 팡 -> 파우 -> 파워 로 흐른다. 가운데 "팡" 단계는 다음 음절의
 * 초성(ㅇ)이 종성으로 잠깐 붙은 상태라, 그대로 찾으면 후보가 없어 반응이 끊긴다. 그때 종성을 뗀
 * "파" 로 한 번 더 찾으면 매 타건마다 후보가 이어진다.
 */
const HANGUL_FIRST = 0xac00;
const HANGUL_LASTChar = 0xd7a3;
const JONGSEONG_COUNT = 28;
const withoutTrailingJongseong = (text: string): string | null => {
  if (!text) return null;
  const code = text.charCodeAt(text.length - 1);
  if (code < HANGUL_FIRST || code > HANGUL_LASTChar) return null;
  const jongseong = (code - HANGUL_FIRST) % JONGSEONG_COUNT;
  if (jongseong === 0) return null;
  return text.slice(0, -1) + String.fromCharCode(code - jongseong);
};

/**
 * 조합 중 자동완성 미리보기 - 편집기 값 대신 화면에 겹쳐 그린다.
 *
 * 영문은 wijmo 가 매 타건마다 편집기 값을 후보로 채우고 뒷부분을 선택 상태로 둔다(ace -> ace KR).
 * 한글은 그렇게 할 수 없다 - 조합 중에 editor.value / selectionRange 를 건드리면 조합이 취소되고
 * 눌린 키가 영문 raw 로 확정된다(2026-09-07 실측). 그래서 값은 그대로 두고, 친 글자 바로 뒤에
 * 붙을 부분만 같은 글꼴로 겹쳐 그려 같은 모양을 만든다.
 *
 * 후보가 친 글자로 시작할 때만 그린다 - 종성 fallback("팡" -> "파" 로 찾은 경우)은 화면 글자와
 * 이어 붙지 않아 어색해지므로 그 순간에는 감춘다(다음 타건에서 다시 뜬다).
 */
let composingPreviewEl: HTMLDivElement | null = null;
let composingMeasureEl: HTMLSpanElement | null = null;
const hideComposingPreview = () => {
  if (composingPreviewEl) composingPreviewEl.hidden = true;
};
const showComposingPreview = (editor: HTMLInputElement, typed: string, candidate: string) => {
  if (!candidate.toLowerCase().startsWith(typed.toLowerCase())) return hideComposingPreview();
  const rest = candidate.slice(typed.length);
  if (!rest) return hideComposingPreview();

  composingPreviewEl ??= document.body.appendChild(document.createElement('div'));
  composingPreviewEl.className = 'wj-composing-preview';
  // 폭 측정용 - 편집기와 같은 글꼴로 친 글자의 실제 폭을 잰다.
  composingMeasureEl ??= document.body.appendChild(document.createElement('span'));
  composingMeasureEl.style.cssText = 'position:fixed;visibility:hidden;white-space:pre;top:-9999px;left:0';

  const style = globalThis.getComputedStyle(editor);
  composingMeasureEl.style.font = style.font;
  composingMeasureEl.textContent = typed;
  const typedWidth = composingMeasureEl.getBoundingClientRect().width;

  const box = editor.getBoundingClientRect();
  const left = box.left + parseFloat(style.paddingLeft || '0') + typedWidth - editor.scrollLeft;
  composingPreviewEl.style.font = style.font;
  composingPreviewEl.style.left = `${left}px`;
  composingPreviewEl.style.top = `${box.top + parseFloat(style.paddingTop || '0')}px`;
  composingPreviewEl.style.lineHeight = `${box.height - parseFloat(style.paddingTop || '0') - parseFloat(style.paddingBottom || '0')}px`;
  // 배경은 안쪽 span 이 갖는다 - 바깥 div 에 주면 line-height 만큼(셀 높이) 블록이 커진다.
  const restEl = composingPreviewEl.firstElementChild ?? composingPreviewEl.appendChild(document.createElement('span'));
  restEl.textContent = rest;
  // 편집기 오른쪽 경계를 넘어가면 그 부분은 감춘다(셀 밖으로 삐져나오지 않게).
  composingPreviewEl.style.maxWidth = `${Math.max(0, box.right - left - 2)}px`;
  composingPreviewEl.style.overflow = 'hidden';
  composingPreviewEl.hidden = false;
};

/**
 * 조합 중(IME) 후보 미리보기 - 편집기 값은 건드리지 않고 드롭다운 선택만 옮긴다.
 *
 * 한글은 다음 음절이 시작돼야 조합이 끝나므로(compositionend), 확정만 기다리면 반응이 한 음절씩
 * 늦다("파" 를 쳐도 무반응, "파워" 에서야 반응). 조합 중에도 후보를 짚어 주려면 compositionupdate
 * 를 봐야 하는데, 그 시점에 editor.value / selectionRange 를 건드리면 조합이 취소되고 눌린 키가
 * 영문 raw 로 확정된다. 그래서 여기서는 목록 선택만 옮긴다 - 값 자동완성은 조합이 끝난 뒤
 * (compositionend -> _keypress) 원본 로직이 그대로 한다.
 *
 * 검색어를 editor.value 에서 읽으면 안 된다 - compositionupdate 는 입력칸 값이 갱신되기 **전**에
 * 오므로 한 타건 뒤처진 문자열을 보게 된다("중" 을 쳐도 "주" 로 찾아 실패). 조합 문자열은
 * CompositionEvent.data 가 가지고 있으므로, 조합 시작 시점의 앞부분 + data 로 만들어 넘긴다.
 */
const highlightComposingCandidate = (editHandler: _EditHandler, typed: string) => {
  const editor = editHandler._edt;
  const listBox = editHandler._lbx;
  const list = editHandler._list as unknown[] | null;
  // listBox 는 없을 수 있다(드롭다운 미개방) - 후보 목록(_list)만 있으면 미리보기는 가능하다.
  if (!editor || !list || list.length === 0 || !typed) return;

  const map = editHandler._map;
  const search = editHandler._mapSearch;
  const displayOf = (item: unknown): string => {
    const raw =
      map?.useFilter && item && typeof item === 'object'
        ? (item as Record<string, unknown>)[map.displayMemberPath]
        : item;
    if (typeof raw === 'string') return raw;
    return typeof raw === 'number' || typeof raw === 'boolean' ? String(raw) : '';
  };

  // 검색 규칙은 아래 자동완성(_keypress)과 같은 것을 쓴다 - 미리보기와 확정 결과가 갈리면 안 된다.
  const findIndexOf = (text: string) => {
    const lower = text.toLowerCase();
    return list.findIndex(item =>
      search ? search(displayOf(item), text) : displayOf(item).toLowerCase().startsWith(lower)
    );
  };

  let index = findIndexOf(typed);
  if (index < 0) {
    // "팡" 처럼 다음 음절 초성이 종성으로 붙은 단계 - 종성을 떼고 다시 찾는다.
    const partial = withoutTrailingJongseong(typed);
    if (partial) index = findIndexOf(partial);
  }
  if (index < 0) {
    hideComposingPreview();
    return;
  }
  // 드롭다운이 열려 있으면 목록 선택도 함께 옮긴다(열려 있을 때의 기존 동작).
  if (listBox) listBox.selectedIndex = index;
  showComposingPreview(editor, typed, displayOf(list[index]));
};

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

    // 4) 한글(IME) 자동완성 - wijmo 는 compositionend 도 이 핸들러로 넘기지만(_compositionendHandler)
    //    CompositionEvent 에는 key 가 없다. 그러면 내부에서 문자코드를 32(공백)로 잡고
    //    `if (e.target == t && i) o += String.fromCharCode(i)` 로 **검색어 뒤에 공백을 붙인다**
    //    ("서" -> "서 "). 그래서 한글은 후보를 절대 못 찾는다(영문은 e.key 가 실제 문자라 정상).
    //    target 을 편집기가 아닌 값으로 바꿔 그 공백 추가 분기만 건너뛰게 한다 - 검색어는
    //    "커서 앞 텍스트"(= 방금 조합이 끝난 글자까지) 그대로가 되어 영문과 같은 규칙으로 찾는다.
    //    아래 2) 표기 보정은 event.key 가 없어 자연히 건너뛴다(한글은 대소문자 개념이 없다).
    if (typeof CompositionEvent !== 'undefined' && event instanceof CompositionEvent) {
      const forwarded = {
        code: '',
        key: undefined,
        target: null,
        preventDefault: () => event.preventDefault(),
      } as unknown as KeyboardEvent;
      originalKeypress.call(this, forwarded);
      return;
    }

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

  // 4-1) 조합 중 후보 미리보기 - 편집기가 만들어질 때 compositionupdate 를 한 번만 건다.
  //   편집기 DOM 은 재사용되기도 하므로 중복 등록을 요소 표식으로 막고, 이벤트 시점의 핸들러는
  //   요소에 심어 둔 최신 참조로 읽는다(편집기가 다른 그리드/컬럼에 재사용되는 경우 대비).
  const BOUND = '__nscmComposingBound';
  const HANDLER = '__nscmEditHandler';
  const PREFIX = '__nscmComposingPrefix';
  // eslint-disable-next-line @typescript-eslint/unbound-method
  const originalStartEditing = _EditHandler.prototype.startEditing;
  _EditHandler.prototype.startEditing = function (
    this: _EditHandler,
    fullEdit?: boolean,
    r?: number,
    c?: number | string,
    focus?: boolean,
    evt?: unknown
  ) {
    const started = originalStartEditing.call(this, fullEdit, r, c, focus, evt);
    const editor = this._edt as (HTMLInputElement & Record<string, unknown>) | null;
    if (editor) {
      editor[HANDLER] = this;
      if (!editor[BOUND]) {
        editor[BOUND] = true;
        // 조합이 시작될 때의 '조합 구간 앞 텍스트'. 조합 문자열은 이 뒤에 붙는다.
        editor.addEventListener('compositionstart', () => {
          editor[PREFIX] = editor.value.slice(0, editor.selectionStart ?? 0);
        });
        editor.addEventListener('compositionupdate', event => {
          const handler = editor[HANDLER] as _EditHandler | undefined;
          if (!handler) return;
          const prefix = typeof editor[PREFIX] === 'string' ? editor[PREFIX] : '';
          highlightComposingCandidate(handler, prefix + (event.data ?? ''));
        });
        // 조합이 끝나거나 편집기를 벗어나면 미리보기를 닫는다. 조합 종료 시점에는 wijmo 가
        //   편집기 값을 후보로 자동완성하므로 미리보기를 계속 띄울 이유가 없다.
        editor.addEventListener('compositionend', () => hideComposingPreview());
        editor.addEventListener('blur', () => hideComposingPreview());
        editor.addEventListener('keydown', keyEvent => {
          // Esc / Enter / Tab 로 편집을 끝내는 경우도 즉시 닫는다.
          if (['Escape', 'Enter', 'Tab'].includes(keyEvent.key)) hideComposingPreview();
        });
      }
    }
    return started;
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
   * 정적 컬럼(admin 메타)의 숫자 입력 제한. 키는 컬럼 binding(colNm).
   * 메타에 없는 화면 선언이라 admin 이 관리하는 속성을 덮어쓰지 않는다. 동적 컬럼은 FlexGridColumnConfig 의
   * positiveOnly/integerOnly/decimalPlaces 로 직접 준다.
   *
   * 렌더마다 새 객체를 만들지 말고 모듈 상수로 넘긴다(ref 로 읽어 재등록은 없지만 불필요한 재렌더를 피한다).
   */
  numberRules?: Record<string, NumberInputRule>;
  /**
   * 자동 콤보(cellCtrlObjTpCd=COMBO)의 SQL 바인드 파라미터(@mnuId / @divisionId 등) 해소용 공통 파라미터.
   * comboId 와 함께 admin/combo 로 전달되어 @키 치환에 사용됨.
   * ⚠ BE makeComboQuery 는 raw 치환이므로 **문자열 리터럴 값은 작은따옴표로 감싸 전달**해야 함
   *   (예: { mnuId: "'DMF0048'" } → PROGRAM_ID = 'DMF0048'). BE resolveComboBoxDataMaps 와 동일 규약.
   * 미지정 시 기존 동작(파라미터 없는 콤보만 정상) — 회귀 0. 미사용 콤보는 여분 파라미터를 무시(무해).
   */
  comboParams?: Record<string, string>;
  /**
   * 그리드 시트명(admin SHEET_NAME). 지정 시 이 그리드의 셀 콤보 요청(자동 콤보 + 행파라미터 콤보)에
   * sheetName 이 함께 실려 콤보 SQL 의 @sheetName(SHEET_NAME 스코프)을 해소한다.
   * 화면 스코프 mnuId(콤보 훅이 자동 주입)와 짝이다 — mnuId 는 화면당 하나라 자동이지만, 시트는
   * 화면 안에 여럿이라 그 콤보가 속한 그리드가 값을 넘겨야 한다.
   * 미지정 시 layoutKey.sheetName 을 승계하며, 둘 다 없으면 sheetName 미전송(종전 동작, 회귀 0).
   */
  sheetName?: string;
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

// 빈 기본값은 모듈 상수로 둔다 — 파라미터 기본값(`= []` / `= {}`)은 렌더마다 새 참조라
//   아래 normalizedDynamicColumns -> columnGroups memo 가 매 렌더 깨진다. 그러면 Wijmo 가 렌더마다
//   컬럼을 통째로 재생성하고 그때 col.dataMap 이 지워져, 콤보 셀이 드롭다운 대신 텍스트박스로
//   떨어진다 (2026-09-02 DMF0004 Sold-To Customer 리포트).
//   columnGroups 참조 안정이 콤보 dataMap 을 구조에서 분리한 설계의 전제다 — 그 전제를 여기서 지킨다.
const EMPTY_DYNAMIC_COLUMNS: FlexGridColumnConfig[] = [];
const EMPTY_COMBO_PARAMS: Record<string, string> = {};

const DataGridComp = <T extends WijmoRowItem = WijmoRowItem>({
  gridFilterRef,
  gridRef,
  editTrackerRef,
  itemsSource = [],
  staticColumns = [],
  dynamicColumns = EMPTY_DYNAMIC_COLUMNS,
  useSummaryTooltip = true,
  useCellTooptip = true,
  useCheckbox = false,
  useResultColumns = false,
  useAggregationRow = false,
  aggregationRowPlacement = 'below',
  emptyCellAsZero,
  numberRules,
  excludeFromDirtyCheck = false,
  useContextMenu = true,
  contextMenuItems,
  excelFileName,
  layoutKey,
  comboParams = EMPTY_COMBO_PARAMS,
  sheetName,
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
  const numberRulesRef = useRef(numberRules);
  numberRulesRef.current = numberRules;

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
  // 화면이 소유한 동적 컬럼 visible 재계산 이펙트(applyDynVisibility 류, sumYn/드릴다운 기반)가
  //   Hide Column 으로 숨긴 컬럼을 되살리지 않도록, 그리드 인스턴스에 직접 얹어 전달한다.
  //   Column 객체에 `_userHidden` 같은 커스텀 플래그를 심어도 전달이 안 된다 — wijmo Column
  //   생성자가 쓰는 `copy()` 유틸이 `_` 로 시작하는 키를 통째로 무시하기 때문(2026-09-01 실측).
  //   반면 grid 인스턴스 자체는 참조 공유라 임의 프로퍼티를 그대로 얹을 수 있다
  //   (`_newAddedRowsSet` 과 같은 기존 배선과 동일 패턴).
  useEffect(() => {
    const g = internalGridRef.current;
    if (!g) return;
    (g as TFlexGrid<T> & { _userHiddenColumns?: ReadonlySet<string> })._userHiddenColumns =
      hiddenColumns;
  }, [hiddenColumns]);

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
    formatPendingComboColumns,
    formatTextTypeColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
    setMultiColumnResize,
  } = useDataGridUtils<T>();

  // 자동 콤보 필터 — comboId + comboParams(@mnuId/@divisionId 등) 를 함께 전달해 파라미터 콤보 해소.
  //   (기존엔 comboId 만 전달 → @mnuId 필요 콤보가 빈 결과가 되던 문제 fix. comboParams 미지정 시 종전과 동일)
  //
  // 여러 컬럼이 같은 콤보(cellCboDataTp)를 쓰면 동일 queryKey 가 useQueries 에 중복 전달되어
  //   [QueriesObserver]: Duplicate Queries 경고 발생 → 중복 제거 필수.
  //   ⚠ 중복 제거는 반드시 문자열 comboId 단계에서 끝내고 그 뒤에 객체로 만든다.
  //     객체 상태에서 Set 을 쓰면 매번 새 참조라 하나도 걸러지지 않아 버그가 조용히 되살아난다.
  //   PARAM9(신규행 전용 콤보)도 같이 모은다 - 신규행만 그 콤보를 보므로 두 목록이 다 필요하다.
  //     PARAM10='D' 인 컬럼은 여기가 아니라 useRowParamCombos 가 행 조합별로 조회한다.
  const comboFilters = [
    ...new Set(
      layoutAppliedColumns
        .filter(
          column =>
            column.display &&
            column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
            column.cellCboDataTp
        )
        .flatMap(column => [String(column.cellCboDataTp), insertComboId(column)])
        .filter(Boolean)
    ),
  ].map(comboId => ({ comboId, ...comboParams }));

  // 콤보에 실을 시트명 — 명시 prop 우선, 없으면 layoutKey 승계(둘 다 없으면 미전송). mnuId(자동)와
  //   짝인 시트 스코프로, 이 그리드의 자동 콤보와 행파라미터 콤보에 함께 실린다.
  const comboSheetName = sheetName ?? layoutKey?.sheetName;

  // src='grid' — Network 탭에서 `admin/combo?src=grid` 로 검색조건 콤보와 구분된다.
  //   화면이 따로 줄 필요 없이 그리드 셀 콤보 전부가 여기서 표식된다.
  const comboQueryResults = useTabComboQueryResults({
    filters: comboFilters,
    src: GRID_COMBO_SRC,
    sheetName: comboSheetName,
  });
  const comboQueries = comboQueryResults.map(item => item.data);
  const comboQueryMap = Object.fromEntries(
    comboFilters.map((filter, i) => [filter.comboId, comboQueries[i]])
  );
  // 상위 콤보 변경 시 하위 셀 정리용 — 핸들러는 grid 생성 시 한 번만 걸리므로 ref 로 최신값을 본다.
  const comboQueryMapRef = useRef(comboQueryMap);
  comboQueryMapRef.current = comboQueryMap;

  // 아직 응답이 안 온(그리고 영구 실패도 아닌) 콤보 컬럼의 binding 집합 — 초기 렌더에서 원본
  //   코드값이 잠깐(네트워크 지연 시엔 길게) 노출되는 걸 막기 위해 formatItem 이 이 컬럼들의
  //   셀 텍스트를 비운다(formatPendingComboColumns). 응답이 오면 comboMapSignature 가 바뀌어
  //   apply 이펙트가 dataMap 을 붙이고, 같은 렌더에서 이 Set 에서도 빠지므로 재도색 시 정상 값이
  //   보인다. 실패(isError)는 로딩과 구분해 제외한다 — 안 그러면 실패한 콤보 컬럼이 영원히
  //   빈 채로 남는다(이전엔 최소한 원본 코드는 보였으므로 그게 오히려 회귀).
  //   행-파라미터 콤보(PARAM10='D')는 편집 진입이 곧 조회 트리거라 이 초기 렌더 갭이 다른
  //   메커니즘(pendingComboColumnsRef)으로 이미 다뤄지고 있어 여기서 명시적으로 제외한다.
  const comboQueryStatusMap = Object.fromEntries(
    comboFilters.map((filter, i) => [filter.comboId, comboQueryResults[i]])
  );
  const pendingComboBindingsRef = useRef<Set<string>>(new Set());
  pendingComboBindingsRef.current = new Set(
    layoutAppliedColumns
      .filter(
        column =>
          column.display &&
          column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO &&
          column.cellCboDataTp &&
          !isRowParamCombo(column)
      )
      .filter(column => {
        const status = comboQueryStatusMap[String(column.cellCboDataTp)];
        return status?.isPending && !status?.isError;
      })
      .map(column => column.colNm)
  );

  // 컬럼 메타 PARAM10='D' 인 콤보 — 행 값 조합마다 따로 조회한다(지연). 규칙은 useRowParamCombos 참조.
  const { rowParamRows, insertRowParamRows, registerTouchedRow } = useRowParamCombos({
    columns: layoutAppliedColumns.filter(column => column.display),
    sheetName: comboSheetName,
  });

  // 핸들러는 grid 생성 시 한 번만 걸리므로 ref 로 최신 콜백을 본다.
  const registerTouchedRowRef = useRef(registerTouchedRow);
  registerTouchedRowRef.current = registerTouchedRow;

  // 구조(binding/헤더/그룹/폭)만 만든다 — 콤보 dataMap 은 여기서 굽지 않고 아래 apply 이펙트가
  //   col.dataMap 으로만 반영한다. 이유: columnGroups 에 dataMap 을 실으면 콤보 응답마다
  //   columnGroups 가 새 배열이 되어 Wijmo 가 전 컬럼(다단 헤더 포함)을 통째로 재생성한다 →
  //   "헤더가 왔다 갔다" + 깜박임(행-파라미터 콤보가 행마다 조회되는 화면에서 특히 심함).
  //   구조만 넘기면 참조가 안정돼 재생성이 안 일어나고, 데이터는 dataMap 교체로만 갱신된다.
  //   memo 키에 콤보 데이터가 없으므로 콤보 응답이 와도 이 배열은 그대로 유지된다.
  const mappedStaticColumns = useMemo(
    () =>
      mapRawColumnsToWijmoColumns(layoutAppliedColumns.filter(column => column.display)).map(
        col => ({
          ...col,
          allowMerging: allowMerging !== AllowMerging.None,
        })
      ),
    [layoutAppliedColumns, allowMerging]
  );

  // 화면이 직접 만든 동적(주차/월/일) 컬럼을 공용 규약에 맞춘다 —
  //   Delete 키가 먹도록 isRequired 기본값(false)을 채우고, 정적 컬럼과 구분되게 _dynamic 을 표식한다.
  // 컨텍스트 메뉴 Hide Column 은 정적 컬럼(layoutAppliedColumns)에만 적용돼 동적 컬럼에서는 무동작이었다.
  //   동적 컬럼은 2/3단 그룹(columns 중첩)일 수 있어 leaf 까지 재귀로 내려가 hiddenColumns 를 적용한다.
  //   화면의 visible 재계산 이펙트(applyDynVisibility 류)가 이 숨김을 되살리지 않게 하는 처리는
  //   위 `_userHiddenColumns` 그리드 프로퍼티 배선이 담당한다(Column 커스텀 플래그로는 전달 불가).
  const normalizedDynamicColumns = useMemo(() => {
    const applyHiddenColumns = (columns: FlexGridColumnConfig[]): FlexGridColumnConfig[] =>
      columns.map(column => {
        if (column.columns) return { ...column, columns: applyHiddenColumns(column.columns) };
        const hidden = !!column.binding && hiddenColumns.has(column.binding);
        return hidden ? { ...column, visible: false } : column;
      });
    return applyHiddenColumns(normalizeDynamicColumns(dynamicColumns));
  }, [dynamicColumns, hiddenColumns]);

  // 2단/3단 헤더(TWO_DEPTH/THREE_DEPTH)에서는 mappedStaticColumns 최상위가 그룹 wrapper라 _fixed가
  //   leaf(columns 내부)에만 있음 — GridUtils.getColumn과 동일한 2단 flatMap으로 leaf까지 펼쳐서 찾는다.
  const flatStaticColumns = mappedStaticColumns
    .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
    .flatMap(smallGroup => smallGroup.columns ?? [smallGroup]);
  const frozenColumns = flatStaticColumns.findLastIndex(column => column._fixed) + 1;

  // Wijmo columnGroups — 구조가 안 바뀌면 참조를 유지한다. 콤보 응답으로는 바뀌지 않으므로(위
  //   mappedStaticColumns 주석) Wijmo 가 컬럼을 재생성하지 않아 다단 헤더가 흔들리지 않는다.
  const columnGroups = useMemo(
    () => [...mappedStaticColumns, ...normalizedDynamicColumns],
    [mappedStaticColumns, normalizedDynamicColumns]
  );

  // 콤보 데이터 변경 서명 — 콤보/행-파라미터 응답이 실제로 바뀌었을 때만 아래 apply 이펙트를 돌린다.
  //   length 만으로는 division 전환처럼 건수가 같고 내용만 다른 경우를 놓칠 수 있어 첫/끝 CODE 도 넣는다.
  const comboMapSignature = comboFilters
    .map((filter, i) => {
      const rows = comboQueries[i] as Array<{ CODE?: string }> | undefined;
      const len = rows?.length ?? 'x';
      const first = rows?.[0]?.CODE ?? '';
      const last = rows && rows.length > 0 ? (rows[rows.length - 1]?.CODE ?? '') : '';
      return `${filter.comboId}#${len}#${first}#${last}`;
    })
    .join(',');

  const rowParamRowsRef = useRef(rowParamRows);
  rowParamRowsRef.current = rowParamRows;
  const insertRowParamRowsRef = useRef(insertRowParamRows);
  insertRowParamRowsRef.current = insertRowParamRows;

  // 재조회형(PARAM10='D') 상위 콤보를 바꾼 뒤 하위 셀을 재검증할 행 큐.
  //   재조회는 비동기라 편집 직후엔 새 후보가 아직 없다 — 여기 담아 두고 후보가 도착하면(아래 이펙트)
  //   또는 이미 캐시돼 있으면(편집 핸들러의 즉시 drain) findStaleRowParamComboCells 로 판정해 비운다.
  //   필터형은 기존 clearStaleComboCellsHandler(동기)가 담당하므로 여기서는 재조회형만 다룬다.
  const pendingRowParamRevalRef = useRef<Array<{ row: T; changedBinding: string }>>([]);

  // 큐를 소진한다 — 후보가 도착한 하위는 비우거나(무효) 남기고(유효), 아직 미도착이면 다음 도착까지
  //   항목을 유지한다. 값을 비우면 EditTracker 에 기록해 저장/되돌림이 정확하다. refs 만 읽어 안정적이다.
  const drainRowParamReval = useCallback(() => {
    const grid = internalGridRef.current;
    const editTracker = internalEditTrackerRef.current;
    const pending = pendingRowParamRevalRef.current;
    if (!grid || !editTracker || pending.length === 0) return;
    // 편집 중(콤보 드롭다운 열림/셀 편집 진행)에는 미룬다. 여기서 grid.invalidate() 를 부르면
    //   refresh 가 finishEditing 을 불러 편집이 끝났다 다시 시작되는 루프가 되고(신규행에서
    //   드롭다운이 열렸다 닫히는 깜빡임 + 드롭다운 자동열기 취소), 최근 재조회형 하위값 자동비움
    //   경로가 이를 트리거한다. 큐는 유지되고, 편집이 실제로 끝나면 cellEditEnded 가 다시 drain 한다.
    if (grid.activeEditor) return;

    let applied = false;
    const remaining: Array<{ row: T; changedBinding: string }> = [];
    for (const entry of pending) {
      const { stale, awaiting } = findStaleRowParamComboCells(
        layoutAppliedRef.current,
        rowParamRowsRef.current,
        insertRowParamRowsRef.current,
        entry.row as unknown as WijmoRowItem,
        entry.changedBinding
      );
      stale.forEach(({ binding, previousValue }) => {
        editTracker.storeChange(entry.row, binding, previousValue, '');
        (entry.row as WijmoRowItem)[binding] = '';
        applied = true;
      });
      // 아직 후보가 안 온 하위가 남아 있으면 다음 도착까지 이 항목을 유지한다.
      if (awaiting.length > 0) remaining.push(entry);
    }
    pendingRowParamRevalRef.current = remaining;
    if (applied) grid.invalidate();
  }, []);
  // grid 초기화 클로저(핸들러)에서 최신 drain 을 부르기 위한 ref. drain 은 stable 이라 값은 고정이다.
  const drainRowParamRevalRef = useRef(drainRowParamReval);
  drainRowParamRevalRef.current = drainRowParamReval;

  // 재조회 결과(rowParamRows)가 갱신되면 큐를 소진한다 — 부모를 바꿔 나간 조회가 도착하는 시점.
  useEffect(() => {
    drainRowParamReval();
  }, [rowParamRows, insertRowParamRows, drainRowParamReval]);

  // 편집 중이라 적용을 건너뛴 콤보 컬럼 — 편집이 끝나면 다시 적용한다.
  //   건너뛰고 끝내면 그 응답은 영영 반영되지 않는다. 이 이펙트는 dep 이 바뀔 때만 도는데,
  //   방금 도착한 응답이 곧 그 dep 이라 다시 돌 계기가 없기 때문이다. 행 파라미터 콤보
  //   (PARAM10='D')는 셀을 여는 그 동작이 조회를 트리거하므로 "응답이 편집 중에 도착" 이 예외가
  //   아니라 기본 경로다 — 그대로 두면 드롭다운이 빈 채로 굳고 다시 열어도 비어 있다
  //   (2026-09-02 리포트).
  const pendingComboColumnsRef = useRef<Set<string>>(new Set());

  // 마지막으로 적용한 dataMap (binding -> map). updatedLayout 재적용의 판정 기준이자 루프 방지책이다 —
  //   buildLeafColumnDataMap 은 부를 때마다 새 DataMap 을 만들므로, 같은 것을 다시 만들어 대입하면
  //   invalidate -> updatedLayout 이 끝없이 돈다. 캐시한 인스턴스와 참조가 다를 때만 대입한다.
  const appliedDataMapsRef = useRef<Map<string, DataMap | null>>(new Map());

  // ⭐ 콤보 dataMap 적용 (구조와 분리한 데이터 축). 콤보/행-파라미터 결과가 도착하면 각 콤보 컬럼의
  //   dataMap 만 교체한다 — columnGroups 재대입이 없으므로 헤더가 흔들리지 않는다.
  //   구조 재생성(columnGroups 변경) 뒤에는 dataMap 이 초기화되므로 columnGroups 도 dep 에 둬 재적용한다.
  //   편집 중 컬럼은 화면(beginningEdit)이 스왑한 편집 전용 dataMap 을 덮지 않도록 건너뛰되,
  //   위 pending 에 담아 편집 종료 후 반드시 따라잡는다.
  const applyComboDataMaps = useCallback((onlyBindings?: ReadonlySet<string>) => {
    const grid = internalGridRef.current;
    if (!grid) return;
    const editingCol = grid.editRange?.col ?? -1;
    // 편집 중에는 콤보 컬럼을 손대지 않고 전부 미룬다. dataMap 재대입도 grid.invalidate() 도
    //   refresh 를 예약하고 FlexGrid.refresh 는 finishEditing 을 부른다 — 편집 중인 셀에서 이게
    //   일어나면 편집이 끝났다 다시 시작되는 루프(신규행 콤보 드롭다운 깜빡임 + 자동열기 취소)가
    //   된다. 편집 종료 시 flushPendingComboDataMaps(cellEditEnded/pastedCell)가 따라잡는다.
    const isEditing = editingCol >= 0;
    for (const rawColumn of layoutAppliedRef.current) {
      if (
        !rawColumn.display ||
        rawColumn.cellCtrlObjTpCd !== CELL_CONTROL_TYPE.COMBO ||
        !rawColumn.cellCboDataTp
      )
        continue;
      if (onlyBindings && !onlyBindings.has(rawColumn.colNm)) continue;
      const wijmoColumn = grid.getColumn(rawColumn.colNm);
      if (!wijmoColumn) continue;
      if (isEditing || grid.columns.indexOf(wijmoColumn) === editingCol) {
        pendingComboColumnsRef.current.add(rawColumn.colNm);
        continue;
      }
      pendingComboColumnsRef.current.delete(rawColumn.colNm);
      const insertId = insertComboId(rawColumn);
      const dataMap =
        buildLeafColumnDataMap({
          ...rawColumn,
          dataMap: comboQueryMapRef.current[rawColumn.cellCboDataTp],
          insertDataMap: insertId ? comboQueryMapRef.current[insertId] : undefined,
          rowParamRows: rowParamRowsRef.current[rawColumn.colNm],
          insertRowParamRows: insertRowParamRowsRef.current[rawColumn.colNm],
        }) ?? null;
      appliedDataMapsRef.current.set(rawColumn.colNm, dataMap);
      wijmoColumn.dataMap = dataMap;
    }
    if (!isEditing) grid.invalidate();
  }, []);

  useEffect(() => {
    applyComboDataMaps();
  }, [comboMapSignature, rowParamRows, insertRowParamRows, columnGroups, applyComboDataMaps]);

  const handleInitialized = (grid: TFlexGrid<T>) => {
    if (gridRef) gridRef.current = grid;
    internalGridRef.current = grid;
    // 콤보 dataMap 방어적 즉시 적용 — 아래 comboMapSignature 의존 이펙트는 "값이 바뀔 때만" 다시
    //   돈다. remount 시점에 콤보 쿼리가 이미 캐시에서 resolve 돼 있으면(gcTime 8h) mount 이펙트
    //   1회 실행 이후 signature 가 다시 안 바뀌어 재시도 계기가 없다 — 탭 전환으로 그리드가
    //   unmount 후 재생성되는 화면(예: SMS Setup Message/Receiver 탭)에서 이 그리드가 막 만들어진
    //   이 시점에 한 번 더 직접 불러 그 갭을 방어한다. grid 는 방금 생성돼 편집 중인 셀이 없으므로
    //   안전하고, 이미 적용됐으면 grid.invalidate() 만 도는 멱등 호출이다.
    applyComboDataMaps();
    // 위 hiddenColumns 동기화 이펙트가 아직 못 붙었을 수 있는 최초 렌더 대비 — 즉시 한 번 얹는다.
    (grid as TFlexGrid<T> & { _userHiddenColumns?: ReadonlySet<string> })._userHiddenColumns =
      hiddenColumnsRef.current;

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

    /**
     * 재조회·신규행 삽입으로 `itemsSource` 배열 참조가 바뀌어도 사용자가 헤더 클릭으로 건
     * 정렬을 유지한다 (위 필터 캡처/복원과 같은 문제의 정렬판).
     *
     * 필터와 달리 정렬 상태는 grid 밖 별도 객체(FlexGridFilter)가 아니라
     * `grid.collectionView.sortDescriptions` 자체에 있다. wijmo `itemsSource` setter 는 배열
     * 참조가 바뀌면 **`itemsSourceChanged` 를 올리기 전에 이미** CollectionView 를 새 것으로
     * 갈아치우므로, 그 이벤트 핸들러 안에서 캡처하면 이전 정렬은 이미 사라진 뒤라 항상 늦는다.
     * 그래서 캡처를 이벤트 시점이 아니라 "정렬이 바뀔 때마다"(사용자 헤더 클릭) 즉시 해 두고,
     * itemsSourceChanged 에서는 그렇게 상시 보관해 둔 최신 값을 새 CollectionView 에 되돌리기만
     * 한다. 되돌린 뒤에는 새 CollectionView 의 sortDescriptions 로 추적 대상을 옮겨 붙인다
     * (CollectionView 가 교체될 때마다 sortDescriptions 도 새 인스턴스이므로).
     */
    let sortSnapshot: ReturnType<typeof captureGridSort> = null;
    let trackedSortDescriptions: ObservableArray<SortDescription> | null = null;
    let sortTrackingHandler: (() => void) | null = null;
    const trackCurrentSort = () => {
      const sortDescriptions = grid.collectionView?.sortDescriptions;
      if (!sortDescriptions || sortDescriptions === trackedSortDescriptions) return;
      if (trackedSortDescriptions && sortTrackingHandler)
        trackedSortDescriptions.collectionChanged.removeHandler(sortTrackingHandler);
      sortTrackingHandler = () => {
        sortSnapshot = captureGridSort(grid);
      };
      sortDescriptions.collectionChanged.addHandler(sortTrackingHandler);
      trackedSortDescriptions = sortDescriptions;
    };
    trackCurrentSort();
    grid.itemsSourceChanged.addHandler(() => {
      restoreGridSort(grid, sortSnapshot);
      trackCurrentSort();
      // 신규행이 앵커(삽입 위치) 옆에 고정되도록 등록해 둔 pin(pinInsertedRow)을 새
      //   CollectionView 에도 다시 적용한다 — sortConverter 는 CollectionView 소속이라 참조가
      //   바뀔 때마다 재설치해야 한다(pinInsertedRow/installInsertPinConverter 주석 참고).
      //   pin 이 없는 화면에서 불러도 원래 값을 그대로 돌려줄 뿐 영향 없다.
      installInsertPinConverter(grid);
    });

    // wijmo 컬럼필터 팝업의 Clear 버튼은 편집기(체크박스/조건 입력)만 비우고 실제 필터에는
    // 반영하지 않는다(clearEditor 문서: "without applying changes to the filter"). Apply 를
    // 따로 눌러야 하는데 사용자는 Clear 로 바로 풀릴 것을 기대하므로, 편집기가 비워지면
    // (isEditorClear) 그 즉시 apply() 를 호출해 실제 필터에도 반영한다.
    const filterOptions = {
      filterColumns: [''],
      // 값 목록형 필터의 고유값 상한. wijmo 기본값 250 이라 그보다 고유값이 많은 컬럼은
      //   앞에서 250개만 목록에 실리고 나머지는 목록에 없는 값 = 체크 안 된 값 = 숨김이 된다
      //   (SYS0001 Message ID 702건 — 정렬상 LBL 이 250개를 채워 MNU 가 통째로 사라짐).
      editingFilter: (s: FlexGridFilter, e: CellRangeEventArgs) => {
        const column = e.getColumn();
        if (column) s.getColumnFilter(column, true).valueFilter.maxValues = 1_000_000;
      },
      filterChanging: (s: FlexGridFilter) => {
        const editor = s.activeEditor as unknown as { isEditorClear?: boolean } | null;
        if (!editor) return;
        s.activeEditor.buttonClicked.addHandler(() => {
          if (editor.isEditorClear) s.apply();
        });
      },
      // 필터 적용/해제로 행 수가 크게 바뀌면 스크롤 높이를 다시 계산해야 한다.
      //   wijmo 는 apply() 에서 collectionView.filter 만 재대입하고 레이아웃은 예전 행 수 기준으로
      //   남겨, 3행까지 좁혔다가 풀면 뷰포트에 들어가는 만큼(예: 51행)만 보이고 스크롤바가 생기지
      //   않는다(2026-09-11 SYS0001 Message 702건 실측 — 콘솔에서 invalidate() 하면 즉시 복구).
      //   refresh(false) 는 셀만 다시 그려 소용없고 invalidate() 라야 레이아웃까지 재계산한다.
      filterApplied: () => grid.invalidate(),
    };

    if (gridFilterRef) gridFilterRef.current = new FlexGridFilter(grid, filterOptions);
    // 팝업(다이얼로그 스코프)인데 외부 filter ref가 없으면 F4용 filter를 내부 생성.
    else if (scopeId !== null) internalFilterRef.current = new FlexGridFilter(grid, filterOptions);

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

    // 숫자 입력 제한(positiveOnly/integerOnly/decimalPlaces). 정적 컬럼은 numberRules prop, 동적 컬럼은
    //   Wijmo Column 에 그대로 실린 같은 이름의 속성에서 읽는다. 규칙이 없는 컬럼은 아무것도 하지 않는다.
    //   경고창은 띄우지 않는다: 타이핑은 입력 자체를 막고, 붙여넣기/확정은 값을 반영하지 않는 것으로 처리한다.
    const resolveNumberRule = (sender: TFlexGrid<T>, colIndex: number): NumberInputRule | undefined => {
      const column = sender.columns[colIndex];
      if (!column) return undefined;
      const fromProp = column.binding ? numberRulesRef.current?.[column.binding] : undefined;
      const { positiveOnly, integerOnly, decimalPlaces } = column as unknown as NumberInputRule;
      const rule: NumberInputRule = {
        positiveOnly: fromProp?.positiveOnly ?? positiveOnly,
        integerOnly: fromProp?.integerOnly ?? integerOnly,
        decimalPlaces: fromProp?.decimalPlaces ?? decimalPlaces,
      };
      return rule.positiveOnly || rule.integerOnly || rule.decimalPlaces != null ? rule : undefined;
    };
    grid.prepareCellForEdit.addHandler((sender: TFlexGrid<T>, event: CellRangeEventArgs) => {
      const rule = resolveNumberRule(sender, event.col);
      const editor = sender.activeEditor;
      if (!rule || !editor) return;
      editor.addEventListener('beforeinput', (inputEvent: InputEvent) => {
        if (inputEvent.data == null) return;
        const { value, selectionStart, selectionEnd } = editor;
        const next =
          value.slice(0, selectionStart ?? value.length) +
          inputEvent.data +
          value.slice(selectionEnd ?? value.length);
        if (!isTypingAllowed(next, rule)) inputEvent.preventDefault();
      });
    });
    grid.cellEditEnding.addHandler((sender: TFlexGrid<T>, event: CellEditEndingEventArgs) => {
      const rule = resolveNumberRule(sender, event.col);
      const editor = sender.activeEditor;
      if (!rule || !editor || event.cancel) return;
      if (!isValueAllowed(editor.value, rule)) event.cancel = true;
    });
    grid.pastingCell.addHandler((sender: TFlexGrid<T>, event: CellRangeEventArgs) => {
      const rule = resolveNumberRule(sender, event.col);
      if (!rule || typeof event.data !== 'string') return;
      if (!isValueAllowed(event.data, rule)) event.cancel = true;
    });

    // 콤보 컬럼에 붙여넣은 값이 그 행의 드롭다운 후보 밖이면 셀을 비운다 (커밋 전 pastingCell 게이트).
    //   clearStaleComboCellsHandler 는 상위 변경으로 밀려난 하위 셀만 보고 붙여넣은 셀 자신은
    //   findStaleComboCells 가 제외한다("자기 자신은 대상이 아니다") — 그 갭을 여기서 메운다.
    //   판정 기준은 표시(getDisplayValues)와 같아 "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값" 불변식을
    //   붙여넣은 셀에도 적용한다. 표시명·저장 코드 어느 쪽으로 붙여넣어도 유효하면 통과시킨다
    //   (셀 복사는 표시명, 외부 붙여넣기는 코드일 수 있다 — salesCompanyGuard.isCandidate 와 같은 규약).
    //
    //   필수: 후보 판정은 반드시 그 행 후보(getDisplayValues(row))로만 한다. 전역 getKeyValue(pasted)로
    //     코드 유효성을 보면 cascade 로 좁혀진 후보 밖이어도 "전체 목록에 있는 코드"면 통과해 버린다
    //     (SCM_SITE_ID 처럼 PARAM2 로 좁히는 콤보의 실사고 — cascade 4건 밖 사이트 코드가 붙었음).
    //     그래서 코드 검사도 후보 이름들을 코드로 되돌려(getKeyValue(name)) 그 집합 안인지로 판정한다.
    //
    //   재조회형 콤보(PARAM10='D')는 후보가 비동기로 도착한다(미도착 != 후보 0건). 후보가 아직 없으면
    //     여기서 동기 판정하면 정상 입력을 지우므로 건너뛴다(그 판정은 salesCompanyGuard 등 화면 가드가
    //     서버 재조회로 맡는다). 후보가 이미 실렸으면 그 후보로 붙여넣기도 판정한다.
    const clearOutOfListComboOnPaste = (
      sender: TFlexGrid<T>,
      event: CellRangeEventArgs & { data?: unknown; cancel: boolean }
    ) => {
      if (event.cancel) return; // 편집 불가 등으로 이미 막힌 셀은 손대지 않는다
      const binding = sender.columns[event.col]?.binding ?? '';
      if (!binding) return;
      const config = layoutAppliedRef.current.find(column => column.colNm === binding);
      if (!config || config.cellCtrlObjTpCd !== CELL_CONTROL_TYPE.COMBO) return;

      const pasted = safeString(event.data).trim();
      if (pasted === '') return; // 빈 값 붙여넣기는 지움 의도이므로 그대로 둔다

      const wijmoColumn = sender.getColumn(binding);
      const dataMap = wijmoColumn?.dataMap ?? undefined;
      // 목록 밖 값을 허용하는 DataMap(isEditable)은 친 그대로가 입력값이라 건드리지 않는다
      //   (restoreCanonicalComboText 와 같은 예외).
      if (dataMap?.isEditable) return;

      const row = sender.rows[event.row]?.dataItem as WijmoRowItem | undefined;
      // 그 행의 드롭다운 후보 표시명 — 후보 판정의 단일 원천 (salesCompanyGuard.candidateNamesOf 규약).
      const candidateNames = dataMap?.getDisplayValues(row) ?? [];
      // 재조회형은 후보가 아직 안 실렸으면(비동기 미도착) 판정을 미룬다 — 정상 입력 오삭제 방지.
      if (isRowParamCombo(config) && candidateNames.length === 0) return;

      const loweredPasted = pasted.toLowerCase();
      // 입력값이 그 행 후보인가 — 표시명·저장 코드 둘 다 그 후보 집합 안에서만 본다.
      //   코드 검사는 전역 색인(getKeyValue(pasted))이 아니라 후보 이름을 코드로 되돌려(getKeyValue(name))
      //   비교한다. 전역 색인은 cascade 밖 코드를 통과시킨다(위 주석 실사고).
      const isCandidate = candidateNames.some(name => {
        const trimmedName = safeString(name).trim();
        if (trimmedName.toLowerCase() === loweredPasted) return true;
        const codeOfName = dataMap ? safeString(dataMap.getKeyValue(trimmedName)).trim() : '';
        return codeOfName !== '' && codeOfName.toLowerCase() === loweredPasted;
      });
      if (isCandidate) return;

      // 후보 0건(getDataMap 이 undefined → dataMap 없음)이면 자유 입력이 되는 경로 — 그것도 비운다.
      event.data = '';
    };
    grid.pastingCell.addHandler(clearOutOfListComboOnPaste as never);

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

    // 행 파라미터 콤보(PARAM10='D')가 쓸 행 조합을 조회 대상에 올린다.
    //   wijmo 가 dataItem 을 제자리 수정해 itemsSource 참조가 안 바뀌므로 이 등록이 없으면
    //   방금 입력한 값으로는 조회가 영영 안 나가고 드롭다운이 빈 채로 남는다.
    const registerRowParamHandler = (sender: TFlexGrid<T>, event: { row: number; col: number }) => {
      const touchedBinding = sender.columns[event.col]?.binding ?? '';
      if (!touchedBinding) return;
      const row = sender.rows[event.row]?.dataItem as WijmoRowItem | undefined;
      if (!row) return;
      registerTouchedRowRef.current(touchedBinding, row);
    };
    grid.cellEditEnded.addHandler(registerRowParamHandler as never);
    grid.pastedCell.addHandler(registerRowParamHandler as never);

    // 재조회형(PARAM10='D') 상위 콤보를 바꾸면 하위 셀 재검증을 큐에 담는다. findStaleComboCells 는
    //   재조회형을 제외하므로(그 후보는 클라 비교가 아니라 서버 재조회라) 위 clearStaleComboCellsHandler
    //   가 못 비운다 — 이 경로가 그 갭을 메운다. 즉시 drain 은 이미 캐시된 조합을 바로 처리하고,
    //   새 조합은 registerRowParamHandler 가 띄운 조회가 도착할 때 위 이펙트가 처리한다.
    const queueRowParamRevalHandler = (
      sender: TFlexGrid<T>,
      event: { row: number; col: number }
    ) => {
      const changedBinding = sender.columns[event.col]?.binding ?? '';
      if (!changedBinding) return;
      const row = sender.rows[event.row]?.dataItem as T | undefined;
      if (!row) return;
      // 바뀐 셀이 재조회형 하위 콤보의 종속 키가 아니면 대상 없음.
      const hasRowParamDependent = layoutAppliedRef.current.some(
        column =>
          isRowParamCombo(column) &&
          column.colNm !== changedBinding &&
          changedBinding in parseComboFilterBindings(column.attribute2)
      );
      if (!hasRowParamDependent) return;
      // 같은 행·같은 변경 중복 제거 후 추가.
      pendingRowParamRevalRef.current = pendingRowParamRevalRef.current.filter(
        entry => !(entry.row === row && entry.changedBinding === changedBinding)
      );
      pendingRowParamRevalRef.current.push({ row, changedBinding });
      drainRowParamRevalRef.current();
    };
    grid.cellEditEnded.addHandler(queueRowParamRevalHandler as never);
    grid.pastedCell.addHandler(queueRowParamRevalHandler as never);

    // 편집 중이라 미뤄둔 콤보 dataMap 을 따라잡는다 (위 pendingComboColumnsRef 주석).
    //   한 박자 미루는 이유가 둘이다 — 이 시점엔 grid.editRange 가 아직 살아 있어 그대로 부르면
    //   또 건너뛴다. 그리고 화면이 cellEditEnded 에서 편집용 dataMap 을 되돌리는 경우 그 뒤에
    //   적용되어야 한다(화면 핸들러는 mount 후 등록이라 여기보다 나중에 불린다).
    const flushPendingComboDataMaps = () => {
      if (pendingComboColumnsRef.current.size === 0) return;
      const pending = new Set(pendingComboColumnsRef.current);
      globalThis.setTimeout(() => applyComboDataMaps(pending), 0);
    };
    grid.cellEditEnded.addHandler(flushPendingComboDataMaps);
    grid.pastedCell.addHandler(flushPendingComboDataMaps);

    // 편집이 시작되는 시점에도 올린다 — 편집 결과만으로는 못 메우는 경로가 있다.
    //   GridAction.addRow 는 source.splice 로 행을 끼워 넣을 뿐 React state 를 안 건드려
    //   렌더가 아예 안 난다. 그래서 신규행 조합은 렌더 시점에 읽는 itemsSource 에 안 잡히고,
    //   회사 코드를 안 채운 채 Sales Plant 를 열면 그 조합이 슬롯에 없어 드롭다운이 빈 채로 뜬다.
    //   여기서 올리면 조회가 돌아올 때 렌더가 나며 채워진다(첫 진입은 한 박자 늦을 수 있다).
    //   재렌더 폭주가 없는 근거: 이미 등록된 조합이면 훅이 prev 를 그대로 돌려준다.
    const registerRowParamOnEditHandler = (sender: TFlexGrid<T>, event: CellRangeEventArgs) => {
      // 공통 편집 가능 판정(setEditableColumns)이 이미 막은 셀이면 관여하지 않는다.
      if (event.cancel) return;
      registerRowParamHandler(sender, event);
    };

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

    grid.formatItem.addHandler((_sender, e) => formatEditableColumns(grid, e, useCheckbox));
    grid.formatItem.addHandler(formatSortableColumns);
    // setCellTooltip(아래, 조건부 등록) 보다 반드시 먼저 걸어야 한다 — 그쪽이 event.cell.textContent
    //   를 그대로 읽어 title 로 쓰므로, 뒤에 걸면 셀 텍스트는 비워지는데 툴팁엔 원본 코드가 남는다.
    grid.formatItem.addHandler((_sender, e) =>
      formatPendingComboColumns(grid, e, pendingComboBindingsRef)
    );
    // 텍스트 셀(FPText/FPTextBox)로 내려온 숫자 원본값의 천단위 콤마 제거 — 표시만 교정.
    //   setCellTooltip 보다 먼저 등록해야 툴팁도 콤마 없는 텍스트를 읽는다.
    grid.formatItem.addHandler((_sender, e) => formatTextTypeColumns(grid, e));

    // 포커스 행 표시(No 컬럼) 갱신 - selection 만 바뀌면 RowHeader 셀의 바인딩 데이터는
    //   안 바뀌므로 Wijmo 가 formatItem 을 자동 재호출하지 않는다. refresh(false) 로 강제
    //   재도색해 formatItem 을 다시 태운다. invalidate() 는 레이아웃까지 재계산해 여기엔
    //   과함(행 높이/컬럼폭 변화가 없으므로) - refresh(false) 가 더 가볍고 즉시 반영된다.
    grid.selectionChanged.addHandler(sender => sender.refresh(false));

    setEditableColumns(grid);
    // 위 setEditableColumns 뒤에 걸어야 한다 — wijmo Event 는 등록 순서대로 부르므로 앞에 걸면
    //   편집 가능 판정이 event.cancel 을 세우기 전에 돌아 그 가드가 무의미해진다.
    grid.beginningEdit.addHandler(registerRowParamOnEditHandler as never);

    // 셀에 포커스가 닿는 시점에 미리 올린다 — 편집 진입 전에 조회를 걸어 드롭다운이 첫 열림부터
    //   차 있게 한다. beginningEdit 만 있으면 조회가 편집 시작과 동시에 나가 첫 열림이 빈다.
    //   클릭과 화살표 이동 양쪽에서 뜨고, 이미 등록된 조합이면 훅이 prev 를 그대로 돌려주므로
    //   셀을 옮겨 다녀도 새 조합에서만 렌더가 난다.
    grid.selectionChanged.addHandler(registerRowParamHandler as never);
    setMoveCellByTab(grid);
    if (sortingEnabled) setSortableColumnHeaderClick(grid);
    setMoveByMetakey(grid, staticColumns.length);
    setHandleUppercase(grid);

    if (useSummaryTooltip) setSummaryTooltip(grid);
    if (useCellTooptip) setCellTooltip(grid);
    if (useAggregationRow) setAggregationRow(grid, aggregationRowPlacement);
    if (useCheckbox) {
      setCheckbox(grid);
      // wijmo Selector 부착이 selectionMode 를 Cell 로 강제해 Ctrl+클릭/드래그 범위 선택이
      //   막힌다 — 체크박스 개별 클릭 선택은 그대로 둔 채 범위 선택만 복원한다. useCheckbox
      //   그리드 전부(호출부마다 반복 안 해도) 여기 한 곳에서 자동 적용.
      grid.selectionMode = SelectionMode.MultiRange;
    }
    if (useResultColumns) setResultColumn(grid);

    if (!gridProps.isReadOnly) grid.rowHeaders.columns.push(new Column({ align: 'center' }));
    grid.rowHeaders.columns[0].width = initialIndexRowHeaderWidth;
    /**
     * TODO: wijmo 객체와 hostElement의 렌더링 시점 차이로 인해 hostElement 등에 핸들러를 추가하는 경우 다음과 같이 ref로 적용하였음.
     * keyboard event, mouse event 등은 다음과 같이 새로 추가하여 ref로 관리하는 방식 사용 필요 - 강민재
     */
    grid.hostElement.addEventListener('dblclick', e => dblClickRef.current?.(e));
    grid.hostElement.addEventListener('click', e => clickRef.current?.(e));

    // 셀 선택 상태(편집기 없음)의 붙여넣기. wijmo 는 Ctrl+V 를 Clipboard.paste 로 처리하는데
    //   그 구현이 숨은 textarea + document.execCommand('paste') 라 Chromium 이 차단한다
    //   (페이지가 임의로 클립보드를 읽는 것을 막는다. copy 는 허용돼 Ctrl+C 는 정상).
    //   그래서 더블클릭으로 편집기를 연 뒤에는(네이티브 input) 되고 선택만 한 상태에서는 안 됐다.
    //
    //   필수: wijmo 의 Ctrl+V 처리를 **캡처 단계에서 먼저 끊는다**. 그대로 두면 wijmo 가 keydown
    //   시점에 그리드 **바깥**(hostElement 조상)에 임시 textarea 를 만들어 포커스를 옮기고, 브라우저는
    //   paste 를 그 textarea 로 보낸다 - 아래 리스너까지 오지 않는다(2026-09-07 실측:
    //   paste target = TEXTAREA[wj-clipboard], 그리드 밖). 끊어 두면 포커스가 그리드에 남아
    //   paste 가 hostElement 로 온다.
    //   편집 중에는 끊지 않는다 - 그때는 편집기(input)가 네이티브로 받아야 하고, 캡처 단계에서
    //   막으면 그 input 까지 이벤트가 못 간다.
    grid.hostElement.addEventListener(
      'keydown',
      event => {
        const isPasteKey = event.code === 'KeyV' || event.key === 'v' || event.key === 'V';
        if (!isPasteKey || !(event.ctrlKey || event.metaKey) || event.altKey) return;
        if (grid.isReadOnly || grid.activeEditor) return;
        event.stopImmediatePropagation();
      },
      true
    );

    //   paste 이벤트는 사용자 제스처로 오는 신뢰된 이벤트라 clipboardData 를 바로 읽을 수 있다.
    grid.hostElement.addEventListener('paste', event => {
      // 편집 중이면 네이티브 붙여넣기가 편집기에 직접 들어간다 - 건드리지 않는다.
      if (grid.isReadOnly || grid.activeEditor) return;
      const text = event.clipboardData?.getData('text/plain');
      if (!text) return;
      event.preventDefault();

      // 병합 셀은 좌상단 좌표에만 쓸 수 있다 - wijmo setClipString 의 셀 루프가
      //   `getMergedRange` 로 좌상단이 아닌 좌표를 **조용히 건너뛴다**. 화면에는 병합 블록이 한 칸으로
      //   보이므로 사용자가 그 안 어느 행을 눌렀는지는 알 수 없다 - 좌상단으로 보정해서 넘긴다
      //   (2026-09-07 실측: 병합 0,4~2,4 인데 선택이 1,4 라 붙여넣기가 무동작이었다).
      const selection = grid.selection;
      const merged = grid.getMergedRange(grid.cells, selection.row, selection.col, false);
      const target =
        merged && (merged.topRow !== selection.row || merged.leftCol !== selection.col)
          ? new CellRange(merged.topRow, merged.leftCol)
          : undefined;
      grid.setClipString(text, target);
    });

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
    // 헤더 다중 선택(MultiRange) 상태에서 컬럼 하나를 리사이즈하면 선택된 다른 컬럼들도
    //   같은 비율로 함께 줄어들게 한다 (기본은 드래그한 컬럼 하나만 바뀜).
    setMultiColumnResize(grid, userColumnWidthsRef);

    // ⭐ 다단 헤더 행 높이 — columnGroups 재적용으로 헤더 row 높이가 리셋되므로
    //   updatedLayout(매 layout refresh 후)에 재적용. 미지정(undefined) 화면은 무영향(회귀 0).
    //   guard: 이미 목표 높이면 skip → 무한 루프 방지.
    grid.updatedLayout.addHandler(() => {
      ensureTopLeftMergeManager(grid);

      // columnGroups 재대입으로 끊어진 필터-컬럼 연결 복구 (rebindFilterColumns 주석 참고).
      //   끊어진 필터가 있을 때만 동작하므로 매 레이아웃 갱신마다 불러도 안전하다.
      rebindFilterColumns(grid, getGridFilter());

      // columnGroups 재대입으로 지워진 콤보 dataMap 을 되돌린다 (폭·필터 복원과 같은 이유).
      //   wijmo 의 `set columnGroups` 는 Column 을 통째로 재생성하므로 붙여둔 dataMap 이 사라진다.
      //   적용 이펙트는 구조 변경 1회당 1회만 도는데, 그 1회가 재생성보다 먼저 끝나면 되돌릴 기회가
      //   없어 콤보 컬럼이 통째로 텍스트로 떨어진다 (2026-09-02 행추가 리포트 — 행추가 렌더에서
      //   staticColumns 참조가 바뀌는 화면이 그 경우다).
      //   guard: 캐시한 인스턴스와 같으면 skip → updatedLayout 무한 루프 방지.
      appliedDataMapsRef.current.forEach((dataMap, binding) => {
        const column = grid.getColumn(binding);
        if (!column || column.dataMap === dataMap) return;
        // 화면이 커스텀 dataMap 을 얹은 컬럼(예: DMF0006 Team = buildTeamDataMap)은 건드리지 않는다.
        //   이 복구는 columnGroups 재대입으로 dataMap 이 **지워진(null)** 경우만 되돌리는 안전망이다.
        //   현재 dataMap 이 다른 유효 맵이면 화면 override 이므로 덮으면 서로 되돌리며 무한 refresh
        //   루프가 된다(refresh→finishEditing 매 프레임 → 신규행 콤보 드롭다운이 열렸다 닫힘).
        if (column.dataMap) return;
        // 편집 중 컬럼은 화면이 스왑한 편집 전용 dataMap 을 덮지 않는다 — 편집 종료 후 따라잡는다.
        if (grid.columns.indexOf(column) === (grid.editRange?.col ?? -1)) {
          pendingComboColumnsRef.current.add(binding);
          return;
        }
        column.dataMap = dataMap;
      });

      // columnGroups 재대입으로 되돌아간 폭을 사용자가 조정한 값으로 복원.
      //   guard: 이미 목표 폭이면 skip → updatedLayout 무한 루프 방지.
      userColumnWidthsRef.current.forEach((width, binding) => {
        const column = grid.getColumn(binding);
        if (column && column.width !== width) column.width = width;
      });

      // columnGroups 재대입으로 되돌아간 F3(GridAction.toggleColumnSort) allowSorting 을 복원.
      //   재대입은 Column 을 통째로 재생성해 메타 기본값(대개 false)으로 돌아간다 — 방치하면
      //   방금 F3 로 켠 정렬 스위치가 조용히 꺼져 재클릭이 씹히고, 동적(주차) 컬럼처럼 재대입이
      //   잦은 화면에서 정렬 화살표가 마지막 방향에 멈춘 것처럼 보인다(사용자 보고 2026-09-04).
      const sortState = grid as unknown as {
        _userSortEnabledBindings?: Set<string>;
        _userSortIconPendingBindings?: Set<string>;
      };
      sortState._userSortEnabledBindings?.forEach(binding => {
        const column = grid.getColumn(binding);
        if (column && !column.allowSorting) column.allowSorting = true;
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
        columnGroups={columnGroups}
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
