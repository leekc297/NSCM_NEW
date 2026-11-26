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
  // 현재 활성 탭의 메뉴 — 같은 메뉴를 좌측에서 음영 처리한다.
  const activeMnuId = useMDIStore(state => state.tabs[state.activeIndex]?.mnuId);

  const [isOpen, setIsOpen] = useState<boolean>(false);

  // 이 그룹의 하위 메뉴가 현재 활성 탭일 때만 상위 제목을 강조색(primary)으로 표시한다.
  // 단순히 펼쳐졌다고(isOpen) 강조하면 활성 메뉴가 아닌 그룹도 강조색으로 보인다.
  const isActiveGroup =
    activeMnuId != null &&
    (menu.children?.some(sub => String(sub.mnuId) === String(activeMnuId)) ?? false);

  // 새 탭이 열려 이 그룹이 지목되면 펼친다.
  // 접는 건 사용자 몫이라 여기서 강제로 닫지는 않는다.
  useEffect(() => {
    if (sidebarOpenGroupId && sidebarOpenGroupId === String(menu.mnuId)) setIsOpen(true);
  }, [sidebarOpenGroupId, menu.mnuId]);

  // 활성 탭이 이 그룹의 하위 메뉴로 바뀌면 펼쳐 음영이 보이게 한다 (탭 전환·새로고침 복원 포함).
  useEffect(() => {
    if (activeMnuId == null) return;
    if (menu.children?.some(sub => String(sub.mnuId) === String(activeMnuId))) setIsOpen(true);
  }, [activeMnuId, menu.children]);

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
            <p className={clsx(styles.title, { [styles.isActive]: isActiveGroup })}>
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
          className={clsx(styles.subMenuLink, {
            [styles.isOpen]: isOpen,
            [styles.on]: activeMnuId != null && String(activeMnuId) === String(subMenu.mnuId),
          })}
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