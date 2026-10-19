import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// SCP0087 저장 전 검증.
//   편집 3컬럼(ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL)은 자유 텍스트 — 범위/필수 규칙 없음(design 03 §3 주의).
//   SAVE 는 CLASS_ID 를 WHERE 키로 UPDATE(design 03 §4.4) — 키가 비면 갱신 대상이 없어 결함이므로 그 존재만 방어 검증.
//   (AS-IS 는 GetValue2(i, CLASS_ID) 로 키를 읽어 전송 — design 03 R7.)
export const useMdmClassMasterValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const validateSaveRows = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        if (s(r.CLASS_ID).trim() === '') {
          void setAlert({ type: 'alert', content: t('MSG00003', '_Failed to save.') });
          return { ok: false };
        }
      }
      return { ok: true };
    },
    [setAlert, t]
  );

  return { validateSaveRows };
};
