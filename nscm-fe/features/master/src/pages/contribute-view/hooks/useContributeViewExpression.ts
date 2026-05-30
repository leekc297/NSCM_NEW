/**
 * DMF0043_01 Contribute_View — Expression hook (2건)
 * AS-IS: __asis-mapping__.md §4 — ColumnHeaderSpan SUM × 2
 */
import type { ContributeViewRow } from '../contribute-view.types';

interface LargeSumHeader {
  header: string;
  bindings: string[];
  span: number;
}

export const useContributeViewExpression = () => {
  /** AS-IS .cs:204, 232 SetSpreadHeaderSpan — Large 그룹별 SUM 헤더 머지
   *  데이터의 LARGE_LABEL 변경 시점에 SUM 헤더 push */
  const buildLargeSumHeader = (rows: ContributeViewRow[]): LargeSumHeader[] => {
    const groups: LargeSumHeader[] = [];
    let currentLarge: string | undefined;
    let span = 0;
    for (const row of rows) {
      const label = row.LARGE_LABEL ?? '';
      if (label !== currentLarge) {
        if (currentLarge !== undefined) {
          groups.push({ header: `${currentLarge} SUM`, bindings: ['SUM_VALUE'], span });
        }
        currentLarge = label;
        span = 1;
      } else {
        span++;
      }
    }
    // 마지막 그룹
    if (currentLarge !== undefined && span > 0) {
      groups.push({ header: `${currentLarge} SUM`, bindings: ['SUM_VALUE'], span });
    }
    return groups;
  };

  return {
    buildLargeSumHeader,
  };
};
