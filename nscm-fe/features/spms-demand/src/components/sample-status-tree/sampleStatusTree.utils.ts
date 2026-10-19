// SPMS 공통 — 샘플 현황 Tree 커서 → LGES Tree 데이터 변환 순수함수.
//   SDM2010(생산요청)/SDM2020(계획수율)이 같은 Tree 를 공유한다 (PKG_SDM2010/PKG_SDM2020
//   P_SDMxxxx_GET_PJT_SAMPLE_TREE — 커서 계약 동일, 사내 DB 실측 2026-08-31):
//   LEVEL_NO(1 고객 / 2 프로젝트 코드 / 3 빌드 No.) + ITEM_ID(표시·키) + UPPER_ITEM_ID(부모 키)
//   + IN_PROGRESS('PROGRESS' = 진행 중 빌드 보유) + DPJT_BUILD_NO(레벨 3 만 — 실키, 예 '26VW01-A1-N1').
//   레벨 3 의 ITEM_ID 는 코드 접두를 뗀 표시값('A1-N1') 이라 조회 키는 DPJT_BUILD_NO 를 쓴다.
import type { TreeData } from '@shared/lges';

import { toText } from '../../lib/call-proc';

/** 샘플 현황 Tree 커서 1행 (flat — FE 가 3-level 로 조립) */
export interface SampleTreeRow {
  LEVEL_NO: string | number;
  ITEM_ID: string;
  UPPER_ITEM_ID: string;
  IN_PROGRESS: string;
  DPJT_BUILD_NO: string;
  [key: string]: string | number;
}

/** Tree 에서 선택된 빌드 No. — 우측(Process/빌드/상세) 조회 필터의 원천 */
export interface SelectedBuild {
  dpjtCode: string;
  dpjtBuildNo: string;
}

const LEVEL = { CUSTOMER: 1, PROJECT: 2, BUILD: 3 } as const;
const IN_PROGRESS = 'PROGRESS' as const;
const SEP = '|';
const BUILD_PREFIX = `build${SEP}`;

const levelOf = (row: SampleTreeRow): number => Number(toText(row.LEVEL_NO) || '0');

// 노드 id 인코딩 — onClick(id) 하나로 선택 레벨/키를 복원한다. 구분자 '|' 는 코드 값에 쓰지 않는다.
export const buildNodeId = (dpjtCode: string, dpjtBuildNo: string): string =>
  `${BUILD_PREFIX}${dpjtCode}${SEP}${dpjtBuildNo}`;

/** 빌드 No. 노드 id → 선택 정보. 상위(고객/프로젝트) 노드 id 면 null — 조회 트리거 아님. */
export const parseBuildNodeId = (id: string): SelectedBuild | null => {
  if (!id.startsWith(BUILD_PREFIX)) return null;
  const [dpjtCode, dpjtBuildNo] = id.slice(BUILD_PREFIX.length).split(SEP);
  if (!dpjtCode || !dpjtBuildNo) return null;
  return { dpjtCode, dpjtBuildNo };
};

/** 진행 샘플 현황 스위치 — On 이면 IN_PROGRESS='PROGRESS' 행만 (커서가 상위 레벨까지 집계해 내려준다) */
export const filterProgressRows = (
  rows: SampleTreeRow[],
  inProgressOnly: boolean
): SampleTreeRow[] =>
  inProgressOnly ? rows.filter(row => toText(row.IN_PROGRESS) === IN_PROGRESS) : rows;

/** flat 커서 행 → 고객 > 프로젝트 > 빌드 No. 3-level TreeData (커서 순서 유지, 부모 없는 행은 버린다) */
export const toTreeData = (rows: SampleTreeRow[], selected?: SelectedBuild): TreeData[] => {
  const customers: TreeData[] = [];
  const customerByKey = new Map<string, TreeData>();
  const projectByKey = new Map<string, TreeData>();

  for (const row of rows.filter(r => levelOf(r) === LEVEL.CUSTOMER)) {
    const key = toText(row.ITEM_ID);
    if (!key || customerByKey.has(key)) continue;
    const node: TreeData = { id: `customer${SEP}${key}`, nodeName: key, childrens: [] };
    customerByKey.set(key, node);
    customers.push(node);
  }
  for (const row of rows.filter(r => levelOf(r) === LEVEL.PROJECT)) {
    const key = toText(row.ITEM_ID);
    const customer = customerByKey.get(toText(row.UPPER_ITEM_ID));
    if (!key || !customer || projectByKey.has(key)) continue;
    const node: TreeData = { id: `project${SEP}${key}`, nodeName: key, childrens: [] };
    projectByKey.set(key, node);
    customer.childrens?.push(node);
  }
  // 선택 빌드 강조 — LGES Tree 는 data 의 isSelected 를 그대로 그린다 (data 참조 변경 시 내부 상태 재동기화)
  const selectedId = selected ? buildNodeId(selected.dpjtCode, selected.dpjtBuildNo) : '';
  for (const row of rows.filter(r => levelOf(r) === LEVEL.BUILD)) {
    const dpjtCode = toText(row.UPPER_ITEM_ID);
    const project = projectByKey.get(dpjtCode);
    const dpjtBuildNo = toText(row.DPJT_BUILD_NO);
    if (!project || !dpjtBuildNo) continue;
    const id = buildNodeId(dpjtCode, dpjtBuildNo);
    project.childrens?.push({
      id,
      nodeName: toText(row.ITEM_ID) || dpjtBuildNo,
      ...(id === selectedId ? { isSelected: true } : {}),
    });
  }
  return customers;
};

/** 전 노드 기본 펼침 — 설계서 레이아웃(전 레벨 펼친 상태) 기준. 자식 있는 노드 id 만 모은다 */
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
