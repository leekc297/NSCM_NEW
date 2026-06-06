# AS-IS Popup 분석 템플릿 v2 — `{PopupClassName}`

> **사용 의무**: 공용/도메인 popup (`*Popup.cs` + `*Popup.Designer.cs`) 분석 시 9 category 100% 채움. anti-simplification 동일 적용.

---

## §0 메타

| 항목 | 값 |
|---|---|
| 클래스 명 | `SCM0002_ProjectbyDivisionPopupEx` |
| 위치 | `GSCM/06.UIL/GSCM.SCM.Popup.UIL/...` |
| 호출 빈도 | N 화면에서 사용 (grep `new XxxPopup` 결과) |
| 호출 화면 list | DMF0004 / DMF0005 / DMF0006 / DMF0008 |
| TO-BE 매핑 modal | `@master/components/ProjectByDivisionModal` (있으면) |

---

## §1 Layout (.Designer.cs)

§ §1.1 조건 패널 컨트롤 (검색조건 영역)

| # | 컨트롤 | 타입 | 라벨 | parent | line |
|---:|---|---|---|---|---:|
| 1 | cboDivision | UsrCombo | Division | UsrLayoutControl1 | NN |
| 2 | txtProjectCode | UsrTextBox | Project Code | UsrLayoutControl1 | NN |
| 3 | clbBizType | UsrCheckedList | Business Type | UsrLayoutControl1 | NN |
| ... | | | | | |

§ §1.2 결과 grid

| Grid | columns | header | line |
|---|---|---|---:|
| spdMain | (§1.3 표시 컬럼 인벤토리) | 1 row | NN |

§ §1.3 표시 컬럼 인벤토리

| binding | header | width | align | format | locked | line |
|---|---|---:|---|---|---|---:|
| DIVISION_ID | Division | 80 | center | - | Y | NN |
| PROJECT_CODE | Project Code | 100 | center | - | Y | NN |
| PROJECT_NAME | Project Name | 200 | left | - | Y | NN |
| PROJECT_STATUS | Status | 80 | center | - | Y | NN |
| BIZ_TYPE_NAME | Biz Type | 100 | center | - | Y | NN |
| ... | | | | | | |

§ §1.4 버튼

| 버튼 | 라벨 | 위치 | 책임 | line |
|---|---|---|---|---:|
| btnSearch | 조회 | bottom-right | FindButton 호출 | NN |
| btnApply | 확인 | bottom-right | 선택 row return + Form 닫기 | NN |
| btnCancel | 취소 | bottom-right | Form 닫기 (선택 무시) | NN |

---

## §2 Form_Load 시그니처 + 호출 인자 분기

```csharp
public void Form_Load(bool isMultiSelect, string divisionId, string projectCode, string bizType, ...)
{
    // 인자별 분기 처리
}
```

| 호출 화면 | 인자 (예) | 분기 동작 |
|---|---|---|
| DMF0004 spdMain dblClick | (false, "81", null, null) | 단일선택, division 81 |
| DMF0005 spdMain dblClick | (false, "40", null, null) | 단일선택, division 40 |
| DMF0008 btnApply Click | (true, "81", null, "EV") | 다중선택, biz type EV |
| ... | | |

---

## §3 검색 (FindButton) 호출 SP

| SP | parameter | 결과 컬럼 | line |
|---|---|---|---:|
| `SCM.SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX` | DivisionId / ProjectCode / BizType / UserId | DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, BIZ_TYPE_NAME | NN |

§ 권한 처리: `filter["_AUTH"] = ...` 위치, `filter["USER_ID"]` 사용

---

## §4 결과 처리 (확인 / 더블클릭 / 다중선택)

§ §4.1 단일선택 (btnApply 또는 row dblClick)
- return 데이터 구조 (DataRow, dictionary, custom class)
- 호출자가 받는 컬럼 list

§ §4.2 다중선택 (isMultiSelect=true)
- check 컬럼 명
- return 구조 (DataTable / List)

---

## §5 Validation

| Msg ID | trigger | line |
|---|---|---:|
| MSG00002 | 검색조건 필수 누락 | NN |
| MSG00137 | 결과 0건 | NN |
| ... | | |

---

## §6 Event 인벤토리

| 위치 | event | 메서드 | 책임 | line |
|---|---|---|---|---:|
| spdMain | CellDoubleClick | OnRowDblClick | 자동 확인 + 닫기 | NN |
| cboDivision | SelectedIndexChanged | RefreshDependentCombo | combo cascade | NN |
| ... | | | | |

---

## §7 권한 (호출자가 무엇을 보장해야 하는가)

- 호출자 `_SAVE_AUTH` 인자 전달 시 동작
- popup 안에서 별도 권한 체크 (있으면)

---

## §8 호출 패턴 인벤토리 (어느 화면이 어떻게 사용하는가)

| 화면 | trigger | Form_Load 인자 | 콜백 처리 | line |
|---|---|---|---|---:|
| DMF0004_SalesSite | spdMain cell dblClick (binding=PROJECT_CODE) | (false, "81", null) | siMain.SetValue(row, PROJECT_CODE, ret) | DMF0004.cs:NN |
| DMF0005_PjtModelMapping | spdMain cell dblClick | (false, divisionId, null) | siMain.SetValue(row, PROJECT_CODE/NAME, ret) | DMF0005.cs:NN |
| DMF0006_CustomerModelMapping | btnSearch.Click | (true, divisionId, null) | grid filter 갱신 | DMF0006.cs:NN |
| ... | | | | |

---

## §9 TO-BE 매핑 (modal `@master/components/{Name}Modal`)

§ §9.1 매핑 modal 존재 여부

| 항목 | 값 |
|---|---|
| TO-BE modal | `ProjectByDivisionModal` |
| 위치 | `nscm-fe/features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx` |
| Props | `open, modalClose, setSelectedValue, preSearchParams, callFromCell` |

§ §9.2 4축 격차 cross-check

| 축 | AS-IS | TO-BE | 격차 |
|---|---|---|---|
| 검색조건 컬럼 | §1.1 list | TO-BE form list | (예: ProjectStatus 누락) |
| 결과 표시 컬럼 | §1.3 list | TO-BE grid columns | OK |
| Validation MSG ID | §5 list | TO-BE validation | OK |
| Event handler | §6 list | TO-BE event | OK |

§ §9.3 격차 해소 작업

| 격차 | 해결 방법 | 적용 위치 |
|---|---|---|
| ProjectStatus 누락 | TO-BE Form 에 추가 | `ProjectByDivisionModal.tsx` |
| ... | | |

§ §9.4 setSelectedValue 콜백 형식 (TO-BE)

```typescript
setSelectedValue: (project: {
  PROJECT_CODE: string;
  PROJECT_NAME: string;
  PROJECT_STATUS: string;  // 신규
  BIZ_TYPE_NAME: string;
}) => void
```

---

## §10 분석 완료 자기 점검

```bash
# 모든 .cs 컨트롤이 §1 에 있는지
test $(grep -cE "this\.\w+\s*=" {p}.Designer.cs) -ge $(awk '/^## §1/,/^## §2/' __popup__.md | grep -c "^| [0-9]")

# 모든 GMessageBox 가 §5 에 있는지
test $(grep -cE "MessageHelper\.GMessageBox" {p}.cs) -le $(awk '/^## §5/,/^## §6/' __popup__.md | grep -c "MSG[0-9]")

# 호출 화면 list 가 §8 에 있는지 (역 grep)
for screen in $(grep -rlE "new\s+{PopupName}\s*\(" GSCM/06.UIL/); do
  basename $screen
done
# = §8 호출 패턴 화면 list
```

§ §10 미통과 = 재작업.
