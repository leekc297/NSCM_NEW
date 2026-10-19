import { useEffect, useState } from 'react';

import { useDynamicQueryStore } from '../useDynamicQueryStore';

import styles from './DynamicQuerySQLViewer.module.scss';

export const DynamicQuerySQLViewer = () => {
  const sqlText = useDynamicQueryStore(s => s.sqlText);
  const dynamicQueryMeta = useDynamicQueryStore(s => s.dynamicQueryMeta);

  const [text, setText] = useState<string>('');

  useEffect(() => {
    if (dynamicQueryMeta) {
      setText(sqlText ?? '');
    } else {
      setText('');
    }
  }, [dynamicQueryMeta]);

  return <textarea readOnly className={styles.sqlTextarea} value={text} spellCheck={false} />;
};
