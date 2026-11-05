// SCP0125 조회조건 cascade — **필터 방식**(서버 재호출 0). 원천 2개를 mount 시 전건 받아 클라에서
//   좁힌다(design 02_search-combo.md §3.2 결론). `useCascadeFields` 는 "조인 평면 콤보 1건" 전제라
//   부적합하다 — 이 화면의 두 원천은 서로 다른 SP 이고 단계 키도 공유하지 않는다(§5.3).
//
// 이관된 CMBO SQL 에는 division 필터가 없다(AS-IS 가 C# 에서 후처리했다) → 여기서 재현하지 않으면
//   후보 범위가 AS-IS 보다 넓어진다(convert-core §2.6 핵심 원칙).
//
// AS-IS 근거: F02 cs:275(`DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '{division}'")`) ·
//             F03 cs:283~289(division + planStart ~ +6일 범위)

import dayjs from 'dayjs';

import type { ComboResponse } from '@foundation/models';

import { COL } from '../workbench.constants';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** F02 — Division → Plan Date(주단위) 후보. */
export const filterPlanDates = (
  all: ComboResponse[] | undefined,
  divisionId: string
): ComboResponse[] => {
  if (!divisionId) return [];
  return (all ?? []).filter(row => str(row[COL.DIVISION_ID]) === divisionId);
};

/**
 * F03 — (Division, Plan Date) → MKT FCST Ver. 후보. 범위는 `planStart` ~ `planStart + 6일`
 * (AS-IS `dtEnd_yyyymmdd = dtStart.AddDays(6)` cs:285~286).
 */
export const filterVersions = (
  all: ComboResponse[] | undefined,
  divisionId: string,
  planStartYyyymmdd: string
): ComboResponse[] => {
  if (!divisionId || !planStartYyyymmdd) return [];
  const start = dayjs(planStartYyyymmdd, 'YYYYMMDD');
  if (!start.isValid()) return [];
  const end = start.add(6, 'day').format('YYYYMMDD');
  return (all ?? []).filter(
    row =>
      str(row[COL.DIVISION_ID]) === divisionId &&
      str(row[COL.YYYYMMDD]) >= planStartYyyymmdd &&
      str(row[COL.YYYYMMDD]) <= end
  );
};

/**
 * Plan Date 콤보 표시명 정리 — **현재는 no-op 방어층이다**(2026-09-26 정정).
 *
 * 설계 §7 U2 는 공유 SQL_ID `OPMZ_DATE_WEEKLY_SCP_ALL` 이 `TO_CHAR(...,'YYYY-MM-DD HH24:MI:SS')`
 * 로 19자를 내려준다고 적었으나, **등록 SQL 실측 결과 시각이 없다** —
 * `TO_CHAR(FN_CHAR_TO_DATE(A.PLAN_NAME),'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')'`
 * (SCP0123 전환이 10자로 정정했고 감사컬럼이 그것을 보여준다). 따라서 아래 정규식은 매치되지 않는다.
 * 공유 SQL 이 다시 19자로 돌아갈 경우를 대비한 무해한 방어층으로만 남긴다 — CODE 는 손대지 않으므로
 * 조회 결과에 영향이 없다. SQL 본문 수정은 **SCP0123 과 공유**라 금지(hook #117 §3).
 */
export const stripTimeFromLabel = (label: string): string =>
  label.replace(/(\d{4}-\d{2}-\d{2}) \d{2}:\d{2}:\d{2}/, '$1');
