import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG } from './capa-loss-plan.constants';
import type { Scp0106Row } from './capa-loss-plan.types';
import { CapaLossPlanColumnModal } from './components/CapaLossPlanColumnModal';
import { CapaLossPlanForm } from './components/CapaLossPlanForm';
import { CapaLossPlanGrid } from './components/CapaLossPlanGrid';
import { CapaLossPlanItemPopup } from './components/CapaLossPlanItemPopup';
import { useCapaLossPlanCellEdit } from './hooks/useCapaLossPlanCellEdit';
import { useCapaLossPlanCombos } from './hooks/useCapaLossPlanCombos';
import { useCapaLossPlanQuery } from './hooks/useCapaLossPlanQuery';
import { useCapaLossPlanSave } from './hooks/useCapaLossPlanSave';
import { useCapaLossPlanStore } from './useCapaLossPlanStore';
import { buildSpreadTitleFilters, toFromYyyymm } from './utils/capaLossPlan.dateColumns';
import { judgeEditGate, toSheetName, toSheetStatus } from './utils/capaLossPlan.sheetKey';

/**
 * AS-IS GSCM.SCP.Forms.UIL Master/SCP0106_CAPA_Loss_Plan — CAPA Loss Plan.
 *   설계: .atlas/gscm-design/SCP0106/design/00~03, 07. 확정 결정: convert-flow/decisions.md.
 *   상세 매핑: __asis-mapping__.md. 도메인 SCP -> features/supply.
 *   라우트는 폴더 + DB `ROUTE_PATH='supply/capa-loss-plan'` 으로만 해석된다(라우트 코드 수정 없음).
 *
 *   한 그리드 + `sheetName`(8종) 스위치. 탭이 아니다(`TabStripPolicy=Never`, 03 R-01).
 *   편집 가능한 조합은 `CURRENT_*` 2시트 + `1ST_CUTOFF_LINE_*` 2시트뿐이다(Edit 게이트 R-20).
 *
 *   조회/저장/동적헤더 런타임 체인은 `PKG_SCP0106` **미배포**라 미완이다(goal.md ② — convert-sp 후속).
 *
 *   Page 는 조립만 한다(구조 룰 #9) — 저장은 `hooks/useCapaLossPlanSave`, 셀 편집 후속은
 *   `hooks/useCapaLossPlanCellEdit`, 모달 2종은 `components/CapaLossPlan{ColumnModal,ItemPopup}`.
 */
export const CapaLossPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openItemPopup, setOpenItemPopup] = useState(false);

  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const applied = useCapaLossPlanStore(state => state.applied);
  const filters = useCapaLossPlanStore(state => state.filters);
  const isEditMode = useCapaLossPlanStore(state => state.isEditMode);
  const setEditMode = useCapaLossPlanStore(state => state.setEditMode);
  const setFilters = useCapaLossPlanStore(state => state.setFilters);
  const clearFilters = useCapaLossPlanStore(state => state.clearFilters);
  const currVersionProgressStatus = useCapaLossPlanStore(
    state => state.currVersionProgressStatus
  );
  const openSearchArea = useCapaLossPlanStore(state => state.openSearchArea);
  const setOpenSearchArea = useCapaLossPlanStore(state => state.setOpenSearchArea);
  const staticColumns = useCapaLossPlanStore(state => state.staticColumns);
  const fetchStaticColumns = useCapaLossPlanStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCapaLossPlanStore(state => state.fetchStaticMeasures);
  const clearUserColumnLayout = useCapaLossPlanStore(state => state.clearUserColumnLayout);
  const initialized = useCapaLossPlanStore(state => state.initialized);

  const combos = useCapaLossPlanCombos();

  // 그리드가 보는 시트는 "확정 조회조건" 기준이다 — 조회 후 라디오만 바꿨다고 따라가면 안 된다.
  const condition = applied ?? sc;
  const sheetName = toSheetName(condition.progressStatus, condition.sheetType, condition.divisionType);
  // 조회조건을 바꾸는 동안에도 컬럼 메타는 "지금 고른" 시트를 따라가야 한다(BeforeFindData 재현).
  const pendingSheetName = toSheetName(sc.progressStatus, sc.sheetType, sc.divisionType);

  // 조회 2종 + 파생값(결과셋 해체 · 기간컬럼 · 편집가능 measure · 확정기간 잠금 · DAY_CNT · DDN 분모).
  const {
    rows,
    periodColumns,
    periodColumnNames,
    editableMeasures,
    scpPlanFixedColumns,
    dayCounts,
    prodCapaD,
    refetch,
  } = useCapaLossPlanQuery({
    tabId,
    filters,
    sheetName,
    progressStatus: condition.progressStatus,
    sheetType: condition.sheetType,
    isEditMode,
  });

  /**
   * Division 권한 0건 게이트 — AS-IS `SetDivisionAuthCheck`(cs:1488~1489 -> BaseForm:5995~6003).
   * 조회영역 전체 비활성 + 안내 1회. 권한 판정은 GROUP_ID 가 아니라 USER_ID 보유 권한 합집합이다
   * (콤보 `Division_SCP` 의 WHERE 가 `@sesUserId` 기준이라 결과 0건이 곧 권한 0건, hook #128).
   * AS-IS 번호 `MSG00097` 을 그대로 쓰면 "Please select Division." 이 뜬다 — `MSG00667` 이 정답(01 L-07).
   */
  const noDivisionAuth = initialized && combos.divisionOptions.length === 0;
  const notifiedAuthRef = useRef(false);
  useEffect(() => {
    if (!noDivisionAuth || notifiedAuthRef.current) return;
    notifiedAuthRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noDivisionAuth]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화 + 메타 1회 fetch(nscm-patterns §5-7).
    //   AS-IS `Form_Load` 도 `FindData` 를 부르지 않는다(02 §4.1, F-26).
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  /**
   * 컬럼/Measure 메타는 **시트 축**이다(8벌). 시트가 바뀌면 다시 받는다 — mount 1회 +
   * 시트 전환 + 매 Search(`handleSearch`)가 fetch 지점이다(CLAUDE.md §2 체크3).
   */
  useEffect(() => {
    void fetchStaticColumns(pendingSheetName, sc.divisionId);
    void fetchStaticMeasures(pendingSheetName);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pendingSheetName]);

  /**
   * Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5).
   * 컬럼 메타는 division 스코프라 여기서 새 division 을 인자로 넘겨 재조회한다 — producer 안에서
   * `get()` 으로 읽으면 커밋 전 이전 값이라 컬럼셋이 한 스텝 밀린다.
   */
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    clearUserColumnLayout();
    void fetchStaticColumns(pendingSheetName, sc.divisionId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  /**
   * `BeforeFindData` 5트리거(Division / Version / VersionSeq / SheetType / DivisionType) =
   * **그리드 비움 + EditTracker clear + 헤더 재구성**(02 §5.4, 01 V-05).
   * DivisionType·Status(→SheetType) 는 store 액션이 이미 `filters` 를 비우므로 여기서는
   * Version/VersionSeq 축과 EditTracker 만 처리한다 — **연쇄로 2회 이상 비우지 않는다**(hook #5 §1.4).
   */
  const prevVersionKeyRef = useRef(`${sc.version}|${sc.versionSeq}`);
  useEffect(() => {
    const versionKey = `${sc.version}|${sc.versionSeq}`;
    if (prevVersionKeyRef.current === versionKey) return;
    prevVersionKeyRef.current = versionKey;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.version, sc.versionSeq]);

  // 시트 전환 = CRUD 마킹 초기화 의무 — 시트마다 컬럼셋이 달라 dirty 가 넘어가면 payload 가 오염된다.
  const prevSheetRef = useRef(pendingSheetName);
  useEffect(() => {
    if (prevSheetRef.current === pendingSheetName) return;
    prevSheetRef.current = pendingSheetName;
    editTrackerRef.current?.clearChanges();
  }, [pendingSheetName]);

  /**
   * 조회(F5) — AS-IS `FindButton`. **필수 조회조건은 만들지 않는다**(F-28).
   * `refetch()` 를 직접 부르지 않는다. filters 참조 교체가 곧 재조회다(nscm-patterns §5-1).
   * 조회 성공 시 `isEditMode=false` 강제는 store `setFilters` 가 선반영한다(01 L-31).
   */
  const handleSearch = () => {
    if (noDivisionAuth) return;
    editTrackerRef.current?.clearChanges();
    const payload = combos.buildGetPayload();
    const targetSheet = toSheetName(sc.progressStatus, sc.sheetType, sc.divisionType);
    const fromYyyymm = toFromYyyymm(sc.version);
    setFilters(
      targetSheet,
      // `p_sheet_name` 은 **`_sheet_name` 8값**이다(F-25). `_sheet_status` 4값을 보내면 SP 가 못 찾는다.
      { ...payload, p_sheet_name: targetSheet },
      // 헤더 SP 는 반대로 **`_sheet_status` 4값**을 쓴다 — 축이 다른 것을 그대로 재현한다(V-12).
      fromYyyymm
        ? buildSpreadTitleFilters(
            fromYyyymm,
            MENU_ID,
            toSheetStatus(sc.progressStatus, sc.sheetType)
          )
        : undefined
    );
    void fetchStaticColumns(targetSheet, sc.divisionId);
    void fetchStaticMeasures(targetSheet);
  };

  /**
   * Edit — AS-IS `EditButton()` 의 가드를 순서 그대로 재현한다(01 L-10~L-15, 03 R-20).
   *   (0) 베이스 ACL `CanUpdate == false` -> `MSG00096` 후 차단(L-22).
   *       버튼 자체는 `hasButton('EDIT')` 로 이미 비노출이지만, 강제 호출 경로의 안내가 AS-IS 동작이다.
   *   (1) 그리드 미마운트 -> 무동작(메시지 없음)
   *   (2) 조회 결과 0건 -> **무동작**(메시지 없음). 상시편집으로 바꾸면 AS-IS 위반
   *   (3) 버전 진행상태 3분기 -> `judgeEditGate`
   * 판정 시점은 Load 가 아니라 **Edit 클릭 시점**이다 — Version 콤보가 바뀌면 값이 재계산된다.
   */
  const handleEdit = () => {
    if (!hasButton('EDIT')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_PERMISSION, { defaultValue: 'No permission.' }),
      });
      return;
    }
    if (!gridRef.current) return;
    if (rows.length === 0) return;
    const verdict = judgeEditGate(
      currVersionProgressStatus,
      condition.progressStatus,
      condition.sheetType
    );
    if (verdict.blocked) {
      void setAlert({
        type: 'alert',
        content: t(verdict.messageId ?? MSG.READ_ONLY, { defaultValue: 'Read-only.' }),
      });
      return;
    }
    setEditMode(!isEditMode);
  };

  /**
   * Insert — **명시적 무동작**. AS-IS `InsertButton()` 본문이 완전히 빈 `{}` 다(03 R-26).
   * `hotkeyConfig` 에서 키를 생략하면 공용 SubTitle 의 기본 `addRow` 가 살아나 AS-IS 에 없던
   * 행 추가가 생기고, `false` 로 주면 버튼이 사라져 시각적으로 달라진다 — 둘 다 오답이다(V-52).
   * AS-IS 캡처 툴바에 `(F8) Insert` 가 실제로 노출되고(decisions §B-4) 메타에도 등록한다(BLK-4 확정).
   */
  const handleInsert = () => undefined;

  /**
   * Delete — AS-IS `DeleteButton()`(03 R-25). 가드 3종(그리드 없음/빈 그리드/행 미선택)은 전부
   * 무동작이고, 선택행이 `'I'`(신규)일 때만 로컬 제거한다. Insert 가 NO-OP 라 신규행이 생기지
   * 않으므로 **실질 무동작**이다 — 기존 행이 지워지지 않는 것이 핵심이다(V-53).
   */
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (grid.rows.length === 0) return;
    if (!grid.selectedRows?.length) return;
    const selected = grid.selectedRows[0]?.dataItem as Scp0106Row | undefined;
    if (selected?.CRUD_TYPE !== 'I') return;
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  const { handleCellEditEnded } = useCapaLossPlanCellEdit({
    gridRef,
    editTrackerRef,
    progressStatus: condition.progressStatus,
    sheetType: condition.sheetType,
    divisionType: condition.divisionType,
    editableMeasures,
    dayCounts,
    prodCapaD,
  });

  const { handleSave } = useCapaLossPlanSave({
    gridRef,
    editTrackerRef,
    sheetName,
    periodColumnNames,
    version: condition.version,
    versionSeq: condition.versionSeq,
    progressStatus: condition.progressStatus,
    sheetType: condition.sheetType,
    divisionType: condition.divisionType,
    isEditMode,
    staticColumns: staticColumns[sheetName] ?? [],
    // AS-IS 는 SAVE -> GET 을 연쇄 실행한다. filters 가 그대로라 refetch 가 맞다(V-51).
    refetch,
  });

  /**
   * hotkeyConfig — `useTabBtnPermissions` 경유 의무(하드코딩 금지, CLAUDE.md §2 체크3).
   * `insert` 는 **키를 존재시킨 채 명시적 무동작 함수**다(위 handleInsert 주석).
   * `manual`/`upload` 는 AS-IS 에 없는 기능이라 false.
   *
   * Edit(AS-IS F2)는 여기 없다 — 공용 `Hotkeys` enum 에 `edit` 키가 없어 `customButtons` 로 노출한다
   * (자매 SCP0105/SCP0114 와 동일, asis_to_tobe §11).
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
   * AS-IS `btnColumn`(조회영역 우측 아이콘) -> SubTitle 공용 아이콘으로 이동(01 L-34, V-21).
   * 순서 규약은 `환율 -> GridColumnSet -> Measure`(hook #120). 환율은 미사용.
   *
   * **Measure 아이콘(`IcMeasureSelect`)은 이번 회차에 넣지 않았다 — 04 리포트 "확인필요".**
   *   (1) AS-IS SCP0106 툴바에 Measure 버튼이 없다(캡처 실측 11종에도 없음, decisions §B-4).
   *       L-34/V-21 의 "Measure 메타 109행 보유라 노출 대상" 은 AS-IS 파리티가 아니라 TO-BE 표준
   *       **확장** 제안이다.
   *   (2) 공용 `MeasureSelectModal` 은 `features/master/src/components` 에만 있다. supply 에서
   *       가져오면 feature 간 직접 import(convert-core §2.1 Top11 #2) + Hard Boundary(§2.2) 위반이다.
   *   해소 경로는 둘 중 하나다 — `MeasureSelectModal` 을 `packages/shared` 로 승격(분리 PR) 하거나,
   *   AS-IS 버튼셋 그대로가 맞다고 사용자가 확정. 추측으로 반쪽 배선을 만들지 않는다.
   */
  const customButtons = [
    // Edit — 라벨 `LBL00414`(EN 'Edit'). `LBL00654` 는 등록문구 'M$' 라 재사용 금지(hook #114).
    //   금지: `buttonLabel` 을 넘기지 않는다. SubTitle 이 `buttonLabel={label}` 뒤에 buttonProps 를
    //   전개하므로 화면이 주면 label 을 덮어써 빈 버튼이 되고, Edit 가 유일한 편집 진입점인 이 화면은
    //   Save/셀편집이 통째로 도달 불가해진다.
    ...(hasButton('EDIT')
      ? [
          {
            label: t('LBL00414', { defaultValue: 'Edit' }),
            title: t('LBL00414', { defaultValue: 'Edit' }),
            action: handleEdit,
          },
        ]
      : []),
    {
      label: t('LBL00605', { defaultValue: 'Column Setting' }),
      title: t('LBL00605', { defaultValue: 'Column Setting' }),
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
        <CapaLossPlanForm
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
        excelFileName='CapaLossPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />
      <CapaLossPlanGrid
        sheetName={sheetName}
        rows={rows}
        staticColumns={staticColumns[sheetName] ?? []}
        periodColumns={periodColumns}
        isEditMode={isEditMode}
        progressStatus={condition.progressStatus}
        sheetType={condition.sheetType}
        divisionType={condition.divisionType}
        editableMeasures={editableMeasures}
        scpPlanFixedColumns={scpPlanFixedColumns}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onCellEditEnded={handleCellEditEnded}
      />

      <CapaLossPlanColumnModal
        open={openColumnSetting}
        onClose={() => setOpenColumnSetting(false)}
        sheetName={sheetName}
        divisionId={sc.divisionId}
      />

      <CapaLossPlanItemPopup open={openItemPopup} onClose={() => setOpenItemPopup(false)} />
    </>
  );
};
