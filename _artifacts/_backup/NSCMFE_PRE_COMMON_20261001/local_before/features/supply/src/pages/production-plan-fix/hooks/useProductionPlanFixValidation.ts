import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { LABEL, MSG, QTY_MAX, QTY_MIN } from '../production-plan-fix.constants';
import type { SearchCondition } from '../production-plan-fix.types';
import { toNum } from '../utils/productionPlanFixDerive';
import { pivotKind } from '../utils/productionPlanFixEditLock';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0024 조회/저장 전 검증 (design 01 §2.6 validations / 03 §3 파생 white-list).
export const useProductionPlanFixValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string): Result => {
      void setAlert({ type: 'alert', content: t(msgId, `_${fallback}`) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // {0} 필수 메시지 — TO-BE MSG00429("{0} value is required.")는 i18next 가 {0}(.NET 형식)를 치환하지
  //   않으므로 라벨을 직접 넣는다(자매 SCP0013 requiredMsg 규약과 동일).
  const requiredAlert = useCallback(
    (labelKey: string, labelDefault: string): Result => {
      const label = t(labelKey, { defaultValue: labelDefault });
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} value is required.').replace('{0}', label),
      });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 조회 전 검증 — 필수 조회조건 + 기간(Period) from > to 금지.
  //   필수: AS-IS 프레임워크 checkRequiredOfSearch(cs:850 → DataUtil.cs InitCheck 427-553)가 라벨 '*'
  //   컨트롤(Designer.cs 실측: Division*=723 / Operation Group*=734 / Period*=898)의 빈값/'ALL' 을
  //   MSG00002 로 차단 — TO-BE 는 MSG00429 로 재현(자매 SCP0013 checkRequiredAndPeriod 정합).
  //   기간 순서: AS-IS Check_PeriodDate_New(SCPPlan.cs:204-233 — 빈값 MSG00049 / from>to MSG00108).
  //   빈값 축은 Period 필수 게이트가 흡수한다.
  const validateSearch = useCallback(
    (sc: SearchCondition): Result => {
      if (!sc.divisionId) return requiredAlert('LBL00641', LABEL.DIVISION);
      if (!sc.operationGroupId) return requiredAlert('LBL00027', LABEL.OPERATION_GROUP);
      const from = sc.fromYyyymmdd.replace(/\D/g, '');
      const to = sc.toYyyymmdd.replace(/\D/g, '');
      if (!from || !to) return requiredAlert('LBL00013', LABEL.PERIOD);
      if (from > to)
        return alert(MSG.PERIOD_RANGE, 'The end date must be on or after the start date.');
      return { ok: true };
    },
    [alert, requiredAlert]
  );

  // 저장 전 검증 — 편집 D_ pivot 셀 수량 범위(design 03 §3 — QTY 0~99999999).
  const validateSave = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        for (const [key, val] of Object.entries(r)) {
          if (pivotKind(key) !== 'D') continue; // D_ 편집 셀만 수량 검증(W_/M_ 롤업·고정 컬럼 제외)
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
