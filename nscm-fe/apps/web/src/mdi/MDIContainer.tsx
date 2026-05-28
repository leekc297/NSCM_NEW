import { Outlet } from 'react-router-dom';

import { useIsBusy } from '@foundation/query-client';
import { clsx } from '@shared/clsx';
import { ToastMessage, Alert } from '@shared/components';
import { ProgressIndicator } from '@shared/lges';
import { TabIdContext, useUIStore } from '@shared/stores';

import styles from './MDIContainer.module.scss';
import { MDITabs } from './MDITabs';
import { useMDIStore } from './useMDIStore';

export const MDIContainer = () => {
  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const progress = useUIStore(state => state.progress);

  const isBusy = useIsBusy([tabs[activeIndex].tabId]);

  return (
    <div className={styles.mdiContainer}>
      <MDITabs />
      <div className={styles.mdiContent}>
        <TabIdContext.Provider value={tabs[activeIndex].tabId}>
          <Outlet />
        </TabIdContext.Provider>
        <ToastMessage />
        <Alert />
        <div className={clsx(styles.spinner, { [styles.open]: isBusy })}>
          <ProgressIndicator shape='circular' open={!!isBusy} />
        </div>
      </div>
      <ProgressIndicator
        shape='linear'
        apprearance='limited'
        placement='parent'
        open={progress > 0}
        value={progress}
      />
    </div>
  );
};
