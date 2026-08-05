import { useEffect, useRef, useState } from 'react';

import type { Menu } from '@foundation/models';
import { useClearAppData } from '@shared/hooks';
import { InputField, Button } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import { useMDIStore } from '../mdi/useMDIStore';

import styles from './Home.module.scss';
import { NoticePreviewModal } from './NoticePreviewModal';
import {
  useHomeNotices,
  formatNoticeDate,
  getTodayKey,
  isNoticeInPeriod,
  isPopupDismissedToday,
  dismissPopupForToday,
  HOME_NOTICE_LIMIT,
  type HomeNotice,
} from './useHomeNotices';
import { useSystemAdmins } from './useSystemAdmins';

type FavoriteMenu = Omit<Menu, 'children' | 'sortOrd'>;

interface FavoriteEntry {
  menu: Menu;
  /** 루트→상위 순서의 조상 메뉴 (breadcrumb 표시용) */
  path: Menu[];
}

/** 메뉴 트리를 순회하며 즐겨찾기 리프와 그 조상 경로를 함께 수집한다. */
const collectFavorites = (menus: Menu[]): FavoriteEntry[] => {
  const result: FavoriteEntry[] = [];

  const walk = (list: Menu[], trail: Menu[]) => {
    for (const menu of list) {
      if (menu.favorite) result.push({ menu, path: trail });
      if (menu.children?.length) walk(menu.children, [...trail, menu]);
    }
  };

  walk(menus, []);
  return result;
};

export const HomePage = () => {
  const { t } = useTranslation();
  const [id, setId] = useState('minyonglee1');

  const isLogin = useSessionStore(state => state.isLogin);
  const login = useSessionStore(state => state.login);
  const logout = useSessionStore(state => state.logout);
  const session = useSessionStore(state => state.session);
  const toggleFavorite = useSessionStore(state => state.toggleFavorite);
  const openTab = useMDIStore(state => state.openTab);
  const { clearAllData } = useClearAppData();
  const notices = useHomeNotices();

  // 로그아웃 — 서버 세션 종료(/user/logout) 후 로컬 상태 전체 정리:
  //   열린 탭 전부 닫기(MDI 초기화) + 모든 페이지 스토어 reset + react-query 캐시 + sessionStorage 클리어.
  //   재로그인 시 이전 사용자 화면/데이터가 남지 않도록 한다.
  const handleLogout = () => {
    logout();
    clearAllData();
  };
  const admins = useSystemAdmins();

  // 목록 클릭 미리보기(항상 열림, 체크박스 없음)
  const [previewNotice, setPreviewNotice] = useState<HomeNotice | null>(null);
  // 로드 시 자동 팝업 대기열(POPUP_YN='Y' + 게시기간 내 + 당일 미차단)
  const [popupQueue, setPopupQueue] = useState<HomeNotice[]>([]);
  const popupSeededRef = useRef(false);

  const today = getTodayKey();
  // 목록: 게시기간(오늘 ∈ START~END) 내 공지 최신 N건
  const listNotices = notices
    .filter(notice => isNoticeInPeriod(notice, today))
    .slice(0, HOME_NOTICE_LIMIT);

  useEffect(() => {
    if (popupSeededRef.current || notices.length === 0) return;
    popupSeededRef.current = true;
    setPopupQueue(
      notices.filter(
        notice =>
          notice.POPUP_YN === 'Y' &&
          isNoticeInPeriod(notice, today) &&
          !isPopupDismissedToday(notice.NOTICE_ID, today)
      )
    );
  }, [notices, today]);

  const favorites = collectFavorites(session?.menus ?? []);
  const authorities = session?.groups ?? [];

  const handleFavoriteClick = (menu: FavoriteMenu) => {
    // 좌측 메뉴(SidebarMenu)와 동일하게 MDI 탭으로 화면을 연다
    openTab(menu);
  };

  const handleDelete = (mnuId: string) => {
    toggleFavorite(mnuId, false);
  };

  // 미로그인: 개발용 로그인 폼만 노출
  if (!isLogin) {
    return (
      <div className={styles.homeWrapper}>
        <form className={styles.devLogin} onSubmit={e => e.preventDefault()}>
          <InputField type='text' value={id} onChange={e => setId(e.target.value)} />
          <Button onClick={() => login(id)}>Login</Button>
        </form>
      </div>
    );
  }

  return (
    <div className={styles.homeWrapper}>
      <div className={styles.topBar}>
        <span className={styles.welcome}>Hello! {session.userNm}</span>
        <Button onClick={handleLogout}>Logout</Button>
      </div>

      {/* 게스트는 대시보드(즐겨찾기/공지/권한/관리자) 숨김 — 권한요청만 하면 되므로 */}
      {!session?.guest && (
        <div className={styles.panelGrid}>
          {/* 좌: 즐겨찾기 (아이콘 없이 이름 + 경로). 길어지면 패널 내부 스크롤 */}
          <div className={styles.favoriteCell}>
            <section className={`${styles.panel} ${styles.favoritePanel}`}>
              <div className={styles.panelHeader}>
                <span className={styles.panelTitle}>Favorite Screens</span>
              </div>
              <div className={styles.panelBody}>
                {favorites.length === 0 ? (
                  <p className={styles.emptyText}>No favorites.</p>
                ) : (
                  favorites.map(({ menu, path }) => (
                    <div key={menu.mnuId} className={styles.favoriteRow}>
                      <button
                        type='button'
                        className={styles.favoriteLink}
                        onClick={() => handleFavoriteClick(menu)}
                      >
                        <span className={styles.favoriteTitle}>
                          {t(menu.mnuMsgId, menu.mnuDesc)}
                        </span>
                        {path.length > 0 && (
                          <span className={styles.favoritePath}>
                            {path.map(parent => t(parent.mnuMsgId, parent.mnuDesc)).join(' > ')}
                          </span>
                        )}
                      </button>
                      <button
                        type='button'
                        className={styles.favoriteDelete}
                        onClick={() => handleDelete(String(menu.mnuId))}
                        aria-label={`${menu.mnuDesc} delete`}
                      >
                        🗑️
                      </button>
                    </div>
                  ))
                )}
              </div>
            </section>
          </div>

          {/* 우: 공지 / 권한 / 관리자 */}
          <div className={styles.rightColumn}>
            {/* Announcements — 제목 + 등록일만 */}
            <section className={`${styles.panel} ${styles.noticePanel}`}>
              <div className={styles.panelHeader}>
                <span className={styles.panelTitle}>Announcements</span>
              </div>
              <div className={styles.noticeBody}>
                {listNotices.length === 0 ? (
                  <p className={styles.emptyText}>No announcements.</p>
                ) : (
                  listNotices.map(notice => (
                    <div
                      key={notice.NOTICE_ID}
                      className={styles.noticeRow}
                      onClick={() => setPreviewNotice(notice)}
                    >
                      <span className={styles.noticeTitle}>
                        {notice.MODULE_NM ? `[${notice.MODULE_NM}] ` : ''}
                        {notice.NOTICE_TITLE}
                      </span>
                      <span className={styles.noticeRegDate}>
                        {formatNoticeDate(notice.CREATION_DATE)}
                      </span>
                    </div>
                  ))
                )}
              </div>
            </section>

            {/* My Authorities — session.groups (6개 초과 시 스크롤) */}
            <section className={styles.panel}>
              <div className={styles.panelHeader}>
                <span className={styles.panelTitle}>My Authorities</span>
              </div>
              <div className={styles.authorityBody}>
                {authorities.length === 0 ? (
                  <p className={styles.emptyText}>No authorities.</p>
                ) : (
                  authorities.map(group => (
                    <div key={group} className={styles.authorityItem}>
                      <span className={styles.authorityDot} />
                      <span className={styles.authorityName}>{group}</span>
                    </div>
                  ))
                )}
              </div>
            </section>

            {/* System Administrators — 목업 */}
            <section className={`${styles.panel} ${styles.adminPanel}`}>
              <div className={styles.panelHeader}>
                <span className={styles.panelTitle}>System Administrators</span>
              </div>
              <div className={styles.panelBody}>
                <table className={styles.adminTable}>
                  <thead>
                    <tr>
                      <th>Module</th>
                      <th>Division</th>
                      <th>PIC</th>
                    </tr>
                  </thead>
                  <tbody>
                    {admins.length === 0 ? (
                      <tr>
                        <td colSpan={3} className={styles.adminEmpty}>
                          No administrators.
                        </td>
                      </tr>
                    ) : (
                      admins.map(admin => (
                        <tr key={`${admin.module}-${admin.division}-${admin.pic}`}>
                          <td>{admin.module}</td>
                          <td>{admin.division}</td>
                          <td>{admin.pic}</td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </section>
          </div>
        </div>
      )}

      {/* 목록 클릭 미리보기 — 무조건 열림, "오늘 하루 열지 않기" 없음 */}
      {previewNotice && (
        <NoticePreviewModal notice={previewNotice} onClose={() => setPreviewNotice(null)} />
      )}

      {/* 로드 시 자동 팝업 — POPUP_YN='Y', "오늘 하루 열지 않기" 지원 (한 건씩 순차 노출). 게스트는 제외 */}
      {!session?.guest && popupQueue.length > 0 && (
        <NoticePreviewModal
          notice={popupQueue[0]}
          showHideToday
          onClose={hideToday => {
            const current = popupQueue[0];
            if (hideToday) dismissPopupForToday(current.NOTICE_ID, today);
            setPopupQueue(queue => queue.slice(1));
          }}
        />
      )}
    </div>
  );
};
