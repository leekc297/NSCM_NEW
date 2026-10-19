/**
 * TransMode 셀콤보 route 파생키 (갭항목 I04).
 *
 * AS-IS SpdDetail_CellClick(GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs L1974~1997)은
 * TRANSPORT_MODE 셀을 누르면 그 행의 route 로 콤보를 **행 단위 재조회**한다:
 *
 *   string sDivision  = GetValue(DIVISION_ID);
 *   string sFromSite  = GetValue(FROM_SITE);
 *   string sToSite    = GetValue(TO_SITE);
 *   string sIncoterms = GetValue(INCOTERMS);
 *
 *   if (sDivision == "EE")                                            // L1981~1982
 *       sDivision = GetValue(ORIGIN_FROM_DIVISION_ID);
 *   if (string.IsNullOrEmpty(sFromSite)) sFromSite = GetValue(FROM_SITE_DESCRIPTION);  // L1984
 *   if (string.IsNullOrEmpty(sToSite))   sToSite   = GetValue(TO_SITE_DESCRIPTION);    // L1985
 *
 *   dtTransMode = Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms);
 *   siDetail.SetCellTypeCombo(e.Row, TRANSPORT_MODE, dtTransMode);    // L1994 (활성 코드)
 *
 * 주의 — 자매 SSP0015 와 결론이 **반대**다. SSP0015 는 같은 블록이 전부 주석처리된 死코드라
 * 사용자 결정(2026-10-03)으로 TransMode 를 정적 콤보로 되돌렸다
 * (.atlas/gscm-design/SSP0015/output/ssp0015_transmode_static_combo.sql).
 * SSP0060 은 L1987/L1994 가 **활성**이므로 그 결정을 이식하면 안 된다 — 행 단위 재조회가 정답이다.
 *
 * TO-BE 구현 — 공용 DataGrid 의 행파라미터 콤보(ATTRIBUTE10='D' + ATTRIBUTE2 `행컬럼:바인드명`)를 쓴다.
 * 그런데 공용 훅은 **행 값을 그대로만** 실을 수 있어(packages/shared .../useRowParamCombos.ts 와
 * foundation `rowParamValues` — "실을 수 있는 것은 행 값뿐이다. PARAM2 는 행 컬럼만 선언한다")
 * 위 조건부 치환 3개를 메타로 표현할 수 없다. 그래서 **치환을 미리 끝낸 파생 속성**을 행에 심고
 * ATTRIBUTE2 가 그 파생 열을 가리키게 한다(같은 주석이 권하는 경로 — "행 컬럼으로도 존재하는 값이면
 * 그 컬럼을 PARAM2 에 적으면 된다"). 공용 패키지 변경 0 — CORE-05/CORE-06 경계 안이다.
 *
 * 파생 속성은 **non-enumerable** 로 심는다. PlanDetail 저장은 그리드 행 객체를 그대로
 * payload 로 넘기므로(ShipmentPlan.tsx `mutateConfirm(dirty)`), 열거 가능 속성으로 심으면
 * JSON.stringify 에 섞여 SAVE 38 IN 매핑에 없는 키가 올라간다. non-enumerable 이면
 * `row[binding]` 읽기는 되고 spread·JSON 직렬화에는 빠진다.
 */

/** ATTRIBUTE2 가 가리킬 파생 열 이름 — 메타(19/20_*.sql)와 **반드시** 같은 문자열이어야 한다. */
export const TRANS_MODE_ROUTE_KEY = {
  DIVISION_ID: 'TRANS_MODE_DIVISION_ID',
  FROM_SITE: 'TRANS_MODE_FROM_SITE',
  TO_SITE: 'TRANS_MODE_TO_SITE',
} as const;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** AS-IS L1981~1982 — 전극(EE) 행은 division 을 원산지 division 으로 바꿔 route 를 찾는다. */
const ELECTRODE_DIVISION = 'EE';

const defineHidden = (row: Record<string, unknown>, key: string, value: string): void => {
  Object.defineProperty(row, key, {
    value,
    enumerable: false, // 저장 payload·spread 에서 제외 (위 주석 참조)
    writable: true,
    configurable: true,
  });
};

/**
 * 한 행에 route 파생키 3개를 심는다(멱등 — 이미 있으면 값만 갱신).
 * DIVISION_ID/FROM_SITE/TO_SITE/INCOTERMS 는 편집 화이트리스트에 없어 조회 후 바뀌지 않으므로
 * 적재 시점 1회 계산으로 충분하다. 신규행(Insert/NEW)은 생성 직후 따로 불러 준다.
 */
export const applyTransModeRouteKeys = (row: Record<string, unknown>): void => {
  const divisionId = str(row.DIVISION_ID).trim();
  const fromSite = str(row.FROM_SITE).trim();
  const toSite = str(row.TO_SITE).trim();

  defineHidden(
    row,
    TRANS_MODE_ROUTE_KEY.DIVISION_ID,
    // 신규행은 ORIGIN_FROM_DIVISION_ID 를 복사받지 않는다(PLAN_DETAIL_INSERT_COPY_COLUMNS 에 없음).
    //   AS-IS 도 같은 상태에서 빈 값을 읽으므로 폴백으로 DIVISION_ID 를 쓰는 것이 파리티다.
    divisionId === ELECTRODE_DIVISION
      ? str(row.ORIGIN_FROM_DIVISION_ID).trim() || divisionId
      : divisionId
  );
  defineHidden(
    row,
    TRANS_MODE_ROUTE_KEY.FROM_SITE,
    fromSite || str(row.FROM_SITE_DESCRIPTION).trim()
  );
  defineHidden(row, TRANS_MODE_ROUTE_KEY.TO_SITE, toSite || str(row.TO_SITE_DESCRIPTION).trim());
};

/** 조회 결과 전 행에 파생키를 심고 같은 배열 참조를 돌려준다(행 객체를 교체하지 않는다 —
 *  EditTracker·wijmo CollectionView 가 들고 있는 참조를 깨면 편집 추적이 끊긴다). */
export const withTransModeRouteKeys = <T extends Record<string, unknown>>(rows: T[]): T[] => {
  rows.forEach(applyTransModeRouteKeys);
  return rows;
};
