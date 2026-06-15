// AS-IS DMF0020_SalesFuturePrice.cs validation.md (71 메인 + 12 POPUP = 83건)
//   카테고리: 사업부분기 38 / 기타 20 / 필수값 6 / Grid입력 2 / 버전선택 1 / 날짜기간 1 / 중복체크 1 / 확인 1 / 모드분기 1
//
// 본 hook 은 메인 71건 중 To-Be 코드에 의미가 있는 GMessageBox 13건 + 사전검증분기 12건 + Grid입력 2건 + 사업부분기 helper 를 다룬다.
//   - 사업부분기 38건은 별도 `divisionRole` selector (useSalesFuturePriceExpression) 에서 처리
//   - 메모리 feedback_no_type_cast_around_runtime: NUMBER → String 명시 변환 의무

import { useMessageStore } from '@shared/stores';

import { DIVISION, MSG } from '../sales-future-price.constants';
import type { FuturePriceRow, SearchCondition, ValidationResult } from '../sales-future-price.types';
import { isPeriodInverted } from '../utils/futurePriceDate';

export const useSalesFuturePriceValidation = () => {
  const setAlert = useMessageStore.getState().setAlert;

  // ----- F5 FindData (validation.md #18~22) -----
  const validateFind = (c: SearchCondition): ValidationResult => {
    // #21 — AS-IS L1327 if (p_division_id == "") MSG00097 Division 을 선택하세요.
    if (!c.divisionId) {
      void setAlert({ type: 'alert', content: '[MSG00097] Division 을 선택하세요.' });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    // #19 — AS-IS L1286 if (txtVersion.Text.Trim() == "") MSG00283 Version을 선택하고 조회하세요.
    if (!c.versionId) {
      void setAlert({ type: 'alert', content: '[MSG00283] Version 을 선택하고 조회하세요.' });
      return { ok: false, msgId: MSG.REQUIRE_VERSION };
    }
    // #20 — AS-IS L1307 if (sPeriod[0] > sPeriod[1]) MSG00108
    if (isPeriodInverted(c.startYyyymmdd, c.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: '[MSG00108] 시작일자가 종료일자보다 늦을 수 없습니다.' });
      return { ok: false, msgId: MSG.NO_DATA };
    }
    return { ok: true };
  };

  // ----- F7 SaveData (validation.md #23~30) -----
  //   #23 (blnWork)         — 사전 가드 (편집 모드)
  //   #24 (필수컬럼 9개)    — Division/EndCustomer/SCMSite/Item/Incoterms/FCST/DOM_EXP/Currency/Measure
  //   #25 (중복)            — Division=40 분기 (fnValidation 8건과 연계)
  //   #27 (Division=40)     — MSG00414 미등록
  //   #30 (확인)            — MSG00004 저장하시겠습니까?
  const validateSaveRows = (rows: FuturePriceRow[], c: SearchCondition): ValidationResult => {
    const dirty = rows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: '저장할 행이 없습니다. (Insert 또는 Edit 후 저장)' });
      return { ok: false };
    }

    // 필수 컬럼 9개 — AS-IS L1679~ 의 else-if 체인
    const REQUIRED: Array<[string, string]> = [
      ['DIVISION_ID',   'Division'],
      ['END_CUSTOMER',  'End Customer'],
      ['SCM_SITE_ID',   'Sales Site'],
      ['ITEM_ID',       'Model (Item)'],
      ['INCOTERMS',     'Incoterms'],
      ['FCST_TYPE',     'FCST Type'],
      ['DOM_EXP',       'Customs Handbook (Dom/Exp)'],
      ['CURRENCY',      'Currency'],
      ['MEASURE',       'Measure'],
    ];
    for (let i = 0; i < dirty.length; i++) {
      const r = dirty[i] as Record<string, string>;
      for (const [k, label] of REQUIRED) {
        const v = (r[k] ?? '').trim();
        if (v === '') {
          void setAlert({ type: 'alert', content: `[MSG00002] [${label}] 은 필수 입력사항입니다. 다시 한번 확인해주세요. (행 ${i + 1})` });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, rowIdx: i };
        }
      }
      // AS-IS L1890 — Division=40 추가 검증 (MSG00414, 미등록 메시지)
      if (c.divisionId === DIVISION.MOBILITY && r.CRUD_TYPE === 'I') {
        const projectCode = (r['PROJECT_CODE'] ?? '').trim();
        if (projectCode === '') {
          void setAlert({ type: 'alert', content: '[MSG00414] Division 40 환경에서 Project 필수.' });
          return { ok: false, msgId: MSG.SAVE_DIVISION_40, rowIdx: i };
        }
      }
    }

    // 행간 중복 — fnValidation (Division 분기 8건). PK 8 컬럼 동일 시 중복.
    const PK = ['DIVISION_ID', 'END_CUSTOMER', 'SCM_SITE_ID', 'ITEM_ID', 'INCOTERMS', 'FCST_TYPE', 'DOM_EXP', 'CURRENCY'];
    const seen = new Set<string>();
    for (let i = 0; i < dirty.length; i++) {
      const key = PK.map(k => (dirty[i] as Record<string, string>)[k] ?? '').join('|');
      if (seen.has(key)) {
        void setAlert({ type: 'alert', content: `[MSG00043] 저장 시 중복 오류가 발생하였습니다. (행 ${i + 1}) 동일 PK 가 이미 존재합니다.` });
        return { ok: false, msgId: MSG.DUPLICATE, rowIdx: i };
      }
      seen.add(key);
    }

    return { ok: true };
  };

  // ----- F2 EditButton (validation.md #7~17 — 11건) -----
  //   #7  MSG00448 — 현재 Version 아님
  //   #9,11,13 MSG00113 — 복사할 데이터 선택 (Division 분기별)
  //   #14 MSG00412 — PRICE_EXIST 컬럼 누락 가드
  const validateEdit = (selectedRow: FuturePriceRow | undefined, c: SearchCondition): ValidationResult => {
    if (!selectedRow) {
      void setAlert({ type: 'alert', content: '[MSG00113] 복사할 데이터를 선택하세요.' });
      return { ok: false, msgId: MSG.SELECT_COPY_ROW };
    }
    // #7 — 현재 버전 아님
    if (c.versionId !== 'CURRENT') {
      void setAlert({ type: 'alert', content: '[MSG00448] 현재 버전이 아닙니다.' });
      return { ok: false, msgId: MSG.EDIT_NOT_CURRENT_VER };
    }
    // #14 — PRICE_EXIST 누락 가드 (analysis.md L952)
    if (!('PRICE_EXIST' in selectedRow)) {
      void setAlert({ type: 'alert', content: '[MSG00412] Price Exist 컬럼 정보 누락.' });
      return { ok: false, msgId: MSG.PRICE_EXIST_MISSING };
    }
    return { ok: true };
  };

  // ----- 셀 클릭 가드 (#63 spdMain_CellClick MSG00447 Currency 빈값) -----
  const validateCellClick = (binding: string, value: unknown): ValidationResult => {
    if (binding === 'CURRENCY' && String((value as string | undefined) ?? '').trim() === '') {
      void setAlert({ type: 'alert', content: '[MSG00447] Currency 가 비어 있습니다.' });
      return { ok: false, msgId: MSG.CURRENCY_EMPTY };
    }
    return { ok: true };
  };

  // ----- Bucket 변경 (#70 cboBucketType_Click MSG00227 — 신규 행 'I' 시) -----
  const validateBucketChange = (firstColValue: string): ValidationResult => {
    if (firstColValue === 'I') {
      void setAlert({ type: 'alert', content: '[MSG00227] 신규 입력 행이 있을 때는 Bucket 을 변경할 수 없습니다.' });
      return { ok: false, msgId: MSG.INSERT_ONLY_BUCKET };
    }
    return { ok: true };
  };

  return {
    validateFind,
    validateSaveRows,
    validateEdit,
    validateCellClick,
    validateBucketChange,
  };
};
