import { useCallback } from 'react';

import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID, PIC_CHECK_BTN, SHEETS } from '../group-code-management.constants';

type Row = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// PIC_ID 변경 즉시 검증 (03_grid-columns.md §3-4 R-PIC-CHECK, AS-IS cs:1737~1782).
//   PKG_SCP0050.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP (2 IN: Search=PIC_ID, Language / 3 OUT: 커서/코드/메시지).
//   반환 커서(o_rc1)에 입력 USER_ID 가 없으면 미등록 → 셀 클리어 + MSG00251(페이지가 표시).
//   API 배선(SCM_ADM_API_M MNU_BTN_CD='PIC_CHECK')·권한은 05_register.sql 로 등록·실측 확인.
//   호출 실패(엔드포인트 미등록/네트워크/코드≠0)면 false 반환 — 미검증 통과 금지(false-success 방지).
export const useGroupCodePicCheck = () => {
  const langCd = useSessionStore.getState().session.langCd ?? '';

  const checkPicRegistered = useCallback(
    async (userId: string): Promise<boolean> => {
      const target = userId.trim();
      if (!target) return false;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.MAIN}/${PIC_CHECK_BTN}/call-proc`,
          { search: target, language: langCd }
        );
        if (res.status >= 400 || Number(res.data?.code)) return false;
        const result = (res.data?.result ?? {}) as { o_rc1?: Row[] };
        // proc 는 USER_ID 를 UPPER 비교 — 이쪽도 대문자 대사(AS-IS 동일 판정).
        const registered = new Set(
          (result.o_rc1 ?? []).map(row => str(row.USER_ID).trim().toUpperCase())
        );
        return registered.has(target.toUpperCase());
      } catch {
        // 검증 호출 실패 = 미확인 -> 통과시키지 않는다(console 금지 룰).
        return false;
      }
    },
    [langCd]
  );

  return { checkPicRegistered };
};
