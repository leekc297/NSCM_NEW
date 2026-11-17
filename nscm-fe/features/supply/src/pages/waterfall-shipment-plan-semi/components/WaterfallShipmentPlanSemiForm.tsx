import { MaterialByDivisionModal, PeriodField } from 'features/master/src/components';
import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { periodFromDate, useWaterfallShipmentPlanSemiStore } from '../useWaterfallShipmentPlanSemiStore';
import { BUCKET_TYPE, LBL, MENU_ID, MSG } from '../waterfall-shipment-plan-semi.constants';

// SCP0018 조회조건 — AS-IS 레이아웃 그대로(한 줄 4개 × 2줄, 접기 없음). 순서:
//   1행: Division / Operation Group / Model/Nickname / Electrode
//   2행: Version / Bucket / Period / Sum
//   SCP0018.md 변경=O 2건만 변형: Model/Nickname(팝업 MaterialByDivisionModal COM0013, 다건) + Ver.(명칭, 별건).
//   나머지(변경=X)는 AS-IS 그대로 — Div/OperationGroup 단건 기본값(첫 항목), 기본 기간(GetDayRange).
//   extraConditions(F6 펼침 2): ElectrodeType/Sum — 사용빈도 낮은 보조조건 판단(§5, 확인 필요 §7#8).
//   OperationGroup 은 useCascadeFields 미사용 — 트리거별 SQL_ID 자체가 다르다(§2.3 이중 데이터소스,
//   초기 LookupCommon(OPERATION_GROUP_SEMI[_EE]) → division onChange 시 OperationGroup[EE]_SCP 로 전환).

interface WaterfallShipmentPlanSemiFormProps {
  onSubmit: () => void;
}

export const WaterfallShipmentPlanSemiForm = ({ onSubmit }: WaterfallShipmentPlanSemiFormProps) => {
  const { t } = useTranslation();

  const searchParams = useWaterfallShipmentPlanSemiStore(state => state.searchParams);
  const setSearchParams = useWaterfallShipmentPlanSemiStore(state => state.setSearchParams);
  const setDivision = useWaterfallShipmentPlanSemiStore(state => state.setDivision);
  const clearData = useWaterfallShipmentPlanSemiStore(state => state.clearData);
  const isOpenSearchArea = useWaterfallShipmentPlanSemiStore(state => state.isOpenSearchArea);
  const hasDivisionAuth = useWaterfallShipmentPlanSemiStore(state => state.hasDivisionAuth);
  const divisionAuthChecked = useWaterfallShipmentPlanSemiStore(state => state.divisionAuthChecked);
  const setDivisionAuth = useWaterfallShipmentPlanSemiStore(state => state.setDivisionAuth);
  const { setAlert } = useMessageStore();
  const tabId = useTabid();

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const isEE = searchParams.divisionId.trim().toUpperCase().startsWith('EE');

  // Division — Division_SCP(cascade 루트, EE 포함 — 02_search-combo.md §2.1).
  //   AS-IS SCP0018 = BLUtils.GetDivision(false,"") → Type.Division(133) → UP_FX_GetCommonDataList_SCP
  //   @Code='Division' → FN_GET_DIVISION, ORDER BY ATTRIBUTE1(기본 81). 권한 WHERE 는 MyDivisionInEE_SCP
  //   와 동일하고 정렬만 ATTRIBUTE1 → Division_SCP 가 등가(이전 MyDivisionInEE_SCP 는 ORDER BY DIVISION_ID·기본 40 로 불일치).
  const [divisions, bucketTypes, versions, electrodeTypes] = useTabComboQueries({
    filters: [
      'Division_SCP',
      'BucketISO_SCP',
      { comboId: 'WaterfallVer_FG2_SCP', divisionId: searchParams.divisionId },
      { comboId: 'LookupCommon', lookupType: 'ELECTRODE_TYPE' },
    ],
  });

  // OperationGroup — 이중 SQL_ID(§2.3). 초기 로드(division 미변경)는 LookupCommon(division 접두
  //   기준 SEMI/SEMI_EE 코드 분기), division 변경 이벤트는 OperationGroup[EE]_SCP 로 전환한다.
  //   이 화면 전용 개별 훅 배선 — useCascadeFields 는 "조인된 평면 콤보 1건" 전제라 안 맞는다(§5).
  const [initialOperGroup, cascadeOperGroup] = useTabComboQueries({
    filters: [
      { comboId: 'LookupCommon', lookupType: isEE ? 'OPERATION_GROUP_SEMI_EE' : 'OPERATION_GROUP_SEMI' },
      { comboId: isEE ? 'OperationGroupEE_SCP' : 'OperationGroup_SCP', divisionId: searchParams.divisionId },
    ],
  });
  // 최초 진입(division 값이 아직 한 번도 안 바뀐 상태)은 LookupCommon 후보, division 변경 이후는
  //   재조회 SQL_ID 후보로 전환 — divisionTouched 로 두 트리거를 구분한다(§2.3 실측 비등가 재현).
  const [divisionTouched, setDivisionTouched] = useState(false);
  const operGroupOptions = (divisionTouched ? cascadeOperGroup : initialOperGroup ?? cascadeOperGroup)?.map(
    item => ({ label: item.NAME, value: item.CODE })
  ) ?? [];

  // 01_layout.md §2 트리거C — dtDivision.Rows.Count==0(조회 가능 Division 0건) 이면 조회조건
  //   영역 전체 비활성 + MSG00097 안내. divisions 콤보 응답이 처음 도착한 시점에 1회 판정한다.
  useEffect(() => {
    if (divisions === undefined || divisionAuthChecked) return;
    const hasAuth = divisions.length > 0;
    setDivisionAuth(hasAuth);
    if (!hasAuth) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_No Division available.') });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, divisionAuthChecked]);

  const divisionOptions = (divisions ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const bucketOptions = (bucketTypes ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const versionOptions = (versions ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const electrodeOptions = (electrodeTypes ?? []).map(item => ({ label: item.NAME, value: item.CODE }));

  // AS-IS 기본값(SCP0018.md 변경=X — AS-IS 그대로) — Div/Operation Group 은 단건(단일 선택)이라 값이
  //   비면 첫 항목을 자동 선택한다(AS-IS setListBox addAll=false = 첫 행 선택). 다건(Version/Electrode)은
  //   공백=전체(ALL)라 비워 둔다. Search 게이트는 그대로(자동조회 아님 — 기본값만 세팅).
  const firstDivision = divisionOptions[0]?.value;
  useEffect(() => {
    if (searchParams.divisionId || firstDivision === undefined) return;
    setSearchParams({ divisionId: String(firstDivision) });
  }, [firstDivision, searchParams.divisionId, setSearchParams]);

  const firstOperGroup = operGroupOptions[0]?.value;
  useEffect(() => {
    if (searchParams.operationGroup || firstOperGroup === undefined) return;
    setSearchParams({ operationGroup: String(firstOperGroup) });
  }, [firstOperGroup, searchParams.operationGroup, setSearchParams]);

  // Version 선택 변경 시 Period 파생 재계산 — AS-IS GetDayRange(cs:1033~1036): CString.GetCheckedListValue(
  //   dtVersion, ..., true) + Substring(Length-8) = 선택 버전 중 '가장 최신(날짜 max)' 버전의 YYYYMMDD.
  //   즉 선택 순서(배열 마지막)가 아니라 최신 주차 기준이다. 예: 40w/37w/28w 선택 → 40w, 40w 해제 → 37w.
  useEffect(() => {
    const dates = searchParams.versionNos
      .map(v => /SP_W_(\d{8})/.exec(v)?.[1])
      .filter((d): d is string => !!d)
      .sort(); // YYYYMMDD 문자열 오름차순 = 날짜순
    const latest = dates[dates.length - 1]; // 마지막 = 최대 = 가장 최신 버전
    if (!latest) return;
    // AS-IS GetDayRange(cs:1039) → DateUtil.GetDayRange(SP SCM0001_GET_SCP_MONTH_PERIOD) 는 선택 버전일을
    //   기준으로 from/to 를 함께 반환한다 — start 뿐 아니라 end(= 기준일 + 12개월 주초 라운딩)도 재계산한다.
    setSearchParams(periodFromDate(latest));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.versionNos]);

  // 01_layout.md §2 트리거C — 조회 가능 Division 0건이면 조회조건 영역 전체 비활성.
  //   SearchArea 자체는 disabled prop 이 없어 필드 단위로 게이트한다.
  const areaDisabled = !hasDivisionAuth;

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!isOpenSearchArea}
        onSearch={onSubmit}
        sx={{ flexShrink: 0 }}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, 'Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.divisionId}
                    options={divisionOptions}
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀(commit 51d4e9fa 패턴). 이 화면은 read-only 라 dirty 는 항상 없지만 공통 패턴을 동일하게 둔다.
                    onChange={(_, option) => {
                      const picked = String(option ?? '');
                      if (picked === searchParams.divisionId) return;
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (!ok) return;
                        setDivisionTouched(true); // Operation Group 이중 SQL_ID 전환 트리거(§2.3)
                        setDivision(picked);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.OPERATION_GROUP, 'Operation group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.operationGroup}
                    options={operGroupOptions}
                    onChange={(_, option) => setSearchParams({ operationGroup: String(option ?? '') })}
                  />
                )}
              />
            </Grid>
            {/* Model/Nickname — SCP0018.md 조회조건 정리(v0.5) 변경=O: 명칭 Model -> Model/Nickname, 팝업
                ItemByDivisionModal -> MaterialByDivisionModal(COM0013). 다건(개행/콤마) 입력 — 팝업 다건
                선택 시 ITEM_ID csv 를 itemId 에 채운다. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL_NICKNAME, 'Model/Nickname')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    multiline
                    maxRows={3}
                    className={commonStyles.popupSearchField}
                    disabled={areaDisabled}
                    value={searchParams.itemId}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={areaDisabled}
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => setItemModalOpen(true)}
                        />
                      ),
                    }}
                  />
                )}
              />
            </Grid>
            {/* Electrode — AS-IS 1행 4번째(변경=X). 다건(공백=전체 ALL)이라 기본 비움. division=EE 여부로
                활성(!isEE 면 disable). 주의: AS-IS 는 init(SetChangedControl)에서만 평가하고 division 변경
                live 경로(SetOperationGroupByDivision)는 재평가하지 않지만, TO-BE 는 공통 규약("Division 변경
                = 검색조건 초기화", store setDivision)에 따라 division 변경 시 enable 을 live 재평가하고 선택값도
                초기화한다(stale 방지 — AS-IS 고정 동작과 의도적으로 다름, 갭분석 G05 안A). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ELECTRODE, 'Electrode')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    disabled={areaDisabled || !isEE}
                    value={searchParams.electrodeTypes.join(',')}
                    options={electrodeOptions}
                    onChange={(_, picked) =>
                      setSearchParams({
                        electrodeTypes: String(picked ?? '')
                          .split(',')
                          .filter(Boolean),
                      })
                    }
                  />
                )}
              />
            </Grid>
            {/* Version — 필수(*). 라벨은 LBL.VER(=LBL01275, KO/EN/CN 모두 'Ver.', DB 등록 2026-11-12,
                SCM_ADM_MSG_M MSG_TP_CD='LBL'). 과거 'Ver.' 하드코딩은 다국어 미처리라 i18n 코드로 교체. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VER, '_Ver.')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    // Version 은 AS-IS setListBox(dtVersion, clbVersion, false) = addAll=false → ALL 항목 없음·
                    //   공백 기본(선택 안 됨)·필수(*). allOption 미사용 + placeholder='' 로 빈 값=공백 표시.
                    //   (CustomDropdown 은 multiple 기본 placeholder 가 'ALL'(CustomDropdown.tsx:570)이라 공백으로 덮어쓴다.)
                    //   미선택 조회 시 handleSubmit 필수값 체크(versionNos.length===0 → MSG00013)로 차단.
                    multiple
                    placeholder=''
                    useClearIcon
                    limitTags={1}
                    disabled={areaDisabled}
                    value={searchParams.versionNos.join(',')}
                    options={versionOptions}
                    onChange={(_, picked) =>
                      setSearchParams({
                        versionNos: String(picked ?? '')
                          .split(',')
                          .filter(Boolean),
                      })
                    }
                  />
                )}
              />
            </Grid>
            {/* Bucket — AS-IS 2행 2번째(변경=X). UI 조회조건(SP 미전달, 순수 클라 그리드 트리거, §2.4). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.BUCKET, 'Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.bucket}
                    options={bucketOptions}
                    // Bucket 변경 = AS-IS CboBucketType_SelectedIndexChanged → InitSpread_2(siMain) = 그리드
                    //   데이터 클리어(재조회 필요, cs:1108~1120). 컬럼 visible 매트릭스는 그리드가 bucket 로 재계산.
                    onChange={(_, option) => {
                      setSearchParams({ bucket: String(option ?? BUCKET_TYPE.DAILY) });
                      clearData();
                    }}
                  />
                )}
              />
            </Grid>
            <PeriodField
              gridSize={3}
              label={t(LBL.PERIOD, 'Period')}
              start={searchParams.startYyyymmdd}
              end={searchParams.endYyyymmdd}
              onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
            />
            {/* Sum — AS-IS 2행 마지막(변경=X). WEEKLY_ISO 면 숨김(Never), 그 외 표시(01_layout.md §2 트리거D). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={' '}
                labelAlign='right'
                render={() =>
                  searchParams.bucket === BUCKET_TYPE.WEEKLY_ISO ? (
                    <></>
                  ) : (
                    <Checkbox
                      labelText={t(LBL.SUM, 'Sum')}
                      disabled={areaDisabled}
                      checked={searchParams.isSumChecked}
                      onChange={checked => setSearchParams({ isSumChecked: checked })}
                    />
                  )
                }
              />
            </Grid>
          </>
        }
      />
      {/* Material by Division 공용 팝업(COM0013, SCM0002_MaterialByDivisionPopup). SCP0018.md 조회조건
          정리(v0.5) 변경=O 로 ItemByDivisionModal(COM0008)에서 교체. 다건 선택(multiCheckbox) → ITEM_ID csv 를
          itemId 로 채운다. Division 단일이라 multiDivision 불요. */}
      {itemModalOpen && (
        <MaterialByDivisionModal
          open={itemModalOpen}
          modalClose={() => setItemModalOpen(false)}
          setSelectedValue={items => setSearchParams({ itemId: items })}
          multiCheckbox
          preSearchParams={{
            divisionId: searchParams.divisionId,
            operationGroup: '',
            scpModuleType: MENU_ID,
            itemId: searchParams.itemId,
          }}
        />
      )}
    </>
  );
};
