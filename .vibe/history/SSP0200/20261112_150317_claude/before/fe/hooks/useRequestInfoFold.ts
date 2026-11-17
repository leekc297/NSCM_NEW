import { useCallback, useEffect, useLayoutEffect, useRef, useState } from 'react';

import { useSessionStore } from '@shared/stores';

import { MENU_ID } from '../shipment-change-request-plan.constants';

/** 고정 상태 — 펼친 채 고정 / 접은 채 고정. 미고정은 저장값 없음(null). */
export type RequestInfoPin = 'expanded' | 'collapsed';

// 고정 상태 저장 키 — 화면·사용자별. 탭 store(createPersistedStoreWithTab)는 영속화하지 않으므로
//   (재진입·새로고침 시 초기화) "고정" 의미를 지키려면 별도 저장소가 필요하다. 선례: apps/web useHomeNotices.
const storageKey = (userId: string): string => `nscm.${MENU_ID}.requestInfoPin.${userId}`;

const readPin = (userId: string): RequestInfoPin | null => {
  try {
    const v = window.localStorage.getItem(storageKey(userId));
    return v === 'expanded' || v === 'collapsed' ? v : null;
  } catch {
    return null; // 저장소 차단(보안 정책 등) — 미고정으로 동작
  }
};

const writePin = (userId: string, pin: RequestInfoPin | null): void => {
  try {
    if (pin) window.localStorage.setItem(storageKey(userId), pin);
    else window.localStorage.removeItem(storageKey(userId));
  } catch {
    // 저장 실패 — 이번 화면 안에서만 고정 상태가 유지된다.
  }
};

// 측정 전 기본 패널 높이(px). 측정값이 오면 그 값으로 바뀐다 — 내용보다 작게 잡혀도 잘림은 첫 측정까지 1프레임뿐.
const FALLBACK_EXPANDED = 160;
const FALLBACK_COLLAPSED = 48;

/**
 * 요청정보(Request Info) 영역 접기/펼치기 + 고정(사용자 지시 2026-11-12).
 *   - 접기/펼치기: 머리줄 화살표 버튼. 고정 중에는 비활성.
 *   - 고정: 핀 버튼. 누른 시점의 상태(펼침/접힘)로 고정하고 화면·사용자별로 저장해 재진입 시 그 상태로 연다.
 *     다시 누르면 고정 해제(저장값 삭제) — 이후 재진입은 기본(펼침).
 *   - 패널 높이: 내용 실측(ResizeObserver) 값을 그대로 쓴다. 고정 px 를 추정해 두면 내용이 늘 때
 *     overflow:hidden 패널이 조용히 잘린다(2026-10-14 Request Complete 잘림 사고) — 측정으로 대체.
 */
export const useRequestInfoFold = () => {
  const userId = useSessionStore(s => String(s.session.userId ?? ''));
  const [pin, setPin] = useState<RequestInfoPin | null>(() => readPin(userId));
  const [collapsed, setCollapsed] = useState<boolean>(() => readPin(userId) === 'collapsed');
  const [contentHeight, setContentHeight] = useState<number>(0);
  const contentRef = useRef<HTMLDivElement>(null);

  // 사용자 전환(재로그인) 시 그 사용자의 고정 상태로 다시 맞춘다.
  useEffect(() => {
    const saved = readPin(userId);
    setPin(saved);
    if (saved) setCollapsed(saved === 'collapsed');
  }, [userId]);

  useLayoutEffect(() => {
    const el = contentRef.current;
    if (!el) return undefined;
    const measure = () => {
      const h = Math.ceil(el.getBoundingClientRect().height);
      if (h > 0) setContentHeight(prev => (prev === h ? prev : h));
    };
    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  const toggleCollapsed = useCallback(() => {
    if (pin) return; // 고정 중에는 상태를 바꾸지 않는다
    setCollapsed(prev => !prev);
  }, [pin]);

  const togglePin = useCallback(() => {
    const next: RequestInfoPin | null = pin ? null : collapsed ? 'collapsed' : 'expanded';
    writePin(userId, next);
    setPin(next);
  }, [pin, collapsed, userId]);

  const fallback = collapsed ? FALLBACK_COLLAPSED : FALLBACK_EXPANDED;
  const panelSize = `${contentHeight > 0 ? contentHeight : fallback}px`;

  return { collapsed, pin, toggleCollapsed, togglePin, contentRef, panelSize };
};
