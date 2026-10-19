import commonStyles from '@foundation/styles/common-styles.module.scss';
import { Button, FormItem, InputField } from '@shared/lges';
import { Stack } from '@shared/mui';

import styles from './PlanManagementGrid.module.scss';

interface Props {
  /** 선택 행의 Revision No 표시(AS-IS txtRevision ReadOnly — FindData_Engin L915 등가) */
  revisionNo: string;
  /** btnStop enable — 선택 행 PLAN_STATUS='0'(실행중)일 때만(design 01 §2 행3~4) */
  stopEnabled: boolean;
  /** Division 권한 0건 — 툴바 전체 disabled, 알림 없음(SearchArea 와 알림 정책이 다름, design 01 §2 행1) */
  disabled: boolean;
  onStop: () => void;
}

// AS-IS usrLayoutControl3(splitContainer2.Panel1) — Revision 표시 + Stop 버튼 툴바(design 01 §1).
//   Stop 그룹 권한 게이트는 사용자 확정(2026-09-24)대로 미반영 — AS-IS 그대로 행 선택 기반 enable 만.
export const EngineToolbar = ({ revisionNo, stopEnabled, disabled, onStop }: Props) => {
  const { t } = useTranslation();

  return (
    <Stack direction='row' spacing={2} alignItems='center' className={styles.engineToolbar}>
      <FormItem
        className={commonStyles.formItem}
        label={t('LBL01110', '_Revision')}
        labelAlign='right'
        render={() => <InputField fullWidth value={revisionNo} InputProps={{ readOnly: true }} />}
      />
      {/* Stop 전용 LBL 미탐(SCM_ADM_MSG_M 역조회 0건) — 영문 라벨 유지, 임의 코드 신설 금지(convert-core §2.3) */}
      <Button appearance='outlined' priority='normal' disabled={disabled || !stopEnabled} onClick={onStop}>
        Stop
      </Button>
    </Stack>
  );
};
