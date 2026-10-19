import type { ComboResponse } from '@foundation/models';

import { ACTIVITY, EXECUTED_ACTIVITY_CODES, MSG, RUN_STATUS } from '../plan-control.constants';
import type { PlanControlRow, PlanControlSearchParams } from '../plan-control.types';

export const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

interface Option {
  label: string;
  value: string;
}

// 콤보 응답(CODE/NAME) -> 드롭다운 옵션. 순서를 보존한다 — 이 화면의 3개 목록은 전부 서버 정렬을
//   지켜야 하므로 buildComboOptions(value.localeCompare 재정렬)를 쓰면 안 된다(design 02 §5).
export const toComboOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) }));

// 조회 파라미터 planStartYyyymmdd 의 소스는 Plan Date 모드로 갈린다(F03·F05·F07~F10 6곳 중복 →
//   단일 파생함수로 통합. 의미 동일 — 축소 아님). 일단위는 DatePicker(yyyyMMdd), 주단위는 콤보 CODE.
export const resolvePlanStartYyyymmdd = (
  searchParams: PlanControlSearchParams,
  isDailyPlanDateMode: boolean
): string =>
  isDailyPlanDateMode
    ? searchParams.planDate.replace(/-/g, '')
    : searchParams.planDateCode;

// Division 후보 = 권한 Division ∩ Plan Group 보유 Division (AS-IS F01, cs:183-196).
//   "Plan Group 이 하나라도 등록된 Division 만 남긴다". 이 교집합을 빼면 TO-BE 후보가 AS-IS 보다
//   넓어진다 — CMBO SQL 에는 없는 클라 전용 필터다(convert-core §2.6 핵심 원칙).
//   두 원천 중 하나라도 아직 도착 전이면 빈 배열(옵션을 성급히 넓게 보여주지 않는다).
export const buildDivisionOptions = (
  divisions: ComboResponse[] | undefined,
  planGroups: { DIVISION_ID?: unknown }[] | undefined
): Option[] => {
  if (!divisions || !planGroups) return [];
  const allowed = new Set(planGroups.map(row => str(row.DIVISION_ID)));
  return toComboOptions(divisions.filter(row => allowed.has(str(row.CODE))));
};

// X12 CheckPreStepCompleted (AS-IS cs:1186-1258) — 그리드 행 순서대로 훑으며 OPTION_YN != 'Y' 인
//   행의 상태만 기억하고, 대상 Activity 행에 도달했을 때 직전 필수 Activity 가 'C'(Completed) 인지 본다.
//   첫 행이면 기억한 상태가 공백이라 false 다. DB 재조회 없이 화면 상태만 본다.
export const isPreStepCompleted = (rows: PlanControlRow[], actvCd: string): boolean => {
  let preStatus = '';
  for (const row of rows) {
    if (str(row.OPMZ_ACTV_CD) === actvCd) return preStatus === RUN_STATUS.COMPLETED;
    // OPTION_YN='Y'(실측 A004·A005·A009)는 선행 판정 대상에서 제외한다.
    if (str(row.OPTION_YN) !== 'Y') preStatus = str(row.OPMZ_ACTV_RUN_STAT_CD);
  }
  return false;
};

// 저장 payload 의 planId — 독립 실행 Activity(INDP_YN='Y')는 Plan ID 를 쓰지 않고 '-' 를 보낸다
//   (AS-IS cs:719-726). 이 값이 SP 의 LEFT JOIN 키가 되므로 잘못 보내면 다음 조회가 어긋난다.
export const resolveSavePlanId = (row: PlanControlRow): string =>
  str(row.OPMZ_PLAN_ID_INDP_YN) === 'Y' ? '-' : str(row.OPMZ_PLAN_ID);

// 저장 성공 Toast 의 MSG 코드(AS-IS cs:756-781). 해당 없는 Activity(A001·A002·A007·A008 의 비Confirm
//   경로)는 AS-IS 도 빈 문자열이라 Toast 를 띄우지 않는다 — 임의로 "저장되었습니다" 를 붙이지 않는다.
//   문구 자체가 아니라 코드를 돌려준다(다국어 원천은 번들이다).
export const resolveSaveMessage = (row: PlanControlRow): string => {
  if (str(row.CONFIRM_YN) === 'Y') return MSG.SAVE_CONFIRMED;
  const actvCd = str(row.OPMZ_ACTV_CD);
  if (EXECUTED_ACTIVITY_CODES.includes(actvCd)) return MSG.SAVE_EXECUTED;
  if (actvCd === ACTIVITY.RELEASE) return MSG.SAVE_RELEASED;
  return '';
};

// DETAIL 파생 셀(G06·G17) — A001 행 + Master Validation 조회 완료 상태일 때만 표시한다.
export const formatValidationDetail = (criticalCnt: number, warningCnt: number): string =>
  `Critical : ${criticalCnt}, Warning : ${warningCnt}`;
