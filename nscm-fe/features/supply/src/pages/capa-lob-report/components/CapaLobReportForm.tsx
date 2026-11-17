import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  ALL_SENTINEL,
  DIVISION_TYPE,
  LBL_MODULE_PACK,
  type DivisionType,
} from '../capa-lob-report.constants';
import type { ComboOption } from '../capa-lob-report.types';
import type { CapaLobReportCombos } from '../hooks/useCapaLobReportCombos';
import { useCapaLobReportStore } from '../useCapaLobReportStore';

interface Props {
  combos: CapaLobReportCombos;
  onSearch: () => void;
  onOpenItemPopup: () => void;
  /** Division 권한 0건 — 조회영역 전체 비활성(01 L-04 / 02 §4.3). */
  disabled: boolean;
}

/**
 * 조회조건 14필드 (design 02 §1 / §5.3).
 *
 * 단 구성 — AS-IS LOB Report 조회조건 순서 그대로(2026-11-04, 명칭·타입 유지). 줄당 4필드·각 size 3 으로 12칸을 채워 줄 경계를 고정한다.
 * 접기 경계: AS-IS 3행(Site~Line Type)부터 접힌다(사용자 지정) — `conditions`(항상 노출) = AS-IS 1·2행, `extraConditions`(확장 접기) = AS-IS 3행:
 *   `conditions`      1단 = Operation group(3) · Basic Nickname+팝업(3) · Bottleneck(3) · 빈칸 spacer(3) = 12  // AS-IS 1행은 3필드뿐
 *   `conditions`      2단 = Division(3) · Plan Month(3) · Version+Plan Type(3, 한 칸에 콤보+RP 회색칸) · Status(3) = 12
 *   `extraConditions` 3단 = Site(3) · Plant(3) · Building(3) · Line(3) = 12
 *   `extraConditions` 4단 = Operation(3) · Line Type(3) = 6
 * Operation/Line Type 은 Electrode 모드에서 숨어 4단에 빈칸이 생길 수 있다(동적 가시성 — 아래).
 *
 * 동적 가시성 2규칙의 **조건식 비대칭을 통일하지 않는다**(01 L-16/L-17):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = divisionType === 'CELL'
 * Module/Pack 에서 Operation 은 보이고 Line Type 은 숨는다 — 자매 SCP0105(CELL·MODULE_PACK 둘 다 표시)와
 * 조건이 다르다. "정리" 하면 파리티가 깨진다.
 *
 * **필수 조회조건을 만들지 않는다.** AS-IS `DataUtil.InitCheck` 는 `LayoutControlItem.Text` 가 `*` 로
 * 끝나는 항목만 검사하고 SCP0108 의 라벨 12종에 `*` 가 0건이다(01 L-23 / 02 §4.3 / V-24).
 * Search 전 alert 를 신설하면 오히려 위반이다.
 */
export const CapaLobReportForm = ({ combos, onSearch, onOpenItemPopup, disabled }: Props) => {
  const { t } = useTranslation();

  const sp = useCapaLobReportStore(state => state.searchParams);
  const setSearchParams = useCapaLobReportStore(state => state.setSearchParams);
  // Division 변경 = Division·부모축 제외 전 조건 + 그리드 초기화(TO-BE 공통 요건, store 단일 액션).
  const setDivision = useCapaLobReportStore(state => state.setDivision);
  // AS-IS `RefreshElectrodeType` 호출 지점(Division / DivisionType / Operation)에서만 부른다 — 02 V-15.
  const syncLineTypeSource = useCapaLobReportStore(state => state.syncLineTypeSource);
  const openSearchArea = useCapaLobReportStore(state => state.openSearchArea);
  const planType = useCapaLobReportStore(state => state.planType);

  const tabId = useTabid();

  const showOperation = sp.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType = sp.divisionType === DIVISION_TYPE.CELL;

  /**
   * DivisionType 3항목 — AS-IS `rgrpDivisionType`(Designer `dsn:664~676`) 순서 그대로.
   * 이 축은 콤보가 아니라 **화면 모드 스위치**라 옵션 값이 화면 상수인 것이 정답이고(02 §7 hook #87 §L),
   * 표시 라벨만 i18n 경유 의무다.
   * NSCM 공용 컴포넌트에 RadioGroup 이 없어(`@shared/components`·`@shared/lges` 전수 확인) 자매
   * SCP0104/0105/0106/0114 와 동일하게 단일선택 드롭다운으로 매핑한다 — 설계문서의 `RadioGroup` 표기는
   * AS-IS 컨트롤 종류이며 TO-BE 대응물이 없다(04 리포트에 기재).
   * 'Module/Pack' 은 기존 `SCM_ADM_MSG_M` 에 정확 매칭 LBL 이 없어(실측: `LBL00378 Sub Module`,
   * `LBL00379 Module` 2건뿐 — 엉뚱한 LBL 재사용은 다국어 전량 불일치, hook #114) `05_register.sql`
   * 1b 블록이 **신규 채번**한 `LBL_MODULE_PACK`(=LBL01143, ora.py 실측 채번)을 쓴다(goal.md BLK-5).
   * 하드코딩 리터럴을 남기지 않는다 — 세 항목 모두 `t()` 경유가 규약이다(iter-1 G-08).
   */
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      {
        label: t(LBL_MODULE_PACK, { defaultValue: 'Module/Pack' }),
        value: DIVISION_TYPE.MODULE_PACK,
      },
    ],
    [t]
  );

  /**
   * DivisionType 변경 — AS-IS `rgrpDivisionType_SelectedIndexChanged`(cs:1521~1526) 는
   * `BeforeFindData()`(그리드 비움 + 헤더 재구성) -> `RefreshAll()`(6축 전량 재구성) 순이다.
   * TO-BE 는 (a) 6축 선택을 한 번에 비우고 (b) 그리드를 비운다(hook #5 §1.4). **콤보 재조회는 없다**
   * (02 §0 #1 — 마스터 comboId 가 고정이라 `_shop_group` 값만 바뀐다).
   * 그리드 비움은 페이지의 조건 effect 가 담당한다(단일 커밋 — 연쇄로 2회 비우지 않는다, 03 V-43).
   */
  const handleDivisionTypeChange = (picked: string) => {
    setSearchParams({
      divisionType: (picked || DIVISION_TYPE.CELL) as DivisionType,
      siteId: ALL_SENTINEL,
      plantId: ALL_SENTINEL,
      factoryId: ALL_SENTINEL,
      lineId: ALL_SENTINEL,
      operationId: ALL_SENTINEL,
      electrodeType: ALL_SENTINEL,
    });
    // `RefreshAll()` 에 `RefreshElectrodeType` 이 포함된다 — 목록도 무선택 기준으로 다시 만든다.
    syncLineTypeSource(ALL_SENTINEL);
  };

  /**
   * Division 변경 — TO-BE 공통 요건(store `setDivision`): Division·부모축(divisionType) 제외 전 조건 초기화 +
   *   그리드 초기화. 편집중(dirty)이면 MSG00704 confirm 후에만 실행하고, 취소 시 controlled 콤보가 이전
   *   Division 으로 자동 복귀한다(value={sp.divisionId}, commit 51d4e9fa 패턴). 조회(Search) 공통 가드와
   *   동일 경로('search'). 이 화면은 조회전용이라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
   */
  const handleDivisionChange = (picked: string) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) setDivision(picked);
    });
  };

  /** Operation 변경 — cascade 말단. Line Type 만 재구성한다(02 §3.2 #9). */
  const handleOperationChange = (picked: string) => {
    setSearchParams({ operationId: picked, electrodeType: ALL_SENTINEL });
    syncLineTypeSource(picked);
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', { defaultValue: 'Search(F5)' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 — Operation group / Basic Nickname / Bottleneck (AS-IS row0 순서 그대로, 2026-11-04).
              AS-IS LOB Report 조회조건 순서를 따른다: Operation group 선두 -> Basic Nickname -> Bottleneck.
              AS-IS 1행은 이 3필드뿐이라 4번째 칸은 빈칸(spacer)으로 두어 Division 을 2행 선두로 내린다.
              명칭·타입은 기존 유지. 각 size 3.
              DivisionType — AS-IS row0 선두(dsn:707-716). `lciDivisionType.TextVisible=false` 라 라벨이 없었으나(01 L-11),
              검색조건 라벨을 `LBL00027`("Operation group")로 지정(사용자 DB 실측). Electrode/Cell/Module.Pack 은 이 필드의 선택지다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', 'Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.divisionType}
                  options={divisionTypeOptions}
                  // AS-IS 파리티: Electrode 항목은 선택 불가(회색)로 둔다 — AS-IS Designer 가
                  //   `RadioGroupItem(null, "Electrode", false)`(dsn:671, 3번째 인자 enabled=false)로
                  //   이 항목만 영구 비활성 생성한다. Cell/Module·Pack 만 선택 가능.
                  getOptionDisabled={option => option.value === DIVISION_TYPE.ELTR}
                  onChange={(_, picked) => handleDivisionTypeChange(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          {/* Basic Nickname — 라벨은 DivisionType 과 무관하게 고정이다(01 L-18: `ItemNames` 참조 0건.
              자매 SCP0105 의 동적 라벨 규칙은 이 화면에 없다).
              입력창 + 팝업 아이콘은 한 덩어리로 묶는다(`popupSearchField`) — 독립 버튼 컴포넌트 금지(L-19).
              팝업 트리거는 **아이콘 클릭 단독**이다 — AS-IS `txtItem` 은 순수 TextBox 이고 더블클릭
              이벤트 배선이 0건이다(cs:1604~1612 / dsn:524~529). `onDoubleClick` 을 달면 AS-IS 에 없던
              초과 동작이 된다(iter-1 G-10). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00054', '_Basic Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sp.nickName}
                  disabled={disabled}
                  onChange={event => setSearchParams({ nickName: event.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={disabled}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onOpenItemPopup}
                      />
                    ),
                  }}
                />
              )}
            />
          </Grid>
          {/* Bottleneck — 'ALL' 선두 옵션이 기본 선택이고 전송 시 `''` 로 치환된다(02 §2.6). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00055', '_Bottleneck')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.bottleneckFlag}
                  options={combos.bottleneckOptions}
                  onChange={(_, picked) => setSearchParams({ bottleneckFlag: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          {/* AS-IS 1행은 3필드뿐 — 빈 칸으로 12칸을 채워 Division 을 2행 선두로 내린다(줄 경계 고정). */}
          <Grid size={3} />

          {/* 2단 — Division / Plan Month / Version(+RP) / Status (AS-IS row1 순서 그대로). 각 size 3 = 12. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              // 'Div' 라벨 — LBL00001(실측 KO 'Div' / EN·CN 'Div.', 하우스 컨벤션) 재사용. 자매 화면 공통 패턴(사용자 지시 2026-11-04).
              label={t('LBL00001', { defaultValue: 'Div' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.divisionId}
                  options={combos.divisionOptions}
                  // Division 변경 = 하위 전량 리셋 + 그리드 초기화 의무(hook #5 §1.4 / 02 §5.4).
                  //   Version/Seq 는 후보가 갈리므로 비우고, 콤보 훅 effect 가 첫 행으로 되돌린다.
                  onChange={(_, picked) => handleDivisionChange(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00053', '_Plan Month')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.verId}
                  options={combos.versionOptions}
                  onChange={(_, picked) =>
                    setSearchParams({ verId: String(picked ?? ''), verSeq: '' })
                  }
                />
              )}
            />
          </Grid>
          {/* Version + Plan Type — AS-IS 는 Version(VER_SEQ) 바로 뒤에 라벨없는 readonly Plan Type(RP 표기)
              이 붙어 한 칸처럼 보였다. 사용자 요청으로 한 FormItem(size 3) 안에 콤보+회색칸을 가로로 묶는다.
              Plan Type 은 조회 파라미터가 아니라 파생 표시다(`txtPlanType.Enabled=false`, 01 L-09). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              // 'Ver.' = LBL01275(KO/EN/CN 'Ver.', DB 등록 2026-11-12, MSG_TP_CD='LBL'). 과거 리터럴 하드코딩은 다국어 미처리라 교체.
              label={t('LBL01275', '_Ver.')}
              labelAlign='right'
              render={() => (
                <Box sx={{ display: 'flex', gap: 0.5, width: '100%', minWidth: 0 }}>
                  {/* 콤보·RP 를 셀 폭 50:50 으로 나눠 나란히 둔다(사용자 요청 2026-10-19).
                      양쪽 flex 1 1 0 + minWidth 0 — InputField 의 내용 기반 최소폭을 무시하고 반칸에 맞춘다. */}
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <CustomDropdown
                      disabled={disabled}
                      value={sp.verSeq}
                      options={combos.versionSeqOptions}
                      onChange={(_, picked) => setSearchParams({ verSeq: String(picked ?? '') })}
                    />
                  </Box>
                  {/* RP(Plan Type) — 라벨없는 readonly 파생 표시(`txtPlanType.Enabled=false`, 01 L-09). */}
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <InputField fullWidth readOnly value={planType} />
                  </Box>
                </Box>
              )}
            />
          </Grid>
          {/* Status — 이중 `Enabled=false` 표시 전용(01 L-10). 목록은 3중 필터로 항상 1건이다(02 §2.3).
              사용자 선택 UI 로 만들면 조회 시트(CURRENT/CUTOFF)가 조작 가능해지는 결함이 된다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown disabled value={sp.progressStatus} options={combos.statusOptions} />
              )}
            />
          </Grid>

        </>
      }
      extraConditions={
        <>
          {/* 3단 — Site / Plant / Building / Line (AS-IS row2 선두 = 접기 시작 지점, 2026-11-04).
              사용자 지정: AS-IS 3행(Site~Line Type)부터 접힌다. 보이는 영역은 1·2단(Operation group~Status)뿐.
              상위 변경 시 하위 선택을 전부 비운다 — AS-IS `setListBox` 재바인딩이 체크를 지운다(02 §3.4).
              단 **Line Type 은 건드리지 않는다**: AS-IS clbSite~clbLine 핸들러(cs:1533~1557)가
              `RefreshElectrodeType` 를 호출하지 않아 재바인딩이 없고 체크가 그대로 유지된다
              (02 §3.1 주의1 / §3.4 결론 3 "AS-IS 그대로 재현"). 여기서 같이 비우면 `p_electrode_type`
              이 ''(무필터)로 넓어져 조회 결과가 AS-IS 와 달라진다(iter-1 G-06).
              Line Type 을 비우는 경로는 Operation 변경(cascade 말단)과 DivisionType 변경(RefreshAll)뿐이다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00015', '_Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={sp.siteId}
                  options={combos.siteOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      siteId: String(picked ?? ''),
                      plantId: ALL_SENTINEL,
                      factoryId: ALL_SENTINEL,
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00030', '_Plant')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={sp.plantId}
                  options={combos.plantOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      plantId: String(picked ?? ''),
                      factoryId: ALL_SENTINEL,
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 컨트롤명은 `clbFactory` 지만 AS-IS 표기는 "Building" 이다 — LBL00008(실측). "Factory" 아님. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00008', '_Building')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={sp.factoryId}
                  options={combos.buildingOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      factoryId: String(picked ?? ''),
                      lineId: ALL_SENTINEL,
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00010', '_Line')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={sp.lineId}
                  options={combos.lineOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      lineId: String(picked ?? ''),
                      operationId: ALL_SENTINEL,
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 4단 — Operation(동적) / Line Type(동적) (AS-IS row2 말단).
              Operation — divisionType !== 'ELTR' 에서만 표시(showOperation). ELTR 모드에선 이 칸이 빈칸이 된다. */}
          <Grid size={3}>
            {showOperation && (
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00009', '_Operation')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    disabled={disabled}
                    value={sp.operationId}
                    options={combos.operationOptions}
                    // Operation -> Line Type 만 재구성(cascade 말단, 02 §3.2 #9).
                    onChange={(_, picked) => handleOperationChange(String(picked ?? ''))}
                  />
                )}
              />
            )}
          </Grid>
          {/* 4단 — Line Type(동적). divisionType === 'CELL' 에서만 표시(showElectrodeType).
              Module/Pack·Electrode 모드에선 4단이 빈칸이 된다(동적 가시성 — 위 docstring 2규칙 참조). */}
          <Grid size={3}>
            {showElectrodeType && (
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00056', '_Line Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    disabled={disabled}
                    value={sp.electrodeType}
                    options={combos.lineTypeOptions}
                    onChange={(_, picked) =>
                      setSearchParams({ electrodeType: String(picked ?? '') })
                    }
                  />
                )}
              />
            )}
          </Grid>
        </>
      }
    />
  );
};
