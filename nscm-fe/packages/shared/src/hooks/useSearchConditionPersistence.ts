/* @refresh reload */
import { apiClient } from '@foundation/apis';
import { useMutation, useQueryClient } from '@foundation/query-client';
import { useMessageStore } from '@shared/stores';

/**
 * G1 — 사용자별 검색조건 저장/복원 (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS BaseForm: F6 (OnClickConditionButton) → Authentication.SaveSearchCondition SP
 *                 F10 (OnClickResetConditionButton) → Authentication.ResetSearchCondition SP
 *
 * ⚠️ Phase 5 추가 발견: BE 의 G1 endpoint 3종 (GET / POST / POST .../reset) 이 이미
 *    `MenuController` (nscm-be/admin/menu/MenuController.java) 에 구현되어 있음.
 *    본 hook 은 BE 의 기존 endpoint 를 사용 — 신규 구현은 FE 의 hook + SubTitle 통합만.
 *
 * BE endpoints:
 * - GET    /admin/menu/{mnuId}/search-conditions          (이미 store.fetchStaticColumns 안에서 사용)
 * - POST   /admin/menu/{mnuId}/search-conditions          (저장 — body = List<SearchCondition>)
 * - POST   /admin/menu/{mnuId}/search-conditions/reset    (초기화 — body 없음)
 *
 * 사용 예:
 * ```typescript
 * const { saveCondition, resetCondition } = useSearchConditionPersistence(MENU_ID);
 *
 * // SubTitle DefaultButtonActions 안에서 자동 호출
 * hotkeyConfig: { condition: () => saveCondition(searchParams), resetCondition }
 * ```
 */
export const useSearchConditionPersistence = <SearchParams extends Record<string, unknown>>(
  menuId: string
) => {
  const queryClient = useQueryClient();
  const { setToast, setAlert, setConfirm } = useMessageStore.getState();
  const { t } = useTranslation();

  /**
   * POST — 현재 searchParams 를 저장
   * AS-IS: Authentication.SaveSearchCondition → MSG00155 "조회 조건이 저장되었습니다"
   */
  const saveConditionMutation = useMutation({
    mutationFn: async (searchParams: SearchParams) => {
      // BE: POST /admin/menu/{mnuId}/search-conditions
      // body = List<SearchCondition> { paramNm, paramCtn } (array, not wrapper)
      const conditions = Object.entries(searchParams)
        .filter(([_, value]) => value !== undefined && value !== null && value !== '')
        .map(([paramNm, paramCtn]) => ({
          paramNm,
          paramCtn: String(paramCtn),
        }));
      return apiClient.post(`/admin/menu/${menuId}/search-conditions`, conditions);
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['search-condition', menuId] });
      setToast({ type: 'success', message: t('MSG00155', '_조회 조건이 저장되었습니다.') });
    },
    onError: error => {
      void setAlert({
        type: 'alert',
        content: error.message ?? t('MSG00399', '_검색조건 초기화중 오류가 발생하였습니다.'),
      });
    },
  });

  /**
   * DELETE — 저장된 검색조건 초기화 (해당 메뉴의 모든 row 삭제)
   * AS-IS: Authentication.ResetSearchCondition → MSG00398 "검색조건이 초기화 되었습니다"
   */
  const resetConditionMutation = useMutation({
    mutationFn: async () => {
      // BE: POST /admin/menu/{mnuId}/search-conditions/reset (DELETE 가 아닌 POST)
      return apiClient.post(`/admin/menu/${menuId}/search-conditions/reset`, {});
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['search-condition', menuId] });
      setToast({ type: 'success', message: t('MSG00398', '_검색조건이 초기화 되었습니다.') });
    },
    onError: error => {
      void setAlert({
        type: 'alert',
        content: error.message ?? t('MSG00399', '_검색조건 초기화중 오류가 발생하였습니다.'),
      });
    },
  });

  /**
   * F6 OnClickConditionButton 동등 — searchParams 저장
   */
  const saveCondition = (searchParams: SearchParams) => {
    saveConditionMutation.mutate(searchParams);
  };

  /**
   * F10 OnClickResetConditionButton 동등 — MSG00397 확인 후 초기화
   */
  const resetCondition = async () => {
    const confirmed = await setConfirm({
      type: 'confirm',
      content: t('MSG00397', '_검색조건을 초기화 하시겠습니까?'),
    });
    if (!confirmed) return;
    resetConditionMutation.mutate();
  };

  return {
    saveCondition,
    resetCondition,
    isSaving: saveConditionMutation.isPending,
    isResetting: resetConditionMutation.isPending,
  };
};
