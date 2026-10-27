import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ItemByDivisionModal } from './components/modals/ItemByDivisionModal';
import { ShipmentMasterElectrodeForm } from './components/ShipmentMasterElectrodeForm';
import { ShipmentMasterElectrodeGrid } from './components/ShipmentMasterElectrodeGrid';
import { useShipmentMasterElectrodeValidation } from './hooks/useShipmentMasterElectrodeValidation';
import {
  EDIT_EDITABLE_COLUMNS,
  LBL,
  MAIN_COLUMNS,
  MENU_ID,
  MSG,
  POPUP_FILL_MAP,
  REQUIRED_COLUMNS,
  SHEETS,
} from './shipment-master-electrode.constants';
import type { MainRow, PopupRow } from './shipment-master-electrode.types';
import styles from './ShipmentMasterElectrode.module.scss';
import { useShipmentMasterElectrodeStore } from './useShipmentMasterElectrodeStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 필수(*) 컬럼 -> 표시 라벨(헤더에서 후행 '*' 제거). MSG00429 "{0} value is required." 의 {0}.
const REQUIRED_LABEL: Record<string, string> = MAIN_COLUMNS.reduce<Record<string, string>>(
  (map, col) => {
    map[col.key] = col.header.replace(/\*$/, '');
    return map;
  },
  {}
);

// 필수(*) 빈값 검사 — 공용 useSaveWithValidation.isEditableForRow 가 INPUT_TP_CD='S'(SEARCH_ONLY) 를
//   편집불가로 보고 필수검사를 통째로 건너뛰므로(runtime-parity H1 / SCP0020 재발), 화면 편집모델(editLock)
//   기준으로 직접 검사한다. 신규행('I')=REQUIRED_COLUMNS 전건, 기존행('M')=Edit 편집가능 필수칸
//   (REQUIRED_COLUMNS ∩ EDIT_EDITABLE_COLUMNS — 식별칸 DIVISION/PLANT_SITE/MATERIAL 은 기존행 잠금·GET 채움).
//   첫 누락 컬럼 라벨 반환(없으면 null). design 03 §5#2 / convert-core §2.4.
const findMissingRequired = (dirty: Record<string, unknown>[]): string | null => {
  for (const row of dirty) {
    const isNew = str(row.CRUD_TYPE) === 'I';
    const cols = isNew
      ? REQUIRED_COLUMNS
      : REQUIRED_COLUMNS.filter(c => EDIT_EDITABLE_COLUMNS.includes(c));
    for (const col of cols) {
      if (str(row[col]).trim() === '') return REQUIRED_LABEL[col] ?? col;
    }
  }
  return null;
};

// AS-IS GSCM.SSP.Plan.UIL SSP0024_ShipmentMasterElectrode — 단일 그리드(spdMain) 전극 출하 Master.
//   설계: .atlas/gscm-design/SSP0024/design/00~03, 07. 상세 매핑: __asis-mapping__.md.
//   편집 상태기계(design 01 R1/R2, 03 §3.1): 조회=전체 lock(뷰) -> Edit(권한체크 SSP0002 통과)=기존행 9칸 편집
//     / Insert=신규행 지정칸 편집 -> Save 성공 후 뷰 복귀. 신규행('I')만 삭제.
//   SP 미배포(goal.md ②): PKG_SSP0024·PKG_SSP0002 -> 조회/저장/권한/팝업 런타임 미완(convert-sp 후속).
export const ShipmentMasterElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkEditPermission, findDuplicateKey } = useShipmentMasterElectrodeValidation();

  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const savingRef = useRef(false);
  // MATERIAL 셀팝업 대상 신규행 기억 — 팝업 확정 시 이 행에 10칸 채움.
  const materialCellRowRef = useRef<Record<string, unknown> | null>(null);

  const sc = useShipmentMasterElectrodeStore(s => s.searchCondition);
  const setSearchCondition = useShipmentMasterElectrodeStore(s => s.setSearchCondition);
  const filters = useShipmentMasterElectrodeStore(s => s.filters);
  const setFilter = useShipmentMasterElectrodeStore(s => s.setFilter);
  const clearFilters = useShipmentMasterElectrodeStore(s => s.clearFilters);
  const openSearchArea = useShipmentMasterElectrodeStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentMasterElectrodeStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentMasterElectrodeStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentMasterElectrodeStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = useShipmentMasterElectrodeStore(s => s.restoreSearchConditions);
  const initialized = useShipmentMasterElectrodeStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 편집 가능 여부 — 2026-09-23 사용자 결정: **Edit 버튼을 없애고 화면 진입이 곧 편집 모드**다.
  //   AS-IS 는 EditButton 클릭 시에만 SSP Planner 권한을 확인했으나(cs:240~250), 버튼이 사라지면 그 체크를
  //   부를 곳이 없어지므로 **마운트 시 1회** 확인하고 결과를 편집 가능 여부로 쓴다. 권한이 없으면 수정 자체를
  //   막는다(사용자 지시). 편집 잠금 자체는 기존 editLock 이 그대로 담당하고, 이 값이 그 게이트가 된다.
  //   초기값 false = 체크 응답 전까지는 잠금(권한 확인 전 편집 허용 금지).
  const [isEditMode, setIsEditMode] = useState(false);
  const [openMaterial, setOpenMaterial] = useState(false);
  const [openModel, setOpenModel] = useState(false);
  const [openMaterialCell, setOpenMaterialCell] = useState(false);

  const { data, refetch, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // F6 저장 조회조건 복원(1회) — searchCondition 만 패치하므로 filters 불변 → 진입 자동조회 아님.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 진입 시 SSP Planner 권한 확인(AS-IS GetSSPUserCheck / SP SSP0002, cs:877~899).
  //   통과하면 편집 가능, 아니면 편집 차단. 거부(반환 0건)일 때만 MSG01261 을 띄운다 —
  //   `available=false`(PKG_SSP0002 미배포·호출 실패)는 권한 거부가 아니라 환경 문제라 잘못된 문구를
  //   띄우지 않고 편집만 막는다(false-success 방지, convert-core §2.4).
  useEffect(() => {
    let alive = true;
    void (async () => {
      const res = await checkEditPermission();
      if (!alive) return;
      setIsEditMode(res.ok);
      if (res.ok || !res.available) return;
      void setAlert({
        type: 'alert',
        content: t(MSG.EDIT_NO_PERMISSION, {
          defaultValue: 'This user does not have permission to the SSP Planner. User ID : {0}',
          0: res.userId,
        }),
      });
    })();
    return () => {
      alive = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 확정(조회된) division — Insert 신규행 기본값 기준(CommonCheckList [화면별] "Insert 확정 searchParams").
  const confirmedDivision = str(
    (filters[SHEETS.MAIN] as { divisionId?: string } | undefined)?.divisionId
  );

  const handleSearch = () => {
    // Division 필수 (design 02 §6, checkRequiredOfSearch cs:294).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    // 조회해도 편집 가능 상태는 유지한다 — 진입이 곧 편집 모드다(2026-09-23 사용자 결정).
    //   이 값을 바꾸는 것은 진입 시 권한 판정뿐이다.
    setFilter();
    void fetchStaticColumns();
  };

  // Insert — 신규행 추가(design 03 §3.4 + convert-core §2.4). 확정 division 필수(조회전 undefined 회피).
  //   AS-IS InsertButton: 조회 전/division 미확정이면 삽입 금지. 신규행 DIVISION_ID = 확정 searchParams division.
  //   선행 가드(gap-resolve iter-1 G4): AS-IS InsertRow 는 `siMain.IsLock(sheetName)==false` 일 때만 동작한다
  //     (cs:365). 시트 lock 초기값은 true(SpreadInfo.cs:412 `ht.Add(sSheetName, true)`)이고 EditButton 의
  //     SwitchLock(cs:253)만 이를 푼다 = **Edit(SSP Planner 권한체크 통과) 전에는 Insert 불가**. AS-IS 는
  //     메시지 없이 무동작이라 동일하게 조용히 반환한다.
  const handleInsert = () => {
    const g = gridRef.current;
    if (!g) return;
    if (!isEditMode) return;
    if (!confirmedDivision) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    const newRow: Record<string, string> = {
      CRUD_TYPE: 'I',
      DIVISION_ID: confirmedDivision,
      PLANT_SITE_CODE: '',
      PLANT_SITE_ID: '',
      MATERIAL_ID: '',
      MODEL_ID: '',
      CELL_TYPE: '',
      NICK_NAME: '',
      ELECTRODE_TYPE: '',
      ITEM_UOM: '',
      POST_OPER: '',
      POST_OPER_LT: '',
      UOM_CONVERT_IN_TACT_TIME: '',
      PC_ROLL_LENGTH: '',
      PACKAGE_TYPE_CODE: '',
      STEELCRATE_PER_CUT: '',
      BOX_PER_CUT: '',
      STEELRACK_PER_CUT: '',
      DOM_EXP_TYPE_CODE: '',
      BUILDING: '',
      BUILDING_DESC: '',
      REMARKS: '',
    };
    GridAction.addRow(g, newRow as Partial<WijmoRowItem>, 'above', true);
  };

  // Delete — 신규행('I')만 즉시 제거. 기존행 삭제 불가(design 03 §3.4 cs:272).
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems?.[0] as Record<string, unknown> | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({
        type: 'alert',
        content: t(LBL.ONLY_NEW_ROWS_DELETABLE, '_Only new rows can be deleted.'),
      });
      return;
    }
    const source = g.collectionView?.sourceCollection ?? [];
    for (let i = source.length - 1; i >= 0; i -= 1) {
      if (source[i] === sel) source.splice(i, 1);
    }
    g.collectionView?.refresh();
  };

  // Material/Model 조회조건 팝업 확정 -> 텍스트 채움(다건 콤마). design 02 §4.6.
  const handleMaterialSelected = (picked: PopupRow[]) => {
    const ids = picked.map(r => str(r.MATERIAL_ID)).filter(Boolean).join(',');
    if (ids) setSearchCondition({ materialId: ids });
  };
  const handleModelSelected = (picked: PopupRow[]) => {
    const ids = picked.map(r => str(r.MODEL_ID)).filter(Boolean).join(',');
    if (ids) setSearchCondition({ modelId: ids });
  };

  // MATERIAL 셀팝업 확정 -> 신규행 10칸 일괄 채움(design 03 §3.2 cs:570~579).
  const handleMaterialCellSelected = (picked: PopupRow[]) => {
    const row = materialCellRowRef.current;
    const first = picked[0];
    if (!row || !first) return;
    Object.entries(POPUP_FILL_MAP).forEach(([col, prop]) => {
      const value = str((first as Record<string, unknown>)[prop]);
      const prev = row[col];
      if (str(prev) === value) return;
      editTrackerRef.current?.storeChange(row as never, col, prev as never, value as never);
      row[col] = value;
    });
    gridRef.current?.invalidate();
    materialCellRowRef.current = null;
  };

  const handleMaterialCellDblClick = (row: Record<string, unknown>) => {
    materialCellRowRef.current = row;
    setOpenMaterialCell(true);
  };

  // Save — 변경행(I/M) ^-delim CLOB -> SAVE SP (design 03 §4.3, DMF0020/SSP0014 handleSave 경로).
  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      const g = gridRef.current;
      const allRows = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
      // 중복(DIVISION_ID + PLANT_SITE_CODE + MATERIAL_ID) 저장차단 MSG00060(design 03 §3.4 cs:781~811).
      if (findDuplicateKey(dirty, allRows)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.DUP_KEY, '_Duplicate key exists.'),
        });
        return;
      }

      // 16 파라미터 ^-delim 누적(design 03 §4.3). 표시전용 10칸(MODEL_ID/CELL_TYPE/...)은 미전송.
      //   p_factory_id = **FACTORY_ID**(= BUILDING 셀콤보의 CODE = 행 BUILDING 값). PLANT_SITE_ID/POST_OPER_LT 등 미전송.
      //   gap-resolve iter-1 G3 교정: AS-IS 는 CODE=FACTORY_NAME / NAME=FACTORY_ID 인 콤보
      //     (CMBO BuildingForShipMasterElec 실측)를 써서 GetSelectedListName(dt, GetValue(BUILDING), "NAME")
      //     = FACTORY_ID 를 보냈다(cs:433,446). TO-BE 콤보(BuildingByPlantSite 계열)는 CODE=FACTORY_ID /
      //     NAME=FACTORY_NAME 라 셀 값 자체가 곧 FACTORY_ID 다. 직전 구현은 BUILDING_DESC(=FACTORY_NAME)를
      //     보내 실 저장 컬럼과 어긋났다 — SSP_MST_SHIP_MASTER_EE.FACTORY_ID 실데이터는 E2/E3/E4/ALL 형태
      //     (FACTORY_ID, ora.py 실측 705행)로 FACTORY_NAME(NJ5_E 형태)이 아니다.
      const acc: Record<string, string[]> = {
        activeFlag: [],
        divisionId: [],
        plantSiteCode: [],
        materialId: [],
        electrodePostOperCode: [],
        pcRollLength: [],
        packageTypeCode: [],
        steelcratePerCut: [],
        boxPerCut: [],
        steelrackPerCut: [],
        domExpTypeCode: [],
        factoryId: [],
        remarks: [],
      };
      for (const r of dirty) {
        acc.activeFlag.push(str(r.CRUD_TYPE) || 'M');
        acc.divisionId.push(str(r.DIVISION_ID));
        acc.plantSiteCode.push(str(r.PLANT_SITE_CODE));
        acc.materialId.push(str(r.MATERIAL_ID));
        acc.electrodePostOperCode.push(str(r.POST_OPER));
        acc.pcRollLength.push(str(r.PC_ROLL_LENGTH));
        acc.packageTypeCode.push(str(r.PACKAGE_TYPE_CODE));
        acc.steelcratePerCut.push(str(r.STEELCRATE_PER_CUT));
        acc.boxPerCut.push(str(r.BOX_PER_CUT));
        acc.steelrackPerCut.push(str(r.STEELRACK_PER_CUT));
        acc.domExpTypeCode.push(str(r.DOM_EXP_TYPE_CODE));
        acc.factoryId.push(str(r.BUILDING)); // BUILDING 셀 값 = FACTORY_ID(콤보 CODE)
        acc.remarks.push(str(r.REMARKS));
      }
      const payload: Record<string, string> = {};
      for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');
      // createId = 세션 사용자 단일 스칼라(감사키 회피, nscm-patterns §5-11). SP 가 CREATED_BY/LAST_UPDATED_BY 처리.
      payload.createId = sessionUserId ?? '';

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
          payload
        );
        // false-success 차단(nscm-patterns §5-10).
        if (res.status >= 400 || Number(res.data?.code)) {
          const reason =
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.SAVE_FAIL, '_Failed to save.');
          void setAlert({ type: 'alert', content: reason });
          return; // 편집 유지 — 수정 후 재저장.
        }
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.', 0: dirty.length }),
        });
        editTrackerRef.current?.clearChanges();
        // 저장 후에도 편집 가능 상태 유지(진입=편집 모드) — 재조회만 한다.
        void refetch?.();
      } catch (e) {
        const msg = e instanceof Error ? e.message : t(MSG.SAVE_FAIL, '_Failed to save.');
        void setAlert({ type: 'alert', content: msg });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleSave = () => {
    // 선행 가드(gap-resolve iter-1 G4): AS-IS SaveData 도 `IsLock(sheetName)==false` 일 때만 저장한다
    //   (cs:397) — Edit 진입(권한체크 통과) 전 저장 금지. AS-IS 는 메시지 없이 무동작.
    if (!isEditMode) return;
    const g = gridRef.current;
    g?.finishEditing();
    const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes to save.') });
      return;
    }
    // 필수(*) 빈값 차단 — INPUT_TP_CD 전건 'S' 라 공용 useSaveWithValidation 이 필수검사를 건너뛴다
    //   (runtime-parity H1). 화면 editLock 기준 명시 검사로 차단(design 03 §5#2, convert-core §2.4).
    const missing = findMissingRequired(dirty);
    if (missing) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, { defaultValue: '{0} value is required.', 0: missing }),
      });
      return;
    }
    // 공통 필수검증(useSaveWithValidation) — 표준 저장 경로 유지(admin 메타가 M/IM 로 갱신되면 함께 발동).
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], doSave);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
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
        <ShipmentMasterElectrodeForm
          onSearch={handleSearch}
          onMaterialSearch={() => setOpenMaterial(true)}
          onModelSearch={() => setOpenModel(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentMasterElectrode'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      {/* Edit 버튼 없음 — 2026-09-23 사용자 결정. 화면 진입이 곧 편집 모드이고, AS-IS 가 Edit 클릭 시
          수행하던 SSP Planner 권한체크는 위 마운트 effect 로 옮겼다. admin 버튼 메타의 EDIT 행은
          그대로 두되 화면은 쓰지 않는다(USER_CHECK 행은 그 권한체크 API 라우팅으로 계속 쓰인다). */}

      <div className={styles.gridWrapper}>
        {/* 조회 중 로딩 — AS-IS FindData 의 ProgressForm(cs:291,298,349) 등가(design 01 R4).
            직전 구현은 "공용 isFetching 으로 대체"라고 적어 두고 실제로는 아무 표시가 없었다(A08). */}
        <ProgressIndicator
          shape='circular'
          apprearance='infinite'
          open={isFetching}
          placement='parent'
        />
        <ShipmentMasterElectrodeGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          division={confirmedDivision || sc.divisionId}
          isEditMode={isEditMode}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onMaterialCellDblClick={handleMaterialCellDblClick}
          onFocus={() => undefined}
        />
      </div>

      {/* 조회조건 Material 검색 팝업 (SSP0024 전용 — 다중 선택, MaterialId 채움). */}
      <ItemByDivisionModal
        open={openMaterial}
        modalClose={() => setOpenMaterial(false)}
        setSelectedValue={handleMaterialSelected}
        preSearchParams={{
          divisionId: sc.divisionId,
          plantSiteId: sc.scmSiteIds.join(','),
          materialId: sc.materialId,
        }}
        callFromCell={false}
      />

      {/* 조회조건 Model 검색 팝업 (SSP0024 전용 — 다중 선택, ModelId 채움). */}
      <ItemByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={handleModelSelected}
        preSearchParams={{
          divisionId: sc.divisionId,
          plantSiteId: sc.scmSiteIds.join(','),
          materialId: sc.materialId,
        }}
        callFromCell={false}
      />

      {/* 그리드 MATERIAL 셀 팝업 (단건 선택 -> 신규행 10칸 일괄 채움). design 03 §3.2. */}
      <ItemByDivisionModal
        open={openMaterialCell}
        modalClose={() => setOpenMaterialCell(false)}
        setSelectedValue={handleMaterialCellSelected}
        preSearchParams={{
          divisionId: str(materialCellRowRef.current?.DIVISION_ID),
          plantSiteId: str(materialCellRowRef.current?.PLANT_SITE_CODE),
          // AS-IS 는 행의 MATERIAL_ID 도 선조회값으로 넘긴다(cs:539,563) — 이미 채워진 신규행에서
          //   팝업을 다시 열면 그 값으로 걸러진 목록이 떠야 한다(gap-resolve iter-1 A07).
          materialId: str(materialCellRowRef.current?.MATERIAL_ID),
        }}
        callFromCell
      />
    </>
  );
};
