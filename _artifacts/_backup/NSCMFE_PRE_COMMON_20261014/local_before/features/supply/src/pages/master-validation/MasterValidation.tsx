import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQueries } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MasterValidationDetailGrid } from './components/MasterValidationDetailGrid';
import { MasterValidationForm } from './components/MasterValidationForm';
import { MasterValidationMasterGrid } from './components/MasterValidationMasterGrid';
import type {
  SHEETS} from './master-validation.constants';
import {
  isDivisionSkipped,
  isPlanGroupLocked,
  MASTER_LOOKUP_TYPE,
  MENU_ID,
  VALIDATION_MAP,
} from './master-validation.constants';
import type { DetailRow, MasterValidationRow } from './master-validation.types';
import styles from './MasterValidation.module.scss';
import { useMasterValidationStore } from './useMasterValidationStore';

// SCP0039 Master Validation — read-only 검증 대시보드(design 00~03).
//   좌 마스터목록(lookup MASTER_VALIDATION) | 우 detail(검증유형별 SP 결과). QUERY 셀 = 데이터 구동
//   dispatch(행 코드 -> PKG_SCP0039 멤버 SP), OPEN 셀 = PROGRAM_ID 네비게이션.
export const MasterValidation = ({ title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const findMenuPath = useSessionStore(state => state.findMenuPath);
  const { setAlert } = useMessageStore.getState();

  const masterGridRef = useRef<FlexGrid<MasterValidationRow>>();
  const detailGridRef = useRef<FlexGrid<DetailRow>>();
  const masterFilterRef = useRef<FlexGridFilter>();
  const detailFilterRef = useRef<FlexGridFilter>();

  const searchParams = useMasterValidationStore(state => state.searchParams);
  const masterColumns = useMasterValidationStore(state => state.masterColumns);
  const staticColumns = useMasterValidationStore(state => state.staticColumns);
  const setPlanGroupLocked = useMasterValidationStore(state => state.setPlanGroupLocked);
  const fetchMasterColumns = useMasterValidationStore(state => state.fetchMasterColumns);
  const fetchDetailColumns = useMasterValidationStore(state => state.fetchDetailColumns);
  const openSearchArea = useMasterValidationStore(state => state.openSearchArea);
  const setOpenSearchArea = useMasterValidationStore(state => state.setOpenSearchArea);

  const [detailRows, setDetailRows] = useState<DetailRow[]>([]);
  const [activeSheet, setActiveSheet] = useState<SHEETS | null>(null);
  const [focusDetail, setFocusDetail] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 마스터 목록 = lookup MASTER_VALIDATION(admin/lookup). AS-IS InsertBaseRow 는 Form_Load 에 목록을
  //   seed 하므로(조회조건 무관) mount 시 로드. 비활성행(PROCEDURE_NAME='-' = Sales Site)은 제외(R11).
  const [lookupData] = useTabLookupQueries({ filters: [{ lookupType: MASTER_LOOKUP_TYPE }] });

  // 마스터 "Validation Info" 컬럼 메타는 admin fetch(하드코딩 금지). mount 1회.
  useEffect(() => {
    void fetchMasterColumns();
  }, [fetchMasterColumns]);

  const masterRows = useMemo(
    () =>
      ((lookupData ?? []) as unknown as MasterValidationRow[])
        .filter(row => (row.PROCEDURE_NAME ?? '').trim() !== '' && row.PROCEDURE_NAME !== '-')
        .map(row => ({ ...row, COUNT: '' })),
    [lookupData]
  );

  const detailStaticColumns = useMemo(
    () => (activeSheet ? (staticColumns[activeSheet] ?? []) : []),
    [activeSheet, staticColumns]
  );

  // 행 COUNT 를 그리드 dataItem 에 직접 갱신 + refresh — itemsSource 재생성 없이(선택/스크롤 보존).
  const setRowCount = useCallback((code: string, count: string) => {
    const row = masterRows.find(item => item.VALIDATION_TYPE === code);
    if (row) row.COUNT = count;
    masterGridRef.current?.collectionView?.refresh();
  }, [masterRows]);

  // Division/PlanGroup 변경 = ClearSheet(AS-IS ClbDivision_SelectedIndexChanged cs:1268 -> ClearSheet
  //   cs:1219). detail 행·activeSheet·전 행 COUNT(cs:1224) 초기화 — stale COUNT·detail 잔존 방지
  //   (design 01 §3, 03 §3 #9, GAP-03).
  const clearResults = useCallback(() => {
    masterRows.forEach(row => {
      row.COUNT = '';
    });
    masterGridRef.current?.collectionView?.refresh();
    setDetailRows([]);
    setActiveSheet(null);
  }, [masterRows]);

  useEffect(() => {
    clearResults();
  }, [searchParams.divisionId, searchParams.planGroupIds, clearResults]);

  // 검증유형 SP 호출(공통) — 성공 시 결과 행 반환, 실패 시 null.
  const callValidationSp = useCallback(
    async (row: MasterValidationRow): Promise<DetailRow[] | null> => {
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return null;
      const payload = {
        divisionId: searchParams.divisionId,
        searchType: '',
        // ALL(빈 배열) -> '' (전체). 다중선택은 콤마 결합.
        planGroupId: searchParams.planGroupIds.length ? searchParams.planGroupIds.join(',') : '',
        itemId: searchParams.itemId,
      };
      try {
        const res = await apiClient.callProc<MENU_ID, SHEETS.BOM>(
          MENU_ID,
          spec.sheet as SHEETS.BOM,
          BUTTON_TYPE.SEARCH,
          payload
        );
        if (res.code !== '0') {
          void setAlert({ type: 'alert', content: res.message ?? t('MSG01052', '_An error has occurred when inquiring.') });
          return null;
        }
        return (res.result?.o_rc1 ?? []) as DetailRow[];
      } catch {
        void setAlert({ type: 'alert', content: t('MSG01052', '_An error has occurred when inquiring.') });
        return null;
      }
    },
    [searchParams, setAlert, t]
  );

  // QUERY 셀 클릭 — 해당 행 검증유형 SP dispatch -> COUNT 갱신 + detail 바인딩(design 03 §3 R13).
  const handleQuery = useCallback(
    async (row: MasterValidationRow) => {
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return;
      await fetchDetailColumns(spec.sheet, spec.adminSheetName);
      const rows = await callValidationSp(row);
      if (rows === null) return;
      setActiveSheet(spec.sheet);
      setDetailRows(rows);
      setRowCount(row.VALIDATION_TYPE, String(rows.length));
    },
    [callValidationSp, fetchDetailColumns, setRowCount]
  );

  // OPEN 셀 클릭 — PROGRAM_ID(SEGMENT4) 네비게이션(design 03 §3 white-list R14).
  //   http 시작 = 외부 URL / 그 외 = MDI 화면(권한 있는 메뉴만).
  const handleOpen = useCallback(
    (row: MasterValidationRow) => {
      const programId = (row.PROGRAM_ID ?? '').trim();
      if (!programId) return;
      if (/^https?:\/\//i.test(programId)) {
        window.open(programId, '_blank', 'noopener,noreferrer');
        return;
      }
      if (!findMenuPath(programId)) return;
      void navigate(`/view/${encodeURIComponent(programId)}`);
    },
    [findMenuPath, navigate]
  );

  // 마스터 행 선택(QUERY/OPEN 외 셀) — CONSTRAINTS01 파싱으로 PlanGroup 조건 잠금(R18) +
  //   detail sheet 프리뷰 전환(조회 없이 뷰만, R15).
  const handleRowSelect = useCallback(
    (row: MasterValidationRow) => {
      setPlanGroupLocked(isPlanGroupLocked(row.CONSTRAINTS01));
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return;
      void fetchDetailColumns(spec.sheet, spec.adminSheetName);
      setActiveSheet(spec.sheet);
      setDetailRows([]);
    },
    [fetchDetailColumns, setPlanGroupLocked]
  );

  // 전체조회(F5/FindDataAll) — 활성 행마다 SP 호출해 COUNT 채움(design 01 §2-E R22:
  //   CONSTRAINTS01 Div: 가 현재 division 과 다르면 skip). detail 은 QUERY 로 개별 드릴다운.
  const handleSearch = useCallback(() => {
    void Promise.allSettled(
      masterRows.map(async row => {
        if (isDivisionSkipped(row.CONSTRAINTS01, searchParams.divisionId)) {
          setRowCount(row.VALIDATION_TYPE, '');
          return;
        }
        const rows = await callValidationSp(row);
        if (rows !== null) setRowCount(row.VALIDATION_TYPE, String(rows.length));
      })
    );
  }, [callValidationSp, masterRows, searchParams.divisionId, setRowCount]);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // read-only 뷰어 — AS-IS Insert/Edit/Delete/Save override 본문 공백(NO-OP, design 00 §4d).
    //   명시적 무동작 함수로 배선(키 생략 금지 — 공용 SubTitle addRow/removeRow 재활성 방지, self-check §3).
    insert: () => undefined,
    save: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  const focusedGrid = focusDetail ? detailGridRef : masterGridRef;
  const focusedFilter = focusDetail ? detailFilterRef : masterFilterRef;
  const focusedCount = focusDetail ? detailRows.length : masterRows.length;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <MasterValidationForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={focusedGrid}
        gridFilter={focusedFilter}
        dataCount={focusedCount}
        excelFileName='MasterValidation'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* 좌 마스터목록(초기폭 400 고정) | 우 detail 2-pane. AS-IS 우측 4분할·빈 3그리드는 dead layout
          미재현(design 01 §1.1 — 확인된 dead 제거). */}
      <PanelGroup className={styles.tableWrapper} orientation='horizontal'>
        <Panel defaultSize={35} minSize={20}>
          <MasterValidationMasterGrid
            gridRef={masterGridRef}
            gridFilterRef={masterFilterRef}
            data={masterRows}
            staticColumns={masterColumns}
            onQuery={handleQuery}
            onOpen={handleOpen}
            onRowSelect={handleRowSelect}
            gotFocus={() => setFocusDetail(false)}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={65} minSize={20}>
          <MasterValidationDetailGrid
            gridRef={detailGridRef}
            gridFilterRef={detailFilterRef}
            data={detailRows}
            staticColumns={detailStaticColumns}
            gotFocus={() => setFocusDetail(true)}
          />
        </Panel>
      </PanelGroup>
    </>
  );
};
