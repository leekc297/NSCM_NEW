/** CRUD 흐름에서 공통으로 사용하는 메시지 정의입니다. */
export const CRUD_MSG = {
  SAVE_CONFIRM: { id: 'MSG00001', fallback: '_저장하시겠습니까?' },
  SAVED: { id: 'MSG00002', fallback: '_성공적으로 저장되었습니다!' },
  NO_CHANGES: { id: 'MSG00004', fallback: '_수정한 내용이 없습니다.' },
  REQUIRED_INPUT: { id: 'MSG00013', fallback: '_필수값을 입력하세요.' },
  DUPLICATE: { id: 'MSG00043', fallback: '_저장시 중복 오류가 발생하였습니다.' },
  REQUIRED_FIELD: { id: 'MSG00429', fallback: '_{0} 값은 필수 입력 항목입니다.' },
  REQUIRED_COLUMN: { id: 'MSG00113', fallback: '_필수 입력 컬럼이 없습니다.' },
  SAVE_FAIL: { id: 'MSG00003', fallback: '_저장에 실패하였습니다.' },
  SAVE_ERROR: { id: 'MSG00618', fallback: '_저장 중 오류가 발생했습니다.' },
  NO_SAVE_TARGET: { id: 'MSG00676', fallback: '_저장할 대상 데이터가 없습니다.' },
  SAVED_COUNT: { id: 'MSG00672', fallback: '_{0}개의 데이터가 저장되었습니다.' },
} as const;
