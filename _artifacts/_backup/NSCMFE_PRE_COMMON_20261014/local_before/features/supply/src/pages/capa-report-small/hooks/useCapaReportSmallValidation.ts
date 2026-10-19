import { useCapaReportSmallStore } from '../useCapaReportSmallStore';

/** 조회/저장 검증 — AS-IS DataUtil.checkRequiredOfSearch(Period 필수) 재현. */
export const useCapaReportSmallValidation = () => {
  const searchParams = useCapaReportSmallStore(s => s.searchParams);

  /** Search 전 검증 — null = 통과, 그 외 = 에러코드. */
  const validateSearch = (): 'PERIOD_REQUIRED' | 'PERIOD_ORDER' | null => {
    const from = searchParams.startYyyymmdd?.trim();
    const to = searchParams.endYyyymmdd?.trim();
    if (!from || !to) return 'PERIOD_REQUIRED';
    if (from > to) return 'PERIOD_ORDER';
    return null;
  };

  return { validateSearch };
};
