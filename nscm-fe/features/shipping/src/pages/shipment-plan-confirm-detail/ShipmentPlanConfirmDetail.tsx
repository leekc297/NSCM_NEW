import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, MainTitle, SubTitle, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { BodDetailModal } from './components/modals/BodDetailModal';
import { ShipmentRequestDetailModal } from './components/modals/ShipmentRequestDetailModal';
import { ShipmentPlanConfirmDetailForm } from './components/ShipmentPlanConfirmDetailForm';
import { ShipmentPlanConfirmDetailGrid } from './components/ShipmentPlanConfirmDetailGrid';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './shipment-plan-confirm-detail.constants';
import type { DrilldownParams, MainRow } from './shipment-plan-confirm-detail.types';
import styles from './ShipmentPlanConfirmDetail.module.scss';
import { useShipmentPlanConfirmDetailStore } from './useShipmentPlanConfirmDetailStore';

// AS-IS GSCM.SSP.Plan.UIL SSP0012_ShipmentPlanConfirmDetail — 출하계획 확정 상세(읽기전용 조회 + 47컬럼 상세).
//   설계: .atlas/gscm-design/SSP0012/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find=실동작 / Insert·Delete·Save=NO-OP. 편집·저장·동적 PIVOT 없음(전열 읽기전용).
//   AS-IS Edit(읽기전용 가드 MSG00109)는 미이식 — TO-BE 표준은 편집모드 토글 버튼을 두지 않는다
//   (convert-core §2.4 / analysis.md ANL-06). 읽기전용 화면이라 처음부터 잠긴 상태로 열리고 Edit 트리거는 소멸.
//   주의: PKG_SSP0012 미배포(convert-sp 후속) — 실 조회/Period 서버기본값 런타임 검증은 SP 배포 후.
export const ShipmentPlanConfirmDetail = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useShipmentPlanConfirmDetailStore(s => s.searchCondition);
  const setSearchCondition = useShipmentPlanConfirmDetailStore(s => s.setSearchCondition);
  const filters = useShipmentPlanConfirmDetailStore(s => s.filters);
  const setFilter = useShipmentPlanConfirmDetailStore(s => s.setFilter);
  const clearFilters = useShipmentPlanConfirmDetailStore(s => s.clearFilters);
  const initPeriodDefault = useShipmentPlanConfirmDetailStore(s => s.initPeriodDefault);
  const restoreSearchConditions = useShipmentPlanConfirmDetailStore(s => s.restoreSearchConditions);
  const openSearchArea = useShipmentPlanConfirmDetailStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanConfirmDetailStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanConfirmDetailStore(s => s.staticColumns);
  const originalStaticColumns = useShipmentPlanConfirmDetailStore(s => s.originalStaticColumns);
  const fetchStaticColumns = useShipmentPlanConfirmDetailStore(s => s.fetchStaticColumns);
  const applyColumnLayout = useShipmentPlanConfirmDetailStore(s => s.applyColumnLayout);
  const initialized = useShipmentPlanConfirmDetailStore(s => s.initialized);
  const hasDivisionAuth = useShipmentPlanConfirmDetailStore(s => s.hasDivisionAuth);
  const divisionCodes = useShipmentPlanConfirmDetailStore(s => s.divisionCodes);

  const queryClient = useQueryClient();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 저장 개인화(titleSet)가 없을 때 좌/우 목록의 base — admin 노출(visible!==false) 컬럼.
  //   ⚠️ ColumnLayoutModal 은 beRows(titleSet)·fallbackColumns 중 하나가 base 가 되고 initialSettings 는
  //     override 만 한다(buildInitialRows). 저장 개인화가 없는 화면은 fallbackColumns 가 없으면 목록이 통째로 빈다.
  const fallbackColumns = useMemo(
    () =>
      (staticColumns[SHEETS.MAIN] ?? [])
        .filter(c => c.visible !== false)
        .map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth,
          display: c.display,
          personalizable: c.personalizable,
        })),
    [staticColumns]
  );
  // ColumnLayoutModal 재진입 복원 — 개인화가 반영된 현재 staticColumns 를 표시/순서/폭/색 설정으로 투영.
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns[SHEETS.MAIN] ?? []),
    [staticColumns]
  );
  // Default 버튼 원복 기준 — 개인화 미적용 admin 메타 원본.
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns),
    [originalStaticColumns]
  );
  // 컬럼 개인화는 division 독립 — titleSet 저장/복원 키는 divisionIds[0] ?? '' 로 통일한다
  //   (모달·saveTitleSet·store.fetchUserColumnLayout 세 곳 동일. 불일치 시 저장/복원 키가 어긋난다).
  const titleSetDivisionId = sc.divisionIds[0] ?? '';
  const [openItem, setOpenItem] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [drilldown, setDrilldown] = useState<DrilldownParams | null>(null);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + Period 기본값 + 컬럼메타 1회 fetch.
    clearFilters();
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // F6 저장분 복원 — 진입/새로고침 1회(store conditionsRestored 가드). 날짜축은 저장 제외라 위 기본값 유지.
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // L6 Find — 필수(Period) 검증 후 조회. refetch 직접호출 금지(setFilter 참조 교체로 자동발사).
  const handleSearch = () => {
    if (!hasDivisionAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTHORITY, '__No authority assigned.'),
      });
      return;
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_PERIOD, '__Please enter the required fields.'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // L2~L4 Insert/Delete/Save — NO-OP(버튼 노출 유지 + 명시적 무동작). false/키 생략 금지(기본 addRow/removeRow 살아남 방지).
  //   admin 권한(hasButton)으로 노출을 제어하되, 노출 시에는 무동작 함수를 배선한다(design 01 §2 L2~L4).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    save: hasButton('SAVE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Column Setting — btnColumn(AS-IS 조회영역) 을 SubTitle 아이콘 버튼으로 재배치(#120). 공용 컬럼설정 모달.
    {
      label: t(LBL.COLUMN_SETTING, '_Column Setting'),
      title: t(LBL.COLUMN_SETTING, '_Column Setting'),
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
        <ShipmentPlanConfirmDetailForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentPlanConfirmDetail'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
        // F10(Reset Condition) 시 서버 저장분 초기화에 더해 **현재 화면 조회조건도 즉시 기본값 복원**
        //   (사용자 지시 2026-11-02). store.reset() 호출 — staticColumns/개인화는 MotherStore 가 보존.
        resetConditionOnClient
      />

      <div className={styles.grid}>
        <ShipmentPlanConfirmDetailGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onDrilldown={setDrilldown}
        />
      </div>

      {/* Model 검색 — 공용 MaterialByDivisionModal(COM0013, 사용자 지시 2026-10-22). 종전 ModelByDivisionPopup
          (SCM0002)에서 교체. 자매 출하 화면(shipment-plan-electrode SSP0026 등)과 동일 전환.
          다중 division 화면이라 multiDivision(콤마 결합 divisionIds 를 멀티 컨트롤로 disabled 미러),
          AS-IS 다중선택(체크행 ITEM_ID 콤마 결합)이라 multiCheckbox. 선택 반환은 비어있지 않을 때만 반영(AS-IS cs:337).
          한계: 이 모달엔 Site 축이 없어 기존 팝업이 넘기던 From Site(scmSite) 사전필터는 빠진다(SSP0003 전환 동일 기록). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchCondition({ itemId: items });
        }}
        preSearchParams={{
          // Div=ALL(미선택)이면 권한 division 전체로 전개 — 빈 divisionId 면 모달 내부 조회가
          //   enabled:false 로 막혀 결과가 비어 Model 검색이 불가하던 문제(사용자 신고 2026-11-02) 해소.
          //   DMF0045(shipment-request) 는 단일 division 을 항상 넘겨 비지 않는다 — 같은 "항상 유효한 division"
          //   을 다중 화면에선 ALL 전개(divisionCodes)로 충족한다.
          divisionId: sc.divisionIds.length > 0 ? sc.divisionIds.join(',') : divisionCodes.join(','),
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
        multiDivision
        multiCheckbox
      />

      {/* 컬럼설정(L7) — 공용 표준 ColumnLayoutModal(POP-13) + titleSet 'C' 영구 저장.
          고정 admin 엔드포인트(/admin/menu/{id}/titleset/*) 라 화면별 call-proc 등록/403 불필요.
          표준 전환(사용자 결정 2026-10-16): 구세대 ColumnSettingModal→ColumnLayoutModal. 표시/순서 + 폭/색 개인화. */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        // ⚠️ 조회·저장과 반드시 같은 값 — admin SHEET_NAME('Shipment Plan Confirm Detail'), SHEETS.MAIN('main') 아님.
        sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
        // columnType 은 조회·저장 모두 'C'(컬럼) 고정 — 저장('C')과 조회가 다른 키를 보면 재진입 시 유실된다.
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={titleSetDivisionId}
        fallbackColumns={fallbackColumns}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        title={t(LBL.COLUMN_SETTING, '_Column Setting')}
        leftTitle={t('LBL00764', '_Invisible')}
        rightTitle={t('LBL00765', '_Visible')}
        // 2단 머지헤더(Departure/Arrival Port·Departure days·Lead Time)라 leaf 라벨이 중복된다
        //   (Port*/Country*/Port Code* 가 양쪽, Mon~Sun 요일 등). 목록에 소분류 열을 함께 띄워 구분.
        showSmallClass
        onSave={settings => {
          // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns[MAIN] 에 적용 → grid 즉시 갱신.
          //   BE 재조회로는 개인화가 돌아오지 않으므로 grid 반영은 store 가 담당(forecast-price 선례 동일).
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              order: s.SORT_ORDER_NO,
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          );
          // (2) titleSet 'C' 영구 저장 — 표시 column 만 순서 1..n + 폭/색(BE 확장 3컬럼).
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN],
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              // MSG 상수에 저장에러 코드가 없어 화면스코프 defaultValue 키로 안내(임의 MSG 코드로 i18n 오매핑 방지).
              void setAlert({
                type: 'alert',
                content: t('_ssp0012.titlesetSaveError', '_Save error.'),
              });
              return;
            }
            // 팝업 titleSet 조회 캐시 무효화(필수) — 전역 staleTime=Infinity 라 invalidate 없이는 재조회 안 됨.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
        }}
      />

      {/* 드릴다운(W9/W10) — INCOTERMS→BOD 상세 / CHANGE_REQ_NO→변경요청 상세. 상세 데이터는 convert-sp 후속. */}
      <BodDetailModal
        open={drilldown?.kind === 'BOD'}
        modalClose={() => setDrilldown(null)}
        divisionId={drilldown?.divisionId}
        bodId={drilldown?.bodId}
      />
      <ShipmentRequestDetailModal
        open={drilldown?.kind === 'REQUEST'}
        modalClose={() => setDrilldown(null)}
        changeReqNo={drilldown?.changeReqNo}
      />
    </>
  );
};
