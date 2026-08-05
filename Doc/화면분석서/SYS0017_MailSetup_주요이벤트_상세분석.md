# SYS0017 Mail Setup — 주요이벤트 상세분석 (AS-IS SCM0006 실측)

> 원천: `GSCM\06.UIL\GSCM.SCM.Master.UIL\SCM0006_Mail_Setup.cs` (1,650줄, 2026-07-29 전문 실측) + `.Designer.cs`(771줄) + `POPUP\SCM0006_PopSQL.cs`(293줄) + `POPUP\SCM0006_PopContent.cs`(241줄)
> SP 원문: `Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP6_DDL.sql` L29220~30242 (9 SP 전문 실측)
> 캡쳐: `Doc\_figma\CAP_SVG\SYS0017_01.png`(Message Setup 탭) / `SYS0017_02.png`(Receiver Setup 탭)
> 작성 규칙: hook #105 0단계 선행 산출물 — 이벤트 단계 단위 + AS-IS 라인번호 병기

## 0. 화면 개관

- 목적: 배치 메일 발송의 **설정 전용** 화면 — 발송 카테고리(주기/시간), 언어별 메일 제목·본문, 수신자 배정을 관리. 실제 SMTP 발송 로직은 화면에 없음(별도 배치가 이 설정을 읽음).
- 고정 상수: `UseTypeCode = "MAIL"` (L35) — 모든 조회/저장에 하드코딩 전달. SMS 화면(SCM0007)이 동일 테이블·SP를 `"SMS"` 로 사용.
- 구조: 상단 조회조건(Module/Sub Module/Active) + Category 그리드(마스터) // 하단 탭 2개 — [Message Setup]=Message 그리드, [Receiver Setup]=좌 검색(Department/User ID(Name))+All_Receiver 그리드, 중앙 ▶(btnRAdd)/◀(btnRDel), 우 Sel_Receiver 그리드. (Designer splitContainer1 수평 293px / splitContainer2 수직 522:464)
- 그리드 4개 컬럼 구성 (InitSpread L209~287):
  - **Category** (헤더 2행): USE_TYPE_CODE(숨김성 콤보) · Module*(콤보) · Sub Module*(콤보) · Category(=CATEGORY_ID, 표시용) · Category*(=CATEGORY_DESC, 편집) · Active(Y/N 콤보) · Period 그룹헤더[Main*(주기 콤보)/Sub1(상세 콤보)/Sub2(시각 콤보)/Sub3(분 콤보)] · SQL VIEW(버튼 컬럼)
  - **Message**: USE_TYPE_CODE·Category(ID)·Category(DESC, 세로머지)·Language*(콤보)·Mail Title*·Mail Content*(멀티라인, AutoRowHeight)
  - **All_Receiver**: UserID·Name·Department·Email·TEL·Language(콤보)
  - **Sel_Receiver**: USE_TYPE_CODE·Category(ID, 세로머지)·Category(DESC, 세로머지)·UserID·Name·Department·Email·TEL·Language
- 콤보 원천 (L38~46): Module/SubModule=LOOKUP `SMS_MAIL_SEND_SYSTEM`, Active=YesOrNo, Main=`MAIL_SEND_CYCLE`, Sub1/Sub2/Sub3=`MAIL_SEND_CYCLE_DETAIL`, Language=LOOKUP `LANGUAGE`. (사내 Oracle 실측 2026-07-29: 4계열 전부 존재 — LANGUAGE 3 / MAIL_SEND_CYCLE 8 / MAIL_SEND_CYCLE_DETAIL 132 / SMS_MAIL_SEND_SYSTEM 15행)

## 1. 조회 (Find — 툴바 버튼, 포커스 시트 분기)

### E01. FindButton (L293~300)
포커스 그리드가 All_Receiver 이면 사용자 조회(E03), 그 외에는 마스터 조회(E02)로 분기한다.

### E02. FindData_Main (L353~394) — Category 마스터 조회
1. Category 그리드 초기화 후 조회조건 3개(Module/Sub Module/Active — 'ALL' 선택 시 빈 값 변환 L358~360)를 `SCM0006_GET_RECIPIENT_MASTER`(p_use_type='MAIL', p_module, p_submodule, p_active)로 전달.
2. SP는 `SCM_ADM_RECIPIENT_LIST`에서 조회하며, 세 파라미터 모두 **콤마 CSV 멀티값**을 XML split으로 IN 처리(NULL이면 전체) — SP L29308~29325.
3. 결과 바인딩 후 **전 컬럼 잠금**(조회 모드, L381) + 조회건수 표시 + 줄무늬 행. Message/All_Receiver/Sel_Receiver 그리드는 모두 초기화(L391~393) — 마스터 재조회 시 하위 영역 클리어.

### E03. FindData_AllReceiver (L396~437) — 사용자 조회 (Receiver 탭)
1. Department 와 User ID(Name) 가 **둘 다 비어 있으면 MSG00083**("[Department,User ID]를 입력해 주세요" 계열) 후 중단 (L402~406).
2. `SCM0006_GET_USERINFO_LIST`(p_user, p_dept) 호출 — SP는 `SCM_MST_SSO_USER_INFO`(전 사용자)에 `TB_FX_USER`(언어/휴대폰)를 LEFT JOIN, 사용자ID/이름(KO·EN)/부서ID/부서명 **부분일치(LIKE)** 검색, Email 은 `USER_ID+'@lgensol.com'` 파생, 부서명은 사용자 언어(KO/EN/CN)별 컬럼 선택 — SP L29414~29482.
3. 결과 바인딩 + 전 컬럼 잠금 + 건수 표시.

## 2. 마스터-디테일 연동 (Category 행 선택)

### E04. Category CellDoubleClick — 조회 모드 (L941~1129 중 L1105~1129)
조회 모드에서 Category 행을 더블클릭하면 해당 행의 CATEGORY_ID/DESC 를 전역 보관(strCategory/strRCategory)하고, **ShowMessage + ShowReceiver 를 연속 호출**하여 두 탭의 디테일을 동시 갱신한다.
- ShowMessage (L1320~1351): `SCM0006_GET_RECIPIENT_MESSAGE`(p_use_type, p_categoryID) — `SCM_ADM_RECIPIENT_MESSAGE` + LIST + LOOKUP(LANGUAGE) 조인, 언어명(segment2) 포함 — SP L29348~29371.
- ShowReceiver (L1359~1390): `SCM0006_GET_RECIPIENT_ASSIGN`(p_use_type, p_categoryID) — `SCM_ADM_RECIPIENT_ASSIGN` + LIST + SSO_USER + TB_FX_USER + SSO_DEPT 조인, 부서명 언어별 선택 — SP L29220~29272.
- 두 조회 모두 결과 전 컬럼 잠금(조회 모드 시작).

### E05. SQL VIEW 셀버튼 → PopSQL 팝업 (CellClick L753~776 / CellDoubleClick L949~970 동일 로직)
- CATEGORY_ID 가 있는 행(=저장된 행, INSERTED 신규행 제외)의 SQL VIEW 컬럼 클릭 시 `SCM0006_PopSQL` 모달 오픈. 전달값 6종: UseTypeCode/ModuleCode/SubModuleCode/CategoryID/CategoryDESC/LastUpdateBy(현재 사용자).
- 팝업 로드(PopSQL L89~100, L239~290): `SCM0006_GET_SQL_LONG_TEXT` 호출 → `FN_GET_SOURCE_CODE` 함수로 `SCM_ADM_RECIPIENT_LIST.SQL_LONG_TEXT` 를 **TEXT1~TEXT8 8분할**(NVARCHAR 4000 한계 우회) 반환 → 연결 후 개행(\n→\r\n) 변환하여 표시.
- OK 클릭(L222~233, L144~187): 편집 SQL 을 \r\n→\n 역변환 후 `SCM0006_SAVE_RECIPIENT_MASTER_U`(7 파라미터, p_sql 포함) — `SCM_ADM_RECIPIENT_LIST.SQL_LONG_TEXT` UPDATE(4키: USE_TYPE/MODULE/SUB_MODULE/CATEGORY_ID). 성공 'S'→MSG00004, 실패→MSG00006. Cancel→변경 없음.
- 이 SQL은 배치가 수신자를 동적 추출할 때 실행하는 쿼리 원문이다(관리자 전용 기능).

## 3. 편집 모드 (Edit 툴바 버튼) — 시트별 잠금 해제 + 부분 잠금 (E06, L322~342)

- Category: 잠금 해제 후 **MODULE_CODE~SUB_MODULE_CODE 재잠금** — 기존 행의 모듈 키는 편집 금지(신규 행에서만 선택 가능).
- Message: **CATEGORY_ID~LANGUAGE_CODE 재잠금** — 키 컬럼 보호(단, Language 는 신규 'I' 행에서만 CellClick 허용 — E10).
- Sel_Receiver: **CATEGORY_ID~LANGUAGE_CODE 재잠금**.

## 4. Category 그리드 편집 이벤트

### E07. 신규 행 (Insert 툴바 → InsertRow L723~747)
- Category 시트: 새 행 + 기본값 ACTIVE_FLAG='Y' + **SQL VIEW 컬럼 잠금**(신규 행은 저장 전 SQL 편집 불가).
- Message 시트: 새 행 + USE_TYPE_CODE='MAIL'/CATEGORY_ID/CATEGORY_DESC 를 선택된 마스터 값으로 자동 세팅 + **CATEGORY_DESC 잠금**. (마스터 미선택 시 빈 값이 들어감 — 저장 시 SP가 채번하지 않는 시트이므로 실질적으로 마스터 선택 후 사용하는 화면 관행)

### E08. Period cascade — CellClick/CellDoubleClick 내 콤보 필터 (L792~907, 동일 로직 2벌)
편집 모드에서 셀 클릭 시 해당 셀 콤보를 상위 값 기준으로 필터링해 로드한다:
1. **Sub Module 셀**: Module 미선택 → MSG00111("모듈을 먼저 선택해 주세요") + 편집 취소. 선택돼 있으면 SubModule 콤보를 `SYSTEM_CODE=선택Module` 로 필터 로드.
2. **Sub1(DETAIL_CLASS) 셀**: Main(주기) 미선택 → MSG00112("주기를 먼저 선택해 주세요") + 취소. 선택 시 Sub1 콤보를 `CYCLE_CODE=Main` 으로 필터 로드.
3. **Sub2(SEND_TIME) 셀**: Main='RT'(실시간)이면 편집 자체 차단. Sub1 미선택 → MSG00112. Sub1 값이 M*/W*(월·주 상세)로 시작하면 Sub2 콤보=`CYCLE_CODE='DAY'`(일자 목록), 그 외(DAY 주기의 상세)는 `CYCLE_CODE='HOUR'`(시각 목록) 필터.
4. **Sub3(SEND_MIN_TIME) 셀**: Main='DAY' 또는 'RT' 이면 편집 차단(분 단위는 MONTH/WEEK 주기에서만).
5. **기존 행(빈 action/M/D)의 Module·Sub Module 셀**: 값이 이미 있으면 편집 취소(E06 잠금과 이중 방어).

### E09. Period cascade reset — ComboSelChange (L913~939)
- Main(주기) 변경 → Sub1/Sub2/Sub3 값·표시 모두 클리어.
- Sub1 변경 → Sub2/Sub3 클리어. Sub2 변경 → Sub3 클리어. (하위 단계 값 일관성 보장 — TO-BE 그리드 셀 cascade 표준 hook #59 §5-G 대응)

### E04-2. CellDoubleClick 편집 차단 (L941~947)
CATEGORY_DESC(텍스트 편집 컬럼) 외의 셀은 더블클릭 편집 진입을 차단한다(콤보/버튼 컬럼 보호).

## 5. Message 그리드 편집 이벤트

### E10. Message CellClick (L1136~1157)
편집 모드에서 CATEGORY_DESC 셀은 항상 편집 취소, LANGUAGE_CODE 셀은 **action='I'(신규 행)일 때만** 편집 허용(기존 행의 언어 키 변경 금지).

### E11. Message CellDoubleClick → PopContent 팝업 (L1159~1194)
- MAIL_TITLE/MESSAGE_CONTENT 외 셀은 더블클릭 차단.
- **편집 모드 + MESSAGE_CONTENT** 더블클릭: `SCM0006_PopContent` 모달(제목 "Mail Content 입력")에 현재 셀 텍스트 전달 → OK 시 팝업 내용을 셀에 반영 + 임시본(sContentTemp) 갱신.
- **조회 모드 + MESSAGE_CONTENT**(내용이 있을 때만): 동일 팝업을 읽기 전용(SaveDiasable=false → Save 버튼 숨김+입력 비활성, 글꼴 변경)으로 표시.
- PopContent 자체(PopContent L93~138): MAIL 이면 MaxLength 3700, TextChanged 마다 바이트 수 검사 — **3,700바이트 이상이면 MSG00165("입력할 수 있는 자리수를 초과하였습니다") + 직전 내용으로 원복**. DB 호출 없음(값 전달 전용). (내부 ChkContent 의 MSG00005 는 호출되지 않는 사문 코드 — 정직 기재)

### E12. Message EditChange (L1196~1218)
그리드에서 직접 MESSAGE_CONTENT 를 타이핑하는 경우에도 **4,000바이트 이상이면 MSG00165 + 원복**(팝업 경유와 이중 방어, 한계값은 4000으로 상이함 — AS-IS 원문 그대로 기재).

## 6. Receiver 탭 이벤트

### E13. Department/User 텍스트박스 Click·TextChanged → Tx_Click (L1641~1646)
포커스 그리드를 All_Receiver 로 전환한다 — 이후 Find 버튼이 사용자 조회(E03)로 분기되게 하는 장치.

### E14. 수신자 추가 — btnRAdd Click / All_Receiver CellDoubleClick (L1508~1526, SetSelData L1551~1634)
1. All_Receiver 에 데이터가 있고 행이 선택되어 있고 **마스터 Category 가 선택된 상태**여야 동작.
2. Sel_Receiver 가 잠금 상태면 잠금 해제 후 키 컬럼(USE_TYPE~LANGUAGE) 재잠금(편집 모드 자동 진입).
3. 선택 영역의 각 사용자에 대해: Sel_Receiver 기존 데이터에 (USE_TYPE='MAIL', CATEGORY_ID, USER_ID) **중복이면 MSG00060("동일한 UserID 가 존재합니다") 후 전체 중단**. 중복이 아니면 Sel_Receiver 에 신규 행 삽입(Category/사용자 정보 7컬럼 복사) + 행 잠금(USE_TYPE~LANGUAGE).
4. 이동된 행은 All_Receiver 에서 제거하되 백업 DataTable(dtAllReceiver)에 보관.

### E15. 수신자 제거 — btnRDel Click (L1528~1549)
Sel_Receiver 선택 행 삭제(action 'D' 마킹) + 직전 Add 에서 백업된 행들을 All_Receiver 로 복원.

## 7. 저장 (Save 툴바 → SaveData L439~721) — 편집 모드(잠금 해제)인 시트만 순차 저장

**공통 페이로드 방식**: 변경 행(action I/M/D)만 골라 각 컬럼 값을 **'^' 구분자 문자열로 연결**해 SP 1회 호출(bulk). SP는 `SCM_ARR_SPL_CNT/VAL` 함수로 재분해 후 행 단위 루프. 감사값: created_by/last_updated_by=현재 사용자, creation_date=yyyyMMdd 문자열.

### E16. Category 저장 → `SCM0006_SAVE_RECIPIENT_MASTER` (14 파라미터, SP L29688~29947)
1. 선행 검증: 그리드 필수컬럼 검사(checkRequiredOfSpread) → **ChkCategoryValidation** (L1398~1505):
   - Main(주기) 미입력 → MSG00124. Main=MONTH/WEEK 인데 Sub1 또는 Sub2 미입력 → MSG00122. Main=DAY/RT 인데 Sub1 미입력 → MSG00123.
   - CATEGORY_ID 중복(삭제 행 제외 전 행 대비) → MSG00060. (2023-03 개정: DESC 가 아닌 **ID 기준** 중복 체크 — 헤더 주석 L24)
2. 삭제 행 포함 시 → **MSG00121 확인**("삭제할 데이터가 포함되어 있습니다. 해당 카테고리에 등록된 메세지와 수신자 정보도 함께 삭제됩니다. 계속하시겠습니까?") No 면 중단.
3. SP 동작: 행별로 ①이력 SP `PR_SCM_ADM_RECIPIENT_LIST_HIST` 호출(변경 전 이력 적재) ②CATEGORY_ID 가 비면 **시퀀스 `SEQ1_SCM_ADM_RECIPIENT_LIST` 채번** ③I/M → LIST MERGE(키: USE_TYPE+CATEGORY_ID+MODULE+SUB_MODULE) ④D → LIST 삭제 + **MESSAGE 동반 삭제 + (MAIL이면 ASSIGN / SMS면 SMS_ASSIGN) 동반 삭제** — 화면 확인 메시지(MSG00121)와 정확히 대응. 시작/종료/오류를 `PR_SCM_SYS_LOG_BATCH` 로 `SCM_SYS_LOG_BATCH` 에 기록. 반환: 'S'+건수 또는 'F'+오류.
4. 성공('S') → MSG00004("{n}개의 데이터가 저장되었습니다") + 마스터 재조회. 실패 → MSG00006.

### E17. Message 저장 → `SCM0006_SAVE_RECIPIENT_MESSAGE` (9 파라미터, SP L30049~30241)
1. 선행 검증: 필수컬럼 + **ChkMsgValidation** (L1227~1312): Language 미입력 → MSG00002("[Language] 은 필수 입력사항입니다"), (CATEGORY_ID+LANGUAGE) 중복 → MSG00060.
2. SP: 행별 이력 SP `PR_SCM_ADM_RECIPIENT_MESSAGE_HIST` → I/M MERGE(키: USE_TYPE+CATEGORY_ID+LANGUAGE_CODE, TITLE/CONTENT 갱신) / D 삭제. 로그·반환 공통.
3. 성공 → MSG00004 + **해당 Category 의 Message 재조회**(ShowMessage). 실패 → MSG00006.

### E18. Sel_Receiver 저장 → `SCM0006_SAVE_RECIPIENT_ASSIGN` (7 파라미터, SP L29494~29674)
1. 별도 화면 검증 없음(추가 시점에 중복 차단 완료).
2. SP: 행별 이력 SP `PR_SCM_ADM_RECIPIENT_ASSIGN_HIST` → I/M MERGE(키: USE_TYPE+CATEGORY_ID+USER_ID) / D 삭제. 로그·반환 공통.
3. 성공 → MSG00004 + 해당 Category 수신자 재조회(ShowReceiver). 실패 → MSG00006.

## 8. 삭제 (Delete 툴바 — E19, L307~320)
포커스 시트(Category/Message/Sel_Receiver)의 선택 행을 action 'D' 마킹(그리드 표준 Delete). All_Receiver 는 삭제 대상 아님. 실제 반영은 Save 시.

## 9. MSG 사용 전수 (호출 지점 25곳 / unique 13종 — 사문 MSG00005 포함)

| MSG ID | 상황 | 호출 지점(L) | 사내 등록(2026-07-29 실측) |
|---|---|---|---|
| MSG00002 | Language 필수 미입력 | 1257 | O (3언어) |
| MSG00004 | 저장 성공 {n}건 | 538, 628, 706, PopSQL173 | O |
| MSG00005 | (사문 — PopContent.ChkContent 미호출) | PopContent228 | O |
| MSG00006 | 저장 실패 | 547, 637, 715, PopSQL181 | **X — 등록 필요** |
| MSG00060 | 중복(카테고리ID/언어/수신자) | 1297, 1489, 1587 | O |
| MSG00083 | 검색 조건(부서·사용자) 미입력 | 404 | **X — 등록 필요** |
| MSG00111 | 모듈 먼저 선택 | 802, 996 | **X — 등록 필요** |
| MSG00112 | 주기 먼저 선택 | 827, 859, 1021, 1053 | **X — 등록 필요** |
| MSG00121 | 삭제 확인(연쇄 삭제 경고, Yes/No) | 503 | **X — 등록 필요** |
| MSG00122 | MONTH/WEEK 는 Sub1·Sub2 필수 | 1428 | **X — 등록 필요** |
| MSG00123 | DAY/RT 는 Sub1 필수 | 1440 | **X — 등록 필요** |
| MSG00124 | Main(주기) 필수 | 1449 | **X — 등록 필요** |
| MSG00165 | 입력 자리수 초과(3700/4000바이트) | 1209, PopContent118·130 | **X — 등록 필요** |

## 10. SP·DB 의존 전수 (사내 Oracle 실측 2026-07-29 병기)

| SP (AS-IS) | 파라미터 | 사내 상태 |
|---|---|---|
| SCM0006_GET_RECIPIENT_MASTER | use_type, module(CSV), submodule(CSV), active(CSV) | SCM_MGR standalone **VALID** + PKG_SCM0006.P_SCM0006_GET_RECIPIENT_MASTER |
| SCM0006_GET_RECIPIENT_MESSAGE | use_type, categoryID | standalone VALID |
| SCM0006_GET_RECIPIENT_ASSIGN | use_type, categoryID | standalone **INVALID**(ORA-03049 — 변환 결함) / PKG 멤버 VALID |
| SCM0006_GET_USERINFO_LIST | user, dept | standalone **INVALID**(ORA-00907) |
| SCM0006_GET_SQL_LONG_TEXT | use_type, module, submodule, category_id | VALID (FN_GET_SOURCE_CODE 8분할) |
| SCM0006_SAVE_RECIPIENT_MASTER | 14개('^' bulk) | VALID |
| SCM0006_SAVE_RECIPIENT_MESSAGE | 9개('^' bulk) | VALID |
| SCM0006_SAVE_RECIPIENT_ASSIGN | 7개('^' bulk) | VALID |
| SCM0006_SAVE_RECIPIENT_MASTER_U | 7개(p_sql) | VALID |

- 의존 함수/SP: `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`('^' 분해) · `FN_GET_SOURCE_CODE` · 이력 SP 3종(`PR_SCM_ADM_RECIPIENT_LIST/_MESSAGE/_ASSIGN_HIST`) · `PR_SCM_SYS_LOG_BATCH` — **사내 SCM_MGR 전부 VALID**.
- 시퀀스: `SEQ1_SCM_ADM_RECIPIENT_LIST`(CATEGORY_ID 채번) — 존재.
- 테이블: `SCM_ADM_RECIPIENT_LIST/_MESSAGE/_ASSIGN/_SMS_ASSIGN` + `_H` 3종 + `SCM_ADM_RECIPIENT_SMS_GROUP` + `SCM_ADM_LOOKUP_MASTER(_DETAIL)` + `SCM_MST_SSO_USER_INFO/_DEPT_INFO` + `TB_FX_USER` + `SCM_SYS_LOG_BATCH` — **사내 전부 존재, 데이터 이관 완료(LIST: MAIL 52행/SMS 34행)**.

## 11. TO-BE 전환 시 유의 (실측 기반)

1. 사내 DB 는 테이블·데이터·의존객체·SP 7/9 이 **이미 준비됨** — 잔여 = standalone 2종(GET_RECIPIENT_ASSIGN/GET_USERINFO_LIST) 변환 결함 정정 + UI별 PKG 취합(기존 PKG_SCM0006 은 GET 2멤버만).
2. '^' bulk 저장 SP 는 TO-BE generic call-proc 의 `createdByBulk` 감사키·bulk payload 표준(메모리 feedback_save_sp_bulk_payload_apiclient_post) 적용 대상.
3. 조회 SP 는 결과 커서(O_RC1)+결과코드 커서 이중 OUT 구조로 래핑 필요(TO-BE 표준 dual OUT).
4. MSG 9종 사내 미등록 — AS-IS 실문구 대사(hook #114) 후 3언어 등록 필요.
5. Mail Content 바이트 제한이 경로별로 상이(팝업 3,700 / 그리드 직접입력 4,000) — TO-BE 는 4,000바이트(DB 컬럼 한계) 단일 기준 권장, 격차로 기재.
6. AS-IS 조회조건 콤보는 Module 변경 시 Sub Module 콤보만 갱신(CboModule_SelectedIndexChanged L1636) — 자동 재조회 없음(Search 버튼 필요). TO-BE Division-변경 그리드 초기화 표준과 동일 방향.
