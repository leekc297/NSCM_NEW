import { describe, expect, it } from 'vitest';

import {
  findProcessIndex,
  type SampleProcessRow,
  toProcessMenuId,
  toProcessTabData,
  toStepStatus,
} from './sampleProcessFlow.utils';

describe('toStepStatus — 서버 PROCESS_STATUS → LGES ProcessTab status', () => {
  it('4 상태를 그대로 매핑한다 (대소문자·공백 관대)', () => {
    expect(toStepStatus('DONE')).toBe('done');
    expect(toStepStatus('INPROGRESS')).toBe('inProgress');
    expect(toStepStatus('STANDBY')).toBe('standBy');
    expect(toStepStatus(' disabled ')).toBe('disabled');
  });

  it('미지 값·빈 값은 대기(standBy) — FE 재파생 금지, 서버 확정값만 신뢰', () => {
    expect(toStepStatus('')).toBe('standBy');
    expect(toStepStatus(null)).toBe('standBy');
    expect(toStepStatus('WHATEVER')).toBe('standBy');
  });
});

// 커서 계약 = P_SDM2020_GET_PJT_SAMPLE_PROCESS (lookup SPMS_DPJT_BUILD_PROCESS 7단계 실측)
const rows: SampleProcessRow[] = [
  {
    DPJT_BUILD_PROCESS: 'PROD_REQ',
    DPJT_BUILD_PROCESS_NAME: '생산요청',
    PROCESS_STATUS: 'DONE',
    PROGRESS_CNT: 1,
    TARGET_CNT: 1,
    ATTRIBUTE1: 'SDM2010',
  },
  {
    DPJT_BUILD_PROCESS: 'PLAN_YIELD',
    DPJT_BUILD_PROCESS_NAME: '계획수율',
    PROCESS_STATUS: 'INPROGRESS',
    PROGRESS_CNT: '1',
    TARGET_CNT: '2',
    ATTRIBUTE1: ' SDM2020 ',
  },
  {
    DPJT_BUILD_PROCESS: 'SPEC',
    DPJT_BUILD_PROCESS_NAME: '',
    PROCESS_STATUS: 'DISABLED',
    PROGRESS_CNT: 0,
    TARGET_CNT: 1,
  },
];

describe('toProcessTabData / findProcessIndex', () => {
  it('단계명·건수·상태를 커서 그대로 옮긴다 (이름 없으면 코드 폴백)', () => {
    const data = toProcessTabData(rows);
    expect(data.map(d => d.item.tabName)).toEqual(['생산요청', '계획수율', 'SPEC']);
    expect(data[1].item).toMatchObject({
      status: 'inProgress',
      currentAmount: 1,
      totalAmount: 2,
      delay: 0,
    });
    // DISABLED 는 대기로 낮춰 내보낸다 — 라이브러리가 disabled 항목의 클릭을 막기 때문 (toClickableStatus)
    expect(data[2].item.status).toBe('standBy');
  });

  it('현재 화면 단계 코드 → 선택 인덱스', () => {
    expect(findProcessIndex(rows, 'PLAN_YIELD')).toBe(1);
    expect(findProcessIndex(rows, 'NOPE')).toBe(undefined);
    expect(findProcessIndex(rows)).toBe(undefined);
  });
});

describe('toProcessMenuId — 단계 클릭 이동 대상 메뉴', () => {
  it('ATTRIBUTE1 을 메뉴 ID 로 읽는다 (앞뒤 공백 제거)', () => {
    expect(toProcessMenuId(rows[0])).toBe('SDM2010');
    expect(toProcessMenuId(rows[1])).toBe('SDM2020');
  });

  it('메뉴가 안 붙은 단계·없는 행은 빈 문자열 — 호출부가 이동하지 않는다', () => {
    expect(toProcessMenuId(rows[2])).toBe('');
    expect(toProcessMenuId(undefined)).toBe('');
  });
});
