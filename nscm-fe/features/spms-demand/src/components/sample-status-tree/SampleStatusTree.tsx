import { useMemo } from 'react';

import { Switch, Tree } from '@shared/lges';

import styles from './SampleStatusTree.module.scss';
import {
  collectExpandedIds,
  filterProgressRows,
  parseBuildNodeId,
  type SampleTreeRow,
  type SelectedBuild,
  toTreeData,
} from './sampleStatusTree.utils';

interface SampleStatusTreeProps {
  rows: SampleTreeRow[];
  /** 진행 샘플 현황 스위치 (설계서 Tree 시트 상단 — 기본 On) */
  inProgressOnly: boolean;
  onToggleProgress: (on: boolean) => void;
  /** 빌드 No. 노드 선택 — 고객/프로젝트 노드 클릭은 펼침만(조회 트리거 아님, 호출되지 않는다) */
  onSelectBuild: (selected: SelectedBuild) => void;
  /** 현재 선택 빌드 — 노드 강조 (다른 화면에서 인계받아 코드로 선택된 경우도 포함) */
  selected?: SelectedBuild;
}

// SPMS 공통 — 좌측 샘플 현황 Tree (고객 > 프로젝트 > 빌드 No.). SDM2010/SDM2020 이 공유한다.
//   LGES Tree 는 expandedNodes 배열 "참조"가 바뀔 때마다 펼침 상태를 리셋하므로 useMemo 로 고정한다.
//   LBL 채번 = SDM2010_META_20260827/sql/03_META §[1] (LBL01020 샘플 현황 / LBL01021 진행 샘플 현황)
export const SampleStatusTree = ({
  rows,
  inProgressOnly,
  onToggleProgress,
  onSelectBuild,
  selected,
}: SampleStatusTreeProps) => {
  const { t } = useTranslation();
  const nodes = useMemo(
    () => toTreeData(filterProgressRows(rows, inProgressOnly), selected),
    [rows, inProgressOnly, selected]
  );
  const expandedIds = useMemo(() => collectExpandedIds(nodes), [nodes]);

  const handleClick = (id: string) => {
    const selected = parseBuildNodeId(id);
    if (selected) onSelectBuild(selected);
  };

  return (
    <div className={styles.container}>
      <div className={styles.title}>{t('LBL01020', '_샘플 현황')}</div>
      <div className={styles.progressSwitch}>
        <Switch
          checked={inProgressOnly}
          checkedText={t('LBL01021', '_진행 샘플 현황')}
          text={t('LBL01021', '_진행 샘플 현황')}
          type='contained-label'
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
            onClick={handleClick}
            variant='triangle'
          />
        )}
      </div>
    </div>
  );
};
