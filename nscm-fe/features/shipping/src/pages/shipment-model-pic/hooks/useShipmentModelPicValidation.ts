import { useCallback } from 'react';

import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS, USER_POPUP_COLUMNS } from '../shipment-model-pic.constants';

type Row = Record<string, unknown>;

// 저장 전 사용자 검증 결과. ok=false 면 message(불러올 MSG id) + 인자.
interface UserCheckResult {
  ok: boolean;
  invalidUser?: string; // 미등록 사용자 ID 목록(콤마 join, MSG00251 인자)
  errored?: boolean; // 검증 호출 자체 실패(엔드포인트 미등록/네트워크) — 저장 중단 사유
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// SSP0014 저장 전 사용자 등록 검증 (design 03 §4 / 00 §4, AS-IS GetUserIDChk cs:554-607).
//   각 편집행의 USER_ID/PART_LEADER/TEAM_LEADER/MAIL_USER1~5 값이 등록 사용자인지
//   P_SSP0014_GET_USER_ID_CHECK 로 확인 — 미등록이면 MSG00251, 저장 중단.
//   CHECK proc 계약(PKG_SSP0014 body 실측):
//     - 입력 P_USER_ID = '^' 구분 다건 CLOB (C_DELIMITER='^'). 콤마 아님.
//     - 반환 o_rc1 = 입력 중 "등록된"(SCM_ADM_USER_M + 그룹권한 SSP PLANNER/ADMIN/SCM PI ADMIN) USER_ID.
//       즉 o_rc1 은 통과 목록이며, 미등록 = 입력값 중 o_rc1 에 없는 것(AS-IS cs:574-585 와 동일 판정).
//     - proc 는 USER_ID 를 UPPER 비교하므로 이쪽도 대문자로 대사한다.
//   API 배선(SCM_ADM_API_M, MNU_BTN_CD='USER_CHECK')·권한은 05_register.sql 로 등록·실측 확인 완료.
//   호출 실패(네트워크/코드≠0)면 errored=true 로 저장을 막는다(false-success 방지 — 미검증 통과 금지).
export const useShipmentModelPicValidation = () => {
  // 편집행에서 채워진 사용자 값(대문자 기준 중복 제거, 원본 표기 보존)을 모아 CHECK proc 로 확인.
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
      // '^' 구분 다건 전송(proc C_DELIMITER='^'). o_rc1 = 등록 통과 사용자 목록.
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/USER_CHECK/call-proc`,
        { userId: users.join('^') }
      );
      if (res.status >= 400 || Number(res.data?.code)) return { ok: false, errored: true };
      const result = (res.data?.result ?? {}) as unknown as { o_rc1?: Row[] };
      const registered = new Set(
        (result.o_rc1 ?? []).map(row => str(row.USER_ID).trim().toUpperCase())
      );
      // 미등록 = 입력값 중 등록 목록에 없는 것(AS-IS 는 발견 전체를 콤마로 이어 MSG00251 표시).
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
