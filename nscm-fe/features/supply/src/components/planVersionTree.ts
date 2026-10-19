import type { ComboResponse } from '@foundation/models';
import type { CascadeNode } from '@shared/components';

// Plan Date → Plan Type → Seq 같은 종속 콤보(_SCP_ALL 전량)를 공유 CascadeDropdown 트리로 재구성한다.
//   콤보 반환 컬럼으로 상위-하위를 잇고(parentKeys), 전량이라 DIVISION_ID 로 먼저 거른다. 단계 수는
//   levels 배열로 결정 — 2단계(date→type)든 3단계(date→type→seq)든 N단계든 같은 트리 로직을 쓴다
//   (AS-IS 재조회 cascade 의 전량+클라필터 등가, convert-core §2.6). PlanVersionCascade 가 이 트리를 그린다.
type Row = Record<string, unknown>;

// 종속 콤보 한 단계 정의. name 키로 선택값이 담기고, rows 는 이 단계 콤보 행(전량)이다.
//   parentKeys 는 이 단계 rows 에서 상위 단계 선택값과 맞춰야 할 컬럼을 조상 순서대로 준다.
//     date  → parentKeys 없음(최상위)
//     type  → ['PLANDATE']            (date 의 CODE 와 매칭)
//     seq   → ['PLANDATE', 'PLANTYPE'] (date·type 의 CODE 와 매칭)
export interface PlanVersionLevel {
  name: string;
  label: string;
  rows: ComboResponse[] | undefined;
  parentKeys?: string[];
  required?: boolean;
}

const cell = (row: Row, key: string): string => {
  const v = row[key];
  return typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
};

const toNode = (row: Row): CascadeNode => ({
  value: cell(row, 'CODE'),
  label: cell(row, 'NAME') || cell(row, 'CODE'),
});

// 같은 value 중복 제거(division 외 축으로 콤보가 넓게 올 수 있다 — 표시 기준 first-wins).
const dedupe = (nodes: CascadeNode[]): CascadeNode[] => {
  const seen = new Map<string, CascadeNode>();
  for (const node of nodes) if (node.value && !seen.has(node.value)) seen.set(node.value, node);
  return [...seen.values()];
};

// levels 를 N단계 재귀로 CascadeNode 트리화. 각 단계에서 division + parentKeys(조상 선택값) 로 거른다.
//   3단계(date/type/seq)일 때 기존 buildPlanVersionTree 와 동일 결과.
export const buildPlanVersionTree = (
  levels: PlanVersionLevel[],
  divisionId: string
): CascadeNode[] => {
  const inDiv = (r: Row): boolean => !divisionId || cell(r, 'DIVISION_ID') === divisionId;
  const recurse = (depth: number, ancestors: string[]): CascadeNode[] => {
    const level = levels[depth];
    if (!level) return [];
    const parentKeys = level.parentKeys ?? [];
    const matched = (level.rows ?? []).filter(
      r => inDiv(r) && parentKeys.every((col, j) => cell(r, col) === ancestors[j])
    );
    const nodes = dedupe(matched.map(toNode));
    if (depth === levels.length - 1) return nodes;
    return nodes.map(node => ({
      ...node,
      children: recurse(depth + 1, [...ancestors, node.value]),
    }));
  };
  return recurse(0, []);
};
