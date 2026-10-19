import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

// ⭐ ProjectAuthRegModal = feature 공용 승격분 (2026-08-19 — SDM1010/SDM1020 공용, MENU_ID SDM1010 유지)
import { ProjectAuthRegModal } from '../../components/ProjectAuthRegModal';

import { MyWorkModal } from './components/modals/MyWorkModal';
import { ProjectRegForm } from './components/ProjectRegForm';
import { ProjectRegTab1Grid } from './components/ProjectRegTab1Grid';
import { ProjectRegTab2Grid } from './components/ProjectRegTab2Grid';
import {
  BTN,
  INSERT_ROW_DEFAULTS,
  MENU_ID,
  MSG,
  PERIOD_DEFAULT_FILTERS,
  SHEETS,
  TAB_INDEX,
} from './project-reg.constants';
import type { Tab1Row, Tab2Row } from './project-reg.types';
import { useProjectRegStore } from './useProjectRegStore';
import type { CallProcResult } from './utils/project-reg.api';
import { callCancelTab1, callReqTab1, callSaveTab1 } from './utils/project-reg.api';
import {
  canOpenAuthRegModal,
  isRowCancelable,
  isRowDeletable,
  isRowRequestable,
  requiredInsertColumns,
} from './utils/project-reg.editLock';
import {
  toSavePayload,
  validateDuplicate,
  validateRequiredInsert,
  validateSearch,
} from './utils/project-reg.validate';

// SDM1010 Project Registration (SDM > SDM_Project — ROUTE_PATH 'sdm/project-reg').
//   ⭐ 2026-08-13 신본 PKG_SDM1010(외부 전달 정본) 15 SP 계약 전면 재배선
//     (계약 명세: scratchpad PKG_SDM1010_NEW_CONTRACT.md).
//   TAB1 '프로젝트 등록' = CRUD(C/M/D) + 등록요청(REQ)/요청취소(CANCEL) + 권한관리 모달(FPModal 셀).
//     저장/버튼 = **행별 단건 호출, 순차 await** ('^' 다행 금지 — 빈 토큰 행밀림·날짜 파싱 함정 §0.2).
//     성공 판정 = CODE '0' + EVENT 건수 (EVENT 0 = 성공 토스트 금지 — 허위성공 방지 계보).
//   TAB2 '나의 프로젝트 현황' = 조회 전용 + MY_WORK 모달. 기간 기본값 = period 시트(§15 GET_PERIOD).
//   공통 버튼은 활성 탭 그리드로 라우팅 (hook #97).
export const ProjectReg = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const tab1GridRef = useRef<FlexGridType<Tab1Row>>(null);
  const tab2GridRef = useRef<FlexGridType<Tab2Row>>(null);
  const tab1FilterRef = useRef<FlexGridFilter>(undefined);
  const tab2FilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  // 메시지 헬퍼 — alert 는 fire-and-forget / confirm 은 Promise<boolean>
  const alertMsg = (msgId: string, fallback: string) => {
    void setAlert({ type: 'alert', content: t(msgId, fallback) });
  };
  const confirmMsg = (msgId: string, fallback: string) =>
    setAlert({ type: 'confirm', content: t(msgId, fallback) });

  const sc = useProjectRegStore(s => s.searchCondition);
  const setSearchCondition = useProjectRegStore(s => s.setSearchCondition);
  const filters = useProjectRegStore(s => s.filters);
  const setFilter = useProjectRegStore(s => s.setFilter);
  const clearFilters = useProjectRegStore(s => s.clearFilters);
  const openSearchArea = useProjectRegStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRegStore(s => s.setOpenSearchArea);
  const activeTab = useProjectRegStore(s => s.activeTab);
  const setActiveTab = useProjectRegStore(s => s.setActiveTab);
  const staticColumns = useProjectRegStore(s => s.staticColumns);
  const fetchStaticColumns = useProjectRegStore(s => s.fetchStaticColumns);
  const authRegTarget = useProjectRegStore(s => s.authRegTarget);
  const openAuthRegModal = useProjectRegStore(s => s.openAuthRegModal);
  const closeAuthRegModal = useProjectRegStore(s => s.closeAuthRegModal);
  const myWorkTarget = useProjectRegStore(s => s.myWorkTarget);
  const openMyWorkModal = useProjectRegStore(s => s.openMyWorkModal);
  const closeMyWorkModal = useProjectRegStore(s => s.closeMyWorkModal);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ===== 조회 — filters 는 store 보관 참조만 (인라인 객체 금지 — 참조 비교 함정) =====
  const { data: tab1Data } = useTabProcQuery<MENU_ID, SHEETS.TAB1>({
    menuId: MENU_ID,
    sheetName: SHEETS.TAB1,
    tabId,
    filters: filters[SHEETS.TAB1],
    enabled: !!filters[SHEETS.TAB1],
  });
  const { data: tab2Data } = useTabProcQuery<MENU_ID, SHEETS.TAB2>({
    menuId: MENU_ID,
    sheetName: SHEETS.TAB2,
    tabId,
    filters: filters[SHEETS.TAB2],
    enabled: !!filters[SHEETS.TAB2],
  });

  // ⭐ TAB2 등록완료일 기본값 — period 시트(§15 GET_PERIOD) SEARCH. YMD_FR/TO 'YYYYMMDD' 수신
  //   (계약 결정 5 — FE 산술 계산 대체. 상수 filters 참조 = 인라인 객체 금지)
  const { data: periodData } = useTabProcQuery<MENU_ID, SHEETS.PERIOD>({
    menuId: MENU_ID,
    sheetName: SHEETS.PERIOD,
    tabId,
    filters: PERIOD_DEFAULT_FILTERS,
    enabled: true,
  });
  const scRef = useRef(sc);
  scRef.current = sc;
  useEffect(() => {
    const row = periodData?.data?.[0];
    if (!row) return;
    const fr = String(row.YMD_FR ?? '');
    const to = String(row.YMD_TO ?? '');
    if (!/^\d{8}$/.test(fr) || !/^\d{8}$/.test(to)) return;
    // 기본값 주입은 미설정 시에만 — 사용자가 손댄(비운 값 포함 유효 8자리) 기간은 보존.
    //   빈 값 조회(전체 — 미완료 포함)도 허용 계약이라 사용자가 비운 뒤에는 재주입하지 않도록
    //   "둘 다 빈 초기 상태"에서만 세팅한다 (ref = 최신 상태 — effect deps 는 periodData 단독).
    if (scRef.current.regCompDateFr === '' && scRef.current.regCompDateTo === '') {
      setSearchCondition({ regCompDateFr: fr, regCompDateTo: to });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [periodData]);

  // 신규 행 (CRUD_TYPE 'C') — 조회 결과와 분리 보관 (조회 결과 data 는 store 저장 금지)
  const [insertedRows, setInsertedRows] = useState<Tab1Row[]>([]);

  // 재조회 = pending insert reset + EditTracker clear (hook #97)
  useEffect(() => {
    if (!tab1Data) return;
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
  }, [tab1Data]);

  // mount 시 persist filters 무효화 + admin 메타 fetch (master hook §2.3)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns([SHEETS.TAB1, SHEETS.TAB2]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const tab1SpRows = useMemo<Tab1Row[]>(() => tab1Data?.data ?? [], [tab1Data]);
  const tab1Rows = useMemo<Tab1Row[]>(
    () => [...insertedRows, ...tab1SpRows],
    [insertedRows, tab1SpRows]
  );
  const tab2Rows = useMemo<Tab2Row[]>(() => tab2Data?.data ?? [], [tab2Data]);

  const isTab1 = activeTab === TAB_INDEX.TAB1;

  const hasPendingChanges = () =>
    insertedRows.length > 0 ||
    (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    tab1SpRows.some(r => r.CRUD_TYPE === 'M' || r.CRUD_TYPE === 'D');

  // F5 Search — 활성 탭 라우팅 (hook #97). 수정 pending 중 재조회 = confirm MSG00703 (UC-02).
  //   검증 = utils/project-reg.validate (division 필수/기간 한쪽만·역전/TAB2 3년 초과)
  const handleSearch = async () => {
    if (isTab1 && hasPendingChanges()) {
      const ok = await confirmMsg(MSG.PENDING_SEARCH_CONFIRM, '_수정 중인 내용이 있습니다. 조회하시겠습니까?');
      if (!ok) return;
    }
    const v = validateSearch(sc, activeTab);
    if (!v.ok) {
      void setAlert({ type: 'alert', content: t(v.msgId!, '_조회 조건을 확인하세요.') });
      return;
    }
    if (isTab1) {
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges();
      setFilter(SHEETS.TAB1);
      void fetchStaticColumns([SHEETS.TAB1]);
    } else {
      setFilter(SHEETS.TAB2);
      void fetchStaticColumns([SHEETS.TAB2]);
    }
  };

  // ⭐ TAB1 재조회 = setFilter 단독 (2026-08-13 실사고 — setFilter+refetch 병용·refetch 직접 호출 금지:
  //   refetch() 는 이전 렌더 관찰자(stale closure)로 옛 쿼리키에 적재돼 그리드 미갱신.
  //   setFilter 는 최초=enabled 전환 fetch / 재호출=참조 변경 invalidate→refetch 단일 경로)
  const refreshTab1 = () => setFilter(SHEETS.TAB1);

  // ⭐ Division 변경 = 고객 ALL reset(Form) + 양 탭 그리드 비움 + CRUD pending reset + 메타 재조회.
  //   자동 재조회 금지 — 재조회는 Search 버튼만 (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    clearFilters(); // filters 제거 → 쿼리키 이탈 → 양 탭 grid 비움
    void fetchStaticColumns([SHEETS.TAB1, SHEETS.TAB2]);
  };

  // ⭐ 사업부 기본값 보정 (MyDivision 첫 값 — 유효값은 덮어쓰지 않는다). 조회조건 폼이 TAB2 전용이라
  //   (사용자 지시 2026-08-13) 폼 mount 와 무관하게 페이지 레벨에서 수행 — 신규행·그리드
  //   콤보의 division 필수 조건 충족.
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const codes = (divisions ?? []).map(item => String(item.CODE));
    if (codes.length === 0 || codes.includes(sc.divisionId)) return;
    setSearchCondition({ divisionId: codes[0], endCustomer: 'ALL' });
    handleDivisionChange();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // F8 Insert — 신규행(CRUD_TYPE 'C') + 그리드 필터 clear (UC-01).
  //   DIVISION 은 자동 부여하지 않는다 — 행별 필수입력(IM 콤보, 사용자 지시 2026-08-13)
  const handleInsert = () => {
    tab1FilterRef.current?.clear();
    const newRow: Tab1Row = {
      ...INSERT_ROW_DEFAULTS,
      CRUD_TYPE: 'C',
    };
    setInsertedRows(prev => [newRow, ...prev]);
  };

  // F9 Delete — 신규행 즉시 제거 / DRAFT·WRITING 행 confirm(MSG00707) 후 'D' 마킹 / 그 외 차단(MSG00706)
  const handleDelete = async () => {
    const g = tab1GridRef.current;
    if (!g) return;
    const selected = (g.selectedItems ?? []) as Tab1Row[];
    if (selected.length === 0) return;
    const invalid = selected.some(
      r => !isRowDeletable(r) // P-07 — 신규(C)/DRAFT/WRITING 만 (editLock 단일 원천)
    );
    if (invalid) {
      alertMsg(MSG.DELETE_ONLY_DRAFT, '_작성중 상태의 프로젝트만 삭제할 수 있습니다.');
      return;
    }
    const newOnes = selected.filter(r => r.CRUD_TYPE === 'C');
    const draftOnes = selected.filter(r => r.CRUD_TYPE !== 'C');
    if (draftOnes.length > 0) {
      const ok = await confirmMsg(MSG.DELETE_CONFIRM, '_선택한 프로젝트를 삭제하시겠습니까?');
      if (!ok) return;
      draftOnes.forEach(r => {
        r.CRUD_TYPE = 'D';
      });
    }
    if (newOnes.length > 0) setInsertedRows(prev => prev.filter(r => !newOnes.includes(r)));
    g.invalidate();
  };

  // ⭐ 행별 단건 순차 실행 공통 — CODE '0'+EVENT 합산 (계약 결정 1·2).
  //   중도 실패: 신본 SAVE·BTN 은 SP 내부 COMMIT(§0.3) — 앞선 행은 이미 확정이므로
  //   오류 안내 후 재조회로 원장 상태와 정합시킨다 (미확정 pending 재저장 시 중복 INSERT 방지)
  const runPerRow = async (
    calls: Array<() => Promise<CallProcResult>>
  ): Promise<{ ok: boolean; totalEvent: number; message?: string }> => {
    let totalEvent = 0;
    for (const call of calls) {
      const res = await call();
      if (!res.ok) return { ok: false, totalEvent, message: res.message };
      totalEvent += res.event;
    }
    return { ok: true, totalEvent };
  };

  // F7 Save — IM 필수(MSG00113) → payload 내 중복(MSG00043) → confirm(MSG00001) →
  //   행별 단건 SAVE (§2 — I=서버 채번/M·D=커서 키 실값) → CODE '0'+EVENT>0 = toast + 재조회.
  //   EVENT 0 = "처리된 행 없음" 안내 (변경 없음 M / DRAFT-D 서버 가드 §18-9① — 성공 토스트 금지)
  const handleSave = async () => {
    const dirty: Tab1Row[] = [
      ...insertedRows,
      ...tab1SpRows.filter(r => r.CRUD_TYPE === 'M' || r.CRUD_TYPE === 'D'),
    ];
    if (dirty.length === 0) {
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    // ① 신규행 IM 필수 컬럼 (메타 단일 원천) — MSG00113 with 컬럼 라벨.
    //   ⚠ §2 I 가드는 필수 미충족 시 **조용히 skip** — FE 선검증이 유일한 사용자 안내 경로
    const vr = validateRequiredInsert(insertedRows, requiredInsertColumns(staticColumns[SHEETS.TAB1]));
    if (!vr.ok) {
      void setAlert({
        type: 'alert',
        content: t(vr.msgId!, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', vr.detail ?? ''),
      });
      return;
    }
    // ② payload 내 중복 — division+class+customer+name (삭제 'D' 행 제외)
    const vd = validateDuplicate(dirty);
    if (!vd.ok) {
      alertMsg(vd.msgId!, '_중복된 데이터가 존재합니다.');
      return;
    }
    // ③ confirm → ④ 행별 단건 호출 (toSavePayload — CRUD 'C'→'I'·sopDate 'YYYY-MM-DD 00:00:00')
    if (!(await confirmMsg(MSG.SAVE_CONFIRM, '_저장하시겠습니까?'))) return;
    const r = await runPerRow(dirty.map(row => () => callSaveTab1(toSavePayload(row))));
    if (!r.ok) {
      // 중도 실패 — 앞선 행은 SP 내부 COMMIT 확정. 안내 후 재조회로 정합 (중복 INSERT 방지)
      void setAlert({
        type: 'alert',
        content: r.message || t(MSG.SAVE_ERROR, '_저장에 실패하였습니다.'),
      });
      if (r.totalEvent > 0) refreshTab1();
      return;
    }
    if (r.totalEvent === 0) {
      // EVENT 0 — 변경 없음/서버 가드 미충족 (허위성공 방지: 성공 토스트 금지, pending 유지)
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    // ⭐ 신규 채번은 서버(TEMP_*) — 저장 성공 후 재조회로 실키 수신 (계약 결정 3)
    refreshTab1();
  };

  // 체크박스 선택 행 수집 (등록요청/요청취소 대상 — row.isSelected)
  const collectChecked = (): Tab1Row[] => {
    const g = tab1GridRef.current;
    if (!g) return [];
    const picked: Tab1Row[] = [];
    for (const r of g.rows) {
      if (r?.isSelected) picked.push(r.dataItem as Tab1Row);
    }
    return picked;
  };

  // 등록요청(REQ) — 0건(MSG00709) / DRAFT·WRITING 외 포함(MSG00708) / 신규 미저장 제외 안내 →
  //   confirm(MSG00710) → §3 행별 단건 (WRITING→WAITING) → EVENT>0 toast MSG00711 / EVENT 0 안내
  const handleReq = async () => {
    const checked = collectChecked();
    if (checked.length === 0) {
      alertMsg(MSG.NO_CHECKED, '_대상을 선택하세요.');
      return;
    }
    const newOnes = checked.filter(r => r.CRUD_TYPE === 'C');
    const targets = checked.filter(r => r.CRUD_TYPE !== 'C');
    if (targets.some(r => !isRowRequestable(r))) {
      alertMsg(MSG.REQ_ONLY_DRAFT, '_작성중 상태의 프로젝트만 등록요청할 수 있습니다.');
      return;
    }
    if (newOnes.length > 0) {
      // 신규(미저장) 행 제외 안내 — 전용 MSG 미채번 (P-31 계열 리터럴)
      setToast({ type: 'default', message: '신규(미저장) 행은 저장 후 등록요청이 가능합니다. 대상에서 제외됩니다.' });
    }
    if (targets.length === 0) {
      alertMsg(MSG.NO_CHECKED, '_대상을 선택하세요.');
      return;
    }
    if (!(await confirmMsg(MSG.REQ_CONFIRM, '_선택한 프로젝트를 등록요청하시겠습니까?'))) return;
    const r = await runPerRow(
      targets.map(row => () =>
        callReqTab1({ divisionId: String(row.DIVISION_ID ?? ''), dpjtKey: String(row.DPJT_KEY ?? '') })
      )
    );
    if (!r.ok) {
      void setAlert({
        type: 'alert',
        content: r.message || t(MSG.REQ_FAIL, '_등록요청에 실패하였습니다.'),
      });
      if (r.totalEvent > 0) refreshTab1();
      return;
    }
    if (r.totalEvent === 0) {
      // §3 가드(WRITING 한정) 미충족 = CODE 0/EVENT 0 — 성공 토스트 금지 (DRAFT 행 §18-9① 계보)
      setToast({ type: 'default', message: '처리된 행이 없습니다. (등록요청 가능 상태가 아닙니다)' });
      return;
    }
    setToast({ type: 'success', message: t(MSG.REQ_DONE, '_등록요청이 완료되었습니다.') });
    refreshTab1();
  };

  // 요청취소(CANCEL) — WAITING 상태만(MSG00713) / 0건(MSG00709) → confirm(MSG00714) →
  //   §4 행별 단건 (WAITING→WRITING) → EVENT>0 toast / EVENT 0 안내
  const handleCancelReq = async () => {
    const checked = collectChecked();
    if (checked.length === 0) {
      alertMsg(MSG.NO_CHECKED, '_대상을 선택하세요.');
      return;
    }
    if (
      checked.some(
        r => !isRowCancelable(r) // P-12 — 승인대기(WAITING)만 (editLock 단일 원천)
      )
    ) {
      alertMsg(MSG.CANCEL_ONLY_REQUEST, '_승인대기 상태의 프로젝트만 요청취소할 수 있습니다.');
      return;
    }
    if (!(await confirmMsg(MSG.CANCEL_CONFIRM, '_선택한 프로젝트의 등록요청을 취소하시겠습니까?'))) return;
    const r = await runPerRow(
      checked.map(row => () =>
        callCancelTab1({
          divisionId: String(row.DIVISION_ID ?? ''),
          dpjtKey: String(row.DPJT_KEY ?? ''),
        })
      )
    );
    if (!r.ok) {
      void setAlert({
        type: 'alert',
        content: r.message || t(MSG.SAVE_ERROR, '_저장에 실패하였습니다.'),
      });
      if (r.totalEvent > 0) refreshTab1();
      return;
    }
    if (r.totalEvent === 0) {
      setToast({ type: 'default', message: '처리된 행이 없습니다. (요청취소 가능 상태가 아닙니다)' });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
    refreshTab1();
  };

  // 권한관리 셀 클릭 — 신규(미저장) 행 = toast 안내 (P-31), 그 외 모달 오픈
  const handleAuthRegCellClick = (row: Tab1Row) => {
    if (!canOpenAuthRegModal(row)) {
      // P-31 — 전용 MSG 미채번 (신규 채번 금지 관행상 리터럴)
      setToast({ type: 'default', message: '저장 후 권한 등록이 가능합니다.' });
      return;
    }
    openAuthRegModal({
      dpjtKey: String(row.DPJT_KEY),
      dpjtName: String(row.DPJT_NAME ?? ''),
    });
  };

  // 공통 버튼 — 활성 탭 라우팅 (hook #97). TAB2 = Search/Excel 만
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? () => void handleSearch() : false,
    insert: isTab1 && hasButton('INSERT') ? handleInsert : false,
    delete: isTab1 && hasButton('DELETE') ? () => void handleDelete() : false,
    save: isTab1 && hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — 등록요청(REQ)/요청취소(CANCEL). TAB1 활성 시에만 노출 (텍스트 버튼 — hook #120)
  const textButton = (label: string, action: () => void) => ({ label, title: label, action, buttonLabel: label });
  const customButtons = isTab1
    ? [
        ...(hasButton(BTN.REQ) ? [textButton(t('LBL00859', '_등록요청'), () => void handleReq())] : []),
        ...(hasButton(BTN.CANCEL)
          ? [textButton(t('LBL00860', '_요청취소'), () => void handleCancelReq())]
          : []),
      ]
    : [];

  // ⭐ 페이지 최상위 = fragment (래퍼 div 금지 — hook #132)
  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        disableSearchArea={isTab1}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {/* 조회조건 = TAB2(나의 프로젝트 현황) 전용 — TAB1 은 비노출 (사용자 지시 2026-08-13) */}
      {!isTab1 && openSearchArea && (
        <ProjectRegForm onSearch={() => void handleSearch()} onDivisionChange={handleDivisionChange} />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={isTab1 ? tab1GridRef : tab2GridRef}
        gridFilter={isTab1 ? tab1FilterRef : tab2FilterRef}
        dataCount={isTab1 ? tab1Rows.length : tab2Rows.length}
        excelFileName='ProjectRegistration'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <TabWrapper
        persist
        activeTabIndex={activeTab}
        setActiveTabIndex={index => setActiveTab(index as TAB_INDEX)}
      >
        <TabItem label={t('MNU_SDM1010', '_Project Registration')}>
          <ProjectRegTab1Grid
            rows={tab1Rows}
            gridRef={tab1GridRef as never}
            gridFilterRef={tab1FilterRef}
            editTrackerRef={editTrackerRef}
            divisionId={sc.divisionId}
            staticColumns={staticColumns[SHEETS.TAB1]}
            insertedRows={insertedRows}
            onAuthRegCellClick={handleAuthRegCellClick}
          />
        </TabItem>
        <TabItem label={t('LBL00858', '_My Project Status')}>
          <ProjectRegTab2Grid
            rows={tab2Rows}
            gridRef={tab2GridRef as never}
            gridFilterRef={tab2FilterRef}
            staticColumns={staticColumns[SHEETS.TAB2]}
            onMyWorkCellClick={row => openMyWorkModal({ dpjtKey: String(row.DPJT_KEY ?? '') })}
          />
        </TabItem>
      </TabWrapper>

      <ProjectAuthRegModal
        open={!!authRegTarget}
        target={authRegTarget}
        modalClose={closeAuthRegModal}
        onSaved={refreshTab1}
      />
      <MyWorkModal open={!!myWorkTarget} target={myWorkTarget} modalClose={closeMyWorkModal} />
    </>
  );
};
