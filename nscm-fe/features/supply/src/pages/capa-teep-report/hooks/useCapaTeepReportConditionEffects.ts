import { useEffect } from 'react';

import { useQueryClient } from '@foundation/query-client';

import { SHEET_NAME_BY_DIVISION_TYPE, type DivisionType } from '../capa-teep-report.constants';
import { useCapaTeepReportStore } from '../useCapaTeepReportStore';
import { toFromYyyymm } from '../utils/capaTeepReport.dateColumns';

interface Params {
  tabId: string;
  divisionId: string;
  divisionType: DivisionType;
  verId: string;
  verSeq: string;
}

/**
 * 조회조건 변경 -> **그리드 비움 + 기간헤더 갱신** (design 03 §2.5 / 02 §3.2 비대칭 2 / V-31·V-32).
 *
 * AS-IS 는 **4개 핸들러 선두에서만** `BeforeFindData()` 를 호출한다 —
 * `clbDivision`(cs:1636) · `cboVersion`(cs:1646) · `cboVersionSeq`(cs:1655) · `rgrpDivisionType`(cs:1663).
 * `BeforeFindData()` = `InitSpread`(그리드 비움) + `RefreshSheetHeader(true)`(헤더 재조회) +
 * `SetVisibleSheetColumns` 다(cs:1422~1429). Column 설정 OK(cs:1770~1777)와 진입(`CreateSpread`)도 같은 경로다.
 * **Site / Plant / Building / Line / Operation / Line Type 변경은 그리드를 건드리지 않는다** —
 * 이 비대칭을 임의로 통일하면 AS-IS 와 체감이 달라진다(dev-manual 04 §5.3).
 *
 * 비움은 `clearFilters()` 한 곳에서만 하고 **한 effect 에서 헤더 갱신까지 함께 커밋**한다 —
 * 조건 축마다 effect 를 쪼개면 Division 한 번 변경에 그리드가 2~3회 깜빡인다(공통 QA "조회조건 변경 시
 * 깜빡임"). 자동 재조회는 하지 않는다 — `refetch()` 직접 호출 금지(nscm-patterns §5-1 / V-12).
 */
export const useCapaTeepReportConditionEffects = ({
  tabId,
  divisionId,
  divisionType,
  verId,
  verSeq,
}: Params) => {
  const queryClient = useQueryClient();
  const clearFilters = useCapaTeepReportStore(state => state.clearFilters);
  const refreshSpreadTitle = useCapaTeepReportStore(state => state.refreshSpreadTitle);
  const fetchStaticColumns = useCapaTeepReportStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useCapaTeepReportStore(state => state.fetchStaticMeasures);
  const restoreSearchConditions = useCapaTeepReportStore(
    state => state.restoreSearchConditions
  );

  /**
   * 진입 — 그리드는 비어 있고 GET SP 를 부르지 않는다(02 §4.1 "`Form_Load` 에 `FindData()` 호출 없음" /
   * nscm-patterns §5-7). MDI keep-alive 로 남아 있는 이전 `filters` 를 무효화하고 캐시까지 버려
   * 재진입 시 옛 rows 가 비치지 않게 한다.
   * 컬럼·Measure 메타는 mount 1회 fetch 가 허용된다(hook #66 — 헤더/컬럼은 조회 전에도 최신이어야 한다).
   */
  useEffect(() => {
    clearFilters();
    queryClient.removeQueries({ queryKey: [tabId] });
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // F6 저장조건 복원 — searchParams 만 patch 하고 filters 는 비운 채라 진입 자동조회는 돌지 않는다.
    //   탭당 1회 가드(store conditionsRestored)로 조건 변경마다 덮어쓰지 않는다.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    clearFilters();
    refreshSpreadTitle(toFromYyyymm(verId), SHEET_NAME_BY_DIVISION_TYPE[divisionType]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionId, divisionType, verId, verSeq]);
};
