import {
  MeasureSelectModal,
  ItemByDivisionModal,
  ProjectByDivisionModal,
  TeamModal,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import { queryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  DEPT_CASCADE_CLEAR_NON40,
  ITEM_CLEAR_FIELDS,
  MENU_ID,
  PROJECT_POPUP_CANCEL_CLEAR,
  SHEETS,
  TITLESET_COLUMN_TYPE,
  TITLESET_MEASURE_TYPE,
} from '../sales-plan.constants';
import type { SalesPlanRow } from '../sales-plan.types';
import { useSalesPlanStore } from '../useSalesPlanStore';
import { isDiv40 } from '../utils/sales-plan.division';
import { buildClearPatch } from '../utils/sales-plan.gridCombos';

export type SalesPlanModalKey = 'PROJECT' | 'ITEM' | 'COLUMN' | 'MEASURE' | 'TEAM';

interface SalesPlanModalsProps {
  divisionId: string;
  openProject: boolean;
  openItem: boolean;
  openTeam: boolean;
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

// ⭐ DMF0021 모달 5종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무 진입≤400):
//   ① PROJECT 셀 모달 (81·82 신규행 — AS-IS spdMain_CellDoubleClick L3834: Project/Name 세팅 + Item 클리어)
//   ② ITEM 셀 모달 (40+Catch_Up 신규행 — L3863~3912: Item/NickName 세팅 [E20231019-001234])
//   ③ TEAM(DEPT_ID) 셀 모달 (신규행 Catch_Up 제외 — 2026-09-18 콤보→모달+키인 전환. 선택 시
//     DEPT_ID 세팅 + 40 제외 division 하위 clear = 그리드 키인 cellEditEnded 와 동일 cascade)
//   ④ Column 설정 (공용 ColumnLayoutModal + titleSet 'C' — AS-IS btnColumn L4427 → InitSpread.
//     forecast-price(DMF0082)·mkt-fcst 와 동일 팝업 — 구본 ColumnSettingModal 사용 금지)
//   ⑤ Measure 선택 (MeasureSelectModal + titleSet 'M' — AS-IS btnMeasure L4440. 메인 SP 가
//     TITLESET 'M' 으로 measure 행을 필터하므로 저장 후 invalidate 재조회로 반영)
export const SalesPlanModals = ({
  divisionId,
  openProject,
  openItem,
  openTeam,
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

  // Project 셀 모달 취소 판정 — 공용 ProjectByDivisionModal 은 OK/더블클릭 확정 경로에서도
  //   modalClose() 를 호출하므로 '닫혔다'는 사실만으로는 선택/취소를 구분할 수 없다.
  //   setSelectedValue 통과 여부를 ref 에 표시해 구분한다.
  //   필수: state 가 아니라 ref — 확정과 닫기가 같은 이벤트 안에서 연달아 일어나 state 는
  //   갱신 전 값이 읽히고(배치), 그러면 방금 선택한 Project 까지 지워진다.
  const projectPickedRef = useRef(false);
  useEffect(() => {
    if (openProject) projectPickedRef.current = false;
  }, [openProject]);

  const handleProjectClose = () => {
    // 선택 없이 닫음 = Project 미선택 확정 (사용자 요구 2026-08-23 — 기존 값이 있어도 비움).
    //   Model 은 Project 종속이라 함께 초기화한다.
    if (!projectPickedRef.current) applyToInsertRow(buildClearPatch(PROJECT_POPUP_CANCEL_CLEAR));
    onClose('PROJECT');
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
        modalClose={handleProjectClose}
        setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName, projectOwner) => {
          // 이 호출을 지나면 확정 — 뒤이어 오는 modalClose 는 취소 clear 를 건너뛴다.
          projectPickedRef.current = true;
          applyToInsertRow({
            PROJECT_CODE: projectCode,
            PROJECT_NAME: projectName ?? '',
            PROJECT_STATUS: projectStatus ?? '',
            BIZ_TYPE_NAME: bizTypeName ?? '',
            PROJECT_OWNER: projectOwner ?? '',
            // Project 가 바뀌면 Model 은 무효 — 취소 경로와 같은 묶음으로 비운다.
            ...buildClearPatch(ITEM_CLEAR_FIELDS),
            // Team(DEPT_ID)은 이 팝업에서 파생하지 않는다 (2026-09-08) — 전 Division 에서 메타
            //   콤보(TeamByDivision)로 직접 편집하는 독립 컬럼이다.
          });
        }}
        preSearchParams={
          {
            divisionId: rowValue('DIVISION_ID', divisionId),
            // Team(DEPT_ID)을 Project 팝업 조회조건으로 실어 연다 (사용자 요구 2026-09-14 재도입).
            //   주의: 재오픈 시 직전 Team 이 필터로 남을 수 있음 — 과거 이 이유로 ALL 로 뺐던 이력 있음.
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
            // Team(DEPT_ID)은 이 팝업에서 파생하지 않는다 (2026-09-08) — 위 PROJECT 모달과 동일.
            //   40+Catch_Up 은 DEPT_ID 잠금이라 편집 Team 이 없다(그 외는 메타 콤보로 직접 편집).
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

      {/* 셀 모달 — TEAM(DEPT_ID) (신규행 Catch_Up 제외 — 2026-09-18 콤보→모달+키인 전환) */}
      <TeamModal
        open={openTeam}
        modalClose={() => onClose('TEAM')}
        setSelectedValue={teamId => {
          applyToInsertRow({
            DEPT_ID: teamId,
            // Team 변경 = 40 제외 division 에서 하위(End Customer/Sales Site/Project) 초기화
            //   — 그리드 키인(cellEditEnded) 의 DEPT_CASCADE_CLEAR_NON40 과 동일 동작(사용자 요구 2026-09-18).
            ...(isDiv40(rowValue('DIVISION_ID', divisionId))
              ? {}
              : buildClearPatch(DEPT_CASCADE_CLEAR_NON40)),
          });
        }}
        teamId={rowValue('DEPT_ID', '')}
        divisionId={rowValue('DIVISION_ID', divisionId)}
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
