import { useCallback, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse } from '@foundation/models';
import { useTabComboQueryResults, useTabLookupQueries } from '@shared/hooks';

import {
  COMBO,
  END_CUSTOMER_EMPTY_CODE,
  INJECTED_COMBO,
  LOOKUP,
  MENU_ID,
} from '../shipment-change-request-plan.constants';

type DataMaps = Record<string, ComboResponse[] | undefined>;

const toCombo = (rows: Record<string, string>[] | undefined): ComboResponse[] | undefined =>
  rows === undefined ? undefined : (rows as ComboResponse[]);

/**
 * 행 파라미터 콤보 캐시 키 — 값이 하나라도 비면 빈 키를 돌려 조회하지 않는다
 *   (AS-IS 도 3/4 키 전건 필수). 구분자를 넣어야 ('a','bc') 와 ('ab','c') 가 같은 키로 뭉치지 않는다.
 */
const KEY_SEP = '||';
const keyOf = (parts: string[]): string => (parts.every(Boolean) ? parts.join(KEY_SEP) : '');

export interface TransModeKeys {
  divisionId: string;
  fromSite: string;
  toSite: string;
  incoterms: string;
}

export interface EndCustomerKeys {
  divisionId: string;
  scmSiteId: string;
  itemId: string;
}

/** 후보 0행이면 '-' 단일행을 합성한다(AS-IS cs:6665~6675). 자동선택 판정과는 별개 축이다. */
const withEmptyFallback = (raw: ComboResponse[]): ComboResponse[] =>
  raw.length > 0
    ? raw
    : [{ CODE: END_CUSTOMER_EMPTY_CODE, NAME: END_CUSTOMER_EMPTY_CODE } as ComboResponse];

/**
 * 셀 콤보 주입 원천 (design 03 §1.3 D-1/D-2 해소).
 *
 * 메타 콤보(`LookupCommon`/`CHANGE_REASON_CODE_ALL`)는 `@lookupType`·`@sesUserId` 를
 * **그리드 단위 `comboParams`** 로만 받을 수 있어, 한 시트에 3종 lookupType 이 필요한 이 화면에서는
 * 원리적으로 충족이 불가능하다. 게다가 공용 DataGrid 가 `cellCboDataTp` 문자열로 중복제거하고
 * `attribute1` 소비처가 FE/BE 통틀어 0건이라 `SHIPMENT_STATUS`·`FCST_TYPE` 이 **같은 목록**을 보게 된다.
 * 그래서 화면이 직접 후보를 조회해 `staticColumns[].dataMap` 으로 주입한다
 * (주입 시 `cellCboDataTp` 를 비워야 자동 콤보가 덮어쓰지 않는다 — `…Columns.ts` 참조).
 *
 * 행 파라미터형 2종(`TRANSPORT_MODE`·`END_CUSTOMER`)은 후보가 **행 값**에 종속이라 컬럼 단위 조회로는
 * 만들 수 없다. AS-IS 도 `SetCellTypeCombo(행, 컬럼, dt)` 로 행마다 갈아끼우므로
 * (cs:5468 TransMode — CellClick / cs:6658 EndCustomer — setEndCustomer), TO-BE 도 대상 행의 키로
 * 그때그때 조회해 같은 dataMap 자리를 교체한다. 키가 같으면 재조회하지 않는다(중복 호출 방지).
 *
 * `FROM_SITE_DESCRIPTION` 도 주입한다(2026-09-29) — AS-IS `PlantSiteByDivisionEEOperation`(cs:2718)의
 *   TO-BE 콤보 `PlantSiteByDivisionEEOperation_SCP`(@divisionId, USE_YN='Y')가 배포돼 있어(ora.py 실측)
 *   To Site 와 동일한 division 축으로 주입한다. 과거 "미이관" 판정은 낡았다.
 *   `NEW_TRANSPORT_MODE` 는 AS-IS 도 자유입력이라 콤보 신설 금지(미배선 유지).
 */
export const useShipmentChangeRequestPlanCellCombos = (divisionId: string) => {
  const [statusRows] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.SHIPMENT_STATUS }] });
  const [fcstRows] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.SALES_TYPE_CODE }] });
  // data 뿐 아니라 isFetching 도 필요하다 — 조회 시 div 로 재조회하는 대용량 To/From Site 셀콤보가
  //   데이터보다 늦게 도착하면 컬럼이 재빌드되며 "데이터 나왔다 사라졌다" 깜빡임이 난다. 호출부가
  //   이 로딩이 끝날 때까지 그리드 표시를 미룰 수 있도록 로딩 상태를 함께 돌려준다.
  const comboResults = useTabComboQueryResults({
    filters: [
      // 필수: @lookupType. CMBO 본문이 `WHERE A.LOOKUP_TYPE = @lookupType` 라 미전달 시 BE 가 '' 로
      //   치환해 후보가 더미 '-' 1행뿐이 된다(ora.py 실측: 전달 시 8행 = '-' + T01~T07).
      //   그러면 요청정보 Change Reason* 를 만족시킬 수 없어 Request Complete 가 영구 차단된다.
      { comboId: COMBO.CHANGE_REASON, mnuId: MENU_ID, lookupType: LOOKUP.CHANGE_REASON_CODE },
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      // 주의: 셀 콤보의 To Site 는 조회조건(`ShipmentPlanToSite_SCP`)과 **다른 SQL_ID** 다(§1.3 #8).
      { comboId: COMBO.CELL_TO_SITE, divisionId },
      // 셀 From Site — AS-IS PlantSiteByDivisionEEOperation(cs:2718)의 TO-BE 등가(@divisionId 스코프).
      //   조회조건 From Site(ShipmentPlanPlantSite_SCP)와 다른 SQL_ID 다 — To Site 와 동일한 division 축.
      { comboId: COMBO.CELL_FROM_SITE, divisionId },
    ],
  });
  const [reasonRows, divisionRows, cellToSiteRows, cellFromSiteRows] = comboResults.map(r => r.data);
  // div 로 재조회하는 대용량 셀콤보(To Site[2]/From Site[3])의 로딩 여부만 본다(reason/division 은 고정).
  const cellCombosLoading = !!comboResults[2]?.isFetching || !!comboResults[3]?.isFetching;

  // 행 파라미터 콤보 — 조회 완료 여부를 키로 함께 들고 있어야 "아직 미조회" 와 "후보 0행" 을 구분할 수 있다.
  const [transMode, setTransMode] = useState<{ key: string; rows: ComboResponse[] }>({
    key: '',
    rows: [],
  });
  const [endCustomer, setEndCustomer] = useState<{ key: string; rows: ComboResponse[] }>({
    key: '',
    rows: [],
  });
  const inFlightRef = useRef<{ transMode: string; endCustomer: string }>({
    transMode: '',
    endCustomer: '',
  });

  const loadTransMode = useCallback(
    async ({ divisionId: div, fromSite, toSite, incoterms }: TransModeKeys): Promise<void> => {
      const key = keyOf([div, fromSite, toSite, incoterms]);
      if (!key || key === transMode.key || key === inFlightRef.current.transMode) return;
      inFlightRef.current.transMode = key;
      try {
        // 인용은 getCombo 가 처리한다 — 화면이 따옴표를 붙이지 않는다(nscm-patterns §3.3).
        const rows = await apiClient.getCombo({
          comboId: COMBO.CELL_TRANS_MODE,
          divisionId: div,
          fromSite,
          toSite,
          incoterms,
        });
        setTransMode({ key, rows: rows ?? [] });
      } catch {
        // 조회 실패는 "후보 0행" 과 같은 취급이다 — AS-IS 도 dtTransMode==null 을 MSG00293 으로 막는다.
        setTransMode({ key, rows: [] });
      } finally {
        inFlightRef.current.transMode = '';
      }
    },
    [transMode.key]
  );

  /**
   * EndCustomer 후보 조회. 0행이면 AS-IS 처럼 '-' 단일 행을 합성해 dataMap 에 넣는다(cs:6665~6675).
   *   반환값은 **이번 조회의 원본 행**이다 — 1행이면 호출부가 그 값을 셀에 넣는다(cs:6660).
   *   캐시 적중(같은 키 재요청)이면 `undefined` 를 돌려 자동선택을 반복하지 않는다. 합성한 '-' 행을
   *   돌려주면 0행 경로에서 AS-IS 가 하지 않는 셀 대입이 생긴다(cs:6670~6672 대입은 주석).
   */
  const loadEndCustomer = useCallback(
    async ({
      divisionId: div,
      scmSiteId,
      itemId,
    }: EndCustomerKeys): Promise<ComboResponse[] | undefined> => {
      const key = keyOf([div, scmSiteId, itemId]);
      if (!key || key === endCustomer.key || key === inFlightRef.current.endCustomer) {
        return undefined;
      }
      inFlightRef.current.endCustomer = key;
      try {
        // @param5 는 packer 분기 토큰이다. AS-IS 3인자 호출은 이 값을 주지 않아 비-packer 분기를 탄다 —
        //   빈 문자열을 명시 전달해 같은 분기를 재현한다(미전달 시 BE 치환 결과가 계약에 없다).
        const rows = await apiClient.getCombo({
          comboId: COMBO.CELL_END_CUSTOMER,
          divisionId: div,
          scmSiteId,
          itemId,
          param5: '',
        });
        const raw = rows ?? [];
        setEndCustomer({ key, rows: withEmptyFallback(raw) });
        return raw;
      } catch {
        setEndCustomer({ key, rows: [] });
        return undefined;
      } finally {
        inFlightRef.current.endCustomer = '';
      }
    },
    [endCustomer.key]
  );

  const mainDataMaps = useMemo<DataMaps>(
    () => ({
      [INJECTED_COMBO.SHIPMENT_STATUS]: toCombo(statusRows),
      [INJECTED_COMBO.FCST_TYPE]: toCombo(fcstRows),
      [INJECTED_COMBO.CHANGE_REASON_CODE]: reasonRows,
      [INJECTED_COMBO.DIVISION_ID]: divisionRows,
      [INJECTED_COMBO.FROM_SITE_DESCRIPTION]: cellFromSiteRows,
      [INJECTED_COMBO.TO_SITE_DESCRIPTION]: cellToSiteRows,
      // 미조회 상태는 `undefined` 로 남겨 메타 셀유형을 건드리지 않는다(빈 배열을 주면 빈 콤보가 된다).
      [INJECTED_COMBO.TRANSPORT_MODE]: transMode.key ? transMode.rows : undefined,
      [INJECTED_COMBO.END_CUSTOMER]: endCustomer.key ? endCustomer.rows : undefined,
    }),
    [
      statusRows,
      fcstRows,
      reasonRows,
      divisionRows,
      cellFromSiteRows,
      cellToSiteRows,
      transMode,
      endCustomer,
    ]
  );

  const subDataMaps = useMemo<DataMaps>(
    () => ({ [INJECTED_COMBO.FCST_TYPE]: toCombo(fcstRows) }),
    [fcstRows]
  );

  /** 이 행 키로 TransMode 조회가 끝났는지 — "미조회" 와 "후보 0행" 을 구분하는 판정축이다. */
  const isTransModeLoaded = useCallback(
    (keys: TransModeKeys): boolean => {
      const key = keyOf([keys.divisionId, keys.fromSite, keys.toSite, keys.incoterms]);
      return !!key && key === transMode.key;
    },
    [transMode.key]
  );

  return {
    mainDataMaps,
    subDataMaps,
    loadTransMode,
    loadEndCustomer,
    isTransModeLoaded,
    cellCombosLoading,
  };
};
