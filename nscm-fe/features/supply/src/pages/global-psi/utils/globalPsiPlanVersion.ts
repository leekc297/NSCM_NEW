import type { CascadeNode } from '@shared/components';

// Plan Date → Plan Type → Seq 종속 콤보(_SCP_ALL 전량)를 CascadeDropdown 트리로 재구성한다.
//   콤보 반환 컬럼으로 상위-하위를 잇는다: type 행은 PLANDATE, seq 행은 PLANDATE+PLANTYPE 로 묶는다
//   (AS-IS CommonAll + DBUtils.Filter 클라 재현과 동치, convert-core §2.6). 전량이라 DIVISION_ID 로 먼저 거른다.
//   자매 SCP0013 ProductionPlanLineForm 의 buildPlanVersionTree 와 동일 규약(반환컬럼 DIVISION_ID/PLANDATE/PLANTYPE).
type Row = Record<string, unknown>;

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

export const buildPlanVersionTree = (
  planDates: Row[],
  planTypes: Row[],
  planSeqs: Row[],
  divisionId: string
): CascadeNode[] => {
  const inDiv = (r: Row): boolean => !divisionId || cell(r, 'DIVISION_ID') === divisionId;
  return dedupe(planDates.filter(inDiv).map(toNode)).map(date => ({
    ...date,
    children: dedupe(
      planTypes.filter(r => inDiv(r) && cell(r, 'PLANDATE') === date.value).map(toNode)
    ).map(type => ({
      ...type,
      children: dedupe(
        planSeqs
          .filter(
            r =>
              inDiv(r) && cell(r, 'PLANDATE') === date.value && cell(r, 'PLANTYPE') === type.value
          )
          .map(toNode)
      ),
    })),
  }));
};
