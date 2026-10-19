import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

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
 * 단 구성(hook #83/#52) — `00_checklist.md` 의 Control.Location 읽기 + AS-IS 실행화면 캡처
 * (`human-doc/media/image2.png`, goal.md §5-7 (1))로 **확정된 3단 배열**이다:
 *   `conditions`      1단 = Division(2) · Plan Month(2) · Version(2) · Plan Type(1) · Status(2) · DivisionType(3) = 12
 *   `conditions`      2단 = Site(3) · Plant(3) · Building(3) · Line(3) = 12   -> 합계 24 = 정확히 2단
 *   `extraConditions` 3단 = Operation(3) · Line Type(3) · Basic Nickname+팝업(4) · Bottleneck(2) = 12
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
  // AS-IS `RefreshElectrodeType` 호출 지점(Division / DivisionType / Operation)에서만 부른다 — 02 V-15.
  const syncLineTypeSource = useCapaLobReportStore(state => state.syncLineTypeSource);
  const openSearchArea = useCapaLobReportStore(state => state.openSearchArea);
  const planType = useCapaLobReportStore(state => state.planType);

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

  /** Division 변경 — `RefreshAll()` 동상. 하위 6축 + Version/Seq 를 한 번에 비운다(hook #5 §1.4). */
  const handleDivisionChange = (picked: string) => {
    setSearchParams({
      divisionId: picked,
      verId: '',
      verSeq: '',
      siteId: ALL_SENTINEL,
      plantId: ALL_SENTINEL,
      factoryId: ALL_SENTINEL,
      lineId: ALL_SENTINEL,
      operationId: ALL_SENTINEL,
      electrodeType: ALL_SENTINEL,
    });
    syncLineTypeSource(ALL_SENTINEL);
  };

  /** Operation 변경 — cascade 말단. Line Type 만 재구성한다(02 §3.2 #9). */
  const handleOperationChange = (picked: string) => {
    setSearchParams({ operationId: picked, electrodeType: ALL_SENTINEL });
    syncLineTypeSource(picked);
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 — Division / Plan Month / Version / Plan Type / Status / DivisionType */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
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
          <Grid size={2}>
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
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00606', '_Version')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.verSeq}
                  options={combos.versionSeqOptions}
                  onChange={(_, picked) => setSearchParams({ verSeq: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          {/* Plan Type — AS-IS `txtPlanType` 은 `TextVisible=false`(라벨 없음) + `Enabled=false`.
              `readOnly` 로 둔다(`disabled` 아님 — 값은 읽혀야 한다). 조회 파라미터가 아니다(01 L-09). */}
          <Grid size={1}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => <InputField fullWidth readOnly value={planType} />}
            />
          </Grid>
          {/* Status — 이중 `Enabled=false` 표시 전용(01 L-10). 목록은 3중 필터로 항상 1건이다(02 §2.3).
              사용자 선택 UI 로 만들면 조회 시트(CURRENT/CUTOFF)가 조작 가능해지는 결함이 된다. */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown disabled value={sp.progressStatus} options={combos.statusOptions} />
              )}
            />
          </Grid>
          {/* DivisionType — `lciDivisionType.TextVisible=false` 라 라벨이 없다(01 L-11).
              `LBL00038`("Electrode")은 이 필드의 **선택지 하나**이지 필드명이 아니다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sp.divisionType}
                  options={divisionTypeOptions}
                  onChange={(_, picked) => handleDivisionTypeChange(String(picked ?? ''))}
                />
              )}
            />
          </Grid>

          {/* 2단 — Site / Plant / Building / Line.
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
        </>
      }
      extraConditions={
        <>
          {/* 3단 — Operation(동적) / Line Type(동적) / Basic Nickname+팝업 / Bottleneck */}
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
          {/* Basic Nickname — 라벨은 DivisionType 과 무관하게 고정이다(01 L-18: `ItemNames` 참조 0건.
              자매 SCP0105 의 동적 라벨 규칙은 이 화면에 없다).
              입력창 + 팝업 아이콘은 한 덩어리로 묶는다(`popupSearchField`) — 독립 버튼 컴포넌트 금지(L-19).
              팝업 트리거는 **아이콘 클릭 단독**이다 — AS-IS `txtItem` 은 순수 TextBox 이고 더블클릭
              이벤트 배선이 0건이다(cs:1604~1612 / dsn:524~529). `onDoubleClick` 을 달면 AS-IS 에 없던
              초과 동작이 된다(iter-1 G-10). */}
          <Grid size={4}>
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
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onOpenItemPopup} />
                        }
                      />
                    ),
                  }}
                />
              )}
            />
          </Grid>
          {/* Bottleneck — 'ALL' 선두 옵션이 기본 선택이고 전송 시 `''` 로 치환된다(02 §2.6). */}
          <Grid size={2}>
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
        </>
      }
    />
  );
};
