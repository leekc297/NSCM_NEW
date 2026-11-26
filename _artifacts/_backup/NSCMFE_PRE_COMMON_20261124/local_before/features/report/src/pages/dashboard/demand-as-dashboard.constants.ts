export const MENU_ID = 'DMD0001' as const;
export type MENU_ID = typeof MENU_ID;

// 조회조건 Div 콤보 — SCP0114(Line Master)와 동일 처리.
//   Division_SCP = 권한필터 변형(AS-IS Data_SCP.Common(Type.Division)). mnuId 필수.
//   base 'Division'(권한필터 없음·NAME 미반환) 재사용 금지 — convert-core §2.6.
export const COMBO = {
  DIVISION: 'Division_SCP',
} as const;

// Division 후처리 필터 — AS-IS BLUtils.GetDivisionWithoutEE(ATTRIBUTE3 <> 'EE').
//   이관된 CMBO SQL 에는 없어 FE 클라 필터로 재현한다(SCP0114 와 동일).
export const DIVISION_EXCLUDE_ATTRIBUTE3 = 'EE';

// 임시: 현재 대시보드는 Div=81(Automotive Battery)로만 조회한다.
//   콤보는 라벨 표시용으로만 로드하고 선택은 비활성(disabled)한다.
//   다른 Div 조회를 지원하게 되면 이 고정값을 제거하고 콤보를 활성화한다.
export const FIXED_DIVISION = '81';
