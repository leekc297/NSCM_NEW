import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  MENU_ID,
  MSG,
  REQUIRED_PROG_STAT,
  REQUIRED_PROG_STAT_LABEL,
  SHEETS,
  SHEET_NAME_BY_DIVISION_TYPE,
} from './capa-teep-report.constants';
import type { CapaTeepRow, SpreadTitleRow } from './capa-teep-report.types';
import { CapaTeepReportForm } from './components/CapaTeepReportForm';
import { CapaTeepReportGrid } from './components/CapaTeepReportGrid';
import { CapaTeepReportColumnModal } from './components/modals/CapaTeepReportColumnModal';
import { useCapaTeepReportCombos } from './hooks/useCapaTeepReportCombos';
import { useCapaTeepReportConditionEffects } from './hooks/useCapaTeepReportConditionEffects';
import { useCapaTeepReportStore } from './useCapaTeepReportStore';
import { pickDataRows, pickSpreadTitleRows } from './utils/capaTeepReport.cursors';
import { buildPeriodColumns, periodColumnSignature } from './utils/capaTeepReport.dateColumns';

/**
 * AS-IS GSCM.SCP.Forms.UIL Report/SCP0107_CAPA_TEEP_Report — CAPA TEEP Report(메뉴 Title "TEEP Report").
 *   설계: .atlas/gscm-design/SCP0107/design/00~03. 확정 결정: convert-flow/goal.md ⑥-1.
 *   상세 매핑: __asis-mapping__.md. 도메인 SCP -> features/supply.
 *   라우트는 폴더 + DB `ROUTE_PATH='supply/capa-teep-report'` 로만 해석된다(라우트 코드 수정 없음).
 *
 *   **조회 전용 리포트** 다 — `SaveButton`/`EditButton` override 0건, `INPUT_TP_CD='S'` 50행 전건,
 *   시트 lock 영구 true(01 L-21), 조회 직후 `LockColumn(0,max,true)`(cs:1510). 그래서 이 화면에는
 *   `useProcMutation`/`useSaveWithValidation`/`EditTracker`/`isEditMode` 가 **존재하지 않는다**(V-28/V-29).
 *
 *   한 그리드 + `sheetName`(ASSEMBLY/ELTR) 스위치. 시트는 Operation group(=`divisionType`) 파생이며
 *   **그 파생값 하나가 시트축·GET SP 변형·헤더 SP 의 `p_sheet_name` 을 전부 결정한다**(03 §4.1) —
 *   AS-IS 가 헤더 호출만 다른 식을 쓰던 불일치(01 L-19)는 TO-BE 에서 단일 출처로 해소했다.
 *
 *   조회·동적 기간 헤더 런타임 체인은 `PKG_SCP0107`·`PKG_SCP0104` **미배포**라 미완이다
 *   (goal ② / 03 §6-6·§6-7 — convert-sp 후속). 이 회차에서 "조회 정상 동작" 으로 보고하지 않는다.
 *
 *   Page 는 조립만 한다 — 콤보·cascade 는 `hooks/useCapaTeepReportCombos`, 조회조건 변경 시 그리드 비움·
 *   기간헤더 갱신은 `hooks/useCapaTeepReportConditionEffects`, 컬럼 모달은 `components/modals/*` 다.
 *   미이식 확정분(사유는 `__asis-mapping__.md`): `POPUP/SCP0107_CAPAReportPopup`(L-22 — `.csproj`
 *   `<Compile Include>` 부재 = 컴파일 대상 아님) · 사장 노드 `usrLayoutControl1`/`layoutControlGroup1`
 *   (L-05/L-06) · Designer 초기 시트 `spdMain_Sheet1` · Delete 가드 3건(L-07~L-09 — 도달 불가).
 */
export const CapaTeepReport = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);

  const sp = useCapaTeepReportStore(state => state.searchParams);
  const filters = useCapaTeepReportStore(state => state.filters);
  const setFilters = useCapaTeepReportStore(state => state.setFilters);
  const currVersionProgressStatus = useCapaTeepReportStore(
    state => state.currVersionProgressStatus
  );
  const openSearchArea = useCapaTeepReportStore(state => state.openSearchArea);
  const setOpenSearchArea = useCapaTeepReportStore(state => state.setOpenSearchArea);
  const staticColumns = useCapaTeepReportStore(state => state.staticColumns);
  const fetchStaticColumns = useCapaTeepReportStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCapaTeepReportStore(state => state.fetchStaticMeasures);
  const columnMetaFailed = useCapaTeepReportStore(state => state.columnMetaFailed);

  const combos = useCapaTeepReportCombos();

  // 시트 = `GetDivisionTypeName(_division_type)` 등가 파생(03 G-01 / V-31). 탭이 아니라 스위치다.
  const sheetName = SHEET_NAME_BY_DIVISION_TYPE[sp.divisionType];

  /**
   * ASSEMBLY / ELTR 는 서로 다른 GET SP 라 시트별 쿼리를 건다. `filters` 에는 확정 시트 1건만 담기므로
   * 두 시트 데이터를 동시에 들고 있지 않다. `enabled` 로 **진입 자동조회를 막는다**(02 §4.1 / V-32).
   */
  const assemblyQuery = useTabProcQuery<MENU_ID, typeof SHEETS.ASSEMBLY>({
    menuId: MENU_ID,
    sheetName: SHEETS.ASSEMBLY,
    tabId,
    filters: filters[SHEETS.ASSEMBLY],
    enabled: !!filters[SHEETS.ASSEMBLY],
  });
  const eltrQuery = useTabProcQuery<MENU_ID, typeof SHEETS.ELTR>({
    menuId: MENU_ID,
    sheetName: SHEETS.ELTR,
    tabId,
    filters: filters[SHEETS.ELTR],
    enabled: !!filters[SHEETS.ELTR],
  });
  /**
   * 동적 기간 헤더 — 그리드 데이터와 **별도 시트**로 조회한다(03 §2.1). 조회(F5)에 묶여 있지 않고
   * 조회조건 변경 시점에 갱신된다(AS-IS `GetSpdTitle` 호출 지점이 `FindButton` 이 아니다, 03 §2.5).
   * 캐시 키 3축(`programId`+`sheetName`+`fromYyyymm`)은 `buildSpreadTitleFilters` 가 보장한다(V-18d).
   */
  const spreadTitleQuery = useTabProcQuery<MENU_ID, typeof SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const activeQuery = sheetName === SHEETS.ELTR ? eltrQuery : assemblyQuery;

  /**
   * 커서 1개 소비(03 §1.6 / hook #80). `itemsSource` 는 `useMemo` 로 참조를 안정화한다 —
   * 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(nscm-patterns §5-4).
   * **정렬을 FE 에서 추가하지 않는다** — SP `ORDER BY`(전체 Total -> Division Total -> 상세, 그 안에서
   * measure `SORT_ORDER_NO`)가 곧 AS-IS 표시 순서다(03 §4.3).
   */
  const rows = useMemo<CapaTeepRow[]>(() => pickDataRows(activeQuery.data), [activeQuery.data]);
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => pickSpreadTitleRows(spreadTitleQuery.data),
    [spreadTitleQuery.data]
  );

  /**
   * **컬럼셋의 단일 출처는 헤더 SP 결과**다(03 §2). 서명이 같으면 같은 참조를 유지한다 —
   * 참조가 바뀌면 Wijmo 가 전 컬럼(3단 헤더 포함)을 재생성해 헤더가 흔들린다.
   */
  const periodSignature = periodColumnSignature(spreadTitleRows);
  const periodColumns = useMemo(
    () => buildPeriodColumns(spreadTitleRows),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature]
  );

  /**
   * Division 권한 0건 게이트 — AS-IS `SetDivisionAuthCheck`(cs:1131~1132 -> BaseForm:5269~5277)가
   * `usrLayoutControl2.Enabled=false` + 메시지 1회를 한다(01 L-04 / §3 (a) / V-06).
   * 권한 판정은 GROUP_ID 가 아니라 **USER_ID 보유 권한 합집합**이다 — 콤보 `Division_SCP` 의 WHERE 가
   * `@sesUserId` 기준이라 결과 0건이 곧 권한 0건이다(hook #128).
   * 판정 시점은 **Division 콤보 성공 수신 후**다. `initialized`(컬럼 메타 완료)를 기준으로 쓰면 두 비동기의
   * 경쟁조건에 걸려 정상 권한 사용자에게도 알림이 뜨고 조회영역이 잠긴다(자매 실사고).
   * 메시지 번호는 **`MSG00667`** 이다 — AS-IS `MSG00097` 을 그대로 쓰면 "Please select Division." 이
   * 뜬다(hook #114, 메모리 `msg00097-tobe-select-division-not-permission`).
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

  /**
   * 콤보 조회 실패 — 권한 게이트와 **다른 분기**다(조회영역을 잠그지 않는다. 재시도 가능해야 한다).
   * 실패를 권한 없음으로 묶으면 네트워크 오류에 조회영역이 통째로 잠긴다(자매 SCP0108 iter-1 G-03).
   */
  const notifiedComboErrorRef = useRef(false);
  useEffect(() => {
    if (!combos.isDivisionError || notifiedComboErrorRef.current) return;
    notifiedComboErrorRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.COMBO_LOAD_FAIL, {
        defaultValue: 'An error occurred while initializing the search conditions.',
      }),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [combos.isDivisionError]);

  /** 컬럼 메타 조회 실패 — 그리드가 컬럼 0개로 렌더되는 원인을 알린다(store 의 빈 catch 보완). */
  const notifiedColumnMetaRef = useRef(false);
  useEffect(() => {
    if (!columnMetaFailed || notifiedColumnMetaRef.current) return;
    notifiedColumnMetaRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.COLUMN_META_FAIL, '_An error has occurred when inquiring.'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columnMetaFailed]);

  useCapaTeepReportConditionEffects({
    tabId,
    divisionId: sp.divisionId,
    divisionType: sp.divisionType,
    verId: sp.verId,
    verSeq: sp.verSeq,
  });

  /**
   * 조회(F5) — AS-IS `FindButton()`(cs:1338~1351) 가드 2건을 재현한다. 단 **평가 순서는 AS-IS 와
   * 반대다(의도적 차이)**: AS-IS 는 진행상태(`MSG00423`) -> 권한(`MSG00097`) 순이고 여기서는 권한 ->
   * 진행상태 순이다. 권한 0건 사용자는 Version 후보도 0건이라 진행상태가 `'0'` 으로 파생돼 두 가드가
   * 동시에 성립하는데, 그 경우 설계 `01 §4 V-06`("Search 를 눌러도 동일 메시지 `MSG00667`")이 권한
   * 안내를 요구하므로 권한을 먼저 본다. 근거·판단은 `__asis-mapping__.md §12` 의도적 차이 표 참조
   * (iter-2 감사 G-06 — "순서 그대로" 라고 적혀 있던 이전 주석이 사실과 달라 정정).
   *   (1) Division 권한 0건 -> `MSG00667` 안내 후 차단(01 L-04 / §3 (a) / V-06). AS-IS
   *       `checkRequiredOfSearch`(cs:1347 -> `DataUtil:390~416`)가 **클릭마다** 안내를 띄우므로
   *       조용한 early-return 은 오답이다(iter-1 감사 R-05). Load 1회 안내는 진입 시 1회일 뿐이고,
   *       그 알림을 닫은 뒤 Search 를 누르면 아무 반응이 없어 "조회가 먹지 않는" 화면이 된다.
   *   (2) 선택 버전의 **현재 진행상태**가 2차 컷오프가 아니면 -> `MSG01410` 후 차단(02 §4.4 / V-07).
   *       판정 대상은 조회조건 콤보값이 아니라 `PROG_STAT` 이다. AS-IS 번호 `MSG00423` 하드코딩 금지.
   *       i18next 기본 보간자는 `{{ }}` 라 DB 문구의 `{0}` 은 `.replace` 로 치환한다.
   * 재조회는 `setFilters()` 참조 교체로만 한다 — **`refetch()` 직접 호출 금지**(nscm-patterns §5-1).
   * 컬럼·Measure 메타는 **Search 마다** refetch 한다(CLAUDE.md §2 체크3).
   * **필수 조회조건은 만들지 않는다**(AS-IS `*` 라벨 0건, 01 §3).
   */
  const handleSearch = () => {
    if (noDivisionAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
      return;
    }
    if (currVersionProgressStatus !== REQUIRED_PROG_STAT) {
      const template = t(MSG.PROG_STAT_BLOCKED, {
        defaultValue: 'Cannot be retrieved because the progress status is before {0}',
      });
      void setAlert({
        type: 'alert',
        content: template.replace('{0}', REQUIRED_PROG_STAT_LABEL),
      });
      return;
    }
    setFilters(sheetName, combos.buildGetPayload());
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  /**
   * Insert(F8) / Delete(F9) — **관측 동작이 무동작이 아니다.** 베이스 `CheckValidation` 이 시트 잠금
   * (`IsLock` 영구 true, 01 L-21)을 보고 각각 `MSG00008`/`MSG00009` 를 띄우고 화면 override 에 도달하지
   * 않는다(01 L-12/L-14 — `BaseForm:3199~3218` + `3313~3337` 실측). 사용자 확정(goal D-2 = "메시지 재현 +
   * 메타 등록")대로 **키를 존재시킨 채 alert 핸들러**를 둔다. TO-BE 코드는 `MSG01044`/`MSG01045` 다 —
   * AS-IS 번호를 그대로 쓰면 전혀 다른 문구가 뜬다(01 §2-F).
   *   `false`  -> 버튼이 사라져 AS-IS 와 시각적으로 달라진다
   *   키 생략  -> 공용 SubTitle 기본 `addRow`/`removeRow` 가 살아나 AS-IS 에 없던 행 추가·삭제가 생긴다
   * 둘 다 오답이다(01 §2-E / V-08·V-09 / 03 V-30). 행 추가·제거 로직은 만들지 않는다.
   * AS-IS 화면 `DeleteButton()` 의 가드 3건(L-07~L-09)도 이식하지 않는다 — 베이스가 먼저 차단해 그 가드가
   * 실행되는 상태가 존재하지 않고, 이식하면 "선택 행이 있으면 삭제됨" 경로를 새로 만들 위험이 있다.
   */
  const handleInsert = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.CANNOT_INSERT, {
        defaultValue: 'Can not add as it is not in modify mode.',
      }),
    });
  };
  const handleDelete = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.CANNOT_DELETE, {
        defaultValue: 'Can not delete as it is not in modify mode.',
      }),
    });
  };

  /**
   * hotkeyConfig — 전 항목 `useTabBtnPermissions().hasButton()` 조건부(하드코딩 금지, CLAUDE.md §2 체크3).
   * `save: false` — 저장 SP 가 존재하지 않고 `SaveButton` override 도 없다(03 §4.4 / V-10·V-29).
   * Edit 는 `customButtons` 에도 만들지 않는다 — AS-IS `EditButton` override 가 0건이라 편집모드 자체가
   *   없다(01 §2-E / V-10·V-13). 자매 SCP0105/0106 의 Edit 버튼을 복사하면 AS-IS 에 없는 경로가 생긴다.
   * `manual`/`upload` 는 AS-IS 에 없는 기능이라 false. Sort/Filter/Condition/Help 는 공용
   *   `SubTitle` 이 제공하므로 키를 생략한다(01 §3 / L-23 / hook #63).
   * Excel 도 동작은 공용 소관이지만 **노출은 admin 권한을 따른다** — 아래 EXCEL 주석 참조.
   */
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: false,
    manual: false,
    upload: false,
    /**
     * EXCEL — `SCM_ADM_MNU_BTN_MPG_M` 에 (ASSEMBLY, ELTR) x EXCEL 2행이 등록돼 있고
     * `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 이 그룹별로 부여한다. 키를 아예 생략하면 공용 SubTitle 기본
     * 액션이 무조건 살아나 **admin 에서 끈 버튼이 화면에 남는다**(CLAUDE.md §2 체크3 / SCM0008 유형).
     * 권한이 없을 때만 `excel: false` 키를 넣어 숨기고, 권한이 있으면 **키 자체를 넣지 않는다** —
     * `excel: undefined` 로 쓰면 `SubTitle` 의 `{ ...DefaultButtonActions, ...hotkeyConfig }` 스프레드가
     * 기본 다운로드 액션을 `undefined` 로 덮어써 버튼이 보이면서 눌리지 않는 상태가 된다.
     * 동작 자체는 공용 핸들러 그대로이므로 AS-IS 파리티(ExcelButton override 0건)는 유지된다.
     */
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  /**
   * AS-IS `btnColumn`(조회영역 3단 우측 24x24 아이콘) -> `SubTitle` 공용 아이콘으로 이동(01 L-20 / V-11).
   * 순서 규약은 `환율(IcExchangeRate) -> GridColumnSet(IcGridColumnSetup) -> Measure(IcMeasureSelect)`
   * (hook #120). 이 화면은 환율을 쓰지 않는다.
   *
   * **Measure Setting 아이콘(3번째 자리)은 미노출로 확정됐다 — 사용자 지시 2026-09-25(iter-2 R-06).**
   *   (1) AS-IS SCP0107 툴바에 Measure 버튼이 **0건**이다. `btnColumn` 이 유일하고 그 인자는
   *       `SCM002_CAPAColumnPopup("SCP0107", sheet, true)` = `isColumn:true` -> TitleSet 타입 `'C'` 뿐이며
   *       Measure 타입(`'M'`) 호출은 소스 전수에서 0건이다(cs:1765~1778). 설계 V-11/V-35 의 "Measure 메타
   *       56행 보유라 노출 대상" 은 AS-IS 파리티가 아니라 **TO-BE 표준 확장** 제안이었고, 사용자가 이
   *       화면에서는 확장을 채택하지 않기로 확정했다(설계 L-20 / 01 V-11 / 03 V-35 정정 완료).
   *   (2) 공용 Measure 모달이 `packages/shared` 에 없다 — `MeasureSelectModal` 은 `features/demand`
   *       전용이라 supply 에서 import 하면 feature 간 직접 import(convert-core §2.1 #2) + Hard Boundary
   *       (§2.2) 위반이고, 화면 사본을 만드는 것은 hook #132 §2-1 위반이다. `packages/shared` 승격은
   *       이 화면 범위 밖의 **별도 과제로 상신**한다.
   *   이 건은 이후 회차에서 다시 갭으로 올리지 않는다(사용자 확정 — goal ⑥-1 iter-2 표).
   *   `staticMeasures` 는 메타 존재 확인용으로 fetch 해 둔다(CLAUDE.md §2 체크3).
   *
   * 금지: `buttonLabel` 을 비우지 않으면 SubTitle 이 label 을 그려 아이콘 옆에 글자가 남는다.
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
        <CapaTeepReportForm
          combos={combos}
          onSearch={handleSearch}
          disabled={noDivisionAuth}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        // 조회 건수 — AS-IS `SetSearchCount(ds)`(cs:1515 / 03 G-17). 별도 건수 라벨을 만들지 않는다.
        dataCount={rows.length}
        // 엑셀은 공통 경로다(AS-IS `ExcelButton` override 0건 — 01 §2-E / 03 V-39).
        excelFileName='CapaTeepReport'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sp}
        customButtons={customButtons}
      />
      <CapaTeepReportGrid
        sheetName={sheetName}
        rows={rows}
        staticColumns={staticColumns[sheetName]}
        periodColumns={periodColumns}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
      />

      {/* 조건부 마운트 — 닫힌 모달이 컬럼 메타를 들고 있지 않게 한다. */}
      {openColumnSetting && (
        <CapaTeepReportColumnModal
          open={openColumnSetting}
          onClose={() => setOpenColumnSetting(false)}
          sheetName={sheetName}
        />
      )}
    </>
  );
};
