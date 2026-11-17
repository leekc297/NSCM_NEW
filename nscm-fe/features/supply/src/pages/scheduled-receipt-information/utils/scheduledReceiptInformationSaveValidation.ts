// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

import { MSG, QTY_DECIMAL_MAX_DIGITS } from '../scheduled-receipt-information.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 payload 빌더 — BE execBtn/makeProcedure(BaseService.java) 는 proc 파라미터를 요청 본문의
//   최상위 flat 키(COL_NM, camelCase)로 읽고(params.get(COL_NM)), 각 값은 변경행들을 '^'로 이어붙인
//   컬럼배열이다(proc 가 SCM_ARR_SPL_VAL 로 '^' 분리). useProcMutation 의 {data:[행]} 중첩 형태로는
//   모든 IN 파라미터가 null 이 되어 proc 가 I/M/D 분기를 전부 건너뛰고 무DML COMMIT → 저장 성공
//   응답(RESULT_CNT=입력행수)만 돌아오고 실제 반영이 안 된다. MailSetup 등 동일 proc 스타일 화면과
//   같은 flat payload 로 보낸다. 파라미터 이름·순서는 SCM_ADM_PROC_M 실측.
const BULK_DELIMITER = '^';

// 날짜는 저장 형식(YYYYMMDD, 하이픈 없음)으로 — proc 는 입력값을 그대로 TO_YYYYMMDD 에 넣고
//   조회/필터(TO_YYYYMMDD >= p_from_date, TO_DATE(...,'YYYYMMDD'))는 YYYYMMDD 를 기대한다.
//   화면 셀은 조회가 돌려준 'YYYY-MM-DD' 를 들고 있어 저장 전 하이픈을 떼야 한다
//   (AS-IS .cs:825-831 Replace("-","") 재현, 멱등).
const ymd8 = (value: WijmoPrimitive | undefined): string => {
  const s = value == null ? '' : String(value);
  return s.includes('-') ? s.replace(/-/g, '') : s;
};

const joinCol = (
  rows: WijmoRowItem[],
  pick: (row: WijmoRowItem) => WijmoPrimitive | undefined
): string =>
  rows
    .map(row => {
      const v = pick(row);
      return v == null ? '' : String(v);
    })
    .join(BULK_DELIMITER);

// pre-image(원본 키값) — 수정(M)/삭제(D)의 proc UPDATE/DELETE 매칭용. 신규(I/C)는 빈값.
//   키 셀이 편집됐으면 editTracker 원본값, 아니면 현재값(변경 없음).
type OriginalValuesMap = Map<WijmoRowItem, Record<string, WijmoPrimitive>> | undefined;
const preVal = (originals: OriginalValuesMap, row: WijmoRowItem, field: string): WijmoPrimitive => {
  if (row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'C') return '';
  const changed = originals?.get(row);
  return changed && field in changed ? changed[field] : row[field];
};

// userId(P_USER_ID) — proc 가 감사컬럼 CREATED_BY/LAST_UPDATED_BY(NOT NULL)에 넣는다. /call-proc 은
//   세션을 주입하지 않으므로 FE 가 로그인 userId 를 싣는다(빈값이면 Oracle 이 ''→NULL 로 보고
//   ORA-01400 CREATED_BY). 전 행 동일 세션값을 '^'로 반복해 넣는다.

// Virtual Bom 저장 payload(PKG_SCP0130.P_SCP0130_SVAE_VIRTUAL_BOM — itemId 있음).
export const buildVirtualBomSavePayload = (
  rows: WijmoRowItem[],
  originals: OriginalValuesMap,
  userId: string
): Record<string, string> => ({
  activeFlag: joinCol(rows, r => r.CRUD_TYPE),
  divisionId: joinCol(rows, r => r.DIVISION_ID),
  opmzPlanGrId: joinCol(rows, r => r.OPMZ_PLAN_GR_ID),
  plantSiteId: joinCol(rows, r => r.PLANT_SITE_ID),
  itemId: joinCol(rows, r => r.ITEM_ID),
  itemIdChild: joinCol(rows, r => r.ITEM_ID_CHILD),
  toYyyymmdd: joinCol(rows, r => ymd8(r.TO_YYYYMMDD)),
  toExpcQty: joinCol(rows, r => r.TO_EXPC_QTY),
  valueDescription: joinCol(rows, r => r.VALUE_DESCRIPTION),
  validYn: joinCol(rows, r => r.VALID_YN),
  // userId 는 단일 스칼라 — proc 이 선언부에서 SUBSTR(P_USER_ID) 1회만 읽고 행별 split 안 한다
  //   (V_LAST_UPDATED_BY, 루프 밖). '^'-fold 하면 'SYSTEM^SYSTEM' 이 그대로 CREATED_BY 에 들어간다.
  userId,
  preDivisionId: joinCol(rows, r => preVal(originals, r, 'DIVISION_ID')),
  preOpmzPlanGrId: joinCol(rows, r => preVal(originals, r, 'OPMZ_PLAN_GR_ID')),
  prePlantSiteId: joinCol(rows, r => preVal(originals, r, 'PLANT_SITE_ID')),
  preItemId: joinCol(rows, r => preVal(originals, r, 'ITEM_ID')),
  preItemIdChild: joinCol(rows, r => preVal(originals, r, 'ITEM_ID_CHILD')),
});

// Scheduled Receipt 저장 payload(PKG_SCP0130.P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION —
//   itemId 없음, preToYyyymmdd 있음: TO_YYYYMMDD 가 이 시트의 키 일부라 UPDATE 매칭에 쓴다).
export const buildScheduledReceiptSavePayload = (
  rows: WijmoRowItem[],
  originals: OriginalValuesMap,
  userId: string
): Record<string, string> => ({
  activeFlag: joinCol(rows, r => r.CRUD_TYPE),
  divisionId: joinCol(rows, r => r.DIVISION_ID),
  opmzPlanGrId: joinCol(rows, r => r.OPMZ_PLAN_GR_ID),
  plantSiteId: joinCol(rows, r => r.PLANT_SITE_ID),
  itemIdChild: joinCol(rows, r => r.ITEM_ID_CHILD),
  toYyyymmdd: joinCol(rows, r => ymd8(r.TO_YYYYMMDD)),
  toExpcQty: joinCol(rows, r => r.TO_EXPC_QTY),
  valueDescription: joinCol(rows, r => r.VALUE_DESCRIPTION),
  validYn: joinCol(rows, r => r.VALID_YN),
  // userId 는 단일 스칼라 — proc 이 선언부에서 SUBSTR(P_USER_ID) 1회만 읽고 행별 split 안 한다
  //   (V_LAST_UPDATED_BY, 루프 밖). '^'-fold 하면 'SYSTEM^SYSTEM' 이 그대로 CREATED_BY 에 들어간다.
  userId,
  preDivisionId: joinCol(rows, r => preVal(originals, r, 'DIVISION_ID')),
  preOpmzPlanGrId: joinCol(rows, r => preVal(originals, r, 'OPMZ_PLAN_GR_ID')),
  prePlantSiteId: joinCol(rows, r => preVal(originals, r, 'PLANT_SITE_ID')),
  preItemIdChild: joinCol(rows, r => preVal(originals, r, 'ITEM_ID_CHILD')),
  preToYyyymmdd: joinCol(rows, r => ymd8(preVal(originals, r, 'TO_YYYYMMDD'))),
});

// AS-IS ParseExact(v_to_yyyymmdd.Replace("-","").Substring(0,8), "yyyyMMdd") 재현 — 8자리 실재 날짜.
const isValidYmd = (ymd: string): boolean => {
  if (!/^\d{8}$/.test(ymd)) return false;
  const y = Number(ymd.slice(0, 4));
  const m = Number(ymd.slice(4, 6));
  const d = Number(ymd.slice(6, 8));
  const dt = new Date(y, m - 1, d);
  return dt.getFullYear() === y && dt.getMonth() === m - 1 && dt.getDate() === d;
};

// 저장 전 커스텀 검증(design 03 §3.1/§4). 필수값은 메타 INPUT_TP_CD=M 의 useSaveWithValidation 과
//   이 커스텀이 함께 걸고, 수량 3중검증(숫자형식/소수10자리/0미만)은 메타로 표현 못 해 이 함수가
//   유일한 방어선이다(convert-core 2.4). 필수값 집합은 시트별로 다르다(SCP0130-13, iter-5):
//   - Virtual Bom(.cs:786-790): ITEM_ID 필수, TO_YYYYMMDD 비필수(.cs:789 주석처리).
//   - Scheduled Receipt(.cs:1072-1080): TO_YYYYMMDD 필수, ITEM_ID 컬럼 없음.
//   공통: DIVISION_ID/OPMZ_PLAN_GR_ID/PLANT_SITE_ID/ITEM_ID_CHILD/TO_EXPC_QTY/VALID_YN.
// isVirtualBom: 활성 시트 판정(onSave 가 activeTab 으로 전달). 첫 위반에서 멈춘다(AS-IS 순차 가드).
export const validateScheduledReceiptRow = (
  row: WijmoRowItem,
  isVirtualBom: boolean
): { msgId: string; message: string; arg?: string } | null => {
  const sheetRequired: [string, unknown] = isVirtualBom
    ? ['ITEM_ID', row.ITEM_ID]
    : ['TO_YYYYMMDD', row.TO_YYYYMMDD];
  const requiredFields: [string, unknown][] = [
    ['DIVISION_ID', row.DIVISION_ID],
    ['OPMZ_PLAN_GR_ID', row.OPMZ_PLAN_GR_ID],
    ['PLANT_SITE_ID', row.PLANT_SITE_ID],
    ['ITEM_ID_CHILD', row.ITEM_ID_CHILD],
    ['TO_EXPC_QTY', row.TO_EXPC_QTY],
    ['VALID_YN', row.VALID_YN],
    sheetRequired,
  ];
  if (requiredFields.some(([, value]) => str(value).trim() === '')) {
    return { msgId: MSG.REQUIRED_FIELDS, message: '_모든 항목은 필수 입력입니다.' };
  }

  // design 03 §3.1 #6/#17(MSG00050) — 숫자 형식 아니면 오류.
  const qtyStr = str(row.TO_EXPC_QTY).trim();
  const qty = Number(qtyStr);
  if (Number.isNaN(qty)) {
    // MSG00050 "유효한 숫자 형식이 아닙니다. {0}" — {0}=위반 값(AS-IS .cs:907 args 재현).
    return { msgId: MSG.QTY_NOT_NUMBER, message: '_수량은 숫자여야 합니다.', arg: qtyStr };
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
  //   MSG00085 "{0} 이상의 값만 입력 가능합니다." — {0}="0"(AS-IS .cs:890/913
  //   GMessageBox("MSG00085", new object[]{ "0" }) 재현). arg 미전달 시 표시부가 {0}을 빈값으로
  //   치환해 "0"이 누락되므로 반드시 '0' 을 넘긴다.
  if (qty < 0) {
    return { msgId: MSG.QTY_NEGATIVE, message: '_수량은 0 이상이어야 합니다.', arg: '0' };
  }

  // 날짜형식 유효성(AS-IS .cs:825-837/863-876) — 값이 있을 때만 YYYYMMDD 실재 날짜인지 확인한다.
  //   (Scheduled Receipt 는 위 필수체크로 항상 값이 있고, Virtual Bom 은 비필수라 값이 있을 때만.)
  //   TO_YYYYMMDD 는 FPDate picker 지만 붙여넣기 등 비정상 입력에 대비한 저장 전 가드(AS-IS 재현).
  const toYmd = str(row.TO_YYYYMMDD).replace(/-/g, '').trim();
  if (toYmd && !isValidYmd(toYmd.slice(0, 8))) {
    return { msgId: MSG.INVALID_DATE, message: '_유효한 날짜 형식이 아닙니다.', arg: 'Valid To' };
  }

  return null;
};

/**
 * MSG00260(design 03 §3.1 #12) — 중복 저장 방지. AS-IS(.cs:1083-1100)는 **신규행(action=I)을 기존
 * 로드 데이터(dtSchRecInfoAll)와 대조**해 Division/PlanGroup/Site/ItemChild/ValidTo 조합이 같으면
 * 차단한다(Scheduled Receipt 전용 — Virtual Bom 은 .cs:796 주석처리). 전체 행(sourceCollection)을
 * 받아 기존행 키를 먼저 적재한 뒤, 신규행이 기존행 또는 앞선 신규행과 겹치면 차단한다.
 * (서버 SP 가 최종 권위이며 이 검사는 저장 전 보조 가드.)
 */
export const findDuplicateScheduledReceiptRows = (
  allRows: WijmoRowItem[]
): { msgId: string; message: string } | null => {
  const keyOf = (row: WijmoRowItem): string =>
    [
      str(row.DIVISION_ID),
      str(row.OPMZ_PLAN_GR_ID),
      str(row.PLANT_SITE_ID),
      str(row.ITEM_ID_CHILD),
      str(row.TO_YYYYMMDD),
    ].join('\x1f');

  // 기존행(CRUD_TYPE 없음) 키를 먼저 적재 — 신규행 대조 기준. 삭제행('D')은 제외.
  const seen = new Set<string>();
  for (const row of allRows) {
    const crud = str(row.CRUD_TYPE);
    if (crud === 'I' || crud === 'C' || crud === 'D') continue;
    seen.add(keyOf(row));
  }
  // 신규행이 기존행/앞선 신규행과 같은 조합이면 중복.
  for (const row of allRows) {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'C') continue;
    const key = keyOf(row);
    if (seen.has(key))
      return { msgId: MSG.DUPLICATE_EXISTS, message: '_신규 입력 데이터 중 중복된 데이터가 있습니다.' };
    seen.add(key);
  }
  return null;
};
