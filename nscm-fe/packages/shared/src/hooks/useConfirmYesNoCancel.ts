/* @refresh reload */
import { useCallback } from 'react';

import { useMessageStore } from '@shared/stores';
import type { YesNoCancelResult } from '@shared/stores';

/**
 * G6 — YesNoCancel 3옵션 confirm hook (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS MessageHelper.GMessageBox Button 코드 '0202004' (YesNoCancel) 매핑.
 *
 * 사용 예 (AS-IS DMF0020 의 MSG00100 "저장하지 않고 바로 열겠습니까?" 동등):
 * ```typescript
 * const confirmYNC = useConfirmYesNoCancel();
 *
 * const handleExcel = async () => {
 *   const result = await confirmYNC({ content: t('MSG00100', '_저장하지 않고 바로 열겠습니까?') });
 *   if (result === 'yes')      exportExcel(true);   // 저장 + 열기
 *   else if (result === 'no')  exportExcel(false);  // 저장만
 *   // result === 'cancel' → 아무 것도 안 함
 * };
 * ```
 *
 * ✅ Phase 7 보완 A2 (2026-06-04): `Alert.tsx` 의 yesNoCancel 3-button variant 활성화 완료.
 *    (Yes / No / Cancel — resolve: 'yes' / 'no' / 'cancel' / dialog X close = 'cancel' 동등)
 */
export const useConfirmYesNoCancel = () => {
  const setConfirmYesNoCancel = useMessageStore(state => state.setConfirmYesNoCancel);

  const confirm = useCallback(
    async (options: {
      content: string;
      header?: string;
    }): Promise<YesNoCancelResult> => {
      return setConfirmYesNoCancel(options);
    },
    [setConfirmYesNoCancel]
  );

  return confirm;
};
