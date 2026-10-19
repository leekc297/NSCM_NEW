// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

import { MSG, QTY_DECIMAL_MAX_DIGITS } from '../scheduled-receipt-information.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 저장 전 커스텀 검증 — design/03_grid-columns.md §3.1/§4 validations 24건 중 저장 게이트 재현.
 * `INPUT_TP_CD` 전 컬럼 'S'(design 03 §1 확인 필요 각주)로 admin 메타 기반 필수검증
 * (useSaveWithValidation)이 사실상 무력화되므로 이 검증들이 유일한 방어선이다(convert-core §2.4,
 * SafetyStock(SCP0128) 선례와 동일 필요성).
 *
 * @returns 위반 시 { msgId, message }, 통과 시 null. 첫 위반에서 멈춘다(AS-IS 순차 가드 재현).
 */
export const validateScheduledReceiptRow = (
  row: WijmoRowItem
): { msgId: string; message: string } | null => {
  // MSG00001(design 03 §3.1 #1/#11) — 7개 필수값 중 하나라도 공백.
  const requiredFields: [string, unknown][] = [
    ['DIVISION_ID', row.DIVISION_ID],
    ['OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID],
    ['PLANT_SITE_ID', row.PLANT_SITE_ID],
    ['ITEM_ID_CHILD', row.ITEM_ID_CHILD],
    ['TO_YYYYMMDD', row.TO_YYYYMMDD],
    ['TO_EXPC_QTY', row.TO_EXPC_QTY],
    ['VALID_YN', row.VALID_YN],
  ];
  if (requiredFields.some(([, value]) => str(value).trim() === '')) {
    return { msgId: MSG.REQUIRED_FIELDS, message: '_필수값을 입력하세요.' };
  }

  // design 03 §3.1 #6/#17(MSG00050) — 숫자 형식 아니면 오류.
  const qtyStr = str(row.TO_EXPC_QTY).trim();
  const qty = Number(qtyStr);
  if (Number.isNaN(qty)) {
    return { msgId: MSG.QTY_NOT_NUMBER, message: '_수량은 숫자여야 합니다.' };
  }

  // design 03 §3.1 #5/#16 — 소수 10자리 초과 금지(literal 메시지, AS-IS msgId 없음).
  const decimalPart = qtyStr.split('.')[1];
  if (decimalPart && decimalPart.length > QTY_DECIMAL_MAX_DIGITS) {
    return {
      msgId: MSG.QTY_DECIMAL_OVERFLOW,
      message: '_소수점 최대 10자리까지 입력 가능합니다.',
    };
  }

  // design 03 §3.1 #4/#7/#15/#18/#24(MSG00085) — 수량 0 미만 금지.
  if (qty < 0) {
    return { msgId: MSG.QTY_NEGATIVE, message: '_수량은 0 이상이어야 합니다.' };
  }

  return null;
};

/**
 * MSG00260(design 03 §3.1 #12) — 중복 저장 방지(dtSchRecInfoAll 동적필터, filterCalls#6 연동).
 * Division/PlanGroup/Site/ItemChild/ValidTo 조합이 저장 대상 신규행 사이에서 같은 조합으로
 * 2건 이상이면 화면 로컬에서만 중복을 재현한다(서버 SP 실측 전 best-evidence, SafetyStock 선례).
 */
export const findDuplicateScheduledReceiptRows = (
  rows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const insertRows = rows.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'C');
  const seen = new Set<string>();
  for (const row of insertRows) {
    const key = [
      str(row.DIVISION_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.PLANT_SITE_ID),
      str(row.ITEM_ID_CHILD),
      str(row.TO_YYYYMMDD),
    ].join('\x1f');
    if (seen.has(key)) return { msgId: MSG.DUPLICATE_EXISTS, message: '_이미 존재하는 데이터입니다.' };
    seen.add(key);
  }
  return null;
};
