import { CustomDialog } from '@shared/components';
import { Checkbox } from '@shared/lges';

import { getSafeNoticeImageSource, sanitizeNoticeHtml } from '../notice-setup.util';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticePreviewDialog.module.scss';

export const NoticePreviewDialog = () => {
  const { t } = useTranslation();

  const isPreviewOpen = useNoticeSetupStore(state => state.isPreviewOpen);
  const previewNotice = useNoticeSetupStore(state => state.previewNotice);
  const previewHideToday = useNoticeSetupStore(state => state.previewHideToday);
  const closePreview = useNoticeSetupStore(state => state.closePreview);
  const setPreviewHideToday = useNoticeSetupStore(state => state.setPreviewHideToday);

  if (!previewNotice) return null;

  const title = previewNotice.NOTICE_TITLE || t('LBL00388', '_Notice');
  const safeContent = sanitizeNoticeHtml(previewNotice.NOTICE_CONTENT);
  const imageSource = getSafeNoticeImageSource(previewNotice.NOTICE_IMAGE);
  const hasPublicationPeriod = previewNotice.START_DATE || previewNotice.END_DATE;
  const publicationPeriod = hasPublicationPeriod
    ? `${t('LBL00389', '_Publication Period')}: ${previewNotice.START_DATE || '-'} ~ ${previewNotice.END_DATE || '-'}`
    : '';

  return (
    <CustomDialog
      open={isPreviewOpen}
      size={294}
      type='modal'
      position='basic'
      handleClose={closePreview}
      draggable={false}
      disableButtonCancel
      customHeaderTitle={<h2 className={styles.headerTitle}>{title}</h2>}
      customContentArea={
        <article className={styles.preview}>
          {imageSource && (
            <div className={styles.previewImageArea}>
              <img
                className={styles.previewImage}
                src={imageSource}
                alt={previewNotice.IMAGE_FILE_NM}
              />
              {previewNotice.IMAGE_FILE_NM && (
                <p className={styles.previewImageName}>{previewNotice.IMAGE_FILE_NM}</p>
              )}
            </div>
          )}

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

          <footer className={styles.footer}>
            <Checkbox
              labelText={t('LBL00413', '_Do not open again today')}
              checked={previewHideToday}
              onChange={setPreviewHideToday}
            />
            {publicationPeriod && (
              <span className={styles.publicationPeriod}>{publicationPeriod}</span>
            )}
          </footer>
        </article>
      }
    />
  );
};
