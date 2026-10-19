import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ScpBomElecForm } from './components/ScpBomElecForm';
import { ScpBomElecGrid } from './components/ScpBomElecGrid';
import { useScpBomElecValidation } from './hooks/useScpBomElecValidation';
import { MENU_ID, MSG, RESPONSE_KEY, SHEETS } from './scp-bom-elec.constants';
import type { ScpBomElecRow } from './scp-bom-elec.types';
import { useScpBomElecStore } from './useScpBomElecStore';
import { isRowLocked } from './utils/scp-bom-elec.editLock';
import { buildSavePayload, callSaveScpBomElec } from './utils/scp-bom-elec.save';

// AS-IS GSCM.SCP.Master.UIL SCP0097_SCP_BOM_Elec — 단일 그리드 마스터, UPDATE 전용(INSERT/DELETE NO-OP).
//   설계: .atlas/gscm-design/SCP0097/design/00~03 · convert-flow/{goal,plan}.md. 매핑: __asis-mapping__.md.
//   NSCM 표준: 그리드 상시 편집(Edit 토글 미이식, asis_to_tobe §11) — 셀별 편집가부는 메타 INPUT_TP_CD(S11/M2),
//   행 단위 잠금은 SCP_YN 비 Y/N(design 03 §3 W7). Division 은 선택 가능(기본 '81', design 01 R6b).
export const ScpBomElec = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSearch } = useScpBomElecValidation();
  // 필수 컬럼(메타 M) 저장검증 — 전 화면 공통(convert-core §2.4). M 2컬럼(SCP_YN/STOCK_SUM).
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const sesUserId = useSessionStore(s => s.session.userId ?? '');

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);

  // R6a — MyDivision 권한 판정(null=로딩). false 면 조회 차단(design 01 R6a).
  const [divisionAuth, setDivisionAuth] = useState<boolean | null>(null);

  const sc = useScpBomElecStore(st => st.searchCondition);
  const filters = useScpBomElecStore(st => st.filters);
  const setFilter = useScpBomElecStore(st => st.setFilter);
  const clearFilters = useScpBomElecStore(st => st.clearFilters);
  const openSearchArea = useScpBomElecStore(st => st.openSearchArea);
  const setOpenSearchArea = useScpBomElecStore(st => st.setOpenSearchArea);
  const staticColumns = useScpBomElecStore(st => st.staticColumns);
  const fetchStaticColumns = useScpBomElecStore(st => st.fetchStaticColumns);
  const initialized = useScpBomElecStore(st => st.initialized);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 커서 읽기키 = SCM_ADM_PROC_M OUT 데이터커서 COL_NM='o_rc1'(RESPONSE_KEY, 05_register.sql (h) 등록 확정).
  //   기본 경로는 타입 보존(data?.[RESPONSE_KEY]). 비면 대소문자만 다른 키를 흡수 — COL_NM casing 재변경
  //   시에도 빈 그리드 방지(memory proc-cursor-key-colnm-vs-fe-read 축 방어).
  const rows = useMemo<ScpBomElecRow[]>(() => {
    const primary = data?.[RESPONSE_KEY];
    if (Array.isArray(primary)) return primary;
    if (!data) return [];
    const alt = Object.entries(data as Record<string, unknown>).find(
      ([k]) => k.toLowerCase() === RESPONSE_KEY.toLowerCase()
    )?.[1];
    return Array.isArray(alt) ? (alt as ScpBomElecRow[]) : [];
  }, [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // R6a — Division 권한 0건이면 조회 차단(design 01 R6a, MSG00097 등가).
    if (divisionAuth === false) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    // R1 — Division 필수(빈값 시 MSG00097 등가 alert + 조회 차단).
    if (!validateSearch(sc)) return;
    setFilter();
    void fetchStaticColumns();
  };

  const doSave = async (dirty: Record<string, unknown>[]) => {
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const payload = buildSavePayload(dirty, sesUserId);
      if (!payload) return;
      const result = await callSaveScpBomElec(payload);
      if (result.ok) {
        setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace(
            '{0}',
            String(result.count ?? dirty.length)
          ),
        });
        editTrackerRef.current?.clearChanges();
        // 저장 성공 후 재조회 — filters 불변이라 refetch 직접 호출 허용(nscm-patterns §5 예외).
        void refetch();
      } else {
        void setAlert({
          type: 'alert',
          content: result.errorMessage || t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
      }
    } finally {
      savingRef.current = false;
    }
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // dirty = 변경행(CRUD_TYPE). 잠금행(SCP_YN 비 Y/N)은 편집 자체가 차단되나 방어적으로 제외.
    const dirty = src.filter(r => r.CRUD_TYPE && !isRowLocked(r));
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 필수 컬럼(메타 M) 검증 통과 후 '^' bulk 저장. saveWithValidation 이 M 2종 빈값을 alert·차단.
    saveWithValidation(dirty as unknown as ScpBomElecRow[], staticColumns, () => {
      void doSave(dirty);
    });
  };

  // INSERT/DELETE — 버튼 노출 + 클릭 무동작(design 01 R4, base 빈 본문 NO-OP. 자매 SCP0053 실등록 미러).
  //   키 존재 + 명시 무동작 함수(공용 addRow/removeRow 부활 금지). hasButton 곱으로 권한 반영.
  const noop = () => undefined;
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? noop : false,
    delete: hasButton('DELETE') ? noop : false,
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
      {openSearchArea && <ScpBomElecForm onSearch={handleSearch} onDivisionAuth={setDivisionAuth} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ScpBomElec'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      <ScpBomElecGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        staticColumns={staticColumns}
      />
    </>
  );
};
