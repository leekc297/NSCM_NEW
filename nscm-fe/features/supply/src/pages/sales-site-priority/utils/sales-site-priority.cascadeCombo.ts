// SCP0131 Plan Group/Site 콤보 좁힘 — 조회영역 cascade(design 02 §3) + 그리드 셀 콤보(design 03 §2.2).
//   AS-IS 는 dtPlanGroupAll/dtScmSiteAll 을 全件 로드한 뒤 DBUtils.Filter(클라 RowFilter)로만
//   좁힌다(재조회 없음, filterCalls#1~#3/#6). admin 셀콤보 메타 PARAM2/9/10 전부 공란 =
//   이 좁힘 미이관 -> FE 로 재현(design 03 §6#5 FAIL 방지, convert-core §2.6 재현 원칙).

import type { CascadeComboSource } from '../sales-site-priority.types';

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

// Division 기준 클라 필터(design 02 §2-2 filterCalls#1, "DIVISION_ID='{division}'").
//   division 미선택 시 빈 배열(하위 콤보를 영영 못 여는 교착 방지 — 상위 선택 전까지는 후보 없음).
export const filterByDivision = (
  rows: CascadeComboSource[],
  divisionId: string
): CascadeComboSource[] => {
  if (!divisionId) return [];
  return rows.filter(r => r.DIVISION_ID === divisionId);
};

// Site 전용 기저 필터(design 02 §2-3 filterCalls#2, 정적 리터럴) — Division 선택 여부와 무관하게
//   상시 적용. gap-audit iter-1 SCP0131-G01 해소 후에는 SiteMasterAll_SCP 가 DIVISION_ID 를
//   반환하지 않아 클라 필터가 불가능하므로, SalesSitePriorityForm 이 이 리스트를 서버 `@divisionId`
//   파라미터(선택 division 과의 교집합)로 실어 재현한다(클라 필터 함수는 더 이상 쓰지 않음).
export const SITE_BASE_DIVISIONS = ['81', '40', '82'] as const;

// AS-IS RefreshSiteByDivision(.cs:254-268) + GetDivisionChecked(.cs:209-238) 재현 — division 선택 시
//   'EE' 만 81/82/40 합집합, 그 외에는 GetDivisionChecked 매핑값(EE_UC->81_UC 등, 그 외 원본 유지)
//   단일값으로 좁힌다. base3(SITE_BASE_DIVISIONS) 교집합으로 비3종 division 을 전부 비워
//   division 필터가 통째로 꺼지던 결함 수정(runtime-parity-gate SCP0131 v1 §3.3).
const EE_DIVISION_ALIAS: Record<string, string> = {
  EE_UC: '81_UC',
  EE_HM: '81_HM',
  EE_ST: '81_ST',
  EE_HD: '81_HD',
  EE_HG: '81_HG',
};

export const resolveSiteDivisionParam = (divisionId: string): string => {
  if (!divisionId || divisionId === 'EE') return SITE_BASE_DIVISIONS.join(',');
  return EE_DIVISION_ALIAS[divisionId] ?? divisionId;
};

export const toOptions = (rows: CascadeComboSource[]): { label: string; value: string }[] =>
  rows.map(r => ({ label: r.NAME || r.CODE, value: r.CODE }));

// 붙여넣기 시 Plan Group 표시명(NAME) -> 코드(CODE) 역변환(AS-IS SpdMain_ClipboardPasted l1060~1064,
//   design 03 §3.2 SetValue(1064)). row 의 DIVISION_ID 로 좁힌 후보 중 NAME 완전일치만 변환 —
//   AS-IS 도 FirstOrDefault 로 미일치 시 예외였으나, TO-BE 는 미일치를 무동작(pasted text 유지)으로
//   안전 처리한다(크래시 재현은 대상 아님).
export const findPlanGroupCodeByName = (
  rows: CascadeComboSource[],
  divisionId: string,
  name: string
): string | undefined => filterByDivision(rows, divisionId).find(r => r.NAME === name)?.CODE;
