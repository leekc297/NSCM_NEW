import { CustomDialog } from '@shared/components';

import styles from './ShipmentPlanRequestModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  requestNo?: string;
}

// AS-IS SCM0002_ShipmentPlanRequestPopup 대체 — REQUEST_NO(CHANGE_REQ_NO) 이미지셀 드릴다운(design 03 §3-4 / 00 §4d,§4e #1).
//   파라미터: sRequestNo(공백 아닐 때만 오픈, 가드 2건은 그리드가 처리). AS-IS 트리거·가드·파라미터 추출까지 구현하고,
//   상세 데이터는 별도 팝업 전환+SP 배포(SCM0002) 대상이라 convert-sp 후속으로 유예한다(자매 SSP0012 ShipmentRequestDetailModal 동형).
//   i18n(Hook#114): 요청 상세 문구 코드가 SCM_ADM_MSG_M 에 없어 화면 스코프 키(_ssp0019.*)+defaultValue 사용 — 실 팝업 전환(convert-sp) 유예.
export const ShipmentPlanRequestModal = ({ open, modalClose, requestNo }: Props) => {
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
      title={t('_ssp0019.requestDetailTitle', { defaultValue: 'Shipment Plan Request Detail' })}
      customContentArea={
        <div className={styles.container}>
          <dl className={styles.params}>
            <dt>{t('_ssp0019.requestNoLabel', { defaultValue: 'Request No' })}</dt>
            <dd>{requestNo || '-'}</dd>
          </dl>
          <p className={styles.note}>
            {t('_ssp0019.requestDetailPending', {
              defaultValue: 'Shipment plan request detail data is pending SP deployment (convert-sp).',
            })}
          </p>
        </div>
      }
    />
  );
};
