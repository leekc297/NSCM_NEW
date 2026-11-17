import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useQueryClient } from '@tanstack/react-query';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { WarehouseCapacityForm } from './components/WarehouseCapacityForm';
import { WarehouseCapacityGrid } from './components/WarehouseCapacityGrid';
import { WarehouseItemMappingGrid } from './components/WarehouseItemMappingGrid';
import { useWarehouseCapacityStore } from './useWarehouseCapacityStore';
import { submitItemMappingSave, submitMainSave } from './utils/warehouseCapacity.saveRequest';
import { findPeriodError } from './utils/warehouseCapacityEditLock';
import { ADMIN_SHEET_NAME, COMBO, MENU_ID, MSG, SHEETS } from './warehouse-capacity.constants';
import type { ItemMappingRow, MainRow } from './warehouse-capacity.types';
import styles from './WarehouseCapacity.module.scss';

// AS-IS GSCM.SCP.Master.UIL SCP0133_WarehouseCapacity — spdMain 2시트(Warehouse Capacity/
//   Warehouse Item Mapping). 격리 세션(GSCM 원본 미확보 + AS-IS MSSQL 접속 불가) — design 00~03
//   3중 ERROR, 확인 필요 15건+ 존재(design 02 §7). 이 activity 는 확정된 부분만 실동작으로
//   배선하고, 미확정 부분은 안전한 기본값(전량 조회 후 클라 필터, 편집 화이트리스트 보수적 적용)
//   으로 배선하되 주석/impl-notes 에 확인 필요임을 명시한다(anti-simplification §1).
//
// 편집제어: AS-IS SwitchLock(EditButton, design 01 §2 #2) "수정 모드" 토글 어포던스는 TO-BE 미이식
//   (전 화면 공통 결정, `.atlas/memory/editbutton-toggle-not-ported.md`). 조회 직후에도 바로 편집
//   가능하며, 항상 잠겨야 하는 컬럼만 `warehouseCapacityEditLock.isCellEditable` 화이트리스트로
//   판정한다.
//
// Warehouse Item Mapping 시트는 전용 GET/SAVE SP(P_SCP0133_GET/SAVE_WAREHOUSE_ITEM_MAPPING)가
// PKG_SCP0133 에 배포돼 있어(gap-resolve iter-2 실측) main 시트와 동일하게 useTabProcQuery(조회)/
// useProcMutation(저장)으로 배선한다(A2/A3 해소). 두 시트 조회조건은 동일 9파라미터다.
export const WarehouseCapacity = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { saveWithValidation } = useSaveWithValidation();
  // admin 버튼 권한(SCM_ADM_USER_GR_MNU_BTN_MPG_M) — SCP0133 은 design 01 DB 실측상 미등록
  //   상태였다(0 rows). 05_register.sql 로 등록을 시도하되, 미등록 상태에서는 hasButton 이 전부
  //   false 를 반환해 버튼이 노출되지 않는 것이 정상이다(CLAUDE.md §2 체크리스트, 추측 우회 금지).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid<MainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const trackerRef = useRef<EditTracker<MainRow>>();

  const itemMappingGridRef = useRef<FlexGrid>();
  const itemMappingGridFilterRef = useRef<FlexGridFilter>();
  const itemMappingTrackerRef = useRef<EditTracker>();

  const sc = useWarehouseCapacityStore(s => s.searchCondition);
  const setSearchCondition = useWarehouseCapacityStore(s => s.setSearchCondition);
  const filters = useWarehouseCapacityStore(s => s.filters);
  const setFilter = useWarehouseCapacityStore(s => s.setFilter);
  const openSearchArea = useWarehouseCapacityStore(s => s.openSearchArea);
  const setOpenSearchArea = useWarehouseCapacityStore(s => s.setOpenSearchArea);
  const staticColumns = useWarehouseCapacityStore(s => s.staticColumns);
  const fetchStaticColumns = useWarehouseCapacityStore(s => s.fetchStaticColumns);
  const restoreSearchCondition = useWarehouseCapacityStore(s => s.restoreSearchCondition);
  const initialized = useWarehouseCapacityStore(s => s.initialized);

  const [activeSheet, setActiveSheet] = useState(0);
  const [openItem, setOpenItem] = useState(false);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const queryClient = useQueryClient();
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  // 저장 — SCP 표준 util(컬럼별 '^'-fold + POST + false-success 가드)로 저장하고, 성공 시 [tabId]
  //   무효화로 활성 조회를 재조회한다(조회 전이면 대상 없음 = no-op, AS-IS 진입 자동조회 없음과 동형).
  //   공용 useProcMutation({data:[rows]}) 은 이 SP 계약(컬럼별 CLOB)에서 전 파라미터 NULL 바인딩 →
  //   저장 no-op 이라 쓰지 않는다(메모리 save-proc-per-column-caret-fold-fe).
  const persistSave = async (sheet: SHEETS, saveRows: Record<string, unknown>[]) => {
    const result =
      sheet === SHEETS.MAIN
        ? await submitMainSave(saveRows, sesUserId)
        : await submitItemMappingSave(saveRows, sesUserId);
    if (!result.ok) {
      void setAlert({ type: 'alert', content: result.message ?? t('MSG00003', '_저장에 실패하였습니다.') });
      return;
    }
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    // 저장 성공 후 EditTracker clear — 안 하면 hasChanges()가 계속 true 라 행이 dirty(노란색)로 남고
    //   재조회/닫기 시 dirty 가드(MSG00703/00704 '작업중인 데이터가 있습니다')가 뜬다(opt-capa
    //   afterSaveSuccess 패턴). 이어지는 invalidate 재조회가 clean 행으로 그리드를 리바인드한다.
    const tracker = sheet === SHEETS.MAIN ? trackerRef.current : itemMappingTrackerRef.current;
    tracker?.clearChanges();
    void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  // Warehouse Item Mapping 시트 — 전용 GET/SAVE SP 배선(A2/A3). 조회조건은 main 과 동일 9파라미터.
  const { data: itemMappingData } = useTabProcQuery<MENU_ID, SHEETS.ITEM_MAPPING>({
    menuId: MENU_ID,
    sheetName: SHEETS.ITEM_MAPPING,
    tabId,
    filters: filters[SHEETS.ITEM_MAPPING],
    enabled: !!filters[SHEETS.ITEM_MAPPING],
  });
  const itemMappingRows = useMemo<ItemMappingRow[]>(() => itemMappingData?.o_rc1 ?? [], [itemMappingData]);

  // Item Mapping 신규/수정행의 숨김 필수 SCM_SITE_ID/STAGE 자동파생 원천 — AS-IS dtWarehouseAll
  //   (GetSearchInfo #4) 대응. 'Warehose' 콤보가 (DIVISION_ID, OPMZ_PLAN_GR_ID, WH_NM=CODE,
  //   SCM_SITE_ID, STAGE)를 반환한다(SCM_ADM_CMBO_SQL_M 실측, 전역 조회 — division 파라미터 없음).
  //   WH Name 선택 시 이 맵으로 Site/Stage 를 채운다(AS-IS SpdMain_ComboSelChange .cs:1298-1314).
  //   두 컬럼은 NOT NULL+INPUT_TP_CD=M 인데 VISIBLE_FLAG=N(숨김)이라 사용자가 직접 넣을 수 없다.
  const [warehouseCombo] = useTabComboQueries({ filters: [COMBO.WAREHOUSE] });
  const warehouseSiteStage = useMemo(() => {
    const map = new Map<string, { site: string; stage: string }>();
    for (const w of (warehouseCombo ?? []) as unknown as Record<string, string>[]) {
      const key = `${w.DIVISION_ID ?? ''}|${w.OPMZ_PLAN_GR_ID ?? ''}|${w.CODE ?? w.WH_NM ?? ''}`;
      // 같은 창고가 여러 (site,stage)로 중복될 수 있어 AS-IS 처럼 첫 매치를 쓴다(dtWarehouseTemp.Rows[0]).
      if (!map.has(key)) map.set(key, { site: w.SCM_SITE_ID ?? '', stage: w.STAGE ?? '' });
    }
    return map;
  }, [warehouseCombo]);

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // F6 로 저장한 조회조건을 진입 시 1회 복원한다(store 비영속 — 새로고침 생존은 이 GET 뿐).
    //   복원은 searchCondition 만 채우고 filters 는 비운 채라 자동조회 없이 Search 대기 상태가 된다.
    void restoreSearchCondition();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 성공 시 EditTracker clear — 새 데이터가 들어오면 이전 편집 추적을 비운다(opt-capa 패턴).
  //   저장 후 재조회로 clean 행이 바인딩될 때 dirty 상태가 확실히 해제돼 dirty 가드 오작동을 막는다.
  useEffect(() => {
    if (!data) return;
    trackerRef.current?.clearChanges();
     
  }, [data]);
  useEffect(() => {
    if (!itemMappingData) return;
    itemMappingTrackerRef.current?.clearChanges();
     
  }, [itemMappingData]);

  // design 02 §4 필수조건(Division/PlanGroup/Warehouse/Site/Stage/From/To 7항목, AS-IS MSG00001
  //   의도 — TO-BE 문구는 MSG00013 로 재매핑, Hook #114). 편집중 재조회는 MSG00703 로 경고
  //   (AS-IS MSG00046 의도 재매핑).
  const handleSearch = () => {
    // AS-IS 조회 필수조건은 라벨 '*' 기준 Div·Period 둘뿐이다(Designer 실측: "Division*"/"Period*"
    //   에만 '*', Plan Group/Site/Stage/Warehouse 는 '*' 없음 — checkRequiredOfSearch 도 이 둘만 막음).
    //   design 02 의 7항목 필수는 신규행 Insert 검증(SaveData_WhCapa, MSG00001)이지 조회 필수가 아니다.
    const requiredMissing = !sc.divisionId || !sc.fromYyyymmdd || !sc.toYyyymmdd;
    if (requiredMissing) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Please enter the required fields.') });
      return;
    }
    if (sc.fromYyyymmdd > sc.toYyyymmdd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INVALID_PERIOD, '_The start date can not be later than the end date.'),
      });
      return;
    }
    if (trackerRef.current?.hasChanges() || itemMappingTrackerRef.current?.hasChanges()) {
      void setAlert({
        type: 'alert',
        content: t(MSG.UNSAVED_RESEARCH, '_There are unsaved changes. Do you want to search again?'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // InsertButton — AS-IS `Insert_Row()`(.cs:695-727) 신규행 기본값 재현. 두 시트 공통 DIVISION_ID
  //   + VALID_YN='Y'; Item Mapping 시트는 추가로 STOR_PER='1'(.cs:717). gap-resolve iter-2(신규행
  //   초기값 축): AS-IS 원본 재확보로 기본값이 DIVISION_ID 하나가 아님을 확정 — 전건 반영.
  //   Insert 표준 가드(ActiveRowIndex<0 등)는 AS-IS 자체에 없음이 확정돼(gap-resolve iter-1 G16)
  //   grid 존재만 확인한다.
  const handleInsert = () => {
    if (activeSheet === 0) {
      if (!gridRef.current) return;
      GridAction.addRow(gridRef.current, {
        DIVISION_ID: sc.divisionId,
        VALID_YN: 'Y',
      });
    } else {
      if (!itemMappingGridRef.current) return;
      GridAction.addRow(itemMappingGridRef.current, {
        DIVISION_ID: sc.divisionId,
        VALID_YN: 'Y',
        STOR_PER: '1',
      });
    }
  };

  // DeleteButton — 선택 행 없으면 무동작(design 01 §2 #3, hasMessage=false). 신규행은 뷰에서 제거,
  //   저장행은 CRUD_TYPE='D' 마킹 → Save 시 SP 'D' 분기가 물리삭제(PKG_SCP0133 BODY:593/861, PRE_*
  //   키로 DELETE)한다. AS-IS DeleteButton→siMain.Delete()(저장행도 삭제) 재현.
  //   deleteOnlyNew(두번째 인자)는 쓰지 않는다 — 'D' 는 물리삭제라 저장행도 마킹해야 한다(design R-17).
  const handleDelete = () => {
    const grid = activeSheet === 0 ? gridRef.current : itemMappingGridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  // SaveButton — 두 시트 모두 실동작 배선(A3: ItemMapping SAVE SP 계약 확정). activeSheet 로 명시
  //   분기해 각 시트의 dirty(CRUD_TYPE) 행만 메타 필수검증(saveWithValidation, INPUT_TP_CD M/IM)을
  //   거쳐 해당 시트 전용 SAVE SP 로 전송한다.
  const handleSave = () => {
    const grid = activeSheet === 0 ? gridRef.current : itemMappingGridRef.current;
    grid?.finishEditing();
    const src = grid?.collectionView?.sourceCollection ?? [];
    const saveData = src.filter((row: { CRUD_TYPE?: string }) => row.CRUD_TYPE);
    if (saveData.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    if (activeSheet === 0) {
      // S3/S4(07_validation-audit) — WhCapa 저장행 FROM/TO 날짜 검증. AS-IS SaveData_WhCapa 는
      //   DateTime.ParseExact(형식) + dtFrom>dtTo(대소)를 저장 직전 행 단위로 막는다. 공통 필수검증
      //   (saveWithValidation) 앞에서 먼저 검사한다(빈값 필수는 saveWithValidation 소관).
      const periodError = findPeriodError(saveData as Record<string, unknown>[]);
      if (periodError === 'format') {
        void setAlert({ type: 'alert', content: t(MSG.INVALID_DATE_FORMAT, '_Invalid date format. (YYYYMMDD)') });
        return;
      }
      if (periodError === 'order') {
        void setAlert({
          type: 'alert',
          content: t(MSG.INVALID_PERIOD, '_The start date can not be later than the end date.'),
        });
        return;
      }
      // 저장은 util(submitMainSave)이 FROM/TO 를 YYYYMMDD 로 환원(ymd8)해 보낸다 — FPDateText 마스크
      //   'yyyy-MM-dd' 를 그대로 저장하면 조회 GET 의 TO_DATE(..,'YYYYMMDD') 가 ORA-01858 로 깨진다.
      saveWithValidation(saveData, staticColumns.main, saveRows =>
        void persistSave(SHEETS.MAIN, saveRows as Record<string, unknown>[])
      );
    } else {
      // SCM_SITE_ID/STAGE 는 WH Name 선택 시 자동파생되는 숨김 필수 컬럼이라 saveWithValidation
      //   (visible=false 제외)이 못 잡는다. 파생 실패(그 조합의 창고 미존재)로 비어 있으면 저장 시
      //   ORA-01400(NOT NULL)이 나므로, 그 전에 명확한 필수 메시지로 막는다(AS-IS SaveData_ItemMapping
      //   공백체크 MSG00001 의도 — TO-BE 는 MSG00013 재매핑). WH Name 과 Plan Group 조합이 유효한
      //   창고여야 Site/Stage 가 채워진다.
      const missingSiteStage = (saveData as Record<string, unknown>[]).some(
        r => r.CRUD_TYPE !== 'D' && (!r.SCM_SITE_ID || !r.STAGE)
      );
      if (missingSiteStage) {
        void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Please enter the required fields.') });
        return;
      }
      saveWithValidation(saveData, staticColumns.itemMapping, saveRows =>
        void persistSave(SHEETS.ITEM_MAPPING, saveRows as Record<string, unknown>[])
      );
    }
  };

  // 편집중 시트 전환 가드(validation C2, AS-IS spdSub_ActiveSheetChanging .cs:1458-1466). 떠나는
  //   시트에 미저장 변경(CRUD_TYPE)이 있으면 전환을 막고 경고한다. AS-IS 는 "편집 중(IsLock==false)"
  //   을 조건으로 하지만 TO-BE 는 EditButton 토글 미이식으로 상시 편집 가능이라, 그 의도(미저장 변경
  //   유실 방지)를 dirty 행 기준으로 재표현한다(Workbench R10 과 동형). {0}=떠나는 시트명.
  //   `TabWrapper` 가 `setActiveTabIndex` 를 무조건 호출하므로 veto 는 이 함수 안에만 둔다(공용 Tab 미수정).
  const handleTabChange = (nextIndex: number) => {
    const leavingGrid = activeSheet === 0 ? gridRef.current : itemMappingGridRef.current;
    leavingGrid?.finishEditing();
    const src = leavingGrid?.collectionView?.sourceCollection ?? [];
    const dirty = src.some((row: { CRUD_TYPE?: string }) => row.CRUD_TYPE);
    if (dirty) {
      const sheetName = activeSheet === 0 ? ADMIN_SHEET_NAME.MAIN : ADMIN_SHEET_NAME.ITEM_MAPPING;
      void setAlert({
        type: 'alert',
        content: t(MSG.SHEET_CHANGE_BLOCKED, '_You are modifying {0} and can not change the sheet.').replace(
          '{0}',
          sheetName
        ),
      });
      return;
    }
    setActiveSheet(nextIndex);
  };

  // admin 미등록(SCM_ADM_MNU_BTN_MPG_M 0 rows, design 01 DB 실측) 이면 hasButton 이 전부 false 를
  //   반환해 버튼이 노출되지 않는다 — 05_register.sql 적용 후 실제 동작한다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
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
        <WarehouseCapacityForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          activeSheet={activeSheet}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={activeSheet === 0 ? gridRef : itemMappingGridRef}
        gridFilter={activeSheet === 0 ? gridFilterRef : itemMappingGridFilterRef}
        dataCount={activeSheet === 0 ? rows.length : itemMappingRows.length}
        excelFileName='WarehouseCapacity'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.tableWrapper}>
        <TabWrapper persist activeTabIndex={activeSheet} setActiveTabIndex={handleTabChange}>
          {/* 탭 제목 = 시트명 literal. gap-resolve iter-2(A6): 기존 t('LBL00641')는 ora.py 실측상
              'Division', t('LBL01142')는 'Item' 으로 해석돼 탭 제목이 시트명과 어긋났다. AS-IS
              SpdSheet 는 "Warehouse Capacity"/"Warehouse Item Mapping" literal 을 쓰므로(.cs:99-101)
              DB 메타 SHEET_NAME 과 동일한 ADMIN_SHEET_NAME 상수를 그대로 쓴다(전용 라벨 미채번). */}
          <TabItem label={ADMIN_SHEET_NAME.MAIN}>
            <WarehouseCapacityGrid
              rows={rows}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              editTrackerRef={trackerRef}
              adminColumns={staticColumns.main}
              divisionId={sc.divisionId}
              onFocus={() => undefined}
            />
          </TabItem>
          <TabItem label={ADMIN_SHEET_NAME.ITEM_MAPPING}>
            <WarehouseItemMappingGrid
              rows={itemMappingRows}
              gridRef={itemMappingGridRef}
              gridFilterRef={itemMappingGridFilterRef}
              editTrackerRef={itemMappingTrackerRef}
              adminColumns={staticColumns.itemMapping}
              divisionId={sc.divisionId}
              warehouseSiteStage={warehouseSiteStage}
              onFocus={() => undefined}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* 조회영역 Item ID 팝업 — MaterialByDivisionModal(COM0013, design 02 §4.6 확정). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, scpModuleType: 'SCP0133' }}
      />
    </>
  );
};
