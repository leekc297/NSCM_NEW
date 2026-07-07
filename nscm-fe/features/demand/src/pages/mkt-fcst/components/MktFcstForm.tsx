import { ItemField, OwnerField, ProjectField } from 'features/master/src/components';

import dayjs from '@foundation/dayjs';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MSG } from '../mkt-fcst.constants';
import { useMktFcstStore } from '../useMktFcstStore';

import styles from './MktFcstForm.module.scss';

interface MktFcstFormProps {
  onSearch: () => void;
  // ⭐ Insert 된 행 수 — Bucket 변경 가드(MSG00227)용. 신규 행 존재 시 버킷 변경 차단.
  insertedRowCount?: number;
}

// AS-IS DMF0003_MktFcst 조회조건 13 + 체크박스 4 (DMF0003_MktFcst_LAYOUT.md §2).
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 모든 객체 36px. DatePicker = .datePickerFix wrapper.
//   데이터 소스: useTabComboQueries (Div/Team/EndCustomer/SalesSite/BizType/Sender/PlantSite/ItemType).
//   ⭐ Project/Model/Owner = 조회조건 표준 카탈로그(@master/searchFields) ProjectField/ItemField/
//     OwnerField + multiCheckbox — DMF0020 과 동일 체크박스 멀티선택 popup (carry 없음, 전체목록 미체크).
//   Bucket = DMF0003_GET_BUCKET_TYPE_CODE (Phase 2 SP 연동, 현재 정적 옵션).
export const MktFcstForm = ({ onSearch, insertedRowCount = 0 }: MktFcstFormProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useMktFcstStore(s => s.searchCondition);
  const set = useMktFcstStore(s => s.setSearchCondition);
  const openSearchArea = useMktFcstStore(s => s.openSearchArea);

  // ⭐ #6 — 조회조건 콤보 전체 데이터 로딩. 사내 SCM_ADM_CMBO_SQL_M 실측(2026-06-28, READ)으로
  //   "등록 SQL_ID + 필요 바인드(@divisionId/@sesUserId 등)" 를 확정해 정합:
  //   - MyDivision            : 등록 O. @sesUserId(BE 자동). 파라미터 불요.
  //   - TeambyDivision        : 'UserTeamByDivision' 미등록 → 정식 등록명. DIVISION_ID 컬럼 반환(클라 필터 가능).
  //   - EndCustomer           : 'EndCustomerByDivision' 미등록 → 정식 등록명. DIVISION_ID 컬럼 반환.
  //   - ScmSitebyEndCustomer40: 등록 O. DIVISION_ID='40' 하드코딩 + @sesUserId. (DIVISION_ID 컬럼 미반환 → 무필터)
  //   - BizType / ItemType    : 등록 O. 전역 lookup(파라미터 불요).
  //   - SalesPlant            : 'PlantSitebyDivision' 미등록 → 정식 등록명. @divisionId 바인드. DIVISION_ID 반환.
  //   - Incoterms             : 등록 O. 전역 lookup(파라미터 불요). Sender Code 콤보 대체 표시용.
  //   ⭐ Sender Code 콤보 = SQL_ID 'SenderCode' (2026-07-02 신규 등록 — A2_dmf0003_sendercode_titleset_meta.sql,
  //      소스 lookup EDI_SENDER_CODE, AS-IS UP_FX_GetCommonDataList_DM 1:1). DIVISION_ID 컬럼 반환 → 클라 필터.
  //      DB 미적용 상태면 빈 옵션(ALL 만) — 가짜 옵션 생성 금지 유지.
  const [
    myDivision,
    userTeamByDivision,
    endCustomerByDivision,
    scmSiteByEndCustomer,
    bizType,
    senderCode,
    plantSite,
    itemType,
  ] = useTabComboQueries({
    filters: [
      'MyDivision',
      { comboId: 'TeambyDivision' },
      { comboId: 'EndCustomer' },
      'ScmSitebyEndCustomer40',
      'BizType',
      'SenderCode',
      { comboId: 'SalesPlant', divisionId: sc.divisionId },
      'ItemType',
    ],
  });

  // TODO(Phase 2): DMF0003_GET_BUCKET_TYPE_CODE SP 호출로 옵션 로드. 임시 옵션.
  const bucketOptions = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];

  // 멀티 select dropdown 값 (^ delim string[] ↔ 단일 string). 카탈로그 부재로 단일선택 + ALL 패턴 사용.
  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00691', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Div* / Team / End Customer / Sales Site(+AS) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={sc.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    set({
                      divisionId: option,
                      deptIds: [],
                      endCustomers: [],
                      scmSiteIds: [],
                      bizTypes: [],
                      plantSiteIds: [],
                      // ⭐ B4 — Cell Qty 는 Div 40 전용 (AS-IS L2107/2140: 비40 = Enabled=false + Checked=false).
                      ...(option !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
                      // ⭐ Invalid(MKT FCST 미등록 제외)는 Div82 전용 — 82 선택 시 기본 checked
                      //   (AS-IS checkInvalidExec .cs L469~477: 82=Enabled+Checked true / 그 외 false).
                      invalidYn: option === DIVISION.POWER,
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.deptIds)}
                  options={
                    userTeamByDivision
                      ?.filter(item => item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ deptIds: toArr(option), endCustomers: [], scmSiteIds: [] })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.endCustomers)}
                  options={
                    endCustomerByDivision
                      ?.filter(item => item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ endCustomers: toArr(option), scmSiteIds: [] })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            {/* ⭐ Sales Site dropdown + AS 체크박스 가로 배치 — AS 는 dropdown 오른쪽 옆(inline, SCSS .salesSiteCell). */}
            <div className={styles.salesSiteCell}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    useClearIcon
                    value={firstOr(sc.scmSiteIds)}
                    options={
                      scmSiteByEndCustomer?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => set({ scmSiteIds: toArr(option) })}
                  />
                )}
              />
              <span className={styles.salesSiteAs}>
                <Checkbox
                  labelText={t('LBL00685', '_AS')}
                  checked={sc.asYn}
                  onChange={checked => set({ asYn: checked })}
                />
              </span>
            </div>
          </Grid>

          {/* Row 2 — Biz Type* / Sender Code / Period* / Bucket* */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Biz. Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.bizTypes)}
                  options={bizType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => set({ bizTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00090', '_Sender Code')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.senderCodes)}
                  options={
                    senderCode
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ senderCodes: toArr(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00013', '_Period')}
              labelAlign='right'
              render={() => (
                <div className={styles.datePickerFix}>
                  <DatePickerCalendar
                    sx={{ width: '100%' }}
                    usecase='date-range-multi'
                    elevation
                    size='large'
                    value={[
                      dayjs(sc.startYyyymmdd, 'YYYYMMDD'),
                      dayjs(sc.endYyyymmdd, 'YYYYMMDD'),
                    ]}
                    onChange={date => {
                      const start = date?.[0] ? dayjs(date[0]).format('YYYYMMDD') : sc.startYyyymmdd;
                      const end = date?.[1] ? dayjs(date[1]).format('YYYYMMDD') : sc.endYyyymmdd;
                      set({ startYyyymmdd: start, endYyyymmdd: end });
                    }}
                  />
                </div>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // ⭐ Insert 된 행이 있으면 Bucket 변경 불가 (AS-IS cboBucketType_Click L5397, MSG00227).
                    if (insertedRowCount > 0) {
                      void setAlert({
                        type: 'alert',
                        content: t(
                          MSG.INSERT_ONLY_BUCKET,
                          '_Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.'
                        ),
                      });
                      return;
                    }
                    set({ bucketType: option as BUCKET_TYPE });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Project🔍 / Model🔍 (카탈로그 필드 + multiCheckbox, DMF0020 동일) / Plant Site / Item Type */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            multiCheckbox
          />
          <ItemField
            gridSize={3}
            value={sc.itemIds}
            onChange={v => set({ itemIds: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            itemIds={sc.itemIds}
            multiCheckbox
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00005', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.plantSiteIds)}
                  options={
                    plantSite
                      ?.filter(item => item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ plantSiteIds: toArr(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.itemTypes)}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => set({ itemTypes: toArr(option) })}
                />
              )}
            />
          </Grid>

          {/* Row 4 — Owner🔍 (카탈로그 필드 + multiCheckbox, DMF0020 동일) / 체크박스 4 (Sum / Color / Qty ≥ 0 / Cell Qty) */}
          <OwnerField
            gridSize={3}
            value={sc.owners}
            onChange={v => set({ owners: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            owners={sc.owners}
            multiCheckbox
          />
          <Grid size={9}>
            <div className={styles.checkboxRow}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={sc.sumYn}
                  onChange={checked => set({ sumYn: checked })}
                />
                {/* (Color 체크박스 제거 — 2026-07-03 사용자 결정: AS-IS 실행 UI 에 미표시(chkColor
                    초기 false·미노출) → false 경로 고정을 MktFcstGrid 에 반영) */}
                <Checkbox
                  labelText={t('LBL00689', '_Qty ≥ 0')}
                  checked={sc.qtyOverZero}
                  onChange={checked => set({ qtyOverZero: checked })}
                />
                {/* ⭐ B4 — Cell Qty 는 Div 40 전용 (AS-IS cboCellQty.Enabled — L445/2107). */}
                <Checkbox
                  labelText={t('LBL00690', '_Cell Qty')}
                  checked={sc.cellQtyYn}
                  disabled={sc.divisionId !== DIVISION.MOBILITY}
                  onChange={checked => set({ cellQtyYn: checked })}
                />
                {/* ⭐ Invalid — 'MKT FCST 미등록 제외' (AS-IS checkInvalidExec Caption 1:1). Div82 전용,
                    82 진입 시 기본 checked. SP p_invalid_exec — 실측 div82 Y=175행/N=1,165행. */}
                <Checkbox
                  labelText={t('LBL00752', '_MKT FCST 미등록 제외')}
                  checked={sc.invalidYn}
                  disabled={sc.divisionId !== DIVISION.POWER}
                  onChange={checked => set({ invalidYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
