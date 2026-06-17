import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  MergeManager,
  Row,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
} from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { type RefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { MainRow } from '../types';
import { useContributeMainStore } from '../useContributeMainStore';

interface Props {
  gridRef: RefObject<FlexGridType<MainRow>>;
  data: MainRow[];
  // ⭐ UI 동적 속성관리 (master hook §4) — admin SYS0004 메타 (BASE 컬럼 visible/width/label override)
  staticColumns?: RawFlexGridColumnConfig[];
}

// AS-IS .cs DefColumns + SP DMF0043_GET_CONTRIBUTE_MAIN_DATA cursor alias 기준 6개 컬럼
// (2026-06-17 ⭐ Step 2 정정: SP cursor 가 DEPARTMENT_ID / DEPT_ID alias 반환.
//  이전 binding 'DEPARTMENT_NAME' / 'DEPT_NAME' 은 row data 매칭 실패 + SHEET_COLUMNS 와도 mismatch.
//  header label 은 admin SHEET_COLUMNS.COLUMN_LABEL_NAME 으로 동적 override — v6 baseColumns useMemo §4.)
//   DEPARTMENT_ID  → 부문 (admin COLUMN_LABEL_NAME 으로 한글명 override)
//   DEPT_ID        → 팀
//   END_CUST_REPORT (← ATTRIBUTE2)        → 고객군
//   SOLDTO_CUST_REPORT (← CUST_GROUP_DTL) → 판매처
//   PRODUCT_GROUP (← REPORT_GROUP3)        → 제품군
//   DM_BIZ_TYPE (← FORECAST_INFO_BIZ_TYPE) → 형태
const BASE_COLUMNS = [
  { binding: 'DEPARTMENT_ID', header: '부문', width: 180 },
  { binding: 'DEPT_ID', header: '팀', width: 200 },
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
const RBU_ORDER = ['RBU_0001', 'RBU_0002', 'RBU_0008', 'RBU_0003', 'RBU_0004', 'RBU_0005', 'RBU_0007', 'RBU_0006', 'RBU_0999'];

interface DynColMeta {
  binding: string;
  period: string;        // '202401'
  periodLabel: string;   // '2024-01'
  leafLabel: string;     // '대만'
  width: number;
}

// admin SYS0004 UI Category Setup 메타 전체를 보존하는 BASE 컬럼 머지 결과 (2026-06-17 v2)
interface MergedBaseColumn {
  binding: string;
  header: string;
  width: number;
  align: 'left' | 'right' | 'center';
  format?: string;
  isReadOnly: boolean;
  ctrlType?: string;
  comboKey?: string;
  modalKey?: string;
}

// AS-IS analysis.md §10 다단 헤더 (Row0: 연도/월, Row1: RBU 한글명).
// 사용자 요구: Y# (연도 단독) 컬럼 제거, M# (월별) 만 유지.
// 룰 27 §F: ColumnGroup wijmo bundle 중복으로 폭발 → 옵션 4 패턴.
//   flat columns + columnHeaders.rows.push(new Row()) + custom mergeManager + formatItem.
export const ContributeMainGrid = ({ gridRef, data, staticColumns }: Props) => {
  const internalRef = useRef<FlexGridType<MainRow> | null>(null);
  const dynamicColumnsRef = useRef<DynColMeta[]>([]);

  // ⭐ master hook §4 — admin 메타 override (column 전체 속성 동기화)
  // 정책 (2026-06-17 v5 — BE 변경 없이 작동 보장):
  //   BE 가 retrieveGridColumns 의 visible/division filter 를 하든 안 하든 (DMF0004 reference 처럼 filter 없음)
  //   FE 가 자체적으로 staticColumns 의 visible 검사 + BASE_COLUMNS 와의 매칭 처리:
  //   - staticColumns 가 빈 배열 (BE 미동작/메타 미등록) → BASE_COLUMNS fallback (안전망)
  //   - staticColumns 에 BASE binding 없음 = admin SHEET_COLUMNS 미등록 → BASE_COLUMNS fallback (안전)
  //   - staticColumns 에 BASE binding 있음 + sc.visible !== false → 표시 + admin 메타 override
  //   - staticColumns 에 BASE binding 있음 + sc.visible === false → 표시 X (admin 결정 보존)
  // 동기화 속성: header (colLblNm) / width (colWth) / align (horzAlgnCd) / scale (format='nN') /
  //              inputTpCd (isReadOnly) / cellCtrlObjTpCd / cellCboDataTp / attribute1 (metadata 보존)
  const baseColumns = useMemo<MergedBaseColumn[]>(() => {
    if (!staticColumns || staticColumns.length === 0) {
      // BE 응답 0건 = BE 미동작 → 안전망으로 BASE_COLUMNS fallback
      return BASE_COLUMNS.map(c => ({
        binding: c.binding,
        header: c.header,
        width: c.width,
        align: 'left',
        isReadOnly: true,
      }));
    }
    // ⭐ 2026-06-17 v6 — DMF0004 reference 패턴 (사용자 명시):
    //   staticColumns 가 단일 진실 source. BE 가 admin SHEET_COLUMNS 등록 + visible='Y' + (filter 있을 시) 통과한 row 만 반환.
    //   FE 는 BE 응답 안 BASE binding 매칭만 표시 (메타 미등록 = 표시 X).
    //   추가 안전: sc.visible === false 시도 명시 제외 (BE filter 없는 환경에서도 admin 결정 보존).
    return BASE_COLUMNS
      .map(c => ({ c, sc: staticColumns.find(s => s.colNm === c.binding) }))
      .filter(({ sc }) => sc !== undefined && sc.visible !== false)
      .map(({ c, sc }) => {
        return {
          binding: c.binding,
          header: sc?.colLblNm || c.header,
          width: sc?.colWth != null ? Number(sc.colWth) : c.width,
          align:
            sc?.horzAlgnCd === 'R' ? 'right' :
            sc?.horzAlgnCd === 'C' ? 'center' :
            'left',
          format: sc?.scale != null ? `n${Number(sc.scale)}` : undefined,
          isReadOnly: sc?.inputTpCd ? sc.inputTpCd === 'S' : true,
          ctrlType: sc?.cellCtrlObjTpCd,
          comboKey: sc?.cellCboDataTp,
          modalKey: sc?.attribute1,
        };
      });
  }, [staticColumns]);

  // AS-IS chkYear: true → Y# (연도총계) 만 / false → M# (월별) 만
  const chkYear = useContributeMainStore(s => s.searchCondition.chkYear);

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
          leafLabel: RBU_NAME_MAP[corp ?? ''] ?? (corp ?? ''),
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

  return (
    <FlexGrid
      initialized={(g: FlexGridType<MainRow>) => {
        internalRef.current = g;
        if (gridRef && 'current' in gridRef) {
          (gridRef as { current: FlexGridType<MainRow> | null }).current = g;
        }
        g.allowMerging = AllowMerging.ColumnHeaders | AllowMerging.Cells;
        // AS-IS Dsdm_Changed 1:1 매핑 — cell edit 종료 시 EDIT_FLAG = 'M' 마킹
        // 동적 컬럼 (Y#/M#) 수정만 dirty 처리. BASE 컬럼은 수정 대상 아님.
        g.cellEditEnded.addHandler((_s, e) => {
          const col = g.columns[e.col];
          if (!col?.binding) return;
          if (!col.binding.startsWith('Y#') && !col.binding.startsWith('M#')) return;
          const row = g.rows[e.row].dataItem as MainRow;
          if (row && row.EDIT_FLAG === 'N') row.EDIT_FLAG = 'M';
        });
        // BASE 6 컬럼 (부문/팀/고객군/판매처/제품군/형태) 좌측 고정 — 가로 스크롤 시 항상 보임
        g.frozenColumns = BASE_COLUMNS.length;

        // 2-단 헤더: columnHeaders 패널에 row 1개 추가 (index 0 = period, index 1 = leaf)
        if (g.columnHeaders.rows.length < 2) {
          g.columnHeaders.rows.unshift(new Row());
        }

        // Custom merge manager:
        //   - ColumnHeader BASE: row 0/1 세로 머지
        //   - ColumnHeader 동적 row 0: 같은 period 가로 머지
        //   - Cell BASE (부문~형태 6 col): 좌측 모든 allowMerging col 동일 row 끼리 세로 머지 (계층적, DMF0072 패턴)
        const dynStart = BASE_COLUMNS.length;
        class HeaderMergeManager extends MergeManager {
          getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
            if (panel.cellType === CellType.ColumnHeader) {
              if (c < dynStart) {
                return new CellRange(0, c, 1, c);
              }
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
              return null;
            }
            if (panel.cellType === CellType.Cell) {
              const col = panel.columns[c];
              if (!col || !col.allowMerging) return null;
              const mergeColIdx: number[] = [];
              for (let i = 0; i <= c; i++) {
                if (panel.columns[i] && panel.columns[i].allowMerging) mergeColIdx.push(i);
              }
              if (mergeColIdx.length === 0) return null;
              const sameAcrossKeys = (rowA: number, rowB: number): boolean =>
                mergeColIdx.every(ci => {
                  const a: unknown = panel.getCellData(rowA, ci, false);
                  const b: unknown = panel.getCellData(rowB, ci, false);
                  return a === b;
                });
              let r1 = r;
              let r2 = r;
              while (r1 > 0 && sameAcrossKeys(r1 - 1, r)) r1--;
              const rowCnt = panel.rows.length;
              while (r2 < rowCnt - 1 && sameAcrossKeys(r2 + 1, r)) r2++;
              if (r1 === r2) return null;
              return new CellRange(r1, c, r2, c);
            }
            return super.getMergedRange(panel, r, c, clip);
          }
        }
        g.mergeManager = new HeaderMergeManager();

        // formatItem 으로 row 0/1 의 텍스트 그리기
        //   - 동적 컬럼: row 0 = period, row 1 = leaf
        //   - BASE 컬럼: row 0 = header (세로 머지로 row 1 도 같은 셀)
        // + 룰 12 §11.7 (2026-06-02): 편집 가능 cell coloring
        //   - BASE 6 컬럼 → wj-cell-non-editable (회색)
        //   - 동적 컬럼 RBU_0999 (구분 — As-Is L388) → wj-cell-non-editable (회색)
        //   - 동적 컬럼 그 외 (Y#/M#) → wj-cell-editable (노란)
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

          const isBase = col2.binding && !col2.binding.startsWith('Y#') && !col2.binding.startsWith('M#');
          const isRbu999 = col2.binding.endsWith('RBU_0999');
          const isReadOnlyCell = isBase || isRbu999;
          const isEditableCell = !isReadOnlyCell;

          toggleClass(e.cell, 'wj-cell-editable', isEditableCell);
          toggleClass(e.cell, 'wj-cell-non-editable', isReadOnlyCell);
        });
      }}
      itemsSource={data}
      autoGenerateColumns={false}
      style={{ height: '100%' }}
    >
      {/* ⭐ master hook §4 (v2 2026-06-17) — admin SYS0004 메타 전체 동기화:
          visible (BE 미리 filter) / header (colLblNm) / width (colWth) / align (horzAlgnCd) /
          format (scale → 'nN') / isReadOnly (inputTpCd='S'). cellCtrlObjTpCd/cellCboDataTp/
          attribute1 은 BASE 6 컬럼 (부문/팀/고객군/판매처/제품군/형태) 이 모두 readonly text 라
          현재 미사용 — admin 에서 변경 시 추후 확장 (메타는 c.ctrlType/comboKey/modalKey 로 보존). */}
      {baseColumns.map(c => (
        <FlexGridColumn
          key={c.binding}
          binding={c.binding}
          header={c.header}
          width={c.width}
          align={c.align}
          format={c.format}
          isReadOnly={c.isReadOnly}
          allowMerging
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
