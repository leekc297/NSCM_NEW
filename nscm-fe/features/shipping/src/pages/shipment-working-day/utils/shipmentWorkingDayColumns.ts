import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';

import {
  DAY_BINDING_RE,
  DAY_CELL_DATA_MAP,
  DAY_COLUMN_WIDTH,
} from '../shipment-working-day.constants';
import type { CalendarColumnRow, DayColumn } from '../shipment-working-day.types';

// 3SPAN 응답에서 동적 일자 컬럼만 추린다.
//   SP 는 D_/W_/M_ 3블록을 SORT_ORDER_NO(접미 31/21/01) 순으로 섞어 내려주고, AS-IS 컬럼 생성
//   루프는 `if (sColumnName.IndexOf("D_") == -1) continue;`(.cs:253) 로 D_ 아닌 행을 전건 건너뛴다.
//   W_/M_ 이 컬럼이 되지 않으므로 헤더 드릴다운(.cs:834-861)은 사문이다 — 미이식(03 §1-b / R8).
export const toDayColumns = (rows: CalendarColumnRow[]): DayColumn[] =>
  (rows ?? [])
    .filter(r => DAY_BINDING_RE.test(String(r?.COLUMN_NAME ?? '')))
    .map(r => ({
      binding: String(r.COLUMN_NAME),
      dayLabel: String(r.COLUMN_LABEL_NAME ?? ''),
      weekLabel: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
      monthLabel: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
      // 주말 색 판정의 유일한 원천. AS-IS GetDayOfWeek 는 미매칭 시 NRE 였는데(.cs:824-830)
      //   여기서는 빈 문자로 방어한다(색만 기본색이 된다).
      dayCode: String(r.DAY_CODE ?? '').toUpperCase(),
    }));

// binding -> DAY_CODE 맵. formatItem 의 주말 헤더 색이 이 맵만 본다.
//   라벨 문자열 파싱이나 dayjs 요일 재계산으로 대체하지 않는다 — 서버 달력이 진실이다(03 §2-c).
export const toDayCodeMap = (dayColumns: DayColumn[]): Map<string, string> =>
  new Map(dayColumns.map(d => [d.binding, d.dayCode]));

// 3단 머지헤더(대=월 / 소=주차 / leaf=일) 컬럼 트리.
//   규칙 2가지를 지켜야 AS-IS span 과 같아진다(03 §2-b):
//   (1) 연속 run 기준 — AS-IS 는 값이 바뀌는 순간에만 span 을 마감하므로 같은 라벨이 떨어져
//       두 번 나오면 블록도 2개다. 전역 dedupe 하면 span 이 달라진다.
//   (2) 주차 그룹은 월 경계에서 강제 마감 — AS-IS 가 월 변경 시 1단과 2단 span 을 함께 닫는다
//       (.cs:272-285). 월을 걸치는 주(예 9/28~10/4)는 9월 블록과 10월 블록에 각각 1개씩 생긴다.
//       월 그룹 안에서만 주차를 매칭하므로 (2)는 구조적으로 보장된다.
export const buildDayColumnTree = (dayColumns: DayColumn[]): FlexGridColumnConfig[] => {
  if (dayColumns.length === 0) return [];

  interface WeekGroup {
    label: string;
    leafs: FlexGridColumnConfig[];
  }
  interface MonthGroup {
    label: string;
    weeks: WeekGroup[];
  }
  const months: MonthGroup[] = [];

  dayColumns.forEach(dc => {
    const leaf: FlexGridColumnConfig = {
      binding: dc.binding,
      header: dc.dayLabel || dc.binding.slice(2),
      align: 'center',
      width: DAY_COLUMN_WIDTH,
      allowDragging: false,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: true,
      // 컬럼은 편집형으로 선언하고 실제 가부는 beginningEdit 에서 canEdit 로 판정한다(hook #70).
      _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      _ctrlType: CELL_CONTROL_TYPE.COMBO,
      // 필수: 화면 주입형 dataMap 이므로 _ctrlData(cellCboDataTp)를 세팅하지 않는다.
      //   값이 남으면 공용 DataGrid 의 자동 콤보 조회가 이 dataMap 을 덮어쓴다.
      dataMap: [...DAY_CELL_DATA_MAP],
      _display: true,
    };

    let month = months[months.length - 1];
    if (!month || month.label !== dc.monthLabel) {
      month = { label: dc.monthLabel, weeks: [] };
      months.push(month);
    }
    let week = month.weeks[month.weeks.length - 1];
    if (!week || week.label !== dc.weekLabel) {
      week = { label: dc.weekLabel, leafs: [] };
      month.weeks.push(week);
    }
    week.leafs.push(leaf);
  });

  return months.map(m => ({
    header: m.label,
    align: 'center',
    columns: m.weeks.map(w => ({
      // 라벨이 비어도 헤더 행 자체는 살려 3단 구조를 유지한다(빈 문자열이면 span 이 접힌다).
      header: w.label || ' ',
      align: 'center',
      columns: w.leafs,
    })),
  }));
};
