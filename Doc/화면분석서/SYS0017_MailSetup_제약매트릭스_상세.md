# SYS0017 Mail Setup — 제약매트릭스 상세 (AS-IS SCM0006 실측, 1건 1행 전수)

> 원천: `SCM0006_Mail_Setup.cs` 전문(1,650줄) + 팝업 2종 + SP 9종 원문 실측 (2026-07-29)
> 축 구성: 필수입력 / 중복 / cascade(콤보 종속) / 편집잠금(Lock) / 바이트 제한 / 삭제 연쇄 / 권한 / Division — 해당 없는 축은 정직하게 "없음" 표기 (hook #105)

## A. 필수입력 축 (5건)

| # | 대상 | 조건 | 위반 메시지 | 근거(L) |
|---|---|---|---|---|
| A1 | Category 시트 필수 컬럼(Module*/Sub Module*/Category*/Main* 등 헤더 * 표기) | 저장 전 checkRequiredOfSpread 공통 검사 | 공통 필수 메시지(프레임워크) | 464 |
| A2 | Period Main(주기) | 변경 행마다 필수 | MSG00124 | 1449 |
| A3 | Period Sub1+Sub2 | Main=MONTH/WEEK 인 행 | MSG00122 | 1428 |
| A4 | Period Sub1 | Main=DAY/RT 인 행 | MSG00123 | 1440 |
| A5 | Message.Language | 변경 행마다 필수 (Message 시트 필수 컬럼 공통검사 + 개별검사) | MSG00002 | 571, 1257 |
| A6 | Receiver 검색 조건 | Department·User ID 둘 다 공란이면 조회 불가 | MSG00083 | 402~406 |

## B. 중복 축 (3건)

| # | 대상 | 키 | 비교 범위 | 위반 메시지 | 근거(L) |
|---|---|---|---|---|---|
| B1 | Category | CATEGORY_ID (2023-03 개정: DESC→ID) | 삭제(D) 행 제외 전 행 | MSG00060 | 1454~1493 |
| B2 | Message | CATEGORY_ID + LANGUAGE | 삭제 행 제외 전 행 | MSG00060 | 1262~1300 |
| B3 | Sel_Receiver(추가 시) | USE_TYPE + CATEGORY_ID + USER_ID | Sel_Receiver 기존 데이터 | MSG00060 (전체 추가 중단) | 1577~1589 |

## C. Cascade(콤보 종속) 축 (7건)

| # | 트리거 | 종속 동작 | 근거(L) |
|---|---|---|---|
| C1 | 조회조건 Module 변경 | 조회조건 Sub Module 콤보를 해당 시스템으로 재바인딩 (재조회는 하지 않음 — Search 버튼) | 1636~1639 |
| C2 | 그리드 Sub Module 셀 진입 | Module 값으로 콤보 필터(SYSTEM_CODE=Module). Module 없으면 MSG00111+취소 | 793~814, 987~1008 |
| C3 | 그리드 Sub1 셀 진입 | Main 값으로 콤보 필터(CYCLE_CODE=Main). Main 없으면 MSG00112+취소 | 817~840, 1011~1034 |
| C4 | 그리드 Sub2 셀 진입 | Main=RT→편집 차단 / Sub1 이 M*·W* 시작→DAY(일자) 목록, 그 외→HOUR(시각) 목록. Sub1 없으면 MSG00112 | 842~879, 1036~1073 |
| C5 | 그리드 Sub3 셀 진입 | Main=DAY 또는 RT → 편집 차단 (분 단위는 MONTH/WEEK 만) | 882~891, 1076~1086 |
| C6 | Main 값 변경(ComboSelChange) | Sub1/Sub2/Sub3 값·표시 클리어 | 915~925 |
| C7 | Sub1 변경 → Sub2/Sub3 클리어 / Sub2 변경 → Sub3 클리어 | 하위 단계 리셋 | 926~938 |

## D. 편집잠금(Lock) 축 (10건)

| # | 시점 | 잠금 대상 | 근거(L) |
|---|---|---|---|
| D1 | 마스터 조회 직후 | Category 전 컬럼 (조회 모드) | 381 |
| D2 | 사용자 조회 직후 | All_Receiver 전 컬럼 (항상 조회 전용) | 428 |
| D3 | Message/Sel_Receiver 조회 직후 | 각 전 컬럼 | 1342, 1381 |
| D4 | Edit(Category) | MODULE_CODE~SUB_MODULE_CODE (기존 행 모듈 키 보호) | 329 |
| D5 | Edit(Message) | CATEGORY_ID~LANGUAGE_CODE | 334 |
| D6 | Edit(Sel_Receiver) | CATEGORY_ID~LANGUAGE_CODE | 339 |
| D7 | Category 신규 행 | SQL VIEW 버튼 컬럼 (저장 전 SQL 편집 불가) | 733 |
| D8 | Message 신규 행 | CATEGORY_DESC (마스터 승계값 보호) | 745 |
| D9 | 수신자 추가된 행 | USE_TYPE~LANGUAGE (사용자 정보 컬럼 보호 — 행 단위) | 1616 |
| D10 | Message CellClick | CATEGORY_DESC 항상 취소 / LANGUAGE 는 신규 'I' 행만 허용 | 1148~1155 |

- 보조 차단: Category 더블클릭은 CATEGORY_DESC 외 취소(944~947) / 기존 행(M/D/무표시) Module·Sub Module 값 존재 시 편집 취소(895~907, 1088~1100) / Message 더블클릭은 MAIL_TITLE·MESSAGE_CONTENT 외 취소(1161~1165).

## E. 바이트 제한 축 (2건 — 경로별 상이, TO-BE 격차 후보)

| # | 경로 | 한계 | 초과 시 | 근거 |
|---|---|---|---|---|
| E1 | PopContent 팝업 입력(MAIL) | MaxLength 3700 + 3,700바이트 검사 | MSG00165 + 직전 내용 원복 | PopContent 97~98, 115~123 |
| E2 | Message 그리드 직접 입력 | 4,000바이트 검사 | MSG00165 + 원복 | 1206~1214 |

## F. 삭제 연쇄 축 (1건)

| # | 트리거 | 동작 | 근거 |
|---|---|---|---|
| F1 | Category 삭제 행 저장 | 화면: MSG00121 Yes/No 확인 → SP: LIST 삭제 + 해당 CATEGORY 의 MESSAGE 전체 삭제 + (MAIL→ASSIGN / SMS→SMS_ASSIGN) 전체 삭제 + 삭제 전 이력 SP 적재 | 500~504, SP L29878~29903 |

## G. 채번 축 (1건)

| # | 대상 | 규칙 | 근거 |
|---|---|---|---|
| G1 | CATEGORY_ID | 신규 행(빈 ID) 저장 시 SP 가 `SEQ1_SCM_ADM_RECIPIENT_LIST` 시퀀스로 채번(화면 채번 없음) | SP L29808~29811 |

## H. 권한 축 — AS-IS 화면 내 개별 권한 분기 **없음**
BaseForm 표준 툴바 권한(메뉴 단위)만 적용. 사용자별/그룹별 컬럼·버튼 분기 코드 없음. → TO-BE 는 표준 권한 2테이블(메뉴+버튼) 등록으로 대응, 화면 내 추가 분기 불요.

## I. Division 축 — **없음**
이 화면은 Division 개념을 사용하지 않음(조회조건·컬럼·SP 파라미터 어디에도 DIVISION 없음). UNIT_TP_CD 등록 시 Division 무관 화면 기준 적용.

## J. Measure 축 — **없음** (admin 설정 화면)
저장 대상 엔터티로 대체: ①발송 카테고리(SCM_ADM_RECIPIENT_LIST — 주기/시간/SQL) ②언어별 메시지(SCM_ADM_RECIPIENT_MESSAGE) ③수신자 배정(SCM_ADM_RECIPIENT_ASSIGN). 이력 3테이블(_H)은 SP가 자동 적재.

## K. FCST_TYPE 축 — **없음** (DM 전용 축)

## 카운트 요약 (문서 대사용)

| 항목 | 건수 |
|---|---|
| 조회조건 | 상단 3 (Module/Sub Module/Active) + Receiver 탭 2 (Department/User ID(Name)) = 5 |
| 툴바 버튼 | 5 (Find/Insert/Delete/Edit/Save) + 화면 버튼 2 (▶추가/◀제거) + 셀 버튼 1 (SQL VIEW) = 8 |
| 그리드 | 4 (Category/Message/All_Receiver/Sel_Receiver) |
| 이벤트 배선 | 12 (Load, Category CellClick·ComboSelChange·CellDoubleClick, Message CellClick·CellDoubleClick·EditChange, btnRAdd·btnRDel Click, txtUser·txtDept Click+TextChanged(2컨트롤 공유), All_Receiver CellDoubleClick) |
| 팝업 | 2 (PopSQL/PopContent) |
| MSG 호출 지점 / unique | 25 / 13 (사문 MSG00005 포함) — 사내 미등록 9종 |
| 제약 행 | A6 + B3 + C7 + D10(+보조3) + E2 + F1 + G1 = 33 |
| SP / 의존 함수·이력SP / 시퀀스 | 9 / 6 / 1 |
| 테이블(직접+조인) | 10 (RECIPIENT 4 + _H 3 은 이력 SP 경유, LOOKUP 2, SSO 2, TB_FX_USER, LOG_BATCH — 직접 참조 기준 10) |
