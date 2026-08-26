import type { FlexGrid } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';

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
//   필수: nscm-be MapUtils.cvtJsonToJVarchar 는 JVARCHAR 컬럼을 data[].length 만큼 순회해서 조인하는데,
//   sesUserId^ 는 그 순회 횟수만큼 세션 유저ID를 반복 조인해 채운다. 그런데 SP(P_SDM1010_SAVE_TAB1_PJT_REG)는
//   P_SES_USER_ID 를 루프 밖에서 스칼라 한 번만 받는다 — data 를 원본 N행 배열 그대로 보내면 N>=2일 때
//   sesUserId^ 가 "user^user" 처럼 캐럿 섞인 문자열째로 MGMT_USER_ID/CREATED_BY 에 들어가 버려서
//   TAB1 조회 SP 의 MGMT_USER_ID=USER_ID INNER JOIN 에서 그 행이 통째로 사라진다.
//   그래서 나머지 13개 컬럼은 FE 에서 미리 '^' 조인해 payload 1건으로 만들고 data 배열 길이를 1로 접어
//   보낸다 — BE 가 1회만 순회하니 sesUserId^ 도 반복 없이 스칼라 그대로 채워진다.
export const buildProjectSavePayload = (rows: ProjectRow[]): ProjectRow[] => {
  if (rows.length === 0) return [];
  // rows[0] 스프레드 대신 전 필드를 빈 문자열로 비운다 — ResponseData 타입상 ProjectRow 전 필드가
  // 필요하지만 P_SDM1010_SAVE_TAB1_PJT_REG 가 실제로 쓰는 값은 PROJECT_SAVE_KEYS 13개뿐이라,
  // DIVISION_NAME 등 나머지를 rows[0] 값 그대로 흘려보내면 안 쓰이는데도 Payload 에 실제 값처럼 찍혀 헷갈린다.
  const payload = Object.fromEntries(Object.keys(rows[0]).map(key => [key, ''])) as ProjectRow;
  for (const key of PROJECT_SAVE_KEYS) {
    payload[key] = rows
      .map(row => {
        const value = row[key];
        if (value == null || value === '') return ' ';
        if (key !== 'SOP_DATE') return String(value);
        if (typeof value === 'boolean') return String(value);

        const parsed = dayjs(value);
        return parsed.isValid() ? parsed.format('YYYY-MM-DD HH:mm:ss') : String(value);
      })
      .join('^');
  }
  return [payload];
};

export const buildProjectActionPayload = (rows: ProjectRow[]): ProjectRow[] => {
  if (rows.length === 0) return [];
  return [
    {
      ...rows[0],
      DIVISION_ID: rows.map(row => row.DIVISION_ID).join('^'),
      DPJT_KEY: rows.map(row => row.DPJT_KEY).join('^'),
    },
  ];
};

// useCheckbox 그리드에서 체크된 row 를 모은다 (auth-approval/auth-request 와 동일한 표준 헬퍼).
export const collectCheckedRows = <T>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (const element of grid.rows) {
    if (element?.isSelected) rows.push(element.dataItem as T);
  }
  return rows;
};

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
