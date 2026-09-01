import { useCallback, useEffect, useLayoutEffect, useRef, useState } from 'react';

import { IcArrowLeft, IcCloseTemp } from '@foundation/assets';
import { clsx } from '@shared/clsx';

import styles from './MDITabs.module.scss';
import { useMDIStore } from './useMDIStore';

//TODO: 뒤로가기,앞으로가기(bf cache) 컨트롤 - 이동주
//      (useLocation 변경 감지 + console.warn 자리였음 — 구현 시 라우터 location 구독 복원)

/** 화살표 한 번에 이동할 비율(보이는 폭 기준) */
const SCROLL_STEP_RATIO = 0.8;

export const MDITabs = () => {
  const tabs = useMDIStore(state => state.tabs);
  const activeIndex = useMDIStore(state => state.activeIndex);
  const setActiveTab = useMDIStore(state => state.setActiveTab);
  const closeTab = useMDIStore(state => state.closeTab);
  const closeOtherTabs = useMDIStore(state => state.closeOtherTabs);
  const closeAllTabs = useMDIStore(state => state.closeAllTabs);

  const { t } = useTranslation();

  const stripRef = useRef<HTMLDivElement>(null);
  const activeTabRef = useRef<HTMLButtonElement>(null);
  const [canScrollLeft, setCanScrollLeft] = useState(false);
  const [canScrollRight, setCanScrollRight] = useState(false);

  // 스크롤 가능 여부 재계산 — 탭 추가/삭제, 창 리사이즈, 스크롤 이동마다 호출된다.
  const syncScrollState = useCallback(() => {
    const strip = stripRef.current;
    if (!strip) return;
    const maxScrollLeft = strip.scrollWidth - strip.clientWidth;
    setCanScrollLeft(strip.scrollLeft > 1);
    setCanScrollRight(strip.scrollLeft < maxScrollLeft - 1);
  }, []);

  // 탭 폭/개수가 바뀌면 오버플로 상태가 달라진다.
  // ResizeObserver 로 창 리사이즈와 탭 영역 크기 변화를 함께 잡는다.
  useLayoutEffect(() => {
    const strip = stripRef.current;
    if (!strip) return;

    syncScrollState();
    const observer = new ResizeObserver(syncScrollState);
    observer.observe(strip);
    return () => observer.disconnect();
  }, [syncScrollState, tabs.length]);

  // 활성 탭이 스크롤 영역 밖이면 보이는 위치로 끌어온다.
  // 개수 제한이 없어져 새 탭이 화면 밖에 생기는 경우가 잦으므로 필수.
  useEffect(() => {
    activeTabRef.current?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
    syncScrollState();
  }, [activeIndex, tabs.length, syncScrollState]);

  const scrollByStep = (direction: 1 | -1) => {
    const strip = stripRef.current;
    if (!strip) return;
    strip.scrollBy({ left: direction * strip.clientWidth * SCROLL_STEP_RATIO });
  };

  const handleTabClose = (e: React.MouseEvent, tabIndex: number) => {
    e.stopPropagation();
    closeTab(tabIndex);
  };

  if (tabs.length === 0) return null;

  return (
    <div className={styles.tabArea}>
      <div ref={stripRef} className={styles.tabStrip} onScroll={syncScrollState}>
        {tabs.map((tab, index) => {
          const isActive = activeIndex === index;
          return (
            <button
              key={tab.tabId}
              ref={isActive ? activeTabRef : undefined}
              className={clsx(styles.tab, { [styles.active]: isActive })}
              onClick={() => setActiveTab(index)}
            >
              <span className={styles.tabContent}>{t(tab.mnuMsgId, `${tab.mnuId}`)}</span>
              {tab.closable && (
                <div className={styles.closeBtn}>
                  <IcCloseTemp height={14} onClick={e => handleTabClose(e, index)} />
                </div>
              )}
            </button>
          );
        })}
      </div>

      <div className={styles.tabActions}>
        <button
          type='button'
          className={styles.scrollBtn}
          onClick={() => scrollByStep(-1)}
          disabled={!canScrollLeft}
          aria-label='Scroll tabs left'
        >
          {/* 주의: IcArrowLeft 는 이름과 달리 오른쪽(›)을 가리킨다(SVG 에 rotate(180) 적용됨).
              왼쪽(‹)으로 쓰려면 다시 180° 뒤집어야 한다. */}
          <IcArrowLeft height={14} className={styles.flip} />
        </button>
        <button
          type='button'
          className={styles.scrollBtn}
          onClick={() => scrollByStep(1)}
          disabled={!canScrollRight}
          aria-label='Scroll tabs right'
        >
          <IcArrowLeft height={14} />
        </button>
        <button type='button' className={styles.actionBtn} onClick={closeOtherTabs}>
          {t('LBL00364', '_다른 탭 닫기')}
        </button>
        <button type='button' className={styles.actionBtn} onClick={closeAllTabs}>
          {t('LBL00365', '_모든 탭 닫기')}
        </button>
      </div>
    </div>
  );
};
