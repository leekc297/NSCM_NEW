import dayjs from '@foundation/dayjs';

import { LBL } from '../safety-stock.constants';

/**
 * 조회 전 필수 조건 검증 — AS-IS DataUtil.checkRequired(Designer "*": Division, Period) 재현.
 * 비어있는 첫 "*" 필드의 라벨 LBL 키를 돌려준다(없으면 null). 호출부가 t(MSG00614, 라벨)로 조립.
 * 자매 SCP0127 동형. 정확 AS-IS 문구는 TO-BE 미등록이라 MSG00614 사용(메시지 신규 INSERT 금지).
 */
export const missingRequiredSearchLabel = (sp: {
  divisionId: string;
  periodFrom: string;
  periodTo: string;
}): string | null => {
  if (!sp.divisionId || sp.divisionId.trim() === '') return LBL.DIVISION;
  if (!sp.periodFrom || !sp.periodTo) return LBL.PERIOD;
  return null;
};

/**
 * FROM/TO_YYYYMMDD 날짜 변환 헬퍼 — 그리드 셀을 FPDate 달력으로 편집하려면 값이 Date 여야 한다.
 *
 * GET SP 가 TO_DATE 로 내려주고 BE Jackson 이 'yyyy-MM-dd HH:mm:ss' 로 직렬화해 조회값은
 * "2026-06-01 00:00:00" 문자열이다. 신규행 기본값은 '' 이고, 편집 후엔 Date(InputDate 커밋)다.
 * 세 형태를 모두 받아 (표시/편집용) Date 또는 (저장/비교용) 'YYYYMMDD' 8자리로 정규화한다.
 * 자매 SCP0127 precede-safety-stock-day.util.ts 와 동형.
 */

// unknown → 문자열(객체는 '' — no-base-to-string 회피, 날짜 필드는 string|number|Date 만 온다).
const asStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** 그리드 표시/편집용 — 파싱되면 Date, 비거나 못 읽으면 '' (FPDate 빈 셀). */
export const toGridDate = (v: unknown): Date | '' => {
  if (v instanceof Date) return v;
  const s = asStr(v).trim();
  if (s === '') return '';
  // "2026-06-01 00:00:00" / "2026-06-01" / "20260601" 모두 허용.
  const d = /^\d{8}$/.test(s) ? dayjs(s, 'YYYYMMDD') : dayjs(s);
  return d.isValid() ? d.toDate() : '';
};

/** 저장/비교용 — Date·날짜문자열을 DB 저장 형태인 'YYYYMMDD' 8자리로. 못 읽으면 ''. */
export const toYmd8 = (v: unknown): string => {
  if (v instanceof Date) return dayjs(v).format('YYYYMMDD');
  return asStr(v)
    .replace(/\D/g, '')
    .slice(0, 8);
};

/**
 * Site(o_rc2) 를 선택 Division 으로 좁히는 규칙 — AS-IS RefreshSiteByDivision(SCP0128.cs:260) 재현.
 *   · 'EE'                → DIVISION_ID IN ('81','40','82')  (Cell 3 사업부 전체)
 *   · 'EE_UC/HM/ST/HD/HG' → '81_UC/81_HM/81_ST/81_HD/81_HG' 매핑 후 일치(GetDivisionChecked)
 *   · 그 외               → DIVISION_ID = 선택 Division (원값)
 *
 * 설계 02 §2-3 이 IN('81','40','82')을 전역 base 필터로 오독해 `base3 AND =division` 으로 이식했으나
 * 실제 AS-IS 는 EE 전용 분기라 EE·EE_* 선택 시 Site 콤보가 비었다(2026-10-12 사용자 신고, GSCM
 * 원본 실측 교정). 자매 SCP0127 precede-safety-stock-day.util.ts 와 동형.
 */
const EE_SUB_DIVISION_MAP: Record<string, string> = {
  EE_UC: '81_UC',
  EE_HM: '81_HM',
  EE_ST: '81_ST',
  EE_HD: '81_HD',
  EE_HG: '81_HG',
};
export const matchSiteByDivision = (siteDivisionId: unknown, selectedDivision: string): boolean => {
  const sid = typeof siteDivisionId === 'string' ? siteDivisionId : '';
  if (selectedDivision === 'EE') return ['81', '40', '82'].includes(sid);
  return sid === (EE_SUB_DIVISION_MAP[selectedDivision] ?? selectedDivision);
};
