import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// ⭐ DMF0049 — sales-reports(DMF0044).merge.ts 이식 (M_ 단일 축 — **1단 헤더**).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan (헤더 행 2개 이상일 때만 의미).
//   ③ 활성 세트 분리 : 클릭된 행의 measure 세트를 ① 의 광역 블록에서 떼어낸다 (REQ:CHAT-20260820-18/19).
//   ⚠ 2026-08-11 — 연도 가로 머지 제거 (DMF0044 2026-08-10 선례 이식). AS-IS
//     `DMF0049_Sales_ETC_Reports.cs:265` 가 `iColumnHeaderRowCount = 1` 을 넘기므로 헤더는 1단이고,
//     동적 컬럼은 `2025-01` 처럼 **월 라벨 하나**로 나온다(연도 상위 span 없음). 종전 2단 구성은
//     SP 라벨(LARGE=SMALL=COLUMN_LABEL='2025-01') 때문에 '2025-01' 그룹 아래 '2025-01' 1개짜리가
//     12개 생기는 오구성이었다.

/**
 * 두 행이 세로 병합 가능한가 — 순수 판정 (DMF0044 `sales-reports.merge.ts` 이식, 2026-08-11).
 *
 * ⭐ 신규(Insert) 행은 **자기 삽입 세트 안에서만** 병합한다.
 *   AS-IS 는 InsertRow 끝에서 삽입한 행 범위만 span 한다 — 이웃한 기존 등록 행과는 묶이지 않는다.
 *   값 비교만 하면 신규행의 빈 값이 인접 기존행과 우연히 일치해 셀이 붙어버려,
 *   행 경계가 사라지고 편집·삭제 대상이 뭉개진다.
 *   ⚠ DMF0049 도 세트 삽입(40=3행 / 81=2행 / 82=1행)을 하므로 동일 사고 소지가 있었다.
 */
export const canMergeRows = (
  ra: Record<string, unknown> | undefined,
  rb: Record<string, unknown> | undefined,
  leftBindings: string[]
): boolean => {
  if (!ra || !rb) return false;
  const ia = ra.CRUD_TYPE === 'I';
  const ib = rb.CRUD_TYPE === 'I';
  if (ia !== ib) return false; // 신규 ↔ 기존 경계 = 병합 금지
  if (ia && ra.INSERT_GROUP_ID !== rb.INSERT_GROUP_ID) return false; // 다른 삽입 세트끼리도 금지
  return leftBindings.every(
    k => ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
  );
};

/**
 * 행이 속한 **measure 세트**의 키 — 신규는 삽입 그룹, 기존은 DATA_SEQ (AS-IS 세트 판정 원천과 동일).
 *
 * AS-IS `GetMeasureCntBy40`(.cs:1643~) 이 "data_seq 가 존재하면 사업부와 무관하게 seq 를 쓰고,
 * 신규 insert 건만 Measure 로 판단한다"([C20210506-000051]) 고 명시한다 — 그 판정을 그대로 옮겼다.
 * 세트를 특정할 수 없는 행(둘 다 없음)은 `null` 이라 활성 세트가 될 수 없다.
 */
export const setKeyOf = (row: Record<string, unknown> | undefined): string | null => {
  if (!row) return null;
  const gid = row.INSERT_GROUP_ID;
  if (typeof gid === 'string' && gid !== '') return `I:${gid}`;
  const seq = row.DATA_SEQ; // SP 는 문자열로 주지만 그리드를 거치며 숫자가 되기도 한다
  if (typeof seq === 'number') return `S:${seq}`;
  if (typeof seq === 'string' && seq !== '') return `S:${seq}`;
  return null;
};

export class EtcSalesReportsMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  // ⭐ REQ:CHAT-20260820-18/19 — 지금 클릭된 행의 세트키. 이 세트는 광역 병합 블록에서 **분리**된다.
  //   AS-IS 는 조회 직후 `SmartColMerge()`(.cs:599) 로 좌측 컬럼을 값 기준 광역 병합해 두고,
  //   `spdMain_CellClick`(.cs:1578~1605) 에서 클릭된 행의 measure 세트 범위
  //   (`GetCellIndexBySpanRowCells40` .cs:1612~1635 로 세트 첫 행 산출 → +iMeasureCnt-1)만
  //   `SetRowSpanFucTwo` 로 **다시 span** 한다 = 그 세트가 광역 블록에서 떨어져 나온다.
  private activeSetKey: string | null = null;

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  /**
   * 활성 세트키 교체. **실제로 바뀐 경우에만** true 를 돌려준다 —
   * 호출부가 이 값으로 `invalidate()` 를 걸지 말지 정한다(같은 세트 재클릭마다 refresh 를 예약하면
   * 10ms 뒤 `FlexGrid.refresh` 가 `finishEditing` 을 불러 편집 진입이 끊긴다.
   * `packages/foundation/src/utils/mergeManager.ts:66~74` 경고와 같은 계열).
   */
  setActiveSetKey(key: string | null): boolean {
    if (this.activeSetKey === key) return false;
    this.activeSetKey = key;
    return true;
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
      // ⭐ 활성 세트 경계 — 활성 세트 안/밖이 갈리면 값이 같아도 잇지 않는다.
      //   결과적으로 ①클릭한 세트는 자기 행들끼리만 묶이고 ②나머지 광역 블록은 그 세트 앞에서 끊긴다
      //   = AS-IS `spdMain_CellClick` 의 세트 단위 재-span 과 같은 화면 상태.
      //   ⚠ 세트 전체가 한 덩어리로 유지되므로 "같은 group 값만 병합된 상태로 입력"(REQ-19) 도 성립한다.
      const inActive = (i: number): boolean =>
        this.activeSetKey !== null && setKeyOf(rowItem(i)) === this.activeSetKey;
      const curActive = inActive(r);
      const sameRow = (a: number, b: number): boolean =>
        inActive(a) === curActive && canMergeRows(rowItem(a), rowItem(b), leftBindings);
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
