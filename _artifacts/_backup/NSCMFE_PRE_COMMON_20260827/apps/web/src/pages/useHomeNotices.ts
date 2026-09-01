import { apiClient } from '@foundation/apis';
import { useQuery } from '@foundation/query-client';
import { useSessionStore } from '@shared/stores';

/**
 * 홈 공지 한 건. 관리자 공지관리(SYS0016) 조회 응답(o_rc1) 중 홈에서 쓰는 컬럼만 추린다.
 * - MODULE_NM: 모듈 룩업 이름(`[DM]` 라벨용)
 * - NOTICE_TITLE: 세션 언어 기준 제목
 * - NOTICE_CONTENT/NOTICE_IMAGE/IMAGE_FILE_NM: 클릭 시 미리보기 내용
 * - START_DATE/END_DATE: 게시기간(오늘이 이 사이여야 노출)
 * - POPUP_YN: 'Y' 면 로드 시 자동 팝업 대상
 * - CREATION_DATE: 등록일(정렬·표시 기준)
 */
export interface HomeNotice {
  NOTICE_ID: string;
  MODULE: string;
  MODULE_NM: string;
  ACTIVE: string;
  NOTICE_TITLE: string;
  NOTICE_CONTENT: string;
  NOTICE_IMAGE: string;
  IMAGE_FILE_NM: string;
  START_DATE: string;
  END_DATE: string;
  POPUP_YN: string;
  CREATION_DATE: string;
}

interface HomeNoticeResponse {
  o_rc1: HomeNotice[];
}

const EMPTY: HomeNotice[] = [];

/** 다양한 날짜 문자열(yyyyMMdd / yyyy-MM-dd / ISO)을 yyyy.MM.dd 로 정규화한다. */
export const formatNoticeDate = (raw?: string): string => {
  if (!raw) return '';
  const digits = raw.replace(/\D/g, '');
  if (digits.length >= 8) {
    return `${digits.slice(0, 4)}.${digits.slice(4, 6)}.${digits.slice(6, 8)}`;
  }
  return raw;
};

/**
 * 상세 팝업의 "등록 일시"(마침표 구분). 시각까지 들어온 값은 `yyyy.MM.dd HH:mm`,
 * 날짜만 있으면 `yyyy.MM.dd` 로 보여준다.
 */
export const formatNoticeDateTime = (raw?: string): string => {
  if (!raw) return '';
  const digits = raw.replace(/\D/g, '');
  if (digits.length < 8) return raw;

  const date = `${digits.slice(0, 4)}.${digits.slice(4, 6)}.${digits.slice(6, 8)}`;
  if (digits.length < 12) return date;
  return `${date} ${digits.slice(8, 10)}:${digits.slice(10, 12)}`;
};

/** 비교용 yyyyMMdd 키(8자리 숫자). 빈 값/형식불명은 undefined. */
const toDateKey = (raw?: string): string | undefined => {
  if (!raw) return undefined;
  const digits = raw.replace(/\D/g, '');
  return digits.length >= 8 ? digits.slice(0, 8) : undefined;
};

/** 오늘 날짜 yyyyMMdd. */
export const getTodayKey = (): string => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}${month}${day}`;
};

/** 오늘이 공지 게시기간(START~END, 경계 포함) 안인지. 빈 경계는 무한대로 취급. */
export const isNoticeInPeriod = (notice: HomeNotice, today = getTodayKey()): boolean => {
  const start = toDateKey(notice.START_DATE);
  const end = toDateKey(notice.END_DATE);
  if (start && today < start) return false;
  if (end && today > end) return false;
  return true;
};

/* ---------- 자동 팝업 "오늘 하루 열지 않기" (당일·공지별 localStorage) ---------- */
const DISMISS_PREFIX = 'home-notice-hide:';

export const isPopupDismissedToday = (noticeId: string, today = getTodayKey()): boolean =>
  localStorage.getItem(DISMISS_PREFIX + noticeId) === today;

export const dismissPopupForToday = (noticeId: string, today = getTodayKey()): void => {
  localStorage.setItem(DISMISS_PREFIX + noticeId, today);
};

/**
 * 홈 공지 조회.
 * BE `/notice/home`(로그인 전용)이 관리자 공지 프로시저를 재사용해 활성 공지를 반환하면,
 * 활성 건만 추려 등록일 내림차순으로 정렬해 돌려준다.
 * 게시기간(START~END) 필터·팝업 여부는 소비하는 쪽(Home)에서 오늘 날짜 기준으로 처리한다.
 *
 * ※ 캐시 정책만 전역 기본값(staleTime Infinity + gcTime 8h + IndexedDB 영속)에서 예외를 둔다.
 *   기본값 그대로면 새로고침을 해도 영속 캐시가 복원돼 관리자 화면(SYS0016)에서 고친 공지가
 *   브라우저 탭을 새로 열기 전까지 반영되지 않는다.
 *   staleTime 0(마운트 시 재조회) + gcTime 0(영속 대상 제외)으로 새로고침·재로그인 때 새로 받는다.
 *   탭 전환만으로는 재조회하지 않는다 — MDI keep-alive 규약(다른 화면과 동일)을 따른다.
 */
export const useHomeNotices = (): HomeNotice[] => {
  const isLogin = useSessionStore(state => state.isLogin);

  const { data } = useQuery<HomeNotice[]>({
    queryKey: ['home-notices'],
    enabled: isLogin,
    staleTime: 0,
    gcTime: 0,
    queryFn: async () => {
      const response = await apiClient.get<HomeNoticeResponse>('/notice/home');
      const rows = response.data.result?.o_rc1 ?? [];

      return rows
        .filter(row => row.ACTIVE === 'Y')
        .sort((a, b) => (b.CREATION_DATE ?? '').localeCompare(a.CREATION_DATE ?? ''));
    },
  });

  return data ?? EMPTY;
};
