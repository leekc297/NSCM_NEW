import type { RawFlexGridColumnConfig } from '@foundation/models';

/** Excel Form은 Sales Price Template 메타의 순서·헤더·폭을 그대로 사용한다.
 * 헤더는 서버 업로드 매핑 키이므로 번역하거나 별도 토큰명으로 치환하지 않는다. */

const pad2 = (n: number): string => String(n).padStart(2, '0');

/** [E20260907-XLSMONTH] 기간 컬럼 = 월 버킷 M0~M12 (13개월). 사용자 지시 2026-09-07 — AS-IS DMF0020 파리티.
 *  ⭐ 파일 헤더는 반드시 'M0'..'M12' 원형이어야 한다. 업로드 저장(PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA)이
 *  SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT('...|M0|..|M12')로 이 토큰을 ATTRIBUTE 슬롯에 위치 매핑하고,
 *  월 창(당월 ~ 당월+12)의 달에 M0→당월 ... M12→당월+12 를 붙여 원장에 적재한다 (AS-IS DMF0020 규약).
 *  구 주간(WEEK_LIST 날짜 헤더) 방식은 이 토큰 매핑을 깨 업로드가 NO_TARGET_ROW 로 실패했다(2026-08-20 회귀).
 *  주의: 배포된 DMF0082 저장 SP 가 M4~M16(당월+4~+16) 세대이면 이 M0~M12 도 매핑이 어긋나므로
 *        저장 SP·HEADER_CONTENT 를 M0~M12 로 함께 배포해야 한다 (라이브 업로드로 확인). */
export const MONTH_SLOT_COUNT = 13; // M0 ~ M12
export const MONTH_TOKENS: readonly string[] = Array.from(
  { length: MONTH_SLOT_COUNT },
  (_, i) => `M${i}`
);

/** 월 토큰('M0'..'M12') → 실제 월 라벨 'YYYY-MM'. 저장 SP 의 창(당월+n)과 동일 규약:
 *  M{n} = 당월 기준 +n 개월 (M0 = 당월 ... M12 = 당월+12). SYSDATE 와 하루 경계 차이는 무시(AS-IS 동일). */
export const monthTokenLabel = (token: string, today: Date = new Date()): string => {
  const m = /^M(\d+)$/.exec(token);
  if (!m) return token;
  const off = Number(m[1]);
  const d = new Date(today.getFullYear(), today.getMonth() + off, 1);
  return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}`;
};

export interface ExcelFormColumn {
  /** 엑셀 1행 헤더 (= BE 매핑 키). 토큰이면 원형, 아니면 정보성 라벨. */
  header: string;
  width?: number;
  align?: 'L' | 'R' | 'C';
  /** 행 객체 접근 키 (= SP 커서 컬럼명 또는 'M0'..'M12') */
  key: string;
  /** 업로드 필수 토큰 여부 */
  isToken: boolean;
  /** 월 값 컬럼(입력칸) 여부 */
  isMonth: boolean;
}

/** 메타 미등록/조회 실패 시 사용할 DB 보완본과 동일한 19컬럼 양식. */
export const FALLBACK_TEMPLATE_COLUMNS: readonly RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div', colWth: 50 },
  { colNm: 'DEPT_NAME', colLblNm: 'Team', colWth: 180 },
  { colNm: 'END_CUSTOMER', colLblNm: 'End Customer', colWth: 150 },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code', colWth: 100 },
  { colNm: 'CURRENCY', colLblNm: 'Currency', colWth: 80 },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 150 },
  ...MONTH_TOKENS.map(token => ({ colNm: token, colLblNm: token, colWth: 40 })),
];

export const buildExcelFormColumns = (
  metaColumns: readonly RawFlexGridColumnConfig[] = []
): ExcelFormColumn[] => {
  const source = metaColumns.length ? metaColumns : FALLBACK_TEMPLATE_COLUMNS;
  return source
    .filter(col => col.visible !== false && col.display !== false)
    .map(col => ({
      key: col.colNm,
      header: col.colLblNm || col.colNm,
      width: col.colWth,
      align: col.horzAlgnCd,
      isToken: true,
      isMonth: /^M\d+$/.test(col.colNm),
    }));
};

/** SP 커서 1행 (BE 는 값이 NULL 인 컬럼을 아예 내려주지 않으므로 키 부재를 전제한다). */
export type ExcelFormRow = Record<string, string | number | null | undefined>;

/** 엑셀 셀 값 — [E20260907-XLSMONTH] 월(버킷) 컬럼은 항상 빈칸(사용자 입력용 · AS-IS DMF0020 파리티),
 *  그 외 토큰·정보성 컬럼은 SP 값 문자열. (구 [E20260820-XLSFORM2] LOC 원장 채움 역전.) */
export const buildExcelFormRows = (
  rows: readonly ExcelFormRow[],
  columns: readonly ExcelFormColumn[]
): Record<string, string>[] =>
  rows.map(row => {
    const out: Record<string, string> = {};
    columns.forEach(col => {
      out[col.key] = col.isMonth ? '' : String(row[col.key] ?? '');
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
    colWth: col.width ?? (col.isMonth ? 90 : 120),
    horzAlgnCd: col.align ?? (col.isMonth ? 'R' : 'L'),
    visible: true,
    display: true,
    inputTpCd: 'S',
  })) as RawFlexGridColumnConfig[];

/** [E20260825-XLSPRJ] 데이터 미존재 정보성 컬럼 숨김 (사용자 지시 2026-08-25).
 *  전 행이 빈값(null/''/공백)인 컬럼은 그리드·다운로드 모두에서 제외한다 — 단
 *  업로드 계약 컬럼(토큰 10 + 주차)은 값과 무관하게 보존한다(BE 이름 매핑 필수 축).
 *  조회 전(rows 없음)에는 판정 근거가 없으므로 전체 유지(양식 미리보기 헤더 보존). */
export const pruneEmptyInfoColumns = (
  columns: readonly ExcelFormColumn[],
  rows: readonly ExcelFormRow[]
): ExcelFormColumn[] => {
  if (rows.length === 0) return [...columns];
  return columns.filter(
    col => col.isToken || col.isMonth || rows.some(r => String(r[col.key] ?? '').trim() !== '')
  );
};

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
