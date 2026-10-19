import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../delegate.constants';
import type { DelegateInput, DelegateRow } from '../delegate.types';

// 검증 실패 결과 — 화면이 msgKey(TO-BE MSG_ID) + 영문 fallback + args 로 alert 를 띄운다.
export interface ValidationResult {
  ok: boolean;
  msgKey?: string;
  msgDefault?: string;
  msgArgs?: Record<string, string>;
}

// 위임자 검색 결과 — AS-IS UserName_Search(cs:789-816) 반환 건수 분기 재현:
//   one=단일 확정(UserID) / many=다건(MSG00302 검색 프롬프트) / none=0건(MSG00301) / error=호출 실패.
export type DelegateeSearch =
  | { status: 'one'; userId: string }
  | { status: 'many' }
  | { status: 'none' }
  | { status: 'error' };

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 날짜 셀/입력 -> yyyymmdd 숫자(비교용). 표시문자열('2026-09-22' 등)의 숫자만 추출해 8자리로.
const toYmd = (v: unknown): number => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  return digits.length === 8 ? Number(digits) : 0;
};

// AS-IS SSP0020_Delegate.cs Validation_Check(cs:362-467) + UserName_Search(cs:341) 재현.
//   - 동기 검증(298/305/134/219/299=097/105/296/297) : 입력값 + rs1(dtFind_Data, hidden
//     USER_ID/DELEGATEE_ID 포함) 클라 계산. AS-IS 는 MSG00105/00296/00297 을 전부 dtFind_Data
//     (=GET rs1 복사본, 내가 위임한 목록)에서 클라 판정한다(cs:416/430/444, 별도 SP 조회 없음) —
//     본 훅이 그 세 판정을 division 별로 그대로 재현한다.
//   - 위임자 실존 검증(UserName_Search) : 서버 P_USER_CHECK(= UP_FX_GetSSPUserUseInfoList) 비동기.
export const useDelegateValidation = () => {
  const sessionUserId = useSessionStore(s => s.session.userId);
  const langCd = useSessionStore(s => s.session.langCd);

  // 저장 전 동기 검증. delegateRows = 현재 Delegate 시트(rs1, hidden USER_ID/DELEGATEE_ID 포함).
  const validateSave = (input: DelegateInput, delegateRows: DelegateRow[]): ValidationResult => {
    // 위임자명 공백 (MSG00298, cs:372)
    if (!input.delegatee.trim() || !input.delegateeId.trim()) {
      return {
        ok: false,
        msgKey: MSG.DELEGATEE_REQUIRED,
        msgDefault: '_Please enter the delegatee.',
      };
    }
    // 위임자 == 본인 (MSG00305, cs:379)
    if (input.delegateeId === sessionUserId) {
      return {
        ok: false,
        msgKey: MSG.DELEGATEE_SELF,
        msgDefault: '_You cannot delegate to yourself.',
      };
    }
    // 기간 공백 (MSG00134, cs:385)
    if (!input.fromDate.trim() || !input.toDate.trim()) {
      return {
        ok: false,
        msgKey: MSG.PERIOD_REQUIRED,
        msgDefault: '_Please enter the period.',
      };
    }
    // From > To (MSG00219, cs:393)
    if (toYmd(input.fromDate) > toYmd(input.toDate)) {
      return {
        ok: false,
        msgKey: MSG.PERIOD_REVERSED,
        msgDefault: '_The start date must be earlier than the end date.',
      };
    }
    // Division 미체크 (MSG00299 -> TO-BE MSG00097, cs:462 bolDivisionChk)
    if (input.divisionIds.length === 0) {
      return {
        ok: false,
        msgKey: MSG.REQUIRE_DIVISION,
        msgDefault: '_Please select Division.',
      };
    }
    // 중복·중첩 검증 (Validation_Check cs:407-458) — dtFind_Data(=GET rs1, 내가 위임한 목록,
    //   hidden USER_ID/DELEGATEE_ID 포함)에서 선택 division 별로 세 중첩을 순서대로 판정한다.
    //   AS-IS 중첩 정의(cs:419-422): 기존행의 FROM 또는 TO 가 신규 [from,to] 안에 들면 겹침(완전
    //   포함은 미검출 — AS-IS 로직 그대로 재현, 임의 보정 금지). 날짜 비교는 yyyymmdd 숫자로.
    const from = toYmd(input.fromDate);
    const to = toYmd(input.toDate);
    const selected = new Set(input.divisionIds);
    const overlaps = (r: DelegateRow): boolean => {
      if (str(r.VALID) !== 'Y') return false;
      if (!selected.has(str(r.DIVISION_ID))) return false;
      const rf = toYmd(r.FROM_DATE);
      const rt = toYmd(r.TO_DATE);
      return (rf >= from && rf <= to) || (rt >= from && rt <= to);
    };
    // MSG00105 (cs:416) — 선택 division·기간 중첩(위임자 무관, 내 위임목록 기준)
    if (delegateRows.some(overlaps)) {
      return {
        ok: false,
        msgKey: MSG.OVERLAP_PERIOD,
        msgDefault: '_There are overlapping periods.',
      };
    }
    // MSG00296 (cs:430) — 수임 대상자(delegateeId)가 위임자(USER_ID)로 이미 걸린 중첩 위임 현황
    if (delegateRows.some(r => overlaps(r) && str(r.USER_ID) === input.delegateeId)) {
      return {
        ok: false,
        msgKey: MSG.DELEGATEE_OTHER,
        msgDefault: '_The delegatee has other delegations in the period.',
      };
    }
    // MSG00297 (cs:444) — 본인(sessionUserId)이 수임자(DELEGATEE_ID)로 걸린 중첩 수임 현황
    if (delegateRows.some(r => overlaps(r) && str(r.DELEGATEE_ID) === sessionUserId)) {
      return {
        ok: false,
        msgKey: MSG.OVERLAP_RECEIVED,
        msgDefault: '_You have overlapping received delegations in the period.',
      };
    }
    return { ok: true };
  };

  // 위임자명 실존 검증(UserName_Search, cs:776-817) — 서버 P_USER_CHECK(UP_FX_GetSSPUserUseInfoList
  //   등가: UserID/UserName/UserName_E LIKE, UseYN='Y'). AS-IS 는 반환 건수로 분기한다:
  //   1건=통과(UserID 확정, cs:791) / 다건=MSG00302 "검색창 여시겠습니까?"(cs:802) / 0건=MSG00301(cs:811).
  //   PKG_SSP0020 미배포·호출 실패는 'error'(저장 중단, false-success 방지).
  const searchDelegatee = async (search: string): Promise<DelegateeSearch> => {
    if (!search.trim()) return { status: 'none' };
    try {
      const res = await apiClient.post<Record<string, unknown>[]>(
        `/${MENU_ID}/${SHEETS.DELEGATE}/USER_CHECK/call-proc`,
        { search: search.trim(), language: langCd ?? '' }
      );
      if (res.status >= 400 || Number(res.data?.code)) return { status: 'error' };
      const rows =
        (res.data as { result?: { o_rc1?: Record<string, unknown>[] } }).result?.o_rc1 ?? [];
      if (rows.length === 1) {
        const id = str(rows[0].USER_ID) || str(rows[0].USERID);
        return id ? { status: 'one', userId: id } : { status: 'none' };
      }
      return { status: rows.length > 1 ? 'many' : 'none' };
    } catch {
      return { status: 'error' }; // 호출 실패 = 저장 중단(false-success 방지)
    }
  };

  return { validateSave, searchDelegatee };
};
