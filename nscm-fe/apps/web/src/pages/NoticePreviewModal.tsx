import { useEffect, useState } from 'react';
import { createPortal } from 'react-dom';

import { Checkbox } from '@shared/lges';

import { sanitizeNoticeHtml, getSafeNoticeImageSource } from './noticeContent';
import styles from './NoticePreviewModal.module.scss';
import type { HomeNotice } from './useHomeNotices';

interface NoticePreviewModalProps {
  notice: HomeNotice;
  /** 닫힐 때 호출. hideToday 는 "오늘 하루 열지 않기" 체크 여부(자동 팝업에서만 의미). */
  onClose: (hideToday: boolean) => void;
  /** true 면 "오늘 하루 열지 않기" 체크박스 노출(자동 팝업 전용). 목록 클릭 미리보기는 false. */
  showHideToday?: boolean;
}

/**
 * 홈 공지 미리보기.
 * 관리자 미리보기와 동일하게 내용(NOTICE_CONTENT)을 sanitize 해 렌더하되,
 * 테두리·헤더 없이 내용만 뜨는 경량 팝업이다. 배경 클릭 / ESC / × 로 닫는다.
 * 자동 팝업(showHideToday)일 때만 "오늘 하루 열지 않기" 체크박스를 노출한다.
 */
export const NoticePreviewModal = ({
  notice,
  onClose,
  showHideToday = false,
}: NoticePreviewModalProps) => {
  const [hideToday, setHideToday] = useState(false);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose(hideToday);
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onClose, hideToday]);

  const safeContent = sanitizeNoticeHtml(notice.NOTICE_CONTENT);
  const imageSource = getSafeNoticeImageSource(notice.NOTICE_IMAGE);

  return createPortal(
    <div
      className={styles.overlay}
      role='dialog'
      aria-modal='true'
      aria-label={notice.NOTICE_TITLE}
    >
      {/* 배경(테두리 없음) — 클릭 시 닫기 */}
      <button
        type='button'
        className={styles.backdrop}
        aria-label='Close'
        onClick={() => onClose(hideToday)}
      />

      <div className={styles.window}>
        <button
          type='button'
          className={styles.close}
          aria-label='Close'
          onClick={() => onClose(hideToday)}
        >
          ×
        </button>

        {imageSource && (
          <img className={styles.image} src={imageSource} alt={notice.IMAGE_FILE_NM} />
        )}

        {safeContent ? (
          <div className={styles.content} dangerouslySetInnerHTML={{ __html: safeContent }} />
        ) : (
          <p className={styles.empty}>등록된 내용이 없습니다.</p>
        )}

        {showHideToday && (
          <div className={styles.footer}>
            <Checkbox labelText='오늘 하루 열지 않기' checked={hideToday} onChange={setHideToday} />
          </div>
        )}
      </div>
    </div>,
    document.body
  );
};
