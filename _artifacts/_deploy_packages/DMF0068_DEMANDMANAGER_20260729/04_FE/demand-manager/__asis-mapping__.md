# DMF0068 Demand Manager — AS-IS ↔ TO-BE 매핑

원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0068_DemandManager40\DMF0068_DemandManager40.cs` (정본 1,337행)
+ Designer 371행 + 팝업 `DMF0068_VersionPopup.cs` 389행 + FoxQuery `DMF0068_DemandManager40.xml`
상세 분석: `Doc/화면분석서/DMF0068_DemandManager_{주요이벤트_상세분석,제약매트릭스_상세}.md`

## 1. 조회조건 (3 → 3, 누락 0)

| # | AS-IS | TO-BE | 비고 |
|---:|---|---|---|
| 1 | `txtVersion` (읽기 전용 입력) | `DemandManagerForm` Version 입력 | 팝업으로만 값이 들어간다 |
| 2 | `btnSPVer` (버전 찾기 버튼) | Version 옆 `...` 버튼 → `VersionPopupModal` | 사업부 40 고정, 기간 ±3개월 |
| 3 | `drpPeriodMonth` (월 구간) | Period 월 달력 2개 | 기본 전년 1월 ~ 익년 12월(36개월) |

사업부는 AS-IS 도 조회조건이 아니라 코드 상수(40)이므로 TO-BE 도 조회조건에 두지 않는다.

## 2. 버튼 (override 6 + 커스텀 1 → 7, 누락 0)

| AS-IS | TO-BE | 처리 |
|---|---|---|
| `FindButton` → `FindData` | `handleSearch` (F5) | 사업부·권한·버전·기간 순 검증 후 조회 |
| `InsertButton` → `InsertRow` | `handleInsert` (F8) | 2행 1세트 삽입 + 그룹 키 부여 + Measure 고정 |
| `DeleteButton` | `handleDelete` (F9) | 세트 단위 삭제 표시 (신규 세트는 즉시 제거) |
| `EditButton` | `handleEdit` 커스텀 버튼 | 편집 모드 토글 + 조회조건 잠금 |
| `SaveButton` → `SaveData` | `handleSave` (F7) | 저장 → 삭제 순차 호출 후 재조회 |
| `ExcelButton` | 공통 Excel 버튼 | AS-IS 옵션(병합 해제·정수 포맷)은 공통 동작으로 대체 |
| `btnSPVer_Click` | `VersionPopupModal` | 버전 1건 채택 |

## 3. 이벤트 (AS-IS 배선 2건 → 전수 반영)

| AS-IS | TO-BE |
|---|---|
| `Form_Load` → InitControls / CreateSpread / SetSpreadMonth | mount effect(컬럼 메타 fetch) + `buildMonthColumns` |
| `btnSPVer.Click` | Version 버튼 → 모달 |

AS-IS 는 그리드에 CellClick/Changed 배선이 없고 셀 제어를 잠금·Formula 로 선처리한다.
TO-BE 는 같은 효과를 `beginningEdit`(편집 가능 판정) + `cellEditEnded`(짝 행 동기화) 로 옮겼다.

## 4. Validation (활성 23건 + 팝업 2건 → 전수, 누락 0)

| AS-IS MSG | 조건 | TO-BE 코드 | 위치 |
|---|---|---|---|
| MSG00415 | 내 사업부에 40 없음 (3곳) | **MSG00702**(신규) | 진입·조회·편집 게이트 |
| MSG00096 | 편집 그룹 아님 (2곳) | MSG00096 | `validateEditGroup` |
| MSG00283 | 버전 공란 | MSG00283 | `validateFind` |
| MSG00002 | 필수값 (조회 1 + 저장 3) | **MSG00614** | `validateFind` / `validateSaveRow` |
| MSG00049 | 날짜 형식 (2곳) | **MSG00611** | 〃 |
| MSG00108 | 기간 대소 (2곳) | MSG00108 | 〃 |
| MSG00084 | 0보다 큰 정수 (2곳) | **MSG00699**(신규) | `validateSaveRow` |
| MSG00113 | 신규 행 짝 미충족 | MSG00113 | `validateNewRowPairs` |
| MSG00004 | 저장·삭제 결과 (2곳) | **MSG00672** | `handleSave` |
| MSG00105 | 기간 중첩 | **MSG00700**(신규) | 〃 |
| MSG00260 | 그 밖의 저장 실패 | MSG00260 | 〃 |
| MSG00284 | 삭제 실패 | **MSG00618** | 〃 |
| MSG00279 | 버전 2건 이상 선택 (팝업 2곳) | **MSG00701**(신규) | `VersionPopupModal` |
| MSG00307 | (도달 불가 죽은 코드) | **이관 제외** | — |

AS-IS 번호를 그대로 쓸 수 없는 4건(MSG00002/00004/00049/00284)은 사내 원장의 **같은 뜻 문구를 명칭 기준으로 찾아 재사용**했고, 원장에 없는 4건만 신규 채번했다.

## 5. Expression / 잠금 (전수)

| AS-IS | TO-BE |
|---|---|
| 조회 직후 전 컬럼 잠금 | `editMode=false` 로 시작 — 모든 셀 편집 불가 |
| 편집 진입 시 컬럼 2·5·8 이후 잠금 | `EDITABLE_BINDINGS` 5개만 허용 |
| 짝수 행 기간 잠금 + 윗행 Formula 복사 | `isSetHead` 판정 + `cellEditEnded` 로 짝 행 동기화 |
| 행 추가 시 둘째 행 3셀 잠금·백색 | 동일 판정으로 편집 불가 처리(색상은 3색 규칙) |
| Measure 셀 잠금 | 편집 대상 컬럼에서 제외 |
| 범위 밖 월 0 처리 | `isOutOfOrderRange` — AS-IS 가 건너뛴 첫 월도 동일 적용 |
| 월 컬럼 11~154 하드코딩 | `buildMonthColumns` — 조회 기간에서 산출 |
| 화면단 실적/계획/잔고 재계산(주석) | 이관하지 않음 — 프로시저 계산값 표시 |
| 3단 헤더 동적 구성(미호출) | 이관하지 않음 |

## 6. SP (6종 → 6종, 누락 0)

| AS-IS | TO-BE |
|---|---|
| `DMF0068_GET_ORDERLIST` | `PKG_DMF0068.P_DMF0068_GET_ORDERLIST` |
| `DMF0068_GET_LOOKUPPROJECT` | `PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT` |
| `DMF0068_GET_CONT_VIEW_VERSIONPOPUP` | `PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP` |
| `DMF0068_SAVE_ORDERLIST` (FoxQuery 경유) | `PKG_DMF0068.P_DMF0068_SAVE_ORDERLIST_JSON` (CLOB 래퍼) |
| `DMF0068_DEL_ORDERLIST` (FoxQuery 경유) | `PKG_DMF0068.P_DMF0068_DEL_ORDERLIST_JSON` (CLOB 래퍼) |
| `SCM0001_GET_LOOKUP_VALUES` (팝업 Type) | 공통 콤보 |

저장·삭제는 AS-IS 가 테이블 값 파라미터를 썼는데 표준 호출로는 컬렉션을 넘길 수 없어,
JSON 을 받아 컬렉션으로 바꿔 **기존 멤버를 그대로 부르는 래퍼**를 새로 만들었다(기존 본문 무수정).

## 7. AS-IS 결함 — TO-BE 교정분

| AS-IS 현상 | TO-BE |
|---|---|
| 사업부 판정이 '포함' 비교라 140·401 도 통과 | 정확히 40 인지로 판정 |
| 범위 밖 월 0 처리가 두 번째 월부터 시작 | 첫 월부터 적용 |
| 조회에도 편집 권한을 요구 | 조회는 메뉴 권한으로 열고 편집 계열만 권한 판정 |
| 사업부 미보유 시 화면이 빈 그리드로 열림 | 진입 게이트에서 안내 |
| 버전 계열(R_S/그 외)로 Measure 목록을 갈랐으나 내용이 동일 | 단일 정의로 통합 |

## 8. 미이관 (의도적 제외)

- `SetSpreadHeaderSpan` 3단 헤더 동적 구성 — 호출부가 주석 처리된 죽은 코드
- `MSG00307` 건수 안내 — 변수가 항상 0 이라 도달 불가
- 화면단 실적/계획/잔고 재계산 — 속도 문제로 AS-IS 도 주석 처리, 프로시저 계산값 사용
- 팝업 `GetSpdTitle` 공통 타이틀 조회 — 호출부 주석
- `cellTypeImage` 팝업 아이콘 셀타입 — 어떤 셀에도 배정되지 않은 잔존물
