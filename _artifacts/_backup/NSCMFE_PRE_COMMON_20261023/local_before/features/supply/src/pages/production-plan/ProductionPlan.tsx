import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ProductionPlanForm } from './components/ProductionPlanForm';
import { ProductionPlanGrid } from './components/ProductionPlanGrid';
import {
  LBL,
  LINE_FIXED_COLUMNS,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MODEL_FIXED_COLUMNS,
  MSG,
  RATIO_MEASURES,
  SHEETS,
  SUM_LAST_VALUE_MEASURES,
} from './production-plan.constants';
import type { EditInfoRow } from './production-plan.types';
import styles from './ProductionPlan.module.scss';
import { useProductionPlanStore } from './useProductionPlanStore';
import { alignPivotKeys, applyRatio, fillPivotSums } from './utils/productionPlanDerive';
import { deriveEditContext, type EditInfoEntry } from './utils/productionPlanEditLock';
import { buildLineSavePayload, submitLineSave } from './utils/productionPlanLineSave';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SCP.Analysis.UIL SCP0011_ProductionPlan — master-detail 2 pivot 그리드.
//   spdMain(MODEL 읽기전용) 더블클릭 → spdLine(LINE, PROD_PLAN_AMEND 편집) drill. 설계 design 00~03.
//   편집모드 미이식(convert-core §2.4): editMode/setEditMode state 금지, mount canEdit=hasButton('SAVE') 1회.
//   Insert/Delete = NO-OP(버튼 노출 + () => undefined, design 01 R-A3/R-A4). btnCal=Amend, btnMeasure=TitleSet.
//   메타: 메뉴/버튼/권한 05_register.sql 등록. SP 실행체인(PROC_M)은 convert-sp 후속(04 정직보고).
export const ProductionPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const masterGridRef = useRef<FlexGrid>();
  const masterFilterRef = useRef<FlexGridFilter>();
  const masterTrackerRef = useRef<EditTracker>();
  const lineGridRef = useRef<FlexGrid>();
  const lineFilterRef = useRef<FlexGridFilter>();
  const lineTrackerRef = useRef<EditTracker>();

  const sc = useProductionPlanStore(s => s.searchCondition);
  const filters = useProductionPlanStore(s => s.filters);
  const setFilter = useProductionPlanStore(s => s.setFilter);
  const setSearchCondition = useProductionPlanStore(s => s.setSearchCondition);
  const restoreSearchConditions = useProductionPlanStore(s => s.restoreSearchConditions);
  const setLineFilter = useProductionPlanStore(s => s.setLineFilter);
  const openSearchArea = useProductionPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useProductionPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useProductionPlanStore(s => s.fetchStaticColumns);
  const staticMeasures = useProductionPlanStore(s => s.staticMeasures);
  const fetchStaticMeasures = useProductionPlanStore(s => s.fetchStaticMeasures);

  const [openItem, setOpenItem] = useState(false);
  // 메1 픽커가 어느 필드에서 열렸는지 — Material(→itemId) / Model/Nickname(→nickName). 아이콘 클릭 시 세팅,
  //   팝업 확정(setSelectedValue) 시 읽어 해당 조건에 반영한다.
  const itemTargetRef = useRef<'material' | 'modelNick'>('material');
  const [openMeasure, setOpenMeasure] = useState(false);
  // 포커스된 그리드(MODEL/LINE) — 상단 공용 툴바의 그리드 대상 동작(Sort/Filter/Excel)과 Measure 팝업 대상을
  //   모두 이 상태로 따른다. AS-IS 는 Sort/Filter(BaseForm 기본)·Measure·Bucket·chkSum 을 전부 fps(focused
  //   spread)로 분기한다(cs btnMeasure_Click/cboBucketType/chkSum_CheckedChanged L764~) — 그 패리티(사용자 결정
  //   2026-10-12). 각 그리드 onFocus 로 갱신되고, 툴바 버튼 클릭은 포커스를 바꾸지 않아 마지막 포커스 그리드가
  //   유지된다. 첫 진입(미포커스) 기본값은 MODEL(상단) — AS-IS 는 fps==null 이면 Measure 를 MSG00007 로 막지만
  //   2그리드 화면 사용성상 상단을 기본 대상으로 연다. (Save 는 이와 무관하게 handleSave=항상 Line.)
  //   주의: MODEL/LINE 은 표시 measure 를 각각 따로(visibleModel/visibleLine) 들어 그리드별 독립 설정이다.
  const [focusedSheet, setFocusedSheet] = useState<SHEETS.MAIN | SHEETS.LINE>(SHEETS.MAIN);
  const [visibleModel, setVisibleModel] = useState<string[] | null>(null);
  const [visibleLine, setVisibleLine] = useState<string[] | null>(null);

  // 편집 권한 1회(mount) — editMode state 금지(convert-core §2.4). AS-IS 편집가부는 CanUpdate(수정권한)
  //   단일 권한이고, EDIT 버튼코드는 이 화면 버튼셋에 없다(SCM_ADM_*_MNU_BTN_MPG_M = SEARCH/SAVE 뿐, ora.py 실측).
  //   hasButton('EDIT') 로 게이트하면 전 사용자가 상시 편집불가(gap iter-1 H1 — 화면 핵심기능 死)라서,
  //   자매 SCP0013 과 동일하게 수정권한(SAVE)으로 게이트한다(AS-IS CanUpdate ↔ TO-BE SAVE 패리티, H1 해소).
  const canEdit = hasButton('SAVE');

  // MODEL(master) GET — 조회(Find) 시 filters[MAIN] 세팅으로 발사.
  const { data: modelData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // LINE(detail) GET — master 더블클릭 drill 시 filters[LINE] 세팅으로 발사.
  const { data: lineData } = useTabProcQuery<MENU_ID, SHEETS.LINE>({
    menuId: MENU_ID,
    sheetName: SHEETS.LINE,
    tabId,
    filters: filters[SHEETS.LINE],
    enabled: !!filters[SHEETS.LINE],
  });
  // EDIT_INFO — 선택 plan version 단일 편집컨텍스트(EDIT_START_DATE/IS_EDITABLE). design 03 §2.5, DB 실측.
  const { data: editInfoData } = useTabProcQuery<MENU_ID, SHEETS.EDIT_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.EDIT_INFO,
    tabId,
    filters: filters[SHEETS.EDIT_INFO],
    enabled: !!filters[SHEETS.EDIT_INFO],
  });

  const { mutate: mutateAmend } = useProcMutation<MENU_ID, SHEETS.AMEND>({
    menuId: MENU_ID,
    sheetName: SHEETS.AMEND,
    tabId,
    onSuccess: () => {
      // onSuccess 를 넘겨 useProcMutation 기본 성공 toast(MSG00002)를 대체 — Amend 는 완료 메시지 없이
      //   조용히 모델만 재조회한다(AS-IS SaveChage_CalData 완료 메시지 주석처리 + FindData_Model_Parallel 패리티).
      //   저장 성공 후 연쇄(runAmend)로 불릴 때도 저장 toast 와 toast 가 중복되지 않는다.
      setFilter();
    },
  });

  // 모델 그리드행 = O_RC1 + O_RC3/O_RC4 ratio 보정(비율 measure FORMATION_YIELD 의 W_/M_ 를 평균으로 덮어씀).
  const modelRowsRaw = useMemo<Record<string, unknown>[]>(() => {
    const d = modelData as
      | { o_rc1?: Record<string, unknown>[]; o_rc3?: Record<string, unknown>[]; o_rc4?: Record<string, unknown>[] }
      | undefined;
    // W_/M_ SUM 은 조회 직후 D_ 합산으로 채운다(AS-IS CalculateSum). ratio 커서가 오면 그 값이 우선.
    const filled = fillPivotSums(d?.o_rc1 ?? [], RATIO_MEASURES, SUM_LAST_VALUE_MEASURES);
    return applyRatio(filled, d?.o_rc3 ?? [], d?.o_rc4 ?? [], RATIO_MEASURES);
  }, [modelData]);

  // Measure 설정 팝업 선택 반영(MODEL) — 표시 measure 만 남긴다(null=전체). LINE 과 동일 토글(AS-IS TitleSet).
  const modelRows = useMemo<Record<string, unknown>[]>(() => {
    if (!visibleModel) return modelRowsRaw;
    return modelRowsRaw.filter(r => {
      const m = r.MEASURE;
      return typeof m === 'string' && visibleModel.includes(m);
    });
  }, [modelRowsRaw, visibleModel]);

  const lineRowsRaw = useMemo<Record<string, unknown>[]>(() => {
    const d = lineData as
      | { o_rc1?: Record<string, unknown>[]; o_rc3?: Record<string, unknown>[]; o_rc4?: Record<string, unknown>[] }
      | undefined;
    // W_/M_ SUM 은 조회 직후 D_ 합산으로 채운다(AS-IS CalculateSum). ratio 커서가 오면 그 값이 우선.
    // 값이 전부 빈 기간 열이 빠지지 않게 조회 기간 전체 키를 채운다(MODEL 첫 행 기준).
    const lf = filters[SHEETS.LINE] as { fromYyyymmdd?: string; toYyyymmdd?: string } | undefined;
    const aligned = alignPivotKeys(
      d?.o_rc1 ?? [],
      modelRowsRaw[0],
      lf?.fromYyyymmdd ?? '',
      lf?.toYyyymmdd ?? ''
    );
    const filled = fillPivotSums(aligned, RATIO_MEASURES, SUM_LAST_VALUE_MEASURES);
    return applyRatio(filled, d?.o_rc3 ?? [], d?.o_rc4 ?? [], RATIO_MEASURES);
  }, [lineData, modelRowsRaw, filters]);

  // Measure 설정 팝업 선택 반영 — 표시 measure 만 LINE 그리드 행으로 남긴다(null=전체). AS-IS TitleSet 표시 토글.
  const lineRows = useMemo<Record<string, unknown>[]>(() => {
    if (!visibleLine) return lineRowsRaw;
    return lineRowsRaw.filter(r => {
      const m = r.MEASURE;
      return typeof m === 'string' && visibleLine.includes(m);
    });
  }, [lineRowsRaw, visibleLine]);

  // EDIT_INFO 단일 편집컨텍스트 — DB 실측상 SP 는 선택 plan version 당 0/1행 반환(CP_KEY 없음). 첫 행만 사용.
  const editInfo = useMemo<EditInfoEntry | null>(() => {
    const list = (editInfoData as { o_rc1?: EditInfoRow[] })?.o_rc1 ?? [];
    const r = list[0];
    if (!r) return null;
    return { isEditable: str(r.IS_EDITABLE), editStartDate: str(r.EDIT_START_DATE) };
  }, [editInfoData]);

  // 편집판정 컨텍스트 — LINE 조회결과에서 최종 PlanType/FN 존재 파생 + canEdit (design 01 R2).
  const lineEditContext = useMemo(() => deriveEditContext(lineRowsRaw, canEdit), [lineRowsRaw, canEdit]);
  // MODEL 그리드는 전건 읽기전용 — 편집 컨텍스트 무의미(canEdit=false 고정).
  const readonlyContext = useMemo(() => deriveEditContext(modelRowsRaw, false), [modelRowsRaw]);

  // F6(Condition) 저장 조회조건 복원 — 마운트 1회(스토어 initialized 가드). Condition(F6) 저장↔복원 왕복 완성.
  //   폼의 기본값 effect(division 첫행·planDate 최신 등)는 전부 length===0/!hasDivision 가드라 복원값을 덮지 않는다.
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  useEffect(() => {
    // MODEL/LINE 두 시트 measure 메타를 받는다 — 포커스된 그리드 기준으로 팝업을 연다(AS-IS fps 분기).
    void fetchStaticMeasures(SHEETS.MAIN);
    void fetchStaticMeasures(SHEETS.LINE);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Measure 표시 설정 서버 복원 — PR_GET_SHEET_MEASURE_LIST 가 SHEET_PRSL_YN='Y'(SCP0011 MODEL/LINE 등록,
  //   SCM_ADM_LOOKUP_MASTER_DETAIL)에서 DISPLAY_FLAG 를 사용자 titleSet('M') 기준으로 내려준다. 이 화면 데이터
  //   SP(P_SCP0011_*_GET)는 titleSet 미반영이라, staticMeasures.display 를 표시 measure 집합으로 시드해 그리드
  //   필터(modelRows/lineRows)로 재현한다(AS-IS SCM0002_TitleSetForm 영구저장 이식). 저장·재조회마다 재동기화.
  useEffect(() => {
    const model = staticMeasures[SHEETS.MAIN];
    const line = staticMeasures[SHEETS.LINE];
    if (model.length > 0) setVisibleModel(model.filter(m => m.display).map(m => m.colNm));
    if (line.length > 0) setVisibleLine(line.filter(m => m.display).map(m => m.colNm));
  }, [staticMeasures]);

  // 고정 컬럼 메타는 division 별 서버 필터 — division 확정/변경마다 Model/Line 재fetch(하드코딩 제거).
  useEffect(() => {
    if (sc.divisionId) {
      void fetchStaticColumns(SHEETS.MAIN);
      void fetchStaticColumns(SHEETS.LINE);
    }
  }, [sc.divisionId, fetchStaticColumns]);

  const requiredMsg = (label: string): string =>
    t(MSG.REQUIRED_FIELD, '_{0} is required.').replace('{0}', label);

  // 조회조건 필수 — Division/OperationGroup (design 01 R1-c checkRequiredOfSearch; PlanDate/Type/Seq 는 제외).
  const checkRequired = (): boolean => {
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.DIVISION, '_Division')) });
      return false;
    }
    if (!sc.operationGroupId) {
      void setAlert({ type: 'alert', content: requiredMsg(t(LBL.OPERATION_GROUP, '_Operation Group')) });
      return false;
    }
    if (sc.fromYyyymmdd && sc.toYyyymmdd && sc.fromYyyymmdd > sc.toYyyymmdd) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_PERIOD_RANGE, '_Invalid period.') });
      return false;
    }
    return true;
  };

  const handleSearch = () => {
    if (!checkRequired()) return;
    setFilter();
    void fetchStaticColumns(SHEETS.MAIN);
  };

  // master(MODEL) 더블클릭 → line drill (design 03 §4.2). 선택 모델행 식별값으로 LINE GET + EDIT_INFO 는 조회 세팅분 유지.
  const handleMasterRowDoubleClick = (row: Record<string, unknown>) => {
    setLineFilter(row);
    void fetchStaticColumns(SHEETS.LINE);
  };

  // AMEND(Target-Plan) 재계산 실행 — btnCal(확인 후)·저장 성공 후 연쇄 공용. mutateAmend onSuccess 가
  //   setFilter()로 모델을 재조회하므로, 한 번 호출로 "재계산 → 모델 재조회" 가 이어진다.
  //   AMEND SP(P_SCP_ANL_PROD_PLAN_I_AMEND)는 P_USER_ID 를 감사용이 아니라 필터 키로 쓴다
  //   (UPPER(USER_ID)=V_USER_ID). call-proc 엔드포인트는 세션 userId 를 주입하지 않으므로(call-proc2 만 주입)
  //   FE 가 세션 userId 를 실어야 recalc 대상 행이 잡힌다. PROC_M 6 IN 은 JVARCHAR 라 data[] 배열이 top-level 로 접힌다.
  const runAmend = () => {
    mutateAmend([
      {
        divisionId: sc.divisionId,
        planStartYyyymmdd: sc.planStartYyyymmdds[0] ?? '',
        planType: sc.planTypes[0] ?? '',
        seq: sc.planSeqs[0] ?? '',
        operationGroup: sc.operationGroupId,
        userId: useSessionStore.getState().session.userId ?? '',
      },
    ] as unknown as never[]);
  };

  // 라인 저장 (design 03 §4.3 — 변경·빈 D_ 셀만). AS-IS SaveData_Line 재현: 변경 D_ 셀을 17 컬럼 '^'-fold
  //   payload 로 조립(buildLineSavePayload)해 SAVE call-proc 로 직접 POST(submitLineSave)한다. SAVE SP 의 17 IN 은
  //   DATA_TP_CD='CLOB' 이라 공용 useProcMutation({data:[rows]})로는 키 불일치로 조용히 no-op 된다(react-gap-audit H2).
  const handleSave = async () => {
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    lineGridRef.current?.finishEditing(); // 진행 중 편집 커밋 → 마지막 셀이 EditTracker 에 반영되게
    const userId = useSessionStore.getState().session.userId ?? '';
    const built = buildLineSavePayload(lineGridRef.current, lineTrackerRef.current, userId);
    if (!built) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // 음수 차단 (design 03 §3 R15 / MSG00225). 변경된 D_ 셀 음수면 저장 중단.
    if (built.negative) {
      void setAlert({ type: 'alert', content: t(MSG.QTY_NEGATIVE, '_Quantity must be 0 or greater.') });
      return;
    }
    const res = await submitLineSave(built.payload);
    if (!res.ok) {
      void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_FAIL, '_Failed to save.') });
      return;
    }
    // 성공 toast(MSG00002, TO-BE 유지) — 무변경(MSG00004)과 분리(M2 해소). AS-IS SaveData_Line 성공 →
    //   SaveChage_CalData(false)(Amend 재계산, 메시지 없이) → FindData_Model_Parallel(모델 재조회) 패리티.
    //   runAmend() 가 재계산을 조용히 돌리고 onSuccess 에서 setFilter()로 모델을 재조회한다(재계산 → 모델 재조회 연쇄).
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    runAmend();
  };

  // btnCal "Calculate" (Amend 재계산) — 가드(design 01 R1): 수정권한(대리권한 SAVE) → 조회조건 필수 → MSG00206 confirm.
  const handleAmend = async () => {
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (!checkRequired()) return;
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_AMEND, '_Recalculate Target-Plan (Amend)?') });
    if (!ok) return;
    runAmend();
  };

  const handleMeasure = () => setOpenMeasure(true);

  // hotkeyConfig — Insert/Delete 는 버튼 자체를 숨긴다(false): AS-IS InsertButton/DeleteButton override 본문이
  //   주석(//InsertRow()/ //siMain.Delete())뿐이라 실제로 쓰지 않는 사문(死)버튼이다. 사용자 지시(2026-10-07)로
  //   NO-OP 노출(design 01 R-A3/R-A4) 대신 비노출로 전환 — 키 생략은 공용 기본 addRow 가 되살아나므로 금지, false 사용.
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: hasButton('SAVE') ? () => void handleSave() : false,
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
        <ProductionPlanForm
          onSearch={handleSearch}
          onItemSearch={target => {
            itemTargetRef.current = target;
            setOpenItem(true);
          }}
        />
      )}
      {/* Model 그리드 헤더 = 공용 툴바 줄(제목 'Model' 왼쪽 + 버튼 오른쪽, 한 줄). 별도 캡션 줄로 분리하지 않고
          오른쪽 버튼과 같은 줄에 둔다(사용자 지시 2026-10-07). 건수는 숨김(hideTotalCases).
          Sort/Filter/Excel 등 그리드 대상 동작은 포커스된 그리드(focusedSheet)를 따른다 — AS-IS fps 패리티
          (사용자 결정 2026-10-12). Save 는 hotkeyConfig.save=handleSave 로 항상 Line, Measure 는 아래 모달이 focusedSheet 로 분기. */}
      <SubTitle
        menuId={MENU_ID}
        grid={focusedSheet === SHEETS.MAIN ? masterGridRef : lineGridRef}
        gridFilter={focusedSheet === SHEETS.MAIN ? masterFilterRef : lineFilterRef}
        dataCount={lineRows.length}
        title={t(LBL.MODEL, '_Model')}
        hideTotalCases
        excelFileName='ProductionPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // btnCal "Calculate"(Amend) — AS-IS Designer Text='Calculate'. 다국어 LBL.AMEND(LBL01058='Calculate') 적용. design 01 R1.
          { label: t(LBL.AMEND, '_Calculate'), action: () => void handleAmend() },
          // btnMeasure(TitleSet) — forecast-price 동일 아이콘(IcMeasureSelect) + MeasureSelectModal.
          {
            label: t(LBL.MEASURE, '_Measure'),
            title: t(LBL.MEASURE, '_Measure'),
            action: handleMeasure,
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]}
      />

      {/* 상/하 2그리드 split (design 01 §1 splitContainer1 Horizontal). 상 spdMain(MODEL) · 하 spdLine(LINE).
          Model 제목은 위 공용 툴바 줄에 통합(오른쪽 버튼과 같은 줄). Line 은 그리드 위 캡션 줄로 둔다. */}
      <div className={styles.splitWrapper}>
        {/* 경계 바를 드래그해 상하 크기 조절(AS-IS splitContainer1) — SSP0015 와 같은 PanelGroup 방식. */}
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel defaultSize='50%' minSize='15%'>
            <div className={styles.masterPane}>
              <ProductionPlanGrid
                rows={modelRows}
                gridRef={masterGridRef}
                gridFilterRef={masterFilterRef}
                editTrackerRef={masterTrackerRef}
                bucket={sc.bucket}
                chkSum={sc.chkSum}
                chkAll={true}
                fallbackColumns={MODEL_FIXED_COLUMNS}
                division={sc.divisionId}
                adminColumns={staticColumns[SHEETS.MAIN]}
                editable={false}
                editContext={readonlyContext}
                editInfo={editInfo}
                onRowDoubleClick={handleMasterRowDoubleClick}
                onFocus={() => setFocusedSheet(SHEETS.MAIN)}
              />
            </div>
          </Panel>
          <PanelSeparator className={styles.splitBar} />
          <Panel defaultSize='50%' minSize='15%'>
            <div className={styles.linePane}>
              <SubTitle
                menuId={MENU_ID}
                grid={lineGridRef}
                gridFilter={lineFilterRef}
                dataCount={lineRows.length}
                title={t(LBL.LINE, '_Line')}
                useHotkey={false}
              />
              <ProductionPlanGrid
                rows={lineRows}
                gridRef={lineGridRef}
                gridFilterRef={lineFilterRef}
                editTrackerRef={lineTrackerRef}
                bucket={sc.bucket}
                chkSum={sc.chkSum}
                chkAll={true}
                fallbackColumns={LINE_FIXED_COLUMNS}
                division={sc.divisionId}
                adminColumns={staticColumns[SHEETS.LINE]}
                editable={canEdit}
                editContext={lineEditContext}
                editInfo={editInfo}
                onFocus={() => setFocusedSheet(SHEETS.LINE)}
              />
            </div>
          </Panel>
        </PanelGroup>
      </div>

      {/* Material · Model/Nickname 공용 메1 픽커(MaterialByDivisionModal COM0013). 모3(ItemByDivisionModal
          COM0008)에서 교체(자매 SCP0013 동일 패턴). EE division 매핑은 모달 내부(mapElectrodeDivision).
          itemTargetRef 로 반영 대상 분기 — Material→item_id, Model/Nickname→nick_name(선택 자재의 Nick Name,
          없으면 선택 코드). 두 필드 모두 같은 팝업을 호출한다(사용자 지시 2026-10-07). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(items, _itemName, _itemClassName, nickName) =>
          setSearchCondition(
            itemTargetRef.current === 'material' ? { itemId: items } : { nickName: nickName ?? items }
          )
        }
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />

      {/* Measure 설정 팝업 — AS-IS btnMeasure(SCM0002_TitleSetForm_Popup). 포커스된 그리드(MODEL/LINE) 기준으로
          열고 해당 그리드 표시 measure 를 토글한다(fps 분기). */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures[focusedSheet]}
        visibleMeasures={focusedSheet === SHEETS.MAIN ? visibleModel : visibleLine}
        onApply={codes => {
          const sheet = focusedSheet;
          // 즉시 반영(재조회 왕복 전 그리드 체감). 서버 저장은 아래 saveTitleSet 가 영구화한다.
          if (sheet === SHEETS.MAIN) setVisibleModel(codes);
          else setVisibleLine(codes);
          // AS-IS TitleSet OK → SCM_MST_TITLESET_USER 영구저장 이식. 그리드별 분리 = sheetName MODEL/LINE
          //   (저장 키 = measure 조회 sheetNm·SHEET_PRSL_YN SEGMENT2 와 동일해야 재조회가 찾는다).
          //   표시 measure 만 저장(행 존재=표시 — saveTitleSet 계약). 성공 시 재조회로 display 재동기화.
          const all = (staticMeasures[sheet] ?? []).map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: MEASURE_SHEET_NAME[sheet],
            columnType: 'M',
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '_Failed to save.') });
              return;
            }
            void fetchStaticMeasures(sheet);
          });
        }}
      />
    </>
  );
};
