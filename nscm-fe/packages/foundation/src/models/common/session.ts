import type { Menu } from './menu';

export interface UserSession {
  groupId: string;
  langCd: string;
  userId: string;
  userEngNm: string;
  userNm: string;
  div: string;
  menus: Menu[];
}
