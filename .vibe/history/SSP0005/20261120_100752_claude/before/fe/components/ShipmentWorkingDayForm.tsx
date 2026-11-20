import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ALL, COMBO, LBL } from '../shipment-working-day.constants';
import { useShipmentWorkingDayStore } from '../useShipmentWorkingDayStore';

interface Props {
  onSearch: () => void;
  // AS-IS SetDivisionAuthCheck(usrLayoutControl2.Enabled=false) 등가 — 권한 Division 0건이면
  //   조회조건 전체를 잠근다(01 R01).
  disabled: boolean;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 02_search-combo.md 영역2 — 조회 파라미터 3필드만 둔다(Company/Div./Period). Day of the week /
//   Input Value / Input 액션은 조회 파라미터가 아니라 Bulk Update 팝업(ShipmentWorkingDayBulkModal)의
//   단발 입력으로 옮겼다 — 요일/값은 그 팝업이 자체 콤보로 조회한다.
//   cascade 는 0건이다(02 §3.1 7축 실측) — useCascadeFields 를 신설하지 않는다.
export const ShipmentWorkingDayForm = ({ onSearch, disabled }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentWorkingDayStore(s => s.searchCondition);
  const setSearchCondition = useShipmentWorkingDayStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentWorkingDayStore(s => s.openSearchArea);

  // 콤보 2종 1 라운드트립.
  //   주의: mnuId 는 화면이 지정하지 않아도 공용 withMenuId 가 탭 menuId 를 자동 주입한다 —
  //   "미전송"(02 §2.1 ④-b / V-21)은 화면 코드로 달성할 수 없다. MyDivision SQL 본문에
  //   `NVL(TRIM(@mnuId),'ALL')='ALL' OR ...` 토큰이 실존하므로, 그룹->메뉴 매핑
  //   (SCM_ADM_USER_GR_MNU_MPG_M)이 비면 교집합이 0행이 되어 Division 콤보가 통째로 비고
  //   권한 게이트가 오발동한다(04_react-gap.md Δ7 / 05_runtime-parity.md H1).
  const [companies, divisions] = useTabComboQueries({
    filters: [COMBO.COMPANY, COMBO.DIVISION],
  });

  const companyOptions = useMemo(() => toOptions(companies), [companies]);
  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);

  // divisionId='ALL' 전개용 코드 목록은 **페이지가 공급한다**(ShipmentWorkingDay.tsx).
  //   금지: 여기서도 setDivisionCodes 를 부르면 두 공급자가 서로 다른 정규화 결과를 번갈아 써
  //   무한 갱신이 된다. 조회조건 영역을 접으면 이 Form 이 언마운트되므로 공급자는 페이지여야 한다.
  // Company 기본값 — AS-IS 는 DataSource 바인딩이 index 0 을 자동 선택한다(CC:362-365).
  //   ALL 옵션이 없으므로 빈값 상태를 두지 않는다.
  //   금지: useRef 1회 가드. F10(조회조건 초기화)은 페이지를 리마운트하지 않고 store.reset() 만
  //   부르므로(useGloablStore.resetSearchCondition), ref 를 쓰면 companyId 가 ''로 돌아온 뒤
  //   영영 다시 채워지지 않아 조회가 "Select Company." 로 영구 차단된다. 조건은 "비어 있으면 채운다"
  //   하나면 충분하다 — 사용자가 고른 값이 있으면 조건이 거짓이라 덮어쓰지 않고, 지우기 아이콘도
  //   꺼 두었으므로 사용자가 스스로 빈값을 만들 수 없다.
  useEffect(() => {
    if (companyOptions.length === 0 || sc.companyId) return;
    setSearchCondition({ companyId: companyOptions[0].value });
  }, [companyOptions, sc.companyId, setSearchCondition]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* F1 Company — ALL 옵션 금지(AS-IS 에 ALL 행이 없다. 주면 전 회사 조회가 새로 생긴다). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.COMPANY, '_Company')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  // AS-IS cboCompany 는 DropDownList + DataSource 바인딩이라 빈 선택이 구조적으로
                  //   존재하지 않는다(index 0 자동선택). 지우기 아이콘을 열어 두면 AS-IS 에 없던
                  //   빈값 상태가 생기고, 빈 companyId 는 SP 에서 회사 필터가 통째로 사라진다.
                  useClearIcon={false}
                  value={sc.companyId}
                  options={companyOptions}
                  onChange={(_, picked) => setSearchCondition({ companyId: str(picked) })}
                />
              )}
            />
          </Grid>
          {/* F2 Div. — 멀티 선택 + ALL. AS-IS clbDivision 은 UsrCheckedList(다중 체크)다
              (setListBox(dtMyDivision, clbDivision, true) + ClearUsrCheckedList(UsrCheckedList control),
              cs:148/164 실측). setFilters 가 'ALL'=권한코드 콤마 전개 / 그 외=선택코드 콤마 그대로 SP
              P_DIVISION_ID(콤마 IN)로 보낸다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  multiple
                  allOption
                  limitTags={1}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // 전체 해제(빈 선택)는 ALL 로 되돌린다 — 빈 divisionId 는 SP 필터를 통째로 없앤다.
                    //   Division 변경 시 그리드는 유지한다(사용자 지시 2026-10-06 — hook #5 그리드 비움
                    //   규범 미적용. 재조회는 Search 로만).
                    setSearchCondition({ divisionId: str(picked) || ALL })
                  }
                />
              )}
            />
          </Grid>
          {/* F3 Period* — 기본값은 PKG_COM0000.P_SCM0001_GET_SCP_PERIOD 가 준다(dayjs 근사 금지).
              PeriodField 는 required 를 내장하고 값 형식이 YYYYMMDD 라 payload 와 같은 축이다. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setSearchCondition({ fromYyyymmdd: start, toYyyymmdd: end })}
          />
        </>
      }
    />
  );
};
