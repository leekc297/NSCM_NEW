import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';

import { D_EDIT_MEASURES, MEASURE, type MENU_ID, type SHEETS } from '../capa-report-small.constants';
import type { CapaRowItem } from '../capa-report-small.types';

import { kindOf } from './capa-report-small.dynamicColumns';

type ProductRateRow = ResponseData<MENU_ID, SHEETS.CAPA_PRODUCT_RATE>;
type CapaMonthRow = ResponseData<MENU_ID, SHEETS.CAPA_MONTH>;
type CapaWorkRow = ResponseData<MENU_ID, SHEETS.CAPA_WORK>;

export interface SavePayload {
  productRate: ProductRateRow[];
  capaMonth: CapaMonthRow[];
  capaWork: CapaWorkRow[];
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): string => {
  const n = typeof v === 'number' ? v : Number(str(v).trim());
  return Number.isFinite(n) ? String(n) : '';
};
// NO_WORK(비조업) D_셀 SP 계약값 — GET 은 값 1을 'Y', 그 외를 ''(빈값)로 내려주고(PKG_SCP0098
// 본문 CASE WHEN =1 THEN 'Y' ELSE ''), 그리드 편집은 'Y'/'N' 으로 정규화한다. SAVE(P_SAVE_SCP_CAPA_WORK)
// 는 1/0 을 기대하므로('82^1^0.9' 예시) 저장 직전 매핑한다. num() 숫자강제는 'Y'→NaN→'' 로 값 소실.
const ynToBit = (v: unknown): string => (str(v).trim().toUpperCase() === 'Y' ? '1' : '0');

/**
 * EditTracker 의 변경 셀(getOriginalValues)을 3분기 저장 payload 로 분해한다(design 03 §4.4).
 *   - PRODUCT_READY      → capaProductRate (조회 period start/end + product_rate)
 *   - measure DAILY_CAPA 의 M_셀 → capaMonth   (yyyymm + value)
 *   - measure NO/LOAD/RAMP 의 D_셀 → capaWork  (measure + yyyymmdd + value)
 * activeFlag = 행 CRUD_TYPE(수정=M). SP 의 P_ACTIVE_FLAG 정확 의미는 SP 본문 대조 대상(convert-sp).
 */
export const buildSavePayload = (
  tracker: EditTracker,
  period: { from: string; to: string },
  userId: string
): SavePayload => {
  const out: SavePayload = { productRate: [], capaMonth: [], capaWork: [] };
  const productKeyed = new Set<string>();

  tracker.getOriginalValues().forEach((originals, rawRow) => {
    const row = rawRow as unknown as CapaRowItem;
    const activeFlag = str(row.CRUD_TYPE) || CRUD_TYPE.MODIFY;
    const key = {
      divisionId: str(row.DIVISION_ID),
      plantId: str(row.PLANT_ID),
      factoryId: str(row.FACTORY_ID),
      operationId: str(row.OPERATION_ID),
      lineId: str(row.LINE_ID),
    };
    const measure = str(row.MEASURE_UI);

    for (const binding of Object.keys(originals)) {
      if (binding === 'PRODUCT_READY') {
        // 행 단위 1건 — 같은 행에서 PRODUCT_READY 를 여러 번 편집해도 중복 저장 방지.
        const dedup = `${key.divisionId}|${key.plantId}|${key.factoryId}|${key.operationId}|${key.lineId}`;
        if (productKeyed.has(dedup)) continue;
        productKeyed.add(dedup);
        out.productRate.push({
          activeFlag,
          ...key,
          startYyyymmdd: period.from,
          endYyyymmdd: period.to,
          productRate: num(row.PRODUCT_READY),
          userId,
        });
        continue;
      }
      const kind = kindOf(binding);
      if (kind === 'M' && measure === MEASURE.DAILY_CAPA) {
        out.capaMonth.push({
          activeFlag,
          ...key,
          itemId: str(row.ITEM_ID),
          yyyymm: binding.slice(2),
          value: num(row[binding]),
          userId,
        });
      } else if (kind === 'D' && D_EDIT_MEASURES.includes(measure)) {
        out.capaWork.push({
          activeFlag,
          ...key,
          measure,
          yyyymmdd: binding.slice(2),
          // NO_WORK 은 'Y'/'N' → 1/0 매핑, 나머지(LOAD_RATE/RAMP_UP)는 숫자 그대로.
          value: measure === MEASURE.NO_WORK ? ynToBit(row[binding]) : num(row[binding]),
          userId,
        });
      }
    }
  });

  return out;
};
