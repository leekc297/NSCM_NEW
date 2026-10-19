import { Tree, type TreeData } from '@shared/lges';

import type { OrgTreeNode } from './authManagementPopup.utils';

interface OrgTreeProps {
  nodes: OrgTreeNode[];
  onSelect: (deptId: string) => void;
  /**
   * 기본으로 펼쳐 둘 DEPT_ID 목록(조상 경로 포함 — collectDeptPathIds 결과).
   * Tree 는 이 배열의 "참조"가 바뀔 때마다 모든 노드의 펼침 상태를 배열 기준으로 리셋하므로,
   * 호출부는 useMemo 등으로 참조를 고정해서 넘겨야 사용자가 직접 접고 편 상태가 유지된다.
   */
  defaultExpandedDeptIds?: string[];
  className?: string;
}

// Tree 내부 effect가 배열 참조 변경을 펼침 상태 초기화로 인식하므로 참조를 고정한다.
const EMPTY_EXPANDED_NODES: string[] = [];

export const OrgTree = ({ nodes, onSelect, defaultExpandedDeptIds, className }: OrgTreeProps) => {
  const handleClick = (id: string, _selected: TreeData[]) => {
    onSelect(id);
  };

  return (
    <div className={className}>
      {nodes.length > 0 && (
        <Tree
          data={nodes}
          expandedNodes={defaultExpandedDeptIds ?? EMPTY_EXPANDED_NODES}
          maxDepth={8}
          onClick={handleClick}
          variant='plusMinus'
        />
      )}
    </div>
  );
};
