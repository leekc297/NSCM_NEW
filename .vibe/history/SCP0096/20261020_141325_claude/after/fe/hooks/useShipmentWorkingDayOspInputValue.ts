import { type FlexGrid } from '@mescius/wijmo.grid';
import { type MutableRefObject, useCallback } from 'react';

import type { EditTracker } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { DAY_WEEK, INPUT_VALUE_SET, LBL, MSG, WEEKDAY_CODE_TO_INDEX } from '../shipment-working-day-osp.constants';
import type { DynDayColumn, ShipmentWorkingDayOspRow } from '../shipment-working-day-osp.types';

interface Params {
  gridRef: MutableRefObject<FlexGrid<ShipmentWorkingDayOspRow> | undefined>;
  // 그리드 공용 EditTracker — 값입력으로 바뀐 셀도 저장 payload 단일 출처(부모 handleSave)에 올린다.
  editTrackerRef: MutableRefObject<EditTracker<ShipmentWorkingDayOspRow> | undefined>;
  // 동적 D_ 일자열(요일 포함) — 요일별 분기 대상 판정.
  dynColumns: DynDayColumn[];
  // 명시 조회 게이트 — 조회 전(persist 된 stale 화면) 값입력 금지(MSG00135).
  hasSearched: boolean;
  // 편집 권한(hasButton('EDIT')) — 없으면 D_ 셀이 잠겨 있으므로 무동작.
  canEdit: boolean;
  // cboDayWeek(WEEK_WORK_TIME) / cboInputValue(YesOrNo) — Form-local 드라이버.
  dayWeekCode: string;
  inputValue: string;
}

// btnInput(값입력) — AS-IS BtnInput_Click(.cs:684-809) 본문 1:1. ShipmentWorkingDayOsp.tsx 에 있던 handleInputValue 를
//   진입 Page ≤400 라인 규약(#9 components-folder, 게이트 R16)으로 2026-10-20 분리(본문 무변경 이식).
//   cboInputValue(Y/N)를 선택 D_ 셀에 일괄 써넣는다(03 §3-b SetText). SCP0019 대비 델타: 정수가 아니라 Y/N.
//   gridRef 를 부모가 보유하므로 imperative handle 없이 선택영역을 읽고 EditTracker 를 경유해 setCellData 로 write 한다
//   (저장 payload 는 EditTracker 단일 출처 그대로 도출).
//   가드 순서(AS-IS btnInput_Click): #1 조회 전(AS-IS MSG00135 → TO-BE MSG00662) → 편집권한 없음(AS-IS MSG00135 → TO-BE MSG01154)
//   → DayWeek 값 없으면 Form 이 버튼 disabled 로 차단(:710-713 return) → Input Value 미선택(MSG00429) → #4 SelectDay 셀 미선택
//   (AS-IS MSG00134 → TO-BE MSG01153). 코드 번호는 TO-BE SCM_ADM_MSG_M 실측(constants MSG 주석, 2026-10-20 정정).
//   일괄입력 3분기(03 §3-b): SelectDay=선택셀 / EveryDay=전체 D_ / 요일별=해당 weekday D_.
export const useShipmentWorkingDayOspInputValue = ({
  gridRef,
  editTrackerRef,
  dynColumns,
  hasSearched,
  canEdit,
  dayWeekCode,
  inputValue,
}: Params) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  return useCallback((): void => {
    // #1 조회 전 차단 — persist 된 stale 화면에 값입력 금지(AS-IS .cs:686-689 MSG00135 "수정모드가 아니므로…" = TO-BE MSG00662 "조회 후 수정모드로 가능합니다").
    if (!hasSearched) {
      void setAlert({ type: 'alert', content: t(MSG.NOT_SEARCHED, '_Edit mode is available after search.') });
      return;
    }
    // 편집 권한 없음 — 읽기전용 사용자는 D_ 셀이 잠겨 있다. AS-IS 는 같은 분기에서 MSG00135 를 띄우므로(무메시지 return 아님)
    //   TO-BE 원문 동일 코드 MSG01154 "수정모드가 아니므로 입력할 수 없습니다" 로 알린다(2026-10-20 정정, 원장 S96-11).
    if (!canEdit) {
      void setAlert({ type: 'alert', content: t(MSG.NOT_EDIT_MODE, '_Can not be entered as it is not in modify mode.') });
      return;
    }

    // 값 검증 — Input Value 는 Y/N 만(cboInputValue YesOrNo 소스라 정상경로는 항상 통과). 미선택('')·오염은 필수값 메시지
    //   MSG00429 "{0} 값은 필수 입력 항목입니다"({0}=Input Value 라벨). AS-IS 는 빈값을 그대로 SetText 했으나(.cs:696) 빈 Y/N 셀은
    //   SAVE SP 가 SHIPMENT_YN='' 로 적재하므로 TO-BE 는 선택을 요구한다(이전 MSG00050 은 TO-BE 미등록 코드였음).
    const raw = inputValue.trim().toUpperCase();
    if (!INPUT_VALUE_SET.includes(raw)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', t(LBL.INPUT_VALUE, '_Input Value')),
      });
      return;
    }

    const g = gridRef.current;
    if (!g) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Select a date and enter it.') });
      return;
    }
    const isSelectDay = dayWeekCode === DAY_WEEK.SELECT_DAY;
    const isEveryDay = dayWeekCode === DAY_WEEK.EVERY_DAY;
    // 요일별 분기 대상 weekday(0=일~6=토). EveryDay/SelectDay 면 미사용.
    const targetWeekday = WEEKDAY_CODE_TO_INDEX[dayWeekCode];

    // 대상 D_ 컬럼 판정 — SelectDay 는 선택영역만, 그 외는 요일 규칙(전행 × 규칙 D_ 컬럼).
    const dayByBinding = new Map<string, DynDayColumn>(dynColumns.map(d => [d.binding, d]));
    const tracker = editTrackerRef.current;
    let wrote = 0;

    const writeCell = (row: number, col: number): void => {
      const item = (g.rows[row] as { dataItem?: ShipmentWorkingDayOspRow } | undefined)?.dataItem;
      const binding = g.columns[col]?.binding ?? '';
      if (!item || !/^D_\d{8}$/.test(binding)) return;
      const original = g.getCellData(row, col, false) as WijmoPrimitive;
      g.setCellData(row, col, raw, true);
      tracker?.storeChange(item, binding, original, raw);
      wrote += 1;
    };

    if (isSelectDay) {
      // #3 SelectDay — 선택 셀에만. 선택영역의 D_ 셀만 write.
      const sel = g.selectedRanges;
      // #4 셀 미선택 — 선택영역이 없으면 대상 없음(AS-IS .cs:700-705 MSG00134 "날짜 선택 후 입력하세요" = TO-BE MSG01153 원문 동일).
      if (!sel || sel.length === 0) {
        void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Select a date and enter it.') });
        return;
      }
      for (const range of sel) {
        for (let row = range.topRow; row <= range.bottomRow; row++) {
          for (let col = range.leftCol; col <= range.rightCol; col++) writeCell(row, col);
        }
      }
    } else {
      // EveryDay=전체 D_ / 요일별=해당 weekday D_. 전행 × 규칙 D_ 컬럼.
      for (let row = 0; row < g.rows.length; row++) {
        for (let col = 0; col < g.columns.length; col++) {
          const binding = g.columns[col]?.binding ?? '';
          const dayCol = dayByBinding.get(binding);
          if (!dayCol) continue;
          if (!isEveryDay && dayCol.weekday !== targetWeekday) continue;
          writeCell(row, col);
        }
      }
    }

    if (wrote === 0) {
      // 선택영역에 D_ 일자 셀이 하나도 없음 — 같은 "날짜 선택 후 입력" 안내(MSG01153).
      void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Select a date and enter it.') });
      return;
    }
    g.invalidate(true);
  }, [hasSearched, canEdit, dayWeekCode, inputValue, dynColumns, gridRef, editTrackerRef, setAlert, t]);
};
