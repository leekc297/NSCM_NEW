// ⭐ DMF0003 Phase 2f — 저장 전 검증 (AS-IS fnValidation L4829 / SetSaveData L4343 / ValidationCheck L4332 동등).
//   validation.md 152건 중 "저장 흐름에 의미가 있는" GMessageBox/사전검증분기 + Division 분기를 1:1 매핑.
//   매핑 매트릭스 전체 = `__asis-mapping__.md` (validation 152 / expressions 130 / events 26 / popup 8).
//
//   메시지 = useMessageStore.setAlert + i18n MSG/LBL 키 (한글 하드코딩 0). 결과 = ValidationResult.
//   anti-simplification: 표본·요약 금지. 각 가드는 AS-IS 라인 근거 주석을 보존한다.
import { useMessageStore } from '@shared/stores';

import { MSG } from '../mkt-fcst.constants';
import type { MktFcstRow, SearchCondition, ValidationResult } from '../mkt-fcst.types';

import { buildDuplicateKey, readIdentity, requiredFieldsFor } from './mkt-fcst.division';
import { dynKindOf } from './mkt-fcst.editLock';

// 타입 안전 string 변환(+trim) — string/number 만 (객체는 ''). no-base-to-string 회피.
const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// 신규 행(CRUD_TYPE='I') 의 D_(일자) 셀 중 값이 입력된 셀이 1개 이상인지 (fnValidation L4964~4972).
//   AS-IS: Measure 컬럼 다음부터 GetColumnTag(iCol).IndexOf("D_")==0 && GetText!=""  → iCnt++.
const hasAnyDailyInput = (row: MktFcstRow): boolean => {
  for (const k of Object.keys(row)) {
    if (dynKindOf(k) !== 'D') continue;
    if (k.slice(2).length !== 8) continue; // D_yyyymmdd 만
    const v = (row as Record<string, unknown>)[k];
    if (v != null && v !== '' && v !== '0') return true;
  }
  return false;
};

export const useMktFcstValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // ===== 조회조건 (FindData L1207~1233 — validation.md #29~32) =====
  //   #30 MSG00097 Division 미선택 / #31 MSG00108 기간 역전 / #32 MSG00164 기간 3년 초과.
  const validateFind = (c: SearchCondition): ValidationResult => {
    if (!str(c.divisionId)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'),
      });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }
    const start = str(c.startYyyymmdd);
    const end = str(c.endYyyymmdd);

    const isValidYmd = (v: string) => /^\d{8}$/.test(v);
    if (!isValidYmd(start) || !isValidYmd(end)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_PERIOD, '_조회 기간을 입력하세요.'),
      });
      return { ok: false, msgId: MSG.REQUIRED_PERIOD };
    }
    // #31 — AS-IS L1224 int.Parse(sPeriod[0]) > int.Parse(sPeriod[1]).
    if (start > end) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_조회 기간이 잘못되었습니다 (시작일 > 종료일).'),
      });
      return { ok: false, msgId: MSG.PERIOD_INVERTED };
    }
    // #32 — AS-IS L1230 drpPeriod.Value1.AddYears(3) < Value2 → MSG00164 (기간 3년 이내).
    //   ⭐ 일자 기준 정밀 판정(연도 정수 비교 아님): 시작일 + 3년(YYYYMMDD) 보다 종료일이 크면 초과.
    const startY = Number(start.slice(0, 4));
    if (Number.isFinite(startY)) {
      const limit = String(startY + 3) + start.slice(4); // 시작일 + 3년
      if (end > limit) {
        void setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_MAX_3YEAR, '_조회 기간은 3년 이내로 입력해주세요.'),
        });
        return { ok: false, msgId: MSG.PERIOD_MAX_3YEAR };
      }
    }
    return { ok: true };
  };

  // ===== 저장 (SaveData L1490~1501 + fnValidation L4829 + SetSaveData L4343 통합) =====
  //   (1) 신규 행 필수 입력 (SetSaveData L4347~4414, division 분기) — ValidationCheck MSG00002.
  //   (2) 신규 행간 중복 (fnValidation L4892~4961, iValidation>1) — SaveData MSG00043.
  //   (3) 신규 행 일자 수량 미입력 (fnValidation L4964~4983, bInputCheck) — SaveData MSG00034.
  //   (4) AS+ALL 가드 (SaveData L1567~1571) — MSG00366.
  const validateSaveRows = (
    rows: MktFcstRow[],
    c: SearchCondition,
    asChecked: boolean,
    asFromSite: string
  ): ValidationResult => {
    const divisionId = str(c.divisionId);
    // 신규('I') + 수정('M') 행만 검증 대상.
    const dirty = rows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_DATA, '_저장할 데이터가 없습니다.') });
      return { ok: false, msgId: MSG.NO_SAVE_DATA };
    }

    // (1) 필수 입력 — division 분기 (SetSaveData). 빈 값이면 즉시 차단 + 컬럼 라벨 {0} 치환.
    const required = requiredFieldsFor(divisionId);
    for (let i = 0; i < dirty.length; i++) {
      const r = dirty[i] as Record<string, unknown>;
      for (const field of required) {
        if (str(r[field.col]) === '') {
          // 사내 미채번 컬럼(FCST Type 등)은 lblKey 없이 fallback 문구를 그대로 쓴다.
          //   예전처럼 `_${labelKey}` 를 fallback 으로 주면 미등록 키가 '_LBL00679' 로 새어 나온다.
          const label = field.lblKey ? t(field.lblKey, field.fallback) : field.fallback;
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_FIELD, '_[{0}] 은 필수 입력사항입니다.').replace('{0}', label),
          });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, rowIdx: i };
        }
      }
    }

    // (2) 신규('I') 행간 중복 (fnValidation iValidation>1) — division 분기 키.
    const seen = new Set<string>();
    const inserts = dirty.filter(r => r.CRUD_TYPE === 'I');
    for (let i = 0; i < inserts.length; i++) {
      const key = buildDuplicateKey(inserts[i] as Record<string, unknown>, divisionId);
      if (seen.has(key)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.DUPLICATE, '_저장시 중복 오류가 발생하였습니다. {0}').replace(
            '{0}',
            String(i + 1)
          ),
        });
        return { ok: false, msgId: MSG.DUPLICATE, rowIdx: i };
      }
      seen.add(key);
    }

    // (3) 신규('I') 행은 D_(일자) 수량이 1건 이상 있어야 함 (fnValidation bInputCheck).
    for (let i = 0; i < inserts.length; i++) {
      if (!hasAnyDailyInput(inserts[i])) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NO_QTY_INPUT, '_MKT FCST 수량이 입력된 일자가 없습니다.'),
        });
        return { ok: false, msgId: MSG.NO_QTY_INPUT, rowIdx: i };
      }
    }

    // (4) AS 체크 + From-Site 가 'ALL' 이면 저장 불가 (SaveData L1567~1571).
    if (asChecked && str(asFromSite).toUpperCase() === 'ALL') {
      void setAlert({
        type: 'alert',
        content: t(MSG.AS_SITE_ALL, '_AS From-Site 를 ALL 로 저장할 수 없습니다.'),
      });
      return { ok: false, msgId: MSG.AS_SITE_ALL };
    }

    return { ok: true };
  };

  // ===== Bucket 변경 가드 (cboBucketType_Click L5397~5401 — validation.md #130) =====
  //   신규 행('I')이 있으면 Bucket 변경 불가 (MSG00227).
  const validateBucketChange = (rows: MktFcstRow[]): ValidationResult => {
    if (rows.some(r => r.CRUD_TYPE === 'I')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INSERT_ONLY_BUCKET, '_Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.'),
      });
      return { ok: false, msgId: MSG.INSERT_ONLY_BUCKET };
    }
    return { ok: true };
  };

  // ===== EditButton 복사 대상 가드 (EditButton L802~826 — validation.md #10/12/14) =====
  //   복사할 데이터 미선택 시 MSG00113 (division 무관 공통 가드).
  const validateCopyTarget = (selected: MktFcstRow | undefined): ValidationResult => {
    if (!selected) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SELECT_COPY_ROW, '_복사할 데이터를 선택하세요.'),
      });
      return { ok: false, msgId: MSG.SELECT_COPY_ROW };
    }
    return { ok: true };
  };

  // ===== 모드 가드 (EditButton L847 — validation.md #15) =====
  //   조회 결과(8주 데이터)가 없으면 수정 모드 진입 불가 (MSG00259).
  const validateEditMode = (hasQueriedData: boolean): ValidationResult => {
    if (!hasQueriedData) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EDIT_AFTER_SEARCH, '_조회 후 수정모드로 가능합니다.'),
      });
      return { ok: false, msgId: MSG.EDIT_AFTER_SEARCH };
    }
    return { ok: true };
  };

  return {
    validateFind,
    validateSaveRows,
    validateBucketChange,
    validateCopyTarget,
    validateEditMode,
  };
};

// 비-React util (테스트/순수 호출용) — readIdentity 재노출 (SAVE payload 빌더가 division 분기 시 사용).
export { readIdentity };
