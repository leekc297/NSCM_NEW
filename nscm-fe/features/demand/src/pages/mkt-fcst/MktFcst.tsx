import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ColumnSettingModal,
  type ColumnSettingRow,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';
import { useSessionStore } from '@shared/stores';

import { MktFcstForm } from './components/MktFcstForm';
import { MktFcstGrid } from './components/MktFcstGrid';
import {
  MeasureSelectModal,
  PrHistoryModal,
  type PrHistoryParams,
  PrModal,
  type PrModalParams,
  SspSyncCompareModal,
  type SspSyncCompareParams,
  SspSyncResultModal,
  type SspSyncResultRow,
} from './components/modals';
import {
  GROUP,
  INSERT_DEFAULT_MEASURE,
  MAIN_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
} from './mkt-fcst.constants';
import type { MktFcstRow, SpreadTitleRow } from './mkt-fcst.types';
import styles from './MktFcst.module.scss';
import type { BucketInfo, CurrentWeekInfo } from './useMktFcstStore';
import { useMktFcstStore } from './useMktFcstStore';
import { isEditableDivision } from './utils/mkt-fcst.division';
import { type PrContextAction, type PrContextResult, toCellStr } from './utils/mkt-fcst.prContext';
import { buildSavePayload, buildUnfoldRows } from './utils/mkt-fcst.save';
import { useMktFcstValidation } from './utils/mkt-fcst.validate';

// AS-IS DMF0003_MktFcst (Demand > Demand Plan > MKT FCST / 시장예측).
//   레이아웃: DMF0020(pivot + 동적컬럼 + 세로머지 + measure-group + 공통 DataGrid + SubTitle hotkeyConfig) 1:1 복제.
//   ⚠️ Phase 2 미검증 — SP 응답 shape/메타/validation 152·expressions 130 정밀 매핑은 BE 적재 후.
//   SubTitle 공통버튼 8: insert/delete/save(실 CRUD 골격) + sort/filter/condition/resetCondition/excel(DefaultButtonActions 자동).
export const MktFcst = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<MktFcstRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const sc = useMktFcstStore(s => s.searchCondition);
  const filters = useMktFcstStore(s => s.filters);
  const setFilter = useMktFcstStore(s => s.setFilter);
  const clearFilters = useMktFcstStore(s => s.clearFilters);
  const openSearchArea = useMktFcstStore(s => s.openSearchArea);
  const setOpenSearchArea = useMktFcstStore(s => s.setOpenSearchArea);
  const staticColumns = useMktFcstStore(s => s.staticColumns);
  const staticMeasures = useMktFcstStore(s => s.staticMeasures);
  const fetchStaticColumns = useMktFcstStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useMktFcstStore(s => s.fetchStaticMeasures);
  const setCalendarInfo = useMktFcstStore(s => s.setCalendarInfo);
  const setWsPlannerYn = useMktFcstStore(s => s.setWsPlannerYn);
  const storeWsPlannerYn = useMktFcstStore(s => s.wsPlannerYn);
  const bucketInfo = useMktFcstStore(s => s.bucketInfo);
  const currentWeekInfo = useMktFcstStore(s => s.currentWeekInfo);
  const applyColumnVisibility = useMktFcstStore(s => s.applyColumnVisibility);
  const visibleMeasures = useMktFcstStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useMktFcstStore(s => s.applyVisibleMeasures);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 편집 가능 division (메타 구동) — CMBO 'MktFcstEditableDivision'(lookup DM_EDITABLE_DIVISION_ALLOW,
  //   SEGMENT1='DMF0003' → 편집가능 division CODE). 현행 업무규칙: 82 만 편집 가능(40/81/81_*/EE* 편집제약).
  //   메타 미적용/빈 응답 시 fallback = {'82'} (하드코딩 금지 원칙상 메타 우선, fallback 은 규칙 기본값 1건).
  const [editableDivRows, userEditDivRows, wsPlannerRows, userGroupRows] = useTabComboQueries({
    filters: [
      'MktFcstEditableDivision',
      'MktFcstUserEditDivision',
      'MktFcstWsPlannerYn',
      // ⭐ [E20260604-000994] 사용자 소속 그룹 전수 (AS-IS NowGroupID 대응 — membership 판정.
      //   TO-BE 는 로그인 시 그룹 선택 개념이 없어 소속 여부로 게이트 적용. 겸직 사용자는 협의 항목).
      'MktFcstUserGroups',
    ],
  });
  const editableSet = useMemo(() => {
    const codes = (editableDivRows ?? [])
      .map(r => {
        const code = (r as { CODE?: unknown }).CODE;
        return typeof code === 'string' ? code.trim() : '';
      })
      .filter(Boolean);
    return codes.length > 0 ? new Set(codes) : new Set(['82']);
  }, [editableDivRows]);
  // ⭐ G6 — 그룹×Division EDIT_YN (CMBO 'MktFcstUserEditDivision' = SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
  //   @sesUserId, EDIT_YN='Y', OR 규칙: 여러 그룹 중 하나라도 Y 면 편집). 사용자별 편집가능 division 집합.
  //   비어 있으면(미응답/미등록) 관대 통과 — 기존 division 게이트만 적용(회귀 0).
  const userEditSet = useMemo(() => {
    const codes = (userEditDivRows ?? [])
      .map(r => {
        const code = (r as { CODE?: unknown }).CODE;
        return typeof code === 'string' ? code.trim() : '';
      })
      .filter(Boolean);
    return new Set(codes);
  }, [userEditDivRows]);
  // 현재 조회 division 이 편집 가능한지 — 셀 편집(그리드) + Insert/Delete/Save 버튼 표시의 게이트.
  //   ⭐ 2단 AND: (1) division 편집허용(editableSet=DM_UI_EDITABLE_DIVISION, 현행 82)
  //   (2) 사용자 그룹권한(userEditSet=UNIT_AUTH EDIT_YN). userEditSet 비면 (2) 생략(관대).
  //   ⭐ [E20260604-000994] + (3) SCP Planner 편집 차단(82·40) — 아래 게이트 블록 뒤에서 산출.

  // ⭐ P1-③ — 로그인 사용자 W/S Planner 여부 반영 (CMBO 'MktFcstWsPlannerYn' 단일행 CODE='Y'/'N').
  //   AS-IS L1679: W/S Planner 이면 AS(asYn) 강제. 세션 groupId 부재 → USER_ID→그룹 소속 실측(SP).
  const wsPlannerCode = useMemo(() => {
    const code = (wsPlannerRows ?? [])[0] as { CODE?: unknown } | undefined;
    return typeof code?.CODE === 'string' ? code.CODE.trim() : '';
  }, [wsPlannerRows]);
  useEffect(() => {
    if (wsPlannerCode) setWsPlannerYn(wsPlannerCode === 'Y');
  }, [wsPlannerCode, setWsPlannerYn]);

  // ⭐ [E20260604-000994] 그룹 게이트 — CMBO 'MktFcstUserGroups'(USER_GR_MPG_M @sesUserId) membership.
  const groupsSet = useMemo(() => {
    const codes = (userGroupRows ?? [])
      .map(r => {
        const code = (r as { CODE?: unknown }).CODE;
        return typeof code === 'string' ? code.trim() : '';
      })
      .filter(Boolean);
    return new Set(codes);
  }, [userGroupRows]);
  const isScpPlanner = groupsSet.has(GROUP.SCP_PLANNER);
  // 대표 DM류 그룹 (AS-IS 단일 NowGroupID 근사 — W/S > DM Planner > DM ADMIN 우선. .cs 비교 문자열 원문).
  const dmFamilyGroup = useMemo(() => {
    const priority = [GROUP.WS_PLANNER, GROUP.DM_PLANNER, GROUP.DM_ADMIN] as const;
    return priority.find(g => groupsSet.has(g)) ?? '';
  }, [groupsSet]);

  // ⭐ 시간창 lookup 2종(.cs L848~874) + W/S FcstType 4종 + AS(비축)향 사이트 목록.
  //   Dmf0003*EditFlag 데이터는 운영값 협의 대기(0행) — SCP=행 0=차단(AS-IS 보수 동작) / DM류=행 0=통과.
  const [scpFlagRows, dmFlagRows, wsFcstTypeRows, asSiteRows] = useTabComboQueries({
    filters: [
      {
        comboId: 'Dmf0003ScpPlannerEditFlag',
        divisionId: `'${sc.divisionId}'`,
        userGroup: `'${GROUP.SCP_PLANNER}'`,
      },
      {
        comboId: 'Dmf0003DmPlannerEditFlag',
        divisionId: `'${sc.divisionId}'`,
        userGroup: `'${dmFamilyGroup}'`,
      },
      'FcstTypeWs',
      { comboId: 'AS_FROM_SITE', param1: `'${sc.divisionId}'` },
    ],
  });

  // SCP Planner 편집 차단 (.cs L828~834 Edit=82·40 prefix / L2531~2537 Insert=81) — MSG00096.
  const scpEditBlocked =
    isScpPlanner && (sc.divisionId.startsWith('82') || sc.divisionId.startsWith('40'));
  const scpInsertBlocked = isScpPlanner && sc.divisionId.startsWith('81');
  // SCP 시간창 (81 한정, lookup 행 0 = 수정 가능 시간 아님 — MSG00477).
  const scpTimeBlocked =
    isScpPlanner && sc.divisionId.startsWith('81') && (scpFlagRows ?? []).length === 0;
  // DM류 시간창 — ⚠ AS-IS 원문 괄호 파리티(.cs L863): 81 제한이 'DM ADMIN' 에만 결합되고
  //   DM Planner/W-S 는 전 division 에서 검사(주석 의도와 코드 불일치 — 원본 결함, 원문 그대로 이식).
  const dmTimeRow = (dmFlagRows ?? [])[0] as { CODE?: unknown } | undefined;
  const dmTimeBlocked =
    !!dmFamilyGroup &&
    (dmFamilyGroup !== GROUP.DM_ADMIN || sc.divisionId.startsWith('81')) &&
    typeof dmTimeRow?.CODE === 'string' &&
    dmTimeRow.CODE.length > 0;

  // 현재 조회 division 이 편집 가능한지 — 셀 편집(그리드) + Insert/Delete/Save 버튼 표시의 게이트.
  //   ⭐ 3단 AND: (1) division 편집허용(editableSet=DM_UI_EDITABLE_DIVISION, 현행 82)
  //   (2) 사용자 그룹권한(userEditSet=UNIT_AUTH EDIT_YN. 비면 생략 — 관대)
  //   (3) [E20260604-000994] SCP Planner 편집 차단(82·40 — .cs L828~834) 아님.
  const editable =
    isEditableDivision(sc.divisionId, editableSet) &&
    (userEditSet.size === 0 || userEditSet.has((sc.divisionId ?? '').trim())) &&
    !scpEditBlocked;

  // ⭐ 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). 마운트 시 persist 된 stale filters 로
  //   SP 가 자동 발사되어 NULL payload → ORA-00936 나던 사고 차단. Search 클릭 후에만 쿼리 enable.
  const [hasSearched, setHasSearched] = useState(false);

  // 메인 그리드 SP — DMF0003_GET_MKT_FCST_DATA (22 IN + O_RC1). wide format(고정 + 동적 PIVOT).
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 PIVOT 기간 헤더 SP — DMF0003_GET_SPREAD_TITLE (6 IN + O_RC1).
  //   기간 컬럼(D_/W_/M_) 의 라벨·정렬·구조를 정의. 그리드 동적 컬럼 생성의 1차 소스.
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [];

  // ⭐ Phase 2b — main query 응답의 O_RC2(8주 bucket)·O_RC3(현재 주차) 를 store 에 보관.
  //   편집 cutoff(Daily 과거일 / Weekly·Monthly 현재월 / Div40 8주 잠금) 산출 입력 (보강스펙 §1/§5).
  const mainData = data as
    | { o_rc2?: BucketInfo[] | BucketInfo; o_rc3?: CurrentWeekInfo[] | CurrentWeekInfo }
    | undefined;
  useEffect(() => {
    if (!mainData) return;
    const pick = <T,>(v: T[] | T | undefined): T | null =>
      Array.isArray(v) ? (v[0] ?? null) : (v ?? null);
    setCalendarInfo(pick(mainData.o_rc2), pick(mainData.o_rc3));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  // ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline)
  //   + persist 된 이전 filters 무효화 — 미조회 상태에서 stale(빈/NULL) payload 로 SP 자동호출 방지.
  //   (NULL divisionId/fromYyyymmdd → SP 동적SQL placeholder 빈치환 → ORA-00936 사고 차단. 2026-06-29)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ⭐ TITLESET 서버 영구 저장 (AS-IS DM0002_TitleSetForm OK → SCM_MST_TITLESET_USER 1:1, DMF0048 패턴).
  //   기존 sessionStorage(탭 단위) 만이라 탭 재오픈 시 Column/Measure 선택이 분실되던 것을 서버 저장으로 해결.
  //   SCM0002_SET_TITLESET_POPUP: '^' delim 다건(DELETE 후 INSERT), P_USER_ID = BE 세션 자동.
  //   ^delim 다건 SAVE 는 apiClient.post 직접 (useProcMutation array unfold 회피 — 표준 선례).
  const saveTitleSet = async (
    columnType: 'C' | 'M',
    saveRows: { name: string; sortOrderNo: number; subTotalFlag?: string; sortMethodCode?: string }[]
  ): Promise<boolean> => {
    try {
      const payload = {
        programId: MENU_ID,
        sheetName: SHEETS.MAIN,
        columnType,
        activeFlag: saveRows.map(() => 'Y').join('^'),
        columnName: saveRows.map(r => r.name).join('^'),
        sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo || i + 1)).join('^'),
        subTotalFlag: saveRows.map(r => r.subTotalFlag ?? 'N').join('^'),
        sortMethodCode: saveRows.map(r => r.sortMethodCode ?? 'ASC').join('^'),
      };
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/titleSet/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return false;
      }
      return true;
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while saving.');
      void setAlert({ type: 'alert', content: msg });
      return false;
    }
  };

  // 신규 행 추적 (CRUD_TYPE='I')
  const [insertedRows, setInsertedRows] = useState<MktFcstRow[]>([]);

  // ⭐ Division(조회조건) 변경 = Grid 초기화 의무 (memory feedback_division_change_grid_reset /
  //   cascade-combo-filter §1.4). 재조회는 Search 버튼으로만. Division 이 바뀌면 이전 division 의
  //   조회 결과·신규행·편집 추적을 즉시 비우고(잔존 데이터로 오편집/오저장 방지) 쿼리 캐시를 제거해
  //   그리드를 공백으로 되돌린다. 컬럼 셋(division별 노출)도 division 기준으로 재평가된다.
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    setHasSearched(false); // 쿼리 disable — Search 전까지 자동 재조회 안 함
    setInsertedRows([]); // CRUD(신규행) reset
    editTrackerRef.current?.clearChanges(); // 편집 추적 reset
    clearFilters(); // filters[MAIN/SPREAD] 무효화 (enabled=false)
    queryClient.removeQueries({ queryKey: [MENU_ID] }); // 이전 조회 데이터 제거 → 그리드 공백
  }, [sc.divisionId, clearFilters, queryClient]);

  // Insert cell popup state (Project / Model) + cell popup group 추적.
  //   ⭐ 조회조건 Project/Model/Owner popup 은 MktFcstForm 의 카탈로그 필드(ProjectField/ItemField/
  //     OwnerField + multiCheckbox) 가 자체 관리 — 화면 레벨 모달은 grid cell popup 전용 (DMF0020 동일).
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupGroupId, setPopupGroupId] = useState<string | null>(null);

  // ⭐ Phase 2e POPUP state — SSP compare / SSP result / PR / PR history.
  //   (MasterChg 는 2026-07-13 사용자 결정으로 기능 전체 삭제 — AS-IS btnIncotermsChg 미이관 확정.)
  const [sspCompareParams, setSspCompareParams] = useState<SspSyncCompareParams | null>(null);
  const [sspResultRows, setSspResultRows] = useState<SspSyncResultRow[]>([]);
  const [prParams, setPrParams] = useState<PrModalParams | null>(null);
  const [prHistoryParams, setPrHistoryParams] = useState<PrHistoryParams | null>(null);

  // ⭐ #3 — Column / Measure 선택 모달 open state.
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ----- validation 152 정밀 매핑 hook (fnValidation/ValidationCheck/SetSaveData 동등) -----
  //   조회(MSG00097/00108/00164) + 저장(MSG00002/00043/00034/00366) + Bucket(MSG00227) division 분기.
  const validation = useMktFcstValidation();

  // F5 Search
  //   ⚠️ refetch?.() 직접 호출 금지 — react-query refetch 는 마지막 렌더의 filters(stale/빈값)를 클로저로
  //      캡쳐해 그 값으로 fetch → 첫 호출이 NULL payload(ORA-00936/-9994), setFilter 후 queryKey 변경으로
  //      두번째가 정상 → "조회 시 최초 1회 에러" 사고. setFilter(=queryKey 변경) + hasSearched(=enabled) 만으로
  //      react-query 가 항상 "최신 filters" 로 1회 자동 fetch 하게 둔다.
  const handleSearch = () => {
    if (!validation.validateFind(sc).ok) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    setHasSearched(true); // 명시 조회 — 쿼리 enable
    setFilter(); // queryKey(filters) 갱신 → enabled 와 함께 react-query 자동 fetch (최신 payload)
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // ⭐ [E20260402/E20260604] 편집 진입 공통 게이트 — AS-IS EditButton(L828~888) 검사 순서 1:1.
  //   TO-BE 는 명시적 Edit 모드가 없어 Insert/Save 시점에 alert 게이트로 이식(셀 잠금은 editable 이 담당).
  //   반환 false = 차단(alert 표시 완료).
  const guardEditGates = (): boolean => {
    // (1) SCP Planner 시간창(81) — lookup 행 0 = 수정 가능 시간 아님(.cs L848~860). 운영값 협의 대기
    //     상태(0행)에서도 AS-IS 보수 동작(차단) 유지 — MSG00477.
    if (scpTimeBlocked) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SCP_TIME_WINDOW, '_SCP Planner 권한사용자의 수정 가능한 시간이 아닙니다.'),
      });
      return false;
    }
    // (2) DM Planner류 시간창 — lookup 행 존재 = 차단(.cs L862~874). MSG00478 5파라미터
    //     ({0}~{4} = LIMIT_AUTH/EDIT_DAYS/FROM_TIME/TO_TIME/AUTH — CMBO CODE '^' 연결 순서).
    if (dmTimeBlocked && typeof dmTimeRow?.CODE === 'string') {
      const p = dmTimeRow.CODE.split('^');
      let msg = t(
        MSG.DM_TIME_WINDOW,
        '_{0} 권한의 수정 가능 시간({1} {2}~{3}) 동안에는 {4} 권한으로 수정할 수 없습니다.'
      );
      p.forEach((v, i) => {
        msg = msg.replace(`{${i}}`, v);
      });
      void setAlert({ type: 'alert', content: msg });
      return false;
    }
    // (3) [E20260402] AS FROM SITE 컬럼 부재(.cs L876~888) — DM Planner/W-S/DM ADMIN + 81*/82
    //     에서 그리드에 AS_FROM_SITE 컬럼이 없으면 MSG00113 (SP LOAD 분기가 자동추가하므로 정상 시 미발생).
    if (dmFamilyGroup && (sc.divisionId.startsWith('81') || sc.divisionId === '82')) {
      const hasAsFromSite = !!gridRef.current?.columns.find(c => c.binding === 'AS_FROM_SITE');
      if (!hasAsFromSite) {
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.'),
        });
        return false;
      }
    }
    return true;
  };

  // F8 Insert — AS-IS InsertRow(L2389~2509) 1:1 — 신규 행 1개 추가. CRUD_TYPE='I', Division=조회조건.
  //   Measure 는 편집 combo(SCM_MST_SHEET_MEASURE VALID_YN='Y' 동적, fallback MEASURE_FALLBACK)이고
  //   기본값 = 'MKT_FCST_RP' (AS-IS L2509 siMain.SetValue(Measure, "MKT_FCST_RP")). 좌측 키는 입력 가능.
  const handleInsert = () => {
    // ⭐ [E20260604-000994] SCP Planner + 81 은 Insert 자체 차단(.cs L2531~2537) — MSG00096.
    if (scpInsertBlocked) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH, '_사용 권한이 없습니다.') });
      return;
    }
    if (!guardEditGates()) return;
    // ⭐ 편집제약 division(82 외)은 Insert 불가 — 버튼도 미표시이나 방어 가드(40·81 등 Insert 자체 불가).
    if (!editable) return;
    const groupId = `I_${Date.now()}`;
    const newRow: MktFcstRow = {
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: groupId,
      DIVISION_ID: sc.divisionId,
      END_CUSTOMER: '',
      SCM_SITE_ID: '',
      ITEM_ID: '',
      NICK_NAME: '',
      INCOTERMS: '',
      FCST_TYPE: '',
      DOM_EXP: '',
      ITEM_TYPE: '',
      MEASURE: INSERT_DEFAULT_MEASURE,
    };
    setInsertedRows(prev => [newRow, ...prev]);
  };

  // F9 Delete — AS-IS DeleteButton(L795~801) 1:1 — 선택 행이 신규('I')일 때만 목록 제거.
  //   기존(조회) 행은 삭제 불가(AS-IS 동일 — Action=='I' 분기만 DeleteRow). INSERT_GROUP_ID 단위 제거.
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as MktFcstRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({ type: 'alert', content: t('LBL00666', '_Only new rows can be deleted.') });
      return;
    }
    const gid = sel.INSERT_GROUP_ID;
    if (gid) setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    else setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // F7 Save — I/M 통합 저장. AS-IS SaveData(L2146~2366) + SetSaveData(L5205~5332) 1:1.
  //   변경 D_(일자) 셀 → (identity keys + YYYYMMDD + QTY) 일자 row unfold → 15 키 '^'delim payload.
  //   ^delim 다건이므로 apiClient.post 직접 호출 (useProcMutation 금지 — array unfold 안 함, memory
  //   feedback_save_sp_bulk_payload_apiclient_post). PROC_M COL_NM(camelCase) positional = SP signature.
  const handleSave = async () => {
    // ⭐ [E20260604-000994] SCP Planner 편집 차단(82·40) + 시간창/AS FROM SITE 게이트 — 저장도 동일 진입 검사.
    if (scpEditBlocked) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH, '_사용 권한이 없습니다.') });
      return;
    }
    if (!guardEditGates()) return;
    // ⭐ 저장 후 재조회 시 스크롤 top 유지용 — 현재 스크롤 위치 캡처 (AS-IS FindData 상단 유지).
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    // (0) ⭐ Phase 2f — 저장 전 검증 (fnValidation/SetSaveData 동등). division 분기 필수/중복/수량/AS+ALL.
    //   수정 행(EditTracker)도 dirty 후보 — collectionView 의 'M' 마킹 행 포함.
    const editTracker = editTrackerRef.current;
    const changedRows = (editTracker?.getOriginalValues() as
      | Map<MktFcstRow, Record<string, unknown>>
      | undefined) ?? new Map<MktFcstRow, Record<string, unknown>>();
    const editedRows = [...changedRows.keys()].filter(r => r.CRUD_TYPE !== 'I');
    const validateTargets: MktFcstRow[] = [...insertedRows, ...editedRows];
    const asFromSite = sc.asYn ? sc.scmSiteIds.join('^') : '';
    const vr = validation.validateSaveRows(validateTargets, sc, sc.asYn, asFromSite);
    if (!vr.ok) return;

    // ⭐ [E20260402-001736] AS FROM SITE 필수(.cs L2300~2329 — 신규행 'I' 경로): W/S Planner +
    //   81*/82 + 고객향 사이트(AS(비축)향 목록 'AS_FROM_SITE' CMBO 의 NAME 미포함) + FcstType 이
    //   W/S 4종('FcstTypeWs' = SALES_TYPE_CODE2) + AS_FROM_SITE 빈값 → MSG00476 차단.
    //   (AS-IS 검사 주체는 조건식상 W/S 단독 — 주석("DM Planner,")과 코드 불일치, 원문 파리티.)
    if (storeWsPlannerYn && (sc.divisionId.startsWith('81') || sc.divisionId === '82')) {
      const strOf = (v: unknown): string =>
        typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';
      const asSiteNames = new Set(
        (asSiteRows ?? []).map(r => strOf((r as { NAME?: unknown }).NAME)).filter(Boolean)
      );
      const wsTypes = new Set(
        (wsFcstTypeRows ?? []).map(r => strOf((r as { CODE?: unknown }).CODE)).filter(Boolean)
      );
      for (const r of insertedRows) {
        const rec = r as Record<string, unknown>;
        const site = strOf(rec.SCM_SITE_ID);
        const fcstType = strOf(rec.FCST_TYPE);
        const rowAsFromSite = strOf(rec.AS_FROM_SITE);
        if (site && !asSiteNames.has(site) && wsTypes.has(fcstType) && rowAsFromSite === '') {
          void setAlert({
            type: 'alert',
            content: t(
              MSG.AS_FROM_SITE_REQUIRED,
              '_고객향 사이트로 Fcst Type을 AS 또는 WS로 등록하시는 경우 AS FROM SITE는 필수로 입력이 필요합니다.'
            ),
          });
          return;
        }
      }
    }

    // (1) 변경 셀 수집 — 신규 행(insertedRows) + EditTracker 추적 수정 행.
    const editedChanges = editTrackerRef.current?.getOriginalValues() as
      | Map<MktFcstRow, Record<string, unknown>>
      | undefined;
    const unfoldRows = buildUnfoldRows({
      insertedRows: insertedRows as Record<string, unknown>[],
      editedChanges: (editedChanges ?? new Map()) as Map<
        Record<string, unknown>,
        Record<string, unknown>
      >,
      divisionId: sc.divisionId,
      createdBy: useSessionStore.getState().session.userId ?? '',
    });

    // ⭐ [E20260604-000994] p_authority = 로그인 권한 그룹(.cs L2243~2244 sAuthority=NowGroupID).
    //   TO-BE 근사: 세션 groupId → 대표 DM류 그룹 → SCP Planner → userId (조회 userGroup 배선과 동일 계보).
    const scpGroup = isScpPlanner ? GROUP.SCP_PLANNER : '';
    const authority =
      useSessionStore.getState().session.groupId ||
      dmFamilyGroup ||
      scpGroup ||
      useSessionStore.getState().session.userId ||
      '';
    const payload = buildSavePayload(unfoldRows, sc.bucketType, authority);
    if (!payload) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_DATA, '_No data to save.') });
      return;
    }

    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_Save changes?') });
    if (!ok) return;

    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });

    try {
      // O_RESULT_CURSOR CODE!='0' 시 foundation responseInterceptor 가 MSG throw → catch 에서 alert.
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      // status 500/403 은 responseErrorInterceptor 가 resolve → 여기서 직접 차단 (false success 방지).
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t('MSG00606', '_Saved.'), type: 'success' });
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      await (refetch?.() ?? Promise.resolve());
      // ⭐ 재조회 데이터 반영 후 스크롤 top 복원 (AS-IS FindData 상단 유지 — best-effort).
      if (savedScroll) {
        window.requestAnimationFrame(() => {
          const g = gridRef.current;
          if (g) g.scrollPosition = savedScroll;
        });
      }
      // ⭐ Phase 2e — SAVE 응답 O_RC1(SSP 동기화 detail) 행 존재 시 SspSyncResultModal 표시
      //   (AS-IS .cs L1610~1617 — 동기화수량보다 작게 수정한 건 내역). result 안의 o_rc1 추출.
      const syncRows = ((res.data?.result as { o_rc1?: SspSyncResultRow[] } | undefined)?.o_rc1 ??
        []);
      if (syncRows.length > 0) setSspResultRows(syncRows);
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while saving.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // ⭐ Phase 2e — contextMenu PR 결과 라우팅 (MktFcstGrid 검증 통과 → 모달 분기).
  //   Request_PR/View_PR/Add_History → PrModal / View_History → PrHistoryModal (AS-IS .cs L5689~5750).
  const handlePrContext = (action: PrContextAction, result: PrContextResult) => {
    if (!result.ok) return;
    const r = result.request;
    if (action === 'View_History') {
      setPrHistoryParams({
        divisionId: r.divisionId ?? sc.divisionId,
        projectCode: r.projectCode ?? '',
        scmSiteId: r.scmSiteId ?? '',
        itemId: r.itemId ?? '',
        domExp: r.domExp ?? '',
        fcstType: r.fcstType ?? '',
        incoterms: r.incoterms ?? '',
        plantSiteId: r.plantSiteId ?? '',
        yyyymmdd: r.yyyymmdd ?? '',
        planQty: r.planQty ?? '',
      });
      return;
    }
    setPrParams({
      popupType: action,
      divisionId: r.divisionId ?? sc.divisionId,
      projectCode: r.projectCode ?? '',
      scmSiteId: r.scmSiteId ?? '',
      itemId: r.itemId ?? '',
      domExp: r.domExp ?? '',
      fcstType: r.fcstType ?? '',
      incoterms: r.incoterms ?? '',
      plantSiteId: r.plantSiteId ?? '',
      yyyymmdd: r.yyyymmdd ?? '',
      planQty: r.planQty ?? '',
    });
  };

  // ⭐ Phase 2e — SSP↔MKT 비교 popup (grid CellDblClick 동기화색 셀, AS-IS .cs L2628~2683).
  //   Div40 키 = ProjectCode(=End Customer40) / ScmSiteId40 / ItemId40 (.cs L2655~2667).
  const handleSspCompare = (row: MktFcstRow, ymd: string) => {
    const get = (k: string) => toCellStr((row as Record<string, unknown>)[k]);
    setSspCompareParams({
      divisionId: sc.divisionId,
      scmSiteId: get('SCM_SITE_ID40') || get('SCM_SITE_ID'),
      projectCode: get('END_CUSTOMER40') || get('END_CUSTOMER') || get('PROJECT_CODE'),
      itemId: get('ITEM_ID40') || get('ITEM_ID'),
      domExp: get('DOM_EXP'),
      fcstType: get('FCST_TYPE'),
      incoterms: get('INCOTERMS'),
      yyyymmdd: ymd,
    });
  };

  // SubTitle 공통버튼 — insert/delete/save 핸들러 연결 + 미명시(sort/filter/condition/resetCondition/excel)는
  //   SubTitle DefaultButtonActions 가 자동 활성 (hook #64). hasButton 권한 분기.
  // ⭐ 버튼 게이트 = 권한(hasButton) × division 편집허용(editable). 편집제약 division(82 외)은
  //   Insert/Delete/Save 미표시(false → SubTitle 버튼 숨김). Search 는 division 무관(조회 항상 가능).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: editable && hasButton('INSERT') ? handleInsert : false,
    delete: editable && hasButton('DELETE') ? handleDelete : false,
    save: editable && hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  // ⭐ #3 — Insert 옆 Column / Measure 버튼 (SubTitle customButtons). hasButton 권한 분기.
  //   Column  : 공용 ColumnSettingModal(DMF0002_GET_TITLESET_POPUP + fallback) → applyColumnVisibility.
  //   Measure : MeasureSelectModal(staticMeasures 실데이터 토글) → 그리드 measure 행 필터.
  //   ⭐ 아이콘 = @foundation/assets 등록 아이콘 (DMF0020/DMF0043_01 과 동일 IcGridColumnSetup +
  //     전용 IcMeasureSelect). label/title = Tooltip + key 유지, buttonLabel='' 로 icon-only.
  const customButtons = [
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenColumnSetting(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  const spRows = useMemo<MktFcstRow[]>(
    () => (data as { o_rc1?: MktFcstRow[] })?.o_rc1 ?? [],
    [data]
  );
  // ⭐ Measure 종속 확장은 SP(DMF0003_GET_MKT_FCST_DATA) 단일 출처 — 사용자 저장 메저 선택
  //   (SCM_MST_TITLESET_USER 'M')을 base 로 종속 메저를 서버에서 확장한다:
  //     CUST_FCST → EDI 계열(Immidiate/Commercial_Agreement/…) / MKT_FCST_RP(Div82) → VMI 계열
  //     (RTF_SYS_RP/VMI_In_Plan/VMI_In_Req/VMI_Inv) / AS 계열 = as_yn='Y'.
  //   따라서 FE 는 SP 반환 measure 집합을 그대로 렌더한다(클라이언트 measure 행 필터 금지 —
  //   과거 visibleMeasures 필터가 SP 가 붙인 종속 메저를 잘라 숨기던 버그를 제거, AS-IS parity).
  //   메저 선택 변경은 모달 OK 의 saveTitleSet('M') + invalidateQueries 재조회로 SP 에서 반영됨.
  const rows: MktFcstRow[] = useMemo(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <MktFcstForm onSearch={handleSearch} insertedRowCount={insertedRows.length} />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='MktFcst'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* ⭐ 상단 PSI 분석 패널 제거 (2026-07-03 사용자 결정) — AS-IS 실행 화면(평문 DMF0003_MktFcst)에는
          상단 분석영역이 없음(별개 변형 DMF0003_1_MktFcst 전용 기능). 구현분은 패키지
          _deploy_packages/DMF0003_PSI_20260703/ 에 보존. */}
      <MktFcstGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        editable={editable}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        staticColumns={staticColumns[SHEETS.MAIN]}
        staticMeasures={staticMeasures[SHEETS.MAIN]}
        spreadTitle={spreadTitleRows}
        bucketInfo={bucketInfo}
        currentWeekInfo={currentWeekInfo}
        onPopupCellDblClick={(modalKey, row) => {
          setPopupGroupId(row.INSERT_GROUP_ID ?? null);
          if (modalKey === 'ITEM') setOpenItem(true);
          else if (modalKey === 'PROJECT') setOpenProject(true);
        }}
        onPrContext={handlePrContext}
        onSspCompare={handleSspCompare}
      />

      {/* Insert cell popup (Project / Model) — 단건 선택, cell 자동 채움 (DMF0020 동일 guard). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName) => {
          if (!popupGroupId) return;
          setInsertedRows(prev =>
            prev.map(r =>
              r.INSERT_GROUP_ID === popupGroupId
                ? { ...r, PROJECT_CODE: projectCode, PROJECT_NAME: projectName ?? '' }
                : r
            )
          );
          setPopupGroupId(null);
        }}
        preSearchParams={
          {
            divisionId: sc.divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: '',
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId: string, itemName?: string, _itemType?: string, nickName?: string) => {
          // ⭐ Model 선택 시 Model Name + Nickname 자동 입력 (사용자 요구 2026-07-03 — AS-IS 팝업 확정
          //   자동채움 1:1). ITEM_NAME/NICK_NAME 메타는 'S'(표시전용) 로 전환 — 직접 편집 불가.
          if (!popupGroupId) return;
          setInsertedRows(prev =>
            prev.map(r =>
              r.INSERT_GROUP_ID === popupGroupId
                ? { ...r, ITEM_ID: itemId, ITEM_NAME: itemName ?? '', NICK_NAME: nickName ?? '' }
                : r
            )
          );
          setPopupGroupId(null);
        }}
        preSearchParams={
          {
            divisionId: sc.divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            itemId: '',
          } as never
        }
        callFromCell={true}
      />

      {/* ⭐ Phase 2e POPUP — SSP 비교 / SSP 동기화 결과 / PR / PR 이력 */}
      <SspSyncCompareModal
        open={!!sspCompareParams}
        modalClose={() => setSspCompareParams(null)}
        params={sspCompareParams}
      />
      <SspSyncResultModal
        open={sspResultRows.length > 0}
        modalClose={() => setSspResultRows([])}
        rows={sspResultRows}
      />
      <PrModal
        open={!!prParams}
        modalClose={() => setPrParams(null)}
        params={prParams}
        onSaved={() => refetch?.()}
      />
      <PrHistoryModal
        open={!!prHistoryParams}
        modalClose={() => setPrHistoryParams(null)}
        params={prHistoryParams}
      />
      {/* ⭐ #3 — Column 설정 (공용 ColumnSettingModal, DMF0002_GET_TITLESET_POPUP + fallback). */}
      <ColumnSettingModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType={SHEETS.MAIN}
        divisionId={sc.divisionId}
        fallbackColumns={MAIN_COLUMNS.map(c => ({ key: c.key, header: c.header, width: c.width }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        onSave={(settings: ColumnSettingRow[]) => {
          // 로컬 즉시 반영 + 서버 영구 저장('C') → 성공 시 admin 메타 재fetch (개인화 기준 재계산).
          applyColumnVisibility(
            SHEETS.MAIN,
            settings.map(s => s.COLUMN_NAME)
          );
          void saveTitleSet(
            'C',
            settings.map(s => ({
              name: s.COLUMN_NAME,
              sortOrderNo: Number(s.SORT_ORDER_NO ?? 0),
              subTotalFlag: s.SUB_TOTAL_FLAG,
              sortMethodCode: s.USER_SORT_METHOD_CODE,
            }))
          ).then(ok => {
            if (ok) void fetchStaticColumns();
          });
        }}
      />

      {/* ⭐ #3 — Measure 선택 (staticMeasures 실데이터 토글 → 그리드 measure 행 필터). */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={staticMeasures[SHEETS.MAIN]}
        visibleMeasures={visibleMeasures[SHEETS.MAIN]}
        onApply={codes => {
          // 로컬 행 필터 + 서버 영구 저장('M'). 저장 후 measure 재fetch + 메인 쿼리 invalidate
          //   (메인 SP 가 TITLESET 'M' 으로 measure 행을 필터하므로 신규 선택이 서버에서 반영됨).
          applyVisibleMeasures(SHEETS.MAIN, codes);
          const all = staticMeasures[SHEETS.MAIN].map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            void fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />
    </div>
  );
};
