import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { LineMasterForm } from './components/LineMasterForm';
import { LineMasterMainGrid } from './components/LineMasterMainGrid';
import { LINE_MODE, MENU_ID, MSG, SHEETS } from './line-master.constants';
import type { MainRow, PackerRow } from './line-master.types';
import { useLineMasterStore } from './useLineMasterStore';
import { savePackerOsp } from './utils/line-master.api';
import { packerInsertDefaults } from './utils/lineMasterEditLock';

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0002_LineMaster — 단일 그리드(spdMain Plant/Packer 2 시트 전환).
//   설계: .atlas/gscm-design/SCP0002/design/00~03. 상세 매핑: __asis-mapping__.md.
//   Plant 시트 = 조회 전용 / Packer 시트 = 편집(Insert/Edit/Delete/Save, SAVE 는 Packer 만).
export const LineMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  // 표준 버튼 권한 동적 fetch — admin SCM_ADM_USER_GR_MNU_BTN_MPG_M 기준 노출(ui-dynamic-property-management §3).
  //   05_register.sql 등록: Plant SEARCH/EXCEL · Packer SEARCH/INSERT/DELETE/SAVE/EXCEL.
  //   hasButton 은 시트 무관 union(mnuBtnAuth) 이라 시트 가드(Plant 조회 전용)는 각 핸들러가 별도로 유지한다.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 필수 컬럼(메타 INPUT_TP_CD=M/IM 또는 라벨 *) 저장검증 — 전 화면 공통.
  const { saveWithValidation } = useSaveWithValidation();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();

  const sc = useLineMasterStore(s => s.searchCondition);
  const filters = useLineMasterStore(s => s.filters);
  const setFilter = useLineMasterStore(s => s.setFilter);
  const setMode = useLineMasterStore(s => s.setMode);
  const openSearchArea = useLineMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useLineMasterStore(s => s.setOpenSearchArea);
  const staticColumns = useLineMasterStore(s => s.staticColumns);
  const fetchStaticColumns = useLineMasterStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = useLineMasterStore(s => s.restoreSearchConditions);
  const initialized = useLineMasterStore(s => s.initialized);
  const authLocked = useLineMasterStore(s => s.authLocked);

  const isPlant = sc.mode === LINE_MODE.PLANT;

  const { data: plantData } = useTabProcQuery<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLANT,
    tabId,
    filters: filters[SHEETS.PLANT],
    enabled: !!filters[SHEETS.PLANT],
  });
  const { data: packerData } = useTabProcQuery<MENU_ID, SHEETS.PACKER>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACKER,
    tabId,
    filters: filters[SHEETS.PACKER],
    enabled: !!filters[SHEETS.PACKER],
  });

  // Packer 만 저장 대상 (Plant 는 조회 전용, 저장 SP 없음 — design 03 §4.4).
  //   SAVE 는 CLOB '^' bulk proc 라 useProcMutation(행 배열) 불가 → savePackerOsp 로 폴딩 POST.
  //   공통 로딩 스피너(MDIContainer useIsBusy = useIsMutating([tabId]))가 돌도록 useMutation 으로 감싼다.
  const queryClient = useQueryClient();
  const userId = useSessionStore.getState().session.userId ?? '';
  const savePacker = useMutation({
    mutationKey: [tabId, SHEETS.PACKER, 'SAVE'],
    mutationFn: (rows: Record<string, unknown>[]) => savePackerOsp(rows, userId),
    onSuccess: result => {
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message ?? t(MSG.SAVE_FAIL, '_저장 중 오류가 발생하였습니다.'),
        });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_성공적으로 저장되었습니다.') });
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    },
    onError: (error: Error) => {
      void setAlert({
        type: 'alert',
        content: error.message || t(MSG.SAVE_FAIL, '_저장 중 오류가 발생하였습니다.'),
      });
    },
  });

  // 참조 안정화 — 조회 전 addRow 신규행이 리렌더에 사라지지 않도록. mode 변경 시 시트 스왑.
  const mainRows = useMemo<MainRow[]>(
    () => (isPlant ? (plantData?.o_rc1 ?? []) : (packerData?.o_rc1 ?? [])),
    [isPlant, plantData, packerData]
  );

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 적용, 없으면 기본값 유지. 형제 파리티.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // 권한 사업부 0건 잠금 — AS-IS SetDivisionAuthCheck(cs:142-143) usrLayoutControl2.Enabled=false.
    //   SearchArea DOM 은 sx pointerEvents 로 막았으나 F5/SubTitle 단축키는 DOM 밖 진입점이라
    //   여기서 authLocked 로 별도 차단한다(안내는 LineMasterForm 이 잠금 전환 시 1회 수행 — 중복 alert 회피).
    if (authLocked) return;
    // Division 필수 (design 02 §2.1 Division*).
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Division.') });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행 — Packer 시트만 (design 03 §3.5 #31: IsLock==false && shtPacker 가드). Plant 는 조회 전용.
  const handleInsert = () => {
    if (isPlant) {
      // Plant 시트 = 조회 전용 — 신규행 불가 (design 03 §화면구조전제, MSG00109).
      void setAlert({ type: 'alert', content: t(MSG.READ_ONLY, '_Read only.') });
      return;
    }
    const grid = mainGridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, packerInsertDefaults(sc.divisionId));
  };

  // Delete — 신규행('I')만 클라측 즉시 제거 (design 03 §3.5 #30, cs:359). 기존행 물리삭제 미지원.
  const handleDelete = () => {
    if (isPlant) {
      void setAlert({ type: 'alert', content: t(MSG.READ_ONLY, '_Read only.') });
      return;
    }
    const grid = mainGridRef.current;
    if (!grid) return;
    const target = grid.selectedItems[0] as Record<string, unknown> | undefined;
    // 기존행 삭제는 AS-IS 미구현(SAVE SP 에 D 분기 없음) — 신규행만 제거.
    if (target && target.CRUD_TYPE !== 'I') {
      setToast({ type: 'error', message: t(MSG.READ_ONLY, '_Cannot delete existing row.') });
      return;
    }
    GridAction.removeRow(grid);
  };

  // Save — Packer 만, I/M 처리 (D 미지원 — design 03 §4.4). 서버 result_code 'S'/'F' 판정 후 재조회.
  const handleSave = () => {
    if (isPlant) {
      void setAlert({ type: 'alert', content: t(MSG.READ_ONLY, '_Read only.') });
      return;
    }
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // 필수 컬럼(메타 M/IM) 검증 통과 시 저장. Packer SAVE 는 CLOB '^' bulk 라 전용 폴딩 전송을
    //   useMutation 으로 감싼다 — 저장 중 공통 로딩 스피너, 완료 시 토스트+재조회(onSuccess).
    saveWithValidation(dirty as unknown as PackerRow[], staticColumns[SHEETS.PACKER], rows =>
      savePacker.mutate(rows as unknown as Record<string, unknown>[])
    );
  };

  // 표준 버튼은 admin 권한(hasButton)에 조건부 노출 — 하드코딩 금지(ui-dynamic-property-management §2 체크3).
  //   Plant/Packer 시트 편집 가부는 각 핸들러의 isPlant 가드가 처리하므로 여기선 권한만 게이트한다.
  //   manual/upload 는 admin 정의 자체가 없어 Hidden allowlist(false 고정).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  // 단일 그리드(spdMain) — mode 에 따라 Plant/Packer 시트 데이터·컬럼을 전환. 활성 탭에만 마운트된다.
  const mainGrid = (
    <LineMasterMainGrid
      mode={sc.mode}
      rows={mainRows}
      gridRef={mainGridRef}
      gridFilterRef={mainFilterRef}
      editTrackerRef={mainTrackerRef}
      adminColumns={isPlant ? staticColumns[SHEETS.PLANT] : staticColumns[SHEETS.PACKER]}
      onFocus={() => undefined}
    />
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <LineMasterForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='LineMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      {/* AS-IS FpSpread 시트탭(shtMain/shtPacker) 등가 — Plant/Packer 2 탭(표준 TabWrapper).
          탭 전환 = setMode(하위 cascade·필터 초기화) → 재조회 필요. 단일 그리드라 활성 탭만 마운트(persist 미사용). */}
      <TabWrapper
        activeTabIndex={isPlant ? 0 : 1}
        setActiveTabIndex={index => setMode(index === 1 ? LINE_MODE.PACKER : LINE_MODE.PLANT)}
      >
        {/* 탭 캡션 = AS-IS FpSpread SheetName(shtMain="Plant" / shtPacker="Packer", SCP0002_LineMaster.cs:63-64).
            AS-IS 가 비번역 리터럴로 쓰고 locale 에 'Packer' 라벨 키가 없으므로 다국어 없이 하드코딩한다. */}
        <TabItem label='Plant'>{mainGrid}</TabItem>
        <TabItem label='Packer'>{mainGrid}</TabItem>
      </TabWrapper>
    </>
  );
};
