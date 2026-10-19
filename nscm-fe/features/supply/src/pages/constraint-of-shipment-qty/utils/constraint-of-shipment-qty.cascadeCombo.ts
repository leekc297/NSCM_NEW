// SCP0132 Plan Group/From Site/To Site/Stage/Model Group 5갈래 fan-out 좁힘(design 02 §3).
//   AS-IS 는 dtPlanGroupAll/dtFromSiteAll/dtToSiteAll/dtStageAll/dtModelGroupAll 을 全件 로드한 뒤
//   DBUtils.Filter(클라 RowFilter)로 동시에(순차 아님) 좁힌다(filterCalls#1~#7) — DMF0020류
//   단계형 useCascadeFields 체인과 달리 "1 Division 트리거 -> N 독립 필터" 구조.

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

// From/To Site 전용 기저 필터(design 02 §2.3/§3 filterCalls#2/#3, 정적 리터럴) — Division 필터보다
//   선행 적용. 업무적 의미(배터리 셀 3개 사업부 한정 추정)는 소스 미확인(확인 필요).
export const SITE_BASE_DIVISIONS = ['81', '40', '82'] as const;

export const filterSiteBase = (rows: CascadeComboSource[]): CascadeComboSource[] =>
  rows.filter(r => (SITE_BASE_DIVISIONS as readonly string[]).includes(r.DIVISION_ID));

export const toOptions = (rows: CascadeComboSource[]): { label: string; value: string }[] =>
  rows.map(r => ({ label: r.NAME || r.CODE, value: r.CODE }));
