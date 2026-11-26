import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ScpBomForm } from './components/ScpBomForm';
import { ScpBomGrid } from './components/ScpBomGrid';
// V1(MSG01329) 조회 가드 임시 비활성 (2026-10-07, 사용자 요청) — "AS-IS 는 빈 조회 허용" 관측과
//   AS-IS 소스(SCP0053_SCPBOM.cs:253~261, 빈 조회 차단)가 충돌 → 운영 바이너리 대조 전까지 보류.
//   AS-IS 등가 복원 시 이 import·아래 destructure·handleSearch 호출 3곳 주석 해제.
// import { useScpBomValidation } from './hooks/useScpBomValidation';
import { MENU_ID, MSG, RESPONSE_KEY, SHEETS } from './scp-bom.constants';
import type { ScpBomRow } from './scp-bom.types';
import { useScpBomStore } from './useScpBomStore';
import { isRowLocked, markRowLocks } from './utils/scp-bom.editLock';
import { buildSavePayload, callSaveScpBom } from './utils/scp-bom.save';
// import { findInvalidScpYnParents } from './utils/scp-bom.scpYn';

// AS-IS GSCM.SCP.Master.UIL SCP0053_SCPBOM — 단일 그리드 마스터, UPDATE 전용(INSERT/DELETE NO-OP).
//   설계: .atlas/gscm-design/SCP0053/design/00~03 · convert-flow/{goal,plan}.md. 매핑: __asis-mapping__.md.
//   NSCM 표준: 그리드 상시 편집(Edit 토글 미이식, asis_to_tobe §11) — 셀별 편집가부는 메타 INPUT_TP_CD(S15/M3),
//   행 단위 잠금은 SCP_PLAN_YN 비 Y/N(design 03 §3 W6). Division 은 권한 콤보 첫 항목 기본선택(2026-10-22, R7 '81' 고정 폐기).
export const ScpBom = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  // const { validateSearch } = useScpBomValidation(); // V1 가드 임시 비활성 (2026-10-07)
  // 필수 컬럼(메타 M) 저장검증 — 전 화면 공통(convert-core §2.4). M 3컬럼(SCP_PLAN_YN/SI_ALT_PRIORITY/SI_SCP_YN).
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);

  const [openMaterial, setOpenMaterial] = useState(false);
  // R8 — MyDivision 권한 판정(null=로딩). false 면 조회 차단(design 01 R8).
  const [divisionAuth, setDivisionAuth] = useState<boolean | null>(null);

  const sc = useScpBomStore(st => st.searchCondition);
  const setSearchCondition = useScpBomStore(st => st.setSearchCondition);
  const filters = useScpBomStore(st => st.filters);
  const setFilter = useScpBomStore(st => st.setFilter);
  const clearFilters = useScpBomStore(st => st.clearFilters);
  const openSearchArea = useScpBomStore(st => st.openSearchArea);
  const setOpenSearchArea = useScpBomStore(st => st.setOpenSearchArea);
  const staticColumns = useScpBomStore(st => st.staticColumns);
  const fetchStaticColumns = useScpBomStore(st => st.fetchStaticColumns);
  const restoreSearchConditions = useScpBomStore(st => st.restoreSearchConditions);
  const initialized = useScpBomStore(st => st.initialized);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 커서 읽기키 = PROC_M COL_NM 실측 'o_rc'(RESPONSE_KEY). o_rc1 아님 주의.
  //   행 잠금은 조회 시점 SCP YN 으로 고정(markRowLocks) — 편집 중 지운 행도 저장 대상(AS-IS 등가).
  const rows = useMemo<ScpBomRow[]>(() => markRowLocks(data?.[RESPONSE_KEY] ?? []), [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  //   F6 저장 조회조건 복원도 mount 1회(conditionsRestored 가드). 새로고침 시 새 store → 재복원.
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    void restoreSearchConditions();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // R8 — Division 권한 0건이면 조회 차단(design 01 R8, MSG00097 등가).
    if (divisionAuth === false) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    // V1 — Alter BOM 미체크 시 3텍스트 최소 1개 필수(design 02 §5). 임시 비활성 (2026-10-07, 사용자 요청).
    // if (!validateSearch(sc)) return;
    setFilter();
    void fetchStaticColumns();
  };

  const doSave = async (dirty: Record<string, unknown>[]) => {
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const payload = buildSavePayload(dirty);
      if (!payload) return;
      const result = await callSaveScpBom(payload);
      if (result.ok) {
        setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '_{0}개의 데이터가 저장되었습니다.').replace(
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
    // dirty = 변경행(CRUD_TYPE). 조회 시점 잠금행(SCP_PLAN_YN 비 Y/N)은 편집 자체가 차단되나 방어적으로 제외.
    //   편집 중 SCP YN 을 지운 행은 잠금행이 아니므로 빈 값으로 저장된다(AS-IS SaveData_Main cs:460-485 등가).
    const dirty = src.filter(r => r.CRUD_TYPE && !isRowLocked(r));
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 기존 로직 주석 보존 (2026-11-03) 시작 - SCP YN Y 1개 검증 제거(사용자 요청)
    // // SCP YN 'Y' 는 같은 Plant + Parent Item 에 반드시 1개(0개, 2개 이상 차단).
    // const invalidParents = findInvalidScpYnParents(src);
    // if (invalidParents.length > 0) {
    //   void setAlert({
    //     type: 'alert',
    //     // 메시지 코드 미등록 - 사용자 요청으로 문구 하드코딩.
    //     // content: `같은 Parent Item 에 SCP YN Y 는 반드시 1개여야 합니다. PARENT ITEM : ${invalidParents.join(', ')}`,
    //     // 위반 3건까지만 표시하고 나머지는 건수로 줄인다.
    //     content: `SCP YN Y 는 Plant·Parent 별 1개만 가능합니다. (${invalidParents.slice(0, 3).join(', ')}${invalidParents.length > 3 ? ` 외 ${invalidParents.length - 3}건` : ''})`,
    //   });
    //   return;
    // }
    // 기존 로직 주석 보존 (2026-11-03) 끝
    // 필수 컬럼(메타 M) 검증 통과 후 '^' bulk 저장. saveWithValidation 이 M 3종 빈값을 alert·차단.
    saveWithValidation(dirty as unknown as ScpBomRow[], staticColumns, () => {
      void doSave(dirty);
    });
  };

  // INSERT/DELETE — 버튼 숨김(사용자 지시 2026-11-03). AS-IS 가 둘 다 NO-OP(design 01 R4/R5, cs 본문 전체 주석)라
  //   실질 작업이 없어 설계 기본 '노출+무동작' 대신 숨김 처리. 감사가 설계 기본으로 되돌리지 말 것(design §5#4 사용자 지시 우선).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
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
        <ScpBomForm
          onSearch={handleSearch}
          onModelSearch={() => setOpenMaterial(true)}
          onDivisionAuth={setDivisionAuth}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ScpBom'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      <ScpBomGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        staticColumns={staticColumns}
      />

      {/* Model/Nickname 돋보기 — MaterialByDivisionModal(COM0013). 단일 선택 → txtModelID(modelId) 반영(design 02 §4.6). */}
      <MaterialByDivisionModal
        open={openMaterial}
        modalClose={() => setOpenMaterial(false)}
        setSelectedValue={code => setSearchCondition({ modelId: code })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.modelId,
        }}
      />
    </>
  );
};
