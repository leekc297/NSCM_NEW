import { useState } from 'react';

import type { Menu } from '@foundation/models';
import { InputField, Button } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import { useMDIStore } from '../mdi/useMDIStore';

import styles from './Home.module.scss';

type FavoriteMenu = Omit<Menu, 'children' | 'sortOrd'>;

interface Notice {
  noticeId: string;
  title: string;
  hasAttachment: boolean;
  regUser: string;
  regDate: string;
}

// TODO: 목업 데이터 - 추후 공지사항 API 연동으로 대체
const MOCK_NOTICES: Notice[] = [
  {
    noticeId: 'N-001',
    title: 'NSCM 시스템 정기 점검 안내 (7/20 02:00~04:00)',
    hasAttachment: true,
    regUser: '홍길동',
    regDate: '2026-07-15',
  },
  {
    noticeId: 'N-002',
    title: '2026년 하반기 공급망 관리 프로세스 개편 안내',
    hasAttachment: true,
    regUser: '김철수',
    regDate: '2026-07-14',
  },
  {
    noticeId: 'N-003',
    title: '메뉴 즐겨찾기 기능 오픈 안내',
    hasAttachment: false,
    regUser: 'Admin',
    regDate: '2026-07-11',
  },
  {
    noticeId: 'N-004',
    title: '신규 사용자 매뉴얼 배포',
    hasAttachment: true,
    regUser: '관리자',
    regDate: '2026-07-08',
  },
  {
    noticeId: 'N-005',
    title: '개인정보 처리방침 개정 안내',
    hasAttachment: false,
    regUser: '관리자',
    regDate: '2026-07-01',
  },
];

const collectFavorites = (menus: Menu[]): Menu[] => {
  const result: Menu[] = [];

  const walk = (list: Menu[]) => {
    for (const menu of list) {
      if (menu.favorite) result.push(menu);
      if (menu.children?.length) walk(menu.children);
    }
  };

  walk(menus);
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

  const favorites = collectFavorites(session?.menus ?? []);

  const handleFavoriteClick = (menu: FavoriteMenu) => {
    // 좌측 메뉴(SidebarMenu)와 동일하게 MDI 탭으로 화면을 연다
    openTab(menu);
  };

  const handleDelete = (mnuId: string) => {
    toggleFavorite(mnuId, false);
  };

  return (
    <div className={styles.homeWrapper}>
      {/* 상단: 로그인 상태에 따라 환영 메시지 / 개발용 로그인 노출 */}
      <div className={styles.topBar}>
        {isLogin ? (
          <>
            <span className={styles.welcome}>{session.userNm}님 환영합니다.</span>
            <Button onClick={() => logout()}>Logout</Button>
          </>
        ) : (
          <form className={styles.devLogin} onSubmit={e => e.preventDefault()}>
            <InputField type='text' value={id} onChange={e => setId(e.target.value)} />
            <Button onClick={() => login(id)}>Login</Button>
          </form>
        )}
      </div>

      {isLogin && (
        <div className={styles.panelGrid}>
          {/* 공지사항 (좌측) */}
          <section className={styles.panel}>
            <div className={styles.panelHeader}>
              <span className={styles.panelTitle}>공지사항</span>
            </div>
            <div className={styles.panelBody}>
              {MOCK_NOTICES.length === 0 ? (
                <p className={styles.emptyText}>등록된 공지사항이 없습니다.</p>
              ) : (
                MOCK_NOTICES.map(notice => (
                  <div key={notice.noticeId} className={styles.noticeRow}>
                    <div className={styles.noticeTitleArea}>
                      {notice.hasAttachment && (
                        <span className={styles.attachIcon} aria-label='첨부파일'>
                          📎
                        </span>
                      )}
                      <span className={styles.noticeTitle}>{notice.title}</span>
                    </div>
                    <div className={styles.noticeMeta}>
                      <span className={styles.noticeRegUser}>{notice.regUser}</span>
                      <span className={styles.noticeRegDate}>{notice.regDate}</span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </section>

          {/* 즐겨찾기 (우측) */}
          <section className={styles.panel}>
            <div className={styles.panelHeader}>
              <span className={styles.panelTitle}>즐겨찾기</span>
            </div>
            <div className={styles.panelBody}>
              {favorites.length === 0 ? (
                <p className={styles.emptyText}>등록된 즐겨찾기가 없습니다.</p>
              ) : (
                favorites.map(menu => (
                  <div key={menu.mnuId} className={styles.favoriteRow}>
                    <button
                      type='button'
                      className={styles.favoriteLink}
                      onClick={() => handleFavoriteClick(menu)}
                    >
                      {t(menu.mnuMsgId, menu.mnuDesc)}
                    </button>
                    <button
                      type='button'
                      className={styles.favoriteDelete}
                      onClick={() => handleDelete(String(menu.mnuId))}
                      aria-label={`${menu.mnuDesc} 삭제`}
                    >
                      🗑️
                    </button>
                  </div>
                ))
              )}
            </div>
          </section>
        </div>
      )}
    </div>
  );
};
