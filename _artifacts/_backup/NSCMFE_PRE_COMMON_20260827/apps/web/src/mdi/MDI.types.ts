import type { Menu } from '@foundation/models';

interface Tab<M extends MenuId = MenuId> extends Omit<Menu, 'sortOrd'> {
  tabId: string;
  closable: boolean;
}

export type AnyTab = {
  [M in MenuId]: Tab<MenuId>;
}[MenuId];
