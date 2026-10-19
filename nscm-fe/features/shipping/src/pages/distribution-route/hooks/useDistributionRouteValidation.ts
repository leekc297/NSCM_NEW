import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { DAYS_COLUMNS, MSG, PRIORITY_MIN } from '../distribution-route.constants';
import { toNum0 } from '../utils/distributionRoute.derive';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0005 저장 전 AS-IS 고유 의미검증 (design 03 — CheckValid cs:728~738, 1293~1314).
//   빈값 필수검증(From/To City 등)은 전 화면 공통 useSaveWithValidation(메타 * 기준)으로 이관했다 —
//   여기서는 메타 필수검증이 표현할 수 없는 두 가지만 남긴다:
//     - PRIORITY 양의 정수(>=1, MSG01134): 표준검증은 빈값만 잡아 0/음수를 통과시키므로 별도 검사.
//     - 요일 최소 1개(MSG00429 등가): 요일 컬럼에 메타 * 가 없어 표준검증 비대상.
//   대상 = 편집/신규 행(CRUD_TYPE). 위반 시 첫 1건 alert 만 — 검증 실패 셀 분홍칠은 전 화면 비표준이라 하지 않는다.
export const useDistributionRouteValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const validateRows = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        // PRIORITY 양의 정수 (MSG01134 — AS-IS MSG00107 과 문구 동일한 TO-BE 등재 코드).
        //   빈값은 표준 필수검증(useSaveWithValidation)이 먼저 잡으므로 여기선 값이 있으나 1 미만(0 등)만 남는다.
        if (toNum0(r.PRIORITY) < PRIORITY_MIN) {
          void setAlert({ type: 'alert', content: t(MSG.PRIORITY_MIN, '_Priority is a positive integer.') });
          return { ok: false };
        }
        // 요일 최소 1개 (요일 컬럼 메타 * 부재로 표준검증 비대상. MSG00429 등가 문구, {0} 에 항목명을
        //   채워 표준 형식 "[항목] 값은 필수 입력 항목입니다." 와 동일하게 노출)
        const hasDay = DAYS_COLUMNS.some(k => s(r[k]).trim().toUpperCase() === 'Y');
        if (!hasDay) {
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_FIELD, '_{0} 값은 필수 입력 항목입니다.').replace('{0}', '[Working Days]'),
          });
          return { ok: false };
        }
      }
      return { ok: true };
    },
    [setAlert, t]
  );

  return { validateRows };
};
