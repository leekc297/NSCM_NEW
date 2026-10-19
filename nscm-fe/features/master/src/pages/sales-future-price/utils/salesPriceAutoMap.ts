// Sales Price(DMF0020) 신규행 Team / End Customer 자동 매핑 헬퍼.
//   Business Plan(DMF0042) 의 "입력 불가 컬럼 + 기준정보 파생" 패턴을 그대로 따른다
//   (business-plan.editLock.ts insertStaticEditable 의 DEPT_ID40/END_CUSTOMER40=false 대응 +
//    business-plan.gridCombos.ts 의 콤보 rows → Map 변환 대응). 상세 근거는
//   sales-future-price.constants.ts SITE_EC_COMBO_ID / AUTO_MAPPED_COLUMNS 주석 참조.
import type { ComboResponse } from '@foundation/models';

import { AUTO_MAPPED_COLUMNS } from '../sales-future-price.constants';

// 셀/콤보 값 → 문자열 (unknown 안전 변환 — no-base-to-string 회피, 코드베이스 cellStr 패턴 동일).
const toStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 사용자가 직접 입력(콤보/타이핑/붙여넣기)할 수 없는 자동 매핑 컬럼 판정.
export const isAutoMappedColumn = (binding: string): boolean =>
  (AUTO_MAPPED_COLUMNS as readonly string[]).includes(binding);

// 콤보 'SiteEndCustomerMapDMF0082' 결과 → Map<SCM_SITE_ID, END_CUSTOMER>.
//   콤보 SQL (사용자 확인, 2026-09-08):
//     SELECT S.SCM_SITE_ID AS CODE, NVL(S.END_CUSTOMER, '-') AS NAME
//       FROM SCM_MGR.SCM_MST_SITE S
//      WHERE S.DIVISION_ID = TRIM(@divisionId)
//   NAME='-' 은 END_CUSTOMER 가 NULL 일 때의 센티널 → 유효 매핑 없음으로 보고 맵에 담지 않는다.
export const buildSiteEndCustomerMap = (
  rows: readonly ComboResponse[] | undefined
): Map<string, string> => {
  const map = new Map<string, string>();
  for (const row of rows ?? []) {
    const rec = row as Record<string, unknown>;
    const code = toStr(rec.CODE).trim();
    const name = toStr(rec.NAME).trim();
    if (!code || !name || name === '-') continue;
    if (!map.has(code)) map.set(code, name);
  }
  return map;
};

// Sales Site 코드 → End Customer 파생. Sales Site 공란/유효 매핑 없음이면 '' (호출부가 clear).
export const deriveEndCustomer = (
  map: Map<string, string>,
  siteCode: string | null | undefined
): string => {
  const code = String(siteCode ?? '').trim();
  if (!code) return '';
  return map.get(code) ?? '';
};

// SCM_SITE_ID 콤보의 관리자 PARAM2(콤보 후보 좁힘 바인딩)에서 End Customer 축 토큰만 떼어낸다.
//   End Customer 는 더 이상 사용자 입력이 아니라 Sales Site 에서 파생되는 값이므로, 신규행에서
//   공란인 그 값으로 Sales Site 후보를 좁히면 목록이 통째로 비거나 잘못 좁혀진다
//   (Business Plan BusinessPlanGrid 의 DROP_SITE_BINDS 와 같은 처리 — 이 화면 한정, 공용 메타 무수정).
//   PARAM2 형식: '행컬럼:콤보컬럼,행컬럼:바인드명,...'. 오른쪽(콤보컬럼/바인드명) 기준으로 제거.
const EC_BIND_TOKENS = new Set(['endcustomer', 'end_customer']);
export const stripEndCustomerComboBinding = (attribute2: string | undefined): string | undefined => {
  if (!attribute2) return attribute2;
  const kept = attribute2
    .split(',')
    .map(tok => tok.trim())
    .filter(tok => {
      if (!tok) return false;
      const right = (tok.split(':')[1] ?? '').trim().toLowerCase();
      return !EC_BIND_TOKENS.has(right);
    });
  return kept.join(',');
};
