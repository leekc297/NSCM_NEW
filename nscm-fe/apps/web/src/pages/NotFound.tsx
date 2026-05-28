import { useNavigate } from 'react-router-dom';

import styles from './NotFound.module.scss';

export const NotFoundPage = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();

  const handleGoBack = () => {
    navigate(-1);
  };

  return (
    <div className={styles.notFoundWrapper}>
      <div className={styles.notFoundIllustration} />
      <div className={styles.notFoundMainText}>{t('MSG00017', '_Page Not Found')}</div>
      <div className={styles.notFoundSubText}>
        {t('MSG00016', '_Unfortunately, the requested page could not be found.')}
      </div>
      <button className={styles.goBackButton} onClick={handleGoBack}>
        {t('MSG00015', '_Go Back')}
      </button>
    </div>
  );
};
