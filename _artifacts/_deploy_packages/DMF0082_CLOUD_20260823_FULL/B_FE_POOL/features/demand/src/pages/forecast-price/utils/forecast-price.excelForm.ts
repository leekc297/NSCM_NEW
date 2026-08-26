import type { RawFlexGridColumnConfig } from '@foundation/models';

/**
 * Excel Form(양식) 컬럼·행 생성 — 순수 함수.
 *
 * ⭐ 계약의 핵심은 **엑셀 1행 헤더 문자열**이다. BE(`FileServiceImpl.cvtListUploadRows`)가
 *   `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰명으로 헤더를 **이름 조회**하기 때문에:
 *     · 토큰 10 + M4~M16 은 **원형 그대로**여야 하고 (1바이트라도 다르면 그 열 전량 탈락)
 *     · HEADER_CONTENT 에 없는 정보성 컬럼은 그냥 무시되므로 자유롭게 덧붙일 수 있으며
 *     · 파일 내 컬럼 순서는 무관하다 (ATTRIBUTE 위치는 HEADER_CONTENT 순서가 결정)
 *   단 **헤더명 중복은 치명적**이다 — `ExcelUtils` 가 헤더를 HashMap 키로 쓰므로 뒤 컬럼이 앞을 덮는다.
 */

/** SHEET_COLUMNS colNm → 업로드 토큰 (HEADER_CONTENT 원형). 이 10개가 업로드 필수 컬럼이다. */
export const UPLOAD_TOKEN_BY_COL: Readonly<Record<string, string>> = {
  DIVISION_ID: 'Div',
  END_CUSTOMER: 'End Customer',
  SCM_SITE_ID: 'Sales Site',
  ITEM_ID: 'Model',
  INCOTERMS: 'Incoterms',
  FCST_TYPE: 'FCST Type',
  DOM_EXP: 'Customs Handbook',
  CELL_PROD_SITE_ID: 'Cell Prod Site',
  CURRENCY: 'Currency',
  MEASURE: 'Measure',
};

/** 월 값 컬럼 — 업로드 양식 고정(M4~M16).
 *  [E20260820-XLSFORM2] 기존 LOC 원장 값이 있으면 채워서 내려준다(2026-08-20 사용자 지시 —
 *  구 '값은 비워서(2026-08-13)' 역전. SP 가 M4~M16 컬럼으로 원장 대표값을 내려주고 여기서 그대로 싣는다). */
/** [E20260820-XLSWEEKLY] 기간 컬럼 = SP WEEK_LIST(주 시작일 CSV) 동적 — 고정 토큰 없음.
 *  파일 헤더 = 주 시작일 YYYYMMDD 원형(BE 1단 날짜헤더 인식 규격), 행 값 키 = SP W01~W26 슬롯. */
export const weekSlotKey = (idx: number): string => `W${String(idx + 1).padStart(2, '0')}`;

export interface ExcelFormColumn {
  /** 엑셀 1행 헤더 (= BE 매핑 키). 토큰이면 원형, 아니면 정보성 라벨. */
  header: string;
  /** 행 객체 접근 키 (= SP 커서 컬럼명 또는 'M4'..'M16') */
  key: string;
  /** 업로드 필수 토큰 여부 */
  isToken: boolean;
  /** 월 값 컬럼(입력칸) 여부 */
  isMonth: boolean;
}

/** SHEET_COLUMNS 라벨의 필수 표기 `*` 제거 — 엑셀 헤더에 `*` 가 붙으면 매핑이 깨진다. */
export const stripStar = (label: string): string => label.replace(/\s*\*+\s*$/, '').trim();

/** 이미 쓰인 헤더면 결정적으로 유일화한다 (`Team` 이 TEAM_ID/TEAM_NAME_KO 두 컬럼에 붙어 있는 실측 사례). */
export const dedupeHeader = (header: string, colNm: string, used: Set<string>): string => {
  if (!used.has(header)) return header;
  const withCol = `${header} (${colNm})`;
  if (!used.has(withCol)) return withCol;
  let n = 2;
  while (used.has(`${withCol}#${n}`)) n += 1;
  return `${withCol}#${n}`;
};

export interface StaticColumnLike {
  colNm: string;
  colLblNm?: string;
  display?: boolean;
  visible?: boolean;
}

/**
 * 양식 컬럼 = [정적 메타(표시 대상, 메타·개인화 순서 그대로)] + [M4~M16 빈칸]
 *
 * 토큰 컬럼은 라벨이 아니라 **토큰 문자열**을 헤더로 쓴다. 그래야 업로드가 그 열을 찾는다.
 */
export const buildExcelFormColumns = (
  staticColumns: readonly StaticColumnLike[],
  weekList: readonly string[] = []
): ExcelFormColumn[] => {
  const used = new Set<string>();
  const cols: ExcelFormColumn[] = [];

  staticColumns
    .filter(c => c.display !== false && c.visible !== false && !!c.colNm)
    .forEach(c => {
      const token = UPLOAD_TOKEN_BY_COL[c.colNm];
      const header = token ?? dedupeHeader(stripStar(c.colLblNm || c.colNm), c.colNm, used);
      if (used.has(header)) return; // 토큰 중복 등재 방지 (메타에 같은 토큰 컬럼이 2번 나오는 경우)
      used.add(header);
      cols.push({ header, key: c.colNm, isToken: !!token, isMonth: false });
    });

  weekList.forEach((wk, i) => {
    if (used.has(wk)) return;
    used.add(wk);
    // header = 주 시작일 원형(파일 헤더 그대로 업로드 해석 근거) / key = SP W 슬롯
    cols.push({ header: wk, key: weekSlotKey(i), isToken: true, isMonth: true });
  });

  return cols;
};

/** SP 커서 1행 (BE 는 값이 NULL 인 컬럼을 아예 내려주지 않으므로 키 부재를 전제한다). */
export type ExcelFormRow = Record<string, string | number | null | undefined>;

/** 엑셀 셀 값 — 월 컬럼 = SP 가 내려준 기존 LOC 원장 값(없으면 빈칸) [E20260820-XLSFORM2], 그 외는 SP 값 문자열. */
export const buildExcelFormRows = (
  rows: readonly ExcelFormRow[],
  columns: readonly ExcelFormColumn[]
): Record<string, string>[] =>
  rows.map(row => {
    const out: Record<string, string> = {};
    columns.forEach(col => {
      out[col.key] = String(row[col.key] ?? ''); // 월 컬럼도 SP 값 사용 (NULL 컬럼은 BE 가 생략 → '')
    });
    return out;
  });

/**
 * 미리보기 그리드 컬럼 — 다운로드 결과와 **1:1** 이어야 하므로 같은 목록에서 만든다.
 * ⚠ 콤보(cellCboDataTp)를 달지 않는다. SP 가 이미 업로드 검증이 기대하는 표기(명칭/코드)로 내려주므로,
 *   콤보 dataMap 을 태우면 코드가 아닌 값이 매핑에 실패해 화면과 엑셀이 어긋난다.
 */
export const toPreviewColumns = (
  columns: readonly ExcelFormColumn[],
  monthLabel: (token: string) => string
): RawFlexGridColumnConfig[] =>
  columns.map(col => ({
    colNm: col.key,
    colLblNm: col.isMonth ? monthLabel(col.header) : col.header,
    colWth: col.isMonth ? 90 : 120,
    horzAlgnCd: col.isMonth ? 'R' : 'L',
    visible: true,
    display: true,
    inputTpCd: 'S',
  })) as RawFlexGridColumnConfig[];

/** 결과커서 판정 — DMF0082 는 RESULT_CODE/RESULT_MSG, 일부 SP 는 CODE/MSG (겸용). */
export const pickResultCursor = (inner?: {
  CODE?: string;
  MSG?: string;
  RESULT_CODE?: string;
  RESULT_MSG?: string;
}): { ok: boolean; message?: string } => {
  if (!inner) return { ok: true };
  const code = inner.RESULT_CODE ?? inner.CODE;
  if (code === undefined || String(code) === '0') return { ok: true };
  return { ok: false, message: inner.RESULT_MSG || inner.MSG };
};
