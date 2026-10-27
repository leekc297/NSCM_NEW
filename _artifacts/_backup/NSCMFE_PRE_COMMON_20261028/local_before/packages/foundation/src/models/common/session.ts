import type { Menu } from './menu';

export interface UserSession {
  groupId: string;
  langCd: string;
  userId: string;
  userEngNm: string;
  userNm: string;
  div: string;
  /** 소속 회사(SCM_MST_SSO_USER_INFO.COMPANY_ID). 없으면 undefined. SSP0015 My Model 기본체크 등에 사용. */
  companyId?: string;
  menus: Menu[];
  /**
   * 미등록 게스트 로그인 여부. true면 권한요청 안내(권한 없음 Alert) 대상.
   * ※ BE(Jackson)가 boolean isGuest 를 "guest" 로 직렬화하므로 필드명은 guest.
   */
  guest?: boolean;
  /** 본인이 속한 그룹 권한명(USER_GR_NM) 목록 */
  groups?: string[];
}
