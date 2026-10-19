import { apiClient } from '@foundation/apis';

import {
  ERP_BLOCK_COMBO,
  MENU_ID,
  SAVE_BTN,
} from '../shipment-change-request-confirm-ssp0003.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';

// call-proc 결과 커서 접근 — 인터셉터가 result 를 data.result 또는 data 최상위로 줄 수 있어 둘 다 본다(SalesFuturePrice L716-717 동일).
const cursor = (res: { data?: unknown }, key: string): Record<string, unknown>[] => {
  const data = res.data as Record<string, unknown> | undefined;
  const inResult = (data?.result as Record<string, unknown> | undefined)?.[key];
  const top = data?.[key];
  return (Array.isArray(inResult) ? inResult : Array.isArray(top) ? top : []) as Record<
    string,
    unknown
  >[];
};

const isFail = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code) > 0;

// SSP0003 승인/반려/자기반려 액션 서버체크 (design 01 §2-E/§2-F, AS-IS 가드 헬퍼 L1511/1536/1574).
export const useShipmentChangeRequestConfirmSsp0003Actions = () => {
  // G3/G8/G14 ERP 차단 게이트 — SSPBlockCheckIF_SCP(@segment1='SSP0003'), BLOCK_YN='Y'면 차단(MSG00267->MSG01395).
  //   조회 실패 시 false(차단 안 함) — false-block 방지, 서버 SAVE SP 가 최종 방어(AS-IS chkERPIFBlockYn L1511).
  const checkErpBlock = async (divisionId: string): Promise<boolean> => {
    try {
      const rows = await apiClient.getCombo({
        comboId: ERP_BLOCK_COMBO,
        divisionId,
        segment1: MENU_ID,
      });
      return (rows ?? []).some(r => str(r.BLOCK_YN ?? (r as Record<string, unknown>).CODE) === 'Y');
    } catch {
      return false;
    }
  };

  // G13 엔진 수행중 체크 — PKG_SSP0003.P_SSP0003_GET_PLAN_PROC_CHECK(@p_division_id). O_RC1 첫행 첫값='Y'면 차단(MSG00291).
  //   AS-IS EngProcessingChk(L1536): Tables[0].Rows[0][0]='Y' 차단, [0][1]=남은시간. 커서 컬럼명은 런타임/convert-sp(PROC_M) 확정 —
  //   AS-IS 와 동일 위치기반 읽기(Object.values). 조회 실패 시 차단 안 함(catch → not blocked, AS-IS catch return false 와 동일 방어).
  const checkEngProcessing = async (
    divisionId: string
  ): Promise<{ blocked: boolean; remainMinute: string }> => {
    try {
      const res = await apiClient.post<Record<string, unknown>, { divisionId: string }>(
        `/${MENU_ID}/main/${SAVE_BTN.PLAN_CHECK}/call-proc`,
        { divisionId }
      );
      if (isFail(res)) return { blocked: false, remainMinute: '' };
      const row = cursor(res, 'o_rc1')[0];
      if (!row) return { blocked: false, remainMinute: '' };
      const vals = Object.values(row).map(str);
      return { blocked: vals[0] === 'Y', remainMinute: vals[1] ?? '' };
    } catch {
      return { blocked: false, remainMinute: '' };
    }
  };

  // G15 D/O 생성 체크 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS(@p_division_id,@p_confirm_id). O_RC3(=AS-IS Tables[2]) 행수>0 면
  //   ERP D/O 생성건 존재 → 해당 CONFIRM_ID 는 D/O Reject 처리 대상(MSG00413). AS-IS GetShipmentStatusChk(L1574) L1620 Tables[2].
  //   반환 doRejectIds = O_RC3 CONFIRM_ID 목록(있으면 blocked=true). 커서 위치(o_rc3)는 ALL_ARGUMENTS 실측(O_RC1/2/3), 컬럼 CONFIRM_ID 는 AS-IS 동일.
  const checkShipmentStatus = async (
    divisionId: string,
    confirmId: string
  ): Promise<{ blocked: boolean; confirmIds: string[] }> => {
    try {
      const res = await apiClient.post<
        Record<string, unknown>,
        { divisionId: string; confirmId: string }
      >(`/${MENU_ID}/main/${SAVE_BTN.SCS_CHECK}/call-proc`, { divisionId, confirmId });
      if (isFail(res)) return { blocked: false, confirmIds: [] };
      const rows = cursor(res, 'o_rc3');
      const ids = rows.map(r => str(r.CONFIRM_ID)).filter(Boolean);
      return { blocked: ids.length > 0, confirmIds: ids };
    } catch {
      return { blocked: false, confirmIds: [] };
    }
  };

  return { checkErpBlock, checkEngProcessing, checkShipmentStatus };
};
