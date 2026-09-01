import { IcMenu } from '@foundation/assets';
import { clsx } from '@shared/clsx';
import { useUIStore } from '@shared/stores';

import { SidebarMenu } from './components/SidebarMenu';
import styles from './Sidebar.module.scss';

export const Sidebar = () => {
  const { t } = useTranslation();

  const sidebarOpen = useUIStore(state => state.sidebarOpen);
  const sidebarMenu = useUIStore(state => state.sidebarMenu);
  const toggleSidebar = useUIStore(state => state.toggleSidebar);

  return (
    <>
      <button className={styles.toggleButton} onClick={toggleSidebar}>
        <IcMenu className={styles.icon} />
      </button>
      <aside className={clsx(styles.sidebar, { [styles.isOpen]: sidebarOpen })}>
        <nav className={clsx(styles.nav)}>
          <p className={styles.pateTitle}>{t(sidebarMenu.mnuMsgId, sidebarMenu.mnuDesc)}</p>
          {sidebarMenu.children?.map(menu => (
            <SidebarMenu key={menu.mnuId} menu={menu} />
          ))}
        </nav>
      </aside>
    </>
  );
};
