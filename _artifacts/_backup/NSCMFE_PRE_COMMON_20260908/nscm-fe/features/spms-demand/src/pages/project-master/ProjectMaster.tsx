import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import {
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  TabItem,
  TabWrapper,
  toColumnLayoutSettings,
} from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { AuthManagementPopup } from '../../components/auth-management-popup';
import { runPerRowProc } from '../../lib/call-proc';

import { ProjectMasterForm } from './components/ProjectMasterForm';
import { ProjectMasterTab1Grid } from './components/ProjectMasterTab1Grid';
import { ProjectMasterTab2Grid } from './components/ProjectMasterTab2Grid';
import { BTN, LBL, MENU_ID, MSG, SHEETS, TAB_INDEX } from './project-master.constants';
import type { Tab1Row, Tab2Row } from './project-master.types';
import styles from './ProjectMaster.module.scss';
import { useProjectMasterStore } from './useProjectMasterStore';
import { callCancelTab1, callConfirmTab1, callSaveTab2 } from './utils/project-master.api';
import { isDpjtCodeValid } from './utils/project-master.editLock';
import {
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
  const originalStaticColumns = useProjectMasterStore(s => s.originalStaticColumns);
  const applyColumnLayout = useProjectMasterStore(s => s.applyColumnLayout);
  const fetchStaticColumns = useProjectMasterStore(s => s.fetchStaticColumns);
  const authRegTarget = useProjectMasterStore(s => s.authRegTarget);
  const openAuthRegModal = useProjectMasterStore(s => s.openAuthRegModal);
  const closeAuthRegModal = useProjectMasterStore(s => s.closeAuthRegModal);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const queryClient = useQueryClient();
  const { saveWithValidation } = useSaveWithValidation();

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

  // 등록 완료일 기본값 M-1(한 달 전 같은 날)~Today 는 store 초기값/reset 에서 FE dayjs 로 직접
  // 산출한다 — 이전의 period 시트(P_SDM1010_GET_PERIOD) YMD_FR 앵커 소비·주입 effect 는 폐기 (E01-2 변경).

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

  // TAB1 은 조회조건 미소비(F-3)라 최초 진입 시 자동조회한다 — TAB1 활성 상태에서
  // filters[TAB1] 이 비면(mount clearFilters / Division 보정의 clearFilters 포함) 즉시 다시
  // 채운다 (SDM1010 동일 패턴). TAB2 는 조회조건 검증이 필요해 대상 아님 — Search 버튼만.
  useEffect(() => {
    if (activeTab === TAB_INDEX.TAB1 && !filters[SHEETS.TAB1]) setFilter(SHEETS.TAB1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeTab, filters]);

  const tab1Rows = useMemo<Tab1Row[]>(() => tab1Data?.data ?? [], [tab1Data]);
  const tab2Rows = useMemo<Tab2Row[]>(() => tab2Data?.data ?? [], [tab2Data]);

  const isTab1 = activeTab === TAB_INDEX.TAB1;

  // 수정 pending — 양 탭 EditTracker 원본 보유 또는 CRUD 'M' 행 (UC-02/E03 축.
  //   TAB2 비활성 체크 토글은 편집기 미경유 수동 'M' 마킹 — rows 스캔이 잡는다)
  const hasPendingChanges = (tab: TAB_INDEX) =>
    tab === TAB_INDEX.TAB1
      ? (tab1TrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
        tab1Rows.some(r => r.CRUD_TYPE === 'M')
      : (tab2TrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
        tab2Rows.some(r => r.CRUD_TYPE === 'M');

  // ⭐ 재조회 = setFilter 단독 (refetch 직접 호출 금지 — stale closure 계보. 최초=enabled 전환
  //   fetch / 재호출=참조 변경 invalidate→refetch 단일 경로)
  const refreshTab1 = () => setFilter(SHEETS.TAB1);
  const refreshTab2 = () => setFilter(SHEETS.TAB2);
  const refreshActive = () => (isTab1 ? refreshTab1() : refreshTab2()); // CF-26 — 모달 닫힘 후

  // F5 Search — 활성 탭 라우팅 (hook #97). 수정 pending 중 재조회 = confirm MSG00703 (UC-02).
  //   검증 = utils/project-master.validate (TAB1 = 조회조건 미소비 F-3 / TAB2 = P-01~P-03)
  const handleSearch = async () => {
    if (hasPendingChanges(activeTab)) {
      const ok = await confirmMsg(
        MSG.PENDING_SEARCH_CONFIRM,
        '_수정 중인 내용이 있습니다. 조회하시겠습니까?'
      );
      if (!ok) return;
    }
    const v = validateSearch(sc, activeTab);
    if (!v.ok) {
      void setAlert({ type: 'alert', content: t(v.msgId, '_조회 조건을 확인하세요.') });
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
    const nextTab = index as TAB_INDEX;
    if (nextTab !== activeTab && hasPendingChanges(activeTab)) {
      const ok = await confirmMsg(
        MSG.PENDING_SEARCH_CONFIRM,
        '_수정 중인 내용이 있습니다. 조회하시겠습니까?'
      );
      if (!ok) return;
    }
    setActiveTab(nextTab);
    if (nextTab === TAB_INDEX.TAB1 && !hasPendingChanges(TAB_INDEX.TAB1)) {
      setFilter(SHEETS.TAB1);
      void fetchStaticColumns([SHEETS.TAB1]);
    }
  };

  // TAB1 승인 (E06 — 행 단건 P-09): 9자리 D-PJT Code FE 선검증(P-08/D12) →
  //   공용 필수값 검증 → confirm MSG01008 →
  //   편집값 반영 payload(계약 ① 14키) → CODE '0'+EVENT>0 = toast MSG01009 + 재조회 / 그 외 MSG01010
  const handleConfirmRow = async (row: Tab1Row) => {
    if (!isDpjtCodeValid(row.DPJT_CODE)) {
      // P-08 — 전용 MSG 미채번 (신규 임의 채번 금지 관행상 리터럴 — T-2)
      setToast({ type: 'default', message: 'D-PJT Code는 9자리로 입력해야 합니다.' });
      return;
    }

    // 승인 대상은 조회 행이지만, IM 필수 메타는 신규행 Save와 동일하게 검증한다.
    let passedMandatoryValidation = false;
    saveWithValidation(
      [{ ...row, CRUD_TYPE: CRUD_TYPE.INSERT }],
      staticColumns[SHEETS.TAB1] ?? [],
      () => {
        passedMandatoryValidation = true;
      }
    );
    if (!passedMandatoryValidation) return;

    if (!(await confirmMsg(MSG.CONFIRM_CONFIRM, '_선택한 프로젝트 등록 요청을 승인하시겠습니까?')))
      return;
    const r = await callConfirmTab1(toConfirmPayload(row));
    if (!r.ok || r.event === 0) {
      // EVENT 0 = 갱신 0건 (D12 — 허위성공 방어: 실패 처리, 성공 토스트 금지)
      void setAlert({
        type: 'alert',
        content: t(
          !r.ok && r.messageId ? r.messageId : MSG.CONFIRM_FAIL,
          '_프로젝트 등록 요청 승인에 실패하였습니다.'
        ),
      });
      return;
    }
    setToast({
      type: 'success',
      message: t(MSG.CONFIRM_DONE, '_선택한 프로젝트 등록 요청이 승인되었습니다.'),
    });
    refreshTab1();
  };

  // TAB1 반려 (E07 — 행 단건 P-10): confirm MSG01011 → payload(계약 ① 4키 — note = 행 내용 전달) →
  //   CODE '0'+EVENT>0 = toast MSG01012 + 재조회 / 그 외 MSG01013
  const handleCancelRow = async (row: Tab1Row) => {
    if (!(await confirmMsg(MSG.CANCEL_CONFIRM, '_선택한 프로젝트 등록 요청을 반려하시겠습니까?')))
      return;
    const r = await callCancelTab1(toCancelPayload(row));
    if (!r.ok || r.event === 0) {
      void setAlert({
        type: 'alert',
        content:
          r.message && !r.ok
            ? r.message
            : t(MSG.CANCEL_FAIL, '_프로젝트 등록 요청 반려에 실패하였습니다.'),
      });
      return;
    }
    setToast({
      type: 'success',
      message: t(MSG.CANCEL_DONE, '_선택한 프로젝트 등록 요청이 반려되었습니다.'),
    });
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
    const r = await runPerRowProc(dirty.map(row => () => callSaveTab2(toSaveTab2Payload(row))));
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
      pjtKey: String(row.DPJT_KEY ?? ''),
      projectName: String(row.DPJT_NAME ?? ''),
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

  const columnSettingSheet = isTab1 ? SHEETS.TAB1 : SHEETS.TAB2;
  const columnSettingButton = {
    label: t('LBL00605', 'Column Setting'),
    title: t('LBL00605', 'Column Setting'),
    action: () => setOpenColumnSetting(true),
    iconComponent: <IcGridColumnSetup />,
    buttonLabel: '',
  };

  // ⭐ 페이지 최상위 = fragment (래퍼 div 금지 — hook #132)
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <MainTitle
          title={title}
          menuId={MENU_ID}
          openSearchArea={openSearchArea}
          disableSearchAreaToggle={isTab1}
          toggleOpenSearchArea={isTab1 ? undefined : setOpenSearchArea}
        />

        {/* 조회조건 = TAB2(프로젝트 Master 관리) 전용 소비 — TAB1 비노출 (F-3 확정) */}
        <ProjectMasterForm
          hidden={isTab1}
          onSearch={() => void handleSearch()}
          onDivisionChange={handleDivisionChange}
        />

        <SubTitle
          menuId={MENU_ID}
          grid={isTab1 ? tab1GridRef : tab2GridRef}
          gridFilter={isTab1 ? tab1FilterRef : tab2FilterRef}
          dataCount={isTab1 ? tab1Rows.length : tab2Rows.length}
          excelFileName='ProjectMaster'
          useHotkey={true}
          hotkeyConfig={hotkeyConfig}
          searchParam={sc}
          customButtons={[columnSettingButton]}
        />
        <ColumnLayoutModal
          open={openColumnSetting}
          modalClose={() => setOpenColumnSetting(false)}
          menuId={MENU_ID}
          sheetName={columnSettingSheet}
          columnType='C'
          divisionId={sc.divisionId}
          fallbackColumns={(staticColumns[columnSettingSheet] ?? []).map(column => ({
            key: column.colNm,
            header: column.colLblNm ?? column.colNm,
            width: column.colWth ?? 100,
            display: column.display,
            personalizable: column.personalizable,
          }))}
          title={t('LBL00605', 'Column Setting')}
          leftTitle={t('LBL00764', 'Invisible')}
          rightTitle={t('LBL00765', 'Visible')}
          initialSettings={toColumnLayoutSettings(staticColumns[columnSettingSheet] ?? [])}
          defaultSettings={toColumnLayoutSettings(originalStaticColumns[columnSettingSheet] ?? [])}
          onSave={settings => {
            applyColumnLayout(
              columnSettingSheet,
              settings.map(setting => ({
                colNm: setting.COLUMN_NAME,
                visible: setting.USER_FLAG === 'Y',
                width: setting.COL_WIDTH,
                cellColor: setting.CELL_COLOR,
                textColor: setting.TEXT_COLOR,
                order: setting.SORT_ORDER_NO,
              }))
            );
            const visible = settings.filter(setting => setting.USER_FLAG === 'Y');
            void saveTitleSet({
              menuId: MENU_ID,
              sheetName: columnSettingSheet,
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
              void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
              void fetchStaticColumns([columnSettingSheet]);
            });
          }}
        />
      </div>

      <div className={styles.mainContent}>
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
              excludeFromDirtyCheck={activeTab !== TAB_INDEX.TAB1}
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
              excludeFromDirtyCheck={activeTab !== TAB_INDEX.TAB2}
              divisionId={sc.divisionId}
              staticColumns={staticColumns[SHEETS.TAB2]}
              onAuthRegCellClick={handleAuthRegCellClick}
            />
          </TabItem>
        </TabWrapper>
      </div>

      <AuthManagementPopup
        open={!!authRegTarget}
        pjtKey={authRegTarget?.pjtKey ?? ''}
        projectName={authRegTarget?.projectName ?? ''}
        onClose={closeAuthRegModal}
        onSaved={refreshActive}
      />
    </div>
  );
};
