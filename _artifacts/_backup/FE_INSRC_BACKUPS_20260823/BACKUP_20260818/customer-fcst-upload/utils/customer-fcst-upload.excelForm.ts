import type { RawFlexGridColumnConfig } from '@foundation/models';

/**
 * DMF0014 Excel Form(양식) 컬럼·행 생성 — 순수 함수.
 *
 * 표준 = hook #135 `excel-form-upload-standard` (정본 DMF0082 `forecast-price.excelForm.ts`).
 *
 * ⭐ 계약의 핵심은 **엑셀 1행 헤더 문자열**이다. BE(`FileServiceImpl.cvtListUploadRows`)가
 *   `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 토큰명으로 헤더를 **이름 조회**하기 때문:
 *     · 토큰은 **원형 그대로** — 1바이트라도 다르면 그 열 전량 탈락(무증상 유실)
 *     · HEADER_CONTENT 에 없는 정보성 컬럼은 무시되므로 자유롭게 덧붙일 수 있고
 *     · 파일 내 컬럼 순서는 무관(ATTRIBUTE 위치는 HEADER_CONTENT 순서가 결정)
 *     · **헤더명 중복은 치명적** — `ExcelUtils` 가 헤더를 HashMap 키로 써서 뒤가 앞을 덮는다
 *
 * ⚠️ DMF0082 와 다른 점 2가지 (사내 메타 실측 2026-08-14 — 화면 간 일반화 금지, hook #135 §4-2):
 *   ① **토큰에 `*` 가 포함**된다 (`Division*`/`Sales Site*` …). DMF0082 토큰(`Div`/`Model`)은 `*` 가
 *      없어 라벨에서 떼야 했지만, DMF0014 토큰은 SHEET_COLUMNS 라벨과 **문자 그대로 동일**하다.
 *      ⇒ `stripStar` 를 적용하면 오히려 매핑이 깨진다.
 *   ② 값 컬럼이 월(M4~M16)이 아니라 **주차 고정 문자열 `W27~W31`** 이다.
 *      상대 주차로 바꾸면 HEADER_CONTENT·업로드 SP 동반 변경 + 기존 업로드 파일 호환이 깨지므로
 *      **현행 유지**(사용자 A안 확정 2026-08-14).
 */

/** SHEET_COLUMNS colNm → 업로드 토큰 (HEADER_CONTENT 원형, ATTRIBUTE1~13 과 1:1 순서). */
export const UPLOAD_TOKEN_BY_COL: Readonly<Record<string, string>> = {
  DIVISION_ID: 'Division*',
  SCM_SITE_ID: 'Sales Site*',
  PLANT_SITE_ID: 'Plant Site*',
  CUSTOMER_PROJECT_CODE: 'Customer Project*',
  CUSTOMER_MODEL: 'Customer Model*',
  INCOTERMS: 'Incoterms*',
  FCST_TYPE: 'FCST Type*',
  DOM_EXP: 'Customs Handbook*',
  MEASURE_GROUP: 'Measure Group*',
  MEASURE: 'Measure*',
  UPLOAD_UOM: 'Upload UOM*',
  PROJECT_CODE: 'Project',
  ITEM_ID: 'Model',
};

/**
 * ⭐ 값 입력 컬럼 — **조회구간의 실제 버킷 수만큼 동적 생성**한다 (사용자 지시 2026-08-14:
 *   "조회조건 기본구간을 기준으로 26주로 EXCEL FORM 생성").
 *
 * ⛔ 구 방식(`W27~W31` 5칸 고정)의 오류: 기본구간(6개월)은 **26주**인데 5주만 담겼다.
 *
 * ⭐ **1단 헤더**(사용자 지시 2026-08-14). 값 컬럼의 헤더는 `W27` 같은 토큰이 아니라
 *   **버킷 시작일 `YYYYMMDD` 그 자체**다. 업로드 SP 는 타이틀행(V_TITLE)의 `ATTRIBUTE14~` 에서
 *   버킷을 읽으므로, 날짜가 헤더에 실리면 별도 일자행(2단) 없이 그대로 성립한다.
 *   BE `cvtListUploadRows` 도 1단 분기에서 `^\d{8}$` 헤더를 기간 컬럼으로 인식하도록 맞췄다.
 *
 * ⚠️ 그래서 `HEADER_CONTENT` 의 기간 토큰(`W27~W31`)은 **더 이상 쓰지 않는다**. 파일에 없으므로
 *   BE 가 자동 제외한다(stale 토큰을 그대로 실으면 빈 컬럼이 끼어 ATTRIBUTE 위치가 밀린다).
 *   식별 컬럼 13종의 토큰 계약은 그대로 유효하다.
 *
 * 슬롯 상한 = `ATTRIBUTE14~200` = 187 (업로드 SP UNPIVOT 실측). 초과분은 **조용히 버리지 않고**
 * 호출부가 경고한다.
 */
export const MAX_VALUE_SLOTS = 187;

/**
 * ⭐ 값 칸 배경색 — **미리보기와 다운로드 파일이 같은 색**이어야 한다(단일 원천).
 * `CustomerFcstTemplateModal.module.scss` 의 `.uploadableCell` / `.blockedCell` 과 값을 맞춘다.
 * 색이 갈리면 화면에서 노랑이던 칸이 파일에서 회색으로 보여 사용자가 입력 위치를 잘못 읽는다.
 */
export const EXCEL_FILL = {
  /** 입력 가능 — DMF0007 이 VALID_YN='Y' 로 표기한 주차 */
  UPLOADABLE: '#FFFBE6',
  /** 입력 불가 — 해당 기간의 기준데이터 없음 */
  BLOCKED: '#F2F3F5',
} as const;

/**
 * SP `PERIOD_BUCKETS`(조회구간 버킷 일자 전량, 콤마 구분) → 배열.
 * 모든 행이 동일 값이므로 첫 행에서 읽는다.
 */
export const extractPeriodBuckets = (rows: readonly ExcelFormRow[]): string[] => {
  const raw = String(rows[0]?.['PERIOD_BUCKETS'] ?? '').trim();
  if (!raw) return [];
  return raw
    .split(',')
    .map(v => v.trim())
    .filter(Boolean);
};

export interface ExcelFormColumn {
  /** 엑셀 1행 헤더 (= BE 매핑 키). 토큰이면 원형, 아니면 정보성 라벨. */
  header: string;
  /** 행 객체 접근 키 (= SP 커서 컬럼명 또는 'W27'..'W31') */
  key: string;
  /** 업로드 필수 토큰 여부 */
  isToken: boolean;
  /** 값 입력 컬럼 여부 */
  isValueSlot: boolean;
  /** 값 컬럼일 때 이 슬롯이 가리키는 실제 버킷 일자(`YYYYMMDD`). 일자행에 이 값을 찍는다. */
  bucket?: string;
}

/** 이미 쓰인 헤더면 결정적으로 유일화한다 (헤더 중복 = HashMap 키 충돌). */
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
 * 양식 컬럼 = [정적 메타(표시 대상, 메타 순서 그대로)] + [W27~W31 빈칸]
 *
 * 토큰 컬럼은 라벨이 아니라 **토큰 문자열**을 헤더로 쓴다(그래야 업로드가 그 열을 찾는다).
 * DMF0014 는 토큰과 라벨이 같지만, 라벨이 바뀌어도 업로드가 깨지지 않도록 **토큰을 우선**한다.
 */
export const buildExcelFormColumns = (
  staticColumns: readonly StaticColumnLike[],
  periodBuckets: readonly string[] = []
): ExcelFormColumn[] => {
  const used = new Set<string>();
  const cols: ExcelFormColumn[] = [];

  staticColumns
    .filter(c => c.display !== false && c.visible !== false && !!c.colNm)
    .forEach(c => {
      const token = UPLOAD_TOKEN_BY_COL[c.colNm];
      const header = token ?? dedupeHeader((c.colLblNm || c.colNm).trim(), c.colNm, used);
      if (used.has(header)) return; // 같은 토큰 컬럼이 메타에 2번 나오는 경우 방지
      used.add(header);
      cols.push({ header, key: c.colNm, isToken: !!token, isValueSlot: false });
    });

  // ⭐ 값 슬롯 = 조회구간 버킷 수만큼. **헤더 = 버킷 일자 그 자체**(1단 헤더).
  periodBuckets.slice(0, MAX_VALUE_SLOTS).forEach(bucket => {
    if (used.has(bucket)) return;
    used.add(bucket);
    cols.push({ header: bucket, key: bucket, isToken: true, isValueSlot: true, bucket });
  });

  return cols;
};

/** SP 커서 1행 (BE 는 값이 NULL 인 컬럼을 아예 내려주지 않으므로 키 부재를 전제한다). */
export type ExcelFormRow = Record<string, string | number | null | undefined>;

/**
 * 엑셀 셀 값 — **1단 헤더**라 데이터행만 내려간다(일자행 없음 — 날짜는 헤더가 싣는다).
 * 값 입력 컬럼은 항상 빈칸(입력 전용 — hook #135 §3-4).
 */
export const buildExcelFormRows = (
  rows: readonly ExcelFormRow[],
  columns: readonly ExcelFormColumn[]
): Record<string, string>[] =>
  rows.map(row => {
    const out: Record<string, string> = {};
    columns.forEach(col => {
      out[col.key] = col.isValueSlot ? '' : String(row[col.key] ?? '');
    });
    return out;
  });

/**
 * 미리보기 그리드 컬럼 — 다운로드 결과와 **1:1** 이어야 하므로 같은 목록에서 만든다.
 * ⚠ 콤보(cellCboDataTp)를 달지 않는다. SP 가 이미 업로드 검증이 기대하는 표기로 내려주므로
 *   dataMap 을 태우면 화면과 엑셀이 어긋난다 (hook #135 §3-3).
 */
export const toPreviewColumns = (columns: readonly ExcelFormColumn[]): RawFlexGridColumnConfig[] =>
  columns.map(col => ({
    colNm: col.key,
    // 값 슬롯은 토큰만으로는 어느 주차인지 알 수 없으므로 미리보기에서만 일자를 덧붙인다.
    // ⚠ 엑셀 헤더는 **토큰 원형**이어야 하므로 여기 라벨을 다운로드에 쓰면 안 된다(handleExcel 은 header 사용).
    colLblNm:
      col.isValueSlot && col.bucket
        ? `${col.header} (${col.bucket.slice(4, 6)}/${col.bucket.slice(6, 8)})`
        : col.header,
    colWth: col.isValueSlot ? 90 : 130,
    horzAlgnCd: col.isValueSlot ? 'R' : 'L',
    visible: true,
    display: true,
    inputTpCd: 'S',
  })) as RawFlexGridColumnConfig[];

/**
 * ⭐ 업로드 가능 주차 판정 (사용자 요구 2026-08-14 — "DMF0007 에서 Y 로 표기한 부분만 COLORING").
 *
 * Form SP 가 행마다 `UPLOAD_VALID_WEEKS`(= DMF0007 `VALID_YN='Y'` 버킷 일자)를 콤마로 내려준다.
 * 1단 헤더에서는 컬럼 키가 곧 버킷 일자이므로 **환산 없이 그대로 대조**한다.
 *
 * ⭐ 구 ISO 주차 환산(A안)은 폐기했다 — 토큰이 아니라 일자가 헤더가 된 뒤로 환산 자체가 불필요하고,
 *   ISO 환산은 연말·연초 경계에서 어긋날 위험만 남는다. 여기 없는 버킷 = **입력 불가**.
 */
export const uploadableWeekTokens = (row: ExcelFormRow | undefined): Set<string> => {
  const raw = String(row?.['UPLOAD_VALID_WEEKS'] ?? '').trim();
  const out = new Set<string>();
  if (!raw) return out;
  raw.split(',').forEach(v => {
    const b = v.trim();
    if (b) out.add(b);
  });
  return out;
};

/** 결과커서 판정 — RESULT_CODE/RESULT_MSG 우선, 일부 SP 는 CODE/MSG (겸용). */
export const pickResultCursor = (
  inner?: { CODE?: string; MSG?: string; RESULT_CODE?: string; RESULT_MSG?: string }
): { ok: boolean; message?: string } => {
  if (!inner) return { ok: true };
  const code = inner.RESULT_CODE ?? inner.CODE;
  if (code === undefined || String(code) === '0') return { ok: true };
  return { ok: false, message: inner.RESULT_MSG || inner.MSG };
};
