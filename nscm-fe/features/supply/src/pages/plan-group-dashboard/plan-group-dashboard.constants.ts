export const MENU_ID = 'SCP0124' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  MAIN = 'main',
  // 조회조건 Plant/Plan Group 공급 — 공용 PKG_COM0000.P_SCP0121_GET_SEARCH_INFO(SCP0039·
  //   SCP0120~0126 공용). AS-IS GetSearchInfo()(cs:178-198) 와 동일 원천(자매 SCP0123 선례).
  SEARCH_INFO = 'searchInfo',
}

export enum RESPONSE_SET {
  MAIN = 'o_rc1',
  // searchInfo 커서 COL_NM(SCM_ADM_PROC_M 실측) — AS-IS Tables[0]=Plant / Tables[3]=Plan Group.
  PLANT_LIST = 'plantList',
  PLAN_GROUP_LIST = 'planGroupList',
}

/**
 * 조회조건 데이터 원천 — AS-IS 소스(SCP0124_PlanGroupDashboard.cs) + TO-BE DB 실측(ora.py)으로 확정.
 *
 * DIVISION: AS-IS `BLUtils.GetDivision(false, "")` = `Data_SCP.Common(Type.Division, false,
 *   NowGroupID, UserId)`(BLUtils.cs:64) — 권한(세션 그룹) 필터 Division 이다(InitControls 가
 *   0건이면 SetDivisionAuthCheck 를 거는 것도 권한 필터임을 뒷받침). TO-BE `Division_SCP`
 *   (@sesUserId/@mnuId 권한조인)와 정합 — 권한필터 없는 공통 `Division` 은 오배선(자매 SCP0123·
 *   SCP0126 도 Division_SCP 정본). `false` 라 ALL 옵션 없음, 기본값은 권한목록 첫 행.
 * PLAN_GROUP / PLANT: AS-IS 는 `GetSearchInfo()` 가 부르는 공용 `P_SCP0121_GET_SEARCH_INFO` 의
 *   Tables[3]=Plan Group / Tables[0]=Plant 를 쓴다(cs:137-138) → TO-BE searchInfo 시트의
 *   `planGroupList`/`plantList` 커서. 둘 다 DIVISION_ID 를 내려주는 전량조회형이라 Division 선택은
 *   FE 클라 필터(RefreshPlanGroupByDivision/RefreshPlantIdByDivision 재현, §2.4). 둘 다 ALL 포함.
 *   주의: 유사명 콤보 `PlantByDivisionAll_SCP` 는 OSP plant 제외(osp_yn='N')·operation 제한 없음이라
 *   AS-IS(OSP union + SCP_PLAN_OPERATION 제한 + EE org-division 매핑)와 집합이 달라 재사용 금지
 *   (convert-core §2.6 이름-매칭 함정).
 */
export const PLAN_GROUP_DASHBOARD_COMBO_ID = {
  DIVISION: 'Division_SCP',
} as const;

/**
 * cboCompleted — AS-IS `cboCompleted.DataBind(Data.Type.YesOrNo, true)`(cs:135) = Y/N 리터럴 +
 * ALL(true=addAll). DB 콤보가 아니다. 조회 시 'ALL'→'' 치환(cs:310).
 */
export const COMPLETED_YN_OPTIONS = [
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
] as const;

/**
 * 조회기간 상한 — AS-IS `DateUtil.Check_PeriodDate`(cs:140-146): To 가 From+1년+7일 **이상**이면
 * 초과로 차단한다(MSG00172 "최대조회기간은 fromdate+{0}", {0}=364+7=371). TO-BE 등가 메시지는
 * MSG01187 "최대 조회일은 From Date + {0} 입니다". 경계는 From+1년+7일(달력 기준), 표시값은 371.
 */
export const MAX_PERIOD_DAYS = 371;

export const PLAN_GROUP_DASHBOARD_COLUMN = {
  PLAN_START_YYYYMMDD: 'PLAN_START_YYYYMMDD',
  DIVISION_ID: 'DIVISION_ID',
  OPMZ_PRS_CD: 'OPMZ_PRS_CD',
  OPMZ_PLAN_GR_ID: 'OPMZ_PLAN_GR_ID',
  OPMZ_PLAN_GR_NAME: 'OPMZ_PLAN_GR_NAME',
  OWNER: 'OWNER',
  COMPLETED_YN: 'COMPLETED_YN',
  FP_TARGET_YN: 'FP_TARGET_YN',
  OPMZ_ACTV_CD: 'OPMZ_ACTV_CD',
  OPMZ_ACTV_NAME: 'OPMZ_ACTV_NAME',
  OPMZ_PLAN_ID: 'OPMZ_PLAN_ID',
  LAST_UPDATED_BY: 'LAST_UPDATED_BY',
  LAST_UPDATE_DATE: 'LAST_UPDATE_DATE',
} as const;
