import { useEffect, useRef, useState } from 'react';
import { useSearchParams } from 'react-router-dom';

import type { Menu } from '@foundation/models';
import { useClearAppData } from '@shared/hooks';
import { InputField, Button } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import { useMDIStore } from '../mdi/useMDIStore';

import styles from './Home.module.scss';
import { getNoticeTextPreview } from './noticeContent';
import { NoticePreviewModal } from './NoticePreviewModal';
import { TestPage } from './TestPage';
import {
  useHomeNotices,
  formatNoticeDate,
  getTodayKey,
  isNoticeInPeriod,
  isPopupDismissedToday,
  dismissPopupForToday,
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

  // 개발용 테스트 진입 — /home?test=true (또는 /view/home?test=true) 이면 대시보드 대신 TestPage 렌더.
  //   RouterSync 가 /view/home 으로 미러링해도 쿼리를 보존하므로 플래그가 유지된다.
  const [searchParams] = useSearchParams();
  const isTestMode = searchParams.get('test') === 'true';

  const isLogin = useSessionStore(state => state.isLogin);
  const login = useSessionStore(state => state.login);
  const logout = useSessionStore(state => state.logout);
  const session = useSessionStore(state => state.session);
  const toggleFavorite = useSessionStore(state => state.toggleFavorite);
  const openTab = useMDIStore(state => state.openTab);
  const { clearAllData } = useClearAppData();
  const notices = useHomeNotices();

  // 로그아웃 — 서버 세션 종료(/user/logout)를 기다린 뒤 로컬 상태 전체 정리:
  //   열린 탭 전부 닫기(MDI 초기화) + 모든 페이지 스토어 reset + react-query 캐시 + sessionStorage 클리어.
  //   재로그인 시 이전 사용자 화면/데이터가 남지 않도록 한다.
  //   ※ await 필수 — 서버 세션이 살아있는 동안 캐시를 비우면, 그 직후 재조회되는 쿼리들이
  //     이전 계정 데이터로 캐시를 다시 채우고 sessionStorage 도 다시 기록된다.
  const handleLogout = async () => {
    await logout();
    await clearAllData();
  };
  const admins = useSystemAdmins();

  // 목록 클릭 상세 팝업(항상 열림, 체크박스 없음). listNotices 기준 인덱스 — 이전/다음 이동용
  const [previewIndex, setPreviewIndex] = useState<number | null>(null);
  // 로드 시 자동 팝업 대상(POPUP_YN='Y' + 게시기간 내 + 당일 미차단)과 현재 노출 위치
  const [popupNotices, setPopupNotices] = useState<HomeNotice[]>([]);
  const [popupIndex, setPopupIndex] = useState(0);
  const popupSeededRef = useRef(false);

  const today = getTodayKey();
  // 목록: 게시기간(오늘 ∈ START~END) 내 공지 전체(최신순). 많으면 패널 안에서 스크롤된다
  const listNotices = notices.filter(notice => isNoticeInPeriod(notice, today));

  useEffect(() => {
    if (popupSeededRef.current || notices.length === 0) return;
    popupSeededRef.current = true;
    setPopupNotices(
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

  // 개발용 테스트 페이지 — 로그인 상태에서 ?test=true 로 진입한 경우 대시보드 대신 노출.
  if (isTestMode) {
    return <TestPage />;
  }

  return (
    <div className={styles.homeWrapper}>
      <div className={styles.topBar}>
        <span className={styles.welcome}>Hello! {session.userNm}</span>
        <Button onClick={() => void handleLogout()}>Logout</Button>
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
                  listNotices.map((notice, index) => {
                    // 제목 아래 한 줄 요약 — 내용 HTML 에서 태그를 걷어낸 텍스트
                    const summary = getNoticeTextPreview(notice.NOTICE_CONTENT);

                    return (
                      <div
                        key={notice.NOTICE_ID}
                        className={styles.noticeRow}
                        onClick={() => setPreviewIndex(index)}
                      >
                        <div className={styles.noticeHead}>
                          {notice.MODULE_NM && (
                            <span className={styles.noticeBadge}>{notice.MODULE_NM}</span>
                          )}
                          <span className={styles.noticeTitle}>{notice.NOTICE_TITLE}</span>
                        </div>
                        {/* 요약이 없어도 카드 높이가 들쭉날쭉하지 않도록 줄 자체는 항상 렌더 */}
                        <p className={styles.noticeSummary}>{summary}</p>
                        <span className={styles.noticeRegDate}>
                          {formatNoticeDate(notice.CREATION_DATE)}
                        </span>
                      </div>
                    );
                  })
                )}
              </div>
            </section>

            {/* My Authorities — session.groups (많으면 패널 안에서 스크롤) */}
            <section className={`${styles.panel} ${styles.authorityPanel}`}>
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

      {/* 목록 클릭 상세 — 무조건 열림, "오늘 하루 열지 않기" 없음. 목록 내에서 이전/다음 이동 */}
      {previewIndex !== null && listNotices[previewIndex] && (
        <NoticePreviewModal
          notice={listNotices[previewIndex]}
          onPrev={previewIndex > 0 ? () => setPreviewIndex(previewIndex - 1) : undefined}
          onNext={
            previewIndex < listNotices.length - 1
              ? () => setPreviewIndex(previewIndex + 1)
              : undefined
          }
          onClose={() => setPreviewIndex(null)}
        />
      )}

      {/* 로드 시 자동 팝업 — POPUP_YN='Y', "오늘 하루 열지 않기" 지원 (한 건씩 순차 노출). 게스트는 제외 */}
      {!session?.guest && popupNotices[popupIndex] && (
        <NoticePreviewModal
          notice={popupNotices[popupIndex]}
          showHideToday
          onPrev={popupIndex > 0 ? () => setPopupIndex(popupIndex - 1) : undefined}
          onNext={
            popupIndex < popupNotices.length - 1 ? () => setPopupIndex(popupIndex + 1) : undefined
          }
          // 닫기: 체크 시 당일 차단하고 다음 건으로. 마지막이면 팝업 종료
          onClose={hideToday => {
            const current = popupNotices[popupIndex];
            if (hideToday) dismissPopupForToday(current.NOTICE_ID, today);
            if (popupIndex < popupNotices.length - 1) setPopupIndex(popupIndex + 1);
            else setPopupNotices([]);
          }}
        />
      )}
    </div>
  );
};
