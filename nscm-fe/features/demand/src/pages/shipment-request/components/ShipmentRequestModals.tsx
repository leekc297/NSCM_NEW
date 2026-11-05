import {
  MaterialByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import { queryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, TITLESET_COLUMN_TYPE, TITLESET_MEASURE_TYPE } from '../shipment-request.constants';
import type { ActiveSheet, BodItemReturn, ShipmentRequestRow } from '../shipment-request.types';
import { useShipmentRequestStore } from '../useShipmentRequestStore';
import { isDiv40 } from '../utils/shipment-request.division';
import { toCellStr } from '../utils/shipment-request.gridCombos';

import { BodItemRouteModal } from './modals/BodItemRouteModal';

// 셀/설정 모달 키 — PROJECT(SCM0002) / BOD(DMF0046 TR_MODE) / ITEM(DMF0047) + COLUMN / MEASURE.
export type ShipmentModalKey = 'PROJECT' | 'BOD' | 'ITEM' | 'COLUMN' | 'MEASURE';

interface ShipmentRequestModalsProps {
  divisionId: string;
  activeSheet: ActiveSheet;
  // 조회 기간 시작(BOD 팝업 fromYyyymmdd 파라미터) — spreadTitle filter start.
  fromYyyymmdd: string;
  openProject: boolean;
  openBod: boolean;
  openItem: boolean;
  openColumnSetting: boolean;
  openMeasureSelect: boolean;
  popupRow: ShipmentRequestRow | null;
  onClose: (key: ShipmentModalKey) => void;
  // 셀 모달 적용 — 부모가 INSERT_GROUP_ID 매칭 행에 patch 반영(sales-plan applyToInsertRow 동형).
  applyToInsertRow: (patch: Record<string, unknown>) => void;
  // Column/Measure 설정 저장 = Grid 초기화 의무 — 부모가 조회 게이트/캐시 reset 수행.
  //   표시 컬럼/measure 가 바뀌는 순간 이전 조건으로 조회한 rows 를 그대로 두면 화면과 데이터가 어긋난다.
  onSettingChanged: () => void;
}

// DMF0045 모달 5종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무):
//   PROJECT_CODE 셀 → SCM0002 / TR_MODE 셀 → DMF0046 BOD(로컬) / ITEM_ID 셀 → DMF0047 +
//   Column 설정(공용 ColumnLayoutModal + titleSet 'C') + Measure 선택(MeasureSelectModal + titleSet 'M').
//   design 03 §3 셀 더블클릭 팝업 3종 — 신규행(action='I')만 트리거(그리드가 선판정).
export const ShipmentRequestModals = ({
  divisionId,
  activeSheet,
  fromYyyymmdd,
  openProject,
  openBod,
  openItem,
  openColumnSetting,
  openMeasureSelect,
  popupRow,
  onClose,
  applyToInsertRow,
  onSettingChanged,
}: ShipmentRequestModalsProps) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;

  const staticColumns = useShipmentRequestStore(s => s.staticColumns);
  const originalStaticColumns = useShipmentRequestStore(s => s.originalStaticColumns);
  const staticMeasures = useShipmentRequestStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentRequestStore(s => s.visibleMeasures);
  const fetchStaticColumns = useShipmentRequestStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestStore(s => s.fetchStaticMeasures);
  const applyColumnLayout = useShipmentRequestStore(s => s.applyColumnLayout);
  const applyVisibleMeasures = useShipmentRequestStore(s => s.applyVisibleMeasures);

  // ColumnLayoutModal 재진입 복원(개인화 반영본) / Default 원복(admin 메타 원본).
  const columnLayoutSettings = useMemo(() => toColumnLayoutSettings(staticColumns), [staticColumns]);
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns),
    [originalStaticColumns]
  );

  // 저장 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
  const alertSaveFailed = () => {
    void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_An error occurred while saving.') });
  };

  // popupRow 값 읽기 — 빈값이면 fallback('ALL'). 셀 팝업 조회조건(preSearchParams) 구성용.
  const rowValue = (key: string, fallback = 'ALL'): string => {
    const value = popupRow?.[key];
    if (value == null) return fallback;
    if (typeof value === 'string') return value.trim() || fallback;
    return typeof value === 'number' ? String(value) : fallback;
  };

  // 팝업 컬럼 메타(bodPopup) 재조회 파라미터로 쓰이는 현재 행 ITEM_ID.
  const rowItemId = toCellStr(popupRow?.ITEM_ID);

  return (
    <>
      {/* 셀 모달 — PROJECT_CODE → SCM0002 ProjectbyDivisionPopup (신규행. 40 제외는 그리드가 선판정) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => onClose('PROJECT')}
        // 반환 positional (projectCode, projectName, projectStatus, bizTypeName, projectOwner,
        //   deptId, deptName, bizType, endCustomer) — 공용 ProjectByDivisionModal 계약.
        //   END_CUSTOMER: AS-IS Project 팝업(cs 1305)이 채운다 — 공용 모달에 endCustomer(9번째) 반환을 추가해 반영.
        //   TEAM_NAME_KO: AS-IS Project 팝업은 Team 을 채우지 않는다(Team 은 TR_MODE 팝업 cs 1387 담당).
        //     사용자 지시(2026-10-30)로 Project 선택 시 Team(팝업 반환 deptName)도 함께 채운다(AS-IS 초과).
        //     [ROLLBACK:dmf0045-project-popup-fill-team] TEAM_NAME_KO 줄만 제거하면 AS-IS 패리티(End Customer 만).
        setSelectedValue={(
          projectCode,
          projectName,
          projectStatus,
          bizTypeName,
          projectOwner,
          _deptId,
          deptName,
          _bizType,
          endCustomer
        ) => {
          applyToInsertRow({
            PROJECT_CODE: projectCode,
            PROJECT_NAME: projectName ?? '',
            PROJECT_STATUS: projectStatus ?? '',
            BIZ_TYPE_NAME: bizTypeName ?? '',
            PROJECT_OWNER: projectOwner ?? '',
            END_CUSTOMER: endCustomer ?? '', // AS-IS cs 1305 (Project 팝업이 채우는 컬럼)
            TEAM_NAME_KO: deptName ?? '', // 사용자 지시 2026-10-30 (AS-IS 초과 — [ROLLBACK:dmf0045-project-popup-fill-team])
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

      {/* 셀 모달 — ITEM_ID(Model) → COM0013 MaterialByDivisionModal(공통 팝업, SCM0002_MaterialByDivisionPopup).
          사용자 지시 2026-10-29: 기존 ItemByDivisionModal(DMF0047)에서 조회조건 Model/Nickname 과 동일한
          공통 팝업으로 교체. 파라미터도 조회조건 팝업과 동형(scpModuleType=화면ID / operationGroup 공란).
          더블클릭 = 그 행으로 확정(모달 handleDblClick→emit) → ITEM_ID/NICK_NAME 2컬럼 채움. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => onClose('ITEM')}
        // 반환 (itemId, itemName, itemClassName, nickName, nickNames). design 03 §3: Model→ITEM_ID, Nickname→NICK_NAME.
        setSelectedValue={(itemId, _itemName, _itemClassName, nickName) => {
          applyToInsertRow({
            ITEM_ID: itemId,
            NICK_NAME: nickName ?? '',
          });
        }}
        preSearchParams={{
          divisionId: rowValue('DIVISION_ID', divisionId),
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: rowValue('ITEM_ID', ''),
        }}
      />

      {/* 셀 모달 — TR_MODE → DMF0046 BOD 팝업(로컬 구성 — 전제 ITEM_ID 는 그리드가 선차단) */}
      <BodItemRouteModal
        open={openBod}
        modalClose={() => onClose('BOD')}
        preSearchParams={{ divisionId, itemId: rowItemId, fromYyyymmdd }}
        // 다건 반환 중 첫 건을 현재 행 7칸에 반영 — c_* → 그리드 binding(design 03 §3 근거표).
        //   다건 신규행 생성은 후속 확장(현재는 첫 건 채움).
        setSelectedValue={(bodRows: BodItemReturn[]) => {
          const first = bodRows[0];
          if (!first) return;
          // SCP0030 기반 BOD 팝업은 END_CUSTOMER/Team(c_END_CUSTOMER·c_DEPT_NAME_KO)을 반환하지 않아 ''다.
          //   빈값으로 덮으면 직전 Project 팝업(cs 1305/사용자지시)이 채운 End Customer·Team 이 지워진다
          //   → 반환값이 있을 때만 반영하고, 없으면 기존 값을 보존한다(AS-IS 는 BOD 가 채우나 TO-BE 미반환).
          const endCustomer = toCellStr(first.c_END_CUSTOMER);
          const teamNameKo = toCellStr(first.c_DEPT_NAME_KO);
          applyToInsertRow({
            FROM_SITE: toCellStr(first.c_FROM_SITE),
            TO_SITE: toCellStr(first.c_TO_SITE),
            INCOTERMS: toCellStr(first.c_INCOTERMS),
            TR_MODE: toCellStr(first.c_TRANSPORT_MODE),
            BOD_ID: toCellStr(first.c_BOD_ID),
            ...(endCustomer ? { END_CUSTOMER: endCustomer } : {}),
            ...(teamNameKo ? { TEAM_NAME_KO: teamNameKo } : {}),
          });
        }}
      />

      {/* Column 설정 — 공용 ColumnLayoutModal(표시/순서 + Width/Cell·Text Color) + titleSet 'C' 영구 저장 */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => onClose('COLUMN')}
        menuId={MENU_ID}
        sheetName={activeSheet}
        // 저장·복원과 반드시 같은 값 — 상수 한 곳에서만 가져온다(조회/저장 키 불일치 = 영구 미조회 사고).
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={isDiv40(divisionId) ? '40' : divisionId}
        fallbackColumns={staticColumns.map(c => ({
          key: c.colNm,
          header: c.colLblNm ?? c.colNm,
          width: c.colWth ?? 100,
          // titleSet 0건일 때의 좌/우 배치·이동 잠금도 admin 플래그 기준.
          display: c.display,
          personalizable: c.personalizable,
        }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다(sales-plan 동일 순서).
          onSettingChanged();
          // (1) 로컬 즉시 반영 — store 가 표시/순서/폭/색을 staticColumns 에 적용.
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
            sheetName: activeSheet,
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
            // 팝업 titleSet 조회 캐시 무효화 — 전역 staleTime=Infinity 라 invalidate 없이는 재조회가
            //   안 일어나 저장 전 값이 재진입 시 이겨 원복된 것처럼 보인다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
        }}
      />

      {/* Measure 선택 — titleSet 'M' 영구 저장 → 메인 SP measure 필터(재조회 반영) */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => onClose('MEASURE')}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다.
          onSettingChanged();
          applyVisibleMeasures(codes);
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: activeSheet,
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
