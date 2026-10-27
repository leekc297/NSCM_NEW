import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import { parseDynTag } from './shipment-plan-electrode.editLock';

type WijmoPrimitive = string | number | boolean | null | undefined;

// 동적 기간 컬럼(X_/Y_/Z_ × M_/W_/D_) 헤더 병합 전담 매니저 (형제 shipment-plan-mobility-it ShipmentPsiMergeManager 1:1 이식).
//   차이: Electrode 동적 binding 은 span prefix(X_/Y_/Z_)가 앞에 붙는다 — parseDynTag 로 벗겨 bucket·ymd 를 읽는다.
//   정적 헤더(BOH/PSI 그룹 등)·데이터셀은 delegate(공용 CustomMergeManager)로 위임한다.
//
// ColumnHeader(동적 M_/W_/D_ 만 전담, binding 기준 결정적 병합):
//   값기반 공용 병합은 M_/W_ 의 'SUM' 라벨을 가로로 잘못 뭉치거나 세로병합을 풀어 버린다.
//   · row 0     = 대상년월(yyyymm) 가로 병합
//   · M_ row1~  = 'SUM' 세로 병합(2·3단 단일 셀) — 월 아래 SUM 헤더가 2줄로 보이는 것을 하나로 합친다.
//   · W_/D_ row1= 주차 라벨 가로 병합
export class ShipmentPlanElectrodeMergeManager extends MergeManager {
  constructor(private readonly delegate: MergeManager) {
    super();
  }

  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const cols = panel.columns;
    const binding = cols[c]?.binding ?? '';
    const tag = parseDynTag(binding);

    // ===== ColumnHeader — 동적 X_/Y_/Z_ × M_/W_/D_ 전담. 정적 헤더·데이터셀은 delegate =====
    if (panel.cellType === CellType.ColumnHeader && tag) {
      const last = panel.rows.length - 1;
      // M_ : 2·3단이 모두 'SUM' → header row 1..last 세로 병합(단일 SUM). AS-IS ColumnHeaderSpan(1,col,2,1,"SUM").
      if (tag.bucket === 'M' && r >= 1) {
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
      // 같은 블록 판정 — span+yyyymm 을 함께 본다(X/Y/Z 3 span 을 모두 생성해 두므로 같은 월이라도 span 이
      //   다르면 다른 블록이다). visible 은 보지 않는다 — AS-IS ColumnHeaderSpan 은 월 전체(숨김 컬럼 포함)를
      //   명시 span 하고 FpSpread/wijmo 가 숨김 컬럼을 폭 0 으로 그려 보이는 칸만큼만 렌더한다. visible 을
      //   경계로 막으면 1단(월) 병합이 숨겨진 SUM/W_/D_ 지점에서 끊긴다(병합 해제의 원인).
      const keyOf = (i: number): string => {
        const t = parseDynTag(cols[i]?.binding ?? '');
        return t ? `${t.span}_${t.ymd.slice(0, 6)}` : '\0';
      };
      const ym = `${tag.span}_${tag.ymd.slice(0, 6)}`;
      // 1단(row 0) = 대상년월 가로 병합.
      if (r === 0) {
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && keyOf(c1 - 1) === ym) c1--;
        while (c2 < cols.length - 1 && keyOf(c2 + 1) === ym) c2++;
        return c1 === c2 ? null : new CellRange(0, c1, 0, c2);
      }
      // 2단(row 1, leaf 아님) = 주차 라벨 가로 병합(같은 년월 + 같은 라벨 연속). leaf 행은 병합 없음.
      if (r === 1 && r < last) {
        const label = panel.getCellData(1, c, false) as WijmoPrimitive;
        if (label === null || label === undefined || label === '') return null;
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && keyOf(c1 - 1) === ym && panel.getCellData(1, c1 - 1, false) === label) c1--;
        while (
          c2 < cols.length - 1 &&
          keyOf(c2 + 1) === ym &&
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
