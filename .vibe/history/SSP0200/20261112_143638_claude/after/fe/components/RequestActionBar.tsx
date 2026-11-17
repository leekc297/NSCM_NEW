import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { LBL } from '../shipment-change-request-plan.constants';

import styles from './RequestActionBar.module.scss';

interface Props {
  /** 각 버튼은 admin 버튼 권한으로 게이트한다 — 하드코딩 노출 금지(V-22). */
  canRequestComplete: boolean;
  canCancel: boolean;
  onRequestComplete: () => void;
  onCancel: () => void;
}

/**
 * 하단 액션 버튼바 (design 01 §1.3 / V-03) — **노출 버튼은 정확히 2개다**.
 *   `Save Draft`(btnSave) · `Delete`(btnDel) · `Add Date`(btnAdd) · 날짜입력(dtDate) 4건은
 *   Designer `Visibility=Never`(+ 일부는 `Visible=false`) 인 2축 dead 라 이식하지 않는다(Δ4).
 *   되살릴 유일한 경로 `SetButtonVisual(bool)` 도 호출 0건(F4)이다.
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
