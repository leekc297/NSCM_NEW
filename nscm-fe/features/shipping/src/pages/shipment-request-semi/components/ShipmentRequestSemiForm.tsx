import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../shipment-request-semi.constants';
import {
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  PERIOD_OFFSET_DAY,
  PERIOD_TIMEZONE,
} from '../shipment-request-semi.constants';
import { useShipmentRequestSemiStore } from '../useShipmentRequestSemiStore';

interface Props {
  onSearch: () => void;
  /** Model 픽커 버튼(F4/PU03) — 페이지가 MaterialByDivisionModal(COM0013, 다중선택)을 연다. */
  onModelSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// AS-IS SSP0045 조회조건 8필드 + 패널 1 (design 02 §1 F1~F8 / C09).
//   1단: Division* / Operation Group* / Model(+픽커) / From Site   2단: Bucket / Period* / Sum (전부 size3)
//   전체 7칸(2단) = 표준 SRCH-02 "8칸 **초과** 시 extraConditions" 미해당 → **확장 접기 토글 없음**.
//   Bucket·Sum 은 SP 파라미터가 아니라 그리드 가시성 전용이지만 2단에 그대로 노출한다(design 02 §5.6).
//   Period 는 `PeriodField gridSize={3}`(카탈로그 표준 폭) — size6 이면 셀 여백이 Bucket 과의 간격으로 보인다.
//   전체 조회영역 접기(isHidden)는 AS-IS `usrConditionPanel1` HidePanel=C09 대응으로 별개 유지.
//   cascade 1개(2단): (Division, Operation Group) → From Site — 전 단계 **재조회 방식**(design 02 §3).
//   주의: 조회조건 노출 순서는 Model 을 Operation Group 다음(3번째), From Site 를 그 뒤에 둔다
//     (사용자 지시 2026-11-06, 종전 From Site→Model 2026-10-20 지시를 대체). 값·SP 파라미터·cascade
//     동작은 불변 — 표시 순서만 바뀐다(cascade 는 여전히 Div·OperGrp → From Site).
export const ShipmentRequestSemiForm = ({ onSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useShipmentRequestSemiStore(s => s.searchCondition);
  const set = useShipmentRequestSemiStore(s => s.setSearchCondition);
  const setDivision = useShipmentRequestSemiStore(s => s.setDivision);
  const setOperationGroup = useShipmentRequestSemiStore(s => s.setOperationGroup);
  const openSearchArea = useShipmentRequestSemiStore(s => s.openSearchArea);
  const divisionAuthLoaded = useShipmentRequestSemiStore(s => s.divisionAuthLoaded);
  const setDivisionAuthLoaded = useShipmentRequestSemiStore(s => s.setDivisionAuthLoaded);

  const tabId = useTabid();

  // 조회조건 콤보 4종 — 값은 raw 로 넘긴다(인용은 apiClient.getCombo → quoteComboParams 가 일괄 처리).
  //   금지: 공용 카탈로그 `DivisionField`/`BucketField`/`ItemField` 재사용(design 02 §5.5).
  //     특히 `BucketField` 는 내부에서 `W`/`M` 만 남기고 0건이면 하드코딩 폴백이라, 이 화면의
  //     `DAILY/WEEKLY/MONTHLY` 가 **전건 탈락**해 항상 잘못된 목록이 뜬다(K17).
  //   `PlantByDivisionOperation` 은 SQL 토큰 4개를 전부 실어야 한다 — 빠지면 '@' 가 치환되지 않는다(design 02 §5.2).
  const [divisions, operationGroups, buckets] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }, COMBO.OPERATION_GROUP, COMBO.BUCKET],
  });

  // From Site 는 상위 2콤보가 확정된 뒤에만 발사한다(CS1 cascade).
  //   AS-IS 는 cs:242 에서 division 을 바인딩한 **뒤** cs:255 `SetChangedControl()` 로 1회만 조회한다.
  //   게이트가 없으면 초기 렌더에서 `divisionId=''` 로 1회 선발사되는데, Oracle 은 `'' IS NULL` 이 참이라
  //   `PlantByDivisionOperation` 의 관대형 게이트를 통과해 **전체 사이트**가 잠깐 뜬다(iter-1 G-13).
  const [fromSites] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.FROM_SITE,
        divisionId: sc.divisionId,
        operationGroup: sc.operationGroup,
        param3: '',
        plantId: '',
      },
    ],
    enabled: !!sc.divisionId && !!sc.operationGroup,
  });

  // F7 Period 서버 산출 — 전역 기등록 콤보 `SCM0001_GET_SCP_DAY_PERIOD` 1회 조회.
  //   반환 1행 CODE = 'YYYYMMDD:YYYYMMDD'(달력 마스터 clamp + FN_MULTY_TIME(AS054) 서버 KST, design 02 §5.4).
  //   call-proc(SSP0200 BTN_DAY_PERIOD) 대신 콤보를 쓴다 — 이 콤보가 전역 기등록이라 DB 등록이 0건이고,
  //   이 화면 Period 는 편집 불가(Enabled=false)·1회 산출이라 call-proc 의 반복호출(시작일 변동 재계산) 장점이
  //   발동하지 않는다(사용자 결정 2026-10-21, design 02 §5.4). @offsetDay 는 문자열로 넘긴다(SQL TO_NUMBER).
  //   파라미터 인용은 apiClient.getCombo(quoteComboParams)가 일괄 처리하므로 raw 로 전달한다(SRCH-04).
  const [dayPeriod] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.DAY_PERIOD,
        fromDate: '',
        offsetDay: String(PERIOD_OFFSET_DAY),
        timeZone: PERIOD_TIMEZONE,
      },
    ],
  });

  // P2 — AS-IS 는 SP 의 `ORDER BY ATTRIBUTE1` 을 클라에서 **CODE 오름차순으로 덮어쓴다**
  //   (`DataService.GetSSPInnerTable` cs 실측). 재현하지 않으면 목록 순서와 "첫 항목 자동선택" 기본값이 달라진다.
  //   필수: 네 목록 모두 useMemo 로 참조를 고정한다 — 아래 자동선택 effect 들이 이 배열을 deps 로 받으므로
  //   렌더마다 새 배열을 만들면 effect 가 매 렌더 재실행된다(hook #52 계열 안정성 규약).
  const divisionOptions = useMemo(
    () => toOptions(divisions).sort((a, b) => a.value.localeCompare(b.value)),
    [divisions]
  );
  const operationGroupOptions = useMemo(() => toOptions(operationGroups), [operationGroups]);
  const fromSiteOptions = useMemo(() => toOptions(fromSites), [fromSites]);
  const bucketOptions = useMemo(() => toOptions(buckets), [buckets]);

  const divisionsLoaded = divisions !== undefined;

  // R02/G06 — 권한 division 0건이면 조회조건 전체를 비활성하고 1회만 안내한다.
  //   메시지는 `MSG00667`("No authority assigned."). AS-IS 번호 `MSG00097` 은 TO-BE 에서
  //   "Please select Division."(입력 안내)이라 뜻이 다르다(hook #114).
  const noDivisionAuth = divisionsLoaded && divisionOptions.length === 0;
  const alertedRef = useRef(false);
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
  }, [noDivisionAuth, setAlert, t]);

  // 콤보 도착 여부를 페이지에 알린다 — 미도착 상태의 조회를 막는 게이트(권한 판정 전 발사 방지).
  //   필수: deps 에 `divisionAuthLoaded` 자신이 들어간다. F10(Reset Condition)은 공용 경로로 페이지
  //   스토어 `reset()` 을 부르고, `divisionAuthLoaded` 는 공용 `PRESERVED_ON_CONDITION_RESET`
  //   (packages/shared/src/stores/useGloablStore.ts) 보존 목록에 없는 화면 로컬 키라 false 로 떨어진다.
  //   이때 `divisions`(react-query 구조공유로 참조 불변)와 액션 참조는 그대로여서, 자신을 deps 에 넣지
  //   않으면 effect 가 다시 돌지 않고 플래그가 false 로 고착 → 조회가 영구 무동작이 된다
  //   (react-gap-audit iter-2 H-01). 공용 보존 목록 수정은 Hard Boundary 밖이라 화면에서 자가복구한다.
  useEffect(() => {
    if (divisionAuthLoaded !== divisionsLoaded) setDivisionAuthLoaded(divisionsLoaded);
  }, [divisionsLoaded, divisionAuthLoaded, setDivisionAuthLoaded]);

  // AS-IS 는 `ComboBox.DataSource` 대입 시 WinForms 가 index 0 을 자동 선택한다(design 02 §4.2).
  //   TO-BE 는 상태가 곧 렌더이므로 "목록 도착 시 1회" 명시 선택으로 등가 재현한다.
  //   주의: 이 선택은 cascade 를 트리거하지 않는다(진입 시 From Site 재조회는 콤보 파라미터 변화로 1회만).
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) setDivision(divisionOptions[0].value);
  }, [sc.divisionId, divisionOptions, setDivision]);
  useEffect(() => {
    if (!sc.operationGroup && operationGroupOptions.length > 0) {
      setOperationGroup(operationGroupOptions[0].value);
    }
  }, [sc.operationGroup, operationGroupOptions, setOperationGroup]);

  // Period 콤보 도착 시 기간을 서버 산출값('from:to')으로 덮어쓴다(달력 clamp·KST 반영).
  //   미도착/실패(row 없음)면 store makeInitPeriod 의 dayjs 근사가 그대로 남는다 — 폴백이므로 지금보다 나빠지지 않는다.
  //   필수: deps 에 현재 기간을 넣는다. F10(Reset Condition)은 공용 경로로 store 를 makeInitState(기간 dayjs 재시드)로
  //   되돌리는데, 콤보는 쿼리 키가 고정이라 재발사되지 않는다. 기간이 dayjs 로 되돌아가면 서버값과 어긋나므로
  //   이 effect 가 다시 돌아 서버값을 재적용한다. 값이 같아지면 set 을 호출하지 않아 수렴한다(무한루프 없음).
  useEffect(() => {
    const row = dayPeriod?.[0];
    if (!row) return;
    const [from, to] = (str(row.CODE) || str(row.NAME)).split(':');
    if (from && to && (from !== sc.fromYyyymmdd || to !== sc.toYyyymmdd)) {
      set({ fromYyyymmdd: from, toYyyymmdd: to });
    }
  }, [dayPeriod, sc.fromYyyymmdd, sc.toYyyymmdd, set]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* F1 Division* — `MyDivision`(EE 제외 + 권한). mnuId 필수(미전달 시 권한군 ALL, design 02 §5.3). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  autoFocus
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                  //   복귀(commit 51d4e9fa 패턴). 조회(Search) 버튼이 타는 공통 가드와 동일 경로('search').
                  onChange={(_, picked) => {
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* F2 Operation Group* — `OperationGroup_SCP`(P=Pack / A=Cell. E=Electrode 는 SQL 이 제외). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.OPERATION_GROUP, '_Operation group')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  value={sc.operationGroup}
                  options={operationGroupOptions}
                  onChange={(_, picked) => setOperationGroup(String(picked ?? ''))}
                />
              )}
            />
          </Grid>

          {/* F3 Model + F4 픽커(PU03) — 콤마 구분 다중 입력. 픽커 버튼은 필드 오른쪽 외부(popupSearchField).
              표시 순서상 Operation Group 다음(3번째, From Site 앞)에 둔다(사용자 지시 2026-11-06). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  disabled={noDivisionAuth}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noDivisionAuth}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onModelSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* F5 From Site — 다중 + ALL. 미선택(ALL)은 SP 에 **빈 문자열**로 나간다(P3, store.setFilter). */}
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
                  disabled={noDivisionAuth}
                  value={sc.scmSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      scmSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* F6 Bucket — `BucketType`(DAILY/WEEKLY/MONTHLY). 기본값 DAILY(G17). 조회 파라미터 아님.
              표시옵션이지만 전체 8칸(2단)이라 표준 SRCH-02(8칸 **초과** 시에만 extraConditions)상
              확장 접기 토글은 불필요 — AS-IS 2단 배치(Bucket/Period/Sum)처럼 conditions 2단에 그대로
              노출한다(design 02 §5.6). 전체 조회영역 접기(isHidden)는 AS-IS HidePanel=C09 대응으로 별개 유지.
              표시 순서상 Period 앞(2단 첫 칸)에 둔다(사용자 지시 2026-11-06). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, picked) =>
                    set({ bucketType: String(picked ?? '') as BUCKET_TYPE })
                  }
                />
              )}
            />
          </Grid>

          {/* F7 Period* — AS-IS `drpPeriod.Enabled=false`(G15). 서버 산출 고정값(오늘~오늘+55일).
              카탈로그 `PeriodField disabled`(DatePickerCalendar 2개, 입력·팝업 모두 잠금)로 AS-IS 비활성
              daterange 달력을 재현한다 — 자매 demand Shipment Request(ShipmentRequestForm:277)와 동일 패턴.
              공용 수정이 아니라 기존 opt-in prop 사용이라 Hard Boundary 무침범(design 02 §5.8 D3 / §7.2 R3).
              label 은 LBL00013 명시 전달(카탈로그 기본 `LBL00505` 는 DB 미등록, design 02 §4.5 함정).
              표시 순서상 Bucket 다음에 둔다(사용자 지시 2026-11-06). */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            disabled
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
          />

          {/* F8 Sum — 초기 unchecked. SUM(M_/W_) 컬럼 가시성만 바꾼다(재조회 없음).
              정렬: 라벨을 `FormItem` 라벨 트랙(우측정렬)에 둬 위 Period·Bucket 라벨 열과 x 정렬한다.
              bare `customGrid`+`Checkbox labelText` 는 라벨 트랙이 없어 체크박스가 셀 왼쪽(Bucket 뒤)으로
              붙어 위 행과 어긋난다 — GlobalPsiReportForm 2026-10-15 사용자 교정과 동형(Pattern A 정렬 기준).
              세로: Grid 에 `customGrid`(flex + align-items:center)를 걸어 체크박스를 행 높이(36px) 중앙에
              맞춘다 — 없으면 체크박스가 셀 위쪽에 붙는다(GlobalPsiReport 동형). */}
          <Grid size={3} className={commonStyles.customGrid}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, '_Sum')}
              labelAlign='right'
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  {/* AS-IS SetDivisionAuthCheck(cs:237-238)는 `usrLayoutControl2` 컨테이너 전체를 끈다 —
                      Designer dz:126-133 상 chkSum·txtItem_Id 도 그 안이라 8필드 전부가 대상이다(G-06). */}
                  <Checkbox
                    disabled={noDivisionAuth}
                    checked={sc.showSum}
                    onChange={checked => set({ showSum: checked })}
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
