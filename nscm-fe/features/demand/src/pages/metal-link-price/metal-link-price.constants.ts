export const MENU_ID = 'DMF0074' as const;
export type MENU_ID = typeof MENU_ID;

// AS-IS DMF0074_MetalLinkPrice.cs (Demand > Demand Plan > Metal Link Price · 메탈 판가 연동):
//   - 조회전용 그리드 — SHEET_COLUMNS 58 (Base 16 + 메탈 6그룹×7원소 42) 전량 'S'/FPText.
//   - 저장 = Excel Upload 스테이징 단일 경로 (공통 FileController excel-upload 체인 —
//     DIV=40 은 formId 'DMF0074_40' 별도 컬럼 카탈로그). 직접 Insert/Delete/Save 없음(AS-IS 빈 override).
//   - 편집제어 = 단일 division-gate: GET SP 가 SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN 으로
//     행 하드필터 + EDIT_YN 프로젝션 (PKG BODY L452/L837) — FE 중복 필터 불요.
//   - 분석 정본: Doc/화면설계서/DMF0074_MetalLinkPrice_상세동작_개발용.md (이벤트 21 / Validation 10 / Expression 0)
export enum SHEETS {
  // 메인 그리드 — AS-IS SpdSheet.shtMain='Metal Link Price' + 사내 SCM_ADM_EXCEL_COLUMNS.SHEET_NAME
  //   기존 등록명 그대로 (룰 #91). excel-upload 는 SHEET_NAME=#{shtNm} 조회이므로 이 값이 체인 키.
  MAIN = 'Metal Link Price',
  // ⭐ 템플릿 다운로드 (Excel Form) — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE (division-gate 동일)
  TEMPLATE = 'template',
  // Sales Price 버전 선택 — DMF0073_GET_VERSION_SALESPRICE 공유 (DMF0020 version 시트와 동일 계약)
  VERSION = 'version',
}

export const RESPONSE_SET = {
  MAIN: 'o_rc1',
  TEMPLATE: 'o_rc1',
  VERSION: 'o_rc1',
} as const;
export type RESPONSE_SET = (typeof RESPONSE_SET)[keyof typeof RESPONSE_SET];

// ⭐ AS-IS Validation MSG — 사내 SCM_ADM_MSG_M 실측 대조 완료 (2026-07-10, 신규 채번 MSG00656 1건):
//   AS-IS MSG00002('{0} 필수')는 사내에서 저장성공으로 재정의 → 의미 1:1 = MSG00614.
//   AS-IS MSG00049(날짜 파싱 실패)는 TO-BE 월 피커로 도달 불가 — 미등록 (__asis-mapping__ 격차 명기).
export const MSG = {
  // "이전 작업이 아직 실행 중입니다…" — FindData blnWork 이중실행 가드 (.cs L370)
  BUSY: 'MSG00137',
  // "버전을 선택하세요." — txtVersion 공란 (.cs L377)
  REQUIRE_VERSION: 'MSG00283',
  // "{0} 값은 필수 입력입니다." — Plan Date 공란 (.cs L387, AS-IS MSG00002 의미 1:1)
  REQUIRED_VALUE: 'MSG00614',
  // "조회 기간이 잘못되었습니다 (시작일 > 종료일)." (.cs L403)
  PERIOD_INVERTED: 'MSG00108',
  // "Division 을 선택하세요." (.cs L421 + 템플릿 팝업 L170)
  REQUIRE_DIVISION: 'MSG00097',
  // "버전은 최대 2개까지 선택할 수 있습니다." — btnSPVer 반환 3개+ (.cs L692)
  VERSION_MAX: 'MSG00255',
  // "Excel 업로드가 완료되었습니다. 재조회합니다." — 업로드 닫힘 후 confirm (.cs L733)
  UPLOAD_DONE: 'MSG00265',
  // ⭐ 신규 채번 (2026-07-10) — 템플릿 0건: MRF 'Y' 버전 부재 (AS-IS 팝업 L229 구 MSG00427 의도)
  TEMPLATE_EMPTY: 'MSG00656',
} as const;

// Column 메타 (customer-fcst-upload MainColumnMeta 동일 형태 + #92 division 토큰)
export interface MainColumnMeta {
  key: string;
  header: string;
  group?: string; // 메탈 42 — SMALL_CLASS_LABEL_NAME (2단 헤더 상단 그룹)
  width?: number;
  align?: 'L' | 'C' | 'R';
  visible?: boolean;
  fixed?: boolean;
  // hook #92 — DIVISION_ID 콤마 토큰 (공란 = 항상 표시). 정본은 admin ATTRIBUTE3 복사분.
  divisionAllow?: string;
  _default?: boolean;
}

const DIV_ALL = '40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG';
const DIV_NO40 = '82,81,81_UC,81_HM,81_ST,81_HD,81_HG';

// 메탈 6그룹 × 7원소 — SCM_MST_SHEET_COLUMNS 실측 (SMALL_CLASS_LABEL_NAME / 라벨 / 너비)
const METAL_ELEMENTS: { suffix: number; label: string; keyWidth: number }[] = [
  { suffix: 1, label: 'Ni', keyWidth: 50 },
  { suffix: 2, label: 'Co', keyWidth: 50 },
  { suffix: 3, label: 'Li2CO3', keyWidth: 50 },
  { suffix: 4, label: 'LIOH', keyWidth: 70 },
  { suffix: 5, label: 'Al', keyWidth: 50 },
  { suffix: 6, label: 'Mn', keyWidth: 50 },
  { suffix: 7, label: 'Cu', keyWidth: 70 },
];
const METAL_GROUPS: { prefix: string; group: string; align: 'C' | 'R' }[] = [
  { prefix: 'APPLY_PRICE_TYPE_CODE', group: 'Key', align: 'C' },
  { prefix: 'FROM_PERIOD', group: 'Period(Fr)', align: 'R' },
  { prefix: 'TO_PERIOD', group: 'Period(To)', align: 'R' },
  { prefix: 'CONTRACT_UNIT', group: 'Contract Price(/kg)', align: 'R' },
  { prefix: 'METAL_APPLY', group: 'Change Price(/kg)', align: 'R' },
  { prefix: 'METAL_REQR', group: 'Metal Index (kg/Biz type)', align: 'R' },
];

// 58컬럼 fallback — 사내 SCM_MST_SHEET_COLUMNS 58행 1:1 스냅샷 (2026-07-10 실측).
//   정본은 admin 동적 fetch (fetchStaticColumns) — 본 fallback 은 BE 메타 미응답 시 작동 보장용.
//   전 컬럼 읽기전용('S'/FPText) — 편집 없음 (AS-IS LockColumn 전셀 잠금 1:1).
export const MAIN_COLUMNS: MainColumnMeta[] = [
  // ── Base 16 (FIXED_FLAG='Y' — AS-IS Freeze 1:1. width 0 = 내부 hidden 컬럼) ──
  { key: 'DIVISION_ID', header: 'Division', width: 30, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'PLAN_YYYYMM', header: 'Plan Date', width: 50, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'DEPT_ID', header: 'DEPT_ID', width: 0, align: 'C', fixed: true, visible: false, _default: false },
  { key: 'DEPT_NAME', header: 'Team', width: 180, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'END_CUSTOMER', header: 'End Customer', width: 100, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  // ⭐ #92 — PROJECT 2열은 DIVISION_ID 토큰에 40 없음 → 소형(40) 조회 시 자동 미표시
  { key: 'PROJECT_CODE', header: 'Project Code', width: 100, align: 'C', fixed: true, divisionAllow: DIV_NO40, _default: true },
  { key: 'PROJECT_NAME', header: 'Project', width: 100, align: 'C', fixed: true, divisionAllow: DIV_NO40, _default: true },
  { key: 'PLANT_SITE_ID', header: 'PLANT_SITE_ID', width: 0, align: 'C', fixed: true, visible: false, _default: false },
  { key: 'ITEM_ID', header: 'Model Code', width: 100, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'METAL_LINK_YN', header: 'Metal Link', width: 40, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'SCM_SITE_ID', header: 'Sales Site', width: 110, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'CURRENCY', header: 'Currency', width: 60, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'FCST_TYPE_CODE', header: 'FCST_TYPE_CODE', width: 0, align: 'C', fixed: true, visible: false, _default: false },
  { key: 'FCST_TYPE', header: 'FCST type', width: 60, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'METAL_EXCEPTION_YN', header: 'Exception', width: 60, align: 'C', fixed: true, divisionAllow: DIV_ALL, _default: true },
  { key: 'ENERGY', header: 'Energy', width: 60, align: 'R', fixed: true, divisionAllow: DIV_ALL, _default: true },
  // ── 메탈 42 (6그룹 × Ni/Co/Li2CO3/LIOH/Al/Mn/Cu — 2단 헤더 상단 = group) ──
  ...METAL_GROUPS.flatMap(g =>
    METAL_ELEMENTS.map<MainColumnMeta>(el => ({
      key: `${g.prefix}${el.suffix}`,
      header: el.label,
      group: g.group,
      // Key 그룹만 원소별 너비 상이 (LIOH/Cu 70) — 그 외 그룹 전부 50 (실측)
      width: g.prefix === 'APPLY_PRICE_TYPE_CODE' ? el.keyWidth : 50,
      align: g.align,
      divisionAllow: DIV_ALL,
      _default: true,
    }))
  ),
];

// ⭐ 템플릿 모달(Excel Form) 그리드 컬럼 — GET_METAL_LINK_TEMPLATE o_rc1 은 메인과 동일 구조
//   (업로드 대상 조합 + measure 열 '-' placeholder). Excel export 가 곧 템플릿 다운로드 (AS-IS 1:1).
export const TEMPLATE_EXCEL_PREFIX = 'DMF0074_Template';
export const MAIN_EXCEL_PREFIX = 'DMF0074_MetalLinkPrice';

// Excel Upload 체인 — SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 실측 (2026-07-10 메탈 42열 확장 적용).
//   DIV=40 은 formId 'DMF0074_40' (Project 2열 없는 53열 카탈로그) / 그 외 55열.
//   ⚠️ 아래 header 문자열은 HEADER_CONTENT 토큰과 1바이트도 달라선 안 된다 —
//      BE 는 엑셀 1행 헤더명으로 값을 찾으므로(ExcelUtils.convertExcelToJson) 불일치 = 해당 열 전량 탈락.
export const UPLOAD_FORM_ID = { DEFAULT: 'DMF0074', DIV40: 'DMF0074_40' } as const;

export interface UploadColumn {
  header: string;
  key: string;
}

const UPLOAD_BASE_DEFAULT: UploadColumn[] = [
  { header: 'Div', key: 'DIVISION_ID' },
  { header: 'Plan Date', key: 'PLAN_YYYYMM' },
  { header: 'Team', key: 'DEPT_NAME' },
  { header: 'End Customer', key: 'END_CUSTOMER' },
  { header: 'Project Code', key: 'PROJECT_CODE' },
  { header: 'Project', key: 'PROJECT_NAME' },
  { header: 'Model Code', key: 'ITEM_ID' },
  { header: 'Metal Link', key: 'METAL_LINK_YN' },
  { header: 'Sales Site', key: 'SCM_SITE_ID' },
  { header: 'Currency', key: 'CURRENCY' },
  { header: 'FCST type', key: 'FCST_TYPE' },
  { header: 'Exception', key: 'METAL_EXCEPTION_YN' },
  { header: 'Energy', key: 'ENERGY' },
];

// 메탈 42 — 업로드 헤더 토큰은 "그룹 고유명 + 원소명" (그리드 2단 헤더의 하위명 Ni/Co… 는 6회 중복이라 사용 불가)
const METAL_UPLOAD_GROUP_TOKEN: Record<string, string> = {
  APPLY_PRICE_TYPE_CODE: 'Key',
  FROM_PERIOD: 'PeriodFr',
  TO_PERIOD: 'PeriodTo',
  CONTRACT_UNIT: 'ContractPrice',
  METAL_APPLY: 'ChangePrice',
  METAL_REQR: 'MetalIndex',
};
const UPLOAD_METAL_COLUMNS: UploadColumn[] = METAL_GROUPS.flatMap(g =>
  METAL_ELEMENTS.map<UploadColumn>(el => ({
    header: `${METAL_UPLOAD_GROUP_TOKEN[g.prefix]}_${el.label}`,
    key: `${g.prefix}${el.suffix}`,
  }))
);

export const UPLOAD_COLUMNS_DEFAULT: UploadColumn[] = [
  ...UPLOAD_BASE_DEFAULT,
  ...UPLOAD_METAL_COLUMNS,
];
export const UPLOAD_COLUMNS_DIV40: UploadColumn[] = [
  ...UPLOAD_BASE_DEFAULT.filter(c => c.header !== 'Project Code' && c.header !== 'Project'),
  ...UPLOAD_METAL_COLUMNS,
];

export const UPLOAD_HEADERS_DEFAULT = UPLOAD_COLUMNS_DEFAULT.map(c => c.header);
export const UPLOAD_HEADERS_DIV40 = UPLOAD_COLUMNS_DIV40.map(c => c.header);

// 템플릿 SP 는 사용자가 채울 열(Plan Date / Energy / 메탈 42)을 '-' 로 내려준다
//   (PKG_DMF0074 L780 "날짜는 빈칸으로 내려받게"). 업로드 검증은 '-' 를 값으로 인식하므로 export 시 빈칸으로 치환한다.
export const TEMPLATE_BLANK_PLACEHOLDER = '-';
