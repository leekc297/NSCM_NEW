import {
  ColumnSettingModal,
  type ColumnSettingRow,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';

import { MENU_ID, SHEETS } from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';
import { useSalesPlanStore } from '../useSalesPlanStore';
import { saveTitleSet } from '../utils/sales-plan.api';

import { MeasureSelectModal } from './modals';

export type SalesPlanModalKey = 'PROJECT' | 'ITEM' | 'COLUMN' | 'MEASURE';

interface SalesPlanModalsProps {
  divisionId: string;
  openProject: boolean;
  openItem: boolean;
  openColumnSetting: boolean;
  openMeasureSelect: boolean;
  popupRow: SalesPlanRow | null;
  onClose: (key: SalesPlanModalKey) => void;
  // 셀 모달 적용 — 부모가 INSERT_GROUP_ID 매칭 행에 patch 반영 (insertedRows 상태 갱신)
  applyToInsertRow: (patch: Record<string, unknown>) => void;
  onMeasureSaved: () => void;
}

// ⭐ DMF0021 모달 4종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무 진입≤400):
//   ① PROJECT 셀 모달 (81·82 신규행 — AS-IS spdMain_CellDoubleClick L3834: Project/Name 세팅 + Item 클리어)
//   ② ITEM 셀 모달 (40+Catch_Up 신규행 — L3863~3912: Item/NickName 세팅 [E20231019-001234])
//   ③ Column 설정 (공용 ColumnSettingModal + titleSet 'C' — AS-IS btnColumn L4427 → InitSpread)
//   ④ Measure 선택 (MeasureSelectModal + titleSet 'M' — AS-IS btnMeasure L4440. 메인 SP 가
//     TITLESET 'M' 으로 measure 행을 필터하므로 저장 후 invalidate 재조회로 반영)
export const SalesPlanModals = ({
  divisionId,
  openProject,
  openItem,
  openColumnSetting,
  openMeasureSelect,
  popupRow,
  onClose,
  applyToInsertRow,
  onMeasureSaved,
}: SalesPlanModalsProps) => {
  const { t } = useTranslation();

  const staticColumns = useSalesPlanStore(s => s.staticColumns);
  const staticMeasures = useSalesPlanStore(s => s.staticMeasures);
  const visibleMeasures = useSalesPlanStore(s => s.visibleMeasures);
  const fetchStaticColumns = useSalesPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useSalesPlanStore(s => s.fetchStaticMeasures);
  const applyColumnVisibility = useSalesPlanStore(s => s.applyColumnVisibility);
  const applyVisibleMeasures = useSalesPlanStore(s => s.applyVisibleMeasures);

  const rowValue = (key: string, fallback = 'ALL'): string => {
    const value = popupRow?.[key];
    if (value == null) return fallback;
    if (typeof value === 'string') return value.trim() || fallback;
    return typeof value === 'number' ? String(value) : fallback;
  };

  return (
    <>
      {/* 셀 모달 — PROJECT (81·82 신규행) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => onClose('PROJECT')}
        setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName, projectOwner) => {
          applyToInsertRow({
            PROJECT_CODE: projectCode,
            PROJECT_NAME: projectName ?? '',
            PROJECT_STATUS: projectStatus ?? '',
            BIZ_TYPE_NAME: bizTypeName ?? '',
            PROJECT_OWNER: projectOwner ?? '',
            ITEM_ID: '',
            ITEM_CLASS_NAME: '',
            ITEM_TYPE: '',
            NICK_NAME: '',
          });
        }}
        preSearchParams={
          {
            divisionId: rowValue('DIVISION_ID', divisionId),
            deptId: rowValue('DEPT_ID'),
            endCustomer: rowValue('END_CUSTOMER'),
            salesSite: rowValue('SCM_SITE_ID'),
            projectCode: rowValue('PROJECT_CODE', ''),
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* 셀 모달 — ITEM (40+Catch_Up 신규행) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => onClose('ITEM')}
        setSelectedValue={(itemId, itemName, itemClassName, nickName, itemType) => {
          applyToInsertRow({
            ITEM_ID: itemId,
            ITEM_NAME: itemName ?? '',
            ITEM_CLASS_NAME: itemClassName ?? '',
            ITEM_TYPE: itemType ?? '',
            NICK_NAME: nickName ?? '',
          });
        }}
        preSearchParams={
          {
            divisionId: rowValue('DIVISION_ID', divisionId),
            deptId: rowValue('DEPT_ID'),
            endCustomer: rowValue('END_CUSTOMER40', rowValue('END_CUSTOMER')),
            salesSite: rowValue('SCM_SITE_ID'),
            projectCode: '',
            itemId: rowValue('ITEM_ID', ''),
            activeFlag: 'Y',
            measure: rowValue('MEASURE', ''),
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
          // 로컬 즉시 반영 + 서버 영구 저장('C') → 성공 시 admin 메타 재fetch (개인화 기준 재계산)
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
            onMeasureSaved();
          });
        }}
      />
    </>
  );
};
