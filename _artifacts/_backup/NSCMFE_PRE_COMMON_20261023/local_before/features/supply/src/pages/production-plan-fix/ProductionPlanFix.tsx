import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ProductionPlanFixForm } from './components/ProductionPlanFixForm';
import { ProductionPlanFixGrid } from './components/ProductionPlanFixGrid';
import { useProductionPlanFixValidation } from './hooks/useProductionPlanFixValidation';
import { LBL, MENU_ID, MSG, PRESET_W52, SHEETS } from './production-plan-fix.constants';
import type { MainRow } from './production-plan-fix.types';
import styles from './ProductionPlanFix.module.scss';
import { useProductionPlanFixStore } from './useProductionPlanFixStore';
import { buildUnfixPayload } from './utils/productionPlanFixSave';

// AS-IS GSCM.SCP.Analysis.UIL SCP0024_ProductionPlanFix — measure-행 pivot 그리드(spdMain) + fix/unfix 액션.
//   설계: .atlas/gscm-design/SCP0024/design/00~03 (v2, DB 실측). 상세 매핑: __asis-mapping__.md.
//   AS-IS 소스 확정(gap-resolve iter-2 — GSCM/ 리포 반입 후 정독):
//     FindButton=조회(cs:605) / btnUnfix=선택셀 기반 Unfix(cs:1199→1249 SaveData_FixInfo_U) /
//     InsertButton=빈 본문(cs:1059-1061)·DeleteButton=주석(cs:615-618) = NO-OP 확정 →
//     노출 + 명시적 무동작(insert/delete: ()=>undefined). EditButton=MSG00109("Read-only mode.") 안내 후
//     return(cs:621-634, SwitchLock 주석) — 모드 토글 자체는 asis_to_tobe.md §11 (b) 결정으로 미이식.
//   주의: AS-IS SaveButton 은 본문 주석(`//SaveData()`, cs:636-639)의 NO-OP 이고 시트도 ReadOnly(cs:415)라
//     AS-IS 화면엔 편집·Fix 저장 경로가 없다(확정은 SCP0013 쪽). 사용자 결정(2026-09-26, gap-resolve G20):
//     AS-IS 엄격 재현 채택 — SAVE=NO-OP(노출 유지 무동작), 편집 band·Fix 저장 경로 제거, 시트 전 셀 읽기전용.
//     화면의 유일한 활성 쓰기는 Unfix(선택 셀 기반). DB 메타(main/SAVE→_DS 배선)는 유지하되 FE 가 호출하지 않는다.
//   권한 모델(design 01 R2): Fix/Unfix 는 AS-IS CanUpdate(화면 update 권한) 단일 게이트 — TO-BE 는 SAVE 권한으로 통일
//     (전용 BTN_CD 미등록, 자매 SCP0013/BOD 선례).
export const ProductionPlanFix = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const { validateSearch } = useProductionPlanFixValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useProductionPlanFixStore(s => s.searchCondition);
  const filters = useProductionPlanFixStore(s => s.filters);
  const setFilter = useProductionPlanFixStore(s => s.setFilter);
  const setSearchCondition = useProductionPlanFixStore(s => s.setSearchCondition);
  const openSearchArea = useProductionPlanFixStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanFixStore(s => s.setOpenSearchArea);
  const staticColumns = useProductionPlanFixStore(s => s.staticColumns);
  const fetchStaticColumns = useProductionPlanFixStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useProductionPlanFixStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useProductionPlanFixStore(s => s.restoreSearchConditions);
  const initialized = useProductionPlanFixStore(s => s.initialized);

  const [openItem, setOpenItem] = useState(false);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // Unfix 성공 토스트의 {0} 은 전송 행 수 — AS-IS 는 SP 의 result_cnt(= 전송 데이터셋 행 수, cs:1502)를 쓴다.
  //   공용 useProcMutation 의 onSuccess 는 응답 본문을 주지 않으므로 전송 시점의 건수를 ref 로 넘긴다.
  const unfixCountRef = useRef(0);
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    // AS-IS 는 성공 후 메시지 → FindData_Main(재조회, cs:1502-1503). 기본 onSuccess 의 invalidate 를 유지하고 문구만 교체한다.
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({
        type: 'success',
        message: t(MSG.SAVED_COUNT, '_{0} data saved.').replace('{0}', String(unfixCountRef.current)),
      });
    },
  });

  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  const visibilityCtx = useMemo(() => ({ division: sc.divisionId }), [sc.divisionId]);

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 'Model' 12행 + SCM_MST_SHEET_MEASURE 'PRODUCTION_PLAN_FIX' 2행)
  //   — mount 1회 fetch(hook #66). Search 시에도 refetch(handleSearch).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 적용, 없으면 기본값(W52 preset 등) 유지. 형제 파리티.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // 필수(Division/OperationGroup/Period — AS-IS checkRequiredOfSearch) + 기간 from<=to
    if (!validateSearch(sc).ok) return;
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // Unfix(btnUnfix) — R2 권한(CanUpdate→SAVE, MSG00096) / R1 조회선행 / R3 셀선택(MSG00134)+confirm(MSG00016).
  //   payload 는 편집(dirty)이 아니라 선택 셀 기반 — AS-IS SaveData_FixInfo_U(cs:1249-1544)는 선택 range 의
  //   Prod Plan 행 × D_(수량 있는 일자, W_ 는 주 확장) 셀을 편집 없이 ACTIVE_FLAG='D' 로 전송한다
  //   (gap-resolve iter-2 — 종전 dirty 기반은 "편집한 셀만 해제 가능" 불일치. 자매 정본 SCP0025 동일 구조).
  //   R3 판정은 grid.selection 존재 여부가 아니라 payload 조립 결과로 한다 — Wijmo FlexGrid 는 itemsSource
  //   바인딩 시 (0,0) 셀을 자동 선택해 selection.row 만으로는 "선택 안 함"을 구분할 수 없다(자매 SCP0013
  //   buildFixPayload/runFix 와 동일 패턴, 실사용 리포트 — 날짜 안 고르고 눌러도 selection 이 항상 존재해
  //   confirm 으로 바로 넘어갔다). 기본 선택 셀은 Prod Plan 행의 날짜(D_/W_) 열이 아니므로 payload 가 0건이다.
  const handleUnfix = async () => {
    // R2 — 권한 게이트(AS-IS CanUpdate → TO-BE SAVE 권한). AS-IS 순서대로 0행 검사(cs:1259)보다 먼저 검사한다(cs:1204).
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    // R1 — 미조회(데이터 없음) 상태면 안내 후 return. AS-IS 는 무반응(cs:1259)이나 TO-BE 는 안내를 유지(사용자 결정).
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SEARCH_FIRST, '_Search before unfix.') });
      return;
    }
    // R3 — 셀 선택(payload 0건 → MSG00134) + confirm(AS-IS 순서: selCells 검사 → confirm → 수집, cs:1311-1319).
    gridRef.current?.finishEditing();
    const payload = buildUnfixPayload(gridRef.current);
    if (payload.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, 'Do you want to delete it?') });
    if (!ok) return;
    unfixCountRef.current = payload.length;
    mutateMain(payload as unknown as MainRow[]);
  };

  // 기간 프리셋 — GetDayRange(weeks) 등가 클라 산정(from=오늘, to=오늘+weeks*7-1). dayjs 로컬(함정12).
  const handlePreset = (weeks: number) => {
    const from = dayjs();
    const to = from.add(weeks * 7 - 1, 'day');
    setSearchCondition({ fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') });
  };

  // 진입 시 조회기간 기본값 = W52 — AS-IS InitControls `dCalendar.InitValue = GetDayRange(PeriodType.W52)`
  //   (cs:430) 재현. 탭 저장값(persisted store)이 이미 있으면 유지, 빈 경우에만 세팅(gap-resolve iter-2).
  useEffect(() => {
    if (!sc.fromYyyymmdd && !sc.toYyyymmdd) handlePreset(PRESET_W52);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 공통 버튼은 전건 hasButton 판정으로 노출을 결정한다(auth-button AUTH-01/AUTH-02).
  //   등록 실측(ora.py 2026-10-09): SCM_ADM_MNU_BTN_MPG_M(SCP0024) = main × {SEARCH, SAVE} 2행뿐이고
  //   INSERT/DELETE 는 미등록 → hasButton 이 false → Insert/Delete 버튼은 그려지지 않는다.
  //   사용자 결정(2026-10-09): SCP0024 는 Insert/Delete 버튼을 노출하지 않는다. AS-IS 도 두 버튼은
  //   NO-OP(InsertRow 빈 본문 cs:1059-1061 / DeleteButton 주석 cs:615-618)이라 기능 손실이 없다.
  //   종전 `() => undefined` 상시 노출(2026-09-26 G20)을 대체한다 — 권한 판정을 타게 되었으므로
  //   나중에 두 버튼을 되살리려면 FE 수정이 아니라 버튼 메타 등록으로 한다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // Save — AS-IS SaveButton 은 NO-OP(주석 cs:636-639). 권한이 있을 때만 노출하고 동작은 무동작 유지(G20).
    save: hasButton('SAVE') ? () => undefined : false,
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
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
        <ProductionPlanFixForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProductionPlanFix'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={
          // btnUnfix — 조회조건 우측 화면 고유 액션 버튼(design 01 §1).
          //   전용 Unfix BTN_CD 는 미등록이라 SAVE 권한으로 대리 게이트한다(자매 SCP0013/BOD 선례,
          //   05_register.sql §3 주석). 권한이 없으면 클릭 후 alert 이 아니라 버튼 자체를 그리지 않는다
          //   (AUTH-02 — 권한 없는 버튼은 비활성 표시 없이 그리지 않는다).
          hasButton('SAVE')
            ? [{ label: t(LBL.UNFIX, '_Unfix'), action: () => void handleUnfix() }]
            : []
        }
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanFixGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          fromYyyymmdd={sc.fromYyyymmdd}
          toYyyymmdd={sc.toYyyymmdd}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Material 검색 — AS-IS cs:650 new SCM0002_MaterialByDivisionPopup (btnItemId → txtItemId, design 02 §4.6).
          ItemByDivisionModal(DM0002)과 SP·컬럼이 다르므로 바꿔 쓰지 않는다. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => itemIds && setSearchCondition({ itemId: itemIds })}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: sc.operationGroupId,
          itemId: sc.itemId,
          scpModuleType: MENU_ID,
        }}
      />
    </>
  );
};
