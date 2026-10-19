import type { FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import {
  ColumnLayoutModal,
  CustomDropdown,
  MainTitle,
  SubTitle,
  toColumnLayoutSettings,
} from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  CAPA_WORK_SAVE_LIMIT,
  CATEGORY_OPTIONS,
  DAY_TYPE_OPTIONS,
  MEASURE,
  MENU_ID,
  MSG,
  SHEETS,
} from './capa-report-small.constants';
import type { CapaReportSmallRow } from './capa-report-small.types';
import styles from './CapaReportSmall.module.scss';
import { CapaReportSmallForm } from './components/CapaReportSmallForm';
import { CapaReportSmallGrid } from './components/CapaReportSmallGrid';
import { CopySelectModal } from './components/modals';
import { useCapaReportSmallValidation } from './hooks/useCapaReportSmallValidation';
import { useCapaReportSmallStore } from './useCapaReportSmallStore';
import { saveTitleSet, TITLESET_SHEET } from './utils/capa-report-small.api';
import { applyBulkInput, validateBulkValue } from './utils/capa-report-small.bulkInput';
import { isCellEditable } from './utils/capa-report-small.editLock';
import { buildSavePayload } from './utils/capa-report-small.save';

/**
 * SCP0098 Production Plan Line (CAPA Mobility IT / CAPA Report Small).
 *   pivot measure 그리드 + 동적 기간컬럼 + measure별 편집잠금 + 3분기 저장 + Week/Month 복사.
 *   Insert 없음(조회형 편집). Division '40' 고정. 편집모드 미이식(편집 기본 ON, mount canEdit 1회).
 */
export const CapaReportSmall = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateSearch } = useCapaReportSmallValidation();

  const gridRef = useRef<TFlexGrid<CapaReportSmallRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker | null>(null);

  const [copyOpen, setCopyOpen] = useState(false);
  const [columnOpen, setColumnOpen] = useState(false);
  const [measureOpen, setMeasureOpen] = useState(false);
  const [saving, setSaving] = useState(false);

  const searchParams = useCapaReportSmallStore(s => s.searchParams);
  const filters = useCapaReportSmallStore(s => s.filters);
  const openSearchArea = useCapaReportSmallStore(s => s.openSearchArea);
  const setOpenSearchArea = useCapaReportSmallStore(s => s.setOpenSearchArea);
  const isDetail = useCapaReportSmallStore(s => s.isDetail);
  const setIsDetail = useCapaReportSmallStore(s => s.setIsDetail);
  const staticColumns = useCapaReportSmallStore(s => s.staticColumns);
  const staticMeasures = useCapaReportSmallStore(s => s.staticMeasures);
  const setFilters = useCapaReportSmallStore(s => s.setFilters);
  const clearFilters = useCapaReportSmallStore(s => s.clearFilters);
  const fetchStaticColumns = useCapaReportSmallStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useCapaReportSmallStore(s => s.fetchStaticMeasures);

  // 편집 기본 ON — 권한은 mount 시 1회(convert-core §2.4). editMode 상태 신설 금지.
  const canEdit = hasButton('EDIT');

  // 일괄입력 도구(cboCategory/cboDayWeek/txtInpuValue) — 조회조건 아님, 그리드 상단 스트립.
  const [bulkCategory, setBulkCategory] = useState<string>(MEASURE.NO_WORK);
  const [bulkDayType, setBulkDayType] = useState<string>(DAY_TYPE_OPTIONS[0].value);
  const [bulkValue, setBulkValue] = useState('');

  // 마운트 1회 — 컬럼/measure 메타 fetch + keep-alive stale filters 무효화(자동조회 금지).
  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const rows = useMemo<CapaReportSmallRow[]>(
    () => (data as { o_rc?: CapaReportSmallRow[] })?.o_rc ?? [],
    [data]
  );

  const staticBindingSet = useMemo(() => new Set(staticColumns.map(c => c.colNm)), [staticColumns]);

  // 저장 성공 시 편집 추적 초기화(재조회로 새 데이터 도착).
  useEffect(() => {
    editTrackerRef.current?.clearChanges();
  }, [data]);

  const invalidateAfterSave = useCallback(() => {
    void queryClient.invalidateQueries({ queryKey: [tabId] });
  }, [tabId]);

  // 3분기 저장 — onSuccess/onError 는 no-op override(단일 흐름 조정). 표준 useProcMutation.
  const noop = useCallback(() => undefined, []);
  const { mutateAsync: saveProductRate } = useProcMutation<MENU_ID, SHEETS.CAPA_PRODUCT_RATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.CAPA_PRODUCT_RATE,
    tabId,
    onSuccess: noop,
    onError: noop,
  });
  const { mutateAsync: saveCapaMonth } = useProcMutation<MENU_ID, SHEETS.CAPA_MONTH>({
    menuId: MENU_ID,
    sheetName: SHEETS.CAPA_MONTH,
    tabId,
    onSuccess: noop,
    onError: noop,
  });
  const { mutateAsync: saveCapaWork } = useProcMutation<MENU_ID, SHEETS.CAPA_WORK>({
    menuId: MENU_ID,
    sheetName: SHEETS.CAPA_WORK,
    tabId,
    onSuccess: noop,
    onError: noop,
  });

  const handleSearch = async () => {
    const err = validateSearch();
    if (err === 'PERIOD_REQUIRED' || err === 'PERIOD_ORDER') {
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_REQUIRED, { defaultValue: 'Enter period.' }) });
      return;
    }
    const isSame = setFilters();
    if (isSame) void refetch();
  };

  const handleSave = async () => {
    const tracker = editTrackerRef.current;
    if (!tracker) return;
    const userId = useSessionStore.getState().session.userId ?? '';
    const payload = buildSavePayload(
      tracker,
      { from: searchParams.startYyyymmdd, to: searchParams.endYyyymmdd },
      userId
    );
    // Capa Work 10000건 상한 (design 03 §4.4, validations #16/#23).
    if (payload.capaWork.length > CAPA_WORK_SAVE_LIMIT) {
      await setAlert({
        type: 'alert',
        content: t('MSG00000', { defaultValue: 'Cannot save more than 10,000 rows.' }),
      });
      return;
    }
    const total = payload.productRate.length + payload.capaMonth.length + payload.capaWork.length;
    if (total === 0) {
      setToast({ type: 'default', message: t(MSG.NO_CHANGES, { defaultValue: 'No changes to save.' }) });
      return;
    }
    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, { defaultValue: 'Save?' }) });
    if (!confirmed) return;

    setSaving(true);
    try {
      if (payload.productRate.length) await saveProductRate(payload.productRate);
      if (payload.capaMonth.length) await saveCapaMonth(payload.capaMonth);
      if (payload.capaWork.length) await saveCapaWork(payload.capaWork);
      setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: 'Saved.' }) });
      tracker.clearChanges();
      invalidateAfterSave();
    } catch (e) {
      await setAlert({
        type: 'alert',
        content:
          (e instanceof Error && e.message) || t(MSG.SAVE_ERROR, { defaultValue: 'Save error.' }),
      });
    } finally {
      setSaving(false);
    }
  };

  // 복사 — CopySelect(Week/Month) → P_COPY_MONTH_WEEK → 성공 재조회 (design 03 §4.5).
  const handleCopy = async (dayType: string) => {
    const userId = useSessionStore.getState().session.userId ?? '';
    setSaving(true);
    try {
      // P_COPY_MONTH_WEEK 계약(PKG_SCP0098 본문 실측): 성공 = O_RC 첫 행 RESULT_CODE='S'(O_RESULT_CURSOR 공집합),
      // 실패 = O_RESULT_CURSOR 에 ERR_CODE/ERR_MESSAGE(O_RC 공집합). RESULT_CODE '0' 비교는 오판(성공 'S'를 오류로 처리).
      const res = await apiClient.post<{
        o_rc?: { RESULT_CODE?: string; RESULT_CNT?: number }[];
        o_result_cursor?: { ERR_CODE?: string; ERR_MESSAGE?: string }[];
      }>(`/${MENU_ID}/copy/SAVE/call-proc`, { userId, dayType, debugMode: 'F' });
      const rc = (res.data?.result?.o_rc ?? [])[0];
      const errRow = (res.data?.result?.o_result_cursor ?? [])[0];
      const ok = res.status < 400 && !Number(res.data?.code) && String(rc?.RESULT_CODE ?? '') === 'S';
      if (!ok) {
        await setAlert({
          type: 'alert',
          content: String(errRow?.ERR_MESSAGE ?? '') || t(MSG.SAVE_ERROR, { defaultValue: 'Copy error.' }),
        });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVED, { defaultValue: 'Copied.' }) });
      invalidateAfterSave();
    } finally {
      setSaving(false);
    }
  };

  // 일괄입력(btnInput) — 선택영역 bulk-fill (design 03 §R2).
  const handleBulkInput = async () => {
    const g = gridRef.current;
    const tracker = editTrackerRef.current;
    if (!g || !tracker || !canEdit) return;
    const err = validateBulkValue(bulkCategory, bulkValue);
    if (err) {
      await setAlert({ type: 'alert', content: t('MSG00000', { defaultValue: 'Invalid input value.' }) });
      return;
    }
    const applyErr = applyBulkInput({
      grid: g,
      tracker,
      category: bulkCategory,
      dayType: bulkDayType,
      value: bulkValue,
      isCellEditable: (binding, row) => canEdit && isCellEditable(binding, row, staticBindingSet),
    });
    if (applyErr === 'NO_SELECTION') {
      await setAlert({ type: 'alert', content: t('MSG00000', { defaultValue: 'Select cells first.' }) });
    }
  };

  const columnLayoutSettings = useMemo(() => toColumnLayoutSettings(staticColumns), [staticColumns]);

  const hotkeyConfig = {
    search: () => void handleSearch(),
    // Insert 없음(조회형) — insert/delete/manual/upload 미노출(AS-IS 툴바에 없음).
    insert: false as const,
    delete: false as const,
    manual: false as const,
    upload: false as const,
    // 저장 = EDIT 권한(편집 기본 ON) AND SAVE 권한.
    save: canEdit && hasButton('SAVE') ? () => void handleSave() : (false as const),
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <CapaReportSmallForm onSearch={() => void handleSearch()} />}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SCP0098'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          // Detail 토글 — Daily bucket D_↔M_ 가시성(design 01 §2 B). LBL00316='Detail'(DB 실측). On/Off 는 토글 상태.
          { label: `${t('LBL00316', { defaultValue: 'Detail' })} ${isDetail ? 'On' : 'Off'}`, action: () => setIsDetail(!isDetail) },
          // Copy Data — hasButton('SAVE') 게이트(데이터 변경 액션, design 01 §2 D5). LBL01064='Copy Data'.
          ...(hasButton('SAVE')
            ? [{ label: t('LBL01064', { defaultValue: 'Copy Data' }), action: () => setCopyOpen(true) }]
            : []),
          // Column / Measure 설정(btnMeasure, design 03 §D-note / hook #120). LBL00309='Column' / LBL00310='Measure'.
          { label: t('LBL00309', { defaultValue: 'Column' }), action: () => setColumnOpen(true) },
          { label: t('LBL00310', { defaultValue: 'Measure' }), action: () => setMeasureOpen(true) },
        ]}
      />

      {/* 일괄입력 도구 스트립 (AS-IS 조회패널 3행 → 그리드 상단, design 01 §1 행3 매핑). */}
      <div className={styles.bulkStrip}>
        <FormItem
          label={t('LBL00036', { defaultValue: 'Category' })}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              value={bulkCategory}
              options={CATEGORY_OPTIONS.map(o => ({ label: o.label, value: o.value }))}
              onChange={(_, picked) => setBulkCategory(String(picked ?? MEASURE.NO_WORK))}
            />
          )}
        />
        <FormItem
          label={t('LBL01066', { defaultValue: 'Day Type' })}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              value={bulkDayType}
              options={DAY_TYPE_OPTIONS.map(o => ({ label: o.label, value: o.value }))}
              onChange={(_, picked) => setBulkDayType(String(picked ?? DAY_TYPE_OPTIONS[0].value))}
            />
          )}
        />
        <InputField
          className={styles.bulkValue}
          value={bulkValue}
          onChange={event => setBulkValue(event.target.value)}
        />
        <Button
          appearance='outlined'
          priority='normal'
          size='small'
          buttonLabel={t('LBL00872', { defaultValue: 'Input' })}
          disabled={!canEdit}
          onClick={() => void handleBulkInput()}
        />
      </div>

      <div className={styles.gridWrapper}>
        <ProgressIndicator shape='circular' placement='parent' open={saving} />
        <CapaReportSmallGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          data={rows}
          staticColumns={staticColumns}
          bucketType={searchParams.bucketType}
          isDetail={isDetail}
          canEdit={canEdit}
        />
      </div>

      <CopySelectModal open={copyOpen} onClose={() => setCopyOpen(false)} onConfirm={dayType => void handleCopy(dayType)} />

      <ColumnLayoutModal
        open={columnOpen}
        modalClose={() => setColumnOpen(false)}
        menuId={MENU_ID}
        sheetName={TITLESET_SHEET}
        columnType='C'
        divisionId={searchParams.divisionId}
        leftTitle={t('LBL00764', { defaultValue: 'Invisible' })}
        rightTitle={t('LBL00765', { defaultValue: 'Visible' })}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutSettings}
        onSave={settings => {
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet(
            'C',
            visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          ).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, { defaultValue: 'Save error.' }) });
              return;
            }
            fetchStaticColumns();
          });
        }}
      />

      <MeasureSelectModal
        open={measureOpen}
        modalClose={() => setMeasureOpen(false)}
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
          });
        }}
      />
    </>
  );
};
