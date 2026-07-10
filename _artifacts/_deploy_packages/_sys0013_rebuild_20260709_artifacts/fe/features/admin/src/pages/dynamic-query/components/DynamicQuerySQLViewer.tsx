// SYS0013 SQL Viewer/Editor — AS-IS rtxtSQL 정합 (View 탭 하단).
// 표시: 선택 쿼리 DQ_TEXT + 파라미터 치환 최종 SQL (부모가 baseSql 계산 전달).
// 편집: 사용자 수정값이 Execute/Validate 시 우선 사용 (store.editedSqlText).
import { useEffect } from 'react';

import { useDynamicQueryStore } from '../useDynamicQueryStore';

import styles from './DynamicQuerySQLViewer.module.scss';

interface Props {
  baseSql: string;
}

export const DynamicQuerySQLViewer = ({ baseSql }: Props) => {
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const editedSqlText = useDynamicQueryStore(s => s.editedSqlText);
  const setEditedSqlText = useDynamicQueryStore(s => s.setEditedSqlText);

  // baseSql 변경(쿼리 선택/파라미터 입력) 시 editedSqlText sync.
  useEffect(() => {
    setEditedSqlText(baseSql, selectedQueryId);
  }, [baseSql, selectedQueryId, setEditedSqlText]);

  const { t } = useTranslation();

  return (
    <textarea
      className={styles.sqlTextarea}
      value={editedSqlText}
      onChange={e => setEditedSqlText(e.target.value, selectedQueryId)}
      spellCheck={false}
      placeholder={selectedQueryId ? '' : t('MSG00628', '_실행할 Query 를 선택하세요')}
    />
  );
};
