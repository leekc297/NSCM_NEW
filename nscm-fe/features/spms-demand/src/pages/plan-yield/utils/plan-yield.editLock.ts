// ⭐ SDM2020 — 편집/표시 순수함수 (테스트 대상 — beginningEdit/formatItem 공용 단일 원천).
//   색(Yellow/Gray)과 편집 판정이 같은 함수를 본다 — 갈리면 "노란칸인데 못 고침" 사고.
import { CELL_CONTROL_TYPE } from '@foundation/constants';

import { toText } from '../../../lib/call-proc';
import { CHECK_STATE, isEditableInputTp } from '../../../lib/grid';
import {
  PERCENT_UOM_MARK,
  PLANT_CONFIRM_BINDING,
  PLANT_GROUP_BINDING,
  YIELD_GROUP_FLAG,
  YIELD_IS_GROUP_BINDING,
} from '../plan-yield.constants';
import type { PlantProgress } from '../plan-yield.types';

type Cell = Record<string, unknown>;

const isCheckbox = (ctrlType: string | undefined): boolean =>
  ctrlType === (CELL_CONTROL_TYPE.CHECKBOX as string);

// 인자 그룹 헤더행 판정 (IS_GROUP='Y' — 값 없음·편집 불가·회색)
export const isGroupRow = (row: Cell | undefined): boolean =>
  !!row && toText(row[YIELD_IS_GROUP_BINDING]) === YIELD_GROUP_FLAG;

// 요청법인 그리드 셀 편집 게이트 — INPUT_TP_CD 메타 단일 원천. 체크박스는 편집기 아닌 클릭 토글
export const isPlantCellEditable = (
  inputTpCd: string | undefined,
  ctrlType: string | undefined
): boolean => isEditableInputTp(inputTpCd) && !isCheckbox(ctrlType);

// 수율 그리드 셀 편집 게이트 — 컬럼 축(메타) × 행 축(그룹 헤더행 잠금)
export const isYieldCellEditable = (
  inputTpCd: string | undefined,
  ctrlType: string | undefined,
  row: Cell | undefined
): boolean => !!row && !isGroupRow(row) && isEditableInputTp(inputTpCd) && !isCheckbox(ctrlType);

// 단위가 백분율인가 ('[%]' — 커서 UOM 원문에 '%' 포함). formatYieldValue 내부 판정 전용
const isPercentUom = (uom: unknown): boolean => toText(uom).includes(PERCENT_UOM_MARK);

// Delta 표시 — 백분율 단위 = 소수 저장값(0.95) → '95.0%', 그 외 = 천단위 콤마. 비수치·빈 값은 원문
export const formatYieldValue = (value: unknown, uom: unknown): string => {
  const text = toText(value).trim();
  if (text === '') return '';
  const n = Number(text.replace(/,/g, ''));
  if (!Number.isFinite(n)) return text;
  if (isPercentUom(uom)) return `${(n * 100).toFixed(1)}%`;
  return n.toLocaleString('en-US');
};

// 요청법인 확인 진행률 — 구분(OPERATION_GROUP) 단위. 구분의 전 행이 CHECKED 면 확인 완료
export const plantProgress = (rows: Cell[]): PlantProgress => {
  const groups = new Map<string, boolean>();
  for (const row of rows) {
    const group = toText(row[PLANT_GROUP_BINDING]);
    if (!group) continue;
    const checked = toText(row[PLANT_CONFIRM_BINDING]) === CHECK_STATE.CHECKED;
    groups.set(group, (groups.get(group) ?? true) && checked);
  }
  const total = groups.size;
  const confirmed = [...groups.values()].filter(Boolean).length;
  return { confirmed, total, percent: total === 0 ? 0 : Math.round((confirmed / total) * 100) };
};

// 구분 첫 행 판정 — 확인 체크박스는 구분당 1개(첫 행)만 그린다 (목업: 구분 단위 체크 1개)
export const isFirstRowOfGroup = (rows: Cell[], index: number): boolean => {
  if (index < 0 || index >= rows.length) return false;
  if (index === 0) return true;
  return toText(rows[index][PLANT_GROUP_BINDING]) !== toText(rows[index - 1][PLANT_GROUP_BINDING]);
};

// index 행이 속한 구분의 연속 행 범위 [첫 행, 끝 행] — 구분/확인 컬럼 세로 병합 축 (인접 구분이 같은
//   값이어도 구분 경계를 넘지 않는다). 범위 밖 index 는 [index, index]
export const groupRowRange = (rows: Cell[], index: number): [number, number] => {
  if (index < 0 || index >= rows.length) return [index, index];
  const group = toText(rows[index][PLANT_GROUP_BINDING]);
  let start = index;
  let end = index;
  while (start > 0 && toText(rows[start - 1][PLANT_GROUP_BINDING]) === group) start--;
  while (end < rows.length - 1 && toText(rows[end + 1][PLANT_GROUP_BINDING]) === group) end++;
  return [start, end];
};
