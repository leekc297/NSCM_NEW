import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
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
import { LBL, LINE_TOTAL_MEASURE_PREFIX, MENU_ID, MSG, SHEETS } from './production-plan-line.constants';
import { MOCK_EDIT_INFO_DATA, MOCK_MAIN_DATA, MOCK_MAIN_ENABLED } from './production-plan-line.mock'; // ⚠ 임시 개발용 목데이터
import type { EditInfoRow, FixMode, FixRow, MainRow } from './production-plan-line.types';
import styles from './ProductionPlanLine.module.scss';
import { deriveEditContext, useProductionPlanLineStore } from './useProductionPlanLineStore';
import { applyRatio } from './utils/productionPlanLineDerive';
import {
  buildFixKey,
  canFixUnfixNew,
  type EditInfoEntry,
  type EditInfoMap,
} from './utils/productionPlanLineEditLock';
import { buildFixPayload } from './utils/productionPlanLineFixSave';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

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
  const staticMeasures = useProductionPlanLineStore(s => s.staticMeasures);
  const fetchStaticMeasures = useProductionPlanLineStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useProductionPlanLineStore(s => s.restoreSearchConditions);
  const latestPlanStart = useProductionPlanLineStore(s => s.latestPlanStart);
  const latestPlanSeq = useProductionPlanLineStore(s => s.latestPlanSeq);

  const [openItem, setOpenItem] = useState(false);
  const [openLoad, setOpenLoad] = useState(false);
  const [openFixReason, setOpenFixReason] = useState(false);
  const [openInsert, setOpenInsert] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false);
  // Measure 설정 팝업 OK 결과 — 표시할 measure 코드(null=전체). AS-IS btnMeasure(TitleSet) 표시 토글 등가.
  //   titleSet 영구저장 proc 은 SCP0013 미배선(9버튼에 titleSet 없음)이라 클라이언트 표시 필터로 재현한다.
  const [visibleMeasures, setVisibleMeasures] = useState<string[] | null>(null);

  // ⚠ 임시: MOCK_MAIN_ENABLED(DEV 전용)이면 조회 SP(main/SEARCH)를 호출하지 않고(enabled:false) 목데이터로
  //   그리드를 채운다. SP 성능 개선 완료 후 production-plan-line.mock.ts 와 이 분기(3곳)를 제거한다.
  const { data: rawMainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !MOCK_MAIN_ENABLED && !!filters[SHEETS.MAIN],
  });
  const data = MOCK_MAIN_ENABLED ? (MOCK_MAIN_DATA as unknown as typeof rawMainData) : rawMainData;
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });
  // Fix/Unfix 저장 — 전용 액션(fix/SAVE → 공용 PKG_SCP0024.P_SCP0024_SAVE_PLAN_FIX_DS). 메인 저장 SP
  //   (P_SCP0013_SAVE_LINE_ROW_JSON)는 pivot+FIX 를 "먼저 저장하라"며 거부하므로 fix 는 이 경로로만 보낸다
  //   (AS-IS SaveData_FixInfo → SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET 패리티).
  const { mutate: mutateFix } = useProcMutation<MENU_ID, SHEETS.FIX>({
    menuId: MENU_ID,
    sheetName: SHEETS.FIX,
    tabId,
    onSuccess: () => {
      setFilter(); // AS-IS FindData_Main — 재조회로 O_RC2(fix) 재수집 → 녹색 fix 표시 갱신
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
    },
  });

  // 메인 그리드행 = O_RC1 + O_RC3/O_RC4 ratio 보정 (M4b — LINE_TOTAL_LOAD 행의 W_/M_ 를 working-time
  //   비율로 덮어씀, design 03 §4.2 / AS-IS Set_Ratio). 비-LINE_TOTAL 행은 O_RC1 원본 그대로.
  const rows = useMemo<MainRow[]>(() => {
    const d = data as
      | { o_rc1?: MainRow[]; o_rc3?: Record<string, unknown>[]; o_rc4?: Record<string, unknown>[] }
      | undefined;
    const rc1 = (d?.o_rc1 ?? []) as unknown as Record<string, unknown>[];
    return applyRatio(rc1, d?.o_rc3 ?? [], d?.o_rc4 ?? [], LINE_TOTAL_MEASURE_PREFIX) as unknown as MainRow[];
  }, [data]);

  // fix 확정 셀 집합 (M4a/M2) — O_RC2(dtFix) 8필드 FIX_KEY + 기간키(D_/W_). Grid formatHandler 가 녹색 판정.
  //   O_RC2 는 Daily 행에 YYYYMMDD, 그 외 주행에 BASIS_YYYYMM/ISO_WEEK 반환(PKG body LINE 3294~3339 실측).
  const fixCellSet = useMemo<Set<string>>(() => {
    const set = new Set<string>();
    const list = (data as { o_rc2?: FixRow[] })?.o_rc2 ?? [];
    for (const r of list) {
      const fixKey = buildFixKey(r as unknown as Record<string, unknown>);
      const ym = str(r.BASIS_YYYYMM);
      const wk = str(r.ISO_WEEK);
      if (ym && wk) set.add(`${fixKey}|W_${ym}${wk}`);
      const ymd = str(r.YYYYMMDD);
      if (ymd) set.add(`${fixKey}|D_${ymd}`);
    }
    return set;
  }, [data]);

  // 행별 편집판정 서버원천 (M4c) — editInfo/SEARCH(P_SCP0013_GET_PLAN_EDIT_INFO). 메인 GET O_RC1 은
  //   IS_EDITABLE 을 반환하지 않으므로(ora.py 2026-10-03 PKG body 실측) 전용 SP 를 CP_KEY 로 조인한다.
  //   필터는 조회 확정분(filters[MAIN])에서 파생 — 폼 편집 중 값이 아니라 조회된 데이터와 정합.
  const editInfoFilters = useMemo(() => {
    const f = filters[SHEETS.MAIN] as Record<string, unknown> | undefined;
    if (!f) return undefined;
    return {
      divisionId: str(f.divisionId),
      operationGroup: str(f.operationGroup),
      scmSiteId: str(f.scmSiteId),
      lineId: str(f.lineId),
      itemId: str(f.itemId),
      fromYyyymmdd: str(f.fromYyyymmdd),
      toYyyymmdd: str(f.toYyyymmdd),
      planStartYyyymmdd: str(f.planStartYyyymmdd),
      planType: str(f.planType),
      seq: str(f.seq),
      debugMode: 'F',
    };
  }, [filters]);
  const { data: rawEditInfoData } = useTabProcQuery<MENU_ID, SHEETS.EDIT_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.EDIT_INFO,
    tabId,
    filters: editInfoFilters,
    enabled: !MOCK_MAIN_ENABLED && !!editInfoFilters, // ⚠ 임시: mock 시 SCP0013 proc 전부 미호출
  });
  // ⚠ 임시: mock 시 editInfo 목(전 행 IS_EDITABLE='Y')으로 셀 편집을 열어 Fix/Unfix 테스트 가능하게.
  const editInfoData = MOCK_MAIN_ENABLED
    ? (MOCK_EDIT_INFO_DATA as unknown as typeof rawEditInfoData)
    : rawEditInfoData;
  const editInfoMap = useMemo<EditInfoMap>(() => {
    const m = new Map<string, EditInfoEntry>();
    const list = (editInfoData as { o_rc1?: EditInfoRow[] })?.o_rc1 ?? [];
    for (const r of list) {
      const cpKey = str(r.CP_KEY);
      if (!cpKey) continue;
      m.set(cpKey, {
        isEditable: str(r.IS_EDITABLE),
        newEditMode: str(r.NEW_EDIT_MODE),
        editStartDate: str(r.EDIT_START_DATE),
      });
    }
    return m;
  }, [editInfoData]);
  // Measure 설정 팝업 선택 반영 — 표시 measure 만 그리드 행으로 남긴다(null=전체). AS-IS TitleSet 표시 토글.
  //   measure 는 그리드 "행"이므로(design 03 §1 Measure) 행 필터로 숨김/표시를 재현한다. 편집 대상은
  //   PROD_PLAN_AMEND 뿐이라 다른 measure 를 숨겨도 저장 영향 없음.
  const visibleRows = useMemo<MainRow[]>(() => {
    if (!visibleMeasures) return rows;
    return rows.filter(r => {
      const measure = (r as Record<string, unknown>).MEASURE;
      return typeof measure === 'string' && visibleMeasures.includes(measure);
    });
  }, [rows, visibleMeasures]);
  // 편집판정 컨텍스트 — 조회결과 전체에서 최종 PlanType/FN 존재 파생 (design 01 F2, 표시 필터 무관).
  const editContext = useMemo(() => deriveEditContext(rows), [rows]);
  const visibilityCtx = useMemo(
    () => ({ division: sc.divisionId, operationGroup: sc.operationGroupId }),
    [sc.divisionId, sc.operationGroupId]
  );

  // F6(Condition)로 저장한 조회조건을 마운트 1회 복원 — 저장만 되고 복원이 없던 갭 보완(DMF0082 등 동등).
  //   스토어 가드(conditionsRestored)로 중복/재마운트 복원을 막는다. 복원값은 Form 기본값 effect 가 덮지 않음.
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  useEffect(() => {
    // Measure 메타는 인메모리 persist 스토어가 탭 리마운트 간 유지되므로 staticMeasures 비면 fetch.
    if (staticMeasures.length === 0) void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 고정 컬럼 메타는 division 별로 DIVISION_ID(SCM_MST_SHEET_COLUMNS) 서버 필터되므로, division 이
  //   확정/변경될 때마다 그 값으로 재fetch 한다(division 별 가시성 데이터화 — FE 하드코딩 제거).
  useEffect(() => {
    if (sc.divisionId) void fetchStaticColumns();
  }, [sc.divisionId, fetchStaticColumns]);

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
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.DIVISION, '_Div')) });
      return false;
    }
    if (!sc.operationGroupId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.OPERATION_GROUP, '_Operation Group')) });
      return false;
    }
    // Plan-date 필수 — SP P_PLAN_START_YYYYMMDD 에 단일 실제 날짜가 TO_DATE 되므로 빈값/ALL 이면
    //   ORA-01841. AS-IS UsrCombo 단일 필수(design 02 #9). 미선택 시 조회/Load 차단.
    if (sc.planStartYyyymmdds.length === 0) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.PLAN_DATE, '_Plan-date')) });
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
    if (MOCK_MAIN_ENABLED) return true; // ⚠ 임시: mock 시 SAVE_YN 서버체크 생략(수정가능 플랜으로 간주)
    const divisionId = sc.divisionId;
    const startYyyymmdd = sc.planStartYyyymmdds[0] ?? '';
    const planType = sc.planTypes[0] ?? '';
    if (!divisionId || !startYyyymmdd || !planType) return false; // AS-IS division 공백 → 즉시 false
    try {
      const res = await apiClient.callProc<MENU_ID, SHEETS.SAVE_YN>(MENU_ID, SHEETS.SAVE_YN, 'SEARCH', {
        divisionId,
        // SCM_ADM_PROC_M COL_NM = planStartYyyymmdd(P_START_YYYYMMDD) — ora.py 2026-10-03 실측.
        //   startYyyymmdd 로 보내면 바인딩 실패로 P_START_YYYYMMDD=NULL → 항상 'N'(M5 교정).
        planStartYyyymmdd: startYyyymmdd,
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
    if (MOCK_MAIN_ENABLED) {
      // ⚠ 임시: mock 시 저장 SP 미호출, 성공 토스트로 저장 플로우만 확인.
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      return;
    }
    mutateMain(dirty as unknown as MainRow[]);
  };

  // New — 권한 + 버전선택(canFix) + 서버 SAVE_YN 가드(design 01 R1/R3/R4) 후 InsertPopup 오픈.
  //   AS-IS(design 01 R5)는 전용 삽입팝업(SCM0002_ProductionPlanInsertPopup)에서 Model→Plant Site→Line 을
  //   배정(EE 는 Origin Div 선행)해 신규 라인을 서버 저장(newCheck→savePopup)한 뒤 재조회한다.
  //   M1 해결(2026-10-02): ProductionPlanInsertModal 이 캐스케이드 라인배정 + newCheck/savePopup 저장까지
  //   내부 처리(AS-IS 소스 GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProductionPlanInsertPopup.cs 대조).
  const handleInsert = async () => {
    // 화면 update 권한(=SAVE)으로 게이트 (design 01 R1/§5). AS-IS CanUpdate 단일권한 매핑 — INSERT 버튼권한은
    //   미등록(SCM_ADM_MNU_BTN_MPG_M 에 INSERT 행 없음)이라 hasButton('INSERT') 게이트는 New 상시차단 결함
    //   이었음(gap-audit iter-1 H1). SAVE 권한으로 Fix/Unfix 와 통일.
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    // canFix(planDate 최신 idx0 & planType∉{FN,TE} & 최종 SEQ & 세 값 non-empty, design 01 R2)는 New
    //   버튼 disabled 로 1차 게이트한다(AS-IS Set_FixButtonEnabled: btnNew.Enabled=false — 안내 메시지 없음).
    //   여기 silent return 은 방어적 2차 가드(AS-IS BtnNew_Click 의 무메시지 early return 과 동일 성격).
    if (!canFix) return;
    // 서버 SAVE_YN 재판정 (design 01 R3 #11 — New 가드). AS-IS 는 CanUpdate·planDate 뒤 Get_IsSaveYn 순서.
    if (!(await checkServerSaveYn())) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot modify this plan type.') });
      return;
    }
    setOpenInsert(true);
  };

  // InsertPopup 저장 성공 후처리 (design 01 R5 — AS-IS SaveData_Row 후 FindData_Main) — 메인 재조회.
  //   신규 라인 저장(newCheck+savePopup)은 모달 내부에서 끝나므로 부모는 재조회만 한다(M1 해결).
  const handleInsertSaved = () => {
    setFilter();
    void fetchStaticColumns();
  };

  // Fix/Unfix 실제 저장 (AS-IS SaveData_FixInfo cs:2829~3270 패리티) — 선택 셀을 일(D_) 단위로 전개해
  //   전용 fix 액션(fix/SAVE → P_SCP0024_SAVE_PLAN_FIX_DS)으로 전송. buildFixPayload 가 ACTIVE_FLAG
  //   (Fix='M'/Unfix='D')·YYYYMMDD(일)·QTY·FIX_REASON·업무키를 조립하고 주(W_) 선택은 그 주의 일로 확장한다.
  const doFixSave = (mode: FixMode, reason?: string) => {
    const g = gridRef.current;
    g?.finishEditing();
    const payload = buildFixPayload(g, mode, reason ?? '', sc.bucket);
    if (payload.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    if (MOCK_MAIN_ENABLED) {
      // ⚠ 임시: mock 시 저장 SP 미호출, 성공 토스트로 Fix/Unfix 플로우만 확인.
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      return;
    }
    mutateFix(payload as unknown as MainRow[]);
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
    // 주의: AS-IS 는 "편집 후 미저장(red) 셀"만 Fix 차단한다(cs:2980/3064/3089, 셀 단위). TO-BE 는 편집가능
    //   셀을 "선택"하는 순간 Wijmo 가 편집모드로 들어가 행을 dirty 로 마킹하므로, 행 단위 dirty 가드는
    //   선택과 충돌(선택하면 무조건 차단)해 fix 자체가 불가능해진다 → 행 단위 가드는 두지 않는다. 음수·소수
    //   방지는 입력단(numberRules)+저장측(useProductionPlanLineValidation)이 담당한다.
    // 선택 셀 가드 (AS-IS selCells<1 → MSG00134) — 일(D_) 전개 결과 0건이면 중단(Daily 버킷에서 D_ 셀 선택 필요).
    if (buildFixPayload(gridRef.current, mode, '', sc.bucket).length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    if (mode === 'U') {
      // Unfix confirm (design 01 R6 — MSG00016). setAlert(confirm) 은 확인 시 true resolve.
      const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, '_Do you want to delete it?') });
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

  // Measure(TitleSet) — SCM0002_TitleSetForm_Popup(measure 표시 커스터마이즈, design 03 §6). forecast-price
  //   (DMF0082)와 동일하게 공용 MeasureSelectModal 사용. OK 결과(표시 measure)는 visibleMeasures 로 그리드
  //   행을 거른다(titleSet 영구저장 proc 은 SCP0013 미배선이라 클라이언트 표시 토글로 재현).
  const handleMeasure = () => setOpenMeasure(true);

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(search 버튼 권한과 무관하게 조회 동작 보장 — design 03 §6).
    search: handleSearch,
    // 툴바 공통 Insert/Delete = 미사용이라 숨김(false → SubTitle 미렌더). AS-IS override InsertButton/DeleteButton
    //   본문이 주석뿐(//InsertRow()=빈 메서드 / //siMain.Delete(), cs:637~645)이라 이 화면엔 실동작이 없다.
    //   노출하면 "눌러도 무반응"인 혼동만 주므로 사용자 지시(2026-10-07)로 숨긴다. false 로 두면 공용 SubTitle
    //   기본 핸들러(addRow/removeRow) 부활도 함께 막힌다. 신규 라인 삽입은 화면 고유 New 버튼(InsertPopup)만 담당.
    insert: false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
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
        <ProductionPlanLineForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={visibleRows.length}
        excelFileName='ProductionPlanLine'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // 라벨 실측 LBL 코드(lbl-dict): Fix=LBL00771 / Unfix=LBL00772 / New=LBL01028 / Load=LBL00773 / Measure=LBL00310.
          //   순서 = AS-IS Designer 상단행 New(X=1119) → Fix(1189) → Unfix(1239) (사용자 지시 2026-10-02).
          // New — AS-IS 버튼 텍스트 'New'(LBL01028 의 KO='신규' 라 t() 쓰면 한글 표기 → AS-IS 처럼 영문 고정).
          //   Fix/Unfix 와 동일하게 canFix 로 비활성(AS-IS Set_FixButtonEnabled 가 btnNew 도 함께
          //   Enabled=false — 조건 미충족 시 안내 메시지 없이 비활성).
          { label: 'New', action: () => void handleInsert(), disabled: !canFix },
          { label: t(LBL.FIX, '_Fix'), action: () => void runFix('F'), disabled: !canFix },
          { label: t(LBL.UNFIX, '_Unfix'), action: () => void runFix('U'), disabled: !canFix },
          // Load — AS-IS 권한 division 0행 시 btnLoad.Enabled=false(cs:269-273 R8). 권한 division 콤보가 비어
          //   divisionId 가 없으면(= 권한 없음) 비활성. 선택된 상태의 추가 가드는 handleLoad(필수조건/기간)에서.
          { label: t(LBL.LOAD, '_Load%'), action: handleLoad, disabled: !sc.divisionId },
          // Measure 설정 — forecast-price 와 동일 아이콘(IcMeasureSelect) + 팝업(MeasureSelectModal).
          //   buttonLabel='' 로 icon-only(텍스트 없이 아이콘만, 자매 forecast-price 표준, 사용자 지시 2026-10-02).
          //   label/title 은 Tooltip·접근성용으로 유지.
          {
            label: t(LBL.MEASURE, '_Measure'),
            title: t(LBL.MEASURE, '_Measure'),
            action: handleMeasure,
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanLineGrid
          rows={visibleRows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          // 전체보기 고정 — 조회가 항상 일자(D_)까지 싣으므로 헤더 더블클릭 드릴다운 게이트도 상시 허용(SCP0011 동일).
          chkAll={true}
          editContext={editContext}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          editInfoMap={editInfoMap}
          fixCellSet={fixCellSet}
          onFocus={() => undefined}
        />
      </div>

      {/* Material + Model/Nickname 공용 검색 — 메1(MaterialByDivisionModal COM0013). 두 조회조건이 같은
          팝업을 열고, 행 선택 1회가 Material(itemId←ITEM_ID)·Model/Nickname(nickName←NICK_NAME)을 함께
          채운다(사용자 지시 2026-10-12). setSelectedValue 시그니처 = (ITEM_ID[csv], ITEM_NAME, ITEM_CLASS_NAME,
          NICK_NAME) — AS-IS SCM0002 SetItem 과 동일 순서. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(items, _itemName, _className, nickName) =>
          setSearchCondition({ itemId: items, nickName: nickName ?? '' })
        }
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />

      {/* Load 팝업 — 부모 조회조건 주입, 읽기전용 선택 로드 (design 01 §P). */}
      <ProductionPlanLineLoadModal open={openLoad} modalClose={() => setOpenLoad(false)} />

      {/* Fix 사유 팝업 — AS-IS RejectReasonPopup 등가(design 01 R6). OK 시에만 Fix 저장. */}
      <ProductionPlanFixReasonModal
        open={openFixReason}
        onClose={() => setOpenFixReason(false)}
        onConfirm={handleFixReasonConfirm}
      />

      {/* New 삽입팝업 — AS-IS SCM0002_ProductionPlanInsertPopup 라인배정(Model→Plant Site→Line) + newCheck/
          savePopup 저장(design 01 R5, M1). 저장 성공 시 onSaved 로 부모 재조회. */}
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
        onSaved={handleInsertSaved}
      />

      {/* Measure 설정 팝업 — AS-IS btnMeasure(SCM0002_TitleSetForm_Popup) 등가. forecast-price(DMF0082)와
          동일 공용 컴포넌트. OK 결과(표시 measure 코드, 전체면 null)를 visibleMeasures 로 그리드 행 필터. */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => setVisibleMeasures(codes)}
      />
    </>
  );
};
