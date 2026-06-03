import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
  Row,
} from '@mescius/wijmo.grid';
import { toggleClass } from '@mescius/wijmo';
import { useEffect, useMemo, type Ref } from 'react';

import { useTabComboQueries } from '@shared/hooks';

import { MAIN_COLUMNS } from '../sales-future-price.constants';
import type { FuturePriceRow } from '../sales-future-price.types';

import styles from '../SalesFuturePrice.module.scss';

interface Props {
  rows: FuturePriceRow[];
  gridRef: Ref<FlexGridType<FuturePriceRow>>;
  onPopupCellDblClick?: (modalKey: string, row: FuturePriceRow) => void;
  divisionId?: string;
}

// SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과는 wide format —
//   28 fixed cols + 동적 W_YYYYMMDD 또는 M_YYYYMM cols
// FE 가 동적 col binding 을 결과 keys 에서 추출

const getDynKey = (binding: string): { kind: 'W' | 'M' | null; ym: string; mmdd: string; wk: string } => {
  if (/^W_\d{8}$/.test(binding)) {
    const d = binding.slice(2);
    const y = Number(d.slice(0, 4));
    const m = Number(d.slice(4, 6)) - 1;
    const dd = Number(d.slice(6, 8));
    const date = new Date(Date.UTC(y, m, dd));
    const dn = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dn);
    const yStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    const wk = Math.ceil(((date.getTime() - yStart.getTime()) / 86400000 + 1) / 7);
    return { kind: 'W', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, mmdd: `${d.slice(4, 6)}${d.slice(6, 8)}`, wk: `W${String(wk).padStart(2, '0')}` };
  }
  if (/^M_\d{6}$/.test(binding)) {
    const d = binding.slice(2);
    return { kind: 'M', ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`, mmdd: '', wk: '' };
  }
  return { kind: null, ym: '', mmdd: '', wk: '' };
};

export const SalesFuturePriceFlexGrid = ({ rows, gridRef, onPopupCellDblClick, divisionId }: Props) => {
  const fixedBindings = useMemo(() => MAIN_COLUMNS.map(c => c.key), []);

  // ===== Grid 내 combo column dropdown — useTabComboQueries + Wijmo DataMap =====
  //   AS-IS .cs L2029/L2034/L2036/L2038/L2055/L2013 SetCellTypeCombo 정확 매핑
  //   Phase C (2026-06-03): FcstType / CustomsHandbook SCM_ADM_CMBO_SQL_M 등록 완료 → 8종 dropdown
  const divParam = divisionId ?? '40';
  const [divQ, teamQ, ecQ, ssQ, incoQ, currQ, fcstQ, customsQ, bizQ] = useTabComboQueries({
    filters: [
      'MyDivision',
      'TeambyDivision',
      'EndCustomerByDivisionDept',
      'SiteByEndCustomer',
      'Incoterms',
      'CurrencyList',
      { comboId: 'FcstType', divisionId: divParam },
      { comboId: 'CustomsHandbook', divisionId: divParam },
      { comboId: 'BizType', divisionId: divParam },
    ],
  });
  type ComboItem = { CODE?: string; NAME?: string };
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (q: ComboItem[] | undefined): DataMap | null => {
      const arr = q ?? [];
      if (arr.length === 0) return null;
      return new DataMap(arr, 'CODE', 'NAME');
    };
    return {
      DIVISION_ID: make(divQ as never),
      DEPT_ID: make(teamQ as never),
      END_CUSTOMER: make(ecQ as never),
      SCM_SITE_ID: make(ssQ as never),
      INCOTERMS: make(incoQ as never),
      CURRENCY: make(currQ as never),
      FCST_TYPE: make(fcstQ as never),
      DOM_EXP: make(customsQ as never),
      BIZ_TYPE_NAME: make(bizQ as never),
    };
  }, [divQ, teamQ, ecQ, ssQ, incoQ, currQ, fcstQ, customsQ, bizQ]);

  // 동적 컬럼 keys 추출 — SP 결과 모든 row 의 union (insertedRows 의 row 가 첫 자리에 있으면 동적 key 없으므로 첫 row 만 보면 누락)
  const dynBindings = useMemo<string[]>(() => {
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (/^[WM]_\d+$/.test(k)) set.add(k);
      }
    }
    return [...set].sort();
  }, [rows]);

  useEffect(() => {
    const g = (gridRef && 'current' in gridRef ? gridRef.current : null) as FlexGridType<FuturePriceRow> | null;
    if (!g) return;
    // 동적 cols 추가 후 allowMerging 재적용 + combo dataMap 적용
    for (let i = 0; i < g.columns.length; i++) {
      const col = g.columns[i];
      col.allowMerging = true;
      const binding = col.binding ?? '';
      const dm = dataMaps[binding];
      if (dm) col.dataMap = dm;
    }
    g.invalidate(true);
  }, [dynBindings, dataMaps, gridRef]);

  return (
    <div className={styles.gridContainer}>
      <FlexGrid
        className={styles.grid}
        initialized={(g: FlexGridType<FuturePriceRow>) => {
          if (gridRef && 'current' in gridRef) {
            (gridRef as { current: FlexGridType<FuturePriceRow> | null }).current = g;
          }

          // ===== 3-row column header (좌측 fixed + 동적) =====
          if (g.columnHeaders.rows.length === 1) {
            g.columnHeaders.rows.push(new Row());
            g.columnHeaders.rows.push(new Row());
          }
          g.columnHeaders.rows.defaultSize = 24;

          g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
            const col = e.panel.columns[e.col];
            if (!col) return;

            if (e.panel.cellType === CellType.ColumnHeader) {
              const binding = col.binding ?? '';
              const dyn = getDynKey(binding);
              if (dyn.kind === 'W') {
                if (e.row === 0) e.cell.textContent = dyn.ym;
                else if (e.row === 1) e.cell.textContent = dyn.wk;
                else if (e.row === 2) e.cell.textContent = dyn.mmdd;
                (e.cell as HTMLElement).style.textAlign = 'center';
              } else if (dyn.kind === 'M') {
                if (e.row === 0) e.cell.textContent = dyn.ym.slice(0, 4);
                else if (e.row === 1) e.cell.textContent = dyn.ym;
                else if (e.row === 2) e.cell.textContent = dyn.ym.slice(5);
                (e.cell as HTMLElement).style.textAlign = 'center';
              } else if (fixedBindings.includes(binding)) {
                const meta = MAIN_COLUMNS.find(c => c.key === binding);
                e.cell.textContent = meta?.header ?? binding;
                (e.cell as HTMLElement).style.textAlign = 'center';
              }
              return;
            }

            if (e.panel.cellType !== CellType.Cell) return;
            if (!col.binding) return;
            const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: FuturePriceRow })?.dataItem;
            const meta = MAIN_COLUMNS.find(c => c.key === col.binding);
            const isDyn = !meta && /^[WM]_/.test(col.binding);
            const isInsert = rowItem?.CRUD_TYPE === 'I';
            const isLocRow = String(rowItem?.MEASURE ?? '') === 'LOC';

            // 동적 col — LOC row 만 editable (AS-IS L2108: Measure='LOC' 가 아니면 LockRange2)
            if (isDyn) {
              if (isLocRow) toggleClass(e.cell, 'wj-cell-editable', true);
              else toggleClass(e.cell, 'wj-cell-non-editable', true);
              return;
            }

            // Wijmo merge cell 의 textContent 를 inner div (.merge-content) 로 감쌈
            //   scrollPositionChanged 에서 cell.offsetTop 이 viewport 위 → div.style.transform=translateY(scrollOffset) 로 sticky 효과
            if (meta && fixedBindings.includes(col.binding)) {
              const cellEl = e.cell as HTMLElement;
              const text = cellEl.textContent ?? '';
              if (text && !cellEl.querySelector('.merge-content')) {
                const wrap = document.createElement('div');
                wrap.className = 'merge-content';
                wrap.textContent = text;
                wrap.style.cssText = 'padding-top:4px;text-align:center;line-height:18px;will-change:transform;';
                cellEl.textContent = '';
                cellEl.appendChild(wrap);
                cellEl.style.verticalAlign = 'top';
                cellEl.style.padding = '0';
              }
            }

            // Fixed col cell coloring
            //   Insert row 의 IM (필수) + IO (옵션) 모두 editable (사용자 요구 2026-06-03 v3)
            //   MEASURE 는 'S' (read-only, RTF/KRW/USD/LOC 고정)
            //   FPModal (popup) 은 cell 우측에 🔍 돋보기 아이콘 표시 + dblClick popup
            if (meta) {
              const editableForInsert = isInsert && (meta._inputEditType === 'IM' || meta._inputEditType === 'IO');
              if (editableForInsert) {
                toggleClass(e.cell, 'wj-cell-editable', true);
                if (meta._ctrlType === 'FPModal') {
                  const cellEl = e.cell as HTMLElement;
                  cellEl.style.cursor = 'pointer';
                  cellEl.title = `${meta.header} 팝업 (더블클릭)`;
                  // 🔍 돋보기 아이콘 (AS-IS cellTypeImage 동등)
                  cellEl.style.position = 'relative';
                  cellEl.style.paddingRight = '20px';
                  const existingIcon = cellEl.querySelector('.popup-icon');
                  if (!existingIcon) {
                    const icon = document.createElement('span');
                    icon.className = 'popup-icon';
                    icon.textContent = '🔍';
                    icon.style.cssText = 'position:absolute;right:4px;top:50%;transform:translateY(-50%);font-size:11px;pointer-events:none;opacity:0.65;';
                    cellEl.appendChild(icon);
                  }
                }
              } else {
                toggleClass(e.cell, 'wj-cell-non-editable', true);
              }
            }
          });

          // 편집 시작 시 row 단위 제어 — Insert row 만 fixed cols 편집 허용
          //   FPModal popup cell 은 직접 입력 차단 (dblClick popup 만 허용)
          //   동적 col 은 LOC row 만 편집 허용 (AS-IS .cs L2108)
          g.beginningEdit.addHandler((s, e) => {
            const col = s.columns[e.col];
            const binding = col.binding ?? '';
            const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
            const isInsert = row?.CRUD_TYPE === 'I';
            const meta = MAIN_COLUMNS.find(c => c.key === binding);

            // Fixed col — Insert row 의 IM/IO + popup 차단
            if (meta) {
              if (!isInsert) { e.cancel = true; return; }
              if (meta._ctrlType === 'FPModal') { e.cancel = true; return; }
              if (meta._inputEditType === 'S')  { e.cancel = true; return; }
              return;
            }
            // Dynamic col — LOC row 만 편집 허용
            if (/^[WM]_/.test(binding)) {
              if (String(row?.MEASURE ?? '') !== 'LOC') e.cancel = true;
            }
          });

          // Insert row 편집 종료 시 — 같은 INSERT_GROUP_ID 4 measure row 의 좌측 fixed cols 동기화
          g.cellEditEnded.addHandler((s, e) => {
            const col = s.columns[e.col];
            const binding = col.binding ?? '';
            const meta = MAIN_COLUMNS.find(c => c.key === binding);
            if (!meta) return;
            const row = s.rows[e.row].dataItem as FuturePriceRow | undefined;
            if (!row || row.CRUD_TYPE !== 'I') return;
            const gid = row.INSERT_GROUP_ID;
            if (!gid) return;
            const newVal = (row as Record<string, unknown>)[binding];
            const view = s.collectionView;
            const items = view.items as FuturePriceRow[];
            for (const item of items) {
              if (item.CRUD_TYPE === 'I' && item.INSERT_GROUP_ID === gid && item !== row) {
                (item as Record<string, unknown>)[binding] = newVal;
              }
            }
            s.invalidate(true);
          });

          g.hostElement.addEventListener('dblclick', (ev) => {
            const ht = g.hitTest(ev as MouseEvent);
            if (ht.cellType !== CellType.Cell) return;
            const col = g.columns[ht.col];
            const meta = MAIN_COLUMNS.find(c => c.key === col.binding);
            if (meta?._ctrlType !== 'FPModal' || meta._inputEditType !== 'IM') return;
            const row = g.rows[ht.row].dataItem as FuturePriceRow | undefined;
            if (!row || row.CRUD_TYPE !== 'I') return;
            if (meta._modalKey) onPopupCellDblClick?.(meta._modalKey, row);
          });

          // Scroll 시 merge cell content 위치 보정 — 머지 그룹 topmost 가 viewport 위로 가면
          //   .merge-content div 를 translateY 로 끌어내려 현재 visible row 위치에 표시
          //   (Wijmo merge cell 의 default 동작: topmost 만 표시, viewport 밖이면 안 보임)
          const adjustMergedContent = () => {
            const cellsPanel = g.cells;
            const root = cellsPanel.hostElement as HTMLElement | null;
            if (!root) return;
            const visRange = g.viewRange;
            const cellsRoot = root.querySelector('.wj-cells') as HTMLElement | null;
            const viewportTop = cellsRoot?.scrollTop ?? root.scrollTop ?? 0;
            const mergeCells = root.querySelectorAll<HTMLElement>('.wj-cell .merge-content');
            mergeCells.forEach(div => {
              const cellEl = div.parentElement as HTMLElement;
              if (!cellEl) return;
              const cellTop = cellEl.offsetTop;
              const cellH = cellEl.offsetHeight;
              const stickyOffset = viewportTop - cellTop;
              if (stickyOffset > 0 && stickyOffset < cellH - 24) {
                div.style.transform = `translateY(${stickyOffset}px)`;
              } else {
                div.style.transform = 'translateY(0)';
              }
            });
            void visRange;
          };
          g.scrollPositionChanged.addHandler(adjustMergedContent);
          g.updatedView.addHandler(adjustMergedContent);

          // ===== 머지 활성 (Wijmo API: g.allowMerging + g.mergeManager) =====
          //   AllowMerging.All = ColumnHeaders | RowHeaders | Cells (헤더 + 데이터 cell 모두)
          g.allowMerging = AllowMerging.All;

          // 좌측 fixed cols + 동적 cols ColumnHeader 의 allowMerging 강제 (column 단위 flag)
          for (let i = 0; i < g.columns.length; i++) {
            g.columns[i].allowMerging = true;
          }

          // MergeManager subclass — 헤더 + Cell 계층 머지 (사용자 요구 2026-06-03 v5):
          //   Wijmo cell merge 유지 (시각 통합) — getMergedRange 가 같은 그룹 range 반환
          //   추가: scrollPositionChanged event 로 머지 cell content 를 viewport 안 visible 영역 의 top 으로 강제 조정 (아래)
          class HierarchicalMergeManager extends MergeManager {
            getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
              const col = panel.columns[c];
              if (!col) return null;
              const binding = col.binding ?? '';

              // ===== ① Data Cell — 좌측 fixed cols 계층 머지 =====
              if (panel.cellType === CellType.Cell && fixedBindings.includes(binding)) {
                const view = panel.rows;
                const rowItem = (i: number): Record<string, unknown> | undefined =>
                  (view[i] as unknown as { dataItem?: Record<string, unknown> })?.dataItem;
                const cur = rowItem(r);
                if (!cur) return null;
                const fixedIdx = fixedBindings.indexOf(binding);
                const leftBindings = fixedBindings.slice(0, fixedIdx + 1);
                const sameRow = (a: number, b: number): boolean => {
                  const ra = rowItem(a); const rb = rowItem(b);
                  if (!ra || !rb) return false;
                  return leftBindings.every(k => String(ra[k] ?? '') === String(rb[k] ?? ''));
                };
                let r1 = r, r2 = r;
                while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
                while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
                if (r1 === r2) return null;
                return new CellRange(r1, c, r2, c);
              }

              // ===== ② ColumnHeader =====
              if (panel.cellType === CellType.ColumnHeader) {
                // 좌측 fixed: row 0~2 vertical merge
                if (fixedBindings.includes(binding)) {
                  return new CellRange(0, c, 2, c);
                }
                // 동적 W: row 0 (YYYY-MM) horizontal merge / row 1 (Wxx) horizontal merge
                const dyn = getDynKey(binding);
                if (dyn.kind === 'W') {
                  if (r === 0) {
                    let c1 = c, c2 = c;
                    while (c1 > 0) {
                      const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                      if (p.kind === 'W' && p.ym === dyn.ym) c1--;
                      else break;
                    }
                    while (c2 < panel.columns.length - 1) {
                      const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                      if (n.kind === 'W' && n.ym === dyn.ym) c2++;
                      else break;
                    }
                    return new CellRange(0, c1, 0, c2);
                  }
                  if (r === 1) {
                    let c1 = c, c2 = c;
                    while (c1 > 0) {
                      const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                      if (p.kind === 'W' && p.wk === dyn.wk && p.ym === dyn.ym) c1--;
                      else break;
                    }
                    while (c2 < panel.columns.length - 1) {
                      const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                      if (n.kind === 'W' && n.wk === dyn.wk && n.ym === dyn.ym) c2++;
                      else break;
                    }
                    return new CellRange(1, c1, 1, c2);
                  }
                } else if (dyn.kind === 'M') {
                  if (r === 0) {
                    const yr = dyn.ym.slice(0, 4);
                    let c1 = c, c2 = c;
                    while (c1 > 0) {
                      const p = getDynKey(panel.columns[c1 - 1].binding ?? '');
                      if (p.kind === 'M' && p.ym.slice(0, 4) === yr) c1--;
                      else break;
                    }
                    while (c2 < panel.columns.length - 1) {
                      const n = getDynKey(panel.columns[c2 + 1].binding ?? '');
                      if (n.kind === 'M' && n.ym.slice(0, 4) === yr) c2++;
                      else break;
                    }
                    return new CellRange(0, c1, 0, c2);
                  }
                }
              }
              return null;
            }
          }
          g.mergeManager = new HierarchicalMergeManager();
        }}
        itemsSource={rows}
        autoGenerateColumns={false}
        allowSorting={true}
        style={{ height: '100%' }}
      >
        {/* 좌측 15 fixed cols — meta._inputEditType 'S' (read-only) 만 isReadOnly, 나머지는 row 단위로 beginningEdit 에서 제어 */}
        {MAIN_COLUMNS.map(c => (
          <FlexGridColumn
            key={c.key}
            binding={c.key}
            header={c.header}
            width={c.width}
            align={c.align === 'C' ? 'center' : c.align === 'R' ? 'right' : 'left'}
            isReadOnly={c._inputEditType === 'S'}
          />
        ))}

        {/* 동적 W_yyyymmdd / M_yyyymm — SP 결과 keys 에서 추출 (소수 3자리, 사용자 요구 2026-06-03) */}
        {dynBindings.map(b => (
          <FlexGridColumn
            key={b}
            binding={b}
            header={b}
            width={90}
            align='right'
            format='n3'
          />
        ))}
      </FlexGrid>
    </div>
  );
};
