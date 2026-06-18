import { toggleClass } from '@mescius/wijmo';
import type { FlexGrid as FlexGridType, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { AllowMerging, CellRange, CellType, MergeManager, Row } from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { type RefObject, useEffect, useMemo, useRef } from 'react';

import { SHEETS } from '../contribute-main.constants';
import type { MainRow } from '../types';
import { useContributeMainStore } from '../useContributeMainStore';

interface Props {
  gridRef: RefObject<FlexGridType<MainRow>>;
  data: MainRow[];
}

// AS-IS .cs DefColumns 주석 + As-Is 화면 표기 기준 6개 컬럼
//   DEPARTMENT_NAME → 부문 (DEPARTMENT_ID 의 한글명)
//   DEPT_NAME       → 팀 (DEPT_ID 의 한글명)
//   END_CUST_REPORT (← ATTRIBUTE2)        → 고객군
//   SOLDTO_CUST_REPORT (← CUST_GROUP_DTL) → 판매처
//   PRODUCT_GROUP (← REPORT_GROUP3)        → 제품군
//   DM_BIZ_TYPE (← FORECAST_INFO_BIZ_TYPE) → 형태
const BASE_COLUMNS = [
  { binding: 'DEPARTMENT_NAME', header: '부문', width: 180 },
  { binding: 'DEPT_NAME', header: '팀', width: 200 },
  { binding: 'END_CUST_REPORT', header: '고객군', width: 120 },
  { binding: 'SOLDTO_CUST_REPORT', header: '판매처', width: 140 },
  { binding: 'PRODUCT_GROUP', header: '제품군', width: 100 },
  { binding: 'DM_BIZ_TYPE', header: '형태', width: 80 },
];

const RBU_NAME_MAP: Record<string, string> = {
  RBU_0001: '대만',
  RBU_0002: '중국-화남',
  RBU_0008: '중국-화북',
  RBU_0003: '미주',
  RBU_0004: '유럽',
  RBU_0005: '일본',
  RBU_0007: '인도',
  RBU_0006: '기타',
  RBU_0999: '구분',
};
const RBU_ORDER = [
  'RBU_0001',
  'RBU_0002',
  'RBU_0008',
  'RBU_0003',
  'RBU_0004',
  'RBU_0005',
  'RBU_0007',
  'RBU_0006',
  'RBU_0999',
];

interface DynColMeta {
  binding: string;
  period: string; // '202401'
  periodLabel: string; // '2024-01'
  leafLabel: string; // '대만'
  width: number;
}

// AS-IS analysis.md §10 다단 헤더 (Row0: 연도/월, Row1: RBU 한글명).
// 사용자 요구: Y# (연도 단독) 컬럼 제거, M# (월별) 만 유지.
// 룰 27 §F: ColumnGroup wijmo bundle 중복으로 폭발 → 옵션 4 패턴.
//   flat columns + columnHeaders.rows.push(new Row()) + custom mergeManager + formatItem.
export const ContributeMainGrid = ({ gridRef, data }: Props) => {
  const internalRef = useRef<FlexGridType<MainRow> | null>(null);
  const dynamicColumnsRef = useRef<DynColMeta[]>([]);

  // AS-IS chkYear: true → Y# (연도총계) 만 / false → M# (월별) 만
  const chkYear = useContributeMainStore(s => s.searchCondition.chkYear);
  // ⭐ admin SHEET_COLUMNS 메타 (ui-category-setup-column-meta.md).
  //   메모리 feedback_fe_grid_visible_no_fallback_loss.md:
  //     BE 가 VISIBLE_FLAG='N' row 미리 제거 → missing = admin 결정 → fallback 시 admin 무효화.
  //   다만 초기 적용 단계 (admin 메타 row 0건) 시 grid 가 비어 보이지 않도록:
  //     staticColumns.length === 0 → BASE 그대로 (transitional fallback)
  //     staticColumns.length > 0  → strict filter (admin 결정 그대로 반영)
  const staticColumns = useContributeMainStore(s => s.staticColumns[SHEETS.MAIN]);

  const visibleBaseColumns = useMemo(() => {
    if (!staticColumns || staticColumns.length === 0) return BASE_COLUMNS;
    return BASE_COLUMNS.filter(c =>
      staticColumns.some(s => {
        const sAny = s as { colNm?: string; binding?: string };
        const colNm = sAny.colNm ?? sAny.binding;
        return colNm === c.binding;
      })
    ).map(c => {
      const meta = staticColumns.find(s => {
        const sAny = s as { colNm?: string; binding?: string };
        const colNm = sAny.colNm ?? sAny.binding;
        return colNm === c.binding;
      });
      // admin width / header 우선 적용 (없으면 BASE default)
      const width = (meta as { width?: number } | undefined)?.width ?? c.width;
      const header = (meta as { header?: string } | undefined)?.header ?? c.header;
      return { ...c, width, header };
    });
  }, [staticColumns]);

  const dynamicColumns = useMemo<DynColMeta[]>(() => {
    if (!data || data.length === 0) return [];
    const prefix = chkYear ? 'Y#' : 'M#';
    const allKeys = new Set<string>();
    for (const row of data) {
      for (const k of Object.keys(row)) {
        if (k.startsWith(prefix)) allKeys.add(k);
      }
    }
    return Array.from(allKeys)
      .map(k => {
        const [, period, corp] = k.split('#');
        return {
          binding: k,
          period: period ?? '',
          periodLabel:
            period?.length === 6 ? `${period.slice(0, 4)}-${period.slice(4)}` : (period ?? ''),
          leafLabel: RBU_NAME_MAP[corp ?? ''] ?? corp ?? '',
          width: 80,
        };
      })
      .sort((a, b) => {
        const periodCmp = a.period.localeCompare(b.period);
        if (periodCmp !== 0) return periodCmp;
        const aCode = a.binding.split('#').pop() ?? '';
        const bCode = b.binding.split('#').pop() ?? '';
        return RBU_ORDER.indexOf(aCode) - RBU_ORDER.indexOf(bCode);
      });
  }, [data, chkYear]);

  useEffect(() => {
    dynamicColumnsRef.current = dynamicColumns;
    internalRef.current?.invalidate();
  }, [dynamicColumns]);

  // 입력받은 두 셀이 머지 가능한지 여부 판단
  const _canMerge = (panel: GridPanel, r1: number, c1: number, r2: number, c2: number) => {
    // 규칙1. 에디터블 한 셀이 아닐것
    if (c1 > BASE_COLUMNS.length - 1) {
      return false;
    }
    // 규칙2. 두 셀의 데이터가 일치
    if (panel.getCellData(r1, c1, false) !== panel.getCellData(r2, c2, false)) {
      return false;
    }
    // 규칙3. 현재 열이 첫번째 열이 아니라면, 바로 왼쪽 열의 데이터도 서로 같아야 함.
    if (c1 > 0) {
      for (let i = 0; i < c1; i++) {
        if (panel.getCellData(r1, c1 - i, false) !== panel.getCellData(r2, c2 - i, false)) {
          return false;
        }
      }
    }
    return true;
  };

  return (
    <FlexGrid
      initialized={(g: FlexGridType<MainRow>) => {
        internalRef.current = g;
        if (gridRef && 'current' in gridRef) {
          (gridRef as { current: FlexGridType<MainRow> | null }).current = g;
        }
        g.allowMerging = AllowMerging.ColumnHeaders;
        // AS-IS Dsdm_Changed 1:1 매핑 — cell edit 종료 시 EDIT_FLAG = 'M' 마킹
        // 동적 컬럼 (Y#/M#) 수정만 dirty 처리. BASE 컬럼은 수정 대상 아님.
        g.cellEditEnded.addHandler((_s, e) => {
          const col = g.columns[e.col];
          if (!col?.binding) return;
          if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
          const row = g.rows[e.row].dataItem as MainRow;
          if (row && row.EDIT_FLAG === 'N') row.EDIT_FLAG = 'M';
        });
        // BASE 컬럼 좌측 고정 — 가로 스크롤 시 항상 보임 (admin visible 적용분 기준)
        g.frozenColumns = visibleBaseColumns.length;

        // 2-단 헤더: columnHeaders 패널에 row 1개 추가 (index 0 = period, index 1 = leaf)
        if (g.columnHeaders.rows.length < 2) {
          g.columnHeaders.rows.unshift(new Row());
        }

        // Custom merge manager:
        //   - 동적 컬럼 row 0 (period): 같은 period 인접 컬럼들 가로 머지 (CellRange(0, left, 0, right))
        //   - BASE 컬럼: row 0/1 세로 머지 (CellRange(0, c, 1, c))
        const dynStart = visibleBaseColumns.length;
        class HeaderMergeManager extends MergeManager {
          getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
            if (panel.cellType === CellType.ColumnHeader) {
              // BASE 컬럼: row 0/1 세로 머지
              if (c < dynStart) {
                return new CellRange(0, c, 1, c);
              }
              // 동적 컬럼 row 0: 같은 period 가로 머지
              if (r === 0) {
                const cols = dynamicColumnsRef.current;
                const idx = c - dynStart;
                if (idx < 0 || idx >= cols.length) return null;
                const period = cols[idx].period;
                let left = idx;
                while (left > 0 && cols[left - 1].period === period) left--;
                let right = idx;
                while (right < cols.length - 1 && cols[right + 1].period === period) right++;
                if (left === right) return null;
                return new CellRange(0, dynStart + left, 0, dynStart + right);
              }
            } else if (panel.cellType === CellType.Cell) {
              // ⭐ 2026-06-17 사용자 요구 — viewport 기준 머지 범위 제한 (DMF0004 CustomMergeManager 패턴).
              //   기존: rng.row > 0 / rng.row2 < panel.rows.length - 1 = 전체 row 범위 확장
              //   → 머지 그룹 topmost row 가 viewport 위로 사라지면 cell content 안 보임
              //   변경: viewport 안 (panel.viewRange.row ~ row2) 으로 머지 범위 제한
              //   → scroll 시 viewport 안에서만 머지 그룹화 = 현재 보이는 row 의 첫 row 에 content 표시
              const rng = new CellRange(r, c);
              const minRow = panel.viewRange.row;
              const maxRow = panel.viewRange.row2;
              while (rng.row > minRow && _canMerge(panel, rng.row, c, rng.row - 1, c)) {
                rng.row--;
              }
              while (rng.row2 < maxRow && _canMerge(panel, rng.row2, c, rng.row2 + 1, c)) {
                rng.row2++;
              }
              return rng;
            }
            return super.getMergedRange(panel, r, c, clip);
          }
        }
        g.mergeManager = new HeaderMergeManager();

        // formatItem 으로 row 0/1 의 텍스트 그리기
        //   - 동적 컬럼: row 0 = period, row 1 = leaf
        //   - BASE 컬럼: row 0 = header (세로 머지로 row 1 도 같은 셀)
        // + 룰 12 §11.7 (2026-06-02): 편집 가능 cell coloring
        // + ⭐ wijmo-merge-sticky-content.md (2026-06-17 사용자 요구):
        //   세로 머지된 BASE 컬럼 cell 의 content 를 .merge-content div 로 wrap →
        //   scroll 시 viewport 안에 sticky (현재 row 기준 값 표시).
        g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
          if (e.panel.cellType === CellType.ColumnHeader) {
            const col = e.panel.columns[e.col];
            if (!col) return;
            const dyn = dynamicColumnsRef.current.find(d => d.binding === col.binding);
            if (dyn) {
              e.cell.textContent = e.row === 0 ? dyn.periodLabel : dyn.leafLabel;
            } else {
              // BASE 컬럼: 머지된 셀의 top-left (row 0) 에 header 표시
              e.cell.textContent = e.row === 0 ? (col.header ?? '') : '';
            }
            return;
          }

          // 룰 12 §11.7 cell coloring
          if (e.panel.cellType !== CellType.Cell) return;
          const col2 = e.panel.columns[e.col];
          if (!col2 || !col2.binding) return;

          const isBase =
            col2.binding && !col2.binding.startsWith('Y#') && !col2.binding.startsWith('M#');
          const isRbu999 = col2.binding.endsWith('RBU_0999');
          const isReadOnlyCell = isBase || isRbu999;
          const isEditableCell = !isReadOnlyCell;

          toggleClass(e.cell, 'wj-cell-editable', isEditableCell);
          toggleClass(e.cell, 'wj-cell-non-editable', isReadOnlyCell);

          // 2026-06-17 변경 — translateY sticky content wrap 제거.
          //   대신 HeaderMergeManager Cell case 의 viewport row 제한 (panel.viewRange)
          //   으로 머지 범위 자체를 viewport 안에 제한 (DMF0004 CustomMergeManager 패턴).
          //   scroll 시 invalidate() 호출 → 머지 범위 재계산 → viewport 첫 row 에 content 자동 표시.
        });

        // ⭐ Viewport sticky — scroll 시 grid invalidate → mergeManager 가 새 viewRange 기준 머지 재계산.
        //   DMF0004 CustomMergeManager 의 viewport 기준 제한 패턴.
        const adjustMergedContent = () => {
          g.invalidate();
        };
        g.scrollPositionChanged.addHandler(adjustMergedContent);
        g.updatedView.addHandler(adjustMergedContent);
      }}
      itemsSource={data}
      autoGenerateColumns={false}
      style={{ height: '100%' }}
    >
      {visibleBaseColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.header}
          width={c.width}
          isReadOnly
        />
      ))}
      {dynamicColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.leafLabel}
          width={c.width}
          align='right'
          format='n2'
        />
      ))}
    </FlexGrid>
  );
};
