import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  DIVISION_TYPE,
  PROGRESS_STATUS,
  SHEET_TYPE,
  type DivisionType,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { ComboOption } from '../capa-loss-plan.types';
import type { CapaLossPlanCombos } from '../hooks/useCapaLossPlanCombos';
import { useCapaLossPlanStore } from '../useCapaLossPlanStore';

interface Props {
  combos: CapaLossPlanCombos;
  onSearch: () => void;
  onOpenItemPopup: () => void;
  /** Division 권한 0건 — 조회영역 전체 비활성(01 L-07). */
  disabled: boolean;
}

/**
 * 조회조건 14필드.
 *
 * 배치·기본값·DivisionType 컨트롤은 **사용자 제시 현재 AS-IS 캡처(2026-11-03)로 정정**했다
 * (설계/구 캡처 `asis-screenshot.png` 는 구버전 — 사용자 확인). **2줄 노출 + 3줄부터 접기**
 *   (SearchArea `conditions`/`extraConditions`, 사용자 지시 2026-11-04 — chevron 토글):
 *   [상시] 1행: **Operation group 콤보(좌, LBL00027)** · Item(Model/Basic Nickname + 돋보기) · Show Rate Columns
 *   [상시] 2행: Div · Plan Month · Ver.(+PlanType 파생 `BP` 를 한 칸에 묶음) · Status · [SheetType]
 *   [접힘] 3행: Site · Plant · Building · Line
 *   [접힘] 4행(동적): Operation · Line Type  (Electrode 상태에선 둘 다 숨김)
 * DivisionType 은 AS-IS 가 `rgrpDivisionType`(라디오)이나, SCP0105 와 동일하게 "Operation group" 콤보박스로
 *   매핑한다(사용자 지시 2026-11-05 — 초기 라디오 재현에서 변경). 기본값 Electrode(constants `DEFAULT_DIVISION_TYPE=ELTR`).
 *
 * 동적 가시성 4규칙의 **조건식이 서로 다르다 — 통일·단순화 금지**(01 L-01/L-02/L-04/L-05):
 *   showOperation     = divisionType !== 'ELTR'
 *   showElectrodeType = !(divisionType === MODULE_PACK || divisionType === ELTR)
 *   showSheetType     = progressStatus in {'1','2'}
 *   showShowRate      = !((progressStatus in {'1','2'}) && sheetType === 'LINE')
 *
 * 필수 조회조건은 만들지 않는다 — AS-IS `Required` 0건 / 라벨 `*` 0건이다(01 §3, 02 §4.4).
 */
export const CapaLossPlanForm = ({ combos, onSearch, onOpenItemPopup, disabled }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaLossPlanStore(state => state.searchCondition);
  const setSearchCondition = useCapaLossPlanStore(state => state.setSearchCondition);
  const setDivision = useCapaLossPlanStore(state => state.setDivision);
  const setDivisionType = useCapaLossPlanStore(state => state.setDivisionType);
  const setProgressStatus = useCapaLossPlanStore(state => state.setProgressStatus);
  const setSheetType = useCapaLossPlanStore(state => state.setSheetType);
  const openSearchArea = useCapaLossPlanStore(state => state.openSearchArea);
  const planType = useCapaLossPlanStore(state => state.planType);

  const tabId = useTabid();

  const showOperation = sc.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType = !(
    sc.divisionType === DIVISION_TYPE.MODULE_PACK || sc.divisionType === DIVISION_TYPE.ELTR
  );
  const isCutoff =
    sc.progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    sc.progressStatus === PROGRESS_STATUS.SECOND_CUTOFF;
  const showSheetType = isCutoff;
  const showShowRate = !(isCutoff && sc.sheetType === SHEET_TYPE.LINE);

  // DivisionType 3옵션 — AS-IS rgrpDivisionType(Designer.cs:737~740) 순서 그대로(Electrode=idx0).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 LBL01143(KO/EN/CN) 등재 확인(2026-11-04 ora.py 실측) → t() 적용.
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      { label: t('LBL01143', 'Module/Pack'), value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  // SheetType 옵션 — AS-IS 가 `Items.Add("MODEL"/"LINE")` 로 코드 하드코딩(02 §2.4). 값은 `_sheet_status`
  //   계산 키라 변경 금지. 표시 문구도 AS-IS 가 코드값 그대로다.
  //   lookup/CMBO 미등록 유지 파리티 확정(I-14 — 2026-11-04 사용자 확정). MODEL/LINE 은 2개 고정
  //   계산키라 DB lookup 등록해도 기능·표시 동일(ora.py 실측: SheetType 전용 CMBO 0건) → 하드코딩 유지.
  const sheetTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: SHEET_TYPE.MODEL, value: SHEET_TYPE.MODEL },
      { label: SHEET_TYPE.LINE, value: SHEET_TYPE.LINE },
    ],
    []
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1행 — Operation group(DivisionType) · Item(Model/Basic Nickname + 팝업) · Show Rate Columns */}
          {/* Operation group — AS-IS rgrpDivisionType(라디오)를 SCP0105 와 동일하게 콤보박스로 변경하고
              라벨 "Operation group"(LBL00027)을 부여한다(사용자 지시 2026-11-05). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionType}
                  options={divisionTypeOptions}
                  onChange={(_, picked) =>
                    setDivisionType((String(picked ?? '') || DIVISION_TYPE.ELTR) as DivisionType)
                  }
                />
              )}
            />
          </Grid>
          {/* Item — 라벨이 DivisionType 으로 갈린다(01 L-03): Cell/Module-Pack = Basic Nickname /
              Electrode = Material(LBL00021, 사용자 지시 2026-11-06 — Model 에서 명칭변경). 조건은
              `!== ELTR`(showOperation) 이다(SCP0105 와 갈리는 지점).
              입력창 + 팝업 아이콘 한 덩어리(hook #121 popupSearchField). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={showOperation ? t('LBL00054', '_Basic Nickname') : t('LBL00021', '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={disabled}
                  // 대소문자 변환 금지 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지.
                  onChange={event => setSearchCondition({ nickName: event.target.value })}
                  onDoubleClick={onOpenItemPopup}
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
          {/* Show Rate Columns — 초기 체크 true(캡처 ☑, decisions §B-3). 고정칸(숨김 시 빈칸).
              토글 대상 `M_00` 가 TVF 0건 생성이라 눌러도 화면 불변인 게 AS-IS 파리티(03 R-02). */}
          {/* Show Rate — 2행 Ver./PlanType 과 같은 3번째 열(size 3)에 맞춘다(사용자 지시 2026-11-11).
              라벨 없는 FormItem 이 라벨열을 유지하므로 체크박스가 Ver 입력칸과 같은 x 에서 시작한다.
              종전 size 2 + ml:100px 오프셋은 Ver 열과 어긋나 제거. */}
          <Grid size={3}>
            {showShowRate && (
              <FormItem
                className={commonStyles.formItem}
                label=''
                render={() => (
                  <div style={{ whiteSpace: 'nowrap' }}>
                    <Checkbox
                      disabled={disabled}
                      checked={sc.showRate}
                      labelText={t('LBL01117', '_Show Rate Columns')}
                      onChange={checked => setSearchCondition({ showRate: Boolean(checked) })}
                    />
                  </div>
                )}
              />
            )}
          </Grid>

          {/* 줄바꿈 스페이서 — 1행(Operation group·Item·Show Rate = 합 9칸)을 12칸으로 채워 Div 를 2행
              머리로 떨어뜨린다(사용자 지시 2026-11-06). CSS Grid(repeat 12) auto-flow 는 span 합이 12
              미만이면 같은 줄에 붙으므로, 남은 3칸을 빈 칸으로 채워 다음 아이템(Div)이 줄을 넘게 한다.
              gridColumnStart 강제는 부모의 `grid-column: span N` 단축 규칙(특이도 상위)에 덮여 안 된다. */}
          <Grid size={3} />

          {/* Div — 2행 머리(사용자 지시 2026-11-06). 2행 구성: Div(3) · Plan Month(3) · Ver./PlanType(3) ·
              Status(+SheetType)(3) = 12칸 균등(사용자 지시 2026-11-11 — Ver/PlanType 을 한 칸으로 묶어 정렬 정정).
              컷오프 상태의 SheetType(MODEL/LINE) 콤보는 Status 셀 안에 Box flex 로 묶어 Status 바로
              오른쪽에 붙인다 — Ver./PlanType 과 같은 패턴. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.divisionId}
                  options={combos.divisionOptions}
                  // Division 변경 = 검색조건(Div·DivisionType 제외) + 그리드 초기화. 편집중(dirty)이면
                  //   MSG00704 confirm 후에만, 취소 시 controlled 콤보가 이전 Div 로 복귀.
                  onChange={(_, picked) => {
                    const next = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(next);
                    });
                  }}
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
                  value={sc.version}
                  options={combos.versionOptions}
                  onChange={(_, picked) => setSearchCondition({ version: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          {/* Ver. + Plan Type — 한 칸(size 3)에 Box flex 50:50 으로 묶는다(자매 SCP0105 패턴, 사용자 지시
              2026-11-11). 종전 Ver(size 1, 34px 라벨 override) + PlanType(size 1) 분리는 Ver/PlanType 이
              중앙에 눌리고 Status 까지 빈 칸이 벌어져 조회조건 정렬이 어긋났다(캡처 지적). Plan Type 은
              조회 파라미터가 아니라 파생 표시다(AS-IS `txtPlanType` TextVisible=false + Enabled=false, 캡처 `BP`). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01275', '_Ver.')}
              labelAlign='right'
              render={() => (
                <Box sx={{ display: 'flex', gap: 0.5, width: '100%', minWidth: 0 }}>
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <CustomDropdown
                      disabled={disabled}
                      value={sc.versionSeq}
                      options={combos.versionSeqOptions}
                      onChange={(_, picked) =>
                        setSearchCondition({ versionSeq: String(picked ?? '') })
                      }
                    />
                  </Box>
                  <Box sx={{ flex: '1 1 0', minWidth: 0 }}>
                    <InputField fullWidth disabled value={planType} />
                  </Box>
                </Box>
              )}
            />
          </Grid>
          {/* Status + SheetType — 컷오프(1/2차) 상태에선 SheetType(MODEL/LINE, 라벨 없음 — AS-IS
              `TextVisible=false`, 01 L-04) 콤보가 Status 바로 오른쪽에 붙는다(AS-IS 캡처:
              `Status [2`nd Cut off] [LINE]`, 사용자 지시 2026-11-11). 종전 SheetType 을 별도 Grid(size 1)로
              두면 2행이 이미 12칸 full 이라 다음 줄 좌측으로 밀려났다 — Ver./PlanType 과 동일하게 같은
              셀 안 Box flex 로 묶는다. Status 는 "2`nd Cut off" 가 길어 flex 를 더 준다(3:2). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', '_Status')}
              labelAlign='right'
              render={() => (
                <Box sx={{ display: 'flex', gap: 0.5, width: '100%', minWidth: 0 }}>
                  <Box sx={{ flex: showSheetType ? '3 1 0' : '1 1 100%', minWidth: 0 }}>
                    <CustomDropdown
                      disabled={disabled}
                      value={sc.progressStatus}
                      options={combos.statusOptions}
                      // Status 1회 변경이 SheetType 가시성 + Operation/LineType 재구성 + ShowRate 가시성 +
                      //   그리드 비움을 함께 일으킨다 — store 액션 하나로 묶는다(02 §5.4).
                      onChange={(_, picked) => setProgressStatus(String(picked ?? ''))}
                    />
                  </Box>
                  {showSheetType && (
                    <Box sx={{ flex: '2 1 0', minWidth: 0 }}>
                      <CustomDropdown
                        disabled={disabled}
                        value={sc.sheetType}
                        options={sheetTypeOptions}
                        // SheetType 변경 = AS-IS cboSheetType → BeforeFindData(그리드 비움). Operation·
                        //   Line Type 만 재구성(02 §0 #9, F-20) + filters clear 는 setSheetType 단일 출처.
                        onChange={(_, picked) =>
                          setSheetType((String(picked ?? '') || SHEET_TYPE.MODEL) as SheetType)
                        }
                      />
                    </Box>
                  )}
                </Box>
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 3행(접힘, 3줄부터 접기 — 2026-11-04) — Site · Plant · Building · Line. 상위 변경 시 하위는 항상 ALL 리셋(F-21). */}
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
                  value={sc.siteId}
                  options={combos.siteOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      siteId: String(picked ?? ''),
                      plantId: 'ALL',
                      factoryId: 'ALL',
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
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
                  value={sc.plantId}
                  options={combos.plantOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      plantId: String(picked ?? ''),
                      factoryId: 'ALL',
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 컨트롤명은 clbFactory 지만 AS-IS 표기는 "Building"(LBL00008). "Factory" 아님. */}
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
                  value={sc.factoryId}
                  options={combos.buildingOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      factoryId: String(picked ?? ''),
                      lineId: 'ALL',
                      operationId: 'ALL',
                      electrodeType: 'ALL',
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
                  value={sc.lineId}
                  options={combos.lineOptions}
                  onChange={(_, picked) =>
                    setSearchCondition({
                      lineId: String(picked ?? ''),
                      operationId: 'ALL',
                      electrodeType: 'ALL',
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* 4행 — Operation · Line Type (동적). Electrode 에선 둘 다 숨김 → 캡처(1~3행)와 동일.
              마지막 요소라 조건부 렌더가 앞 행 정렬을 깨지 않는다. */}
          {showOperation && (
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00009', '_Operation')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sc.operationId}
                    options={combos.operationOptions}
                    onChange={(_, picked) =>
                      setSearchCondition({
                        operationId: String(picked ?? ''),
                        electrodeType: 'ALL',
                      })
                    }
                  />
                )}
              />
            </Grid>
          )}
          {showElectrodeType && (
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00056', '_Line Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    disabled={disabled}
                    value={sc.electrodeType}
                    options={combos.lineTypeOptions}
                    onChange={(_, picked) => setSearchCondition({ electrodeType: String(picked ?? '') })}
                  />
                )}
              />
            </Grid>
          )}
        </>
      }
    />
  );
};
