# AS-IS 실측 요약 — GSCM_MESSAGEINFO

- 실행: 2026-11-12 21:09:10.945 ~ 2026-11-12 21:09:52.500 · 계정 jaeuk.shin · 상태 OK
- 화면: Message (GSCM.SystemMgmt.UIL.MessageInfo)
- 조회 결과: None ·  · 완료 판단 no_signal
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 21:09:11.286 | load | GSCM.BizService.WSL | UP_FX_GetBaseCodeList | 4 | 3.2 | Level=100, BaseCode=0201000 |
| 21:09:11.293 | load | GSCM.BizService.WSL | UP_FX_GetBaseCodeList | 6 | 2.94 | Level=100, BaseCode=0202000 |
| 21:09:11.348 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0108 |
| 21:09:11.374 | load | GSCM.BizService.WSL | SELECT * | 874 | 20.13 | USER_ID= |
| 21:09:11.475 | load | GSCM.BizService.WSL | UP_FX_GetBaseCodeList | 4 | 6.67 | Level=100, BaseCode=0201000 |
| 21:09:11.954 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 432.94 | MenuID=Message, CnntCode=0104001, UserID=jaeuk.shin |
| 21:09:12.081 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.19 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=SY0108 |
| 21:09:20.933 | find | GSCM.SystemMgmt.WSL | UP_FX_GetMessageInfoSeachList | 470 | 278.05 | MessageType=None, Search=None |
| 21:09:51.754 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.1 | MenuID=Message, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Message | txtSearch |  |
| Message Type | cmbType |  |

## 그리드

- spdMain / MessageInfo: 행 470 · 컬럼 8(보임 7) · 헤더 1단 · 고정 컬럼 1

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
