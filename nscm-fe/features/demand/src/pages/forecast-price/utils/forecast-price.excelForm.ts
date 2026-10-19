import type { RawFlexGridColumnConfig } from '@foundation/models';

/**
 * Excel Form(양식) 컬럼·행 생성 — 순수 함수.
 *
 * ⭐ [E20260921-XLSFORMASIS] 양식 컬럼은 **admin 메타 주도**다 (사용자 확정 2026-09-21).
 *   AS-IS `DMF0020_SalesPriceTemplatePopup` 이 `DMF0000_GET_COMMON_SPREAD_TITLE` 로
 *   `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID, SHEET_NAME='Sales Price Template', DIVISION_ID)를 읽어
 *   `CreateSheetHeaderColumn` 으로 헤더를 만드는 구조([PJ2024-50611])와 동일하게 맞춘 것이다.
 *   ⇒ 앞으로 양식 컬럼 변경은 **DB 메타만** 고치면 되고 이 파일은 손대지 않는다.
 *
 * ⭐ 계약의 핵심은 **엑셀 1행 헤더 문자열**이다. BE(`FileServiceImpl.cvtListUploadRows`)가
 *   `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰명으로 헤더를 **이름 조회**하기 때문에:
 *     · 헤더 문자열은 HEADER_CONTENT 토큰과 **1바이트도 달라선 안 된다** (다르면 그 열 전량 탈락)
 *     · HEADER_CONTENT 에 없는 컬럼은 그냥 무시된다
 *     · 파일 내 컬럼 순서는 무관하다 (ATTRIBUTE 위치는 HEADER_CONTENT 순서가 결정)
 *   단 **헤더명 중복은 치명적**이다 — `ExcelUtils` 가 헤더를 HashMap 키로 쓰므로 뒤 컬럼이 앞을 덮는다.
 *   메타의 `COLUMN_LABEL_NAME` 이 곧 토큰이므로, 메타와 HEADER_CONTENT 는 같은 회차에 맞춘다.
 */

/** admin UI Category Setup 시트명 — AS-IS DMF0020 원본명 그대로 (룰 #91 SHEET_NAME 불변). */
export const TEMPLATE_META_SHEET = 'Sales Price Template' as const;

/** 메타 미적재/조회 실패 시 폴백 — AS-IS DMF0020 `Sales Price Template` 19행 실측값(2026-09-21).
 *  ⚠ 폴백은 "화면이 빈 양식으로 깨지지 않게" 하는 안전망일 뿐 정본이 아니다.
 *     정본은 `SCM_MST_SHEET_COLUMNS`(DMF0082 / 'Sales Price Template') 19행이다. */
export const FALLBACK_TEMPLATE_COLUMNS: ReadonlyArray<{ key: string; header: string; width: number }> =
  [
    { key: 'DIVISION_ID', header: 'Div', width: 50 },
    { key: 'DEPT_NAME', header: 'Team', width: 180 },
    { key: 'END_CUSTOMER', header: 'End Customer', width: 150 },
    { key: 'PROJECT_CODE', header: 'Project Code', width: 100 },
    { key: 'CURRENCY', header: 'Currency', width: 80 },
    { key: 'ITEM_ID', header: 'Model', width: 150 },
  ];

const pad2 = (n: number): string => String(n).padStart(2, '0');

/** [E20260907-XLSMONTH / E20260921-XLSFORMASIS] 기간 컬럼 = 월 버킷 M0~M12 (13개월) — AS-IS DMF0020 파리티.
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
  /** 엑셀 1행 헤더 (= BE 매핑 키 = HEADER_CONTENT 토큰 원형 = 메타 COLUMN_LABEL_NAME). */
  header: string;
  /** 행 객체 접근 키 (= SP 커서 컬럼명 = 메타 COLUMN_NAME, 또는 'M0'..'M12') */
  key: string;
  /** 업로드 매핑 대상 여부 (메타에서 온 컬럼 + 월 컬럼 = true) */
  isToken: boolean;
  /** 월 값 컬럼(사용자 입력칸) 여부 */
  isMonth: boolean;
  /** 미리보기 그리드 폭 (메타 colWth). 없으면 기본값 사용. */
  width?: number;
}

/**
 * 양식 컬럼 = [admin 메타 컬럼(SHEET_NAME='Sales Price Template')] + [월 버킷 M0~M12]
 *
 * [E20260921-XLSFORMASIS] AS-IS DMF0020 파리티 — 양식 컬럼 정의의 **정본은 DB 메타**다.
 *   AS-IS 팝업이 `CreateSheetHeaderColumn(siMain, 1, GetSpdTitle(...))` 로 메타 헤더를 그리는 것과 동일.
 *   메타 19행에는 M0~M12 도 포함돼 있으므로, 월 컬럼은 **메타에 있으면 그것을 쓰고**
 *   없을 때만 `MONTH_TOKENS` 로 보충한다(메타 미적재 환경 방어).
 *
 * @param metaColumns admin `/admin/menu/DMF0082/column` (sheetNm='Sales Price Template') 응답.
 *                    비었으면 `FALLBACK_TEMPLATE_COLUMNS` + `MONTH_TOKENS` 로 폴백한다.
 */
const isMonthToken = (name: string): boolean => /^M(?:[0-9]|1[0-2])$/.test(name);

export const buildExcelFormColumns = (
  metaColumns?: readonly RawFlexGridColumnConfig[] | null
): ExcelFormColumn[] => {
  const meta = (metaColumns ?? []).filter(m => (m.colNm ?? '') !== '' && m.visible !== false);

  if (meta.length > 0) {
    const cols: ExcelFormColumn[] = meta.map(m => {
      const key = String(m.colNm);
      // 헤더 = 메타 라벨(= HEADER_CONTENT 토큰). 라벨 미설정 시에만 컬럼명으로 대체한다.
      const header = String(m.colLblNm ?? '').trim() !== '' ? String(m.colLblNm) : key;
      return { header, key, isToken: true, isMonth: isMonthToken(key), width: m.colWth };
    });
    // 메타에 월 컬럼이 하나도 없으면 보충 (구 메타 세대 방어)
    if (!cols.some(c => c.isMonth)) {
      MONTH_TOKENS.forEach(tok =>
        cols.push({ header: tok, key: tok, isToken: true, isMonth: true, width: 40 })
      );
    }
    return cols;
  }

  // 폴백 — 메타 미적재/조회 실패
  const cols: ExcelFormColumn[] = FALLBACK_TEMPLATE_COLUMNS.map(c => ({
    header: c.header,
    key: c.key,
    isToken: true,
    isMonth: false,
    width: c.width,
  }));
  MONTH_TOKENS.forEach(tok =>
    cols.push({ header: tok, key: tok, isToken: true, isMonth: true, width: 40 })
  );
  return cols;
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
    // [E20260921-XLSFORMASIS] 폭도 admin 메타(colWth) 를 따른다 — 없을 때만 종전 기본값.
    colWth: col.width ?? (col.isMonth ? 90 : 120),
    horzAlgnCd: col.isMonth ? 'R' : 'L',
    visible: true,
    display: true,
    inputTpCd: 'S',
  })) as RawFlexGridColumnConfig[];

/** [E20260825-XLSPRJ] 데이터 미존재 정보성 컬럼 숨김 (사용자 지시 2026-08-25).
 *  전 행이 빈값(null/''/공백)인 컬럼은 그리드·다운로드 모두에서 제외한다 — 단
 *  업로드 계약 컬럼은 값과 무관하게 보존한다(BE 이름 매핑 필수 축).
 *  조회 전(rows 없음)에는 판정 근거가 없으므로 전체 유지(양식 미리보기 헤더 보존).
 *
 *  ⚠ [E20260921-XLSFORMASIS] 메타 주도 전환 후 양식 컬럼은 **전부 업로드 계약 컬럼**(isToken=true)이라
 *     이 함수는 사실상 no-op 이다. AS-IS 파리티상 양식에 정보성 컬럼이 없기 때문이다.
 *     메타에 정보성 컬럼(HEADER_CONTENT 에 없는 라벨)이 추가되면 그때 다시 유효해진다 — 그래서 남겨 둔다. */
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
