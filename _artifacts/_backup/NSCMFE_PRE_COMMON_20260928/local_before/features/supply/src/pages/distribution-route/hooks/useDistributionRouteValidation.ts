import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';

import { DAYS_COLUMNS, MSG, PRIORITY_MIN } from '../distribution-route.constants';
import { toNum0 } from '../utils/distributionRoute.derive';

type Row = Record<string, unknown>;
interface Result {
  ok: boolean;
  // 위반 셀 — 호출부 markInvalidCells 하이라이트 대상 (design 03 R17 InvalidColor. sister SCP0006 동형).
  invalidCells: { row: Row; column: string }[];
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// SCP0005 저장 전 클라 검증 (design 03 R17/G4 — CheckValid cs:728~738, 1293~1314).
//   대상 = 편집/신규 행(CRUD_TYPE). PRIORITY>=1(MSG01134) / FROM·TO City Name 비공백(MSG00429) /
//   요일 최소 1개(MSG00429). 위반 시 alert + 위반 셀 반환(호출부가 InvalidColor 마킹 후 저장 중단).
//   (City Name·요일은 AS-IS MSG00167/MSG00223 이 TO-BE SCM_ADM_MSG_M 미등재 → 등재된 MSG00429 로 매핑)
export const useDistributionRouteValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (
      msgId: string,
      fallback: string,
      cells: { row: Row; column: string }[],
      bound?: number
    ): Result => {
      const text = t(msgId, `_${fallback}`);
      void setAlert({
        type: 'alert',
        content: bound === undefined ? text : text.replace('{0}', String(bound)),
      });
      return { ok: false, invalidCells: cells };
    },
    [setAlert, t]
  );

  const validateRows = useCallback(
    (rows: Row[]): Result => {
      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        // PRIORITY >= 1 (design 03 R17 — MSG01134, 구 MSG00107 미등재 교체)
        const priority = toNum0(r.PRIORITY);
        if (priority < PRIORITY_MIN)
          return alert(MSG.PRIORITY_MIN, 'Priority', [{ row: r, column: 'PRIORITY' }], PRIORITY_MIN);
        // FROM/TO City Name 비공백 (design 03 R17 — MSG00429. AS-IS MSG00167 미등재 대체. 도시팝업 파생 잠금 컬럼)
        if (s(r.FROM_CITY_NAME).trim() === '')
          return alert(MSG.REQUIRED_FIELD, 'From City', [{ row: r, column: 'FROM_CITY_NAME' }]);
        if (s(r.TO_CITY_NAME).trim() === '')
          return alert(MSG.REQUIRED_FIELD, 'To City', [{ row: r, column: 'TO_CITY_NAME' }]);
        // 요일 최소 1개 (design 03 G4 — MSG00429. AS-IS MSG00223 미등재 대체. 전부 공백/'N' 이면 차단)
        const hasDay = DAYS_COLUMNS.some(k => s(r[k]).trim().toUpperCase() === 'Y');
        if (!hasDay)
          return alert(
            MSG.REQUIRED_FIELD,
            'Working Days',
            DAYS_COLUMNS.map(k => ({ row: r, column: k }))
          );
      }
      return { ok: true, invalidCells: [] };
    },
    [alert]
  );

  return { validateRows };
};
