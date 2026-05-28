import { useState } from 'react';
import { Link } from 'react-router-dom';

import { IcMinus, IcPlus } from '@foundation/assets';
import type { Menu } from '@foundation/models';
import { clsx } from '@shared/clsx';
import { useMessageStore } from '@shared/stores';

import { useMDIStore } from '../../../mdi/useMDIStore';

import styles from './SidebarMenu.module.scss';

interface SidebarMenuProps {
  menu: Menu;
}

const MAXIUM_TAB_NUMBER = 10;

export const SidebarMenu = ({ menu }: SidebarMenuProps) => {
  const { t } = useTranslation();
  const openTab = useMDIStore(state => state.openTab);
  const tabs = useMDIStore(state => state.tabs);
  const setAlert = useMessageStore(state => state.setAlert);

  const [isOpen, setIsOpen] = useState<boolean>(false);

  const handleMenuClick = (menu: Menu, isParentMenu: boolean = false) => {
    if (menu.children) {
      if (isParentMenu) setIsOpen(state => !state);
      return;
    }

    if (tabs.length >= MAXIUM_TAB_NUMBER) {
      void setAlert({
        type: 'alert',
        header: t('LBL00360', '_최대 화면 수 초과 알림'),
        content: t('MSG00012', '_탭은 10개를 넘을 수 없습니다.'),
      });
    } else openTab(menu);
  };

  return (
    <div className={styles.menuWrapper} key={menu.mnuId}>
      <Link to='#' className={styles.menuLink} onClick={() => handleMenuClick(menu, true)}>
        {menu.children ? (
          <>
            <p className={clsx(styles.title, { [styles.isOpen]: isOpen })}>
              {t(menu.mnuMsgId, menu.mnuDesc)}
            </p>
            {isOpen ? (
              <IcMinus fontSize='small' className={styles.icon} />
            ) : (
              <IcPlus fontSize='small' className={styles.icon} />
            )}
          </>
        ) : (
          <p className='acc-title'>{t(menu.mnuMsgId, menu.mnuDesc)}</p>
        )}
      </Link>
      {menu.children?.map(subMenu => (
        <Link
          to='#'
          className={clsx(styles.subMenuLink, { [styles.isOpen]: isOpen })}
          onClick={() => handleMenuClick(subMenu)}
          key={subMenu.mnuId}
        >
          <p className={styles.subTitle}>{t(subMenu.mnuMsgId, subMenu.mnuDesc)}</p>
        </Link>
      ))}
    </div>
  );
};
