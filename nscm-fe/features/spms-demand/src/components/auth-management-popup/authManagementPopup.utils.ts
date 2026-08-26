import type { TreeData } from '@shared/lges';

import type { OrgTreeRow } from '../../pages/project-registration/project-registration.types';

export type OrgTreeNode = OrgTreeRow &
  Omit<TreeData, 'childrens'> & {
    childrens?: OrgTreeNode[];
  };

// 조직도 최상위가 "LG 에너지솔루션"(그룹) 아래 동명의 "LG 에너지솔루션"(법인) 노드를 형제들
// (CHO/CFO/여수공장 등) 사이에 자식으로 하나 더 갖고 내려온다 — 트리는 바깥쪽 중복 래퍼를
// 건너뛰고 그 안쪽 "LG 에너지솔루션"에서 시작해야 한다(요청 4). 이름은 실제 라벨(공백 포함)과
// 정확히 일치해야 매치된다 — 원본 데이터가 "LG 에너지솔루션"으로 공백을 포함한다.
const ORG_ROOT_NAME = 'LG 에너지솔루션';

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

  // roots가 "기타관련부서" 같은 다른 최상위 형제를 포함해도 트리는 ORG_ROOT_NAME 하나만
  // 보여준다 — 래퍼는 안쪽 동명 노드로 치환하고 나머지 형제 root는 버린다(요청 4).
  const orgRoot = roots.find(root => root.nodeName === ORG_ROOT_NAME);
  if (!orgRoot) return roots;
  const innerRoot = (orgRoot.childrens ?? []).find(child => child.nodeName === ORG_ROOT_NAME);
  return [innerRoot ?? orgRoot];
};
