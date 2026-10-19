import {
  ItemByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import { useQueryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_MEASURE_TYPE,
} from '../business-plan.constants';
import type { BusinessPlanRow } from '../business-plan.types';
import { useBusinessPlanStore } from '../useBusinessPlanStore';
import { buildCellPopupSearch, isDiv40 } from '../utils/business-plan.division';

import { ExchangeRateModal, ReplaceByCutoffModal, VersionCutoffModal } from './modals';

export type BusinessPlanModalKey =
  | 'PROJECT'
  | 'ITEM'
  | 'COLUMN'
  | 'MEASURE'
  | 'EXCHANGE'
  | 'CUTOFF'
  | 'REPLACE';

interface BusinessPlanModalsProps {
  divisionId: string;
  period: { start: string; end: string };
  replaceRange: { from: string; to: string };
  openProject: boolean;
  openItem: boolean;
  openColumnSetting: boolean;
  openMeasureSelect: boolean;
  openExchangeRate: boolean;
  openCutoff: boolean;
  openReplace: boolean;
  // 셀 모달을 연 그 행 — Model/Project 팝업의 사전 검색조건 원천 (Team/End Customer/Sales Site/Project).
  popupRow: BusinessPlanRow | null;
  onClose: (key: BusinessPlanModalKey) => void;
  // Exchange/Cutoff/Replace 완료 후 메인 재조회 (AS-IS FindData 재조회 1:1)
  onRefetch: () => void;
  // 셀 모달 적용 — 부모가 INSERT_GROUP_ID 매칭 Measure 블록 전 행에 patch 반영
  applyToInsertBlock: (patch: Record<string, unknown>) => void;
  // Column 설정 저장 = Grid 초기화 의무 — 부모(BusinessPlan.tsx)가 insertedRows/EditTracker/
  //   조회 게이트/캐시 reset 수행. 표시 컬럼이 바뀌는 순간 이전 조건으로 조회해 둔 rows 를
  //   그대로 두면 화면 구성과 데이터가 어긋난다 (AS-IS btnColumn OK → InitSpread).
  onSettingChanged: () => void;
}

// ⭐ DMF0042 모달 7종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무 진입≤400):
//   ① PROJECT 셀 모달 (81·82 신규행 — AS-IS L1699~1797: Project/Name/BizType 세팅)
//   ② ITEM 셀 모달 (전 division 신규행 — L1640~1698: Item/ItemName 세팅)
//   ③ Column 설정 (공용 ColumnSettingModal + titleSet 'C' — AS-IS btnColumn L2807 → InitSpread)
//   ④ Measure 선택 (MeasureSelectModal + titleSet 'M' — AS-IS btnMeasure L2819)
//   ⑤ Exchange Rate (전용 — AS-IS DMF0042_ExchangeRatePopup 677줄. 카테고리 'BP' + '^' bulk 저장)
//   ⑥ Ver. Cutoff (전용 — AS-IS VersionCutOffPopUp 610줄. 'BP_M' 고정, ADMIN 게이트는 부모 hasButton)
//   ⑦ Replace by Cutoff (전용 — AS-IS ReplaceByCutOffPopUp 562줄. 선택 M_ 범위 from/to)
export const BusinessPlanModals = ({
  divisionId,
  period,
  replaceRange,
  openProject,
  openItem,
  openColumnSetting,
  openMeasureSelect,
  openExchangeRate,
  openCutoff,
  openReplace,
  popupRow,
  onClose,
  onRefetch,
  applyToInsertBlock,
  onSettingChanged,
}: BusinessPlanModalsProps) => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();

  const setAlert = useMessageStore.getState().setAlert;

  const staticColumns = useBusinessPlanStore(s => s.staticColumns);
  const originalStaticColumns = useBusinessPlanStore(s => s.originalStaticColumns);
  const staticMeasures = useBusinessPlanStore(s => s.staticMeasures);
  const visibleMeasures = useBusinessPlanStore(s => s.visibleMeasures);
  const fetchStaticColumns = useBusinessPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useBusinessPlanStore(s => s.fetchStaticMeasures);
  const applyColumnLayout = useBusinessPlanStore(s => s.applyColumnLayout);
  const applyVisibleMeasures = useBusinessPlanStore(s => s.applyVisibleMeasures);

  // ColumnLayoutModal 재진입 복원(개인화 반영본) / Default 원복(admin 메타 원본).
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns),
    [staticColumns]
  );
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns),
    [originalStaticColumns]
  );

  // 저장 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
  const alertSaveFailed = () => {
    void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
  };

  const div40 = isDiv40(divisionId);

  // 셀 팝업 사전 검색조건 — 더블클릭한 그 행의 Team/End Customer/Sales Site/Project 를 그대로 올린다.
  //   행이 없을 때(팝업 닫힘 상태)는 전량 'ALL' — 팝업은 open 시점 값만 읽으므로 표시에 영향 없다.
  const itemSearch = useMemo(
    () => buildCellPopupSearch(popupRow ?? {}, divisionId, 'ITEM'),
    [popupRow, divisionId]
  );
  const projectSearch = useMemo(
    () => buildCellPopupSearch(popupRow ?? {}, divisionId, 'PROJECT'),
    [popupRow, divisionId]
  );

  return (
    <>
      {/* 셀 모달 — PROJECT (81·82 신규행. division별 키 컬럼 분기 — AS-IS L1738~1796) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => onClose('PROJECT')}
        setSelectedValue={(projectCode, projectName) => {
          applyToInsertBlock(
            div40
              ? { PROJECT_CODE: projectCode, PROJECT_NAME: projectName ?? '' }
              : divisionId === '82'
                ? {
                    PROJECT_CODE82: projectCode,
                    PROJECT_NAME: projectName ?? '',
                    ITEM_ID: '',
                    ITEM_CLASS_NAME: '',
                  }
                : {
                    PROJECT_CODE: projectCode,
                    PROJECT_NAME: projectName ?? '',
                    ITEM_ID: '',
                    ITEM_CLASS_NAME: '',
                  }
          );
        }}
        preSearchParams={projectSearch as never}
        callFromCell={true}
      />

      {/* 셀 모달 — ITEM (신규행. 40=ITEM_ID40 / 81·82=ITEM_ID — AS-IS L1687~1697) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => onClose('ITEM')}
        setSelectedValue={(
          itemId: string,
          itemName?: string,
          _itemType?: string,
          nickName?: string
        ) => {
          applyToInsertBlock(
            div40
              ? { ITEM_ID40: itemId, ITEM_NAME: itemName ?? '', NICK_NAME: nickName ?? '' }
              : { ITEM_ID: itemId, ITEM_NAME: itemName ?? '', NICK_NAME: nickName ?? '' }
          );
        }}
        preSearchParams={itemSearch as never}
        callFromCell={true}
      />

      {/* Column 설정 — 공용 ColumnLayoutModal (표시/순서 + Width/Cell·Text Color) + titleSet 'C' 영구 저장 */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => onClose('COLUMN')}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        // ⚠️ 저장·복원과 반드시 같은 값 — 상수 한 곳에서만 가져온다.
        //   2026-07-29 교정: 조회는 SHEETS.MAIN('Biz Plan'), 저장은 'C' 로 서로 달라
        //   저장한 개인화가 재진입 시 영구 미조회였다.
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
        }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다 (sales-plan 동일 순서).
          onSettingChanged();
          // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns 에 적용 → grid 즉시 갱신.
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          // (2) titleSet 'C' 영구 저장 — 표시 column + 순서 + 폭/색.
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
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
            // ⭐ 팝업 titleSet 조회 캐시 무효화 (필수). 전역 staleTime=Infinity 라 invalidate 없이는
            //   재조회가 안 일어나고, buildInitialRows 는 BE 응답을 화면 상태보다 우선하므로
            //   저장 전 값이 그대로 이겨서 재진입 시 원복된 것처럼 보인다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
        }}
      />

      {/* Measure 선택 — titleSet 'M' 영구 저장 → 메인 SP measure 필터 (재조회 반영) */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => onClose('MEASURE')}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: SHEETS.MAIN,
            // Measure 개인화 — 폭/색은 대상이 아니라 미전달(빈 값으로 저장됨).
            columnType: TITLESET_MEASURE_TYPE,
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              alertSaveFailed();
              return;
            }
            void fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
        }}
      />

      {/* Exchange Rate — 전용 모달 (닫으면 메인 재조회 — AS-IS blnOK 시 FindData L3003) */}
      <ExchangeRateModal
        open={openExchangeRate}
        modalClose={saved => {
          onClose('EXCHANGE');
          if (saved) onRefetch();
        }}
        defaultDivision={divisionId}
        defaultPeriod={{ start: period.start.slice(0, 6), end: period.end.slice(0, 6) }}
      />

      {/* Ver. Cutoff — 'BP_M' 고정 (AS-IS L2857. 팝업 자체 저장 — blnOK 후 처리 없음 L2862).
          기간은 메인을 승계하지 않는다 — 팝업 자체 기본값(오늘~+5개월, AS-IS L106~108). */}
      <VersionCutoffModal
        open={openCutoff}
        modalClose={() => onClose('CUTOFF')}
        divisionId={divisionId}
      />

      {/* Replace by Cutoff — 선택 M_ 범위 from/to (AS-IS L3465. 실행 후 메인 재조회) */}
      <ReplaceByCutoffModal
        open={openReplace}
        modalClose={applied => {
          onClose('REPLACE');
          if (applied) onRefetch();
        }}
        divisionId={divisionId}
        range={replaceRange}
      />
    </>
  );
};
