import { MaterialByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';

import { useSessionStore } from '@shared/stores';

import { COLUMN, EXCLUDED_DIVISION, MENU_ID } from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';

import { ApprovalUserModal } from './modals/ApprovalUserModal';
import { InsertMultipleModal } from './modals/InsertMultipleModal';

interface Props {
  divisionId: string;
  openItem: boolean;
  openProject: boolean;
  openApproval: boolean;
  openInsertMultiple: boolean;
  /** 그리드 셀에서 열렸는지 — true 면 결과를 셀에 쓰고, false 면 조회조건 Model 에 쓴다. */
  calledFromCell: boolean;
  /**
   * Model 팝업 사전조회 Model 값 — 셀에서 열 때 그 행에 이미 값이 있으면 그 값으로 팝업이
   * 필터 조회되게 한다(사용자 지시 2026-09-30: 그리드의 Model 값이 팝업에서 조회돼야 함).
   * 조회조건에서 열 때는 빈 값(전체 조회).
   */
  itemSearchValue: string;
  setOpenItem: (open: boolean) => void;
  setOpenProject: (open: boolean) => void;
  setOpenApproval: (open: boolean) => void;
  setOpenInsertMultiple: (open: boolean) => void;
  /** 팝업 대상 셀 참조 해제 — 취소로 닫을 때 호출해야 다음 조회조건 팝업이 셀에 쓰지 않는다. */
  clearPopupTarget: () => void;
  /** 셀에 값을 쓴다(EditTracker 마킹 포함). */
  writeCell: (value: string, nameValue?: string, nameCol?: string) => void;
  setSearchItemId: (itemId: string) => void;
  setRequestInfo: (p: Partial<RequestInfo>) => void;
  onInsertMultiple: (count: number) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 팝업 묶음 — open state 는 페이지가 소유하고 이 컴포넌트는 배치만 한다(nscm-patterns §3.7).
 *
 * 미구현 2종(조용한 제외 금지 — 04 §2-1 G-09):
 *   `SSP0300_OrderDetailPopup`(ERP_SO_NO 더블클릭 드릴다운) ·
 *   `SCM0002_ShipmentPlanRequestPopup`(CHANGE_REQ_NO 단일클릭 드릴다운).
 *   TO-BE 공용 컴포넌트가 없고 화면 전용 신설은 AS-IS 초과 위험이 있어 보고만 한다.
 */
export const ShipmentChangeRequestPlanModals = ({
  divisionId,
  openItem,
  openProject,
  openApproval,
  openInsertMultiple,
  calledFromCell,
  itemSearchValue,
  setOpenItem,
  setOpenProject,
  setOpenApproval,
  setOpenInsertMultiple,
  clearPopupTarget,
  writeCell,
  setSearchItemId,
  setRequestInfo,
  onInsertMultiple,
}: Props) => {
  const langCd = useSessionStore(s => s.session.langCd);

  return (
    <>
    {/* Model/Nickname 조회조건·셀 팝업 — 공용 `MaterialByDivisionModal`(COM0013,
        PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)로 교체(사용자 지시 2026-10-08, 4자매 화면 공통).
        AS-IS 는 `SCM0002_ItembyDivisionPopup`(= DM.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx_40_**TEST**)를
        쓰므로 **조회 SP 가 달라지는 의도적 드리프트**다 — 후보 목록이 AS-IS 와 다를 수 있다(§G-9 기록).
        `scpModuleType` 은 SP 의 Operation Group 분기 기준이고 SSP 화면 ID 는 열거돼 있지 않아
        기본 ELSE 분기(PKG_SCM0002 1750→1766)를 타 기본 Material 목록을 돌려준다(실측).
        빈 값이면 기존 입력을 유지한다(cs:3476). 닫을 때 대상 셀 참조를 끊는다 — 취소 후 조회조건
        돋보기로 열면 값이 셀에 쓰이던 경로 차단. */}
    <MaterialByDivisionModal
      open={openItem}
      modalClose={() => {
        clearPopupTarget();
        setOpenItem(false);
      }}
      setSelectedValue={(itemId, itemName, itemClassName, nickName) => {
        // master 계약 positional: (itemId, itemName, itemClassName, nickName). Nick Name 은 4번째다 —
        //   2번째(itemName)를 받으면 모델 설명(`MC,M,M,46950,…` 속성 나열)이 Nick Name 에 박힌다.
        const picked = str(itemId);
        if (!picked) return;
        if (calledFromCell) writeCell(picked, str(nickName), COLUMN.NICK_NAME);
        else setSearchItemId(picked);
      }}
      preSearchParams={{
        divisionId,
        scpModuleType: MENU_ID,
        operationGroup: '',
        itemId: itemSearchValue,
      }}
    />

    {/* Project 셀 팝업 — SCM0002_ProjectbyDivisionPopup. div=='EE' 면 division 을 빈 값으로 치환한다(cs:5196). */}
    <ProjectByDivisionModal
      open={openProject}
      modalClose={() => {
        clearPopupTarget();
        setOpenProject(false);
      }}
      setSelectedValue={(projectCode, projectName) =>
        writeCell(str(projectCode), str(projectName), COLUMN.PROJECT_NAME)
      }
      preSearchParams={{ divisionId: divisionId === EXCLUDED_DIVISION ? '' : divisionId }}
      callFromCell={true}
    />

    {/* 승인자 검색 — 화면 전용 `ApprovalUserModal`(AS-IS `SSP0002_UserInfoPopup` 등가, 단일선택).
        **AS-IS 는 전사 공용 사용자 팝업을 쓰지 않는다**(2026-10-06 실측으로 확정): 도메인별로 7개가
        따로 있고 SSP 계열 4화면(SSP0002·SSP0050·SSP0200·SSP0201)이 `SSP.Plan.UIL/Popup/
        SSP0002_UserInfoPopup` 하나를 공유한다. 공용 `SsoUserModal`(COM0010)은 AS-IS
        `SystemMgmt.UIL/UserInfoPopup` 계열의 등가라 이 자리에 쓰면 **권한 필터가 없어 전체
        사용자(실측 9,197명)가 노출된다** — AS-IS 이탈이다.
        호출 규약(cs:3153~3161): `SSOUserYN=false`(= SCM_ADM_USER_M 기준) · `SingleSelectYn=true` ·
        500x400. 주석 "C20200312-000078 승인자 조회시 SSP Planner 권한만 조회 되게 팝업 변경".
        후보 조회원은 **AS-IS 원본 SP** `PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST` 다
        (design/15_register_approval_user_proc.sql, 2026-10-06 적용 — 실측 298명). 필터는 SP 내부
        L116~117 `UPPER(USER_GR_ID) IN ('SSP PLANNER','ADMIN','SCM PI ADMIN') AND USE_YN='Y'`.
        SP 머리말이 "SSP Planner 권한 사용자 조회용" 이라 1그룹으로 좁히면 승인자 60명이 사라진다.
        종전 화면 전용 콤보(`SSP0200_ApprovalUserList`) 우회는 권한 판정 조인이 틀려서
        (`SCM_ADM_USER_GR_MPG_M`, AS-IS 가 GrpName 표시용으로만 쓰는 테이블) 집합이 어긋났다 — 폐기.
        반환 인자 순서는 공용 모달과 동일하게 맞춰 아래 배선을 그대로 쓴다.
        AS-IS(cs:3176~3177 item.Dept_Name/Dept_ID)와 동일하게 **부서명은 텍스트박스, 부서ID는 저장용**으로
        채운다(사용자 지시 2026-10-01). appDeptId 가 요청확정 payload approvalDeptId 로 저장돼야 SSP0003
        디테일 조인(B.DEPT_ID=A.APPROVAL_DEPT)이 성립해 승인부서명이 표시된다. */}
    <ApprovalUserModal
      open={openApproval}
      modalClose={() => setOpenApproval(false)}
      setSelectedValue={(userId, userNm, userEngNm, deptNm, deptId) =>
        // AS-IS L-058(cs:3165~3179) 은 KO -> UserName / 그 외 -> UserName_E 로 갈린다.
        //   영문명 우선 고정으로 두면 한국어 사용자에게도 영문명이 박힌다.
        setRequestInfo({
          approvalId: userId,
          approval: (langCd === 'KO' ? userNm || userEngNm : userEngNm || userNm) || userId,
          appDeptId: deptId ?? '', // DEPT_ID -> 저장(approvalDeptId -> APPROVAL_DEPT)
          appDeptName: deptNm ?? '', // DEPT_NM -> Dept 텍스트박스 표시
        })
      }
    />

    {/* 다건 추가 — SSP0200 전용 건수 입력 팝업(btnInsertMultiple). */}
      <InsertMultipleModal
        open={openInsertMultiple}
        modalClose={() => setOpenInsertMultiple(false)}
        onConfirm={onInsertMultiple}
      />
    </>
  );
};
