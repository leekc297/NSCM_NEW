import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG } from '../shipment-lot-size.constants';
import { toIntOrNull } from '../utils/shipmentLotSize.derive';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
  // 위반 셀 — 호출부 formatItem 하이라이트 대상 (design 03 R17. sister SCP0005 동형).
  invalidCells: { row: Row; column: string }[];
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0028 저장 전 클라 검증 (design 03 §4.3 checkValidSize — cs:762~773).
//   대상 = 편집/신규 행(CRUD_TYPE, 삭제행 제외). 순서 AS-IS 동일:
//     ① LOT_SIZE < INCREMENT → MSG.INC_GT_LOT (구 MSG00099, TO-BE 미등재 → 영문 fallback)
//     ② LOT_SIZE==0 또는 INCREMENT==0 → MSG.ZERO_VALUE (MSG00699 'Please enter an integer greater than 0.')
//   메타 필수검증(INPUT_TP_CD='M')은 useSaveWithValidation 이 별도로 건다(convert-core §2.4) — 여기선 산식만.
export const useShipmentLotSizeValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const validateRows = useCallback(
    (rows: Row[]): Result => {
      const invalidCells: { row: Row; column: string }[] = [];
      let firstMsgText = '';
      const remember = (msgId: string, fallback: string) => {
        if (!firstMsgText) firstMsgText = t(msgId, `_${fallback}`);
      };

      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        const lot = toIntOrNull(r.LOT_SIZE);
        const inc = toIntOrNull(r.INCREMENT);

        // ① LOT_SIZE < INCREMENT 차단
        if (lot !== null && inc !== null && lot < inc) {
          invalidCells.push({ row: r, column: 'LOT_SIZE' });
          invalidCells.push({ row: r, column: 'INCREMENT' });
          remember(MSG.INC_GT_LOT, 'Increment cannot be greater than Lot Size.');
          continue;
        }
        // ② LOT_SIZE==0 또는 INCREMENT==0(또는 미입력) 차단 — 0보다 큰 정수 필요
        if (lot === null || lot === 0) {
          invalidCells.push({ row: r, column: 'LOT_SIZE' });
          remember(MSG.ZERO_VALUE, 'Please enter an integer greater than 0.');
        }
        if (inc === null || inc === 0) {
          invalidCells.push({ row: r, column: 'INCREMENT' });
          remember(MSG.ZERO_VALUE, 'Please enter an integer greater than 0.');
        }
      }

      if (invalidCells.length > 0) {
        void setAlert({ type: 'alert', content: firstMsgText || t(MSG.ZERO_VALUE, '_Invalid') });
        return { ok: false, invalidCells };
      }
      return { ok: true, invalidCells: [] };
    },
    [setAlert, t]
  );

  return { validateRows };
};
