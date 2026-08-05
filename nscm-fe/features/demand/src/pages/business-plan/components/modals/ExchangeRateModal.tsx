import {
  AllowMerging,
  CellRange,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { EXCHANGE_CATE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import { callSaveExchangeRate } from '../../utils/business-plan.api';

import styles from './ExchangeRateModal.module.scss';

interface Props {
  open: boolean;
  // saved=true 시 부모가 메인 재조회 (AS-IS blnOK → GetFuturePriceInfo + FindData L3001~3003)
  modalClose: (saved: boolean) => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

interface ExchangeRow {
  DIVISION_ID?: string;
  YYYYMMDD?: string; // 'D'||yyyymmdd (SP L54 실측 — 'D' prefix)
  CURRENCY?: string;
  UNIT_CURRENCY?: string;
  EXCHANGE_PRICE?: number | string;
  EDIT_YN?: string;
}

interface PivotRow {
  DIVISION_ID: string;
  CURRENCY: string;
  UNIT_CURRENCY: string;
  EDIT_YN: string;
  [yyyymmKey: string]: string | number;
}

// 고정 3컬럼 (AS-IS DMF0042_ExchangeRatePopup grid 좌측 키 — 정렬코드 단일문자 C, hook #96)
const EXCHANGE_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 90, align: 'C' as const },
  { key: 'CURRENCY', header: 'Currency', width: 90, align: 'C' as const },
  { key: 'UNIT_CURRENCY', header: 'Unit Currency', width: 100, align: 'C' as const },
];

// ⭐ DMF0042 Exchange Rate 모달 — forecast-price ExchangeRateModal(hook #108 No. 코너 정본) 구조 1:1 복제
//   + 데이터 계약 교체 (플랜 §E): 조회 = futurePriceData(DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA,
//   P_CATE='BP') / 저장 = exchangeRate SAVE(DMF0042_SAVE_DM_BP_EXCHANGE_RATE '^' bulk 6키 + 감사 BE주입).
//   AS-IS DMF0042_ExchangeRatePopup(677줄) — 환율 편집(EDIT_YN='Y' 행 × 월 셀) + 저장 + blnOK 재조회.
export const ExchangeRateModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<PivotRow>>(undefined);
  const [divisionId, setDivisionId] = useState(defaultDivision);
  const [savedAny, setSavedAny] = useState(false);

  // Division dropdown — 권한 기반 MyDivision combo (미응답 시 빈 목록 — 하드코딩 fallback 금지)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);

  // 편집 추적 — (pivot key)|(M_ym) → 새 환율값. 저장 성공/재조회 시 clear.
  const editsRef = useRef<Map<string, { row: PivotRow; ym: string; value: number }>>(new Map());
  const [editCount, setEditCount] = useState(0);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultPeriod.start);
      setPeriodTo(defaultPeriod.end);
      setSavedAny(false);
      editsRef.current.clear();
      setEditCount(0);
    }
  }, [open, defaultDivision, defaultPeriod]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const startYyyymmdd = periodFrom.length === 6 ? `${periodFrom}01` : periodFrom;
  const endYyyymmdd = periodTo.length === 6 ? `${periodTo}31` : periodTo;
  const filters = useMemo(
    () => ({
      divisionId: divisionId || 'ALL',
      fromYyyymmdd: startYyyymmdd,
      toYyyymmdd: endYyyymmdd,
      cate: EXCHANGE_CATE, // 'BP' (AS-IS LoadData L2994)
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, startYyyymmdd, endYyyymmdd, sesUserId]
  );
  // ⭐ 자동조회 — enabled=open (모달 자동조회 표준. Find 버튼은 재조회용)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.FUTURE_PRICE_DATA>({
    menuId: MENU_ID,
    sheetName: SHEETS.FUTURE_PRICE_DATA,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });

  const allRows = useMemo<ExchangeRow[]>(
    () => (data as { data?: ExchangeRow[] } | undefined)?.data ?? [],
    [data]
  );

  // ===== long → wide pivot (2단 헤더 YYYY/MM — 정본 구조 1:1) =====
  const { pivotRows, ymKeys } = useMemo(() => {
    const groupMap = new Map<string, PivotRow>();
    const ymSet = new Set<string>();
    for (const r of allRows) {
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      const uc = String(r.UNIT_CURRENCY ?? '');
      // YYYYMMDD = 'D'||yyyymmdd (SP 실측) — prefix 제거 후 yyyymm 추출
      const raw = String(r.YYYYMMDD ?? '').replace(/^D/, '');
      const ym = raw.slice(0, 6);
      if (!div || !cur || !uc || !/^\d{6}$/.test(ym)) continue;
      ymSet.add(ym);
      const key = `${div}|${cur}|${uc}`;
      if (!groupMap.has(key)) {
        groupMap.set(key, {
          DIVISION_ID: div,
          CURRENCY: cur,
          UNIT_CURRENCY: uc,
          EDIT_YN: String(r.EDIT_YN ?? 'N'),
        });
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
    return { pivotRows: list, ymKeys: [...ymSet].sort() };
  }, [allRows]);

  const fixedBindings = useMemo(() => EXCHANGE_COLUMNS.map(c => c.key), []);

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      EXCHANGE_COLUMNS.map(
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
      ),
    []
  );
  // ⭐ 대상 년월 2단 헤더 — nested columnGroups(년 그룹→월 leaf). 환율 셀 = 편집 가능 (EDIT_YN 행 게이트).
  const gridDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const byYear = new Map<string, FlexGridColumnConfig[]>();
    for (const ym of ymKeys) {
      const y = ym.slice(0, 4);
      if (!byYear.has(y)) byYear.set(y, []);
      byYear.get(y)!.push({
        binding: `M_${ym}`,
        header: ym.slice(4, 6),
        width: 90,
        align: 'right',
        format: 'n2',
        allowSorting: false,
        visible: true,
      });
    }
    return [...byYear.entries()].map(([y, cols]) => ({
      header: y,
      align: 'center',
      columns: cols,
    }));
  }, [ymKeys]);

  // ⭐ 헤더 머지/코너/편집 게이트 — useEffect + gridRef (initialized prop deprecated)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
      }
      // ⭐ No. 코너 헤더 (hook #108 — setCellData 재귀 가드)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
        return;
      }
      // 편집 가능 셀 Yellow (#95 — EDIT_YN='Y' 행 × 환율 월 셀)
      if (e.panel.cellType === CellType.Cell) {
        const binding = e.panel.columns[e.col]?.binding ?? '';
        if (/^M_\d{6}$/.test(binding)) {
          const item = (e.panel.rows[e.row] as unknown as { dataItem?: PivotRow })?.dataItem;
          const editable = item?.EDIT_YN === 'Y';
          e.cell.classList.toggle('wj-cell-editable', editable);
        }
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 게이트 — EDIT_YN='Y' 행 × M_ 셀만 (고정 3컬럼은 SEARCH_ONLY)
    const beginningEditHandler = (
      s: FlexGridType<PivotRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!/^M_\d{6}$/.test(binding)) {
        e.cancel = true;
        return;
      }
      const item = s.rows[e.row]?.dataItem as PivotRow | undefined;
      e.cancel = item?.EDIT_YN !== 'Y';
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 편집 종료 — 변경 수집 ('^' bulk 저장 대상)
    const cellEditEndedHandler = (s: FlexGridType<PivotRow>, e: { row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!/^M_\d{6}$/.test(binding)) return;
      const item = s.rows[e.row]?.dataItem as PivotRow | undefined;
      if (!item) return;
      const value = Number(String(item[binding] ?? '').replace(/,/g, ''));
      if (!Number.isFinite(value)) return;
      const ym = binding.slice(2);
      const key = `${item.DIVISION_ID}|${item.CURRENCY}|${item.UNIT_CURRENCY}|${ym}`;
      editsRef.current.set(key, { row: item, ym, value });
      setEditCount(editsRef.current.size);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    class ExchangeMerge extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';
        if (panel.cellType === CellType.TopLeft) {
          return new CellRange(0, 0, panel.rows.length - 1, panel.columns.length - 1);
        }
        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) {
            return new CellRange(0, c, panel.rows.length - 1, c);
          }
          // 동적 1단(년도) 수평 머지 — 커스텀 MergeManager 설치 시 네이티브 span 무효 (hook #108 ②)
          if (binding.startsWith('M_') && r === 0) {
            const yearOf = (b: string): string => (b.startsWith('M_') ? b.slice(2, 6) : '');
            const y = yearOf(binding);
            let c1 = c,
              c2 = c;
            while (c1 > 0 && yearOf(panel.columns[c1 - 1]?.binding ?? '') === y) c1--;
            while (
              c2 < panel.columns.length - 1 &&
              yearOf(panel.columns[c2 + 1]?.binding ?? '') === y
            )
              c2++;
            if (c1 === c2) return null;
            return new CellRange(0, c1, 0, c2);
          }
          return null;
        }
        if (panel.cellType === CellType.Cell) {
          if (binding === 'DIVISION_ID' || binding === 'CURRENCY') {
            const view = panel.rows;
            const ri = (i: number): PivotRow | undefined =>
              view[i]?.dataItem as PivotRow | undefined;
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
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, pivotRows, ymKeys, fixedBindings]);

  // ⭐⭐ 헤더 총높이 48px 상시 정규화 (2단=24×2 — CustomDialog open 애니메이션 지연 build 재발 경로 방어)
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<PivotRow> | null = null;
    const normalizeHeader = () => {
      const g = gridRef.current;
      if (!g) return;
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      const ok =
        Math.round(headerRows.defaultSize) === per &&
        Array.from({ length: headerRows.length }).every(
          (_, i) => Math.round(headerRows[i]?.height ?? 0) === per
        );
      if (ok) return;
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    const loop = () => {
      const g = gridRef.current;
      if (g && g !== attached) {
        try {
          attached?.updatedLayout.removeHandler(normalizeHeader);
        } catch {
          /* destroyed instance */
        }
        g.updatedLayout.addHandler(normalizeHeader);
        attached = g;
      }
      try {
        normalizeHeader();
      } catch {
        /* unmount race */
      }
      raf = requestAnimationFrame(loop);
    };
    loop();
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout.removeHandler(normalizeHeader);
      } catch {
        /* unmount race */
      }
    };
  }, [open]);

  const handleFind = () => {
    if (periodFrom > periodTo) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_시작 월이 종료 월보다 늦을 수 없습니다.'),
      });
      return;
    }
    editsRef.current.clear();
    setEditCount(0);
    void refetch?.();
  };

  // ⭐ 저장 — '^' bulk 6키 (DMF0042_SAVE_DM_BP_EXCHANGE_RATE — activeFlag='M'/yyyymmdd=월 1일)
  const handleSave = async () => {
    const edits = [...editsRef.current.values()];
    if (edits.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    const join = (sel: (e: (typeof edits)[number]) => string): string => edits.map(sel).join('^');
    const res = await callSaveExchangeRate({
      activeFlag: join(() => 'M'),
      divisionId: join(e => e.row.DIVISION_ID),
      yyyymmdd: join(e => `${e.ym}01`),
      currency: join(e => e.row.CURRENCY),
      unitCurrency: join(e => e.row.UNIT_CURRENCY),
      exchangePrice: join(e => String(e.value)),
    });
    if (!res.ok) {
      void setAlert({
        type: 'alert',
        content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
    editsRef.current.clear();
    setEditCount(0);
    setSavedAny(true);
    void refetch?.();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      handleClose={() => modalClose(savedAny)}
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
                          placeholder='YYYYMM'
                        />
                        <span>~</span>
                        <InputField
                          value={periodTo}
                          onChange={e => setPeriodTo(e.target.value)}
                          placeholder='YYYYMM'
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
              staticColumns={gridStaticColumns}
              dynamicColumns={gridDynamicColumns}
              autoGenerateColumns={false}
              frozenColumns={fixedBindings.length}
              allowSorting={false}
              allowMerging={AllowMerging.All}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={editCount > 0 ? `Save (${editCount})` : 'Save'}
              onClick={() => void handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={() => modalClose(savedAny)}
            />
          </div>
        </div>
      }
    />
  );
};
