import type { ComboResponse } from '@foundation/models';
import { useTabComboQueryResults } from '@shared/hooks';

import { CELL_COMBO_COLUMNS, COMBO } from '../shipment-change-request.constants';

/**
 * 그리드1 셀 콤보 dataMap 공급 — `FROM_SITE_DESCRIPTION` / `TO_SITE_DESCRIPTION`.
 *
 * **왜 필요한가(사용자 신고 2026-10-13 "Insert 하면 From Site 에 데이터가 안 들어간다")**
 *   `buildCopiedRow` 는 AS-IS(cs:2443~2444)대로 **코드값**(`FROM_SITE`/`TO_SITE`)을 복사해
 *   description 열에 넣는다. 저장 payload 가 `P_FROM_SITE`=site_id 를 요구하기 때문에 셀의 **값**은
 *   코드여야 맞다. 그런데 이 두 열에 콤보(dataMap)가 없으면 **값이 그대로 렌더**돼
 *   `IN00142000_40-P` 같은 코드가 보인다(기존행은 SP 가 `FN_GET_SCM_SITE_DESCRIPTION` 으로 만든
 *   `Elentec_IN` 을 보여주므로 신규행만 달라 보인다).
 *   -> 콤보를 붙이면 `값=코드 / 표시=설명` 이 되어 **복제·저장·표시가 동시에 맞는다.**
 *   To Site 가 멀쩡해 보였던 건 대부분의 to-site 가 코드==설명(`Honda_JP_STM`)이라 가려졌을 뿐이고
 *   같은 결함이다(ora.py 대조: FROM_SITE `IN00142000_40-P` ≠ 설명 `Elentec_IN`).
 *
 * 콤보 선택 근거는 `COMBO.CELL_FROM_SITE` 주석 참조 — 자매 SSP0200 의 셀 From Site 콤보는
 *   OSP 패커 사이트를 배제해 SSP0201(Packer) 실사용 12종을 **0건** 커버한다. 베끼면 안 된다.
 *
 * `useTabComboQueryResults` 를 쓰는 이유: data 뿐 아니라 `isFetching` 이 필요하다. division 축으로
 *   재조회되는 사이트 콤보가 행 데이터보다 늦게 도착하면 컬럼이 재빌드되며 깜빡인다 — 호출부가
 *   로딩 동안 표시를 미룰 수 있도록 함께 돌려준다(자매 SSP0200 과 같은 처방).
 */
export interface CellComboResult {
  /** 컬럼ID -> 후보행. `undefined` = 아직 미조회(0행과 구분해야 dataMap 을 성급히 비우지 않는다). */
  dataMaps: Record<string, ComboResponse[] | undefined>;
  /** 사이트 콤보 조회 중 여부. */
  loading: boolean;
}

export const useShipmentChangeRequestCellCombos = (divisionId: string): CellComboResult => {
  const results = useTabComboQueryResults({
    filters: [
      { comboId: COMBO.CELL_FROM_SITE, divisionId },
      { comboId: COMBO.CELL_TO_SITE, divisionId },
    ],
  });

  return {
    dataMaps: {
      [CELL_COMBO_COLUMNS.FROM_SITE_DESCRIPTION]: results[0]?.data,
      [CELL_COMBO_COLUMNS.TO_SITE_DESCRIPTION]: results[1]?.data,
    },
    loading: !!results[0]?.isFetching || !!results[1]?.isFetching,
  };
};
