import type { EditTracker } from '@foundation/utils';

import { isM4Locked, toNumber } from '../components/ForecastPriceGridUtils';

/**
 * DMF0082_SAVE_MAIN_DATA 저장 payload 구성 — AS-IS SaveData(.cs L2025~2160) 1:1.
 * 저장 단위 = (행 키 × D_ 일자) flat row. 17 IN 파라미터를 '^' bulk 로 연결
 * (SAVE SP 는 '^' 파싱 — 조회 멀티선택의 콤마와 다름).
 * 행 키 컬럼 = GT_DMF0082_MF_SP 실측 (PROJECT_CODE/PLANT_SITE_ID 포함).
 *
 * 2026-08-03 — Plant Site / AS FROM SITE 를 별도 파라미터로 분리 (mkt-fcst DMF0003 규약 정합).
 *   이전에는 SP 슬롯이 하나뿐이라 p_plant_site_id 에 AS_FROM_SITE 값을 실어 보냈다. BE 가
 *   p_as_from_site IN 을 추가하면서 각 컬럼이 제 슬롯으로 간다.
 *   주의: 배포 순서 — PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA 와 PROC_M 에 asFromSite 가 등록되기
 *     전에 이 코드가 나가면 AS_FROM_SITE 는 전달 경로를 잃고 p_plant_site_id 는 공란이 되어
 *     저장이 깨진다 (ORA-01400 / MERGE 미매치).
 *   참고: payload 는 key-value 라 SP 파라미터 순서와 무관하다 — BE makeProcedure 가 PROC_M 의
 *     COL_NM 으로 값을 찾는다 (BaseService L381). 순서 맞추기용 키 재배치는 불필요.
 */
export interface SaveRow {
  activeFlag: string; // I / M / D
  divisionId: string;
  projectCode: string;
  endCustomer: string;
  scmSiteId: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  measure: string;
  plantSite: string;
  asFromSite: string;
  cellProdSiteId: string;
  yyyymmdd: string;
  currency: string;
  qty: string;
}

const str = (v: unknown): string => {
  if (v === undefined || v === null) return '';
  return typeof v === 'string'
    ? v
    : typeof v === 'number' || typeof v === 'boolean'
      ? String(v)
      : '';
};

/**
 * 저장 키의 Project 코드.
 *
 * Division 40 은 Project 개념이 없어 원장(DM_PLN_CFM_MKT_DEMAND_PLAN)과 마스터(SCM_MST_SITE_ITEM) 모두
 * PROJECT_CODE 슬롯에 End Customer 코드를 넣는다 (AS-IS L761). 2026-10-13 개발 DB 실측: 40 원장
 * 284,147행 전부 PROJECT_CODE = END_CUSTOMER 로 예외가 없다.
 *
 * 40 화면에는 PROJECT_CODE 컬럼이 없다(컬럼 메타 DIVISION_ID 가 81·82 한정). 신규행은 시드 행의 값을
 * 숨은 채로 물려받고 End Customer 를 바꿔도 그 값이 따라오지 않아, 종전 `PROJECT_CODE || END_CUSTOMER`
 * 폴백은 시드가 '-' 인 행(INFAC_KR_JCH 등)에서 '-' 를 그대로 보냈다. 저장 SP 에 신규행 SSPM 4키
 * 검증이 들어오면서(E20261013-DMF0082SSPMNEW) 그 '-' 가 "등록되지 않은 조합" 으로 막혔다
 * (2026-10-13 11:08 로그: projectCode '-', endCustomer 'acer', acer_CN_CKG, MPPACERX481C).
 *
 * 그래서 40 은 Project 를 End Customer 키로 고정한다. 수정·삭제 행도 원장 규칙이 같으므로
 * MERGE/DELETE 키가 어긋나지 않는다. 비40 은 종전 그대로(Project 팝업 값, 비면 End Customer).
 */
const projectCodeOf = (item: WijmoRowItem, endCustomer: string): string =>
  str(item['DIVISION_ID']).trim() === '40'
    ? endCustomer
    : str(item['PROJECT_CODE'] || item['END_CUSTOMER']);

const keyOf = (item: WijmoRowItem): Omit<SaveRow, 'activeFlag' | 'yyyymmdd' | 'qty'> => {
  // ⭐ [ENDCUSTDISP 2026-08-18] 표시/키 분리 — 비40 조회행의 END_CUSTOMER 는 화면 표시용
  //   (사이트 파생, 조회조건 축)으로 교체되고 원장 키는 END_CUSTOMER_KEY 에 보존된다
  //   (ForecastPrice.tsx gridRows 변환). SAVE·중복키는 **반드시 KEY** — 원장 END_CUSTOMER 는
  //   DM_PLN_CFM_* PK 구성 컬럼이라 표시값으로 보내면 DELETE/MERGE 가 어긋나 중복 적재된다.
  //   'in' 검사인 이유: KEY='' (원장 빈값) 도 유효한 키라 || 폴백으로 덮으면 안 된다.
  //   신규행(I)은 KEY 가 없어 사용자가 고른 END_CUSTOMER 가 그대로 키가 된다(새 키 — 충돌 없음).
  const endCustomer =
    'END_CUSTOMER_KEY' in item ? str(item['END_CUSTOMER_KEY']) : str(item['END_CUSTOMER']);
  return {
    divisionId: str(item['DIVISION_ID']),
    projectCode: projectCodeOf(item, endCustomer),
    endCustomer,
    scmSiteId: str(item['SCM_SITE_ID']),
    itemId: str(item['ITEM_ID']),
    domExp: str(item['DOM_EXP']),
    fcstType: str(item['FCST_TYPE']),
    incoterms: str(item['INCOTERMS']),
    measure: str(item['MEASURE']),
    // 각 컬럼이 제 슬롯으로 (2026-08-03 — 그 전에는 p_plant_site_id 하나에 AS_FROM_SITE 를 실었다).
    //   PLANT_SITE_ID 는 81 계열 신규행의 필수 키 컬럼이고(validate.ts V0-2), 조회 커서에도 BE 가
    //   함께 추가한다. AS_FROM_SITE 는 기존대로 커서가 내려준다 (procedures.d.ts fcstNPrice).
    plantSite: str(item['PLANT_SITE_ID']),
    // 금지: '^' 를 넣지 말 것 — buildSavePayload 가 '^' 로 행을 잇는 bulk 라 값 안의 '^' 는 행 경계를
    //   깨뜨린다. 이 화면은 단건 그대로 보낸다.
    asFromSite: str(item['AS_FROM_SITE']),
    cellProdSiteId: str(item['CELL_PROD_SITE_ID']),
    currency: str(item['CURRENCY']),
  };
};

/**
 * 신규행 중복(MSG00260) 판정 키 — AS-IS 중복검증 컬럼셋 1:1. 유일한 사용처는
 *   `validate.ts validateSaveRows` V3 (저장 버튼).
 *
 * 근거: AS-IS `fnValidation L4892~4956` 비교 컬럼셋 —
 *   공통 Division / Project / ScmSite / Item / DomExp / FcstType / Incoterms / Measure
 *   + 81 계열만 PlantSite (82·40 제외) + AS_FROM_SITE([C20220328-000205] SetSaveData L4432/L5043).
 *   형제 화면 DMF0003 이 같은 루틴을 이식해 둔 `mkt-fcst.division.ts buildDuplicateKey` 와 동일 구성.
 *
 * 필수: 키는 `keyOf`(SAVE payload) 에서 파생한다 — 화면 전용 컬럼 목록을 따로 들고 있으면 저장 키와
 *   조용히 갈린다. 2026-08-05 사고가 정확히 그거였다: 중복키는 `NICK_NAME` 을 모델 축으로 썼는데
 *   SAVE 는 `ITEM_ID` 로 나갔고, NICK_NAME 은 `ForecastPrice.handleInsert` 의 시드 복사 대상이
 *   아니라 신규행에서 늘 공란 ⇒ 시드로 만든 행은 저장 키가 기존 행과 완전히 같은데도 중복검사를
 *   구조적으로 항상 통과했다. (AS-IS 도 복사 시 Nick Name 을 안 가져간다 — 실측 캡처 2026-08-05.)
 *
 * 제외 컬럼:
 *   · CURRENCY  : AS-IS 키에 없다. 통화는 식별자가 아니라 값이고, 가격 통화는 MEASURE 로 갈린다
 *                 (Unit Price(KRW)/(USD)/(LOC)).
 *   · NICK_NAME : 위 사고 참조 — 저장에 나가지도 않는 표시용 컬럼.
 * CELL_PROD_SITE_ID 는 포함한다 — AS-IS DMF0003 목록에 없는 이유는 그 화면에 컬럼 자체가 없어서이고,
 *   DMF0082 에서는 필수(Cell Prod Site*) 이자 SAVE payload 키다. 빼면 "Cell Prod Site 만 다른"
 *   정상 입력이 중복으로 잘못 차단된다.
 *
 * @param divisionId 행에 DIVISION_ID 가 없을 때의 폴백 (AS-IS `str(row.DIVISION_ID) || divisionId`).
 */
export const duplicateKeyOf = (item: WijmoRowItem, divisionId = ''): string => {
  const key = keyOf(item);
  const division = key.divisionId || divisionId;
  const parts = [
    division,
    key.projectCode,
    key.endCustomer,
    key.scmSiteId,
    key.itemId,
    key.domExp,
    key.fcstType,
    key.incoterms,
    key.measure,
    key.cellProdSiteId,
    // AS-IS 는 값이 있을 때만 덧붙이지만, 모든 행을 같은 방식으로 만들므로 항상 넣는 것과 동치다.
    key.asFromSite,
  ];
  // 81 계열만 PlantSite 를 키에 포함 (AS-IS L4907 / 82·40 은 L4913~4956 에서 제외).
  if (division.trim().startsWith('81')) parts.push(key.plantSite);
  // 필수: 구분자 — 없으면 ('AB','C') 와 ('A','BC') 가 같은 키로 이어붙어 오탐이 난다.
  return parts.map(part => part.trim()).join('|');
};

/**
 * 저장 대상 rows 수집:
 *  - CRUD_TYPE='I' (신규): 편집가능 D_ 일자 중 값이 있는 셀 전량 → 'I'
 *  - CRUD_TYPE='M' (수정): tracker 변경분 중 D_ binding 만 → 'M'
 *  - CRUD_TYPE='D' (삭제): 편집가능 D_ 일자 전량 0 → 'D' (AS-IS DeleteButton — 계획구간만)
 *
 * editableDayColumns 는 기준주차(금주 월요일) 경계만 반영한 measure 무관 목록이다.
 *   Monthly 조회의 MKT/SCM/VMI 는 그 위에 M+4 동결이 더 걸리므로 행 measure 로 한 번 더 걸러낸다.
 *   특히 Delete('D')는 값 유무와 무관하게 편집가능 일자 전량에 0 을 쓰기 때문에, 필터가 없으면
 *   셀 편집을 막아둔 동결 구간(M+0~M+3) 실적을 0 으로 지운다.
 *
 * @param bucketType 조회 버킷('D'/'W'/'M'). 셀 편집 판정과 같은 값을 넘겨야 한다 — M+4 동결은
 *   Monthly 조회 한정이라(현업 검수 40번, isM4Locked 주석) 여기서 빠뜨리면 Weekly/Daily 는
 *   화면에선 입력되는데 저장 rows 에서 잘려 "저장 성공인데 안 들어가는" 상태가 된다.
 */
export const buildSaveRows = (
  gridRows: WijmoRowItem[],
  tracker: EditTracker,
  editableDayColumns: string[],
  m3CutoffYyyymm = '',
  bucketType = ''
): SaveRow[] => {
  const rows: SaveRow[] = [];
  const changed = tracker.getOriginalValues();

  for (const item of gridRows) {
    const crud = item['CRUD_TYPE'];
    const measure = str(item['MEASURE']);
    const days = editableDayColumns.filter(
      d => !isM4Locked(measure, d, m3CutoffYyyymm, bucketType)
    );
    if (crud === 'I') {
      const base = keyOf(item);
      days.forEach(d => {
        const qty = toNumber(item[d]);
        if (qty !== 0) {
          rows.push({ activeFlag: 'I', ...base, yyyymmdd: d.replace('D_', ''), qty: String(qty) });
        }
      });
    } else if (crud === 'D') {
      const base = keyOf(item);
      days.forEach(d => {
        rows.push({ activeFlag: 'D', ...base, yyyymmdd: d.replace('D_', ''), qty: '0' });
      });
    } else if (crud === 'M') {
      const base = keyOf(item);
      const bindings = changed.get(item);
      if (!bindings) continue;
      Object.keys(bindings).forEach(binding => {
        if (!binding.startsWith('D_')) return; // M_/W_ 편집은 배분으로 D_ 에 반영됨 — D_ 만 저장
        // 셀 편집 단계에서 이미 막히지만, cutoff 가 늦게 도착한 뒤 남은 변경분이 새는 것을 막는다.
        if (isM4Locked(measure, binding, m3CutoffYyyymm, bucketType)) return;
        rows.push({
          activeFlag: 'M',
          ...base,
          yyyymmdd: binding.replace('D_', ''),
          qty: String(toNumber(item[binding])),
        });
      });
    }
  }
  return rows;
};

/** 17 IN '^' bulk payload (PROC_M COL_NM 기준 — 키 이름 매칭이라 나열 순서는 무관). */
export const buildSavePayload = (rows: SaveRow[], userId: string): Record<string, string> => ({
  activeFlag: rows.map(r => r.activeFlag).join('^'),
  divisionId: rows.map(r => r.divisionId).join('^'),
  projectCode: rows.map(r => r.projectCode).join('^'),
  endCustomer: rows.map(r => r.endCustomer).join('^'),
  scmSiteId: rows.map(r => r.scmSiteId).join('^'),
  itemId: rows.map(r => r.itemId).join('^'),
  domExp: rows.map(r => r.domExp).join('^'),
  fcstType: rows.map(r => r.fcstType).join('^'),
  incoterms: rows.map(r => r.incoterms).join('^'),
  measure: rows.map(r => r.measure).join('^'),
  plantSite: rows.map(r => r.plantSite).join('^'),
  asFromSite: rows.map(r => r.asFromSite).join('^'),
  cellProdSiteId: rows.map(r => r.cellProdSiteId).join('^'),
  yyyymmdd: rows.map(r => r.yyyymmdd).join('^'),
  currency: rows.map(r => r.currency).join('^'),
  qty: rows.map(r => r.qty).join('^'),
  createdBy: rows.map(() => userId).join('^'),
});
