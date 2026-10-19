import { useEffect } from 'react';

import { useQueryClient } from '@foundation/query-client';

import { useCapaLobReportStore } from '../useCapaLobReportStore';
import { toFromYyyymm } from '../utils/capaLobReport.dateColumns';

interface Params {
  tabId: string;
  divisionId: string;
  divisionType: string;
  verId: string;
  verSeq: string;
  progressStatus: string;
}

/**
 * 조회조건 변경 -> **그리드 비움 + 기간헤더 갱신** (design 03 §2.6 / R-16 / V-43).
 *
 * AS-IS 는 Division / Plan Month / Version / DivisionType 핸들러 **선두**에서 `BeforeFindData()` 를
 * 호출한다(cs:1493·1504·1514·1523) — `InitSpread()`(그리드 비움) -> `RefreshSheetHeader(true)`
 * (헤더 재조회) -> `SetVisibleSheetColumns()` 순이다. Column 설정 OK(cs:1619~1622)와 진입
 * (`rgrpDivisionType.SelectedIndex=CELL` 대입, cs:975)도 같은 경로다.
 *
 * 비움은 `clearFilters()` 한 곳에서만 하고 **한 effect 에서 헤더 갱신까지 함께 커밋**한다 —
 * 조건 축마다 effect 를 쪼개면 Division 한 번 변경에 그리드가 2~3회 깜빡인다(공통 QA "조회조건 변경 시
 * 깜빡임" / 03 V-43). `progressStatus` 도 같은 dep 에 둔다: 시트 전환(CURRENT<->CUTOFF)은 상위 콤보
 * cascade 의 결과라 AS-IS 도 같은 `BeforeFindData` 경로에서 처리된다(03 §2.6 말미).
 *
 * `refetch()` 를 직접 부르지 않는다 — 재조회는 `setFilters()` 참조 교체로만 한다(nscm-patterns §5-1).
 */
export const useCapaLobReportConditionEffects = ({
  tabId,
  divisionId,
  divisionType,
  verId,
  verSeq,
  progressStatus,
}: Params) => {
  const queryClient = useQueryClient();
  const clearFilters = useCapaLobReportStore(state => state.clearFilters);
  const restoreSearchConditions = useCapaLobReportStore(state => state.restoreSearchConditions);
  const refreshSpreadTitle = useCapaLobReportStore(state => state.refreshSpreadTitle);
  const fetchStaticColumns = useCapaLobReportStore(state => state.fetchStaticColumns);

  /**
   * 진입 — 그리드는 비어 있고 GET SP 를 부르지 않는다(01 L-36 / 02 §4.1 / 03 V-21).
   * 컬럼 메타는 mount 1회 fetch 가 허용된다(hook #66 — 헤더/컬럼은 조회 전에도 최신이어야 한다).
   * `removeQueries([tabId])` 로 이전 탭 세션의 캐시까지 버려 재진입 시 옛 rows 가 비치지 않게 한다.
   * F6 로 저장한 조회조건을 복원한다(새로고침/재진입 1회, basic-check #3). `searchParams` 만 patch 하고
   * `filters` 는 불변이라 진입 자동조회 금지 게이트는 유지된다 — 저장측은 Page 의 SubTitle `searchParam={sp}`.
   */
  useEffect(() => {
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    void restoreSearchConditions();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    clearFilters();
    refreshSpreadTitle(toFromYyyymm(verId));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionId, divisionType, verId, verSeq, progressStatus]);
};
