import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

import { IcCloseTemp } from '@foundation/assets';
import { clsx } from '@shared/clsx';

import styles from './MDITabs.module.scss';
import { useMDIStore } from './useMDIStore';

export const MDITabs = () => {
  const location = useLocation();

  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const setActiveTab = useMDIStore(state => state.setActiveTab);
  const closeTab = useMDIStore(state => state.closeTab);
  const closeOtherTabs = useMDIStore(state => state.closeOtherTabs);
  const closeAllTabs = useMDIStore(state => state.closeAllTabs);

  const { t } = useTranslation();

  useEffect(() => {
    //TODO: 뒤로가기,앞으로가기 컨트롤 - 이동주
    console.warn('TODO: bf cache control', location.pathname, location.state);
  }, [location]);

  const handleTabClick = (tabIndex: number) => {
    setActiveTab(tabIndex);
  };

  const handleTabClose = (e: React.MouseEvent, tabIndex: number) => {
    e.stopPropagation();
    closeTab(tabIndex);
  };

  if (tabs.length === 0) return null;

  return (
    <div className={styles.tabArea}>
      <div className={styles.tabContainer}>
        {tabs.map((tab, index) => (
          <button
            key={tab.tabId}
            className={clsx(styles.tab, { [styles.active]: activeIndex === index })}
            onClick={() => handleTabClick(index)}
          >
            <span className={styles.tabContent}>{t(tab.mnuMsgId, `${tab.mnuId}`)}</span>
            {tab.closable && (
              <div className={styles.closeBtn}>
                <IcCloseTemp height={14} onClick={e => handleTabClose(e, index)} />
              </div>
            )}
          </button>
        ))}
        <button className={clsx(styles.tab, styles.closeOther)} onClick={closeOtherTabs}>
          {t('LBL00364', '_다른 탭 닫기')}
        </button>
        <button className={clsx(styles.tab)} onClick={closeAllTabs}>
          {t('LBL00365', '_모든 탭 닫기')}
        </button>
      </div>
    </div>
  );
};
