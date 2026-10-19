import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';

import { SsoUserModal } from '@shared/components';
import { useSessionStore } from '@shared/stores';

import { COLUMN, EXCLUDED_DIVISION } from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';

import { InsertMultipleModal } from './modals/InsertMultipleModal';

interface Props {
  divisionId: string;
  openItem: boolean;
  openProject: boolean;
  openApproval: boolean;
  openInsertMultiple: boolean;
  /** 그리드 셀에서 열렸는지 — true 면 결과를 셀에 쓰고, false 면 조회조건 Model 에 쓴다. */
  calledFromCell: boolean;
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
    {/* Model 조회조건/셀 팝업 — SCM0002_ItembyDivisionPopup. 빈 값이면 기존 입력을 유지한다(cs:3476).
        AS-IS 는 Div 와 함께 From Site(sScmSite)도 사전필터로 넘기지만(cs:3461) 공용 모달의
        preSearchParams 계약에 site 축이 없어 Div 만 전달한다 — 04 확인필요(G-14).
        닫을 때 대상 셀 참조를 끊는다 — 취소 후 조회조건 돋보기로 열면 값이 셀에 쓰이던 경로 차단. */}
    <ItemByDivisionModal
      open={openItem}
      modalClose={() => {
        clearPopupTarget();
        setOpenItem(false);
      }}
      setSelectedValue={(itemId, nickName) => {
        const picked = str(itemId);
        if (!picked) return;
        if (calledFromCell) writeCell(picked, str(nickName), COLUMN.NICK_NAME);
        else setSearchItemId(picked);
      }}
      preSearchParams={{ divisionId }}
      callFromCell={calledFromCell}
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

    {/* 승인자 검색 — 공용 SsoUserModal(AS-IS SSP0002_UserInfoPopup, 단일선택).
        AS-IS 는 부서명·부서ID 까지 4값을 받지만(cs:3165~3179) 공용 모달은 3값(userId/userNm/userEngNm)만
        준다(packages/shared SsoUserModal:20 실측). 승인부서 2값은 **반드시 비운다** —
        남겨두면 이전 승인자(또는 o_rc2 모델 담당자)의 부서가 요청확정 payload 의 approvalDeptId
        (SP 45 IN 중 7번)로 저장된다. 공용 모달을 4값으로 확장하는 것은 공용 축이라 별건이다(04 확인필요). */}
    <SsoUserModal
      open={openApproval}
      modalClose={() => setOpenApproval(false)}
      setSelectedValue={(userId, userNm, userEngNm) =>
        // AS-IS L-058(cs:3165~3179) 은 KO -> UserName / 그 외 -> UserName_E 로 갈린다.
        //   영문명 우선 고정으로 두면 한국어 사용자에게도 영문명이 박힌다.
        setRequestInfo({
          approvalId: userId,
          approval: (langCd === 'KO' ? userNm || userEngNm : userEngNm || userNm) || userId,
          appDeptId: '',
          appDeptName: '',
        })
      }
      ssoUserYn='N'
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
