// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요).

import { MSG } from '../precede-safety-stock-day.constants';

import { toYmd8 } from './precede-safety-stock-day.util';

const str = (v: unknown): string => {
  if (v == null) return '';
  if (typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean') return String(v);
  return '';
};

/**
 * 저장 전 커스텀 검증 — design/00_checklist.md §3b(13건) 1:1 재현. 전 17칼럼 `INPUT_TP_CD='S'`
 * (03_grid-columns.md §4.4)로 메타 기반 필수검증(useSaveWithValidation)이 사실상 무력화되므로
 * 이 13건이 유일한 필수값 방어선이다 — 누락 절대 금지(convert-core §2.4).
 *
 * #1~9 는 AS-IS SaveData 소속이 확정적(라인 앵커 근거). #10~13 은 AS-IS 소스 라인 인접 추정으로
 * enclosingMethod 확정이 이월된 상태(§3b 근거) — 이 화면(저장 시점)에도 동일 조건으로 적용해
 * 누락을 방지한다(§7 확인 필요, 최종 확정은 원본 `.cs` 재확인 후).
 *
 * @returns 위반 시 { msgId, message }, 통과 시 null. 첫 위반에서 멈춘다(AS-IS 순차 가드 재현).
 */
export const validatePrecedeSafetyStockDayRow = (
  row: WijmoRowItem
): { msgId: string; message: string; field?: string } | null => {
  // #1 MSG00001 — 필수값(value_type/division/plan_gr/site/item/stage/from~to/type_apply_day/valid_yn) 공백.
  const requiredFields: [string, unknown][] = [
    ['VALUE_TYPE', row.VALUE_TYPE],
    ['DIVISION_ID', row.DIVISION_ID],
    ['OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID],
    ['SCM_SITE_ID', row.SCM_SITE_ID],
    ['ITEM_ID', row.ITEM_ID],
    ['STAGE', row.STAGE],
    // FROM/TO 는 그리드에서 Date(FPDate)일 수 있어 toYmd8 로 8자리 정규화 후 공백 판정.
    ['FROM_YYYYMMDD', toYmd8(row.FROM_YYYYMMDD)],
    ['TO_YYYYMMDD', toYmd8(row.TO_YYYYMMDD)],
    ['TYPE_APPLY_DAY', row.TYPE_APPLY_DAY],
    ['VALID_YN', row.VALID_YN],
  ];
  // 필드별 메시지 — 비어있는 첫 필수 컬럼명을 field 로 돌려(호출부가 라벨 해소해 MSG00614 {0} 치환).
  const firstEmpty = requiredFields.find(([, value]) => str(value).trim() === '');
  if (firstEmpty) {
    return { msgId: 'MSG00614', message: '_{0} 값은 필수 입력입니다.', field: firstEmpty[0] };
  }

  // #3 MSG00046 — "No Work Date"(작업일수 미상 — TYPE_APPLY_DAY 공백 재확인, #1과 별도 가드).
  if (str(row.TYPE_APPLY_DAY).trim() === '') {
    return { msgId: MSG.NO_WORK_DATE, message: '_No Work Date' };
  }

  // #4/#11 MSG00219 — From > To 역전. 8자리 정규화 후 문자열 비교(YYYYMMDD 는 사전순=시간순).
  const from = toYmd8(row.FROM_YYYYMMDD);
  const to = toYmd8(row.TO_YYYYMMDD);
  if (from && to && from > to) {
    return { msgId: MSG.DATE_RANGE_INVALID, message: '_Valid From 이 Valid To 보다 클 수 없습니다.' };
  }

  // #5/#13 MSG00085 — TYPE_APPLY_DAY 음수.
  const typeApplyDay = Number(row.TYPE_APPLY_DAY);
  if (!Number.isNaN(typeApplyDay) && typeApplyDay < 0) {
    return { msgId: MSG.TYPE_APPLY_DAY_NEGATIVE, message: '_Day 는 0 이상이어야 합니다.' };
  }

  // #6 MSG00458 — 품목 미존재(dtItem.Rows.Count<=0). ITEM_ID 는 #1 필수검증을 통과했으므로
  //   여기서는 형식만 재확인 — 실제 존재 검증은 SP(ITEM_ID FK) 응답으로만 최종 확정 가능(확인 필요).
  if (str(row.ITEM_ID).trim() === '') {
    return { msgId: MSG.ITEM_NOT_FOUND, message: '_존재하지 않는 품목입니다.' };
  }

  return null;
};

/**
 * #2 MSG00260 — 중복 저장 방지(dtPreSafeStock.Rows.Count>0 && action!=FlagD).
 *
 * AS-IS `filterCalls#5`(line674, `sb.ToString()` 동적 조합식)는 원식 미상(design/00_checklist.md
 * §3b·§5 확인 필요) — 저장 대상 행 중 (DIVISION_ID, OPMZ_PLAN_GR_ID, SCM_SITE_ID, ITEM_ID, STAGE,
 * VALUE_TYPE) 조합이 같은 신규행 2건 이상이면 화면 로컬에서만 중복을 재현한다(서버 SP 실측 전
 * best-evidence). SP 배포 후 서버측 유니크 검증과 대사 필요(§7 확인 필요).
 */
export const findDuplicatePrecedeSafetyStockDayRows = (
  rows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const insertRows = rows.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'C');
  const seen = new Set<string>();
  for (const row of insertRows) {
    const key = [
      str(row.DIVISION_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.SCM_SITE_ID),
      str(row.ITEM_ID),
      str(row.STAGE),
      str(row.VALUE_TYPE),
    ].join('\x1f');
    if (seen.has(key)) return { msgId: MSG.DUPLICATE_EXISTS, message: '_이미 존재하는 데이터입니다.' };
    seen.add(key);
  }
  return null;
};
