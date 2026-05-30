/**
 * DMF0008 ErpEdiMaster — Validation hook
 * AS-IS: validation.md 40건 (31 클라이언트 + 9 SP side)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0008_ErpEdiMaster/__asis-mapping__.md §3
 *
 * 본 hook 은 Step B (2026-05-29 보완) 의 핵심 산출물. 기존 5 components 는 보존.
 * 사용처: ErpEdiMaster.tsx 의 handleSave 진입 시 호출 (SalesSite / SSPM 별 분기).
 */
import { useTranslation } from 'react-i18next';

import { useMessageStore } from '@shared/stores';

interface SalesSiteRow {
  CRUD_TYPE?: string;
  SCM_SITE_ID?: string;
  REP_SOLDTO_CODE?: string;
  REP_SHIPTO_CODE?: string;
  SITE_VALID_YN?: string;
  CUSTOMER_VALID_YN?: string;
  [key: string]: unknown;
}

interface SspmRow {
  CRUD_TYPE?: string;
  ITEM_ID?: string;
  SOLDTO_CODE?: string;
  SHIPTO_CODE?: string;
  ACTIVE_YN?: string;
  [key: string]: unknown;
}

export const useErpEdiMasterValidation = () => {
  const { t } = useTranslation();
  const { setAlert, setConfirm } = useMessageStore();

  /** AS-IS SaveSalesSite — 5 필수값 검증 (MSG00002) */
  const validateSalesSiteRequired = (rows: SalesSiteRow[]): boolean => {
    const required: Array<keyof SalesSiteRow> = [
      'SCM_SITE_ID',
      'REP_SOLDTO_CODE',
      'REP_SHIPTO_CODE',
      'SITE_VALID_YN',
      'CUSTOMER_VALID_YN',
    ];
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      for (const key of required) {
        if (!row[key]) {
          void setAlert({
            type: 'alert',
            content: t('MSG00002', '_필수 입력 항목입니다.') + ` (${String(key)})`,
          });
          return false;
        }
      }
    }
    return true;
  };

  /** AS-IS SaveSSPM — 필수값 (MSG00002) */
  const validateSspmRequired = (rows: SspmRow[]): boolean => {
    const required: Array<keyof SspmRow> = [
      'ITEM_ID',
      'SOLDTO_CODE',
      'SHIPTO_CODE',
      'ACTIVE_YN',
    ];
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      for (const key of required) {
        if (!row[key]) {
          void setAlert({
            type: 'alert',
            content: t('MSG00002', '_필수 입력 항목입니다.') + ` (${String(key)})`,
          });
          return false;
        }
      }
    }
    return true;
  };

  /** AS-IS MSG00060 — PK 중복 검증 (행간 검사) */
  const validateDuplicateKey = (
    rows: Array<Record<string, unknown>>,
    pkColumns: string[]
  ): boolean => {
    const seen = new Set<string>();
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      const key = pkColumns.map(c => String(row[c] ?? '')).join('/');
      if (seen.has(key)) {
        void setAlert({
          type: 'alert',
          content: t('MSG00060', '_데이터가 중복됩니다.') + ` (${key})`,
        });
        return false;
      }
      seen.add(key);
    }
    return true;
  };

  /** AS-IS MSG00130 — ACTIVE 행 1건 초과 금지 (특정 키 단위) */
  const validateActiveUniqueness = (
    rows: Array<Record<string, unknown>>,
    groupColumns: string[],
    activeColumn: string = 'ACTIVE_YN'
  ): boolean => {
    const counts = new Map<string, number>();
    for (const row of rows) {
      if (row[activeColumn] !== 'Y') continue;
      const key = groupColumns.map(c => String(row[c] ?? '')).join('/');
      counts.set(key, (counts.get(key) ?? 0) + 1);
    }
    for (const [key, count] of counts) {
      if (count > 1) {
        void setAlert({
          type: 'alert',
          content: t('MSG00130', '_ACTIVE 행이 1건을 초과합니다.') + ` (${key})`,
        });
        return false;
      }
    }
    return true;
  };

  /** AS-IS MSG00164 — Period 범위 오류 (Period 검색 추가 시) */
  const validatePeriodRange = (from?: string, to?: string): boolean => {
    if (!from || !to) return true;
    if (from > to) {
      void setAlert({
        type: 'alert',
        content: t('MSG00164', '_시작일이 종료일보다 클 수 없습니다.'),
      });
      return false;
    }
    return true;
  };

  /** AS-IS MSG00004 — 저장 확인 */
  const confirmSaveData = (onConfirm: () => void): void => {
    void setConfirm({
      content: t('MSG00004', '_저장하시겠습니까?'),
      onConfirm,
    });
  };

  /** AS-IS MSG00284 — 실행 오류 */
  const showSavedError = (resultMsg?: string): void => {
    void setAlert({
      type: 'alert',
      content: resultMsg ?? t('MSG00284', '_실행 중 오류가 발생했습니다.'),
    });
  };

  return {
    validateSalesSiteRequired,
    validateSspmRequired,
    validateDuplicateKey,
    validateActiveUniqueness,
    validatePeriodRange,
    confirmSaveData,
    showSavedError,
  };
};
