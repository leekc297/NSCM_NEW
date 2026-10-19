import type { MENU_ID, SHEETS } from './global-psi.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0031 은 procedures.d.ts 미등재라 Base 인덱스시그니처
//   fallback(Record<string, WijmoRowItem>)으로 해석된다(자매 SCP0095/SCP0100 동일). pivot 값(D_/W_/M_ 기간칼럼)은
//   메인 SP 가 동적 emit 하므로 정적 타입 열거 불가 — 자매와 동일하게 fallback 을 정본으로 쓴다(04_react-gap §SSOT).
export type GlobalPsiRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건(Form 입력 상태 — searchCondition). design 02 §1 인벤토리 13필드 + §5.3 GET 16-param 매핑.
//   순수 조회 — 저장/입력 필드 없음. cascade 트리거(divisionId/planStartYyyymmdd/planType)도 SP 파라미터라
//   searchCondition 에 둔다 — setFilter 가 spread 가 아니라 명시 매핑이라 조회 파라미터 누출 위험 없음
//   (CLAUDE.local §6, 자매 global-psi-elec setFilter 규약 동일).
export interface SearchCondition {
  divisionId: string; // cboDivision — Division_SCP + FE ATTRIBUTE3!=='EE' && CODE!=='40'. 단일. p_division_id
  itemId: string; // txtItemId — ItemByDivisionModal 이 채움. p_item_id
  nickName: string; // txtNickName — 자유 입력. p_nick_name
  fromSite: string; // clbFromSite — FromSiteByDivision(divisionId 재조회, PLANT). 다중 CSV. p_from_site
  toSite: string; // clbToSite — ToSiteByDivision(divisionId 재조회, 전체). 다중 CSV. p_to_site
  planStartYyyymmdd: string; // cboPlanDate — DATE_WEEKLY1_SCP_ALL(_ALL 로드 후 FE 필터). p_plan_start_yyyymmdd. 단일
  planType: string; // cboPlanType — PlanType1_SCP_ALL(FE 필터). 기본=마지막. p_plan_type
  planSeq: string; // cboPlanSeq — PlanSeq1_SCP_ALL(FE 필터). 기본=index0. p_seq
  bucket: string; // cboBucketType — DAILY(기본)/WEEKLY/MONTHLY. D_/W_/M_ pivot visible 토글(조회 파라미터 p_bucket)
  chkAll: boolean; // chkAll — p_chk_all Y/N. 'Y'면 SP 가 bucket=daily 로 조회(design 03 §2.3)
  chkSum: boolean; // chkSum — SUM 컬럼(주계·월계) 표시 토글(design 03 §2.2). 조회 파라미터 아님(그리드 가시성)
  fromYyyymmdd: string; // dCalendar From — Period(기본 W52). p_from_yyyymmdd
  toYyyymmdd: string; // dCalendar To — Period(기본 W52). p_to_yyyymmdd
}
