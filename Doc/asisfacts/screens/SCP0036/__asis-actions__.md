# AS-IS 액션 대조표 — SCP0036

> 원천: `Doc/asisfacts/screens/SCP0036/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 231행 · 메서드 21 · 종류 DATA_OP 120 · GRID_SET 30 · RETURN 21 · MESSAGE 10 · POPUP 8 · GRID_LOCK 7 · FLAG 6 · ENDPOINT 6 · UI_PROP 5 · GRID_INIT 4 · UI_MISC 4 · GRID_STYLE 3 · VALIDATE 3 · LIST_REBIND 2 · GRID_BIND 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SCP0036_JigItem.checkValidN0

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebc5bb91 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:636 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a903d22 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:639 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-32bac656 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:640 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f79609e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:641 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0446dfba | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:657 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e59504e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:658 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-02f819d0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:659 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-220a7426 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:676 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68c0e656 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:680 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN1

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a2d31ee | (진입점 미연결) | SCP0036_JigItem.cs:695 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-7428e106 | (진입점 미연결) | SCP0036_JigItem.cs:698 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-181b00c7 | (진입점 미연결) | SCP0036_JigItem.cs:699 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-f81a6448 | (진입점 미연결) | SCP0036_JigItem.cs:700 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fdde6e0 | (진입점 미연결) | SCP0036_JigItem.cs:701 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-15bb5028 | (진입점 미연결) | SCP0036_JigItem.cs:702 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e7d433 | (진입점 미연결) | SCP0036_JigItem.cs:704 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-5735bbea | (진입점 미연결) | SCP0036_JigItem.cs:712 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2975135 | (진입점 미연결) | SCP0036_JigItem.cs:715 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9898c04 | (진입점 미연결) | SCP0036_JigItem.cs:716 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-e675863e | (진입점 미연결) | SCP0036_JigItem.cs:717 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e78d3716 | (진입점 미연결) | SCP0036_JigItem.cs:718 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-31f7be62 | (진입점 미연결) | SCP0036_JigItem.cs:719 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-329c9810 | (진입점 미연결) | SCP0036_JigItem.cs:733 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00212", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f5daabff | (진입점 미연결) | SCP0036_JigItem.cs:736 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccdb435c | (진입점 미연결) | SCP0036_JigItem.cs:750 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-24d51058 | (진입점 미연결) | SCP0036_JigItem.cs:753 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d71e68 | (진입점 미연결) | SCP0036_JigItem.cs:754 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-41678a9a | (진입점 미연결) | SCP0036_JigItem.cs:755 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e78d1c1f | (진입점 미연결) | SCP0036_JigItem.cs:756 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-351a1724 | (진입점 미연결) | SCP0036_JigItem.cs:757 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2dedd09 | (진입점 미연결) | SCP0036_JigItem.cs:759 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-69cbd9a5 | (진입점 미연결) | SCP0036_JigItem.cs:767 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-a50f0b3a | (진입점 미연결) | SCP0036_JigItem.cs:770 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a47a84c6 | (진입점 미연결) | SCP0036_JigItem.cs:771 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-05e2ece1 | (진입점 미연결) | SCP0036_JigItem.cs:772 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d908e59d | (진입점 미연결) | SCP0036_JigItem.cs:773 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7b84c93 | (진입점 미연결) | SCP0036_JigItem.cs:774 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b8b17ac | (진입점 미연결) | SCP0036_JigItem.cs:788 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00213", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7901280b | (진입점 미연결) | SCP0036_JigItem.cs:791 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN3

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868322bf | (진입점 미연결) | SCP0036_JigItem.cs:805 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-1533c402 | (진입점 미연결) | SCP0036_JigItem.cs:808 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-70e60e7d | (진입점 미연결) | SCP0036_JigItem.cs:809 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-98ce291f | (진입점 미연결) | SCP0036_JigItem.cs:810 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc60309 | (진입점 미연결) | SCP0036_JigItem.cs:811 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-703f58d0 | (진입점 미연결) | SCP0036_JigItem.cs:812 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf199e4b | (진입점 미연결) | SCP0036_JigItem.cs:814 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2edea99 | (진입점 미연결) | SCP0036_JigItem.cs:823 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-00f294f5 | (진입점 미연결) | SCP0036_JigItem.cs:826 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-d25f3416 | (진입점 미연결) | SCP0036_JigItem.cs:827 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a163ca02 | (진입점 미연결) | SCP0036_JigItem.cs:828 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3dce19e | (진입점 미연결) | SCP0036_JigItem.cs:829 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d32c16e9 | (진입점 미연결) | SCP0036_JigItem.cs:830 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-11326da1 | (진입점 미연결) | SCP0036_JigItem.cs:844 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00250", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c9d24a3 | (진입점 미연결) | SCP0036_JigItem.cs:847 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN5

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d0f4a10 | (진입점 미연결) | SCP0036_JigItem.cs:865 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-be67e88f | (진입점 미연결) | SCP0036_JigItem.cs:868 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-392523ac | (진입점 미연결) | SCP0036_JigItem.cs:869 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-aabc5cbe | (진입점 미연결) | SCP0036_JigItem.cs:870 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b51dc8a4 | (진입점 미연결) | SCP0036_JigItem.cs:871 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-70710007 | (진입점 미연결) | SCP0036_JigItem.cs:872 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-f33febff | (진입점 미연결) | SCP0036_JigItem.cs:879 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b6a0a5a | (진입점 미연결) | SCP0036_JigItem.cs:888 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-95e88ac4 | (진입점 미연결) | SCP0036_JigItem.cs:891 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-50e2d440 | (진입점 미연결) | SCP0036_JigItem.cs:892 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f93dc3a | (진입점 미연결) | SCP0036_JigItem.cs:893 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fddfe21 | (진입점 미연결) | SCP0036_JigItem.cs:894 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-4879879c | (진입점 미연결) | SCP0036_JigItem.cs:895 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-46ba7c0d | (진입점 미연결) | SCP0036_JigItem.cs:921 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00216", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fe366f1 | (진입점 미연결) | SCP0036_JigItem.cs:924 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN6

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-712c9bdf | (진입점 미연결) | SCP0036_JigItem.cs:940 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5d4a8e9 | (진입점 미연결) | SCP0036_JigItem.cs:943 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-68073bb7 | (진입점 미연결) | SCP0036_JigItem.cs:946 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bda568b | (진입점 미연결) | SCP0036_JigItem.cs:947 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-d07ae60b | (진입점 미연결) | SCP0036_JigItem.cs:948 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1259bf95 | (진입점 미연결) | SCP0036_JigItem.cs:949 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b1f351f | (진입점 미연결) | SCP0036_JigItem.cs:950 | for (i < dsValiChkBinding.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d364562 | (진입점 미연결) | SCP0036_JigItem.cs:952 | for (i < dsValiChkBinding.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("VALID_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-643c6a26 | (진입점 미연결) | SCP0036_JigItem.cs:953 | for (i < dsValiChkBinding.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("JIG_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b3c433b | (진입점 미연결) | SCP0036_JigItem.cs:954 | for (i < dsValiChkBinding.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb093a9a | (진입점 미연결) | SCP0036_JigItem.cs:954 | for (i < dsValiChkBinding.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("TO_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-9de7a2b1 | (진입점 미연결) | SCP0036_JigItem.cs:970 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-251527c1 | (진입점 미연결) | SCP0036_JigItem.cs:973 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_ITEM_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5304d81 | (진입점 미연결) | SCP0036_JigItem.cs:974 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.JIG_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcb9eeb6 | (진입점 미연결) | SCP0036_JigItem.cs:975 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7125c24f | (진입점 미연결) | SCP0036_JigItem.cs:976 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-678b0f26 | (진입점 미연결) | SCP0036_JigItem.cs:977 | for (i < dsValiChkBinding.Rows.Count) ▸ for (j < dsValiChkBinding.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b6b102c | (진입점 미연결) | SCP0036_JigItem.cs:995 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00217", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09700744 | (진입점 미연결) | SCP0036_JigItem.cs:999 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.checkValidN8

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e999a1c8 | (진입점 미연결) | SCP0036_JigItem.cs:1014 | for (i <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-adf3d6bf | (진입점 미연결) | SCP0036_JigItem.cs:1030 | for (i <= siMain.GetMaxRowIndex()) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | GRID_STYLE | siMain.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-72925396 | (진입점 미연결) | SCP0036_JigItem.cs:1031 | for (i <= siMain.GetMaxRowIndex()) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-49714997 | (진입점 미연결) | SCP0036_JigItem.cs:1040 | for (i <= siMain.GetMaxRowIndex()) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | GRID_STYLE | siMain.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-53a73663 | (진입점 미연결) | SCP0036_JigItem.cs:1047 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef206085 | (진입점 미연결) | SCP0036_JigItem.cs:1050 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-721eccd1 | this.Load | SCP0036_JigItem.cs:137 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2896812e | this.Load | SCP0036_JigItem.cs:138 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-51b74401 | this.Load | SCP0036_JigItem.cs:139 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0036_JigItem.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23cb769f | DeleteButton | SCP0036_JigItem.cs:181 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-262ac73c | DeleteButton | SCP0036_JigItem.cs:186 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0036_JigItem.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69eb3338 | Dispose | SCP0036_JigItem.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0036_JigItem.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e92424dd | EditButton | SCP0036_JigItem.cs:167 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6616beb | EditButton | SCP0036_JigItem.cs:168 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f33e0f89 | EditButton | SCP0036_JigItem.cs:170 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cea7cbf4 | EditButton | SCP0036_JigItem.cs:171 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0036_JigItem.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e29989d | FindButton 외 1 | SCP0036_JigItem.cs:203 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d5716ace | FindButton 외 1 | SCP0036_JigItem.cs:206 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-089a46dd | FindButton 외 1 | SCP0036_JigItem.cs:206 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80d9534d | FindButton 외 1 | SCP0036_JigItem.cs:210 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ef6799b2 | FindButton 외 1 | SCP0036_JigItem.cs:222 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-53696e66 | FindButton 외 1 | SCP0036_JigItem.cs:223 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-01b9dbae | FindButton 외 1 | SCP0036_JigItem.cs:227 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0036_GET_JIG_ITEM") ⇒ SCP.SCP0036_GET_JIG_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-b6e7e271 | FindButton 외 1 | SCP0036_JigItem.cs:228 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9b236fbb | FindButton 외 1 | SCP0036_JigItem.cs:229 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2257b4ee | FindButton 외 1 | SCP0036_JigItem.cs:230 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-85ca5c44 | FindButton 외 1 | SCP0036_JigItem.cs:231 | try ▸ lambda | DATA_OP | request.Parameters["p_jig_name"] | p_jig_name | 행/컬럼 값 대입 |  |  |  |
| AC-c1f9ef96 | FindButton 외 1 | SCP0036_JigItem.cs:232 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn.Equals("ALL") ? DBNull.Value : p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-bb071ebe | FindButton 외 1 | SCP0036_JigItem.cs:234 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b1b3c46 | FindButton 외 1 | SCP0036_JigItem.cs:236 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6bc5eec9 | FindButton 외 1 | SCP0036_JigItem.cs:243 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3372e3ad | FindButton 외 1 | SCP0036_JigItem.cs:244 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1ac5098 | FindButton 외 1 | SCP0036_JigItem.cs:247 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1abaa311 | FindButton 외 1 | SCP0036_JigItem.cs:252 | try | FLAG | dsFullBinding | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-2cdc04c3 | FindButton 외 1 | SCP0036_JigItem.cs:262 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0036_JigItem.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed911da3 | this.Load | SCP0036_JigItem.cs:97 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0036_JigItem.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d7f8931 | this.Load | SCP0036_JigItem.cs:113 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-babe7f2b | this.Load | SCP0036_JigItem.cs:116 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-cba89a12 | this.Load | SCP0036_JigItem.cs:118 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ab3080d6 | this.Load | SCP0036_JigItem.cs:119 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0036_JigItem.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d03bfec5 | this.Load 외 2 | SCP0036_JigItem.cs:146 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6baed3f0 | this.Load 외 2 | SCP0036_JigItem.cs:147 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0036_JigItem.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-857e16e3 | InsertButton | SCP0036_JigItem.cs:273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bd5bb9dd | InsertButton | SCP0036_JigItem.cs:279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-8343d4a9 | InsertButton | SCP0036_JigItem.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.FROM_YYYYMMDD, "2018-01-01") | 데이터 객체 조작/조회 |  |  |  |
| AC-34eb27ba | InsertButton | SCP0036_JigItem.cs:281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.TO_YYYYMMDD, "2100-01-01") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cb9e4db | InsertButton | SCP0036_JigItem.cs:283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b57b3e9c | InsertButton | SCP0036_JigItem.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e230c33 | InsertButton | SCP0036_JigItem.cs:286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8bb51a3e | InsertButton | SCP0036_JigItem.cs:287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0036_JigItem.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a88e995 | SaveButton | SCP0036_JigItem.cs:301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be3a8243 | SaveButton | SCP0036_JigItem.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-6b93afea | SaveButton | SCP0036_JigItem.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c36a9142 | SaveButton | SCP0036_JigItem.cs:323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db51a555 | SaveButton | SCP0036_JigItem.cs:371 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0036_SAVE_JIG_ITEM") ⇒ SCP.SCP0036_SAVE_JIG_ITEM | 엔드포인트 요청 생성 |  |  |  |
| AC-dfd89df0 | SaveButton | SCP0036_JigItem.cs:375 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b3ddf0d | SaveButton | SCP0036_JigItem.cs:379 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6bfa98d0 | SaveButton | SCP0036_JigItem.cs:380 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_jig_seq"] | p_jig_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4fb96fe7 | SaveButton | SCP0036_JigItem.cs:381 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_jig_item_seq"] | p_jig_item_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b258b09c | SaveButton | SCP0036_JigItem.cs:382 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0856fea3 | SaveButton | SCP0036_JigItem.cs:383 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e220fcdd | SaveButton | SCP0036_JigItem.cs:384 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3348fd6c | SaveButton | SCP0036_JigItem.cs:385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-61c1c108 | SaveButton | SCP0036_JigItem.cs:386 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_s_valid_yn"] | p_s_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3458a176 | SaveButton | SCP0036_JigItem.cs:387 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-d241a9e5 | SaveButton | SCP0036_JigItem.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-967e97e1 | SaveButton | SCP0036_JigItem.cs:389 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-71550f38 | SaveButton | SCP0036_JigItem.cs:390 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1b907a58 | SaveButton | SCP0036_JigItem.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-283dbe9c | SaveButton | SCP0036_JigItem.cs:392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-0f683256 | SaveButton | SCP0036_JigItem.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aaa66355 | SaveButton | SCP0036_JigItem.cs:411 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0036_JigItem.set_ValidDataSet

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb7cddfa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:582 |  | FLAG | dsValiChkBinding | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5c79d3cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:583 |  | FLAG | dsValiChkBinding | dsFullBinding.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1fde450a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:583 |  | DATA_OP | dsFullBinding.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5d66a63d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:587 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("JIG_ITEM_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8878b8cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:588 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("JIG_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d45d1df8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:589 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb3bbf5d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:590 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("FROM_YYYYMMDD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-264cbeeb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:591 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("TO_YYYYMMDD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86ff663f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:592 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("VALID_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbb04e82 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:593 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.Columns.Add | ("ACTION_FLAG_DIV", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ee7c9f6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:594 | if (dsValiChkBinding==null) | DATA_OP | dsValiChkBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78abdb7d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:606 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(JIG_ITEM_SEQ)) | DATA_OP | dsValiChkBinding.Rows.Remove | (dsValiChkBinding.Select("JIG_ITEM_SEQ = '" + JIG_ITEM_SEQ + "'")[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaff7ee6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:606 | for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(JIG_ITEM_SEQ)) | DATA_OP | dsValiChkBinding.Select | ("JIG_ITEM_SEQ = '" + JIG_ITEM_SEQ + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a7771c6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:609 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsValiChkBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de84be5e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:611 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.JIG_ITEM_SEQ] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.JIG_ITEM_SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54866cc6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:612 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.JIG_SEQ] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.JIG_SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b472ce3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:613 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.ITEM_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c41d7d2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:614 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.FROM_YYYYMMDD] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fb6fd744 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:615 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.TO_YYYYMMDD] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e702a978 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:616 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.VALID_YN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06552e9d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:617 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newDr[DefColumns.ACTION_FLAG_DIV] | action | 행/컬럼 값 대입 |  |  |  |
| AC-1a3af8ab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:619 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsValiChkBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c9b6aee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0036_JigItem.cs:622 |  | DATA_OP | dsValiChkBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0036_JigItem.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecbcd2b7 | spdMain.CellClick | SCP0036_JigItem.cs:427 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ceb663ea | spdMain.CellClick | SCP0036_JigItem.cs:435 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | POPUP | new SCM0002_JigbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8f89c49b | spdMain.CellClick | SCP0036_JigItem.cs:437 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | POPUP | popJig.Form_Load | (false, "", "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-6a9b5e69 | spdMain.CellClick | SCP0036_JigItem.cs:438 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | UI_PROP | popJig.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f9a6aa0 | spdMain.CellClick | SCP0036_JigItem.cs:439 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | POPUP | popJig.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cdecea31 | spdMain.CellClick | SCP0036_JigItem.cs:443 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.JIG_SEQ), popJig.JIgSeq) | 그리드 값 설정 |  |  |  |
| AC-82c9dd11 | spdMain.CellClick | SCP0036_JigItem.cs:444 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.JIG_NAME), popJig.JigName) | 그리드 값 설정 |  |  |  |
| AC-0af49068 | spdMain.CellClick | SCP0036_JigItem.cs:445 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), popJig.ScmSiteNm) | 그리드 값 설정 |  |  |  |
| AC-90038c19 | spdMain.CellClick | SCP0036_JigItem.cs:447 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), popJig.OperationId) | 그리드 값 설정 |  |  |  |
| AC-cb013364 | spdMain.CellClick | SCP0036_JigItem.cs:448 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), popJig.DivisionId) | 그리드 값 설정 |  |  |  |
| AC-72f00341 | spdMain.CellClick | SCP0036_JigItem.cs:449 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), popJig.ScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-c0e52dd1 | spdMain.CellClick | SCP0036_JigItem.cs:451 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-66bcf278 | spdMain.CellClick | SCP0036_JigItem.cs:452 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.JIG_… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-27abdb5c | spdMain.CellClick | SCP0036_JigItem.cs:462 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "JIG Name" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f610e0bf | spdMain.CellClick | SCP0036_JigItem.cs:463 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3ae8b75 | spdMain.CellClick | SCP0036_JigItem.cs:467 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12ff1cc5 | spdMain.CellClick | SCP0036_JigItem.cs:480 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | POPUP | new SCM0002_ItembyPlantSitePopup | () | 팝업/폼 생성 |  |  |  |
| AC-650633ad | spdMain.CellClick | SCP0036_JigItem.cs:482 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | POPUP | popItem.Form_Load | (false, "Y", division, sScmSite, "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-5d5c9b48 | spdMain.CellClick | SCP0036_JigItem.cs:483 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d5018406 | spdMain.CellClick | SCP0036_JigItem.cs:484 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f67bb61 | spdMain.CellClick | SCP0036_JigItem.cs:490 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-dbf47768 | spdMain.CellClick | SCP0036_JigItem.cs:491 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, 0) == "I") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |

## SCP0036_JigItem.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-725c5e89 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:515 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91d4ae13 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:518 | if (siMain.IsLock(siMain.SheetName) == true \|\| siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActio…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed389339 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:529 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | DATA_OP | dtJIGAll.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4e768d0 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:532 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | DATA_OP | dtChkSiteRow.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-23f51342 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:533 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtChkSite.Rows[0][DefColumns.DIVISIO… | 그리드 값 설정 |  |  |  |
| AC-e7a33b5c | spdMain.ClipboardPasted | SCP0036_JigItem.cs:534 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.JIG_SEQ), dtChkSite.Rows[0][DefColumns.JIG_SEQ].To… | 그리드 값 설정 |  |  |  |
| AC-922beb89 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:535 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), dtChkSite.Rows[0][DefColumns.SI… | 그리드 값 설정 |  |  |  |
| AC-4e48d6a6 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:536 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), dtChkSite.Rows[0][DefColumns.OPERAT… | 그리드 값 설정 |  |  |  |
| AC-a0623755 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:537 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtChkSite.Rows[0][DefColumns.SCM_SIT… | 그리드 값 설정 |  |  |  |
| AC-bb20c86e | spdMain.ClipboardPasted | SCP0036_JigItem.cs:541 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.JIG_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-bf528ed2 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:542 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8613db04 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:543 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.JIG_SEQ), "") | 그리드 값 설정 |  |  |  |
| AC-52829bba | spdMain.ClipboardPasted | SCP0036_JigItem.cs:544 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-24893f0f | spdMain.ClipboardPasted | SCP0036_JigItem.cs:545 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d17f9658 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:546 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-406035d3 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:552 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.JIG_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0046e5d5 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:553 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-210143e3 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:554 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.JIG_SEQ), "") | 그리드 값 설정 |  |  |  |
| AC-d066c604 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:555 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-aad7ac59 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:556 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1dbb6edc | spdMain.ClipboardPasted | SCP0036_JigItem.cs:557 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (siMain.ActiveSheet.Cel… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ca7db5cc | spdMain.ClipboardPasted | SCP0036_JigItem.cs:561 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e156d3c4 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:562 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-63526bd8 | spdMain.ClipboardPasted | SCP0036_JigItem.cs:563 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (siMain.ActiveShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0036_JigItem.SpdMain_KeyPress

진입점: spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a3df8e0 | spdMain.KeyPress | SCP0036_JigItem.cs:505 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-133a0853 | spdMain.KeyPress | SCP0036_JigItem.cs:507 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

