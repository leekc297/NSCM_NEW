import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG } from '../shipment-plan-fix.constants';
import type { SearchCondition } from '../shipment-plan-fix.types';

interface Result {
  ok: boolean;
}

// SCP0025 조회 전 검증 (design 02 §6 / 01 §2.6). read-only 화면이라 편집 저장 검증은 없다 —
//   Unfix 대상 유무(셀 선택)는 페이지 handleUnfix 가드가 담당(design 01 R4, MSG00134).
export const useShipmentPlanFixValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string): Result => {
      void setAlert({ type: 'alert', content: t(msgId, `_${fallback}`) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 조회 전 검증 — 기간(Period) from > to 금지 (design 02 §6). YYYYMMDD 문자열 사전순 비교(zero-pad 전제).
  const validateSearch = useCallback(
    (sc: SearchCondition): Result => {
      const from = sc.fromYyyymmdd.replace(/\D/g, '');
      const to = sc.toYyyymmdd.replace(/\D/g, '');
      if (from && to && from > to)
        return alert(MSG.PERIOD_RANGE, 'The end date must be on or after the start date.');
      return { ok: true };
    },
    [alert]
  );

  return { validateSearch };
};
