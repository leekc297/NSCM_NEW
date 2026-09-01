import { Tree, type TreeData } from '@shared/lges';

import type { OrgTreeNode } from './authManagementPopup.utils';

interface OrgTreeProps {
  nodes: OrgTreeNode[];
  onSelect: (deptId: string) => void;
  className?: string;
}

// Tree 내부 effect가 배열 참조 변경을 펼침 상태 초기화로 인식하므로 참조를 고정한다.
const EMPTY_EXPANDED_NODES: string[] = [];

export const OrgTree = ({ nodes, onSelect, className }: OrgTreeProps) => {
  const handleClick = (id: string, _selected: TreeData[]) => {
    onSelect(id);
  };

  return (
    <div className={className}>
      {nodes.length > 0 && (
        <Tree
          data={nodes}
          expandedNodes={EMPTY_EXPANDED_NODES}
          maxDepth={8}
          onClick={handleClick}
          variant='plusMinus'
        />
      )}
    </div>
  );
};
