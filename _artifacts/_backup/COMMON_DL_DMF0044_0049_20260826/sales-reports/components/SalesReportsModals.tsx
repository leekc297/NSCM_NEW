import { ItemByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useMemo } from 'react';

import type { ColumnLayoutRow } from '@shared/components';
import { ColumnLayoutModal } from '@shared/components';

import { VersionModal } from '../../../components';
import { MENU_ID, SHEETS } from '../sales-reports.constants';
import type { SalesReportRow } from '../sales-reports.types';
import { useSalesReportsStore } from '../useSalesReportsStore';
import { saveTitleSet } from '../utils/sales-reports.api';
import { toCellStr } from '../utils/sales-reports.gridCombos';

import { ExchangeRateModal, TextboxModal } from './modals';

export type SalesReportsModalKey =
  | 'ITEM'
  | 'COLUMN'
  | 'MEASURE'
  | 'VERSION'
  | 'EXCHANGE'
  | 'TEXTBOX';

interface SalesReportsModalsProps {
  divisionId: string;
  year: string;
  mdfType: string;
  versionNo: string;
  openKey: SalesReportsModalKey | null;
  onClose: () => void;
  // ITEM 셀 팝업 반영 대상 행 (Grid dblclick — 값 '기타매출' 제외)
  itemTargetRow: SalesReportRow | null;
  // 선택값 반영 — 대상 행이 아니라 **세트 전체**에 쓰고 변경 등록까지 한다(부모가 소유).
  //   금지: 여기서 `itemTargetRow` 에 직접 대입하지 말 것 — 한 행만 바뀌고 저장에서도 빠진다
  //   (2026-08-22 결함. 근거는 SalesReports.tsx `applyPopupSelection` 주석).
  onItemSelect: (target: SalesReportRow, values: Record<string, unknown>) => void;
  onVersionSelect: (versionNo: string, label: string) => void;
  // Measure 선택 적용 직후 호출 — 부모의 Grid 초기화 (Measure 구성이 바뀌므로)
  onMeasureApply: () => void;
}

// ⭐ DMF0044 모달 스위치 — United/Exchange/Textbox 전용 3종 + Item(공용)/Column/Measure(공용 승격분).
export const SalesReportsModals = ({
  divisionId,
  year,
  mdfType,
  versionNo,
  openKey,
  onClose,
  itemTargetRow,
  onItemSelect,
  onVersionSelect,
  onMeasureApply,
}: SalesReportsModalsProps) => {
  const staticColumns = useSalesReportsStore(s => s.staticColumns);
  const applyColumnLayout = useSalesReportsStore(s => s.applyColumnLayout);
  const userColumnLayout = useSalesReportsStore(s => s.userColumnLayout);

  // ColumnLayoutModal 재진입 복원값 / Default 버튼 기준값 (DMF0003 계약 1:1)
  const labelOf = useMemo(
    () => new Map(staticColumns.map(c => [c.colNm, c.colLblNm ?? c.colNm])),
    [staticColumns]
  );
  const columnLayoutSettings = useMemo<ColumnLayoutRow[]>(
    () =>
      (userColumnLayout ?? []).map(s => ({
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
      staticColumns.map((c, i) => ({
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
  const applyVisibleMeasures = useSalesReportsStore(s => s.applyVisibleMeasures);
  const staticMeasures = useSalesReportsStore(s => s.staticMeasures);
  const visibleMeasures = useSalesReportsStore(s => s.visibleMeasures);
  const fetchStaticMeasures = useSalesReportsStore(s => s.fetchStaticMeasures);

  // ⭐ 조건부 마운트 (REQ:CHAT-20260820-7/8/9 — 버튼 클릭 시 main 화면 깜박임, 사용자 지정 2026-08-20).
  //   종전에는 6개 모달이 **전부 상시 마운트**되어 `open` prop 만 토글했다. 그래서 버튼을 누르면
  //   닫혀 있던 모달들의 훅(조회·raf 루프·레이아웃 계산)까지 같은 렌더 사이클에 함께 깨어나며
  //   본문이 한 번 리플로우된다 = 팝업이 뜨기 직전의 깜박임. 열린 모달 하나만 마운트한다.
  //   ⚠ 언마운트되므로 모달 내부 상태는 매번 초기화된다 — 재오픈 시 잔존값이 사라지는 것은
  //     오히려 규약(hook #132 §2 설정 저장·재오픈 초기화)과 같은 방향이다.
  return (
    <>
      {/* ITEM_ID 셀 더블클릭 — DM0002_ItembyDivisionPopupEx 대응 (공용 모달 재사용, business-plan 선례) */}
      {openKey === 'ITEM' && (
        <ItemByDivisionModal
          open={openKey === 'ITEM'}
          modalClose={onClose}
          setSelectedValue={(
            itemId: string,
            itemName?: string,
            _itemType?: string,
            nickName?: string
          ) => {
            if (!itemTargetRow) return;
            onItemSelect(itemTargetRow, {
              ITEM_ID: itemId,
              NICK_NAME: nickName ?? itemName ?? '',
            });
          }}
          preSearchParams={
            {
              divisionId,
              // ⭐ AS-IS 파리티 (L1316·L1319 `Form_Load(false, sDiv, sTeam, …)`) — 팝업은 **그 행의 팀**으로
              //   필터한다. 'ALL' 하드코딩은 AS-IS 보다 넓은 후보를 보여주는 결함이었다.
              //   모달은 `item.DEPT_ID`(코드)와 비교하므로 표시명이 아니라 코드를 넘긴다.
              deptId:
                toCellStr((itemTargetRow as Record<string, unknown>)?.DEPT_ID).trim() || 'ALL',
              endCustomer: 'ALL',
              salesSite: 'ALL',
              itemId: '',
            } as never
          }
          callFromCell={true}
        />
      )}

      {/* ⭐ Column Setting — DMF0003(mkt-fcst) 방식으로 교체 (2026-07-30 사용자 지시).
          공용 ColumnLayoutModal = 표시/순서 + Width/Cell·Text Color 개인화. */}
      {openKey === 'COLUMN' && (
        <ColumnLayoutModal
          open={openKey === 'COLUMN'}
          modalClose={onClose}
          menuId={MENU_ID}
          sheetName={SHEETS.MAIN}
          columnType='C'
          divisionId={divisionId}
          fallbackColumns={staticColumns.map(c => ({
            key: c.colNm,
            header: c.colLblNm ?? c.colNm,
            width: c.colWth ?? 100,
          }))}
          title='Column Setting'
          leftTitle='Invisible'
          rightTitle='Visible'
          // 재진입 복원 — 현재 grid 상태(개인화 반영본). 미전달 시 사용자 선택이 원복된다.
          initialSettings={columnLayoutSettings}
          defaultSettings={columnLayoutDefaults}
          onSave={settings => {
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
            const visible = settings.filter(s => s.USER_FLAG === 'Y');
            void saveTitleSet(
              'C',
              visible.map((s, i) => ({
                name: s.COLUMN_NAME,
                sortOrderNo: i + 1,
                colWidth: s.COL_WIDTH,
                cellColor: s.CELL_COLOR,
                textColor: s.TEXT_COLOR,
              }))
            );
            onClose();
          }}
        />
      )}

      {/* Measure Select — business-plan 판 복제 (measures/visibleMeasures/onApply 계약) */}
      {openKey === 'MEASURE' && (
        <MeasureSelectModal
          open={openKey === 'MEASURE'}
          modalClose={onClose}
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
              if (ok) void fetchStaticMeasures();
            });
            // Grid 초기화는 개인화 저장(saveTitleSet) 성패와 무관하게 즉시 한다 — 선택은 이미
            //   applyVisibleMeasures 로 반영됐으므로 화면에 남은 이전 결과가 곧바로 어긋난다.
            onMeasureApply();
          }}
        />
      )}

      {/* Version — DMF0049 와 공유하는 공용 팝업 (AS-IS DMF0044_United_VersionPopup 1본 공유 파리티) */}
      {openKey === 'VERSION' && (
        <VersionModal
          open={openKey === 'VERSION'}
          modalClose={onClose}
          menuId={MENU_ID}
          divisionId={divisionId}
          parentReportType={mdfType}
          onSelect={onVersionSelect}
        />
      )}

      {/* Exchange Rate — Version 필수 + pending 차단은 부모 게이트 */}
      {openKey === 'EXCHANGE' && (
        <ExchangeRateModal
          open={openKey === 'EXCHANGE'}
          modalClose={onClose}
          divisionId={divisionId}
          year={year}
          versionNo={versionNo}
        />
      )}

      {/* Textbox — Division 82 전용 */}
      {openKey === 'TEXTBOX' && (
        <TextboxModal open={openKey === 'TEXTBOX'} modalClose={onClose} versionNo={versionNo} />
      )}
    </>
  );
};
