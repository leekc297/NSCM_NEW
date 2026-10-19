// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요).

import { MSG } from '../safety-stock.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 저장 전 커스텀 검증 — design/00_checklist.md §4d 하단 validations 표(MSG00001/00219/00085/00458)
 * 1:1 재현. 전 16칼럼 `INPUT_TP_CD='S'`(03_grid-columns.md §1 확인 필요 각주)로 메타 기반 필수검증
 * (useSaveWithValidation)이 사실상 무력화되므로 이 검증들이 유일한 방어선이다(convert-core §2.4).
 *
 * @returns 위반 시 { msgId, message }, 통과 시 null. 첫 위반에서 멈춘다(AS-IS 순차 가드 재현).
 */
export const validateSafetyStockRow = (
  row: WijmoRowItem
): { msgId: string; message: string } | null => {
  // MSG00001(line643) — 필수값 9개(value_type/division_id/opmz_plan_gr_id/scm_site_id/item_id/
  //   stage/from_yyyymmdd/to_yyyymmdd/apl_qty/valid_yn) 중 하나라도 공백.
  const requiredFields: [string, unknown][] = [
    ['VALUE_TYPE', row.VALUE_TYPE],
    ['DIVISION_ID', row.DIVISION_ID],
    ['OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID],
    ['SCM_SITE_ID', row.SCM_SITE_ID],
    ['ITEM_ID', row.ITEM_ID],
    ['STAGE', row.STAGE],
    ['FROM_YYYYMMDD', row.FROM_YYYYMMDD],
    ['TO_YYYYMMDD', row.TO_YYYYMMDD],
    ['APL_QTY', row.APL_QTY],
    ['VALID_YN', row.VALID_YN],
  ];
  if (requiredFields.some(([, value]) => str(value).trim() === '')) {
    return { msgId: MSG.REQUIRED_FIELDS, message: '_필수 입력값이 누락되었습니다.' };
  }

  // MSG00046(line704-711) — FROM/TO 날짜가 yyyyMMdd 형식으로 파싱되지 않음(AS-IS DateTime.ParseExact
  //   catch, MSG00219 대소비교와는 별개 가드). GAP-05 — 필수값 통과 후, 대소비교 전에 원문 순서대로 배선.
  const from = str(row.FROM_YYYYMMDD);
  const to = str(row.TO_YYYYMMDD);
  const isValidYyyymmdd = (v: string): boolean => {
    if (!/^\d{8}$/.test(v)) return false;
    const year = Number(v.slice(0, 4));
    const month = Number(v.slice(4, 6));
    const day = Number(v.slice(6, 8));
    const date = new Date(year, month - 1, day);
    return date.getFullYear() === year && date.getMonth() === month - 1 && date.getDate() === day;
  };
  if (!isValidYyyymmdd(from) || !isValidYyyymmdd(to)) {
    return { msgId: MSG.INVALID_DATE_FORMAT, message: '_유효한 날짜 형식이 아닙니다. No Work Date' };
  }

  // MSG00219(line719) — From > To 날짜 역전.
  if (from > to) {
    return { msgId: MSG.DATE_RANGE_INVALID, message: '_Valid From 이 Valid To 보다 클 수 없습니다.' };
  }

  // MSG00085(line728) — 적용수량(APL_QTY) 음수.
  const qty = Number(row.APL_QTY);
  if (!Number.isNaN(qty) && qty < 0) {
    return { msgId: MSG.QTY_NEGATIVE, message: '_수량은 0 이상이어야 합니다.' };
  }

  // MSG00458(line747) — 대상 Item 존재하지 않음(filterCalls#6 dtItemAll 연계). ITEM_ID 는 위
  //   필수검증을 통과했으므로 여기서는 형식만 재확인 — 실제 마스터 존재 검증은 SP 응답으로만
  //   최종 확정 가능(design 03 §6 확인 필요, PKG_SCP0128 미배포로 서버측 검증 대사 불가).
  if (str(row.ITEM_ID).trim() === '') {
    return { msgId: MSG.ITEM_NOT_FOUND, message: '_존재하지 않는 품목입니다.' };
  }

  return null;
};

/**
 * MSG00260(line690) — 중복 저장 방지(dtPreSafeStock.Rows.Count>0 && action!=Delete).
 *
 * AS-IS `filterCalls#5`(line686, `sb.ToString()` 동적 조합식)는 원식 미상(design/03_grid-columns.md
 * §3.2 확인 필요) — `SCP_OPMZ_SAFETY_STOCK` PK 8컬럼(DIVISION_ID/SCM_SITE_ID/OPMZ_PLAN_GR_ID/
 * STAGE/ITEM_ID/VALUE_TYPE/FROM_YYYYMMDD/TO_YYYYMMDD, DDL 실측 확정)이 저장 대상 신규행 사이에서
 * 같은 조합으로 2건 이상이면 화면 로컬에서만 중복을 재현한다(서버 SP 실측 전 best-evidence).
 * SP 배포 후 서버측 유니크 검증과 대사 필요(§6 확인 필요).
 */
export const findDuplicateSafetyStockRows = (
  rows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const insertRows = rows.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'C');
  const seen = new Set<string>();
  for (const row of insertRows) {
    const key = [
      str(row.DIVISION_ID),
      str(row.SCM_SITE_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.STAGE),
      str(row.ITEM_ID),
      str(row.VALUE_TYPE),
      str(row.FROM_YYYYMMDD),
      str(row.TO_YYYYMMDD),
    ].join('\x1f');
    if (seen.has(key)) return { msgId: MSG.DUPLICATE_EXISTS, message: '_이미 존재하는 데이터입니다.' };
    seen.add(key);
  }
  return null;
};
