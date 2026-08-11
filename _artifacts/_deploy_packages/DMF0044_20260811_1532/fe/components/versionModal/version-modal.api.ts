// ⭐ 공용 Version 팝업 call-proc 헬퍼 — menuId 를 인자로 받아 DMF0044 / DMF0049 양쪽 배선을 그대로 쓴다.
//   (화면별 api 파일이 MENU_ID 를 상수로 박고 있어 공용화 불가 → 본 파일이 단일 출처)
import { apiClient } from '@foundation/apis';

import { VERSION_BTN_CD, VERSION_SHEET } from './version-modal.constants';

export interface VersionCallResult {
  ok: boolean;
  message?: string;
}

/** call-proc 응답의 SP 결과 커서 1행을 꺼낸다.
 *  ⭐ 실측 응답 2형 (2026-08-10 HTTP 직접 호출):
 *   · 정상   `{"MSG":"SUCCESS","CODE":"0","EVENT":"0"}`
 *   · 검증실패 `{"CODE":"1","MSG":"VERSION 값이 존재하지 않습니다.","EVENT":null}`
 *     (SP `WHEN e_validation` L9239~9240 — `SELECT '1' AS CODE, v_result_msg AS MSG …`)
 *  HTTP 는 **양쪽 다 200 + envelope code '0'** 이므로 이 커서를 봐야만 실패를 알 수 있다. */
const firstResultRow = (data: unknown): Record<string, unknown> | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  return first && typeof first === 'object' ? (first as Record<string, unknown>) : undefined;
};

const str = (v: unknown): string => (typeof v === 'string' || typeof v === 'number' ? String(v) : '').trim();

const callProc = async (
  menuId: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<VersionCallResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${menuId}/${VERSION_SHEET}/${btnCd}/call-proc`,
    payload
  );
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, message: (res.data as { message?: string })?.message?.trim() };
  }
  // ⚠️ 2026-08-10 실사고: 예전 구현은 "첫 문자열 값"을 뽑아 `String(Number(v)) !== v` 로 걸렀는데,
  //   검증실패 응답은 CODE 가 먼저 와서 값이 `'1'` 이었고 `String(Number('1'))==='1'` 이라 조건이
  //   무너져 **실패를 성공으로 판정**했다(Version Delete 가 "성공적으로 저장되었습니다" 를 띄우고
  //   실제로는 아무 것도 지우지 않던 원인). ⇒ CODE 를 **이름으로 명시 확인**한다.
  const row = firstResultRow(res.data);
  if (!row) return { ok: true }; // 결과 커서를 안 내리는 SP(전송류) — HTTP 성공을 그대로 신뢰
  const code = str(row.CODE);
  const msg = str(row.MSG);
  if (code !== '' && code !== '0') return { ok: false, message: msg || code };
  if (msg !== '' && msg.toLowerCase() !== 'success') return { ok: false, message: msg };
  return { ok: true };
};

// Version Create / Copy / Delete — PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY (8 IN, createdBy BE주입)
//   ⚠️ AS-IS United 팝업(727행)은 Type 무관하게 이 SP 1본만 호출한다. BIZ_PLAN 분기는 이관 제외된
//   dead 팝업(DMF0044_Sales_VersionCopyPopUp L304) 소관이므로 여기서 분기하지 않는다.
export const callVersionAction = (
  menuId: string,
  params: {
    divisionId: string;
    versionNo: string;
    versionDescription: string;
    resultDate: string; // 실적 포함 체크 시 yyyymmdd, 미체크 ''
    actionType: string; // 'CR' | 'CP' | 'D'
    mvPlanYyyymm: string; // 이동계획 체크 시 yyyymm, 미체크 ''
    updateYn: string; // 최신화 'Y' | 'N'
  }
): Promise<VersionCallResult> => callProc(menuId, VERSION_BTN_CD.ACTION, { ...params });

// Transfer / Transfer Cancel — PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE (GDW 전송, action 'T'|'C')
export const callVersionTransfer = (
  menuId: string,
  params: {
    divisionId: string;
    versionNo: string;
    versionType: string;
    actionType: string; // 'T' | 'C'
  }
): Promise<VersionCallResult> => callProc(menuId, VERSION_BTN_CD.TRANSFER, { ...params });
