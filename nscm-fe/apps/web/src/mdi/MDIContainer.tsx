import { useIsBusy } from '@foundation/query-client';
import { clsx } from '@shared/clsx';
import { ToastMessage, Alert } from '@shared/components';
import { ProgressIndicator } from '@shared/lges';
import { useUIStore } from '@shared/stores';

import { AtlasBridge } from './AtlasBridge';
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
  // 전체보기 조회 시 스피너가 전체화면 뷰(position:fixed, z-index 1200) 뒤로 가려지는 것 보정 — 아래 .spinner 참고.
  const pageFullscreen = useUIStore(state => state.pageFullscreen);

  const isBusy = useIsBusy([tabs[activeIndex].tabId]);

  // 특정 화면(대시보드 DMD0001)은 콘텐츠 여백 없이 full-bleed 로 보여준다 — 활성 탭일 때만.
  const isFlushScreen = tabs[activeIndex]?.mnuId === 'DMD0001';

  return (
    <div className={styles.mdiContainer}>
      <MDITabs />
      <div className={clsx(styles.mdiContent, { [styles.mdiContentFlush]: isFlushScreen })}>
        <RouterSync mirrorOnMount={mirrorRouteOnMount} />
        <AtlasBridge />
        <ViewContainer />
        <ToastMessage />
        <Alert />
        <div
          className={clsx(styles.spinner, {
            [styles.open]: isBusy,
            [styles.fullscreen]: pageFullscreen,
          })}
        >
          <ProgressIndicator shape='circular' open={!!isBusy} />
        </div>
      </div>
      <GlobalProgressBar />
    </div>
  );
};
