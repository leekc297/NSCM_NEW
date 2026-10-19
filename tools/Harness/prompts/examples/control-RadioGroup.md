# 예제 — control-RadioGroup (2건 중 2)

같은 유형의 As-is 항목을 기존 To-Be 화면이 어떻게 구현했는지. **모양(훅·컴포넌트·네이밍·주석 규약)을 그대로 따른다.**

## SCP0106 · §1 rgrpDivisionType / RadioGroup
- 위치: `features/supply/src/pages/capa-loss-plan/components/CapaLossPlanForm.tsx:69-95`
- 비고: NSCM 공용에 RadioGroup 이 없어 단일선택 드롭다운으로 매핑(자매 SCP0105/0114 동일 판단)

```tsx
    sc.progressStatus === PROGRESS_STATUS.FIRST_CUTOFF ||
    sc.progressStatus === PROGRESS_STATUS.SECOND_CUTOFF;
  const showSheetType = isCutoff;
  const showShowRate = !(isCutoff && sc.sheetType === SHEET_TYPE.LINE);

  // 라디오 3옵션 — AS-IS rgrpDivisionType(Designer.cs:733~743) 순서 그대로.
  //   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로 매핑한다(자매 SCP0105/0114 동일 판단).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 정확 매칭 LBL 이 없다(02 §4.5 #17 실측: LBL00378 'Sub Module',
  //   LBL00379 'Module' 뿐). 엉뚱한 LBL 재사용 = 다국어 전량 불일치라 영문 표기를 유지하고 채번을
  //   04 리포트 확인필요로 남긴다(goal BLK-7, hook #114). SCP0105 와 **공유 채번** 대상이다.
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      { label: 'Module/Pack', value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  // SheetType 옵션 — AS-IS 가 `Items.Add("MODEL"/"LINE")` 로 **코드 하드코딩**한다(02 §2.4).
  //   TO-BE lookup/CMBO 에 대응 0건이라 화면 상수로 둔다(hook #87 §L 와 충돌 — 04 확인필요).
  //   **값 자체는 `_sheet_status` 계산 키라 변경 금지.** 표시 문구도 AS-IS 가 코드값 그대로다.
  const sheetTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: SHEET_TYPE.MODEL, value: SHEET_TYPE.MODEL },
      { label: SHEET_TYPE.LINE, value: SHEET_TYPE.LINE },
    ],
```

## SCP0105 · §1 rgrpDivisionType / RadioGroup
- 위치: `features/supply/src/pages/capa-speed-plan/components/CapaSpeedPlanForm.tsx:53-79`
- 비고: 공용 RadioGroup 부재 → 단일선택 드롭다운(자매 SCP0114 동일). 초기값 `Cell` 은 사용자 확정 BLK-4

```tsx

  const showOperation = sc.divisionType !== DIVISION_TYPE.ELTR;
  const showElectrodeType =
    sc.divisionType === DIVISION_TYPE.CELL || sc.divisionType === DIVISION_TYPE.MODULE_PACK;

  // 라디오 3옵션 — AS-IS rgrpDivisionType(Designer.cs:615~618) 순서 그대로.
  //   NSCM 공용에 RadioGroup 컴포넌트가 없어 단일선택 드롭다운으로 매핑한다(자매 SCP0114 와 동일 판단).
  //   'Module/Pack' 은 `SCM_ADM_MSG_M` 에 정확 매칭 LBL 이 없다(실측 2026-09-23: LBL00378 'Sub Module',
  //   LBL00379 'Module' 뿐). 엉뚱한 LBL 재사용 = 다국어 전량 불일치라 영문 표기를 유지하고 채번을
  //   04 리포트 확인필요로 남긴다(goal BLK-9, hook #114).
  const divisionTypeOptions = useMemo<ComboOption[]>(
    () => [
      { label: t('LBL00038', '_Electrode'), value: DIVISION_TYPE.ELTR },
      { label: t('LBL01059', '_Cell'), value: DIVISION_TYPE.CELL },
      { label: 'Module/Pack', value: DIVISION_TYPE.MODULE_PACK },
    ],
    [t]
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1단 — DivisionType(시트 전환축) / Division / Plan Month / Version / Plan Type */}
```
