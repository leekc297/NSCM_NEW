import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../shipment-master-electrode.constants';

// AS-IS SSP0024 검증/권한 (design 01_layout R1, 03_grid-columns §3.4):
//   - Edit 진입 SSP Planner 권한체크: SP SSP0002_GET_USER_INFO_LIST (Search=userId·Language·SSOUserYN='N').
//     반환 0건이면 isOK=false -> MSG00251 alert + 편집 차단 (cs:240~250, 877~899).
//   - 저장 전 중복(DIVISION_ID + PLANT_SITE_CODE + MATERIAL_ID) 검사 -> MSG00060 (cs:781~811 checkValidN1).
//   주의: PKG_SSP0002 미배포(goal.md ②) -> 권한 API 는 런타임 미완. 배선은 완비, 실행은 convert-sp 배포 후.

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const useShipmentMasterElectrodeValidation = () => {
  const sessionUserId = useSessionStore.getState().session.userId;
  const langCd = useSessionStore.getState().session.langCd;

  // Edit 진입 권한체크 — SSP0002 사용자 정보 조회(SSP Planner). 반환 0건이면 권한 없음.
  //   API 미배포/네트워크 실패는 false-success 방지 위해 편집 차단으로 처리(available=false).
  const checkEditPermission = async (): Promise<{
    ok: boolean;
    available: boolean;
    userId: string;
  }> => {
    const userId = sessionUserId ?? '';
    try {
      const res = await apiClient.post<Record<string, unknown>[]>(
        `/${MENU_ID}/${SHEETS.MAIN}/USER_CHECK/call-proc`,
        { userId, language: langCd ?? '', ssoUserYn: 'N' }
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        return { ok: false, available: false, userId };
      }
      const result = res.data?.result as { o_rc1?: unknown[] } | unknown[] | undefined;
      const rows = Array.isArray(result)
        ? result
        : ((result as { o_rc1?: unknown[] })?.o_rc1 ?? []);
      return { ok: rows.length > 0, available: true, userId };
    } catch {
      return { ok: false, available: false, userId };
    }
  };

  // 저장 전 중복키 검사 — (DIVISION_ID + PLANT_SITE_CODE + MATERIAL_ID) 조합 중복 금지(MSG00060).
  //   대상 = 저장 대상행(I/M) 전체를 화면 전체 행 대비로 검사(AS-IS checkValidN1, 신규행 중복 포함).
  const findDuplicateKey = (
    targetRows: Record<string, unknown>[],
    allRows: Record<string, unknown>[]
  ): string | null => {
    const keyOf = (r: Record<string, unknown>): string =>
      `${str(r.DIVISION_ID)}${str(r.PLANT_SITE_CODE)}${str(r.MATERIAL_ID)}`;
    const counts = new Map<string, number>();
    for (const r of allRows) {
      const k = keyOf(r);
      counts.set(k, (counts.get(k) ?? 0) + 1);
    }
    for (const r of targetRows) {
      const k = keyOf(r);
      if ((counts.get(k) ?? 0) > 1) return k;
    }
    return null;
  };

  return { checkEditPermission, findDuplicateKey };
};
