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

  const validateRows = useCallback(
    (rows: Row[]): Result => {
      const invalidCells: { row: Row; column: string }[] = [];
      // 첫 위반 메시지 1건만 alert 로 노출한다(AS-IS CheckValid 도 첫 위반 메시지 표시). 단 셀 색칠은
      //   전 편집행을 검사해 누적한다(design 03 R16/R17/G4 — 첫 행에서 멈추지 않는다, gap G4).
      let firstMsgText = '';
      const remember = (msgId: string, fallback: string, bound?: number) => {
        if (firstMsgText) return;
        const text = t(msgId, `_${fallback}`);
        firstMsgText = bound === undefined ? text : text.replace('{0}', String(bound));
      };

      for (const r of rows) {
        if (!s(r.CRUD_TYPE)) continue;
        // PRIORITY >= 1 (design 03 R17 — MSG01134. AS-IS MSG00107 과 문구 동일한 TO-BE 등재 코드 사용)
        if (toNum0(r.PRIORITY) < PRIORITY_MIN) {
          invalidCells.push({ row: r, column: 'PRIORITY' });
          remember(MSG.PRIORITY_MIN, 'Priority', PRIORITY_MIN);
        }
        // FROM/TO City Name 비공백 (design 03 R17 — MSG00429. AS-IS MSG00167 미등재 대체. 도시팝업 파생 잠금 컬럼)
        if (s(r.FROM_CITY_NAME).trim() === '') {
          invalidCells.push({ row: r, column: 'FROM_CITY_NAME' });
          remember(MSG.REQUIRED_FIELD, 'From City');
        }
        if (s(r.TO_CITY_NAME).trim() === '') {
          invalidCells.push({ row: r, column: 'TO_CITY_NAME' });
          remember(MSG.REQUIRED_FIELD, 'To City');
        }
        // 요일 최소 1개 (design 03 G4 — MSG00429. AS-IS MSG00223 미등재 대체. 전부 공백/'N' 이면 차단)
        const hasDay = DAYS_COLUMNS.some(k => s(r[k]).trim().toUpperCase() === 'Y');
        if (!hasDay) {
          DAYS_COLUMNS.forEach(k => invalidCells.push({ row: r, column: k }));
          remember(MSG.REQUIRED_FIELD, 'Working Days');
        }
      }

      if (invalidCells.length > 0) {
        void setAlert({ type: 'alert', content: firstMsgText || t(MSG.REQUIRED_FIELD, '_Invalid') });
        return { ok: false, invalidCells };
      }
      return { ok: true, invalidCells: [] };
    },
    [setAlert, t]
  );

  return { validateRows };
};
