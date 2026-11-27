import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { isInsertRow } from '@foundation/utils';

// ⭐ DMF0042 — sales-plan/utils/sales-plan.merge.ts 복제 + DynKey 파서 Y_/Q_/M_ 교체 (2026-07-15 플랜 §B 확정
//   — HierarchicalMergeManager 거의 그대로, 주(W_)/일(D_) 축 → 연(Y_)/분기(Q_) 축).
//   헤더 3단: 1단=연(Y) / 2단=분기(Q — Y_ 는 'SUM') / 3단=leaf(M_ 월 라벨 · Q_/Y_ 는 'SUM').

// 1단 그룹 키 = 연도 4자리 (Y_yyyy / Q_yyyy_q / M_yyyymm 공통)
const yearOf = (b: string): string => {
  if (/^Y_\d{4}$/.test(b)) return b.slice(2, 6);
  if (/^Q_\d{4}_\d$/.test(b)) return b.slice(2, 6);
  if (/^M_\d{6}$/.test(b)) return b.slice(2, 6);
  return '\0';
};

// 2단 그룹 키 = 연:분기 (Y_='연:SUM' — 단독 열 / Q_ 와 그 소속 M_ 는 동일 키로 수평 머지)
const subOf = (b: string): string => {
  if (/^Y_\d{4}$/.test(b)) return `${b.slice(2, 6)}:SUM`;
  if (/^Q_\d{4}_\d$/.test(b)) return `${b.slice(2, 6)}:Q${b.slice(7)}`;
  if (/^M_\d{6}$/.test(b)) {
    const month = Number(b.slice(6, 8));
    return `${b.slice(2, 6)}:Q${Math.ceil(month / 3)}`;
  }
  return '\0';
};

// ⭐ 계층 머지 (DMF0020 HierarchicalMergeManager 계보 — 좌측 키컬럼 세로 머지 + viewport sticky).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan + 동적 1단(연)/2단(분기) 가로 머지 + Y_/Q_ SUM 세로 머지.
//   ⚠ 커스텀 mergeManager 설치 시 nested columnGroups 네이티브 span 무효 → 수동 머지 의무 (hook #108).
//   AS-IS SmartColMerge + TopChange 재적용 (L2736~2741) 대응.
export class HierarchicalMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    // ===== #108 — No. 코너(TopLeft) 가로/세로 단일 머지 (정본 ExchangeRateModal) =====
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
      // 신규 Insert 행 병합 규칙 (사용자 2026-09-02: "신규행추가한 것은 measure 값만 분기되고
      //   앞에는 병합되어 있어야 한다"):
      //   · 신규행 vs 기존행 : 절대 병합 안 함 — 신규행은 앞(키) 컬럼이 전부 빈값이라 '' === '' 로
      //     바로 위/아래 기존 블록에 들러붙는 것을 막는다.
      //   · 다른 그룹(INSERT_GROUP_ID)의 신규행끼리 : 병합 안 함 — 행추가를 여러 번 하면 각 그룹이
      //     별개 블록으로 보여야 한다.
      //   · 같은 그룹 신규행끼리 : 아래 leftBindings 비교를 그대로 탄다 — 앞(키) 컬럼은 값이 같아
      //     병합되고, MEASURE 는 leftBindings 에 포함돼 행마다 달라 분기된다(= 원하는 표시).
      //   (DMF0021 은 신규행을 전부 분리하지만 DMF0042 는 measure 블록을 한 덩어리로 보여야 해 다르다.)
      // 값 타입을 좁혀서 문자열화한다 — unknown 을 그대로 String() 에 넣으면 객체가 섞였을 때
      //   '[object Object]' 로 뭉개져 서로 다른 그룹이 같은 값으로 비교된다(@typescript-eslint/
      //   no-base-to-string 이 잡는 지점). 문자열/숫자가 아니면 빈 그룹으로 본다.
      const groupId = (row: Record<string, unknown>): string => {
        const v = row.INSERT_GROUP_ID;
        return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
      };
      const sameRow = (a: number, b: number): boolean => {
        const ra = rowItem(a);
        const rb = rowItem(b);
        if (!ra || !rb) return false;
        const aInsert = isInsertRow(ra);
        const bInsert = isInsertRow(rb);
        if (aInsert !== bInsert) return false;
        if (aInsert && groupId(ra) !== groupId(rb)) return false;
        return leftBindings.every(
          k =>
            ((ra as Record<string, string>)[k] ?? '') === ((rb as Record<string, string>)[k] ?? '')
        );
      };
      const minRow = panel.viewRange.row;
      const maxRow = panel.viewRange.row2;
      let r1 = r;
      let r2 = r;
      while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
      while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
      if (r1 === r2) return null;
      return new CellRange(r1, c, r2, c);
    }

    // ===== ② ColumnHeader — 정적 verticalSpan + 동적 1단(연)/2단(분기) 가로 + SUM 세로 =====
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (!/^[YQM]_/.test(binding)) return null;
      const last = panel.rows.length - 1;
      // ⭐ Y_ = 연 SUM 세로 머지 (2·3단 'SUM' 단일 셀 — 플랜 §E "Y_=연 SUM 세로 2단 머지")
      if (r >= 1 && /^Y_\d{4}$/.test(binding)) {
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
      const cols = panel.columns;
      const bind = (i: number): string => cols[i]?.binding ?? '';
      if (r === 0) {
        const y = yearOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && yearOf(bind(c1 - 1)) === y) c1--;
        while (c2 < cols.length - 1 && yearOf(bind(c2 + 1)) === y) c2++;
        return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
      }
      if (r === 1) {
        const sub = subOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && subOf(bind(c1 - 1)) === sub) c1--;
        while (c2 < cols.length - 1 && subOf(bind(c2 + 1)) === sub) c2++;
        return c1 === c2 ? null : new CellRange(1, c1, 1, c2);
      }
    }
    return null;
  }
}
