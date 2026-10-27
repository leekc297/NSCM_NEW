import { CustomDialog } from '@shared/components';

import styles from './DrilldownModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  changeReqNo?: string;
}

// AS-IS SCM0002_ShipmentPlanRequestPopup 대체 — CHANGE_REQ_NO 셀 클릭 드릴다운(design 03 W10, G3).
//   파라미터: CHANGE_REQ_NO(공백 아닐 때만 오픈, G3 가드는 그리드가 처리).
//   주의: 변경요청 상세 팝업의 데이터 원천 SP 는 이 화면(PKG_SSP0012) 소관이 아니라 별도 팝업 전환+SP 배포 대상이다.
//   여기서는 AS-IS 트리거·가드·파라미터 추출(W10/G3)까지 구현하고, 상세 데이터는 convert-sp 후속으로 유예한다.
//   i18n(Hook#114): 'Change Request Detail'/'Change Request No' 문구 코드가 SCM_ADM_MSG_M 에 없어(LBL01048='SMS Content *',
//   LBL01108='Requestor') AS-IS 번호 답습 대신 화면 스코프 키(_ssp0012.*)+defaultValue 사용 — message-master 신규 등록은 실 팝업 전환(convert-sp) 유예.
export const ShipmentRequestDetailModal = ({ open, modalClose, changeReqNo }: Props) => {
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
      title={t('_ssp0012.requestDetailTitle', { defaultValue: 'Change Request Detail' })}
      customContentArea={
        <div className={styles.container}>
          <dl className={styles.params}>
            <dt>{t('_ssp0012.changeReqNoLabel', { defaultValue: 'Change Request No' })}</dt>
            <dd>{changeReqNo || '-'}</dd>
          </dl>
          <p className={styles.note}>
            {t('_ssp0012.requestDetailPending', {
              defaultValue: 'Change request detail data is pending SP deployment (convert-sp).',
            })}
          </p>
        </div>
      }
    />
  );
};
