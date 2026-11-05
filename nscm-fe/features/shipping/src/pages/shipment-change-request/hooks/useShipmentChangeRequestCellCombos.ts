import { useCallback, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse } from '@foundation/models';
import { useTabComboQueryResults } from '@shared/hooks';

import {
  CELL_COMBO_COLUMNS,
  COMBO,
  END_CUSTOMER_EMPTY_CODE,
} from '../shipment-change-request.constants';

/** 행 파라미터 콤보(End Customer) 캐시 키 — 값이 하나라도 비면 빈 키(조회 안 함, 자매 SSP0200 과 동일). */
const KEY_SEP = '||';
const keyOf = (parts: string[]): string => (parts.every(Boolean) ? parts.join(KEY_SEP) : '');

/** 후보 0행이면 '-' 단일행을 합성한다(AS-IS cs:6665~6675, 자매 SSP0200 과 동일). */
const withEmptyFallback = (raw: ComboResponse[]): ComboResponse[] =>
  raw.length > 0
    ? raw
    : [{ CODE: END_CUSTOMER_EMPTY_CODE, NAME: END_CUSTOMER_EMPTY_CODE } as ComboResponse];

export interface EndCustomerKeys {
  divisionId: string;
  scmSiteId: string;
  itemId: string;
}

/**
 * 그리드1 셀 콤보 dataMap 공급 — `FROM_SITE_DESCRIPTION` / `TO_SITE_DESCRIPTION` / `END_CUSTOMER`.
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
  /**
   * End Customer 후보 재조회(행 파라미터, AS-IS setEndCustomer cs:5731~5748 의 TO-BE 등가).
   *   1건이면 호출부가 그 코드를 셀에 자동대입할 수 있도록 원본 후보를 돌려준다. 캐시 적중(같은 키
   *   재요청)이면 `undefined` 를 돌려 자동확정을 반복하지 않는다(자매 SSP0200 `loadEndCustomer` 와 동일 규약).
   */
  loadEndCustomer: (keys: EndCustomerKeys) => Promise<ComboResponse[] | undefined>;
  /**
   * End Customer 셀 포커스 — 자동확정 없이 그 행 키로 dataMap 슬롯만 맞춘다. 키가 비면(item/To Site
   *   미설정) 슬롯을 즉시 비워 이전 행 후보가 남지 않게 한다.
   */
  focusEndCustomerRow: (keys: EndCustomerKeys) => void;
}

export const useShipmentChangeRequestCellCombos = (divisionId: string): CellComboResult => {
  const results = useTabComboQueryResults({
    filters: [
      { comboId: COMBO.CELL_FROM_SITE, divisionId },
      { comboId: COMBO.CELL_TO_SITE, divisionId },
    ],
  });

  const [endCustomer, setEndCustomer] = useState<{ key: string; rows: ComboResponse[] }>({
    key: '',
    rows: [],
  });
  const inFlightKeyRef = useRef('');

  const loadEndCustomer = useCallback(
    async ({
      divisionId: div,
      scmSiteId,
      itemId,
    }: EndCustomerKeys): Promise<ComboResponse[] | undefined> => {
      const key = keyOf([div, scmSiteId, itemId]);
      if (!key || key === endCustomer.key || key === inFlightKeyRef.current) return undefined;
      inFlightKeyRef.current = key;
      try {
        // @param5='P' — SSP0201(Packer) 분기 상수(COMBO.CELL_END_CUSTOMER 주석 참조, 자매 SSP0200 은 '').
        const rows = await apiClient.getCombo({
          comboId: COMBO.CELL_END_CUSTOMER,
          divisionId: div,
          scmSiteId,
          itemId,
          param5: 'P',
        });
        const raw = rows ?? [];
        setEndCustomer({ key, rows: withEmptyFallback(raw) });
        return raw;
      } catch {
        setEndCustomer({ key, rows: [] });
        return undefined;
      } finally {
        inFlightKeyRef.current = '';
      }
    },
    [endCustomer.key]
  );

  const focusEndCustomerRow = useCallback(
    ({ divisionId: div, scmSiteId, itemId }: EndCustomerKeys): void => {
      const key = keyOf([div, scmSiteId, itemId]);
      if (!key) {
        if (endCustomer.key) setEndCustomer({ key: '', rows: [] });
        return;
      }
      if (key === endCustomer.key || key === inFlightKeyRef.current) return;
      void loadEndCustomer({ divisionId: div, scmSiteId, itemId });
    },
    [endCustomer.key, loadEndCustomer]
  );

  return {
    dataMaps: {
      [CELL_COMBO_COLUMNS.FROM_SITE_DESCRIPTION]: results[0]?.data,
      [CELL_COMBO_COLUMNS.TO_SITE_DESCRIPTION]: results[1]?.data,
      [CELL_COMBO_COLUMNS.END_CUSTOMER]: endCustomer.key ? endCustomer.rows : undefined,
    },
    loading: !!results[0]?.isFetching || !!results[1]?.isFetching,
    loadEndCustomer,
    focusEndCustomerRow,
  };
};
