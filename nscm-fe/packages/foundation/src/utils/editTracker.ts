import { isUndefined, toggleClass } from '@mescius/wijmo';
import { CellType } from '@mescius/wijmo.grid';
import type { CellRangeEventArgs, FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';

import { CRUD_TYPE } from '@foundation/constants';

type TrackedValue = WijmoPrimitive | undefined;

/** "값이 비어 있다" 의 모든 표현 — 셀을 오가는 값의 타입은 아래처럼 제각각이다. */
const isBlank = (value: TrackedValue): boolean =>
  value === null || value === undefined || value === '';

/**
 * 원본값 == 현재값 판정. `===` 만으로 비교하면 **원래 값으로 되돌려도 수정상태(M)가 안 풀린다**.
 * Wijmo 가 셀에 써 넣는 값의 타입이 편집 시점의 셀 상태에 따라 갈리기 때문이다.
 *
 * ① 빈 값 표현이 섞인다 — SP 결과 `null` / 응답에 아예 없던 컬럼 `undefined` /
 *    Delete 키 `null` / 빈 문자열 커밋 `''`. 셋 다 화면상 "빈 칸" 인데 `===` 는 전부 다른 값이다.
 * ② 숫자 컬럼이라도 **편집 직전 셀이 비어 있으면** Wijmo 가 컬럼 dataType 을 확정하지 못해
 *    (`GridPanel.setCellData`: `dataType || getType(현재값)` → `getType(null)`=Object)
 *    입력 문자열을 변환 없이 그대로 저장한다 → 원본 `61386`(number) vs 입력 `'61386'`(string).
 *    ※ dataType 자체가 첫 행 값으로 추론되므로(`FlexGrid._updateColumnTypes` → `items[0]`),
 *      첫 행이 빈 동적(주차/월) 컬럼은 이 경로를 항상 탄다.
 *
 * 숫자↔문자열은 **문자열이 그 숫자의 표준 표기일 때만** 같다고 본다.
 * `'0100'` vs `100`, `'1,830'` vs `1830` 처럼 표기가 다르면 실제 변경일 수 있어 그대로 남긴다.
 */
const isSameValue = (a: TrackedValue, b: TrackedValue): boolean => {
  if (a === b) return true;
  // 빈값(널/undefined/'')과 숫자 0 은 같은 "빈 셀" 로 본다. 수량 그리드의 분배·Delete 로직은
  //   셀을 되돌릴 때 숫자 0 을 써 넣는데(예: DMF0082 divideBy*/allocateLoc), 원본이 빈칸이면
  //   `isBlank vs 0` 이 서로 달라 원래 값으로 돌려도 수정(M)이 안 풀렸다(사용자 신고 2026-09-03).
  //   ※ 문자열 '0' 은 제외 — 사용자가 명시 입력한 표기이므로 빈칸과 구분한다(fillEmptyCellWithZero 규약).
  if (isBlank(a) && b === 0) return true;
  if (a === 0 && isBlank(b)) return true;
  if (isBlank(a) || isBlank(b)) return isBlank(a) && isBlank(b);
  if (a instanceof Date && b instanceof Date) return a.getTime() === b.getTime();
  const isCanonicalNumber = (num: number, text: string): boolean => String(num) === text.trim();
  if (typeof a === 'number' && typeof b === 'string') return isCanonicalNumber(a, b);
  if (typeof a === 'string' && typeof b === 'number') return isCanonicalNumber(b, a);
  return false;
};

// TODO: binding 속성 fallback 고려..? - binding 속성 없는 column 없을듯 - 강민재
export class EditTracker<T extends WijmoRowItem = WijmoRowItem> {
  private readonly _grid: FlexGrid<T>;
  private readonly _originalValues: Map<T, Record<string, WijmoPrimitive>>;
  private _originalValue: WijmoPrimitive;

  private _cellChanging(sender: FlexGrid<T>, event: CellRangeEventArgs) {
    this._originalValue = sender.getCellData(event.row, event.col, false) as WijmoPrimitive;
  }

  private _cellChanged(sender: FlexGrid<T>, event: CellRangeEventArgs) {
    const newValue = sender.getCellData(event.row, event.col, false) as WijmoPrimitive;
    const dataItem = event.getRow().dataItem as T;

    this.storeChange(dataItem, event.getColumn().binding ?? '', this._originalValue, newValue);
  }

  storeChange(item: T, binding: string, originalValue: WijmoPrimitive, newValue: WijmoPrimitive) {
    let editItem = this._originalValues.get(item);
    if (!editItem) {
      editItem = {};
      this._originalValues.set(item, editItem);
    }

    // 이미 기록된 원본이 있으면 그것이 기준. `editItem[binding] === undefined` 로 판정하면
    // **원본이 undefined 인 셀**(응답에 없던 동적 컬럼 등)이 매번 "기록 없음" 으로 오인돼
    // 편집 직전 값(=사용자가 방금 넣은 값)을 원본으로 덮어쓴다 → 되돌려도 영영 M 으로 남는다.
    const hasOriginal = binding in editItem;
    const actualOriginalValue = hasOriginal ? editItem[binding] : originalValue;

    if (isSameValue(actualOriginalValue, newValue)) {
      delete editItem[binding];
      if (Object.keys(editItem).length === 0) this._originalValues.delete(item);
    } else if (!hasOriginal) {
      editItem[binding] = originalValue;
    }

    if (item.CRUD_TYPE !== CRUD_TYPE.INSERT && item.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      const hasChanges = this._originalValues.has(item);
      item.CRUD_TYPE = hasChanges ? CRUD_TYPE.MODIFY : undefined;
      this._grid.invalidate();
    }
  }

  private _hasChange(item: T, binding: string): boolean {
    const editItem = this._originalValues.get(item);
    if (item.CRUD_TYPE === CRUD_TYPE.INSERT) return true;
    if (editItem === null) return true;
    if (editItem && binding in editItem && editItem[binding] === undefined) return true;
    return editItem !== undefined && !isUndefined(editItem[binding]);
  }

  constructor(grid: FlexGrid<T>) {
    this._grid = grid;
    this._originalValues = new Map();
    this._originalValue = null;
    const cellChanging = this._cellChanging.bind(this);
    const cellChanged = this._cellChanged.bind(this);

    grid.beginningEdit.addHandler(cellChanging);
    grid.pastingCell.addHandler(cellChanging);

    grid.cellEditEnded.addHandler(cellChanged);
    grid.pastedCell.addHandler(cellChanged);

    grid.formatItem.addHandler((sender: FlexGrid, event: FormatItemEventArgs) => {
      if (event.panel.cellType === CellType.Cell) {
        const changed = this._hasChange(
          event.getRow().dataItem as T,
          event.getColumn().binding ?? ''
        );
        toggleClass(event.cell, 'cell-changed', changed);
      }
    });
  }

  clearChanges(): void {
    this._originalValues.clear();
    this._grid.invalidate();
  }

  /** 셀 단위 수정(M) 기록 존재 여부. 신규(I)/삭제(D) 는 GridUtils.isDirty 가 CRUD_TYPE 로 판정한다. */
  hasChanges(): boolean {
    return this._originalValues.size > 0;
  }

  getOriginalValues(): Map<T, Record<string, WijmoPrimitive>> {
    return this._originalValues;
  }
}

/**
 * 편집 종료 시 비어 있는 수치셀을 '0' 으로 채운다 (AS-IS spdMain_Changed L1295~1302 파리티).
 * 빈 셀에 Delete/공백 커밋이 들어와도 저장 payload 가 빈 문자열이 아닌 '0' 을 보내게 하는 규약.
 *
 * 주의: 이 함수는 EditTracker 의 cellEditEnded 핸들러 **뒤에** 실행된다 — 공용 DataGrid 가
 *   그리드 생성(initialized) 시점에 EditTracker 를 먼저 걸고, 화면 핸들러는 mount 후
 *   useEffect 에서 등록되기 때문이다(Wijmo Event 는 등록 순서대로 호출).
 *
 * 그래서 원본 기록 유무로 갈라야 한다.
 *   - 기록 없음 = 현재 값이 곧 원본(= 원래 빈 셀). 여기서 storeChange 를 부르면 원본 ''(빈값) ·
 *     새 값 '0' 을 넘기게 되는데 둘은 같은 값이 아니므로(빈값 vs 숫자 — '0100' 오탐 방지 규칙),
 *     EditTracker 가 방금 푼 수정상태(M)가 **다시 켜진다**. 값만 채우고 추적하지 않는다.
 *   - 기록 있음 = 원래 값이 있던 셀. '0' 을 새 값으로 넘겨 재판정한다 (원본이 0 이었으면 해제).
 */
export const fillEmptyCellWithZero = <T extends WijmoRowItem = WijmoRowItem>(
  row: T,
  binding: string,
  tracker: EditTracker<T> | undefined
): void => {
  const originals = tracker?.getOriginalValues().get(row);
  if (originals && binding in originals) {
    tracker?.storeChange(row, binding, originals[binding], '0');
  }
  (row as WijmoRowItem)[binding] = '0';
};

/**
 * 편집 종료 시 음수가 들어온 수치셀을 '0' 으로 보정한다 (AS-IS Dsdm_Changed L1186~1193 파리티:
 *   CONVERT_QTY_PACK/MODULE/CELL 에 음수 입력 시 SetText(..., "0")). 입력 자체는 막지 않고
 *   커밋 시점에 교정하는 것이 AS-IS 동작이다 (positiveOnly 규칙의 '거부' 와 다르다).
 *
 * fillEmptyCellWithZero 와 같은 이유로 EditTracker 의 cellEditEnded **뒤에** 실행되며,
 *   원본 기록 유무로 갈라 수정상태(M) 재판정을 바르게 유지한다.
 *   - 기록 없음 = 현재 값이 원본. 음수 원본을 '0' 으로 추적하면 거짓 M 이 켜지므로 값만 바꾼다.
 *   - 기록 있음 = '0' 을 새 값으로 넘겨 재판정한다 (원본이 0 이었으면 해제).
 *
 * 값이 음수가 아니면(빈칸·0·양수·숫자 아님) 아무 동작도 하지 않는다.
 */
export const clampNegativeCellToZero = <T extends WijmoRowItem = WijmoRowItem>(
  row: T,
  binding: string,
  tracker: EditTracker<T> | undefined
): void => {
  const current = (row as WijmoRowItem)[binding];
  if (isBlank(current as TrackedValue)) return;
  if (Number(current) >= 0) return; // NaN(숫자 아님) 포함 — 음수일 때만 보정한다

  const originals = tracker?.getOriginalValues().get(row);
  if (originals && binding in originals) {
    tracker?.storeChange(row, binding, originals[binding], '0');
  }
  (row as WijmoRowItem)[binding] = '0';
};

/**
 * 상위 콤보 변경 등으로 하위 셀을 ''(빈값)으로 비우면서 수정상태(M)를 정확히 갱신한다
 *   (DataGrid clearStaleComboCellsHandler 와 같은 규약 — 화면 cascade 에서 재사용).
 *
 * 이미 빈 셀은 건드리지 않는다(불필요한 storeChange 로 거짓 M 이 켜지는 것 방지).
 *   - 기록 없음 = 현재 값이 원본. '' 를 새 값으로 넘겨 재판정한다(원본이 빈칸이면 가드로 이미 반환).
 *   - 기록 있음 = 기록된 원본 기준으로 재판정한다(원본이 '' 였으면 M 해제).
 */
export const clearCellValue = <T extends WijmoRowItem = WijmoRowItem>(
  row: T,
  binding: string,
  tracker: EditTracker<T> | undefined
): void => {
  const current = (row as WijmoRowItem)[binding];
  if (isBlank(current as TrackedValue)) return; // 이미 비어 있으면 변경 없음

  const originals = tracker?.getOriginalValues().get(row);
  const originalValue = originals && binding in originals ? originals[binding] : current;
  tracker?.storeChange(row, binding, originalValue, '');
  (row as WijmoRowItem)[binding] = '';
};
