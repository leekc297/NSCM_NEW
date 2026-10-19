import {
  BOH_MODE_PREFIX,
  BOH_SUM_COLUMN_SETS,
  DYNAMIC_COLUMN_TAG_PATTERN,
  type BohMode,
} from '../shipment-request-electrode.constants';
import type { DynamicColumnTag } from '../shipment-request-electrode.types';

/**
 * 동적 pivot 컬럼 바인딩(예 'X_D_20260101')을 축1(BOH모드)/축2(Bucket)/날짜로 분해한다.
 * AS-IS `SetSpreadColumn()`(cs:1869-2059)의 `ColumnTag` 접두 매칭 규칙 — design 03 §2.2 정본.
 */
export const parseDynamicColumnTag = (binding: string): DynamicColumnTag | null => {
  const m = DYNAMIC_COLUMN_TAG_PATTERN.exec(binding);
  if (!m) return null;
  return { bohMode: m[1] as DynamicColumnTag['bohMode'], bucket: m[2] as DynamicColumnTag['bucket'], yyyymmdd: m[3] };
};

/**
 * BOH 표시모드(rdButton1/2/3) 선택에 따라 9칼럼×3세트 중 1세트만 visible=true (design 01 R4 매핑표).
 * 반환: 3세트 전체 칼럼ID → visible 맵.
 */
export const bohSumColumnVisibility = (mode: BohMode): Record<string, boolean> => {
  const visibility: Record<string, boolean> = {};
  (Object.keys(BOH_SUM_COLUMN_SETS) as BohMode[]).forEach(key => {
    BOH_SUM_COLUMN_SETS[key].forEach(col => {
      visibility[col] = key === mode;
    });
  });
  return visibility;
};

/**
 * 동적 pivot 컬럼 1개의 visible 여부 — design 03 §2.2 규칙 1~3(BOH모드 × Bucket × chkSum × chkPastPeriod).
 *
 * 규칙(AS-IS cs:1879-2044 그대로):
 * 1. bohMode 와 일치하는 접두(X_/Y_/Z_)만 후보 — 불일치 접두는 전부 숨김.
 * 2. bucket 별 세부 노출: Daily→D_+W_ 표시(M_은 chkSum 연동) / Weekly→D_숨김,W_표시(M_은 chkSum 연동) /
 *    Monthly→D_+W_ 숨김, M_ 표시.
 * 3. PastPeriod 필터 — chkPastPeriod 해제 시, planDate 기준일보다 과거인 컬럼은 숨김.
 */
export const isDynamicColumnVisible = (
  binding: string,
  params: {
    bohMode: BohMode;
    bucketType: 'D' | 'W' | 'M';
    sumChecked: boolean;
    pastPeriodChecked: boolean;
    planDateYyyymmdd: string;
  }
): boolean => {
  const tag = parseDynamicColumnTag(binding);
  if (!tag) return false;
  if (tag.bohMode !== BOH_MODE_PREFIX[params.bohMode]) return false;

  const { bucketType, sumChecked } = params;
  let bucketVisible: boolean;
  if (bucketType === 'D') {
    bucketVisible = tag.bucket === 'D' || tag.bucket === 'W' || (tag.bucket === 'M' && sumChecked);
  } else if (bucketType === 'W') {
    bucketVisible = tag.bucket === 'W' || (tag.bucket === 'M' && sumChecked);
  } else {
    bucketVisible = tag.bucket === 'M';
  }
  if (!bucketVisible) return false;

  if (!params.pastPeriodChecked && params.planDateYyyymmdd) {
    if (tag.yyyymmdd < params.planDateYyyymmdd) return false;
  }
  return true;
};
