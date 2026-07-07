// SYS0013 SQL Viewer/Editor — AS-IS SCM0005_DynamicQueryList.cs L541 `rtxtSQL.Text = sFinalSql;` 정합.
// 표시: selected query 의 DQ_TEXT + parameter 값 치환된 최종 SQL (parent 가 baseSql 로 계산해서 전달).
// 편집: textarea editable. 사용자 수정값이 Execute 시 우선 사용 (store.editedSqlText).
// 자동 sync: selectedQueryId 또는 baseSql 변경 시 store.editedSqlText 를 baseSql 로 reset (parameter 값 즉시 반영).
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

  // baseSql 변경 시 editedSqlText 를 baseSql 로 sync.
  // (selected query 또는 Parameters Tab 입력값 변경 시 SQL Tab 즉시 반영)
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
