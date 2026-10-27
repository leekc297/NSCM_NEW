import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import type { FlexGridColumnConfig } from '@foundation/models';
import { isInsertRow } from '@foundation/utils';

/**
 * P_SSP0022_GET_SHEET_CALENDAR_3SPAN(배포됨) 동적 헤더 빌더 — AS-IS SetSpreadHeaderSpan/
 * InitSpreadDateColumn(cs:716-814) 3단 병합 헤더를 공용 DataGrid 의 중첩 columnGroups 로 재현한다.
 * 자매 화면 SSP0026(shipment-request-pack.spreadHeader) 이식 — 차이는 COLUMN_NAME 접두뿐이다.
 *
 * SP 실측(ora.py PKG_SSP0022 body): COLUMN_NAME 은 BOH 축 접두 X_/Y_/Z_ + 버킷 D_/W_/M_ + 날짜코드.
 *   - X_D_yyyymmdd(8): COLUMN_LABEL=일(CALENDAR_DAY) / SMALL=주차(WEEK_NAME) / LARGE=월(MONTH_NAME)
 *   - X_W_yyyymm+isoweek(8): LABEL·SMALL=주차 / LARGE=월
 *   - X_M_yyyymm(6): LABEL·SMALL·LARGE=월
 *   (Y_/Z_ 동일 구조 — BOH 표시모드 rdButton2/3). SSP0026 과 동일 컬럼셋(COLUMN_NAME/..._LABEL_NAME/
 *   DAY_CODE/SORT_ORDER_NO), 접두 2글자(X_/Y_/Z_)만 더 붙는다.
 */
export interface SpreadTitleRow {
  COLUMN_NAME: string;
  COLUMN_LABEL_NAME: string;
  SMALL_CLASS_LABEL_NAME: string;
  LARGE_CLASS_LABEL_NAME: string;
  DAY_CODE: string;
  // SP 는 SORT_ORDER_NO(정렬 키)를 반환하나 procedures.d.ts 타입엔 없어 옵셔널로 읽는다.
  SORT_ORDER_NO?: string | number;
}

type Kind = 'D' | 'W' | 'M';

export interface DynColMeta {
  binding: string;
  kind: Kind;
  large: string; // 1단(대분류) = 년월
  small: string; // 2단(소분류) = 주차 / 월
  leaf: string; // 3단(leaf) = 일 / SUM
  sort: number;
  dayCode: string; // D_ 전용 요일(SAT/SUN) — 주말 헤더 색상용
}

// 접두 X_/Y_/Z_ + 버킷. M_=6자리(yyyymm), D_/W_=8자리(yyyymmdd / yyyymm+isoweek).
export const dynKindOf = (b: string): Kind | null =>
  /^[XYZ]_M_\d{6}$/.test(b) ? 'M' : /^[XYZ]_W_\d{8}$/.test(b) ? 'W' : /^[XYZ]_D_\d{8}$/.test(b) ? 'D' : null;

// spreadTitle 부재 시 binding 파생 fallback 라벨(= SP 미응답 경로. D 는 일자, W/M 은 SUM).
//   접두('X_D_' 등 4글자) 뒤가 날짜코드다.
const deriveLabels = (binding: string, kind: Kind): Pick<DynColMeta, 'large' | 'small' | 'leaf'> => {
  const d = binding.slice(4);
  const ym = `${d.slice(0, 4)}-${d.slice(4, 6)}`;
  if (kind === 'D') return { large: ym, small: '', leaf: String(Number(d.slice(6, 8))) };
  if (kind === 'M') return { large: ym, small: 'SUM', leaf: 'SUM' };
  return { large: ym, small: `W${d.slice(6)}`, leaf: 'SUM' };
};

/**
 * 동적 컬럼 메타 — GET_SHEET_CALENDAR_3SPAN 우선, 없으면 조회 row 의 동적 키 집합에서 파생. SP sort 순
 * (SORT_ORDER_NO)으로 반환한다. 표시/필터(BOH축·버킷·chkSum·pastPeriod)는 호출부가 isDynamicColumnVisible
 * 로 걸러 이 빌더에 넘긴다(buildDynamicColumns 는 넘어온 메타만 중첩 렌더).
 */
export const buildDynColMetas = (
  spreadTitle: SpreadTitleRow[] | undefined,
  dynBindingsFromRows: string[]
): DynColMeta[] => {
  const fromTitle: DynColMeta[] = (spreadTitle ?? []).flatMap(r => {
    const binding = String(r.COLUMN_NAME ?? '');
    const kind = dynKindOf(binding);
    if (!kind) return [];
    return [
      {
        binding,
        kind,
        large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
        small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
        leaf: String(r.COLUMN_LABEL_NAME ?? ''),
        sort: Number(r.SORT_ORDER_NO ?? 0),
        dayCode: String(r.DAY_CODE ?? '').trim(),
      },
    ];
  });
  const metas =
    fromTitle.length > 0
      ? fromTitle
      : dynBindingsFromRows.flatMap<DynColMeta>(binding => {
          const kind = dynKindOf(binding);
          if (!kind) return [];
          return [{ binding, kind, ...deriveLabels(binding, kind), sort: 0, dayCode: '' }];
        });
  return metas.sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
};

/**
 * 3단 중첩 columnGroups — 1단(년월 LARGE) → 2단(주차/월 SMALL) → leaf(일 / SUM). DataGrid 가 중첩
 * columns 를 병합 헤더로 렌더한다. leaf 높이(height:48)는 다단 헤더용 명시 의무(공용 wrapper 는
 * staticColumns 만 자동 처리). 넘어오는 메타는 전 BOH축(X_/Y_/Z_)을 함께 포함하므로(축 전환 시 재빌드
 * 없이 visible 만 토글 — 깜빡임 방지), 월 그룹키에 축 접두를 포함해 축 간 월 그룹이 충돌하지 않게 한다.
 * 비활성 축 컬럼은 호출부 baseVisible(isDynamicColumnVisible)이 visible=false 로 숨긴다.
 */
export const buildDynamicColumns = (metas: DynColMeta[]): FlexGridColumnConfig[] => {
  if (metas.length === 0) return [];
  type LeafCol = FlexGridColumnConfig & { binding: string };
  const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
  metas.forEach((m, idx) => {
    // 1단 그룹 키 = 축 접두(X_/Y_/Z_, 2글자) + yyyymm(버킷 2글자 건너뛴 4~10). 축을 포함해야 전 축을
    //   함께 빌드해도 같은 달이 축 간에 안 뭉친다. 라벨만으로 묶으면 동명 월 충돌 → binding 기준.
    const ymKey = m.binding.slice(0, 2) + m.binding.slice(4, 10);
    let bucket = largeMap.get(ymKey);
    if (!bucket) {
      bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
      largeMap.set(ymKey, bucket);
    }
    // 2단 키 — D/W 는 주차(SMALL), M 은 'SUM'.
    const subKey = m.kind === 'M' ? 'SUM' : m.small || 'SUM';
    let subCols = bucket.subs.get(subKey);
    if (!subCols) {
      subCols = [];
      bucket.subs.set(subKey, subCols);
    }
    subCols.push({
      binding: m.binding,
      // leaf 라벨 — D=일자, W/M=SUM(상위 버킷은 합계 셀).
      header: m.kind === 'D' ? m.leaf || 'SUM' : 'SUM',
      align: 'right',
      width: 90,
      allowSorting: false,
      visible: true,
      height: 48,
      _display: true,
      format: '#,##0.###',
    });
  });
  // 2단(주차/SUM) 정렬 — 세로병합되는 월 SUM(M_)이 맨 앞(왼쪽), 그다음 주차 번호순. leaf 정렬 —
  //   같은 그룹 안에서 M<W<D 순(주간 SUM 이 그 주 일자들보다 앞). SSP0015 ShipmentPlanMainGrid 동일 규칙.
  //   메타 삽입 순서(D→M→W binding 정렬)와 무관하게 출력 컬럼 순서를 고정한다.
  const kindRank: Record<Kind, number> = { M: 0, W: 1, D: 2 };
  const subOrder = (k: string): number => {
    if (k === 'SUM') return Number.NEGATIVE_INFINITY;
    const n = Number(k.replace(/\D/g, '') || 0);
    return k.trim().startsWith('+') ? n - 1000 : n;
  };
  const leafKind = (b: string): Kind => dynKindOf(b) ?? 'D';
  return [...largeMap.values()]
    .sort((a, b) => a.order - b.order)
    .map(bucket => ({
      header: bucket.label,
      align: 'center',
      height: 48,
      columns: [...bucket.subs.entries()]
        .sort(([a], [b]) => subOrder(a) - subOrder(b))
        .map(([subLabel, leafCols]) => ({
          header: subLabel,
          align: 'center',
          height: 48,
          columns: leafCols.sort(
            (a, b) =>
              kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
              a.binding.localeCompare(b.binding)
          ),
        })),
    }));
};

/** D_ 주말(토/일) leaf 헤더 글자색 — 토=파랑/일=빨강(AS-IS cs:767). binding → CSS color. */
const WEEKEND_HEADER_COLOR: Record<string, string> = {
  SAT: 'rgb(0, 0, 255)',
  SUN: 'rgb(255, 0, 0)',
};
export const buildWeekendColorByBinding = (metas: DynColMeta[]): Map<string, string> => {
  const m = new Map<string, string>();
  for (const meta of metas) {
    if (meta.kind !== 'D') continue;
    const color = WEEKEND_HEADER_COLOR[meta.dayCode];
    if (color) m.set(meta.binding, color);
  }
  return m;
};

/**
 * spdMain 머지 매니저 — AS-IS `siMain.SmartColMerge()`(좌측 정적 컬럼 세로 병합, 아이템별 그룹) +
 * 헤더 병합(월 SUM 세로, 정적 헤더 세로 span). SSP0026 SpreadHeaderMergeManager 이식 — M_ 정규식만
 * 접두(X_/Y_/Z_) 포함으로 조정.
 *
 * (1) 데이터셀: 좌측 정적(fixed) 컬럼 계층 병합 — 이 컬럼과 왼쪽 컬럼들이 모두 같은 값이면 위/아래 세로 병합.
 *     viewport 범위 제한, 신규행(Insert) 제외.
 * (2) 헤더: 정적 컬럼 전 헤더행 세로 span + 월(M_) SUM row1~마지막 세로 병합. 동적 가로병합은 super.
 */
export class SpreadHeaderMergeManager extends MergeManager {
  private readonly fixedBindings: string[];
  private readonly fixedSet: Set<string>;

  constructor(fixedBindings: string[]) {
    super();
    this.fixedBindings = fixedBindings;
    this.fixedSet = new Set(fixedBindings);
  }

  getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
    const binding = panel.columns[c]?.binding ?? '';

    // (1) 데이터셀 — 좌측 정적 컬럼 계층 세로 병합(AS-IS SmartColMerge).
    if (panel.cellType === CellType.Cell && this.fixedSet.has(binding)) {
      const rowAt = (i: number): Record<string, unknown> | undefined =>
        (panel.rows[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
      const cur = rowAt(r);
      if (!cur || isInsertRow(cur)) return null;
      const leftBindings = this.fixedBindings.slice(0, this.fixedBindings.indexOf(binding) + 1);
      const sameRow = (a: number, b: number): boolean => {
        const ra = rowAt(a);
        const rb = rowAt(b);
        if (!ra || !rb || isInsertRow(ra) || isInsertRow(rb)) return false;
        return leftBindings.every(k => String(ra[k] ?? '') === String(rb[k] ?? ''));
      };
      const minRow = panel.viewRange.row;
      const maxRow = panel.viewRange.row2;
      let r1 = r;
      let r2 = r;
      while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
      while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
      return r1 === r2 ? null : new CellRange(r1, c, r2, c);
    }
    // 그 외 데이터셀(동적 날짜·MEASURE 등)은 병합하지 않는다(우연 병합 방지 — super 미호출).
    if (panel.cellType === CellType.Cell) return null;

    // (2) 헤더.
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedSet.has(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (r >= 1 && /^[XYZ]_M_\d{6}$/.test(binding)) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
    }
    return super.getMergedRange(panel, r, c, clip);
  }
}
