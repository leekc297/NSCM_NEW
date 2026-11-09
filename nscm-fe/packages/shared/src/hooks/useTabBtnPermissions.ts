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
 *
 * 시트 단위 권한:
 * - hasButton(btnCd) : 메뉴 단위(기존). 버튼 노출 판정에 사용.
 * - hasButton(btnCd, sheetName) : 시트 단위. 그 시트(SHT_NM)에 해당 버튼 권한이 등록돼 있는지.
 *   그리드 편집가부를 시트 단위 SAVE 권한으로 잠그는 데 사용(AS-IS MODIFY 파리티). sheetName 은
 *   저장 라우팅 SHEETS enum 값(=등록 SHT_NM)과 동일해야 하며 대소문자를 구분한다.
 */
interface MnuBtnAuthSheet {
  shtNm: string | null;
  btnCd: string;
}

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
      const res = await apiClient.get<{
        mnuBtnAuth: string[];
        mnuBtnAuthSheets?: MnuBtnAuthSheet[];
        mnuBtnDefs?: MnuBtnAuthSheet[];
      }>(`/admin/menu/${menuId}/auth`);
      return {
        mnuBtnAuth: res.data.result?.mnuBtnAuth ?? [],
        mnuBtnAuthSheets: res.data.result?.mnuBtnAuthSheets ?? [],
        mnuBtnDefs: res.data.result?.mnuBtnDefs ?? [],
      };
    },
    enabled: enabled && !!menuId,
    staleTime: 60_000,
  });

  const buttons = data?.mnuBtnAuth ?? [];
  const buttonSheets = data?.mnuBtnAuthSheets ?? [];
  const buttonDefs = data?.mnuBtnDefs ?? [];

  // 사용자가 "가진" 버튼. sheetName 미지정=메뉴 단위, 지정=시트 단위.
  const hasButton = (btnCd: string, sheetName?: string): boolean =>
    sheetName === undefined
      ? buttons.includes(btnCd)
      : buttonSheets.some(sheet => sheet.btnCd === btnCd && sheet.shtNm === sheetName);

  // 이 메뉴에 "정의된" 버튼(사용자 무관). 그리드 자동 SAVE 잠금의 saveDefined 판정용 —
  //   SAVE 미부여가 권한없음인지 화면에 SAVE 정의 자체가 없음(EXECUTE 저장)인지 가른다.
  const hasButtonDef = (btnCd: string, sheetName?: string): boolean =>
    sheetName === undefined
      ? buttonDefs.some(def => def.btnCd === btnCd)
      : buttonDefs.some(def => def.btnCd === btnCd && def.shtNm === sheetName);

  return { buttons, hasButton, hasButtonDef, isLoading, refetch };
};
