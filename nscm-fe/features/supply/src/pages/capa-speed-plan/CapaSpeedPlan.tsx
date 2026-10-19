import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  MENU_ID,
  MSG,
  SHEETS,
  SHEET_BY_DIVISION_TYPE,
} from './capa-speed-plan.constants';
import type { Scp0105Row, SpreadTitleRow } from './capa-speed-plan.types';
import { CapaSpeedPlanColumnModal } from './components/CapaSpeedPlanColumnModal';
import { CapaSpeedPlanForm } from './components/CapaSpeedPlanForm';
import { CapaSpeedPlanGrid } from './components/CapaSpeedPlanGrid';
import { CapaSpeedPlanItemPopup } from './components/CapaSpeedPlanItemPopup';
import { useCapaSpeedPlanCellEdit } from './hooks/useCapaSpeedPlanCellEdit';
import { useCapaSpeedPlanCombos } from './hooks/useCapaSpeedPlanCombos';
import { useCapaSpeedPlanConditionEffects } from './hooks/useCapaSpeedPlanConditionEffects';
import { useCapaSpeedPlanSave } from './hooks/useCapaSpeedPlanSave';
import { useCapaSpeedPlanStore } from './useCapaSpeedPlanStore';
import {
  buildPeriodColumns,
  periodColumnSignature,
  toPeriodColumnNames,
} from './utils/capaSpeedPlan.dateColumns';

/**
 * AS-IS GSCM.SCP.Forms.UIL Master/SCP0105_CAPA_Speed_Plan — CAPA Speed Plan.
 *   설계: .atlas/gscm-design/SCP0105/design/00~03, 07. 상세 매핑: __asis-mapping__.md.
 *   도메인 SCP -> features/supply. 라우트는 폴더 + DB `ROUTE_PATH='supply/capa-speed-plan'` 으로만 해석된다.
 *
 *   한 그리드 + `sheetName`(ASSEMBLY/ELTR) 스위치. 행 추가는 없고(AS-IS InsertButton 빈 구현),
 *   편집은 Current 버전에서만 열린다. 조회/저장 런타임 체인은 `PKG_SCP0105` 미배포라 미완이다
 *   (goal.md BLK-2 — convert-sp 후속).
 *
 *   Page 는 조립만 한다 — 저장 체인은 `hooks/useCapaSpeedPlanSave`, 셀 편집 후속은
 *   `hooks/useCapaSpeedPlanCellEdit`, 조회조건 변경 초기화·기간헤더 재조회는
 *   `hooks/useCapaSpeedPlanConditionEffects`, 모달 2종은
 *   `components/CapaSpeedPlan{ColumnModal,ItemPopup}` 이다.
 */
export const CapaSpeedPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  /**
   * 편집 가능 여부는 mount 1회 권한(`MNU_BTN_CD='EDIT'`)만으로 판정한다 — AS-IS Edit 모드토글
   * (SwitchLock/IsLock)은 이식하지 않는다(convert-core §2.4). 권한이 있으면 조회 직후 바로 편집
   * 가능하고, 없으면 grid 의 `isEditMode` prop 이 false 라 셀 편집게이트(`isCellEditable`)가 전 셀을 잠근다.
   */
  const canEdit = hasButton('EDIT');
  const editMode = canEdit;

  const gridRef = useRef<FlexGrid | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openItemPopup, setOpenItemPopup] = useState(false);

  const sc = useCapaSpeedPlanStore(state => state.searchCondition);
  const applied = useCapaSpeedPlanStore(state => state.applied);
  const filters = useCapaSpeedPlanStore(state => state.filters);
  const setFilters = useCapaSpeedPlanStore(state => state.setFilters);
  const openSearchArea = useCapaSpeedPlanStore(state => state.openSearchArea);
  const setOpenSearchArea = useCapaSpeedPlanStore(state => state.setOpenSearchArea);
  const staticColumns = useCapaSpeedPlanStore(state => state.staticColumns);
  const staticMeasures = useCapaSpeedPlanStore(state => state.staticMeasures);
  const fetchStaticColumns = useCapaSpeedPlanStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCapaSpeedPlanStore(state => state.fetchStaticMeasures);

  const combos = useCapaSpeedPlanCombos();

  // 조회에 쓰는 시트는 "확정 조회조건" 기준이다 — 조회 후 라디오만 바꿨다고 그리드가 따라가면 안 된다.
  const sheetName = SHEET_BY_DIVISION_TYPE[(applied ?? sc).divisionType];

  // ASSEMBLY / ELTR 은 서로 다른 SP 변형이라 시트별로 별도 쿼리를 건다. 두 시트 데이터를 동시에
  //   들고 있지 않도록 filters 에는 확정 시트 1건만 담긴다(03 R-01).
  const assemblyQuery = useTabProcQuery<MENU_ID, SHEETS.ASSEMBLY>({
    menuId: MENU_ID,
    sheetName: SHEETS.ASSEMBLY,
    tabId,
    filters: filters[SHEETS.ASSEMBLY],
    enabled: !!filters[SHEETS.ASSEMBLY],
  });
  const eltrQuery = useTabProcQuery<MENU_ID, SHEETS.ELTR>({
    menuId: MENU_ID,
    sheetName: SHEETS.ELTR,
    tabId,
    filters: filters[SHEETS.ELTR],
    enabled: !!filters[SHEETS.ELTR],
  });
  // 동적 기간 헤더 — 그리드 데이터와 별도 시트로 조회한다(03 §2.5).
  const spreadTitleQuery = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const activeQuery = sheetName === SHEETS.ELTR ? eltrQuery : assemblyQuery;
  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(nscm-patterns §5-4).
  const rows = useMemo<Scp0105Row[]>(
    () => ((activeQuery.data as { o_rc1?: Scp0105Row[] } | undefined)?.o_rc1 ?? []),
    [activeQuery.data]
  );
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () =>
      ((spreadTitleQuery.data as { o_rc1?: SpreadTitleRow[] } | undefined)?.o_rc1 ?? []),
    [spreadTitleQuery.data]
  );

  // 컬럼 재조립 억제 — 내용 서명이 같으면 같은 참조를 유지한다(Wijmo 전 컬럼 재생성 방지).
  const periodSignature = periodColumnSignature(spreadTitleRows);
  const periodColumns = useMemo(
    () => buildPeriodColumns(spreadTitleRows),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature]
  );
  const periodColumnNames = useMemo(
    () => toPeriodColumnNames(spreadTitleRows),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature]
  );

  // ELTR 셀 콤보 후보 원천 — 조회조건 Line Type 과 같은 콤보를 쓰되 좁히는 기준이 다르다(행 기준, §1.3).
  const electrodeTypeRows = combos.electrodeTypeRows;

  /**
   * Division 권한 0건 게이트 — AS-IS `SetDivisionAuthCheck`(cs:1241~1242 -> BaseForm:5995~6003).
   * 조회영역 전체 비활성 + 안내 1회. 권한 판정은 GROUP_ID 가 아니라 USER_ID 보유 권한 합집합이다
   * (콤보 `Division_SCP` 의 WHERE 가 `@sesUserId` 기준이라 결과 0건이 곧 권한 0건, hook #128).
   * AS-IS 번호 `MSG00097` 을 그대로 쓰면 "Please select Division." 이 뜬다 — `MSG00667` 이 정답(01 L-04).
   *
   * 판정 시점은 **Division 콤보 응답 수신 후**다(`combos.isDivisionSettled`). 컬럼 메타 fetch 완료
   * (`initialized`)를 기준으로 쓰면 두 비동기의 경쟁조건에 걸려 — 컬럼 메타(2 POST)가 먼저 끝나는
   * 순간 후보가 아직 `[]` 이라 — 정상 권한 사용자에게도 알림이 뜨고 조회영역이 잠긴다.
   */
  const noDivisionAuth = combos.isDivisionSettled && combos.divisionOptions.length === 0;
  const notifiedAuthRef = useRef(false);
  useEffect(() => {
    if (!noDivisionAuth || notifiedAuthRef.current) return;
    notifiedAuthRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noDivisionAuth]);

  useCapaSpeedPlanConditionEffects({
    tabId,
    editTrackerRef,
    divisionId: sc.divisionId,
    divisionType: sc.divisionType,
    version: sc.version,
    versionSeq: sc.versionSeq,
    progressStatus: sc.progressStatus,
  });

  // 조회(F5) — AS-IS FindButton. 필수 조회조건은 만들지 않는다(F-21).
  //   `refetch()` 를 직접 부르지 않는다. filters 참조 교체가 곧 재조회다(nscm-patterns §5-1).
  const handleSearch = () => {
    if (noDivisionAuth) return;
    editTrackerRef.current?.clearChanges();
    setFilters(combos.buildGetPayload());
    void fetchStaticColumns(sc.divisionId);
    void fetchStaticMeasures();
  };

  /**
   * Insert — **명시적 무동작**. AS-IS `InsertButton()` 본문이 빈 구현이다(cs:1463~1465, R-15).
   * `hotkeyConfig` 에서 키를 생략하면 공용 SubTitle 의 기본 `addRow` 가 살아나 AS-IS 에 없던
   * 행 추가가 생기고, `false` 로 주면 버튼이 사라져 시각적으로 달라진다 — 둘 다 오답이다.
   * 메타에도 `MNU_BTN_CD='INSERT'` 를 등록한다(사용자 확정 2026-09-23, goal.md BLK-6).
   */
  const handleInsert = () => undefined;

  /**
   * Delete — AS-IS `DeleteButton()`(cs:1821~1839). 가드 3종(그리드 없음/빈 그리드/행 미선택)은 전부
   * 무동작이고, 선택행 상태가 `'I'`(신규) 일 때만 로컬 제거한다. 이 화면은 행 추가가 없어 신규행이
   * 생기지 않으므로 **실질 무동작**이다 — 기존 행이 지워지지 않는 것이 핵심이다(R-27, V-40).
   */
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (grid.rows.length === 0) return;
    if (!grid.selectedRows?.length) return;
    const selected = grid.selectedRows[0]?.dataItem as Scp0105Row | undefined;
    if (selected?.CRUD_TYPE !== 'I') return;
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  const { handleCellEditEnded } = useCapaSpeedPlanCellEdit({
    gridRef,
    editTrackerRef,
    sheetName,
  });

  const { handleSave } = useCapaSpeedPlanSave({
    gridRef,
    editTrackerRef,
    sheetName,
    periodColumnNames,
    condition: applied ?? sc,
    canEdit,
    staticColumns: staticColumns[sheetName],
    // AS-IS 는 SAVE -> GET 을 연쇄 실행한다(cs:2392~2399). filters 가 그대로라 refetch 가 맞다.
    refetch: () => void activeQuery.refetch?.(),
  });

  /**
   * hotkeyConfig — `useTabBtnPermissions` 경유 의무(하드코딩 금지, CLAUDE.md §2 체크3).
   * `insert` 는 **키를 존재시킨 채 명시적 무동작 함수**다(위 handleInsert 주석 참조).
   * `manual`/`upload` 는 AS-IS 에 없는 기능이라 false.
   *
   * Edit(AS-IS F2)는 여기 없다 — TO-BE 공통 결정으로 Edit 모드토글은 이식하지 않고 편집 가능 여부는
   * mount 1회 권한(`canEdit = hasButton('EDIT')`)으로만 판정한다(convert-core §2.4).
   */
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  /**
   * AS-IS `btnColumn`(조회영역 우측 아이콘) -> SubTitle 공용 아이콘 `IcGridColumnSetup` 으로 이동(01 §2-G).
   * 이 화면은 환율·Measure 아이콘을 쓰지 않아 GridColumnSet 1개만 둔다(순서 규약 hook #120 충족).
   * 라벨은 `LBL00605`("Column Setting") 재사용 — AS-IS Tag 는 "Column Show" 지만 등가 LBL 이 없고
   * 공용 아이콘 표준 문구가 이것이다(신규 채번 회피, hook #114).
   */
  const customButtons = [
    {
      label: t('LBL00605', '_Column Setting'),
      title: t('LBL00605', '_Column Setting'),
      action: () => setOpenColumnSetting(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <CapaSpeedPlanForm
          combos={combos}
          onSearch={handleSearch}
          onOpenItemPopup={() => setOpenItemPopup(true)}
          disabled={noDivisionAuth}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='CapaSpeedPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />
      <CapaSpeedPlanGrid
        sheetName={sheetName}
        rows={rows}
        staticColumns={staticColumns[sheetName]}
        staticMeasures={staticMeasures[sheetName]}
        periodColumns={periodColumns}
        electrodeTypeRows={electrodeTypeRows}
        isEditMode={editMode}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onCellEditEnded={handleCellEditEnded}
      />

      <CapaSpeedPlanColumnModal
        open={openColumnSetting}
        onClose={() => setOpenColumnSetting(false)}
        sheetName={sheetName}
        divisionId={sc.divisionId}
      />

      <CapaSpeedPlanItemPopup open={openItemPopup} onClose={() => setOpenItemPopup(false)} />
    </>
  );
};
