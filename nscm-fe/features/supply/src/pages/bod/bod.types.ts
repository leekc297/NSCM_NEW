export interface SearchParamProps {
  divisionId: string;
  fromSite: string;
  toSite: string;
  incoterms: string;
  incotermsSsp: string;
  transMode: string;
  inputStatus: string;
  validYn: string;
}

/**
 * 저장 실패 결과 행 — SP P_SCP0007_SAVE_BOD 의 O_RESULT_CURSOR(RESULT_CODE='F') 1행.
 * AS-IS SaveData_Main 저장검증 오류(99010~99040) 시 위반 행 식별자 + 오류코드/메시지를 반환한다.
 * 이 값으로 (1) 오류 메시지 표출(MSG00043), (2) 매칭 행 컬럼 배경 강조(BodGrid formatItem)한다.
 */
export interface BodSaveErrorRow {
  RESULT_CODE?: string;
  CODE?: string;
  MSG?: string;
  ERR_CODE?: string;
  ERR_MESSAGE?: string;
  DIVISION_ID?: string;
  FROM_SITE_CODE?: string;
  TO_SITE_CODE?: string;
  INCOTERMS?: string;
  PRIORITY?: string;
  [key: string]: string | undefined;
}
