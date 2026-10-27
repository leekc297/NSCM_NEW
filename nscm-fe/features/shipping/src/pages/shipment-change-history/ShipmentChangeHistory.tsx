import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentPlanRequestModal } from './components/modals/ShipmentPlanRequestModal';
import { ShipmentChangeHistoryForm } from './components/ShipmentChangeHistoryForm';
import { ShipmentChangeHistoryGrid } from './components/ShipmentChangeHistoryGrid';
import {
  DIVISION_ALL,
  LAST_SEQ_COLUMN,
  LAST_SEQ_CURRENT,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
} from './shipment-change-history.constants';
import type { MainRow } from './shipment-change-history.types';
import styles from './ShipmentChangeHistory.module.scss';
import { useShipmentChangeHistoryStore } from './useShipmentChangeHistoryStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0019_ShipmentChangeHistory — 단일 그리드(spdMain) 출하 변경 이력 조회.
//   설계: .atlas/gscm-design/SSP0019/design/00~03 + convert-flow goal/plan. 도메인 SSP(features/shipping).
//   읽기전용 조회(inquiry): 전열 LockColumn, 편집 4버튼(Insert/Delete/Edit/Save) AS-IS NO-OP -> admin 메타 SEARCH 한정
//     등록(design 01 §4d) -> hotkeyConfig 편집키 false(미노출, __asis-mapping__ 근거). 저장/편집 데이터 계약 없음.
//   읽기전용의 근거는 코드 + DB 양쪽이다: AS-IS 가 Insert/Delete/Edit/SaveButton 을 빈 override 로 두고
//     spdMain 을 ReadOnlySheetList 에 넣으며(cs:268, 352-367), TB_FX_GROUPMENUAUTH 실측(2026-10-14)상
//     SSP0019 등록 15개 그룹 전부 BASICACLR 만 Y 이고 C/U/D 는 0건이다(= 편집권한 보유 그룹 자체가 없음).
//   GET SP PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY 는 배포됨(ALL_PROCEDURES 실측 2026-10-14).
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
  const restoreSearchConditions = useShipmentChangeHistoryStore(s => s.restoreSearchConditions);
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

  // 진입 — 개인화 조회조건 복원(SubTitle F6 저장분, 1회). GET /admin/menu/SSP0019/search-conditions
  //   → searchCondition 패치. 저장(searchParam prop)만 배선돼 있고 복원이 누락돼 재진입/새로고침 시
  //   저장조건이 소실되던 것을 해소(basic-check #3, 자매 shipment-plan-mobility-it 파리티).
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(admin 동적 속성관리).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 기본 조회기간(design 01 §2#9 / 02 §4) — 오늘 기준 1개월. from/to 가 둘 다 비면 기본값으로 채운다.
  //   AS-IS GET_DATE_RANGE_1MONTH(SCP SP) 등가 — 정확한 1개월 방향은 SP 미배포로 브라우저 실검증 대상(정직 보고).
  //   기본점검 #4(F10 기본값 초기화): 마운트 전용([tabId]) effect 에 두면 F10(조회조건 초기화)이
  //   reset()->initState 로 fromDate/toDate 를 비운 뒤 재진입 전까지 기본기간이 복원되지 않아, 기간
  //   필수검증(handleSearch)이 조회를 영구 차단한다(삭제형 결함). 기간은 필수라 '둘 다 빈' 상태 자체가
  //   유효 조회가 아니므로, 날짜값 축 effect 로 F10/수동삭제 모두에서 기본기간으로 자가복구한다. 선례
  //   SSP0005(0a2b7512) dayRangeApplied 재적용 — 단 SSP0005 는 기간이 선택사항(빈값=전기간)이라 수동삭제
  //   보존용 플래그를 뒀고, 본 화면은 기간 필수라 플래그 없이 둘 다 빌 때 무조건 복원한다.
  useEffect(() => {
    if (!sc.fromDate && !sc.toDate) {
      setSearchCondition({
        fromDate: dayjs().format('YYYYMMDD'),
        toDate: dayjs().add(1, 'month').format('YYYYMMDD'),
      });
    }
  }, [sc.fromDate, sc.toDate, setSearchCondition]);

  // 조회 — 권한 게이트(design 01 §2#1) + 기간 필수/역전 검증(Check_PeriodDate 등가, design 02 §4).
  const handleSearch = () => {
    // 권한 후보 미도착: 이 상태로 조회하면 권한범위를 모른 채 나간다(Form 콤보 도착 후 재시도).
    if (!divisionAuthLoaded) return;
    // 권한 division 0건 = AS-IS SetDivisionAuthCheck -> 조회 차단(design 01 §2#1). Form 이 조회영역 disable + alert.
    if (authDivisionIds.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
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
          `[${t(LBL.SHIPMENT_DATE, '_Shipment Date')}]`
        ),
      });
      return;
    }
    // 기간 역전(from > to) 차단 — YYYYMMDD 문자 사전식 비교 = 날짜 대소 비교와 일치.
    if (from > to) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INVALID_PERIOD, '_Invalid period (start > end).'),
      });
      return;
    }
    setFilter(langCd ?? '');
    void fetchStaticColumns();
  };

  // Model/Nickname 팝업 선택 확정 — master 계약 positional 1번째가 ITEM_ID(다건은 콤마 결합).
  //   빈 반환(선택 없이 닫기)이면 기존 조회조건을 유지한다(AS-IS btnItemId_Click 의 `if (ItemID != "")` 등가).
  const handleModelSelected = (itemId: string) => {
    const picked = str(itemId);
    if (picked) setSearchCondition({ itemId: picked });
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

      {/* Model/Nickname 조회조건 팝업 — 공용 `MaterialByDivisionModal`(COM0013,
          PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)로 교체(사용자 지시 2026-10-14, 자매 SSP0003/0026 공통).
          AS-IS 는 `SCM0002_ItembyDivisionPopup`(= SCM.SCM0002_GET_ITEM_BY_DIVISION_POPUP)이라
          **조회 SP 가 달라지는 의도적 드리프트**다. `scpModuleType` 에 SSP 화면 ID 는 SP 에 열거돼 있지
          않아 기본 ELSE 분기를 타 기본 Material 목록을 돌려준다(자매 화면 실측).
          `multiDivision` — 이 화면 Division 은 다중체크라 콤마 결합해 그대로 넘긴다(SP 가 P_DIVISION_ID 를
          콤마 split → IN 처리). 미체크(=권한범위 전체)면 'ALL' 센티널 — 빈 문자열이면 모달이
          `enabled: !!divisionId` 로 조회를 막아 검색이 안 된다.
          한계: AS-IS 가 함께 넘기던 scmSite(From Site) 사전필터는 이 모달 계약에 site 축이 없어 전달
          불가다 — 종전 `scmSite` 전달분이 사라진다(자매 SSP0003 §Q-5 와 동일 한계). */}
      <MaterialByDivisionModal
        open={modelPopupOpen}
        modalClose={() => setModelPopupOpen(false)}
        multiDivision
        multiCheckbox
        setSelectedValue={handleModelSelected}
        preSearchParams={{
          divisionId: sc.divisionIds.length ? sc.divisionIds.join(',') : DIVISION_ALL,
          scpModuleType: MENU_ID,
          operationGroup: '',
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
