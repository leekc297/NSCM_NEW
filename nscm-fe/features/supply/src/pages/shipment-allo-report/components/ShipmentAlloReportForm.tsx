import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, LABEL, MENU_ID, MSG } from '../shipment-allo-report.constants';
import { useShipmentAlloReportStore } from '../useShipmentAlloReportStore';

interface Props {
  onSearch: () => void;
  // 조회결과 PlanType/Seq 라벨(AS-IS ulPlanType_Seq1=Main / ulPlanType_Seq2=Gap, "{PLAN_TYPE}, {SEQ}" 예 "MA, 1").
  mainPlanSeq?: string;
  gapPlanSeq?: string;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
// PeriodRangePicker(monthOnly) 는 값이 일 단위(YYYYMMDD)인데 조회 param 은 월 단위(fromYyyymm/toYyyymm)다.
//   경계에서만 환산: From=해당월 1일, To=해당월 말일(SCP0111 통합PSI 동일 패턴).
const monthStart = (v: string): string => (/^\d{6}$/.test(v) ? `${v}01` : '');
const monthEnd = (v: string): string => {
  if (!/^\d{6}$/.test(v)) return '';
  const y = Number(v.slice(0, 4));
  const m = Number(v.slice(4, 6));
  if (m < 1 || m > 12) return '';
  const lastDay = new Date(Date.UTC(y, m, 0)).getUTCDate();
  return `${v}${String(lastDay).padStart(2, '0')}`;
};
const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str((r as Record<string, unknown>).NAME) || str(r.CODE), value: str(r.CODE) }));

// AS-IS SCP0055_Shipment_Allo_Report — design 02 §5.1 SearchArea 매핑.
// Division/OperationGroup/BucketType/CellTypeGr = OnShown 강제 고정 + disabled(design 01 §2 #1-4) —
// 사용자가 바꿀 수 없다(표시만). 실질 조작 가능: Team/FromSite/FCST/PlanDate/GapDate/Period/Model/Nickname.
// SCP0055.md #5/#6: AS-IS Model + Nick Name 2개 조회조건을 단일 'Model/Nickname' 팝업으로 통합(Nick Name 삭제).
export const ShipmentAlloReportForm = ({ onSearch, mainPlanSeq, gapPlanSeq }: Props) => {
  const { t } = useTranslation();
  const sc = useShipmentAlloReportStore(s => s.searchCondition);
  const set = useShipmentAlloReportStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentAlloReportStore(s => s.openSearchArea);

  const [openPopup, setOpenPopup] = useState(false);

  // 콤보 — 화면 고정값(disabled)이라도 데이터소스는 실제로 배선한다(design 02 §5 TO-BE 매핑).
  //   Division/OperationGroup 도 배선해야 콤보가 코드('40'/'A')가 아니라 네임("40 Mobility & IT
  //   Battery"/"Cell")으로 보인다(이 배선 전엔 label=코드 하드코딩이라 코드값이 노출됐다).
  const [
    cellTypeGrRows,
    fromSiteRows,
    dateRows,
    bucketTypeRows,
    divisionRows,
    operationGroupRows,
    teamRows,
  ] = useTabComboQueries({
    filters: [
      { comboId: COMBO.CELL_TYPE_GR },
      { comboId: COMBO.FROM_SITE },
      { comboId: COMBO.DATE_WEEKLY, divisionId: sc.divisionId },
      { comboId: COMBO.BUCKET_TYPE },
      { comboId: COMBO.DIVISION },
      { comboId: COMBO.OPERATION_GROUP },
      // Team(clbTeam) — AS-IS UserTeamByDivision("TeambyDivision", division) 이관. SCM0001_TeamByDivision.
      { comboId: COMBO.TEAM, divisionId: sc.divisionId },
    ],
  });
  const teamOptions = toOptions(teamRows);

  const cellTypeGrOptions = toOptions(cellTypeGrRows);
  const dateOptions = useMemo(() => toOptions(dateRows), [dateRows]);
  const bucketTypeOptions = toOptions(bucketTypeRows);
  // 고정(disabled) 콤보 옵션 — 콤보 로드 전/권한 누락 시에도 코드라도 보이도록 고정값을 폴백 포함.
  const withFixed = (rows: ComboResponse[] | undefined, code: string): Option[] => {
    const opts = toOptions(rows);
    return opts.some(o => o.value === code) ? opts : [{ label: code, value: code }, ...opts];
  };
  // AS-IS SetDivisionAuthCheck(InitControls cs:144-145 → BaseForm.cs:5995): 사용자 권한 Division 0건이면
  //   안내(MSG) + 조회조건 레이아웃(usrLayoutControl2) 전체 Enabled=false. divisionRows(MyDivisionInEE_SCP
  //   응답)가 '조회완료 && 빈 배열'일 때가 권한 0 — 로딩 중(undefined)과 구분(사용자 결정 2026-11-03, AS-IS 재현).
  const noDivisionAuth = divisionRows !== undefined && divisionRows.length === 0;

  // 고정 콤보 폴백 — 로딩 중/정상(권한 보유)엔 고정값(40)을 표시하되, 권한 0건일 때는 AS-IS(OnShown SelectCombo
  //   가 권한목록에 없는 "40"을 선택하지 못함, cs:1460/1473-1492)대로 **40 을 강제 주입하지 않는다**(빈 콤보).
  //   withFixed 의 "권한 누락 시 40 주입"은 설계 의도(02 §2.3 은 0건을 '위험'으로만 명시)가 아니라 로딩용 폴백의
  //   부작용이라, 권한 0 케이스만 AS-IS 와 동일하게 되돌린다(사용자 결정 2026-11-03).
  const divisionOptions = noDivisionAuth ? [] : withFixed(divisionRows, sc.divisionId);
  const operationGroupOptions = withFixed(operationGroupRows, sc.operationGroup);

  // 권한 0건: 1회 안내(MSG00667 = AS-IS MSG00097 등가, constants 주석) + Division 선택값도 비워 AS-IS(미선택 →
  //   빈 division param) 와 동일하게. 조회조건은 아래 disabled 로 전부 비활성(usrLayoutControl2.Enabled=false 등가).
  const authAlertedRef = useRef(false);
  useEffect(() => {
    if (noDivisionAuth && !authAlertedRef.current) {
      authAlertedRef.current = true;
      set({ divisionId: '' });
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
      });
    }
  }, [noDivisionAuth, t, set]);

  // FromSite 클라 후처리 필터(design 02 §2.3/§4c 필수) — OperationGroup(고정 'A') + Division(고정 '40') 일치만.
  const fromSiteOptions = useMemo(() => {
    const rows = (fromSiteRows ?? []) as Record<string, unknown>[];
    return toOptions(
      rows.filter(r => str(r.OPERATION_GROUP) === sc.operationGroup && str(r.DIVISION_ID) === sc.divisionId) as ComboResponse[]
    );
  }, [fromSiteRows, sc.operationGroup, sc.divisionId]);

  // PlanDate 기본값 — 목록 첫 항목. dep 에 sc.planDate 를 함께 둬 F10(조회조건 초기화)로 planDate 가
  //   ''로 비워져도 이 effect 가 재발화해 기본값(첫 항목)으로 자가복구한다 — planDate 는 필수 조회조건이라
  //   firstDate 단일 dep(마운트/division 변경 시만 발화)로는 F10 뒤 영구 공란이 된다(값축 effect 복구).
  // 기본값(AS-IS 첫 오픈): PlanDate=목록 첫 항목(최신주, DATE_WEEKLY DESC), GapDate=그 다음 항목(index+1).
  //   AS-IS 예: PlanDate 2026-10-26(W44) / GapDate 2026-10-19(W43). planDate 가 비면(진입·F10 초기화)
  //   둘 다 재설정해 GapDate 공란으로 남지 않게 한다(이전엔 planDate 만 세팅돼 GapDate 가 빈 채였음).
  const firstDate = dateOptions[0]?.value ?? '';
  const secondDate = dateOptions[1]?.value ?? '';
  useEffect(() => {
    if (firstDate && !sc.planDate) set({ planDate: firstDate, gapDate: secondDate || sc.gapDate });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDate, secondDate, sc.planDate]);

  // PlanDate 변경 시 GapDate = 옵션 배열 index+1 항목으로 자동 동기화(값 매칭 아님, design 02 §3 §5).
  const handlePlanDateChange = (v: string) => {
    const idx = dateOptions.findIndex(o => o.value === v);
    const next = idx >= 0 ? dateOptions[idx + 1]?.value : undefined;
    set({ planDate: v, gapDate: next ?? sc.gapDate });
  };

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            // 권한 Division 0건이면 전 조회조건 비활성화(AS-IS usrLayoutControl2.Enabled=false 재현).
            disabled={disabled || noDivisionAuth}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const multi = (labelText: string, value: string, options: Option[], onPick: (codes: string) => void) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value}
            options={options}
            disabled={noDivisionAuth}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const popupField_ = (labelText: string, value: string, onPopup: () => void) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            disabled={noDivisionAuth}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  disabled={noDivisionAuth}
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={onPopup}
                />
              ),
            }}
            // AS-IS txtModel_ID 는 읽기전용이 아니라 직접 입력(복사·붙여넣기)도 가능하다
            //   (design 02 §4.6: "텍스트 input(읽기전용 아님, 팝업으로 채움)"). 직접 입력 시
            //   itemId 를 갱신하고 nickName(팝업이 함께 채운 값)은 비운다(형제 화면 동일 패턴).
            onChange={e => set({ itemId: e.target.value, nickName: '' })}
          />
        )}
      />
    </Grid>
  );

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search(F5)')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* 필드 배치 순서 = 테스트 이슈 "조회조건 순서 조정"(사용자 지시 2026-11-24):
                  1행 Div · Plan Date · Gap Date · Model/Nickname
                  2행 From Site · Team · Period · FCST Pegging
                  3행(접기) Operation Group · Cell Type Gr · Bucket — 화면 고정값(disabled)이라 접어 둔다.
                AS-IS Model + Nick Name 2필드는 Model/Nickname 1필드로 통합(#5/#6). */}
            {single(t(LABEL.DIVISION, { defaultValue: 'Division' }), sc.divisionId, divisionOptions, () => undefined, true, true)}
            {single(t(LABEL.PLAN_DATE, { defaultValue: 'Plan Date' }), sc.planDate, dateOptions, handlePlanDateChange, true)}
            {single(t(LABEL.GAP_DATE, { defaultValue: 'Gap Date' }), sc.gapDate, dateOptions, v => set({ gapDate: v }), true)}
            {popupField_(t(LABEL.MODEL_NICKNAME, { defaultValue: 'Model/Nickname' }), sc.itemId, () => setOpenPopup(true))}
            {multi(t(LABEL.FROM_SITE, { defaultValue: 'From Site' }), sc.fromSite, fromSiteOptions, v => set({ fromSite: v }))}
            {multi(t(LABEL.TEAM, { defaultValue: 'Team' }), sc.team, teamOptions, v => set({ team: v }))}
            {/* Period(월 범위) — SCP0111 통합PSI 와 동일한 PeriodRangePicker(monthOnly): 조밀 입력칸
                (YYYY-MM) + 달력 팝업. 인라인 월 그리드(DatePickerCalendar)에서 교체(사용자 지시 2026-10-30).
                값 계약은 YYYYMMDD 라 경계에서 YYYYMM 과 환산(monthStart/monthEnd). */}
            {/* PeriodRangePicker 는 disabled prop 이 없어, 권한 0 시 상위 래퍼로 상호작용 차단(pointer-events)
                + 흐림(opacity) 처리해 다른 비활성 필드와 시각/동작을 맞춘다(AS-IS usrLayoutControl2 전체 비활성). */}
            <Grid
              size={3}
              style={noDivisionAuth ? { pointerEvents: 'none', opacity: 0.5 } : undefined}
            >
              <PeriodRangePicker
                className={commonStyles.formItem}
                label={t(LABEL.PERIOD, { defaultValue: 'Period' })}
                monthOnly
                start={monthStart(sc.fromYyyymm)}
                end={monthEnd(sc.toYyyymm)}
                onChange={(start, end) => set({ fromYyyymm: start.slice(0, 6), toYyyymm: end.slice(0, 6) })}
              />
              {/* 조회결과 PlanType/Seq(AS-IS ulPlanType_Seq1=Main / ulPlanType_Seq2=Gap, .cs:595/597)
                  — 각 날짜 피커 아래 정렬: Main=From(시작월) 박스 아래 / Gap=To(종료월) 박스 아래.
                  주의: 위 PeriodRangePicker 의 .trigger 는 flex(gap 8px) 좌측 정렬이고 그 안의
                  [From 박스][~ 구분자][To 박스] 가 전부 flex:none(내용폭)이라 좌측에 몰려 있다.
                  고정 px 격자(과거)나 flex:1 중앙(과거)로 그리면 박스 배치와 어긋나 브라우저 폭에 따라
                  텍스트만 따로 움직였다(사용자 신고 2026-11-06). 해결: 이 행도 상위 FormItem 과 동일한
                  grid(minmax(70,140) auto) 로 라벨 칼럼만큼 오프셋한 뒤, 필드 칼럼을 .trigger 와 똑같이
                  flex(gap 8px) 좌측 정렬로 두고 각 셀을 박스와 같은 flex:none·동일 폭으로 맞춰
                  From/To 박스 바로 아래에 못박는다(폭이 바뀌어도 박스와 함께 고정). 박스 폭은 monthOnly
                  날짜 박스(.dateBox, 'YYYY.MM' 내용폭) 실측 ~91px. */}
              {(mainPlanSeq || gapPlanSeq) && (
                <div style={{ display: 'grid', gridTemplateColumns: 'minmax(70px, 140px) auto', marginTop: 2 }}>
                  <span />
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 11, color: '#666' }}>
                    {/* From 박스(.dateBox ~91px) 아래 중앙 — AS-IS ulPlanType_Seq1 MiddleCenter.
                        AS-IS 는 PlanType/Seq 값만 찍는다(.cs:595, Designer .Text 초기값 없음) — "Main:" 접두어 없음. */}
                    <span style={{ flex: 'none', width: 91, textAlign: 'center', whiteSpace: 'nowrap' }}>{mainPlanSeq}</span>
                    {/* .trigger 의 '~' 구분자와 동일 폭(그쪽 '~'는 16px 내용폭)으로 자리만 비워
                        From/To 박스 사이 간격을 똑같이 맞춘다 — 이 행 글자(11px)와 무관하게 16px 고정. */}
                    <span style={{ flex: 'none', visibility: 'hidden', fontSize: 16 }}>~</span>
                    {/* To 박스(.dateBox ~91px) 아래 중앙 — AS-IS ulPlanType_Seq2 MiddleCenter.
                        AS-IS 는 PlanType/Seq 값만 찍는다(.cs:597) — "Gap:" 접두어 없음. */}
                    <span style={{ flex: 'none', width: 91, textAlign: 'center', whiteSpace: 'nowrap' }}>{gapPlanSeq}</span>
                  </div>
                </div>
              )}
            </Grid>
            {/* FCST Pegging — AS-IS 3행(Plan Date 옆) 체크박스 chkFCST("FCST Pegging", Designer L1313). 체크 시
                P_FCST_YN='Y' 전송(.cs:765-769,796). Designer L1315 가 chkFCST.Visible=false 지만 이 컨트롤은
                DevExpress LayoutControlItem(layoutFCST)에 담겨 있고 layoutFCST 에 Visibility 설정이 없어(기본
                Always) 런타임엔 레이아웃이 표시한다 → AS-IS 실화면에 노출됨(사용자 실관찰 2026-11-06). 이전
                '숨김' 결정(설계 01 §5.3·02 §4.3, 2026-11-03)은 Visible=false 한 줄만 본 오판이라 '노출'로 정정. */}
            {/* SCP0009(Shipment Plan FG)의 Sum 체크박스와 동일 간격·정렬: FormItem 라벨 칸은 공백,
                customGrid(flex·align-items:center)로 체크박스를 행 높이 기준 세로 중앙 정렬한다. */}
            <Grid size={3} className={commonStyles.customGrid}>
              <FormItem
                className={commonStyles.formItem}
                label={' '}
                labelAlign='right'
                render={() => (
                  <Checkbox
                    disabled={noDivisionAuth}
                    checked={sc.fcstYn}
                    labelText={t(LABEL.FCST_PEGGING, { defaultValue: 'FCST Pegging' })}
                    onChange={checked => set({ fcstYn: Boolean(checked) })}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <>
            {/* 3줄째 = 화면 고정값(disabled) 3종. SearchArea 는 extraConditions 가 있으면 접기 토글
                (ArrowChevron 버튼)을 자동 노출하고 기본 접힘이다. */}
            {single(
              t(LABEL.OPERATION_GROUP, { defaultValue: 'Operation Group' }),
              sc.operationGroup,
              operationGroupOptions,
              () => undefined,
              true,
              true
            )}
            {single(t(LABEL.CELL_TYPE_GR, { defaultValue: 'Cell Type Gr' }), sc.cellTypeGr, cellTypeGrOptions, () => undefined, false, true)}
            {single(t(LABEL.BUCKET, { defaultValue: 'Bucket' }), sc.bucketType, bucketTypeOptions, () => undefined, false, true)}
          </>
        }
      />

      {/* Model/Nickname 팝업 — SCP0055.md #5/#6 통합: 단일 팝업이 itemId·nickName 둘 다 반환(P_ITEM_ID/
          P_NICKNAME 유지). AS-IS Model/Nick Name 2개 버튼을 하나로 합침(design 02 §4.6).
          팝업 컴포넌트는 SCP0055.md 지정대로 MaterialByDivisionModal(COM0013) 사용(사용자 결정 2026-11-02).
          다중 선택(SCP0055.md Model/Nickname = 텍스트/다중, 사용자 지시 2026-11-02): multiCheckbox 체크박스
            컬럼으로 복수 선택한다. 콜백 인자 (items, itemName?, itemClassName?, nickName?, nickNames?) 중
            items=선택 ITEM_ID 콤마결합, nickNames(5번째)=선택 NICK_NAME 콤마결합 → 둘 다 콤마결합본을 쓴다
            (단일 선택 시 nickName 4번째와 동일값). AS-IS SCM0002 가 ItemID+NickName 둘 다 반환(.cs:1386,1413). */}
      <MaterialByDivisionModal
        open={openPopup}
        modalClose={() => setOpenPopup(false)}
        multiCheckbox
        setSelectedValue={(items, _itemName, _itemClassName, _nickName, nickNames) =>
          set({ itemId: items, nickName: nickNames ?? '' })
        }
        preSearchParams={{ divisionId: sc.divisionId, scpModuleType: MENU_ID, operationGroup: '', itemId: sc.itemId }}
      />
    </>
  );
};
