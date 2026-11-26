/**
 * Cell Prod Site 행별 편집 후보 캐시 (D9, AS-IS `Data.Common(Type.CELL_PROD_SITE_ID, division, itemId)`
 *   = `UP_FX_GetCommonDataList @Code='CELL_PROD_SITE_ID'`, .cs L5854)
 *
 * 후보는 행의 (DIVISION_ID, ITEM_ID) 조합으로 서버에서 받아 행별로 보관한다.
 *
 * 주의: 행 객체만 키로 쓰면 안 된다. Model 팝업은 ITEM_ID 를 **행 객체를 그대로 둔 채** 바꾸므로,
 *   행 참조만 보면 이전 Model 의 후보가 그대로 남는다. 그래서 캐시를 꺼낼 때마다 저장 당시의
 *   (DIVISION_ID, ITEM_ID) 와 현재 값을 비교해, 다르면 없는 것(undefined)으로 돌려준다.
 *
 * 주의: 응답 순서가 뒤바뀔 수 있다. 같은 행에서 조회를 두 번 띄우면(Model 을 빠르게 두 번 변경 등)
 *   먼저 띄운 요청이 나중에 도착할 수 있다. 도착 시점에 그 요청이 그 행의 마지막 요청이 아니거나
 *   그 사이 Model 이 바뀌었으면 결과를 버린다(undefined).
 *
 * DIVISION_ID 또는 ITEM_ID 가 비어 있는 행은 조회하지 않는다(undefined) — 종전 동작 유지.
 *   이때 편집 드롭다운은 전체 표시 목록으로 폴백한다.
 */
import type { ComboResponse } from '@foundation/models';

type SiteRow = WijmoRowItem;

interface CellProdSiteEntry {
  key: string;
  rows?: ComboResponse[];
}

/** 후보를 결정하는 (DIVISION_ID, ITEM_ID) 조합 키. */
export const cellProdSiteKey = (row: SiteRow): string =>
  JSON.stringify([String(row.DIVISION_ID ?? ''), String(row.ITEM_ID ?? '')]);

export const createCellProdSiteCandidates = (
  fetchRows: (divisionId: string, itemId: string) => Promise<ComboResponse[]>
) => {
  const entries = new WeakMap<SiteRow, CellProdSiteEntry>();
  return {
    /** 현재 (DIVISION_ID, ITEM_ID) 로 받아 둔 후보. 없거나 Model 이 바뀌었으면 undefined. */
    get(row: SiteRow): ComboResponse[] | undefined {
      const entry = entries.get(row);
      return entry?.key === cellProdSiteKey(row) ? entry.rows : undefined;
    },
    /** 후보를 새로 조회해 보관한다. 조회하지 않았거나 결과를 버렸으면 undefined. */
    async load(row: SiteRow): Promise<ComboResponse[] | undefined> {
      const divisionId = String(row.DIVISION_ID ?? '');
      const itemId = String(row.ITEM_ID ?? '');
      if (!divisionId || !itemId) return undefined;
      const entry: CellProdSiteEntry = { key: cellProdSiteKey(row) };
      entries.set(row, entry);
      const rows = (await fetchRows(divisionId, itemId)) ?? [];
      // 이 요청이 그 행의 마지막 요청이 아니거나, 기다리는 사이 Model 이 바뀌었으면 버린다.
      if (entries.get(row) !== entry || entry.key !== cellProdSiteKey(row)) return undefined;
      entry.rows = rows;
      return rows;
    },
  };
};
