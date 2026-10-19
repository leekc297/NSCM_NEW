import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ItemByDivisionModal } from './components/modals/ItemByDivisionModal';
import { ShipmentPlanRequestModal } from './components/modals/ShipmentPlanRequestModal';
import { ShipmentChangeHistoryForm } from './components/ShipmentChangeHistoryForm';
import { ShipmentChangeHistoryGrid } from './components/ShipmentChangeHistoryGrid';
import { LAST_SEQ_COLUMN, LAST_SEQ_CURRENT, MENU_ID, MSG, SHEETS } from './shipment-change-history.constants';
import type { MainRow, PopupRow } from './shipment-change-history.types';
import styles from './ShipmentChangeHistory.module.scss';
import { useShipmentChangeHistoryStore } from './useShipmentChangeHistoryStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0019_ShipmentChangeHistory — 단일 그리드(spdMain) 출하 변경 이력 조회.
//   설계: .atlas/gscm-design/SSP0019/design/00~03 + convert-flow goal/plan. 도메인 SSP(features/shipping).
//   읽기전용 조회(inquiry): 전열 LockColumn, 편집 4버튼(Insert/Delete/Edit/Save) AS-IS NO-OP -> admin 메타 SEARCH 한정
//     등록(design 01 §4d) -> hotkeyConfig 편집키 false(미노출, __asis-mapping__ 근거). 저장/편집 데이터 계약 없음.
//   SP 미배포(goal.md ②): PKG_SSP0019 -> 조회 런타임 미완(convert-sp 후속). FE 는 47컬럼 계약으로 구현.
export const ShipmentChangeHistory = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);

  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const sc = useShipmentChangeHistoryStore(s => s.searchCondition);
  const setSearchCondition = useShipmentChangeHistoryStore(s => s.setSearchCondition);
  const filters = useShipmentChangeHistoryStore(s => s.filters);
  const setFilter = useShipmentChangeHistoryStore(s => s.setFilter);
  const clearFilters = useShipmentChangeHistoryStore(s => s.clearFilters);
  const openSearchArea = useShipmentChangeHistoryStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeHistoryStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeHistoryStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeHistoryStore(s => s.fetchStaticColumns);
  const initialized = useShipmentChangeHistoryStore(s => s.initialized);
  const authDivisionIds = useShipmentChangeHistoryStore(s => s.authDivisionIds);
  const divisionAuthLoaded = useShipmentChangeHistoryStore(s => s.divisionAuthLoaded);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const [modelPopupOpen, setModelPopupOpen] = useState(false);
  const [requestNo, setRequestNo] = useState<string | null>(null);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<MainRow[]>(() => (data?.o_rc1 ?? []) as unknown as MainRow[], [data]);

  // chkCurrent 토글(design 03 §3 SetCheckRow) — 체크 시 LAST_SEQ='C'(현재값) 행만 표시, 해제 시 전행.
  //   강조(LightSkyBlue)는 두 상태 공통으로 그리드 formatItem 이 'C' 행에 적용. 서버 재조회 없는 클라 토글.
  const displayRows = useMemo<MainRow[]>(
    () =>
      sc.chkCurrent
        ? rows.filter(r => str((r as Record<string, unknown>)[LAST_SEQ_COLUMN]) === LAST_SEQ_CURRENT)
        : rows,
    [rows, sc.chkCurrent]
  );

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(admin 동적 속성관리).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // 기본 조회기간(design 01 §2#9 / 02 §4) — 오늘 기준 1개월. 값이 비었을 때만 세팅(탭 재진입 시 사용자값 보존).
    //   AS-IS GET_DATE_RANGE_1MONTH(SCP SP) 등가 — 정확한 1개월 방향은 SP 미배포로 브라우저 실검증 대상(정직 보고).
    if (!sc.fromDate && !sc.toDate) {
      setSearchCondition({
        fromDate: dayjs().format('YYYYMMDD'),
        toDate: dayjs().add(1, 'month').format('YYYYMMDD'),
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 — 권한 게이트(design 01 §2#1) + 기간 필수/역전 검증(Check_PeriodDate 등가, design 02 §4).
  const handleSearch = () => {
    // 권한 후보 미도착: 이 상태로 조회하면 권한범위를 모른 채 나간다(Form 콤보 도착 후 재시도).
    if (!divisionAuthLoaded) return;
    // 권한 division 0건 = AS-IS SetDivisionAuthCheck -> 조회 차단(design 01 §2#1). Form 이 조회영역 disable + alert.
    if (authDivisionIds.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
      });
      return;
    }
    const from = sc.fromDate.trim();
    const to = sc.toDate.trim();
    // 기간 필수(Check_PeriodDate) — 공백 차단. MSG00134 미등록이라 CRUD_MSG.REQUIRED_FIELD 로 안내(hook #114).
    if (!from || !to) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${t('LBL01115', { defaultValue: 'Shipment Date' })}]`
        ),
      });
      return;
    }
    // 기간 역전(from > to) 차단 — YYYYMMDD 문자 사전식 비교 = 날짜 대소 비교와 일치.
    if (from > to) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INVALID_PERIOD, { defaultValue: 'Invalid period (start > end).' }),
      });
      return;
    }
    setFilter(langCd ?? '');
    void fetchStaticColumns();
  };

  // Model 팝업(design 02 §4.6) — 조회조건 Division/From Site/Model 사전필터로 오픈.
  const handleModelSelected = (picked: PopupRow[]) => {
    const ids = picked.map(r => str(r.ITEM_ID)).filter(Boolean);
    if (ids.length > 0) setSearchCondition({ itemId: ids.join(',') });
    setModelPopupOpen(false);
  };

  // 읽기전용 조회 — SEARCH 만 실동작. Insert/Delete/Edit/Save 는 AS-IS NO-OP(design 01 §2 #3~6, §4d):
  //   admin 버튼메타에 미등록(hasButton=false)이라 미노출. false 사용 근거는 __asis-mapping__.md(화면별 확정 = 읽기전용).
  //   키 생략 금지(공용 addRow/removeRow 되살아남) — 명시적으로 false.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
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
        <ShipmentChangeHistoryForm
          onSearch={handleSearch}
          onOpenModelPopup={() => setModelPopupOpen(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={displayRows.length}
        excelFileName='ShipmentChangeHistory'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentChangeHistoryGrid
          rows={displayRows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onRequestNoClick={setRequestNo}
        />
      </div>

      {/* Model 조회조건 팝업 — SCM0002 Item by Division(로컬, division/scmSite 사전필터). */}
      <ItemByDivisionModal
        open={modelPopupOpen}
        modalClose={() => setModelPopupOpen(false)}
        setSelectedValue={handleModelSelected}
        preSearchParams={{
          divisionId: sc.divisionIds.join(','),
          scmSite: sc.fromSiteIds.join(','),
          itemId: sc.itemId,
        }}
      />

      {/* REQUEST_NO 이미지셀 드릴다운 — SCM0002 요청 상세(SP 미배포로 상세 유예, design 03 §3-4). */}
      <ShipmentPlanRequestModal
        open={requestNo !== null}
        modalClose={() => setRequestNo(null)}
        requestNo={requestNo ?? undefined}
      />
    </>
  );
};
