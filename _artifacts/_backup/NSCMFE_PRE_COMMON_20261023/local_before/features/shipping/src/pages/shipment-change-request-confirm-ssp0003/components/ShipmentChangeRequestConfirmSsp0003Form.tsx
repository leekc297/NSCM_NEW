import { PeriodField } from 'features/master/src/components';
import { useEffect, useRef } from 'react';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  ALL,
  COMBO,
  EXCLUDE_DIVISION,
  LBL,
  LOOKUP,
} from '../shipment-change-request-confirm-ssp0003.constants';
import { useShipmentChangeRequestConfirmSsp0003Store } from '../useShipmentChangeRequestConfirmSsp0003Store';

interface Props {
  onSearch: () => void;
  onRequestorSearch: () => void;
  onItemSearch: () => void;
  // 액션 3종(Approval/Reject/Self Reject)은 조회영역이 아니라 BtnArea(SubTitle customButtons)가
  //   렌더한다 — 사용자 지시 2026-09-30. 이 폼은 조회조건만 담당한다.
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: (ComboResponse | LookupResponse)[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 §5(02_search-combo.md) 조회조건 7건 — 6필드 초과라 extraConditions 접기(hook #52/#83):
//   메인(5): Division(다중+ALL, EE제외) / From Site(다중+ALL, division cascade) / Request Date(Period, D-14 기본)
//            / Status(ALL선두,기본 D=Drafting, AS-IS 패리티) / Change Type(ALL선두,기본 ALL)
//   확장(2): Model(입력+ItemByDivision 팝업) / Requestor(입력+SsoUser 팝업)
//   주의: gap-resolve iter-1 에서 design 02 §5 정합화 — Request Date 는 D-14 기본값을 갖는 1차 조건이라
//     메인 노출, 보조 팝업 입력(Model/Requestor)을 접힘으로(직전 배치는 반대였음, runtime-parity B-1 해소).
export const ShipmentChangeRequestConfirmSsp0003Form = ({
  onSearch,
  onRequestorSearch,
  onItemSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestConfirmSsp0003Store(s => s.searchCondition);
  const set = useShipmentChangeRequestConfirmSsp0003Store(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestConfirmSsp0003Store(s => s.setPeriod);
  const openSearchArea = useShipmentChangeRequestConfirmSsp0003Store(s => s.openSearchArea);

  // Division = MyDivisionInEE_SCP (권한범위 EE 포함) -> FE 클라 EE 제거(design 02 §2.1).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // From Site = PlantSiteByDivision_SCP @divisionId(=선택 division 콤마조인). Division 변경 시 키 변경 -> 자동 재조회(design 02 §3).
  const fromSiteFilter: ComboParam = {
    comboId: COMBO.FROM_SITE,
    divisionId: sc.divisionIds.join(','),
  };
  const [fromSites] = useTabComboQueries({ filters: [fromSiteFilter] });
  const [changeStatus] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.CHANGE_REQ_STATUS }],
  });
  const [changeTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }] });

  // Division: AS-IS 클라 필터 CODE!=='EE' 재현(design 02 §2.1). 안 하면 AS-IS 보다 넓어짐.
  const divisionOptions = toOptions(divisions).filter(o => o.value !== EXCLUDE_DIVISION);
  // PlantSiteByDivision_SCP 는 선두 더미행('-')을 반환(ora.py 실측) — ALL 과 별개로 노출되므로 제외(design 02 §6).
  const fromSiteOptions = toOptions(fromSites).filter(o => o.value !== '-');
  const statusOptions = toOptions(changeStatus);
  const changeTypeOptions = toOptions(changeTypes);

  // From Site 콤보 "값이 새로 로드"(옵션 내용 변경)될 때만 From Site 선택을 초기화한다(사용자 지시 2026-10-07):
  //   AS-IS 처럼 div 변경 시 초기화하되, **콤보 값이 실제로 새로 불러와진 경우에만** — div 를 바꿔도 옵션이
  //   그대로면 초기화하지 않는다. (종전엔 div 변경만으로 store 가 무조건 비웠다.) 최초 로드/로딩중엔 초기화 안 함.
  //
  //   추가 가드(사용자 신고 2026-10-08 "조건 저장 후 다시 열면 초기화된다"):
  //   **사용자가 Division 을 바꿨을 때만** 초기화한다. 개인화 조건 복원(restoreSearchConditions)이
  //   divisionIds 를 패치하면 From Site 콤보 키(`divisionId: divisionIds.join(',')`)가 바뀌어 재조회가
  //   일어나는데, 종전 구현은 그 재조회를 "div 가 바뀌었다"로 오인해 **복원된 fromSiteIds 를 지웠다**.
  //   옵션집합 비교만으로는 두 경우를 구분할 수 없어, 사용자 조작 여부를 명시 플래그로 들고 간다.
  const prevFromSiteKeyRef = useRef<string | null>(null);
  const divisionChangedByUserRef = useRef(false);
  useEffect(() => {
    if (fromSites === undefined) return; // 재조회 중 — 판단 보류
    const key = fromSiteOptions
      .map(o => o.value)
      .sort()
      .join('|');
    const byUser = divisionChangedByUserRef.current;
    divisionChangedByUserRef.current = false; // 1회 소비
    if (prevFromSiteKeyRef.current === null) {
      prevFromSiteKeyRef.current = key; // 최초 로드 — 기준만 기록(복원/초기 선택 보존)
      return;
    }
    if (key !== prevFromSiteKeyRef.current) {
      prevFromSiteKeyRef.current = key;
      // 사용자 조작이 아니면(복원 등) 기준키만 갱신하고 선택은 보존한다.
      if (byUser && sc.fromSiteIds.length > 0) set({ fromSiteIds: [] });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [fromSites]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division (다중 + ALL) — MyDivisionInEE_SCP + 클라 EE 제거. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // 사용자 조작 표식 — From Site prune effect 가 이 값으로 '복원 재조회'와 구분한다.
                    divisionChangedByUserRef.current = true;
                    set({
                      divisionIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — PlantSiteByDivision_SCP(divisionIds cascade). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      fromSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Status — Row1 3열. CHANGE_REQ_STATUS, ALL 선두, 기본 D(Drafting) — AS-IS SelectedIndex=2 가
              CODE정렬상 Drafting 에 떨어짐. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.STATUS, '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.status}
                  options={statusOptions}
                  onChange={(_, picked) => set({ status: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>

          {/* Row1 4열 — AS-IS `emptySpaceItem1`(X=796, Y=0) 의도적 빈칸. 이게 없으면 Request Date 가
              1행으로 올라와 AS-IS 2행 구성이 깨진다(Change Type 이 Row2 4열이라 자리를 맞춰야 한다). */}
          <Grid size={3} />

          {/* Request Date(기간) — Row2 1열. 기본 D-14(from=오늘-14, to=오늘).
              라벨은 AS-IS `layoutControlItem1.Text="Request Date"` 를 따라 LBL00677 명시
              (PeriodField 기본값 LBL00505='Period' 를 쓰면 AS-IS 와 문구가 다르다). */}
          <PeriodField
            gridSize={3}
            label={t(LBL.REQUEST_DATE, '_Request Date')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* Requestor — Row2 2열(AS-IS X=294, Y=25). 입력 + 돋보기(SsoUserModal, 단일선택), 다건. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.REQUESTOR, '_Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.requestId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onRequestorSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ requestId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model/Nickname — Row2 3열(AS-IS X=554, Y=25). 입력 + 돋보기(MaterialByDivisionModal
              COM0013, division 다중), 다건. design 02 §4.6/§5. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Change Type — Row2 4열(AS-IS PlanType1 X=796, Y=26). CHANGE_REQ_TYPE(P/C/N/A),
              ALL 선두, 기본 ALL. 'P' 는 디테일 그리드 컬럼세트 분기 트리거다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CHANGE_TYPE, '_Change Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.changeType}
                  options={changeTypeOptions}
                  onChange={(_, picked) => set({ changeType: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
