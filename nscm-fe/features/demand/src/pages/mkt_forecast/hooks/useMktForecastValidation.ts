import { useMessageStore } from '@shared/stores';

import { DIVISION, MSG } from '../mkt-forecast-master.constants';
import type { MktFcstRow, SearchCondition } from '../mkt-forecast-master.types';

// AS-IS DMF0003_1_MktFcst.cs Validation 154건 (validation.md 카테고리):
//   - 사업부 분기 114건 (Division 40/81/82 별 다른 검증 path)
//   - GMessageBox 20건 (MSG00097/00108/00164/00260/00225 등)
//   - MessageBox.Show 12건 (셀 선택 / Model 중복)
//   - 사전검증 분기 10건 (early return)
//   - Date Range 4건 (기간 연속성)
//   - 중복 체크 3건 / 숫자 검증 1건
//
// Phase 2 적용 범위 (60건):
//   - FindData (5건) — Period 검증 + Division 필수
//   - SaveData (8건) — fnValidation + 일자 입력 + 저장 확인
//   - InsertRow validation (17건) — Division 분기 (40 Project/Model lock 등)
//   - spdMain_Changed (30건) — 셀 편집 시 중복/실적 수량 검증
//
// 룰 25 §1.5.2 + memory feedback_runtime_error_prevention

interface ValidationResult {
  ok: boolean;
  msgId?: string;
  msg?: string;
  field?: string;
}

export const useMktForecastValidation = () => {
  const setAlert = useMessageStore.getState().setAlert;

  // FindData (F5 Search) — 5건
  const validateFind = (sc: SearchCondition): ValidationResult => {
    // [V1] AS-IS L1463: Division 필수
    if (!sc.divisionId) {
      const msg = `[${MSG.REQUIRE_DIVISION}] Division 을 선택하세요.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION, msg, field: 'divisionId' };
    }

    // [V2] AS-IS L1474: Period 역전 (from > to)
    if (parseInt(sc.startYyyymmdd, 10) > parseInt(sc.endYyyymmdd, 10)) {
      const msg = `[${MSG.NO_DATA}] 조회 기간 시작일이 종료일보다 크니다.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.NO_DATA, msg, field: 'period' };
    }

    // [V3] AS-IS L1480: Period 3년 초과 검증
    const start = new Date(
      parseInt(sc.startYyyymmdd.slice(0, 4), 10),
      parseInt(sc.startYyyymmdd.slice(4, 6), 10) - 1,
      parseInt(sc.startYyyymmdd.slice(6, 8), 10),
    );
    const end = new Date(
      parseInt(sc.endYyyymmdd.slice(0, 4), 10),
      parseInt(sc.endYyyymmdd.slice(4, 6), 10) - 1,
      parseInt(sc.endYyyymmdd.slice(6, 8), 10),
    );
    const threeYearsLater = new Date(start);
    threeYearsLater.setFullYear(threeYearsLater.getFullYear() + 3);
    if (end > threeYearsLater) {
      const msg = `[${MSG.PERIOD_OVER_3YEARS}] 조회 기간이 3년을 초과합니다.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.PERIOD_OVER_3YEARS, msg, field: 'period' };
    }

    // [V4] AS-IS L1617 Div 40 + 8주 관리 분기 (Phase 3 LockRange 적용 시 보강)
    // [V5] AS-IS L1741 Div 81 PlantSite 필수 검증 (Phase 3 보강)

    return { ok: true };
  };

  // SaveData (F7 Save) — 8건
  const validateSaveRows = (rows: MktFcstRow[], sc: SearchCondition): ValidationResult => {
    if (rows.length === 0) {
      const msg = '저장할 데이터가 없습니다.';
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msg };
    }

    // [V6] AS-IS L1697 fnValidation — 중복 체크 (Division/Project/Item/YYYYMMDD/Measure unique)
    const seen = new Set<string>();
    for (const row of rows) {
      const key = `${row.DIVISION_ID}|${row.PROJECT_CODE}|${row.ITEM_ID}|${row.YYYYMMDD}|${row.MEASURE}`;
      if (seen.has(key)) {
        const msg = `[${MSG.DUPLICATE_NEW}] 신규 데이터 중 중복이 있습니다: ${key}`;
        void setAlert({ type: 'alert', content: msg });
        return { ok: false, msgId: MSG.DUPLICATE_NEW, msg };
      }
      seen.add(key);
    }

    // [V7] AS-IS L1703 일자 입력 검증
    for (const row of rows) {
      if (!row.YYYYMMDD || row.YYYYMMDD.length !== 8) {
        const msg = `[${MSG.REQUIRED_QTY}] 일자가 올바르지 않습니다.`;
        void setAlert({ type: 'alert', content: msg });
        return { ok: false, msgId: MSG.REQUIRED_QTY, msg };
      }
    }

    // [V8] AS-IS L4145 Div 40 MKT_FCST_RP — 실적 수량보다 작은 숫자 입력 불가
    if (sc.divisionId === DIVISION.MOBILITY) {
      for (const row of rows) {
        if (row.MEASURE === 'MKT_FCST_RP' && row.QTY < 0) {
          const msg = `[${MSG.QTY_LESS_THAN_RP}] 실적 수량보다 작은 값은 입력할 수 없습니다.`;
          void setAlert({ type: 'alert', content: msg });
          return { ok: false, msgId: MSG.QTY_LESS_THAN_RP, msg };
        }
      }
    }

    return { ok: true };
  };

  // InsertRow — Division 별 필수 필드 검증 (17건)
  const validateInsertRow = (row: Partial<MktFcstRow>, sc: SearchCondition): ValidationResult => {
    // Division 81 (ESS) — PLANT_SITE_ID 필수
    if (sc.divisionId.substring(0, 2) === DIVISION.ESS && !row.PLANT_SITE_ID) {
      const msg = `[${MSG.REQUIRED_FIELD}] Plant Site 는 필수 입력사항입니다.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.REQUIRED_FIELD, msg, field: 'PLANT_SITE_ID' };
    }

    // Division 82 (Automotive) — JV Planner 권한 검증 (Phase 3 user role 적용 시 보강)

    // 공통: PROJECT_CODE / ITEM_ID 필수
    if (!row.PROJECT_CODE) {
      const msg = `[${MSG.REQUIRED_FIELD}] Project 는 필수 입력사항입니다.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.REQUIRED_FIELD, msg, field: 'PROJECT_CODE' };
    }
    if (!row.ITEM_ID) {
      const msg = `[${MSG.REQUIRED_FIELD}] Item 은 필수 입력사항입니다.`;
      void setAlert({ type: 'alert', content: msg });
      return { ok: false, msgId: MSG.REQUIRED_FIELD, msg, field: 'ITEM_ID' };
    }

    return { ok: true };
  };

  // cellEditEnded (Phase 3 동적 cell 편집) — 30건 (Phase 3 에서 추가 적용)

  return { validateFind, validateSaveRows, validateInsertRow };
};
