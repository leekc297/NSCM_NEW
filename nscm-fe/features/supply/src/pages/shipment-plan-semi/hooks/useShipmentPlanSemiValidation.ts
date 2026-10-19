// 조회 필수값 검증(design 01 §3, design 02 §0-4/§4) — AS-IS fnValidation 1:1.
//   AS-IS DataUtil.checkRequired(pnlCondition) 는 패널 내 '*' 캡션 컨트롤 전건을 순회한다(design 01
//   §3 .cs:326-328) — Division/OperationGroup 뿐 아니라 cboPlanDate/cboPlanType/cboPlanSeq 도
//   '*' 캡션(Plan-date*/Plan-type*/Seq*)이라 동일하게 MSG00002 대상이다. `ConditionNotUseList`
//   등록은 조회조건 상태복원(재방문 시 컨트롤 값 유지) 제외 트랙일 뿐 checkRequired 와는 별개
//   메커니즘이라(design 01 §3, `BaseForm.cs:1044-1143` 대 `DataUtil.cs:95-368`) 검증 면제 근거가
//   아니다(gap-resolve iter-1 확정 — 독립 react-gap-audit G-07 지적, 4회차 감사 누락 정정).
//   Period(dCalendar) 는 checkRequired 대상에서 실질 제외 — 별도 Check_PeriodDate_New(From/To 존재
//   + From<=To 만).
//   dead code(design 02 §0-5): MSG00171/172(ValidateUserInput("CHK_PERIOD")) 는 호출부 0건이라
//   미이식이 기본(AS-IS 파리티) — 이 훅에서 구현하지 않는다.
import type { SearchCondition } from '../shipment-plan-semi.types';

export interface ValidationResult {
  ok: boolean;
  messageKey?: string;
  defaultMessage?: string;
}

export const useShipmentPlanSemiValidation = () => {
  const validateSearch = (sc: SearchCondition): ValidationResult => {
    if (!sc.divisionId || !sc.operationGroupId || !sc.planStartYyyymmdd || !sc.planType || !sc.planSeq) {
      return { ok: false, messageKey: 'MSG00002', defaultMessage: '_Required field missing.' };
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      return { ok: false, messageKey: 'MSG00049', defaultMessage: '_Period is required.' };
    }
    if (Number(sc.fromYyyymmdd) > Number(sc.toYyyymmdd)) {
      return { ok: false, messageKey: 'MSG00108', defaultMessage: '_Period From must not be after To.' };
    }
    return { ok: true };
  };

  return { validateSearch };
};
