import { useMessageStore } from '@shared/stores';

import { MSG } from '../scp-bom.constants';
import type { SearchCondition } from '../scp-bom.types';

// SCP0053 조회 사전검증 (design 02 §5/§6 · 01 §2.6):
//   V1(MSG01329): Alter BOM 미체크일 때만 Model/Parent/Child 3텍스트 전부 공백이면 차단(cs:253~261).
//                 Alter BOM 체크 시 무입력 조회 허용.
//   V2~V4(MSG01330/1331/1332 — 타입검증): AS-IS 인라인 SQL 이나 TO-BE 체크 프로시저 미배포(goal.md ④).
//                 실행 수단 없음 → 이번 회차 미배선(명세 이탈 기록, __asis-mapping__ / 04_react-gap).
export const useScpBomValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const validateSearch = (sc: SearchCondition): boolean => {
    if (!sc.alterBom) {
      const allEmpty =
        sc.modelId.trim() === '' && sc.parentId.trim() === '' && sc.childId.trim() === '';
      if (allEmpty) {
        void setAlert({
          type: 'alert',
          content: t(
            MSG.REQUIRE_ONE_ITEM,
            '_Plese input at least one of Model ID, Parent ID, Child ID'
          ),
        });
        return false;
      }
    }
    return true;
  };

  return { validateSearch };
};
