import {
  ColumnLayoutModal,
  ItemByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useMemo } from 'react';

import { useQueryClient } from '@foundation/query-client';
import type { ColumnLayoutRow } from '@shared/components';

import { MENU_ID, SHEETS } from '../business-plan.constants';
import { useBusinessPlanStore } from '../useBusinessPlanStore';
import { saveTitleSet } from '../utils/business-plan.api';
import { isDiv40 } from '../utils/business-plan.division';

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
  onClose: (key: BusinessPlanModalKey) => void;
  // Exchange/Cutoff/Replace 완료 후 메인 재조회 (AS-IS FindData 재조회 1:1)
  onRefetch: () => void;
  // 셀 모달 적용 — 부모가 INSERT_GROUP_ID 매칭 Measure 블록 전 행에 patch 반영
  applyToInsertBlock: (patch: Record<string, unknown>) => void;
  // ⭐ Column/Measure 설정 저장 시 그리드 비움 (hook #132 §2-2 — Division 변경과 동일 초기화
  //   규약. 이전 결과는 옛 구성으로 조회된 것이라 새 구성과 어긋남 → Search 재조회 유도.
  //   자동 재조회(invalidateQueries/refetch) 금지, saveTitleSet 성패 무관 비움).
  onSettingsApplied: () => void;
}

// ⭐ DMF0042 모달 7종 묶음 (진입 컴포넌트 분리 — components/ 분리 의무 진입≤400):
//   ① PROJECT 셀 모달 (81·82 신규행 — AS-IS L1699~1797: Project/Name/BizType 세팅)
//   ② ITEM 셀 모달 (전 division 신규행 — L1640~1698: Item/ItemName 세팅)
//   ③ Column 설정 (공용 ColumnLayoutModal + titleSet 'C' — AS-IS btnColumn L2807 → InitSpread)
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
  onSettingsApplied,
}: BusinessPlanModalsProps) => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();

  const staticColumns = useBusinessPlanStore(s => s.staticColumns);
  const staticMeasures = useBusinessPlanStore(s => s.staticMeasures);
  const visibleMeasures = useBusinessPlanStore(s => s.visibleMeasures);
  const fetchStaticColumns = useBusinessPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useBusinessPlanStore(s => s.fetchStaticMeasures);
  const applyColumnLayout = useBusinessPlanStore(s => s.applyColumnLayout);
  const userColumnLayout = useBusinessPlanStore(s => s.userColumnLayout);
  const applyVisibleMeasures = useBusinessPlanStore(s => s.applyVisibleMeasures);

  // ColumnLayoutModal 재진입 복원값 — 현재 grid 상태(개인화 반영본) / Default 버튼 기준값(admin 메타 원본).
  const labelOf = useMemo(
    () => new Map(staticColumns.map(c => [c.colNm, c.colLblNm ?? c.colNm])),
    [staticColumns]
  );
  // ⭐ MEASURE 는 Column Setting 목록에서 제외 — 그리드가 정적 컬럼 마지막에 상시 표시한다
  //   (2026-08-05 사용자 확정). titleset 'C' 저장에서도 제외해 SP ColList 중복(ORA-00960) 오염을 차단.
  const columnLayoutSettings = useMemo<ColumnLayoutRow[]>(
    () =>
      (userColumnLayout ?? []).filter(s => s.colNm !== 'MEASURE').map(s => ({
        COLUMN_NAME: s.colNm,
        COLUMN_LABEL_NAME: labelOf.get(s.colNm) ?? s.colNm,
        USER_FLAG: s.visible ? 'Y' : 'N',
        SORT_ORDER_NO: s.order,
        COL_WIDTH: s.width,
        CELL_COLOR: s.cellColor,
        TEXT_COLOR: s.textColor,
        isKey: false,
      })),
    [userColumnLayout, labelOf]
  );
  const columnLayoutDefaults = useMemo<ColumnLayoutRow[]>(
    () =>
      staticColumns.filter(c => c.colNm !== 'MEASURE').map((c, i) => ({
        COLUMN_NAME: c.colNm,
        COLUMN_LABEL_NAME: c.colLblNm ?? c.colNm,
        USER_FLAG: c.visible === false ? 'N' : 'Y',
        SORT_ORDER_NO: i + 1,
        COL_WIDTH: c.colWth ?? 100,
        CELL_COLOR: '',
        TEXT_COLOR: '',
        isKey: false,
      })),
    [staticColumns]
  );

  const div40 = isDiv40(divisionId);

  return (
    <>
      {/* 셀 모달 — PROJECT (81·82 신규행. division별 키 컬럼 분기 — AS-IS L1738~1796) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => onClose('PROJECT')}
        setSelectedValue={(projectCode, projectName, _projectStatus, bizTypeName) => {
          // ⭐ BIZ_TYPE_NAME81/82 자동 채움 — AS-IS L1807~1808/L1857~1858 (popProject.BizType 반영)
          applyToInsertBlock(
            div40
              ? { PROJECT_CODE: projectCode, PROJECT_NAME: projectName ?? '' }
              : divisionId === '82'
                ? {
                    PROJECT_CODE82: projectCode,
                    PROJECT_NAME: projectName ?? '',
                    // 더블클릭 단일선택 경로만 bizTypeName 제공 — 미제공(멀티 OK) 시 기존값 보존
                    ...(bizTypeName !== undefined ? { BIZ_TYPE_NAME82: bizTypeName } : {}),
                    ITEM_ID: '',
                    ITEM_CLASS_NAME: '',
                  }
                : {
                    PROJECT_CODE: projectCode,
                    PROJECT_NAME: projectName ?? '',
                    ...(bizTypeName !== undefined ? { BIZ_TYPE_NAME81: bizTypeName } : {}),
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

      {/* ⭐ Column 설정 — DMF0003(mkt-fcst) 방식으로 교체 (2026-07-30 사용자 지시).
          공용 ColumnLayoutModal = 표시/순서 + Width/Cell·Text Color 개인화. DMF0082 → DMF0003 선례 1:1.
          ⚠️ columnType 은 반드시 'C' — TITLESET_USER.USER_INQUIRY_COLUMN_TYPE_CODE 실측값이
            'C'(컬럼)/'M'(measure) 이다. 이전에 sheetName('Biz Plan')을 넘겨 아래 saveTitleSet('C')
            저장분과 키가 어긋나 저장한 개인화가 영구 미조회되던 상태였다. */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => onClose('COLUMN')}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        columnType='C'
        divisionId={divisionId}
        fallbackColumns={staticColumns
          .filter(c => c.colNm !== 'MEASURE')
          .map(c => ({
            key: c.colNm,
            header: c.colLblNm ?? c.colNm,
            width: c.colWth ?? 100,
          }))}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        // 재진입 복원 — 현재 grid 상태(개인화 반영본). 미전달 시 사용자 선택이 원복된다.
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // 로컬 즉시 반영 + titleSet 'C' 영구 저장(표시 컬럼 + 순서 + 폭/색)
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
          const visible = settings.filter(s => s.USER_FLAG === 'Y' && s.COLUMN_NAME !== 'MEASURE');
          void saveTitleSet(
            'C',
            visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          ).then(ok => {
            if (!ok) return;
            // ⭐ 팝업 titleSet 캐시 무효화 필수 — 전역 staleTime=Infinity 라 invalidate 없이는
            //   재조회가 안 일어나고, buildInitialRows 는 BE 응답을 화면 상태보다 우선하므로
            //   방금 표시로 옮긴 컬럼이 재진입 시 비표시로 보인다 (DMF0003 2026-07-28 실측 사고).
            //   (메인 그리드 쿼리 키는 tabId UUID prefix 라 이 invalidate 에 미매칭 — 모달 캐시 전용)
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
          // hook #132 §2-2 — 저장 성패 무관 그리드 비움 (Search 재조회 유도)
          onSettingsApplied();
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
            // 모달 titleSet 캐시 무효화 전용 (메인 그리드 키는 tabId UUID prefix — 미매칭)
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
          });
          // hook #132 §2-2 — 저장 성패 무관 그리드 비움 (Search 재조회 유도)
          onSettingsApplied();
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
          Period 는 팝업 자체 기본값(오늘~+5개월 — AS-IS Form_Load L106~108) */}
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
