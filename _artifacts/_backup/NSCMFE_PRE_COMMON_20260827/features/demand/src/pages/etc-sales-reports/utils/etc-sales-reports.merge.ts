import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { measureCntOf } from '../etc-sales-reports.constants';

// ⭐ DMF0049 — sales-reports(DMF0044).merge.ts 이식 (M_ 단일 축 — **1단 헤더**).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan (헤더 행 2개 이상일 때만 의미).
//
//   ③ 편집 진입한 세트만 광역 블록에서 떼어낸다 (`activeSetKey`) — AS-IS spdMain_CellClick 파리티.
//     조회 직후에는 종전대로 값 기준 광역 병합이고, **더블클릭(= 편집 진입)** 한 세트 하나만 갈라진다.
//     사용자 확정 2026-08-21: "merge 는 원래대로, 쪼개지는 건 더블클릭해서 포커싱 상태일 때".
//
//   왜 갈라야 하는가 — 갈라 보이는 것 자체가 목적이 아니라 **쓰기 범위**가 목적이다.
//     wijmo 의 편집 커밋은 병합 블록 전 행에 값을 쓴다
//     (`_EditHandler.finishEditing`: `for (r = rng.topRow; r <= rng.bottomRow) setCellData(r, c, v)`).
//     그 `rng` 은 `startEditing` 이 **beginningEdit 보다 먼저** `getMergedRange(…, clip=false)` 로 잡고,
//     `CellRangeEventArgs.range` 게터는 clone 을 주므로 핸들러에서 줄일 수 없다.
//     ⇒ 편집이 시작되기 **전에** 병합이 세트로 갈라져 있어야 쓰기가 세트 안에 머문다.
//     안 그러면 Department 한 칸을 고쳤을 때 다른 세트까지 바뀌고, EditTracker 는 `event.row`
//     (= 블록 맨 윗행) 하나만 변경 기록하므로(`packages/foundation/src/utils/editTracker.ts:48~53`)
//     나머지 세트는 화면·메모리만 바뀐 채 저장에서 빠진다 — 화면과 DB 가 갈린다.
//     세트 범위는 AS-IS 와 같다 — `spdMain_CellClick`(`.cs:1503~1527`) 이 클릭 시 span 을 세트로 다시 잡고,
//     그 범위는 `GetMeasureCntBy40`(`.cs:1564~1600`) 의 **연속된 같은 DATA_SEQ**(신규행은 삽입 세트)다.
//     세트키의 원천은 저장부와 **같은 맵 하나**다(`EtcSalesReports.tsx` 가 만들어 양쪽에 넘긴다).
//
//   금지: 병합을 **선택(selectionChanged)** 에 의존시키지 말 것 (2026-08-21 회귀 정정).
//     wijmo 는 이미 선택된 셀을 다시 클릭해도 선택 이벤트를 내므로 "포커스만 옮겼는데 병합이 깨진다"가
//     된다. 진입 트리거는 **더블클릭(mousedown detail>=2)** 과 편집 시작 키 입력뿐이다.
//   금지: 편집 **중**에 invalidate 하지 말 것 — invalidate 는 10ms 뒤 refresh 를 예약하고
//     FlexGrid.refresh 는 finishEditing 을 불러 편집기·콤보 드롭다운을 닫는다
//     (`packages/foundation/src/utils/mergeManager.ts:65~74`, 커밋 0a76c94).
//     분리는 편집 **직전**에 동기 `refresh(false)` 로, 복원은 편집 **종료 후**(cellEditEnded) invalidate 로 한다.
//     세부 등록·해제는 `components/EtcSalesReportsGrid.tsx` 의 openSetForEdit / closeActiveSet 참조.
//   주의: 2026-08-11 — 연도 가로 머지 제거 (DMF0044 2026-08-10 선례 이식). AS-IS
//     `DMF0049_Sales_ETC_Reports.cs:265` 가 `iColumnHeaderRowCount = 1` 을 넘기므로 헤더는 1단이고,
//     동적 컬럼은 `2025-01` 처럼 **월 라벨 하나**로 나온다(연도 상위 span 없음). 종전 2단 구성은
//     SP 라벨(LARGE=SMALL=COLUMN_LABEL='2025-01') 때문에 '2025-01' 그룹 아래 '2025-01' 1개짜리가
//     12개 생기는 오구성이었다.

type Rec = Record<string, unknown>;

/** 행 → 세트키. 병합(보이는 범위)과 저장(쓰이는 범위)이 갈리지 않도록 **한 맵을 둘이 공유**한다. */
export type SetKeyMap = ReadonlyMap<Rec, string>;

/** 세트키 조각 — SP 값은 문자/숫자로 온다. 그 외 타입은 "키 없음"으로 본다. */
const keyText = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

/**
 * 행이 속한 group(세트) 키 — AS-IS Row Span 단위 = 저장 target 단위.
 *
 * AS-IS `GetMeasureCntBy40`(`.cs:1564~1600`) 이 세트를 잡는 순서를 그대로 따른다.
 *   1. 신규(Insert) 행 — 자기 삽입 세트(`INSERT_GROUP_ID`) 안에서만 한 세트.
 *      AS-IS 도 InsertRow 끝에서 삽입한 행 범위만 span 한다. 값만 비교하면 신규행의 빈 값이
 *      인접 기존행과 우연히 일치해 셀이 붙어버려 행 경계·삭제 대상이 뭉개진다.
 *   2. 조회 행 — `DATA_SEQ`([C20210506-000051] "조회된 데이터는 data_seq 를 이용").
 *      DMF0049 는 SHEET_COLUMNS 에 DATA_SEQ 가 `VISIBLE_FLAG='N'` 로 등록돼 있어
 *      **행 데이터에는 있고 화면 컬럼에는 없다** — 그래서 좌측 컬럼 값 비교만으로는 세트를 못 가른다.
 *   3. 둘 다 없을 때 — division 별 세트 크기(40=3/81=2/82=1) 단위 인접 그룹.
 */
export const setKeyOf = (row: Rec, idx: number, divisionId: string): string => {
  const gid = keyText(row.INSERT_GROUP_ID);
  if (gid) return `I:${gid}`;
  const seq = keyText(row.DATA_SEQ);
  if (seq) return `S:${seq}`;
  const cnt = Math.max(1, measureCntOf(divisionId));
  return `P:${Math.floor(idx / cnt)}`;
};

/** 화면 행 배열(= `[...insertedRows, ...spRows]`) 전체의 세트키 맵. */
export const buildSetKeyMap = (rows: readonly Rec[], divisionId: string): SetKeyMap => {
  const map = new Map<Rec, string>();
  rows.forEach((row, idx) => map.set(row, setKeyOf(row, idx, divisionId)));
  return map;
};

/**
 * 신규 세트를 끼워 넣을 위치 — 포커스 행이 속한 **세트의 첫 행** 인덱스.
 *
 * AS-IS InsertRow 파리티(`.cs:890~892`): `GetCellNumbersByRow(ActiveRowIndex, cnt)` 로 활성 행이
 * 속한 세트의 행 번호를 구해 `SetActiveCell(iArray[0], cnt)` 로 **세트 첫 행**으로 옮긴 뒤
 * `Insert(cnt)` 한다 — 포커스한 줄 한가운데를 쪼개지 않고 그 세트 바로 위에 붙는다.
 *
 * 포커스가 없거나 화면 목록에서 못 찾으면 0(맨 위) — 종전 동작.
 */
export const setHeadIndexOf = (
  rows: readonly Rec[],
  focused: Rec | undefined,
  setKeys: SetKeyMap | undefined
): number => {
  if (!focused) return 0;
  const idx = rows.indexOf(focused);
  if (idx < 0) return 0;
  const key = setKeys?.get(focused);
  if (!key) return idx; // 세트키를 모르면 그 행 위에 그대로 넣는다
  let head = idx;
  while (head > 0 && setKeys?.get(rows[head - 1]) === key) head--;
  return head;
};

/** 그룹 판정 입력 — 화면 표시 순서 그대로의 컬럼 정보(`grid.columns` 를 인덱스 루프로 복사한 것). */
export interface GroupKeyColumn {
  binding: string;
  visible: boolean;
}

/** 동적(월) 컬럼 `M_yyyymm` — 값이 세로로 다 다르므로 그룹 키가 될 수 없다. */
const isDynamicBinding = (binding: string): boolean => /^M_\d{6}$/.test(binding);

/**
 * 머지 블록을 가르는 키 컬럼 — 표시 순서 0번부터 **클릭한 컬럼까지**의 정적 컬럼.
 *
 * 근거: EtcSalesReportsMergeManager 의 좌측 계층 병합은 컬럼 c 의 범위를 `fixedBindings.slice(0, idx + 1)` 값이
 *   모두 같은 연속 행으로 잡는다(`canMergeRows` 의 leftBindings). 즉 **누른 병합 셀이 덮는 범위**가
 *   곧 신규행을 올려 보낼 범위다 — Department 셀을 누르면 그 아래 여러 세트를, Model 셀을 누르면
 *   그 안의 세트만 덮는다.
 *
 * 필수: 기준을 컬럼 **인덱스**로 받는다(binding 문자열 역탐색 금지). `grid.selection.col` 이 곧
 *   `grid.columns` 의 인덱스이므로 그대로 넘기면 어긋날 여지가 없다.
 *
 * 클릭 컬럼이 병합 축이 못 되면(MEASURE 자신 · 동적 월 컬럼 · 비표시 · 범위 밖) MEASURE 직전까지로
 * 폴백한다 = 정적 값이 모두 같고 measure 만 다른 블록(= 한 레코드의 세트).
 *
 * 주의: 비표시 컬럼은 키에서 뺀다 — 화면에 없는 컬럼은 병합에도 참여하지 않는다.
 */
export const groupKeyBindings = (
  columnsInOrder: readonly GroupKeyColumn[],
  clickedIndex: number
): string[] => {
  const usable = (column: GroupKeyColumn | undefined): boolean =>
    !!column && column.visible && !!column.binding && !isDynamicBinding(column.binding);

  const clicked = columnsInOrder[clickedIndex];
  let end: number;
  if (usable(clicked) && clicked?.binding !== 'MEASURE') {
    end = clickedIndex + 1;
  } else {
    const measureIndex = columnsInOrder.findIndex(column => column.binding === 'MEASURE');
    end = measureIndex < 0 ? columnsInOrder.length : measureIndex;
  }

  const keys: string[] = [];
  for (let i = 0; i < end && i < columnsInOrder.length; i++) {
    const column = columnsInOrder[i];
    if (usable(column)) keys.push(column.binding);
  }
  return keys;
};

/**
 * 선택한 셀이 속한 머지 블록의 **첫 행** 인덱스 — Insert 앵커.
 *
 * 값 비교는 `canMergeRows` 와 **같은 규칙**(`?? ''`)을 쓴다. 갈리면 "붙어 보이는데 그룹은 아니다"
 * 가 되어 신규행이 블록 한가운데 끼어든다.
 *
 * 위로 훑다가 멈추는 조건 두 가지:
 *   1. 키 컬럼 값이 하나라도 다르면 = 다른 그룹.
 *   2. 신규행(CRUD_TYPE='I')이면 = 병합이 이미 끊기는 자리다(`canMergeRows` 가 신규↔기존을 막는다).
 *      앞서 추가한 신규 세트 위로 타고 올라가면 누른 순서가 뒤집힌다.
 *
 * 키를 못 구했거나 신규행에서 눌렀으면 `index` 를 그대로 돌려준다(= 포커스 행 자리).
 */
export const findGroupTopIndex = (
  rows: readonly (Rec | undefined)[],
  index: number,
  keyBindings: readonly string[]
): number => {
  const target = rows[index];
  if (!target || keyBindings.length === 0 || target.CRUD_TYPE === 'I') return index;
  const cell = (row: Rec, binding: string): string =>
    (row as Record<string, string>)[binding] ?? '';
  const isSameGroup = (row: Rec): boolean =>
    keyBindings.every(binding => cell(row, binding) === cell(target, binding));
  let top = index;
  while (top > 0) {
    const prev = rows[top - 1];
    if (!prev || prev.CRUD_TYPE === 'I' || !isSameGroup(prev)) break;
    top--;
  }
  return top;
};

/** 병합 판정에 필요한 화면 상태 — 세트키 맵 + 지금 편집 진입한 세트키(없으면 광역 병합). */
export interface MergeContext {
  setKeys?: SetKeyMap;
  activeSetKey?: string | null;
}

/**
 * 두 행이 세로 병합 가능한가 — 순수 판정 (DMF0044 `sales-reports.merge.ts` 이식, 2026-08-11).
 *
 * 기본은 종전 그대로 **좌측 계층 값 기준 광역 병합**이다. `activeSetKey` 가 있을 때만
 * 그 세트를 블록에서 떼어낸다 — 한쪽만 활성 세트면 경계다(활성 세트 위/아래는 계속 붙어 있다).
 *
 * 신규(Insert) 행의 병합 범위 = **자기 삽입 세트 안** (사용자 확정 2026-08-21).
 *   · 신규 세트 **내부**는 병합한다 — 한 레코드이므로 Department 를 고치면 세트 전체가 같이 바뀌어야
 *     한다(AS-IS InsertRow 끝의 `SetRowSpanFucTwo(ActiveRowIndex, +cnt-1, …)` 와 같다).
 *   · 신규행 ↔ **기존(조회) 행**은 값이 같아도 절대 붙이지 않는다. 신규 세트의 Department 를 아래
 *     기존 행과 같은 값으로 고른 순간 한 덩어리가 되어 행 경계·편집·삭제 대상이 뭉개진다.
 *     공용 규약도 같은 취지다 — `packages/foundation/src/utils/mergeManager.ts` 의 `isInsertRow`.
 *   · 서로 다른 삽입 세트끼리도 붙이지 않는다.
 */
export const canMergeRows = (
  ra: Rec | undefined,
  rb: Rec | undefined,
  leftBindings: string[],
  ctx?: MergeContext
): boolean => {
  if (!ra || !rb) return false;
  const ia = ra.CRUD_TYPE === 'I';
  const ib = rb.CRUD_TYPE === 'I';
  if (ia !== ib) return false; // 신규 ↔ 기존 경계 = 값이 같아도 병합 금지
  if (ia && ra.INSERT_GROUP_ID !== rb.INSERT_GROUP_ID) return false; // 다른 삽입 세트끼리도 금지
  const active = ctx?.activeSetKey;
  if (active != null) {
    // 편집 진입한 세트만 분리 — AS-IS 가 클릭 시 그 세트만 다시 span 하던 것과 같다
    const aActive = ctx?.setKeys?.get(ra) === active;
    const bActive = ctx?.setKeys?.get(rb) === active;
    if (aActive !== bActive) return false;
  }
  return leftBindings.every(
    k => ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
  );
};

export class EtcSalesReportsMergeManager extends MergeManager {
  private readonly fixedBindings: string[];
  // ref 미러 — MergeManager 는 컬럼 구성이 바뀔 때만 다시 만들어지므로(Grid useEffect 의존성),
  //   조회·Insert 마다 바뀌는 세트키 맵과 편집 진입 세트는 ref 로 들여다본다(lockCtxRef 와 동형).
  private readonly ctxRef: { current: MergeContext };

  constructor(fixedBindings: string[], ctxRef: { current: MergeContext }) {
    super();
    this.fixedBindings = fixedBindings;
    this.ctxRef = ctxRef;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ===== #108 — No. 코너(TopLeft) 단일 머지 (정본 ExchangeRateModal) =====
    if (panel.cellType === CellType.TopLeft) {
      return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
    }

    const col = panel.columns[c];
    if (!col) return null;
    const binding = col.binding ?? '';

    // ===== ① Data Cell — 좌측 fixed cols 계층 머지 (viewport row 제한) =====
    if (panel.cellType === CellType.Cell && this.fixedBindings.includes(binding)) {
      const view = panel.rows;
      const rowItem = (i: number): Record<string, unknown> | undefined =>
        (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      const cur = rowItem(r);
      if (!cur) return null;
      const fixedIdx = this.fixedBindings.indexOf(binding);
      const leftBindings = this.fixedBindings.slice(0, fixedIdx + 1);
      // 경계는 행 데이터(값 + 삽입 세트)와 **편집 진입 세트** 만 본다.
      //   선택(selectionChanged)에는 절대 걸지 말 것 — 파일 상단 금지 참조.
      const ctx = this.ctxRef.current;
      const sameRow = (a: number, b: number): boolean =>
        canMergeRows(rowItem(a), rowItem(b), leftBindings, ctx);
      const minRow = panel.viewRange.row;
      const maxRow = panel.viewRange.row2;
      let r1 = r;
      let r2 = r;
      while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
      while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
      if (r1 === r2) return null;
      return new CellRange(r1, c, r2, c);
    }

    // ===== ② ColumnHeader — 정적 컬럼 verticalSpan =====
    //   ⚠ 2026-08-11 — **연도 가로 머지 제거**. 헤더가 1단이 되어(AS-IS iColumnHeaderRowCount=1)
    //     묶을 상위 행 자체가 없다. 헤더 행이 1개면 아래 verticalSpan 도 1행짜리라 실질 무동작이지만,
    //     정적 컬럼 규약(hook #108 계열)을 유지하기 위해 형태는 남긴다.
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding) && panel.rows.length > 1) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
    }
    return null;
  }
}
