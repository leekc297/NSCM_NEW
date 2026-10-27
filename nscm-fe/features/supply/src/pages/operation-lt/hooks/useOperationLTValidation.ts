import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { DUP_KEY_COLUMNS, MSG } from '../operation-lt.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 검증 (design 01 §2 R9 / 03 §3-4 checkValidN1):
//   4키(DIVISION+SCM_SITE+ITEM+LT_OPERATION) 중복 차단 — MSG01092("The same {0} exists.").
// 필수값 검증은 여기서 하지 않는다 — AS-IS checkRequiredOfSpread 는 헤더 라벨 '*' 컬럼만 필수로 보는데
//   (DB 실측 '*' = DIVISION_ID·SCM_SITE_ID·ITEM_ID·LT_DAY, LT_OPERATION 은 '*' 없음 → 필수 아님),
//   이 화면 INPUT_TP_CD 가 IM/M 로 적재돼 공통 useSaveWithValidation(메타+'*' 라벨 기반, 잠금셀 스킵)이
//   AS-IS 와 등가로 재현한다. 하드코딩 필수집합(과거 LT_OPERATION 포함)은 AS-IS 와 어긋나므로 제거
//   (convert-core hook #130 — FE 필수 하드코딩 금지).
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

      // 4키 중복 — 전 행에서 같은 (DIVISION+SCM_SITE+ITEM+LT_OPERATION) 조합이 2건 이상이고
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
