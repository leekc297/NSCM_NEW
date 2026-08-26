import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID } from '../forecast-price.constants';

// titleSet(SCM_MST_TITLESET_USER) 저장 시트명 — PKG_DMF0082 L603 실측('fcstNPrice').
export const TITLESET_SHEET = 'FcstNPrice';

/** titleSet 영구 저장 (SCM0002_SET_TITLESET_POPUP — DMF0003/0048 선례. 'C'=Column / 'M'=Measure). */
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: {
    name: string;
    sortOrderNo?: number;
    // ⭐ 컬럼 개인화 확장분 (SCM_MST_TITLESET_USER 3컬럼) — Measure('M') 저장 시엔 미전달.
    colWidth?: number;
    cellColor?: string;
    textColor?: string;
  }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: TITLESET_SHEET,
      columnType,
      activeFlag: saveRows.map(() => 'Y').join('^'),
      columnName: saveRows.map(r => r.name).join('^'),
      sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo ?? i + 1)).join('^'),
      subTotalFlag: saveRows.map(() => 'N').join('^'),
      sortMethodCode: saveRows.map(() => 'ASC').join('^'),
      // ⭐ 2026-07-27 BE 확장 — 폭/셀색/글자색 영구 저장. 다른 인자와 동일한 '^' 다건 규약.
      //   ⚠️ 키 이름은 PROC_M COL_NM(SP IN 파라미터) 과 정확히 일치해야 한다.
      columnWidth: saveRows.map(r => String(r.colWidth ?? '')).join('^'),
      cellColor: saveRows.map(r => r.cellColor ?? '').join('^'),
      textColor: saveRows.map(r => r.textColor ?? '').join('^'),
    };
    const res = await apiClient.post<{ CODE?: string }[]>(
      `/${MENU_ID}/titleSet/SAVE/call-proc`,
      payload
    );
    // ⚠️ HTTP/envelope 먼저 판정 — 구 구현은 결과 행이 없으면(`!row`) 무조건 성공으로 봐서,
    //   SP 미배선·no-op 을 '저장 성공' 으로 보고했다(2026-07-27). mkt-fcst/sales-monitoring 과 동일 판정.
    if (res.status >= 400 || Number((res.data as { code?: string }).code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};

/** Excel Form 조회 행 — P_DMF0082_GET_EXCEL_UPLOAD_DATA 커서 공용 (BE 는 NULL 값 컬럼을 생략한다). */
export type UploadPreviewRow = Record<string, string | number | null>;

/**
 * Excel Form 조회 — [E20260813-EXCELFORM] `PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA`.
 *
 * ⭐ 종전(UPLOAD_DATA)은 **본인 최종 업로드분**을 되돌려 보는 조회였다. 신 계약은 그 반대로
 *   **화면 조회조건에 걸린 현재 데이터 전체**를 양식으로 내려준다 (사용자 요구 2026-08-13).
 *   - 파라미터 = 메인 조회(FcstNPrice)와 **동일 축·동일 이름** → store 의 filters 를 가공 없이 그대로 전달
 *   - 1행 = (키 조합) × (입력 가능 measure 1종). measure 는 화면 개인화(titleset)와 무관
 *   - 월 값(M4~M16)은 SP 가 내리지 않는다 — 빈칸 입력용으로 FE 가 생성
 *   - 각 값은 **업로드 검증 SP 가 기대하는 표기**(End Customer/FCST Type/Cell Prod Site/Measure = 명칭,
 *     그 외 = 코드)로 이미 변환돼 온다. 따라서 FE 는 콤보 변환을 하지 않는다.
 *   - `FORM_WARN` = 마스터 결핍으로 업로드가 거부될 행 예고 (EC/CELL_PROD_SITE/INCOTERMS)
 * ⚠ BE 는 값이 NULL 인 컬럼을 응답에서 생략하므로 소비 시 키 부재를 전제할 것.
 */
export const fetchExcelFormData = async (
  filters: Record<string, unknown>
): Promise<{
  ok: boolean;
  message?: string;
  /** o_rc1 — 양식 행 (조회조건에 걸린 키 × 입력 가능 measure) */
  pivot: UploadPreviewRow[];
  /** [E20260820-XLSWEEKLY] o_result_cursor.WEEK_LIST — 주 시작일(YYYYMMDD) CSV → 배열 */
  weekList: string[];
}> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/FcstNPrice/FORM_DATA/call-proc`,
      { ...filters, sesUserId }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    const result = (res.data?.result ?? {}) as {
      o_rc1?: UploadPreviewRow[];
      o_result_cursor?: {
        CODE?: string;
        MSG?: string;
        RESULT_CODE?: string;
        RESULT_MSG?: string;
      }[];
    };
    // 결과커서 CODE 이름 판정 (RESULT_CODE/CODE 겸용 — UPLOAD_SAVE 와 동일 규약)
    const inner = result.o_result_cursor?.[0];
    const innerCode = inner?.RESULT_CODE ?? inner?.CODE;
    if (res.status >= 400 || code || (innerCode !== undefined && String(innerCode) !== '0')) {
      return {
        ok: false,
        message: inner?.RESULT_MSG || inner?.MSG || (res.data as { message?: string })?.message,
        pivot: [],
        weekList: [],
      };
    }
    // WEEK_LIST 는 커서 컬럼이라 정적 타입이 없다. unknown 을 그대로 String() 에 넣으면
    //   no-base-to-string 에 걸리므로 원시값으로 좁힌 뒤 변환한다.
    const weekRaw = (inner as { WEEK_LIST?: unknown } | undefined)?.WEEK_LIST;
    const weekCsv =
      typeof weekRaw === 'string' || typeof weekRaw === 'number' ? String(weekRaw) : '';
    return {
      ok: true,
      pivot: result.o_rc1 ?? [],
      weekList: weekCsv ? weekCsv.split(',').filter(w => /^\d{8}$/.test(w)) : [],
    };
  } catch (e) {
    return {
      ok: false,
      message: e instanceof Error ? e.message : undefined,
      pivot: [],
      weekList: [],
    };
  }
};

/**
 * Excel 업로드 확정 저장 (2-Step OK — DMF0082_EXCEL_UPLOAD mode=1, DMF0074 P_MODE 패턴 1:1).
 * 반환 { ok, message } — FcstUploadModal onSave 계약.
 */
export const saveExcelUpload = async (): Promise<{ ok: boolean; message?: string }> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/FcstNPrice/UPLOAD_SAVE/call-proc`,
      // [5ARG 2026-08-12] validProc 공통 계약(Excel.xml) 확장분 명시 전달 — PROC_M positional 매핑
      { mode: 1, createdBy: sesUserId, programId: 'DMF0082', sheetName: 'FcstNPrice' }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    // [2026-08-12] DMF0082 표준 결과 커서 키 = RESULT_CODE/RESULT_MSG (실측) — CODE/MSG 겸용 판정
    const inner = (
      res.data?.result as {
        o_result_cursor?: {
          CODE?: string;
          MSG?: string;
          RESULT_CODE?: string;
          RESULT_MSG?: string;
        }[];
      }
    )?.o_result_cursor?.[0];
    const innerCode = inner?.RESULT_CODE ?? inner?.CODE;
    if (res.status >= 400 || code || (innerCode !== undefined && String(innerCode) !== '0')) {
      return {
        ok: false,
        message: inner?.RESULT_MSG || inner?.MSG || (res.data as { message?: string })?.message,
      };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
