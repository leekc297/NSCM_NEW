import type { TreeData } from '@shared/lges';

import type { OrgTreeRow } from '../../project-registration.types';

export type OrgTreeNode = OrgTreeRow &
  Omit<TreeData, 'childrens'> & {
    childrens?: OrgTreeNode[];
  };

// 프로시저의 UPPER_DEPT_ID를 부모 키로 사용해 디자인시스템 Tree 데이터로 조립한다.
export const buildOrgTree = (rows: OrgTreeRow[]): OrgTreeNode[] => {
  const nodes = rows.flatMap<OrgTreeNode>(row => {
    const deptId = String(row.DEPT_ID ?? '').trim();
    if (!deptId) return [];
    return [
      {
        ...row,
        DEPT_ID: deptId,
        UPPER_DEPT_ID: String(row.UPPER_DEPT_ID ?? '').trim() || null,
        checked: false,
        id: deptId,
        nodeName: String(row.DEPT_NAME ?? '').trim() || deptId,
      } satisfies OrgTreeNode,
    ];
  });
  const byCode = new Map(nodes.map(node => [node.DEPT_ID, node]));
  const roots: OrgTreeNode[] = [];
  const levelPath: OrgTreeNode[] = [];

  for (const node of nodes) {
    const level = Math.max(1, Number(node.LEVEL_NO) || 1);
    const parent =
      (node.UPPER_DEPT_ID ? byCode.get(node.UPPER_DEPT_ID) : undefined) ?? levelPath[level - 2];
    if (!parent || parent === node) {
      roots.push(node);
    } else {
      parent.childrens = [...(parent.childrens ?? []), node];
    }
    levelPath.length = level;
    levelPath[level - 1] = node;
  }

  return roots;
};
