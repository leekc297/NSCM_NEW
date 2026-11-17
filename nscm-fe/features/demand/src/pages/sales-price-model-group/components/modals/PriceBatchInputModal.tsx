import { toggleClass } from '@mescius/wijmo';
import { AllowMerging, CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  buildComboOptions,
  PeriodField,
  ProjectField,
  SalesSiteField,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { BUTTON_TYPE } from '@foundation/constants';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  MENU_ID,
  MODAL_PRICE_BATCH,
  MSG,
  PRC_RPSN,
  PRICE_BATCH_MAX_WEEKS,
  PRICE_BATCH_SITE_COMBO,
  PROC_ACTION,
  SEARCH_COMBO,
  SHEETS,
} from '../../sales-price-model-group.constants';
import type { ExchangeRateRow, ModelGroupRow } from '../../sales-price-model-group.types';
import { useSalesPriceModelGroupStore } from '../../useSalesPriceModelGroupStore';
import { buildPeriodColumns } from '../../utils/sales-price-model-group.grid';
import { attachHeaderHeightNormalizer } from '../../utils/sales-price-model-group.grid';
import { keepMergeManager, ModelGroupMergeManager } from '../../utils/sales-price-model-group.grid';
import { postSave } from '../../utils/sales-price-model-group.save';
import {
  buildBatchSaveEntries,
  describeRow,
  toSavePayload,
} from '../../utils/sales-price-model-group.save';
import { showAlert } from '../../utils/sales-price-model-group.util';
import { buildExchangeRateMap } from '../../utils/sales-price-model-group.util';
import {
  addWeeks,
  enumerateWeekStarts,
  isPastPeriodKey,
  mondayOf,
  thisWeekMonday,
  WEEK_KEY_RE,
} from '../../utils/sales-price-model-group.util';
import { cellOf, joinCodes } from '../../utils/sales-price-model-group.util';
import { ModelGroupField } from '../ModelGroupField';

import styles from './PriceBatchInputModal.module.scss';
import { usePriceBatchInputModalStore } from './priceBatchInputModalStore';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  // 메인 조회 시작일 — 팝업 기간 기본값(FROM)만 정한다. 그 뒤 팝업 기간은 메인과 무관하다(사용자 결정 2026-11-06).
  mainFromYyyymmdd: string;
  // 메인 End Customer — 팝업 Sales Site 목록 조건으로만 쓴다(원천 DMF0020 팝업과 같음).
  endCustomers: string[];
  onSaved: () => void;
}

// 행마다 묶음이 달라 묶음 조건 없이 값으로만 합친다 — Div → Team → End Customer → Sales Site → Project 순.
const MERGE_BINDINGS = ['DIVISION_ID', 'DEPT_ID', 'END_CUSTOMER', 'SCM_SITE_ID', 'PROJECT_CODE'];
const EMPTY_ROWS: ModelGroupRow[] = [];

// Price Batch Input (설계서 popup-1) — Model Group 단위로 기간 주 칸에 같은 LOC 를 한 번에 넣는다.
export const PriceBatchInputModal = ({
  open,
  modalClose,
  divisionId,
  mainFromYyyymmdd,
  endCustomers,
  onSaved,
}: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ModelGroupRow> | null>(null);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker<ModelGroupRow> | undefined>(undefined);
  const savingRef = useRef(false);
  const [saving, setSaving] = useState(false);

  const [scmSiteIds, setScmSiteIds] = useState<string[]>([]);
  const [projectCodes, setProjectCodes] = useState<string[]>([]);
  const [mdlGrs, setMdlGrs] = useState<string[]>([]);
  const [fromYyyymmdd, setFrom] = useState('');
  const [toYyyymmdd, setTo] = useState('');
  const appliedCond = usePriceBatchInputModalStore(s => s.appliedCond);
  const setAppliedCond = usePriceBatchInputModalStore(s => s.setAppliedCond);
  const staticColumns = useSalesPriceModelGroupStore(s => s.staticColumns[SHEETS.PRICE_BATCH]);
  const fetchBatchColumns = useSalesPriceModelGroupStore(s => s.fetchBatchColumns);

  const monday = thisWeekMonday();
  const comboParams = useMemo(() => ({ divisionId: `'${divisionId}'` }), [divisionId]);

  // 열 때마다 조건을 처음으로 — 기간 FROM = max(메인 시작일의 월요일, 이번 주 월요일), TO = FROM 부터 52주(설계서 F28).
  const mainFromRef = useRef(mainFromYyyymmdd);
  mainFromRef.current = mainFromYyyymmdd;
  useEffect(() => {
    if (!open) return;
    const mainMonday = mondayOf(mainFromRef.current);
    const from = mainMonday > monday ? mainMonday : monday;
    setScmSiteIds([]);
    setProjectCodes([]);
    setMdlGrs([]);
    setFrom(from);
    setTo(addWeeks(from, PRICE_BATCH_MAX_WEEKS - 1));
    setAppliedCond(null);
    void fetchBatchColumns(divisionId);
  }, [open]); // eslint-disable-line react-hooks/exhaustive-deps

  const [divisions] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  const divisionOptions = buildComboOptions(divisions).filter(o => o.value === divisionId);

  const filters = useMemo(
    () =>
      open && appliedCond
        ? {
            divisionId,
            scmSiteId: joinCodes(appliedCond.scmSiteIds, '^'),
            projectCode: joinCodes(appliedCond.projectCodes, '^'),
            mdlGr: joinCodes(appliedCond.mdlGrs, '^'),
            fromYyyymmdd: appliedCond.fromYyyymmdd,
            toYyyymmdd: appliedCond.toYyyymmdd,
          }
        : undefined,
    [open, appliedCond, divisionId]
  );
  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.PRICE_BATCH>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRICE_BATCH,
    tabId: MODAL_PRICE_BATCH,
    filters,
    enabled: !!filters,
  });
  // 저장 때 KRW · USD 계산용 환율 — 82 사업부 · 팝업 기간 (설계서 popup-1 Search D35).
  const exchangeFilters = useMemo(
    () =>
      filters
        ? { divisionId, fromYyyymmdd: filters.fromYyyymmdd, toYyyymmdd: filters.toYyyymmdd }
        : undefined,
    [filters, divisionId]
  );
  const { data: exchangeData } = useTabProcQuery<MENU_ID, SHEETS.PRICE_BATCH>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRICE_BATCH,
    procedureAction: PROC_ACTION.EXCHANGE_RATE as BUTTON_TYPE,
    tabId: MODAL_PRICE_BATCH,
    filters: exchangeFilters,
    enabled: !!exchangeFilters,
  });
  const rateMap = useMemo(
    () => buildExchangeRateMap(exchangeData?.o_rc1 as unknown as ExchangeRateRow[] | undefined),
    [exchangeData]
  );

  const rows = useMemo<ModelGroupRow[]>(
    () => (appliedCond ? ((data?.o_rc1 as unknown as ModelGroupRow[]) ?? EMPTY_ROWS) : EMPTY_ROWS),
    [data, appliedCond]
  );
  // 주 칸 — 조회 결과 키 ∪ 팝업 기간의 주 시작일 (값 없는 주도 칸을 세운다).
  const weekBindings = useMemo(() => {
    if (!appliedCond) return [];
    const set = new Set(
      enumerateWeekStarts(appliedCond.fromYyyymmdd, appliedCond.toYyyymmdd).map(d => `W_${d}`)
    );
    for (const row of rows) for (const k of Object.keys(row)) if (WEEK_KEY_RE.test(k)) set.add(k);
    return [...set].sort();
  }, [rows, appliedCond]);
  const periodColumns = useMemo(
    () => buildPeriodColumns(weekBindings, BUCKET_TYPE.WEEKLY, 80),
    [weekBindings]
  );

  const visibleBindings = useMemo(
    () => staticColumns.filter(c => c.visible !== false).map(c => c.colNm),
    [staticColumns]
  );
  const visibleRef = useRef(visibleBindings);
  visibleRef.current = visibleBindings;
  const mergeManager = useMemo(
    () =>
      new ModelGroupMergeManager(
        () => MERGE_BINDINGS.filter(b => visibleRef.current.includes(b)),
        () => visibleRef.current,
        () => true
      ),
    []
  );

  // 편집 — Price Master Representative(메타 M)는 공용 판정, Batch Price 는 Y 인 행만, 주 칸은 표시 전용(설계서 F50 · G55 · F56).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const isYes = (row: ModelGroupRow | undefined) => cellOf(row, 'PRC_RPSN') === PRC_RPSN.YES;
    const format = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const row = (e.panel.rows[e.row] as unknown as { dataItem?: ModelGroupRow })?.dataItem;
      if (binding === 'PRICE_ALL') {
        toggleClass(e.cell, 'wj-cell-editable', !g.isReadOnly && isYes(row));
        toggleClass(e.cell, 'wj-cell-non-editable', false);
      } else if (WEEK_KEY_RE.test(binding)) {
        toggleClass(e.cell, 'wj-cell-editable', false);
        toggleClass(e.cell, 'wj-cell-non-editable', isPastPeriodKey(binding, monday));
      }
    };
    const guard = (s: FlexGrid<ModelGroupRow>, e: { cancel: boolean; row: number; col: number }) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as ModelGroupRow | undefined;
      if (WEEK_KEY_RE.test(binding) || (binding === 'PRICE_ALL' && !isYes(row))) e.cancel = true;
    };
    // N 으로 바꾸면 넣어 둔 Batch Price 는 쓰지 않으므로 비운다(N 이면 Measure 값 갱신 없음, 설계서 I36).
    const ended = (s: FlexGrid<ModelGroupRow>, e: { row: number; col: number }) => {
      const row = s.rows[e.row]?.dataItem as ModelGroupRow | undefined;
      if (s.columns[e.col]?.binding === 'PRC_RPSN' && row && !isYes(row)) {
        row.PRICE_ALL = null;
        s.invalidate();
      }
    };
    const onScroll = () => g.invalidate();
    g.formatItem.addHandler(format);
    g.beginningEdit.addHandler(guard);
    g.pastingCell.addHandler(guard);
    g.cellEditEnded.addHandler(ended);
    g.scrollPositionChanged.addHandler(onScroll);
    const detachHeader = attachHeaderHeightNormalizer(g as never);
    // 팝업도 닫을 때 미저장 변경 되돌리기가 머지를 기본값으로 바꾼다 — 다시 건다.
    const detachMerge = keepMergeManager(g as never, mergeManager);
    g.invalidate(true);
    return () => {
      g.formatItem.removeHandler(format);
      g.beginningEdit.removeHandler(guard);
      g.pastingCell.removeHandler(guard);
      g.cellEditEnded.removeHandler(ended);
      g.scrollPositionChanged.removeHandler(onScroll);
      detachHeader();
      detachMerge();
    };
  }, [periodColumns, staticColumns, monday, mergeManager]);

  // 조회 검사 순서 (설계서 popup-1 N28): 역전 → 과거 → 월요일 아님 → Div 빈 값, 그리고 최대 52주.
  //   기간은 조회할 때 그 주 월요일로 맞춘다(N28). 입력 중에 맞추면 타이핑 도중의 날짜(예: 일 자리 첫 글자
  //   '1' → 11/01 일요일)가 앞 주 월요일로 바뀌어 입력이 깨진다(2026-11-06).
  const handleSearch = () => {
    const from = mondayOf(fromYyyymmdd);
    const to = mondayOf(toYyyymmdd);
    setFrom(from);
    setTo(to);
    if (from > to) return showAlert(t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다.'));
    if (from < monday) return showAlert(t(MSG.PAST_PERIOD, '_과거 구간은 일괄입력이 불가합니다.'));
    // 날짜가 아닌 값은 mondayOf 가 그대로 돌려주므로 여기서 걸린다.
    if (mondayOf(from) !== from || mondayOf(to) !== to) {
      return showAlert(t(MSG.MONDAY_ONLY, '_기간을 다시 선택하여 주십시오.(월요일)'));
    }
    if (!divisionId) return showAlert(t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'));
    if (to > addWeeks(from, PRICE_BATCH_MAX_WEEKS - 1)) {
      return showAlert(t(MSG.MAX_PERIOD, '_최대 조회일은 From Date + {0} 입니다.').replace('{0}', `${PRICE_BATCH_MAX_WEEKS}W`));
    }
    setAppliedCond({ scmSiteIds, projectCodes, mdlGrs, fromYyyymmdd: from, toYyyymmdd: to });
  };

  const runSave = async () => {
    if (!appliedCond) return;
    const weeks = enumerateWeekStarts(appliedCond.fromYyyymmdd, appliedCond.toYyyymmdd).filter(
      d => d >= monday
    );
    if (weeks.length === 0) return showAlert(t(MSG.NO_DATA, '_조회된 데이터가 없습니다.'));
    gridRef.current?.finishEditing();
    const built = buildBatchSaveEntries({
      rows,
      originals: editTrackerRef.current?.getOriginalValues(),
      weeks,
      rateMap,
    });
    if (!built.ok) {
      return showAlert(`${t(MSG.REQUIRED_INPUT, '_필수 입력란을 입력해 주세요.')} [${describeRow(built.row)}]`);
    }
    if (built.entries.length === 0) {
      useMessageStore.getState().setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return;
    }
    const confirmed = await useMessageStore
      .getState()
      .setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_저장 하시겠습니까?') });
    if (!confirmed) return;
    // 52주 채우기는 팝업 기간 시작 주부터(설계서 I36 — 메인 조회 구간과 무관).
    const result = await postSave(
      toSavePayload(built.entries, appliedCond.fromYyyymmdd),
      t(MSG.SAVE_FAIL, '_저장 중 오류가 발생했습니다.')
    );
    if (!result.ok) return showAlert(result.message);
    useMessageStore.getState().setToast({ type: 'success', message: t(MSG.SAVED, '_저장되었습니다.') });
    onSaved();
    modalClose();
  };

  // 이중 제출 차단 — 저장 왕복 중 다시 누르면 같은 인자가 두 번 들어간다.
  const handleSave = async () => {
    if (savingRef.current) return;
    savingRef.current = true;
    setSaving(true);
    try {
      await runSave();
    } finally {
      savingRef.current = false;
      setSaving(false);
    }
  };

  const loading = isLoading || isFetching;

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1400}
      handleClose={modalClose}
      disableButtonCancel
      // 셀 콤보(Price Master Representative) 편집 — MUI FocusTrap 이 Wijmo 드롭다운 선택을 버리지 않게 한다(POP-04).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL01274', '_Price Bulk Input')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t('LBL00664', '_Search')}
            onSearch={handleSearch}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00001', '_Div')}
                    labelAlign='right'
                    required
                    render={() => (
                      <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                    )}
                  />
                </Grid>
                <SalesSiteField
                  gridSize={3}
                  value={scmSiteIds}
                  onChange={setScmSiteIds}
                  division={divisionId}
                  comboId={PRICE_BATCH_SITE_COMBO}
                  endCustomer={joinCodes(endCustomers, ',')}
                />
                <ProjectField
                  gridSize={3}
                  value={projectCodes}
                  onChange={setProjectCodes}
                  division={divisionId}
                  scmSiteIds={scmSiteIds}
                  projectCodes={projectCodes}
                  multiCheckbox
                />
                <ModelGroupField
                  value={mdlGrs}
                  onChange={setMdlGrs}
                  divisionId={divisionId}
                  deptIds={[]}
                  endCustomers={[]}
                  scmSiteIds={scmSiteIds}
                  projectCodes={projectCodes}
                />
                <PeriodField
                  gridSize={3}
                  start={fromYyyymmdd}
                  end={toYyyymmdd}
                  onChange={(start, end) => {
                    // 입력값을 그대로 둔다 — 월요일 맞춤은 조회 때 한다(handleSearch).
                    setFrom(start);
                    setTo(end);
                  }}
                />
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator shape='circular' open={loading || saving} placement='parent' />
            <ResultArea title='' count={rows.length} gridRef={gridRef as never} gridFilterRef={gridFilterRef}>
              <DataGrid<ModelGroupRow>
                className={styles.grid}
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                editTrackerRef={editTrackerRef}
                itemsSource={rows}
                staticColumns={staticColumns}
                dynamicColumns={periodColumns}
                autoGenerateColumns={false}
                comboParams={comboParams}
                sheetName={SHEETS.PRICE_BATCH}
                // 팝업 저장은 main / SAVE 로 간다 — 편집 잠금도 main 시트 SAVE 권한으로 본다(설계서 L28, 사용자 결정 2026-11-06).
                saveAuth={{ sheetName: SHEETS.MAIN }}
                allowMerging={AllowMerging.All}
                mergeManager={mergeManager}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00111', '_Save')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={loading || saving || rows.length === 0}
              onClick={() => void handleSave()}
            />
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
