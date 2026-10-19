// AS-IS DMF0020_SalesFuturePrice.cs validation.md (71 메인 + 12 POPUP = 83건)
//   카테고리: 사업부분기 38 / 기타 20 / 필수값 6 / Grid입력 2 / 버전선택 1 / 날짜기간 1 / 중복체크 1 / 확인 1 / 모드분기 1
//
// 본 hook 은 메인 71건 중 To-Be 코드에 의미가 있는 GMessageBox 13건 + 사전검증분기 12건 + Grid입력 2건 + 사업부분기 helper 를 다룬다.
//   - 사업부분기 38건은 별도 `divisionRole` selector (useSalesFuturePriceExpression) 에서 처리
//   - 메모리 feedback_no_type_cast_around_runtime: NUMBER → String 명시 변환 의무

import { useMessageStore } from '@shared/stores';

import { DIVISION, MSG } from '../sales-future-price.constants';
import type {
  FuturePriceRow,
  SearchCondition,
  ValidationResult,
} from '../sales-future-price.types';
import { isPeriodInverted } from '../utils/futurePriceDate';

export const useSalesFuturePriceValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // ----- F5 FindData (validation.md #18~22) -----
  const validateFind = (c: SearchCondition): ValidationResult => {
    // #21 — AS-IS L1327 if (p_division_id == "") MSG00097 Division 을 선택하세요.
    if (!c.divisionId) {
      void setAlert({ type: 'alert', content: t('MSG00097', '_Division 을 선택하세요.') });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    // #19 — AS-IS L1286 if (txtVersion.Text.Trim() == "") MSG00283 Version을 선택하고 조회하세요.
    if (!c.versionId) {
      void setAlert({ type: 'alert', content: t('MSG00283', '_Version 을 선택하고 조회하세요.') });
      return { ok: false, msgId: MSG.REQUIRE_VERSION };
    }
    // #20 — AS-IS L1307 if (sPeriod[0] > sPeriod[1]) MSG00108
    if (isPeriodInverted(c.startYyyymmdd, c.endYyyymmdd)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_시작일자가 종료일자보다 늦을 수 없습니다.'),
      });
      return { ok: false, msgId: MSG.NO_DATA };
    }
    // ⚠️ 기간 max 제한은 SP 측 query 튜닝 후 재논의 (사용자 명시 2026-06-21).
    return { ok: true };
  };

  // ----- F7 SaveData (validation.md #23~30 + fnValidation #34~41) — 2026-07-02 AS-IS 전수 정합 -----
  //   #23 (blnWork 연속작업)  — 호출부 handleSave in-flight 가드 (MSG00137)
  //   #24 (필수컬럼)          — AS-IS L1634~1685: Division / Project(40=End Customer40, 81·82=Project Code) /
  //                             Sales Site / [81계열만 Plant Site — C20210330-000045] / Model / Currency /
  //                             Measure / Customs Handbook / FCST Type / Incoterms. 'I' 행만 검사(AS-IS L1581).
  //                             ⚠ END_CUSTOMER 는 AS-IS 필수 아님(과거 오적용 제거 — 82 오차단 사고 방지).
  //   #25+#34~41 (fnValidation 중복) — 신규 'I' 행을 "화면 전체 행(기존 조회분 포함)"과 대조 (AS-IS L2267 전 행 루프).
  //                             키 = 사업부 분기: 81계열 10키(+PLANT) / 82 9키 / 40 END_CUSTOMER40 기반 9키.
  //   #27 (MSG00414)          — AS-IS 실기능 = "가격 payload 전무" 가드 (원본 L1871~1892; validation.md 메타의
  //                             'div40 분기'는 라벨 선택일 뿐) → handleSave 의 acc.length===0 'No data to save' 가 담당.
  //   #30 (확인)              — MSG00001 저장하시겠습니까? (2026-07-02 MSG_M 재지정)
  // AS-IS: 40 은 END_CUSTOMER40 컬럼이 Project 역할 (라벨 'End Customer'), 81·82 는 PROJECT_CODE.
  const projectFieldOf = (divisionId: string): [string, string] =>
    divisionId === DIVISION.MOBILITY
      ? ['END_CUSTOMER40', 'End Customer']
      : ['PROJECT_CODE', 'Project Code'];

  const validateSaveRows = (
    rows: FuturePriceRow[],
    allRows: FuturePriceRow[],
    c: SearchCondition
  ): ValidationResult => {
    const dirty = rows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      // 변경분 0건 = 저장 대상 없음. 다른 화면(DMF0004~0007)과 동일하게 toast 로 알린다
      //   (변경 없음 = toast / 필수·중복 검증 실패 = modal alert). AS-IS MSG00004.
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.') });
      return { ok: false };
    }

    const is81 = c.divisionId.startsWith('81');
    const [projectField, projectLabel] = projectFieldOf(c.divisionId);
    // AS-IS L1634 필수 체인 — 40=End Customer40 / 81·82=Project Code, 81계열만 Plant Site 추가.
    const REQUIRED: Array<[string, string]> = [
      ['DIVISION_ID', 'Division'],
      [projectField, projectLabel],
      ['SCM_SITE_ID', 'Sales Site'],
      ...(is81 ? ([['PLANT_SITE_ID', 'Plant Site']] as Array<[string, string]>) : []),
      ['ITEM_ID', 'Model'],
      ['CURRENCY', 'Currency'],
      ['MEASURE', 'Measure'],
      ['DOM_EXP', 'Customs Handbook'],
      ['FCST_TYPE', 'FCST Type'],
      ['INCOTERMS', 'Incoterms'],
    ];
    // no-base-to-string 회피 — unknown 값을 안전하게 string 으로 (null/undefined → '').
    const val = (r: FuturePriceRow, k: string): string => {
      const v = (r as Record<string, unknown>)[k];
      return v == null ? '' : String(v as string | number).trim();
    };

    const inserted = dirty.filter(r => r.CRUD_TYPE === 'I');
    for (let i = 0; i < inserted.length; i++) {
      const r = inserted[i];
      for (const [k, label] of REQUIRED) {
        if (val(r, k) === '') {
          void setAlert({
            type: 'alert',
            content: `${t('MSG00429', '_{0} 값은 필수 입력 항목입니다.').replace('{0}', `[${label}]`)} (신규 ${i + 1}행)`,
          });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, rowIdx: i };
        }
      }
    }

    // fnValidation 정합 — 신규 'I' 행 × 화면 전체 행(allRows: 기존 조회분 + 신규) 대조.
    //   AS-IS 키(사업부 분기): 공통 8키(DIV/SITE/ITEM/DOM/FCST/INCO/CUR/MEASURE) + project 필드,
    //   81계열은 PLANT_SITE_ID 추가 (L2280). 자기 자신 1회 매치는 정상 → 2회 이상 = 중복.
    const DUP_KEYS: string[] = [
      'DIVISION_ID',
      projectField,
      'SCM_SITE_ID',
      'ITEM_ID',
      'DOM_EXP',
      'FCST_TYPE',
      'INCOTERMS',
      'CURRENCY',
      'MEASURE',
      ...(is81 ? ['PLANT_SITE_ID'] : []),
    ];
    const keyOf = (r: FuturePriceRow): string => DUP_KEYS.map(k => val(r, k)).join('|');
    // 전체 행 키 카운트 1회 구축 (AS-IS O(n²) 루프의 등가 — Map 으로 성능만 개선)
    const counts = new Map<string, number>();
    for (const r of allRows) {
      const k = keyOf(r);
      counts.set(k, (counts.get(k) ?? 0) + 1);
    }
    for (let i = 0; i < inserted.length; i++) {
      if ((counts.get(keyOf(inserted[i])) ?? 0) > 1) {
        // AS-IS L1691~1703 — 중복 키 컬럼 리스트를 {0} 로 표기.
        const sMsg =
          c.divisionId === DIVISION.MOBILITY
            ? '[Division],[End Customer],[Sales Site],[Model],[INCOTERMS],[FcstType],[Customs Handbook],[Currency]'
            : `[Division],[Project Code],${is81 ? '[Plant Site],' : ''}[Sales Site],[Model],[INCOTERMS],[FcstType],[Customs Handbook],[Currency]`;
        void setAlert({
          type: 'alert',
          content: `${t('MSG00043', '_저장시 중복 오류가 발생하였습니다. {0}').replace('{0}', sMsg)} (신규 ${i + 1}행)`,
        });
        return { ok: false, msgId: MSG.DUPLICATE, rowIdx: i };
      }
    }

    return { ok: true };
  };

  // ----- F2 EditButton (validation.md #7~17 — 11건) -----
  //   #7  MSG00448 — 현재 Version 아님
  //   #9,11,13 MSG00113 — 복사할 데이터 선택 (Division 분기별)
  //   #14 MSG00412 — PRICE_EXIST 컬럼 누락 가드
  const validateEdit = (
    selectedRow: FuturePriceRow | undefined,
    c: SearchCondition
  ): ValidationResult => {
    if (!selectedRow) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_복사할 데이터를 선택하세요.') });
      return { ok: false, msgId: MSG.SELECT_COPY_ROW };
    }
    // #7 — 현재 버전 아님
    if (c.versionId !== 'Current') {
      void setAlert({ type: 'alert', content: t('MSG00448', '_현재 버전이 아닙니다.') });
      return { ok: false, msgId: MSG.EDIT_NOT_CURRENT_VER };
    }
    // #14 — PRICE_EXIST 누락 가드 (analysis.md L952)
    if (!('PRICE_EXIST' in selectedRow)) {
      void setAlert({ type: 'alert', content: t('MSG00412', '_Price Exist 컬럼 정보 누락.') });
      return { ok: false, msgId: MSG.PRICE_EXIST_MISSING };
    }
    return { ok: true };
  };

  // ----- 셀 클릭 가드 (#63 spdMain_CellClick MSG00447 Currency 빈값) -----
  const validateCellClick = (binding: string, value: unknown): ValidationResult => {
    if (binding === 'CURRENCY' && String((value as string | undefined) ?? '').trim() === '') {
      void setAlert({ type: 'alert', content: t('MSG00447', '_Currency 가 비어 있습니다.') });
      return { ok: false, msgId: MSG.CURRENCY_EMPTY };
    }
    return { ok: true };
  };

  // ----- Bucket 변경 (#70 cboBucketType_Click MSG00227 — 신규 행 'I' 시) -----
  const validateBucketChange = (firstColValue: string): ValidationResult => {
    if (firstColValue === 'I') {
      void setAlert({
        type: 'alert',
        content: t('MSG00227', '_신규 입력 행이 있을 때는 Bucket 을 변경할 수 없습니다.'),
      });
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
