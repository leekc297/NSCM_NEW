import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
  Row,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { EXCHANGE_RATE_COLUMNS, MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

interface ExchangeRow {
  DIVISION_ID?: string;
  YYYYMMDD?: string;
  YYYYMM?: string;
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  [yyyymmKey: string]: string | number;
}

// AS-IS DMF0020_SalesFuturePricePopUp.cs L141~194 InitSpread + L324~334 PIVOT 클라이언트 측 변환
//   SP P_DMF0020_GET_FUTUREPRICE_INFO (long format) → grid wide format
//   동적 col binding = `M_yyyymm` (캡쳐 2-row header: YYYY / MM)
//   좌측 fixed cols Restricted merge (Division / Currency)
export const ExchangeRateModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => {
  const setAlert = useMessageStore.getState().setAlert;
  const [divisionId, setDivisionId] = useState(defaultDivision);
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultPeriod.start);
      setPeriodTo(defaultPeriod.end);
    }
  }, [open, defaultDivision, defaultPeriod]);

  // sheet 'exchange' — SP PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (4 IN + 2 OUT, divisionId 인자 없음)
  //   filters useMemo 안정화 + enabled false + Find 트리거 (refetch loop 방지)
  const startYyyymmdd = periodFrom.length === 6 ? `${periodFrom}01` : periodFrom;
  const endYyyymmdd = periodTo.length === 6 ? `${periodTo}31` : periodTo;
  const filters = useMemo(
    () => ({ startYyyymmdd, endYyyymmdd } as never),
    [startYyyymmdd, endYyyymmdd],
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    filters,
    enabled: false,
  });

  const allRows = (data?.o_rc1 ?? []) as ExchangeRow[];
  const filteredRows = divisionId && divisionId !== 'ALL'
    ? allRows.filter(r => String(r.DIVISION_ID ?? '') === divisionId)
    : allRows;

  // ===== long → wide pivot (사용자 요구 2026-06-03: AS-IS 2단 헤더 YYYY/MM) =====
  const { pivotRows, ymKeys } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
    const ymSet = new Set<string>();
    for (const r of filteredRows) {
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      const uc = String(r.UNIT_CURRENCY ?? '');
      const ym = String(r.YYYYMM ?? '');
      if (!div || !cur || !uc || !ym) continue;
      ymSet.add(ym);
      const key = `${div}|${cur}|${uc}`;
      if (!groupMap.has(key)) {
        groupMap.set(key, { DIVISION_ID: div, CURRENCY: cur, UNIT_CURRENCY: uc });
      }
      const row = groupMap.get(key)!;
      const price = typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
      if (!Number.isNaN(price)) row[`M_${ym}`] = price;
    }
    const list = [...groupMap.values()].sort((a, b) => {
      if (a.DIVISION_ID !== b.DIVISION_ID) return a.DIVISION_ID.localeCompare(b.DIVISION_ID);
      if (a.CURRENCY !== b.CURRENCY) return a.CURRENCY.localeCompare(b.CURRENCY);
      return a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY);
    });
    const ymSorted = [...ymSet].sort();
    return { pivotRows: list, ymKeys: ymSorted };
  }, [filteredRows]);

  const fixedBindings = useMemo(() => EXCHANGE_RATE_COLUMNS.map(c => c.key), []);
  const loading = isLoading || isFetching;

  const handleFind = () => {
    if (periodFrom > periodTo) {
      void setAlert({ type: 'alert', content: '[MSG00108] 시작 월이 종료 월보다 늦을 수 없습니다.' });
      return;
    }
    refetch?.();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 12, height: 12, background: '#1976d2', borderRadius: '50%' }} />
          <h2 style={{ fontSize: 16, fontWeight: 600, margin: 0 }}>Exchange Rate</h2>
        </div>
      }
      customContentArea={
        <div className={styles.container}>
          <div className={styles.filterRow}>
            <label>Div
              <select value={divisionId} onChange={e => setDivisionId(e.target.value)}>
                <option value='ALL'>ALL</option>
                <option value='40'>40</option>
                <option value='81'>81</option>
                <option value='82'>82</option>
              </select>
            </label>
            <label>Period
              <input type='text' value={periodFrom} onChange={e => setPeriodFrom(e.target.value)} placeholder='YYYY-MM' />
            </label>
            <span>~</span>
            <label>
              <input type='text' value={periodTo} onChange={e => setPeriodTo(e.target.value)} placeholder='YYYY-MM' />
            </label>
            <button type='button' onClick={handleFind} className={styles.findBtn} disabled={loading}>
              {loading ? '⏳ 조회 중...' : '🔍 Find'}
            </button>
            <button type='button' onClick={modalClose} className={styles.closeBtn}>❌ Close</button>
            <span style={{ marginLeft: 'auto', fontSize: 12, color: '#6b7785' }}>
              {loading ? '데이터 조회 중' : `${pivotRows.length} rows`}
            </span>
          </div>

          <div className={styles.gridWrap}>
            <FlexGrid
              itemsSource={pivotRows}
              autoGenerateColumns={false}
              style={{ height: '100%' }}
              frozenColumns={fixedBindings.length}
              allowSorting={false}
              initialized={(g: FlexGridType<PivotRow>) => {
                // ===== 2-row column header (AS-IS L150 ColumnHeaderSpanRow + L173 AddNumColumn) =====
                if (g.columnHeaders.rows.length === 1) {
                  g.columnHeaders.rows.push(new Row());
                }
                g.columnHeaders.rows.defaultSize = 25;

                // formatItem — 동적 col header (Row 0: YYYY / Row 1: MM) + 좌측 fixed col 의 Row 1 만 header 표시
                g.formatItem.addHandler((_s, e: FormatItemEventArgs) => {
                  if (e.panel.cellType === CellType.ColumnHeader) {
                    const col = e.panel.columns[e.col];
                    const binding = col?.binding ?? '';
                    if (/^M_\d{6}$/.test(binding)) {
                      const yyyy = binding.slice(2, 6);
                      const mm = binding.slice(6, 8);
                      if (e.row === 0) e.cell.textContent = yyyy;
                      else if (e.row === 1) e.cell.textContent = mm;
                      (e.cell as HTMLElement).style.textAlign = 'center';
                    } else if (fixedBindings.includes(binding)) {
                      const meta = EXCHANGE_RATE_COLUMNS.find(c => c.key === binding);
                      e.cell.textContent = meta?.header ?? binding;
                      (e.cell as HTMLElement).style.textAlign = 'center';
                    }
                  }
                });

                // ===== Merge (AS-IS L191 SmartColMerge) =====
                //   ColumnHeader: 좌측 fixed cols row 0~1 vertical merge + 동적 cols row 0 (YYYY) horizontal merge
                //   Cell: Division / Currency cell 머지 (Restricted)
                g.allowMerging = AllowMerging.All;
                for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
                class ExchangeMerge extends MergeManager {
                  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
                    const col = panel.columns[c];
                    if (!col) return null;
                    const binding = col.binding ?? '';

                    if (panel.cellType === CellType.ColumnHeader) {
                      // 좌측 fixed: row 0~1 vertical merge
                      if (fixedBindings.includes(binding)) {
                        return new CellRange(0, c, 1, c);
                      }
                      // 동적 M_yyyymm: row 0 (YYYY) horizontal merge
                      if (/^M_\d{6}$/.test(binding) && r === 0) {
                        const yyyy = binding.slice(2, 6);
                        let c1 = c, c2 = c;
                        while (c1 > 0) {
                          const pb = panel.columns[c1 - 1].binding ?? '';
                          if (/^M_\d{6}$/.test(pb) && pb.slice(2, 6) === yyyy) c1--;
                          else break;
                        }
                        while (c2 < panel.columns.length - 1) {
                          const nb = panel.columns[c2 + 1].binding ?? '';
                          if (/^M_\d{6}$/.test(nb) && nb.slice(2, 6) === yyyy) c2++;
                          else break;
                        }
                        return new CellRange(0, c1, 0, c2);
                      }
                      return null;
                    }

                    // ===== Data Cell — Division / Currency Restricted merge =====
                    //   Division: 같은 DIVISION_ID row 머지
                    //   Currency: 같은 (DIVISION_ID + CURRENCY) row 머지
                    if (panel.cellType === CellType.Cell) {
                      if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
                        const view = panel.rows;
                        const ri = (i: number): PivotRow | undefined =>
                          (view[i] as unknown as { dataItem?: PivotRow })?.dataItem;
                        const cur = ri(r);
                        if (!cur) return null;
                        const sameRow = (a: number, b: number): boolean => {
                          const ra = ri(a); const rb = ri(b);
                          if (!ra || !rb) return false;
                          if (binding === 'DIVISION_ID') {
                            return ra.DIVISION_ID === rb.DIVISION_ID;
                          }
                          // CURRENCY merge — Restricted by left (Division + Currency)
                          return ra.DIVISION_ID === rb.DIVISION_ID && ra.CURRENCY === rb.CURRENCY;
                        };
                        let r1 = r, r2 = r;
                        while (r1 > 0 && sameRow(r1 - 1, r)) r1--;
                        while (r2 < view.length - 1 && sameRow(r2 + 1, r)) r2++;
                        if (r1 === r2) return null;
                        return new CellRange(r1, c, r2, c);
                      }
                    }
                    return null;
                  }
                }
                g.mergeManager = new ExchangeMerge();
              }}
            >
              {/* 좌측 3 fixed cols (Div / Currency / Unit) */}
              {EXCHANGE_RATE_COLUMNS.map(c => (
                <FlexGridColumn
                  key={c.key}
                  binding={c.key}
                  header={c.header}
                  width={c.width}
                  align={c.align === 'C' ? 'center' : c.align === 'R' ? 'right' : 'left'}
                  isReadOnly
                />
              ))}
              {/* 동적 월 cols — AS-IS L173 AddNumColumn (소수 2자리, 캡쳐: 960.00 등) */}
              {ymKeys.map(ym => (
                <FlexGridColumn
                  key={ym}
                  binding={`M_${ym}`}
                  header={ym}
                  width={90}
                  align='right'
                  format='n2'
                />
              ))}
            </FlexGrid>
          </div>
        </div>
      }
    />
  );
};
