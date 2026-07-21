import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnSettingModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import {
  ExchangeRateModal,
  MeasureSelectModal,
  SavePricePeriodModal,
  VersionSelectModal,
} from './components/modals';
import {
  AUTH_MEASURES,
  MENU_ID,
  MSG,
  SHEETS,
  UPLOAD_HEADERS,
  UPLOAD_SHEET,
} from './forecast-price.constants';
import type {
  CalendarRow,
  ForecastPriceRow,
  MeasureAuthRow,
  MonthInfoRow,
  SpreadTitleRow,
} from './forecast-price.types';
import { useForecastPriceStore } from './useForecastPriceStore';
import { saveExcelUpload, saveTitleSet, TITLESET_SHEET } from './utils/forecast-price.api';
import { editableDayColumnsOf } from './utils/forecast-price.editLock';
import { buildSavePayload, buildSaveRows } from './utils/forecast-price.save';
import { validateSaveRows } from './utils/forecast-price.validate';

// ⭐ DMF0082 (Fcst&Price MGMT) — AS-IS DMF0082_FcstNPrice_Mgmt 1:1. 조회 = PKG_DMF0082.
//   P_DMF0082_GET_MAIN_DATA(12 IN+6 cursor) / 저장 = DMF0082_SAVE_MAIN_DATA(16 IN '^' bulk).
export const ForecastPrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<TFlexGrid<ForecastPriceRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker | null>(null);

  const [versionModalOpen, setVersionModalOpen] = useState(false);
  const [measureModalOpen, setMeasureModalOpen] = useState(false);
  const [columnModalOpen, setColumnModalOpen] = useState(false);
  const [exchangeModalOpen, setExchangeModalOpen] = useState(false);
  const [savePriceModalOpen, setSavePriceModalOpen] = useState(false);
  const [uploadModalOpen, setUploadModalOpen] = useState(false);
  const [insertedRows, setInsertedRows] = useState<ForecastPriceRow[]>([]);

  const { setAlert } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const filters = useForecastPriceStore(state => state.filters);
  const titleFilters = useForecastPriceStore(state => state.titleFilters);
  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const setFilters = useForecastPriceStore(state => state.setFilters);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useForecastPriceStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useForecastPriceStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useForecastPriceStore(state => state.fetchStaticMeasures);
  const setMeasureAuth = useForecastPriceStore(state => state.setMeasureAuth);
  const setCalendar = useForecastPriceStore(state => state.setCalendar);
  const setM3Cutoff = useForecastPriceStore(state => state.setM3Cutoff);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const staticMeasures = useForecastPriceStore(state => state.staticMeasures);

  // division-linked 메타(SHEET_COLUMNS/SHEET_MEASURE) — 81 전환 시 재fetch (fetch 는 호출 시점 divisionId 를 body 로 전송)
  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.divisionId]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.FCST_N_PRICE_40>({
    menuId: MENU_ID,
    sheetName: SHEETS.FCST_N_PRICE_40,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: titleFilters,
    enabled: titleFilters !== undefined,
  });

  // GET 부가 커서 반영 — drop1(월정보 M3_CUTOFF=M+4 경계, #4) / drop3(measure 편집권한 EDIT_AUTH_YN =
  //   AS-IS bEDIT_AUTH_* 원천) / drop4(배분 캘린더 MONTH_DAY_CNT·WEEK_DAY_CNT, #1).
  //   기준주차 경계는 editLock util 클라 계산(금주 월요일 — AS-IS L9133 동일 규칙).
  useEffect(() => {
    if (!data) return;
    const d = data as unknown as Record<string, unknown[]>;
    const authRows = (d.drop3 ?? []) as MeasureAuthRow[];
    if (authRows.length > 0) setMeasureAuth(authRows);
    setM3Cutoff((d.drop1 ?? []) as MonthInfoRow[]);
    setCalendar((d.drop4 ?? []) as CalendarRow[]);
    setInsertedRows([]); // 재조회 = pending insert reset (hook #97)
    editTrackerRef.current?.clearChanges();
  }, [data, setMeasureAuth, setM3Cutoff, setCalendar]);

  const spreadTitle = useMemo(
    () => ((titleData as unknown as Record<string, unknown[]>)?.data ?? []) as SpreadTitleRow[],
    [titleData]
  );

  const gridRows = useMemo(
    () => [...insertedRows, ...(data?.fcstNPrice ?? [])],
    [insertedRows, data]
  );

  const editableDayColumns = useMemo(
    () =>
      editableDayColumnsOf(
        spreadTitle
          .map(r => String(r.COLUMN_NAME ?? ''))
          .filter(b => /^D_\d{8}$/.test(b))
      ),
    [spreadTitle]
  );

  const isCurVersion = searchParams.versionType.trim() === 'Current';

  // ── Search (AS-IS FindButton — V1~V4 검증 후 조회) ──
  const handleSubmit = async () => {
    if (!searchParams.divisionId) {
      await setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_Select Division.') });
      return;
    }
    if (!searchParams.versionType.trim()) {
      await setAlert({ type: 'alert', content: t(MSG.VERSION_REQUIRED, '_Select Version.') });
      return;
    }
    const from = searchParams.startYyyymmdd;
    const to = searchParams.endYyyymmdd;
    if (from && to && from > to) {
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '_Invalid period.') });
      return;
    }
    // 3년 초과 (AS-IS MSG00164 — 종료일 보정 후 재입력 안내)
    const fromYear = Number(from.slice(0, 4));
    if (Number(to.slice(0, 4)) - fromYear >= 3) {
      setSearchParams({ endYyyymmdd: `${fromYear + 2}${from.slice(4)}` });
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_3Y, '_Period exceeds 3 years.') });
      return;
    }
    const isSame = setFilters();
    if (isSame) void refetch();
  };

  // ── Insert (AS-IS InsertButton — Current 버전 조회 시에만) ──
  //   ⭐ #9 시드 복사 (AS-IS L2636~2676): 포커스 행이 있으면 키 10종을 새 행에 복제, 없으면 Measure='MKT_FCST'.
  const handleInsert = () => {
    if (!isCurVersion) return;
    const g = gridRef.current;
    const seed = g?.rows[g.selection.row]?.dataItem as WijmoRowItem | undefined;
    const str = (v: unknown): string => (typeof v === 'string' ? v : '');
    const baseDivision = str((data?.fcstNPrice ?? [])[0]?.DIVISION_ID);
    const newRow = {
      CRUD_TYPE: 'I',
      DIVISION_ID: searchParams.divisionId || str(seed?.['DIVISION_ID']) || baseDivision,
      END_CUSTOMER: str(seed?.['END_CUSTOMER']),
      PROJECT_CODE: str(seed?.['PROJECT_CODE']),
      PLANT_SITE_ID: '',
      SCM_SITE_ID: str(seed?.['SCM_SITE_ID']),
      ITEM_ID: str(seed?.['ITEM_ID']),
      DOM_EXP: str(seed?.['DOM_EXP']),
      FCST_TYPE: str(seed?.['FCST_TYPE']),
      INCOTERMS: str(seed?.['INCOTERMS']),
      MEASURE: seed ? str(seed['MEASURE']) : 'MKT_FCST',
      CURRENCY: str(seed?.['CURRENCY']),
      CELL_PROD_SITE_ID: str(seed?.['CELL_PROD_SITE_ID']),
      // 시드 행 BUCKET(요일비트) 승계 — 배분 요일 유지 (없으면 #2 캐스케이드/기본요일).
      BUCKET: str(seed?.['BUCKET']),
      EDIT_FLAG: 'Y',
    } as unknown as ForecastPriceRow;
    setInsertedRows(prev => [newRow, ...prev]);
  };

  // ── Bucket 전환 가드 (AS-IS cboBucketType_Click :3361 — Insert 행 존재 시 MSG00227 차단) ── #13
  const handleBucketChange = (bucket: string) => {
    if (insertedRows.length > 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.BUCKET_CHANGE_BLOCK, '_Cannot change bucket while rows are inserted.'),
      });
      return;
    }
    setSearchParams({ bucketType: bucket });
  };

  // ── Delete (AS-IS DeleteButton — measure 4종 + 권한 검증 후 D 마킹 / I 행 즉시 제거) ──
  const handleDelete = async () => {
    const g = gridRef.current;
    if (!g) return;
    const item = g.rows[g.selection.row]?.dataItem as WijmoRowItem | undefined;
    if (!item) return;
    const crud = item['CRUD_TYPE'];
    if (crud === 'I') {
      setInsertedRows(prev => prev.filter(r => (r as unknown as WijmoRowItem) !== item));
      return;
    }
    if (crud === 'D') {
      item['CRUD_TYPE'] = undefined; // 삭제 취소 (AS-IS 토글)
      g.invalidate();
      return;
    }
    const measure = String(item['MEASURE'] ?? '');
    if (!(AUTH_MEASURES as readonly string[]).includes(measure) || measureAuth[measure] === false) {
      await setAlert({ type: 'alert', content: t(MSG.MEASURE_NOT_EDITABLE, '_Not editable measure.') });
      return;
    }
    item['CRUD_TYPE'] = 'D';
    g.invalidate();
  };

  // ── Save (AS-IS SaveButton — 검증 → MSG00001 확인 → 16 IN '^' bulk → 재조회) ──
  const handleSave = async () => {
    const tracker = editTrackerRef.current;
    if (!tracker) return;
    const allRows = gridRows as unknown as WijmoRowItem[];

    const validationError = validateSaveRows(allRows, editableDayColumns);
    if (validationError === 'CURRENCY_REQUIRED') {
      await setAlert({ type: 'alert', content: t(MSG.REQUIRED, '_{0} is required.').replace('{0}', 'Currency') });
      return;
    }
    if (validationError === 'QTY_PRICE_REQUIRED') {
      await setAlert({ type: 'alert', content: t(MSG.QTY_PRICE_REQUIRED, '_Qty/Price required.') });
      return;
    }
    if (validationError === 'DUP_NEW_ROW') {
      await setAlert({ type: 'alert', content: t(MSG.DUP_NEW_ROW, '_Duplicated new row.') });
      return;
    }

    const saveRows = buildSaveRows(allRows, tracker, editableDayColumns);
    if (saveRows.length === 0) return;

    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '_Save?') });
    if (!confirmed) return;

    const userId = useSessionStore.getState().session.userId ?? '';
    // '^' bulk payload — useProcMutation 의 array unfold 를 피해 call-proc 직접 (표준 패턴).
    const res = await apiClient.post<{ CODE?: string; MSG?: string }[]>(
      `/${MENU_ID}/FcstNPrice/SAVE/call-proc`,
      buildSavePayload(saveRows, userId)
    );
    const result = (res.data.result ?? [])[0];
    if (result && result.CODE !== undefined && String(result.CODE) !== '0') {
      await setAlert({ type: 'alert', content: String(result.MSG ?? t(MSG.DUP_SAVE_ERROR, '_Save error.')) });
      return;
    }
    await setAlert({ type: 'alert', content: t(MSG.SAVED, '_Saved.') });
    tracker.clearChanges();
    setInsertedRows([]);
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
  };

  const hotkeyConfig = {
    search: () => void handleSubmit(),
    manual: false as const, // Manual(F1) 버튼 미표시 (전체 삭제 방침 — 강민재)
    ...(hasButton('SAVE')
      ? {
          insert: handleInsert,
          delete: () => void handleDelete(),
          save: () => void handleSave(),
        }
      : { insert: false as const, delete: false as const, save: false as const }),
    // Excel 업로드 — 버튼 미표시 (2026-07-12 요청). 기능/모달은 보존, 버튼만 숨김.
    upload: false as const,
  };

  // AS-IS 커스텀 4버튼 — icon-only (mkt-fcst/DMF0020 표준: buttonLabel='' + iconComponent,
  //   label/title=Tooltip). ⚠️ LBL 실측 대사 완료 — LBL00661/00712/00605 (직전 LBL00741/752/753 은
  //   View PR/MKT FCST 미등록 제외/Include Internal Txn 오매핑 사고 → 교정 2026-07-12).
  const customButtons = [
    {
      // 명칭 = DMF0020 과 동일 'Price Batch Input' (LBL00662, 2026-07-12 요청)
      label: t('LBL00662', 'Price Batch Input'),
      title: t('LBL00662', 'Price Batch Input'),
      action: () => {
        // AS-IS V15: 수정모드(변경 존재) 시 차단 (MSG00669) 후 SavePricePeriodModal open
        const changed = editTrackerRef.current?.getOriginalValues();
        if (changed && changed.size > 0) {
          void setAlert({ type: 'alert', content: t(MSG.EDIT_MODE_NO_INPUT, '_Not in edit mode.') });
          return;
        }
        setSavePriceModalOpen(true);
      },
      buttonLabel: t('LBL00662', 'Price Batch Input'),
    },
    // 환율(Exchange Rate) — 메저(Measure) 버튼 바로 옆으로 이동 (2026-07-12 요청)
    {
      label: t('LBL00661', 'Exchange Rate'),
      title: t('LBL00661', 'Exchange Rate'),
      action: () => setExchangeModalOpen(true),
      iconComponent: <IcExchangeRate />,
      buttonLabel: '',
    },
    {
      label: t('LBL00712', '_Measure'),
      title: t('LBL00712', '_Measure'),
      action: () => setMeasureModalOpen(true),
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    {
      label: t('LBL00605', 'Column Setting'),
      title: t('LBL00605', 'Column Setting'),
      action: () => setColumnModalOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ForecastPriceForm
        onSubmit={() => {
          void handleSubmit();
        }}
        onOpenVersionLookup={() => setVersionModalOpen(true)}
        onBucketChange={handleBucketChange}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={gridRows.length}
        excelFileName='FcstPrice'
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <ForecastPriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={gridRows}
        spreadTitle={spreadTitle}
        editTrackerRef={editTrackerRef}
        onDuplicateKey={() => {
          void setAlert({ type: 'alert', content: t(MSG.DUP_NEW_ROW, '_Duplicated new row.') });
        }}
      />

      {/* Version 선택 (AS-IS SCM0002_VersionByWaterfallPopup — DMF0073 공유 계약) */}
      <VersionSelectModal
        open={versionModalOpen}
        modalClose={() => setVersionModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        onApply={versionIds => setSearchParams({ versionType: versionIds })}
      />

      {/* Measure 설정 (AS-IS btnMeasure — titleSet 'M' 영구 저장 → 재조회) */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />

      {/* Column 설정 (AS-IS btnColumn — 공용 ColumnSettingModal + titleSet 'C') */}
      <ColumnSettingModal
        open={columnModalOpen}
        modalClose={() => setColumnModalOpen(false)}
        menuId={MENU_ID}
        sheetName={TITLESET_SHEET}
        columnType={TITLESET_SHEET}
        divisionId={searchParams.divisionId}
        title={t('LBL00753', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        onSave={(settings: { COLUMN_NAME: string }[]) => {
          void saveTitleSet(
            'C',
            settings.map((s, i) => ({ name: s.COLUMN_NAME, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            fetchStaticColumns();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />

      {/* Exchange Rate (AS-IS btnExchangeRate — DMF0082_POPUP_GET_FUTUREPRICE_INFO) */}
      <ExchangeRateModal
        open={exchangeModalOpen}
        modalClose={() => setExchangeModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
      />

      {/* Save Price Period (AS-IS btnSavePricePeriod — DMF0082_SaveSalesFuturePrice_Popup 1:1) */}
      <SavePricePeriodModal
        open={savePriceModalOpen}
        modalClose={() => setSavePriceModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        defaultEndCustomers={searchParams.endCustomers}
        defaultSalesSites={searchParams.salesSites}
        onSaveResult={() => void queryClient.invalidateQueries({ queryKey: [MENU_ID] })}
      />

      {/* Excel Upload (AS-IS DMF0082_EXCEL_UPLOAD — 2-Step: Upload=검증분류 / OK=저장 mode=1.
          공용 FcstUploadModal(demand) + EXCEL_COLUMNS SHEET_NAME='FcstNPrice' 기이관 실측) */}
      <FcstUploadModal
        open={uploadModalOpen}
        modalClose={() => setUploadModalOpen(false)}
        menuId={MENU_ID}
        sheetName={UPLOAD_SHEET}
        attributeHeaders={[...UPLOAD_HEADERS]}
        onSave={saveExcelUpload}
        onUploaded={() => void queryClient.invalidateQueries({ queryKey: [MENU_ID] })}
      />
    </>
  );
};
