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
  /**
   * ⭐ [2026-08-22 신설] 텍스트 입력 **과** 모달 선택을 **둘 다** 허용하는 셀.
   *
   * 왜 별도 값이 필요한가 — `FPModal` 은 공용 DataGrid 에서 **세 가지를 한 덩어리로** 지배한다:
   *   ① `beginningEdit` cancel(타이핑 차단)  ② 돋보기 아이콘(`is-popup`)  ③ `wj-cell-popup` 스타일
   * 그래서 기존 두 값으로는 AS-IS 동작을 표현할 수 없었다.
   *   · `FPTextBox` → 타이핑 O / **아이콘 X** (모달이 있어도 사용자가 알 수 없다)
   *   · `FPModal`   → 아이콘 O / **타이핑 X**
   *
   * AS-IS 는 `TextCellType`(텍스트) 에 `BackgroundImage = ImagePopUp`(돋보기) 를 씌우고
   * `CellDoubleClick` 으로 팝업을 여는 방식이라 **둘 다** 가능했다
   * (`DMF0082_FcstNPrice_Mgmt.cs:404-407` 셀타입 정의 / `:2541` InsertRow 적용 / `:3772` 더블클릭).
   *
   * `FPTextModal` = ①은 **허용**, ②③은 `FPModal` 과 동일. 모달 식별자는 `ATTRIBUTE1`(모달키)에 둔다.
   */
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
