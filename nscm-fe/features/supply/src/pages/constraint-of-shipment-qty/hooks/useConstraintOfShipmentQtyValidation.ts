import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG, REQUIRED_COLUMNS } from '../constraint-of-shipment-qty.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 커스텀 검증(design 03 §3.1/§4) — INPUT_TP_CD 전 컬럼 'S'(메타 무효)라 admin 메타 필수
//   검증이 걸리지 않는다. 8개 필수값(#2 MSG00001) + 수량 게이트(#1 MSG00099, #5 MSG00022, 일반
//   쌍만 — SAT/SUN 쌍 적용 여부는 확인 필요, design 03 §6#6) + 날짜 게이트(#4 MSG00219)를 전건
//   재현한다. Item 존재 확인(#6 MSG00458)·Sales Site Priority(#3 MSG00046)는 서버(SAVE SP) 판정
//   영역이며 PKG_SCP0132 미배포로 이 회차에서는 검증하지 않는다(확인 필요, __asis-mapping__.md 명시).
export const useConstraintOfShipmentQtyValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string, arg?: string): Result => {
      const text = t(msgId, `_${fallback}`);
      void setAlert({
        type: 'alert',
        content: arg === undefined ? text : text.replace('{0}', arg),
      });
      return { ok: false };
    },
    [setAlert, t]
  );

  const validateSaveRows = useCallback(
    (rows: Row[]): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));
      if (dirty.length === 0) return { ok: true };

      // 1) 필수값 8개(design 03 §3.1 #2 MSG00001 원문 그대로 — STAGE/MDL_GR_NM 은 조건식에 없어 제외).
      for (const r of dirty) {
        for (const key of REQUIRED_COLUMNS) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_FIELDS, 'Please enter the required fields.');
          }
        }
      }

      // 2) 일반 쌍 Min>Max 금지(design 03 §3.1 #1 MSG00099).
      for (const r of dirty) {
        const min = Number(r.SIPM_MIN_QYT);
        const max = Number(r.SIPM_MAX_QTY);
        if (Number.isFinite(min) && Number.isFinite(max) && min > max) {
          return alert(MSG.MIN_MAX_INVALID, 'Min qty can not be greater than Max qty.');
        }
      }

      // 3) 일반 쌍 Min/Max 동시 공백 금지(design 03 §3.1 #5 MSG00022).
      for (const r of dirty) {
        if (s(r.SIPM_MIN_QYT).trim() === '' && s(r.SIPM_MAX_QTY).trim() === '') {
          return alert(MSG.MIN_MAX_BOTH_EMPTY, 'Please enter Min qty or Max qty.');
        }
      }

      // 4) From <= To(design 03 §3.1 #4 MSG00219).
      for (const r of dirty) {
        const from = s(r.FROM_YYYYMMDD);
        const to = s(r.TO_YYYYMMDD);
        if (from && to && from > to) {
          return alert(MSG.PERIOD_INVALID, 'The start date can not be later than the end date.');
        }
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateSaveRows };
};
