// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요).

import { MSG } from '../safety-stock.constants';

import { toYmd8 } from './safety-stock.util';

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
): { msgId: string; message: string; field?: string } | null => {
  // MSG00001(line643) — 필수값 9개(value_type/division_id/opmz_plan_gr_id/scm_site_id/item_id/
  //   stage/from_yyyymmdd/to_yyyymmdd/apl_qty/valid_yn) 중 하나라도 공백.
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
    ['APL_QTY', row.APL_QTY],
    ['VALID_YN', row.VALID_YN],
  ];
  // 필드별 메시지 — 비어있는 첫 필수 컬럼명을 field 로 돌려(호출부가 라벨 해소해 MSG00614 {0} 치환).
  const firstEmpty = requiredFields.find(([, value]) => str(value).trim() === '');
  if (firstEmpty) {
    return { msgId: 'MSG00614', message: '_{0} 값은 필수 입력입니다.', field: firstEmpty[0] };
  }

  // MSG00046(line704-711) — FROM/TO 날짜가 yyyyMMdd 형식으로 파싱되지 않음(AS-IS DateTime.ParseExact
  //   catch, MSG00219 대소비교와는 별개 가드). GAP-05 — 필수값 통과 후, 대소비교 전에 원문 순서대로 배선.
  const from = toYmd8(row.FROM_YYYYMMDD);
  const to = toYmd8(row.TO_YYYYMMDD);
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

  // 적용수량(APL_QTY) 수치 가드 — AS-IS SaveData(.cs:725)는 `Convert.ToInt32(v_apl_qty)`로 변환하므로
  //   Int32 상한(2,147,483,647) 초과는 OverflowException 으로 저장 중단(MSG00460 "정수값만 입력가능합니다!"),
  //   음수는 변환 후 `< 0` 비교로 차단(MSG00085). 변환 예외가 비교보다 먼저 터지므로 상한을 먼저 검사한다.
  //   number 셀 입력 자릿수 cap(SafetyStockGrid)이 정밀도 손실(17자리→9,007,199,254,740,991 변조)을 1차로
  //   막고, 붙여넣기 등 우회 입력은 이 저장검증이 이중 안전망이다(csharp-int-to-js 메모리, 자매 SCP0131 동형).
  const qty = Number(row.APL_QTY);
  if (!Number.isNaN(qty) && qty > 2147483647) {
    return { msgId: MSG.QTY_OVER_MAX, message: '_정수값만 입력가능합니다!' };
  }
  // MSG00085(line728) — 적용수량(APL_QTY) 음수.
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
 * MSG00428(AS-IS MSG00260 재번호, line690) — 중복 저장 방지. AS-IS `SaveData`(.cs:651~693)는 각
 * 변경행(action!=Delete)의 조합을 조회결과 스냅샷 `dtPreSafeStockAll`(DBUtils.Filter, line686)과
 * 대조해 이미 존재하면 AS-IS `GMessageBox("MSG00260")`("신규 입력 데이터 중 중복된 데이터가
 * 있습니다.")로 막는다. TO-BE Oracle 에서 MSG00260 은 무관한 "중복된 조합이 존재합니다…"로 재번호돼
 * 문구 역조회로 MSG00428 확정(DB 실측 2026-11-05, 자매 SCP0127 동일). TO-BE 는 그리드에 로드된
 * 전체 행(기존 미변경 + 신규/수정)을 받아 이
 * "조회결과 대조"를 재현한다 — 종전엔 신규행끼리만 대조해 기존 행과 같은 조합의 신규행 1건을 놓쳐
 * SP 가 거부했다(자매 SCP0127 와 동일 결함·수정, 사용자 신고 2026-11-05).
 *
 * 비교 키는 SAVE SP/DB 유니크인 `SCP_OPMZ_SAFETY_STOCK` PK 8칼럼(DIVISION_ID/SCM_SITE_ID/
 * OPMZ_PLAN_GR_ID/STAGE/ITEM_ID/VALUE_TYPE/FROM_YYYYMMDD/TO_YYYYMMDD, DDL 실측 확정). AS-IS 는
 * Insert 는 8칼럼·Modify 는 값칼럼 포함 11칼럼 전체일치였으나 DB 유니크는 이 8칼럼이라, 같은 PK·
 * 다른 값인 행은 AS-IS 가 놓치고 SP 가 거부한다 — PK 로 좁혀 "SP 가 거부할 조합" 을 FE 가 먼저
 * MSG00428 로 막는다(자매 SCP0127 findDuplicatePrecedeSafetyStockDayRows 동형).
 *   - 삭제행(CRUD_TYPE='D')은 제외: 저장 후 사라져 PK 를 점유하지 않는다.
 *   - 변경행(I/C/M)의 PK 가 살아남는 다른 행과 겹치면 중복(기존행 복제·신규행 충돌·키편집 충돌 포함).
 *     count>1 로 자기자신만 매칭되는 무변경 수정행의 오탐은 배제한다.
 */
export const findDuplicateSafetyStockRows = (
  allRows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const pkOf = (row: WijmoRowItem): string =>
    [
      str(row.DIVISION_ID),
      str(row.SCM_SITE_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.STAGE),
      str(row.ITEM_ID),
      str(row.VALUE_TYPE),
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
