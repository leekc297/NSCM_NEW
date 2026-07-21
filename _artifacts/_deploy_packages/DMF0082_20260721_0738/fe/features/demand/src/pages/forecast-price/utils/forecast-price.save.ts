import type { EditTracker } from '@foundation/utils';

import { toNumber } from '../components/ForecastPriceGridUtils';

/**
 * DMF0082_SAVE_MAIN_DATA 저장 payload 구성 — AS-IS SaveData(.cs L2025~2160) 1:1.
 * 저장 단위 = (행 키 × D_ 일자) flat row. 16 IN 파라미터를 '^' bulk 로 연결
 * (SAVE SP 는 '^' 파싱 — 조회 멀티선택의 콤마와 다름).
 * 행 키 컬럼 = GT_DMF0082_MF_SP 실측 (PROJECT_CODE/PLANT_SITE_ID 포함).
 */
export interface SaveRow {
  activeFlag: string; // I / M / D
  divisionId: string;
  projectCode: string;
  endCustomer: string;
  scmSiteId: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  measure: string;
  plantSite: string;
  cellProdSiteId: string;
  yyyymmdd: string;
  currency: string;
  qty: string;
}

const str = (v: unknown): string => {
  if (v === undefined || v === null) return '';
  return typeof v === 'string' ? v : typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';
};

const keyOf = (item: WijmoRowItem): Omit<SaveRow, 'activeFlag' | 'yyyymmdd' | 'qty'> => ({
  divisionId: str(item['DIVISION_ID']),
  projectCode: str(item['PROJECT_CODE'] || item['END_CUSTOMER']), // 40: PROJECT=END_CUSTOMER 코드 (AS-IS L761)
  endCustomer: str(item['END_CUSTOMER']),
  scmSiteId: str(item['SCM_SITE_ID']),
  itemId: str(item['ITEM_ID']),
  domExp: str(item['DOM_EXP']),
  fcstType: str(item['FCST_TYPE']),
  incoterms: str(item['INCOTERMS']),
  measure: str(item['MEASURE']),
  plantSite: str(item['PLANT_SITE_ID']),
  cellProdSiteId: str(item['CELL_PROD_SITE_ID']),
  currency: str(item['CURRENCY']),
});

/**
 * 저장 대상 rows 수집:
 *  - CRUD_TYPE='I' (신규): 편집가능 D_ 일자 중 값이 있는 셀 전량 → 'I'
 *  - CRUD_TYPE='M' (수정): tracker 변경분 중 D_ binding 만 → 'M'
 *  - CRUD_TYPE='D' (삭제): 편집가능 D_ 일자 전량 0 → 'D' (AS-IS DeleteButton — 계획구간만)
 */
export const buildSaveRows = (
  gridRows: WijmoRowItem[],
  tracker: EditTracker,
  editableDayColumns: string[]
): SaveRow[] => {
  const rows: SaveRow[] = [];
  const changed = tracker.getOriginalValues();

  for (const item of gridRows) {
    const crud = item['CRUD_TYPE'];
    if (crud === 'I') {
      const base = keyOf(item);
      editableDayColumns.forEach(d => {
        const qty = toNumber(item[d]);
        if (qty !== 0) {
          rows.push({ activeFlag: 'I', ...base, yyyymmdd: d.replace('D_', ''), qty: String(qty) });
        }
      });
    } else if (crud === 'D') {
      const base = keyOf(item);
      editableDayColumns.forEach(d => {
        rows.push({ activeFlag: 'D', ...base, yyyymmdd: d.replace('D_', ''), qty: '0' });
      });
    } else if (crud === 'M') {
      const base = keyOf(item);
      const bindings = changed.get(item);
      if (!bindings) continue;
      Object.keys(bindings).forEach(binding => {
        if (!binding.startsWith('D_')) return; // M_/W_ 편집은 배분으로 D_ 에 반영됨 — D_ 만 저장
        rows.push({
          activeFlag: 'M',
          ...base,
          yyyymmdd: binding.replace('D_', ''),
          qty: String(toNumber(item[binding])),
        });
      });
    }
  }
  return rows;
};

/** 16 IN '^' bulk payload (PROC_M COL_NM 순 — activeFlag~createdBy). */
export const buildSavePayload = (rows: SaveRow[], userId: string): Record<string, string> => ({
  activeFlag: rows.map(r => r.activeFlag).join('^'),
  divisionId: rows.map(r => r.divisionId).join('^'),
  projectCode: rows.map(r => r.projectCode).join('^'),
  endCustomer: rows.map(r => r.endCustomer).join('^'),
  scmSiteId: rows.map(r => r.scmSiteId).join('^'),
  itemId: rows.map(r => r.itemId).join('^'),
  domExp: rows.map(r => r.domExp).join('^'),
  fcstType: rows.map(r => r.fcstType).join('^'),
  incoterms: rows.map(r => r.incoterms).join('^'),
  measure: rows.map(r => r.measure).join('^'),
  plantSite: rows.map(r => r.plantSite).join('^'),
  cellProdSiteId: rows.map(r => r.cellProdSiteId).join('^'),
  yyyymmdd: rows.map(r => r.yyyymmdd).join('^'),
  currency: rows.map(r => r.currency).join('^'),
  qty: rows.map(r => r.qty).join('^'),
  createdBy: rows.map(() => userId).join('^'),
});
