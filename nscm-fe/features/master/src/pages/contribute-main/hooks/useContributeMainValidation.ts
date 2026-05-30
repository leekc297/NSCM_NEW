/**
 * DMF0043 Contribute_Main — Validation hook (4건)
 * AS-IS: __asis-mapping__.md §3 — MSG00303 / MSG00308 / MSG00004 / MSG00266
 */
import { useTranslation } from 'react-i18next';

import { useMessageStore } from '@shared/stores';

import type { ContributeMainRow } from '../contribute-main.types';

export const useContributeMainValidation = () => {
  const { t } = useTranslation();
  const { setAlert, setConfirm } = useMessageStore();

  /** AS-IS .cs:306 ValidChk — 입력 데이터 100 초과/미만 검증 (MSG00303) */
  const validateRatioSum = (rows: ContributeMainRow[]): boolean => {
    const dirty = rows.filter(r => r.CRUD_TYPE);
    for (const row of dirty) {
      const sum =
        (row.PREV_YEAR_SUM ?? 0) + (row.CURR_YEAR_SUM ?? 0) + (row.NEXT_YEAR_SUM ?? 0);
      if (Math.abs(sum - 100) > 0.001) {
        void setAlert({
          type: 'alert',
          content: t('MSG00303', '_입력한 데이터가 100을 초과하거나 미만입니다.'),
        });
        return false;
      }
    }
    return true;
  };

  /** AS-IS .cs:313 ValidChk2 — 구분값 필수 (MSG00308) */
  const validateDivisionValueSet = (rows: ContributeMainRow[]): boolean => {
    const dirty = rows.filter(r => r.CRUD_TYPE);
    for (const row of dirty) {
      if (!row.DIVISION_ID || !row.CUSTOMER_GROUP || !row.PRODUCT_TYPE) {
        void setAlert({
          type: 'alert',
          content: t('MSG00308', '_구분값을 입력해 주세요.'),
        });
        return false;
      }
    }
    return true;
  };

  /** AS-IS .cs:421 confirm Save (MSG00004) */
  const confirmSaveData = (onConfirm: () => void): void => {
    void setConfirm({
      content: t('MSG00004', '_저장하시겠습니까?'),
      onConfirm,
    });
  };

  /** AS-IS .cs:665 chkYear_CheckedChanged — Sheet Lock 상태 (MSG00266) */
  const validateChkYearLockState = (isLocked: boolean): boolean => {
    if (!isLocked) {
      void setAlert({
        type: 'alert',
        content: t('MSG00266', '_수정 모드가 아닙니다.'),
      });
      return false;
    }
    return true;
  };

  return {
    validateRatioSum,
    validateDivisionValueSet,
    confirmSaveData,
    validateChkYearLockState,
  };
};
