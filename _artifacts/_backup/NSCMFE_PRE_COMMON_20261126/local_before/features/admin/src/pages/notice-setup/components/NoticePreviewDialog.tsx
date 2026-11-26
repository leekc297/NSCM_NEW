import { useEffect, useState, type MouseEvent } from 'react';
import { createPortal } from 'react-dom';

import { Checkbox } from '@shared/lges';

import {
  formatFileSize,
  getAttachmentDownloadUrl,
  getSafeNoticeImageSource,
  sanitizeNoticeHtml,
} from '../notice-setup.util';
import { useNoticeAttachmentsQuery } from '../useNoticeAttachments';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticePreviewDialog.module.scss';

/**
 * 공지 미리보기 — 홈 공지 팝업(apps/web pages/NoticePreviewModal)과 같은 커스텀 오버레이 형태.
 * 창/헤더(말머리 점 + [모듈] 제목 + 닫기)/본문 박스/첨부/메타 chrome 을 홈 팝업과 맞춘다.
 * 홈과 다른 점: 이전·다음 네비게이션이 없고, 하단 정보는 게시기간이다.
 * 편집 다이얼로그(MUI, z-index ~1300) 위에서 열릴 수 있어 오버레이 z-index 를 그보다 높게 둔다.
 */
export const NoticePreviewDialog = () => {
  const { t } = useTranslation();

  const isPreviewOpen = useNoticeSetupStore(state => state.isPreviewOpen);
  const previewNotice = useNoticeSetupStore(state => state.previewNotice);
  const previewHideToday = useNoticeSetupStore(state => state.previewHideToday);
  const closePreview = useNoticeSetupStore(state => state.closePreview);
  const setPreviewHideToday = useNoticeSetupStore(state => state.setPreviewHideToday);
  const sessionAttachments = useNoticeSetupStore(state => state.attachments);
  const isEditorOpen = useNoticeSetupStore(state => state.isEditorOpen);

  // 편집 중 미리보기(draft)는 세션 첨부 목록을, 그리드에서 연 저장 공지는 서버 조회를 쓴다.
  const { data: fetchedAttachments } = useNoticeAttachmentsQuery(
    String(previewNotice?.NOTICE_ID ?? ''),
    isPreviewOpen && !isEditorOpen && !!previewNotice?.NOTICE_ID
  );

  // 확대해서 볼 이미지 src(없으면 null). 본문 이미지 더블클릭·배너 이미지 클릭으로 연다.
  const [zoomedImage, setZoomedImage] = useState<string | null>(null);

  // 미리보기를 닫으면 확대 상태도 함께 해제
  useEffect(() => {
    if (!isPreviewOpen) setZoomedImage(null);
  }, [isPreviewOpen]);

  // ESC — 확대 중이면 확대만, 아니면 미리보기를 닫는다. 캡처 단계에서 가로채 상위(편집 다이얼로그)까지 닫히지 않게 한다.
  useEffect(() => {
    if (!isPreviewOpen) return;
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return;
      event.stopPropagation();
      if (zoomedImage) setZoomedImage(null);
      else closePreview();
    };
    document.addEventListener('keydown', handleKeyDown, true);
    return () => document.removeEventListener('keydown', handleKeyDown, true);
  }, [isPreviewOpen, zoomedImage, closePreview]);

  if (!isPreviewOpen || !previewNotice) return null;

  const title = previewNotice.NOTICE_TITLE || t('LBL00388', '_Notice');
  const safeContent = sanitizeNoticeHtml(previewNotice.NOTICE_CONTENT);
  const imageSource = getSafeNoticeImageSource(previewNotice.NOTICE_IMAGE);
  const attachments = isEditorOpen ? sessionAttachments : (fetchedAttachments ?? []);
  const hasPublicationPeriod = previewNotice.START_DATE || previewNotice.END_DATE;
  const publicationPeriod = hasPublicationPeriod
    ? `${t('LBL00389', '_Publication Period')} : ${previewNotice.START_DATE || '-'} ~ ${previewNotice.END_DATE || '-'}`
    : '';

  // 본문 이미지 더블클릭 → 원본(전체) 크기로 확대
  const handleContentDoubleClick = (event: MouseEvent<HTMLDivElement>) => {
    const target = event.target;
    if (target instanceof HTMLImageElement && target.src) setZoomedImage(target.src);
  };

  return createPortal(
    <div className={styles.overlay} role='dialog' aria-modal='true' aria-label={title}>
      {/* 반투명 배경 — 클릭 시 닫기 */}
      <button type='button' className={styles.backdrop} aria-label='Close' onClick={closePreview} />

      <div className={styles.window}>
        <div className={styles.header}>
          <h2 className={styles.title}>
            <span className={styles.bullet} aria-hidden='true' />
            {previewNotice.MODULE_NM && (
              <span className={styles.module}>[{previewNotice.MODULE_NM}]</span>
            )}
            {title}
          </h2>
          <button type='button' className={styles.close} aria-label='Close' onClick={closePreview}>
            ×
          </button>
        </div>

        {/* 본문 — 테두리 박스 안에서만 스크롤 */}
        <div className={styles.body}>
          {safeContent ? (
            <div
              className={styles.noticeContent}
              onDoubleClick={handleContentDoubleClick}
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
                onClick={() => setZoomedImage(imageSource)}
              >
                <img className={styles.image} src={imageSource} alt={previewNotice.IMAGE_FILE_NM} />
              </button>
              {previewNotice.IMAGE_FILE_NM && (
                <p className={styles.imageName}>{previewNotice.IMAGE_FILE_NM}</p>
              )}
            </div>
          )}
        </div>

        {/* 첨부파일 — 본문 박스와 별개로 하단에 분리된 영역 */}
        {attachments.length > 0 && (
          <div className={styles.attachmentsSection}>
            <span className={styles.attachmentsLabel}>첨부파일</span>
            <ul className={styles.attachmentList}>
              {attachments.map(attachment => (
                <li key={attachment.fileId} className={styles.attachmentItem}>
                  <a
                    className={styles.attachmentLink}
                    href={getAttachmentDownloadUrl(attachment.fileId)}
                  >
                    {attachment.fileName}
                  </a>
                  <span className={styles.attachmentSize}>{formatFileSize(attachment.size)}</span>
                </li>
              ))}
            </ul>
          </div>
        )}

        <div className={styles.meta}>
          {publicationPeriod && (
            <span className={styles.publicationPeriod}>{publicationPeriod}</span>
          )}
          <Checkbox
            labelText={t('LBL00381', '_Do not open again today')}
            checked={previewHideToday}
            onChange={setPreviewHideToday}
          />
        </div>
      </div>

      {/* 이미지 확대 — 화면 전체. 아무 곳이나 클릭하면 닫힌다 */}
      {zoomedImage && (
        <button
          type='button'
          className={styles.zoomOverlay}
          onClick={() => setZoomedImage(null)}
          aria-label={t('LBL00107', '_취소')}
        >
          <img className={styles.zoomImage} src={zoomedImage} alt={previewNotice.IMAGE_FILE_NM} />
        </button>
      )}
    </div>,
    document.body
  );
};
