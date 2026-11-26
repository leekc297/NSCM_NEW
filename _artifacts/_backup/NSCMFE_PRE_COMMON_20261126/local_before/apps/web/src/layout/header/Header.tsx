import { useState } from 'react';
import { Link } from 'react-router-dom';

import type { Menu } from '@foundation/models';
import { clsx } from '@shared/clsx';
import { Avatar } from '@shared/lges';
import { useSessionStore, useUIStore } from '@shared/stores';

import { useMDIStore } from '../../mdi/useMDIStore';

import { LanguageButton } from './components/LanguageButton';
import { PersonalSettingModal } from './components/PersonalSettingModal';
import styles from './Header.module.scss';

export const Header = () => {
  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const setSidebarOpen = useUIStore(state => state.setSidebarOpen);
  const setSidebarMenu = useUIStore(state => state.setSidebarMenu);
  const sidebarMenu = useUIStore(state => state.sidebarMenu);
  const setActiveTab = useMDIStore(state => state.setActiveTab);

  const [settingOpen, setSettingOpen] = useState(false);

  const displayName = session.langCd === 'KO' ? session.userNm : session.userEngNm;

  const handleClickMenu = (menu: Menu) => {
    setSidebarOpen(true);
    setSidebarMenu(menu);
  };

  // 로고 클릭 → 홈 탭(항상 index 0)으로 전환. 사이드바 메뉴와 동일하게 MDI 스토어를
  // 활성 탭 변경으로 이동시키고, URL(/view/home) 미러링은 RouterSync 가 처리한다.
  // (예전처럼 to='/home' 로 URL 만 바꾸면 RouterSync 가 /view/ 접두가 아닌 경로를 무시해
  //  주소만 바뀌고 화면은 그대로였다.)
  const handleClickLogo = () => {
    setActiveTab(0);
  };

  return (
    <header className={styles.header}>
      <div className={clsx(styles.logoWrapper, { [styles.open]: true })}>
        <Link to='#' onClick={handleClickLogo} className={clsx(styles.logo)}>
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
        {/* 사용자 아바타+이름 클릭 → Personal Setting 팝업(Time Zone 설정). 별도 기어 버튼 대신 사용. */}
        <button
          type='button'
          className={styles.userButton}
          onClick={() => setSettingOpen(true)}
          title='Personal Setting'
        >
          <Avatar alt={displayName} textAvatar={displayName} size='xsmall' />
          <span>{displayName}</span>
        </button>
        <PersonalSettingModal open={settingOpen} onClose={() => setSettingOpen(false)} />
      </div>
    </header>
  );
};
