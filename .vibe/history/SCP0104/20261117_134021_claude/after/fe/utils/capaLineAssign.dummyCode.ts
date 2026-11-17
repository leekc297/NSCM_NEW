import { apiClient } from '@foundation/apis';

import {
  COLUMN,
  DUMMY_CODE_BUTTON_CD,
  DUMMY_CODE_SHEET_PARAM,
  DUMMY_CODE_TYPE,
  MENU_ID,
  type DummyCodeType,
} from '../capa-line-assign.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface DummyCodeRequest {
  /** 라우팅 시트 — `ASSEMBLY` | `ELTR`. */
  sheet: string;
  /** `'N'` = Nickname(ASSEMBLY) / `'I'` = Item(ELTR). AS-IS `CheckNameOnDummyCodeDB(name, codeType)`. */
  codeType: DummyCodeType;
  /** 사용자가 셀에 입력한 미등록 명칭. */
  name: string;
}

/**
 * 미등록 명칭 → Dummy 코드 get-or-create (AS-IS `CheckNameOnDummyCodeDB` cs:2960-2998 / G14·G15).
 *
 * AS-IS 는 `SCP.SCP0104_CHECK_NAME_ON_DUMMY_CODE` 를 호출해 이름이 Dummy 테이블에 없으면 **추가 후
 * 채번한 `DMY_<seq>` 코드**를 돌려받고(있으면 기존 코드), 클라 목록을 갱신한 뒤 `DUMMY_YN='Y'` 를 세운다.
 * 파라미터도 AS-IS 원문 그대로다 — `p_sheet_name` 은 라우팅 시트가 아니라 **`'MAIN'` 고정**(cs:2975).
 * `p_user_id` 만 BE `@LoginUser` 주입이라 싣지 않는다(convert-core §3.5).
 *
 * 실패(네트워크·미배포·코드≠0)면 빈 문자열을 돌려준다 — 호출부는 그때 Dummy 마킹을 하지 않는다.
 * AS-IS 도 `try/catch` 로 삼키고 `""` 를 반환한다(cs:2994-2997).
 *
 * 런타임 한계: `PKG_SCP0104` 미배포 상태에서는 이 경로가 항상 빈 문자열이다(convert-sp 후속).
 */
export const checkNameOnDummyCode = async (request: DummyCodeRequest): Promise<string> => {
  const { sheet, codeType, name } = request;
  if (!name) return '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${sheet}/${DUMMY_CODE_BUTTON_CD}/call-proc`,
      {
        p_code_tp: codeType,
        p_name: name,
        p_program_id: MENU_ID,
        p_sheet_name: DUMMY_CODE_SHEET_PARAM,
        debug_mode: 'F',
      }
    );
    // 인터셉터가 500/CODE≠0 도 resolve 하므로 직접 판정한다(convert-core §2.4).
    if (res.status >= 400 || Number(res.data?.code)) return '';
    const body = res.data?.result as Record<string, unknown> | undefined;
    const firstSet = body
      ? (Object.values(body).find(Array.isArray) as Record<string, unknown>[] | undefined)
      : undefined;
    const head = firstSet?.[0];
    return head ? str(head.CODE ?? head.code) : '';
  } catch {
    return '';
  }
};

/**
 * 그리드 셀 binding → Dummy 코드 타입. 해당 없으면 null(= Dummy 채번 대상 아님).
 * AS-IS 가 실제로 채번하는 축은 둘뿐이다 — `NICK_NAME`(ASSEMBLY, "N") / `ITEM_ID`(ELTR, "I").
 * Site/Company/Plant/Factory/Line/Operation 축은 전부 주석 처리돼 있다(cs:3365~3627).
 */
export const dummyCodeTypeOf = (binding: string, isEltr: boolean): DummyCodeType | null => {
  if (!isEltr && binding === COLUMN.NICK_NAME) return DUMMY_CODE_TYPE.NICKNAME;
  if (isEltr && binding === COLUMN.ITEM_ID) return DUMMY_CODE_TYPE.ITEM;
  return null;
};
