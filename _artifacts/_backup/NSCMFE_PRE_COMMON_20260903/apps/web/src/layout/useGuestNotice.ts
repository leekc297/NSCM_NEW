import { useEffect, useRef } from 'react';

import { useMessageStore, useSessionStore } from '@shared/stores';

/**
 * 레거시 GSCM 재현: 미등록 게스트로 로그인하면 "권한 없음 → 권한신청" 안내를 띄운다.
 * 현업 결정(2026-07): 메시지코드 MSG00023 다국어 / 단일 닫기 버튼(확인/취소 분기 없음).
 * 로그인 1회당 한 번만 노출.
 */
export const useGuestNotice = () => {
  const { t } = useTranslation();
  const isLogin = useSessionStore(state => state.isLogin);
  const isGuest = useSessionStore(state => state.session?.guest); // BE는 "guest"로 직렬화
  const setAlert = useMessageStore(state => state.setAlert);
  const shownRef = useRef(false);

  useEffect(() => {
    if (!isLogin) {
      shownRef.current = false; // 로그아웃 시 리셋
      return;
    }
    if (!isGuest || shownRef.current) return;
    shownRef.current = true;

    void setAlert({
      type: 'alert',
      content: t('MSG00023', 'You are not authorized to NSCM.\nApply for permission.'),
    });
  }, [isLogin, isGuest, setAlert, t]);
};
