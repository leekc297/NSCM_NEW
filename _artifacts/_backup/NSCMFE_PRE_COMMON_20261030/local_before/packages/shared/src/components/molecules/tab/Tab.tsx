import type { ReactElement, ReactNode } from 'react';
import React, { isValidElement, useState } from 'react';

import { clsx } from '@shared/clsx';

import styles from './Tab.module.scss';

interface TabWrapperProps {
  onTabClick?: (index: number) => void;
  onClose?: (index: number) => void;
  clearAll?: () => void;
  clearOthers?: () => void;
  persist?: boolean;
  children: ReactElement | ReactElement[];
  activeTabIndex?: number;
  setActiveTabIndex?: (index: number) => void;
}

interface TabItemProps {
  label: string;
  closable?: boolean;
  children?: ReactNode;
}

export const TabWrapper = ({
  children,
  onTabClick,
  onClose,
  clearAll,
  clearOthers,
  persist,
  activeTabIndex,
  setActiveTabIndex,
}: TabWrapperProps) => {
  const { t } = useTranslation();
  const [activeIndex, setActiveIndex] = useState<number>(0);

  const childrenArray = React.Children.toArray(children);

  const handleTabClick = (tabIndex: number) => {
    onTabClick?.(tabIndex);
    (setActiveTabIndex ?? setActiveIndex)(tabIndex);
  };

  const handleTabClose = (e: React.MouseEvent, tabIndex: number) => {
    e.stopPropagation();
    onClose?.(tabIndex);
  };

  return (
    <div className={styles.tabContainer}>
      <div className={styles.tabArea}>
        {childrenArray.map((child, index) => {
          if (isValidElement<TabItemProps>(child))
            return (
              <button
                key={child.key}
                onClick={() => handleTabClick(index)}
                className={clsx(styles.tab, {
                  [styles.active]: (activeTabIndex ?? activeIndex) === index,
                })}
              >
                <span>{child.props.label}</span>
                {onClose && child.props.closable && (
                  <button onClick={e => handleTabClose(e, index)}>x</button>
                )}
              </button>
            );
        })}
        <div>
          {clearOthers && <button onClick={clearOthers}>{t('LBL00364', '_다른 탭 닫기')}</button>}
          {clearAll && <button onClick={clearAll}>{t('LBL00365', '_모든 탭 닫기')}</button>}
        </div>
      </div>
      <div className={styles.contentArea}>
        {persist ? (
          childrenArray.map((child, index) => (
            <div
              className={clsx(styles.content, {
                [styles.active]: (activeTabIndex ?? activeIndex) === index,
              })}
              key={isValidElement<TabItemProps>(child) ? child.props.label : `${index}`}
            >
              {child}
            </div>
          ))
        ) : (
          <div className={clsx(styles.content, styles.active)}>
            {childrenArray[activeTabIndex ?? activeIndex]}
          </div>
        )}
      </div>
    </div>
  );
};

export const TabItem = ({ children }: TabItemProps) => {
  return <div className={styles.tabItem}>{children}</div>;
};
