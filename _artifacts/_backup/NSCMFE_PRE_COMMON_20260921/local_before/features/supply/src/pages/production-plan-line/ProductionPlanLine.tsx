import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ProductionPlanLineLoadModal } from './components/modals/ProductionPlanLineLoadModal';
import { ProductionPlanLineForm } from './components/ProductionPlanLineForm';
import { ProductionPlanLineGrid } from './components/ProductionPlanLineGrid';
import { useProductionPlanLineValidation } from './hooks/useProductionPlanLineValidation';
import { LABEL, MENU_ID, MSG, PLAN_TYPE_EXCLUDE_FIX, SHEETS } from './production-plan-line.constants';
import type { FixMode, MainRow } from './production-plan-line.types';
import styles from './ProductionPlanLine.module.scss';
import { deriveEditContext, useProductionPlanLineStore } from './useProductionPlanLineStore';

// AS-IS GSCM.SCP.Analysis.UIL SCP0013_ProductionPlanLine — 단일 pivot 그리드(spdMain) + Load 팝업.
//   설계: .atlas/gscm-design/SCP0013/design/00~03 (v2, DB 실측). 상세 매핑: __asis-mapping__.md.
//   주의: 버튼-API 배선 미등록(SCM_ADM_MNU_BTN_MPG_M 0행) → 조회/저장 실행체인은 admin 등록 후 실동작.
//         SP 는 배포 완료(PKG_SCP0013 VALID), 메뉴 가시화 완료(SCM_ADM_MNU_M 등록). design 03 §6.
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
  const initialized = useProductionPlanLineStore(s => s.initialized);

  const [openItem, setOpenItem] = useState(false);
  const [openLoad, setOpenLoad] = useState(false);
  // btnWLast 텍스트 주차 — AS-IS GetLastRange(division)(SCM0001_GET_SCP_DAILY_PLAN_PERIOD). SP 미배선이라
  //   기본 공란(버튼 'W' 표기, 숨김 아님). 서버 배선 후 division별 최종주로 갱신(design 01 A3 확인필요).
  const wLastPeriod = '';

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  // 편집판정 컨텍스트 — 조회결과에서 최종 PlanType/FN 존재 파생 (design 01 F2).
  const editContext = useMemo(() => deriveEditContext(rows), [rows]);
  const visibilityCtx = useMemo(
    () => ({ division: sc.divisionId, operationGroup: sc.operationGroupId }),
    [sc.divisionId, sc.operationGroupId]
  );

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Fix/Unfix/New enable — 마지막 주차·SEQ·확정/임시 아닌 Plan (design 01 D1). 단일 선택 + FN/TE 제외 근사.
  //   주의: '마지막 주차/SEQ' 의 엄밀 판정(콤보 옵션 index0 대조)은 Form 이 보유 — 여기선 선택+타입 규칙으로 근사.
  const canFix = useMemo(() => {
    if (sc.planStartYyyymmdds.length === 0 || sc.planTypes.length === 0 || sc.planSeqs.length === 0)
      return false;
    return !sc.planTypes.some(pt => (PLAN_TYPE_EXCLUDE_FIX as readonly string[]).includes(pt));
  }, [sc.planStartYyyymmdds, sc.planTypes, sc.planSeqs]);

  const handleSearch = () => {
    // Division/OperationGroup 필수 (design 02 §6 — Division*/Operation Group*).
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, `_${LABEL.DIVISION}.`) });
      return;
    }
    if (!sc.operationGroupId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, `_${LABEL.OPERATION_GROUP}.`) });
      return;
    }
    if (!validateSearch(sc).ok) return; // chkLineAssign → Material 필수 (MSG00290)
    setFilter();
    void fetchStaticColumns();
  };

  const dirtyRows = (): Record<string, unknown>[] => {
    const g = gridRef.current;
    g?.finishEditing();
    const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    return src.filter(r => r.CRUD_TYPE);
  };

  const handleSave = () => {
    const dirty = dirtyRows();
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.SAVE_SUCCESS, '_No changes.') });
      return;
    }
    if (!validateSave(dirty).ok) return; // 수량 범위 / 신규행 붉은셀
    // PROD_PLAN_AMEND 편집셀 저장 (P_SCP0013_SAVE_LINE_ROW/_DS). 실행체인 미배선 시 BE 오류(honest — design 03 §6).
    mutateMain(dirty as unknown as MainRow[]);
  };

  // New — 권한 + 버전선택(canFix) 가드 후 신규행(design 01 E5). AS-IS 삽입팝업(ProductionPlanInsertPopup)은
  //   미이식(SCM0002 공용 팝업 별도) — 조회된 선택행 복사로 근사. 미조회 상태 삽입 차단(convert-core §2.4).
  const handleInsert = () => {
    if (!hasButton('INSERT')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (!canFix) {
      void setAlert({ type: 'alert', content: t(MSG.INSERT_GUIDE, '_Select the latest plan version.') });
      return;
    }
    const grid = gridRef.current;
    if (!grid) return;
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.INSERT_GUIDE, '_Edit mode is available after search.') });
      return;
    }
    const src = (grid.selectedItems[0] as Record<string, unknown> | undefined) ?? {
      DIVISION_ID: sc.divisionId,
    };
    GridAction.addRow(grid, { ...src, INPUT_STATUS: 'I' });
  };

  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  // Fix/Unfix — 권한 + 모드 + 서버 SAVE_YN 가드(design 01 E1~E4). SAVE_YN 서버판정(P_SCP0013_GET_PLAN_SAVE_YN)
  //   + fix 저장 실행체인은 버튼 메타 미배선(design 03 §6) → 가드 통과 후 저장 mutate 로 근사, 서버 SAVE_YN
  //   재판정은 admin 배선 후 연동(honest 보고). mode 'F'=Fix / 'U'=Unfix.
  const runFix = (mode: FixMode) => {
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (!canFix) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_YN_NO, '_Cannot fix/unfix this plan version.') });
      return;
    }
    const dirty = dirtyRows();
    const payload = dirty.map(r => ({ ...r, FIX_MODE: mode }));
    if (payload.length === 0) {
      setToast({ type: 'error', message: t(MSG.SAVE_SUCCESS, '_No changes.') });
      return;
    }
    mutateMain(payload as unknown as MainRow[]);
  };

  const handleLoad = () => {
    setLoadFilter();
    setOpenLoad(true);
  };

  // Measure(TitleSet) — SCM0002_TitleSetForm_Popup(컬럼/measure 커스터마이즈, design 03 §6). 공용
  //   ColumnLayoutModal 대체 대상 — 미이식(별도 후속). 진입만 안내.
  const handleMeasure = () => {
    setToast({ type: 'default', message: t('LBL00000', `_${LABEL.MEASURE} setup is not available yet.`) });
  };

  // 기간 프리셋 — GetDayRange(weeks) 등가 클라 산정(from=오늘, to=오늘+weeks*7-1). dayjs 로컬(함정12).
  const handlePreset = (weeks: number) => {
    const from = dayjs();
    const to = from.add(weeks * 7 - 1, 'day');
    setSearchCondition({ fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') });
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(버튼 권한 메타 미배선 상태에서도 조회 동작 보장 — design 03 §6).
    search: handleSearch,
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
        <ProductionPlanLineForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onPreset={handlePreset}
          wLastPeriod={wLastPeriod}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProductionPlanLine'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          { label: LABEL.FIX, action: () => runFix('F'), disabled: !canFix },
          { label: LABEL.UNFIX, action: () => runFix('U'), disabled: !canFix },
          { label: LABEL.NEW, action: handleInsert },
          { label: LABEL.LOAD, action: handleLoad },
          { label: LABEL.MEASURE, action: handleMeasure },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanLineGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          editContext={editContext}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Material 검색 — 공용 표준 ItemByDivisionModal (btnItemId → txtItemId). */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* Load 팝업 — 부모 조회조건 주입, 읽기전용 선택 로드 (design 01 §P). */}
      <ProductionPlanLineLoadModal open={openLoad} modalClose={() => setOpenLoad(false)} />
    </>
  );
};
