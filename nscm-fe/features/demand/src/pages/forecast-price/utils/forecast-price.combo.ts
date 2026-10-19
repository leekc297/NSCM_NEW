/**
 * 콤보 파라미터 quoting — AS-IS `UP_FX_GetCommonDataList(_DM)` 의 PARAM1~5 대응 규약.
 *
 * ⚠️ BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 문자열 치환**한다(바인드 변수 아님).
 *   따옴표 없이 넘기면 생성 SQL 이 `SCM_SITE_ID = KRSL` 이 되어 ORA-00904(부적합한 식별자),
 *   숫자형 컬럼이면 ORA-01722 가 난다. 2026-08-08 사내 Oracle 실행으로 재현 확인.
 *   미전달 토큰은 BE 가 `''` 로 치환하므로, 값이 비면 `'ALL'`(관대형 SQL 의 전체 게이트)로 보낸다.
 *
 * 정본: `features/master/src/components/searchFields/SearchFields.tsx` q() /
 *       `pages/sales-plan/utils/sales-plan.comboContext.ts` quote()
 */
export const q = (value: string | undefined): string =>
  `'${(value && value.trim() !== '' ? value : 'ALL').replace(/'/g, "''")}'`;
