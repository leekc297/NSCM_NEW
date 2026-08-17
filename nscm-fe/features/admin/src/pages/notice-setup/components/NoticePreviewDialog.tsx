import { useEffect, useState } from 'react';
import { createPortal } from 'react-dom';

import { CustomDialog } from '@shared/components';
import { Checkbox } from '@shared/lges';

import { getSafeNoticeImageSource, sanitizeNoticeHtml } from '../notice-setup.util';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticePreviewDialog.module.scss';

/**
 * 공지 미리보기.
 * 홈 화면 공지 팝업(apps/web pages/NoticePreviewModal)과 같은 형태로 보여준다 —
 * 말머리 점 + [모듈] 제목 / 회색 테두리 박스 안에서 스크롤되는 본문 / 맨 아래 이미지 / 게시기간·체크박스.
 * 창 크기(750×750)는 내용과 무관하게 고정이고, 이미지는 축소해 넣되 클릭하면 원본 크기로 확대한다.
 */
export const NoticePreviewDialog = () => {
  const { t } = useTranslation();

  const isPreviewOpen = useNoticeSetupStore(state => state.isPreviewOpen);
  const previewNotice = useNoticeSetupStore(state => state.previewNotice);
  const previewHideToday = useNoticeSetupStore(state => state.previewHideToday);
  const closePreview = useNoticeSetupStore(state => state.closePreview);
  const setPreviewHideToday = useNoticeSetupStore(state => state.setPreviewHideToday);

  const [isZoomed, setIsZoomed] = useState(false);

  // 미리보기를 닫으면 확대 상태도 함께 해제(다음에 열 때 확대된 채로 뜨지 않도록)
  useEffect(() => {
    if (!isPreviewOpen) setIsZoomed(false);
  }, [isPreviewOpen]);

  // 확대 중 ESC 는 확대만 닫는다 — 캡처 단계에서 가로채 MUI Dialog 의 ESC 닫기까지 가지 않게 한다.
  useEffect(() => {
    if (!isZoomed) return;
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      event.stopPropagation();
      setIsZoomed(false);
    };
    document.addEventListener('keydown', handleKeyDown, true);
    return () => document.removeEventListener('keydown', handleKeyDown, true);
  }, [isZoomed]);

  if (!previewNotice) return null;

  const title = previewNotice.NOTICE_TITLE || t('LBL00388', '_Notice');
  const safeContent = sanitizeNoticeHtml(previewNotice.NOTICE_CONTENT);
  const imageSource = getSafeNoticeImageSource(previewNotice.NOTICE_IMAGE);
  const hasPublicationPeriod = previewNotice.START_DATE || previewNotice.END_DATE;
  const publicationPeriod = hasPublicationPeriod
    ? `${t('LBL00389', '_Publication Period')} : ${previewNotice.START_DATE || '-'} ~ ${previewNotice.END_DATE || '-'}`
    : '';

  return (
    <>
      <CustomDialog
        open={isPreviewOpen}
        size={750}
        height={750}
        disableScale
        type='modal'
        position='basic'
        handleClose={closePreview}
        draggable={false}
        disableButtonCancel
        customHeaderTitle={
          <h2 className={styles.headerTitle}>
            <span className={styles.bullet} aria-hidden='true' />
            {previewNotice.MODULE_NM && (
              <span className={styles.module}>[{previewNotice.MODULE_NM}]</span>
            )}
            {title}
          </h2>
        }
        customContentArea={
          <article className={styles.preview}>
            {/* 본문 — 회색 테두리 박스 안에서만 스크롤 */}
            <div className={styles.body}>
              {safeContent ? (
                <div
                  className={styles.noticeContent}
                  dangerouslySetInnerHTML={{ __html: safeContent }}
                />
              ) : (
                <p className={styles.emptyContent}>
                  {t('LBL00412', '_There is no registered content.')}
                </p>
              )}

              {/* 이미지는 항상 본문 맨 아래. 클릭하면 원본 크기로 확대 */}
              {imageSource && (
                <div className={styles.imageBox}>
                  <button
                    type='button'
                    className={styles.imageButton}
                    onClick={() => setIsZoomed(true)}
                  >
                    <img
                      className={styles.image}
                      src={imageSource}
                      alt={previewNotice.IMAGE_FILE_NM}
                    />
                  </button>
                  {previewNotice.IMAGE_FILE_NM && (
                    <p className={styles.imageName}>{previewNotice.IMAGE_FILE_NM}</p>
                  )}
                </div>
              )}
            </div>

            <div className={styles.meta}>
              {publicationPeriod && (
                <span className={styles.publicationPeriod}>{publicationPeriod}</span>
              )}
              <Checkbox
                labelText={t('LBL00413', '_Do not open again today')}
                checked={previewHideToday}
                onChange={setPreviewHideToday}
              />
            </div>
          </article>
        }
      />

      {/* 이미지 확대 — 화면 전체. 아무 곳이나 클릭하면 닫힌다 */}
      {isZoomed &&
        imageSource &&
        createPortal(
          <button
            type='button'
            className={styles.zoomOverlay}
            onClick={() => setIsZoomed(false)}
            aria-label={t('LBL00107', '_취소')}
          >
            <img className={styles.zoomImage} src={imageSource} alt={previewNotice.IMAGE_FILE_NM} />
          </button>,
          document.body
        )}
    </>
  );
};
