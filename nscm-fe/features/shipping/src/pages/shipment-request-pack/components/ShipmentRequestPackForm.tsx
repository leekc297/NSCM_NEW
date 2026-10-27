import { MaterialByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, LBL, MENU_ID } from '../shipment-request-pack.constants';
import type { SearchParamProps } from '../shipment-request-pack.types';
import { useShipmentRequestPackStore } from '../useShipmentRequestPackStore';

import { PopupInput } from './PopupInput';

interface Props {
  onSearch: () => void;
}

const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

/**
 * 조회조건 1차 영역(design 02 §1/§3/§5) — Division(고정 disabled)→Team→End Customer→Sales Site
 * 4단 재조회형 cascade + Division→Plant Site 독립 2단 재조회. 전부 서버 재조회형(클라 필터 없음)
 * 이라 각 단계는 `useTabComboQueries`에 상위 선택값을 파라미터로 넘겨 쿼리키 변경으로 자동 재조회한다.
 *
 * BucketType SQL_ID는 이번 회차 ora.py 재실측으로 'BucketType'(SCM_ADM_CMBO_SQL_M, USE_YN='Y')
 * 확정(이전 회차 'DM0003_GET_BUCKET_TYPE_CODE'는 미등록 오기재였음, react-gap-audit 신규 발견 해소).
 * 잔여 6종(MyDivision/TeambyDivision/SoldToCustomerByDivisionDept/SiteByEndCustomer/
 * FromSiteByDivisionOspPack/Plan_InforPacker_SCP)도 이번 회차 ora.py 재실측으로 전건
 * `SCM_ADM_CMBO_SQL_M`에 USE_YN='Y'로 존재함을 확인했다(존재 확인만 — react-gap-audit §11 확인필요②
 * "SQL 본문 의미 패리티" 대사는 SQL_DTL_CTN 원문과 AS-IS 원본 비교가 필요해 여전히 미착수, 다음 회차 이월).
 *
 * 확인 필요(design 02 §7 — 이번 회차 임의 해소 금지):
 * - Project/Model 팝업(SCM0002_ProjectbyDivisionPopupEx / SSP0026_ItembyDivisionPopup) 미배선 —
 *   이번 회차는 텍스트 입력만 우선 배선, 팝업 버튼은 04_react-gap.md 미완 항목.
 */
export const ShipmentRequestPackForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestPackStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestPackStore(state => state.setSearchParams);
  const isOpenSearchArea = useShipmentRequestPackStore(state => state.isOpenSearchArea);

  const [openProject, setOpenProject] = useState(false);
  const [openModel, setOpenModel] = useState(false);

  // Division 은 값이 "40" 고정·disabled 이나 목록(MyDivision)을 공급해야 그 코드의 명칭이 표시된다
  //   (design 02 §5 source=MyDivision·§6 #1 "항상 40 표시"). options 가 비면 라벨 미해소로 빈칸이 된다.
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const [teams] = useTabComboQueries({
    filters: [{ comboId: COMBO.TEAM, divisionId: sp.divisionId }],
  });
  const [endCustomers] = useTabComboQueries({
    filters: [
      { comboId: COMBO.END_CUSTOMER, divisionId: sp.divisionId, teamId: joinComma(sp.teamIds) },
    ],
  });
  const [salesSites] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.SALES_SITE,
        divisionId: sp.divisionId,
        endCustomerId: joinComma(sp.endCustomerIds),
      },
    ],
  });
  const [plantSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: sp.divisionId }],
  });
  const [bucketTypes] = useTabComboQueries({ filters: [COMBO.BUCKET_TYPE] });

  // R3: Team 변경 = End Customer + Sales Site 동시 재조회(자신부터 하위 전체 재계산, design 02 §3).
  const handleTeamChange = (value: string) => {
    setSearchParams({
      teamIds: value.split(',').filter(v => v && v !== 'ALL'),
      endCustomerIds: [],
      salesSiteIds: [],
    });
  };

  // R4: End Customer 변경 = Sales Site만 재조회, Team 은 영향 없음.
  const handleEndCustomerChange = (value: string) => {
    setSearchParams({
      endCustomerIds: value.split(',').filter(v => v && v !== 'ALL'),
      salesSiteIds: [],
    });
  };

  return (
    <>
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH_MAIN, '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSearch}
      conditions={
        // AS-IS 조회조건 순서(design 01 §1 Designer 좌표 y,x) — 2단 접기 구조 없음(단일 단):
        //   Row1(y0): Division · Team · End Customer · Period
        //   Row2(y25): Sales Site · Project · Model
        //   Row3(y49): Plant Site · Bucket
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sp.divisionId}
                  options={(divisions ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  disabled
                  onChange={() => undefined}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TEAM, '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.teamIds.join(',')}
                  options={(teams ?? []).map(r => ({ label: String(r.NAME ?? ''), value: String(r.CODE ?? '') }))}
                  onChange={(_, option) => handleTeamChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.END_CUSTOMER, '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.endCustomerIds.join(',')}
                  options={(endCustomers ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) => handleEndCustomerChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <PeriodRangePicker
              label={t(LBL.PERIOD, '_Period')}
              start={sp.fromYyyymmdd}
              end={sp.toYyyymmdd}
              onChange={(start, end) => setSearchParams({ fromYyyymmdd: start, toYyyymmdd: end })}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SALES_SITE, '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.salesSiteIds.join(',')}
                  options={(salesSites ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({ salesSiteIds: option.split(',').filter(v => v && v !== 'ALL') })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PROJECT, '_Project')}
              labelAlign='right'
              render={() => (
                <PopupInput
                  value={sp.projectCode}
                  onChange={v => setSearchParams({ projectCode: v })}
                  onOpen={() => setOpenProject(true)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <PopupInput
                  value={sp.modelId}
                  onChange={v => setSearchParams({ modelId: v })}
                  onOpen={() => setOpenModel(true)}
                />
              )}
            />
          </Grid>
        </>
      }
      // 2단 접기(design 01 §7 #83) — AS-IS 마지막 행(Plant Site·Bucket)을 확장영역으로 둔다.
      //   순서는 conditions(앞 7개) → extraConditions(뒤 2개)로 AS-IS 좌→우·상→하와 동일하게 유지되고,
      //   SearchArea 가 extraConditions 존재 시 chevron(▼/▲) 토글(기본 접힘)을 자동 노출한다.
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.plantSiteIds.join(',')}
                  options={(plantSites ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({ plantSiteIds: option.split(',').filter(v => v && v !== 'ALL') })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sp.bucketType}
                  // 주의: CODE(SEGMENT1='DAILY'/'WEEKLY'/'MONTHLY', 대문자)가 아니라 NAME(SEGMENT2=
                  //   'Daily'/'Weekly'/'Monthly')을 value 로 쓴다 — 화면 내부 표현(BUCKET_TYPE 상수,
                  //   SearchParamProps['bucketType'] 타입, dynamicColumn.ts BUCKET_PREFIX)이 전부
                  //   NAME 표기와 동일한 대소문자를 쓰므로, CODE 를 그대로 쓰면 selection 즉시
                  //   'DAILY' 로 바뀌어 D_/W_/M_ pivot 컬럼 필터가 전부 매칭 실패한다.
                  options={(bucketTypes ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.NAME ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({ bucketType: option as SearchParamProps['bucketType'] })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
    />

      {/* Project 팝업 — AS-IS btnProject → SCM0002_ProjectbyDivisionPopupEx(공용 ProjectByDivisionModal).
          조회조건 Division/Team/EndCustomer/SalesSite 를 그대로 전달(design 02 §4.6). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode: string) => {
          setSearchParams({ projectCode });
          setOpenProject(false);
        }}
        preSearchParams={
          {
            divisionId: sp.divisionId,
            deptId: joinComma(sp.teamIds),
            endCustomer: joinComma(sp.endCustomerIds),
            salesSite: joinComma(sp.salesSiteIds),
            projectCode: sp.projectCode || 'ALL',
            etc: 'N',
          } as never
        }
        callFromCell={false}
      />

      {/* Model/Nickname 팝업 — 공용 MaterialByDivisionModal(COM0013, 사용자 지시 2026-10-22, SSP0024/0025 동일
          팝업). 종전 ModelByDivisionPopup 에서 교체. Division(40 고정) 단일이라 multiDivision 불요. 상단 메인 GET
          SP 는 modelId 만 받고 nickName 파라미터가 없으므로 선택 품번(ITEM_ID)을 modelId 로만 쓴다(라벨만 통합).
          한계: 이 모달엔 Plant Site 축이 없어 기존 팝업이 넘기던 plantSite 사전필터는 빠진다(SSP0003 전환 동일). */}
      <MaterialByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={items => setSearchParams({ modelId: items })}
        preSearchParams={{
          divisionId: sp.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sp.modelId,
        }}
      />
    </>
  );
};
