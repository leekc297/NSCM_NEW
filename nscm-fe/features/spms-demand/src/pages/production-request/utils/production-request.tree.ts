// SDM2010 — Tree 커서(flat) → LGES Tree 데이터 변환 순수함수.
//   level1 고객(END_CUSTOMER) / level2 프로젝트(DPJT_NAME) / level3 빌드 No.(DPJT_BUILD_NO)
//   — 설계서 Tree 시트 (VW > VWUCET > A1-N1) 구조.
import type { TreeData } from '@shared/lges';

import { toText } from '../../../lib/call-proc';
import type { SelectedBuild, TreeRow } from '../production-request.types';

// 노드 id 인코딩 — onClick(id) 하나로 선택 레벨/키를 복원한다. 구분자는 코드 값에 안 쓰는 '|'.
const PROJECT_PREFIX = 'project|';
const BUILD_PREFIX = 'build|';

/**
 * Level 2 프로젝트 노드 고유 ID 인코딩 규칙 (예: project|26VW91)
 */
export const projectNodeId = (pjtCode: string): string => `${PROJECT_PREFIX}${pjtCode}`;

/**
 * Level 3 빌드 노드 고유 ID 인코딩 규칙 (예: build|26VW91-A1-N1)
 */
export const buildNodeId = (row: TreeRow): string => `${BUILD_PREFIX}${toText(row.DPJT_BUILD_NO)}`;

/**
 * 트리 노드 클릭 시 데이터 복원 함수
 * Level 3 노드를 클릭했을 때 DPJT_BUILD_NO(예: 26VW91-A1-N1) 문자열을 하이픈(-) 기준으로 파싱하여
 * 우측 폼에 필요한 dpjtCode(26VW91)와 dpjtBuildNo(A1-N1)를 정확히 분리해 바인딩합니다.
 */
export const parseBuildNodeId = (id: string, rows: TreeRow[]): SelectedBuild | null => {
  // 1. Level 2: 프로젝트 노드 클릭 처리
  if (id.startsWith(PROJECT_PREFIX)) {
    const dpjtCode = id.slice(PROJECT_PREFIX.length);
    if (!dpjtCode) return null;

    const row = rows.find(r => toText(r.DPJT_CODE) === dpjtCode);
    return {
      dpjtCode,
      dpjtBuildNo: '', // 프로젝트 선택 모드이므로 빌드 번호는 빈 값 처리
      dpjtName: toText(row?.DPJT_NAME || dpjtCode),
    };
  }

  // 2. Level 3: 빌드 노드 클릭 처리
  if (id.startsWith(BUILD_PREFIX)) {
    const fullBuildNo = id.slice(BUILD_PREFIX.length);
    if (!fullBuildNo) return null;

    // 하이픈(-) 분리 기법 적용 (예: "26VW91-A1-N1" -> ["26VW91", "A1", "N1"])
    const parts = fullBuildNo.split('-');
    if (parts.length < 2) return null;

    const dpjtCode = parts[0];
    const dpjtBuildNo = parts.slice(1).join('-'); // 빌드 차수 코드에 하이픈이 추가로 포함된 경우 방어

    // 기존 rows 데이터에서 원본 행을 추적하여 프로젝트 이름 매핑용 fallback 준비
    const row = rows.find(r => toText(r.DPJT_BUILD_NO) === fullBuildNo);

    return {
      dpjtCode,
      dpjtBuildNo,
      dpjtName: toText(row?.DPJT_NAME || dpjtCode),
    };
  }

  return null;
};

/**
 * 진행 샘플 현황 스위치 필터 규칙
 * 데이터 명세의 IN_PROGRESS 필드(예: 'Y' / 'N')를 기준으로 필터링
 */
export const filterProgressRows = (rows: TreeRow[], inProgressOnly: boolean): TreeRow[] => {
  if (!inProgressOnly) return rows;
  const flag = (row: TreeRow) => toText(row.IN_PROGRESS);
  if (!rows.some(r => flag(r) !== '')) return rows;
  return rows.filter(r => flag(r) === 'PROGRESS');
};

/**
 * 핵심 구현: 3-Level 트리 조립 순수 알고리즘 (명세서 100% 동기화)
 * 1레벨(고객) → 2레벨(프로젝트 코드: ITEM_ID) → 3레벨(빌드차수: ITEM_ID)을
 * UPPER_ITEM_ID 부모 고리를 역추적하여 순서대로 실시간 조립합니다.
 */
export const toTreeData = (rows: TreeRow[]): TreeData[] => {
  const rootNodes: TreeData[] = [];

  // 빠른 조회를 위한 레벨별 메모리 캐시 인덱스 선언
  const nodesMap = new Map<string, TreeData>();

  // 명세 규격 보장: 순서 뒤틀림을 방지하기 위해 Level 1 -> Level 2 -> Level 3 순서로 안전하게 3회전 조립 진행
  const targetRows = rows ?? [];

  // [Pass] Level 1: 고객사 등록
  targetRows.forEach(row => {
    if (toText(row.LEVEL_NO) === '1') {
      const itemId = toText(row.ITEM_ID);
      if (itemId && !nodesMap.has(itemId)) {
        const node: TreeData = { id: `l1|${itemId}`, nodeName: itemId, childrens: [] };
        nodesMap.set(itemId, node);
        rootNodes.push(node);
      }
    }
  });

  // Level 2: 프로젝트 코드 등록 (부모: UPPER_ITEM_ID)
  targetRows.forEach(row => {
    if (toText(row.LEVEL_NO) === '2') {
      const itemId = toText(row.ITEM_ID); // 예: 26VW91
      const upperId = toText(row.UPPER_ITEM_ID);
      if (itemId && !nodesMap.has(itemId)) {
        const node: TreeData = { id: projectNodeId(itemId), nodeName: itemId, childrens: [] };
        nodesMap.set(itemId, node);

        // 부모 레벨1 노드 탐색 및 자식 주입
        const parentNode = nodesMap.get(upperId);
        if (parentNode) {
          parentNode.childrens?.push(node);
        } else if (rootNodes.length > 0) {
          // 혹시 모를 프로시저 결측치 방어용
          rootNodes[rootNodes.length - 1].childrens?.push(node);
        }
      }
    }
  });

  // Level 3: 빌드 번호 등록 (부모: UPPER_ITEM_ID / 표시값: ITEM_ID)
  targetRows.forEach(row => {
    if (toText(row.LEVEL_NO) === '3') {
      const itemId = toText(row.ITEM_ID); // 예: A1-N1
      const upperId = toText(row.UPPER_ITEM_ID); // 예: 26VW91

      const parentNode = nodesMap.get(upperId);
      if (parentNode && itemId) {
        parentNode.childrens?.push({
          id: buildNodeId(row), // build|26VW91-A1-N1 인코딩 주입
          nodeName: itemId, // 트리 텍스트에는 순수 빌드차수 "A1-N1" 출력
        });
      }
    }
  });

  return rootNodes;
};

/** 전 노드 기본 펼침 — 설계서 레이아웃(전 레벨 펼친 상태) 기준 */
export const collectExpandedIds = (nodes: TreeData[]): string[] => {
  const ids: string[] = [];
  const walk = (list: TreeData[]) => {
    for (const node of list) {
      if (node.childrens && node.childrens.length > 0) {
        ids.push(node.id);
        walk(node.childrens);
      }
    }
  };
  walk(nodes);
  return ids;
};
