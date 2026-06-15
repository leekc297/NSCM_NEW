import dayjs from 'dayjs';

import { useMessageStore } from '@shared/stores';

import { DIVISION, MSG } from '../sales-plan.constants';
import type { SearchCondition, SalesPlanRow, ValidationResult } from '../sales-plan.types';

// AS-IS DMF0021_SalesPlan.cs validation.md 141 건 정밀 매핑 (Option A 정정 2026-06-09):
//   - 사업부 분기 73 (40/81/82 별 컬럼 표시·lock·필수 분기)
//   - 필수값 39 (DIVISION/SCM_SITE/ITEM/MEASURE/CURRENCY 공통 + 사업부 분기 추가)
//   - 기타 29 (concurrency/기간/silent guard 등)
//
// SaveData L2198~2236 정밀 매핑:
//   공통:        DIVISION_ID + SCM_SITE_ID + ITEM_ID + MEASURE + CURRENCY
//   40 사업부:   END_CUSTOMER40 + CELL_PROD_SITE_ID
//   40 + Catch_Up:   DomExp + FcstType + INCOTERMS  (DEPT_ID 불필요)
//   40 + Catch_Up 외: DEPT_ID
//   40 외:       PROJECT_CODE + END_CUSTOMER
//   81 사업부:   TEXT
//
// FindData L1450~1515:
//   blnWork (MSG00137 — 동시 실행 차단)
//   기간 역전 sPeriod[0] > sPeriod[1] (MSG00108)
//   기간 3년 초과 drpPeriod.Value1.AddYears(3) < Value2 (MSG00164)
//   Division 필수 (MSG00097)
export const useSalesPlanValidation = () => {
  const setAlert = useMessageStore.getState().setAlert;

  // F5 Search 검증 (AS-IS FindData L1450~1515)
  const validateFind = (sc: SearchCondition): ValidationResult => {
    if (!sc.divisionId || sc.divisionId === '') {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRE_DIVISION}] Division 을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    const start = dayjs(sc.startYyyymmdd, 'YYYYMMDD');
    const end = dayjs(sc.endYyyymmdd, 'YYYYMMDD');
    if (!start.isValid() || !end.isValid()) {
      void setAlert({ type: 'alert', content: '유효한 날짜를 입력하세요.' });
      return { ok: false };
    }
    if (start.isAfter(end)) {
      void setAlert({ type: 'alert', content: `[${MSG.NO_DATA}] 시작일자가 종료일자보다 늦을 수 없습니다.` });
      return { ok: false, msgId: MSG.NO_DATA };
    }
    // AS-IS L1479 AddYears(3) — 3년 초과 차단 (분석서의 "2년" 은 오기, 실제 코드는 3년)
    if (start.add(3, 'year').isBefore(end)) {
      void setAlert({ type: 'alert', content: `[${MSG.PERIOD_OVER_3YEARS}] 조회 기간은 최대 3년까지 가능합니다.` });
      return { ok: false, msgId: MSG.PERIOD_OVER_3YEARS };
    }
    return { ok: true };
  };

  // F7 Save 검증 (AS-IS SaveData L1922~2272 + fnValidation L4150~4263) — 사업부 분기 정밀
  //   누적 sMsg → MSG00002 ([{}] 은 필수 입력사항입니다)
  //   중복 PK 검증은 BE SP 안 처리 (AS-IS L2249 주석: 'SP 에서 수행')
  const validateSaveRows = (rows: SalesPlanRow[]): ValidationResult => {
    if (!rows || rows.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRED_COLUMN}] 저장할 데이터가 없습니다.` });
      return { ok: false, msgId: MSG.REQUIRED_COLUMN };
    }

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i] as Record<string, unknown>;
      if (row.CRUD_TYPE === 'D' || row.EDIT_FLAG === 'D') continue;  // Delete 행은 검증 skip
      if (row.CRUD_TYPE !== 'I' && row.CRUD_TYPE !== 'U' && row.CRUD_TYPE !== 'M') continue;

      const div = String(row.DIVISION_ID ?? '');
      const measure = String(row.MEASURE ?? '');
      const isCatchUp = measure === 'Catch_Up';
      const is40 = div === DIVISION.MOBILITY;
      const is81 = div.startsWith(DIVISION.ESS);
      const is82 = div === DIVISION.POWER;
      void is82;  // reserved

      // 누적 sMsg (AS-IS L2210~2236)
      const missing: string[] = [];

      // ===== 공통 필수 (AS-IS L2198~2207) =====
      if (!div) missing.push('Division');
      if (!row.SCM_SITE_ID || row.SCM_SITE_ID === '') missing.push('Sales_Site');
      if (!row.ITEM_ID || row.ITEM_ID === '') missing.push('Model');
      if (!measure) missing.push('Measure');
      if (!row.CURRENCY || row.CURRENCY === '') missing.push('Currency');

      // ===== 40 사업부 외 — PROJECT_CODE 필수 (L2198) =====
      if (!is40 && (!row.PROJECT_CODE || row.PROJECT_CODE === '')) missing.push('Project Code');

      // ===== 40 사업부 — END_CUSTOMER40 필수 (L2199) =====
      if (is40 && (!row.END_CUSTOMER40 || row.END_CUSTOMER40 === '')) missing.push('END_CUSTOMER');

      // ===== 40 사업부 — Catch_Up 외 Measure 일 때 DEPT_ID 필수 (L2200) =====
      if (is40 && !isCatchUp && (!row.DEPT_ID || row.DEPT_ID === '')) missing.push('TEAM');

      // ===== 81 사업부 — TEXT 필수 (L2201) =====
      if (is81 && (!row.TEXT || row.TEXT === '')) missing.push('TEXT');

      // ===== 40 사업부 + Catch_Up — DomExp/FcstType/INCOTERMS 필수 (L2204~2206) =====
      if (is40 && isCatchUp) {
        if (!row.DOM_EXP || row.DOM_EXP === '') missing.push('Customer Handbook');
        if (!row.FCST_TYPE || row.FCST_TYPE === '') missing.push('FcstType');
        if (!row.INCOTERMS || row.INCOTERMS === '') missing.push('INCOTERMS');
      }

      // ===== 40 사업부 — CELL_PROD_SITE_ID 필수 (PJ2025-50017, L2207) =====
      if (is40 && (!row.CELL_PROD_SITE_ID || row.CELL_PROD_SITE_ID === '')) missing.push('CellProdSiteID');

      if (missing.length > 0) {
        void setAlert({
          type: 'alert',
          content: `[${MSG.REQUIRED_FIELD}] [${missing.join(', ')}] 은 필수 입력사항입니다. 다시한번 확인해주세요. (행 ${i + 1})`,
        });
        return { ok: false, msgId: MSG.REQUIRED_FIELD, detail: missing.join(',') };
      }
    }

    return { ok: true };
  };

  // F9 Delete 검증
  const validateDelete = (selected: SalesPlanRow[]): ValidationResult => {
    if (!selected || selected.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRED_COLUMN}] 삭제할 행을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRED_COLUMN };
    }
    return { ok: true };
  };

  // F2 Edit 진입 검증 (AS-IS EditButton L703~717) — 14 필수 컬럼 grid 안 존재 여부
  //   현재 To-Be 는 column meta 가 정적이므로 항상 통과 (column 존재 보장됨)
  //   사업부 별 분기는 useSalesPlanExpression 에서 자동 처리
  const validateEditMode = (divisionId: string): ValidationResult => {
    if (!divisionId || divisionId === '') {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRE_DIVISION}] Division 을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    return { ok: true };
  };

  // cboBucketType_Click 검증 (AS-IS L5475 — Insert 'I' 행 또는 Edit Mode 시 차단 MSG00227)
  const validateBucketChange = (
    rows: SalesPlanRow[],
    isEditMode: boolean,
  ): ValidationResult => {
    const hasInsert = rows.some(r => r.CRUD_TYPE === 'I');
    if (hasInsert) {
      void setAlert({ type: 'alert', content: `[${MSG.INSERT_ONLY_BUCKET}] Insert 행이 있을 때 Bucket 을 변경할 수 없습니다.` });
      return { ok: false, msgId: MSG.INSERT_ONLY_BUCKET };
    }
    if (isEditMode) {
      void setAlert({ type: 'alert', content: `[${MSG.INSERT_ONLY_BUCKET}] Edit Mode 일 때 Bucket 을 변경할 수 없습니다.` });
      return { ok: false, msgId: MSG.INSERT_ONLY_BUCKET };
    }
    return { ok: true };
  };

  return { validateFind, validateSaveRows, validateDelete, validateEditMode, validateBucketChange };
};
