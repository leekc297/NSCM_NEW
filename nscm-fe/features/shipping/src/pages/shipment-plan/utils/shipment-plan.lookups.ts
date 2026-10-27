import { DataMap } from '@mescius/wijmo.grid';
import { useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

import { COMBO, MENU_ID } from '../shipment-plan.constants';

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

/**
 * lookup 행 배열의 참조 안정화 — useTabLookupQueries 는 useQueries 결과를 `.map(d => d.data)` 로
 * 돌려줘 **매 렌더 새 배열**이다(참조 불안정). 그대로 useMemo deps 에 쓰면 파생 DataMap/맵이
 * 매 렌더 재생성되고, 그 인스턴스를 그리드 col.dataMap 에 재대입하는 effect 가 매 렌더 돌아
 * 편집 중 드롭다운이 닫히고 커밋이 증발한다 (2026-10-22 실사고 — Request 팝업 "Maximum update
 * depth exceeded" 300건/3초 + 하단 그리드 콤보 소실. DataGrid L1762 주석이 경고한 유형).
 * 내용 시그니처(CODE·NAME*)가 같으면 직전 배열 참조를 돌려줘 로드 완료 후 참조를 고정한다.
 */
const useStableLookup = (rows: LookupRow[] | undefined): LookupRow[] | undefined => {
  const ref = useRef<{ sig: string; rows: LookupRow[] | undefined }>({ sig: '', rows: undefined });
  const sig = (rows ?? [])
    .map(r => `${r.CODE}${r.NAME ?? ''}${r.NAME_K ?? ''}${r.NAME_E ?? ''}`)
    .join('');
  if (ref.current.sig !== sig || (ref.current.rows === undefined && rows !== undefined)) {
    ref.current = { sig, rows };
  }
  return ref.current.rows;
};

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
  // oWMS Inventory Status(STOCK_STATUS) 편집 콤보 — 드롭다운 + 'CODE : 명' 표시. 미로딩이면 null.
  stockStatusDataMap: DataMap | null;
}

/**
 * SSP0060 그리드 셀 콤보 lookup 4종을 한 번에 조회해 주입용 맵을 돌려준다.
 *   react-query 가 lookupType 키로 캐시·중복제거하므로 Main/Detail 양쪽에서 호출해도 1회 조회다.
 */
export const useShipmentPlanLookups = (): ShipmentPlanLookups => {
  const langCd = useSessionStore(s => s.session.langCd);
  const [salesTypeRaw, shipmentStatusRaw, stockStatusRaw, changeReasonRaw] = useTabLookupQueries({
    filters: [
      { lookupType: LOOKUP_TYPE.SALES_TYPE },
      { lookupType: LOOKUP_TYPE.SHIPMENT_STATUS },
      { lookupType: LOOKUP_TYPE.OWMS_STOCK },
      { lookupType: LOOKUP_TYPE.CHANGE_REASON },
    ],
  });
  // 참조 안정화 필수 — useStableLookup 주석 참조(매 렌더 새 배열 → DataMap 재생성 → 편집 파손).
  const salesType = useStableLookup(salesTypeRaw);
  const shipmentStatus = useStableLookup(shipmentStatusRaw);
  const stockStatus = useStableLookup(stockStatusRaw);
  const changeReason = useStableLookup(changeReasonRaw);

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

  // oWMS Inventory Status(STOCK_STATUS) 편집 콤보 — 드롭다운 + 'CODE : 명' 표시(사용자 지시 2026-10-20:
  //   자매 SSP0021 처럼 콤보 선택 가능해야 한다). 원천은 표시전용 stockStatusMap 과 동일(OWMS_STOCK lookup) —
  //   값=CODE, 표시='CODE : 명'(SSP0021 '80 : 검사합격' 비주얼 일치). 종전엔 formatItem 표시만 있어 드롭다운이 없었다.
  const stockStatusDataMap = useMemo(() => {
    const rows = stockStatus ?? [];
    if (rows.length === 0) return null;
    const list = rows.map(r => {
      const code = str(r.CODE);
      return { CODE: code, NAME: `${code} : ${nameByLang(r)}` };
    });
    return new DataMap(list, 'CODE', 'NAME');
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stockStatus, langCd]);

  return {
    fcstTypeMap,
    shipmentStatusMap,
    stockStatusMap,
    changeReasonDataMap,
    stockStatusDataMap,
  };
};

// 신규행 From/To Site 셀 콤보 주입 대상 컬럼(값=site_id 코드 / 표시=SITE_DESCRIPTION).
//   AS-IS BtnNew_Click 이 SetCellTypeCombo 로 이 두 *_DESCRIPTION 컬럼에 거는 콤보(cs L7421~7422)의
//   TO-BE 등가. 값 모델은 EditorValue=ItemData(= 코드 저장, 명 표시, SpreadInfo.LoadCombo L4576)라
//   dataMap(코드->명)으로 재현한다 — dataMap 이 없으면 코드가 날것으로 보인다([[ssp0201-site-description
//   -cell-needs-combo-datamap]]).
export const SITE_CELL_COLUMN = {
  FROM_SITE_DESCRIPTION: 'FROM_SITE_DESCRIPTION',
  TO_SITE_DESCRIPTION: 'TO_SITE_DESCRIPTION',
} as const;

export interface ShipmentPlanSiteCombos {
  fromSiteDataMap: DataMap | null;
  toSiteDataMap: DataMap | null;
}

const buildSiteDataMap = (
  rows: readonly Record<string, unknown>[] | undefined
): DataMap | null => {
  if (!rows || rows.length === 0) return null;
  const list = rows.map(r => ({ CODE: str(r.CODE), NAME: str(r.NAME) || str(r.CODE) }));
  return new DataMap(list, 'CODE', 'NAME');
};

/**
 * 신규행 From/To Site 셀 콤보 데이터(design 03 §0 G24/§1.2 route 구간, gap-resolve iter-4).
 *   - From Site: `Com_FromSite_SCP`(@divisionId @companyId) — AS-IS `dtFromSite`(cs L7180) 등가.
 *   - To Site:   `ShipmentPlanToSite_SCP`(@divisionId, @group·@user BE주입) — AS-IS `dtToSite`(cs L7185) 등가.
 *   조회조건 From Site 콤보와 동일 토큰이라 react-query 가 division/company 키로 중복제거(1회 조회).
 */
export const useShipmentPlanSiteCombos = (
  divisionId: string,
  companyId: string
): ShipmentPlanSiteCombos => {
  const [fromSites, toSites] = useTabComboQueries({
    filters: [
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId, companyId },
      { comboId: COMBO.TO_SITE, mnuId: MENU_ID, divisionId },
    ],
  });
  const fromSiteDataMap = useMemo(() => buildSiteDataMap(fromSites), [fromSites]);
  const toSiteDataMap = useMemo(() => buildSiteDataMap(toSites), [toSites]);
  return { fromSiteDataMap, toSiteDataMap };
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
