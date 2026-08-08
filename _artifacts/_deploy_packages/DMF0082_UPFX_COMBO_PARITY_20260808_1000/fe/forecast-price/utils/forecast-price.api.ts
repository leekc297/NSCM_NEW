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

/**
 * Excel 업로드 확정 저장 (2-Step OK — DMF0082_EXCEL_UPLOAD mode=1, DMF0074 P_MODE 패턴 1:1).
 * 반환 { ok, message } — FcstUploadModal onSave 계약.
 */
export const saveExcelUpload = async (): Promise<{ ok: boolean; message?: string }> => {
  const sesUserId = useSessionStore.getState().session.userId ?? '';
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/FcstNPrice/UPLOAD_SAVE/call-proc`,
      { mode: 1, createdBy: sesUserId }
    );
    const code = Number((res.data as { code?: string })?.code ?? 0);
    const inner = (res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] })
      ?.o_result_cursor?.[0];
    if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
      return { ok: false, message: inner?.MSG || (res.data as { message?: string })?.message };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
