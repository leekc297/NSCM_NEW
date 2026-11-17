import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

import { IcMinus, IcPlus } from '@foundation/assets';
import type { Menu } from '@foundation/models';
import { clsx } from '@shared/clsx';
import { useUIStore } from '@shared/stores';

import { useMDIStore } from '../../../mdi/useMDIStore';

import styles from './SidebarMenu.module.scss';

interface SidebarMenuProps {
  menu: Menu;
}

export const SidebarMenu = ({ menu }: SidebarMenuProps) => {
  const { t } = useTranslation();
  const openTab = useMDIStore(state => state.openTab);
  const sidebarOpenGroupId = useUIStore(state => state.sidebarOpenGroupId);

  const [isOpen, setIsOpen] = useState<boolean>(false);

  // 새 탭이 열려 이 그룹이 지목되면 펼친다.
  // 접는 건 사용자 몫이라 여기서 강제로 닫지는 않는다.
  useEffect(() => {
    if (sidebarOpenGroupId && sidebarOpenGroupId === String(menu.mnuId)) setIsOpen(true);
  }, [sidebarOpenGroupId, menu.mnuId]);

  // 탭 개수 제한 없음 — 넘치는 탭은 MDITabs 의 좌우 화살표로 스크롤한다.
  // (기존 10개 제한 + LBL00360/MSG00012 알림 제거)
  const handleMenuClick = (menu: Menu, isParentMenu: boolean = false) => {
    if (menu.children) {
      if (isParentMenu) setIsOpen(state => !state);
      return;
    }

    openTab(menu);
  };

  // 메뉴 오픈은 마우스 클릭으로만 — a 태그는 포커스 후 Enter 시 네이티브 클릭이 재발생해
  // 탭이 계속 추가되므로 keydown 단계에서 막는다.
  const blockEnterActivation = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') e.preventDefault();
  };

  return (
    <div className={styles.menuWrapper} key={menu.mnuId}>
      <Link
        to='#'
        className={styles.menuLink}
        onClick={() => handleMenuClick(menu, true)}
        onKeyDown={blockEnterActivation}
      >
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
          onKeyDown={blockEnterActivation}
          key={subMenu.mnuId}
        >
          <p className={styles.subTitle}>{t(subMenu.mnuMsgId, subMenu.mnuDesc)}</p>
        </Link>
      ))}
    </div>
  );
};
