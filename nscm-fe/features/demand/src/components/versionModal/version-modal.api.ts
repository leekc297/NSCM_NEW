// ⭐ 공용 Version 팝업 call-proc 헬퍼 — menuId 를 인자로 받아 DMF0044 / DMF0049 양쪽 배선을 그대로 쓴다.
//   (화면별 api 파일이 MENU_ID 를 상수로 박고 있어 공용화 불가 → 본 파일이 단일 출처)
import { apiClient } from '@foundation/apis';

import { VERSION_BTN_CD, VERSION_SHEET } from './version-modal.constants';

export interface VersionCallResult {
  ok: boolean;
  message?: string;
}

// call-proc 응답 첫 커서 첫 문자열 값 추출 (SP OUT 은 'success' 또는 오류 문구를 그대로 실어 보낸다)
const parseFirstValue = (data: unknown): string | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  if (!first || typeof first !== 'object') return undefined;
  const firstVal = Object.values(first as Record<string, unknown>).find(
    v => typeof v === 'string' && String(v).trim() !== ''
  );
  return typeof firstVal === 'string' ? firstVal.trim() : undefined;
};

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
  const firstVal = parseFirstValue(res.data);
  if (firstVal && firstVal.toLowerCase() !== 'success' && String(Number(firstVal)) !== firstVal) {
    return { ok: false, message: firstVal };
  }
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
