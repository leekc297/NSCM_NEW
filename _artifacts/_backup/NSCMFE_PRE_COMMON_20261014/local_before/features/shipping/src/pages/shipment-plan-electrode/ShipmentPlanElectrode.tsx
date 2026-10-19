import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnSettingModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox } from '@shared/lges';
import { Stack } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentPlanElectrodeDetailBar } from './components/ShipmentPlanElectrodeDetailBar';
import { ShipmentPlanElectrodeDetailGrid } from './components/ShipmentPlanElectrodeDetailGrid';
import { ShipmentPlanElectrodeForm } from './components/ShipmentPlanElectrodeForm';
import { ShipmentPlanElectrodeMainGrid } from './components/ShipmentPlanElectrodeMainGrid';
import {
  ADMIN_SHEET_NAME,
  BOH_RADIO,
  LBL,
  MENU_ID,
  MSG,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  PLAN_DETAIL_REQUIRED_COLUMNS,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-electrode.constants';
import type { MainRow } from './shipment-plan-electrode.types';
import styles from './ShipmentPlanElectrode.module.scss';
import { useShipmentPlanElectrodeStore } from './useShipmentPlanElectrodeStore';
import { activeSpanOf } from './utils/shipment-plan-electrode.editLock';
import {
  collectDetailSaveRows,
  collectMainSaveRows,
} from './utils/shipment-plan-electrode.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// BOH 3-radio 라벨 매핑 (03 §2.1). RadioGroup 미제공(@shared)이라 Button 배타토글로 재현 —
//   활성 radio 만 contained/primary, 나머지 outlined/normal. rdButton→span(X/Y/Z)은 activeSpanOf.
const BOH_RADIO_ITEMS: { radio: BOH_RADIO; lbl: string; fallback: string }[] = [
  { radio: BOH_RADIO.GENERAL, lbl: LBL.BOH_UOM, fallback: 'UOM' },
  { radio: BOH_RADIO.CELL, lbl: LBL.BOH_CELL, fallback: 'Cell' },
  { radio: BOH_RADIO.PCM, lbl: LBL.BOH_PCM, fallback: 'Pancake m' },
];

// AS-IS GSCM.SSP.Plan.UIL SSP0023_ShipmentPlanElectrode (Shipment Plan - Electrode / 출하계획-전극) — 신규 전환.
//   설계: .atlas/gscm-design/SSP0023/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지, false 숨김 금지),
//     Edit = SwitchLock 미이식(convert-core §2.4 — 편집 기본 ON, 권한 마운트 1회).
//   이중 pivot: rdButton1/2/3 이 BOH 3칸 + 활성 기간 span(X_/Y_/Z_)을 동시 선택(03 §2.1/§2.2).
//   주의: 초안작성/확정 SAVE SP(PKG_SSP0023 draft/confirm)는 미배포(§6-1) — Detail 저장 경로는
//     배선 보류·미완 안내(convert-sp 후속). siMain 시뮬레이션 저장(SAVE_SHIPMENT_PLAN_SIMU)은 배포됨.
export const ShipmentPlanElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);

  // ── refs (Main + Detail 3-sheet) ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const planDetailGridRef = useRef<FlexGridType>();
  const planDetailGridFilterRef = useRef<FlexGridFilter>();
  const planDetailEditTrackerRef = useRef<EditTracker>();
  const stockDetailGridRef = useRef<FlexGridType>();
  const stockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const filters = useShipmentPlanElectrodeStore(s => s.filters);
  const setMainFilters = useShipmentPlanElectrodeStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanElectrodeStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanElectrodeStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanElectrodeStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanElectrodeStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanElectrodeStore(s => s.realFlag);
  const activeGrid = useShipmentPlanElectrodeStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);
  const setBohRadio = useShipmentPlanElectrodeStore(s => s.setBohRadio);
  const setChkSum = useShipmentPlanElectrodeStore(s => s.setChkSum);
  const setChkPastPeriod = useShipmentPlanElectrodeStore(s => s.setChkPastPeriod);
  const staticColumns = useShipmentPlanElectrodeStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanElectrodeStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentPlanElectrodeStore(s => s.fetchStaticMeasures);
  const initialized = useShipmentPlanElectrodeStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 가능 = 권한(canEdit = hasButton('EDIT'), 마운트 1회) · 최신 Plan(realFlag).
  //   AS-IS EditButton/SwitchLock '수정 모드' 토글은 이식하지 않는다(convert-core §2.4 · 전 화면 공통 결정).
  //   realFlag(최신 Plan 아님 → 편집 차단)는 AS-IS 데이터 조건이라 유지(토글 어포던스와 별개).
  const canEdit = hasButton('EDIT');
  const mainEditable = canEdit && realFlag;
  const detailEditable = canEdit && realFlag;

  // ── Measure 설정 모달 (btnMeasure — spdMain 활성일 때만) ──
  const [openMeasure, setOpenMeasure] = useState(false);

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
  const { data: shipmentResultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.PLAN_DETAIL]: (planDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.STOCK_DETAIL]: (stockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SHIPMENT_RESULT]: (shipmentResultData?.o_rc1 ?? []) as WijmoRowItem[],
    }),
    [planDetailData, stockDetailData, shipmentResultData]
  );

  // Detail 확정 SAVE 는 PKG_SSP0023 draft/confirm SP 미배포(§6-1)라 useProcMutation 을 아직 걸지 않는다.
  //   SP 배포 시 useProcMutation<MENU_ID, SHEETS.PLAN_DETAIL>({ onSuccess: clearChanges+toast+refetch }) 을
  //   추가하고 handleSave detail 경로에서 호출한다(convert-sp 후속). 지금은 payload 조립까지만 완비.

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼/measure 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns([SHEETS.MAIN, SHEETS.PLAN_DETAIL, SHEETS.STOCK_DETAIL, SHEETS.SHIPMENT_RESULT]);
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Division/Company 변경 = 그리드·편집 상태 초기화 의무 (hook #5). filters 초기화는 store 담당,
  //    여기서는 EditTracker 잔여 기록 정리. ──
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();

  }, [sc.divisionId, sc.companyId]);

  // ── Find (F5 — 01 R10) ──
  const runMainSearch = () => {
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
    void fetchStaticMeasures();
  };

  const handleSearch = () => {
    // 필수 4종 (02 §3 — Division*/Company*/Plan Date*/Period*)
    if (!sc.divisionId || !sc.companyId || !sc.planDateYyyymmdd || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 미저장 변경이 있으면 재조회 전 확인(MSG00703).
    const hasUnsaved =
      mainEditTrackerRef.current?.hasChanges() === true ||
      planDetailEditTrackerRef.current?.hasChanges() === true;
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

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회) ──
  const handleDetailSearch = () => {
    setDetailFilter(activeDetailSheet, 'N');
    void fetchStaticColumns([activeDetailSheet]);
  };

  // ── Save (F7 — activeGrid 분기, 03 §3-H) ──
  const savingRef = useRef(false);
  const handleSave = () => {
    if (activeGrid === 'main') {
      // 편집 사전조건 — 편집 불가면 조용히 무시(AS-IS IsLock 가드).
      if (!mainEditable) return;
      const rows = (mainGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const tracker = mainEditTrackerRef.current;
      const { payload, negatives } = collectMainSaveRows(
        rows,
        row => tracker?.getOriginalValues().get(row as WijmoRowItem),
        {
          divisionId: sc.divisionId,
          companyId: sc.companyId,
          planStartYyyymmdd: sc.planDateYyyymmdd,
          userId: session.userId ?? '',
          activeSpan: activeSpanOf(sc.bohRadio),
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
      // siMain 시뮬레이션 저장(SAVE_SHIPMENT_PLAN_SIMU — 배포됨). SAVE 액션 코드로 call-proc.
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
          setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
          if (filters[SHEETS.MAIN]) void refetchMain();
        })
        .finally(() => {
          savingRef.current = false;
        });
      return;
    }

    // Detail 저장 — PlanDetail(확정)만 편집 대상. StockDetail/ShipmentResult 는 read-only.
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return;
    const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
    if (dirty.length === 0) {
      // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준)
      setToast({
        type: 'error',
        message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
      });
      return;
    }
    // 행별 필수 (03 §1.2 PLAN_DETAIL_REQUIRED_COLUMNS 공백검증) + 변경사유 필수
    for (const row of dirty) {
      for (const col of PLAN_DETAIL_REQUIRED_COLUMNS) {
        if (str(row[col]).trim() === '') {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, { defaultValue: '_{0} value is required.', 0: col }),
          });
          return;
        }
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
    // payload 조립은 완비(collectDetailSaveRows) — 확정 SAVE SP(PKG_SSP0023 draft/confirm)만 미배포(§6-1).
    //   실제 payload 를 만들어 두어 SP 배포 시 mutateDetailSave(payload) 한 줄로 배선되게 하되,
    //   지금은 SP 부재라 미배포 안내로 종료한다(convert-sp 후속). payload 는 배선 준비 완료의 증거로 유지.
    const payload = collectDetailSaveRows(dirty, {
      userId: session.userId ?? '',
      userDeptId: '', // AS-IS USER_DEPT_ID — 세션에 부서 없음(04 확인필요)
      planStartYyyymmdd: sc.planDateYyyymmdd,
    });
    if (payload.length === 0) {
      setToast({
        type: 'error',
        message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
      });
      return;
    }
    void setAlert({
      type: 'alert',
      content: t(MSG.SAVE_NOT_DEPLOYED, {
        defaultValue: '_Save procedure is not deployed yet.',
      }),
    });
    // SP 배포 시: 위 안내 블록을 제거하고 mutate 를 배선한다(mutateDetailSave(payload as unknown as PlanDetailRow[])).
  };

  // ── Insert (F8 — PlanDetail 신규행. 03 §3.2 — 이전행 명시 필드만 복사) ──
  const handleInsert = () => {
    if (!detailEditable) return;
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return; // 읽기전용 2-sheet — 신규행 없음
    const g = planDetailGridRef.current;
    if (!g) return;
    const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
      | Record<string, unknown>
      | undefined;
    if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4)
    // 원본 행 STATUS 게이트 — 공백은 'C' 간주 허용(AS-IS InsertRow).
    const status = str(source.SHIPMENT_STATUS).trim() || 'C';
    if (status !== 'C') return;
    // 복사 필드는 AS-IS defaultData 명시 목록만(전 필드 스프레드 복사 금지 — 03 §3.2).
    const copied: Record<string, unknown> = {};
    PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
      copied[col] = source[col];
    });
    copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제
    copied.ERP_STATUS = ''; // 항상 공백 강제
    GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
  };

  // ── 2차 NEW 버튼 — Insert 와 동일 본문(SSP0023 는 별도 BtnNew 로직 부재, 03 §3.2 단일 삽입 경로) ──
  const handleNew = () => handleInsert();

  // ── Measure (btnMeasure) — spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return; // 경고 없이 조용히 return
    setOpenMeasure(true);
  };

  // ── hotkeyConfig (00 §4d/01 R10 — hasButton 조건부, 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS 빈 몸체) — 노출 유지 + 명시적 무동작. 키 생략/false 금지(03 §3.5).
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Measure (btnMeasure — hook #120). Edit 버튼 미노출(convert-core §2.4 — hasButton('EDIT')은 canEdit 판정 전용).
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <ShipmentPlanElectrodeForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanElectrode'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (01 §1, 비율 6:4) */}
      <div className={styles.gridArea}>
        <div className={styles.mainGrid}>
          {/* Main 상단 컨트롤바 — BOH 3-radio(배타 Button 토글) / Sum / Past Period (03 §2.1, 재조회 없음) */}
          <Stack direction='row' className={styles.mainControlBar}>
            <div className={styles.radioGroup}>
              {BOH_RADIO_ITEMS.map(item => (
                <Button
                  key={item.radio}
                  appearance={sc.bohRadio === item.radio ? 'contained' : 'outlined'}
                  priority={sc.bohRadio === item.radio ? 'primary' : 'normal'}
                  onClick={() => setBohRadio(item.radio)}
                >
                  {t(item.lbl, item.fallback)}
                </Button>
              ))}
            </div>
            {/* Sum — chkSum (W_/M_ SUM 칼럼 표시, 재조회 없음 — 03 §2.2) */}
            <label className={styles.radioGroup}>
              <Checkbox checked={sc.chkSum} onChange={checked => setChkSum(checked)} />
              {t(LBL.SUM, '_Sum')}
            </label>
            {/* Past Period — chkPastPeriod (과거일 D_/W_ 숨김, 재조회 없음 — 03 §2.2) */}
            <label className={styles.radioGroup}>
              <Checkbox
                checked={sc.chkPastPeriod}
                onChange={checked => setChkPastPeriod(checked)}
              />
              {t(LBL.PAST_PERIOD, '_Past Period')}
            </label>
          </Stack>

          <ShipmentPlanElectrodeMainGrid
            rows={mainRows}
            calendar={calendarRows}
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            adminColumns={staticColumns[SHEETS.MAIN]}
            bucketType={sc.bucketType}
            bohRadio={sc.bohRadio}
            chkSum={sc.chkSum}
            chkPastPeriod={sc.chkPastPeriod}
            editable={mainEditable}
            curPlanDate={sc.planDateYyyymmdd}
          />
        </div>

        <div className={styles.detailArea}>
          <ShipmentPlanElectrodeDetailBar
            onDetailSearch={handleDetailSearch}
            onNew={handleNew}
          />
          <ShipmentPlanElectrodeDetailGrid
            rowsBySheet={rowsBySheet}
            gridRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
            }}
            gridFilterRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridFilterRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridFilterRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridFilterRef,
            }}
            editTrackerRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
            }}
            staticColumns={staticColumns}
            editable={detailEditable}
          />
        </div>
      </div>

      {/* Measure 설정 (btnMeasure — 공용 ColumnSettingModal + TITLESET 'M').
          OK 시 spdMain 활성 경로만 재조회 */}
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
    </>
  );
};
