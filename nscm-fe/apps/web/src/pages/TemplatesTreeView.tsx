import { TreeView } from '@mescius/wijmo.nav';
import { useEffect, useMemo, useRef, useState } from 'react';

export interface TreeNode {
  /** 노드 식별자. 선택 시 상세 영역에서 사용 */
  code: string;
  name: string;
  /** 리프 노드에만 있는 부가 정보 (상세 영역 표시용) */
  owner?: string;
  items?: TreeNode[];
}

/** 화면 중간 메뉴(세로 배치)용 더미 트리 */
export const menuTreeNodes: TreeNode[] = [
  {
    code: 'PRD',
    name: '생산관리',
    items: [
      {
        code: 'PRD-A',
        name: '라인 A',
        items: [
          { code: 'PRD-A-01', name: '공정 01 - 극판', owner: '김생산' },
          { code: 'PRD-A-02', name: '공정 02 - 조립', owner: '이생산' },
          { code: 'PRD-A-03', name: '공정 03 - 화성', owner: '박생산' },
        ],
      },
      {
        code: 'PRD-B',
        name: '라인 B',
        items: [
          { code: 'PRD-B-01', name: '공정 01 - 극판', owner: '최생산' },
          { code: 'PRD-B-02', name: '공정 02 - 조립', owner: '정생산' },
        ],
      },
    ],
  },
  {
    code: 'QLT',
    name: '품질관리',
    items: [
      { code: 'QLT-01', name: '수입검사', owner: '김품질' },
      { code: 'QLT-02', name: '공정검사', owner: '이품질' },
      { code: 'QLT-03', name: '출하검사', owner: '박품질' },
    ],
  },
  {
    code: 'SCM',
    name: '공급망관리',
    items: [
      {
        code: 'SCM-P',
        name: '구매',
        items: [
          { code: 'SCM-P-01', name: '발주 등록', owner: '김구매' },
          { code: 'SCM-P-02', name: '입고 확정', owner: '이구매' },
        ],
      },
      {
        code: 'SCM-L',
        name: '물류',
        items: [{ code: 'SCM-L-01', name: '출하 지시', owner: '김물류' }],
      },
    ],
  },
];

/**
 * 검색어로 트리를 걸러낸다.
 *
 * 자기 이름이 맞거나(하위는 그대로 유지), 자손 중 하나라도 맞으면 경로 유지를 위해 살린다.
 * 예: '화성' 입력 → 생산관리 > 라인 A > 공정 03 - 화성 만 남는다.
 */
export const filterTreeNodes = (nodes: TreeNode[], keyword: string): TreeNode[] => {
  const key = keyword.trim().toLowerCase();
  if (!key) {
    return nodes;
  }

  return nodes.reduce<TreeNode[]>((acc, node) => {
    if (node.name.toLowerCase().includes(key)) {
      acc.push(node);
      return acc;
    }

    const items = filterTreeNodes(node.items ?? [], key);
    if (items.length) {
      acc.push({ ...node, items });
    }
    return acc;
  }, []);
};

/**
 * Wijmo TreeView 샘플.
 *
 * 좌측 세로 트리에서 노드를 고르면 우측 상세 영역이 바뀌는 "화면 중간 메뉴" 패턴이다.
 * React 래퍼 대신 같은 파일군의 FlexChart 예시와 동일하게 명령형으로 생성한다.
 */
export const TreeViewExample = () => {
  const hostRef = useRef<HTMLDivElement>(null);
  const treeRef = useRef<TreeView | undefined>(undefined);
  const [selected, setSelected] = useState<TreeNode>();
  const [filter, setFilter] = useState('');

  const filteredNodes = useMemo(() => filterTreeNodes(menuTreeNodes, filter), [filter]);

  useEffect(() => {
    if (!hostRef.current) {
      return undefined;
    }

    const tree = new TreeView(hostRef.current, {
      itemsSource: menuTreeNodes,
      displayMemberPath: 'name',
      childItemsPath: 'items',
      isAnimated: true,
      // 이벤트 인자에는 노드가 없다. sender.selectedItem 이 바인딩된 데이터 항목이다.
      selectedItemChanged: (sender: TreeView) => {
        setSelected(sender.selectedItem as TreeNode | undefined);
      },
    });
    tree.collapseToLevel(1);
    treeRef.current = tree;

    return () => {
      tree.dispose();
      treeRef.current = undefined;
    };
  }, []);

  // 검색어가 바뀌면 걸러낸 데이터를 다시 바인딩한다.
  // 검색 중에는 매칭된 노드가 접힌 채로 숨지 않도록 전부 펼친다.
  useEffect(() => {
    const tree = treeRef.current;
    if (!tree) {
      return;
    }

    tree.itemsSource = filteredNodes;
    tree.collapseToLevel(filter.trim() ? 99 : 1);
  }, [filter, filteredNodes]);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
        <input
          placeholder='메뉴 검색'
          value={filter}
          onChange={e => setFilter(e.target.value)}
          style={{ padding: '4px 8px' }}
        />
        <button onClick={() => treeRef.current?.collapseToLevel(99)}>전체 펼치기</button>
        <button onClick={() => treeRef.current?.collapseToLevel(0)}>전체 접기</button>
      </div>

      <div style={{ display: 'flex', gap: '12px', alignItems: 'stretch' }}>
        {/* 세로 메뉴 패널 */}
        <div
          style={{
            width: '260px',
            height: '360px',
            overflow: 'auto',
            border: '1px solid #ddd',
            padding: '8px',
          }}
        >
          <div ref={hostRef} />
          {!filteredNodes.length && (
            <span style={{ color: '#666', fontSize: '13px' }}>검색 결과가 없습니다.</span>
          )}
        </div>

        {/* 선택 노드 상세 */}
        <div style={{ flex: 1, border: '1px solid #ddd', padding: '12px' }}>
          {selected ? (
            <dl style={{ margin: 0, display: 'grid', gridTemplateColumns: '80px 1fr', gap: '8px' }}>
              <dt style={{ color: '#666' }}>코드</dt>
              <dd style={{ margin: 0 }}>{selected.code}</dd>
              <dt style={{ color: '#666' }}>이름</dt>
              <dd style={{ margin: 0 }}>{selected.name}</dd>
              <dt style={{ color: '#666' }}>담당자</dt>
              <dd style={{ margin: 0 }}>{selected.owner ?? '-'}</dd>
              <dt style={{ color: '#666' }}>하위</dt>
              <dd style={{ margin: 0 }}>{selected.items?.length ?? 0} 건</dd>
            </dl>
          ) : (
            <span style={{ color: '#666' }}>좌측 트리에서 메뉴를 선택하세요.</span>
          )}
        </div>
      </div>
    </div>
  );
};
