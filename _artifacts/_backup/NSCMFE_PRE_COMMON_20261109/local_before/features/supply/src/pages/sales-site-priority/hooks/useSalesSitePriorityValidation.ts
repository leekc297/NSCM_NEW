import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { MSG, REQUIRED_COLUMNS } from '../sales-site-priority.constants';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 전 검증(design 00 §4a validations 12건 중 저장 시점 6건 — #1/#4/#5/#6, 나머지는 붙여넣기·
//   결과 toast 는 useProcMutation 표준 경로로 처리됨).
//   1) 필수값(division/planGroup/site/item/prioRank/from/to/validYn 8개) 공백 차단 — VALID_YN 은
//      라벨 '*' 불일치(design 03 §1 비고)로 REQUIRED_COLUMNS(라벨기준 7칸)에서 제외했으나,
//      AS-IS validations#1 이 실제로 검사하는 8번째 값이라 이 화면 커스텀 검증에서 별도 포함한다.
//   2) PRIO_RANK < 1 차단(MSG00175 등가 MSG00699).
//   3) From > To 차단(MSG00219 등가 MSG01135).
//   안전재고 경고(AS-IS MSG00260)·item 존재확인(MSG00458)은 서버(SAVE SP) 판정 영역이라 SP 배포 후
//   런타임에서만 검증 가능 — 이 화면은 SP MISSING 이므로 미검증 상태(확인 필요, __asis-mapping__.md 명시).
export const useSalesSitePriorityValidation = () => {
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

      // 1) 필수값 — 라벨 '*' 7칸 + VALID_YN(AS-IS validations#1 실제 검사 대상, 라벨 불일치 별도 반영).
      const requiredForSave = [...REQUIRED_COLUMNS, 'VALID_YN'];
      for (const r of dirty) {
        for (const key of requiredForSave) {
          if (s(r[key]).trim() === '') {
            return alert(MSG.REQUIRED_FIELDS, 'Please enter the required fields.');
          }
        }
      }

      // 2) PRIO_RANK >= 1.
      for (const r of dirty) {
        const prio = Number(r.PRIO_RANK);
        if (!Number.isFinite(prio) || prio < 1) {
          return alert(MSG.PRIO_MIN, 'Please enter an integer greater than 0.');
        }
      }

      // 3) From <= To.
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
