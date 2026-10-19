import type { FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  CAPA_WORK_SAVE_LIMIT,
  CATEGORY_OPTIONS,
  DEFAULT_BUCKET,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
} from './capa-mobility-it.constants';
import type { CapaMobilityItRow } from './capa-mobility-it.types';
import styles from './CapaMobilityIt.module.scss';
import { CapaMobilityItForm } from './components/CapaMobilityItForm';
import { CapaMobilityItGrid } from './components/CapaMobilityItGrid';
import { BulkUpdateModal, CopySelectModal } from './components/modals';
import { useCapaMobilityItValidation } from './hooks/useCapaMobilityItValidation';
import { useCapaMobilityItStore } from './useCapaMobilityItStore';
import { saveTitleSet } from './utils/capa-mobility-it.api';
import {
  applyBulkInput,
  type BulkType,
  hasBulkSelection,
  validateBulkType,
  validateBulkValue,
} from './utils/capa-mobility-it.bulkInput';
import { isCellEditable } from './utils/capa-mobility-it.editLock';
import { buildSavePayload } from './utils/capa-mobility-it.save';

/**
 * SCP0098 Production Plan Line (CAPA Mobility IT / CAPA Report Small).
 *   pivot measure 그리드 + 동적 기간컬럼 + measure별 편집잠금 + 3분기 저장 + Week/Month 복사.
 *   Insert 없음(조회형 편집). Division '40' 고정. 편집모드 미이식(편집 기본 ON, mount canEdit 1회).
 */
export const CapaMobilityIt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateSearch } = useCapaMobilityItValidation();

  const gridRef = useRef<TFlexGrid<CapaMobilityItRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker | null>(null);

  const [copyOpen, setCopyOpen] = useState(false);
  const [measureOpen, setMeasureOpen] = useState(false);
  const [saving, setSaving] = useState(false);

  const searchParams = useCapaMobilityItStore(s => s.searchParams);
  const filters = useCapaMobilityItStore(s => s.filters);
  const openSearchArea = useCapaMobilityItStore(s => s.openSearchArea);
  const setOpenSearchArea = useCapaMobilityItStore(s => s.setOpenSearchArea);
  const staticColumns = useCapaMobilityItStore(s => s.staticColumns);
  const staticMeasures = useCapaMobilityItStore(s => s.staticMeasures);
  const setFilters = useCapaMobilityItStore(s => s.setFilters);
  const clearFilters = useCapaMobilityItStore(s => s.clearFilters);
  const fetchStaticColumns = useCapaMobilityItStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useCapaMobilityItStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useCapaMobilityItStore(s => s.restoreSearchConditions);

  // 편집 기본 ON — 권한은 mount 시 1회(convert-core §2.4). editMode 상태 신설 금지.
  const canEdit = hasButton('EDIT');

  // Bulk Update 팝업 — 대상 measure(category)는 화면에 measure 가 하나뿐이면 그 measure, 여럿이면 팝업을 열 때 그리드 선택 행의 MEASURE_UI 로 정한다.
  const [bulkOpen, setBulkOpen] = useState(false);
  const [bulkCategory, setBulkCategory] = useState('');

  // 마운트 1회 — 컬럼 메타 fetch + keep-alive stale filters 무효화(자동조회 금지)
  //   + F6 개인화 조회조건 복원(저장분 되불러오기, store 1회 가드).
  useEffect(() => {
    fetchStaticColumns();
    void fetchStaticMeasures();
    clearFilters();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const rows = useMemo<CapaMobilityItRow[]>(
    () => (data as { o_rc?: CapaMobilityItRow[] })?.o_rc ?? [],
    [data]
  );

  // 화면에 내려온 measure — Bulk Update 의 대상 measure 를 정한다.
  const presentMeasures = useMemo(() => {
    const present = new Set(rows.map(row => String((row as { MEASURE_UI?: string }).MEASURE_UI ?? '')));
    return CATEGORY_OPTIONS.map(o => o.value as string).filter(value => present.has(value));
  }, [rows]);

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
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_REQUIRED, '_Enter period.') });
      return;
    }
    const isSame = setFilters();
    if (isSame) void refetch();
  };

  const handleSave = async () => {
    if (saving) return; // save_status=="RUN" 가드(MSG00199) — 중복 호출(연속 hotkey/클릭) 재진입 차단.
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
        content: t('MSG00000', '_Cannot save more than 10,000 rows.'),
      });
      return;
    }
    const total = payload.productRate.length + payload.capaMonth.length + payload.capaWork.length;
    if (total === 0) {
      setToast({ type: 'default', message: t(MSG.NO_CHANGES, '_No changes to save.') });
      return;
    }
    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '_Save?') });
    if (!confirmed) return;

    setSaving(true);
    try {
      if (payload.productRate.length) await saveProductRate(payload.productRate);
      if (payload.capaMonth.length) await saveCapaMonth(payload.capaMonth);
      if (payload.capaWork.length) await saveCapaWork(payload.capaWork);
      setToast({ type: 'success', message: t(MSG.SAVED, '_Saved.') });
      tracker.clearChanges();
      invalidateAfterSave();
    } catch (e) {
      await setAlert({
        type: 'alert',
        content:
          (e instanceof Error && e.message) || t(MSG.SAVE_ERROR, '_Save error.'),
      });
    } finally {
      setSaving(false);
    }
  };

  // 복사 — CopySelect(Week/Month) → P_COPY_MONTH_WEEK → 성공 재조회 (design 03 §4.5).
  const handleCopy = async (dayType: string) => {
    if (saving) return;
    const userId = useSessionStore.getState().session.userId ?? '';
    setSaving(true);
    try {
      // P_COPY_MONTH_WEEK 계약(PKG_SCP0098 본문 실측): 성공 = O_RC 첫 행 RESULT_CODE='S'(O_RESULT_CURSOR 공집합),
      // 실패 = O_RESULT_CURSOR 에 ERR_CODE/ERR_MESSAGE(O_RC 공집합). RESULT_CODE '0' 비교는 오판(성공 'S'를 오류로 처리).
      // 응답 키 대소문자는 SCM_ADM_PROC_M.COL_NM 을 그대로 쓴다(BaseService, 소문자화 없음) — PROC_M 실측:
      // o_rc=소문자 / O_RESULT_CURSOR=대문자(SORT_ORD 15, PROC_RESULT). [[callproc-cursor-key-colnm-case-must-be-lower-o-rc1]]
      const res = await apiClient.post<{
        o_rc?: { RESULT_CODE?: string; RESULT_CNT?: number }[];
        O_RESULT_CURSOR?: { ERR_CODE?: string; ERR_MESSAGE?: string }[];
      }>(`/${MENU_ID}/copy/SAVE/call-proc`, { userId, dayType, debugMode: 'F' });
      const rc = (res.data?.result?.o_rc ?? [])[0];
      const errRow = (res.data?.result?.O_RESULT_CURSOR ?? [])[0];
      const ok = res.status < 400 && !Number(res.data?.code) && String(rc?.RESULT_CODE ?? '') === 'S';
      if (!ok) {
        await setAlert({
          type: 'alert',
          content: String(errRow?.ERR_MESSAGE ?? '') || t(MSG.SAVE_ERROR, '_Copy error.'),
        });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVED, '_Copied.') });
      invalidateAfterSave();
    } finally {
      setSaving(false);
    }
  };

  // Bulk Update 열기 — measure 가 하나뿐이면 그 measure 가 대상이고, 여럿이면 그리드에서 선택한 행의 measure 가 대상이다.
  // 대상을 정할 수 없으면 열지 않는다.
  const handleBulkOpen = async () => {
    const g = gridRef.current;
    if (!g || !canEdit) return;
    const row = g.rows[g.selection.row]?.dataItem as { MEASURE_UI?: string } | undefined;
    const category = presentMeasures.length === 1 ? presentMeasures[0] : (row?.MEASURE_UI ?? '');
    if (!CATEGORY_OPTIONS.some(o => o.value === category)) {
      await setAlert({ type: 'alert', content: t('MSG00000', '_Select a measure row first.') });
      return;
    }
    setBulkCategory(category);
    setBulkOpen(true);
  };

  // Bulk Update 확정 — Type 과 Value 로 대상 measure 의 셀에 일괄 입력한다(AS-IS Input 버튼). true = 팝업 닫기.
  const handleBulkConfirm = async (type: BulkType, value: string): Promise<boolean> => {
    const g = gridRef.current;
    const tracker = editTrackerRef.current;
    if (!g || !tracker || !canEdit) return false;
    if (validateBulkType(bulkCategory, type)) {
      await setAlert({ type: 'alert', content: t('MSG00000', '_Daily Capa does not allow weekday input.') });
      return false;
    }
    if (type === 'SelectDay' && !hasBulkSelection(g)) {
      await setAlert({ type: 'alert', content: t('MSG00000', '_Select cells first.') });
      return false;
    }
    if (validateBulkValue(bulkCategory, value)) {
      await setAlert({ type: 'alert', content: t('MSG00000', '_Invalid input value.') });
      return false;
    }
    const changed = applyBulkInput({
      grid: g,
      tracker,
      category: bulkCategory,
      type,
      value,
      isCellEditable: (binding, row) => canEdit && isCellEditable(binding, row, staticBindingSet),
    });
    if (changed === 0) {
      await setAlert({ type: 'alert', content: t('MSG00000', '_No cells to update.') });
      return false;
    }
    return true;
  };

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
      {openSearchArea && <CapaMobilityItForm onSearch={() => void handleSearch()} />}

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
          // Copy Data — hasButton('SAVE') 게이트(데이터 변경 액션, design 01 §2 D5).
          ...(hasButton('SAVE')
            ? [{ label: t(LBL.COPY_DATA, 'Copy Data'), action: () => setCopyOpen(true) }]
            : []),
          // Bulk Update — Category/Day Type/Input Value/Input 을 대체(To-Be 문서 SCP0098). EDIT 권한 게이트.
          ...(canEdit ? [{ label: 'Bulk Update', action: () => void handleBulkOpen() }] : []),
          // Column/Detail 버튼은 AS-IS 에 없어 제외(AS-IS 개인화 버튼은 btnMeasure 하나).
          // Measure 설정 — AS-IS btnMeasure(SCM0002_TitleSetForm 'M') 복원. 사용자별 표시 measure 와 순서를 저장한다.
          ...(hasButton('MEASURE_SELECT')
            ? [
                {
                  label: t(LBL.MEASURE, 'Measure'),
                  title: t(LBL.MEASURE, 'Measure'),
                  action: () => setMeasureOpen(true),
                  iconComponent: <IcMeasureSelect />,
                  buttonLabel: '',
                },
              ]
            : []),
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProgressIndicator shape='circular' placement='parent' open={saving} />
        <CapaMobilityItGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          data={rows}
          staticColumns={staticColumns}
          bucketType={DEFAULT_BUCKET}
          canEdit={canEdit}
        />
      </div>

      <BulkUpdateModal
        open={bulkOpen}
        onClose={() => setBulkOpen(false)}
        onConfirm={handleBulkConfirm}
      />

      <CopySelectModal open={copyOpen} onClose={() => setCopyOpen(false)} onConfirm={dayType => void handleCopy(dayType)} />

      {/* 표시 measure 는 메인 SP(P_GET_CAPA_MOBILITYIT)가 저장분(titleSet 'M')으로 거르므로 FE 필터 없이 저장 후 재조회한다. */}
      <MeasureSelectModal
        open={measureOpen}
        modalClose={() => setMeasureOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={codes => {
          const selected = codes ?? staticMeasures.map(m => m.colNm);
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_Save error.') });
              return;
            }
            void fetchStaticMeasures();
            void refetch();
          });
        }}
      />

    </>
  );
};
