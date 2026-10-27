import { MeasureSelectModal } from 'features/master/src/components';

import { queryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type {
  SHEETS} from '../global-psi-report.constants';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MEASURE_SHEET_NAME,
  TITLESET_COLUMN_TYPE,
  TITLESET_MEASURE_TYPE,
} from '../global-psi-report.constants';
import { useGlobalPsiReportStore } from '../useGlobalPsiReportStore';

interface Props {
  // 활성 그리드 시트 — sheetName(admin SHEET_NAME) 3점 일치 축. design 01 R1~R3 로 결정된 현재 노출 시트.
  activeSheet: SHEETS;
  divisionId: string;
  openColumn: boolean;
  openMeasure: boolean;
  onClose: () => void;
}

// SCP0100 개인화 팝업 2종 (design 02 §4.6 B3/B4 — AS-IS SCM0002_TitleSetForm_Popup):
//   btnColumn -> ColumnLayoutModal + saveTitleSet('C', sheetName=활성 SHEET_NAME 3점 일치)
//   btnMeasure -> MeasureSelectModal + saveTitleSet('M', measure sheetNm='Global PSI New')
// SCP0100 은 read-only 리포트라 메인 SP 가 titleSet 으로 measure/컬럼을 필터하지 않는다(design 03 §6).
//   따라서 SalesPlan(DMF0021)의 로컬 즉시적용(applyColumnLayout/applyVisibleMeasures) machinery 없이
//   저장 후 fetchStaticColumns/fetchStaticMeasures refetch 로만 그리드 메타를 갱신한다.
//   ColumnLayoutModal 은 menuId/sheetName/columnType/divisionId 로 자체 titleSet+컬럼메타를 조회하므로
//   fallback/initialSettings 없이 단독 동작한다(SalesPlanModals 는 로컬 반영 위해 넘길 뿐).
export const GlobalPsiReportModals = ({
  activeSheet,
  divisionId,
  openColumn,
  openMeasure,
  onClose,
}: Props) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;

  const staticMeasures = useGlobalPsiReportStore(s => s.staticMeasures);
  const staticColumns = useGlobalPsiReportStore(s => s.staticColumns);
  const fetchStaticColumns = useGlobalPsiReportStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useGlobalPsiReportStore(s => s.fetchStaticMeasures);

  // 활성 시트의 admin SHEET_NAME — 저장·조회·그리드 렌더가 반드시 같은 값을 써야 재진입 복원된다(titleSetApi 계약).
  const sheetName = ADMIN_SHEET_NAME[activeSheet];

  // 저장 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
  const alertSaveFailed = () => {
    void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
  };

  return (
    <>
      {/* Column 설정 — 공용 ColumnLayoutModal(표시/순서 + Width/Cell·Text Color) + titleSet 'C' 영구 저장 */}
      <ColumnLayoutModal
        open={openColumn}
        modalClose={onClose}
        menuId={MENU_ID}
        sheetName={sheetName}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={divisionId}
        // 저장된 개인화(titleSet)가 없으면 ColumnLayoutModal 의 beRows 가 0건이라 리스트가 빈다 —
        //   admin 컬럼메타(staticColumns)를 fallbackColumns 로 넘겨 기본 컬럼을 표시한다(형제 SalesPlanModals 동형).
        //   /column 메타는 모달 내부에선 라벨/플래그 보정용일 뿐 베이스 리스트가 아니다(2026-10-14 미표시 버그 해소).
        fallbackColumns={(staticColumns[activeSheet] ?? []).map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
          display: c.display,
          personalizable: c.personalizable,
        }))}
        title={t(LBL.COLUMN, 'Column Setting')}
        onSave={settings => {
          // 표시 컬럼만(USER_FLAG='Y') sortOrderNo 1..n 으로 저장 — 행 존재 = 표시(titleSetApi 계약).
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName,
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              alertSaveFailed();
              return;
            }
            // 팝업 titleSet 조회 캐시 무효화 — 전역 staleTime=Infinity 라 invalidate 없이는 재조회가 안 된다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
        }}
      />

      {/* Measure 선택 — titleSet 'M' 영구 저장 -> 저장 후 measure 메타 refetch 로 반영(measure='Global PSI New') */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={onClose}
        measures={staticMeasures}
        // AS-IS SCM0002 가 SMALL_CLASS_LABEL_NAME 을 세로 병합해 앞에 보여줬다 — measure 36종이
        //   Sales/Pack/Cell/AS Sales/Total PSI 소분류로 묶임(LARGE_CLASS 는 전 행 공란, DB 실측 2026-10-23).
        showSmallClass
        // SCP0100 store 는 visibleMeasures 상태를 두지 않는다(read-only) — null(전체 표시)로 진입, display 기본 복원.
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
    </>
  );
};
