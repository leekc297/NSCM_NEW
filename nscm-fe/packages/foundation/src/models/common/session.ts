import type { Menu } from './menu';

export interface UserSession {
  langCd: string;
  userId: string;
  userEngNm: string;
  userNm: string;
  div: string;
  menus: Menu[];
}
