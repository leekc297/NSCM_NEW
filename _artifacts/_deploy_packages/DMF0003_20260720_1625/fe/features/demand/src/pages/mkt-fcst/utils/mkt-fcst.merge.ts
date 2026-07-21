import {
  CellRange,
  CellType,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';

// 동적 PIVOT 컬럼 키 파서 — M_yyyymm / W_yyyymmdd / D_yyyymmdd
//   kind  : 'M'(월) / 'W'(주) / 'D'(일) / null(고정 컬럼)
//   ym    : 'YYYY-MM' (1단 그룹 = 대상년월 머지 키)
//   sub   : 2단 그룹 키 (주: ISO 'Wxx' / 일·월: '')
//   leaf  : 3단 leaf 라벨 (일: 'MMDD' / 그 외: '')
export interface DynKey {
  kind: 'M' | 'W' | 'D' | null;
  ym: string;
  sub: string;
  leaf: string;
}

const isoWeek = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
};

export const getDynKey = (binding: string): DynKey => {
  if (/^M_\d{6}$/.test(binding)) {
    const d = binding.slice(2);
    return { kind: 'M', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, sub: 'SUM', leaf: '' };
  }
  // ⭐ AS-IS SP(DMF0003_GET_SPREAD_TITLE L101) 실측: 'W_' || BASIS_YYYYMM || ISO_WEEK.
  //   → W_yyyymm + 주차(가변 1~3자리). 일자(yyyymmdd) 8자리 형식도 함께 허용(데이터 row fallback 호환).
  if (/^W_\d{8}$/.test(binding)) {
    // W_yyyymmdd (8자리 = 주 시작일) — 데이터 row 키 fallback 경로.
    const d = binding.slice(2);
    return {
      kind: 'W',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      sub: `W${isoWeek(d)}`,
      leaf: `${d.slice(4, 6)}${d.slice(6, 8)}`,
    };
  }
  if (/^W_\d{7,9}$/.test(binding)) {
    // W_yyyymm + ISO_WEEK (SP 실측 형식) — yyyymm 으로 1단 그룹(년월) 산정, 나머지=주차.
    const d = binding.slice(2);
    const week = d.slice(6);
    return {
      kind: 'W',
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      sub: `W${week}`,
      leaf: '',
    };
  }
  if (/^D_\d{8}$/.test(binding)) {
    const d = binding.slice(2);
    return {
      kind: 'D',
      // ⭐ Daily 2단 = 주차(ISO week). 일자(leaf) 의 상위 그룹으로 주차 헤더를 노출 (SUM 아님).
      ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
      sub: `W${isoWeek(d)}`,
      leaf: `${d.slice(4, 6)}${d.slice(6, 8)}`,
    };
  }
  return { kind: null, ym: '', sub: '', leaf: '' };
};

// ⭐ 계층 머지 (DMF0020 HierarchicalMergeManager 복제 — End Customer/Sales Site 세로 머지 + viewport sticky).
//   ① Data Cell  : 좌측 fixed cols 계층(상위 동일값) 세로 머지 (v4 viewport row 제한 = sticky content).
//   ② ColumnHeader: 정적 column verticalSpan + 동적 column 2단(년월/주차) 가로 머지.
//   생성 시 fixedBindings(좌측 고정 컬럼 binding 순서)를 주입 → 컬럼 구성 변경 시 재생성.
export class HierarchicalMergeManager extends MergeManager {
  private readonly fixedBindings: string[];

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
  }

  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
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

    // ===== ② ColumnHeader — 정적 verticalSpan + 동적 1단(년월)/2단(주차) 가로 머지 =====
    //   ⚠️ 커스텀 mergeManager 설정 시 Wijmo 가 헤더 머지를 매니저에 위임 → 여기서 직접 머지해야 함.
    //   ⚠️ getDynKey 미사용: GET_SPREAD_TITLE Weekly binding 'W_'+yyyymm+ISO_WEEK(예 W_20260727=2026-07·W27)을
    //      getDynKey 가 '날짜 2026-07-27' 로 오해석 → 같은 주 연속 binding 이 동일 isoWeek 로 묶여 collapse.
    //      → binding 을 직접 파싱(아래 dynYm/dynSub)해 신뢰 키로 머지.
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedBindings.includes(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (!/^[MWD]_/.test(binding)) return null;
      // ⭐ Monthly 2·3단 세로 머지 (사용자 지정 2026-07-02) — 1단(yyyy-mm)만 유효, 2·3단은 모두 'SUM'
      //   라벨(월당 1열 = 가로 머지 대상 없음) → header row 1..last 를 세로로 합쳐 단일 SUM 셀 표시.
      if (r >= 1 && /^M_\d{6}$/.test(binding)) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
      const cols = panel.columns;
      const bind = (i: number): string => cols[i]?.binding ?? '';
      // 1단 = 년월(yyyymm) — M_/W_/D_ 공통, binding[2..7].
      const ymOf = (b: string): string => (/^[MWD]_/.test(b) ? b.slice(2, 8) : '\0');
      // 2단 = 주차 그룹. Monthly=SUM(월당 1열) / Weekly=주차번호(yyyymm 뒤, 주당 1열) / Daily=일자의 ISO 주차.
      const subOf = (b: string): string => {
        if (/^M_\d{6}$/.test(b)) return b.slice(2, 8) + ':SUM';
        if (/^W_\d{7,9}$/.test(b)) return b.slice(2, 8) + ':W' + b.slice(8);
        if (/^D_\d{8}$/.test(b)) return b.slice(2, 8) + ':W' + isoWeek(b.slice(2));
        return '\0';
      };
      if (r === 0) {
        const ym = ymOf(binding);
        let c1 = c;
        let c2 = c;
        while (c1 > 0 && ymOf(bind(c1 - 1)) === ym) c1--;
        while (c2 < cols.length - 1 && ymOf(bind(c2 + 1)) === ym) c2++;
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
