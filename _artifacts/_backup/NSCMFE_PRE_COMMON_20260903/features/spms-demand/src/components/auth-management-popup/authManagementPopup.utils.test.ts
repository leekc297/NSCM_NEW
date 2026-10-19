import { describe, expect, it } from 'vitest';

import type { OrgTreeRow } from '../../pages/project-registration/project-registration.types';

import { buildOrgTree, collectDeptPathIds } from './authManagementPopup.utils';

const org = (level: number, id: string, name: string, upperDeptId: string | null): OrgTreeRow => ({
  LEVEL_NO: level,
  DEPT_ID: id,
  DEPT_NAME: name,
  UPPER_DEPT_ID: upperDeptId,
  USER_COUNT: 0,
  ORGN: '',
  SES_DEPT_ID: '',
});

describe('buildOrgTree', () => {
  it('서버가 반환한 모든 루트와 하위 조직을 유지한다', () => {
    const tree = buildOrgTree([
      org(1, 'group', 'LG 에너지솔루션', null),
      org(2, 'company', 'LG 에너지솔루션', 'group'),
      org(3, 'cto', 'CTO', 'company'),
      org(1, 'etc', '기타관련부서', null),
    ]);

    expect(tree.map(node => node.DEPT_ID)).toEqual(['group', 'etc']);
    expect(tree[0].childrens?.[0].DEPT_ID).toBe('company');
    expect(tree[0].childrens?.[0].childrens?.[0].DEPT_ID).toBe('cto');
  });

  it('selectedDeptId 를 주면 그 부서 노드만 isSelected 가 켜진다', () => {
    const tree = buildOrgTree(
      [
        org(1, 'group', 'LG 에너지솔루션', null),
        org(2, 'company', 'LG 에너지솔루션', 'group'),
        org(3, 'cto', 'CTO', 'company'),
      ],
      'company'
    );

    expect(tree[0].isSelected).toBe(false);
    expect(tree[0].childrens?.[0].isSelected).toBe(true);
    expect(tree[0].childrens?.[0].childrens?.[0].isSelected).toBe(false);
  });

  it('selectedDeptId 를 생략하면 어떤 노드도 선택되지 않는다', () => {
    const tree = buildOrgTree([org(1, 'group', 'LG 에너지솔루션', null)]);

    expect(tree[0].isSelected).toBe(false);
  });
});

describe('collectDeptPathIds', () => {
  const tree = buildOrgTree([
    org(1, 'group', 'LG 에너지솔루션', null),
    org(2, 'company', 'LG 에너지솔루션', 'group'),
    org(3, 'cto', 'CTO', 'company'),
    org(1, 'etc', '기타관련부서', null),
  ]);

  it('루트부터 대상 부서 자신까지의 경로를 반환한다', () => {
    expect(collectDeptPathIds(tree, 'cto')).toEqual(['group', 'company', 'cto']);
  });

  it('루트 부서를 찾으면 자기 자신만 반환한다', () => {
    expect(collectDeptPathIds(tree, 'etc')).toEqual(['etc']);
  });

  it('트리에 없는 부서나 빈 deptId 는 빈 배열을 반환한다', () => {
    expect(collectDeptPathIds(tree, 'unknown')).toEqual([]);
    expect(collectDeptPathIds(tree, '')).toEqual([]);
  });
});
