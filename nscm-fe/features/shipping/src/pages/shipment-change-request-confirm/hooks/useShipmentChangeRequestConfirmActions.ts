import { apiClient } from '@foundation/apis';

import { ERP_BLOCK_COMBO, FIXED_DIVISION, MENU_ID } from '../shipment-change-request-confirm.constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// SSP0202 승인/반려/자기반려 액션 서버체크 (design 01 §2 E2/E10/E11, roslyn validations 실측).
export const useShipmentChangeRequestConfirmActions = () => {
  // E2/E6/E12 ERP 차단 게이트 — SSPBlockCheckIF_SCP(@segment1='SSP0202'), BLOCK_YN='Y'면 차단(MSG00267->MSG01395).
  //   조회 실패 시 false(차단 안 함) — false-block 방지, 서버 SAVE SP 가 최종 방어(자매 SSP0201 동일).
  const checkErpBlock = async (divisionId: string): Promise<boolean> => {
    try {
      const rows = await apiClient.getCombo({
        comboId: ERP_BLOCK_COMBO,
        divisionId: divisionId || FIXED_DIVISION,
        segment1: MENU_ID,
      });
      return (rows ?? []).some(r => str(r.BLOCK_YN ?? (r as Record<string, unknown>).CODE) === 'Y');
    } catch {
      return false;
    }
  };

  return { checkErpBlock };
};
