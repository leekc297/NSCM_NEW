export enum CELL_INPUT_EDIT_TYPE {
  SEARCH_ONLY = 'S',
  OPTIONAL = 'O',
  MANDATORY = 'M',
  OPTIONAL_INSERT_ONLY = 'IO',
  MANDATORY_INSERT_ONLY = 'IM',
}

export enum CELL_CONTROL_TYPE {
  // modal에 대한 명칭 정하기 필요
  MODAL = 'FPModal',
  // 타이핑 + 돋보기 모달을 동시에 허용하는 셀 (AS-IS FPTextModal).
  TEXT_MODAL = 'FPTextModal',
  COMBO = 'FPComboBox',
  BUTTON = 'FPButton',
  DATE = 'FPDate',
  DATE_MONTH = 'FPDateMonth',
  DATE_TIME = 'FPDateTime',
  DATE_TEXT = 'FPDateText',
  CHECKBOX = 'FPCheckBox',
  NUMBER_TEXT = 'FPNumberText',
  TEXT_BOX = 'FPTextBox',
  PERCENT = 'FPPercent',
  TEXT = 'FPText',
  NUMBER = 'FPNumber',
  MULTILINE_TEXT = 'FPMultiLineTextBox',
}
