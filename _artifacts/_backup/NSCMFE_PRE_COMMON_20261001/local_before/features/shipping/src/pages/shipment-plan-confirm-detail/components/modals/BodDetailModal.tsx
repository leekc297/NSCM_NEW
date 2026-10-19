import { CustomDialog } from '@shared/components';

import styles from './DrilldownModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId?: string;
  bodId?: string;
}

// AS-IS SCM0002_ShipmentPlanConfirmBODPopup 대체 — INCOTERMS 셀 클릭 드릴다운(design 03 W9).
//   파라미터: DIVISION_ID(EE 분기면 ORIGIN_FROM_DIVISION_ID) + BOD_ID.
//   주의: BOD 상세 팝업의 데이터 원천 SP 는 이 화면(PKG_SSP0012) 소관이 아니라 별도 팝업 전환+SP 배포 대상이다.
//   여기서는 AS-IS 트리거·가드·파라미터 추출(W9/G1/G2)까지 구현하고, 상세 그리드 데이터는 convert-sp 후속으로 유예한다.
//   i18n(Hook#114): 'BOD Detail' 문구를 담은 SCM_ADM_MSG_M 코드가 없어(LBL01047 은 'Receiver Setup') AS-IS 번호 답습 대신
//   화면 스코프 키(_ssp0012.*)+defaultValue 를 쓴다 — 플레이스홀더 모달이라 message-master 신규 등록은 실 팝업 전환(convert-sp) 때로 유예.
export const BodDetailModal = ({ open, modalClose, divisionId, bodId }: Props) => {
  const { t } = useTranslation();
  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={520}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      title={t('_ssp0012.bodDetailTitle', { defaultValue: 'BOD Detail' })}
      customContentArea={
        <div className={styles.container}>
          <dl className={styles.params}>
            <dt>{t('LBL00641', { defaultValue: 'Division' })}</dt>
            <dd>{divisionId || '-'}</dd>
            <dt>BOD ID</dt>
            <dd>{bodId || '-'}</dd>
          </dl>
          <p className={styles.note}>
            {t('_ssp0012.bodDetailPending', {
              defaultValue: 'BOD detail data is pending SP deployment (convert-sp).',
            })}
          </p>
        </div>
      }
    />
  );
};
