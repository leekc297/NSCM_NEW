import type { ComboResponse } from '@foundation/models';

/**
 * ⭐ 조회조건 팝업 3종(Owner / Model·Nickname / Project) 공통 가로 폭 (2026-08-06 사용자 요청 —
 *   "owner, model, project 세 개 사이즈 같도록"). 이전에는 1200 / 1000 / 1000 으로 제각각이라
 *   같은 조회조건 행에서 팝업을 띄울 때마다 크기가 달라 보였다.
 *
 * ⚠ CustomDialog 는 size 에 DIALOG_SCALE(1.5) 을 곱한다 → 실제 렌더 폭 = 900 * 1.5 = 1350px.
 *   값 산정 기준은 셋 중 컬럼이 가장 많은 Model/Nickname(11컬럼) — 더 줄이면 Team 등 긴 텍스트
 *   컬럼의 말줄임이 심해진다.
 *
 * 위치 — 이 셋은 SearchFields 카탈로그(Project/Item/OwnerField)가 띄우는 팝업이라 카탈로그
 *   유틸에 둔다. SearchFields.tsx 본체는 세 모달을 import 하므로 거기 두면 순환이 된다.
 */
export const SEARCH_POPUP_WIDTH = 900;

// ====================================================================================
// 조회조건 팝업 3종(Project / Item / Owner) 공용 — Div/Team 으로 좁히는 콤보 옵션
// ====================================================================================
/**
 * 콤보 행에서 먼저 값이 있는 컬럼을 고른다. 공백만 든 셀은 없는 값으로 본다.
 * 컬럼명이 바뀌는 과도기에 양쪽 이름을 다 견디기 위한 것이다.
 */
const pick = (row: ComboResponse, ...columns: string[]): string => {
  for (const column of columns) {
    const raw = row[column] as string | number | null | undefined;
    if (raw === null || raw === undefined) continue;
    const value = String(raw).trim();
    if (value !== '') return value;
  }
  return '';
};

/**
 * 콤보 한 행을 화면이 쓰는 모양으로 읽는다. 컬럼명은 풀네임을 먼저 보고 없으면 종전 이름으로
 * 떨어진다.
 *
 * 이 콤보들은 CascadeFields 규약에 맞춰 풀네임 컬럼(DIVISION_CODE / TEAM_CODE /
 * END_CUSTOMER / SALES_SITE_CODE ...)으로 개정되는 중인데, 같은 SQL_ID 를 쓰는 화면 중에는
 * 아직 종전 이름(DIVISION_ID / DEPT_ID / CODE / NAME)으로 읽는 곳이 남아 있다. 어느 쪽으로
 * 내려오든 목록이 비지 않게 한다.
 */
const readRow = (row: ComboResponse, codeColumns: string[], nameColumns: string[]) => ({
  divisionCode: pick(row, 'DIVISION_CODE', 'DIVISION_ID'),
  teamCode: pick(row, 'TEAM_CODE', 'DEPT_ID'),
  code: pick(row, ...codeColumns),
  name: pick(row, ...nameColumns),
});

interface ComboOptionArgs {
  rows: ComboResponse[] | undefined;
  divisionId?: string;
  deptId?: string;
  /** 현재 선택돼 있는 값. 목록에서 탈락하지 않도록 보존한다. */
  selected?: string;
}

/**
 * division 으로 자르고 team 으로 좁힌 뒤 코드 기준 중복을 없앤 옵션 목록.
 *
 * team 은 관대하게 통과시킨다 — 콤보 행의 팀은 owner 기준이라 NULL 이 많고 그리드 팀
 * (SITE_ITEM.DEPT_ID)과 기준도 달라, 엄격하게 자르면 이미 선택돼 있는 값이 옵션에서 빠진다.
 * 팝업의 이 콤보들은 disabled 표시 전용이라 옵션에 없는 값은 화면에서 그냥 사라져(ALL 로
 * 보여) 조회조건이 안 넘어온 것처럼 보인다. 그래서 팀이 빈 행과 이미 선택된 값은 남긴다.
 */
const buildOptions = (
  { rows, divisionId, deptId, selected }: ComboOptionArgs,
  codeColumns: string[],
  nameColumns: string[]
) => {
  const deptFilter = (deptId ?? '').split(',').filter(Boolean);
  const selectedCodes = (selected ?? '').split(',').filter(Boolean);
  const skipTeamFilter = deptFilter.length === 0 || deptFilter.includes('ALL');

  return [
    ...new Map(
      (rows ?? [])
        .map(row => readRow(row, codeColumns, nameColumns))
        .filter(
          row =>
            row.code !== '' &&
            row.divisionCode === divisionId &&
            (skipTeamFilter ||
              row.teamCode === '' ||
              deptFilter.includes(row.teamCode) ||
              selectedCodes.includes(row.code))
        )
        .map(row => [row.code, { label: row.name || row.code, value: row.code }] as const)
    ).values(),
  ];
};

/** 'EndCustomer' 콤보 -> End Customer 드롭다운 옵션. */
export const buildEndCustomerOptions = (args: ComboOptionArgs) =>
  buildOptions(args, ['END_CUSTOMER', 'CODE'], ['END_CUSTOMER_NAME', 'NAME']);

/** 'SalesSite' 콤보 -> Sales Site 드롭다운 옵션. */
export const buildSalesSiteOptions = (args: ComboOptionArgs) =>
  buildOptions(args, ['SALES_SITE_CODE', 'CODE'], ['SALES_SITE_NAME', 'NAME']);
