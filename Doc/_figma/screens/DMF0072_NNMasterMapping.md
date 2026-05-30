> ⚠️ **이 파일은 이관되었습니다 (2026-05-30).** 진실 source 는 다음 파일입니다:
> `C:\Projects\NSCM\Doc\_figma\screens\DMF0072_NNMasterMapping.md`
> 본 파일은 분석서 호환성을 위해 유지됨.
# DMF0072_NNMasterMapping — Figma Link (placeholder)

> 작성: 2026-05-29 | Figma 디자인 시 본 문서 갱신 의무

---

## Figma 디자인

- **상태**: 미작성 (placeholder)
- **TODO**: 디자인팀 협의 후 Figma URL 추가
- **참고 캡쳐**: `Doc/ui_cap/asis_dmf0072.png` (AS-IS WinForms 1350×703)

## 디자인 가이드 (To-Be)

| 영역 | 컴포넌트 |
|---|---|
| Page Header | `MainTitle` (룰 15) |
| Search Area | `SearchArea` + `FormItem` × 7 (Division/Team/EndCust/SalesSite/Project+popup/Model+popup/DataType) |
| Sub Header | `SubTitle` + Hotkey (F5/F7/F8/F9/F12) |
| Main Grid | Wijmo `<FlexGrid>` 22 cols (hidden 1 포함) |
| POPUPs (3) | MUI `<Dialog>` × 3 (Project / Item / Customer) |

## 색상

- Edit 모드 셀: `#fff8e1` (연한 노랑)
- 잠긴 셀 (EDI/RPA 행): `#f5f5f5` (회색)
- 신규 행 (I): `#e3f2fd` (연한 파랑)

## 우선순위

- **사용성 우선**: F5/F7/F8 hotkey 가시화 (룰 12)
- **AS-IS 호환**: 22 컬럼 순서 동일 (column ordering 변경 시 사용자 학습 비용)
- **Division=40 분기**: PROJECT_CODE 컬럼 비활성 시각 표시 (회색)

