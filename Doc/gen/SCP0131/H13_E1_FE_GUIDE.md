# SCP0131 Sales Site Priority — FE 보완 가이드 (DB MODE · 직접 수정 안 함) · 2026-11-07

## 1. H13 Priority 음수 글자색 빨강 (CheckList v6 조치필요 V-e5dd5abc)
- 실측(E2E 11-07 04:14): PRIO_RANK r0 값 '-1' 글자색 rgb(0,0,0) — 음수가 빨강이 아님
- AS-IS: SHEET_COLUMNS PRIO_RANK CELL=FPNumber → SpreadInfo NumberCellType 기본 `NegativeRed=true`
- TO-BE 위치: `nscm-fe/features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx:105` `<DataGrid<SalesSitePriorityRow> …>` — formatItem 배선 없음
- 변경(형제 화면과 같은 배선 — `nscm-fe/features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx:1706-1709`, 정본 `@foundation/utils` `paintNegativeText` · `gridNegativeText.ts:38`)
  ```ts
  import { paintNegativeText, toGridNumber } from '@foundation/utils';
  // 그리드 initialized/ref 획득 뒤 1회
  grid.formatItem.addHandler((_s, e) => {
    if (e.panel !== grid.cells) return;
    const binding = grid.columns[e.col]?.binding;
    if (binding !== 'PRIO_RANK') return;
    const item = grid.rows[e.row]?.dataItem as SalesSitePriorityRow | undefined;
    paintNegativeText(e.cell, toGridNumber(item?.PRIO_RANK)); // 비음수는 helper 가 색을 지운다(셀 DOM 재활용 잔상 방지)
  });
  ```
  - 이유: 공용 DataGrid 는 음수색을 기본으로 칠하지 않는다(공용 기본 변경 금지) → 화면 배선. 공용 `paintNegativeText` 를 쓰면 다른 화면과 같은 색·규약.
- 검증: 행 PRIO_RANK 에 -1 입력 → 글자색 빨강 · 양수로 되돌리면 검정 · CheckList H13 행 재측정 PASS.

## 2. E1 Priority 소수 입력 허용 (V-637991ac) — DB 메타 적용(07:40:05) → **원복(14:18:13)** · FE 가이드로 전환
- 실측: '1.5' 입력 → '1.5' 그대로. AS-IS cell_rules: 정수만(DecimalPlaces 0).
- 원인: 공용 `nscm-fe/packages/foundation/src/utils/columnMapping.ts:94-101` — 메타 `DATA_SCALE_NUMBER` NULL 이면 "제한 없는 기본 편집기", 0 이면 InputNumber(n0). AS-IS 메타도 NULL 이지만 AS-IS 프레임워크 기본값이 0.
- 07:40 DB 메타 NULL→0 적용 결과(chain6b CheckList v7 · 11:28 실측): **신규행 r0 PRIO_RANK 편집 시작 시 "Assertion failed in Wijmo: Number expected"** (D1 V-90126e36 FAIL · 컬럼 프로브 테스트 중단 → E7/E1/H13 ERROR). 화면 `utils/sales-site-priority.editLock.ts:43` 신규행 기본값 `PRIO_RANK: ''`(문자열) 이 InputNumber 편집기와 충돌. → 14:18:13 메타를 NULL 로 원복(`_artifacts/_apply_corporate/SCP0131_PRIO_RANK_SCALE_20261107/revert_meta_scale.py` · APPLIED_OPERATIONS.md) · 클라우드 패키지 `SCP0131_CLOUD_DB_MOD_20261107_1421`(메타 변경 없음 · 0740 패키지 폐기).
- 변경(FE · 두 가지를 함께 적용해야 한다):
  1. `utils/sales-site-priority.editLock.ts:43` `PRIO_RANK: ''` → `PRIO_RANK: null` (신규행 기본값을 숫자 아님 빈값으로 — InputNumber 는 null 허용 · saveRequest `safeString(r.PRIO_RANK)` 는 null→'' 로 그대로 직렬화)
  2. FE 배포 뒤 메타 `DATA_SCALE_NUMBER` 0 재적용(`apply_meta_scale.py`) — 그래야 '1.5' 가 막힌다. 같은 구조의 SCP0127 TYPE_APPLY_DAY(메타 0 · editLock 기본값 '')는 이번 실행에서 프로브가 통과했으므로 신규행 편집 시작 재현 여부를 먼저 실측(차이 원인 미확인).
- 검증: 신규행 PRIO_RANK 편집기 열림(오류 없음) · '1.5' 거부 · '-1' 거부(§1 음수색과 별개 · AS-IS 최소 1) · CheckList D1·E1·H13 행 재측정.

## 3. E7 Model 셀 잘못된 값 저장 — DB 보완 완료(07:38:34)
- PKG_SCP0131.P_SCP0131_SAVE_SALES_SITE_PRIORITY 에 품목 유효성(SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM) 검증 추가 → ORA-20010 'MODEL: … 유효하지 않은 모델입니다!'(MSG00458)
- FE `utils/salesSitePriority.saveRequest.ts:76-93` 는 o_result_cursor RESULT_CODE≠'0' 을 실패로 읽어 메시지를 띄운다 → FE 추가 수정 불필요(SCP0127 과 다름). AS-IS 처럼 저장 전 FE 사전 검증(MSG00458)을 원하면 SEARCH_INFO o_rc6 품목 집합 대조를 `SalesSitePriorityForm.tsx` 저장 전 검증에 추가.
