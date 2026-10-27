# AS-IS 액션 대조표 — DEMO001

> 원천: `Doc/asisfacts/screens/DEMO001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 264행 · 메서드 28 · 종류 CALL_EXT 78 · DATA_OP 66 · FLAG 62 · ENDPOINT 26 · UI_PROP 9 · UI_MISC 7 · POPUP 7 · RETURN 2 · GRID_SET 2 · EXTERNAL_IF 2 · STATE_RESET 2 · THROW 1 · ⚠ 의미 확인 필요 78


## Program.excuteQury

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69e6320c | (진입점 미연결) | Program.cs:456 |  | FLAG | xifCon | new SqlConnection(ConfigurationManager.AppSettings["XIFConnectionString"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c7955d4 | (진입점 미연결) | Program.cs:458 |  | CALL_EXT | xifCon.Open | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b39b04d9 | (진입점 미연결) | Program.cs:462 |  | CALL_EXT | xifCon.BeginTransaction | ("XIFTransaction") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cc9de2f | (진입점 미연결) | Program.cs:464 |  | FLAG | xifCom | new SqlCommand() | 화면 필드/플래그 변경 |  |  |  |
| AC-f985b9f8 | (진입점 미연결) | Program.cs:465 |  | UI_PROP | xifCom.Connection | xifCon | 속성 Connection 설정 |  |  |  |
| AC-daf2391b | (진입점 미연결) | Program.cs:466 |  | UI_PROP | xifCom.Transaction | transaction | 속성 Transaction 설정 |  |  |  |
| AC-5440b4d1 | (진입점 미연결) | Program.cs:478 | try ▸ for (jdx < lstSQL.Count()) ▸ if (tmpCount == mergeCount) | UI_PROP | xifCom.CommandText | sqlMerge.ToString() | 속성 CommandText 설정 |  |  |  |
| AC-df01142a | (진입점 미연결) | Program.cs:485 | try ▸ for (jdx < lstSQL.Count()) ▸ if (tmpCount == mergeCount) | ENDPOINT | xifCom.ExecuteNonQuery | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85ffe0d2 | (진입점 미연결) | Program.cs:495 | try ▸ for (jdx < lstSQL.Count()) ▸ if (jdx == lstSQL.Count() - 1) ▸ if (sqlMerge.Length > 0) | UI_PROP | xifCom.CommandText | sqlMerge.ToString() | 속성 CommandText 설정 |  |  |  |
| AC-165806e8 | (진입점 미연결) | Program.cs:498 | try ▸ for (jdx < lstSQL.Count()) ▸ if (jdx == lstSQL.Count() - 1) ▸ if (sqlMerge.Length > 0) | ENDPOINT | xifCom.ExecuteNonQuery | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8246f85d | (진입점 미연결) | Program.cs:505 | try | CALL_EXT | transaction.Commit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8aede9a | (진입점 미연결) | Program.cs:507 | try | UI_MISC | xifCon.Close | () | 창 닫기/해제 |  |  |  |
| AC-71cbb55d | (진입점 미연결) | Program.cs:517 | catch ((Exception ex)) ▸ try | CALL_EXT | transaction.Rollback | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc87ac2b | (진입점 미연결) | Program.cs:527 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## Program.GET_IFSEQNO

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4afcba3 | (진입점 미연결) | Program.cs:415 |  | UI_PROP | scmCom.Connection | scmCon | 속성 Connection 설정 |  |  |  |
| AC-72e5ac80 | (진입점 미연결) | Program.cs:419 | try | CALL_EXT | scmCon.Open | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-509ac80b | (진입점 미연결) | Program.cs:421 | try | UI_PROP | scmCom.CommandText | (string.Format(@"SELECT NEXT VALUE FOR {0};", p_sequence_name)) | 속성 CommandText 설정 |  |  |  |
| AC-57eae617 | (진입점 미연결) | Program.cs:423 | try | ENDPOINT | scmCom.ExecuteScalar | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-008516e5 | (진입점 미연결) | Program.cs:425 | try | UI_MISC | scmCon.Close | () | 창 닫기/해제 |  |  |  |
| AC-77de7bd8 | (진입점 미연결) | Program.cs:427 | try | RETURN | return (Int64)returnValue; |  | 처리 중단/반환 |  |  |  |
| AC-76cc80d1 | (진입점 미연결) | Program.cs:432 | catch ((Exception ex)) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-843691f6 | (진입점 미연결) | Program.cs:438 | finally ▸ if (scmCon != null) | UI_MISC | scmCon.Dispose | () | 창 닫기/해제 |  |  |  |

## Program.Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80278bad | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-66d9d52e | (진입점 미연결) | Program.cs:26 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f70efbeb | (진입점 미연결) | Program.cs:28 |  | CALL_EXT | Go.Go.Launch | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-60d954fc | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d77220e | (진입점 미연결) | Program.cs:26 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f08d5e02 | (진입점 미연결) | Program.cs:28 |  | CALL_EXT | Go.Go.Launch | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0324cbd6 | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4bf5a53 | (진입점 미연결) | Program.cs:26 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cc26598 | (진입점 미연결) | Program.cs:28 |  | CALL_EXT | Go.Go.Launch | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7559ff85 | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6429f362 | (진입점 미연결) | Program.cs:26 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-854bc14a | (진입점 미연결) | Program.cs:28 |  | CALL_EXT | Go.Go.Launch | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b70ef98 | (진입점 미연결) | Program.cs:17 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-31314ee2 | (진입점 미연결) | Program.cs:18 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34d0f53c | (진입점 미연결) | Program.cs:19 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8493430f | (진입점 미연결) | Program.cs:19 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |
| AC-bc0a8e9e | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ddda72bb | (진입점 미연결) | Program.cs:26 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afa053f0 | (진입점 미연결) | Program.cs:27 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6b9d64d | (진입점 미연결) | Program.cs:27 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |
| AC-be920e99 | (진입점 미연결) | Program.cs:73 | if (args.Count() > 0) | FLAG | program_name | args[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b6b63126 | (진입점 미연결) | Program.cs:100 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_BEGIN_END_STOCK_R": | CALL_EXT | args.Last | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7dfb6fc1 | (진입점 미연결) | Program.cs:263 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | FLAG | rfc | new RfcConfigParameters() | 화면 필드/플래그 변경 |  |  |  |
| AC-78fdff0d | (진입점 미연결) | Program.cs:264 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.Name, SAPRfcName) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f76571b | (진입점 미연결) | Program.cs:266 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.MessageServerHost, SAPRfcMessageServerHost) | 데이터 객체 조작/조회 |  |  |  |
| AC-471ce277 | (진입점 미연결) | Program.cs:267 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.Client, SAPRfcClient) | 데이터 객체 조작/조회 |  |  |  |
| AC-08aee3d8 | (진입점 미연결) | Program.cs:268 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.User, SAPRfcUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6efb7cf | (진입점 미연결) | Program.cs:269 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.Password, SAPRfcPassword) | 데이터 객체 조작/조회 |  |  |  |
| AC-60541e49 | (진입점 미연결) | Program.cs:271 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.SystemID, SAPRfcSystemID) | 데이터 객체 조작/조회 |  |  |  |
| AC-465f1624 | (진입점 미연결) | Program.cs:272 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.LogonGroup, SAPRfcLogonGroup) | 데이터 객체 조작/조회 |  |  |  |
| AC-833c159c | (진입점 미연결) | Program.cs:273 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.Language, SAPRfcLanguage) | 데이터 객체 조작/조회 |  |  |  |
| AC-334e59aa | (진입점 미연결) | Program.cs:274 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | DATA_OP | rfc.Add | (RfcConfigParameters.PoolSize, SAPRfcPoolSize) | 데이터 객체 조작/조회 |  |  |  |
| AC-185daeec | (진입점 미연결) | Program.cs:276 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | FLAG | rfcDest | RfcDestinationManager.GetDestination(rfc) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3e4a2b9 | (진입점 미연결) | Program.cs:276 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | CALL_EXT | RfcDestinationManager.GetDestination | (rfc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db6e6d62 | (진입점 미연결) | Program.cs:277 | try ▸ if (args.Count() > 0) ▸ switch (callFunction) case "XIF_ERP_SLOC_R": case "XIF_ERP_VENDOR_R": case "XIF_ERP_CUSTOMER_R": case "XIF_ERP… | FLAG | rfcRep | rfcDest.Repository | 화면 필드/플래그 변경 |  |  |  |
| AC-e608635c | (진입점 미연결) | Program.cs:329 | finally ▸ if (rfc != null) | FLAG | rfc | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8fb8ad04 | (진입점 미연결) | Program.cs:330 | finally ▸ if (rfc != null) | FLAG | rfcDest | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f284eb78 | (진입점 미연결) | Program.cs:331 | finally ▸ if (rfc != null) | FLAG | rfcRep | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fd473cf1 | (진입점 미연결) | Program.cs:58 | try | CALL_EXT | LogWork.CreateLogFile | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-26f63a87 | (진입점 미연결) | Program.cs:70 | try ▸ else of (args == null \|\| args.Count() == 0 \|\| args[0] == null) | FLAG | program_name | args[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2b61570b | (진입점 미연결) | Program.cs:78 | try ▸ else of (args == null \|\| args.Count() == 0 \|\| args[0] == null) ▸ for (args.Length > i) ▸ if (i == 0) | FLAG | argsLog | args[i] | 화면 필드/플래그 변경 |  |  |  |
| AC-283c8036 | (진입점 미연결) | Program.cs:80 | try ▸ else of (args == null \|\| args.Count() == 0 \|\| args[0] == null) ▸ for (args.Length > i) ▸ else of (i == 0) | FLAG | argsLog | += ", " + args[i] | 화면 필드/플래그 변경 |  |  |  |
| AC-b06b8153 | (진입점 미연결) | Program.cs:87 | try ▸ else of (args == null \|\| args.Count() == 0 \|\| args[0] == null) | CALL_EXT | nerp.Run | (program_name, args) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e00c64e | (진입점 미연결) | Program.cs:16 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f85f795a | (진입점 미연결) | Program.cs:17 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86cf214b | (진입점 미연결) | Program.cs:18 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c06db6c | (진입점 미연결) | Program.cs:18 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |
| AC-d6efc530 | (진입점 미연결) | Program.cs:17 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-72bc8407 | (진입점 미연결) | Program.cs:18 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51185853 | (진입점 미연결) | Program.cs:19 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68ec3f52 | (진입점 미연결) | Program.cs:19 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |
| AC-5150a92f | (진입점 미연결) | Program.cs:24 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-16471349 | (진입점 미연결) | Program.cs:25 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc7601b1 | (진입점 미연결) | Program.cs:42 |  | CALL_EXT | start.Run | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9a90a2f | (진입점 미연결) | Program.cs:19 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-37c99170 | (진입점 미연결) | Program.cs:20 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c6e10be | (진입점 미연결) | Program.cs:22 |  | CALL_EXT | BonusSkins.Register | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed0b963c | (진입점 미연결) | Program.cs:23 |  | CALL_EXT | SkinManager.EnableFormSkins | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-376c6dc4 | (진입점 미연결) | Program.cs:24 |  | CALL_EXT | UserLookAndFeel.Default.SetSkinStyle | ("DevExpress Style") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ab12d9 | (진입점 미연결) | Program.cs:26 |  | UI_PROP | TheOne.Windows.Forms.FoxExceptionHandler.Factory | new TheOne.Windows.Forms.FoxExceptionDialogFactory() | 속성 Factory 설정 |  |  |  |
| AC-824fa484 | (진입점 미연결) | Program.cs:26 |  | POPUP | new TheOne.Windows.Forms.FoxExceptionDialogFactory | () | 팝업/폼 생성 |  |  |  |
| AC-f0402ce2 | (진입점 미연결) | Program.cs:27 |  | CALL_EXT | TheOne.Windows.Forms.FoxExceptionHandler.Register | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fd3a9a3 | (진입점 미연결) | Program.cs:29 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad118da7 | (진입점 미연결) | Program.cs:29 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |
| AC-10ba7b86 | (진입점 미연결) | Program.cs:17 |  | CALL_EXT | Application.EnableVisualStyles | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-58a6ef75 | (진입점 미연결) | Program.cs:18 |  | CALL_EXT | Application.SetCompatibleTextRenderingDefault | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a5aa2a1 | (진입점 미연결) | Program.cs:19 |  | CALL_EXT | Application.Run | (new Form1()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dbade94 | (진입점 미연결) | Program.cs:19 |  | POPUP | new Form1 | () | 팝업/폼 생성 |  |  |  |

## Program.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d806d137 | (진입점 미연결) | Program.cs:347 |  | UI_PROP | scmCom.Connection | scmCon | 속성 Connection 설정 |  |  |  |
| AC-3acbaf28 | (진입점 미연결) | Program.cs:351 | try | CALL_EXT | scmCon.Open | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-02d9a381 | (진입점 미연결) | Program.cs:353 | try | UI_PROP | scmCom.CommandType | CommandType.StoredProcedure | 속성 CommandType 설정 |  |  |  |
| AC-8b6a922d | (진입점 미연결) | Program.cs:388 | try | DATA_OP | scmCom.Parameters.AddRange | (@param) | 데이터 객체 조작/조회 |  |  |  |
| AC-3462b8a0 | (진입점 미연결) | Program.cs:389 | try | ENDPOINT | scmCom.ExecuteNonQuery | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-093a9f55 | (진입점 미연결) | Program.cs:390 | try | UI_MISC | scmCon.Close | () | 창 닫기/해제 |  |  |  |
| AC-be89bd27 | (진입점 미연결) | Program.cs:400 | finally ▸ if (scmCon != null) | UI_MISC | scmCon.Dispose | () | 창 닫기/해제 |  |  |  |

## Program.XIF_ERP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db00e6fd | (진입점 미연결) | Program.cs:547 | try | CALL_EXT | sw.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cd78ce8 | (진입점 미연결) | Program.cs:562 | try | CALL_EXT | rfcRep.CreateFunction | (RFC_FNC_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d3471b6 | (진입점 미연결) | Program.cs:563 | try | CALL_EXT | function.GetTable | (RFC_TABLE_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fe54ad3 | (진입점 미연결) | Program.cs:577 | try ▸ for (i < IN_PARM_NAMES.Length) | GRID_SET | function.SetValue | (strName, strVal) | 그리드 값 설정 |  |  |  |
| AC-1daed7ab | (진입점 미연결) | Program.cs:580 | try | EXTERNAL_IF | function.Invoke | (rfcDest) | 외부 시스템 인터페이스 호출(SAP RFC 등) |  |  |  |
| AC-d36f1d74 | (진입점 미연결) | Program.cs:581 | try | FLAG | rfcDest | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0f30ea50 | (진입점 미연결) | Program.cs:599 | try ▸ else of (returnCode.Equals("F")) | CALL_EXT | SqlBuilderUitl.makeQuery | (lstSQL, iTable, COLS, SAP_COLS, ifseqno, program_name) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57e4c442 | (진입점 미연결) | Program.cs:604 | try ▸ else of (returnCode.Equals("F")) | CALL_EXT | sw.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a357eb5 | (진입점 미연결) | Program.cs:620 | finally ▸ if (xifCon != null) | UI_MISC | xifCon.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-ae0e2872 | (진입점 미연결) | Program.cs:621 | finally ▸ if (xifCon != null) | FLAG | xifCon | null | 화면 필드/플래그 변경 |  |  |  |

## Program.XIF_ERP_BEGIN_END_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccbdf836 | (진입점 미연결) | Program.cs:3552 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DAY_FROM", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-920bb473 | (진입점 미연결) | Program.cs:3553 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DAY_TO", args[2])) | 데이터 객체 조작/조회 |  |  |  |
| AC-975b561c | (진입점 미연결) | Program.cs:3554 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_WERKS", args[3])) | 데이터 객체 조작/조회 |  |  |  |
| AC-67147fdf | (진입점 미연결) | Program.cs:3555 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_LGORT", args[4])) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d8b5b34 | (진입점 미연결) | Program.cs:3556 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_MATNR", args[5])) | 데이터 객체 조작/조회 |  |  |  |
| AC-212043d0 | (진입점 미연결) | Program.cs:3557 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_FLAG", args[6])) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a4265cc | (진입점 미연결) | Program.cs:3560 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_GSCM", args[7])) | 데이터 객체 조작/조회 |  |  |  |
| AC-db96c8e9 | (진입점 미연결) | Program.cs:3565 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-17ca3d0a | (진입점 미연결) | Program.cs:3566 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ce63124e | (진입점 미연결) | Program.cs:3569 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-ccac343d | (진입점 미연결) | Program.cs:3585 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_CUSTOMER_CONSIGN_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b39aec0 | (진입점 미연결) | Program.cs:2544 |  | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1fdb977 | (진입점 미연결) | Program.cs:2545 |  | DATA_OP | rfcParams.Add | (new RFCParam("I_NEW", "X")) | 데이터 객체 조작/조회 |  |  |  |
| AC-27e908ed | (진입점 미연결) | Program.cs:2549 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7e38abf | (진입점 미연결) | Program.cs:2550 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4c98fdbf | (진입점 미연결) | Program.cs:2553 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-d1c2b150 | (진입점 미연결) | Program.cs:2569 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_CUSTOMER_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-188b0689 | (진입점 미연결) | Program.cs:1020 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d3bcd95 | (진입점 미연결) | Program.cs:1024 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99a0ca83 | (진입점 미연결) | Program.cs:1029 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a88cecd4 | (진입점 미연결) | Program.cs:1030 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cb872420 | (진입점 미연결) | Program.cs:1033 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb1631c | (진입점 미연결) | Program.cs:1049 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_DELIVERY_TRACKING_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aca493d | (진입점 미연결) | Program.cs:1552 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-d31cf5bb | (진입점 미연결) | Program.cs:1556 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e89a4881 | (진입점 미연결) | Program.cs:1561 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e9a55be | (진입점 미연결) | Program.cs:1562 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09f2b9a6 | (진입점 미연결) | Program.cs:1565 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-e3ee8f52 | (진입점 미연결) | Program.cs:1581 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_EXCRATE_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-559e2240 | (진입점 미연결) | Program.cs:4103 | if (args.Count() > 1) | CALL_EXT | DateTime.DaysInMonth | (d.Year, d.Month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9383cc2c | (진입점 미연결) | Program.cs:4116 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUKRS", "B100")) | 데이터 객체 조작/조회 |  |  |  |
| AC-19db0618 | (진입점 미연결) | Program.cs:4117 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", i_date)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43a2d92f | (진입점 미연결) | Program.cs:4118 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_TYPE", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a32bdbbe | (진입점 미연결) | Program.cs:4123 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7731c6b | (진입점 미연결) | Program.cs:4124 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cca93d80 | (진입점 미연결) | Program.cs:4127 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-d58ef5f6 | (진입점 미연결) | Program.cs:4143 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_FI_MDF_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd87b509 | (진입점 미연결) | Program.cs:3143 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUKRS", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dc55a83 | (진입점 미연결) | Program.cs:3144 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUDAT_FR", DateTime.Now.AddMonths(-1).ToString("yyyyMM") + "01")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf55c650 | (진입점 미연결) | Program.cs:3145 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUDAT_TO", DateTime.Now.ToString("yyyyMMdd"))) | 데이터 객체 조작/조회 |  |  |  |
| AC-87371e6c | (진입점 미연결) | Program.cs:3146 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_HKONT", args[2])) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc3bb3fe | (진입점 미연결) | Program.cs:3147 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_GSBER", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb2da7c9 | (진입점 미연결) | Program.cs:3152 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9fbefa6 | (진입점 미연결) | Program.cs:3153 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aae056f5 | (진입점 미연결) | Program.cs:3156 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-df5d8ccf | (진입점 미연결) | Program.cs:3172 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_INTRANSIT_CO_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbbfbd88 | (진입점 미연결) | Program.cs:2909 | foreach (string type in typeArr) ▸ switch (type) case "A": ▸ if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-4989418d | (진입점 미연결) | Program.cs:2910 | foreach (string type in typeArr) ▸ switch (type) case "A": ▸ if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_GUBUN", type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-27a03766 | (진입점 미연결) | Program.cs:2915 | foreach (string type in typeArr) ▸ switch (type) case "A": ▸ if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e01167ca | (진입점 미연결) | Program.cs:2916 | foreach (string type in typeArr) ▸ switch (type) case "A": ▸ if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-eee8dced | (진입점 미연결) | Program.cs:2919 | foreach (string type in typeArr) ▸ switch (type) case "A": | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-2f288c7c | (진입점 미연결) | Program.cs:2941 | foreach (string type in typeArr) ▸ switch (type) case "B": ▸ if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-84dfe6c0 | (진입점 미연결) | Program.cs:2942 | foreach (string type in typeArr) ▸ switch (type) case "B": ▸ if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_GUBUN", type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34805c2f | (진입점 미연결) | Program.cs:2947 | foreach (string type in typeArr) ▸ switch (type) case "B": ▸ if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-edd7f90b | (진입점 미연결) | Program.cs:2948 | foreach (string type in typeArr) ▸ switch (type) case "B": ▸ if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-445f6662 | (진입점 미연결) | Program.cs:2951 | foreach (string type in typeArr) ▸ switch (type) case "B": | CALL_EXT | rfc.TryGetValue | (RfcConfigParameters.Name, out SAPRfcName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f74911e8 | (진입점 미연결) | Program.cs:2969 | foreach (string type in typeArr) ▸ switch (type) case "B": ▸ if (rfc.TryGetValue(RfcConfigParameters.Name, out SAPRfcName)) | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-2cf77b6f | (진입점 미연결) | Program.cs:2988 | foreach (string type in typeArr) | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_INTRANSIT_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d5b6e34 | (진입점 미연결) | Program.cs:1251 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-024462b7 | (진입점 미연결) | Program.cs:1255 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0da09ed | (진입점 미연결) | Program.cs:1260 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a55e38d5 | (진입점 미연결) | Program.cs:1261 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7646d5a5 | (진입점 미연결) | Program.cs:1264 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-85d5b311 | (진입점 미연결) | Program.cs:1280 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_LONG_TERM_STOCK_OV_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940fc17c | (진입점 미연결) | Program.cs:3792 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("SIGN", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-14559c12 | (진입점 미연결) | Program.cs:3793 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("OPTION", "EQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6f31172 | (진입점 미연결) | Program.cs:3794 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("LOW", interfaceMonth)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea7602d1 | (진입점 미연결) | Program.cs:3795 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("HIGH", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e664dd05 | (진입점 미연결) | Program.cs:3800 | if (rfcTableParamMapper != null) | STATE_RESET | rfcTableParamMapper.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-630820cf | (진입점 미연결) | Program.cs:3801 | if (rfcTableParamMapper != null) | FLAG | rfcTableParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fb460085 | (진입점 미연결) | Program.cs:3804 |  | FLAG | rfcTableParamMapper | new RFCTableParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, //… | 화면 필드/플래그 변경 |  |  |  |
| AC-9c127239 | (진입점 미연결) | Program.cs:3820 |  | ENDPOINT | rfcTableParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_LONG_TERM_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15dd5ac8 | (진입점 미연결) | Program.cs:3611 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("SIGN", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-07ba8921 | (진입점 미연결) | Program.cs:3612 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("OPTION", "EQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1eed8467 | (진입점 미연결) | Program.cs:3613 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("LOW", interfaceMonth)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffe585c2 | (진입점 미연결) | Program.cs:3614 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("HIGH", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-153aea84 | (진입점 미연결) | Program.cs:3619 | if (rfcTableParamMapper != null) | STATE_RESET | rfcTableParamMapper.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1ca0c7fc | (진입점 미연결) | Program.cs:3620 | if (rfcTableParamMapper != null) | FLAG | rfcTableParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4d50dfb3 | (진입점 미연결) | Program.cs:3623 |  | FLAG | rfcTableParamMapper | new RFCTableParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, //… | 화면 필드/플래그 변경 |  |  |  |
| AC-f18791b9 | (진입점 미연결) | Program.cs:3639 |  | ENDPOINT | rfcTableParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MAT_IMPORT_BL_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10607549 | (진입점 미연결) | Program.cs:2662 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-7297ab65 | (진입점 미연결) | Program.cs:2667 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cbdf60e | (진입점 미연결) | Program.cs:2668 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3a03b957 | (진입점 미연결) | Program.cs:2671 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-68b76837 | (진입점 미연결) | Program.cs:2687 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MAT_INBOUND_DO_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4451e36f | (진입점 미연결) | Program.cs:2421 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-a024723b | (진입점 미연결) | Program.cs:2426 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa0bad8f | (진입점 미연결) | Program.cs:2427 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dabe30dc | (진입점 미연결) | Program.cs:2430 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-e5f9666d | (진입점 미연결) | Program.cs:2446 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MAT_PO_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a46ac24 | (진입점 미연결) | Program.cs:2186 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-c829e75b | (진입점 미연결) | Program.cs:2190 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08165ae8 | (진입점 미연결) | Program.cs:2195 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1667af25 | (진입점 미연결) | Program.cs:2196 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1930d338 | (진입점 미연결) | Program.cs:2199 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-fc089d46 | (진입점 미연결) | Program.cs:2215 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MAT_PO_RECEIPT_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b30dda9 | (진입점 미연결) | Program.cs:2304 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-96f72507 | (진입점 미연결) | Program.cs:2309 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c15196a9 | (진입점 미연결) | Program.cs:2310 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a80f4743 | (진입점 미연결) | Program.cs:2313 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-b7c296dc | (진입점 미연결) | Program.cs:2329 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MATERIAL_DOCUMENT_DM_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dde3d7a | (진입점 미연결) | Program.cs:3292 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-2055dfbc | (진입점 미연결) | Program.cs:3298 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-216c077a | (진입점 미연결) | Program.cs:3299 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f195930f | (진입점 미연결) | Program.cs:3302 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-5a02034a | (진입점 미연결) | Program.cs:3318 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_MATERIAL_DOCUMENT_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e20bcb20 | (진입점 미연결) | Program.cs:1804 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-902da187 | (진입점 미연결) | Program.cs:1808 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fd2c6de | (진입점 미연결) | Program.cs:1813 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-904f9df2 | (진입점 미연결) | Program.cs:1814 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7cdec50a | (진입점 미연결) | Program.cs:1817 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-f925bfaf | (진입점 미연결) | Program.cs:1833 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_SALES_RESULT_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d805570 | (진입점 미연결) | Program.cs:2054 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-96a71834 | (진입점 미연결) | Program.cs:2058 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b7bc8a6 | (진입점 미연결) | Program.cs:2063 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a6440f5 | (진입점 미연결) | Program.cs:2064 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fcd3c079 | (진입점 미연결) | Program.cs:2067 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-08a7376d | (진입점 미연결) | Program.cs:2083 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_SALES_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90c7d4d1 | (진입점 미연결) | Program.cs:2779 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e69ee4d | (진입점 미연결) | Program.cs:2784 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae7d0398 | (진입점 미연결) | Program.cs:2785 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7a66e476 | (진입점 미연결) | Program.cs:2788 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-a2db689f | (진입점 미연결) | Program.cs:2804 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_SLOC_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa50681 | (진입점 미연결) | Program.cs:638 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_WERKS", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7a53b2d | (진입점 미연결) | Program.cs:642 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_WERKS", string.Empty)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b4da115 | (진입점 미연결) | Program.cs:647 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-304cdc6c | (진입점 미연결) | Program.cs:648 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0930c1af | (진입점 미연결) | Program.cs:651 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-fde649d2 | (진입점 미연결) | Program.cs:667 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_VENDOR_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d06bd37 | (진입점 미연결) | Program.cs:817 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e1883f3 | (진입점 미연결) | Program.cs:821 | else of (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_DATE", yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2dae8d8 | (진입점 미연결) | Program.cs:826 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c771477 | (진입점 미연결) | Program.cs:827 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f83c00ca | (진입점 미연결) | Program.cs:830 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-9d5be603 | (진입점 미연결) | Program.cs:846 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_ERP_ZMM_GSCM_END_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b43952ba | (진입점 미연결) | Program.cs:4257 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUKRS", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1d4f7d8 | (진입점 미연결) | Program.cs:4258 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_WERKS", args[2])) | 데이터 객체 조작/조회 |  |  |  |
| AC-a980d81a | (진입점 미연결) | Program.cs:4259 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_SPMON", args[3])) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0caeb5c | (진입점 미연결) | Program.cs:4264 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-13a05acd | (진입점 미연결) | Program.cs:4265 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-61d39cf2 | (진입점 미연결) | Program.cs:4268 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-bf96eaef | (진입점 미연결) | Program.cs:4284 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_TEMP_ZMMB_GET_MONTH_END_STOCK_R

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af8db111 | (진입점 미연결) | Program.cs:3956 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_BUKRS", args[1])) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccfd8a1f | (진입점 미연결) | Program.cs:3957 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_SPMON", args[2])) | 데이터 객체 조작/조회 |  |  |  |
| AC-1724ff71 | (진입점 미연결) | Program.cs:3958 | if (args.Count() > 1) | DATA_OP | rfcParams.Add | (new RFCParam("I_GUBUN", args[3])) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1f0edb1 | (진입점 미연결) | Program.cs:3963 | if (rfcEachParamMapper != null) | CALL_EXT | rfcEachParamMapper.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7f4fa81 | (진입점 미연결) | Program.cs:3964 | if (rfcEachParamMapper != null) | FLAG | rfcEachParamMapper | null | 화면 필드/플래그 변경 |  |  |  |
| AC-80002f70 | (진입점 미연결) | Program.cs:3967 |  | FLAG | rfcEachParamMapper | new RFCEachParamMapper(rfc, // rfc rfcDest, // rfcDest rfcRep, // rfcRep program_name, // … | 화면 필드/플래그 변경 |  |  |  |
| AC-95ae2f9c | (진입점 미연결) | Program.cs:3983 |  | ENDPOINT | rfcEachParamMapper.Execute | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## Program.XIF_TEST

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3376eda5 | (진입점 미연결) | Program.cs:4412 | try | CALL_EXT | sw.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8db4b70 | (진입점 미연결) | Program.cs:4414 | try | CALL_EXT | rfcRep.CreateFunction | (args[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf439aba | (진입점 미연결) | Program.cs:4415 | try | CALL_EXT | function.GetTable | ("G_ITAB_T") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d802c8a3 | (진입점 미연결) | Program.cs:4422 | try | GRID_SET | function.SetValue | ("I_DATE", interfaceDate) | 그리드 값 설정 |  |  |  |
| AC-ee5020ad | (진입점 미연결) | Program.cs:4423 | try | EXTERNAL_IF | function.Invoke | (rfcDest) | 외부 시스템 인터페이스 호출(SAP RFC 등) |  |  |  |
| AC-f3be32ca | (진입점 미연결) | Program.cs:4424 | try | FLAG | rfcDest | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e30da79f | (진입점 미연결) | Program.cs:4442 | finally ▸ if (xifCon != null) | UI_MISC | xifCon.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-139855af | (진입점 미연결) | Program.cs:4443 | finally ▸ if (xifCon != null) | FLAG | xifCon | null | 화면 필드/플래그 변경 |  |  |  |

