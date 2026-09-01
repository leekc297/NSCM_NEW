import { describe, expect, it } from 'vitest';

import { buildCellPopupSearch, readUnitEnergySlot } from './business-plan.division';

// 신규행 셀 더블클릭 → Model/Project 팝업. 그 행에서 고른 값이 팝업 조회조건으로 올라가야 한다
//   (2026-08-25 리포트 — Team 을 골라 둔 행에서 열어도 팝업이 ALL 로 조회됐다).
describe('buildCellPopupSearch', () => {
  it('40 — 행의 40 슬롯(DEPT_ID40 / END_CUSTOMER40 / SCM_SITE_ID40) 을 싣는다', () => {
    const row = {
      DEPT_ID40: 'SCM2',
      END_CUSTOMER40: 'BYD',
      SCM_SITE_ID40: 'INFAC_KR_JCH',
      // 81·82 슬롯이 함께 있어도 40 은 40 슬롯만 본다
      DEPT_ID: 'WRONG',
      END_CUSTOMER: 'WRONG',
      SCM_SITE_ID81: 'WRONG',
    };

    expect(buildCellPopupSearch(row, '40', 'ITEM')).toEqual({
      divisionId: '40',
      deptId: 'SCM2',
      endCustomer: 'BYD',
      salesSite: 'INFAC_KR_JCH',
      projectCode: '', // 40 은 Project 조건 없음
      itemId: '',
    });
  });

  it('81 — 행의 81 슬롯 + Project 를 싣는다', () => {
    const row = {
      DEPT_ID: 'AUTO1',
      END_CUSTOMER: 'GM',
      SCM_SITE_ID81: 'LGES_PL',
      PROJECT_CODE: 'PRJ-001',
    };

    expect(buildCellPopupSearch(row, '81_HM', 'ITEM')).toEqual({
      divisionId: '81_HM',
      deptId: 'AUTO1',
      endCustomer: 'GM',
      salesSite: 'LGES_PL',
      projectCode: 'PRJ-001',
      itemId: '',
    });
  });

  it('82 — PROJECT_CODE82 / SCM_SITE_ID82 슬롯을 싣는다', () => {
    const row = {
      DEPT_ID: 'ESS1',
      END_CUSTOMER: 'TESLA',
      SCM_SITE_ID82: 'ESS_SITE',
      PROJECT_CODE82: 'PRJ-082',
    };

    expect(buildCellPopupSearch(row, '82', 'ITEM')).toMatchObject({
      salesSite: 'ESS_SITE',
      projectCode: 'PRJ-082',
    });
  });

  it('행 값이 비면 ALL — Project 만 공란', () => {
    expect(buildCellPopupSearch({}, '81', 'ITEM')).toEqual({
      divisionId: '81',
      deptId: 'ALL',
      endCustomer: 'ALL',
      salesSite: 'ALL',
      projectCode: '',
      itemId: '',
    });
  });

  it('PROJECT 팝업 — Project 는 거기서 고를 값이라 조건에서 뺀다 (+ etc=N)', () => {
    const row = { DEPT_ID: 'AUTO1', END_CUSTOMER: 'GM', PROJECT_CODE: 'PRJ-001' };

    expect(buildCellPopupSearch(row, '81', 'PROJECT')).toEqual({
      divisionId: '81',
      deptId: 'AUTO1',
      endCustomer: 'GM',
      salesSite: 'ALL',
      projectCode: '',
      etc: 'N',
    });
  });

  it('공백만 있는 셀은 값 없음으로 본다', () => {
    const row = { DEPT_ID: '   ', END_CUSTOMER: '' };

    expect(buildCellPopupSearch(row, '81', 'ITEM')).toMatchObject({
      deptId: 'ALL',
      endCustomer: 'ALL',
    });
  });
});

// Energy 저장 슬롯 — SP 에 에너지 파라미터는 P_UNIT_ENERGY 하나뿐이라 화면 컬럼 2종을 여기서 합친다.
//   기존행에 40 의 ENERGE_WH(품목 마스터 파생)를 실으면 저장 SP 의 키(UNIT_ENERGY)가 어긋나
//   update 가 아니라 중복 행이 생긴다 — 그래서 신규행 한정이다.
describe('readUnitEnergySlot', () => {
  it('40 신규행 — ENERGE_WH 를 싣는다', () => {
    expect(readUnitEnergySlot({ CRUD_TYPE: 'I', ENERGE_WH: 0.096 }, '40')).toBe('0.096');
  });

  it('40 기존행 — ENERGE_WH 가 있어도 원장 키(UNIT_ENERGY)를 그대로 보낸다', () => {
    expect(readUnitEnergySlot({ ENERGE_WH: 0.096, UNIT_ENERGY: 0 }, '40')).toBe('0');
    expect(readUnitEnergySlot({ ENERGE_WH: 0.096 }, '40')).toBe('');
  });

  it('82 — 신규/기존 모두 UNIT_ENERGY', () => {
    expect(readUnitEnergySlot({ CRUD_TYPE: 'I', UNIT_ENERGY: 12.5, ENERGE_WH: 99 }, '82')).toBe(
      '12.5'
    );
    expect(readUnitEnergySlot({ UNIT_ENERGY: 12.5 }, '82')).toBe('12.5');
  });

  it('40 신규행에 ENERGE_WH 가 비면 UNIT_ENERGY 로 폴백', () => {
    expect(readUnitEnergySlot({ CRUD_TYPE: 'I', ENERGE_WH: '', UNIT_ENERGY: 3 }, '40')).toBe('3');
  });
});
