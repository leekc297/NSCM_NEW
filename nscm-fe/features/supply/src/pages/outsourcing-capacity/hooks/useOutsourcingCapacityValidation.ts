import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { DAILY_CAPA_MIN, MSG, TOTAL_ITEM_LABEL } from '../outsourcing-capacity.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');
const toNum = (v: unknown): number | null => {
  if (typeof v === 'number') return Number.isFinite(v) ? v : null;
  if (typeof v === 'string' && v.trim() !== '') {
    const n = Number(v);
    return Number.isFinite(n) ? n : null;
  }
  return null;
};

// SCP0023 저장 전 검증 (design 03 §4.2):
//   (1) 변경행 daily_capa_qty 필수·정수 최소 1 (checkRequiredOfSpread + CheckDigitValueEntered)
//   (2) checkValidN — 조회된 Plant 별 item_id='Total' 행의 daily_capa_qty 공백이면 차단 (MSG00258)
export const useOutsourcingCapacityValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string, bound?: string | number): Result => {
      const text = t(msgId, `_${fallback}`);
      void setAlert({
        type: 'alert',
        content: bound === undefined ? text : text.replace('{0}', String(bound)),
      });
      return { ok: false };
    },
    [setAlert, t]
  );

  // dirty = 변경행(CRUD_TYPE), all = 현재 그리드 전체(Total 필수 검증용).
  const validateMainRows = useCallback(
    (dirty: Row[], all: Row[]): Result => {
      // (1) 변경행 daily_capa_qty 필수 + 최소 1 (design 03 §5-4)
      for (const r of dirty) {
        if (!s(r.CRUD_TYPE)) continue;
        const qty = toNum(r.daily_capa_qty);
        if (qty === null)
          return alert(MSG.DAILY_CAPA_MIN, 'Only values greater than or equal to {0} are allowed.', DAILY_CAPA_MIN);
        if (qty < DAILY_CAPA_MIN)
          return alert(MSG.DAILY_CAPA_MIN, 'Only values greater than or equal to {0} are allowed.', DAILY_CAPA_MIN);
      }

      // (2) checkValidN — 조회된 Plant 의 item_id='Total' 행 daily_capa_qty 공백이면 차단 (design 03 §4.2, MSG00258)
      for (const r of all) {
        if (s(r.item_id) !== TOTAL_ITEM_LABEL) continue;
        if (toNum(r.daily_capa_qty) === null)
          // {0} = Plant 코드 (AS-IS MSG00258 "Plant의 Total이 입력되지 않았습니다.({0})", TB_FX_MessageInfo).
          return alert(MSG.PLANT_TOTAL_REQUIRED, 'Plant\'s Total is not entered.({0})', s(r.scm_site_id));
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateMainRows };
};
