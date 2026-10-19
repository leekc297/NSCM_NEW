import { useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import { Switch, Tree } from '@shared/lges';

import type { TreeRow } from '../production-request.types';
import {
  collectExpandedIds,
  filterProgressRows,
  toTreeData,
} from '../utils/production-request.tree';

import styles from './SampleTree.module.scss';

interface SampleTreeProps {
  rows: TreeRow[];
  /** 진행 샘플 현황 스위치 (설계서 Tree 시트 상단 — 기본 On) */
  inProgressOnly: boolean;
  onToggleProgress: (on: boolean) => void;
  /** 노드 클릭 — id 는 production-request.tree 의 인코딩(빌드 노드만 조회 트리거) */
  onNodeClick: (id: string) => void;
}

// SDM2010 좌측 샘플 현황 Tree — 고객 > 프로젝트 > 빌드 No. (LGES Tree, SDM1010 OrgTree 관례).
//   Tree 는 expandedNodes 배열 "참조"가 바뀔 때마다 펼침 상태를 리셋하므로 useMemo 로 고정한다.
export const SampleTree = ({
  rows,
  inProgressOnly,
  onToggleProgress,
  onNodeClick,
}: SampleTreeProps) => {
  const { t } = useTranslation();
  const nodes = useMemo(
    () => toTreeData(filterProgressRows(rows, inProgressOnly)),
    [rows, inProgressOnly]
  );
  const expandedIds = useMemo(() => collectExpandedIds(nodes), [nodes]);

  return (
    <div className={styles.container}>
      {/* LBL 채번 = SDM2010_META_20260827/sql/03_META §[1] (LBL01020~01030) */}
      <div className={styles.title}>{t('LBL01020', '_샘플 현황')}</div>
      <div className={styles.progressSwitch}>
        <Switch
          type='contained-label'
          text={t('LBL01021', '_진행 샘플 현황')}
          checkedText={t('LBL01021', '_진행 샘플 현황')}
          checked={inProgressOnly}
          onChange={(_, checked) => onToggleProgress(checked)}
          size='small'
        />
      </div>
      <div className={styles.tree}>
        {nodes.length > 0 && (
          <Tree
            data={nodes}
            expandedNodes={expandedIds}
            maxDepth={3}
            onClick={id => onNodeClick(id)}
            variant='triangle'
          />
        )}
      </div>
    </div>
  );
};
