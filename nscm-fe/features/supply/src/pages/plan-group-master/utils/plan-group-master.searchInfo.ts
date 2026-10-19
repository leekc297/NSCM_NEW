// 조회조건 체크리스트 5개 = 콤보 레지스트리가 아니라 GET_SEARCH_INFO 1콜 결과를 클라에서 좁힌다
//   (02_search-combo.md §2-B/§3). cascade 는 전건 "필터 방식"(서버 재조회 아님).
import { safeString } from '@foundation/utils';

import { ALL } from '../plan-group-master.constants';
import type { ComboOption, LineInfoRow, SearchInfoRow } from '../plan-group-master.types';

// SP 커서 값 타입은 unknown — String(v??'') 는 no-base-to-string 에 걸린다. 공용 safeString(원시값만 변환) 경유.
const str = (v: unknown): string => safeString(v).trim();

/** CODE/NAME → 드롭다운 옵션. */
const toOption = (row: SearchInfoRow): ComboOption => ({
  label: str(row.NAME) || str(row.CODE),
  value: str(row.CODE),
});

/** 선택 Division 으로 좁힘 (02 §2-B filterCall 1/3/5/6). */
const byDivision = (rows: readonly SearchInfoRow[], division: string): SearchInfoRow[] =>
  rows.filter(r => str(r.DIVISION_ID) === str(division));

/** CODE 중복제거 (Plant GetDistinctTable 등가, SRCH-05). 첫 등장 순서 유지. */
const distinctByCode = (rows: readonly SearchInfoRow[]): SearchInfoRow[] => {
  const seen = new Set<string>();
  const out: SearchInfoRow[] = [];
  for (const r of rows) {
    const code = str(r.CODE);
    if (seen.has(code)) continue;
    seen.add(code);
    out.push(r);
  }
  return out;
};

export const buildOperationOptions = (
  rows: readonly SearchInfoRow[],
  division: string
): ComboOption[] => byDivision(rows, division).map(toOption);

export const buildPlantOptions = (
  rows: readonly SearchInfoRow[],
  division: string
): ComboOption[] => distinctByCode(byDivision(rows, division)).map(toOption);

export const buildBuildingOptions = (
  rows: readonly SearchInfoRow[],
  division: string
): ComboOption[] => byDivision(rows, division).map(toOption);

export const buildPlanGroupOptions = (
  rows: readonly SearchInfoRow[],
  division: string
): ComboOption[] => byDivision(rows, division).map(toOption);

/** CustomDropdown multiple 값(CSV/'ALL'/'') → CODE 배열. */
const parseSel = (csv: string): string[] => str(csv).split(',').map(s => s.trim()).filter(Boolean);

/**
 * 한 축의 선택값 매칭 — AS-IS Line 필터의 `OPERATION_ID IN (...)` 재현 (02 §2-B filterCall 4).
 * · 'ALL' 포함(기본값) → 제약 없음(전체 통과).
 * · 빈 선택(사용자가 전부 해제) → `IN ('')` AS-IS 그대로 = 공백 값만 매칭(사실상 0건).
 * · 그 외 → 선택 CODE 집합에 포함되는 행만.
 */
const axisMatch = (rowValue: string, selectedCsv: string): boolean => {
  const selected = parseSel(selectedCsv);
  if (selected.includes(ALL)) return true;
  if (selected.length === 0) return rowValue === '';
  return selected.includes(rowValue);
};

/**
 * Line = Division + 선택 Operation/Plant/Building 다축 IN 필터 (02 §2-B filterCall 4).
 * 상위(Op/Plant/Building) 미선택 축은 axisMatch 규약(ALL=통과 / 빈=IN('')) 을 따른다.
 */
export const buildLineOptions = (
  rows: readonly LineInfoRow[],
  division: string,
  selectedOperation: string,
  selectedPlant: string,
  selectedBuilding: string
): ComboOption[] =>
  rows
    .filter(
      r =>
        str(r.DIVISION_ID) === str(division) &&
        axisMatch(str(r.OPERATION_ID), selectedOperation) &&
        axisMatch(str(r.PLANT_ID), selectedPlant) &&
        axisMatch(str(r.FACTORY_ID), selectedBuilding)
    )
    .map(toOption);

/**
 * 체크리스트 선택값(CSV/'ALL') → 그리드 조회 SP 파라미터 CSV.
 * 'ALL'/빈 선택 → 공백(AS-IS FindData 미선택/ALL → 파라미터 공백, SRCH-06).
 */
export const toParamCsv = (selectedCsv: string): string => {
  const selected = parseSel(selectedCsv);
  if (selected.length === 0 || selected.includes(ALL)) return '';
  return selected.join(',');
};

/**
 * 선택값(CSV/'ALL') 정규화 — 유효 옵션에 없는 값은 버리고, 아무것도 안 남으면 전체('ALL').
 * Division/상위축 변경 시 하위 선택이 새 범위를 벗어나면 리셋하는 데 쓴다.
 */
export const pruneSelection = (selectedCsv: string, options: readonly ComboOption[]): string => {
  const selected = parseSel(selectedCsv);
  if (selected.includes(ALL)) return ALL;
  const valid = new Set(options.map(o => o.value));
  const kept = selected.filter(v => valid.has(v));
  return kept.length > 0 ? kept.join(',') : ALL;
};
