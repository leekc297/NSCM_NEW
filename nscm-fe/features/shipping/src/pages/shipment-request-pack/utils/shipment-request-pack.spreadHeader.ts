import { CellRange, CellType, type GridPanel, MergeManager } from '@mescius/wijmo.grid';

import type { FlexGridColumnConfig } from '@foundation/models';
import { isInsertRow } from '@foundation/utils';

import type { SearchParamProps } from '../shipment-request-pack.types';

/**
 * GET_SPREAD_TITLE(P_SSP0026_GET_SPREAD_TITLE, 배포됨) 동적 헤더 빌더 — AS-IS SetSpreadHeaderSpan
 * (cs:497-566) 3단 병합 헤더를 공용 DataGrid 의 중첩 columnGroups 로 재현한다(DMF0045 동일 패턴).
 *
 * SP 실측(asis.py SSP0026_GET_SPREAD_TITLE / ora.py SCM_SYS_CALENDAR_M): 정적 컬럼 + D_/W_/M_
 * 전 버킷을 캘린더 기반으로 반환(동적 부분은 sheetName 무관 동일). 라벨 형식(2026-10 기간 실측):
 *   - D_yyyymmdd: COLUMN_LABEL=일(CALENDAR_DAY "19") / SMALL=주차(WEEK_NAME "W43") / LARGE=월("2026-10")
 *   - W_yyyymm+isoweek: LABEL·SMALL=주차 / LARGE=월
 *   - M_yyyymm: LABEL·SMALL·LARGE=월
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

// 버킷 서열 — M(월)=0 상위 … D(일)=2 하위. 활성 버킷 기준 상위(summary)/하위(drill) 판정용(DMF0045 DYN_RANK).
export const DYN_RANK: Record<Kind, number> = { M: 0, W: 1, D: 2 };

export const BUCKET_PREFIX: Record<SearchParamProps['bucketType'], Kind> = {
  Daily: 'D',
  Weekly: 'W',
  Monthly: 'M',
};

export const dynKindOf = (b: string): Kind | null =>
  /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;

// spreadTitle 부재 시 binding 파생 fallback 라벨(= AS-IS 미응답 경로. D 는 일자, W/M 은 SUM).
const deriveLabels = (binding: string, kind: Kind): Pick<DynColMeta, 'large' | 'small' | 'leaf'> => {
  const d = binding.slice(2);
  const ym = `${d.slice(0, 4)}-${d.slice(4, 6)}`;
  if (kind === 'D') return { large: ym, small: '', leaf: String(Number(d.slice(6, 8))) };
  if (kind === 'M') return { large: ym, small: 'SUM', leaf: 'SUM' };
  return { large: ym, small: `W${d.slice(6)}`, leaf: 'SUM' };
};

/**
 * 동적 컬럼 메타 — GET_SPREAD_TITLE 우선, 없으면 조회 row 의 동적 키 집합에서 파생. D/W/M 전 버킷을
 * SP sort 순(M=월첫 → W=주 → D=일)으로 반환한다. 표시/드릴은 컬럼 visible 로 제어(buildDynamicColumns
 * 는 전 버킷을 중첩 렌더하고, 활성 버킷만 보이게 하는 것은 화면의 applyDynVisibility 소관).
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
 * 3단 중첩 columnGroups — 1단(년월 LARGE) → 2단(주차/월 SMALL) → leaf(일 / SUM). DataGrid 가
 * 중첩 columns 를 병합 헤더로 렌더한다. leaf 높이(height:48)는 다단 헤더용 명시 의무(공용 wrapper 는
 * staticColumns 만 자동 처리).
 */
export const buildDynamicColumns = (metas: DynColMeta[]): FlexGridColumnConfig[] => {
  if (metas.length === 0) return [];
  type LeafCol = FlexGridColumnConfig & { binding: string };
  // 균일 3단(large→sub→leaf) — 전 버킷 동일 깊이라 물리 헤더 행이 항상 3줄. 월(M_)은 sub·leaf 가
  //   모두 'SUM' 이고, 그 r1~r2 세로 병합은 SpreadHeaderMergeManager 가 처리한다(DMF0045 동일 —
  //   월 1단 / SUM 세로병합 2단). 여기선 구조만, 병합은 매니저 소관(헤더 머지는 커스텀 매니저 위임).
  const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
  metas.forEach((m, idx) => {
    // 1단 그룹 키 = binding 의 yyyymm(라벨은 large). 라벨만으로 묶으면 동명 월 충돌 → binding 기준.
    const ymKey = m.binding.slice(2, 8);
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
  return [...largeMap.values()]
    .sort((a, b) => a.order - b.order)
    .map(bucket => ({
      header: bucket.label,
      align: 'center',
      height: 48,
      columns: [...bucket.subs.entries()].map(([subLabel, leafCols]) => ({
        header: subLabel,
        align: 'center',
        height: 48,
        columns: leafCols,
      })),
    }));
};

/** D_ 주말(토/일) leaf 헤더 글자색 — 토=파랑/일=빨강(AS-IS cs:542). binding → CSS color. */
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
 * 헤더 병합(월 SUM 세로, 정적 헤더 세로 span)을 함께 담당. DMF0045 HierarchicalMergeManager 계보.
 *
 * (1) 데이터셀: 좌측 정적(fixed) 컬럼을 **계층 병합** — 이 컬럼과 그 왼쪽 컬럼들이 모두 같은 값이면
 *     위/아래 행과 세로 병합(아이템 정보가 measure 행들에 걸쳐 1번만 표시). viewport 범위로 제한,
 *     신규행(Insert)은 제외(키가 전부 빈값이라 과다병합 방지).
 * (2) 헤더: 정적 컬럼 전 헤더행 세로 span(커스텀 매니저 꽂으면 기본 자동 span 이 꺼짐) + 월(M_) SUM
 *     row1~마지막 세로 병합(월 1단 / SUM 세로병합 2단, AS-IS ColumnHeaderSpan). 동적 가로병합은 super.
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
    // 그 외 데이터셀(동적 날짜·MEASURE 등)은 병합하지 않는다(같은 값 우연 병합 방지 — super 미호출).
    if (panel.cellType === CellType.Cell) return null;

    // (2) 헤더.
    if (panel.cellType === CellType.ColumnHeader) {
      if (this.fixedSet.has(binding)) {
        return new CellRange(0, c, panel.rows.length - 1, c);
      }
      if (r >= 1 && /^M_\d{6}$/.test(binding)) {
        const last = panel.rows.length - 1;
        return last <= 1 ? null : new CellRange(1, c, last, c);
      }
    }
    return super.getMergedRange(panel, r, c, clip);
  }
}
