import type { Menu } from './menu';

export interface PageProps<M extends MenuId> {
  tabId: string;
  title: string;
  menu: Menu;
}
