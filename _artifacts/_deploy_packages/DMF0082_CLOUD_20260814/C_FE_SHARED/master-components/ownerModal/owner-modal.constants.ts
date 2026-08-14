export const MODAL_OWNER = 'COM0004' as const;
export type MODAL_OWNER = typeof MODAL_OWNER;

export const MODAL_SHEET_OWNER = 'owner' as const;
export type MODAL_SHEET_OWNER = typeof MODAL_SHEET_OWNER;

export const MODAL_NAME = 'ownerPopup';

export enum SHEET_INDEX {
  CANDIDATE = 1,
  SELECTED = 2,
}
