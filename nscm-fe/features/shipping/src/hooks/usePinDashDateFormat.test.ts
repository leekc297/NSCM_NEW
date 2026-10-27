import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { renderHook } from '@testing-library/react';
import { describe, expect, it } from 'vitest';

import { usePinDashDateFormat } from './usePinDashDateFormat';

// 공용 getFormat(columnMapping.ts)이 날짜 컬럼에 'yyyy.MM.dd' 를 찍는다. 조회는 서버 문자열이라
//   대시로 보이는데 달력 편집은 Date 를 커밋해 점 형식이 되고, 그 점 형식이 행 데이터에 그대로
//   들어가 SP payload 까지 흘러간다. 이 훅은 그 컬럼만 집어 대시로 고정한다.
//   여기서 지키는 계약: (1) 점 형식만 바꾼다 (2) 숫자/기타 포맷은 손대지 않는다
//   (3) 컬럼 재생성(updatedLayout) 뒤에도 유지된다.

interface FakeColumn {
  binding: string;
  format?: string;
}

const fakeGrid = (columns: FakeColumn[]) => {
  const handlers: (() => void)[] = [];
  return {
    columns,
    updatedLayout: {
      addHandler: (fn: () => void) => handlers.push(fn),
      removeHandler: (fn: () => void) => {
        const i = handlers.indexOf(fn);
        if (i >= 0) handlers.splice(i, 1);
      },
    },
    /** Wijmo 가 컬럼을 재생성한 뒤 발생시키는 이벤트를 흉내낸다. */
    fireUpdatedLayout: () => handlers.forEach(fn => fn()),
    handlerCount: () => handlers.length,
  };
};

const renderWith = (grid: ReturnType<typeof fakeGrid>, resetKey?: unknown) =>
  renderHook(
    ({ key }: { key?: unknown }) =>
      usePinDashDateFormat(
        { current: grid as unknown as FlexGridType },
        key
      ),
    { initialProps: { key: resetKey } }
  );

describe('usePinDashDateFormat', () => {
  it('점 형식 날짜 컬럼을 대시로 바꾼다', () => {
    const grid = fakeGrid([
      { binding: 'SHIPMENT_DATE', format: 'yyyy.MM.dd' },
      { binding: 'NEW_ETD', format: 'yyyy.MM.dd' },
    ]);
    renderWith(grid);
    expect(grid.columns.map(c => c.format)).toEqual(['yyyy-MM-dd', 'yyyy-MM-dd']);
  });

  it('날짜가 아닌 포맷은 건드리지 않는다 — 숫자 서식이 깨지면 안 된다', () => {
    const grid = fakeGrid([
      { binding: 'QTY', format: 'n3' },
      { binding: 'RATE', format: 'd0' },
      { binding: 'NAME', format: undefined },
      { binding: 'ETD', format: 'yyyy.MM.dd' },
    ]);
    renderWith(grid);
    expect(grid.columns.map(c => c.format)).toEqual(['n3', 'd0', undefined, 'yyyy-MM-dd']);
  });

  it('이미 대시면 그대로 둔다(멱등)', () => {
    const grid = fakeGrid([{ binding: 'ETD', format: 'yyyy-MM-dd' }]);
    renderWith(grid);
    expect(grid.columns[0].format).toBe('yyyy-MM-dd');
  });

  it('컬럼 재생성(updatedLayout) 뒤에도 다시 적용된다', () => {
    const grid = fakeGrid([{ binding: 'ETD', format: 'yyyy.MM.dd' }]);
    renderWith(grid);
    // 메타 재로드로 컬럼이 공용 getFormat 기준으로 다시 만들어진 상황.
    grid.columns[0].format = 'yyyy.MM.dd';
    grid.fireUpdatedLayout();
    expect(grid.columns[0].format).toBe('yyyy-MM-dd');
  });

  it('언마운트하면 핸들러를 떼어 누수되지 않는다', () => {
    const grid = fakeGrid([{ binding: 'ETD', format: 'yyyy.MM.dd' }]);
    const { unmount } = renderWith(grid);
    expect(grid.handlerCount()).toBe(1);
    unmount();
    expect(grid.handlerCount()).toBe(0);
  });

  it('그리드 ref 가 비어 있어도 던지지 않는다(마운트 순서 경쟁)', () => {
    expect(() =>
      renderHook(() => usePinDashDateFormat({ current: undefined }))
    ).not.toThrow();
  });

  it('resetKey 가 바뀌면 다시 적용한다', () => {
    const grid = fakeGrid([{ binding: 'ETD', format: 'yyyy.MM.dd' }]);
    const { rerender } = renderWith(grid, 'cols-v1');
    grid.columns[0].format = 'yyyy.MM.dd'; // 컬럼 교체로 되돌아간 상태
    rerender({ key: 'cols-v2' });
    expect(grid.columns[0].format).toBe('yyyy-MM-dd');
  });
});
