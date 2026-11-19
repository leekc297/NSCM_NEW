import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import { isFixedColumnVisible, isPivotColumn } from './integrationPsiEditLock';

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Integration PSI' 24행) 등록본이 유일 원천(design 03 §1).
//   하드코딩 fallback 없음 — 미등록 시 빈 배열(store 규약). 여기선 VISIBLE=N(MEASURE_COLOR/MEASURE_ORDER_NO)
//   상시 숨김 + 편집 권한 전용 4열(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE)만 런타임 가시성 override 로 적용한다.
//   주의(속성 단위 덮어쓰기 금지): admin VISIBLE_FLAG 은 그대로 두고(baseVisible), 조건 가시성만 AND 로 좁힌다.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  canEdit: boolean
): RawFlexGridColumnConfig[] => {
  const base = adminCols ?? [];
  return base.map(c => ({
    ...c,
    visible: isFixedColumnVisible(c.colNm, c.visible !== false, canEdit),
  }));
};

// 고정 컬럼 바인딩 집합 — pivot(YYYYMM) 판정 기준. admin 메타 colNm 전체가 고정 컬럼.
export const fixedBindingSet = (
  adminCols: RawFlexGridColumnConfig[] | undefined
): ReadonlySet<string> => new Set((adminCols ?? []).map(c => c.colNm));

// 조회기간(From~To) YYYYMM 열거 — AS-IS SetCalendar(cs:340~356)가 `Data.Type.CalendarMonth` 로 돌린
//   월 목록과 같다. DB 산술 대신 FE 산술로 뽑는 근거: `scm_sys_calendar_m` 의 basis_yyyymm 은 구간 내
//   **결번이 없다**(실측 202609~202712 → DISTINCT 16개월 = 달 수와 일치) → 연속 월 증가와 동일하다.
//   from/to 가 YYYYMM 6자리가 아니거나 from > to 면 빈 배열(컬럼 미생성).
export const periodMonthRange = (from: string, to: string): string[] => {
  if (!/^\d{6}$/.test(from) || !/^\d{6}$/.test(to) || from > to) return [];
  const out: string[] = [];
  let y = Number(from.slice(0, 4));
  let m = Number(from.slice(4, 6));
  if (m < 1 || m > 12) return [];
  // 상한 가드 — 비정상 입력으로 무한 루프/수천 컬럼이 되는 것을 막는다(AS-IS 기본 6개월, HORIZON 최대 12개월대).
  for (let guard = 0; guard < 120; guard++) {
    const code = `${y}${String(m).padStart(2, '0')}`;
    out.push(code);
    if (code >= to) break;
    m += 1;
    if (m > 12) {
      m = 1;
      y += 1;
    }
  }
  return out;
};

// 동적 pivot 컬럼 빌드 — 월(yyyy-MM) 1단 헤더로 렌더한다(design 03 §2-C — 고정 base 20열 이후는 전부 YYYYMM pivot).
//   AS-IS FpSpread 의 D_/W_/M_ 3단은 로컬 pivot 이고 TO-BE 는 서버가 월단위로 집계해 내려주므로 월 컬럼만 생성.
//
//   컬럼 원천은 **조회기간(periodMonths) ∪ 조회결과 행의 YYYYMM 키** 다.
//   - periodMonths 를 넣는 이유: AS-IS 는 `Form_Load → CreateSpread → InitSpread → SetCalendar`(cs:174/303/334)
//     로 **데이터와 무관하게** From/To 월 컬럼을 먼저 만들고, PlanDate 변경(cs:1862)·조회(cs:853) 때마다
//     `InitSpread` 로 재생성한다. 즉 조회 전에도 기간 컬럼이 보인다. 행에서만 유도하면 조회 전 그리드가
//     고정 컬럼만 남아 AS-IS 와 다르다(사용자 신고 2026-10-12).
//   - 행 키를 함께 union 하는 이유: 사용자가 조회 후 기간을 좁히면 응답에 있는 월이 컬럼을 잃어
//     데이터가 보이지 않게 된다. union 은 그 데이터 은폐를 막는다.
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  fixedBindings: ReadonlySet<string>,
  periodMonths: readonly string[] = []
): FlexGridColumnConfig[] => {
  // 조회기간 월 — 고정 컬럼과 충돌하는 이름은 제외(pivot 판정 동일 기준).
  const bindings = new Set<string>(
    periodMonths.filter(m => isPivotColumn(m, fixedBindings))
  );

  // 행 union 에서 YYYYMM pivot 바인딩만 추출(고정 컬럼 제외).
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (isPivotColumn(k, fixedBindings)) bindings.add(k);
    }
  }
  if (bindings.size === 0) return [];

  return [...bindings]
    .sort()
    .map<FlexGridColumnConfig>(binding => ({
      binding,
      header: `${binding.slice(0, 4)}-${binding.slice(4, 6)}`,
      align: 'right',
      format: 'n0', // QTY = 정수(design 03 §4.1). 소수 measure 없음.
      width: 75, // AS-IS AddNumColumn width 75 (design 03 §2-A cs:354)
      allowMerging: false, // pivot 컬럼은 병합 대상 아님(고정 식별열만 병합)
      allowSorting: false,
      allowResizing: true,
      visible: true,
      // 컬럼 레벨은 **편집 허용**(OPTIONAL)로 두고, 실제 잠금은 그리드 beginningEdit 의 L2~L23 규칙
      //   (isPivotCellLocked)이 행 단위로 판정한다(design 03 §3-Lock).
      //
      //   종전에는 여기가 SEARCH_ONLY 였고 "편집가능 셀은 beginningEdit 가 명시 해제" 라고 적혀 있었다.
      //   그건 **불가능**하다 — 공용 DataGrid 가 `setEditableColumns`(dataGridUtils.ts:371~393)에서
      //   beginningEdit 에 먼저 핸들러를 걸고 `cancel = !GridUtils.isEditableCell(...)` 을 세우는데,
      //   isEditableCell 은 SEARCH_ONLY 를 무조건 false 로 돌린다(gridUtils.ts:95~101).
      //   wijmo Event 는 등록 순서대로 호출하고(DataGrid.tsx:1527 주석) 화면 핸들러는 cancel 을
      //   true 로만 세우므로, 한번 cancel 된 편집은 되살아나지 않는다 → **모든 기간셀이 편집 불가**였다
      //   (사용자 신고 2026-10-13 "값이 수정이 안 된다").
      //
      //   OPTIONAL 이 통과하는 근거: isEditableCell 의 OPTIONAL 분기는 `editFlag !== 'N'` 인데
      //   GET SP 는 EDIT_FLAG 를 반환하지 않는다(PKG_SCP0111 전문에 EDIT_FLAG 0건, 2026-10-13 ora.py 실측)
      //   → undefined !== 'N' → true.
      _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      _dynamic: true,
    }));
};
