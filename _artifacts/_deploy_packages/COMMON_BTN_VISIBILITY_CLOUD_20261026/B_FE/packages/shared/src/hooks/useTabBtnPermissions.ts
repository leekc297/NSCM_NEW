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
 * - divisionId(단일 Division 코드)를 주면 그 Division 에 단위권한(SCM_ADM_USER_GR_UNIT_AUTH_MPG_M 'D')이 있는
 *   그룹 기준으로만 버튼을 돌려준다(BE PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV). 미지정/'ALL'/복수('a,b')는
 *   종전처럼 사용자 그룹 합집합. SubTitle 이 조회조건 Division(searchParam)으로 넘겨 Division 선택 시 공통버튼
 *   노출이 따라 바뀐다(사용자·Division 별 권한이 다를 때 cascade — 2026-10-26).
 */
export const useTabBtnPermissions = ({
  menuId,
  enabled = true,
  divisionId,
}: {
  menuId: string;
  enabled?: boolean;
  divisionId?: string;
}) => {
  // 'ALL'·복수 선택·빈값은 Division 축 없음(합집합) — 서버에 보내지 않아 캐시 키도 하나로 모인다
  const div = divisionId && !/^all$/i.test(divisionId) && !divisionId.includes(',') ? divisionId : '';
  const { data, isLoading, refetch } = useQuery({
    queryKey: ['menu-auth', menuId, div],
    queryFn: async () => {
      const res = await apiClient.get<{ mnuBtnAuth: string[] }>(`/admin/menu/${menuId}/auth`, {
        params: div ? { divisionId: div } : undefined,
      });
      return res.data.result?.mnuBtnAuth ?? [];
    },
    enabled: enabled && !!menuId,
    staleTime: 60_000,
  });

  const buttons = data ?? [];

  const hasButton = (btnCd: string): boolean => buttons.includes(btnCd);

  return { buttons, hasButton, isLoading, refetch };
};
