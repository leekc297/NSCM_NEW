import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';

import { LBL } from '../precede-safety-stock-day.constants';

/**
 * 조회 전 필수 조건 검증 — AS-IS DataUtil.checkRequired(Designer "*": Division, Period) 재현.
 * 비어있는 첫 "*" 필드의 라벨 LBL 키를 돌려준다(없으면 null). 호출부가 t(MSG00614, 라벨)로 조립.
 * 정확 AS-IS 문구 "[{0}]은 필수 입력사항입니다" 는 TO-BE 미등록이라 가장 가까운 MSG00614
 * ("{0} 값은 필수 입력입니다")를 쓴다(메시지 신규 INSERT 금지 — deploy-sql-no-msg-m-insert).
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
 * 세 형태를 모두 받아 (표시/편집용) Date 또는 (저장용) 'YYYYMMDD' 8자리로 정규화한다.
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
 * Site(o_rc2) 를 선택 Division 으로 좁히는 규칙 — AS-IS RefreshSiteByDivision(SCP0127/SCP0128 동일) 재현.
 *   · 'EE'                → DIVISION_ID IN ('81','40','82')  (Cell 3 사업부 전체)
 *   · 'EE_UC/HM/ST/HD/HG' → '81_UC/81_HM/81_ST/81_HD/81_HG' 매핑 후 일치(GetDivisionChecked)
 *   · 그 외               → DIVISION_ID = 선택 Division (원값)
 *
 * 설계 02_search-combo.md §2-3 이 IN('81','40','82')을 전역 base 필터로 오독해 `base3 AND =division`
 * 으로 이식했었다 — 실제 AS-IS 는 EE 전용 분기라, EE·EE_* 선택 시 Site 콤보가 통째로 비었다
 * (2026-10-12 사용자 신고, GSCM 원본 SCP0127.cs:262 RefreshSiteByDivision 실측으로 교정).
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

/**
 * 다중 콤보에서 "전 항목 선택"을 'ALL' sentinel 로 되돌린다 — AS-IS 파리티(테스트 No.3).
 *
 * 공용 CustomDropdown 은 사용자 확정 요구(2026-10-23)로 SELECT ALL 을 'ALL' 로 뭉개지 않고 선택값을
 * 그대로 열거해 내보낸다. 그런데 AS-IS SCP0127 은 "SELECT ALL = SCM Site 전체 조회(비운 것과 같음)"
 * 이고, GET SP(PKG_SCP0127.P_SCP0127_GET BODY:196~199)도 scmSiteId 가 'ALL'/NULL 일 때만 무필터다 —
 * 열거된 코드들을 그대로 보내면 `IN(그 코드들)`로 좁혀져 비운 경우(534)보다 적게(9) 나왔다. 공용
 * 컴포넌트는 못 바꾸므로(전 화면 영향), 이 화면이 조회 직전 값을 보정한다: 선택 코드 집합이 현재
 * 옵션 전체를 덮으면 'ALL' 로 치환해 무필터 조회가 되게 한다(부분 선택은 그대로 둔다).
 *
 * 보정 시점은 store setFilters(조회 직전)다 — onChange 가 아니다. onChange 에서 뭉개면 콤보 value 가
 * 'ALL' 이 되어 체크가 전부 풀린 것처럼 보였다(사용자 신고). searchParams 에는 Plan Group 처럼 열거값을
 * 그대로 두어 체크 표시를 유지하고, filters(SP 요청)로 나갈 때만 'ALL' 로 뭉갠다.
 */
export const normalizeAllSelectedToAll = (value: string, optionCodes: string[]): string => {
  const selected = (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== 'ALL');
  if (optionCodes.length === 0 || selected.length < optionCodes.length) return value;
  const selectedSet = new Set(selected);
  return optionCodes.every(code => selectedSet.has(code)) ? 'ALL' : value;
};

/** 'ALL' / 빈 값을 sentinel 로 걸러 콤마 코드 배열만 남긴다 — cascade-combo-filter.md §2.2. */
const toSelectedCodes = (value: string): string[] =>
  (value ?? '')
    .split(',')
    .map(code => code.trim())
    .filter(code => code !== '' && code.toUpperCase() !== 'ALL');

/**
 * Division 선택값으로 콤보/lookup 행을 client-side 필터링 — AS-IS `RefreshPlanGroupByDivision`/
 * `RefreshStageByDivision`(`DBUtils.Filter(dtXxxAll, "DIVISION_ID = division")`,
 * design/02_search-combo.md §2-2·§2-4)을 재조회 없는 필터 방식으로 재현한다
 * (plan-group-dashboard.util.ts `buildDivisionFilteredOptions` 표준 패턴 재사용).
 */
export const buildDivisionFilteredOptions = (
  rows: ComboResponse[] | undefined,
  divisionId: string,
  codeColumn = 'CODE',
  nameColumn = 'NAME'
): { label: string; value: string }[] => {
  const divisionCodes = toSelectedCodes(divisionId);

  const byCode = new Map<string, { label: string; value: string }>();
  for (const row of rows ?? []) {
    const code = String(row[codeColumn] ?? '').trim();
    if (code === '') continue;
    if (divisionCodes.length > 0) {
      const rowDivision = String(row.DIVISION_ID ?? '').trim();
      if (rowDivision !== '' && !divisionCodes.includes(rowDivision)) continue;
    }
    if (byCode.has(code)) continue;
    byCode.set(code, { label: String(row[nameColumn] ?? code), value: code });
  }
  return [...byCode.values()];
};
