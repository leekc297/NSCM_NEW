import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// ⭐ DMF0044 — business-plan.merge.ts 축약 (M_ 단일 축 — **1단 헤더**).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan (헤더 행 2개 이상일 때만 의미).
//
//   ③ 편집 진입한 세트만 광역 블록에서 떼어낸다 (`activeSetKey`) — 자매 화면 DMF0049 와 같은 규약.
//     조회 직후에는 종전대로 값 기준 광역 병합이고, **더블클릭(= 편집 진입)** 한 2행 세트만 갈라진다.
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
//     세트키 규약은 저장부 `SalesReports.tsx` 의 `setInfoOf` 와 **같다**(`buildSetKeyMap` 주석 참조).
//
//   금지: 병합을 **선택(selectionChanged)** 에 의존시키지 말 것 — wijmo 는 이미 선택된 셀을 다시
//     클릭해도 선택 이벤트를 내므로 "포커스만 옮겼는데 병합이 깨진다"가 된다. 진입 트리거는
//     **더블클릭(mousedown detail>=2)** 과 편집 시작 키 입력뿐이다.
//   금지: 편집 **중**에 invalidate 하지 말 것 — invalidate 는 10ms 뒤 refresh 를 예약하고
//     FlexGrid.refresh 는 finishEditing 을 불러 편집기·콤보 드롭다운을 닫는다.
//     분리는 편집 **직전**에 동기 `refresh(false)`, 복원은 편집 **종료 후**(cellEditEnded) invalidate.
//     규약 전문 = `.atlas/wiki/wijmo-merge-no-state-dependency.md`,
//     공용 = `packages/foundation/src/utils/mergeManager.ts:65~74` (커밋 0a76c94).
//     세부 등록·해제는 `components/SalesReportsGrid.tsx` 의 openSetForEdit / closeActiveSet 참조.
//   ⚠ 2026-08-10 — 연도 가로 머지 제거. AS-IS `DMF0044_Sales_Reports.cs:235~236` 가
//     `iColumnHeaderRowCount = 1` 을 넘기므로 헤더는 1단이고, 동적 컬럼은 `2025-01` 처럼
//     **월 라벨 하나**로 나온다(연도 상위 span 없음). 종전 2단 구성은 SP 라벨(LARGE=SMALL='2025-01')
//     때문에 '2025-01' 그룹 아래 '2025-01' 1개짜리가 12개 생기는 오구성이었다.

type Rec = Record<string, unknown>;

/** 행 → 세트키. 병합(보이는 범위)과 저장(쓰이는 범위)이 갈리지 않도록 **한 맵을 둘이 공유**한다. */
export type SetKeyMap = ReadonlyMap<Rec, string>;

/** 2행 Measure 블록 — AS-IS `GetCellNumbersByRow` multiful=2 (Insert/Delete/저장 수집 단위). */
const SET_SIZE = 2;

/** 세트키 조각 — SP 값은 문자/숫자로 온다. 그 외 타입은 "키 없음"으로 본다. */
const keyText = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

/**
 * 화면 행 배열(= `[...insertedRows, ...spRows]`) 전체의 세트키 맵.
 *
 * 세트 판별 규약은 저장부 `SalesReports.tsx` 의 `setInfoOf` 와 **같아야 한다** — 갈리면
 * "보이는 병합 범위 ≠ 저장되는 범위" 가 되어 이 파일 상단의 결함이 그대로 되살아난다.
 *   1. 신규(Insert) 행 — 자기 삽입 세트(`INSERT_GROUP_ID`) 안에서만 한 세트.
 *      AS-IS 도 InsertRow 끝에서 `SetRowSpanFucTwo(siMain, ActiveRowIndex, ActiveRowIndex + 1, …)`
 *      로 **삽입한 2행만** span 한다(`.cs` L1031). 값만 비교하면 신규행의 빈 값이 인접 기존행과
 *      우연히 일치해 셀이 붙어버려 행 경계·삭제 대상이 뭉개진다.
 *   2. 조회 행 — 인접 2행 쌍(`setInfoOf` 의 `idx % 2` 와 같은 위치 규약).
 *      DMF0044 는 DMF0049 와 달리 행 키(DATA_SEQ)가 없다 — `P_DMF0044_GET_SALES_REPORTS_DATA` 가
 *      내려주지 않으므로 AS-IS·TO-BE 모두 위치로만 세트를 가른다.
 *   ⚠ 키는 **행 객체**로 걸어 둔다. 그리드가 정렬·필터로 화면 순서를 바꿔도 세트가 따라 흔들리지
 *     않게 하기 위한 것이다(뷰 인덱스로 잡으면 정렬 후 다른 레코드끼리 한 세트가 된다).
 */
export const buildSetKeyMap = (rows: readonly Rec[], setSize: number = SET_SIZE): SetKeyMap => {
  const map = new Map<Rec, string>();
  const size = Math.max(1, setSize);
  rows.forEach((row, idx) => {
    const gid = keyText(row.INSERT_GROUP_ID);
    map.set(row, gid ? `I:${gid}` : `P:${Math.floor(idx / size)}`);
  });
  return map;
};

/**
 * 신규 세트를 끼워 넣을 위치 — 포커스 행이 속한 **세트의 첫 행** 인덱스.
 *
 * AS-IS InsertRow 파리티(`.cs:931~933`): `GetCellNumbersByRow(ActiveRowIndex)` 로 활성 행이 속한
 * 2행 세트의 행 번호를 구해 `SetActiveCell(iArray[0], 2)` 로 **세트 첫 행**으로 옮긴 뒤 `Insert(2)`
 * 한다 — 포커스한 줄 한가운데를 쪼개지 않고 그 세트 바로 위에 붙는다.
 *
 * 포커스가 없거나 화면 목록에서 못 찾으면 0(맨 위) — 종전 동작.
 * ⚠ 세트 첫 행에 맞추는 것은 위치 규약(`P:floor(idx/2)`) 유지에도 필요하다 — 홀수 위치에 2행을
 *   끼우면 그 아래 SP 행들의 짝이 통째로 어긋난다.
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

/** 병합 판정에 필요한 화면 상태 — 세트키 맵 + 지금 편집 진입한 세트키(없으면 광역 병합). */
export interface MergeContext {
  setKeys?: SetKeyMap;
  activeSetKey?: string | null;
}

/**
 * 두 행이 세로 병합 가능한가 — 순수 판정 (MergeManager 내부에서 사용. 단위테스트 대상).
 *
 * 기본은 종전 그대로 **좌측 계층 값 기준 광역 병합**이다. `activeSetKey` 가 있을 때만
 * 그 세트를 블록에서 떼어낸다 — 한쪽만 활성 세트면 경계다(활성 세트 위/아래는 계속 붙어 있다).
 *
 * 신규(Insert) 행의 병합 범위 = **자기 2행 세트 안** (사용자 확정 2026-08-21).
 *   · 신규 세트 **내부**는 병합한다 — 한 레코드이므로 Department 를 고치면 세트 전체가 같이 바뀌어야
 *     한다(AS-IS InsertRow 끝의 `SetRowSpanFucTwo(ActiveRowIndex, ActiveRowIndex + 1, …)` 와 같다).
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
    const aActive = ctx?.setKeys?.get(ra) === active;
    const bActive = ctx?.setKeys?.get(rb) === active;
    if (aActive !== bActive) return false;
  }
  return leftBindings.every(
    k => ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
  );
};

export class SalesReportsMergeManager extends MergeManager {
  private readonly fixedBindings: string[];
  // ref 미러 — MergeManager 는 컬럼 구성이 바뀔 때만 다시 만들어지므로(Grid useEffect 의존성),
  //   조회·Insert 마다 바뀌는 세트키 맵과 편집 진입 세트는 ref 로 들여다본다.
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
    //   ⚠ 2026-08-10 — **연도 가로 머지 제거**. 헤더가 1단이 되어(AS-IS iColumnHeaderRowCount=1)
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
