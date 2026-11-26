import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Checkbox } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { ShipmentPlanFixForm } from './components/ShipmentPlanFixForm';
import { ShipmentPlanFixGrid } from './components/ShipmentPlanFixGrid';
import { useShipmentPlanFixValidation } from './hooks/useShipmentPlanFixValidation';
import { COMBO, LBL, MENU_ID, MSG, SHEETS } from './shipment-plan-fix.constants';
import type { MainRow } from './shipment-plan-fix.types';
import styles from './ShipmentPlanFix.module.scss';
import { useShipmentPlanFixStore } from './useShipmentPlanFixStore';
import { mergeFixReason } from './utils/shipmentPlanFixDerive';
import { buildUnfixPayload } from './utils/shipmentPlanFixSave';

// AS-IS GSCM.SCP.Analysis.UIL SCP0025_ShipmentPlanFix — read-only pivot 그리드(spdMain) + 셀선택→Unfix 액션.
//   설계: .atlas/gscm-design/SCP0025/design/00~03 (v2, DB·SP 실측). 상세 매핑: __asis-mapping__.md.
//   액션 모델: FindButton=조회 / btnUnfix=Unfix(확정 해제, ACTIVE_FLAG='D', SAVE SP P_SCP0025_SAVE_FIX_DATASET).
//     SAVE 버튼은 AS-IS protected override SaveButton() 본문이 비어 있어(cs:468-469) 무동작 — Unfix 는 btnUnfix 만 수행
//     (SAVE 에 unfix 배선 안 함, 사용자 지시 2026-10-02). Edit=읽기전용 안내(MSG00109, cs:463) → read-only 라 미노출.
//   자매 SCP0024(production-plan-fix)와 차이: SCP0025 는 전 컬럼 read-only(편집·EditTracker 없음) → Unfix 는
//     편집 저장이 아니라 선택 셀 역산 키에 ACTIVE_FLAG='D' 전송(design 03 §3-보강).
//   가드(design 01 R1~R4): R1 조회선행(ViewModel null) / R2 권한(CanUpdate→SAVE, MSG00096) / R3 PlanExecYn
//     PLAN_STATUS='0' 차단(MSG00304) / R4 셀선택(MSG00134)+confirm(MSG00016).
export const ShipmentPlanFix = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const { validateSearch } = useShipmentPlanFixValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useShipmentPlanFixStore(s => s.searchCondition);
  const filters = useShipmentPlanFixStore(s => s.filters);
  const setFilter = useShipmentPlanFixStore(s => s.setFilter);
  const setSearchCondition = useShipmentPlanFixStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentPlanFixStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanFixStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanFixStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanFixStore(s => s.fetchStaticColumns);
  const fetchDayRange = useShipmentPlanFixStore(s => s.fetchDayRange);
  const restoreSearchConditions = useShipmentPlanFixStore(s => s.restoreSearchConditions);
  const initialized = useShipmentPlanFixStore(s => s.initialized);

  const [openItem, setOpenItem] = useState(false);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // Unfix 성공 토스트의 {0} 은 전송 행 수 — AS-IS 는 SP 의 result_cnt(= 전송 데이터셋 행 수, cs:1156)를 쓴다.
  //   공용 useProcMutation 의 onSuccess 는 응답 본문을 주지 않으므로 전송 시점의 건수를 ref 로 넘긴다(자매 SCP0024 동형).
  const unfixCountRef = useRef(0);
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    // 기본 onSuccess 의 invalidate(재조회)는 유지하고 성공 문구만 건수 포함으로 교체한다.
    //   MSG00672 "{0}개의 데이터가 저장되었습니다." — {0} 는 i18next 보간자({{ }})가 아니라 수동 .replace 대상.
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({
        type: 'success',
        message: t(MSG.SAVED_COUNT, '_{0} data saved.').replace('{0}', String(unfixCountRef.current)),
      });
    },
  });

  // R3 PlanExecYn 게이트 데이터 — division 기준 PLAN_STATUS 조회(design 01 R3, comboCall §4b #5).
  //   콤보(dropdown)가 아니라 unfix 가드용 데이터 조회라 Page 에서 fetch, handleUnfix 가 결과를 판정한다.
  const [planExecRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_EXEC_YN, mnuId: MENU_ID, divisionId: sc.divisionId }],
    enabled: !!sc.divisionId,
  });

  const rc1 = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  const rc2 = useMemo<Record<string, unknown>[]>(
    () => (data as { o_rc2?: Record<string, unknown>[] })?.o_rc2 ?? [],
    [data]
  );
  // O_RC2(Fix Reason 상세)를 Fix Reason 행 D_ 셀에 매핑(design 03 §2.3 R-H).
  const rows = useMemo<MainRow[]>(
    () => mergeFixReason(rc1 as unknown as Record<string, unknown>[], rc2) as unknown as MainRow[],
    [rc1, rc2]
  );
  const visibilityCtx = useMemo(() => ({ division: sc.divisionId }), [sc.divisionId]);

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 'Shipment Plan Fix' 20행) — mount 1회 fetch(hook #66). Search 시에도 refetch.
  //   Measure 레지스트리(SCM_MST_SHEET_MEASURE)는 0행이라 fetch 없음(design 03 §0/§4.1).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
    }
    // 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 적용, 없으면 기본값(fetchDayRange 등) 유지. 형제 파리티.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 기본 조회기간 시드 — 기간이 비어 있으면(최초 mount) 서버 SP(SCM0001_GET_SCP_DAY_PERIOD, W52=offset 363)로 채워
  //   pivot 컬럼 0(빈 그리드)을 막는다. AS-IS CreateSpread `dCalendar.InitValue = GetDayRange(PeriodType.W52)`(cs:240)
  //   재현 — dayjs 근사 폐기(SCM_SYS_CALENDAR_M 경계를 서버가 산정, 자매 SSP0200 §5.4). division 변경 시 기간 유지
  //   (store setDivision)라 실질적으로 mount 1회 발동. SP/권한 미배포 시 조용히 무동작(store fetchDayRange catch).
  useEffect(() => {
    if (sc.divisionId && !sc.fromYyyymmdd && !sc.toYyyymmdd) void fetchDayRange('');
  }, [sc.divisionId, sc.fromYyyymmdd, sc.toYyyymmdd, fetchDayRange]);

  const handleSearch = () => {
    if (!validateSearch(sc).ok) return; // 기간 from<=to
    setFilter();
    void fetchStaticColumns();
  };

  // 선택 셀 존재 — AS-IS Unfix 전제(design 01 R4 — selCells<1 → MSG00134).
  const hasSelectedCell = (): boolean => {
    const g = gridRef.current;
    return !!g && g.rows.length > 0 && (g.selection?.row ?? -1) >= 0 && (g.selection?.col ?? -1) >= 0;
  };

  // R3 — PlanExecYn 조회결과 행 1건 & PLAN_STATUS=='0'(계획 미실행)이면 unfix 차단(design 01 R3, MSG00304).
  //   ComboResponse 는 [key:string]:string 인덱스 시그니처라 PLAN_STATUS 를 직접 읽는다(PlanExecYn_SCP 반환 컬럼).
  const isPlanNotExecuted = (): boolean => {
    const list = planExecRows ?? [];
    return list.length === 1 && list[0].PLAN_STATUS === '0';
  };

  // Unfix(SAVE 버튼 / btnUnfix) — 선택 셀(Ship Plan 행 × D_ 일자)에서 역산한 키에 ACTIVE_FLAG='D' → SAVE SP 전송.
  //   design 01 R1~R4 가드 → design 03 §4.3 JSON 계약. 성공/실패/재조회는 useProcMutation 기본 onSuccess.
  const handleUnfix = async () => {
    // R1 — 미조회(데이터 없음). TO-BE 는 AS-IS 와 달리 상시 편집모드라 '조회 먼저'(ViewModel null) 게이트가
    //   부적용 — 아무것도 조회/선택하지 않은 상태의 Unfix 는 "행 미선택"(SELECT_CELL)으로 안내한다(사용자 지시 2026-10-02).
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    // R2 — 권한 게이트(AS-IS CanUpdate → TO-BE SAVE 권한).
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    // R3 — 계획 실행상태 게이트(PlanExecYn PLAN_STATUS='0').
    if (isPlanNotExecuted()) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_NOT_EXEC, '_Plan is not executed; unfix is not allowed.') });
      return;
    }
    // R4a — 셀 선택 자체가 없으면 "행 미선택"(AS-IS MSG00134 selCells<1).
    if (!hasSelectedCell()) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    // R4b — AS-IS 순서대로 confirm 을 먼저 띄운다(selCells 확인 → confirm → 수집). "삭제하시겠습니까?"
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, 'Do you want to delete it?') });
    if (!ok) return;
    // R4c — 확인 후 대상 수집. 선택 셀은 있으나 확정(삭제 대상) 데이터가 0건이면(이미 unfix 된 빈 셀 등)
    //   "삭제할 데이터가 없습니다"(AS-IS SaveData_FixInfo_U 수집 0건 → MSG00046). "행 미선택" 이 아니다.
    const payload = buildUnfixPayload(gridRef.current);
    if (payload.length === 0) {
      void setToast({ type: 'error', message: t(MSG.NO_DELETE_DATA, '_No data to delete.') });
      return;
    }
    unfixCountRef.current = payload.length; // MSG00672 {0} = 전송 행수(AS-IS result_cnt 등가)
    mutateMain(payload as unknown as MainRow[]);
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(search 버튼 권한과 무관하게 조회 보장).
    search: handleSearch,
    // SAVE = 동작 없는 no-op 버튼이라 제거(false, 사용자 결정 2026-10-20: 무동작 버튼 미노출). AS-IS SaveButton
    //   본문 공백(cs:468-469). 확정 해제(Unfix)는 화면 고유 btnUnfix(customButtons)로만 수행(사용자 지시
    //   2026-10-02). 키 생략 금지(공용 SubTitle 기본 save 핸들러 부활) — false 로 명시.
    save: false,
    // Insert/Delete — BTN_MPG_M(권한) 미등록이라 숨김(false, 사용자 결정 2026-10-20). AS-IS toolbarOverride
    //   없음(design 00 §4-2 / 01 §2.4). 키 생략 금지(공용 SubTitle addRow/removeRow 부활) — false 로 명시.
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
        <ShipmentPlanFixForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentPlanFix'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={
          // btnUnfix — 조회조건 우측 화면 고유 액션 버튼(design 01 §1).
          //   전용 Unfix BTN_CD 는 미등록이라 SAVE 권한으로 대리 게이트한다(자매 SCP0024 ProductionPlanFix 선례).
          //   권한이 없으면 클릭 후 alert 이 아니라 버튼 자체를 그리지 않는다(AUTH-02 — 권한 없는 버튼은
          //   비활성 표시 없이 그리지 않는다). handleUnfix 내부 R2 권한 체크는 방어적으로 유지.
          hasButton('SAVE')
            ? [{ label: t(LBL.UNFIX, '_Unfix'), action: () => void handleUnfix() }]
            : []
        }
        // Sum(chkSum, SUM 컬럼 토글)을 그리드 건수 오른쪽(afterCount)으로 배치(사용자 지시 2026-11-18, SCP0013 동형).
        afterCount={
          <Checkbox
            labelText={t(LBL.SUM, '_Sum')}
            checked={sc.chkSum}
            onChange={checked => setSearchCondition({ chkSum: checked })}
          />
        }
      />

      <div className={styles.gridWrapper}>
        <ShipmentPlanFixGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Model/Nickname 검색 — 공용 MaterialByDivisionModal (AS-IS SCM0002_MaterialByDivisionPopup=COM0013,
          사용자 지시 2026-10-01). setSelectedValue 첫 인자(ITEM_ID 콤마결합)를 itemId 로 세팅. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => setSearchCondition({ itemId: items })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: sc.operationGroupId,
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
