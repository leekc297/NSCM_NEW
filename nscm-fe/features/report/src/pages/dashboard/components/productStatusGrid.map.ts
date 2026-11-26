import { ACTION_PRESENTATION, resolveActionCode } from '../demand-as-dashboard.rules';
import type { ActionCode, ActionTone, StatusDot } from '../demand-as-dashboard.rules';

// 제품별 현황 — P_DMD0001_GET_PRODUCT_STATUS 의 o_rc1 을 그리드 뷰모델로.
//   컬럼: NICK_NAME·END_CUSTOMER·BIZ_TYPE·STOCK·COVER·SHORTAGE_MONTH·ACTION_CODE.
//   ACTION_CODE(비즈니스 분류)는 SP 소유. FE 는 코드 기준 톤/신호등(표시)만 매핑하고,
//   라벨 텍스트는 컴포넌트가 i18n(t)으로 해석한다(FE 하드코딩 금지 — 사용자 결정 2026-11-23).
//   표시 포맷(천단위·소수 1자리·'–')은 FE.

export type ProductStatusApiRow = Record<string, string | number | null | undefined>;

// 매퍼 산출 — 라벨(action 텍스트)은 빠져 있다. 컴포넌트가 actionCode 로 t() 해석해 채운다.
export interface ProductStatusMapped {
  product: string;
  oem: string;
  bizType: string;
  stock: string;
  cover: string;
  shortageMonth: string;
  actionCode: ActionCode | null;
  actionTone: ActionTone;
  status: StatusDot;
}

const num = (v: string | number | null | undefined): number | null => {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isNaN(n) ? null : n;
};
const str = (v: string | number | null | undefined): string => (v == null ? '' : String(v));

const fmtEa = (v: string | number | null | undefined): string => {
  const n = num(v);
  return n == null ? '–' : n.toLocaleString('en-US');
};
const fmtCover = (v: string | number | null | undefined): string => {
  const n = num(v);
  return n == null ? '–' : n.toFixed(1);
};

const NO_ACTION_PRESENTATION = { actionTone: 'keep' as ActionTone, status: 'green' as StatusDot };

export const mapProductStatus = (rows: ProductStatusApiRow[]): ProductStatusMapped[] =>
  rows.map(r => {
    const code = resolveActionCode(str(r.ACTION_CODE), num(r.COVER));
    const presentation = code ? ACTION_PRESENTATION[code] : NO_ACTION_PRESENTATION;
    const shortage = str(r.SHORTAGE_MONTH);
    return {
      product: str(r.NICK_NAME),
      oem: str(r.END_CUSTOMER),
      bizType: str(r.BIZ_TYPE),
      stock: fmtEa(r.STOCK),
      cover: fmtCover(r.COVER),
      shortageMonth: shortage === '' ? '–' : shortage,
      actionCode: code,
      ...presentation,
    };
  });
