import { CustomDialog } from '@shared/components';

import styles from './PlanGroupInfoModal.module.scss';

interface PlanGroupInfoModalProps {
  open: boolean;
  division: string;
  divisionText: string;
  modalClose: () => void;
  // OK(등록 반영) 시 호출 — 부모가 GET_SEARCH_INFO 재조회 + PlanGroup 콤보/셀콤보 invalidate (R3, 02 §4.6).
  onRegistered: () => void;
}

/**
 * Plan Group 등록 팝업 (btnPlanGroupReg → AS-IS SCP0121_PlanGroupInfoPopup).
 *
 * 주의(스코프): 이 메인 화면(convert-react SCP0121 v3) 의 책임은 **버튼(영역1) + open state + OK 콜백
 *   invalidate 배선**까지다. 팝업 내부의 Plan Group 등록/편집 그리드는 **자매 화면(SCP0121_PlanGroupInfoPopup)
 *   전환 범위**(goal.md ① 잔재/스코프 경계, ⑤-6 확인필요 #8) 로, 여기서는 셸만 둔다. 등록 그리드 본문은
 *   자매 팝업 전환 후속 작업에서 채운다 — 이 셸을 "완성된 등록 UI" 로 오인하지 말 것(정직 보고, convert-core §4.3).
 */
export const PlanGroupInfoModal = ({
  open,
  division,
  divisionText,
  modalClose,
  onRegistered,
}: PlanGroupInfoModalProps) => {
  const { t } = useTranslation();

  return (
    <CustomDialog
      open={open}
      title={t('LBL00002', '_Plan Group')}
      handleClose={modalClose}
      handleSubmit={() => {
        onRegistered();
        modalClose();
      }}
      maxWidth='sm'
      fullWidth
    >
      <div className={styles.placeholder}>
        <p>{t('LBL00641', '_Division')}: {divisionText || division}</p>
        <p>
          {t(
            '_SCP0121_PLAN_GROUP_REG_PENDING',
            '_Plan Group registration popup is converted as a separate screen (SCP0121_PlanGroupInfoPopup).'
          )}
        </p>
      </div>
    </CustomDialog>
  );
};
