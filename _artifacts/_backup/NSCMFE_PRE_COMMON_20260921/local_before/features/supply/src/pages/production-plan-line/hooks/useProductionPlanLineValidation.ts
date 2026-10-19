import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG, QTY_MAX, QTY_MIN } from '../production-plan-line.constants';
import type { SearchCondition } from '../production-plan-line.types';
import { toNum } from '../utils/productionPlanLineDerive';
import { pivotKind } from '../utils/productionPlanLineEditLock';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0013 조회/저장 전 검증 (design 03 §3 파생 white-list / design 00 §4-D 31건 중 셀검증).
export const useProductionPlanLineValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string): Result => {
      void setAlert({ type: 'alert', content: t(msgId, `_${fallback}`) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 조회 전 검증 — chkLineAssign 체크 시 Material(txtItemId) 필수 (design 01 H3 — MSG00290).
  const validateSearch = useCallback(
    (sc: SearchCondition): Result => {
      if (sc.chkLineAssign && sc.itemId.trim() === '')
        return alert(MSG.LINE_ASSIGN_ITEM, 'Material is required when Line Assign is checked.');
      return { ok: true };
    },
    [alert]
  );

  // 저장 전 검증 — 편집 pivot 셀 수량 범위(MSG00084 <0 / MSG00317 >99999999) + 신규행 붉은셀(MSG00026).
  const validateSave = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        // 신규행('I') 붉은셀(미입력 필수) 저장 차단 (design 03 §3 파생 — MSG00026).
        if (s(r.CRUD_TYPE) === 'I' && s(r.MEASURE).trim() === '')
          return alert(MSG.NEW_ROW_RED_CELL, 'New row has empty required cells.');
        for (const [key, val] of Object.entries(r)) {
          if (pivotKind(key) === null) continue; // pivot 셀만 수량 검증
          const n = toNum(val);
          if (n === null) continue;
          if (n < QTY_MIN) return alert(MSG.QTY_NEGATIVE, 'Quantity must be >= 0.');
          if (n > QTY_MAX) return alert(MSG.QTY_OVERFLOW, 'Quantity exceeds the maximum (99999999).');
        }
      }
      return { ok: true };
    },
    [alert]
  );

  return { validateSearch, validateSave };
};
