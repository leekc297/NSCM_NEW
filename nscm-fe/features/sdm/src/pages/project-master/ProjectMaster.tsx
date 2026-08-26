import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

// ⭐ 권한관리 모달 = SDM1010 공용 승격분 재사용 (F-22 — 신규 작성 금지. 모달 내부 MENU_ID SDM1010 유지)
import { ProjectAuthRegModal } from '../../components/ProjectAuthRegModal';

import { ProjectMasterForm } from './components/ProjectMasterForm';
import { ProjectMasterTab1Grid } from './components/ProjectMasterTab1Grid';
import { ProjectMasterTab2Grid } from './components/ProjectMasterTab2Grid';
import {
  BTN,
  LBL,
  MENU_ID,
  MSG,
  PERIOD_DEFAULT_FILTERS,
  SHEETS,
  TAB_INDEX,
} from './project-master.constants';
import type { Tab1Row, Tab2Row } from './project-master.types';
import { useProjectMasterStore } from './useProjectMasterStore';
import type { CallProcResult } from './utils/project-master.api';
import { callCancelTab1, callConfirmTab1, callSaveTab2 } from './utils/project-master.api';
import { isDpjtCodeValid } from './utils/project-master.editLock';
import {
  defaultRegCompRange,
  toCancelPayload,
  toConfirmPayload,
  toSaveTab2Payload,
  validateSearch,
} from './utils/project-master.validate';

// SDM5010 Project Master (SDM > SDM_Admin — ROUTE_PATH 'sdm/project-master' 후속 적용).
//   ⭐ 표준 = project-reg(SDM1010) 2탭 골격 + project-list(SDM1020) api 판정·TAG 승계 (hook #134) +
//     메타 등재 계약 `_artifacts/_apply_corporate/SDM5010_META_20260819/_CONTRACT.md` 단일 원천 배선.
//   TAB1 '프로젝트 등록 요청' = 본인(MGMT_USER_ID) 필터 조회(SP 처리 — FE 세션 전달만, D14 확정) +
//     셀 편집(수정 항목 11종 → 승인 파라미터 E05) + 행 내 [승인][반려] 버튼(REG_COL — 행 단건 E06/E07).
//   TAB2 '프로젝트 Master 관리' = 조회조건 6종 소비(F-3 — TAB2 전용) + 개발현황/비활성 2컬럼
//     편집(P-12) + [저장]('M' 행별 단건 SAVE — E20. confirm 없음 명기·성공 Toast hook #132).
//   공통 버튼은 활성 탭 그리드로 라우팅 (hook #97). 권한 = SPMS Administrator 단독 (useTabBtnPermissions).
//   성공 판정 = CODE '0' + EVENT 건수 (EVENT 0 = 실패 처리 — D12 허위성공 방어 정오표 방침).
export const ProjectMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const tab1GridRef = useRef<FlexGridType<Tab1Row>>(null);
  const tab2GridRef = useRef<FlexGridType<Tab2Row>>(null);
  const tab1FilterRef = useRef<FlexGridFilter>(undefined);
  const tab2FilterRef = useRef<FlexGridFilter>(undefined);
  const tab1TrackerRef = useRef<EditTracker>(undefined);
  const tab2TrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  // 메시지 헬퍼 — alert 는 fire-and-forget / confirm 은 Promise<boolean>
  const alertMsg = (msgId: string, fallback: string) => {
    void setAlert({ type: 'alert', content: t(msgId, fallback) });
  };
  const confirmMsg = (msgId: string, fallback: string) =>
    setAlert({ type: 'confirm', content: t(msgId, fallback) });

  const sc = useProjectMasterStore(s => s.searchCondition);
  const setSearchCondition = useProjectMasterStore(s => s.setSearchCondition);
  const filters = useProjectMasterStore(s => s.filters);
  const setFilter = useProjectMasterStore(s => s.setFilter);
  const clearFilters = useProjectMasterStore(s => s.clearFilters);
  const openSearchArea = useProjectMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectMasterStore(s => s.setOpenSearchArea);
  const activeTab = useProjectMasterStore(s => s.activeTab);
  const setActiveTab = useProjectMasterStore(s => s.setActiveTab);
  const staticColumns = useProjectMasterStore(s => s.staticColumns);
  const fetchStaticColumns = useProjectMasterStore(s => s.fetchStaticColumns);
  const authRegTarget = useProjectMasterStore(s => s.authRegTarget);
  const openAuthRegModal = useProjectMasterStore(s => s.openAuthRegModal);
  const closeAuthRegModal = useProjectMasterStore(s => s.closeAuthRegModal);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID }); // SPMS Administrator 단독 (P-21)

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

  // ⭐ 등록 완료일 기본값 M-1~Today (E01-2 — period 시트 = P_SDM1010_GET_PERIOD 공유 배선, 계약 ①.
  //   YMD_FR(M-1 시작) 앵커 소비 + To=Today FE dayjs 병행. 상수 filters 참조 = 인라인 객체 금지)
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
    // 기본값 주입은 "둘 다 빈 초기 상태"에서만 — 사용자가 손댄 기간은 보존 (SDM1010 period 패턴)
    if (scRef.current.regCompDateFr !== '' || scRef.current.regCompDateTo !== '') return;
    const { fr, to } = defaultRegCompRange(row.YMD_FR);
    setSearchCondition({ regCompDateFr: fr, regCompDateTo: to });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [periodData]);

  // 재조회 = EditTracker clear (조회 성공 시 CRUD pending reset — E04/E18)
  useEffect(() => {
    if (!tab1Data) return;
    tab1TrackerRef.current?.clearChanges();
  }, [tab1Data]);
  useEffect(() => {
    if (!tab2Data) return;
    tab2TrackerRef.current?.clearChanges();
  }, [tab2Data]);

  // mount 시 persist filters 무효화 + admin 메타 fetch (master hook §2.3 — E01-3)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns([SHEETS.TAB1, SHEETS.TAB2]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const tab1Rows = useMemo<Tab1Row[]>(() => tab1Data?.data ?? [], [tab1Data]);
  const tab2Rows = useMemo<Tab2Row[]>(() => tab2Data?.data ?? [], [tab2Data]);

  const isTab1 = activeTab === TAB_INDEX.TAB1;

  // 수정 pending — 양 탭 EditTracker 원본 보유 또는 CRUD 'M' 행 (UC-02/E03 축.
  //   TAB2 비활성 체크 토글은 편집기 미경유 수동 'M' 마킹 — rows 스캔이 잡는다)
  const hasPendingChanges = () =>
    (tab1TrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    (tab2TrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    tab1Rows.some(r => r.CRUD_TYPE === 'M') ||
    tab2Rows.some(r => r.CRUD_TYPE === 'M');

  // ⭐ 재조회 = setFilter 단독 (refetch 직접 호출 금지 — stale closure 계보. 최초=enabled 전환
  //   fetch / 재호출=참조 변경 invalidate→refetch 단일 경로)
  const refreshTab1 = () => setFilter(SHEETS.TAB1);
  const refreshTab2 = () => setFilter(SHEETS.TAB2);
  const refreshActive = () => (isTab1 ? refreshTab1() : refreshTab2()); // CF-26 — 모달 닫힘 후

  // F5 Search — 활성 탭 라우팅 (hook #97). 수정 pending 중 재조회 = confirm MSG00703 (UC-02).
  //   검증 = utils/project-master.validate (TAB1 = 조회조건 미소비 F-3 / TAB2 = P-01~P-03)
  const handleSearch = async () => {
    if (hasPendingChanges()) {
      const ok = await confirmMsg(MSG.PENDING_SEARCH_CONFIRM, '_수정 중인 내용이 있습니다. 조회하시겠습니까?');
      if (!ok) return;
    }
    const v = validateSearch(sc, activeTab);
    if (!v.ok) {
      void setAlert({ type: 'alert', content: t(v.msgId!, '_조회 조건을 확인하세요.') });
      return;
    }
    if (isTab1) {
      tab1TrackerRef.current?.clearChanges();
      setFilter(SHEETS.TAB1);
      void fetchStaticColumns([SHEETS.TAB1]);
    } else {
      tab2TrackerRef.current?.clearChanges();
      setFilter(SHEETS.TAB2);
      void fetchStaticColumns([SHEETS.TAB2]);
    }
  };

  // ⭐ Division 변경 (E02/CF-07) = 종속 콤보 reset(Form) + 양 탭 그리드 비움 + CRUD pending reset +
  //   컬럼 메타 재조회. 자동 재조회 금지 — 재조회는 Search 버튼만 (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    tab1TrackerRef.current?.clearChanges();
    tab2TrackerRef.current?.clearChanges();
    clearFilters(); // filters 제거 → 쿼리키 이탈 → 양 탭 grid 비움
    void fetchStaticColumns([SHEETS.TAB1, SHEETS.TAB2]);
  };

  // ⭐ 사업부 기본값 보정 (CF-01 — MyDivision 첫 값. 유효값은 덮어쓰지 않는다 — 페이지 레벨 관례)
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const codes = (divisions ?? []).map(item => String(item.CODE));
    if (codes.length === 0 || codes.includes(sc.divisionId)) return;
    setSearchCondition({ divisionId: codes[0], endCustomers: [], bizTypes: [] });
    handleDivisionChange();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // 탭 전환 (E03) — 수정 pending 중 전환 = confirm MSG00703 (편집값은 보존 — 파기 아님)
  const handleTabChange = async (index: number) => {
    // 탭 인덱스는 UI 가 number 로 넘기고 store 는 TAB_INDEX enum 으로 들고 있다.
    //   그대로 비교하면 no-unsafe-enum-comparison — enum 쪽을 number 로 좁혀 비교한다.
    if (index !== (activeTab as number) && hasPendingChanges()) {
      const ok = await confirmMsg(MSG.PENDING_SEARCH_CONFIRM, '_수정 중인 내용이 있습니다. 조회하시겠습니까?');
      if (!ok) return;
    }
    setActiveTab(index as TAB_INDEX);
  };

  // ⭐ 행별 단건 순차 실행 공통 — CODE '0'+EVENT 합산 (project-list 계약 이식).
  //   중도 실패: BTN·SAVE SP 는 내부 COMMIT(D21) — 앞선 행은 이미 확정이므로 오류 안내 후
  //   재조회로 원장 상태와 정합시킨다
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

  // TAB1 승인 (E06 — 행 단건 P-09): 6자리 D-PJT Code FE 선검증(P-08/D12) → confirm MSG01008 →
  //   편집값 반영 payload(계약 ① 14키) → CODE '0'+EVENT>0 = toast MSG01009 + 재조회 / 그 외 MSG01010
  const handleConfirmRow = async (row: Tab1Row) => {
    if (!isDpjtCodeValid(row.DPJT_CODE)) {
      // P-08 — 전용 MSG 미채번 (신규 임의 채번 금지 관행상 리터럴 — T-2)
      setToast({ type: 'default', message: 'D-PJT Code는 6자리로 입력해야 합니다.' });
      return;
    }
    if (!(await confirmMsg(MSG.CONFIRM_CONFIRM, '_선택한 프로젝트 등록 요청을 승인하시겠습니까?'))) return;
    const r = await callConfirmTab1(toConfirmPayload(row));
    if (!r.ok || r.event === 0) {
      // EVENT 0 = 갱신 0건 (D12 — 허위성공 방어: 실패 처리, 성공 토스트 금지)
      void setAlert({
        type: 'alert',
        content: r.message && !r.ok ? r.message : t(MSG.CONFIRM_FAIL, '_프로젝트 등록 요청 승인에 실패하였습니다.'),
      });
      return;
    }
    setToast({ type: 'success', message: t(MSG.CONFIRM_DONE, '_선택한 프로젝트 등록 요청이 승인되었습니다.') });
    refreshTab1();
  };

  // TAB1 반려 (E07 — 행 단건 P-10): confirm MSG01011 → payload(계약 ① 4키 — note = 행 내용 전달) →
  //   CODE '0'+EVENT>0 = toast MSG01012 + 재조회 / 그 외 MSG01013
  const handleCancelRow = async (row: Tab1Row) => {
    if (!(await confirmMsg(MSG.CANCEL_CONFIRM, '_선택한 프로젝트 등록 요청을 반려하시겠습니까?'))) return;
    const r = await callCancelTab1(toCancelPayload(row));
    if (!r.ok || r.event === 0) {
      void setAlert({
        type: 'alert',
        content: r.message && !r.ok ? r.message : t(MSG.CANCEL_FAIL, '_프로젝트 등록 요청 반려에 실패하였습니다.'),
      });
      return;
    }
    setToast({ type: 'success', message: t(MSG.CANCEL_DONE, '_선택한 프로젝트 등록 요청이 반려되었습니다.') });
    refreshTab1();
  };

  // F7 Save — TAB2 전용 (E20 — confirm 없음 명기): CRUD 'M' 행만 행별 단건 SAVE(P-13 — 계약 ① 4키.
  //   개발현황 콤보 = EditTracker 'M' / 비활성 체크 = 클릭 토글 수동 'M') → EVENT>0 = Toast
  //   MSG00002(hook #132) + 재조회(UC-07 필터 유지) / EVENT 0 = MSG00004 (허위성공 방지)
  const handleSave = async () => {
    const dirty = tab2Rows.filter(r => r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    const r = await runPerRow(dirty.map(row => () => callSaveTab2(toSaveTab2Payload(row))));
    if (!r.ok) {
      void setAlert({
        type: 'alert',
        content: r.message || t(MSG.SAVE_ERROR, '_저장에 실패하였습니다.'),
      });
      if (r.totalEvent > 0) refreshTab2(); // 중도 실패 — 앞선 행은 내부 COMMIT 확정, 정합 재조회
      return;
    }
    if (r.totalEvent === 0) {
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
    refreshTab2();
  };

  // 권한관리 링크 (E08 — 양 탭 공통. 실전달 키 = 행 DPJT_KEY invisible) → 모달 오픈
  const handleAuthRegCellClick = (row: Tab1Row | Tab2Row) => {
    openAuthRegModal({
      dpjtKey: String(row.DPJT_KEY ?? ''),
      dpjtName: String(row.DPJT_NAME ?? ''),
    });
  };

  // 공통 버튼 — 활성 탭 라우팅 (hook #97). 저장 = TAB2 전용 (TAB1 B31 <해당없음> — E03)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? () => void handleSearch() : false,
    insert: false,
    delete: false,
    save: !isTab1 && hasButton(BTN.SAVE) ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

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

      {/* 조회조건 = TAB2(프로젝트 Master 관리) 전용 소비 — TAB1 비노출 (F-3 확정) */}
      {!isTab1 && openSearchArea && (
        <ProjectMasterForm onSearch={() => void handleSearch()} onDivisionChange={handleDivisionChange} />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={isTab1 ? tab1GridRef : tab2GridRef}
        gridFilter={isTab1 ? tab1FilterRef : tab2FilterRef}
        dataCount={isTab1 ? tab1Rows.length : tab2Rows.length}
        excelFileName='ProjectMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <TabWrapper
        persist
        activeTabIndex={activeTab}
        setActiveTabIndex={index => void handleTabChange(index)}
      >
        {/* 탭 라벨 = 설계서 레이아웃 도형 텍스트 (i18n 코드 미채번 — T-3 계열, 임의 채번 금지) */}
        <TabItem label='프로젝트 등록 요청'>
          <ProjectMasterTab1Grid
            rows={tab1Rows}
            gridRef={tab1GridRef as never}
            gridFilterRef={tab1FilterRef}
            editTrackerRef={tab1TrackerRef}
            divisionId={sc.divisionId}
            staticColumns={staticColumns[SHEETS.TAB1]}
            canConfirm={hasButton(BTN.CONFIRM)}
            canCancel={hasButton(BTN.CANCEL)}
            approveLabel={t(LBL.APPROVE, '_Approve')}
            rejectLabel={t(LBL.REJECT, '_Reject')}
            onConfirmClick={row => void handleConfirmRow(row)}
            onCancelClick={row => void handleCancelRow(row)}
            onAuthRegCellClick={handleAuthRegCellClick}
          />
        </TabItem>
        <TabItem label='프로젝트 Master 관리'>
          <ProjectMasterTab2Grid
            rows={tab2Rows}
            gridRef={tab2GridRef as never}
            gridFilterRef={tab2FilterRef}
            editTrackerRef={tab2TrackerRef}
            divisionId={sc.divisionId}
            staticColumns={staticColumns[SHEETS.TAB2]}
            onAuthRegCellClick={handleAuthRegCellClick}
          />
        </TabItem>
      </TabWrapper>

      <ProjectAuthRegModal
        open={!!authRegTarget}
        target={authRegTarget}
        modalClose={closeAuthRegModal}
        onSaved={refreshActive}
      />
    </>
  );
};
