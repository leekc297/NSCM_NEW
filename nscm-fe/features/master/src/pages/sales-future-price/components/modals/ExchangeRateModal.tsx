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
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { EXCHANGE_RATE_COLUMNS, MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

// 권한 combo 미응답 시 fallback (형제 SalesPriceVersionModal 동일) — Division_id + Division name 표기.
const DIVISION_FALLBACK: Array<{ value: string; label: string }> = [
  { value: '40', label: '40 (Mobility & IT Battery)' },
  { value: '81', label: '81 (ESS Battery)' },
  { value: '82', label: '82 (Power Tool)' },
];

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
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<PivotRow>>(undefined);
  const [divisionId, setDivisionId] = useState(defaultDivision);

  // Division dropdown — 권한 기반 MyDivision combo (grid 와 동일하게 Division_id + Division name 표기).
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    const base =
      arr.length === 0
        ? DIVISION_FALLBACK
        : arr.map(r => {
            const code = String(r.CODE ?? '');
            const name = String(r.NAME ?? code);
            const label = code === name || name === '' ? code : `${code} (${name})`;
            return { value: code, label };
          });
    return [{ value: 'ALL', label: t('LBL00632', 'All') }, ...base];
  }, [myDivisions, t]);

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
    () => ({ startYyyymmdd, endYyyymmdd }) as never,
    [startYyyymmdd, endYyyymmdd]
  );
  // ⭐ 자동조회 (2026-07-07 사용자 요구 — Batch Price Input 제외 전 modal 자동조회):
  //   enabled=open → modal open 시 react-query 가 filters(기간)로 자동 fetch. Find 버튼은 재조회용 유지.
  //   (setFilter();refetch() 직접 발사 대신 enabled 구동 → stale-closure NULL 재조회 함정 회피.)
  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });

  const allRows = (data?.o_rc1 ?? []) as unknown as ExchangeRow[];
  // ⭐ Currency KRW 만 조회 (2026-07-07 사용자 요구) + Division 필터(고정 division).
  const filteredRows = allRows.filter(r => {
    if (String(r.CURRENCY ?? '').toUpperCase() !== 'KRW') return false;
    if (divisionId && divisionId !== 'ALL' && String(r.DIVISION_ID ?? '') !== divisionId)
      return false;
    return true;
  });

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
      const price =
        typeof r.EXCHANGE_PRICE === 'number' ? r.EXCHANGE_PRICE : Number(r.EXCHANGE_PRICE);
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

  // ⭐ #70 — DataGrid `initialized` prop deprecated(wrapper 미호출) → useEffect + gridRef 로 이동.
  //   2단 column header(YYYY/MM) + 좌측 fixed 머지 + 동적 YYYY horizontal 머지 + Division/Currency cell 머지.
  useEffect(() => {
    const g = gridRef.current;
    // ⭐ CustomDialog 는 open=false 라도 content 를 mount 한다. 숨겨진(host display:none) 상태의
    //   Wijmo grid 는 panel 을 지연 초기화하므로 columnHeaders 가 null 일 수 있다 → guard 필수.
    if (!g || !g.columnHeaders) return;

    if (g.columnHeaders.rows.length === 1) g.columnHeaders.rows.push(new Row());
    g.columnHeaders.rows.defaultSize = 25;

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        const binding = e.panel.columns[e.col]?.binding ?? '';
        if (/^M_\d{6}$/.test(binding)) {
          if (e.row === 0) e.cell.textContent = binding.slice(2, 6);
          else if (e.row === 1) e.cell.textContent = binding.slice(6, 8);
          e.cell.style.textAlign = 'center';
        } else if (fixedBindings.includes(binding)) {
          const meta = EXCHANGE_RATE_COLUMNS.find(c => c.key === binding);
          e.cell.textContent = meta?.header ?? binding;
          e.cell.style.textAlign = 'center';
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    class ExchangeMerge extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';
        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) return new CellRange(0, c, 1, c);
          if (/^M_\d{6}$/.test(binding) && r === 0) {
            const yyyy = binding.slice(2, 6);
            let c1 = c,
              c2 = c;
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
        if (panel.cellType === CellType.Cell) {
          if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
            const view = panel.rows;
            const ri = (i: number): PivotRow | undefined =>
              (view[i] as unknown as { dataItem?: PivotRow })?.dataItem;
            if (!ri(r)) return null;
            const sameRow = (a: number, b: number): boolean => {
              const ra = ri(a);
              const rb = ri(b);
              if (!ra || !rb) return false;
              if (binding === 'DIVISION_ID') return ra.DIVISION_ID === rb.DIVISION_ID;
              return ra.DIVISION_ID === rb.DIVISION_ID && ra.CURRENCY === rb.CURRENCY;
            };
            let r1 = r,
              r2 = r;
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
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, pivotRows, ymKeys, fixedBindings]);

  const handleFind = () => {
    if (periodFrom > periodTo) {
      void setAlert({ type: 'alert', content: t('MSG00108', '_시작 월이 종료 월보다 늦을 수 없습니다.') });
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
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00661', 'Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleFind}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled
                        value={divisionId}
                        options={divisionOptions}
                        onChange={(_, option) => setDivisionId(String(option))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.periodRange}>
                        <InputField
                          value={periodFrom}
                          onChange={e => setPeriodFrom(e.target.value)}
                          placeholder='YYYY-MM'
                        />
                        <span>~</span>
                        <InputField
                          value={periodTo}
                          onChange={e => setPeriodTo(e.target.value)}
                          placeholder='YYYY-MM'
                        />
                      </div>
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.gridWrapper}>
            <DataGrid<PivotRow>
              gridRef={gridRef}
              className={styles.grid}
              itemsSource={pivotRows}
              staticColumns={EXCHANGE_RATE_COLUMNS.map(
                (c): RawFlexGridColumnConfig => ({
                  colNm: c.key,
                  colLblNm: c.header,
                  colWth: c.width,
                  horzAlgnCd: c.align,
                  fixed: true,
                  visible: true,
                  display: true,
                  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
                })
              )}
              dynamicColumns={ymKeys.map(
                (ym): FlexGridColumnConfig => ({
                  binding: `M_${ym}`,
                  header: ym,
                  width: 90,
                  align: 'right',
                  format: 'n2',
                  isReadOnly: true,
                  allowSorting: false,
                })
              )}
              autoGenerateColumns={false}
              frozenColumns={fixedBindings.length}
              allowSorting={false}
              // ⭐ Div / Currency 세로 셀 머지 (사용자 요구 2026-07-07) — ExchangeMerge(mergeManager)가 데이터셀
              //   계층 머지를 담당하나, prop 미전달 시 wrapper 가 매 렌더 g.allowMerging 을 기본(ColumnHeaders)으로
              //   되돌려 셀 머지가 꺼짐. 형제 PriceBatchInputModal 과 동일하게 All 전달로 일관 적용.
              allowMerging={AllowMerging.All}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
