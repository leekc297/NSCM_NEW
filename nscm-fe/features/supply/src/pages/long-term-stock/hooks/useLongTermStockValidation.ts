import { useMessageStore } from '@shared/stores';

import { LBL } from '../long-term-stock.constants';
import type { SearchParams } from '../long-term-stock.types';

// 조회 필수값 가드 — AS-IS Find_Data 진입 시 DataUtil.checkRequiredOfSearch(cs:285) 재현.
//   Month 는 범위 SP 로 기본 세팅되어 통상 값이 있으나, 비어 있으면 조회를 차단한다.
//   (Division/Plant/Long Term Type 은 미선택=전체 허용이라 필수 아님 — design 02 §4.)
export const useLongTermStockValidation = () => {
  const setAlert = useMessageStore(state => state.setAlert);
  const { t } = useTranslation();

  const validateFind = (sc: SearchParams): boolean => {
    if (!sc.month) {
      // Month 는 monthPicker 기본값(최신월)이 항상 있어 통상 도달하지 않는 방어 가드.
      //   MSG00013 = TO-BE 등록된 필수입력 안내('필수 입력 항목입니다.') — DB 실측(SCM_ADM_MSG_M).
      void setAlert({
        type: 'alert',
        content: `${t(LBL.MONTH, 'Month')}: ${t('MSG00013', '_필수 입력 항목입니다.')}`,
      });
      return false;
    }
    return true;
  };

  return { validateFind };
};
