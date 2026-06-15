/* @refresh reload */
import { apiClient } from '@foundation/apis';
import { useQuery } from '@foundation/query-client';

/**
 * 메뉴 버튼 권한 동적 fetch — UI 동적 속성관리 master hook §3 (2026-06-15)
 *
 * BE: GET /admin/menu/{mnuId}/auth → MenuAuthDto.mnuBtnAuth: List<String>
 *   SCM_ADM_USER_GR_MNU_BTN_MPG_M JOIN 으로 사용자 그룹 권한 있는 BTN_CD list 반환
 *
 * 사용 예:
 * ```typescript
 * const { hasButton, isLoading } = useTabBtnPermissions({ menuId: MENU_ID });
 *
 * const hotkeyConfig: HotkeyConfig = {
 *   search: hasButton('SEARCH') ? handleSearch : false,
 *   save:   hasButton('SAVE')   ? handleSave   : false,
 *   insert: hasButton('INSERT') ? handleInsert : false,
 *   delete: hasButton('DELETE') ? handleDelete : false,
 *   manual: false,  // admin 정의 자체 없음 (Hidden allowlist)
 *   upload: false,
 * };
 *
 * const customButtons = hasButton('EXECUTE') ? [{ label: 'Execute', action: handleExecute }] : [];
 * ```
 *
 * 동작:
 * - admin 이 SYS0009 (Menu Button) 에서 BTN 의 USE_YN='N' 설정 시 → mnuBtnAuth 에서 제외
 * - 사용자 그룹이 BTN 권한 없으면 → mnuBtnAuth 에서 제외
 * - 화면 mount 시 자동 fetch + 결과 cache (react-query)
 */
export const useTabBtnPermissions = ({
  menuId,
  enabled = true,
}: {
  menuId: string;
  enabled?: boolean;
}) => {
  const { data, isLoading, refetch } = useQuery({
    queryKey: ['menu-auth', menuId],
    queryFn: async () => {
      const res = await apiClient.get<{ mnuBtnAuth: string[] }>(`/admin/menu/${menuId}/auth`);
      return res.data.result?.mnuBtnAuth ?? [];
    },
    enabled: enabled && !!menuId,
    staleTime: 60_000,
  });

  const buttons = data ?? [];

  const hasButton = (btnCd: string): boolean => buttons.includes(btnCd);

  return { buttons, hasButton, isLoading, refetch };
};
