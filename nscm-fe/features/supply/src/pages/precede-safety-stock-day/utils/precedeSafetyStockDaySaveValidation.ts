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

  // #4/#11 MSG01230 — From > To 역전. 8자리 정규화 후 문자열 비교(YYYYMMDD 는 사전순=시간순).
  const from = toYmd8(row.FROM_YYYYMMDD);
  const to = toYmd8(row.TO_YYYYMMDD);
  if (from && to && from > to) {
    return { msgId: MSG.DATE_RANGE_INVALID, message: '_시작일자가 종료일자보다 늦을 수 없습니다.' };
  }

  // #5/#13 MSG00085 — TYPE_APPLY_DAY 음수.
  const typeApplyDay = Number(row.TYPE_APPLY_DAY);
  if (!Number.isNaN(typeApplyDay) && typeApplyDay < 0) {
    return { msgId: MSG.TYPE_APPLY_DAY_NEGATIVE, message: '_Day 는 0 이상이어야 합니다.' };
  }

  // #6 MSG00458 — 품목 미존재는 여기(행별 동기 검증)서 다루지 않는다. AS-IS 는 Division 유효 품목
  //   집합(dtItemAll)과 ITEM_ID 를 대조하는데, 그 집합은 비동기 조회가 필요하므로 저장 흐름에서
  //   findInvalidItemIdRow(utils/precedeSafetyStockDayItemValidation.ts)로 별도 검증한다.
  //   (공백 ITEM_ID 는 위 #1 필수검증이 선처리하므로 중복 가드하지 않는다.)

  return null;
};

/**
 * #2 MSG00428(AS-IS MSG00260 재번호) — 중복 저장 방지. AS-IS `SaveData`(.cs:656~682)는 각 변경행
 * (action!=Delete)의 조합을 조회결과 스냅샷 `dtPreSafeStockAll` 과 대조해 이미 존재하면 AS-IS
 * `GMessageBox("MSG00260")`("신규 입력 데이터 중 중복된 데이터가 있습니다.")로 막는다. TO-BE 는
 * 그리드에 로드된 전체 행(기존 미변경 + 신규/수정)을 받아 이 "조회결과 대조"를 재현한다 — 종전엔
 * 신규행끼리만 대조해 기존 행과 같은 조합의 신규행 1건을 놓쳐 SP `ORA-20010` 원문이 떴다(사용자
 * 신고 2026-11-03).
 *
 * 비교 키는 SAVE SP/DB 유니크인 PK 8칼럼(DIVISION_ID/OPMZ_PLAN_GR_ID/SCM_SITE_ID/STAGE/VALUE_TYPE/
 * ITEM_ID/FROM_YYYYMMDD/TO_YYYYMMDD — saveRequest.ts WHERE 실측). AS-IS 는 값칼럼까지 포함한 11칼럼
 * 전체일치였으나 DB 유니크는 이 8칼럼이라, 같은 PK·다른 값인 행은 AS-IS 가 놓치고 SP 가 거부한다 —
 * PK 로 좁혀 "SP 가 거부할 조합" 을 FE 가 먼저 MSG00428 로 막는다(TO-BE Oracle 에서 AS-IS 번호
 * MSG00260 은 무관한 "중복된 조합이 존재합니다…"로 재번호됨, 문구 역조회로 MSG00428 확정 2026-11-05).
 *   - 삭제행(CRUD_TYPE='D')은 제외: 저장 후 사라져 PK 를 점유하지 않는다.
 *   - 변경행(I/C/M)의 PK 가 살아남는 다른 행과 겹치면 중복(기존행 복제·신규행 충돌·키편집 충돌 포함).
 *     미변경 기존행끼리는 DB PK 가 이미 보장하므로 트리거 주체에서 빼고, count>1 로 자기자신만
 *     매칭되는 무변경 수정행의 오탐도 배제한다.
 */
export const findDuplicatePrecedeSafetyStockDayRows = (
  allRows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const pkOf = (row: WijmoRowItem): string =>
    [
      str(row.DIVISION_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.SCM_SITE_ID),
      str(row.STAGE),
      str(row.VALUE_TYPE),
      str(row.ITEM_ID),
      toYmd8(row.FROM_YYYYMMDD),
      toYmd8(row.TO_YYYYMMDD),
    ].join('\x1f');

  // 저장 후 살아남을 행(삭제 아님)만 PK 빈도를 센다.
  const survivors = allRows.filter(row => str(row.CRUD_TYPE) !== 'D');
  const keyCount = new Map<string, number>();
  for (const row of survivors) {
    const key = pkOf(row);
    keyCount.set(key, (keyCount.get(key) ?? 0) + 1);
  }
  // 변경행(I/C/M) 중 PK 가 둘 이상 존재하면 중복.
  for (const row of survivors) {
    if (!str(row.CRUD_TYPE)) continue;
    if ((keyCount.get(pkOf(row)) ?? 0) > 1) {
      return { msgId: MSG.DUPLICATE_EXISTS, message: '_신규 입력 데이터 중 중복된 데이터가 있습니다.' };
    }
  }
  return null;
};
