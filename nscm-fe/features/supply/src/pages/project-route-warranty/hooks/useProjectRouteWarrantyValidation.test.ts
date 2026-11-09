import { renderHook } from '@testing-library/react';
import { describe, expect, it } from 'vitest';

import { MSG } from '../project-route-warranty.constants';
import type { MainRow } from '../project-route-warranty.types';

import { useProjectRouteWarrantyValidation } from './useProjectRouteWarrantyValidation';

// 기존행(CRUD_TYPE='M') 기본값 — Warranty(W)·VALID='Y'·PRIORITY≥11·div≠81 로 N8 외 규칙을 건드리지 않는다.
const baseRow = (over: Partial<MainRow>): MainRow =>
  ({
    DIVISION_ID: '80',
    OPERATION_GROUP: 'W',
    VALID_YN: 'Y',
    PRIORITY: 11,
    PRIORITY_SEQ: '1',
    CRUD_TYPE: 'M',
    ITEM_ID: 'IT1',
    SCM_SITE_ID: 'S1',
    PROJECT_CODE: 'P1',
    PLANT_SITE_ID: 'PL1',
    ...over,
  }) as unknown as MainRow;

describe('useProjectRouteWarrantyValidation — 기존행 FROM/TO 순서 검증(ORG_* 스냅샷 회귀)', () => {
  it('기존행에서 TO 를 FROM 보다 이르게 수정하면 N8 순서검증(MSG01230)에 걸린다', () => {
    const { result } = renderHook(() => useProjectRouteWarrantyValidation());
    // 라이브 셀: TO(2023-01-01) < FROM(2024-01-01) — 사용자가 TO 만 과거로 수정한 상태.
    // 스냅샷 ORG_*: 원래 유효하던 순서(2024-01-01 ~ 2024-12-31) — 수정돼도 갱신되지 않는다.
    const row = baseRow({
      FROM_YYYYMMDD: new Date(2024, 0, 1) as unknown as string,
      TO_YYYYMMDD: new Date(2023, 0, 1) as unknown as string,
      ORG_FROM_YYYYMMDD: '20240101',
      ORG_TO_YYYYMMDD: '20241231',
    } as Partial<MainRow>);

    const v = result.current.validateWarrantySave([row]);

    expect(v.ok).toBe(false);
    expect(v.msgId).toBe(MSG.N8_DATE_ORDER);
  });

  it('정상 순서(FROM<=TO)면 통과한다', () => {
    const { result } = renderHook(() => useProjectRouteWarrantyValidation());
    const row = baseRow({
      FROM_YYYYMMDD: new Date(2024, 0, 1) as unknown as string,
      TO_YYYYMMDD: new Date(2024, 11, 31) as unknown as string,
    });

    const v = result.current.validateWarrantySave([row]);

    expect(v.ok).toBe(true);
  });
});
