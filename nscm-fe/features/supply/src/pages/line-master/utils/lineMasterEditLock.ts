// 셀 편집 가부는 SCM_MST_SHEET_COLUMNS.INPUT_TP_CD 메타(Packer: IM/M/O, 조회전용 S)로 판정한다 —
//   공통 DataGrid 의 isEditableCell 가 beginningEdit·pastingCell 을 가드하므로 코드측 화이트리스트는 두지 않는다.
//   (AS-IS SCP0002_LineMaster.cs Insert_Row/EditButton 편집규칙은 그 메타로 등가 재현.)

// Packer 신규행 기본값 — AS-IS Insert_Row(cs:565~567) defaultData 와 1:1:
//   DIVISION_ID=조회 사업부 / VALID_YN='Y' / RACK_YN='N' 만 설정. 그 외(SCM_SITE_ID·LINE 등)와
//   SCS_PROD_AMEND 는 AS-IS 가 기본값을 넣지 않으므로 blank 로 둔다(콤보 선택·입력·파생으로 채움).
//   주의: SCS_PROD_AMEND 를 'N' 으로 선채움하지 않는다 — AS-IS 미설정(저장 후 GET 의 NVL 로 'N' 표시).
export const packerInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  SCM_SITE_ID: '',
  SITE_DESCRIPTION: '',
  LINE_ID: '',
  LINE_NAME: '',
  VALID_YN: 'Y',
  OPERATION_ID: '',
  RACK_YN: 'N',
  SCS_PROD_AMEND: '',
});
