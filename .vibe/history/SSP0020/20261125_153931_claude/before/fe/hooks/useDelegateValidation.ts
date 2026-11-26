import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import { BTN, MENU_ID, MSG, SHEETS } from '../delegate.constants';
import type { DelegateInput, DelegateRow } from '../delegate.types';

// 검증 실패 결과 — 화면이 msgKey(TO-BE MSG_ID) + 영문 fallback + args 로 alert 를 띄운다.
export interface ValidationResult {
  ok: boolean;
  msgKey?: string;
  msgDefault?: string;
  msgArgs?: Record<string, string>;
}

// 위임자 검색 결과 — AS-IS UserName_Search(cs:789-816) 반환 건수 분기 재현:
//   one=단일 확정(UserID+UserName) / many=다건(MSG00302 검색 프롬프트) / none=0건(MSG00301) / error=호출 실패.
//   userName = AS-IS 가 1건 확정 시 txtDelegatee.Text 에 되넣는 사용자명(cs:797 KO / cs:799 EN) —
//   화면이 입력칸을 ID 가 아닌 정식 이름으로 치환하는 데 쓴다.
export type DelegateeSearch =
  | { status: 'one'; userId: string; userName: string }
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
        msgDefault: 'Please enter Delegatee.',
      };
    }
    // 위임자 == 본인 (MSG00305, cs:379)
    if (input.delegateeId === sessionUserId) {
      return {
        ok: false,
        msgKey: MSG.DELEGATEE_SELF,
        msgDefault: 'The delegator and the officer are the same.',
      };
    }
    // 기간 공백 (MSG00134, cs:385)
    if (!input.fromDate.trim() || !input.toDate.trim()) {
      return {
        ok: false,
        msgKey: MSG.PERIOD_REQUIRED,
        msgDefault: 'Select a date and enter it.',
      };
    }
    // From > To (AS-IS MSG00219 → TO-BE MSG01230, cs:393)
    if (toYmd(input.fromDate) > toYmd(input.toDate)) {
      return {
        ok: false,
        msgKey: MSG.PERIOD_REVERSED,
        msgDefault: 'The start date can not be later than the end date.',
      };
    }
    // Division 미체크 (MSG00299 -> TO-BE MSG00097, cs:462 bolDivisionChk)
    if (input.divisionIds.length === 0) {
      return {
        ok: false,
        msgKey: MSG.REQUIRE_DIVISION,
        msgDefault: 'No Division ID selected.',
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
        msgDefault: 'The period overlaps with an existing one.',
      };
    }
    // MSG00296 (cs:430) — 수임 대상자(delegateeId)가 위임자(USER_ID)로 이미 걸린 중첩 위임 현황
    if (delegateRows.some(r => overlaps(r) && str(r.USER_ID) === input.delegateeId)) {
      return {
        ok: false,
        msgKey: MSG.DELEGATEE_OTHER,
        msgDefault: 'There is another delegation status of the appointed person.',
      };
    }
    // MSG00297 (cs:444) — 본인(sessionUserId)이 수임자(DELEGATEE_ID)로 걸린 중첩 수임 현황
    if (delegateRows.some(r => overlaps(r) && str(r.DELEGATEE_ID) === sessionUserId)) {
      return {
        ok: false,
        msgKey: MSG.OVERLAP_RECEIVED,
        msgDefault: 'You have a status that you have received in the nested period.',
      };
    }
    return { ok: true };
  };

  // 위임자명 실존 검증(UserName_Search, cs:776-817) — 서버 P_USER_CHECK(UP_FX_GetSSPUserUseInfoList
  //   등가: UserID/UserName/UserName_E LIKE, UseYN='Y'). AS-IS 는 반환 건수로 분기한다:
  //   1건=통과(UserID 확정, cs:791) / 다건=MSG00302 "검색창 여시겠습니까?"(cs:802) / 0건=MSG00301(cs:811).
  //   PKG_SSP0020 미배포·호출 실패는 'error'(저장 중단, false-success 방지).
  const searchDelegatee = async (search: string): Promise<DelegateeSearch> => {
    // AS-IS UserName_Search(cs:780)는 빈 이름도 그대로 서버(UP_FX_GetSSPUserUseInfoList / TO-BE
    //   P_USER_CHECK)로 보낸다 — 빈 검색어가 LIKE 전체 매칭돼 다건('many')으로 분기하는 것이 AS-IS
    //   동작이다(화면 열자마자 Save 시 MSG00302 "다중검색된 User…"). 따라서 여기서 빈값을 'none' 으로
    //   조기 반환하지 않고 서버 판정에 맡긴다(사용자 지시 2026-11-10 — 빈값을 서버로 흘림, 완전 파리티).
    try {
      // useYn — AS-IS UseYN='Y' 파리티. P_USER_CHECK 는 NVL(...,'Y') 로 기본값을 두지만
      //   (PKG_SSP0020 body 426), 계약(SCM_ADM_PROC_M 3파라미터)대로 명시 전송한다.
      const res = await apiClient.post<Record<string, unknown>[]>(
        `/${MENU_ID}/${SHEETS.DELEGATE}/${BTN.USER_CHECK}/call-proc`,
        { search: search.trim(), language: langCd ?? '', useYn: 'Y' }
      );
      if (res.status >= 400 || Number(res.data?.code)) return { status: 'error' };
      const rows =
        (res.data as { result?: { o_rc1?: Record<string, unknown>[] } }).result?.o_rc1 ?? [];
      if (rows.length === 1) {
        const row = rows[0];
        const id = str(row.USER_ID) || str(row.USERID);
        // AS-IS cs:796-799 — 1건 확정 시 사용자명을 txtDelegatee.Text 로 되넣는다(KO=USERNAME /
        //   그 외=USERNAME_E). P_USER_CHECK 는 USERNAME/USERNAME_E 로 반환(소스 418-420). 비면 ID 로 폴백.
        const nm = langCd === 'KO' ? str(row.USERNAME) : str(row.USERNAME_E);
        return id ? { status: 'one', userId: id, userName: nm || id } : { status: 'none' };
      }
      return { status: rows.length > 1 ? 'many' : 'none' };
    } catch {
      return { status: 'error' }; // 호출 실패 = 저장 중단(false-success 방지)
    }
  };

  return { validateSave, searchDelegatee };
};
