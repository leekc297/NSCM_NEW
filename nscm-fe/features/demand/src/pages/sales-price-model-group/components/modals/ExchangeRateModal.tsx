import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { Dayjs } from 'dayjs';
import { buildComboOptions } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { BUTTON_TYPE } from '@foundation/constants';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, ProgressIndicator } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  EXCHANGE_RATE_COLUMNS,
  MEASURE_CODE,
  MENU_ID,
  MODAL_EXCHANGE_RATE,
  MSG,
  PROC_ACTION,
  SEARCH_COMBO,
  SHEETS,
} from '../../sales-price-model-group.constants';
import type { ExchangeRateRow } from '../../sales-price-model-group.types';
import { attachHeaderHeightNormalizer } from '../../utils/sales-price-model-group.grid';
import { keepMergeManager } from '../../utils/sales-price-model-group.grid';
import { enumerateYyyymm, showAlert } from '../../utils/sales-price-model-group.util';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  // 메인 조회 기간(YYYYMM) — 팝업을 열 때의 기본 기간.
  defaultPeriod: { start: string; end: string };
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  [monthKey: string]: string | number;
}

const MONTH_PREFIX = 'M_';
const FIXED_BINDINGS: readonly string[] = EXCHANGE_RATE_COLUMNS.map(c => c.key);
const yearOf = (binding: string): string =>
  binding.startsWith(MONTH_PREFIX) ? binding.slice(2, 6) : '';

// Period(YYYYMM) → 달력 값. 저장 · 비교는 계속 YYYYMM 문자열로 한다.
const monthOf = (yyyymm: string): Dayjs | null =>
  /^\d{6}$/.test(yyyymm) ? dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`) : null;

// 머지 — 고정 칸 머리글은 2단 세로, 연도 머리글은 같은 해끼리 가로, Div · Currency 값은 세로 (원천 DMF0020 팝업과 같음).
class ExchangeRateMergeManager extends MergeManager {
  getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
    const binding = panel.columns[c]?.binding ?? '';
    if (panel.cellType === CellType.ColumnHeader) {
      if (FIXED_BINDINGS.includes(binding)) return new CellRange(0, c, panel.rows.length - 1, c);
      const year = yearOf(binding);
      if (!year || r !== 0) return null;
      let left = c;
      let right = c;
      while (left > 0 && yearOf(panel.columns[left - 1]?.binding ?? '') === year) left--;
      while (
        right < panel.columns.length - 1 &&
        yearOf(panel.columns[right + 1]?.binding ?? '') === year
      )
        right++;
      return left === right ? null : new CellRange(0, left, 0, right);
    }
    if (panel.cellType === CellType.Cell && (binding === 'DIVISION_ID' || binding === 'CURRENCY')) {
      const rowAt = (i: number): PivotRow | undefined =>
        (panel.rows[i] as unknown as { dataItem?: PivotRow } | undefined)?.dataItem;
      const current = rowAt(r);
      if (!current) return null;
      const same = (i: number): boolean => {
        const other = rowAt(i);
        if (!other || other.DIVISION_ID !== current.DIVISION_ID) return false;
        return binding === 'DIVISION_ID' || other.CURRENCY === current.CURRENCY;
      };
      let top = r;
      let bottom = r;
      while (top > 0 && same(top - 1)) top--;
      while (bottom < panel.rows.length - 1 && same(bottom + 1)) bottom++;
      return top === bottom ? null : new CellRange(top, c, bottom, c);
    }
    return null;
  }
}

// Exchange Rate 팝업 — 원천 DMF0020 Sales Price 의 Exchange Rate 팝업과 같은 조회 전용 화면 (요청 2026-11-16).
//   설계서 v8 의 "메인 Exchange Rate 팝업은 만들지 않는다(2026-11-05)"는 잘못 적힌 것으로 확인되어 추가한다.
//   환율은 화면이 이미 쓰는 main / EXCHANGE_RATE (PKG_DMF0083.P_DMF0083_GET_EXCHANGE_RATE)로 읽는다 — 저장 기능 없음.
//   프로시저가 조회조건 사업부만 돌려주므로 Div 는 메인 사업부로 고정해 보여 준다.
export const ExchangeRateModal = ({ open, modalClose, divisionId, defaultPeriod }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<PivotRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  // 달력에서 고르는 중인 기간(편집값)과 Search 로 확정한 기간(조회 키)을 나눈다 — 달력만 바꿔서는 다시 조회하지 않는다(POP-08).
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);
  const [applied, setApplied] = useState<{ start: string; end: string } | null>(null);

  // 열 때마다 메인 조회 기간으로 되돌리고 한 번 조회한다. 닫으면 확정 기간을 비워 다음에 열 때 옛 기간으로 조회하지 않게 한다.
  const defaultRef = useRef(defaultPeriod);
  defaultRef.current = defaultPeriod;
  useEffect(() => {
    if (!open) {
      setApplied(null);
      return;
    }
    const { start, end } = defaultRef.current;
    setPeriodFrom(start);
    setPeriodTo(end);
    setApplied({ start, end });
  }, [open]);

  const [divisions] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  const divisionOptions = buildComboOptions(divisions).filter(o => o.value === divisionId);

  // 환율 기준일은 YYYYMM01 이고 프로시저가 문자열로 비교하므로 종료일은 그 달 31 로 보낸다(원천 DMF0020 팝업과 같음).
  const filters = useMemo(
    () =>
      open && applied && divisionId
        ? { divisionId, fromYyyymmdd: `${applied.start}01`, toYyyymmdd: `${applied.end}31` }
        : undefined,
    [open, applied, divisionId]
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: PROC_ACTION.EXCHANGE_RATE as BUTTON_TYPE,
    tabId: MODAL_EXCHANGE_RATE,
    filters,
    enabled: !!filters,
  });
  const loading = isLoading || isFetching;

  // 긴 형식(월 · 통화쌍마다 1행) → 통화쌍 1행 + 월 칸. KRW 기준 환율만 보여 준다(원천 DMF0020 팝업과 같음).
  //   월 칸은 데이터가 있는 달이 아니라 조회한 기간 전체로 세운다 — 환율이 없는 달도 빈 칸으로 남는다.
  const { pivotRows, monthKeys } = useMemo(() => {
    const months = new Set<string>(applied ? enumerateYyyymm(applied.start, applied.end) : []);
    const groups = new Map<string, PivotRow>();
    for (const r of (data?.o_rc1 as unknown as ExchangeRateRow[] | undefined) ?? []) {
      const division = String(r.DIVISION_ID ?? '').trim();
      const currency = String(r.CURRENCY ?? '').trim();
      const unit = String(r.UNIT_CURRENCY ?? '').trim();
      const ym = String(r.YYYYMM ?? '').trim();
      if (currency.toUpperCase() !== MEASURE_CODE.KRW || !division || !unit || !ym) continue;
      months.add(ym);
      const key = `${division}|${currency}|${unit}`;
      const row = groups.get(key) ?? { DIVISION_ID: division, CURRENCY: currency, UNIT_CURRENCY: unit };
      const price = Number(r.EXCHANGE_PRICE);
      if (!Number.isNaN(price)) row[`${MONTH_PREFIX}${ym}`] = price;
      groups.set(key, row);
    }
    const list = [...groups.values()].sort(
      (a, b) =>
        a.DIVISION_ID.localeCompare(b.DIVISION_ID) ||
        a.CURRENCY.localeCompare(b.CURRENCY) ||
        a.UNIT_CURRENCY.localeCompare(b.UNIT_CURRENCY)
    );
    return { pivotRows: list, monthKeys: [...months].sort() };
  }, [data, applied]);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      EXCHANGE_RATE_COLUMNS.map(c => ({
        colNm: c.key,
        colLblNm: c.labelCode ? t(c.labelCode, c.header) : c.header,
        colWth: c.width,
        horzAlgnCd: 'C',
        fixed: true,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      })),
    [t]
  );
  // 2단 머리글 — 1단 연도, 2단 월.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const ym of monthKeys) {
      const year = ym.slice(0, 4);
      const list = byYear.get(year) ?? [];
      list.push({
        binding: `${MONTH_PREFIX}${ym}`,
        header: ym.slice(4, 6),
        width: 90,
        align: 'right',
        format: 'n2',
        isReadOnly: true,
        allowSorting: false,
        visible: true,
      });
      byYear.set(year, list);
    }
    return [...byYear.entries()].map(([year, columns]) => ({ header: year, align: 'center', columns }));
  }, [monthKeys]);

  const mergeManager = useMemo(() => new ExchangeRateMergeManager(), []);
  useEffect(() => {
    const g = gridRef.current;
    // CustomDialog 는 닫혀 있어도 내용을 만들어 둔다 — 숨은 그리드는 머리글이 아직 없을 수 있다.
    if (!open || !g || !g.columnHeaders) return;
    const center = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) e.cell.style.textAlign = 'center';
    };
    g.formatItem.addHandler(center);
    const detachHeader = attachHeaderHeightNormalizer(g as never);
    const detachMerge = keepMergeManager(g as never, mergeManager);
    g.invalidate(true);
    return () => {
      g.formatItem.removeHandler(center);
      detachHeader();
      detachMerge();
    };
  }, [open, dynamicColumns, pivotRows, mergeManager]);

  const handleSearch = () => {
    if (!periodFrom || !periodTo || periodFrom > periodTo) {
      return showAlert(t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다.'));
    }
    // 기간이 그대로면 조회 키가 안 바뀌므로 다시 조회를 직접 부른다.
    if (applied?.start === periodFrom && applied?.end === periodTo) void refetch();
    else setApplied({ start: periodFrom, end: periodTo });
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={modalClose}
      disableButtonCancel
      // 컬럼 필터 팝업이 다이얼로그 밖에 붙어 MUI FocusTrap 과 부딪힌다 — 필터 입력이 먹지 않는 것을 막는다(POP-04).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00661', '_Exchange Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t('LBL00664', '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={6}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00001', '_Div')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00013', '_Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.periodSplit}>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={monthOf(periodFrom)}
                            onChange={
                              ((date: Dayjs | null) =>
                                setPeriodFrom(date?.format('YYYYMM') ?? '')) as never
                            }
                          />
                        </div>
                        <span className={styles.periodSep}>~</span>
                        <div className={styles.datePickerFix}>
                          <DatePickerCalendar
                            usecase='month'
                            elevation
                            size='small'
                            value={monthOf(periodTo)}
                            onChange={
                              ((date: Dayjs | null) =>
                                setPeriodTo(date?.format('YYYYMM') ?? '')) as never
                            }
                          />
                        </div>
                      </div>
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' open={loading} placement='parent' />
            <ResultArea
              title=''
              count={pivotRows.length}
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<PivotRow>
                className={styles.grid}
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                isReadOnly
                itemsSource={pivotRows}
                staticColumns={staticColumns}
                dynamicColumns={dynamicColumns}
                autoGenerateColumns={false}
                frozenColumns={FIXED_BINDINGS.length}
                allowSorting={false}
                allowMerging={AllowMerging.All}
                mergeManager={mergeManager}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
