import type { TreeData } from '@shared/lges';

import type { OrgTreeRow } from '../../pages/project-registration/project-registration.types';

export type OrgTreeNode = OrgTreeRow &
  Omit<TreeData, 'childrens'> & {
    childrens?: OrgTreeNode[];
  };

// 프로시저의 UPPER_DEPT_ID를 부모 키로 사용해 디자인시스템 Tree 데이터로 조립한다.
// selectedDeptId 를 주면 그 부서 노드에 isSelected 를 켠다 — Tree 는 내부 선택 상태를 data 로
// 초기화하므로 팝업이 열릴 때 대상 부서가 클릭된 상태로 보이고, 이후 다른 노드를 클릭하면
// Tree 내부 로직이 나머지 노드의 isSelected 를 알아서 끈다(단일 선택).
export const buildOrgTree = (rows: OrgTreeRow[], selectedDeptId = ''): OrgTreeNode[] => {
  const nodes = rows.flatMap<OrgTreeNode>(row => {
    const deptId = String(row.DEPT_ID ?? '').trim();
    if (!deptId) return [];
    return [
      {
        ...row,
        DEPT_ID: deptId,
        UPPER_DEPT_ID: String(row.UPPER_DEPT_ID ?? '').trim() || null,
        checked: false,
        isSelected: deptId === selectedDeptId,
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

// 조직도에서 특정 부서까지의 루트→대상 경로 DEPT_ID 목록을 만든다. 디자인시스템 Tree 의
// expandedNodes 는 "id 가 포함된 노드를 펼침"이므로, 조상 전부와 대상 부서 자신을 함께 담아야
// 트리를 열었을 때 그 부서가 펼쳐진 상태로 보인다. 못 찾으면 빈 배열(기본 펼침 없음).
export const collectDeptPathIds = (nodes: OrgTreeNode[], deptId: string): string[] => {
  if (!deptId) return [];
  for (const node of nodes) {
    if (node.DEPT_ID === deptId) return [node.DEPT_ID];
    const childPath = collectDeptPathIds(node.childrens ?? [], deptId);
    if (childPath.length > 0) return [node.DEPT_ID, ...childPath];
  }
  return [];
};
