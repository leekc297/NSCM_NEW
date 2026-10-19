import dayjs from '@foundation/dayjs';

import { buildBulkActionPayload, buildBulkSavePayload } from '../../lib/bulk-save';

import type { ProjectRow } from './project-registration.types';

const PROJECT_SAVE_KEYS = [
  'CRUD_TYPE',
  'DPJT_KEY',
  'DPJT_CODE',
  'DPJT_SEQ',
  'DIVISION_ID',
  'DPJT_CLASS',
  'END_CUSTOMER',
  'DPJT_NAME',
  'CELL_TYPE',
  'STACK_METHOD',
  'BIZ_TYPE',
  'SOP_DATE',
  'SOP_PLANT_ID',
] as const;

const PROJECT_COMBO_ID_BY_NAME = {
  DIVISION_NAME: 'DIVISION_ID',
  DPJT_CLASS_NAME: 'DPJT_CLASS',
  CELL_TYPE_NAME: 'CELL_TYPE',
  STACK_METHOD_NAME: 'STACK_METHOD',
  BIZ_TYPE_NAME: 'BIZ_TYPE',
  SOP_PLANT_NAME: 'SOP_PLANT_ID',
} as const;

// 요청 1: 신규 TAB1 행에서 SAVE SP가 요구하는 프로젝트 식별자 3종을 FE에서 생성한다.
//   BE 채번 SP(P_SDM1010_SAVE_TAB1_PJT_REG)의 V_DPJT_CODE := 'TEMP_' || TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF6'),
//   V_DPJT_KEY := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ,'000000') 규칙과 자릿수를 맞춘다.
//   dayjs는 ms(3자리)까지만 주므로 FF6(마이크로초 6자리)는 뒤에 '000'을 붙여 자리수만 맞춘다.
export const createProjectIdentifiers = () => {
  const dpjtCode = `TEMP_${dayjs().format('YYYYMMDDHHmmssSSS')}000`;
  return {
    DPJT_CODE: dpjtCode,
    DPJT_SEQ: '1',
    DPJT_KEY: `${dpjtCode}_000001`,
  };
};

// 요청 2: NAME 콤보가 반환한 CODE를 함께 갱신할 실제 ID 컬럼을 찾는다.
export const getProjectComboIdBinding = (binding: string) =>
  PROJECT_COMBO_ID_BY_NAME[binding as keyof typeof PROJECT_COMBO_ID_BY_NAME];

// 요청 3: 다중 변경행을 행 배열이 아닌 컬럼별 '^' 구분 문자열 한 건으로 저장한다.
//   접는 이유(BE cvtJsonToJVarchar × SP 스칼라 sesUserId)와 빈 값 ' ' 센티널 규칙은
//   SPMS 표준단 lib/bulk-save.ts 가 단일 원천 — 이 화면(SDM1010)이 그 표준의 정본 사용례다.
export const buildProjectSavePayload = (rows: ProjectRow[]): ProjectRow[] =>
  buildBulkSavePayload(rows, PROJECT_SAVE_KEYS, ['SOP_DATE']);

export const buildProjectActionPayload = (rows: ProjectRow[]): ProjectRow[] =>
  buildBulkActionPayload(rows, ['DIVISION_ID', 'DPJT_KEY']);

// 등록요청(REQUEST) — P_SDM1010_BTN_REQ_PJT_REG_MAIN(저장/등록 동시 SP, 2026-09-02 확정) IN 세트.
//   SAVE 13종과 1:1 동일 — SP 1번 P_ACTIVE_FLAG(=CRUD_TYPE)가 행 수 기준
//   (N_MAX_CNT := REGEXP_COUNT(P_ACTIVE_FLAG,'\^')+1)이라 미전달 시 FOR 1..NULL 로
//   ORA-06502 가 터진다(2026-09-02 실측). P_SES_USER_ID 는 BE 세션 주입.
//   CRUD_TYPE 은 행 내부 값 그대로 전송 — 신규 행 'I'(handleInsert 마킹), 편집된 기존 행 'M'
//   (EditTracker 마킹), 미편집 기존 행은 마킹 없음(빈값 → ' ' 센티널).
export const buildProjectRequestPayload = buildProjectSavePayload;

// useCheckbox 그리드에서 체크된 row 를 모은다 — SDM 공통(lib/grid) 재노출 (기존 import 경로 유지)
export { collectCheckedRows } from '../../lib/grid';

export const formatSopDate = (value: WijmoPrimitive | undefined): string => {
  if (value == null || value === '') return '';
  if (typeof value === 'boolean') return String(value);
  const normalized =
    typeof value === 'string' && /^\d{8}$/.test(value)
      ? `${value.slice(0, 4)}-${value.slice(4, 6)}-${value.slice(6, 8)}`
      : value;
  const parsed = dayjs(normalized);
  return parsed.isValid() ? parsed.format('YYYY.MM.DD') : String(value);
};
