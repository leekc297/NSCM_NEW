import { useCallback } from 'react';

import dayjs from '@foundation/dayjs';
import { useMessageStore } from '@shared/stores';

import { MSG, REQUIRED_COLUMNS } from '../constraint-of-shipment-qty.constants';
import { toYmd8 } from '../utils/constraint-of-shipment-qty.editLock';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 커스텀 검증 — AS-IS SaveData(.cs:678~762) 행 단위 순서 그대로: 필수값 8개(MSG00013) → 날짜 형식
//   (MSG01081) → From<=To(MSG00219) → Min·Max 둘 중 하나 필수(MSG00022) → 수량 정수(MSG00460) → Min<=Max 세
//   쌍(MSG00099) → 품목 존재(MSG00458). 공용 saveWithValidation 은 칸 제목 * 도 필수로 보므로 AS-IS 공백 대상이
//   아닌 칸(NOT_REQUIRED_ON_SAVE_COLUMNS)을 뺀 목록을 넘긴다(갭분석 C-25).
const QTY_COLUMNS = [
  'SIPM_MIN_QYT',
  'SIPM_MAX_QTY',
  'SAT_SIPM_MIN_QTY',
  'SAT_SIPM_MAX_QTY',
  'SUN_SIPM_MIN_QTY',
  'SUN_SIPM_MAX_QTY',
] as const;

const QTY_PAIRS = [
  { minKey: 'SIPM_MIN_QYT', maxKey: 'SIPM_MAX_QTY', minTitle: 'MIN', maxTitle: 'MAX' },
  {
    minKey: 'SAT_SIPM_MIN_QTY',
    maxKey: 'SAT_SIPM_MAX_QTY',
    minTitle: 'MIN(SAT)',
    maxTitle: 'MAX(SAT)',
  },
  {
    minKey: 'SUN_SIPM_MIN_QTY',
    maxKey: 'SUN_SIPM_MAX_QTY',
    minTitle: 'MIN(SUN)',
    maxTitle: 'MAX(SUN)',
  },
] as const;

const toQty = (v: unknown): number => Number(s(v).replace(/,/g, '').trim());

const isValidYmd8 = (ymd: string): boolean =>
  ymd.length === 8 && dayjs(ymd, 'YYYYMMDD', true).isValid();

export const useConstraintOfShipmentQtyValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string, ...args: string[]): Result => {
      // {0}, {1}, ... 순서대로 치환(AS-IS GMessageBox(msgId, new object[]{...}) 파리티).
      //   등록 문구의 줄바꿈이 글자(\\r\\n)로 저장된 코드가 있어 안내창 표시 전 실제 줄바꿈으로 바꾼다.
      const content = args
        .reduce((acc, a, i) => acc.split(`{${i}}`).join(a), t(msgId, `_${fallback}`))
        .replace(/(\\r)?\\n/g, '\n');
      void setAlert({ type: 'alert', content });
      return { ok: false };
    },
    [setAlert, t]
  );

  const validateSaveRows = useCallback(
    (rows: Row[], itemsByDivision: ReadonlyMap<string, ReadonlySet<string>>): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));

      for (const r of dirty) {
        // 1) 필수값 8개(AS-IS .cs:678 원문 — STAGE/MDL_GR_NM 은 조건식에 없음).
        for (const key of REQUIRED_COLUMNS) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_FIELDS, 'Please enter the required fields.');
          }
        }

        // 2) 날짜 형식 · From<=To(.cs:709~731). 조회 값(YYYY-MM-DD)과 편집 값(YYYY.MM.DD)이 섞여 8자리로 견준다.
        const from = toYmd8(r.FROM_YYYYMMDD);
        const to = toYmd8(r.TO_YYYYMMDD);
        for (const [raw, ymd] of [
          [r.FROM_YYYYMMDD, from],
          [r.TO_YYYYMMDD, to],
        ] as const) {
          if (!isValidYmd8(ymd)) {
            return alert(MSG.DATE_INVALID, 'This is not a valid date format. {0}', s(raw));
          }
        }
        if (from > to) {
          return alert(MSG.PERIOD_INVALID, 'The start date can not be later than the end date.');
        }

        // 3) 일반 쌍 Min/Max 둘 중 하나 필수(.cs:735 MSG00022 {0}=MIN,{1}=MAX). SAT/SUN 쌍은 대상 아님.
        if (s(r.SIPM_MIN_QYT).trim() === '' && s(r.SIPM_MAX_QTY).trim() === '') {
          return alert(
            MSG.MIN_MAX_BOTH_EMPTY,
            'Either {0} or {1} is a required input.',
            'MIN',
            'MAX'
          );
        }

        // 4) 수량 정수(원장 NUMBER(18,0)). AS-IS checkMinMax 의 Convert.ToInt32 는 소수에서 예외로 저장이
        //   중단된다(.cs:541, 갭분석 G-17). TO-BE 는 값이 한 칸만 있어도 반올림 저장되지 않게 여섯 칸 모두 막는다.
        for (const key of QTY_COLUMNS) {
          if (s(r[key]).trim() !== '' && !Number.isInteger(toQty(r[key]))) {
            return alert(MSG.QTY_NOT_INTEGER, 'Only integer values can be entered!');
          }
        }

        // 5) Min>Max 금지(checkMinMax .cs:534~552, MSG00099) — 일반쌍 + SAT쌍 + SUN쌍. 빈값 쌍은 비교 생략.
        for (const { minKey, maxKey, minTitle, maxTitle } of QTY_PAIRS) {
          if (s(r[minKey]).trim() === '' || s(r[maxKey]).trim() === '') continue;
          if (toQty(r[minKey]) > toQty(r[maxKey])) {
            return alert(
              MSG.MIN_MAX_INVALID,
              '{0} can not be greater than {1}.',
              minTitle,
              maxTitle
            );
          }
        }

        // 6) 유효한 모델(.cs:757 MSG00458) — 그 사업부 품목 목록(init 6번째 결과)에 있어야 한다. AS-IS RowFilter 처럼
        //   대소문자는 구분하지 않고, 사업부도 변환하지 않는다(갭분석 C-23 — 붙여넣기 포함).
        const itemId = s(r.ITEM_ID).trim();
        if (!itemsByDivision.get(s(r.DIVISION_ID))?.has(itemId.toUpperCase())) {
          return alert(MSG.ITEM_NOT_EXIST, 'MODEL: {0} Invalid model!', itemId);
        }
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateSaveRows };
};
