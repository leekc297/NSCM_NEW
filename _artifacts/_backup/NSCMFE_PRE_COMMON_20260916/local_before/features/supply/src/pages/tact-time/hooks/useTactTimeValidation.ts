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

  const alert = useCallback(
    (msgId: string, fallback: string): Result => {
      void setAlert({ type: 'alert', content: t(msgId, `_${fallback}`) });
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
        if (priority !== null && priority <= 0) return alert(MSG.REQUIRED_POSITIVE, 'Priority must be > 0.');
        const tact = toNum(r.TACT_TIME);
        if (tact !== null && tact <= 0) return alert(MSG.REQUIRED_POSITIVE, 'Tact Time must be > 0.');
        const yieldVal = toNum(r.YIELD);
        if (yieldVal !== null) {
          if (yieldVal < YIELD_MIN) return alert(MSG.RANGE_MIN, `Yield must be >= ${YIELD_MIN}.`);
          if (yieldVal > YIELD_MAX) return alert(MSG.RANGE_MAX, `Yield must be <= ${YIELD_MAX}.`);
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

  // 예외(Except) 저장 검증 — LINE_ID 필수 / 날짜 형식·범위·순서·중첩.
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
        const yieldVal = toNum(r.YIELD);
        if (yieldVal !== null) {
          if (yieldVal < YIELD_MIN) return alert(MSG.RANGE_MIN, `Yield must be >= ${YIELD_MIN}.`);
          if (yieldVal > YIELD_MAX) return alert(MSG.RANGE_MAX, `Yield must be <= ${YIELD_MAX}.`);
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
