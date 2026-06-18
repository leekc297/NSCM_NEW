import { toggleClass } from '@mescius/wijmo';
import type { FlexGrid as FlexGridType, FormatItemEventArgs, GridPanel } from '@mescius/wijmo.grid';
import { AllowMerging, CellRange, CellType, MergeManager, Row } from '@mescius/wijmo.grid';
import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { type RefObject, useEffect, useMemo, useRef } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import { BASE_COLUMN_COUNT, MENU_ID, SHEETS } from '../contribute-view.constants';
import { buildColumnMeta, type ColumnMeta } from '../hooks/useContributeViewExpression';
import type { SalesViewRow, SpreadTitleRow } from '../types';
import { useContributeViewStore } from '../useContributeViewStore';

import styles from './ContributeViewGrid.module.scss';

interface Props {
  gridRef: RefObject<FlexGridType<SalesViewRow> | null>;
  data: SalesViewRow[];
}

// AS-IS DMF0043_Contribute_View.cs InitSpread + SetSpreadHeaderSpan
//
// 사용자 요구 (2026-06-01):
//   - 좌측 고정 (frozen): 년월(YYYYMM) ~ Biz(DM_BIZ_TYPE) 9 컬럼
//   - 동적: 2-row 헤더
//     * Row 0 (상단): 지역 (대만/중국-화남/.../합계) = LARGE_CLASS_LABEL_NAME
//     * Row 1 (하단): Commission/Markup = COLUMN_LABEL_NAME (leaf)
//   - readonly grid — AS-IS L342: siMain.LockColumn(0, Max, true)
//   - 룰 12 §11.5: frozenColumns = BASE_COLUMN_COUNT (= 9)
//   - 룰 27 §F: FlexGridColumnGroup JSX single-child 회피 — flat 컬럼 + HeaderMergeManager
export const ContributeViewGrid = ({ gridRef, data }: Props) => {
  const internalRef = useRef<FlexGridType<SalesViewRow> | null>(null);
  const columnMetaRef = useRef<ColumnMeta[]>([]);

  const titleFilter = useContributeViewStore(s => s.filters[SHEETS.MAIN_TITLE]);

  // AS-IS InitSpread: DMF0043_GET_SALES_LIST_SPREAD_TITLE
  const { data: titleData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN_TITLE,
    tabId: MENU_ID,
    filters: titleFilter,
    enabled: !!titleFilter,
  });

  // SP body 가 SORT_ORDER_NO 기준 정렬 + DISTINCT 처리됨 → FE dedup 불필요
  const titleRows = useMemo<SpreadTitleRow[]>(
    () => (titleData?.o_rc1 ?? []) as unknown as SpreadTitleRow[],
    [titleData]
  );

  // 첫 BASE_COLUMN_COUNT 개 = BASE (고정), 나머지 = dynamic (지역×Type)
  const columnMetas = useMemo<ColumnMeta[]>(
    () => buildColumnMeta(titleRows, BASE_COLUMN_COUNT),
    [titleRows]
  );

  // useEffect(() => {
  //   columnMetaRef.current = columnMetas;
  //   internalRef.current?.invalidate();
  // }, [columnMetas]);

  useEffect(() => {
    columnMetaRef.current = columnMetas;
    const g = internalRef.current;
    // Wijmo refresh() 가 내부 finishEditing() 을 호출하는데, edit cycle 중간이면
    // null 접근으로 폭발. read-only grid 라도 발생 가능 (rAF 로 deferral).
    if (g && g.hostElement && g.hostElement.isConnected) {
      requestAnimationFrame(() => {
        try {
          g.invalidate();
        } catch {
          /* Wijmo internal refresh timing — safe to ignore */
        }
      });
    }
  }, [columnMetas]);

  // ⭐ ColumnSettingModal OK 결과 반영 — store.visibleBaseColumns 에 매칭되는 base 만 표시.
  //   빈 array = default (모든 base 컬럼 visible).
  const visibleBaseColumnsList = useContributeViewStore(s => s.visibleBaseColumns);
  const baseColumns = useMemo<ColumnMeta[]>(() => {
    const all = columnMetas.filter(m => m.isBase);
    if (visibleBaseColumnsList.length === 0) return all;
    const visibleSet = new Set(visibleBaseColumnsList);
    return all.filter(m => visibleSet.has(m.binding));
  }, [columnMetas, visibleBaseColumnsList]);
  const dynamicColumns = useMemo<ColumnMeta[]>(
    () => columnMetas.filter(m => !m.isBase && !m.isHidden),
    [columnMetas]
  );

  // frozenColumns / dynStart 는 actual baseColumns.length 추적 (BASE_COLUMN_COUNT 상수 X).
  const baseCountRef = useRef(BASE_COLUMN_COUNT);
  useEffect(() => {
    baseCountRef.current = baseColumns.length;
    const g = internalRef.current;
    if (g) g.frozenColumns = baseColumns.length;
  }, [baseColumns.length]);

  const mergingColums = new Set([
    'YYYYMM',
    'DEPARTMENT_NAME',
    'DEPT_NAME',
    'CUST_REPORT',
    'END_CUST_REPORT',
    'SHIPTO_CODE',
  ]);

  const setColumnName = (val: string) => {
    if (val.includes('#')) {
      return val.toUpperCase();
    }
    return val;
  };

  return (
    <>
      {/* <div>{ JSON.stringify(baseColumns) }</div>
      <div>{ JSON.stringify(dynamicColumns) }</div> */}

      <FlexGrid
        initialized={(g: FlexGridType<SalesViewRow>) => {
          internalRef.current = g;
          if (gridRef && 'current' in gridRef) {
            (gridRef as { current: FlexGridType<SalesViewRow> | null }).current = g;
          }
          g.isReadOnly = true;
          g.allowMerging = AllowMerging.ColumnHeaders;

          // 룰 12 §11.5: BASE 컬럼 좌측 고정
          g.frozenColumns = BASE_COLUMN_COUNT;

          // 2-row 헤더 (Row 0 = 지역, Row 1 = Commission/Markup)
          while (g.columnHeaders.rows.length < 2) {
            g.columnHeaders.rows.unshift(new Row());
          }

          // Custom merge manager — BASE 컬럼 row 0/1 세로 머지 + 동적 컬럼 row 0 (지역) 가로 머지
          // ⭐ dynStart 는 매 호출 시 baseCountRef.current (= 실 표시 base 수) 사용 — ColumnSetting 반영.
          class HeaderMergeManager extends MergeManager {
            getMergedRange(panel: GridPanel, r: number, c: number, clip = true): CellRange | null {
              const dynStart = baseCountRef.current;
              if (panel.cellType === CellType.ColumnHeader) {
                // BASE 컬럼: row 0/1 세로 머지
                if (c < dynStart) {
                  return new CellRange(0, c, 1, c);
                }
                // 동적 row 0: 같은 LARGE_CLASS_LABEL_NAME 인접 컬럼 가로 머지
                if (r === 0) {
                  const metas = columnMetaRef.current;
                  const idx = c;
                  if (idx >= metas.length) return null;
                  const large = metas[idx].large;
                  if (!large) return null;
                  let left = idx;
                  while (
                    left > dynStart &&
                    metas[left - 1].large === large &&
                    !metas[left - 1].isBase
                  )
                    left--;
                  let right = idx;
                  while (
                    right < metas.length - 1 &&
                    metas[right + 1].large === large &&
                    !metas[right + 1].isBase
                  )
                    right++;
                  if (left === right) return null;
                  return new CellRange(0, left, 0, right);
                }
              }

              // 🔥 [추가 코드] 일반 데이터 셀 영역 위아래(세로) 머지 처리
              if (panel.cellType === CellType.Cell) {
                // 해당 컬럼이 머지 가능하도록 설정되어 있는지 확인
                const col = panel.columns[c];

                if (col?.allowMerging) {
                  // 위아래로 동일한 값을 가진 행의 범위를 찾습니다.
                  // ⭐ viewport row 제한 (wijmo-merge-sticky-content.md v4, 2026-06-18)
                  let top = r;
                  let bottom = r;
                  const val = panel.getCellData(r, c, false);
                  const minRow = panel.viewRange.row;
                  const maxRow = panel.viewRange.row2;

                  // 위쪽으로 동일한 값이 있는지 확인 (viewport 시작까지)
                  while (top > minRow && panel.getCellData(top - 1, c, false) === val) {
                    top--;
                  }
                  // 아래쪽으로 동일한 값이 있는지 확인 (viewport 끝까지)
                  while (
                    bottom < maxRow &&
                    panel.getCellData(bottom + 1, c, false) === val
                  ) {
                    bottom++;
                  }

                  // 위아래로 머지할 타겟이 있다면 CellRange 반환 (세로 머지이므로 컬럼 c는 고정)
                  if (top !== bottom) {
                    if (mergingColums.has(col.binding as string) && c > 0) {
                      // 해당 컬럼에 위아래로 여러 셀이 동일한 값이 있을 수는 있지만 이전 컬럼에 머지 범위에 속해 있는지 판단하여 머지를 해야 할지 말지를 판단하는 로직
                      /**
                       * 머지가 적용 되기 전 그리드
                       * ----------------------------
                       *   Cate A | Cate B |  Cate C
                       * ----------------------------
                       *    A1    |   B1   |   1
                       * ----------------------------
                       *    A1    |   B1   |   1
                       * ----------------------------
                       *    A1    |   B2   |   1      <-- 이렇게 앞에 Cate C의 값은 위아래 여러 셀이 같지만 Cate B가 다르기 때문에 머지 영역을 앞 머지 영역을 따라 정해줘야 한다.
                       * ----------------------------
                       *    A1    |   B2   |   1
                       * ----------------------------
                       *
                       *  잘못된 머지
                       * ----------------------------
                       *   Cate A | Cate B |  Cate C
                       * ----------------------------
                       *          |        |
                       *          |   B1   |
                       *    A1    |--------|    1
                       *          |        |
                       *          |   B2   |
                       * ----------------------------
                       *
                       * 아래 로직을 적용 시켰을 때의 정상적인 머지
                       * ----------------------------
                       *   Cate A | Cate B |  Cate C
                       * ----------------------------
                       *          |        |
                       *          |   B1   |   1
                       *    A1    |--------|---------
                       *          |        |
                       *          |   B2   |   1
                       * ----------------------------
                       */
                      let prevTop = r;
                      let prevbottom = r;
                      const prevVal = panel.getCellData(r, c - 1, false);

                      // 위쪽으로 동일한 값이 있는지 확인
                      while (
                        prevTop > 0 &&
                        panel.getCellData(prevTop - 1, c - 1, false) === prevVal
                      ) {
                        prevTop--;
                      }
                      // 아래쪽으로 동일한 값이 있는지 확인
                      while (
                        prevbottom < panel.rows.length - 1 &&
                        panel.getCellData(prevbottom + 1, c - 1, false) === prevVal
                      ) {
                        prevbottom++;
                      }

                      if (top < prevTop) {
                        top = prevTop;
                      }

                      if (bottom > prevbottom) {
                        bottom = prevbottom;
                      }

                      let cnt = 0;
                      for (let i = 0; i < c; i++) {
                        if (
                          panel.getCellData(top, i, false) === panel.getCellData(bottom, i, false)
                        ) {
                          cnt++;
                        }
                      }
                      if (cnt === c) {
                        return new CellRange(top, c, bottom, c);
                      }
                    }
                    if (c === 0) {
                      return new CellRange(top, c, bottom, c);
                    }
                  }
                }
              }
              return super.getMergedRange(panel, r, c, clip);
            }
          }
          g.mergeManager = new HeaderMergeManager();
          // ⭐ viewport sticky — scroll 시 머지 재계산 (wijmo-merge-sticky-content.md v4, 2026-06-18)
          g.scrollPositionChanged.addHandler(() => g.invalidate());

          // formatItem — row 0/1 별 텍스트 그리기 + 룰 12 §11.7 (2026-06-02) cell coloring
          // 조회 전용 화면 — 모든 cell 회색 (wj-cell-non-editable)
          //
          // ⭐ 2026-06-17 fix — dynamic 컬럼 binding case-insensitive 매칭:
          //   FlexGridColumn 의 binding = setColumnName(c.binding) = 대문자 (# 포함 시).
          //   반면 columnMetaRef 의 m.binding = SP 응답 원본 (mixed case 가능) → find 실패 가능.
          //   사고: row 0 (LARGE_CLASS_LABEL_NAME 상단 지역명) textContent 빈 셀.
          //   fix: # 포함 dynamic 컬럼은 대문자 변환 후 비교.
          g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
            if (e.panel.cellType === CellType.ColumnHeader) {
              const col = e.panel.columns[e.col];
              if (!col) return;
              const colBind = col.binding ?? '';
              const meta = columnMetaRef.current.find(m => {
                const mb = m.binding ?? '';
                if (mb === colBind) return true;
                // dynamic 컬럼 (# 포함) — setColumnName 으로 대문자 변환 매칭
                if (mb.includes('#') && mb.toUpperCase() === colBind) return true;
                return false;
              });
              if (!meta) return;
              if (meta.isBase) {
                e.cell.textContent = e.row === 0 ? meta.leaf : '';
              } else {
                if (e.row === 0) e.cell.textContent = meta.large;
                else if (e.row === 1) e.cell.textContent = meta.leaf;
              }
              return;
            }
            if (e.panel.cellType === CellType.Cell) {
              toggleClass(e.cell, 'wj-cell-non-editable', true);
            }
          });
        }}
        itemsSource={data}
        autoGenerateColumns={false}
        className={styles.grid}
      >
        {baseColumns.map(c => (
          <FlexGridColumn
            key={c.binding}
            binding={c.binding}
            header={c.leaf}
            width={Math.max(c.width, 110)}
            allowMerging={mergingColums.has(c.binding)}
            isReadOnly
          />
        ))}
        {dynamicColumns.map(c => (
          <FlexGridColumn
            key={setColumnName(c.binding)}
            binding={setColumnName(c.binding)}
            header={c.leaf}
            width={c.width}
            align='right'
            format='n0'
            isReadOnly
          />
        ))}
      </FlexGrid>
    </>
  );
};
