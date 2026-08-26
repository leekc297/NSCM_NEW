import {
  MeasureSelectModal,
  ItemByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import { queryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  MENU_ID,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_MEASURE_TYPE,
} from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';
import { useSalesPlanStore } from '../useSalesPlanStore';

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
  // Column/Measure 설정 저장 = Grid 초기화 의무 (사용자 요구 2026-08-05) — 부모(SalesPlan.tsx)가
  //   insertedRows/EditTracker/조회 게이트/캐시 reset 수행. 표시 컬럼/메저가 바뀌는 순간
  //   이전 조건으로 조회해 둔 rows 를 그대로 두면 화면 구성과 데이터가 어긋난다.
  onSettingChanged: () => void;
}

// ⭐ DMF0021 모달 4종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무 진입≤400):
//   ① PROJECT 셀 모달 (81·82 신규행 — AS-IS spdMain_CellDoubleClick L3834: Project/Name 세팅 + Item 클리어)
//   ② ITEM 셀 모달 (40+Catch_Up 신규행 — L3863~3912: Item/NickName 세팅 [E20231019-001234])
//   ③ Column 설정 (공용 ColumnLayoutModal + titleSet 'C' — AS-IS btnColumn L4427 → InitSpread.
//     forecast-price(DMF0082)·mkt-fcst 와 동일 팝업 — 구본 ColumnSettingModal 사용 금지)
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
  onSettingChanged,
}: SalesPlanModalsProps) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;

  const staticColumns = useSalesPlanStore(s => s.staticColumns);
  const originalStaticColumns = useSalesPlanStore(s => s.originalStaticColumns);
  const staticMeasures = useSalesPlanStore(s => s.staticMeasures);
  const visibleMeasures = useSalesPlanStore(s => s.visibleMeasures);
  const fetchStaticColumns = useSalesPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useSalesPlanStore(s => s.fetchStaticMeasures);
  const applyColumnLayout = useSalesPlanStore(s => s.applyColumnLayout);
  const applyVisibleMeasures = useSalesPlanStore(s => s.applyVisibleMeasures);

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
        setSelectedValue={(
          projectCode,
          projectName,
          projectStatus,
          bizTypeName,
          projectOwner,
          deptId,
          deptName
        ) => {
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
            // [No.61-④] Team 파생 — 입력 불가 컬럼이라 마스터(선택 행)의 팀이 유일한 출처.
            //   팝업이 팀을 안 내려주면(구 버전·다건 선택) 종전 값을 유지한다.
            ...(deptId ? { DEPT_ID: deptId, TEAM_NAME: deptName ?? '' } : {}),
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
        setSelectedValue={(
          itemId,
          itemName,
          itemClassName,
          nickName,
          itemType,
          deptId,
          deptName
        ) => {
          applyToInsertRow({
            ITEM_ID: itemId,
            ITEM_NAME: itemName ?? '',
            ITEM_CLASS_NAME: itemClassName ?? '',
            ITEM_TYPE: itemType ?? '',
            NICK_NAME: nickName ?? '',
            // [No.61-④] Team 파생 — 위 PROJECT 모달과 동일 계약.
            ...(deptId ? { DEPT_ID: deptId, TEAM_NAME: deptName ?? '' } : {}),
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

      {/* Column 설정 — 공용 ColumnLayoutModal (표시/순서 + Width/Cell·Text Color) + titleSet 'C' 영구 저장 */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => onClose('COLUMN')}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        // ⚠️ 저장·복원과 반드시 같은 값 — 상수 한 곳에서만 가져온다.
        //   2026-07-29 교정: 조회는 SHEETS.MAIN('Sales Plan'), 저장은 'C' 로 서로 달라
        //   저장한 개인화가 재진입 시 영구 미조회였다.
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
          // titleSet 응답이 0건일 때의 좌/우 배치·이동 잠금도 admin 플래그 기준 (라벨 '*' 폐기).
          display: c.display,
          personalizable: c.personalizable,
        }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다 (mkt-fcst 동일 순서).
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
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다 (mkt-fcst 동일 순서).
          //   (메인 SP 가 TITLESET 'M' 으로 measure 행을 필터하므로 신규 선택은 재조회로만 반영된다.)
          onSettingChanged();
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
          });
        }}
      />
    </>
  );
};
