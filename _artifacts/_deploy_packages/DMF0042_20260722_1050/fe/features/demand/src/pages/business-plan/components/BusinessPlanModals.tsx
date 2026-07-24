import {
  ColumnSettingModal,
  type ColumnSettingRow,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';

import { useQueryClient } from '@foundation/query-client';

import { MENU_ID, SHEETS } from '../business-plan.constants';
import { useBusinessPlanStore } from '../useBusinessPlanStore';
import { saveTitleSet } from '../utils/business-plan.api';
import { isDiv40 } from '../utils/business-plan.division';

import { ExchangeRateModal, MeasureSelectModal, ReplaceByCutoffModal, VersionCutoffModal } from './modals';

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
  onClose: (key: BusinessPlanModalKey) => void;
  // Exchange/Cutoff/Replace 완료 후 메인 재조회 (AS-IS FindData 재조회 1:1)
  onRefetch: () => void;
  // 셀 모달 적용 — 부모가 INSERT_GROUP_ID 매칭 Measure 블록 전 행에 patch 반영
  applyToInsertBlock: (patch: Record<string, unknown>) => void;
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
  onClose,
  onRefetch,
  applyToInsertBlock,
}: BusinessPlanModalsProps) => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();

  const staticColumns = useBusinessPlanStore(s => s.staticColumns);
  const staticMeasures = useBusinessPlanStore(s => s.staticMeasures);
  const visibleMeasures = useBusinessPlanStore(s => s.visibleMeasures);
  const fetchStaticColumns = useBusinessPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useBusinessPlanStore(s => s.fetchStaticMeasures);
  const applyColumnVisibility = useBusinessPlanStore(s => s.applyColumnVisibility);
  const applyVisibleMeasures = useBusinessPlanStore(s => s.applyVisibleMeasures);

  const div40 = isDiv40(divisionId);

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
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: '',
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* 셀 모달 — ITEM (신규행. 40=ITEM_ID40 / 81·82=ITEM_ID — AS-IS L1687~1697) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => onClose('ITEM')}
        setSelectedValue={(itemId: string, itemName?: string, _itemType?: string, nickName?: string) => {
          applyToInsertBlock(
            div40
              ? { ITEM_ID40: itemId, ITEM_NAME: itemName ?? '', NICK_NAME: nickName ?? '' }
              : { ITEM_ID: itemId, ITEM_NAME: itemName ?? '', NICK_NAME: nickName ?? '' }
          );
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            itemId: '',
          } as never
        }
        callFromCell={true}
      />

      {/* Column 설정 — 공용 ColumnSettingModal + titleSet 'C' 영구 저장 */}
      <ColumnSettingModal
        open={openColumnSetting}
        modalClose={() => onClose('COLUMN')}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType={SHEETS.MAIN}
        divisionId={divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
        }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        onSave={(settings: ColumnSettingRow[]) => {
          applyColumnVisibility(settings.map(s => s.COLUMN_NAME));
          void saveTitleSet(
            'C',
            settings.map(s => ({
              name: s.COLUMN_NAME,
              sortOrderNo: Number(s.SORT_ORDER_NO ?? 0),
              subTotalFlag: s.SUB_TOTAL_FLAG,
              sortMethodCode: s.USER_SORT_METHOD_CODE,
            }))
          ).then(ok => {
            if (ok) void fetchStaticColumns();
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
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
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

      {/* Ver. Cutoff — 'BP_M' 고정 (AS-IS L2857. 팝업 자체 저장 — blnOK 후 처리 없음 L2862) */}
      <VersionCutoffModal
        open={openCutoff}
        modalClose={() => onClose('CUTOFF')}
        divisionId={divisionId}
        period={{ from: period.start.slice(0, 6), to: period.end.slice(0, 6) }}
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
