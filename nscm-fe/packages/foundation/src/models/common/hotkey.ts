export enum Hotkeys {
  F1 = 'manual',
  /**
   * 단축키 동작은 안 하지만 일괄 관리를 위해 등록
   */
  F2 = '_F2_Unused',
  F3 = 'sort',
  F4 = 'filter',
  F5 = 'search',
  F6 = 'condition',
  F7 = 'save',
  F8 = 'insert',
  F9 = 'delete',
  F10 = 'resetCondition',
  /**
   * 단축키 등록은 안 하지만 일괄 관리를 위해 등록.
   */
  _Excel = 'excel',
  _Upload = 'upload',
}

export type HotkeyConfig = Partial<Record<Hotkeys, false | (() => void)>>;
