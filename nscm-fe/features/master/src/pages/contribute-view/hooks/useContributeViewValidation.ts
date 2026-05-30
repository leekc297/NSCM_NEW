/**
 * DMF0043_01 Contribute_View — Validation hook (2건)
 * AS-IS: __asis-mapping__.md §3 — MSG00283 / MSG00307
 */
import { useTranslation } from 'react-i18next';

import { useMessageStore } from '@shared/stores';

export const useContributeViewValidation = () => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  /** AS-IS .cs:287 FindData — Version 필수 (MSG00283) */
  const validateVersionSelected = (versionId: string): boolean => {
    if (!versionId) {
      void setAlert({
        type: 'alert',
        content: t('MSG00283', '_Version을 선택하고 조회하세요.'),
      });
      return false;
    }
    return true;
  };

  /** AS-IS .cs:335 FindData — 조회 결과 미등록 안내 (MSG00307) */
  const validateSearchResultEmpty = (count: number): boolean => {
    if (count === 0) {
      void setAlert({
        type: 'alert',
        content: t('MSG00307', '_조회 결과가 없습니다.'),
      });
      return false;
    }
    return true;
  };

  return {
    validateVersionSelected,
    validateSearchResultEmpty,
  };
};
