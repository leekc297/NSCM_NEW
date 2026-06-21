// SYS0013 SQL Viewer/Editor — AS-IS SCM0005_DynamicQueryList.cs L541 `rtxtSQL.Text = sFinalSql;` 정합.
// 표시: selected query 의 DQ_TEXT + parameter 값 치환된 최종 SQL (parent 가 baseSql 로 계산해서 전달).
// 편집: textarea editable. 사용자 수정값이 Execute 시 우선 사용 (store.editedSqlText).
// 자동 sync: selectedQueryId 또는 baseSql 변경 시 store.editedSqlText 를 baseSql 로 reset (parameter 값 즉시 반영).
import { useEffect } from 'react';

import { useDynamicQueryStore } from '../useDynamicQueryStore';

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

  return (
    <textarea
      value={editedSqlText}
      onChange={e => setEditedSqlText(e.target.value, selectedQueryId)}
      spellCheck={false}
      placeholder={selectedQueryId ? '' : 'Query 를 선택하세요'}
      style={{
        width: '100%',
        minHeight: 240,
        padding: 12,
        fontFamily:
          'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \'Liberation Mono\', \'Courier New\', monospace',
        fontSize: 13,
        lineHeight: 1.5,
        border: '1px solid #d9d9d9',
        borderRadius: 4,
        background: '#ffffff',
        resize: 'vertical',
        whiteSpace: 'pre-wrap',
        wordBreak: 'break-word',
        overflow: 'auto',
      }}
    />
  );
};
