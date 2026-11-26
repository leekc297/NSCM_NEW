import { useEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';

import { Checkbox } from '@shared/lges';

import { sanitizeNoticeHtml, getSafeNoticeImageSource } from './noticeContent';
import styles from './NoticePreviewModal.module.scss';
import { formatNoticeDateTime, type HomeNotice } from './useHomeNotices';

interface NoticePreviewModalProps {
  notice: HomeNotice;
  /** 닫힐 때 호출. hideToday 는 "오늘 하루 열지 않기" 체크 여부(자동 팝업에서만 의미). */
  onClose: (hideToday: boolean) => void;
  /** true 면 "오늘 하루 열지 않기" 체크박스 노출(자동 팝업 전용). 목록 클릭 미리보기는 false. */
  showHideToday?: boolean;
  /** 이전/다음 공지로 이동. 없으면(양 끝·단건) 버튼은 자리를 지키고 비활성된다. */
  onPrev?: () => void;
  onNext?: () => void;
}

/**
 * 홈 공지 상세 팝업.
 * 반투명 배경으로 뒤 화면을 덮는 모달이며, 제목 / 본문(테두리 박스 안에서 스크롤) /
 * 등록 일시 / 이전·다음 순으로 쌓인다. 내용(NOTICE_CONTENT)은 관리자 미리보기와 동일하게 sanitize 한다.
 * - 배경 클릭 / ESC / × 로 닫고, ←→ 키와 하단 버튼으로 이전·다음 공지로 이동한다.
 * - 창 크기는 내용·이미지와 무관하게 고정. 이미지는 항상 본문 맨 아래에 축소해 넣고,
 *   클릭하면 원본 크기로 전체 화면 확대한다.
 * - 자동 팝업(showHideToday)일 때만 "오늘 하루 열지 않기" 체크박스를 노출한다.
 */
export const NoticePreviewModal = ({
  notice,
  onClose,
  showHideToday = false,
  onPrev,
  onNext,
}: NoticePreviewModalProps) => {
  const [hideToday, setHideToday] = useState(false);
  const [isZoomed, setIsZoomed] = useState(false);
  const bodyRef = useRef<HTMLDivElement>(null);

  // 공지가 바뀌면(이전/다음) 창 상태를 초기화하고 본문을 맨 위로
  useEffect(() => {
    setHideToday(false);
    setIsZoomed(false);
    bodyRef.current?.scrollTo({ top: 0 });
  }, [notice.NOTICE_ID]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      // 확대 중이면 ESC 는 확대만 닫는다(팝업은 유지)
      if (event.key === 'Escape') {
        if (isZoomed) setIsZoomed(false);
        else onClose(hideToday);
        return;
      }
      if (isZoomed) return;
      if (event.key === 'ArrowLeft') onPrev?.();
      if (event.key === 'ArrowRight') onNext?.();
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onClose, hideToday, isZoomed, onPrev, onNext]);

  const safeContent = sanitizeNoticeHtml(notice.NOTICE_CONTENT);
  const imageSource = getSafeNoticeImageSource(notice.NOTICE_IMAGE);

  return createPortal(
    <div
      className={styles.overlay}
      role='dialog'
      aria-modal='true'
      aria-label={notice.NOTICE_TITLE}
    >
      {/* 반투명 배경 — 클릭 시 닫기 */}
      <button
        type='button'
        className={styles.backdrop}
        aria-label='Close'
        onClick={() => onClose(hideToday)}
      />

      <div className={styles.window}>
        <div className={styles.header}>
          <h2 className={styles.title}>
            <span className={styles.bullet} aria-hidden='true' />
            {notice.MODULE_NM && <span className={styles.module}>[{notice.MODULE_NM}]</span>}
            {notice.NOTICE_TITLE}
          </h2>
          <button
            type='button'
            className={styles.close}
            aria-label='Close'
            onClick={() => onClose(hideToday)}
          >
            ×
          </button>
        </div>

        {/* 본문 — 테두리 박스 안에서만 스크롤 */}
        <div className={styles.body} ref={bodyRef}>
          {safeContent ? (
            <div className={styles.content} dangerouslySetInnerHTML={{ __html: safeContent }} />
          ) : (
            <p className={styles.empty}>등록된 내용이 없습니다.</p>
          )}

          {/* 이미지는 항상 본문 맨 아래. 클릭하면 원본 크기로 확대 */}
          {imageSource && (
            <div className={styles.imageBox}>
              <button
                type='button'
                className={styles.imageButton}
                onClick={() => setIsZoomed(true)}
                aria-label='이미지 확대'
              >
                <img
                  className={styles.image}
                  src={imageSource}
                  alt={notice.IMAGE_FILE_NM || notice.NOTICE_TITLE}
                />
              </button>
            </div>
          )}
        </div>

        <div className={styles.meta}>
          <span className={styles.metaDate}>
            등록 일시 : {formatNoticeDateTime(notice.CREATION_DATE) || '-'}
          </span>
          {showHideToday && (
            <Checkbox labelText='오늘 하루 열지 않기' checked={hideToday} onChange={setHideToday} />
          )}
        </div>

        {/* 이전 / 다음 — 항상 노출하고 양 끝에서는 비활성 */}
        <div className={styles.footer}>
          <button type='button' className={styles.navButton} onClick={onPrev} disabled={!onPrev}>
            이전
          </button>
          <button type='button' className={styles.navButton} onClick={onNext} disabled={!onNext}>
            다음
          </button>
        </div>
      </div>

      {/* 이미지 확대 — 화면 전체. 아무 곳이나 클릭하면 닫힌다 */}
      {isZoomed && imageSource && (
        <button
          type='button'
          className={styles.zoomOverlay}
          aria-label='이미지 확대 닫기'
          onClick={() => setIsZoomed(false)}
        >
          <img
            className={styles.zoomImage}
            src={imageSource}
            alt={notice.IMAGE_FILE_NM || notice.NOTICE_TITLE}
          />
        </button>
      )}
    </div>,
    document.body
  );
};
