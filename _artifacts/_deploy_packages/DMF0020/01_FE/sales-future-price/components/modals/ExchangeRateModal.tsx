import { FlexGrid, FlexGridColumn, FlexGridColumnGroup } from '@mescius/wijmo.react.grid';
import { useEffect, useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { EXCHANGE_RATE_COLUMNS, MENU_ID, SHEETS } from '../../sales-future-price.constants';
import type { SpreadTitleDateRow } from '../../sales-future-price.types';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

// AS-IS DMF0020_SalesFuturePricePopUp.cs (586줄) — Exchange Rate 일괄 등록·조회·저장
//   - Filter: Div / Period From / Period To (월 단위)
//   - SP 3종: GET_EXCHANGE_POPUP_SPREAD_TITLE (동적 월 컬럼) / GET_FUTUREPRICE_INFO (데이터) / SAVE_DM_MST_EXCHANGE_RATE_ALL
//   - 2단 헤더 (Row 0: YYYY, Row 1: MM)
//   - Validation: MSG00142 (Lock) / MSG00108 (Period 역전)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_ExchangeRate/
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

  // SP 1 — 동적 월 컬럼 메타 (P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE)
  const { data: titleData, refetch: refetchTitle } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,    // TODO: 별도 sheet 로 등록 (현재는 동일 sheet 재사용)
    filters: { startYyyymmdd: periodFrom, endYyyymmdd: periodTo } as never,
    enabled: open && !!periodFrom && !!periodTo,
  });

  // SP 2 — 통화별 환율 데이터 (P_DMF0020_GET_FUTUREPRICE_INFO)
  const { data: rateData, refetch: refetchRate } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    filters: { startYyyymmdd: periodFrom, endYyyymmdd: periodTo } as never,
    enabled: open && !!periodFrom && !!periodTo,
  });

  const titleRows = (titleData?.o_rc1 ?? []) as SpreadTitleDateRow[];
  const dataRows = (rateData?.o_rc1 ?? []) as Record<string, unknown>[];

  const handleFind = () => {
    // Validation: Period 역전 (MSG00108)
    if (periodFrom > periodTo) {
      void setAlert({ type: 'alert', content: '[MSG00108] 시작 월이 종료 월보다 늦을 수 없습니다.' });
      return;
    }
    refetchTitle?.();
    refetchRate?.();
  };

  // 2단 헤더 트리 (YYYY → MM)
  const yearGroups = (() => {
    const map = new Map<string, Array<{ binding: string; label: string }>>();
    for (const t of titleRows) {
      const yr = String(t.YER ?? '');
      const month = String(t.MON ?? '');
      const binding = String(t.BASIS_START_DATE2 ?? '');
      if (!yr || !binding) continue;
      const list = map.get(yr) ?? [];
      list.push({ binding, label: month });
      map.set(yr, list);
    }
    return Array.from(map.entries()).map(([yr, months]) => ({ yr, months }));
  })();

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      title='Exchange Rate'
      width={1100}
      height={500}
    >
      <div className={styles.container}>
        <div className={styles.filterRow}>
          <label>
            Div
            <select value={divisionId} onChange={e => setDivisionId(e.target.value)}>
              <option value='ALL'>ALL</option>
              <option value='40'>40</option>
              <option value='81'>81</option>
              <option value='82'>82</option>
            </select>
          </label>
          <label>
            Period From
            <input
              type='text'
              value={periodFrom}
              onChange={e => setPeriodFrom(e.target.value)}
              placeholder='YYYYMM'
            />
          </label>
          <label>
            Period To
            <input
              type='text'
              value={periodTo}
              onChange={e => setPeriodTo(e.target.value)}
              placeholder='YYYYMM'
            />
          </label>
          <button type='button' onClick={handleFind} className={styles.findBtn}>Find</button>
          <button type='button' onClick={modalClose} className={styles.closeBtn}>Close</button>
        </div>

        <div className={styles.gridWrap}>
          <FlexGrid
            itemsSource={dataRows}
            autoGenerateColumns={false}
            frozenColumns={3}
            style={{ height: '100%' }}
          >
            {EXCHANGE_RATE_COLUMNS.map(c => (
              <FlexGridColumn
                key={c.key}
                binding={c.key}
                header={c.header}
                width={c.width}
                align={c.align === 'C' ? 'center' : c.align === 'R' ? 'right' : 'left'}
                format={c.format}
                isReadOnly={c._inputEditType === 'S'}
              />
            ))}
            {/* 동적 월 컬럼 — 2단 헤더 (YYYY > MM) */}
            {yearGroups.map(yg => (
              <FlexGridColumnGroup key={yg.yr} header={yg.yr}>
                {yg.months.map(m => (
                  <FlexGridColumn
                    key={m.binding}
                    binding={m.binding}
                    header={m.label}
                    width={80}
                    align='right'
                    format='n4'
                  />
                ))}
              </FlexGridColumnGroup>
            ))}
          </FlexGrid>
        </div>
      </div>
    </CustomDialog>
  );
};
