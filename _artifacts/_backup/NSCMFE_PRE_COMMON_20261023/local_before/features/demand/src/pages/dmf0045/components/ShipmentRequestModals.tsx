import {
  ItemByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import { queryClient } from '@foundation/query-client';
import { ColumnLayoutModal, saveTitleSet, toColumnLayoutSettings } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, TITLESET_COLUMN_TYPE, TITLESET_MEASURE_TYPE } from '../dmf0045.constants';
import type { ActiveSheet, BodItemReturn, ShipmentRequestRow } from '../dmf0045.types';
import { useShipmentRequestStore } from '../useShipmentRequestStore';
import { isDiv40 } from '../utils/dmf0045.division';
import { toCellStr } from '../utils/dmf0045.gridCombos';

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
        // 반환 positional (projectCode, projectName, projectStatus, bizTypeName, projectOwner) — design 03 §3.
        //   주의: 공용 SCM0002 모달은 END_CUSTOMER 를 positional 로 반환하지 않는다(master 계약).
        //   AS-IS cs 1250-1310 은 END_CUSTOMER 도 채우나 모달 반환에 없어 여기서 임의로 채우지 않는다
        //   (blank/추측 금지 — 04_react-gap 확인필요. 반환되는 컬럼만 반영).
        setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName, projectOwner) => {
          applyToInsertRow({
            PROJECT_CODE: projectCode,
            PROJECT_NAME: projectName ?? '',
            PROJECT_STATUS: projectStatus ?? '',
            BIZ_TYPE_NAME: bizTypeName ?? '',
            PROJECT_OWNER: projectOwner ?? '',
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

      {/* 셀 모달 — ITEM_ID → DMF0047 ItembyDivisionPopup (Pack='P'/Cell='A' BizType 은 SP 응답 필터) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => onClose('ITEM')}
        // 반환 positional (itemId, itemName, itemClassName, itemType, nickName) — master 계약 순서.
        //   design 03 §3: ItemID→ITEM_ID, NickName→NICK_NAME 2컬럼만 채움.
        setSelectedValue={(itemId, _itemName, _itemClassName, _itemType, nickName) => {
          applyToInsertRow({
            ITEM_ID: itemId,
            NICK_NAME: nickName ?? '',
          });
        }}
        preSearchParams={
          {
            divisionId: rowValue('DIVISION_ID', divisionId),
            deptId: rowValue('DEPT_ID'),
            endCustomer: rowValue('END_CUSTOMER'),
            salesSite: rowValue('SCM_SITE_ID'),
            projectCode: rowValue('PROJECT_CODE', ''),
            itemId: rowValue('ITEM_ID', ''),
            activeFlag: 'Y',
          } as never
        }
        callFromCell={true}
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
          applyToInsertRow({
            FROM_SITE: toCellStr(first.c_FROM_SITE),
            TO_SITE: toCellStr(first.c_TO_SITE),
            INCOTERMS: toCellStr(first.c_INCOTERMS),
            TR_MODE: toCellStr(first.c_TRANSPORT_MODE),
            BOD_ID: toCellStr(first.c_BOD_ID),
            END_CUSTOMER: toCellStr(first.c_END_CUSTOMER),
            TEAM_NAME_KO: toCellStr(first.c_DEPT_NAME_KO),
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
