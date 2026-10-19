import { useMessageStore } from '@shared/stores';

import { MSG } from '../scp-bom-elec.constants';
import type { SearchCondition } from '../scp-bom-elec.types';

// SCP0097 조회 사전검증 (design 02 §4/§6 · 01 §2.6 R1):
//   AS-IS checkRequiredOfSearch — 라벨 '*' 필수(Division*) 빈값이면 조회 차단 + 포커스(MSG00002 의도).
//   TO-BE 는 등가 코드 MSG00097("Please select Division.")로 재현(동번호 MSG00002='Saved successfully.' 재사용 금지, #114).
//   Parent/Child 는 필수 아님(라벨 '*' 없음). 권한 0건(R6a) 게이트는 페이지 divisionAuth 축에서 별도 처리.
export const useScpBomElecValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const validateSearch = (sc: SearchCondition): boolean => {
    if (sc.divisionId.trim() === '') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return false;
    }
    return true;
  };

  return { validateSearch };
};
