import { FIXED_DIVISION } from './demand-as-dashboard.constants';

// DMD0001 대시보드 조회조건 → 프로시저 요청 파라미터 빌더.
//   proc IN 파라미터(DB 실측): P_DIVISION_ID·P_YYYYMMDD·P_BIZ_TYPE·P_END_CUSTOMER(+차트 P_NICK_NAME).
//   BE 가 'P_' 제거 후 snake→camel 로 요청 키를 유도하므로(BaseService.makeProc) 키는 camel 로 보낸다.

// 화면 조회조건(표시값). division 은 FIXED_DIVISION 고정이라 미포함.
export interface DashboardSearchParams {
  baseMonth: string; // 기준 주차 시작일 'YYYYMMDD'(COMBO.BASE_DATE CODE — 라벨만 '기준월')
  bizType: string; // '전체' | 'Cell' | 'Pack' | 'Module'
  oem: string; // '전체' | End Customer
}

// 비차트 위젯 공통 필터(proc 요청 키).
export interface DashboardBaseFilters {
  divisionId: string;
  yyyymmdd: string;
  bizType: string;
  endCustomer: string;
}

// '전체'(ALL 센티널)는 SP 가 무필터로 해석한다(ALL · 값 없음). 그 외 라벨은 그대로 토큰으로 넘긴다.
const ALL_TOKEN = 'ALL';
const ALL_LABEL = '전체';

export const toBizTypeToken = (label: string): string =>
  label === ALL_LABEL ? ALL_TOKEN : label;

export const toEndCustomerToken = (label: string): string =>
  label === ALL_LABEL ? ALL_TOKEN : label;

export const buildBaseFilters = (sp: DashboardSearchParams): DashboardBaseFilters => ({
  divisionId: FIXED_DIVISION,
  yyyymmdd: sp.baseMonth, // COMBO.BASE_DATE CODE 가 이미 8자리 YYYYMMDD — 그대로 P_YYYYMMDD 로 넘긴다
  bizType: toBizTypeToken(sp.bizType),
  endCustomer: toEndCustomerToken(sp.oem),
});
