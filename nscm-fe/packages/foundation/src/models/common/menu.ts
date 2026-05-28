export interface Menu {
  mnuId: string | MenuId;
  upprMnuId?: string | null;
  mnuUrl: string;
  mnuMsgId: translation;
  mnuDesc: string;
  favorite?: boolean;
  children?: Menu[];
}
