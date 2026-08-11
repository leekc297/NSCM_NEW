import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { useMessageStore } from '@shared/stores';

const checkMandatoryColumns = <T>(saveData: T[], staticColumns: RawFlexGridColumnConfig[]) => {
  const mandatoryColumns = staticColumns.filter(
    col =>
      col.inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY ||
      col.inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY
  );

  if (mandatoryColumns.length <= 0) return true;

  const isValid = !saveData.some(row =>
    mandatoryColumns.some(
      col =>
        (row as WijmoRowItem)[col.colNm] === '' ||
        (row as WijmoRowItem)[col.colNm] === null ||
        (row as WijmoRowItem)[col.colNm] === undefined
    )
  );

  return isValid;
};

export const useSaveWithValidation = () => {
  const setAlert = useMessageStore(state => state.setAlert);
  const { t } = useTranslation();

  const saveWithValidation = <T>(
    saveData: T[] | undefined,
    staticColumns: RawFlexGridColumnConfig[],
    mutate: (data: T[]) => void
  ) => {
    if (saveData && checkMandatoryColumns(saveData, staticColumns)) {
      mutate(saveData);
    } else {
      void setAlert({
        type: 'alert',
        content: t('MSG00013', '_필수값을 입력하세요.'),
      });
    }
  };

  return { saveWithValidation };
};
