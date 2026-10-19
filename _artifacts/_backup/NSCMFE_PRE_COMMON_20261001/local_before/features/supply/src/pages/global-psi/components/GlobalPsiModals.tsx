import { MeasureSelectModal } from 'features/master/src/components';

import { saveTitleSet } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MEASURE_SHEET_NAME, MENU_ID, TITLESET_MEASURE_TYPE } from '../global-psi.constants';
import { useGlobalPsiStore } from '../useGlobalPsiStore';

interface Props {
  openMeasure: boolean;
  onClose: () => void;
}

// SCP0031 Measure 개인화 팝업(design 03 §6 C3 — AS-IS btnMeasure→SCM0002_TitleSetForm_Popup):
//   btnMeasure -> MeasureSelectModal + saveTitleSet('M', sheetName='Global PSI').
//   SCP0031 은 read-only 분석화면이라 메인 SP 가 titleset_user 로 measure 를 서버측 필터한다(design 03 §2.3 C3).
//   따라서 로컬 즉시적용 machinery 없이 저장 후 fetchStaticMeasures refetch + 재조회로만 반영한다
//   (자매 SCP0100 GlobalPsiReportModals 규약 동일). USER_SELECTABLE_FLAG='Y' 8 measure 대상.
export const GlobalPsiModals = ({ openMeasure, onClose }: Props) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;
  const staticMeasures = useGlobalPsiStore(s => s.staticMeasures);
  const fetchStaticMeasures = useGlobalPsiStore(s => s.fetchStaticMeasures);

  // 저장 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
  const alertSaveFailed = () => {
    void setAlert({
      type: 'alert',
      content: t('MSG00618', { defaultValue: 'An error occurred while saving.' }),
    });
  };

  return (
    <MeasureSelectModal
      open={openMeasure}
      modalClose={onClose}
      measures={staticMeasures}
      // SCP0031 store 는 visibleMeasures 상태를 두지 않는다(read-only) — null(전체 표시)로 진입, display 기본 복원.
      visibleMeasures={null}
      onApply={codes => {
        const all = staticMeasures.map(m => m.colNm);
        const selected = codes ?? all;
        void saveTitleSet({
          menuId: MENU_ID,
          sheetName: MEASURE_SHEET_NAME,
          // Measure 개인화 — 폭/색은 대상이 아니라 미전달(빈 값으로 저장됨).
          columnType: TITLESET_MEASURE_TYPE,
          rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
        }).then(ok => {
          if (!ok) {
            alertSaveFailed();
            return;
          }
          void fetchStaticMeasures();
        });
      }}
    />
  );
};
