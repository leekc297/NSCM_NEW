/* @refresh reload */
import { apiClient } from '@foundation/apis';
import type { ComboParam, ComboResponse } from '@foundation/models';
import { useQuery } from '@foundation/query-client';
import type { UseQueryOptions } from '@foundation/query-client';

/**
 * G2 — Multi-combo 1 round-trip (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS DataService.GetDMInnerTable BigFilter 캐싱 동등.
 * BE: POST /admin/combo-muti (이미 구현됨 — LookupController.retrieveComboMuti)
 *
 * 기존 `useTabComboQueries` 와 차이:
 * - `useTabComboQueries`: N 개 filter 마다 N round-trip (useQueries)
 * - `useTabCombosMulti`: 1 round-trip 으로 모든 combo 반환 (서버 측 통합 조회)
 *
 * DM 도메인 화면 권장: 본 hook 사용 (5+ combo 1 round-trip)
 *
 * 사용 예:
 * ```typescript
 * const { data: combos } = useTabCombosMulti({
 *   filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite', 'YesOrNo']
 * });
 *
 * // 결과: { MyDivision: [...], TeambyDivision: [...], EndCustomer: [...], ... }
 * const divisions = combos?.MyDivision ?? [];
 * const teams = combos?.TeambyDivision ?? [];
 * ```
 */
export const useTabCombosMulti = ({
  filters,
  enabled = true,
  queryOptions,
}: {
  filters: (ComboParam | string)[];
  enabled?: boolean;
  queryOptions?: Omit<
    UseQueryOptions<Record<string, ComboResponse[]>>,
    'queryKey' | 'queryFn'
  >;
}) => {
  const comboList = filters.map(f => (typeof f === 'string' ? { comboId: f } : f));
  const comboIds = comboList.map(c => c.comboId).sort();

  return useQuery<Record<string, ComboResponse[]>>({
    queryKey: ['combo-muti', comboIds, comboList],
    queryFn: () => apiClient.getCombosMulti(comboList),
    enabled,
    staleTime: 5 * 60 * 1000, // 5 분 캐시 (DM lookup 변경 빈도 낮음)
    persister: queryOptions?.persister ?? undefined,
    ...queryOptions,
  });
};

/**
 * G2 — DM 도메인 특화 BigFilter helper (Phase 5)
 *
 * AS-IS DataService.InitBigFilterDM + GetDMInnerTable 의 case 별 분기 동등.
 * 단일 호출로 모든 DM lookup (MyDivision / TeambyDivision / EndCustomer / SalesSite / BizType / ...) 반환.
 *
 * 사용 예 (DMF0004 retrofit):
 * ```typescript
 * const { data: bigFilter, filterByDivision } = useBigFilterDM();
 *
 * const teamOptions = filterByDivision(searchParams.divisionId)?.team ?? [];
 * const endCustomerOptions = filterByDivision(searchParams.divisionId)?.endCustomer ?? [];
 * ```
 */
export const useBigFilterDM = ({
  enabled = true,
}: { enabled?: boolean } = {}) => {
  const filters: string[] = [
    'MyDivision',
    'TeambyDivision',
    'EndCustomer',
    'SalesSite',
    'BizType',
    'YesOrNo',
  ];

  const queryResult = useTabCombosMulti({ filters, enabled });

  const filterByDivision = (divisionId: string | undefined) => {
    if (!queryResult.data) return undefined;
    return {
      myDivision: queryResult.data.MyDivision ?? [],
      team: (queryResult.data.TeambyDivision ?? []).filter(
        (t: any) => !divisionId || t.DIVISION_ID === divisionId
      ),
      endCustomer: (queryResult.data.EndCustomer ?? []).filter(
        (e: any) => !divisionId || e.DIVISION_ID === divisionId
      ),
      salesSite: (queryResult.data.SalesSite ?? []).filter(
        (s: any) => !divisionId || s.DIVISION_ID === divisionId
      ),
      bizType: (queryResult.data.BizType ?? []).filter(
        (b: any) => !divisionId || b.DIVISION_ID === divisionId
      ),
      yesOrNo: queryResult.data.YesOrNo ?? [],
    };
  };

  return {
    ...queryResult,
    filterByDivision,
  };
};
