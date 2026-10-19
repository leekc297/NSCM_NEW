import type { FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import { useTabProcQuery } from '@shared/hooks';

import {
  MENU_ID,
  POLL_INTERVAL_MS,
  RESPONSE_SET,
  RUN_STATUS,
  SHEETS,
} from '../plan-control.constants';
import type { EngineRunRow, PlanControlRow } from '../plan-control.types';
import { usePlanControlStore } from '../usePlanControlStore';
import { str } from '../utils/planControl.activity';

interface Args {
  tabId: string;
  // 상단 그리드 — 폴링 결과로 선택 Activity 행 3컬럼을 제자리 갱신하고, 숨김 탭 판정에도 쓴다.
  gridRef: MutableRefObject<FlexGrid<PlanControlRow> | undefined>;
  rows: PlanControlRow[];
}

// refetchInterval 콜백이 받는 query 의 최소 형상. TanStack 의 Query 타입을 그대로 끌어오지 않고
//   필요한 필드만 구조적으로 선언한다(Query 는 이 형상에 할당 가능).
interface PollQuery {
  state: { data?: { planControl?: PlanControlRow[] } };
}

// AS-IS timerStatus(2초) — CheckEngineStatus 가 GET_PLAN_ENGINE_RUN + GET_PLAN_CONTROL 2건을 호출한다
//   (cs:156·588·837-847). TO-BE 는 react-query refetchInterval 2개로 옮긴다.
// 정지 조건 3가지를 모두 건다:
//   R20 상태가 C(Completed)/E(Error)/공백 — 공백(미실행)도 정지 대상이다.
//   R21 조회 재발사 시 — store 가 engineRunContext 를 비우면 query 가 disabled 된다.
//   R23 숨김 탭 — MDI 는 keep-alive 라 숨긴 탭도 언마운트되지 않는다. 걸지 않으면 열어둔 탭 수만큼
//       분당 30회씩 SP 호출이 백그라운드로 나간다(hook #72).
export const usePlanControlPolling = ({ tabId, gridRef, rows }: Args) => {
  const searchFilters = usePlanControlStore(state => state.filters[SHEETS.PLAN_CONTROL]);
  const engineRunContext = usePlanControlStore(state => state.engineRunContext);

  // 단건 경로 파라미터 = 조회조건 3키 + 선택 행의 actvCd/planId(design 03 §4.4).
  const pollFilters = useMemo(() => {
    if (!searchFilters || !engineRunContext) return undefined;
    return {
      divisionId: searchFilters.divisionId,
      planGroupId: searchFilters.planGroupId,
      planStartYyyymmdd: searchFilters.planStartYyyymmdd,
      actvCd: engineRunContext.actvCd,
      planId: engineRunContext.planId,
    };
  }, [searchFilters, engineRunContext]);

  // 마지막으로 관측한 실행 상태. refetchInterval 콜백이 렌더 사이에 최신값을 읽도록 ref 로 둔다.
  //   undefined = 아직 응답 전(초기 1회 조회는 refetchInterval 과 무관하게 발사된다).
  const runStatusRef = useRef<string | undefined>(undefined);

  const canPoll = useCallback(() => {
    const status = runStatusRef.current;
    if (status === undefined) return false;
    if (status === '' || status === RUN_STATUS.COMPLETED || status === RUN_STATUS.ERROR) {
      return false;
    }
    // 숨김 탭이면 offsetParent 가 null 이다(display:none 조상). 그리드가 아직 없으면 폴링하지 않는다.
    const host = gridRef.current?.hostElement;
    return !!host && host.offsetParent !== null;
  }, [gridRef]);

  // 단건 상태 폴링 — 자기 응답에서 상태를 직접 읽어 다음 주기를 정한다(한 렌더 지연 없음).
  const statusInterval = useCallback(
    (query: PollQuery): number | false => {
      const status = query.state.data?.planControl?.[0];
      if (!status) return false;
      const code = str(status.OPMZ_ACTV_RUN_STAT_CD);
      if (code === '' || code === RUN_STATUS.COMPLETED || code === RUN_STATUS.ERROR) return false;
      const host = gridRef.current?.hostElement;
      return !!host && host.offsetParent !== null ? POLL_INTERVAL_MS : false;
    },
    [gridRef]
  );

  const { data: statusData } = useTabProcQuery<MENU_ID, SHEETS.PLAN_CONTROL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_CONTROL,
    tabId,
    filters: pollFilters,
    enabled: !!pollFilters,
    queryOptions: { refetchInterval: statusInterval },
  });

  const { data: engineRunData } = useTabProcQuery<MENU_ID, SHEETS.ENGINE_RUN>({
    menuId: MENU_ID,
    sheetName: SHEETS.ENGINE_RUN,
    tabId,
    filters: pollFilters,
    enabled: !!pollFilters,
    queryOptions: { refetchInterval: () => (canPoll() ? POLL_INTERVAL_MS : false) },
  });

  const statusRow = statusData?.[RESPONSE_SET.PLAN_CONTROL]?.[0];
  runStatusRef.current = statusRow ? str(statusRow.OPMZ_ACTV_RUN_STAT_CD) : undefined;

  // G14~G16 — 폴링 응답으로 선택 Activity 행의 3컬럼만 제자리 갱신한다. 행 객체를 통째로 교체하면
  //   선택/스크롤 상태가 날아가므로 값만 쓰고 collectionView.refresh() 로 다시 그린다.
  //   갱신 컬럼은 3개다(STAT_NAME 제외) — 콤보 변경 경로(G18~G21, 4컬럼)와 다르며 통일하면 안 된다.
  useEffect(() => {
    if (!statusRow || !engineRunContext) return;
    const target = rows.find(row => str(row.OPMZ_ACTV_CD) === engineRunContext.actvCd);
    if (!target) return;
    const nextStatus = str(statusRow.OPMZ_ACTV_RUN_STAT_CD);
    // AS-IS 도 변화가 있을 때만 쓴다(cs:598).
    if (str(target.OPMZ_ACTV_RUN_STAT_CD) === nextStatus) return;
    target.OPMZ_ACTV_RUN_STAT_CD = nextStatus;
    target.LAST_UPDATE_DATE = str(statusRow.LAST_UPDATE_DATE);
    target.LAST_UPDATED_BY = str(statusRow.LAST_UPDATED_BY);
    gridRef.current?.collectionView?.refresh();
  }, [statusRow, engineRunContext, rows, gridRef]);

  // X13 — AS-IS 는 하단 시트의 기존 행에 4컬럼을 덮어써서 행수가 어긋나면 엉뚱한 행을 갱신할 수 있어
  //   "행수 불일치 시 return" 가드를 두었다. TO-BE 는 커서 결과를 통째로 재바인딩하므로 행이 어긋나는
  //   상태 자체가 생기지 않는다(구조적 대체).
  const engineRunRows: EngineRunRow[] = useMemo(
    () => engineRunData?.[RESPONSE_SET.ENGINE_RUN] ?? [],
    [engineRunData]
  );

  return { engineRunRows };
};
