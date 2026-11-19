import dayjs from '@foundation/dayjs';

import type { DynColumnMeta, DynDayColumn, DynSumColumn } from './shipment-working-day-osp.types';

// GET SP O_RC1(PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP) 데이터 커서의 동적 기간 컬럼을
//   골라 3단 머지헤더(대 월 / 소 주차 / 일) 파생물과 SUM 열(W_/M_) 목록을 만든다.
//   근거(03_grid-columns §1-b): SP 는 PIVOT 으로 D_yyyymmdd(일별 Y/N), W_yyyyww(주 SUM), M_yyyymm(월 SUM),
//   B_(hidden 태그) 컬럼을 만든다. 3SPAN(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)이 헤더 그룹의
//   원천이나 요일/주차 그룹 span 은 커서에 없으므로 SCP0019 와 동일하게 yyyymmdd 로 클라 파싱해 재현한다.
//   입력(columnMeta)은 CALENDAR(3SPAN) o_rc1 의 COLUMN_NAME 목록({name}) — SORT_ORDER_NO 순서 보존.

// 동적 컬럼 alias 규칙 — SP PIVOT alias. 정적 6컬럼과 구분.
const DAY_COLUMN_PATTERN = /^D_(\d{8})$/; //  일별 Y/N (편집 셀콤보)
const WEEK_SUM_PATTERN = /^W_(\d+)$/; //      주 SUM (잠금)
const MONTH_SUM_PATTERN = /^M_(\d{6})$/; //   월 SUM (잠금)
// B_ 은 hidden 태그(AddTextColumn w0) — 파생 대상 아님(그리드에서 숨김). 여기선 무시.

// 8자리 yyyymmdd → 하이픈 ISO. customParseFormat plugin 미등록 환경 대응(SCP0019 동일 규약).
const toIso = (yyyymmdd: string): string =>
  `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}-${yyyymmdd.slice(6, 8)}`;

// D_ 일자열 → 3단 머지헤더(월/주차/일) 파생. 월/주차 그룹·라벨은 3SPAN SP 라벨이 정본이다.
//   AS-IS InitSpreadDateColumn(SCP0096.cs:183-244)은 SMALL/LARGE_CLASS_LABEL_NAME 이 바뀌는 지점에서
//   주·월 span 을 끊고 그 라벨을 헤더에 그대로 쓴다 — 1:1 재현. SP 는 SCM_SYS_CALENDAR_M 의 ISO 주차
//   (예 'W48', 월요일 시작·연중 연속)를 WEEK_NAME 으로 내려주므로, 월 내 Math.ceil(day/7) 재계산
//   (W1·W2 가 매월 재시작 + 주 시작요일을 월1일 기준 7일블록으로 무시하던 결함)을 폐기한다.
//   라벨이 없을 때(비정상 응답)만 yyyymmdd 로 폴백한다 — 단정 금지.
export const buildDynDayColumns = (columnMeta: DynColumnMeta[]): DynDayColumn[] => {
  const out: DynDayColumn[] = [];
  for (const col of columnMeta) {
    const match = DAY_COLUMN_PATTERN.exec(col.name ?? '');
    if (!match) continue;
    const yyyymmdd = match[1];
    const d = dayjs(toIso(yyyymmdd));
    // 파싱 불가(비정상 alias)면 건너뛴다 — 단정 금지, 미발견 처리.
    if (!d.isValid()) continue;
    // 월 라벨 = SP LARGE_CLASS_LABEL_NAME('2026-11'). 폴백은 yyyymm 를 하이픈 ISO 로.
    const monthKey = col.monthName?.trim() || `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}`;
    // 주차 라벨 = SP SMALL_CLASS_LABEL_NAME('W48', ISO 주차). 폴백은 기존 월내 주차(결함 재현 아님, 최후수단).
    const weekLabel = col.weekName?.trim() || `W${Math.ceil(Number(yyyymmdd.slice(6, 8)) / 7)}`;
    out.push({
      binding: col.name,
      yyyymmdd,
      dayLabel: String(d.date()), // 일(DD, 앞 0 제거) — leaf 헤더
      weekday: d.day(), //           0=일 ~ 6=토 — 요일색·btnInput 요일별 분기
      monthKey, //                   대(월) 그룹 — 3단 머지헤더 상단(SP 라벨)
      // 월경계를 넘는 ISO 주(예 W49 가 11월말·12월초에 걸침)는 월별로 분리해야 월→주 중첩이 성립한다
      //   → 월 라벨을 접두해 그룹 키를 유일화한다(표시 라벨은 weekLabel 그대로).
      weekKey: `${monthKey}/${weekLabel}`,
      weekLabel,
    });
  }
  return out;
};

// W_/M_ SUM 열 목록 — chkSum 토글 대상. 03 §1-b: W_=주 SUM(잠금) / M_=월 SUM(잠금).
export const buildDynSumColumns = (columnMeta: DynColumnMeta[]): DynSumColumn[] => {
  const out: DynSumColumn[] = [];
  for (const col of columnMeta) {
    const name = col.name ?? '';
    if (WEEK_SUM_PATTERN.test(name)) {
      out.push({ binding: name, kind: 'W', header: name.replace(/^W_/, '') });
    } else if (MONTH_SUM_PATTERN.test(name)) {
      const ym = name.replace(/^M_/, '');
      out.push({ binding: name, kind: 'M', header: `${ym.slice(0, 4)}-${ym.slice(4, 6)}` });
    }
  }
  return out;
};
