import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ColumnSettingModal,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { ComboResponse, HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ConfirmDetailModal } from './components/modals/ConfirmDetailModal';
import { RequestorModal } from './components/modals/RequestorModal';
import { ShipmentRequestModal } from './components/modals/ShipmentRequestModal';
import { ShipmentPlanDetailBar } from './components/ShipmentPlanDetailBar';
import { ShipmentPlanDetailGrid } from './components/ShipmentPlanDetailGrid';
import { ShipmentPlanForm } from './components/ShipmentPlanForm';
import { ShipmentPlanMainGrid } from './components/ShipmentPlanMainGrid';
import {
  ADMIN_SHEET_NAME,
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  SHEETS,
  TITLESET_MEASURE_TYPE,
  TOT_PSI_SEQ_LIMIT,
} from './shipment-plan.constants';
import type { MainRow, PlanDetailRow } from './shipment-plan.types';
import styles from './ShipmentPlan.module.scss';
import { useShipmentPlanStore } from './useShipmentPlanStore';
import {
  buildCalendarGroups,
  itemGroupKeyOf,
  simulate,
  type CalcRow,
} from './utils/shipment-plan.calc';
import {
  BOH_DRILLDOWN,
  measureDrilldownOf,
} from './utils/shipment-plan.detailSheets';
import { markBtnNewRow } from './utils/shipment-plan.editLock';
import { collectMainSaveRows } from './utils/shipment-plan.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0060_ShipmentPlan (Shipment Plan) — 신규 전환(2026-09-25).
//   설계: .atlas/gscm-design/SSP0060/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find/Save/Insert/Edit=실동작, Delete=NO-OP `() => undefined` (00 §4d — 노출 유지, false 숨김 금지).
//   주의: PKG_SSP0002(GetSSPUserCheck/GetNERPCode)·HoldStock 저장 SP·ERP Drafting IF 체인은
//   TO-BE 미배포 — 04_react-gap.md "확인 필요/SP 후속" 참조.
export const ShipmentPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);

  // ── refs (Main + Detail 7-sheet) ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const planDetailGridRef = useRef<FlexGridType>();
  const planDetailGridFilterRef = useRef<FlexGridFilter>();
  const planDetailEditTrackerRef = useRef<EditTracker>();
  const stockDetailGridRef = useRef<FlexGridType>();
  const stockDetailGridFilterRef = useRef<FlexGridFilter>();
  const owmsDetailGridRef = useRef<FlexGridType>();
  const owmsDetailGridFilterRef = useRef<FlexGridFilter>();
  const holdStockGridRef = useRef<FlexGridType>();
  const holdStockGridFilterRef = useRef<FlexGridFilter>();
  const holdStockEditTrackerRef = useRef<EditTracker>();
  const mesStockGridRef = useRef<FlexGridType>();
  const mesStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockDetailGridRef = useRef<FlexGridType>();
  const mesStockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanStore(s => s.searchCondition);
  const set = useShipmentPlanStore(s => s.setSearchCondition);
  const filters = useShipmentPlanStore(s => s.filters);
  const setMainFilters = useShipmentPlanStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanStore(s => s.realFlag);
  const activeGrid = useShipmentPlanStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanStore(s => s.fetchStaticColumns);
  const initialized = useShipmentPlanStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 가능 = 권한(canEdit = hasButton('EDIT'), 마운트 1회) · 최신 Plan(realFlag).
  //   AS-IS EditButton/SwitchLock '수정 모드' 토글은 이식하지 않는다(convert-core §2.4 · 전 화면 공통
  //   결정 2026-09-23/25 · 자매 SSP0025). 편집이 기본 ON 이고 권한은 진입 시 1회 판정 — 조회모드 복귀 없음.
  //   realFlag(최신 Plan 아님 → 편집 차단)는 AS-IS 데이터 조건이라 유지(토글 어포던스와 별개).
  //   두 그리드 편집 가능 여부는 동일(활성 그리드로 제한하지 않음) — activeGrid 는 저장 라우팅·Measure 에만
  //   쓴다. AS-IS InsertRow 가 fps 를 안 보는 것(J6)·셀 단위 화이트리스트(editLock)가 실제 편집 범위를 판정.
  const canEdit = hasButton('EDIT');
  const mainEditable = canEdit && realFlag;
  const detailEditable = canEdit && realFlag;

  // ── 모달 open state (페이지 소유) ──
  const [openItemMain, setOpenItemMain] = useState(false); // 1차 Model(btnItemId)
  const [openItemDetailBar, setOpenItemDetailBar] = useState(false); // 2차 Model(btnItemID2)
  const [openRequestor, setOpenRequestor] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false); // TitleSetForm(Measure — R2/R3)
  const [openRequest, setOpenRequest] = useState(false); // 저장 후 Request 팝업(R8)
  const [confirmDetailNo, setConfirmDetailNo] = useState(''); // CHANGE_REQ_NO 클릭
  const [cellPopupRow, setCellPopupRow] = useState<WijmoRowItem | null>(null);
  const [cellPopupKind, setCellPopupKind] = useState<'item' | 'project' | null>(null);

  // ── 조회 (React Query — SSOT) ──
  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
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
  const { data: planDetailData } = useTabProcQuery<MENU_ID, SHEETS.PLAN_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_DETAIL,
    tabId,
    filters: filters[SHEETS.PLAN_DETAIL],
    enabled: !!filters[SHEETS.PLAN_DETAIL],
  });
  const { data: stockDetailData } = useTabProcQuery<MENU_ID, SHEETS.STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.STOCK_DETAIL],
    enabled: !!filters[SHEETS.STOCK_DETAIL],
  });
  const { data: owmsDetailData } = useTabProcQuery<MENU_ID, SHEETS.OWMS_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.OWMS_DETAIL,
    tabId,
    filters: filters[SHEETS.OWMS_DETAIL],
    enabled: !!filters[SHEETS.OWMS_DETAIL],
  });
  const { data: holdStockData } = useTabProcQuery<MENU_ID, SHEETS.HOLD_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.HOLD_STOCK,
    tabId,
    filters: filters[SHEETS.HOLD_STOCK],
    enabled: !!filters[SHEETS.HOLD_STOCK],
  });
  const { data: mesStockData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK,
    tabId,
    filters: filters[SHEETS.MES_STOCK],
    enabled: !!filters[SHEETS.MES_STOCK],
  });
  const { data: mesStockDetailData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.MES_STOCK_DETAIL],
    enabled: !!filters[SHEETS.MES_STOCK_DETAIL],
  });
  const { data: shipmentResultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });

  // chkTotPSI 행 필터 (03 §2.3 — 미체크 SEQ<12 / 체크 SEQ<21. 서버 전량 반환, 클라 필터)
  const mainRows = useMemo<MainRow[]>(() => {
    const limit = sc.chkTotPsi ? TOT_PSI_SEQ_LIMIT.ON : TOT_PSI_SEQ_LIMIT.OFF;
    return (mainData?.o_rc1 ?? []).filter(r => Number(r.SEQ ?? 0) < limit);
  }, [mainData, sc.chkTotPsi]);
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.PLAN_DETAIL]: (planDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.STOCK_DETAIL]: (stockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.OWMS_DETAIL]: (owmsDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.HOLD_STOCK]: (holdStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK]: (mesStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK_DETAIL]: (mesStockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SHIPMENT_RESULT]: (shipmentResultData?.o_rc1 ?? []) as WijmoRowItem[],
    }),
    [
      planDetailData,
      stockDetailData,
      owmsDetailData,
      holdStockData,
      mesStockData,
      mesStockDetailData,
      shipmentResultData,
    ]
  );

  // ── 저장 ──
  // Main 저장 — 편집 D_셀 flat payload 수동 조립(apiClient.post call-proc, np §3.2). in-flight 가드 필수.
  const savingRef = useRef(false);
  const { mutate: mutateConfirm } = useProcMutation<MENU_ID, SHEETS.PLAN_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_DETAIL,
    tabId,
    onSuccess: () => {
      planDetailEditTrackerRef.current?.clearChanges();
      // 편집 기본 ON(convert-core §2.4) — 저장 후 조회모드 복귀 없음.
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.PLAN_DETAIL, 'N');
    },
  });

  // ── mount — keep-alive 잔여 filters 무효화 + Main 컬럼 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns([SHEETS.MAIN, SHEETS.PLAN_DETAIL]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Division/Company 변경 = 그리드·편집 상태 초기화 의무 (np §5-5 / hook #5, gap-audit I9).
  //    filters 초기화는 store setDivision/setCompany 가 수행 — 여기서는 EditTracker 잔여 기록 정리.
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();
    holdStockEditTrackerRef.current?.clearChanges();
     
  }, [sc.divisionId, sc.companyId]);

  // ── Find (F5 — FindData_Main, 01 R10) ──
  const runMainSearch = () => {
    // validations #58(MSG01315) — 최신 Plan 을 보는 중일 때 서버 최신 Plan 과 불일치 안내(차단 아님).
    //   AS-IS Plan_Current_Check 는 재조회 대조 — TO-BE 는 콤보 캐시(staleTime 0)와 대조가 어렵고
    //   임의 재조회 배선은 과잉이라 보고만 유지(04 확인필요 — 브라우저 축 검증 필요).
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
  };

  const handleSearch = () => {
    // 필수 4종 (02 §4.1 — Division*/Company*/Period*/Plan Date*)
    if (!sc.divisionId || !sc.companyId || !sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // UI 공통(통합테스트) UC-02 — 미저장 변경이 있으면 재조회 전 확인(MSG00703).
    //   AS-IS 는 편집 중 재조회 시 confirm 후 진행 — EditTracker.hasChanges() 로 dirty 판정.
    const hasUnsaved =
      mainEditTrackerRef.current?.hasChanges() === true ||
      planDetailEditTrackerRef.current?.hasChanges() === true ||
      holdStockEditTrackerRef.current?.hasChanges() === true;
    if (hasUnsaved) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_RESEARCH_UNSAVED, {
          defaultValue: '_There are unsaved changes. Do you want to search again?',
        }),
        onConfirm: runMainSearch,
      });
      return;
    }
    runMainSearch();
  };

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회, hook #81 lazy) ──
  const handleDetailSearch = () => {
    setDetailFilter(activeDetailSheet, 'N');
    void fetchStaticColumns([activeDetailSheet]);
  };

  // ── Main 드릴다운 (03 §3-D — BOH_TYPE / MEASURE 분기) ──
  const handleMainDrilldown = (row: MainRow, binding: string) => {
    const overrides = { itemId: str(row.ITEM_ID), fromSite: str(row.FROM_SITE) };
    // 편집 기본 ON(convert-core §2.4) — 드릴다운 시 별도 편집모드 해제 없음(AS-IS bEdit_Mode=false 미이식).
    if (binding === 'BOH_QTY' && str(row.BOH_TYPE) === 'MES') {
      // MES 는 MES Stock Detail + MES Stock 2-sheet 연속 조회, 활성 탭은 MES Stock
      //   (AS-IS L2356~2366 — Detail 먼저 조회 후 Stock 조회·활성화, gap-audit I10)
      setDetailFilter(SHEETS.MES_STOCK_DETAIL, 'Y', overrides);
      setActiveDetailSheet(SHEETS.MES_STOCK);
      setDetailFilter(SHEETS.MES_STOCK, 'Y', overrides);
      void fetchStaticColumns([SHEETS.MES_STOCK_DETAIL, SHEETS.MES_STOCK]);
      return;
    }
    const sheet =
      binding === 'BOH_QTY'
        ? BOH_DRILLDOWN[str(row.BOH_TYPE)]
        : measureDrilldownOf(str(row.MEASURE), str(row.TO_SITE));
    if (!sheet) return;
    setActiveDetailSheet(sheet);
    setDetailFilter(sheet, 'Y', overrides);
    void fetchStaticColumns([sheet]);
  };

  // Edit 버튼/토글 미이식 (convert-core §2.4 — 전 화면 공통 결정 2026-09-23/25, 자매 SSP0025).
  //   AS-IS EditButton(F2)의 4가드 중 데이터 조건(가드② 최신 Plan=realFlag)은 mainEditable/detailEditable
  //   계산에 흡수했고, 토글·"다른 그리드 편집 중"(가드③) 상태는 개념 자체가 사라졌다(활성 그리드가 곧 편집 대상).
  //   가드①(GetSSPUserCheck/PKG_SSP0002)은 미배포로 fail-open — convert-sp 후속(A01, 04_react-gap 확인필요).

  // ── Save (F7 — fps 분기, 01 R10 / 03 §3-H) ──
  const handleSave = () => {
    if (activeGrid === 'main') {
      // 편집 사전조건 (AS-IS SaveData_Main L2935 `IsLock(shtMain)==false` 가드 — 편집 불가면 조용히 무시,
      //   gap-audit I2). 편집 기본 ON 이므로 canEdit·최신Plan·활성그리드=main 을 mainEditable 로 판정.
      if (!mainEditable) return;
      const rows = (mainGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dayCols = calendarRows
        .map(r => str(r.COLUMN_NAME))
        .filter(b => b.startsWith('D_'))
        .sort();
      const tracker = mainEditTrackerRef.current;
      const { payload, negatives } = collectMainSaveRows(
        rows,
        dayCols,
        row => tracker?.getOriginalValues().get(row as WijmoRowItem),
        {
          divisionId: sc.divisionId,
          companyId: sc.companyId,
          planStartYyyymmdd: sc.planDate,
          userId: session.userId ?? '',
          userDeptId: '', // AS-IS USER_DEPT_ID — 세션에 부서 없음(04 확인필요)
        }
      );
      // 음수 차단 (AS-IS MSG00084 — 저장 abort, SP 미호출)
      if (negatives.length > 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NEGATIVE_QTY, '__Quantity must be 0 or greater.'),
        });
        return;
      }
      if (payload.length === 0) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      if (savingRef.current) return; // in-flight 가드 (np §3.2)
      savingRef.current = true;
      void apiClient
        .post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, payload)
        .then(res => {
          // false-success 판별 의무 (np §5-10 — 인터셉터가 500/403 도 resolve)
          if (res.status >= 400 || Number(res.data?.code)) {
            void setAlert({
              type: 'alert',
              content: t(MSG.SAVE_FAILED, '__Save failed.'),
            });
            return;
          }
          mainEditTrackerRef.current?.clearChanges();
          // 편집 기본 ON(convert-core §2.4) — 저장 후 조회모드 복귀 없음.
          setToast({
            type: 'success',
            message: t(MSG.SAVED, '__Saved successfully.'),
          });
          // R8: 저장 성공 시 Request 팝업 무조건 오픈. 재조회는 팝업 닫힘 시(취소 포함) 무조건 수행.
          setOpenRequest(true);
        })
        .finally(() => {
          savingRef.current = false;
        });
      return;
    }

    // Detail 저장 — 활성 sheet 분기
    if (activeDetailSheet === SHEETS.PLAN_DETAIL) {
      const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
      if (dirty.length === 0) {
        // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준, gap-audit J4.
        //   Main 경로와 동일 처리 — memory datagrid-nochange-save-toast-standard)
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      // 행별 필수 (validations #3/#34/#35): TRANSPORT_MODE 공백 / CHANGE_REASON_CODE 미선택 차단
      for (const row of dirty) {
        if (str(row.TRANSPORT_MODE).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, {
              defaultValue: '_{0} value is required.',
              0: 'Trans Mode',
            }),
          });
          return;
        }
        const reason = str(row.CHANGE_REASON_CODE).trim();
        if (reason === '' || reason === '-') {
          void setAlert({
            type: 'alert',
            content: t(MSG.ROW_REASON_REQUIRED, {
              defaultValue: '_There is a shipment change. Please enter Change_Reason.',
            }),
          });
          return;
        }
      }
      // 확인창 (validations #27 MSG00324 → TO-BE MSG01201)
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_SAVE, {
          defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
        }),
        onConfirm: () => {
          // payload = 그리드 행 그대로 — 컬럼↔SAVE 38 IN 매핑은 PROC_M(convert-sp 소관, 03 §4.3)
          mutateConfirm(dirty as unknown as PlanDetailRow[]);
        },
      });
      return;
    }
    if (activeDetailSheet === SHEETS.HOLD_STOCK) {
      // HoldStock 저장 SP(SSP0060_SAVE_HOLD_STOCK_DATA) — TO-BE/AS-IS DB 공히 미존재(실측).
      //   convert-sp 후속 대상 — 저장 경로 미배선을 명시 안내(04_react-gap.md 확인 필요).
      void setAlert({
        type: 'alert',
        content: t(MSG.SAVE_FAILED, '__Save procedure is not deployed yet.'),
      });
      return;
    }
  };

  // ── Insert (F8 — 03 §3-E 2원천. 활성 sheet 분기, 가드 재현 — 공통 addRow 는 안 막음) ──
  //   주의: AS-IS InsertRow(L2539/L2558)는 fps(활성 그리드)를 참조하지 않고 IsLock 만 가드한다 —
  //   activeGrid 게이트를 걸면 Detail 편집모드 중 Main 셀 클릭 직후 F8 이 무동작이 된다(gap-audit J6).
  const handleInsert = () => {
    // 편집 사전조건 (AS-IS InsertRow 두 분기 공통 `siDetail.IsLock(...)==false` 가드 L2539/L2558 —
    //   편집 불가면 조용히 무시. gap-audit I3). 편집 기본 ON 이라 canEdit·최신Plan 만 판정(fps 미참조 — J6).
    if (!detailEditable) return;
    if (activeDetailSheet === SHEETS.HOLD_STOCK) {
      // 값 원본 = siMain 활성행 (Detail 자신 아님 — 03 §3-E). 활성행 없으면 조용히 중단.
      const g = mainGridRef.current;
      const mainRow = g ? (GridUtils.getRow(g, g.selection?.row ?? -1) as MainRow | undefined) : undefined;
      if (!mainRow) return;
      const target = holdStockGridRef.current;
      if (!target) return;
      GridAction.addRow(
        target,
        {
          CRUD_TYPE: 'I',
          DIVISION_ID: str(mainRow.DIVISION_ID),
          FROM_SITE: str(mainRow.FROM_SITE),
          FROM_SITE_NM: str(mainRow.FROM_SITE_DESCRIPTION),
          ITEM_ID: str(mainRow.ITEM_ID),
          NICK_NAME: str(mainRow.NICK_NAME),
          HOLD_YYYYMMDD: sc.planDate, // cboPlanDate.Text (03 §3-E)
          RELEASE_YYYYMMDD: '',
          HOLD_QTY: 0,
          REMARKS: '',
        } as WijmoRowItem,
        'above',
        true
      );
      return;
    }
    if (activeDetailSheet === SHEETS.PLAN_DETAIL) {
      const g = planDetailGridRef.current;
      if (!g) return;
      const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
        | Record<string, unknown>
        | undefined;
      if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4 — 미조회 상태 삽입 결함)
      // 원본 행 STATUS 게이트 — 공백은 'C' 간주 허용 (AS-IS L2568~2571, gap-audit I6).
      const status = str(source.SHIPMENT_STATUS).trim() || 'C';
      if (status !== 'C') return; // 'C' 아님 — 에러 없이 조용히 중단 (03 §3-E/§5-5)
      // 복사 필드는 AS-IS defaultData 명시 목록만 (L2644~2692 — 전 필드 스프레드 복사 금지.
      //   ERP_SO_NO/SHIPMENT_STATUS 등은 신규행에 물려주지 않는다. gap-audit I6)
      const copied: Record<string, unknown> = {};
      PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
        copied[col] = source[col];
      });
      copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제(원본 값 무시)
      copied.ERP_STATUS = ''; // 항상 공백 강제
      GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
      return;
    }
    // 읽기전용 5-sheet — 신규행 없음 (03 §1.5~1.9)
  };

  // ── 2차 NEW 버튼 (AS-IS BtnNew_Click L7337~7441 — InsertRow 와 별개 본문, gap-audit J1):
  //   가드: PlanDetail 탭(#43 ActiveSheetIndex==0) + Detail 편집모드(IsLock) + RowCount>0.
  //   InsertRow 와 달리 SHIPMENT_STATUS 게이트가 없고, 복사는 DIVISION_ID·MKT_OWNER 2필드뿐
  //   (나머지 defaultData 는 전부 주석 dead code — L7384~7411). 원본행은 활성행의 "다음" 행
  //   (마지막 행이면 자기 자신 — AS-IS activeRow 클램프 quirk L7347~7352 재현).
  //   편집 스팬은 AS-IS LockRange 등가(잠금 DIVISION_ID..PRODUCT_LEVEL1 + MKT_OWNER..
  //   ORIGIN_TO_DIVISION_ID) — markBtnNewRow 마킹으로 editLock 이 판정한다. 신규행
  //   FROM/TO_SITE·DIVISION_ID 셀콤보와 route 재조회 경로(L7421~7434)는 설계 01~03 에 BtnNew
  //   상세 부재 + 셀콤보 메타 갭(03 §0)으로 보류 — 04_react-gap.md 확인필요(설계 축).
  const handleNew = () => {
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return;
    if (!detailEditable) return; // AS-IS IsLock 가드 (L7342) — 편집 기본 ON, canEdit·최신Plan 판정
    const g = planDetailGridRef.current;
    if (!g) return;
    if (g.rows.length === 0) return; // AS-IS RowCount>0 가드 (L7344)
    const active = g.selection?.row ?? -1;
    if (active < 0) return;
    const sourceIndex = active + 1 >= g.rows.length ? active : active + 1;
    const source = GridUtils.getRow(g, sourceIndex) as Record<string, unknown> | undefined;
    if (!source) return;
    const added = GridAction.addRow(
      g,
      {
        CRUD_TYPE: 'I',
        DIVISION_ID: str(source.DIVISION_ID),
        MKT_OWNER: str(source.MKT_OWNER),
      } as WijmoRowItem,
      'above',
      true
    ) as WijmoRowItem | undefined;
    if (added) markBtnNewRow(added); // addRow 는 전달 객체를 spread 복사 — 반환 행에 마킹
  };

  // ── Measure (R2/R3): spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return; // R2 — 경고 없이 조용히 return (AS-IS L2148)
    setOpenMeasure(true);
  };

  // ── Simulation (R4 — AS-IS Simulation() L7463~7886, iter-2 라인 정독으로 03 §6-9 해소 후 구현):
  //   Real 아님 경고(경고 후 계속 진행 — validations #59 return 없음) → Container_Size 콤보 로드 →
  //   편집(dirty) 그룹의 SHIP_PLAN 행 기준 WH/BALANCE/CONTAINER 재계산 + 전 행 주/월 SUM 캐스케이드.
  //   Container 단위수량은 realFlag 일 때만 실값, 아니면 0 (AS-IS L7507~7521). ──
  const simulatingRef = useRef(false);
  const handleSimulation = () => {
    if (!realFlag) {
      setToast({
        type: 'error',
        message: t(MSG.SIMULATION_NOT_REAL, {
          defaultValue: '_Cutoff Container Qty does not apply simulation.',
        }),
      });
      // AS-IS: 경고 표시만 하고 계속 진행 (validations #59 — return 없음)
    }
    if (simulatingRef.current) return;
    simulatingRef.current = true;
    // Container_Size 콤보 — AS-IS Data_SCP.Common(Container_Size) 무파라미터 전량 조회(L7488).
    //   TO-BE SQL_ID 'Container_Size_SCP' 등록 여부는 ora.py 실측 차단으로 미확정(04 확인필요) —
    //   미등록/실패 시 빈 목록 = 단위수량 0 = CONTAINER 0 (AS-IS qty 미매치 경로와 동일 결과).
    void apiClient
      .getCombo({ comboId: COMBO.CONTAINER_SIZE, mnuId: MENU_ID })
      .catch(() => [] as ComboResponse[])
      .then(containerRows => {
        const g = mainGridRef.current;
        if (!g) return;
        const rows = (g.collectionView?.sourceCollection ?? []) as unknown as CalcRow[];
        const dirtyKeys = new Set(
          rows
            .filter(r => str(r.CRUD_TYPE) === 'M')
            .map(r => itemGroupKeyOf(r))
        );
        const containerQtyOf = (row: CalcRow): number => {
          if (!realFlag) return 0;
          const match = containerRows.find(
            c =>
              str(c.DIVISION_ID) === str(row.DIVISION_ID) &&
              str(c.FROM_SITE) === str(row.FROM_SITE) &&
              str(c.ITEM_ID) === str(row.ITEM_ID)
          );
          const qty = Number(match?.CONTAINER_QTY ?? 0);
          return Number.isFinite(qty) ? qty : 0;
        };
        const changed = simulate(
          rows,
          buildCalendarGroups(calendarRows),
          containerQtyOf,
          dirtyKeys
        );
        if (changed > 0) g.collectionView?.refresh();
      })
      .finally(() => {
        simulatingRef.current = false;
      });
  };

  // ── 그리드 셀 팝업 (03 §3-D — 신규행 한정 + 필수값 MSG00013 가드) ──
  const openCellPopup = (kind: 'item' | 'project', row: WijmoRowItem) => {
    const division = str(row.DIVISION_ID);
    const fromSite = str(row.FROM_SITE);
    const toSite = str(row.TO_SITE);
    const required =
      kind === 'item'
        ? [division, fromSite, toSite]
        : [division, fromSite, toSite, str(row.ITEM_ID)];
    if (required.some(v => v.trim() === '')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    setCellPopupRow(row);
    setCellPopupKind(kind);
  };

  // ── hotkeyConfig (00 §4d/01 R10 확정값 — 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS L2708-2710 완전 빈 몸체) — 노출 유지 + 명시적 무동작.
    //   키 생략 금지(공용 removeRow 부활) / false 금지(AS-IS 는 버튼이 보였음).
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Edit 버튼 미노출 (convert-core §2.4 — AS-IS EditButton 토글 미이식). hasButton('EDIT') 은
    //   버튼 노출이 아니라 canEdit(편집 권한) 판정에만 쓴다(자매 SSP0025 선례). EDIT 버튼코드 메타는 유지.
    // Measure (R2 — 아이콘 순서: GridColumnSet 없음 → Measure, hook #120)
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Simulation (R4/R7 — AS-IS 노출게이트 dtPgmAuthId 재현 수단 미확정(01 §5-3) → 항상 노출, 04 확인필요)
    {
      label: t(LBL.SIMULATION, '_Simulation'),
      title: t(LBL.SIMULATION, '_Simulation'),
      action: handleSimulation,
    },
  ];

  const cellPopupDivision = str(cellPopupRow?.DIVISION_ID);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanForm
          tabId={tabId}
          onSearch={handleSearch}
          onItemSearch={() => setOpenItemMain(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (01 §1) */}
      <div className={styles.gridArea}>
        {/* R5 sticky — Main 클릭 시 activeGrid 복귀 핸들러는 배선하지 않는다(AS-IS parity) */}
        <div className={styles.mainGrid}>
          <ShipmentPlanMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[SHEETS.MAIN]}
            bucketType={sc.bucketType}
            chkSum={sc.chkSum}
            editable={mainEditable}
            curPlanDate={sc.planDate}
            onDrilldown={handleMainDrilldown}
          />
        </div>

        <div className={styles.detailArea}>
          <ShipmentPlanDetailBar
            onDetailSearch={handleDetailSearch}
            onNew={handleNew}
            onModelSearch={() => setOpenItemDetailBar(true)}
            onRequestorSearch={() => setOpenRequestor(true)}
          />
          <ShipmentPlanDetailGrid
            rowsBySheet={rowsBySheet}
            gridRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridRef,
              [SHEETS.HOLD_STOCK]: holdStockGridRef,
              [SHEETS.MES_STOCK]: mesStockGridRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
            }}
            gridFilterRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridFilterRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridFilterRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridFilterRef,
              [SHEETS.HOLD_STOCK]: holdStockGridFilterRef,
              [SHEETS.MES_STOCK]: mesStockGridFilterRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridFilterRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridFilterRef,
            }}
            editTrackerRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
              [SHEETS.HOLD_STOCK]: holdStockEditTrackerRef,
            }}
            staticColumns={staticColumns}
            editable={detailEditable}
            onItemCellSearch={row => openCellPopup('item', row)}
            onProjectCellSearch={row => openCellPopup('project', row)}
            onConfirmDetail={setConfirmDetailNo}
          />
        </div>
      </div>

      {/* 1차 Model 팝업 (btnItemId — SCM0002_ItembyDivisionPopup 재사용) */}
      <ItemByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        setSelectedValue={itemId => set({ itemId: str(itemId) })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* 2차 Model 팝업 (btnItemID2 — 동일 컴포넌트 재사용, 대입 대상만 상이 — 02 §4.6) */}
      <ItemByDivisionModal
        open={openItemDetailBar}
        modalClose={() => setOpenItemDetailBar(false)}
        setSelectedValue={itemId => set({ model: str(itemId) })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.model }}
        callFromCell={false}
      />

      {/* Detail 그리드 ITEM_ID 셀 팝업 (신규행 한정 — 03 §3-D. 선택 시 ITEM_ID+NICK_NAME 반영) */}
      <ItemByDivisionModal
        open={cellPopupKind === 'item'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(itemId, _itemName, _itemClassName, _itemType, nickName) => {
          if (cellPopupRow) {
            cellPopupRow.ITEM_ID = str(itemId);
            cellPopupRow.NICK_NAME = str(nickName);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{ divisionId: cellPopupDivision, itemId: str(cellPopupRow?.ITEM_ID) }}
        callFromCell={true}
      />

      {/* Detail 그리드 PROJECT_CODE 셀 팝업 (신규행 한정 — 03 §3-D) */}
      <ProjectByDivisionModal
        open={cellPopupKind === 'project'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(projects, projectsNames) => {
          if (cellPopupRow) {
            cellPopupRow.PROJECT_CODE = str(projects);
            cellPopupRow.PROJECT_NAME = str(projectsNames);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{
          divisionId: cellPopupDivision,
          projectCode: str(cellPopupRow?.PROJECT_CODE),
        }}
        callFromCell={true}
      />

      {/* Requestor 팝업 (UserInfoPopup — SSP0060 전용 신규, 02 §4.6#3 사용자 확정) */}
      <RequestorModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        setSelectedValue={(userId, userName) =>
          set({ requestorId: userId, requestorName: userName })
        }
      />

      {/* Measure 설정 (R2/R3 — TitleSetForm 대응, 공용 ColumnSettingModal + TITLESET 'M').
          OK 시 spdMain 활성 경로만 재조회(R3 — spdDetail 경로는 AS-IS 주석처리 NO-OP 재현) */}
      <ColumnSettingModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        menuId={MENU_ID}
        sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN] ?? ''}
        columnType={TITLESET_MEASURE_TYPE}
        onSave={() => {
          setOpenMeasure(false);
          if (activeGrid === 'main' && filters[SHEETS.MAIN]) void refetchMain();
        }}
      />

      {/* 저장 후 Request 팝업 (R8 — 무조건 오픈, 닫힘(취소 포함) 시 무조건 재조회) */}
      <ShipmentRequestModal
        open={openRequest}
        modalClose={() => {
          setOpenRequest(false);
          if (filters[SHEETS.MAIN]) void refetchMain();
        }}
        tabId={tabId}
      />

      {/* Confirm 상세 팝업 (CHANGE_REQ_NO 클릭 — 표시전용) */}
      <ConfirmDetailModal
        open={confirmDetailNo !== ''}
        modalClose={() => setConfirmDetailNo('')}
        tabId={tabId}
        changeReqNo={confirmDetailNo}
      />
    </>
  );
};
