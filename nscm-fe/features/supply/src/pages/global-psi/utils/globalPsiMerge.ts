import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

// 동적 기간 컬럼(M_/W_/D_) 헤더 병합 + 선행 식별 컬럼 데이터셀 계층 세로병합 전담 매니저.
//   자매 SCP0025 Shipment Plan Fix ShipmentPlanFixMergeManager 1:1 — Global PSI 도 같은 캘린더 원천
//   (W_=W_+yyyymm(6)+ISO_WEEK(2), M_=M_+yyyymm)을 써서 binding slice 로직이 동일하다. 정적 헤더·
//   TopLeft 는 delegate(공용 CustomMergeManager)로 위임한다.
//
// ① Data Cell   : fixedBindings(선행 식별 컬럼 — Division/Item/Site … measure 행라벨 제외) 계층
//                  세로병합. 좌측(0..자기) 값이 모두 같은 연속 행을 하나로 합친다. viewport row 로 제한.
// ② ColumnHeader: 동적 M_/W_/D_ 만 전담(binding 기준 결정적 병합). 값기반 공용 병합은 M_/W_ 의 'SUM'
//                  leaf 라벨을 가로로 잘못 뭉치거나(사용자 신고 2026-10-07 Weekly SUM 가로합쳐짐) 세로병합을
//                  풀어 버린다.
//                  · row 0     = 대상년월(yyyymm) 가로 병합
//                  · M_ row1~  = 'SUM' 세로 병합(2·3단 단일 셀)
//                  · W_/D_ row1= 주차 라벨 가로 병합
export class GlobalPsiMergeManager extends MergeManager {
  // 선행 식별 컬럼 binding(표시 순서) — 그리드가 updatedLayout 마다 갱신(컬럼 재구성 대응).
  fixedBindings: string[];

  constructor(
    private readonly delegate: MergeManager,
    fixedBindings: string[] = []
  ) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const cols = panel.columns;
    const binding = cols[c]?.binding ?? '';

    // ===== ① Data Cell — 선행 식별 컬럼 계층 세로병합 (viewport 제한) =====
    if (panel.cellType === CellType.Cell && this.fixedBindings.includes(binding)) {
      const view = panel.rows;
      const rowItem = (i: number): Record<string, unknown> | undefined =>
        (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      if (!rowItem(r)) return null;
      const fixedIdx = this.fixedBindings.indexOf(binding);
      const leftBindings = this.fixedBindings.slice(0, fixedIdx + 1);
      const sameRow = (a: number, b: number): boolean => {
        const ra = rowItem(a);
        const rb = rowItem(b);
        if (!ra || !rb) return false;
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

    // ===== ② ColumnHeader — 동적 M_/W_/D_ 전담. 정적 헤더는 delegate =====
    if (panel.cellType === CellType.ColumnHeader && /^[MWD]_/.test(binding)) {
      const last = panel.rows.length - 1;
      // M_ : 2·3단이 모두 'SUM' → header row 1..last 세로 병합(단일 SUM). AS-IS ColumnHeaderSpan(1,col,2,1,"SUM").
      if (/^M_\d{6}$/.test(binding) && r >= 1) {
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
      const bind = (i: number): string => cols[i]?.binding ?? '';
      const ymOf = (b: string): string => (/^[MWD]_/.test(b) ? b.slice(2, 8) : '\0');
      // 1단(row 0) = 대상년월 가로 병합.
      if (r === 0) {
        const ym = ymOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && ymOf(bind(c1 - 1)) === ym) c1--;
        while (c2 < cols.length - 1 && ymOf(bind(c2 + 1)) === ym) c2++;
        return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
      }
      // 2단(row 1, leaf 아님) = 주차 라벨 가로 병합(같은 년월 + 같은 라벨 연속). leaf 행은 병합 없음.
      if (r === 1 && r < last) {
        const label = panel.getCellData(1, c, false) as WijmoPrimitive;
        if (label === null || label === undefined || label === '') return null;
        const ym = ymOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && ymOf(bind(c1 - 1)) === ym && panel.getCellData(1, c1 - 1, false) === label)
          c1--;
        while (
          c2 < cols.length - 1 &&
          ymOf(bind(c2 + 1)) === ym &&
          panel.getCellData(1, c2 + 1, false) === label
        )
          c2++;
        return c1 === c2 ? null : new CellRange(1, c1, 1, c2);
      }
      return null; // leaf 행 등 — 병합 없음
    }

    return this.delegate.getMergedRange(panel, r, c, clip);
  }
}
