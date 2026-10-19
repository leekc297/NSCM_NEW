import { type ComponentType, lazy, Suspense } from 'react';

import { type PageProps } from '@foundation/models';
import { ProgressIndicator } from '@shared/lges';

import { useMDIStore } from '../mdi/useMDIStore';

import styles from './LazyLoader.module.scss';

const Spinner = (
  <div className={styles.spinner}>
    <ProgressIndicator shape='circular' open />
  </div>
);

export const LazyLoader = <T extends MenuId>(
  importFn: () => Promise<{ default: ComponentType<PageProps<T>> }>
) => {
  const LazyComponent = lazy(importFn);

  const WrappedComponent = () => {
    const activeIndex = useMDIStore(state => state.activeIndex);
    const tabs = useMDIStore(state => state.tabs);
    const activeTab = tabs[activeIndex];

    return (
      <Suspense fallback={Spinner}>
        <LazyComponent tabId={activeTab.tabId} title={activeTab.mnuMsgId} menu={activeTab} />
      </Suspense>
    );
  };

  return WrappedComponent;
};
