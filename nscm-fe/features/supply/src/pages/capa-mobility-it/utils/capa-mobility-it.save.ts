import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';

import { D_EDIT_MEASURES, MEASURE, type MENU_ID, type SHEETS } from '../capa-mobility-it.constants';
import type { CapaRowItem } from '../capa-mobility-it.types';

import { kindOf } from './capa-mobility-it.dynamicColumns';

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

/**
 * 저장 전 값 검증 — AS-IS SaveDataFull(L1998~2177) 파리티. 변경된 행(payload)만 AS-IS 순서로 검사해
 *   첫 위반 메시지를 반환한다. null = 통과. 하나라도 위반하면 저장 전체 차단(AS-IS return).
 *   메시지는 AS-IS 하드코딩 한글 리터럴 그대로다(MSG 코드 없음 = 다국어 아님 → t() 래핑하지 않는다).
 *   검증 순서(AS-IS): 빈값 → 숫자아님/음수 → 범위초과. AS-IS IsNumeric 은 '-' 를 숫자로 안 보므로
 *   음수는 '허용 범위'가 아니라 '숫자(양수)를 입력' 메시지다(CommonUtils.IsNumeric: '-'.All(IsNumber)=false).
 *   검증 축: PRODUCT_READY 0~100 / DAILY_CAPA(M_) 0~1000000 / LOAD_RATE(D_) 0~100 / RAMP_UP(D_) 0~1.
 *   NO_WORK(D_)은 Y/N→1/0 이라 범위 없음(셀편집서 이미 Y/N 강제).
 */
export const validateSavePayload = (payload: SavePayload): string | null => {
  // 1) PRODUCT_READY (0 ~ 100) — AS-IS L1998~2012
  for (const r of payload.productRate) {
    const tag = `[ ${str(r.lineId)} ]`;
    const raw = str(r.productRate).trim();
    if (raw === '') return `${tag} 생산준비율 값이 없습니다.`;
    const n = Number(raw);
    if (!Number.isFinite(n) || n < 0) return `${tag} 생산준비율 값에 숫자(양수)를 입력해 주세요.`;
    if (n > 100) return `${tag} 생산준비율 값 허용 범위 오류 (0 ~ 100).`;
  }
  // 2) DAILY_CAPA — M_ 월값 (0 ~ 1000000) — AS-IS L2072~2096
  for (const r of payload.capaMonth) {
    const tag = `[ ${str(r.lineId)} ${str(r.itemId)} ${str(r.yyyymm)} ]`;
    const raw = str(r.value).trim();
    if (raw === '') return `${tag}\n값이 없습니다.`;
    const n = Number(raw);
    if (!Number.isFinite(n) || n < 0) return `${tag}\n값에 숫자(양수)를 입력해 주세요.`;
    if (n > 1000000) return `${tag}\n값 허용 범위 오류 (0 ~ 1000000).`;
  }
  // 3) CAPA_WORK — D_ 일값. NO_WORK(1/0) 제외, LOAD_RATE 0~100 / RAMP_UP 0~1 — AS-IS L2143~2177
  for (const r of payload.capaWork) {
    const measure = str(r.measure);
    if (measure === MEASURE.NO_WORK) continue;
    const tag = `[ ${str(r.lineId)} ${str(r.yyyymmdd)} ]`;
    const label = measure === MEASURE.LOAD_RATE ? 'Load Rate' : 'Ramp UP';
    const max = measure === MEASURE.LOAD_RATE ? 100 : 1;
    const raw = str(r.value).trim();
    if (raw === '') return `${tag} ${label} 값이 없습니다.`;
    const n = Number(raw);
    if (!Number.isFinite(n) || n < 0) return `${tag}\n${label} 값에 숫자(양수)를 입력해 주세요.`;
    if (n > max) return `${tag} ${label} 값 허용 범위 오류 (0 ~ ${max}).`;
  }
  return null;
};
