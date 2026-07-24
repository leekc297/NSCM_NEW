import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PeriodField,
  PlantSiteField,
  ProjectField,
  TeamField,
} from 'features/master/src/components';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
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
  // ⭐ P1-③ — W/S Planner 이면 AS 강제 checked·잠금 (AS-IS cboAS.Checked=true·Enabled=false, L324).
  //   AS 체크박스 비표시(2026-07-21)로 본 컴포넌트 내 참조 없음 — store 강제(asYn=true) 로직은 유지. 재노출 시 주석 해제.
  // const wsPlannerYn = useMktFcstStore(s => s.wsPlannerYn);

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
  // ⚠️ Plant Site 는 SalesPlant(division-only, 권한/cascade 미반영) 사용 금지 — 표준 PlantSiteField
  //   카탈로그(PlantSitebyEndCustomer, 81 전용, Division+EndCustomer 서버 바인드)로 대체(아래 extraConditions).
  // Division/Team/EndCustomer/BizType 은 표준 카탈로그 필드가 자체 fetch → Form 에서는 인라인 유지 필드만.
  //   Sales Site = 'SalesSite'(AS 체크박스 통합 인라인) / SenderCode·ItemType(카탈로그 없음) / BucketType(D 포함 인라인).
  const [scmSiteByEndCustomer, senderCode, itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['SalesSite', 'SenderCode', 'ItemType', 'BucketType'],
  });

  // ⭐ G3 — Bucket 옵션 = CMBO 'BucketType'(LOOKUP_TYPE='BUCKET_TYPE_CODE') 동적 fetch.
  //   ⚠️ CMBO CODE 는 풀워드(DAILY/WEEKLY/MONTHLY)라 BUCKET_TYPE enum('D'/'W'/'M')과 불일치 →
  //      CODE 첫 글자로 enum 매핑(charAt(0): DAILY→D). label 은 CMBO NAME(i18n 아님) 대신 코드→LBL 유지.
  //   CMBO 빈 응답 시 정적 fallback(3종 불변) — 화면 작동 보장.
  const bucketLabelKey: Record<string, string> = {
    [BUCKET_TYPE.DAILY]: 'LBL00682',
    [BUCKET_TYPE.WEEKLY]: 'LBL00683',
    [BUCKET_TYPE.MONTHLY]: 'LBL00684',
  };
  const bucketFallback = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0) as BUCKET_TYPE;
            return { label: t(bucketLabelKey[code] ?? '', String(item.NAME ?? code)), value: code };
          })
          .filter(o => o.value === BUCKET_TYPE.DAILY || o.value === BUCKET_TYPE.WEEKLY || o.value === BUCKET_TYPE.MONTHLY)
      : bucketFallback;

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
          {/* Row 1 — Div* / Team / End Customer / Sales Site(+AS). Division/Team/EndCustomer = 표준 카탈로그. */}
          {/* ⭐ Division — 종속필드 전면 reset(cascade) + division별 기본값(cellQty/invalid/bucket)은 onChange 커스텀. */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={option =>
              set({
                divisionId: option,
                deptIds: [],
                endCustomers: [],
                scmSiteIds: [],
                bizTypes: [],
                plantSiteIds: [],
                // Sender Code(81 전용) / Project(40 비활성) — division 변경 시 clear.
                senderCodes: [],
                projectCodes: [],
                // Cell Qty 는 Div 40 전용 (AS-IS L2107/2140: 비40 = Enabled=false + Checked=false).
                ...(option !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
                // Invalid(MKT FCST 미등록 제외)는 Div82 전용 — 82 진입 시 기본 checked (AS-IS L469~477).
                invalidYn: option === DIVISION.ESS,
                // Bucket 기본값: 전 Division = Weekly (사용자 확정 2026-07-22 — 구 82(ESS)=Daily 분기 폐기).
                bucketType: BUCKET_TYPE.WEEKLY,
              })
            }
          />
          <TeamField
            gridSize={3}
            value={sc.deptIds}
            onChange={v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] })}
            division={sc.divisionId}
          />
          <EndCustomerField
            gridSize={3}
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v, scmSiteIds: [] })}
            division={sc.divisionId}
          />
          <Grid size={3}>
            {/* ⭐ Sales Site — 멀티선택(카탈로그 SalesSiteField 동등: SalesSite CMBO + DIVISION_ID 필터) +
                AS 체크박스 가로 배치. SalesSiteField 는 AS 미지원 → AS 통합 위해 인라인 유지. */}
            <div className={styles.salesSiteCell}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={sc.scmSiteIds.join(',')}
                    options={
                      scmSiteByEndCustomer
                        ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) =>
                      set({ scmSiteIds: String(options ?? '').split(',').filter(Boolean) })
                    }
                  />
                )}
              />
              {/* ⭐ AS 체크박스 — 사용자 요청(2026-07-21)으로 비표시.
                  asYn 상태·검색 payload('Y'/'N')·W/S Planner 강제(asYn=true)·save asFromSite 로직은 전부 유지(무회귀).
                  재노출 시 아래 블록 주석 해제.
              <span className={styles.salesSiteAs}>
                <Checkbox
                  labelText={t('LBL00685', '_AS')}
                  checked={sc.asYn || wsPlannerYn}
                  disabled={wsPlannerYn}
                  onChange={checked => set({ asYn: checked })}
                />
              </span> */}
            </div>
          </Grid>

          {/* Row 2 — Biz Type*(카탈로그) / Sender Code(81 전용 인라인) / Period*(카탈로그) / Bucket*(D 포함 인라인) */}
          <BizTypeField
            gridSize={3}
            value={sc.bizTypes}
            onChange={v => set({ bizTypes: v })}
          />
          <Grid size={3}>
            {/* ⭐ Sender Code — 81 계열 전용 enable (AS-IS clbEDISender Division==81 만 활성, .cs L469~).
                40/82 비활성 + Division 변경 시 clear(onChange 종속 reset). */}
            <FormItem
              label={t('LBL00090', '_Sender Code')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  disabled={!sc.divisionId.startsWith('81')}
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
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
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
          {/* ⭐ Project — Division==='40' 비활성 (AS-IS btnProject Division==40 disabled, 소형사업부는
              프로젝트 코드 관리 안함). DMF0020 은 숨김, DMF0003 은 disabled 로 레이아웃 유지. */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={sc.divisionId === DIVISION.MOBILITY}
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
          {/* ⭐ Plant Site — 표준 카탈로그 PlantSiteField (PlantSitebyEndCustomer, 81 계열 전용 enable,
              Division+EndCustomer 서버 바인드 + 값 quoting). 40/82 비활성. (메모리 룰 2026-07-10) */}
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
          />
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
                  disabled={sc.divisionId !== DIVISION.ESS}
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
