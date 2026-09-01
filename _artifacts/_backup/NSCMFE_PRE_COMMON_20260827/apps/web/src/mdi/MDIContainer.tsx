import { useIsBusy } from '@foundation/query-client';
import { clsx } from '@shared/clsx';
import { ToastMessage, Alert } from '@shared/components';
import { ProgressIndicator } from '@shared/lges';
import { useUIStore } from '@shared/stores';

import styles from './MDIContainer.module.scss';
import { MDITabs } from './MDITabs';
import { RouterSync } from './RouterSync';
import { useMDIStore } from './useMDIStore';
import { ViewContainer } from './ViewContainer';

interface MDIContainerProps {
  /** 404 로 진입한 경우 false — RouterSync 가 마운트 시 URL 을 덮어쓰지 않게 한다 */
  mirrorRouteOnMount?: boolean;
}

const GlobalProgressBar = () => {
  const progress = useUIStore(state => state.progress);
  return (
    <ProgressIndicator
      shape='linear'
      apprearance='limited'
      placement='parent'
      open={progress > 0}
      value={progress}
    />
  );
};

export const MDIContainer = ({ mirrorRouteOnMount = true }: MDIContainerProps) => {
  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const progress = useUIStore(state => state.progress);

  const isBusy = useIsBusy([tabs[activeIndex].tabId]);

  return (
    <div className={styles.mdiContainer}>
      <MDITabs />
      <div className={styles.mdiContent}>
        <RouterSync mirrorOnMount={mirrorRouteOnMount} />
        <ViewContainer />
        <ToastMessage />
        <Alert />
        <div className={clsx(styles.spinner, { [styles.open]: isBusy })}>
          <ProgressIndicator shape='circular' open={!!isBusy} />
        </div>
      </div>
      <GlobalProgressBar />
    </div>
  );
};
