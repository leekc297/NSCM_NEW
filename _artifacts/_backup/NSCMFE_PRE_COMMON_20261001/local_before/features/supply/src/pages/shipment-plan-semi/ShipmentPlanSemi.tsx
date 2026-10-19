import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentPlanSemiForm } from './components/ShipmentPlanSemiForm';
import { ShipmentPlanSemiGrid, type SpreadTitleRow } from './components/ShipmentPlanSemiGrid';
import { useShipmentPlanSemiValidation } from './hooks/useShipmentPlanSemiValidation';
import type {
  BUCKET_TYPE} from './shipment-plan-semi.constants';
import {
  COMBO,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-semi.constants';
import type { FixInfoRow, MainRow } from './shipment-plan-semi.types';
import { useShipmentPlanSemiStore } from './useShipmentPlanSemiStore';
import { buildSaveRows, buildSavePayloadJson, isSaveResultFailure } from './utils/shipment-plan-semi.save';

// AS-IS GSCM.SCP.Analysis.UIL SCP0010_Shipment_Plan_SEMI — 단일 그리드(spdMain), 서브그리드 없음.
//   설계: .atlas/gscm-design/SCP0010/design/00~03. 상세 매핑: __asis-mapping__.md.
//   자매화면 SCP0009(shipment-plan-fg) 골격 참고 — 로직(BlockCellsChecking 분기, payload 형식)은
//   이 화면 고유 실측(design/01~03)을 따른다. 복붙 아님.
//   Edit(잠금 토글) 버튼은 design 01 §5#4 — 사용자 결정 대기, 표준 DataGrid 상시편집 모델로 임시 구현.
export const ShipmentPlanSemi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateSearch } = useShipmentPlanSemiValidation();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();

  const sc = useShipmentPlanSemiStore(s => s.searchCondition);
  const set = useShipmentPlanSemiStore(s => s.setSearchCondition);
  const filters = useShipmentPlanSemiStore(s => s.filters);
  const setFilter = useShipmentPlanSemiStore(s => s.setFilter);
  const clearFilters = useShipmentPlanSemiStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanSemiStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanSemiStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanSemiStore(s => s.staticColumns);
  const staticMeasures = useShipmentPlanSemiStore(s => s.staticMeasures);
  const fetchStaticColumns = useShipmentPlanSemiStore(s => s.fetchStaticColumns);
  const initialized = useShipmentPlanSemiStore(s => s.initialized);
  const appliedPlanStartYyyymmdd = useShipmentPlanSemiStore(s => s.appliedPlanStartYyyymmdd);
  const appliedToYyyymmdd = useShipmentPlanSemiStore(s => s.appliedToYyyymmdd);
  const appliedPlanType = useShipmentPlanSemiStore(s => s.appliedPlanType);
  const appliedPlanSeq = useShipmentPlanSemiStore(s => s.appliedPlanSeq);

  const [openItem, setOpenItem] = useState(false);
  const [openMeasureSetup, setOpenMeasureSetup] = useState(false);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: !!filters[SHEETS.CALENDAR],
  });

  const mainRows = useMemo<MainRow[]>(() => (mainData as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [mainData]);
  const fixInfoRows = useMemo<FixInfoRow[]>(
    () => (mainData as { o_rc3?: FixInfoRow[] })?.o_rc3 ?? [],
    [mainData]
  );
  const spreadTitle = useMemo<SpreadTitleRow[]>(
    () => (calendarData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [],
    [calendarData]
  );

  // Measure 세트는 OperationGroup 값(A=CELL, 그외=ELECTRODE)에 종속(design 03 §0.1) — 조회 시점 확정값 사용.
  const measureSheetGroup = sc.operationGroupId === 'A' ? 'CELL' : 'ELECTRODE';
  const currentMeasures = staticMeasures[measureSheetGroup];

  // Model 팝업(ItemByDivisionModal) division 파라미터 — AS-IS UIUtils.GetAllDivisionCheckedElectrode
  //   재현(design 02 §4.6). res.Substring(0,2)=="EE" 만 보고(EE_UC 도 "EE"로 시작하므로 동일 분기),
  //   EE 계열이면 GetAllDivisionsExceptUCEE(콤보 후보 중 접미 "UC" 아니고 접두 "EE" 아닌 항목의
  //   콤마조인) 목록으로 치환한다 — SCP0009 의 GetAllDivisionChecked(EE_UC 전용 "81_UC" 고정값
  //   분기)와 다르다, 복붙 금지(iter-2 gap-audit SCP0010-G-09).
  const [itemModalDivisionOptions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const itemModalDivisionId = useMemo(() => {
    const raw = sc.divisionId;
    if (!raw.startsWith('EE')) return raw;
    const codes = (itemModalDivisionOptions ?? [])
      .map(o => String(o.CODE ?? ''))
      .filter(c => c !== '' && !c.endsWith('UC') && !c.startsWith('EE'));
    return codes.join(',');
  }, [sc.divisionId, itemModalDivisionOptions]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(nscm-patterns.md §5-7) + 메타 1회 fetch.
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Bucket 전환(design 03 §0.2/§2.4) — chkAll 은 AS-IS Visible=false 죽은 코드라 렌더하지 않음.
  //   SCP0009 와 달리 예외 경로 없이 매번 InitSpread_2+ClearDataSource 파리티로 재조회 필요 상태로 전환.
  const handleChangeBucketType = (bucketType: BUCKET_TYPE) => {
    set({ bucketType });
    clearFilters();
  };

  const handleSearch = () => {
    const result = validateSearch(sc);
    if (!result.ok) {
      void setAlert({ type: 'alert', content: t(result.messageKey ?? 'MSG00002', result.defaultMessage ?? '') });
      return;
    }
    setFilter();
  };

  // Fix/Unfix/New 공통 가드(design 01 §2 #1-5): PlanSeq 최댓값 여부로 파생된 disabled(규칙#1) +
  //   CanUpdate 권한 / 그리드 잠금 상태(IsLock) / 저장가능 SP 판정. `SCP0013_GET_PLAN_TYPE_SAVE_YN`
  //   판정 SP 는 SCP0013 화면 소관 메뉴/버튼 권한에 등록돼 있어(ora.py 재실측, iter-2) SCP0010 이
  //   임의로 재사용 배선할 수 없다(convert-core Hard Boundary §2.2 — 타 화면 메뉴 권한 재사용 금지).
  //   이 화면 단독으로는 해소 불가 — 교차 화면 SP 재사용 정책이 사용자 결정된 후 별도 activity 로
  //   보강해야 한다(iter-2 gap-audit SCP0010-G-05). 그 전까지 이 축은 확인 필요로 남기고 나머지
  //   가드만 재현한다(SCP0009 M9 와 동일 제약).
  const isLockedPlanType = sc.planType === 'FN' || sc.planType === 'TE';
  // btnFix/btnUnfix/btnNew 공통 disabled(design 01 §2 #1) — PlanSeq 콤보 후보 최댓값 여부는
  //   ShipmentPlanSemiForm 이 useTabComboQueries 로 이미 자동선택하므로, 여기서는 sc.planSeq 가 그
  //   자동선택값과 같은지를 별도로 재조회하지 않고 "폼이 자동으로 최댓값을 유지한다"는 전제(§2.6)로
  //   isLockedPlanType 만 disabled 조건에 반영한다 — 사용자가 PlanSeq 를 최댓값이 아닌 값으로 강제
  //   변경할 UI 경로가 없으므로(폼이 항상 재확정) 이 축은 실질적으로 isLockedPlanType 과 동치.
  const canOperate = !isLockedPlanType;

  const saveFixDataset = async (action: 'FIX' | 'UNFIX', fixReason: string): Promise<boolean> => {
    const tracker = mainTrackerRef.current;
    const rows = buildSaveRows(
      tracker,
      useSessionStore.getState().session.userId ?? '',
      '',
      appliedPlanType,
      appliedPlanSeq,
      fixReason
    );
    // SCM_ADM_PROC_M(PROC_NM=PKG_SCP0010.P_SCP0010_SAVE_SEMI_FIX_DS) 등록 COL_NM = data/sesUserId
    //   (ora.py 실측, iter-2) — pData/pUserId 로 보내면 name-lookup 바인딩이 NULL 처리돼 저장이
    //   빈 값으로 실행된다.
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string }[] }>(
      `/${MENU_ID}/${SHEETS.MAIN}/${action}/call-proc`,
      { data: buildSavePayloadJson(rows), sesUserId: useSessionStore.getState().session.userId ?? '' }
    );
    if (isSaveResultFailure(res)) {
      void setAlert({
        type: 'alert',
        content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Save failed.'),
      });
      return false;
    }
    const result = (res.data?.result?.o_rc1 ?? [])[0];
    if (result && String(result.RESULT_CODE ?? '') !== '0') {
      void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return false;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    mainTrackerRef.current?.clearChanges();
    setFilter();
    return true;
  };

  const handleFix = () => {
    if (!hasButton('FIX')) return;
    if (mainRows.length === 0) return; // 조회결과 없음 — silent no-op
    if (!canOperate) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // Fix 는 confirm 없이 즉시 실행(design 01 §2 #2 가드체인 통과 후 즉시 저장) — 저장 SP 는
    //   PROC_M 등록 완료(iter-2, ora.py 재실측 확인), E2E 런타임(브라우저 왕복)만 미검증(ERROR,
    //   __asis-mapping__.md 명시. iter-2 gap-audit SCP0010-G-08).
    void saveFixDataset('FIX', 'FIX');
  };

  const handleUnfix = () => {
    if (!hasButton('UNFIX')) return;
    if (mainRows.length === 0) return;
    if (!canOperate) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // Unfix 는 Fix 와 달리 confirm(MSG00016) 필수(design 01 §2 #3) — Yes 선택 시에만 저장.
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_UNFIX, '_Are you sure you want to unfix?'),
      onConfirm: () => {
        void saveFixDataset('UNFIX', 'UNFIX');
      },
    });
  };

  const handleNew = () => {
    if (!hasButton('NEW')) return;
    if (!sc.planStartYyyymmdd) return; // cboPlanDate 미선택 — 메시지 없이 조용히 차단(design 01 §2 #5)
    if (!canOperate) return; // 저장가능 SP 판정 대체 — 확인 필요(위 canOperate 주석 참조)
    // 확인 필요(iter-4 AS-IS 서브분석 완료, 여전히 미구현) — SCM0002_ShipmentPlanInsertPopup 은
    //   자체 spread 그리드(콤보 15열+cascade)·중첩 BOD 선택 팝업(SCM0002_GetBODItemPopup)·독립 저장
    //   경로(SP `SCM.SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK`→`SCM0002_SAVE_SHIPMENT_PLAN_NEW`)를 가진
    //   별도 서브화면이다 — 축소판 화면 1개를 새로 변환하는 규모라 이 activity 의 design/00~03(SCP0010
    //   본화면) 범위 밖이며, 자매화면 SCP0009 도 동일 결론으로 미구현 상태(shipment-plan-fg
    //   handleNew 참조). Oracle 측은 P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK 는 VALID 이나
    //   SCM_ADM_PROC_M 미등록(ora.py 재실측, PKG_SCM0002.P_SCM0002_SAVE_SHIPMENT_PLAN_NEW 만 등록됨) —
    //   백엔드 배선도 미완이라 추측 구현은 anti-simplification §1 위반. 전용 design 서브태스크(+
    //   convert-sp PROC_M 등록) 선행 필요 — 그 전까지는 가드만 재현하고 팝업은 열지 않는다.
    //   MSG00000 은 DB 미등록(0 rows, 재확인)이라 기 등록된 MSG00284("The grid is not ready.")로 교체.
    void setAlert({
      type: 'alert',
      content: t(MSG.NEW_POPUP_NOT_READY, '_The grid is not ready.'),
    });
  };

  // 일반 저장(design 03 §4.4, P_SCP0010_SAVE_SEMI_DATASET) — 변경 D_ 셀만 24필드 JSON 배열(CLOB).
  //   editable(=잠금해제) 상태 아니면 저장 자체 차단(design 01 §2 #7) — 이 화면은 EditButton(잠금토글)
  //   UX 를 사용자 결정 대기 상태로 표준 DataGrid 상시편집 모델로 임시 구현했으므로(design 01 §5#4),
  //   canOperate(PlanType 잠금 여부)만 게이트로 쓴다 — Edit 토글 자체는 별도 미구현.
  //   81 계열 Weekly LOT SIZE 분배 저장(P_SCP0010_SAVE_SEMI_WEEKLY)은 알고리즘 상세 확인 필요(design
  //   03 §6#4)라 이 activity 범위에서 분기 배선하지 않는다 — 일반 저장 SP 로만 전송(확인 필요 남김).
  const handleSave = async () => {
    // AS-IS SaveData_Main(.cs:2124-2132)도 Get_IsSaveYn()(SCP0013_GET_PLAN_TYPE_SAVE_YN, MSG00182)를
    //   호출한다(design 01 §5-1 — Fix/Unfix/New 와 동일 SP 를 공유, 체크리스트가 영역3 항목으로
    //   분류해 놓아 4회차 감사 동안 이 가드 자체가 handleSave 에 배선되지 않은 채 누락돼 있었다
    //   — gap-resolve iter-1 확정, 독립 react-gap-audit G-06). SP 는 G-05 와 동일한 Hard Boundary
    //   (SCP0013 메뉴 소관, SCP0010 이 임의 배선 불가)라 Fix/Unfix/New 와 동일하게 canOperate 대체
    //   게이트만 재현한다 — SP 실배선은 교차 화면 정책 사용자 결정 후 별도 activity.
    if (!canOperate) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_Save is not allowed for this plan.') });
      return;
    }
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const tracker = mainTrackerRef.current;
    if (!tracker?.hasChanges()) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    const rows = buildSaveRows(
      tracker,
      useSessionStore.getState().session.userId ?? '',
      '',
      appliedPlanType,
      appliedPlanSeq
    );
    if (rows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    // SCM_ADM_PROC_M(PROC_NM=PKG_SCP0010.P_SCP0010_SAVE_SEMI_DATASET) 등록 COL_NM = data/sesUserId
    //   (ora.py 실측, iter-2) — pData/pUserId 로 보내면 name-lookup 바인딩이 NULL 처리돼 저장이
    //   빈 값으로 실행된다.
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string }[] }>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      { data: buildSavePayloadJson(rows), sesUserId: useSessionStore.getState().session.userId ?? '' }
    );
    if (isSaveResultFailure(res)) {
      void setAlert({
        type: 'alert',
        content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Save failed.'),
      });
      return;
    }
    const result = (res.data?.result?.o_rc1 ?? [])[0];
    if (result && String(result.RESULT_CODE ?? '') !== '0') {
      void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    tracker.clearChanges();
    setFilter();
  };

  // hotkeyConfig — DeleteButton 은 AS-IS 본문이 주석처리된 1줄뿐인 NO-OP 확정(design 01 §2 판정표).
  //   버튼 노출은 유지하되 클릭만 무동작 — `() => undefined`(false/키 생략 금지, convert-core 절차3).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: false,
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
        <ShipmentPlanSemiForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanSemi'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          hasButton('NEW') && { label: t('LBL01028', { defaultValue: 'New' }), action: handleNew, disabled: !canOperate },
          hasButton('FIX') && { label: t('LBL00771', { defaultValue: 'Fix' }), action: handleFix, disabled: !canOperate },
          hasButton('UNFIX') && { label: t('LBL00772', { defaultValue: 'Unfix' }), action: handleUnfix, disabled: !canOperate },
        ].filter((b): b is Exclude<typeof b, false> => b !== false)}
      />

      <ShipmentPlanSemiGrid
        rows={mainRows}
        spreadTitle={spreadTitle}
        fixInfoRows={fixInfoRows}
        gridRef={mainGridRef}
        gridFilterRef={mainFilterRef}
        editTrackerRef={mainTrackerRef}
        adminColumns={staticColumns}
        division={sc.divisionId}
        planStartYyyymmdd={appliedPlanStartYyyymmdd}
        toYyyymmdd={appliedToYyyymmdd}
        bucketType={sc.bucketType}
        chkSum={sc.chkSum}
        onChangeBucketType={handleChangeBucketType}
        onChangeChkSum={chkSum => set({ chkSum })}
        onOpenMeasureSetup={() => setOpenMeasureSetup(true)}
        showMeasureButton={hasButton('MEASURE_SELECT')}
        onFocus={() => undefined}
      />

      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => set({ itemId: itemIds })}
        preSearchParams={{ divisionId: itemModalDivisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
      {/* Measure 커스텀 설정(btnMeasure) — SCM0002_TitleSetForm_Popup("SCP0010", measureType, false) 대응,
          measureType = OperationGroup 기준 CELL/ELECTRODE(design 00 §1 #6, design 03 §0.1). 메인 SP 가
          SCM_MST_TITLESET_USER 를 직접 읽어 Measure 행을 필터하므로(design 03 §0.1) FE 는 영구 저장 후
          setFilter() 재조회만 하면 된다(measure 코드 파라미터 전달 불요). */}
      <MeasureSelectModal
        open={openMeasureSetup}
        modalClose={() => setOpenMeasureSetup(false)}
        measures={currentMeasures}
        visibleMeasures={null}
        fallbackCodes={currentMeasures.map(m => m.colNm)}
        onApply={codes => {
          const all = currentMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: MEASURE_SHEET_NAME[measureSheetGroup],
            columnType: TITLESET_MEASURE_TYPE,
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Save failed.') });
              return;
            }
            setFilter();
          });
        }}
      />
    </>
  );
};
