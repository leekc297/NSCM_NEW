import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { DUP_KEY_COLUMNS, MSG, REQUIRED_COLUMNS } from '../operation-lt.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 검증 (design 01 §2 R9 / 03 §3-4 checkValidN1 + checkRequiredOfSpread):
//   1) 필수값(SCM_SITE_ID·ITEM_ID·LT_OPERATION·LT_DAY) 공백 차단 — INPUT_TP_CD 전 'S' 라 메타
//      useSaveWithValidation 만으론 못 잡으므로 화면에서 명시 검증(design 03 §6#2).
//   2) 4키(DIVISION+SCM_SITE+ITEM+LT_OPERATION) 중복 차단 — MSG01092("The same {0} exists.").
export const useOperationLTValidation = () => {
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

  // rows = 현재 그리드 전 행(중복 스캔 대상). dirty = CRUD_TYPE 있는 저장 대상.
  const validateSaveRows = useCallback(
    (rows: Row[]): Result => {
      const dirty = rows.filter(r => s(r.CRUD_TYPE));
      if (dirty.length === 0) return { ok: true };

      // 1) 필수값 — 신규/수정행 공통, 편집가능 필수 컬럼 공백 차단.
      for (const r of dirty) {
        for (const key of REQUIRED_COLUMNS) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_SELECT, 'Select {0}.', key);
          }
        }
      }

      // 2) 4키 중복 — 전 행에서 같은 (DIVISION+SCM_SITE+ITEM+LT_OPERATION) 조합이 2건 이상이고
      //    그 중 저장 대상(dirty)이 포함되면 중복 차단(AS-IS checkValidN1, arg='Operation LT').
      const keyOf = (r: Row): string => DUP_KEY_COLUMNS.map(k => s(r[k]).trim()).join('|');
      const counts = new Map<string, number>();
      for (const r of rows) counts.set(keyOf(r), (counts.get(keyOf(r)) ?? 0) + 1);
      for (const r of dirty) {
        if ((counts.get(keyOf(r)) ?? 0) > 1) {
          return alert(MSG.DUPLICATE, 'The same {0} exists.', 'Operation LT');
        }
      }

      return { ok: true };
    },
    [alert]
  );

  return { validateSaveRows };
};
