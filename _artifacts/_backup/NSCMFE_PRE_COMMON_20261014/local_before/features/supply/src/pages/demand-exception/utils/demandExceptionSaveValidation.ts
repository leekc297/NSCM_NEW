// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요).

import { MSG } from '../demand-exception.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 저장 전 커스텀 검증 — design/00_checklist.md §3a validations(MSG00001/00219/00458) 1:1 재현.
 * 전 16칼럼 `INPUT_TP_CD='S'`(design 03 §5 확인 필요 각주)로 메타 기반 필수검증
 * (useSaveWithValidation)이 사실상 무력화되므로 이 검증이 유일한 방어선이다(convert-core §2.4).
 *
 * @returns 위반 시 { msgId, message }, 통과 시 null. 첫 위반에서 멈춘다(AS-IS 순차 가드 재현).
 */
export const validateDemandExceptionRow = (
  row: WijmoRowItem
): { msgId: string; message: string } | null => {
  // AS-IS MSG00001(line628, 8필드 조회조건 공백 검증) 의 그리드 저장행 등가 — 필수 라벨 7종
  //   (design 03 §1: DIVISION_ID/OPMZ_PLAN_GR_ID/SCM_SITE_ID/ITEM_ID/STAGE/FROM_YYYYMMDD/
  //   TO_YYYYMMDD) 공백 차단. TO-BE 코드는 역조회 확정(MSG00013, constants 주석 참조).
  const requiredFields: [string, unknown][] = [
    ['DIVISION_ID', row.DIVISION_ID],
    ['OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID],
    ['SCM_SITE_ID', row.SCM_SITE_ID],
    ['ITEM_ID', row.ITEM_ID],
    ['STAGE', row.STAGE],
    ['FROM_YYYYMMDD', row.FROM_YYYYMMDD],
    ['TO_YYYYMMDD', row.TO_YYYYMMDD],
  ];
  if (requiredFields.some(([, value]) => str(value).trim() === '')) {
    return { msgId: MSG.REQUIRED_FIELDS, message: '_Please enter the required fields.' };
  }

  // MSG00219(line998, 그리드 셀 더블클릭 편집 검증) — From > To 날짜 역전.
  const from = str(row.FROM_YYYYMMDD);
  const to = str(row.TO_YYYYMMDD);
  if (from && to && from > to) {
    return { msgId: MSG.DATE_RANGE_INVALID, message: '_Invalid period (start > end).' };
  }

  // MSG00458(line710, filterCalls#6 dtItemAll 연계) — 대상 Item 존재하지 않음. 실제 마스터 존재
  //   검증은 SP 응답으로만 최종 확정 가능(design 03 §6 확인 필요, PKG_SCP0129 미배포로 서버측
  //   대사 불가) — 여기서는 형식(공백)만 재확인.
  if (str(row.ITEM_ID).trim() === '') {
    return { msgId: MSG.ITEM_NOT_FOUND, message: '_Invalid model!' };
  }

  return null;
};

/**
 * MSG00260(design 01 §2 규칙#1, line655) — 저장 전 안전재고(Pre-Safety-Stock) 존재 시 차단
 * (`dtPreSafeStock.Rows.Count>0 && action!=Delete`).
 *
 * AS-IS `filterCalls#5`(line651, `sb.ToString()` 동적 조합식)는 원식 미상(design 01 §5-2 확인
 * 필요) — SP 미배포(PKG_SCP0129)로 서버측 대사도 불가하다. 신규행(`CRUD_TYPE==='I'`)이 이미
 * 조회된 기존 그리드 행과 7컬럼(DIVISION_ID/OPMZ_PLAN_GR_ID/SCM_SITE_ID/ITEM_ID/STAGE/
 * FROM_YYYYMMDD/TO_YYYYMMDD) 완전일치하면 클라이언트 로컬 비교로 우선 차단한다(SP 배포 후 서버측
 * 재검증 필요 — safety-stock findDuplicateSafetyStockRows 와 달리 이 화면은 신규행끼리가 아니라
 * 신규행 vs 기존 조회행을 대조한다).
 *
 * @param newRows 저장 대상 신규행(CRUD_TYPE==='I').
 * @param existingRows 현재 조회된 그리드 전체 행(신규행 포함 가능 — 기존행만 비교 대상으로 거른다).
 * @returns 위반 시 { msgId, message }, 통과 시 null.
 */
export const findSafetyStockBlockedRows = (
  newRows: WijmoRowItem[],
  existingRows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const key = (row: WijmoRowItem): string =>
    [
      str(row.DIVISION_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.SCM_SITE_ID),
      str(row.ITEM_ID),
      str(row.STAGE),
      str(row.FROM_YYYYMMDD),
      str(row.TO_YYYYMMDD),
    ].join('\x1f');

  const existingKeys = new Set(
    existingRows.filter(row => row.CRUD_TYPE !== 'I').map(key)
  );

  const hasDuplicate = newRows
    .filter(row => row.CRUD_TYPE === 'I')
    .some(row => existingKeys.has(key(row)));

  if (hasDuplicate) {
    return { msgId: MSG.SAFETY_STOCK_EXISTS, message: '_Duplicate combination already exists.' };
  }
  return null;
};
