import { useMessageStore } from '@shared/stores';

import { VALIDATION_MSG } from '../contribute-view.constants';
import type { SalesViewRow } from '../types';

// AS-IS DMF0043_Contribute_View.cs Validation 2 건 1:1 매핑 (룰 24 §3)
//   - MSG00283 (.cs L285~289): if (txtVersion.Text == "") → 차단
//   - MSG00307 (.cs L333~336): if (strCnt != "0") → 알림
//
// 룰 14: window.alert/confirm 절대 금지 — useMessageStore.setAlert 만 사용
export const useContributeViewValidation = () => {
  const setAlert = useMessageStore(s => s.setAlert);

  // AS-IS .cs L285~289 — FindData() 진입 시 Version 미선택 차단
  const validateVersionSelected = async (versionNo: string): Promise<boolean> => {
    if (!versionNo || versionNo.trim() === '') {
      await setAlert({
        type: 'alert',
        content: `[${VALIDATION_MSG.VERSION_REQUIRED}] Version 을 선택하고 조회하세요.`,
      });
      return false;
    }
    return true;
  };

  // AS-IS .cs L333~336 — FindData() 결과 처리
  //   strCnt != "0" 인 경우 MSG00307 노출 (As-IS 는 "0이 아닐 때" 알림 — count 가 너무 큼/예외 case)
  //   AS-IS i18n message catalog 상 MSG00307 = "조회 결과가 없습니다" 의미.
  //   To-Be 는 rows.length === 0 일 때 noResult toast 노출로 통일 (룰 14).
  const validateSearchResultEmpty = async (rows: SalesViewRow[]): Promise<boolean> => {
    if (rows.length === 0) {
      await setAlert({
        type: 'alert',
        content: `[${VALIDATION_MSG.NO_RESULT}] 조회 결과가 없습니다.`,
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
