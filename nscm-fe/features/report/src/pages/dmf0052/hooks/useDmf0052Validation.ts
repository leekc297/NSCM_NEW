// DMF0052 EDISummary — As-is Validation 100% 적용 (룰 09)
//   V-nnn 마커는 게이트(check.js V01)가 센다 — 삭제·병합 금지.
//   Doc/_analysis/.../DMF0052_EDISummary/validation.md 4건: V-001~V-004
import { useCallback, useMemo } from 'react';

import { useMessageStore } from '@shared/stores';

export interface AsisValidationRule {
  id: string;        // V-nnn (validation.md #)
  asisLine: number;  // As-is .cs 줄
  msg?: string;      // MSG 코드
  apply: () => boolean;
}

export interface Dmf0052ValidationInput {
  divisionId?: string;
  periodFrom?: string; // YYYYMMDD
  periodTo?: string;   // YYYYMMDD
}

export const useDmf0052Validation = (input?: Dmf0052ValidationInput) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);

  const rules = useMemo<AsisValidationRule[]>(() => [
    // V-001 FindData_Main L283 : sEDISender == "" 상태 → 사업부·EDI Sender 미선택 통보 (MSG00097)
    {
      id: 'V-001', asisLine: 283, msg: 'MSG00097',
      apply: (): boolean => {
        if (!input?.divisionId) {
          void setAlert({ type: 'alert', content: t('MSG00097', '_Please select Division.') });
          return false;
        }
        return true;
      },
    },
    // V-002 FindData_Main L292 : sPeriod[0] > sPeriod[1] (from > to) → 날짜 역순 통보 (MSG00108)
    {
      id: 'V-002', asisLine: 292, msg: 'MSG00108',
      apply: (): boolean => {
        const from = Number(input?.periodFrom ?? 0);
        const to = Number(input?.periodTo ?? 0);
        if (from && to && from > to) {
          void setAlert({ type: 'alert', content: t('MSG00108', '_The start date cannot be later than the end date.') });
          return false;
        }
        return true;
      },
    },
    // V-003 spdPjt_CellDoubleClick L572 : siPjt.ActiveSheet.Rows.Count <= 0 → 종료 (runPjtGuard 가 호출 시점 평가)
    { id: 'V-003', asisLine: 572, msg: undefined, apply: (): boolean => true },
    // V-004 spdData_CellDoubleClick L634 : siMain.ActiveSheet.Rows.Count <= 0 → 종료 (runDataGuard 가 호출 시점 평가)
    { id: 'V-004', asisLine: 634, msg: undefined, apply: (): boolean => true },
  ], [input, setAlert, t]);

  // AS-IS FindButton 사전 가드 — V-001 → V-002 순서, 하나라도 실패하면 중단
  const runAll = useCallback((): boolean => {
    for (const r of rules) if (!r.apply()) return false;
    return true;
  }, [rules]);

  // V-003 : spdPjt 행 0건이면 더블클릭 종료 — rowCount 전달
  const runPjtGuard = useCallback((rowCount: number): boolean => rowCount > 0, []);
  // V-004 : spdData 행 0건이면 더블클릭 종료
  const runDataGuard = useCallback((rowCount: number): boolean => rowCount > 0, []);

  return { rules, runAll, runPjtGuard, runDataGuard };
};
