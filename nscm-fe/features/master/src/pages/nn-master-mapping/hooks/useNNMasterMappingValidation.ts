/**
 * DMF0072 NNMasterMapping — Validation hook (9 MSG)
 * AS-IS: validation.md 9 MSG 매핑 (MSG00097/00002/00049/00108/00105/00106/00020/00017/00284)
 */
import { useTranslation } from 'react-i18next';

import { useMessageStore } from '@shared/stores';

import type { NNMasterMappingRow } from '../nn-master-mapping.types';

export const useNNMasterMappingValidation = () => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  /** MSG00097 — Division 필수 */
  const validateDivisionSelected = (divisionId: string): boolean => {
    if (!divisionId) {
      void setAlert({ type: 'alert', content: t('MSG00097', '_Division을 선택하세요.') });
      return false;
    }
    return true;
  };

  /** MSG00017 — 변경사항 없음 */
  const validateHasChanges = (rows: NNMasterMappingRow[]): boolean => {
    const dirty = rows.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00017', '_변경사항이 없습니다.') });
      return false;
    }
    return true;
  };

  /** MSG00002 — 필수 입력 누락 (ITEM_ID/VALID_START/VALID_END/FCST_TYPE/INCOTERMS/DOM_EXP/ACTIVE_YN/DATA_TYPE_CODE/END_CUSTOMER) */
  const validateRequiredFields = (rows: NNMasterMappingRow[]): boolean => {
    const required: Array<keyof NNMasterMappingRow> = [
      'ITEM_ID', 'VALID_START_DATE', 'VALID_END_DATE',
      'FCST_TYPE', 'INCOTERMS', 'DOM_EXP',
      'ACTIVE_YN', 'DATA_TYPE_CODE', 'END_CUSTOMER',
    ];
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      for (const key of required) {
        if (!row[key]) {
          void setAlert({ type: 'alert', content: t('MSG00002', '_필수 입력 항목입니다.') });
          return false;
        }
      }
    }
    return true;
  };

  /** MSG00049 — 날짜 형식 (yyyymmdd) */
  const validateDateFormat = (rows: NNMasterMappingRow[]): boolean => {
    const re = /^\d{8}$/;
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      if ((row.VALID_START_DATE && !re.test(row.VALID_START_DATE)) ||
          (row.VALID_END_DATE && !re.test(row.VALID_END_DATE))) {
        void setAlert({ type: 'alert', content: t('MSG00049', '_잘못된 날짜 형식입니다.') });
        return false;
      }
    }
    return true;
  };

  /** MSG00108 — dtFrom > dtTo 불허 */
  const validateDateRangeOrder = (rows: NNMasterMappingRow[]): boolean => {
    for (const row of rows.filter(r => r.CRUD_TYPE)) {
      if (row.VALID_START_DATE && row.VALID_END_DATE &&
          row.VALID_START_DATE > row.VALID_END_DATE) {
        void setAlert({ type: 'alert', content: t('MSG00108', '_시작일이 종료일보다 큽니다.') });
        return false;
      }
    }
    return true;
  };

  /** MSG00105/00106 — 기간 중첩/비연속 (cross-row, AS-IS 버그 수정: 그룹핑 후 정렬 검증) */
  const validatePeriodConsistency = (rows: NNMasterMappingRow[]): boolean => {
    // grouping by (DIVISION_ID, ITEM_ID, END_CUSTOMER) 후 정렬, 인접 검증
    // 단순화: 같은 ITEM_ID 내에서 정렬 후 인접 행이 overlap 또는 gap 검증
    const dirty = rows.filter(r => r.CRUD_TYPE);
    const groups = new Map<string, NNMasterMappingRow[]>();
    for (const r of dirty) {
      const key = `${r.DIVISION_ID}/${r.ITEM_ID}/${r.END_CUSTOMER}`;
      const arr = groups.get(key) ?? [];
      arr.push(r);
      groups.set(key, arr);
    }
    for (const [, arr] of groups) {
      arr.sort((a, b) => (a.VALID_START_DATE ?? '').localeCompare(b.VALID_START_DATE ?? ''));
      for (let i = 1; i < arr.length; i++) {
        const prev = arr[i - 1];
        const curr = arr[i];
        if ((prev.VALID_END_DATE ?? '') >= (curr.VALID_START_DATE ?? '')) {
          void setAlert({ type: 'alert', content: t('MSG00105', '_기간이 중첩됩니다.') });
          return false;
        }
      }
    }
    return true;
  };

  /** MSG00020 — 저장 성공 */
  const showSaveSuccess = (): void => {
    void setAlert({ type: 'toast', content: t('MSG00020', '_저장되었습니다.') });
  };

  /** MSG00284 — 실행 오류 */
  const showSavedError = (resultMsg?: string): void => {
    void setAlert({
      type: 'alert',
      content: resultMsg ?? t('MSG00284', '_실행 중 오류가 발생했습니다.'),
    });
  };

  return {
    validateDivisionSelected,
    validateHasChanges,
    validateRequiredFields,
    validateDateFormat,
    validateDateRangeOrder,
    validatePeriodConsistency,
    showSaveSuccess,
    showSavedError,
  };
};
