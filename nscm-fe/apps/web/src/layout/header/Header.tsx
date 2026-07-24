import { Link } from 'react-router-dom';

import type { Menu } from '@foundation/models';
import { clsx } from '@shared/clsx';
import { Avatar } from '@shared/lges';
import { useSessionStore, useUIStore } from '@shared/stores';

import { LanguageButton } from './components/LanguageButton';
import styles from './Header.module.scss';

export const Header = () => {
  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const setSidebarOpen = useUIStore(state => state.setSidebarOpen);
  const setSidebarMenu = useUIStore(state => state.setSidebarMenu);
  const sidebarMenu = useUIStore(state => state.sidebarMenu);

  const handleClickMenu = (menu: Menu) => {
    setSidebarOpen(true);
    setSidebarMenu(menu);
  };

  return (
    <header className={styles.header}>
      <div className={clsx(styles.logoWrapper, { [styles.open]: true })}>
        <Link to='/home' className={clsx(styles.logo)}>
          <span className={styles.abb}>{import.meta.env.VITE_APP_NAME}</span>
          <span className={styles.full}>
            <span className={styles.ko}>{import.meta.env.VITE_KO_NAME}</span>
            <span className={styles.en}>{import.meta.env.VITE_EN_NAME}</span>
          </span>
        </Link>
      </div>
      <nav className={styles.menuWrapper}>
        {session.menus?.map(menu => (
          <Link
            className={clsx(styles.menuLink, {
              // 참조 비교하면 sessionStorage 에서 복원된 sidebarMenu 는 별개 객체라 항상 어긋난다
              [styles.selected]: !!menu.mnuId && menu.mnuId === sidebarMenu?.mnuId,
            })}
            to='#'
            onClick={() => handleClickMenu(menu)}
            key={`${menu.mnuUrl}`}
          >
            {t(menu.mnuMsgId, menu.mnuDesc)}
          </Link>
        ))}
      </nav>
      <div className={styles.userInfoWrapper}>
        <LanguageButton />
        <Avatar alt='개발자1' src='이미지' size='xsmall' />
        {/* TODO: 테스트용 화면 링크 삭제 */}
        <Link to='/ui'>
          <span>{session.langCd === 'KO' ? session.userNm : session.userEngNm}</span>
        </Link>
      </div>
    </header>
  );
};
