# AS-IS 액션 대조표 — SSP0301

> 원천: `Doc/asisfacts/screens/SSP0301/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 8행 · 메서드 8 · 종류 UI_MISC 3 · UI_PROP 3 · VALUE_CLEAR 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 0


## SSP0301_SqlPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d50a36cc | this.btnClose.Click | SSP0301_SqlPopup.cs:155 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0301_SqlPopup.comboService_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d561909 | (진입점 미연결) | SSP0301_SqlPopup.cs:166 |  | VALUE_CLEAR | rtxtSQL.Text | "" | 컨트롤 값 비움 |  |  |  |

## SSP0301_SqlPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db25ae33 | this.Load | SSP0301_SqlPopup.cs:85 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0301_SqlPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48bcb093 | Dispose | SSP0301_SqlPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0301_SqlPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42706640 | this.Load | SSP0301_SqlPopup.cs:65 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0301_SqlPopup.FPC0001_SqlPopup_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ebb8c59 | this.Load | SSP0301_SqlPopup.cs:174 |  | UI_PROP | btnClose.Left | (panel1.Width - btnClose.Width) / 2 | 속성 Left 설정 |  |  |  |

## SSP0301_SqlPopup.panel1_SizeChanged

진입점: this.panel1.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a523df8e | this.panel1.SizeChanged | SSP0301_SqlPopup.cs:161 |  | UI_PROP | btnClose.Left | (panel1.Width - btnClose.Width) / 2 | 속성 Left 설정 |  |  |  |

## SSP0301_SqlPopup.processDataset

진입점: this.Load [if (dsData != null)] / this.Load [if (this.dsData!=null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b03ab9d0 | this.Load [if (dsData != null)] 외 2 | SSP0301_SqlPopup.cs:143 | if (dt != null && dt.Tables != null && dt.Tables.Count > 0 && dt.Tables[0].Rows != null && dt.Tables[0].Rows.Count > 0) | VALUE_SET | rtxtSQL.Text | res | 컨트롤 값 설정 |  |  |  |

