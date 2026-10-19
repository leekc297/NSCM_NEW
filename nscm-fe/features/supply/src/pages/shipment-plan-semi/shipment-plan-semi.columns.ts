// 정보컬럼 constants fallback — admin SCM_MST_SHEET_COLUMNS 가 이미 등록돼 있으므로(design 03 §1,
//   27행 DB 실측 확인) 화면은 fetchStaticColumns 로 admin 메타를 우선 사용한다. 이 파일은 fetch
//   실패/지연 시의 최소 fallback 이며, 편집가능 여부(INPUT_TP_CD)는 전건 'S'(읽기전용) — 동적 pivot
//   컬럼만 편집대상(design 03 §0).
//   근거: .atlas/gscm-design/SCP0010/design/03_grid-columns.md §1 (DB 실측 27건 그대로).
import type { MainColumnMeta } from './shipment-plan-semi.types';

// ===== spdMain(단일 그리드) — SHEET_NAME='Shipment Plan SEMI' 27건 (design 03 §1) =====
//   division 조건부 visible(R-A, EE 계열 3건)은 utils/shipment-plan-semi.editLock.ts 의 runtime 파생.
export const MAIN_COLUMNS: MainColumnMeta[] = [
  { key: 'key_idx', header: 'KEY_IDX', width: 0, visible: false },
  { key: 'division_id', header: 'Division', width: 70, align: 'C' },
  { key: 'OPERATION_GROUP_DESC', header: 'Operation Group', width: 110, align: 'L' },
  { key: 'item_id', header: 'Model', width: 110, align: 'L' },
  { key: 'nick_name', header: 'Nick Name', width: 100, align: 'L' },
  { key: 'ELECTRODE_TYPE', header: 'Electrode Type', width: 100, align: 'L' }, // division EE* 만 표시(R-A)
  { key: 'ORIGIN_FROM_DIVISION_ID', header: 'Origin From Div', width: 90, align: 'C' }, // division EE* 만 표시(R-A)
  { key: 'FROM_SITE_DESCRIPTION', header: 'From Site', width: 120, align: 'L' },
  { key: 'boh', header: 'BOH (From Site)', width: 90, align: 'R' },
  { key: 'ORIGIN_TO_DIVISION_ID', header: 'Origin To Div', width: 90, align: 'C' }, // division EE* 만 표시(R-A)
  { key: 'T0_SITE_DESCRIPTION', header: 'To Site', width: 120, align: 'L' }, // 컬럼명 T0(영문 O가 숫자 0) AS-IS 그대로
  { key: 'transport_mode', header: 'Trans Mode', width: 90, align: 'L' },
  { key: 'lt_day', header: 'L/T(Day)', width: 70, align: 'R' },
  { key: 'measure_label', header: 'Measure', width: 130, align: 'L', frozen: true }, // FIXED — Freeze 경계 앵커
  { key: 'measure', header: 'Measure', width: 0, visible: false },
  { key: 'division_name', header: 'Div Name', width: 0, visible: false },
  { key: 'operation_group', header: 'Operation Group', width: 0, visible: false },
  { key: 'from_site', header: 'from_site', width: 0, visible: false },
  { key: 'to_site', header: 'to_site', width: 0, visible: false },
  { key: 'bod_id', header: 'BOD ID', width: 0, visible: false },
  { key: 'BOD_FROM_YYYYMMDD', header: 'BOD_FROM_YYYYMMDD', width: 0, visible: false },
  { key: 'BOD_TO_YYYYMMDD', header: 'BOD_TO_YYYYMMDD', width: 0, visible: false },
  { key: 'measure_order_no', header: 'MEASURE_ORDER_NO', width: 0, visible: false },
  { key: 'SHIP_FROZEN', header: 'SHIP_FROZEN', width: 0, visible: false },
  { key: 'from_yyyymmdd', header: 'from_yyyymmdd', width: 0, visible: false },
  { key: 'to_yyyymmdd', header: 'to_yyyymmdd', width: 0, visible: false },
  { key: 'Dept_Day', header: 'Dept_Day', width: 0, visible: false }, // 편집가능판정(R-K')·Weekly 자동분배(R-DeptDist) 내부용
];

// division EE*(Substring(0,2)==='EE') 조건부 표시 컬럼(design 03 §1 R-A, 3건)
export const DIVISION_EE_ONLY_COLUMNS = [
  'ELECTRODE_TYPE',
  'ORIGIN_FROM_DIVISION_ID',
  'ORIGIN_TO_DIVISION_ID',
] as const;
// Freeze 경계(SmartColMerge 병합 대상 = 이 컬럼까지, design 03 §3 R-I) — measure_label 포함 그 앞까지
export const FREEZE_ANCHOR_COLUMN = 'measure_label';
