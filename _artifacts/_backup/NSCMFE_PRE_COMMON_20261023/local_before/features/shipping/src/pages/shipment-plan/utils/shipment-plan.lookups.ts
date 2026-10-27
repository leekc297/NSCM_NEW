import { DataMap } from '@mescius/wijmo.grid';
import { useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useTabLookupQueries } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

// 그리드 셀 콤보 code->name 주입 대상 (runtime-parity §3.2 H2 — 공용 DataGrid 자동 콤보는
//   'LookupCommon'/'LookupCommon3'/'CHANGE_REASON_CODE_ALL' 의 @lookupType 토큰을 못 실어(comboId+mnuId만
//   전송) 0행 → 코드 원문 노출. 자매 SSP0014 처럼 useTabLookupQueries 직접 조회 + 컬럼별 주입으로 해소).
//
//   표시전용 3종(FCST_TYPE/SHIPMENT_STATUS/STOCK_STATUS)은 formatItem 으로 셀 텍스트만 교체하고,
//   편집 콤보 CHANGE_REASON_CODE 는 Wijmo DataMap 을 컬럼에 얹어 드롭다운 + 표시('CODE : 명')를 동시에 준다.
export const LOOKUP_COLUMN = {
  FCST_TYPE: 'FCST_TYPE', // SALES_TYPE_CODE
  SHIPMENT_STATUS: 'SHIPMENT_STATUS', // SHIPMENT_STATUS
  STOCK_STATUS: 'STOCK_STATUS', // OWMS_STOCK_STATUS (oWMS Detail)
  CHANGE_REASON_CODE: 'CHANGE_REASON_CODE', // CHANGE_REASON_CODE (편집)
} as const;

// admin/lookup(PR_GET_LOOKUP_INFO_LIST) 반환 커서 컬럼명은 SCM_ADM_LOOKUP_MASTER 헤더 실측으로 확정:
//   SALES_TYPE_CODE/SHIPMENT_STATUS = CODE/NAME · OWMS_STOCK_STATUS/CHANGE_REASON_CODE = CODE/NAME_K/NAME_E.
const LOOKUP_TYPE = {
  SALES_TYPE: 'SALES_TYPE_CODE',
  SHIPMENT_STATUS: 'SHIPMENT_STATUS',
  OWMS_STOCK: 'OWMS_STOCK_STATUS',
  CHANGE_REASON: 'CHANGE_REASON_CODE',
} as const;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type LookupRow = Record<string, string>;

const toRecord = (rows: LookupRow[] | undefined, nameOf: (r: LookupRow) => string): Record<string, string> => {
  const m: Record<string, string> = {};
  (rows ?? []).forEach(r => {
    const code = str(r.CODE);
    if (code) m[code] = nameOf(r) || code;
  });
  return m;
};

export interface ShipmentPlanLookups {
  // code -> 표시명 (표시전용 formatItem 용)
  fcstTypeMap: Record<string, string>;
  shipmentStatusMap: Record<string, string>;
  stockStatusMap: Record<string, string>;
  // 편집 콤보(드롭다운 + 'CODE : 명' 표시) — 미로딩이면 null
  changeReasonDataMap: DataMap | null;
}

/**
 * SSP0060 그리드 셀 콤보 lookup 4종을 한 번에 조회해 주입용 맵을 돌려준다.
 *   react-query 가 lookupType 키로 캐시·중복제거하므로 Main/Detail 양쪽에서 호출해도 1회 조회다.
 */
export const useShipmentPlanLookups = (): ShipmentPlanLookups => {
  const langCd = useSessionStore(s => s.session.langCd);
  const [salesType, shipmentStatus, stockStatus, changeReason] = useTabLookupQueries({
    filters: [
      { lookupType: LOOKUP_TYPE.SALES_TYPE },
      { lookupType: LOOKUP_TYPE.SHIPMENT_STATUS },
      { lookupType: LOOKUP_TYPE.OWMS_STOCK },
      { lookupType: LOOKUP_TYPE.CHANGE_REASON },
    ],
  });

  const nameByLang = (r: LookupRow): string =>
    (langCd === 'KO' ? str(r.NAME_K) : str(r.NAME_E)) || str(r.NAME_E) || str(r.NAME_K);

  const fcstTypeMap = useMemo(() => toRecord(salesType, r => str(r.NAME)), [salesType]);
  const shipmentStatusMap = useMemo(() => toRecord(shipmentStatus, r => str(r.NAME)), [shipmentStatus]);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  const stockStatusMap = useMemo(() => toRecord(stockStatus, nameByLang), [stockStatus, langCd]);

  // CHANGE_REASON_CODE: 표시형 'CODE : 명'(AS-IS CHANGE_REASON_CODE_ALL 콤보 재현, SSP0014 동일).
  //   선두 '-'(해제) 행 포함 — AS-IS 콤보 SQL 이 `SELECT '-' AS CODE, NULL AS NAME ... UNION ALL ...` 로
  //   사유 해제 옵션을 제공한다(선택 시 파생 로직이 CHANGE_REASON_DETAIL 클리어).
  const changeReasonDataMap = useMemo(() => {
    const rows = changeReason ?? [];
    if (rows.length === 0) return null;
    const list = [
      { CODE: '-', NAME: '-' },
      ...rows.map(r => {
        const code = str(r.CODE);
        return { CODE: code, NAME: `${code} : ${nameByLang(r)}` };
      }),
    ];
    return new DataMap(list, 'CODE', 'NAME');
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [changeReason, langCd]);

  return { fcstTypeMap, shipmentStatusMap, stockStatusMap, changeReasonDataMap };
};

/**
 * 지정 컬럼들의 셀 콤보 메타(cellCtrlObjTpCd/cellCboDataTp)를 벗긴다 — 공용 DataGrid 자동 콤보가
 *   빈 dataMap(@lookupType 미해소 0행)을 얹어 화면 주입 dataMap/formatItem 과 충돌하는 것을 막는다.
 */
export const stripComboMeta = (
  columns: RawFlexGridColumnConfig[] | undefined,
  names: ReadonlySet<string>
): RawFlexGridColumnConfig[] => {
  if (!columns || columns.length === 0) return columns ?? [];
  if (!columns.some(c => names.has(c.colNm) && c.cellCboDataTp)) return columns;
  return columns.map(c => {
    if (!names.has(c.colNm)) return c;
    const { cellCtrlObjTpCd: _ctrl, cellCboDataTp: _combo, ...rest } = c;
    return rest;
  });
};
