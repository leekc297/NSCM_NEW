import type { CalendarRow } from '../capa.types';

/**
 * GAP-04/05 Excel Upload/Form Download — AS-IS `btnExcelUpload_Click`(cs:2603)
 * `ExcelUploadForm("SCP0049", "CAPA")` / `btnExcelFormDownload_Click`(cs:2628) `FindData_Excel_DownLoad`.
 *
 * TO-BE BE 는 공용 FileController(`/{mnuId}/{shtNm}/{mnuBtnCd}/excel-upload`) + 이미 배포된
 * `PKG_SCP0049.P_CAPA_EXCEL_UPLOAD`(ora.py 실측 — SCM_ADM_EXCEL_COLUMNS PROGRAM_ID='SCP0049'
 * SHEET_NAME='CAPA' 행 존재, STORAGE_SQL_ID=PKG_SCP0049.P_CAPA_EXCEL_UPLOAD, VALID_YN='Y')를 쓴다.
 * HEADER_CONTENT 15 토큰(SCM_ADM_EXCEL_COLUMNS 실측)은 식별 컬럼이고, 동적 기간 컬럼은
 * `cvtListUploadRows`(FileServiceImpl)의 titleDateRow 휴리스틱을 탄다 — 업로드 파일의 첫 데이터행에서
 * 식별 컬럼(Div)이 공란이고 기간 컬럼에 값이 있으면 그 행을 "날짜 행"으로 보고, `P_CAPA_EXCEL_UPLOAD`
 * body 는 그 날짜 행 ATTRIBUTE16.. 을 UNPIVOT 해 YYYYMMDD 로 읽는다(ora.py USER_SOURCE 실측).
 * 그래서 다운로드 파일에도 같은 날짜 행을 심어야 재업로드가 가능하다(라운드트립).
 */
export const EXCEL_FORM_HEADER_TOKENS = [
  'Div',
  'Company',
  'Site',
  'Plant',
  'Factory',
  'Line*',
  'Operation*',
  'Line Type*',
  'Group',
  'Level 1*',
  'Level 2*',
  'Material *',
  'Lane*',
  'Finish*',
  'UOM',
] as const;

/** 식별 토큰 → CAPA EXCEL 커서(searchType='EXCEL') 필드명 매핑(SCM_MST_SHEET_COLUMNS SHEET_NAME='CAPA EXCEL' 실측). */
const TOKEN_FIELD: Record<string, string> = {
  Div: 'DIVISION_ID',
  Company: 'COMPANY_ID',
  Site: 'SITE_ID',
  Plant: 'PLANT_ID',
  Factory: 'FACTORY_ID',
  'Line*': 'LINE_ID',
  'Operation*': 'OPERATION_ID',
  'Line Type*': 'ELECTRODE_TYPE',
  Group: 'OPERATION_GROUP_NAME',
  'Level 1*': 'CATEGORY_ID',
  'Level 2*': 'KEY_ID',
  'Material *': 'ITEM_ID',
  'Lane*': 'LANE_QTY',
  'Finish*': 'CONFIRM_FLAG',
  UOM: 'UOM',
};

/** CAPA EXCEL 커서 1행(동적 기간칼럼은 인덱스 시그니처). */
export type CapaExcelRow = Record<string, string | number | undefined> & {
  DIVISION_ID?: string;
};

/** 캘린더 커서(D_yyyymmdd/M_yyyymm) → 기간 컬럼 키 + 타이틀행용 YYYYMMDD(월은 1일로 대표). */
export const buildDayColumns = (
  calendar: CalendarRow[]
): { key: string; header: string; yyyymmdd: string }[] =>
  calendar.map(c => {
    const digits = c.COLUMN_NAME.replace(/^[A-Z]_/, '');
    const yyyymmdd = digits.length >= 8 ? digits.slice(0, 8) : `${digits.slice(0, 6)}01`;
    return { key: c.COLUMN_NAME, header: c.COLUMN_LABEL_NAME || c.COLUMN_NAME, yyyymmdd };
  });

export const buildExcelFormColumns = (
  dayColumns: { key: string; header: string }[]
): { header: string; key: string }[] => [
  ...EXCEL_FORM_HEADER_TOKENS.map(token => ({ header: token, key: token })),
  ...dayColumns.map(d => ({ header: d.header, key: d.key })),
];

/** 숨은 날짜 행(@TITLE 판별용) — 식별 컬럼 공란 + 기간 컬럼 = YYYYMMDD(FileServiceImpl titleDateRow 계약). */
export const buildExcelTitleRow = (
  dayColumns: { key: string; yyyymmdd: string }[]
): Record<string, string> => {
  const row: Record<string, string> = {};
  EXCEL_FORM_HEADER_TOKENS.forEach(token => {
    row[token] = '';
  });
  dayColumns.forEach(d => {
    row[d.key] = d.yyyymmdd;
  });
  return row;
};

export const buildExcelDataRows = (
  rows: CapaExcelRow[],
  dayColumns: { key: string }[]
): Record<string, string | number>[] =>
  rows.map(r => {
    const out: Record<string, string | number> = {};
    EXCEL_FORM_HEADER_TOKENS.forEach(token => {
      out[token] = r[TOKEN_FIELD[token]] ?? '';
    });
    dayColumns.forEach(d => {
      out[d.key] = r[d.key] ?? '';
    });
    return out;
  });
