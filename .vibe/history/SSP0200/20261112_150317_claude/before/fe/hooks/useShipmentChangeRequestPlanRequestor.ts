import { useEffect } from 'react';

import { useSessionStore } from '@shared/stores';

import type { RequestorRow } from '../shipment-change-request-plan.types';
import { useShipmentChangeRequestPlanStore } from '../useShipmentChangeRequestPlanStore';
import { str } from '../utils/shipmentChangeRequestPlanDerive';

/**
 * detail 조회 SP 2번째 커서(`o_rc2`) 소비 — **승인자(기본값) 전용**이다(design 03 §4.3).
 *
 *   이 커서의 정체는 PKG_SSP0200 본문 실측(ALL_SOURCE 935~963)으로 확정됐다:
 *   `SSP_MST_MODEL_USER + SCM_MST_SSO_USER_INFO + SCM_MST_SSO_DEPT_INFO ... WHERE ROWNUM=1`
 *   = **모델 담당자 1행**이다. AS-IS 도 이 값을 `txtApproval`/`txtAppDeptName`(승인자·승인부서)에만
 *   쓰고(cs:2071~2088), 요청자·요청부서는 세션에서 가져온다(cs:521~524).
 *
 *   금지: 이 커서로 요청자/요청부서를 채우기 — 남의 부서가 요청확정 payload 의 `requestDeptId`
 *   (SP 45 IN 중 5번)로 저장된다. 요청부서는 `store.fetchRequestorDept()`(세션 축)가 담당한다.
 *
 *   승인자는 **빈칸일 때만** 채운다(Δ7 / L-152 / V-10) — 사용자가 고른 값은 덮지 않는다.
 */
export const useShipmentChangeRequestPlanRequestor = (subData: unknown): void => {
  const langCd = useSessionStore(s => s.session.langCd);
  const fillApprovalIfEmpty = useShipmentChangeRequestPlanStore(s => s.fillApprovalIfEmpty);

  useEffect(() => {
    const modelUser = (subData as { o_rc2?: RequestorRow[] } | undefined)?.o_rc2?.[0];
    if (!modelUser) return;
    const isKo = langCd === 'KO';
    const name =
      str(isKo ? modelUser.USER_NAME : modelUser.USER_NAME_EN) || str(modelUser.USER_NAME);
    const dept =
      str(isKo ? modelUser.DEPT_NAME_KO : modelUser.DEPT_NAME_EN) || str(modelUser.DEPT_NAME_KO);
    fillApprovalIfEmpty(name, str(modelUser.USER_ID), dept, str(modelUser.DEPT_ID));
  }, [subData, langCd, fillApprovalIfEmpty]);
};
