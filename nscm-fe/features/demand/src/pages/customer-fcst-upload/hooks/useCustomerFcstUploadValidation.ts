import dayjs from 'dayjs';

import { useMessageStore } from '@shared/stores';

import { MSG } from '../customer-fcst-upload.constant';
import type { SearchParamProps } from '../customer-fcst-upload.types';

interface ValidationResult {
  ok: boolean;
  msgId?: string;
  detail?: string;
}

interface RowData {
  CRUD_TYPE?: 'I' | 'U' | 'D';
  EDIT_FLAG?: string;
  DIVISION_ID?: string;
  SCM_SITE_ID?: string;
  PLANT_SITE_ID?: string;
  CUSTOMER_PROJECT_CODE?: string;
  CUSTOMER_MODEL?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  DOM_EXP?: string;
  MEASURE_GROUP?: string;
  MEASURE?: string;
  UPLOAD_UOM?: string;
  [key: string]: unknown;
}

// AS-IS DMF0014_CustFcstUpload.cs validation.md 20 건 매핑
//   필수값 11 (Division/SalesSite/PlantSite/CustProject/CustModel/Incoterms/FcstType/DOMExp/Measure/UploadUOM/MeasureGroup)
//   비즈니스 규칙 8 (기간 / 중복 / Bucket 등)
//   사일런트 가드 1 (empty data)
export const useCustomerFcstUploadValidation = () => {
  const setAlert = useMessageStore.getState().setAlert;

  // === F5 Search 검증 (AS-IS FindData) ===
  const validateFind = (sc: SearchParamProps): ValidationResult => {
    // 1) Division 필수 (MSG00097)
    if (!sc.divisionId || sc.divisionId === '') {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRE_DIVISION}] Division 을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }

    // 2) 기간 형식 (MSG00049)
    if (sc.period && sc.period.includes(':')) {
      const [start, end] = sc.period.split(':');
      const sDt = dayjs(start, 'YYYYMMDD');
      const eDt = dayjs(end, 'YYYYMMDD');
      if (!sDt.isValid() || !eDt.isValid()) {
        void setAlert({ type: 'alert', content: `[${MSG.INVALID_DATE}] 유효한 날짜 형식이 아닙니다.` });
        return { ok: false, msgId: MSG.INVALID_DATE };
      }
      // 3) 기간 역전 (MSG00108)
      if (sDt.isAfter(eDt)) {
        void setAlert({ type: 'alert', content: `[${MSG.NO_DATA}] 시작일자가 종료일자보다 늦을 수 없습니다.` });
        return { ok: false, msgId: MSG.NO_DATA };
      }
    }

    return { ok: true };
  };

  // === F7 Save 검증 (AS-IS SaveData — 11 필수값 컬럼 검사) ===
  const validateSaveRows = (rows: RowData[]): ValidationResult => {
    if (!rows || rows.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRED_COLUMN}] 저장할 데이터가 없습니다.` });
      return { ok: false, msgId: MSG.REQUIRED_COLUMN };
    }

    // AS-IS DefColumnsLabel 의 `*` 컬럼 (필수) — spdMain_Changed L1022~1088 정밀 매핑
    //   ⭐ Option A 정정 (2026-06-08): PLANT_SITE_ID 는 Division=81 일 때만 필수 (L1077 분기)
    //   순서는 AS-IS spdMain_Changed 검증 순서 그대로
    const baseRequired: Array<{ key: keyof RowData; label: string }> = [
      { key: 'DIVISION_ID',           label: 'Division' },           // L1022
      { key: 'SCM_SITE_ID',           label: 'Sales Site' },         // L1029
      { key: 'CUSTOMER_PROJECT_CODE', label: 'Customer Project' },   // L1035
      { key: 'CUSTOMER_MODEL',        label: 'Customer Model' },     // L1041
      { key: 'INCOTERMS',             label: 'Incoterms' },          // L1047
      { key: 'FCST_TYPE',             label: 'FCST Type' },          // L1053
      { key: 'DOM_EXP',               label: 'Customs Handbook' },   // L1059
      { key: 'MEASURE_GROUP',         label: 'Measure Group' },      // L1065
      { key: 'MEASURE',               label: 'Measure' },            // L1071
      { key: 'UPLOAD_UOM',            label: 'Upload UOM' },         // L1083
    ];

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      // Delete 행은 검증 skip
      if (row.CRUD_TYPE === 'D' || row.EDIT_FLAG === 'D') continue;

      // 5~13, 15) 기본 필수값 10건 (MSG00002 — AS-IS spdMain_Changed cell 별 검증)
      for (const { key, label } of baseRequired) {
        if (!row[key] || String(row[key]).trim() === '') {
          void setAlert({
            type: 'alert',
            content: `[${MSG.REQUIRED_FIELD}] ${label} 값은 필수 입력입니다. (행 ${i + 1})`,
          });
          return { ok: false, msgId: MSG.REQUIRED_FIELD, detail: String(key) };
        }
      }

      // 14) PLANT_SITE_ID — Division=81 일 때만 필수 (AS-IS L1077: sPlantSiteId == "" && sDivision == "81")
      if (row.DIVISION_ID === '81' && (!row.PLANT_SITE_ID || String(row.PLANT_SITE_ID).trim() === '')) {
        void setAlert({
          type: 'alert',
          content: `[${MSG.REQUIRED_FIELD}] Plant Site 값은 필수 입력입니다 (Division=81). (행 ${i + 1})`,
        });
        return { ok: false, msgId: MSG.REQUIRED_FIELD, detail: 'PLANT_SITE_ID' };
      }
    }

    return { ok: true };
  };

  // === F9 Delete 검증 (AS-IS DeleteButton — 선택 행 검사) ===
  const validateDelete = (selectedRows: RowData[]): ValidationResult => {
    if (!selectedRows || selectedRows.length === 0) {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRED_COLUMN}] 삭제할 행을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRED_COLUMN };
    }
    return { ok: true };
  };

  return { validateFind, validateSaveRows, validateDelete };
};
