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
 * Excel Form 조회 (UPLOAD_DATA 버튼 — PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA, BODY L4963).
 * 본인(createdBy)의 **최종 업로드 성공분**(SCM_ADM_EXCEL_UPLOAD MAX(CREATION_DATE)·SUCCESS, L5032/L5093)을
 * Daily 로 풀어 반환하는 SP — o_rc1 = RECORD(KEY+BASIS_YYYYMMDD+DAILY_QTY, L5549) /
 * o_rc2 = PIVOT(동적 D{yyyymmdd} 컬럼, L5626 동적 SQL).
 * ⭐ 파라미터 = `createdBy` 단일 (PROC_M 실측 — call-proc 감사키는 FE 필수 전달, BE 주입은 sesUserId 뿐).
 * ⭐ BUCKET 연동은 FE 파라미터가 아니라 SP 내부 자동 수급이 정본 계약:
 *   업로드 division 기준 DM_MST_BUCKET_CONVERSION(주차/일할 분배, L5203·L5391) +
 *   LOOKUP 'DEFAULT_BUCKET_DAY'(SEGMENT1=division·SEGMENT2='MONTHLY', L5250·L5449).
 *   → 화면 조회조건 Bucket 을 전달할 IN 파라미터 자체가 없다 (임의 파라미터 추가 금지).
 */
export const fetchUploadPreview = async (): Promise<{
  ok: boolean;
  message?: string;
  /** o_rc2 — Daily PIVOT (그리드 표시·양식 복원 원천) */
  pivot: UploadPreviewRow[];
}> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/FcstNPrice/UPLOAD_DATA/call-proc`,
      { createdBy: sesUserId }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    const result = (res.data?.result ?? {}) as {
      o_rc2?: UploadPreviewRow[];
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
      };
    }
    return { ok: true, pivot: result.o_rc2 ?? [] };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined, pivot: [] };
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
        o_result_cursor?: { CODE?: string; MSG?: string; RESULT_CODE?: string; RESULT_MSG?: string }[];
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
