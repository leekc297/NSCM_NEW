import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import {
  EXCEPT_DATE_MIN,
  MSG,
  OPERATION_GROUP_ELECTRODE,
  YIELD_MAX,
  YIELD_MIN,
} from '../tact-time.constants';
import { toNum } from '../utils/tactTimeDerive';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// yyyyMMdd 형식/실재 날짜 검증.
const parseYmd = (v: string): Date | null => {
  if (!/^\d{8}$/.test(v)) return null;
  const y = Number(v.slice(0, 4));
  const m = Number(v.slice(4, 6));
  const d = Number(v.slice(6, 8));
  const dt = new Date(y, m - 1, d);
  if (dt.getFullYear() !== y || dt.getMonth() !== m - 1 || dt.getDate() !== d) return null;
  return dt;
};

// SCP0020 저장 전 검증 (design 03 §4.3 / design 00 §2b 영역3 39건 이식).
export const useTactTimeValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // arg 전달 시 메시지의 {0} 자리표시자를 치환. AS-IS 파라미터 메시지는 {0} 에 "<컬럼라벨> : <경계값>"
  //   문자열을 넣는다(예 MSG00193/01035 "{0} 초과의 값만…" → "Tact Time : 0 초과의 값만…", AS-IS cs:1458).
  const alert = useCallback(
    (msgId: string, fallback: string, arg?: string | number): Result => {
      const text = t(msgId, `_${fallback}`);
      void setAlert({ type: 'alert', content: arg === undefined ? text : text.replace('{0}', String(arg)) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 메인(Plant/Packer) 저장 검증 — 편집/신규 행(CRUD_TYPE) 대상.
  //   필수: PRIORITY>0, TACT_TIME>0 (MSG00193) / 전극(E) LANE_QTY 필수 (MSG00002) /
  //   범위: YIELD 1~100 (MSG00085 하한 / MSG00072 상한).
  const validateMainRows = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        const priority = toNum(r.PRIORITY);
        if (priority !== null && priority <= 0)
          return alert(MSG.REQUIRED_POSITIVE, 'You can only enter values above {0}', 'Priority : 0');
        const tact = toNum(r.TACT_TIME);
        if (tact !== null && tact <= 0)
          return alert(MSG.REQUIRED_POSITIVE, 'You can only enter values above {0}', 'Tact Time : 0');
        const yieldVal = toNum(r.YIELD);
        if (yieldVal !== null) {
          if (yieldVal < YIELD_MIN)
            return alert(MSG.RANGE_MIN, 'Only values greater than or equal to {0} are allowed.', `Yield : ${YIELD_MIN}`);
          if (yieldVal > YIELD_MAX)
            return alert(MSG.RANGE_MAX, 'You can only enter values equal to or below {0}', `Yield : ${YIELD_MAX}`);
        }
        // 전극(E) LANE_QTY 필수 (design 03 §1.1 #17 — MSG00002)
        if (s(r.OPERATION_GROUP_ID) === OPERATION_GROUP_ELECTRODE) {
          const lane = toNum(r.LANE_QTY);
          if (lane === null || lane <= 0) return alert(MSG.REQUIRED_FIELD, 'Lane Qty (Electrode).');
        }
      }
      return { ok: true };
    },
    [alert]
  );

  // 예외(Except) 저장 검증 — LINE_ID 필수 / 날짜 형식·범위·순서·중첩 / Tact Time>0 / Yield 1~100.
  const validateExceptRows = useCallback(
    (rows: Row[]): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));
      for (const r of dirty) {
        // LINE_ID 필수 (design 03 §1.3 #7 — MSG00002)
        if (s(r.LINE_ID).trim() === '') return alert(MSG.REQUIRED_FIELD, 'Line.');
        const startStr = s(r.TACT_TIME_START_DATE).trim();
        const endStr = s(r.TACT_TIME_END_DATE).trim();
        // 날짜 형식 (MSG00049)
        const start = parseYmd(startStr);
        const end = parseYmd(endStr);
        if (!start || !end) return alert(MSG.DATE_FORMAT, 'Date format (yyyyMMdd).');
        // 날짜 범위 >= 17530101 (MSG00048)
        if (startStr < EXCEPT_DATE_MIN || endStr < EXCEPT_DATE_MIN)
          return alert(MSG.DATE_RANGE, `Date must be >= ${EXCEPT_DATE_MIN}.`);
        // 시작 <= 종료 (checkValidN8 — MSG00108)
        if (startStr > endStr) return alert(MSG.START_END_ORDER, 'Start date must be <= end date.');
        // Tact Time > 0 (AS-IS 예외 저장 양수체크 cs:1921/2128, 체크리스트 #29·#35 — MSG00193 "Tact Time : 0").
        //   입력값이 음수/0 일 때만 차단(빈값은 필수검증 소관). 메인그리드 패턴과 동일.
        const tact = toNum(r.TACT_TIME);
        if (tact !== null && tact <= 0)
          return alert(MSG.REQUIRED_POSITIVE, 'You can only enter values above {0}', 'Tact Time : 0');
        const yieldVal = toNum(r.YIELD);
        if (yieldVal !== null) {
          if (yieldVal < YIELD_MIN)
            return alert(MSG.RANGE_MIN, 'Only values greater than or equal to {0} are allowed.', `Yield : ${YIELD_MIN}`);
          if (yieldVal > YIELD_MAX)
            return alert(MSG.RANGE_MAX, 'You can only enter values equal to or below {0}', `Yield : ${YIELD_MAX}`);
        }
      }
      // 중첩 기간 검증 (checkValidN5 — MSG00105) — 같은 복합키 행끼리 기간 겹침 금지.
      const keyOf = (r: Row): string =>
        [r.DIVISION_ID, r.PLANT_SITE_ID, r.ITEM_ID, r.OPERATION_ID, r.LINE_ID].map(s).join('|');
      const groups = new Map<string, { start: string; end: string }[]>();
      for (const r of rows) {
        const start = s(r.TACT_TIME_START_DATE).trim();
        const end = s(r.TACT_TIME_END_DATE).trim();
        if (!/^\d{8}$/.test(start) || !/^\d{8}$/.test(end)) continue;
        const k = keyOf(r);
        const list = groups.get(k) ?? [];
        list.push({ start, end });
        groups.set(k, list);
      }
      for (const list of groups.values()) {
        const sorted = [...list].sort((a, b) => a.start.localeCompare(b.start));
        for (let i = 1; i < sorted.length; i++) {
          if (sorted[i].start <= sorted[i - 1].end) return alert(MSG.PERIOD_OVERLAP, 'Overlapping period.');
        }
      }
      return { ok: true };
    },
    [alert]
  );

  return { validateMainRows, validateExceptRows };
};
