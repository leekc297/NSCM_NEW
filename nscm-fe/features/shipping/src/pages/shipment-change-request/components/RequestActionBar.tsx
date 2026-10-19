import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL } from '../shipment-change-request.constants';

import styles from './RequestActionBar.module.scss';

interface Props {
  /** 각 버튼은 admin 버튼 권한으로 게이트한다 — 하드코딩 노출 금지(CLAUDE.md §2 체크3). */
  canRequestComplete: boolean;
  canCancel: boolean;
  onRequestComplete: () => void;
  onCancel: () => void;
}

/**
 * 요청정보 폼 우측 액션 버튼바 — AS-IS panel3 의 우측 버튼군(Designer 실측: 요청정보 좌 X=0 / 버튼 우 X=760).
 *   노출 버튼은 정확히 2개다: `btnChangeRe2`(Request Complete, R14) · `btnCancel`(Cancel, R9).
 *   `btnAdd`/`btnDel`/`btnSave`/`dtDate`/상단 `btnChangeRe` 5건은 dead UI 라 이식하지 않는다(R4).
 *   자매 SSP0200 의 RequestActionBar 와 같은 역할이나 LBL 원천이 화면별로 달라 컴포넌트를 공유하지 않는다.
 */
export const RequestActionBar = ({
  canRequestComplete,
  canCancel,
  onRequestComplete,
  onCancel,
}: Props) => {
  const { t } = useTranslation();

  return (
    <Stack direction='row' justifyContent='flex-end' spacing={1} className={styles.actionBar}>
      {canRequestComplete && (
        <Button appearance='contained' priority='primary' onClick={onRequestComplete}>
          {t(LBL.REQUEST_COMPLETE, '_Request Complete')}
        </Button>
      )}
      {canCancel && (
        <Button appearance='outlined' priority='normal' onClick={onCancel}>
          {t(LBL.CANCEL, '_Cancel')}
        </Button>
      )}
    </Stack>
  );
};
