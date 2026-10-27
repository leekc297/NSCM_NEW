import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { NewPlanModal, type NewPlanContext } from 'features/supply/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentPlanSemiForm } from './components/ShipmentPlanSemiForm';
import { ShipmentPlanSemiGrid, type SpreadTitleRow } from './components/ShipmentPlanSemiGrid';
import { useShipmentPlanSemiValidation } from './hooks/useShipmentPlanSemiValidation';
import {
  LBL,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-semi.constants';
import type { FixInfoRow, MainRow } from './shipment-plan-semi.types';
import { useShipmentPlanSemiStore } from './useShipmentPlanSemiStore';
import {
  buildFixRows,
  buildSaveRows,
  buildSavePayloadJson,
  buildWeekToDayBindings,
  isSaveResultFailure,
} from './utils/shipment-plan-semi.save';

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
  const fetchStaticMeasures = useShipmentPlanSemiStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useShipmentPlanSemiStore(s => s.restoreSearchConditions);
  const initialized = useShipmentPlanSemiStore(s => s.initialized);
  const appliedPlanStartYyyymmdd = useShipmentPlanSemiStore(s => s.appliedPlanStartYyyymmdd);
  const appliedToYyyymmdd = useShipmentPlanSemiStore(s => s.appliedToYyyymmdd);
  const appliedPlanType = useShipmentPlanSemiStore(s => s.appliedPlanType);
  const appliedPlanSeq = useShipmentPlanSemiStore(s => s.appliedPlanSeq);

  const [openItem, setOpenItem] = useState(false);
  const [openMeasureSetup, setOpenMeasureSetup] = useState(false);
  const [openNewPlan, setOpenNewPlan] = useState(false);

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
  // plan-level 편집가능 — GET SP o_rc2 IS_EDITABLE(플랜 시작주 < 이번주 월요일이면 'N', PKG_SCP0010 L2951).
  //   AS-IS grid 잠금/Get_IsSaveYn 상당. 값 없으면 보수적으로 false(편집불가).
  const planEditable = useMemo(
    () => ((mainData as { o_rc2?: { IS_EDITABLE?: string }[] })?.o_rc2?.[0]?.IS_EDITABLE ?? 'N') === 'Y',
    [mainData]
  );
  const spreadTitle = useMemo<SpreadTitleRow[]>(
    () => (calendarData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [],
    [calendarData]
  );

  // 선택 셀 Fix/Unfix 전개 보조 — W_(주 SUM) 선택 시 그 주의 D_ 로 펼칠 매핑(calendar SP 결과 기준) +
  //   현재 fix 된 일자 집합(O_RC3, unfix 는 fix 된 일자만 대상). FixInfoRow.YYYYMMDD 는 'D_' 접두가
  //   붙을 수 있어 제거해 bare yyyymmdd 로 맞춘다(그리드 fixedDayBindings 와 동일 매칭).
  const weekToDays = useMemo(() => buildWeekToDayBindings(spreadTitle), [spreadTitle]);
  const fixedDays = useMemo(
    () => new Set(fixInfoRows.map(r => String(r.YYYYMMDD ?? '').replace(/^D_/, ''))),
    [fixInfoRows]
  );

  // Measure 세트는 OperationGroup 값(A=CELL, 그외=ELECTRODE)에 종속(design 03 §0.1) — 조회 시점 확정값 사용.
  const measureSheetGroup = sc.operationGroupId === 'A' ? 'CELL' : 'ELECTRODE';
  const currentMeasures = staticMeasures[measureSheetGroup];

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(nscm-patterns.md §5-7) + 메타 1회 fetch.
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns();
    }
    // 개인화 조회조건 복원(F6 저장분) — 1회 가드 내장, Form 자동선택보다 우선 적용된다(자매 SCP0009 동일).
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

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
    // Fix/Unfix 는 "선택 셀" 기반(AS-IS SaveData_FixInfo, 사용자 결정 2026-10-13) — 편집(EditTracker)이
    //   아니라 그리드에서 선택한 날짜 셀을 대상으로 한다. 일반 저장(handleSave)만 EditTracker(buildSaveRows).
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const rows = buildFixRows(
      grid,
      action,
      fixReason,
      useSessionStore.getState().session.userId ?? '',
      appliedPlanType,
      appliedPlanSeq,
      weekToDays,
      fixedDays
    );
    if (rows.length === 0) {
      // 선택 셀 없음 / 대상 일자 0건 — AS-IS selCells<1(MSG00134) · iCount<=0(MSG00252) 통합 안내.
      void setAlert({ type: 'alert', content: t(MSG.SELECT_FIX_DATE, '_No date selected. Select Fix/Unfix date.') });
      return false;
    }
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
    // 성공 코드는 'S' 다 — AS-IS SaveData_FixInfo result_code.Equals("S")(.cs:4259). o_rc1.RESULT_CODE
    //   가 'S' 가 아니면 실패(RESULT_MSG=err_message). '0' 비교는 프레임워크 O_RESULT_CURSOR.CODE('0')와
    //   혼동한 오판(SP 비즈니스 결과는 o_rc1.RESULT_CODE='S', 네트워크 실측 2026-10-13).
    if (result && String(result.RESULT_CODE ?? '') !== 'S') {
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
    // 조회결과 자체가 없음(그리드 0행) — AS-IS 는 그리드가 기본 잠금(수정모드 아님) 상태라 BtnFix_Click
    //   의 IsLock 가드가 MSG00010(수정모드가 아니므로 저장할 수 없습니다)을 띄운다(.cs:4859-4861). TO-BE 는
    //   상시편집 모델이라 IsLock 개념이 없으므로 그 문구(LOCKED_MODE=MSG01046, TO-BE 역매핑)로 알린다
    //   (조용한 no-op 회귀 수정, 사용자 보고 2026-10-13). 그리드에 행은 있는데 선택이 없는 경우는
    //   saveFixDataset 의 선택 대상 0건 가드(MSG01262)가 처리한다.
    if (mainRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    if (!canOperate) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // plan-level 편집가능(IS_EDITABLE) 게이트 — 과거주 플랜은 Fix 불가(AS-IS Get_IsSaveYn=false→MSG00182 상당).
    if (!planEditable) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') });
      return;
    }
    // Fix 는 confirm 없이 즉시 실행(design 01 §2 #2 가드체인 통과 후 즉시 저장) — 저장 SP 는
    //   PROC_M 등록 완료(iter-2, ora.py 재실측 확인), E2E 런타임(브라우저 왕복)만 미검증(ERROR,
    //   __asis-mapping__.md 명시. iter-2 gap-audit SCP0010-G-08).
    void saveFixDataset('FIX', 'FIX');
  };

  const handleUnfix = () => {
    if (!hasButton('UNFIX')) return;
    // 조회결과 없음 — handleFix 와 동일(AS-IS BtnUnfix_Click IsLock 가드 MSG00010, .cs:4882-4884).
    if (mainRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    if (!canOperate) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // plan-level 편집가능(IS_EDITABLE) 게이트 — 과거주 플랜은 Unfix 불가(confirm 전에 차단).
    if (!planEditable) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') });
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

  // New 버튼 팝업 호출 컨텍스트 — AS-IS BtnNew_Click 이 팝업에 넘기는 값(.cs:4919-4930). programId 로 SEMI 분기
  //   (Project Code 숨김·toSite PLANT·Operation Group 콤보 등)을 공용 NewPlanModal 이 처리한다.
  //   useMemo 로 참조를 고정한다 — 매 렌더 새 객체면 모달의 staticColumns/핸들러 재부착이 저장 대기 중에
  //   재실행돼 그리드 행이 비워지는 레이스를 유발한다(NewPlanModal handleSave 스냅샷 주석 참조).
  const newPlanContext = useMemo<NewPlanContext>(
    () => ({
      divisionId: sc.divisionId,
      operationGroupId: sc.operationGroupId,
      planStartYyyymmdd: sc.planStartYyyymmdd,
      planType: sc.planType,
      planSeq: sc.planSeq,
      programId: 'SEMI',
    }),
    [sc.divisionId, sc.operationGroupId, sc.planStartYyyymmdd, sc.planType, sc.planSeq]
  );

  // 팝업 저장 성공 후 — 비EE 는 신규 Item 을 조회조건에 채우고 재조회 여부를 묻는다(AS-IS .cs:4932-4948).
  //   EE 는 아무 동작도 하지 않는다(AS-IS SetChangedControlPart 호출이 주석 처리돼 있다, .cs:4934-4937).
  const handleNewPlanSaved = (itemIds: string[]) => {
    if (sc.divisionId.startsWith('EE')) return;
    set({ itemId: itemIds.join(',') });
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_RESEARCH, '_Do you want to re-search?'),
      onConfirm: () => handleSearch(),
    });
  };

  const handleNew = () => {
    if (!hasButton('NEW')) return;
    if (!sc.planStartYyyymmdd) return; // cboPlanDate 미선택 — 메시지 없이 조용히 차단(design 01 §2 #5)
    // 그 Division+Plan Date 에 Plan 이 없어 Plan Type/Seq 가 비면 신규 입력 대상 Plan 자체가 없다 —
    //   New 팝업 컨텍스트(Div/Plan-date/Plan-type/Seq/Operation Group)가 빈 값으로 열리는 것을 막는다.
    //   AS-IS 는 이 경우 Get_IsSaveYn() 이 NO_DATA → N → MSG00182("수정할 수 없는 플랜입니다")로 차단한다(.cs:1523-1524).
    if (!sc.planType || !sc.planSeq) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This Plan can not be modified.') });
      return;
    }
    // AS-IS Get_IsSaveYn()(최종 PLAN 상태 체크, .cs:4909) 대체 — 저장가능 판정 SP(SCP0013_GET_PLAN_TYPE_SAVE_YN)는
    //   SCP0013 메뉴 소관이라 SCP0010 이 배선 불가(Hard Boundary, __asis-mapping__ G-05). canOperate(PlanType
    //   FN/TE 잠금 여부)로 대체 — handleFix/handleSave 와 동일 게이트.
    if (!canOperate) return;
    // plan-level 편집가능(IS_EDITABLE) 게이트 — 과거주 플랜은 New 불가(AS-IS Get_IsSaveYn=false→MSG00182 상당).
    if (!planEditable) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This plan cannot be modified.') });
      return;
    }
    // EE+Operation Group A 가드는 FG 호출부에만 있고 SEMI 는 없다(newPlan.ts isNewPlanBlocked 주석, FG .cs:1130-1131).
    setOpenNewPlan(true); // AS-IS SCM0002_ShipmentPlanInsertPopup ShowDialog(.cs:4919-4930)
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
    // 성공 코드 'S'(AS-IS SaveData_Main result_code.Equals("S"), .cs:2920) — saveFixDataset 와 동일 교정.
    if (result && String(result.RESULT_CODE ?? '') !== 'S') {
      void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    tracker.clearChanges();
    setFilter();
  };

  // hotkeyConfig — DeleteButton 은 AS-IS 본문이 주석처리된 1줄뿐인 NO-OP 확정(design 01 §2 판정표,
  //   SCP0010_Shipment_Plan_SEMI.cs:879-882 `//siMain.Delete();` 실측). AS-IS 는 버튼을 NO-OP 로
  //   노출만 했으나, 사용자 지시(2026-10-13)로 버튼 자체를 숨긴다 — `delete: false`(SubTitle 이
  //   `buttonActions.delete === false` 면 버튼 미렌더). 키 생략은 금지(기본 removeRow 가 살아나 실삭제).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: false,
    delete: false,
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
        // Condition(F6) 저장 시 plan date(planStartYyyymmdd)도 보존 — 기본 날짜 제외 규칙에서 예외 처리
        //   (사용자 요청 2026-10-13). planType/planSeq 는 날짜형이 아니라 이미 저장되며, plan date 까지
        //   복원되어야 3단(date→type→seq)이 저장값대로 일관되게 살아난다(restoreSearchConditions).
        conditionIncludeKeys={['planStartYyyymmdd']}
        customButtons={[
          hasButton('NEW') && { label: t(LBL.NEW, '_New'), action: handleNew, disabled: !canOperate },
          hasButton('FIX') && { label: t(LBL.FIX, '_Fix'), action: handleFix, disabled: !canOperate },
          hasButton('UNFIX') && { label: t(LBL.UNFIX, '_Unfix'), action: handleUnfix, disabled: !canOperate },
          // btnMeasure(TitleSet) — SCP0011(production-plan) 동일 아이콘(IcMeasureSelect) + 상단 툴바 이동
          //   (사용자 지시 2026-10-12). 기존 그리드 툴바 텍스트 버튼에서 교체.
          hasButton('MEASURE_SELECT') && {
            label: t(LBL.MEASURE, '_Measure'),
            title: t(LBL.MEASURE, '_Measure'),
            // AS-IS btnMeasure_Click(.cs:4726)는 조회와 무관하게 현재 cboOperGroup(A=CELL/그외=ELECTRODE)
            //   기준으로 measure 목록을 팝업이 직접 로드한다. TO-BE 는 setFilters(조회) 에서만 fetch 하므로
            //   조회 전에 열면 staticMeasures 가 비어 팝업이 공란이 된다 → 버튼 클릭 시 현재 그룹을 fetch 한다.
            action: () => {
              void fetchStaticMeasures(measureSheetGroup);
              setOpenMeasureSetup(true);
            },
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
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
        planEditable={planEditable}
        chkSum={sc.chkSum}
        onFocus={() => undefined}
      />

      {/* Model/Nickname 공용 검색 — 메1(MaterialByDivisionModal COM0013, SCP0013 동일 패턴, 사용자 지시
          2026-10-12). 모3 ItemByDivisionModal 에서 교체. EE/EE_UC division 매핑(81,82,40 / 81_UC)은
          모달이 내부 처리하므로 sc.divisionId 를 그대로 넘긴다. 반환 첫 인자(items=ITEM_ID csv)만 itemId 로
          — 이 화면 GET SP 는 P_ITEM_ID 만 사용(nickName 미사용). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => set({ itemId: items })}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
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
      {/* New(Insert Plan) 팝업 — AS-IS SCM0002_ShipmentPlanInsertPopup. SCP0009(FG)와 공용 모달,
          programId='SEMI' 로 분기. DB(call-proc 라우트 newCheck/savePopup/bodPopup + PROC_M)는 SCP0010 까지
          등록 확인됨(.atlas/gscm-design/SCM0002/design/11·12_register*.sql, ora.py 실측 2026-10-12). */}
      <NewPlanModal
        open={openNewPlan}
        modalClose={() => setOpenNewPlan(false)}
        context={newPlanContext}
        menuId={MENU_ID}
        onSaved={handleNewPlanSaved}
      />
    </>
  );
};
