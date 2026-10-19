import { DYNAMIC_COLUMN_TAG_PATTERN } from '../shipment-request-pack.constants';
import type { DynamicColumnTag, SearchParamProps } from '../shipment-request-pack.types';

/** `D_20260101` 형태의 동적 pivot 컬럼 바인딩을 파싱한다(design 03 §2, GET_SPREAD_TITLE 응답 기준). */
export const parseDynamicColumnTag = (binding: string): DynamicColumnTag | null => {
  const match = DYNAMIC_COLUMN_TAG_PATTERN.exec(binding);
  if (!match) return null;
  return { bucket: match[1] as DynamicColumnTag['bucket'], yyyymmdd: match[2] };
};

const BUCKET_PREFIX: Record<SearchParamProps['bucketType'], DynamicColumnTag['bucket']> = {
  Daily: 'D',
  Weekly: 'W',
  Monthly: 'M',
};

/**
 * Bucket 선택(design 01 R16)에 따른 D_/W_/M_ visible 세트 — 선택된 Bucket 접두만 노출한다.
 * chkSum/chkPastPeriod 는 §2 R3/R4 로 렌더 자체가 사문화 확정돼 항상 기본값(false) 취급한다
 * (임의 확정 아님 — 확인 필요 §5-2 잔존, 04_react-gap.md 명시).
 */
export const isDynamicColumnVisible = (
  binding: string,
  bucketType: SearchParamProps['bucketType']
): boolean => {
  const tag = parseDynamicColumnTag(binding);
  if (!tag) return false;
  return tag.bucket === BUCKET_PREFIX[bucketType];
};
