import { useCallback } from 'react';

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS, USER_POPUP_COLUMNS } from '../shipment-requestor-pic.constants';

type Row = Record<string, unknown>;

// 저장 전 사용자 검증 결과. ok=false 면 invalidUser(미등록 목록) 또는 errored(호출 실패).
interface UserCheckResult {
  ok: boolean;
  invalidUser?: string; // 미등록 사용자 ID 목록(콤마 join, MSG01261 {0} 인자)
  errored?: boolean; // 검증 호출 자체 실패(엔드포인트 미등록/네트워크) — 저장 중단 사유
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// SSP0025 저장 전 사용자 등록 검증 (design 03 §4.3 V11, AS-IS GetUserIDChk cs:400~408,491~498).
//   각 편집행의 USER_ID(필수)/PART_LEADER/TEAM_LEADER(비공백일 때만) 값이 등록 사용자인지
//   P_SSP0025_GET_USER_ID_CHECK 로 확인 — 미등록이면 안내 후 저장 중단
//   (AS-IS MSG00251 → TO-BE 는 문구 역조회로 MSG01261. AS-IS 번호는 TO-BE 에 미등록, constants MSG 주석 참조).
//   CHECK proc 계약(자매 SSP0014 PKG body 실측 준거):
//     - 입력 P_USER_ID = '^' 구분 다건 CLOB. 반환 o_rc1 = 입력 중 "등록된"(SSP PLANNER/ADMIN 그룹) USER_ID.
//     - proc 는 USER_ID 를 UPPER 비교 → 이쪽도 대문자로 대사.
//   API 배선(SCM_ADM_API_M, MNU_BTN_CD='USER_CHECK')·권한은 05_register.sql 로 등록.
//   호출 실패(네트워크/코드≠0)면 errored=true 로 저장을 막는다(false-success 방지 — 미검증 통과 금지).
//   주의: PKG_SSP0025 미배포(goal.md ②) → 런타임 미완, 배선 완비. convert-sp 배포 후 실행.
export const useShipmentRequestorPicValidation = () => {
  const checkUsersRegistered = useCallback(async (dirtyRows: Row[]): Promise<UserCheckResult> => {
    const users: string[] = [];
    const seen = new Set<string>();
    for (const r of dirtyRows) {
      for (const col of USER_POPUP_COLUMNS) {
        const v = str(r[col]).trim();
        if (v && !seen.has(v.toUpperCase())) {
          seen.add(v.toUpperCase());
          users.push(v);
        }
      }
    }
    if (users.length === 0) return { ok: true };

    try {
      // '^' 구분 다건 전송. o_rc1 = 등록 통과 사용자 목록.
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/USER_CHECK/call-proc`,
        { userId: users.join('^') }
      );
      if (res.status >= 400 || Number(res.data?.code)) return { ok: false, errored: true };
      const result = (res.data?.result ?? {}) as unknown as { o_rc1?: Row[] };
      const registered = new Set(
        (result.o_rc1 ?? []).map(row => str(row.USER_ID).trim().toUpperCase())
      );
      const invalid = users.filter(u => !registered.has(u.toUpperCase()));
      if (invalid.length > 0) return { ok: false, invalidUser: invalid.join(', ') };
      return { ok: true };
    } catch {
      // 검증 호출 실패 = 미확인 -> 저장 중단(console 금지 룰).
      return { ok: false, errored: true };
    }
  }, []);

  return { checkUsersRegistered };
};
