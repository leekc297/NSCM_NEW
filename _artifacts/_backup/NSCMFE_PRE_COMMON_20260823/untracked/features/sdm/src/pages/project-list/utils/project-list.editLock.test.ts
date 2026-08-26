import { describe, expect, it } from 'vitest';

import type { MainRow } from '../project-list.types';

import {
  canOpenAuthMgmt,
  canReqAuth,
  hasCheckedReq,
  isAdminRow,
  isCellEditable,
  isReqCheckToggleable,
} from './project-list.editLock';

// ⭐ SDM1020 나의 권한(행) × 기능 매트릭스 전수 (제약매트릭스 §1 — P-01~P-04 GET 커서 CASE 실측):
//   ADMIN = 편집 ✅ · 권한관리 ✅('' NULL) · 권한요청 ⛔ · 체크박스 DISABLED
//   WRITE(CONFIRM) = 편집 ⛔ · 권한관리 ⛔('-') · 권한요청 ⛔ · DISABLED
//   READ/NONE = 편집 ⛔ · 권한관리 ⛔('-') · 권한요청 ✅ · UNCHECKED(요청 중 CHECKED)

// GET 커서 행 헬퍼 — SP CASE 산출값 조합 그대로 (P-02 ADMIN 은 '' = NULL 직렬화)
const row = (over: Record<string, unknown> = {}): MainRow =>
  ({
    DPJT_KEY: 'PJT2600001_000001',
    DPJT_AUTH_TYPE: 'NONE',
    DPJT_AUTH_MGMT: '-',
    DPJT_AUTH_REQ_WRITE: 'UNCHECKED',
    DPJT_AUTH_REQ_READ: 'UNCHECKED',
    ...over,
  }) as unknown as MainRow;

const adminRow = () =>
  row({
    DPJT_AUTH_TYPE: 'ADMIN',
    DPJT_AUTH_MGMT: null, // SP '' → NULL 직렬화 (노출)
    DPJT_AUTH_REQ_WRITE: 'DISABLED',
    DPJT_AUTH_REQ_READ: 'DISABLED',
  });

describe('P-01 행 편집 게이트 — ADMIN 행만 (isAdminRow · isCellEditable)', () => {
  it('ADMIN 행 = 편집 가능 (IM/IO — 정오표 D5 재지정 축 + M/O 일반형)', () => {
    expect(isAdminRow(adminRow())).toBe(true);
    expect(isCellEditable('IM', adminRow())).toBe(true);
    expect(isCellEditable('IO', adminRow())).toBe(true);
    expect(isCellEditable('M', adminRow())).toBe(true);
    expect(isCellEditable('O', adminRow())).toBe(true);
  });

  it('비관리자(WRITE/READ/NONE) 행 = 전 셀 잠금', () => {
    for (const auth of ['WRITE', 'READ', 'NONE', '']) {
      expect(isCellEditable('IM', row({ DPJT_AUTH_TYPE: auth }))).toBe(false);
      expect(isCellEditable('IO', row({ DPJT_AUTH_TYPE: auth }))).toBe(false);
    }
  });

  it('S/미지정 컬럼 = ADMIN 이어도 잠금 (INPUT_TP_CD 단일 원천) · 행 부재 = 잠금', () => {
    expect(isCellEditable('S', adminRow())).toBe(false);
    expect(isCellEditable(undefined, adminRow())).toBe(false);
    expect(isCellEditable('IM', undefined)).toBe(false);
  });
});

describe('P-02 권한관리 링크 — SP 산출값 단일 원천 (canOpenAuthMgmt)', () => {
  it("ADMIN 행 = ''(NULL 직렬화) → 링크 노출", () => {
    expect(canOpenAuthMgmt(adminRow())).toBe(true);
    expect(canOpenAuthMgmt(row({ DPJT_AUTH_MGMT: '' }))).toBe(true);
  });

  it("비관리자 행 = '-' 봉인 · 행 부재 = 차단", () => {
    expect(canOpenAuthMgmt(row())).toBe(false);
    expect(canOpenAuthMgmt(undefined)).toBe(false);
  });
});

describe('P-03/P-04 권한요청 링크·체크박스 — 3상태 단일 원천 (canReqAuth · isReqCheckToggleable)', () => {
  it('ADMIN·WRITE CONFIRM 행 = 둘 다 DISABLED → 링크 봉인 + 토글 불가', () => {
    expect(canReqAuth(adminRow())).toBe(false);
    expect(isReqCheckToggleable('DISABLED')).toBe(false);
  });

  it('READ/NONE 행 = UNCHECKED → 링크 노출 + 토글 가능 / 요청 중 = CHECKED 도 토글 가능(해제→취소 경로)', () => {
    expect(canReqAuth(row())).toBe(true);
    expect(canReqAuth(row({ DPJT_AUTH_REQ_WRITE: 'CHECKED' }))).toBe(true);
    expect(isReqCheckToggleable('UNCHECKED')).toBe(true);
    expect(isReqCheckToggleable('CHECKED')).toBe(true);
  });

  it('미지 값·행 부재 = 안전측 차단', () => {
    expect(isReqCheckToggleable('')).toBe(false);
    expect(isReqCheckToggleable(undefined)).toBe(false);
    expect(canReqAuth(undefined)).toBe(false);
    expect(canReqAuth(row({ DPJT_AUTH_REQ_WRITE: 'DISABLED', DPJT_AUTH_REQ_READ: 'DISABLED' }))).toBe(
      false
    );
  });
});

describe('P-11/P-12 체크 존재 판정 (hasCheckedReq — 현재값·원본 스냅샷 공용 술어)', () => {
  it('하나라도 CHECKED = true (WRITE 우선 무관 — 존재 판정만)', () => {
    expect(hasCheckedReq('CHECKED', 'UNCHECKED')).toBe(true);
    expect(hasCheckedReq('UNCHECKED', 'CHECKED')).toBe(true);
  });

  it('둘 다 비CHECKED = false (DISABLED/UNCHECKED/미지 값)', () => {
    expect(hasCheckedReq('UNCHECKED', 'UNCHECKED')).toBe(false);
    expect(hasCheckedReq('DISABLED', 'DISABLED')).toBe(false);
    expect(hasCheckedReq(undefined, null)).toBe(false);
  });
});
