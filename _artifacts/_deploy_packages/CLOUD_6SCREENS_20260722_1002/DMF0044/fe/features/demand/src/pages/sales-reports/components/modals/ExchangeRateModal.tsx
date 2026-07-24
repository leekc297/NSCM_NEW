import { CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
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

// ⭐ Exchange Rate 팝업 — AS-IS DMF0044_SalesReportExchangePopup(721행):
//   조회 = GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA (통화쌍 × 월 피벗 M_yyyymm) + 월 헤더
//   (GET_EXCHANGE_POPUP_SPREAD_TITLE p_year — 여기서는 데이터 키 union 으로 동적 컬럼 산출).
//   저장 = SAVE_DM_EXCHANGE_RATE_REPORT '^' 7키 (9 IN − 감사 2 BE주입). Red(변경) 셀만.
//   과거연도 조회 시 현재월 이전 컬럼 입력 차단 (L-29 L631~650). price ''→'0', '0'→'D'.
//   정책④(2026-07-22): 종료 후 메인 재조회 없음 — AS-IS 파리티 (blnOK 재조회 주석 L1446~1454).
export const ExchangeRateModal = ({ open, modalClose, divisionId, year, versionNo }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<ExchangeRateRow>>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const [saving, setSaving] = useState(false);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({ divisionId, year, versionNo, userId: sesUserId, mnuId: MENU_ID }),
    [divisionId, year, versionNo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE_RATE,
    tabId: MENU_ID,
    filters,
    enabled: open && versionNo !== '',
  });
  const rateRows = useMemo<ExchangeRateRow[]>(
    () => ((data as { data?: ExchangeRateRow[] } | undefined)?.data ?? []),
    [data]
  );

  // 정적 3컬럼 + 동적 월 컬럼 (데이터 키 union — M_yyyymm)
  const monthBindings = useMemo<string[]>(() => {
    const set = new Set<string>();
    for (const r of rateRows) {
      for (const k of Object.keys(r)) if (/^M_\d{6}$/.test(k)) set.add(k);
    }
    return [...set].sort();
  }, [rateRows]);

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

  // 과거연도 조회 시 현재월 이전 입력 차단 (AS-IS L-29) + No. 코너
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const thisMonth = `M_${new Date().getFullYear()}${String(new Date().getMonth() + 1).padStart(2, '0')}`;
    const beginningEdit = (
      s: FlexGridType<ExchangeRateRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
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

  // ⭐ 저장 — EditTracker 변경 셀 unfold → '^' 7키 (activeFlag/divisionId/versionNo/yyyymmdd/
  //   currency/unitCurrency/exchangePrice — createdBy/lastUpdatedBy BE주입). '0'→'D'.
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
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    setSaving(true);
    try {
      const keys = Object.keys(rows[0]);
      const payload: Record<string, string> = {};
      for (const k of keys) payload[k] = rows.map(r => r[k]).join('^');
      const res = await callSaveExchangeRate(payload);
      if (!res.ok) {
        void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.') });
        return;
      }
      void setAlert({ type: 'alert', content: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
      editTrackerRef.current?.clearChanges();
      void refetch?.();
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
            <Button appearance='contained' priority='primary' size='medium' buttonLabel='Save'
              disabled={saving} onClick={() => void handleSave()} />
            <Button appearance='outlined' priority='normal' size='medium' buttonLabel='Close' onClick={modalClose} />
          </div>
        </div>
      }
    />
  );
};
