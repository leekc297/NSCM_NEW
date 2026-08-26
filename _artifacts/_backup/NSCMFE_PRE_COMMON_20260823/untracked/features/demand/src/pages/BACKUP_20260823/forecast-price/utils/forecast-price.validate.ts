import { isM4Locked, toNumber } from '../components/ForecastPriceGridUtils';
import { PRICE_MEASURES as PRICE_MEASURE_LIST } from '../forecast-price.constants';

import { duplicateKeyOf } from './forecast-price.save';
import { isAsFromSiteMissing } from './forecast-price.wsAuth';

/**
 * 저장 전 검증 — AS-IS fnValidation + SaveData 검증(.cs L2052~2075) 1:1.
 * 반환 = 통과 시 null / 실패 시 MSG 상수 키 (호출측이 setAlert).
 *
 * 주의: alert 문구는 다국어 MSG 원문만 노출한다 (2026-07-30 요청) — 걸린 행 식별자 등 부가 텍스트를
 *   덧붙이지 않는다. 따라서 반환도 코드 하나로 충분하다.
 */
export type SaveValidationError =
  | 'CURRENCY_REQUIRED' // Currency 값은 필수 입력 (PRICE 행 — MSG00429 {0}=Currency)
  | 'QTY_PRICE_REQUIRED' // 추가 행에 수량/가격 미입력 (MSG00670)
  | 'AS_FROM_SITE_REQUIRED' // 고객향 사이트 + AS/WS FcstType 인데 AS FROM SITE 공란 (MSG00476)
  | 'PLANT_SITE_REQUIRED' // 81 계열 신규행에 Plant Site 공란 (MSG00429 {0}=Plant Site)
  | 'DUP_NEW_ROW'; // 신규 행 중복 조합 (MSG00260)

/**
 * division 분기 검증 2종의 입력 컨텍스트.
 *   · V0   AS FROM SITE 필수 (현업 요청 2026-07-31 — 81 계열 + 82, W/S 조건부)
 *   · V0-2 Plant Site 필수  (현업 요청 2026-08-03 — 81 계열만, 무조건)
 *
 * 미지정 = 두 검증 모두 생략 — 콤보(FcstTypeWs / AS_FROM_SITE)가 아직 안 왔거나 division 을 아직
 * 모르는 상태에서 잘못된 차단이 나지 않도록 관대 통과한다 (mkt-fcst 도 조건 미충족 시 통과).
 * 주의: 운영 호출부(ForecastPrice.handleSave)는 항상 넘긴다 — 생략은 테스트/초기화 경로 전용이다.
 */
export interface SaveValidationContext {
  wsPlannerYn: boolean;
  divisionId: string;
  wsFcstTypes: ReadonlySet<string>;
  asSiteNames: ReadonlySet<string>;
}

/**
 * V0-2 Plant Site 필수 사업부 — 81 계열만 (mkt-fcst `requiresPlantSite` 1:1 —
 * AS-IS SetSaveData L4365 "40·82 은 해당없음", ValidationCheck L5227).
 * 주의: AS FROM SITE 게이트(wsAuth.isAsFromSiteDivision)는 81 계열 + 82 라 범위가 다르다.
 *   같은 "81 로 시작" 표현이라고 두 판정을 하나로 합치지 말 것.
 */
const requiresPlantSite = (divisionId: string): boolean => divisionId.trim().startsWith('81');

/** 셀 값 → 비교용 문자열. 파라미터를 WijmoPrimitive 로 좁혀 no-base-to-string 을 피한다. */
const str = (v: WijmoPrimitive | undefined): string => (v == null ? '' : String(v).trim());

const PRICE_MEASURES = new Set<string>(PRICE_MEASURE_LIST);

export const validateSaveRows = (
  gridRows: WijmoRowItem[],
  editableDayColumns: string[],
  m3CutoffYyyymm = '',
  ctx?: SaveValidationContext,
  // 조회 버킷('D'/'W'/'M') — M+4 판정 범위가 buildSaveRows 와 같아야 해서 함께 받는다
  //   (M+4 동결은 Monthly 한정 — 현업 검수 40번. ForecastPriceGridUtils.isM4Locked 주석 참조).
  bucketType = ''
): SaveValidationError | null => {
  const insertRows = gridRows.filter(r => r['CRUD_TYPE'] === 'I');

  // V0 — AS FROM SITE 필수 (MSG00476). 판정 규칙은 wsAuth.isAsFromSiteMissing 단일 출처.
  //   필수: Currency/수량 검증보다 앞에 둔다 — AS FROM SITE 는 SAVE SP 의 키 컬럼이라, 비어 있으면
  //     MERGE ON 절이 어긋난다(save.ts keyOf 주석). 값 검증보다 먼저 막는다.
  if (ctx) {
    for (const row of insertRows) {
      if (
        isAsFromSiteMissing({
          wsPlannerYn: ctx.wsPlannerYn,
          divisionId: ctx.divisionId,
          scmSiteId: str(row['SCM_SITE_ID']),
          fcstType: str(row['FCST_TYPE']),
          asFromSite: str(row['AS_FROM_SITE']),
          wsFcstTypes: ctx.wsFcstTypes,
          asSiteNames: ctx.asSiteNames,
        })
      ) {
        return 'AS_FROM_SITE_REQUIRED';
      }
    }
  }

  // V0-2 — Plant Site 필수 (MSG00429 {0}=Plant Site). 81 계열 신규행만 — 40·82 는 해당없음.
  //   V0 과 같은 이유로 값 검증(V1~)보다 앞에 둔다 — PLANT_SITE_ID 도 SAVE SP 의 키 컬럼이다.
  //   주의: V0 뒤에 두는 순서는 의도적이다 — 둘 다 공란인 행에서 기존 AS FROM SITE 안내 문구
  //     (MSG00476, 2026-07-31 요건)를 계속 먼저 보여주기 위함이다.
  if (ctx && requiresPlantSite(ctx.divisionId)) {
    for (const row of insertRows) {
      if (str(row['PLANT_SITE_ID']) === '') return 'PLANT_SITE_REQUIRED';
    }
  }

  // V1 — PRICE 행(LOC 계열) Insert 는 CURRENCY 필수 (AS-IS bInputCheck2).
  for (const row of insertRows) {
    const measure = String(row['MEASURE'] ?? '');
    if (PRICE_MEASURES.has(measure) && !String(row['CURRENCY'] ?? '').trim()) {
      return 'CURRENCY_REQUIRED';
    }
  }

  // V1-R — 역방향 (AS-IS `NO_DATA` 분기 이식, .cs L5639): PRICE 계열이 아닌데 CURRENCY 가 남아 있으면
  //   저장 전에 비운다. AS-IS 는 콤보를 빈 목록으로 교체해 입력 자체를 막으므로 이 상태가 생기지 않는다
  //   (측정 후 measure 를 바꾼 행에서 잔존 가능 — 원장 오염 방지용 정리).
  for (const row of insertRows) {
    const measure = String(row['MEASURE'] ?? '');
    if (!PRICE_MEASURES.has(measure) && String(row['CURRENCY'] ?? '').trim()) {
      row['CURRENCY'] = '';
    }
  }

  // V2 — Insert 행은 하루 이상 수량/가격 입력 (AS-IS MSG00449).
  //   판정 범위는 buildSaveRows 가 실제로 저장하는 일자와 같아야 한다. MKT/SCM/VMI 는 M+4
  //   동결 구간이 저장에서 빠지므로, 그 구간에만 값이 있는 신규행은 "입력 없음"으로 막는다.
  //   (범위가 어긋나면 검증은 통과하고 저장 rows 는 0건 — 사용자는 '저장 성공'을 보는데
  //    아무것도 안 들어간다.)
  for (const row of insertRows) {
    const measure = String(row['MEASURE'] ?? '');
    const hasValue = editableDayColumns.some(
      d => !isM4Locked(measure, d, m3CutoffYyyymm, bucketType) && toNumber(row[d]) !== 0
    );
    if (!hasValue) return 'QTY_PRICE_REQUIRED';
  }

  // V3 — 신규 행 키 중복 (MSG00260). 이 화면의 유일한 중복 방어선이다
  //   (2026-08-05 요청으로 ForecastPriceGrid 의 실시간 검사 + 값 롤백을 제거했다 —
  //    입력 도중 셀이 되돌려지는 동작이 편집 흐름을 끊는다는 현업 피드백).
  //
  //   비교 대상 = 화면 전 행 (기존 조회분 포함, 2026-08-12 정정). 신규행끼리만 보면 기존 조회행과
  //     키가 같은 신규행이 통과하고, 저장 시 DMF0082_SAVE_MAIN_DATA 의 MERGE 가 매치되어 기존 값을
  //     덮어쓴다. SP 는 이를 에러로 알리지 않는다 (MERGE USING 이 `... WHERE RN = 1` 로 중복분을
  //     조용히 버림) ⇒ 사용자는 '저장 성공' 을 보고 데이터를 잃는다.
  //     handleInsert 가 포커스 행의 키를 그대로 복제하므로 이것이 오히려 기본 시나리오다.
  //   주의: 'D'(삭제 마킹) 행은 비교에서 뺀다 — 사라질 행이라 중복이 아니고, 포함하면
  //     "지우고 같은 키로 다시 넣기" 가 막힌다.
  //   주의: 판정 대상은 신규행(I)뿐 — 기존 조회행끼리 키가 겹치는 건 사용자가 만든 상황이 아니므로
  //     저장을 막지 않는다. 그래서 `> 1` 판정을 신규행에만 건다.
  //   필수: 판정 키 = AS-IS 중복검증 컬럼셋(save.ts duplicateKeyOf — SAVE payload 키에서 파생).
  //     화면 전용 키 집합을 따로 두면 저장 키와 갈려 "저장은 충돌하는데 검사는 통과" 가 난다
  //     (2026-08-05 NICK_NAME 사고 — 컬럼 선정 근거는 duplicateKeyOf 주석이 단일 출처).
  //   필수: gridRows 는 필터와 무관한 화면 전 행이어야 한다 (호출측 handleSave 는 grid.rows 가
  //     아니라 상태의 gridRows 를 넘긴다 — 필터로 가려진 행과의 중복도 잡기 위함).
  const divisionId = ctx?.divisionId ?? '';
  const keyCounts = new Map<string, number>();
  for (const row of gridRows) {
    if (row['CRUD_TYPE'] === 'D') continue;
    const key = duplicateKeyOf(row, divisionId);
    keyCounts.set(key, (keyCounts.get(key) ?? 0) + 1);
  }
  for (const row of insertRows) {
    if ((keyCounts.get(duplicateKeyOf(row, divisionId)) ?? 0) > 1) return 'DUP_NEW_ROW';
  }

  return null;
};
