import { describe, expect, it } from 'vitest';

import {
  buildNodeId,
  collectExpandedIds,
  filterProgressRows,
  parseBuildNodeId,
  type SampleTreeRow,
  toTreeData,
} from './sampleStatusTree.utils';

const row = (patch: Partial<SampleTreeRow>): SampleTreeRow => ({
  LEVEL_NO: 3,
  ITEM_ID: 'A1-N1',
  UPPER_ITEM_ID: '26VW01',
  IN_PROGRESS: 'PROGRESS',
  DPJT_BUILD_NO: '26VW01-A1-N1',
  ...patch,
});

// 커서 계약 = P_SDM2020_GET_PJT_SAMPLE_TREE (LEVEL_NO / ITEM_ID / UPPER_ITEM_ID / IN_PROGRESS / DPJT_BUILD_NO)
const cursor: SampleTreeRow[] = [
  row({ LEVEL_NO: 1, ITEM_ID: 'VW', UPPER_ITEM_ID: '', DPJT_BUILD_NO: '' }),
  row({ LEVEL_NO: 1, ITEM_ID: 'GM', UPPER_ITEM_ID: '', IN_PROGRESS: '', DPJT_BUILD_NO: '' }),
  row({ LEVEL_NO: 2, ITEM_ID: '26VW01', UPPER_ITEM_ID: 'VW', DPJT_BUILD_NO: '' }),
  row({ LEVEL_NO: 2, ITEM_ID: '26VW02', UPPER_ITEM_ID: 'VW', IN_PROGRESS: '', DPJT_BUILD_NO: '' }),
  row({ LEVEL_NO: 2, ITEM_ID: '26GM01', UPPER_ITEM_ID: 'GM', IN_PROGRESS: '', DPJT_BUILD_NO: '' }),
  row({}),
  row({ ITEM_ID: 'B2-N1', DPJT_BUILD_NO: '26VW01-B2-N1', IN_PROGRESS: '' }),
  row({
    ITEM_ID: 'A1-N1',
    UPPER_ITEM_ID: '26VW02',
    DPJT_BUILD_NO: '26VW02-A1-N1',
    IN_PROGRESS: '',
  }),
];

describe('toTreeData — 고객 > 프로젝트 > 빌드 No. 3-level 변환 (LEVEL_NO flat 커서)', () => {
  it('레벨별로 묶고 커서 순서를 유지한다', () => {
    const tree = toTreeData(cursor);
    expect(tree.map(n => n.nodeName)).toEqual(['VW', 'GM']);
    expect(tree[0].childrens?.map(n => n.nodeName)).toEqual(['26VW01', '26VW02']);
    expect(tree[0].childrens?.[0].childrens?.map(n => n.nodeName)).toEqual(['A1-N1', 'B2-N1']);
    expect(tree[1].childrens?.[0].childrens).toEqual([]);
  });

  it('빌드 노드 id 는 실키(DPJT_BUILD_NO)로 왕복되고 상위 노드는 null', () => {
    const id = buildNodeId('26VW01', '26VW01-A1-N1');
    expect(parseBuildNodeId(id)).toEqual({ dpjtCode: '26VW01', dpjtBuildNo: '26VW01-A1-N1' });
    expect(parseBuildNodeId('customer|VW')).toBeNull();
    expect(parseBuildNodeId('project|26VW01')).toBeNull();
  });

  it('부모가 없는 행은 버린다 (고아 빌드)', () => {
    const tree = toTreeData([row({ UPPER_ITEM_ID: 'NOPE' })]);
    expect(tree).toEqual([]);
  });

  it('collectExpandedIds 는 자식 있는 노드만 모은다 (빌드 없는 프로젝트 26GM01 은 제외)', () => {
    const tree = toTreeData(cursor);
    expect(collectExpandedIds(tree)).toEqual([
      'customer|VW',
      'project|26VW01',
      'project|26VW02',
      'customer|GM',
    ]);
  });
});

describe('filterProgressRows — 진행 샘플 현황 스위치', () => {
  it("On 이면 IN_PROGRESS='PROGRESS' 행만 남긴다 (전 레벨)", () => {
    const filtered = filterProgressRows(cursor, true);
    expect(filtered.map(r => r.ITEM_ID)).toEqual(['VW', '26VW01', 'A1-N1']);
    expect(toTreeData(filtered)[0].childrens?.[0].childrens?.map(n => n.nodeName)).toEqual([
      'A1-N1',
    ]);
  });

  it('Off 면 전체', () => {
    expect(filterProgressRows(cursor, false)).toHaveLength(cursor.length);
  });
});

describe('toTreeData — 선택 빌드 강조 (isSelected)', () => {
  it('selected 와 일치하는 빌드 노드만 isSelected=true, 나머지는 키 없음', () => {
    const tree = toTreeData(cursor, { dpjtCode: '26VW01', dpjtBuildNo: '26VW01-B2-N1' });
    const builds = tree[0].childrens?.[0].childrens ?? [];
    expect(builds.map(n => n.isSelected)).toEqual([undefined, true]);
    expect(toTreeData(cursor)[0].childrens?.[0].childrens?.[1].isSelected).toBeUndefined();
  });
});
