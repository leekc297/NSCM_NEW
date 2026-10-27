import { useEffect } from 'react';

import type { Menu } from '@foundation/models';
import { useIsBusy } from '@foundation/query-client';
import { CustomDialog } from '@shared/components';
import { ProgressIndicator } from '@shared/lges';
import { MenuIdContext, TabIdContext } from '@shared/stores';

import { ProductionPlanLine } from '../../production-plan-line/ProductionPlanLine';
import { useProductionPlanLineStore } from '../../production-plan-line/useProductionPlanLineStore';
import { DRILLDOWN } from '../global-psi-elec.constants';

// SCP0095 Prod Plan (Engine) 더블클릭 → SCP0013(production-plan-line)을 모달로 오픈(AS-IS openSubMenu 파리티,
//   사용자 지시 2026-10-15). AS-IS 는 팝업 + 5조건(Msc) 자동조회였다(cs L840~848):
//     cboDivision=_division / cboOperationGroup='E' / clbPlantSite=현재행 TO_SITE / txtItemId=현재행 ELEC_MODEL
//     / cboPlanDate=_plan_start_yyyymmdd.
//   TO-BE 는 MDI 탭 전환이 기본 컨벤션이나(plan-control D2), 이 화면만 사용자 지시로 모달 임베드한다.
//   격리: 전용 tabId 로 TabIdContext/MenuIdContext 를 공급해 실제 SCP0013 탭·SCP0095 와 스토어/쿼리키가 섞이지 않게 한다
//   (ViewContainer 의 Provider 구성과 동형).
const DRILLDOWN_TAB_ID = 'scp0095-drilldown-scp0013';

export interface DrilldownParams {
  divisionId: string; // SCP0095 조회조건 division
  plantSiteId: string; // 현재행 TO_SITE
  itemId: string; // 현재행 ELEC_MODEL
  nickName: string; // 현재행 NICK_NAME
  planStartYyyymmdd: string; // SCP0095 조회조건 Plan-date
}

// 조건 seeding — Provider 안에서 돌아야 격리된 SCP0013 스토어 인스턴스(DRILLDOWN_TAB_ID)에 바인딩된다.
//   ProductionPlanLine 마운트 뒤에 배치해(형제 effect 실행순서) Form 기본선택보다 늦게 조건을 심는다.
//   주의: planType/planSeq 는 AS-IS 도 미전달 — SCP0013 Form 의 cascade 기본선택(firstPlanSeq 등)에 의존한다.
//     그래서 자동조회(setFilter)는 콤보 cascade 가 안정될 시간을 두고 best-effort 로 호출한다(로컬 검증 필요).
//   주의: SCP0013 에 F6 저장조건이 있으면 restoreSearchConditions(async) 가 seed 를 덮을 수 있다(저장분 없으면 no-op).
const Seeder = ({ params }: { params: DrilldownParams }) => {
  const setSearchCondition = useProductionPlanLineStore(s => s.setSearchCondition);
  const setFilter = useProductionPlanLineStore(s => s.setFilter);

  useEffect(() => {
    setSearchCondition({
      divisionId: params.divisionId,
      operationGroupId: DRILLDOWN.OPERATION_GROUP, // 'E'
      plantSiteIds: params.plantSiteId ? [params.plantSiteId] : [],
      itemId: params.itemId,
      nickName: params.nickName,
      planStartYyyymmdds: params.planStartYyyymmdd ? [params.planStartYyyymmdd] : [],
    });
    // cascade(plantSite/planType/planSeq) 로드 후 조건이 유효해야 결과가 나오므로 지연 후 자동조회.
    const timer = setTimeout(() => setFilter(), 600);
    return () => clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return null;
};

interface Props {
  open: boolean;
  onClose: () => void;
  params: DrilldownParams | null;
  // SCP0013 메뉴명(findMenuPath + t 로 해석) — 모달 헤더·페이지 제목을 실제 메뉴명과 일치시킨다.
  title: string;
}

export const GlobalPsiElecDrilldownModal = ({ open, onClose, params, title }: Props) => {
  // 임베드 SCP0013 쿼리 로딩 — 쿼리 키 prefix 가 DRILLDOWN_TAB_ID 라 이 탭 스코프만 잡는다. 전역 스피너는
  //   MDIContainer 안(z-index 999)에 그려져 MUI Dialog(portal, z-index ~1300) 뒤에 가려지므로 모달 안에 자급한다.
  const isBusy = useIsBusy([DRILLDOWN_TAB_ID]);

  // 닫혀 있으면 임베드 자체를 마운트하지 않는다(무거운 cascade 화면 — 열릴 때만 생성, 닫으면 스토어도 리셋).
  if (!open || !params) return null;

  // ProductionPlanLine(PageProps.menu)은 실제로 menu 를 소비하지 않으나 타입상 필수 — 최소 스텁(메뉴명 반영).
  const drilldownMenu: Menu = {
    mnuId: DRILLDOWN.TARGET_MENU,
    mnuUrl: 'production-plan-line',
    mnuMsgId: title as Menu['mnuMsgId'], // 미소비 필드 — 브랜디드 translation 타입 회피용 캐스트
    mnuDesc: title,
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic' // basic=드래그·리사이즈 MuiDialog(overflow 는 Popover=하단고정·드래그불가)
      size={1400}
      height='85vh' // 임베드 전체 페이지(제목+조회+툴바+그리드)가 세로로 펼쳐질 높이 확보
      disableScale // size/height 를 1.5배 확대하지 않고 지정값 그대로
      handleClose={onClose}
      title={title}
      customContentArea={
        // 임베드 페이지가 그리드까지 높이를 채우도록 full-height flex 컨테이너로 감싼다(탭 컨테이너 등가).
        //   position:relative = 로딩 스피너 오버레이의 기준 박스.
        <div
          style={{
            position: 'relative',
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            overflow: 'hidden',
          }}
        >
          {/* 조회 로딩 스피너 — MDI 전역 스피너가 모달 뒤에 가려지므로 모달 내부에 자급(ProgressIndicator 동형). */}
          {isBusy ? (
            <div
              style={{
                position: 'absolute',
                inset: 0,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                zIndex: 10,
                pointerEvents: 'none',
              }}
            >
              <ProgressIndicator shape='circular' open />
            </div>
          ) : null}
          <TabIdContext.Provider value={DRILLDOWN_TAB_ID}>
            <MenuIdContext.Provider value={DRILLDOWN.TARGET_MENU}>
              <ProductionPlanLine tabId={DRILLDOWN_TAB_ID} title={title} menu={drilldownMenu} />
              <Seeder params={params} />
            </MenuIdContext.Provider>
          </TabIdContext.Provider>
        </div>
      }
    />
  );
};
