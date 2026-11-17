import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery, useProcMutation } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ShipmentAlloReportForm } from './components/ShipmentAlloReportForm';
import { ShipmentAlloReportGrid } from './components/ShipmentAlloReportGrid';
import { MENU_ID, MSG, SHEETS, TAB } from './shipment-allo-report.constants';
import type { PivotMonthMeta, ShipmentAlloRow, TeamRow } from './shipment-allo-report.types';
import { useShipmentAlloReportStore } from './useShipmentAlloReportStore';
import {
  applyGap,
  buildBaseRows,
  buildPivotMonths,
  fillPivotValues,
  insertSummaryRows,
  mergeMainWithGap,
} from './utils/shipment-allo-report.columns';

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0055_Shipment_Allo_Report(1,486줄) — Main/Gap 탭 2그리드
//   피벗 리포트 + 비고(NOTE) 상시편집. 설계: .atlas/gscm-design/SCP0055/design/00~03. domain=Supply 확정.
//   버튼: Search/Save/Excel 실동작(EDIT 토글 제거 2026-10-30 — 비고 상시편집, hotkeyConfig 참조).
//   PKG_SCP0055 배포 완료(PACKAGE/BODY VALID, 멤버 GET_PLAN/GET_NOTE/SAVE_PLAN — ora.py 실측 2026-11-03).
//   Team 콤보=SCM0001_TeamByDivision 확정. Excel 은 확인창 없이 바로 다운로드(AS-IS MSG00100 3분기
//   미재현 — 사용자 결정 2026-11-02, handleExcel 참조).
const buildRowsFor = (data: unknown, monthsForTab: PivotMonthMeta[]): ShipmentAlloRow[] => {
  const d = data as { o_rc1?: unknown[]; o_rc2?: TeamRow[]; o_rc3?: unknown[] } | undefined;
  if (!d?.o_rc2) return [];
  const base = buildBaseRows(d.o_rc2);
  return fillPivotValues(base, (d.o_rc1 ?? []) as never, (d.o_rc3 ?? []) as never, monthsForTab);
};

// 비고 매핑 키 — AS-IS RefreshNote 의 조회 키와 동일(P_SITE_ID, P_DEPT_ID[요약행은 TEAM_NAME],
//   P_NICK_NAME, .cs:1053-1055). 요약행은 DEPT_ID 대신 "{닉}요약"(TEAM_NAME)으로 조회/저장된다.
const noteKeyOf = (r: ShipmentAlloRow): string =>
  `${r.SITE_ID}|${r.IS_SUMMARY ? r.TEAM_NAME : r.DEPT_ID}|${r.NICK_NAME}`;

// 조회결과 PlanType/Seq 라벨값 — AS-IS ulPlanType_Seq1/Seq2(.cs:595/597, RefreshGrid L817
//   = Tables[3][0]+", "+Tables[3][1]). o_rc4[0]의 PLAN_TYPE, SEQ 를 "{PLAN_TYPE}, {SEQ}"(예 "MA, 1")로.
//   Main=planDate 기준 / Gap=gapDate 기준 계획 버전을 표시한다.
const planTypeSeqOf = (data: unknown): string => {
  // 배포된 proc O_RC4 의 실제 컬럼명은 V_PLAN_TYPE / V_SEQ(ora.py 실측 2026-11-02, GET proc L794-795).
  //   타입맵은 PLAN_TYPE/SEQ 로 선언돼 있어 양쪽 키를 모두 폴백 조회한다.
  const rc4 = (
    data as
      | { o_rc4?: { V_PLAN_TYPE?: string; V_SEQ?: string; PLAN_TYPE?: string; SEQ?: string }[] }
      | undefined
  )?.o_rc4?.[0];
  if (!rc4) return '';
  const pt = String(rc4.V_PLAN_TYPE ?? rc4.PLAN_TYPE ?? '').trim();
  const sq = String(rc4.V_SEQ ?? rc4.SEQ ?? '').trim();
  return pt || sq ? `${pt}, ${sq}` : '';
};

export const ShipmentAlloReport = ({ tabId, title }: PageProps<typeof MENU_ID>) => {
  const { t } = useTranslation();
  const userId = useSessionStore(s => s.session?.userId ?? '');

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();
  const gapGridRef = useRef<FlexGrid>();
  const gapFilterRef = useRef<FlexGridFilter>();
  const gapTrackerRef = useRef<EditTracker>();

  const [activeTabIndex, setActiveTabIndex] = useState(0);
  const activeTab = activeTabIndex === 0 ? TAB.MAIN : TAB.GAP;

  const sc = useShipmentAlloReportStore(s => s.searchCondition);
  const openSearchArea = useShipmentAlloReportStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentAlloReportStore(s => s.setOpenSearchArea);
  const runSearch = useShipmentAlloReportStore(s => s.runSearch);
  const mainFilter = useShipmentAlloReportStore(s => s.mainFilter);
  const gapFilter = useShipmentAlloReportStore(s => s.gapFilter);
  const staticColumns = useShipmentAlloReportStore(s => s.staticColumns);
  const initialized = useShipmentAlloReportStore(s => s.initialized);
  const fetchStaticColumns = useShipmentAlloReportStore(s => s.fetchStaticColumns);
  const restoreSearchCondition = useShipmentAlloReportStore(s => s.restoreSearchCondition);

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // F6 로 저장한 조회조건을 진입 시 1회 복원한다(store 비영속 — 새로고침 생존은 이 GET 뿐).
    //   복원은 searchCondition 만 채우고 filters 는 비운 채라 자동조회 없이 Search 대기 상태가 된다.
    void restoreSearchCondition();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 두 쿼리 모두 base tabId 를 쓴다 — 전역 조회 스피너(MDIContainer useIsBusy([activeTab.tabId]))는
  //   쿼리키 첫 요소가 tabId 와 정확히 일치해야 매칭된다. 예전 `${tabId}-main`/`-gap` 접미는 첫 요소가
  //   달라져 스피너가 안 떴다. Main/Gap 구분은 filters(planStart=planDate vs gapDate)로 되고, 캐시 정리는
  //   removeQueries({exact:true}) 라 서로 간섭 없다. planDate≠gapDate 는 검증(MSG00348)이 보장해 키 충돌 없음.
  const mainQuery = useTabProcQuery<typeof MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: mainFilter,
    enabled: !!mainFilter,
  });
  const gapQuery = useTabProcQuery<typeof MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: gapFilter,
    enabled: !!gapFilter,
  });

  const saveMutation = useProcMutation<typeof MENU_ID, SHEETS.MAIN, 'o_rc2'>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  // 피벗 월(헤더) 은 라이브 검색조건(sc)이 아니라 조회 실행 스냅샷(mainFilter/gapFilter)에서 뽑는다 —
  //   AS-IS 파리티. AS-IS 는 헤더 세팅(InitSpreadDateColumn)을 조회(FindData_Main) 안에서만 하므로
  //   Plan/Gap Date 콤보만 바꾸고 조회하지 않으면 헤더가 그대로다(cs:579/582, Find 경로 전용). 반면 sc 직결
  //   파생은 날짜를 고르는 즉시 헤더가 재세팅돼 AS-IS 와 어긋났다. 스냅샷(…Yyyymmdd 8자리)에서 YYYYMM 을
  //   잘라 쓰고, 조회 전(filter undefined)이면 빈 배열이라 헤더가 뜨지 않는다(조회해야 생성 — AS-IS 동일).
  const months = useMemo(
    () =>
      mainFilter
        ? buildPivotMonths(
            String(mainFilter.fromYyyymmdd).slice(0, 6),
            String(mainFilter.toYyyymmdd).slice(0, 6),
            String(mainFilter.planStartYyyymmdd).slice(0, 6)
          )
        : [],
    [mainFilter]
  );
  const gapMonths = useMemo(
    () =>
      gapFilter
        ? buildPivotMonths(
            String(gapFilter.fromYyyymmdd).slice(0, 6),
            String(gapFilter.toYyyymmdd).slice(0, 6),
            String(gapFilter.planStartYyyymmdd).slice(0, 6)
          )
        : [],
    [gapFilter]
  );

  const gapRows = useMemo(() => buildRowsFor(gapQuery.data, gapMonths), [gapQuery.data, gapMonths]);
  const mainRowsRaw = useMemo(() => buildRowsFor(mainQuery.data, months), [mainQuery.data, months]);
  // Main⊇Gap 행 보장 + GAP 계산(design 03 §3.1) + 요약행 삽입(RefreshGridGAP). 비고 로드 전 뼈대.
  const mainRowsBase = useMemo(() => {
    const merged = mergeMainWithGap(mainRowsRaw, gapRows);
    const withGap = applyGap(merged, gapRows);
    return insertSummaryRows(withGap, months, true);
  }, [mainRowsRaw, gapRows, months]);

  // 비고 로드(AS-IS RefreshNote 파리티, .cs:1003-1067) — 메인 조회·GAP·요약행 생성 후 Main 그리드
  //   행마다 per-row 비고 조회(N+1). AS-IS 가 메인 조회(GET_SHIPMENT_ALLO_PLAN)에 비고를 안 싣고
  //   행별로 GET_SHIPMENT_ALLO_NOTE 를 1건씩 부르는 구조 그대로다(사용자 지시 2026-11-02: AS-IS 동일).
  //   팀명 공백 행은 스킵(.cs:1041), 요약행은 P_DEPT_ID 자리에 "{닉}요약". GAP_DATE 는 넘기되 프로시저가
  //   무시('ALL' 고정, DB 실측). Gap 탭은 비고 편집·로드 대상 아님(AS-IS siGap 제외)이라 Main 만 로드한다.
  //
  // useQuery 로 감싸는 이유(2종 파리티):
  //   1) 전역 조회 스피너 — queryKey 첫 요소가 tabId 라 MDIContainer useIsBusy([tabId]) 에 집계된다.
  //      메인 쿼리가 끝나고 비고(N+1)만 로드되는 구간에도 스피너가 유지돼, AS-IS WinScreen 의 동기
  //      RefreshNote 블로킹과 동일하게 "조회 중"이 비고까지 이어진다(사용자 지시 2026-11-09).
  //   2) 분할 렌더 제거 — 아래 mainRows 는 비고 data 가 '현재 뼈대 세대'와 일치할 때만 입히고(아니면
  //      이전 완성본 유지), 메인 뼈대를 먼저 그린 뒤 비고를 덧입히는 "비고 늦게 뜸"을 없앤다. AS-IS 는
  //      메인+비고가 한 번에 표시된다.
  // 대상 행 식별 리스트 — 비고 조회 단위(site|dept|nick)의 안정 문자열. 뼈대가 바뀌면 이 키가 바뀌어
  //   비고 쿼리가 재실행되고, 커밋 시 세대 일치 판정("이 비고가 지금 뼈대의 것인가")의 기준이 된다.
  const noteTargets = useMemo(() => mainRowsBase.filter(r => !r.IS_TEAM_BLANK), [mainRowsBase]);
  const noteTargetSig = useMemo(() => noteTargets.map(noteKeyOf).join('~'), [noteTargets]);
  const noteQuery = useQuery<Map<string, string>>({
    queryKey: [tabId, 'note', sc.planDate, sc.gapDate, userId, noteTargetSig],
    queryFn: async () => {
      const entries = await Promise.all(
        noteTargets.map(async r => {
          const res = await apiClient.callProc<typeof MENU_ID, SHEETS.NOTE>(
            MENU_ID,
            SHEETS.NOTE,
            BUTTON_TYPE.SEARCH,
            {
              siteId: r.SITE_ID,
              deptId: r.IS_SUMMARY ? r.TEAM_NAME : r.DEPT_ID, // 요약행은 "{닉}요약"(AS-IS .cs:1054)
              nickName: r.NICK_NAME,
              planDate: sc.planDate,
              gapDate: sc.gapDate,
              userId,
            }
          );
          return [noteKeyOf(r), String(res.result?.o_rc1?.[0]?.NOTE ?? '')] as const;
        })
      );
      return new Map(entries);
    },
    enabled: noteTargets.length > 0 && !!sc.planDate,
  });

  // 완성본 커밋 — 비고 로드 대상이 없으면(또는 planDate 미설정) 뼈대 그대로, 비고가 현재 뼈대 세대에
  //   대해 도착했으면(noteQuery.data) 그 비고를 입힌 완성본, 아직 로드 중이면 undefined 로 두고 아래
  //   useEffect 가 이전 완성본을 유지한다(분할 렌더 방지). 팀공백 행은 제외(배경 회색·저장 제외).
  //   사용자 편집은 EditTracker 가 추적하며 저장은 tracker 직접순회(handleSave)라 이 재계산과 무관하다.
  const committedMainRows = useMemo(() => {
    if (!noteTargets.length || !sc.planDate) return mainRowsBase;
    if (!noteQuery.data) return undefined; // 비고 로딩 중 — 커밋 보류
    const noteByKey = noteQuery.data;
    return mainRowsBase.map(r =>
      r.IS_TEAM_BLANK ? r : { ...r, NOTE: noteByKey.get(noteKeyOf(r)) ?? r.NOTE }
    );
  }, [mainRowsBase, noteTargets.length, sc.planDate, noteQuery.data]);

  const [mainRows, setMainRows] = useState<ShipmentAlloRow[]>([]);
  useEffect(() => {
    if (committedMainRows) setMainRows(committedMainRows);
  }, [committedMainRows]);
  // Gap 탭은 요약행을 넣지 않는다 — AS-IS siGap 은 RefreshGridGAP(요약 생성·노랑) 대상이 아니다
  //   (cs:604 RefreshGridGAP 는 svMain 만). Gap 은 팀행 그대로 표시(편집·색상 없음).
  const activeRowCount = activeTab === TAB.MAIN ? mainRows.length : gapRows.length;

  // 조회결과 PlanType/Seq 라벨(AS-IS ulPlanType_Seq1=Main, ulPlanType_Seq2=Gap) — Period 근처 표시.
  const mainPlanSeq = useMemo(() => planTypeSeqOf(mainQuery.data), [mainQuery.data]);
  const gapPlanSeq = useMemo(() => planTypeSeqOf(gapQuery.data), [gapQuery.data]);

  // 사전검증 3건(design 01 §2 #13) — Period From>To / PlanDate<GapDate / PlanDate=GapDate.
  const validateBeforeSearch = (): boolean => {
    const setAlert = useMessageStore.getState().setAlert;
    if (sc.fromYyyymm && sc.toYyyymm && sc.fromYyyymm > sc.toYyyymm) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_RANGE, '_Please check the Period.') });
      return false;
    }
    if (sc.planDate && sc.gapDate && sc.planDate < sc.gapDate) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_GAP_ORDER, '_plan date is earlier than gap date') });
      return false;
    }
    if (sc.planDate && sc.gapDate && sc.planDate === sc.gapDate) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_GAP_EQUAL, '_Gap date and Plan date must not be equal.') });
      return false;
    }
    return true;
  };

  const handleSearch = () => {
    if (!validateBeforeSearch()) return;
    runSearch(userId);
  };

  // Save — 비고 값이 실제로 바뀐 행만 전송(design 03 §4.3). 요약행(IS_SUMMARY)은 파생행이라 제외.
  const handleSave = () => {
    // 편집 중인 비고 셀을 먼저 커밋한다 — 안 하면 cellEditEnded 미발생으로 EditTracker 에 반영이 안 돼
    //   수집 대상 0건 → "수정한 내용이 없습니다"(MSG00004)로 빠진다(SubTitle.tsx:234 동일 사정, SCP0131 선례).
    const grid = activeTab === TAB.MAIN ? mainGridRef.current : gapGridRef.current;
    grid?.finishEditing();
    const tracker = activeTab === TAB.MAIN ? mainTrackerRef.current : gapTrackerRef.current;
    // 변경행 수집은 EditTracker 를 직접 순회한다(정본 패턴: shipment-plan-semi.save.ts).
    //   예전엔 tracker 키를 React 메모 배열(mainRows)과 객체참조로 교집합(dirtyRowSet.has(r))했는데,
    //   조회 refetch 등으로 mainRows 가 재생성되면 그리드가 추적 중인 dataItem 과 참조가 갈려 교집합이
    //   0 이 되어 저장이 '수정 내용 없음'(MSG00004)으로 빠졌다. tracker 키 자체가 편집된 실제 행이므로
    //   그 행으로 바로 payload 를 만든다(아이덴티티 의존 제거).
    // 저장 대상(AS-IS 실측): 일반행·요약행은 저장, 팀명 공백 행(IS_TEAM_BLANK)은 입력은 되나 저장 제외
    //   (design 03 §3 #29-부속, 비고 회색). 요약행은 저장 포함 — AS-IS SaveData 가 P_DEPT_ID 에 "요약"
    //   팀명을 실어 저장한다(cs:1054 `sTEAM_NAME.IndexOf("요약")>=0 ? sTEAM_NAME : sDEPT_ID`).
    // 비고를 실제로 편집한 행(회색 포함) — 두 '저장 0건' 케이스를 가르는 기준이다(사용자 결정 2026-11-09).
    //   AS-IS 는 소스상 둘 다 무음 재조회지만(iCount==0), 사용자 요구는 "아무 변경 없음=알림 / 회색만=무음".
    const editedRows = [...(tracker?.getOriginalValues().entries() ?? [])]
      .filter(([, orig]) => 'NOTE' in orig)
      .map(([row]) => row as unknown as ShipmentAlloRow);
    // 저장 대상 = 편집행 중 팀명 공백(회색) 행 제외(AS-IS cs:1265 `if IsNullOrEmpty(sTEAM_NAME) continue`).
    const changed = editedRows.filter(r => !r.IS_TEAM_BLANK);
    const payload = changed.map(r => ({
      SITE_NAME: r.FROM_SITE,
      SITE_ID: r.SITE_ID,
      EXTRA_SPEC: r.EXTRA_SPEC,
      NICK_NAME: r.NICK_NAME,
      // 요약행은 DEPT_ID 자리에 팀명("{닉네임} 요약")을 넣는다(AS-IS cs:1054). 일반행은 DEPT_ID 그대로.
      DEPT_ID: r.IS_SUMMARY ? r.TEAM_NAME : r.DEPT_ID,
      DEPT_NAME: r.TEAM_NAME,
      PLAN_DATE: sc.planDate,
      GAP_DATE: sc.gapDate,
      NOTE: r.NOTE ?? '',
      PROGRAM_ID: MENU_ID,
      USER_ID: userId,
    }));
    // 저장 0건을 두 케이스로 구분한다(사용자 결정 2026-11-09):
    //   (A) 회색(팀명 공백) 셀만 편집 — editedRows>0 이지만 전부 회색이라 payload 0 → 알림 없이 무음
    //       재조회(입력값 원복). AS-IS 가 cs:1265 로 회색행을 건너뛰어 iCount==0 이 되는 것과 등가.
    //   (B) 아무것도 편집 안 함 — editedRows==0 → "수정한 내용이 없습니다"(MSG00004) 알림만, 재조회 안 함.
    //       setAlert 로 직접 띄운다. 공통 useProcMutation 에 빈 배열을 넘기면 reject 전에 mutation 이
    //       pending→error 를 거쳐 전역 스피너(MDIContainer useIsBusy — mutationKey 접두 tabId 집계,
    //       query-client.ts:170)가 깜빡이므로, mutation 을 돌리지 않고 알림만 띄운다.
    if (payload.length === 0) {
      if (editedRows.length > 0) {
        runSearch(userId); // (A) 회색만 편집 — 무음 재조회
      } else {
        void useMessageStore
          .getState()
          .setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') }); // (B)
      }
      return;
    }
    saveMutation.mutate(payload, {
      onSuccess: () => {
        useMessageStore.getState().setToast({
          type: 'success',
          // MSG00672 "{0}개의 데이터가 저장되었습니다." — {0} 를 저장건수로 치환(ScpIfBlocking 선례).
          //   MSG00004 재사용 금지: TO-BE 에서 "수정한 내용이 없습니다"로 반전돼 성공인데 실패처럼 보인다(D2).
          message: t(MSG.SAVE_COUNT, '_{0} data saved.').replace('{0}', String(payload.length)),
        });
        runSearch(userId); // 저장 후 자동 재조회 → 그리드 재잠금(design 01 §2 #15)
      },
    });
  };

  // Excel — 확인창 없이 바로 다운로드. AS-IS MSG00100 "저장하지 않고 바로 열겠습니까?"(Yes/No/Cancel)는
  //   WinForms 가 엑셀 앱에서 파일을 '여는' 전제라, 파일만 내려받는 웹 다운로드 모델엔 부적합해 제거한다
  //   (사용자 결정 2026-11-02, 선례 ending-inventory·long-term-stock 동일 — 확인창 미재현). 웹은 그리드를
  //   그대로 export 해 미저장 비고도 파일에 포함되므로 "저장하지 않고" 경고 자체가 의미가 약하다.
  const handleExcel = () => {
    const grid = activeTab === TAB.MAIN ? mainGridRef.current : gapGridRef.current;
    if (!grid) return;
    void GridAction.excelDownload(grid, 'ShipmentAlloReport', useUIStore.getState().setProgress);
  };

  // TO-BE 편집모델(사용자 지시 2026-10-30): EditButton(수정) 토글 없음 — 편집가능 컬럼(비고 NOTE)이
  //   상시 편집가능하고, 저장은 공통 Save 버튼으로 한다. Insert/Delete 는 이 화면에 없음(AS-IS 도 행
  //   추가/삭제 없는 피벗 리포트 — 비고 수정만). Manual/Upload 없음.
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
    save: handleSave,
    excel: handleExcel,
  };

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} openSearchArea={openSearchArea} toggleOpenSearchArea={setOpenSearchArea} />

      <ShipmentAlloReportForm onSearch={handleSearch} mainPlanSeq={mainPlanSeq} gapPlanSeq={gapPlanSeq} />

      <SubTitle
        menuId={MENU_ID}
        grid={activeTab === TAB.MAIN ? mainGridRef : gapGridRef}
        gridFilter={activeTab === TAB.MAIN ? mainFilterRef : gapFilterRef}
        dataCount={activeRowCount}
        excelFileName='ShipmentAlloReport'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      {/* AS-IS 구조: Main/Gap 탭(tabControl1) → 각 탭 안에 FpSpread 시트탭 "Shipment(Allo) Report" →
          그 안에 그리드. 중첩 탭으로 재현한다(안쪽은 단일 시트탭). */}
      <TabWrapper activeTabIndex={activeTabIndex} setActiveTabIndex={setActiveTabIndex} persist>
        <TabItem label={t('', { defaultValue: 'Main' })}>
          <TabWrapper>
            <TabItem label='Shipment(Allo) Report'>
              <ShipmentAlloReportGrid
                rows={mainRows}
                adminColumns={staticColumns}
                months={months}
                isGapTab={false}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                editTrackerRef={mainTrackerRef}
              />
            </TabItem>
          </TabWrapper>
        </TabItem>
        <TabItem label={t('', { defaultValue: 'Gap' })}>
          <TabWrapper>
            <TabItem label='Shipment(Allo) Report'>
              <ShipmentAlloReportGrid
                rows={gapRows}
                adminColumns={staticColumns}
                months={gapMonths}
                isGapTab={true}
                gridRef={gapGridRef}
                gridFilterRef={gapFilterRef}
                editTrackerRef={gapTrackerRef}
              />
            </TabItem>
          </TabWrapper>
        </TabItem>
      </TabWrapper>
    </>
  );
};
