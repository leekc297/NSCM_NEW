import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { ColumnLayoutModal, MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

// ⭐ 권한관리 모달 = SDM1010 공용 승격분 (features/sdm/src/components — 모달 내부 MENU_ID SDM1010 유지)
import { AuthManagementPopup } from '../../components/auth-management-popup';

import { ProjectListForm } from './components/ProjectListForm';
import { ProjectListGrid } from './components/ProjectListGrid';
import {
  BTN,
  MENU_ID,
  MSG,
  PERIOD_DEFAULT_FILTERS,
  REQ_CHECK_BINDINGS,
  SHEETS,
} from './project-list.constants';
import type { MainRow, ReqCheckOrigin } from './project-list.types';
import { useProjectListStore } from './useProjectListStore';
import type { CallProcResult } from './utils/project-list.api';
import { callReqProjectAuth, callReqProjectReg } from './utils/project-list.api';
import { canOpenAuthMgmt, canReqAuth, hasCheckedReq } from './utils/project-list.editLock';
import { defaultRegCompRange, toReqPayload, validateSearch } from './utils/project-list.validate';
import { toText } from './utils/project-list.value';

// SDM1020 Project List (SDM > SDM_Project — ROUTE_PATH 'sdm/project-list').
//   ⭐ 표준 = SDM1010 골격 1:1 승계 (hook #134 — SDM 도메인 정본) + 메타 등재 계약
//     `_artifacts/_apply_corporate/SDM1020_META_20260819/_CONTRACT.md` 단일 원천 배선.
//   단일 그리드 '프로젝트 조회/변경' — **저장 버튼 없음** (P-25): 셀 편집(ADMIN 행만, P-01)은
//   CRUD_TYPE 'M' 마킹만 하고, [등록요청] 버튼이 Checked+`'M'` 행을 **행별 단건 call-proc** 으로 저장
//   (D4 — SP 는 P_ACTIVE_FLAG 분기 부재. '^' join 금지 — 확정 결정).
//   권한요청 = 그리드 내 링크(NONE/READ 행만, P-03) + 입력/조회 체크박스 서버 3상태 (P-04/P-05).
//   권한관리 = ADMIN 행 링크(P-02) → SDM1010 ProjectAuthRegModal 공용 승격분 오픈.
//   성공 판정 = CODE '0' + EVENT 건수 (EVENT 0 = 성공 토스트 금지 — 허위성공 방지 계보).
export const ProjectList = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<MainRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);
  // 권한요청 체크박스 서버 원본 (P-12 취소 경로 판정 — 재조회 시 clear. Map = pending 유무 판정 겸용)
  const reqCheckOriginsRef = useRef<Map<MainRow, ReqCheckOrigin>>(new Map());

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  // 메시지 헬퍼 — alert 는 fire-and-forget / confirm 은 Promise<boolean>
  const alertMsg = useCallback(
    (msgId: string, fallback: string) => {
      void setAlert({ type: 'alert', content: t(msgId, fallback) });
    },
    [setAlert, t]
  );
  const confirmMsg = useCallback(
    (msgId: string, fallback: string) => setAlert({ type: 'confirm', content: t(msgId, fallback) }),
    [setAlert, t]
  );

  const sc = useProjectListStore(s => s.searchCondition);
  const setSearchCondition = useProjectListStore(s => s.setSearchCondition);
  const filters = useProjectListStore(s => s.filters);
  const setFilter = useProjectListStore(s => s.setFilter);
  const clearFilters = useProjectListStore(s => s.clearFilters);
  const openSearchArea = useProjectListStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectListStore(s => s.setOpenSearchArea);
  const staticColumns = useProjectListStore(s => s.staticColumns);
  const fetchStaticColumns = useProjectListStore(s => s.fetchStaticColumns);
  const authRegTarget = useProjectListStore(s => s.authRegTarget);
  const openAuthRegModal = useProjectListStore(s => s.openAuthRegModal);
  const closeAuthRegModal = useProjectListStore(s => s.closeAuthRegModal);
  const columnSettingOpen = useProjectListStore(s => s.columnSettingOpen);
  const setColumnSettingOpen = useProjectListStore(s => s.setColumnSettingOpen);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ===== 조회 — filters 는 store 보관 참조만 (인라인 객체 금지 — 참조 비교 함정) =====
  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // ⭐ 등록 완료일 기본값 M-1~Today (P-27 — period 시트 = PR_GET_DAY_RANGE 공유 배선, 계약 ⑤.
  //   o_rc2 DAY_RANGE 의 당월 1일 앵커 소비 + dayjs 병행 산출. 상수 filters 참조 = 인라인 객체 금지)
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
    const range = periodData?.o_rc2?.[0]?.DAY_RANGE;
    if (range == null) return;
    // 기본값 주입은 "둘 다 빈 초기 상태"에서만 — 사용자가 손댄 기간은 보존 (SDM1010 period 패턴)
    if (scRef.current.regCompDateFr !== '' || scRef.current.regCompDateTo !== '') return;
    const { fr, to } = defaultRegCompRange(range);
    setSearchCondition({ regCompDateFr: fr, regCompDateTo: to });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [periodData]);

  // 재조회 = EditTracker clear + 체크박스 원본 스냅샷 폐기 (서버 3상태가 새 단일 원천)
  useEffect(() => {
    if (!mainData) return;
    editTrackerRef.current?.clearChanges();
    reqCheckOriginsRef.current.clear();
  }, [mainData]);

  // mount 시 persist filters 무효화 + admin 메타 fetch (master hook §2.3)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const rows = useMemo<MainRow[]>(() => mainData?.data ?? [], [mainData]);

  // 수정 pending — EditTracker 원본 보유(셀 편집 'M') 또는 체크박스 토글 스냅샷 존재 (UC-02 축)
  const hasPendingChanges = () =>
    (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    rows.some(r => r.CRUD_TYPE === 'M') ||
    reqCheckOriginsRef.current.size > 0;

  // ⭐ 재조회 = setFilter 단독 (refetch 직접 호출 금지 — stale closure 계보. 최초=enabled 전환 fetch /
  //   재호출=참조 변경 invalidate→refetch 단일 경로)
  const refreshMain = useCallback(() => setFilter(), [setFilter]);

  // F5 Search — 수정 pending 중 재조회 = confirm MSG00703 (UC-02) → 검증(P-09/P-10) → 조회.
  //   필터는 유지된 채 재조회 (UC-07 — 공용 DataGrid rebindFilterColumns 내장 경로)
  const handleSearch = async () => {
    if (hasPendingChanges()) {
      const ok = await confirmMsg(
        MSG.PENDING_SEARCH_CONFIRM,
        '_수정 중인 내용이 있습니다. 조회하시겠습니까?'
      );
      if (!ok) return;
    }
    const v = validateSearch(sc);
    if (!v.ok) {
      void setAlert({ type: 'alert', content: t(v.msgId!, '_조회 조건을 확인하세요.') });
      return;
    }
    editTrackerRef.current?.clearChanges();
    reqCheckOriginsRef.current.clear();
    setFilter();
    void fetchStaticColumns([SHEETS.MAIN]);
  };

  // ⭐ Division 변경 (P-26) = 그리드 비움 + CRUD pending reset + 컬럼 메타 재조회.
  //   자동 재조회 금지 — 재조회는 Search 버튼만 (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    editTrackerRef.current?.clearChanges();
    reqCheckOriginsRef.current.clear();
    clearFilters(); // filters 제거 → 쿼리키 이탈 → 그리드 비움
    void fetchStaticColumns([SHEETS.MAIN]);
  };

  // ⭐ 사업부 기본값 보정 (P-27 — MyDivision 첫 값. 유효값은 덮어쓰지 않는다 — SDM1010 페이지 레벨 관례)
  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const codes = (divisions ?? []).map(item => String(item.CODE));
    if (codes.length === 0 || codes.includes(sc.divisionId)) return;
    setSearchCondition({ divisionId: codes[0], endCustomers: 'ALL' });
    handleDivisionChange();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, sc.divisionId]);

  // ⭐ 행별 단건 순차 실행 공통 — CODE '0'+EVENT 합산 (project-reg 계약 이식).
  //   중도 실패: BTN SP 는 내부 COMMIT(O-4) — 앞선 행은 이미 확정이므로 오류 안내 후 재조회로
  //   원장 상태와 정합시킨다 (미확정 pending 재전송 시 변경본 중복 INSERT 방지)
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

  // 체크박스 선택 행 수집 (등록요청 대상 — row.isSelected)
  const collectChecked = (): MainRow[] => {
    const g = gridRef.current;
    if (!g) return [];
    const picked: MainRow[] = [];
    for (const r of g.rows) {
      if (r?.isSelected) picked.push(r.dataItem as MainRow);
    }
    return picked;
  };

  // 등록요청(REQ) — Checked 0건(P-07 MSG00709) → 'M' 행 0건(P-06 MSG00004) → confirm(P-08 MSG00710)
  //   → 행별 단건 (변경본 INSERT + 원본 MODIFYING — D3 정정분) → EVENT>0 toast MSG00711 / EVENT 0 안내
  const handleReq = async () => {
    const checked = collectChecked();
    if (checked.length === 0) {
      alertMsg(MSG.NO_CHECKED, '_선택한 항목이 존재하지 않습니다.');
      return;
    }
    // ⭐ 확정 결정 — Checked 이면서 CRUD_TYPE 'M' 행만 (D4: SP 분기 부재 — 'M' 외 전송 금지)
    const targets = checked.filter(r => r.CRUD_TYPE === 'M');
    if (targets.length === 0) {
      alertMsg(MSG.NO_CHANGES, '_수정된 내용이 없습니다.');
      return;
    }
    if (!(await confirmMsg(MSG.REQ_CONFIRM, '_프로젝트를 등록/변경 하시겠습니까?'))) return;
    const r = await runPerRow(targets.map(row => () => callReqProjectReg(toReqPayload(row))));
    if (!r.ok) {
      void setAlert({
        type: 'alert',
        content: r.message || t(MSG.REQ_FAIL, '_등록요청에 실패하였습니다.'),
      });
      if (r.totalEvent > 0) refreshMain();
      return;
    }
    if (r.totalEvent === 0) {
      // EVENT 0 — 처리된 행 없음 (허위성공 방지: 성공 토스트 금지, pending 유지)
      setToast({ type: 'default', message: '처리된 행이 없습니다.' });
      return;
    }
    setToast({ type: 'success', message: t(MSG.REQ_DONE, '_성공적으로 등록요청 되었습니다.') });
    refreshMain();
  };

  // 권한요청 링크 (E07) — 체크 有 = confirm MSG01003 / 체크 無 + 원래 CHECKED(해제 후) = 취소 confirm
  //   MSG01004 (P-12 — D12: SP 취소 경로는 PKG 정정 대기, FE 는 현재값 그대로 전달) / 체크 無 =
  //   MSG01002 (P-11) → 단건 call-proc → CODE '0'+EVENT>0 = toast MSG01005 + 재조회
  const handleAuthReq = useCallback(
    async (row: MainRow) => {
      if (!canReqAuth(row)) return; // P-03 — 봉인('-') 행 (렌더에서 이미 차단, 이중 방어)
      const write = toText(row[REQ_CHECK_BINDINGS.WRITE]);
      const read = toText(row[REQ_CHECK_BINDINGS.READ]);
      if (hasCheckedReq(write, read)) {
        if (!(await confirmMsg(MSG.AUTHREQ_CONFIRM, '_권한요청 하시겠습니까?'))) return;
      } else {
        const origin = reqCheckOriginsRef.current.get(row);
        const hadChecked = !!origin && hasCheckedReq(origin.write, origin.read);
        if (!hadChecked) {
          alertMsg(MSG.AUTHREQ_EMPTY, '_권한요청 항목이 없습니다.'); // P-11
          return;
        }
        // 취소 경로 — 요청 진행 중(CHECKED 수신) 을 해제하고 요청 (P-12 / D12)
        if (!(await confirmMsg(MSG.AUTHREQ_CANCEL_CONFIRM, '_권한요청을 취소 하시겠습니까?')))
          return;
      }
      const r = await callReqProjectAuth({
        dpjtKey: toText(row.DPJT_KEY),
        dpjtAuthReqWrite: write,
        dpjtAuthReqRead: read,
      });
      if (!r.ok) {
        void setAlert({
          type: 'alert',
          content: r.message || t(MSG.AUTHREQ_FAIL, '_권한요청에 실패하였습니다.'),
        });
        return;
      }
      if (r.event === 0) {
        // SP no-op 가드(동일 요청 반복·취소 미지원 경로 등 — CASE 0) = 성공 토스트 금지
        setToast({ type: 'default', message: '처리된 권한요청이 없습니다.' });
        return;
      }
      setToast({
        type: 'success',
        message: t(MSG.AUTHREQ_DONE, '_성공적으로 권한요청 되었습니다.'),
      });
      refreshMain();
    },
    [alertMsg, confirmMsg, refreshMain, setAlert, setToast, t]
  );

  // 권한관리 링크 (E08) — ADMIN 행만 (P-02 — SP '-' 봉인 값 단일 원천) → 모달 오픈 (pjtKey 전달)
  const handleAuthMgmt = useCallback(
    (row: MainRow) => {
      if (!canOpenAuthMgmt(row)) return;
      openAuthRegModal({
        pjtKey: toText(row.DPJT_KEY),
        projectName: toText(row.DPJT_NAME),
      });
    },
    [openAuthRegModal]
  );

  // 공통 버튼 — Search 만 (저장 버튼 없음 P-25. Excel/Filter/Sort 는 SubTitle 공용 경로 — hook #97)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? () => void handleSearch() : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 — 등록요청(REQ, LBL00859 — 계약 ③. 텍스트 버튼 — hook #120)
  const textButton = (label: string, action: () => void) => ({
    label,
    title: label,
    action,
    buttonLabel: label,
  });
  const columnSettingButton = {
    label: t('LBL00605', 'Column Setting'),
    title: t('LBL00605', 'Column Setting'),
    action: () => setColumnSettingOpen(true),
    iconComponent: <IcGridColumnSetup />,
    buttonLabel: '',
  };
  const customButtons = [
    columnSettingButton,
    ...(hasButton(BTN.REQ)
      ? [textButton(t('LBL00865', '_Reg Request'), () => void handleReq())]
      : []),
  ];

  // ⭐ 페이지 최상위 = fragment (래퍼 div 금지 — hook #132)

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <ProjectListForm
          onSearch={() => void handleSearch()}
          onDivisionChange={handleDivisionChange}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProjectList'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <ProjectListGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        staticColumns={staticColumns[SHEETS.MAIN]}
        reqCheckOriginsRef={reqCheckOriginsRef}
        onAuthMgmtClick={handleAuthMgmt}
        onAuthReqClick={handleAuthReq}
      />

      <ColumnLayoutModal
        open={columnSettingOpen}
        modalClose={() => setColumnSettingOpen(false)}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType='C'
        divisionId={sc.divisionId}
        fallbackColumns={(staticColumns[SHEETS.MAIN] ?? []).map(column => ({
          key: column.colNm,
          header: column.colLblNm ?? column.colNm,
          width: column.colWth ?? 100,
          display: column.display,
          personalizable: column.personalizable,
        }))}
        title={t('LBL00605', 'Column Setting')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        onSave={settings => {
          const visible = settings.filter(setting => setting.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
            columnType: 'C',
            rows: visible.map((setting, index) => ({
              name: setting.COLUMN_NAME,
              sortOrderNo: index + 1,
              colWidth: setting.COL_WIDTH,
              cellColor: setting.CELL_COLOR,
              textColor: setting.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              void setAlert({
                type: 'alert',
                content: t('MSG00618', '_An error occurred while saving.'),
              });
              return;
            }
            void fetchStaticColumns([SHEETS.MAIN]);
            setToast({
              type: 'success',
              message: t('MSG_LAYOUT_SAVED', '_레이아웃이 저장되었습니다.'),
            });
          });
        }}
      />

      <AuthManagementPopup
        open={!!authRegTarget}
        pjtKey={authRegTarget?.pjtKey ?? ''}
        projectName={authRegTarget?.projectName ?? ''}
        onClose={closeAuthRegModal}
        onSaved={refreshMain}
      />
    </>
  );
};
