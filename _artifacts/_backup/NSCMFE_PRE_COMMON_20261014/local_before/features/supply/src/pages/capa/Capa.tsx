import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { CapaNewModelPopup } from 'features/master/src/components';
import { type ReactNode, useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcGridColumnSetup } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { PageProps } from '@foundation/models';
import type { HotkeyConfig } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { type EditTracker } from '@foundation/utils';
import { ColumnLayoutModal, MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  COMBO,
  DAY_RANGE_MONTH_PARAM,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  VERSION_CURRENT,
} from './capa.constants';
import styles from './Capa.module.scss';
import type { CalendarRow, CapaRow, CapaSummary } from './capa.types';
import { CapaForm } from './components/CapaForm';
import { CapaGrid } from './components/CapaGrid';
import { NewVersionConfirmModal } from './components/modals/NewVersionConfirmModal';
import { VersionInfoModal } from './components/modals/VersionInfoModal';
import { useCapaStore } from './useCapaStore';
import type { EditContext } from './utils/capa.editLock';
import { buildSaveElems, buildSavePayload, validateSave } from './utils/capa.save';

/**
 * SCP0049 CAPA (Capacity) — 편집형 동적 pivot 화면(신규 전환 2026-09-26).
 * 조회 = PKG_SCP0049.P_GET_CAPA / 저장 = P_SAVE_CAPA(^-bulk). EDIT 모드 토글 미이식(편집=beginningEdit 종합식).
 * INSERT/DELETE = 명시적 무동작(() => undefined, R4·R5). 헤더 요약 5종 = o_rc2/o_rc3(R14).
 */
export const Capa = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const gridRef = useRef<TFlexGrid<CapaRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<CapaRow>>();

  const [newModelOpen, setNewModelOpen] = useState(false);
  const [newVersionOpen, setNewVersionOpen] = useState(false);
  const [versionInfoOpen, setVersionInfoOpen] = useState(false);
  const [columnSettingOpen, setColumnSettingOpen] = useState(false);
  // 저장 진행 플래그 setter — postSave 재진입 구간 표시(값은 현재 미구독, setter 만 사용).
  const [, setSaving] = useState(false);

  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const queryClient = useQueryClient();

  const searchParams = useCapaStore(state => state.searchParams);
  const filters = useCapaStore(state => state.filters);
  const calendarFilters = useCapaStore(state => state.calendarFilters);
  const isOpenSearchArea = useCapaStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCapaStore(state => state.setOpenSearchArea);
  const setFilters = useCapaStore(state => state.setFilters);
  const clearFilters = useCapaStore(state => state.clearFilters);
  const changeDivision = useCapaStore(state => state.changeDivision);
  const setSearchParams = useCapaStore(state => state.setSearchParams);
  const staticColumns = useCapaStore(state => state.staticColumns);
  const fetchStaticColumns = useCapaStore(state => state.fetchStaticColumns);
  const calendar = useCapaStore(state => state.calendar);
  const setCalendar = useCapaStore(state => state.setCalendar);
  const summary = useCapaStore(state => state.summary);
  const setSummary = useCapaStore(state => state.setSummary);
  const setVersionOptions = useCapaStore(state => state.setVersionOptions);
  const setPeriodMaxYyyymm = useCapaStore(state => state.setPeriodMaxYyyymm);

  // Version 옵션 재조회(02 §4 MDMVersionId_SCP) — division 확정 시 + New Version 생성 직후(NEW-03).
  const reloadVersionOptions = useCallback(
    (divId: string) => {
      if (!divId) return;
      void apiClient
        .getCombo({ comboId: COMBO.VERSION, divisionId: `'${divId}'` })
        .then(comboRows =>
          setVersionOptions(
            (comboRows ?? []).map(r => ({ code: String(r.CODE ?? ''), name: String(r.NAME ?? '') }))
          )
        )
        .catch(() => undefined);
    },
    [setVersionOptions]
  );

  // Division 콤보(기본선택용) — Form 과 동일 캐시 공유. 첫 항목(81) 기본선택(02 §2 #1·§4).
  const [divisionRows] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  useEffect(() => {
    if (searchParams.divisionId) return;
    const rows = (divisionRows ?? []);
    if (rows.length === 0) return;
    const rank = (c: string): number => (c === '81' ? 1 : c === '40' ? 2 : 3);
    const first = [...rows].sort((a, b) => rank(String(a.CODE)) - rank(String(b.CODE)))[0];
    if (first) changeDivision(String(first.CODE));
  }, [divisionRows, searchParams.divisionId, changeDivision]);

  // Period 초기화 — GET_DAY_RANGE(p_month=13) 1회(mount). 상한 = 당월+3년5개월(cs:317-333).
  useEffect(() => {
    const createdBy = useSessionStore.getState().session.userId ?? '';
    void (async () => {
      try {
        const res = await apiClient.post<{ o_rc?: { FROM_VALUE?: string; TO_VALUE?: string }[] }>(
          `/${MENU_ID}/dayRange/SEARCH/call-proc`,
          { createdBy, month: DAY_RANGE_MONTH_PARAM }
        );
        const row = res.data.result?.o_rc?.[0];
        if (row?.TO_VALUE) setSearchParams({ toYyyymm: String(row.TO_VALUE).slice(0, 6) });
      } catch {
        // 실패 시 기본값(당월) 유지 — SP 가 정본이나 미응답 시 화면 차단 금지.
      }
      setPeriodMaxYyyymm(dayjs().add(3, 'year').add(5, 'month').format('YYYYMM'));
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Division 변경 = Grid 초기화 의무 — 이전 division 결과·편집 추적 비움 + 컬럼 메타 재조회(§5-5).
  const prevDivisionRef = useRef(searchParams.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === searchParams.divisionId) {
      if (searchParams.divisionId) fetchStaticColumns();
      return;
    }
    prevDivisionRef.current = searchParams.divisionId;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    if (searchParams.divisionId) {
      fetchStaticColumns();
      // Version 옵션 로드(02 §4 — MDMVersionId_SCP). 엄밀 lazy-on-open 대신 division 확정 시 eager(iter-1 편차, 저위험).
      reloadVersionOptions(searchParams.divisionId);
    }
  }, [searchParams.divisionId, clearFilters, fetchStaticColumns, reloadVersionOptions]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CAPA>({
    menuId: MENU_ID,
    sheetName: SHEETS.CAPA,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: calendarFilters,
    enabled: calendarFilters !== undefined,
  });

  const rows = useMemo<CapaRow[]>(() => {
    const base = (data as { o_rc?: CapaRow[] } | undefined)?.o_rc ?? [];
    // AS-IS SetLineAssignVisible(cs:1572, 호출 cs:2910): checkEmpty ∧ ¬checkLine 조회 시 LA001(LINE ASSIGN
    //   우선순위) 행을 숨긴다. SP(P_GET_CAPA)는 LA001 을 포맷만 하고 행 제거는 클라 소관(BODY 실측) → 조회된
    //   filters 기준으로 표시 필터. (checkEmpty=Y·checkLine=N 조합에서만 발화)
    if (filters?.checkEmpty === 'Y' && filters?.checkLine === 'N') {
      // LOSS_COD 문자열 직접 비교(no-base-to-string 회피 — unknown 문자열화 금지).
      return base.filter(r => (r as Record<string, unknown>).LOSS_CODE !== 'LA001');
    }
    return base;
  }, [data, filters]);

  // 헤더 요약 5종(o_rc2 1~4열, o_rc3.FILTER — R14). Version 변경 시 clear 는 changeDivision/조회로 수렴.
  useEffect(() => {
    if (!data) return;
    const d = data as { o_rc2?: Record<string, string>[]; o_rc3?: Record<string, string>[] };
    const s = d.o_rc2?.[0];
    const p = d.o_rc3?.[0];
    const next: CapaSummary = {
      total: String(s?.TOT_PROGRESS ?? ''),
      auto: String(s?.AUTO_PROGRESS ?? ''),
      small: String(s?.SMALL_PROGRESS ?? ''),
      elec: String(s?.ELECTRODE_PROGRESS ?? ''),
      pic: String(p?.FILTER ?? ''),
    };
    setSummary(next);
    editTrackerRef.current?.clearChanges();
  }, [data, setSummary]);

  // 캘린더 커서 → 동적 기간칼럼 store.
  useEffect(() => {
    if (!calendarData) return;
    const cal = (calendarData as { o_rc?: unknown[] } | undefined)?.o_rc ?? [];
    setCalendar(cal as unknown as CalendarRow[]);
  }, [calendarData, setCalendar]);

  // 조회 — 검증 가드(02 §6): from>to · Day+1년 · 6년 초과 자동보정.
  const handleSearch = useCallback(async () => {
    const sp = searchParams;
    if (!sp.divisionId) {
      await setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_No division.') });
      return;
    }
    if (sp.fromYyyymm > sp.toYyyymm) {
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '_Invalid period.') });
      return;
    }
    const fromYear = Number(sp.fromYyyymm.slice(0, 4));
    const toYear = Number(sp.toYyyymm.slice(0, 4));
    if (sp.bucketDay && toYear - fromYear >= 1 && sp.toYyyymm.slice(0, 6) > sp.fromYyyymm.slice(0, 6)) {
      // Day 버킷 + 1년 초과 차단(MSG00354 등가).
      await setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_DAY_1Y, '_Day check: only 1 year.').replace('{0}', 'Day').replace('{1}', '1'),
      });
      return;
    }
    if (toYear - fromYear >= 6) {
      // 6년 초과 To 자동보정 후 중단(MSG00326 등가).
      setSearchParams({ toYyyymm: `${fromYear + 6}${sp.fromYyyymm.slice(4)}` });
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_6Y, '_Only 6 years.').replace('{0}', '6') });
      return;
    }
    const isSame = setFilters();
    if (isSame) void refetch();
  }, [searchParams, setAlert, setFilters, setSearchParams, refetch, t]);

  // 실패 셀 포커스(검증 실패 시 — 03 §5-5 SetActiveCell 등가).
  const focusCell = useCallback((row: CapaRow, binding: string) => {
    const g = gridRef.current;
    if (!g) return;
    let rowIdx = -1;
    for (let i = 0; i < g.rows.length; i += 1) {
      if (g.rows[i]?.dataItem === row) {
        rowIdx = i;
        break;
      }
    }
    const colIdx = g.columns.findIndex(c => c.binding === binding);
    if (rowIdx >= 0 && colIdx >= 0) {
      g.select(rowIdx, colIdx);
      g.scrollIntoView(rowIdx, colIdx);
    }
  }, []);

  // 실제 저장 실행 — false-success 차단. 저장 후 재조회 없이 dirty 리셋(AS-IS Set_RefreshAfterSave).
  const postSave = useCallback(
    async (elems: ReturnType<typeof buildSaveElems>) => {
      setSaving(true);
      try {
        const res = await apiClient.post<{ code?: string; message?: string }>(
          `/${MENU_ID}/capa/SAVE/call-proc`,
          buildSavePayload(elems)
        );
        if (res.status >= 400 || Number(res.data?.code)) {
          await setAlert({
            type: 'alert',
            content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Failed to save.'),
          });
          return;
        }
        setToast({
          type: 'success',
          message: t(MSG.SAVE_COUNT, '_{0} data saved.').replace('{0}', String(elems.length)),
        });
        editTrackerRef.current?.clearChanges();
        gridRef.current?.invalidate();
      } catch (e) {
        // P_SAVE_CAPA 롤백은 O_RESULT_CURSOR.CODE='-1' 이라 공용 responseInterceptor 가 throw 한다
        //   (memory callproc-cursor-code-failure-caught-by-interceptor — SP OUT 에 CODE 컬럼 존재).
        //   catch 가 없으면 조용한 실패(성공 토스트도 실패 알럿도 안 뜸)라 error.message(SP V_MSG) 를 실표시한다.
        await setAlert({
          type: 'alert',
          content: (e instanceof Error ? e.message : '').trim() || t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
      } finally {
        setSaving(false);
      }
    },
    [setAlert, setToast, t]
  );

  // 저장 — (1) 셀 값검증 게이트(GAP-01, 03 §3.1) → (2) 메타 필수검증 병행(useSaveWithValidation) → (3) ^-bulk 저장.
  const handleSave = useCallback(async () => {
    const tracker = editTrackerRef.current;
    if (!tracker) return;
    const violation = validateSave(rows, tracker);
    if (violation) {
      let content = t(violation.code, violation.fallback);
      violation.args.forEach((a, i) => {
        content = content.replace(`{${i}}`, a);
      });
      await setAlert({ type: 'alert', content });
      focusCell(violation.row, violation.binding);
      return;
    }
    const userId = useSessionStore.getState().session.userId ?? '';
    const elems = buildSaveElems(rows, tracker, userId);
    if (elems.length === 0) {
      await setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // convert-core §2.4: 메타 필수검증(useSaveWithValidation) 병행. INPUT_TP_CD 전부 'S' → 통과 후 postSave.
    saveWithValidation(elems, staticColumns, data => void postSave(data));
  }, [rows, setAlert, focusCell, saveWithValidation, staticColumns, postSave, t]);

  // 메일 발송 요청(R12) — REQUEST_CHK='True' 행만 P_SAVE_MAIL_SEND_REQUEST.
  const handleMailRequest = useCallback(async () => {
    const checked = rows.filter(r => String(r.REQUEST_CHK ?? '') === 'True');
    if (checked.length === 0) {
      await setAlert({ type: 'alert', content: t(MSG.NO_ROW_CHECKED, '_No rows checked.') });
      return;
    }
    const updateId = useSessionStore.getState().session.userId ?? '';
    const join = (fn: (r: CapaRow) => string): string => checked.map(fn).join('^');
    try {
      const res = await apiClient.post<{ code?: string; message?: string }>(
        `/${MENU_ID}/mailSend/SAVE/call-proc`,
        {
          divisionId: join(r => String(r.DIVISION_ID ?? '')),
          companyId: join(r => String(r.COMPANY_ID ?? '')),
          siteId: join(r => String(r.SITE_ID ?? '')),
          plantId: join(r => String(r.PLANT_ID ?? '')),
          factoryId: join(r => String(r.FACTORY_ID ?? '')),
          operationId: join(r => String(r.OPERATION_ID ?? '')),
          lineId: join(r => String(r.LINE_ID ?? '')),
          electrodeType: join(r => String(r.ELECTRODE_TYPE ?? '')),
          itemId: join(r => String(r.ITEM_ID ?? '')),
          laneQty: join(r => String(r.LANE_QTY ?? '')),
          lossCode: join(r => String(r.LOSS_CODE ?? '')),
          updateId,
        }
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        await setAlert({ type: 'alert', content: t(MSG.MAIL_ERROR, '_Error occurred.') });
        return;
      }
      setToast({ type: 'success', message: t(MSG.MAIL_SUCCESS, '_Mail requested.') });
    } catch {
      await setAlert({ type: 'alert', content: t(MSG.MAIL_ERROR, '_Error occurred.') });
    }
  }, [rows, setAlert, setToast, t]);

  const isCurrentVersion = searchParams.versionId === VERSION_CURRENT;
  const canSave = hasButton('SAVE');

  const editContext = useMemo<EditContext>(
    () => ({
      isCurrentVersion,
      userId: useSessionStore.getState().session.userId ?? '',
      groupId: useSessionStore.getState().session.groupId ?? '',
      // LANE_QTY 후보 수 — 셀 콤보는 서버 주도(메타 등록 후). LINE ASSIGN 행만 후보 가능(best-effort).
      laneQtyCandidateCountOf: (row: CapaRow) =>
        String(row.CATEGORY_ID ?? '') === 'LINE ASSIGN' ? 1 : 0,
    }),
    [isCurrentVersion]
  );

  // INSERT/DELETE = 명시적 무동작(R4·R5 — false·키생략 금지). EDIT 미등록(§11). SEARCH/SAVE 실핸들러.
  //   EXCEL = 공용 기본 다운로드를 hasButton('EXCEL') 로 게이트(NEW-02, CLAUDE.md §2 체크3). 권한 있으면
  //   키 생략 → 공용 DefaultButtonActions 의 excelDownload 유지, 없으면 excel:false 로 숨김(값 undefined 금지).
  const hotkeyConfig: HotkeyConfig = {
    search: () => void handleSearch(),
    save: canSave ? () => void handleSave() : false,
    insert: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  // 화면버튼 7종 — hasButton 조건부(CLAUDE.md §2 체크3). SAVE 게이트 = SCM Viewer 미보유.
  //   컬럼설정(R6)은 개인화 버튼이라 SAVE 게이트 없이 상시 노출(AS-IS btnColumn 동일) — 아이콘 버튼.
  const customButtons = useMemo(() => {
    const list: {
      label: string;
      action: () => void;
      title?: string;
      iconComponent?: ReactNode;
      buttonLabel?: string;
    }[] = [];
    list.push({
      label: t(LBL.COLUMN_SETTING, 'Column Setting'),
      title: t(LBL.COLUMN_SETTING, 'Column Setting'),
      action: () => setColumnSettingOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    });
    if (canSave) {
      list.push({ label: t(LBL.NEW_VERSION, 'New Version'), action: () => setNewVersionOpen(true) });
      list.push({ label: t(LBL.NEW_MODEL, 'New Model'), action: () => setNewModelOpen(true) });
    }
    list.push({ label: t(LBL.VERSION_INFO, 'Version Info'), action: () => setVersionInfoOpen(true) });
    if (canSave) {
      list.push({ label: t(LBL.MAIL_REQUEST, 'Mail Request'), action: () => void handleMailRequest() });
    }
    return list;
  }, [canSave, handleMailRequest, t]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {isOpenSearchArea && <CapaForm onSearch={() => void handleSearch()} />}
      {/* 헤더 요약 5종(R14, ReadOnly 우측정렬) — Total/Auto/Small/Elec/PIC. */}
      <div className={styles.summaryBar}>
        <span>
          {t(LBL.TOTAL, '_Total')}: {summary.total}
        </span>
        <span>
          {t(LBL.AUTO, 'Auto')}: {summary.auto}
        </span>
        <span>
          {t(LBL.SMALL, 'Small')}: {summary.small}
        </span>
        <span>
          {t(LBL.ELEC, 'Elec')}: {summary.elec}
        </span>
        <span>
          {t(LBL.PIC, 'PIC')}: {summary.pic}
        </span>
      </div>
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='CAPA'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <CapaGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        rows={rows}
        staticColumns={staticColumns}
        calendar={calendar}
        divisionId={searchParams.divisionId}
        editContext={editContext}
        fromYyyymm={searchParams.fromYyyymm}
        checkResult={searchParams.checkResult}
        checkEmpty={searchParams.checkEmpty}
      />
      <CapaNewModelPopup
        open={newModelOpen}
        onClose={() => setNewModelOpen(false)}
        params={{
          divisionId: searchParams.divisionId,
          groupId: searchParams.group === 'ALL' ? '' : searchParams.group,
          plantId: searchParams.plantIds.join(','),
          factoryId: searchParams.factoryIds.join(','),
          lineId: searchParams.lineIds.join(','),
          operationId: searchParams.operationIds.join(','),
          modelId: searchParams.modelId,
          itemId: searchParams.materialId,
          nickName: '',
        }}
      />
      <NewVersionConfirmModal
        open={newVersionOpen}
        divisionId={searchParams.divisionId}
        onClose={() => setNewVersionOpen(false)}
        onSaved={() => reloadVersionOptions(searchParams.divisionId)}
      />
      <VersionInfoModal open={versionInfoOpen} tabId={tabId} onClose={() => setVersionInfoOpen(false)} />
      {/*
        컬럼설정(R6) — 공용 ColumnLayoutModal 재사용(hook #132). OK(onSave) 시에만 titleSet 저장 +
        staticColumns 재조회(전역 staleTime=Infinity 라 invalidate 없이는 재조회 안 됨). 취소 시 무변화.
      */}
      <ColumnLayoutModal
        open={columnSettingOpen}
        modalClose={() => setColumnSettingOpen(false)}
        menuId={MENU_ID}
        sheetName={ADMIN_SHEET_NAME}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={searchParams.divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm || c.colNm,
          width: c.colWth ?? 100,
        }))}
        onSave={settings => {
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME,
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, index) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: index + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
              return;
            }
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            fetchStaticColumns();
          });
        }}
      />
    </>
  );
};
