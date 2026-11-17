import { useCallback, useEffect, useState } from 'react';

import { useSessionStore } from '@shared/stores';

import { MENU_ID } from '../shipment-change-request-confirm.constants';

/** 고정 상태 — 펼친 채 고정 / 접은 채 고정. 미고정은 저장값 없음(null). */
export type ConfirmDetailPin = 'expanded' | 'collapsed';

// 고정 상태 저장 키 — 화면·사용자별. 탭 store(createPersistedStoreWithTab)는 영속화하지 않으므로
//   (재진입·새로고침 시 초기화) "고정" 의미를 지키려면 별도 저장소가 필요하다.
//   자매 SSP0200 `useRequestInfoFold` 와 같은 규칙(키만 화면 ID 로 다르다). 선례: apps/web useHomeNotices.
const storageKey = (userId: string): string => `nscm.${MENU_ID}.confirmDetailPin.${userId}`;

const readPin = (userId: string): ConfirmDetailPin | null => {
  try {
    const v = window.localStorage.getItem(storageKey(userId));
    return v === 'expanded' || v === 'collapsed' ? v : null;
  } catch {
    return null; // 저장소 차단(보안 정책 등) — 미고정으로 동작
  }
};

const writePin = (userId: string, pin: ConfirmDetailPin | null): void => {
  try {
    if (pin) window.localStorage.setItem(storageKey(userId), pin);
    else window.localStorage.removeItem(storageKey(userId));
  } catch {
    // 저장 실패 — 이번 화면 안에서만 고정 상태가 유지된다.
  }
};

/**
 * Request Confirm Detail 영역 접기/펼치기 + 고정(사용자 지시 2026-11-12 — SSP0200 Request Info 와 같은 형태).
 *   - 접기/펼치기: 머리줄 화살표 버튼. 고정 중에는 비활성.
 *   - 고정: 핀 버튼. 누른 시점의 상태(펼침/접힘)로 고정하고 화면·사용자별로 저장해 재진입 시 그 상태로 연다.
 *     다시 누르면 고정 해제(저장값 삭제) — 이후 재진입은 기본(펼침).
 *   - SSP0200 과 달리 패널 높이 실측은 없다: SSP0202 의 디테일 폼은 하단 Panel 안에서 자연 높이(flex 0 0 auto)
 *     이고 남는 높이는 아래 디테일 그리드가 가져가므로, 접으면 그리드가 그만큼 커진다(px 고정 패널 아님).
 */
export const useConfirmDetailFold = () => {
  const userId = useSessionStore(s => String(s.session.userId ?? ''));
  const [pin, setPin] = useState<ConfirmDetailPin | null>(() => readPin(userId));
  const [collapsed, setCollapsed] = useState<boolean>(() => readPin(userId) === 'collapsed');

  // 사용자 전환(재로그인) 시 그 사용자의 고정 상태로 다시 맞춘다.
  useEffect(() => {
    const saved = readPin(userId);
    setPin(saved);
    if (saved) setCollapsed(saved === 'collapsed');
  }, [userId]);

  const toggleCollapsed = useCallback(() => {
    if (pin) return; // 고정 중에는 상태를 바꾸지 않는다
    setCollapsed(prev => !prev);
  }, [pin]);

  const togglePin = useCallback(() => {
    const next: ConfirmDetailPin | null = pin ? null : collapsed ? 'collapsed' : 'expanded';
    writePin(userId, next);
    setPin(next);
  }, [pin, collapsed, userId]);

  return { collapsed, pin, toggleCollapsed, togglePin };
};
