// SCP0132 Plan Group/From Site/To Site/Stage/Model Group 5갈래 fan-out 좁힘(design 02 §3).
//   AS-IS 는 dtPlanGroupAll/dtFromSiteAll/dtToSiteAll/dtStageAll/dtModelGroupAll 을 全件 로드한 뒤
//   DBUtils.Filter(클라 RowFilter)로 동시에(순차 아님) 좁힌다(filterCalls#1~#7) — DMF0020류
//   단계형 useCascadeFields 체인과 달리 "1 Division 트리거 -> N 독립 필터" 구조.

import { INIT_SET } from '../constraint-of-shipment-qty.constants';
import type { CascadeComboSource } from '../constraint-of-shipment-qty.types';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const toCascadeSource = (rows: readonly unknown[] | undefined): CascadeComboSource[] =>
  (rows ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return {
      CODE: s(rec.CODE),
      NAME: s(rec.NAME),
      DIVISION_ID: s(rec.DIVISION_ID),
    };
  });

// Division 기준 클라 필터(design 02 §3 filterCalls#1/#4/#5/#6/#7). division 미선택 시 빈 배열
//   (상위 선택 전까지는 하위 후보 없음 — 교착 방지).
export const filterByDivision = (
  rows: CascadeComboSource[],
  divisionId: string
): CascadeComboSource[] => {
  if (!divisionId) return [];
  return rows.filter(r => r.DIVISION_ID === divisionId);
};

// From/To Site 를 거를 사업부 — AS-IS RefreshSiteByDivision + GetDivisionChecked(.cs:236~287):
//   EE 는 81·40·82 사이트, EE_UC·EE_HM·EE_ST·EE_HD·EE_HG 는 81_* 사이트, 그 밖은 선택 Div 그대로(갭분석 C-03·C-19).
const SITE_DIVISION_MAP: Record<string, readonly string[]> = {
  EE: ['81', '40', '82'],
  EE_UC: ['81_UC'],
  EE_HM: ['81_HM'],
  EE_ST: ['81_ST'],
  EE_HD: ['81_HD'],
  EE_HG: ['81_HG'],
};

export const siteDivisionsOf = (divisionId: string): readonly string[] =>
  SITE_DIVISION_MAP[divisionId] ?? [divisionId];

export const isMappedSiteDivision = (divisionId: string): boolean =>
  divisionId in SITE_DIVISION_MAP;

export const filterSiteByDivision = (
  rows: CascadeComboSource[],
  divisionId: string
): CascadeComboSource[] => {
  if (!divisionId) return [];
  const divisions = siteDivisionsOf(divisionId);
  return rows.filter(r => divisions.includes(r.DIVISION_ID));
};

export const toOptions = (rows: CascadeComboSource[]): { label: string; value: string }[] =>
  rows.map(r => ({ label: r.NAME || r.CODE, value: r.CODE }));

// 선택 Div 의 조회조건 목록 5갈래 — 조회조건 칸과 SELECT ALL 판정(setFilter)이 같은 목록을 본다.
export const buildSearchOptions = (
  initData: Record<string, readonly unknown[] | undefined> | undefined,
  divisionId: string
) => ({
  planGroup: toOptions(
    filterByDivision(toCascadeSource(initData?.[INIT_SET.PLAN_GROUP]), divisionId)
  ),
  fromSite: toOptions(
    filterSiteByDivision(toCascadeSource(initData?.[INIT_SET.FROM_SITE]), divisionId)
  ),
  toSite: toOptions(
    filterSiteByDivision(toCascadeSource(initData?.[INIT_SET.TO_SITE]), divisionId)
  ),
  stage: toOptions(filterByDivision(toCascadeSource(initData?.[INIT_SET.STAGE]), divisionId)),
  modelGroup: toOptions(
    filterByDivision(toCascadeSource(initData?.[INIT_SET.MODEL_GROUP]), divisionId)
  ),
});

export type SearchOptions = ReturnType<typeof buildSearchOptions>;

// 드롭다운이 목록에서 빼는 미지정 표기(CustomDropdown SENTINEL_VALUES) — SELECT ALL 도 이 값들은 열거하지 않는다.
const UNLISTED_VALUES = new Set(['', '-', '--']);

// 조회 인자 — 목록 전체를 고른 상태(SELECT ALL)면 AS-IS 처럼 빈 값을 보낸다(.cs:444~449
//   ControlValues.Equals("ALL") ? "" : ...). 값을 나열하면 프로그램이 200자에서 잘라 비교해 0건·일부 건이 된다(갭분석 C-05).
export const toSearchParam = (
  picked: readonly string[],
  options: readonly { value: string }[]
): string => {
  const listed = options.map(o => o.value).filter(v => !UNLISTED_VALUES.has(v.trim()));
  const pickedSet = new Set(picked);
  if (listed.length > 0 && listed.every(v => pickedSet.has(v))) return '';
  return picked.join(',');
};
