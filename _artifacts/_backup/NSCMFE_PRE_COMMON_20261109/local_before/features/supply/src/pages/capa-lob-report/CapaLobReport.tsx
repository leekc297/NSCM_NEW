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
  PRE_VERSION_LABEL,
  PROGRESS_STATUS,
  SHEETS,
  sheetOf,
} from './capa-lob-report.constants';
import type { CapaLobRow, SpreadTitleRow } from './capa-lob-report.types';
import { CapaLobReportForm } from './components/CapaLobReportForm';
import { CapaLobReportGrid } from './components/CapaLobReportGrid';
import { CapaLobReportColumnModal } from './components/modals/CapaLobReportColumnModal';
import { CapaLobReportItemPopup } from './components/modals/CapaLobReportItemPopup';
import { useCapaLobReportCombos } from './hooks/useCapaLobReportCombos';
import { useCapaLobReportConditionEffects } from './hooks/useCapaLobReportConditionEffects';
import { useCapaLobReportStore } from './useCapaLobReportStore';
import {
  buildBottleneckIndex,
  pickBottleneckRows,
  pickDataRows,
} from './utils/capaLobReport.cursors';
import {
  buildPeriodColumns,
  periodColumnSignature,
} from './utils/capaLobReport.dateColumns';

/**
 * AS-IS GSCM.SCP.Forms.UIL Report/SCP0108_CAPA_LOB_Report — CAPA LOB Report(메뉴 Title "LOB Report").
 *   설계: .atlas/gscm-design/SCP0108/design/00~03. 상세 매핑: __asis-mapping__.md.
 *   도메인 SCP -> features/supply. 라우트는 폴더 + DB `ROUTE_PATH='supply/capa-lob-report'` 로만 해석된다.
 *
 *   **전건 조회전용 Report** 다 — 편집·저장·measure·셀콤보가 코드·메타·SP 어디에도 없다.
 *   그래서 이 화면에는 다음이 존재하지 않는다(자매 SCP0104/0105/0106 에서 복사하면 전부 오답):
 *     `useProcMutation`/`useSaveWithValidation`/`EditTracker`/`CRUD_TYPE` · `isEditMode` state ·
 *     `fetchStaticMeasures`/`staticMeasures` · `_ASSIGN_PRIORITY` · Edit 버튼 · 시트 탭 UI.
 *
 *   한 그리드 + `sheetName`(CURRENT/CUTOFF) 스위치. 시트는 Status(사용자 조작 불가 파생값)가 정한다.
 *   조회·동적 월 헤더 런타임 체인은 `PKG_SCP0108`·`PKG_SCP0104` 미배포라 미완이다(goal.md BLK-1 —
 *   convert-sp 후속).
 *
 *   Page 는 조립만 한다 — 콤보·cascade 는 `hooks/useCapaLobReportCombos`, 조회조건 변경 시 그리드 비움·
 *   기간헤더 갱신은 `hooks/useCapaLobReportConditionEffects`, 모달 2종은 `components/modals/*` 다.
 */
export const CapaLobReport = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openItemPopup, setOpenItemPopup] = useState(false);

  const sp = useCapaLobReportStore(state => state.searchParams);
  const filters = useCapaLobReportStore(state => state.filters);
  const setFilters = useCapaLobReportStore(state => state.setFilters);
  const currVersionProgressStatus = useCapaLobReportStore(
    state => state.currVersionProgressStatus
  );
  const openSearchArea = useCapaLobReportStore(state => state.openSearchArea);
  const setOpenSearchArea = useCapaLobReportStore(state => state.setOpenSearchArea);
  const staticColumns = useCapaLobReportStore(state => state.staticColumns);
  const fetchStaticColumns = useCapaLobReportStore(state => state.fetchStaticColumns);
  const columnMetaFailed = useCapaLobReportStore(state => state.columnMetaFailed);

  const combos = useCapaLobReportCombos();

  // 시트 = `_progress_status == '0'` ? CURRENT : CUTOFF (cs:376~389). 탭이 아니라 스위치다(03 R-01/R-02).
  const sheetName = sheetOf(sp.progressStatus);

  /**
   * CURRENT / CUTOFF 는 서로 다른 GET SP 라 시트별 쿼리를 건다. `filters` 에는 확정 시트 1건만 담기므로
   * 두 시트 데이터를 동시에 들고 있지 않는다. `enabled` 로 **진입 자동조회를 막는다**(03 §4.1 #3 / V-21).
   */
  const currentQuery = useTabProcQuery<MENU_ID, typeof SHEETS.CURRENT>({
    menuId: MENU_ID,
    sheetName: SHEETS.CURRENT,
    tabId,
    filters: filters[SHEETS.CURRENT],
    enabled: !!filters[SHEETS.CURRENT],
  });
  const cutoffQuery = useTabProcQuery<MENU_ID, typeof SHEETS.CUTOFF>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUTOFF,
    tabId,
    filters: filters[SHEETS.CUTOFF],
    enabled: !!filters[SHEETS.CUTOFF],
  });
  /**
   * 동적 기간 헤더 — 그리드 데이터와 **별도 시트**로 조회한다(03 §2.1). 조회(F5)에 묶여 있지 않고
   * 조회조건 변경 시점에 갱신된다(AS-IS `GetSpdTitle` 호출 지점이 `FindButton` 이 아니다, 03 §2.6).
   */
  const spreadTitleQuery = useTabProcQuery<MENU_ID, typeof SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const activeQuery = sheetName === SHEETS.CUTOFF ? cutoffQuery : currentQuery;

  /**
   * 커서 2개 소비(03 R-11 / V-26 / hook #80). `itemsSource` 는 `useMemo` 로 참조를 안정화한다 —
   * 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(nscm-patterns §5-4).
   * **정렬을 FE 에서 추가하지 않는다**: CURRENT SP 는 `ORDER BY` 가 없어 서버 반환 순서가 곧 AS-IS
   * 표시 순서이고, CUTOFF 는 SP 정렬(합계행 `DV='1'` 이 상세행보다 위)을 그대로 유지한다(03 V-24/V-25).
   */
  const rows = useMemo<CapaLobRow[]>(() => pickDataRows(activeQuery.data), [activeQuery.data]);
  const bottleneckIndex = useMemo(
    () => buildBottleneckIndex(pickBottleneckRows(activeQuery.data)),
    [activeQuery.data]
  );
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (pickDataRows(spreadTitleQuery.data) as unknown as SpreadTitleRow[]),
    [spreadTitleQuery.data]
  );

  /**
   * **컬럼셋의 단일 출처는 헤더 SP 결과**다(03 §2.4 / V-17). CURRENT 응답에는 헤더에 없는 과거 월
   * 컬럼이 최대 11개 더 붙어 오는데(데이터는 `SCM_MST_BUCKET`, 헤더는 `SCM_SYS_CALENDAR_M`),
   * 응답 컬럼을 컬럼셋 출처로 삼으면 그 과거 월이 그리드에 나타난다.
   * 서명이 같으면 같은 참조를 유지한다 — 참조가 바뀌면 Wijmo 가 전 컬럼을 재생성한다.
   */
  const periodSignature = periodColumnSignature(spreadTitleRows);
  const periodColumns = useMemo(
    () => buildPeriodColumns(spreadTitleRows),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [periodSignature]
  );

  /**
   * Division 권한 0건 게이트 — AS-IS `SetDivisionAuthCheck`(cs:1133~1134 -> BaseForm:5269~5277)가
   * `usrLayoutControl2.Enabled=false` + 메시지 1회를 한다(01 L-04 / 02 §4.3 / V-23).
   * 판정 시점은 **Division 콤보 응답 수신 후**다 — 컬럼 메타 fetch 완료(`initialized`)를 기준으로 쓰면
   * 두 비동기의 경쟁조건에 걸려 정상 권한 사용자에게도 알림이 뜨고 조회영역이 잠긴다(자매 실사고).
   * 메시지 번호는 **`MSG00667`** 이다 — AS-IS `MSG00097` 을 그대로 쓰면 "Please select Division." 이
   * 뜬다(hook #114, 메모리 `msg00097-tobe-select-division-not-permission`).
   * 판정은 **성공 수신(`isSuccess`)** 기준이다 — 조회 실패(`isError`)를 권한 0건으로 묶으면 네트워크
   * 오류에 조회영역이 통째로 잠기고 "권한 없음" 오안내가 뜬다(iter-1 G-03). 실패는 아래 별도 분기다.
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
   * 콤보 조회 실패 — 권한 게이트와 다른 분기다(조회영역을 잠그지 않는다. 재시도 가능해야 한다).
   * `MSG01390` = "An error occurred while initializing the search conditions."(문구 역조회 실측).
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

  /**
   * 컬럼 메타 조회 실패 — 그리드가 컬럼 0개로 렌더되는 상태의 원인을 알린다(iter-1 G-11).
   * store 의 빈 catch 가 실패를 삼키던 자리다 — console 금지 룰이라 상태 플래그 -> 안내로 잇는다.
   */
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

  useCapaLobReportConditionEffects({
    tabId,
    divisionId: sp.divisionId,
    divisionType: sp.divisionType,
    verId: sp.verId,
    verSeq: sp.verSeq,
    progressStatus: sp.progressStatus,
  });

  /**
   * 조회(F5) — AS-IS `FindButton()`(cs:1267~1282) 가드 2건을 순서 그대로 재현한다.
   *   (1) Division 권한 0건 -> 무동작(01 L-23. AS-IS 는 클릭마다 같은 alert 을 띄우지만 TO-BE 는
   *       Load 1회 안내 + 조회영역 비활성으로 통일한다 — 01 V-07 의 "의도적 차이")
   *   (2) 선택 버전의 **현재 진행상태**가 `-`(Pre) -> `MSG01410` 후 차단(01 L-22 / V-08).
   *       판정 대상은 Status 콤보값이 아니라 `PROG_STAT` 이다 — 혼동하면 조회 가능 조건이 통째로 달라진다.
   *       i18next 기본 보간자는 `{{ }}` 라 DB 문구의 `{0}` 은 `.replace` 로 치환한다.
   * 재조회는 `setFilters()` 참조 교체로만 한다(`refetch()` 직접 호출 금지).
   * 컬럼 메타는 **Search 마다** refetch 한다(CLAUDE.md §2 체크3).
   */
  const handleSearch = () => {
    if (noDivisionAuth) return;
    if (currVersionProgressStatus === PROGRESS_STATUS.PRE) {
      const template = t(MSG.PRE_VERSION_BLOCKED, {
        defaultValue: 'Cannot be retrieved because the progress status is before {0}',
      });
      void setAlert({ type: 'alert', content: template.replace('{0}', PRE_VERSION_LABEL) });
      return;
    }
    setFilters(combos.buildGetPayload());
    void fetchStaticColumns();
  };

  /**
   * Insert(F8) / Delete(F9) — **관측 동작이 무동작이 아니다.** 베이스 `CheckValidation` 이 시트 잠금
   * (`IsLock` 영구 true, 01 L-32)을 보고 각각 `MSG00008`/`MSG00009` 를 띄우고 화면 override 에
   * 도달하지 않는다. TO-BE 는 **키를 존재시킨 채 alert 핸들러**를 둔다(TO-BE 코드는 `MSG01044`/
   * `MSG01045` — AS-IS 번호를 그대로 쓰면 전혀 다른 문구가 뜬다).
   *   `false`      -> 버튼이 사라져 AS-IS 와 시각적으로 달라진다
   *   키 생략      -> 공용 SubTitle 기본 `addRow`/`removeRow` 가 살아나 AS-IS 에 없던 행 추가·삭제가 생긴다
   * 둘 다 오답이다(01 L-27 / V-11·V-12 / 03 R-14 / V-30). 행 추가·제거 로직은 만들지 않는다.
   * 등록 여부는 사용자 확정 완료 — `MNU_BTN_CD` 에 INSERT/DELETE 를 등록한다(goal.md BLK-4 DECIDED).
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
   * `save: false` — 저장 SP 가 존재하지 않는다(`QueryDics` 는 `DIC_GET_CAPA_LOB` 하나뿐, 03 §4.3).
   *   AS-IS Save 는 `MSG00010` alert 만 뜨지만 저장 경로 자체가 없으므로 버튼을 노출하지 않는다
   *   (사용자 확정: SAVE·EDIT 메타 미등록, goal.md BLK-4).
   * Edit 는 `customButtons` 에도 만들지 않는다 — AS-IS override 가 없어 클릭해도 메시지조차 없고
   *   편집모드 state 자체가 없다(01 L-31/L-33 / V-14).
   * `manual`/`upload` 는 AS-IS 에 없는 기능이라 false. Sort/Filter/Condition/Excel/Help 는 공통
   *   `SubTitle` 이 제공하므로 키를 생략한다(01 L-31 / hook #63).
   */
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: false,
    manual: false,
    upload: false,
  };

  /**
   * AS-IS `btnColumn`(조회영역 우측 아이콘) -> `SubTitle` 공용 아이콘으로 이동(01 L-21 / V-16).
   * 이 화면은 환율·Measure 를 쓰지 않아 **GridColumnSet 1개만** 둔다(순서 규약 hook #120 충족).
   * 금지: `buttonLabel` 을 넘기지 않으면 SubTitle 이 label 을 그려 아이콘 옆에 글자가 남는다 —
   * 자매 선례대로 빈 문자열을 명시한다.
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
        <CapaLobReportForm
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
        // 조회 건수 — AS-IS `SetSearchCount(ds)`(cs:1411). 별도 건수 라벨을 만들지 않는다(01 L-37).
        dataCount={rows.length}
        // 엑셀은 공통 경로다 — 자체 `XLSX.writeFile` 금지(01 L-31 / 03 V-39).
        excelFileName='CapaLobReport'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sp}
        customButtons={customButtons}
      />
      <CapaLobReportGrid
        sheetName={sheetName}
        rows={rows}
        staticColumns={staticColumns[sheetName]}
        periodColumns={periodColumns}
        bottleneckIndex={bottleneckIndex}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
      />

      {/* 조건부 마운트(hook #50) — 닫힌 모달이 컬럼 메타를 들고 있지 않게 한다. */}
      {openColumnSetting && (
        <CapaLobReportColumnModal
          open={openColumnSetting}
          onClose={() => setOpenColumnSetting(false)}
          sheetName={sheetName}
        />
      )}
      {openItemPopup && (
        <CapaLobReportItemPopup open={openItemPopup} onClose={() => setOpenItemPopup(false)} />
      )}
    </>
  );
};
