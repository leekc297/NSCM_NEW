import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE, type BUTTON_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../sales-reports.constants';
import type { ExchangeRateRow } from '../../sales-reports.types';
import styles from '../../SalesReports.module.scss';
import { callSaveExchangeRate } from '../../utils/sales-reports.api';
import { toCellStr } from '../../utils/sales-reports.gridCombos';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  year: string;
  versionNo: string;
}

// Exchange Rate 팝업
// 조회는 통화쌍(SEARCH), 월별 환율 데이터(SEARCH_DATA), 연도별 월 헤더(TITLE)를 조합한다.
// 저장은 변경된 월별 값을 행 단위 데이터로 변환한 뒤 SAVE 프로시저에 일괄 전달한다.
// 과거 월과 EDIT_YN이 N인 행은 수정할 수 없다.
export const ExchangeRateModal = ({ open, modalClose, divisionId, year, versionNo }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<ExchangeRateRow>>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const [saving, setSaving] = useState(false);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({ divisionId, year, sesUserId, versionNo, userId: sesUserId, mnuId: MENU_ID }),
    [divisionId, year, versionNo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    tabId: MENU_ID,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });
  const { data: detailData, refetch: refetchDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.EXCHANGE_RATE
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    procedureAction: 'SEARCH_DATA' as BUTTON_TYPE,
    tabId: `${MENU_ID}-exchange-rate-data`,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    procedureAction: 'TITLE' as BUTTON_TYPE,
    tabId: `${MENU_ID}-exchange-rate-title`,
    filters,
    enabled: open && versionNo !== '',
    queryOptions: { staleTime: 0 },
  });
  const rateRows = useMemo<ExchangeRateRow[]>(() => {
    const baseRows = (data as { data?: ExchangeRateRow[] } | undefined)?.data ?? [];
    const detailRows = (detailData as { data?: ExchangeRateRow[] } | undefined)?.data ?? [];
    const rowMap = new Map<string, ExchangeRateRow>();

    const getKey = (row: ExchangeRateRow) =>
      [row.DIVISION_ID, row.CURRENCY, row.UNIT_CURRENCY].map(toCellStr).join('|');

    for (const row of baseRows) rowMap.set(getKey(row), { ...row });
    for (const detail of detailRows) {
      const key = getKey(detail);
      const row = rowMap.get(key) ?? { ...detail };
      const date = toCellStr((detail as Record<string, unknown>).YYYYMMDD)
        .replace(/^D/i, '')
        .replace(/\D/g, '');
      const price = Number((detail as Record<string, unknown>).EXCHANGE_PRICE);
      if (date.length >= 6 && !Number.isNaN(price)) row[`M_${date.slice(0, 6)}`] = price;
      rowMap.set(key, row);
    }

    return [...rowMap.values()].sort((a, b) =>
      getKey(a).localeCompare(getKey(b), undefined, { numeric: true })
    );
  }, [data, detailData]);

  // 고정 3개 컬럼과 조회 연도의 동적 월 컬럼(M_yyyymm)
  const monthBindings = useMemo<string[]>(() => {
    const set = new Set<string>();
    const titleRows =
      (titleData as { data?: Array<Record<string, unknown>> } | undefined)?.data ?? [];
    for (const row of titleRows) {
      const titleYear = toCellStr(row.CALENDAR_YYYY);
      const titleMonth = toCellStr(row.CALENDAR_MONTH).padStart(2, '0');
      if (/^\d{4}$/.test(titleYear) && /^\d{2}$/.test(titleMonth)) {
        set.add(`M_${titleYear}${titleMonth}`);
      }
    }
    for (const r of rateRows) {
      for (const k of Object.keys(r)) if (/^M_\d{6}$/.test(k)) set.add(k);
    }
    return [...set].sort();
  }, [rateRows, titleData]);

  const staticCols = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      [
        { colNm: 'DIVISION_ID', colLblNm: 'Division', colWth: 80 },
        { colNm: 'CURRENCY', colLblNm: 'Currency', colWth: 90 },
        { colNm: 'UNIT_CURRENCY', colLblNm: 'Unit Currency', colWth: 100 },
      ].map(c => ({
        ...c,
        fixed: true,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      })),
    []
  );
  const dynamicCols = useMemo(
    () =>
      monthBindings.map(b => ({
        binding: b,
        header: b.slice(2),
        align: 'right' as const,
        width: 90,
        visible: true,
        _display: true,
      })),
    [monthBindings]
  ) as never[];

  // 과거 월과 편집 권한이 없는 행의 입력을 차단하고 No. 헤더를 표시한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const thisMonth = `M_${new Date().getFullYear()}${String(new Date().getMonth() + 1).padStart(2, '0')}`;
    const beginningEdit = (
      s: FlexGridType<ExchangeRateRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const rowData = s.rows[e.row]?.dataItem as ExchangeRateRow | undefined;
      if (toCellStr(rowData?.EDIT_YN) !== 'Y') {
        e.cancel = true;
        return;
      }
      if (/^M_\d{6}$/.test(binding) && binding < thisMonth) e.cancel = true;
    };
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.beginningEdit.addHandler(beginningEdit);
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEdit);
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, monthBindings]);

  // EditTracker의 변경 셀을 월별 저장 행으로 펼쳐 '^' 구분 일괄 데이터로 전달한다.
  // 빈 값은 0으로 저장하며 0은 삭제 플래그(D)로 처리한다.
  const handleSave = async () => {
    if (saving) return;
    const changes = editTrackerRef.current?.getOriginalValues() as
      | Map<ExchangeRateRow, Record<string, unknown>>
      | undefined;
    const rows: Record<string, string>[] = [];
    changes?.forEach((chg, row) => {
      for (const binding of Object.keys(chg)) {
        if (!/^M_\d{6}$/.test(binding)) continue;
        const raw = toCellStr((row as Record<string, unknown>)[binding]).replace(/,/g, '');
        const price = raw === '' ? '0' : raw;
        rows.push({
          activeFlag: price === '0' ? 'D' : 'M',
          divisionId: toCellStr(row.DIVISION_ID) || divisionId,
          versionNo,
          yyyymmdd: `${binding.slice(2)}01`,
          currency: toCellStr(row.CURRENCY),
          unitCurrency: toCellStr(row.UNIT_CURRENCY),
          exchangePrice: price,
        });
      }
    });
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정된 내용이 없습니다.') });
      return;
    }
    setSaving(true);
    try {
      const keys = Object.keys(rows[0]);
      const payload: Record<string, string> = {};
      for (const k of keys) payload[k] = rows.map(r => r[k]).join('^');
      const res = await callSaveExchangeRate(payload);
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
      editTrackerRef.current?.clearChanges();
      void Promise.all([refetch?.(), refetchDetail?.()]);
    } finally {
      setSaving(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={980}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Exchange Rate</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <DataGrid<ExchangeRateRow>
              gridRef={gridRef}
              editTrackerRef={editTrackerRef as never}
              itemsSource={rateRows}
              staticColumns={staticCols}
              dynamicColumns={dynamicCols}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>
          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Save'
              disabled={saving}
              onClick={() => void handleSave()}
            />
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
