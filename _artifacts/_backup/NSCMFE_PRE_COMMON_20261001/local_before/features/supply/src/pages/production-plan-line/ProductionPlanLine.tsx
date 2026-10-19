import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ProductionPlanFixReasonModal } from './components/modals/ProductionPlanFixReasonModal';
import { ProductionPlanInsertModal } from './components/modals/ProductionPlanInsertModal';
import { ProductionPlanLineLoadModal } from './components/modals/ProductionPlanLineLoadModal';
import { ProductionPlanLineForm } from './components/ProductionPlanLineForm';
import { ProductionPlanLineGrid } from './components/ProductionPlanLineGrid';
import { useProductionPlanLineValidation } from './hooks/useProductionPlanLineValidation';
import { LABEL, MENU_ID, MSG, SHEETS } from './production-plan-line.constants';
import type { FixMode, MainRow } from './production-plan-line.types';
import styles from './ProductionPlanLine.module.scss';
import { deriveEditContext, useProductionPlanLineStore } from './useProductionPlanLineStore';
import { canFixUnfixNew, isEeDivision } from './utils/productionPlanLineEditLock';

// AS-IS GSCM.SCP.Analysis.UIL SCP0013_ProductionPlanLine — 단일 pivot 그리드(spdMain) + Load 팝업.
//   설계: .atlas/gscm-design/SCP0013/design/00~03 (v4, DB 실측). 상세 매핑: __asis-mapping__.md.
//   버튼-API 배선: SCM_ADM_MNU_BTN_MPG_M(SCP0013)=main/SEARCH·main/SAVE·load/SEARCH 3행 등록됨
//     (ora.py 2026-09-18). SAVE = P_SCP0013_SAVE_LINE_ROW_JSON(JSON CLOB). SP 배포 완료(PKG_SCP0013 VALID),
//     메뉴 가시화 완료(SCM_ADM_MNU_M 등록). design 03 §6 / 05_register.sql.
//   권한 모델: New/Fix/Unfix 는 AS-IS 에서 전부 CanUpdate(화면 update 권한) 하나로 게이트된다. TO-BE 는
//     별도 INSERT/UPDATE 버튼권한이 없고 SAVE 가 이 화면의 유일한 update 권한이므로 세 액션 모두
//     hasButton('SAVE') 로 통일한다(design 01 R1/§5 — INSERT 미등록 코드 게이트 금지).
export const ProductionPlanLine = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSearch, validateSave } = useProductionPlanLineValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useProductionPlanLineStore(s => s.searchCondition);
  const filters = useProductionPlanLineStore(s => s.filters);
  const setFilter = useProductionPlanLineStore(s => s.setFilter);
  const setLoadFilter = useProductionPlanLineStore(s => s.setLoadFilter);
  const setSearchCondition = useProductionPlanLineStore(s => s.setSearchCondition);
  const openSearchArea = useProductionPlanLineStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanLineStore(s => s.setOpenSearchArea);
  const staticColumns = useProductionPlanLineStore(s => s.staticColumns);
  const fetchStaticColumns = useProductionPlanLineStore(s => s.fetchStaticColumns);
  const initialized = useProductionPlanLineStore(s => s.initialized);
  const latestPlanStart = useProductionPlanLineStore(s => s.latestPlanStart);
  const latestPlanSeq = useProductionPlanLineStore(s => s.latestPlanSeq);

  const [openItem, setOpenItem] = useState(false);
  const [openLoad, setOpenLoad] = useState(false);
  const [openFixReason, setOpenFixReason] = useState(false);
  const [openInsert, setOpenInsert] = useState(false);
  // btnWLast 텍스트 주차 — AS-IS GetLastRange(division)(SCM0001_GET_SCP_DAILY_PLAN_PERIOD). SP 미배선이라
  //   기본 공란(버튼 'W' 표기, 숨김 아님). 서버 배선 후 division별 최종주로 갱신(design 01 A3 확인필요).
  const wLastPeriod = '';

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  // 편집판정 컨텍스트 — 조회결과에서 최종 PlanType/FN 존재 파생 (design 01 F2).
  const editContext = useMemo(() => deriveEditContext(rows), [rows]);
  const visibilityCtx = useMemo(
    () => ({ division: sc.divisionId, operationGroup: sc.operationGroupId }),
    [sc.divisionId, sc.operationGroupId]
  );

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Fix/Unfix/New enable — 엄밀판정(design 01 R2): planDate=최신(옵션 idx0) & planSeq=최신 & planType∉{FN,TE}
  //   & 세 값 non-empty. Form 이 스토어로 승격한 최신 버전 CODE(latestPlanStart/Seq)와 선택값을 대조한다
  //   (근사 제거 — canFixUnfixNew util 배선, M6/gap-audit iter-1).
  const canFix = useMemo(
    () =>
      canFixUnfixNew({
        planStartYyyymmdd: sc.planStartYyyymmdds[0] ?? '',
        planType: sc.planTypes[0] ?? '',
        planSeq: sc.planSeqs[0] ?? '',
        latestPlanStart,
        latestPlanSeq,
      }),
    [sc.planStartYyyymmdds, sc.planTypes, sc.planSeqs, latestPlanStart, latestPlanSeq]
  );

  // {0} 필수 메시지 — TO-BE MSG00429("{0} value is required.")는 i18next 가 {0}(.NET 형식)를 치환하지
  //   않으므로 라벨을 직접 넣는다(자매 tact-time alert 규약과 동일).
  const requiredMsg = (label: string): string =>
    t(MSG.REQUIRED_FIELD, '_{0} is required.').replace('{0}', label);

  // 조회/Load 공통 사전조건 — 필수 조회조건(Division/OperationGroup/Plan-date) + chkLineAssign→Material + 기간(from<=to).
  //   AS-IS checkRequiredOfSearch + Check_PeriodDate (design 02 §4.6 buttonGuards #12/13/14). Search·Load 둘 다 통과 필수.
  const checkRequiredAndPeriod = (): boolean => {
    // Division/OperationGroup 필수 (design 02 §6 — Division*/Operation Group*).
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: requiredMsg(LABEL.DIVISION) });
      return false;
    }
    if (!sc.operationGroupId) {
      void setAlert({ type: 'alert', content: requiredMsg(LABEL.OPERATION_GROUP) });
      return false;
    }
    // Plan-date 필수 — SP P_PLAN_START_YYYYMMDD 에 단일 실제 날짜가 TO_DATE 되므로 빈값/ALL 이면
    //   ORA-01841. AS-IS UsrCombo 단일 필수(design 02 #9). 미선택 시 조회/Load 차단.
    if (sc.planStartYyyymmdds.length === 0) {
      void setAlert({ type: 'alert', content: requiredMsg(LABEL.PLAN_DATE) });
      return false;
    }
    return validateSearch(sc).ok; // chkLineAssign → Material 필수(MSG00290) + 기간 from<=to
  };

  const handleSearch = () => {
    if (!checkRequiredAndPeriod()) return;
    setFilter();
    void fetchStaticColumns();
  };

  const dirtyRows = (): Record<string, unknown>[] => {
    const g = gridRef.current;
    g?.finishEditing();
    const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    return src.filter(r => r.CRUD_TYPE);
  };

  // 서버 SAVE_YN 재판정 (design 01 R3 / M5 보완) — Save/New/Fix/Unfix 진행 전 서버가 'Y' 를 줄 때만 통과.
  //   AS-IS Get_IsSaveYn(cs:3420~, SP cs:3442): division 공백이면 SP 호출 없이 false, 반환 EDIT_YN='Y' 만 통과.
  //   TO-BE P_SCP0013_GET_PLAN_SAVE_YN(P_DIVISION_ID·P_START_YYYYMMDD·P_PLAN_TYPE)→O_RC1 EDIT_YN(PKG body 실측).
  //   saveYn/SEARCH 버튼배선(ora.py 2026-09-27). 결과판정 res.code(false-success 방지). 서버 실동작·200 응답은
  //   runtime-parity-gate 브라우저 축(미확인) — 계약(파라미터·반환컬럼)은 DB 실측 확정.
  const checkServerSaveYn = async (): Promise<boolean> => {
    const divisionId = sc.divisionId;
    const startYyyymmdd = sc.planStartYyyymmdds[0] ?? '';
    const planType = sc.planTypes[0] ?? '';
    if (!divisionId || !startYyyymmdd || !planType) return false; // AS-IS division 공백 → 즉시 false
    try {
      const res = await apiClient.callProc<MENU_ID, SHEETS.SAVE_YN>(MENU_ID, SHEETS.SAVE_YN, 'SEARCH', {
        divisionId,
        startYyyymmdd,
        planType,
      });
      if (Number(res.code)) return false; // false-success 판정(공통 QA)
      const rc = (res.result as { o_rc1?: { EDIT_YN?: string }[] })?.o_rc1;
      return rc?.[0]?.EDIT_YN === 'Y';
    } catch {
      return false; // 서버 판정 실패 = 저장 불가로 간주(AS-IS 동치, 안전측)
    }
  };

  const handleSave = async () => {
    const dirty = dirtyRows();
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.SAVE_SUCCESS, '_No changes.') });
      return;
    }
    if (!validateSave(dirty).ok) return; // 수량 범위 / 신규행 붉은셀
    // 서버 SAVE_YN 가드 (design 01 R3 / 00 §4-D #30 — AS-IS SaveButton Get_PlanTypeSaveYn/MSG00182). New/Fix/Unfix
    //   와 동일하게 저장가능 plan type(EDIT_YN='Y')만 통과 — 확정/임시 버전(SAVE_YN=N) 저장 차단.
    if (!(await checkServerSaveYn())) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot modify this plan type.') });
      return;
    }
    // PROD_PLAN_AMEND 편집셀 저장 — main/SAVE = P_SCP0013_SAVE_LINE_ROW_JSON(P_DATA CLOB, PROC_M5, USE_YN=Y).
    //   JSON payload 실동작·200 응답·false-success 판정은 runtime-parity-gate 브라우저 축(design 03 §6).
    mutateMain(dirty as unknown as MainRow[]);
  };

  // New — 권한 + 버전선택(canFix) + 서버 SAVE_YN 가드(design 01 R1/R3/R4) 후 InsertPopup 오픈.
  //   AS-IS(design 01 R5)는 전용 삽입팝업(SCM0002_ProductionPlanInsertPopup)에서 Item 을 선택해 신규 라인을
  //   서버 저장(savePopup)한 뒤 재조회한다 — 클라이언트 행복사가 아니다. iter-4 까지의 GridAction.addRow(선택행
  //   복사)는 AS-IS 미대응 동작이라 제거하고(gap-audit M1/M6), Item 후보 선택 팝업 경로로 교체한다.
  //   팝업은 newPopup(Item 후보)만 소비해 선택 Item_id 를 반환하고, 부모는 R5 후처리(비EE txtItemId + MSG00265
  //   재조회)를 수행한다. 신규 라인 확정 저장(newCheck+savePopup, lineId·라인배정 UI 필요)은 팝업 내부 로직으로
  //   AS-IS 공통팝업(SCM0002, 저장소 밖) 원본이 있어야 재현 가능 — 04_react-gap.md 에 팝업 전용 산출로 인계.
  const handleInsert = async () => {
    // 화면 update 권한(=SAVE)으로 게이트 (design 01 R1/§5). AS-IS CanUpdate 단일권한 매핑 — INSERT 버튼권한은
    //   미등록(SCM_ADM_MNU_BTN_MPG_M 에 INSERT 행 없음)이라 hasButton('INSERT') 게이트는 New 상시차단 결함
    //   이었음(gap-audit iter-1 H1). SAVE 권한으로 Fix/Unfix 와 통일.
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    // canFix = planDate 최신(idx0) & planType∉{FN,TE} & 최종 SEQ & 세 값 non-empty (design 01 R2). planDate
    //   미선택도 여기서 걸러진다(R4 — cboPlanDate null 무동작). 그 외는 안내 메시지.
    if (!canFix) {
      void setAlert({ type: 'alert', content: t(MSG.INSERT_GUIDE, '_Select the latest plan version.') });
      return;
    }
    // 서버 SAVE_YN 재판정 (design 01 R3 #11 — New 가드). AS-IS 는 CanUpdate·planDate 뒤 Get_IsSaveYn 순서.
    if (!(await checkServerSaveYn())) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot modify this plan type.') });
      return;
    }
    setOpenInsert(true);
  };

  // InsertPopup OK 후처리 (design 01 R5) — 비EE 면 검색조건 txtItemId 세팅(EE 는 미주입), 이어 MSG00265
  //   재조회 confirm=Yes 면 메인 재조회(FindData_Main 등가 setFilter). editInfo(Get_IsEditInfo) 재조회의
  //   is_editable 반영은 M4(4커서/서버 편집판정) 소관으로 잔여 — 04_react-gap.md.
  const handleInsertConfirm = async (itemId: string, _originDivisionId: string) => {
    setOpenInsert(false);
    if (!isEeDivision(sc.divisionId)) setSearchCondition({ itemId });
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_RESEARCH, '_Do you want to re-search?') });
    if (!ok) return;
    setFilter();
    void fetchStaticColumns();
  };

  // 선택 셀/행 존재 — AS-IS Fix/Unfix 전제(design 01 R6 — selCells<1 → MSG00134).
  const hasSelectedCell = (): boolean => {
    const g = gridRef.current;
    return !!g && g.rows.length > 0 && (g.selection?.row ?? -1) >= 0;
  };

  // Fix/Unfix 실제 저장 — 편집셀(dirty)에 FIX_MODE(+Fix 사유) 부착 후 저장. 서버 SAVE_YN 재판정
  //   (P_SCP0013_GET_PLAN_SAVE_YN)·전용 fix-hist SP 배선은 SP/runtime 후속(honest — 04 리포트).
  const doFixSave = (mode: FixMode, reason?: string) => {
    const dirty = dirtyRows();
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.SAVE_SUCCESS, '_No changes.') });
      return;
    }
    const payload = dirty.map(r => ({ ...r, FIX_MODE: mode, ...(reason ? { FIX_REASON: reason } : {}) }));
    mutateMain(payload as unknown as MainRow[]);
  };

  // Fix/Unfix — 권한 + 버전선택(canFix) + 선택셀(MSG00134) 가드(design 01 R1/R2/R6).
  //   Unfix('U') 는 confirm(MSG00016) Yes 만 진행, Fix('F') 는 사유 팝업(RejectReasonPopup 등가) OK 만 진행.
  const runFix = async (mode: FixMode) => {
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (!canFix) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot fix/unfix this plan version.') });
      return;
    }
    // 서버 SAVE_YN 재판정 (design 01 R3 #17/#20 — Fix/Unfix 가드). AS-IS Get_IsSaveYn 를 선택셀 검사 앞에서.
    if (!(await checkServerSaveYn())) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot modify this plan type.') });
      return;
    }
    if (!hasSelectedCell()) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    if (dirtyRows().length === 0) {
      setToast({ type: 'error', message: t(MSG.SAVE_SUCCESS, '_No changes.') });
      return;
    }
    if (mode === 'U') {
      // Unfix confirm (design 01 R6 — MSG00016). setAlert(confirm) 은 확인 시 true resolve.
      const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, '_Do you want to unfix?') });
      if (!ok) return;
      doFixSave('U');
      return;
    }
    // Fix('F') — 사유 필수 입력 팝업 오픈(취소 시 저장 중단).
    setOpenFixReason(true);
  };

  const handleFixReasonConfirm = (reason: string) => {
    setOpenFixReason(false);
    doFixSave('F', reason);
  };

  // Load 팝업 — AS-IS BtnLoad_Click 3가드(checkRequiredOfSearch/Check_PeriodDate/planDate null) 재현 후 오픈
  //   (design 02 §4.6 #12/13/14). 통과 시 부모 조회조건 주입(setLoadFilter) — 완전 읽기전용 선택 로드.
  const handleLoad = () => {
    if (!checkRequiredAndPeriod()) return;
    setLoadFilter();
    setOpenLoad(true);
  };

  // Measure(TitleSet) — SCM0002_TitleSetForm_Popup(컬럼/measure 커스터마이즈, design 03 §6). 공용
  //   ColumnLayoutModal 대체 대상 — 미이식(별도 후속). 진입만 안내. TO-BE 에 "준비중" 등가 MSG 코드가
  //   없어(reverse-map 미탐) Measure 라벨(LBL00310) + 영문 안내로 표기(임의 MSG 신설 금지 §2.3).
  const handleMeasure = () => {
    setToast({
      type: 'default',
      message: `${t('LBL00310', { defaultValue: LABEL.MEASURE })}: not available yet.`,
    });
  };

  // 기간 프리셋 — GetDayRange(weeks) 등가 클라 산정(from=오늘, to=오늘+weeks*7-1). dayjs 로컬(함정12).
  const handlePreset = (weeks: number) => {
    const from = dayjs();
    const to = from.add(weeks * 7 - 1, 'day');
    setSearchCondition({ fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') });
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(search 버튼 권한과 무관하게 조회 동작 보장 — design 03 §6).
    search: handleSearch,
    // 툴바 공통 Insert/Delete = NO-OP (design 03 §5#14/§7.2). AS-IS override InsertButton/DeleteButton 본문은
    //   주석뿐(//InsertRow()/ //siMain.Delete(), cs:637~645) — 버튼은 노출하되 클릭 무동작이다. 공용 addRow/
    //   removeRow 로 실동작하거나 false 로 숨기면 둘 다 AS-IS 와 다르다. 키를 () => undefined 로 명시해 공용
    //   SubTitle 기본 핸들러(addRow/removeRow) 부활·버튼 숨김을 둘 다 막는다(convert-react self-check §3).
    //   신규행 추가는 화면 고유 New 버튼(customButtons, InsertPopup 경로)만 담당.
    insert: () => undefined,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ProductionPlanLineForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onPreset={handlePreset}
          wLastPeriod={wLastPeriod}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProductionPlanLine'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // 라벨 실측 LBL 코드(ora.py 2026-09-18): Fix=LBL00771 / Unfix=LBL00772 / New=LBL01028 / Measure=LBL00310.
          //   Load 전용 LBL 은 미탐이라 영문 라벨 유지(임의 코드 신설 금지 §2.3).
          { label: t('LBL00771', { defaultValue: LABEL.FIX }), action: () => void runFix('F'), disabled: !canFix },
          { label: t('LBL00772', { defaultValue: LABEL.UNFIX }), action: () => void runFix('U'), disabled: !canFix },
          { label: t('LBL01028', { defaultValue: LABEL.NEW }), action: () => void handleInsert() },
          { label: LABEL.LOAD, action: handleLoad },
          { label: t('LBL00310', { defaultValue: LABEL.MEASURE }), action: handleMeasure },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanLineGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          editContext={editContext}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Material 검색 — 공용 표준 ItemByDivisionModal (btnItemId → txtItemId). */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* Load 팝업 — 부모 조회조건 주입, 읽기전용 선택 로드 (design 01 §P). */}
      <ProductionPlanLineLoadModal open={openLoad} modalClose={() => setOpenLoad(false)} />

      {/* Fix 사유 팝업 — AS-IS RejectReasonPopup 등가(design 01 R6). OK 시에만 Fix 저장. */}
      <ProductionPlanFixReasonModal
        open={openFixReason}
        onClose={() => setOpenFixReason(false)}
        onConfirm={handleFixReasonConfirm}
      />

      {/* New 삽입팝업 — AS-IS SCM0002_ProductionPlanInsertPopup Item 후보 선택(design 01 R5). 선택 Item_id 반환. */}
      <ProductionPlanInsertModal
        open={openInsert}
        modalClose={() => setOpenInsert(false)}
        params={{
          divisionId: sc.divisionId,
          operationGroupId: sc.operationGroupId,
          planStartYyyymmdd: sc.planStartYyyymmdds[0] ?? '',
          planType: sc.planTypes[0] ?? '',
          planSeq: sc.planSeqs[0] ?? '',
        }}
        onConfirm={handleInsertConfirm}
      />
    </>
  );
};
