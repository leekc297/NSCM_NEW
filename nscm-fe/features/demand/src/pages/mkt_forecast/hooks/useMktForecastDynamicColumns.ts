import { useMemo } from 'react';

import { BUCKET_TYPE, MAIN_COLUMNS, type MainColumnMeta } from '../mkt-forecast-master.constants';
import type { SearchCondition } from '../mkt-forecast-master.types';
import { generateBucketKeys, getBucketHeader, getEditableWeeksFromCurrentDate } from '../utils/bucketDate';
import { filterColumnsByDivision } from '../utils/divisionBranch';

// AS-IS DMF0003_1_MktFcst.cs L1780 InitSpread + SetSpreadColumn 동등
//   - SPREAD_TITLE SP 결과 기반 동적 컬럼 생성 (Phase 3)
//   - 단 SPREAD_TITLE SP 미호출 시 FE 측에서 Bucket type + Period 로 직접 생성
//
// Bucket type 별 동적 컬럼:
//   - DAILY  : ~90 일 column (D_YYYYMMDD)
//   - WEEKLY : ~52 주 column (W_YYYYMMDD)
//   - MONTHLY: ~36 월 column (M_YYYYMM)
//
// Div 40 (8주 관리) — Weekly Bucket 시 8주 이내 column 만 editable
//
// 룰 12 §11.5 + hook pivot-frozen-columns — frozenColumns=5 (좌측 Division~TeamName)

interface DynamicColumnsResult {
  fixedColumns: MainColumnMeta[];
  dynamicColumns: MainColumnMeta[];
  allColumns: MainColumnMeta[];
}

export const useMktForecastDynamicColumns = (sc: SearchCondition): DynamicColumnsResult => {
  // Division 3-way 분기 fixed columns
  const fixedColumns = useMemo(
    () => filterColumnsByDivision(MAIN_COLUMNS, sc.divisionId),
    [sc.divisionId],
  );

  // Bucket type 별 동적 컬럼 키
  const dynamicKeys = useMemo(
    () => generateBucketKeys(sc.bucketType, sc.startYyyymmdd, sc.endYyyymmdd),
    [sc.bucketType, sc.startYyyymmdd, sc.endYyyymmdd],
  );

  // Div 40 (8주) editable 키
  const editableKeys = useMemo(
    () => (sc.divisionId === '40' && sc.bucketType === BUCKET_TYPE.WEEKLY
      ? new Set(getEditableWeeksFromCurrentDate())
      : null),
    [sc.divisionId, sc.bucketType],
  );

  const dynamicColumns = useMemo<MainColumnMeta[]>(
    () => dynamicKeys.map(key => {
      const isEditable = editableKeys === null || editableKeys.has(key);
      return {
        key,
        header: getBucketHeader(key),
        width: 80,
        align: 'R',
        _ctrlType: 'FPNumber',
        _inputEditType: isEditable ? 'O' : 'S',
      };
    }),
    [dynamicKeys, editableKeys],
  );

  const allColumns = useMemo(
    () => [...fixedColumns, ...dynamicColumns],
    [fixedColumns, dynamicColumns],
  );

  return { fixedColumns, dynamicColumns, allColumns };
};
