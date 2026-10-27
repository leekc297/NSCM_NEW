import { describe, expect, it } from 'vitest';

import type { PlantRow, YieldRow } from '../plan-yield.types';

import {
  isSameOperationGroup,
  toConfirmYieldPayload,
  toSavePlantPayload,
  toSelectedOperationGroup,
} from './plan-yield.payload';

const ctx = { dpjtCode: '26VW01', dpjtBuildNo: '26VW01-B2-N1', sesDivisionId: '81' };

// 커서 실측 형태 — 양극/음극은 OPERATION_GROUP 'E' 공유, MGMT_TYPE(C/A) 로 구분. 공정 코드도 동일(SP_E2000)
const plantRow = (patch: Partial<PlantRow>): PlantRow =>
  ({
    DPJT_BUILD_NO: '26VW01-B2-N1',
    DPJT_KEY: 'PJT0001_000001',
    OPERATION_GROUP: 'E',
    MGMT_TYPE: 'C',
    OPERATION_ID: 'SP_E2000',
    OPERATION_GROUP_NAME: '양극',
    OPERATION_NAME: '믹싱/코팅',
    PLANT_ID: 'ESNA',
    CONFIRM_FLAG: 'CHECKED',
    DISPLAY_SEQ: 1,
    ...patch,
  }) as unknown as PlantRow;

describe('toSavePlantPayload — replace-set 벌크 1건', () => {
  it("전 행을 '^' 조인하고 빈 요청법인은 ' ' 센티널로 자리를 지킨다 (dpjtKey 는 SP 해석 — 미전송)", () => {
    const rows = [
      plantRow({}),
      plantRow({ OPERATION_ID: 'SP_E3000', PLANT_ID: '', CONFIRM_FLAG: 'UNCHECKED' }),
      plantRow({ MGMT_TYPE: 'A', OPERATION_GROUP_NAME: '음극', PLANT_ID: 'ESOC' }),
      plantRow({
        OPERATION_GROUP: 'A',
        MGMT_TYPE: '-',
        OPERATION_ID: 'SP_A7000',
        PLANT_ID: 'ESOC',
      }),
    ];
    const p = toSavePlantPayload(rows, ctx);
    expect(p).toEqual({
      dpjtCode: '26VW01',
      dpjtBuildNo: '26VW01-B2-N1',
      mgmtType: 'C^C^A^-',
      operationGroup: 'E^E^E^A',
      operationId: 'SP_E2000^SP_E3000^SP_E2000^SP_A7000',
      plantId: 'ESNA^ ^ESOC^ESOC',
      confirmFlag: 'CHECKED^UNCHECKED^CHECKED^CHECKED',
      sesDivisionId: '81',
    });
  });

  it('행 0건 = null (호출부가 저장 대상 없음 처리)', () => {
    expect(toSavePlantPayload([], ctx)).toBeNull();
  });
});

// 커서 실측 형태 — SPMS_YIELD_TABLE 키(A7000_LOSS_01040_C00 그룹 / _C01·_C02 조건행)
const yieldRow = (patch: Partial<YieldRow>): YieldRow =>
  ({
    YIELD_MGMT_KEY: 'A7000_LOSS_01040_C01',
    DPJT_KEY: 'PJT0001_000001',
    YIELD_VER: '4.0',
    LEVEL_1: 'Loss',
    LEVEL_2: '형개발_조건 조정',
    LEVEL_3: 'Halfcell 두께',
    LEVEL_4: '200㎛ 미만',
    IS_GROUP: 'N',
    UOM: '[%]',
    CHECKED_FLAG: 'UNCHECKED',
    BASIC_VAL: '0.95',
    YIELD_VAL: '',
    ADD_INFO_1: '',
    CALC_RULE: 'YEILD',
    ...patch,
  }) as unknown as YieldRow;

// 조회·확정 단위 = 구분(공정 그룹). 법인/공정은 행별 값이라 여기 없다.
const group = {
  operationGroup: 'A',
  mgmtType: '-',
  operationGroupName: '조립',
};

describe('toConfirmYieldPayload — 그룹 헤더행 제외 조건행 벌크 1건 (편집값만)', () => {
  it('IS_GROUP=Y 행은 제외. 구분은 스칼라, 법인·공정은 행별 조인 (빈 값 = 공백 센티널)', () => {
    const rows = [
      yieldRow({ YIELD_MGMT_KEY: 'A7000_LOSS_01040_C00', IS_GROUP: 'Y', LEVEL_4: '' }),
      yieldRow({ PLANT_ID: 'ESNA', OPERATION_ID: 'SP_A7000' }),
      yieldRow({
        YIELD_MGMT_KEY: 'A7000_LOSS_01040_C02',
        PLANT_ID: 'ESOC',
        OPERATION_ID: 'SP_A8000',
        LEVEL_4: '200㎛ 이상',
        BASIC_VAL: '0.99',
        CHECKED_FLAG: 'CHECKED',
        YIELD_VAL: 0.9,
        ADD_INFO_1: '두께 조정',
      }),
    ];
    const p = toConfirmYieldPayload(rows, group, ctx);
    expect(p).toEqual({
      dpjtCode: '26VW01',
      dpjtBuildNo: '26VW01-B2-N1',
      operationGroup: 'A',
      mgmtType: '-',
      yieldVer: '4.0',
      yieldMgmtKey: 'A7000_LOSS_01040_C01^A7000_LOSS_01040_C02',
      plantId: 'ESNA^ESOC',
      operationId: 'SP_A7000^SP_A8000',
      checkedFlag: 'UNCHECKED^CHECKED',
      yieldVal: ' ^0.9',
      addInfo1: ' ^두께 조정',
      sesDivisionId: '81',
    });
  });

  it('조건행 0건(그룹행만) = null', () => {
    expect(toConfirmYieldPayload([yieldRow({ IS_GROUP: 'Y' })], group, ctx)).toBeNull();
  });
});

describe('toSelectedOperationGroup / isSameOperationGroup', () => {
  it('그룹 코드 없는 행은 null, 있으면 구분(공정 그룹)으로 변환', () => {
    expect(toSelectedOperationGroup(undefined)).toBeNull();
    expect(toSelectedOperationGroup(plantRow({ OPERATION_GROUP: '' }))).toBeNull();
    expect(toSelectedOperationGroup(plantRow({}))).toEqual({
      operationGroup: 'E',
      mgmtType: 'C',
      operationGroupName: '양극',
    });
  });

  it('같은 구분의 다른 공정·법인 행은 동일 값 — 재조회가 일어나지 않는다', () => {
    const a = toSelectedOperationGroup(plantRow({}));
    expect(
      isSameOperationGroup(
        a,
        toSelectedOperationGroup(plantRow({ OPERATION_ID: 'SP_E3000', PLANT_ID: 'ESOC' }))
      )
    ).toBe(true);
    expect(isSameOperationGroup(null, null)).toBe(true);
  });

  it('양극/음극은 OPERATION_GROUP 이 같은 E — MGMT_TYPE 으로 갈린다', () => {
    const a = toSelectedOperationGroup(plantRow({}));
    expect(isSameOperationGroup(a, toSelectedOperationGroup(plantRow({ MGMT_TYPE: 'A' })))).toBe(
      false
    );
    expect(
      isSameOperationGroup(a, toSelectedOperationGroup(plantRow({ OPERATION_GROUP: 'A' })))
    ).toBe(false);
  });
});
