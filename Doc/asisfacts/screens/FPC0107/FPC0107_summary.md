# FPC0107 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0107_MemoReadOnlyPopup.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 263 |
| only | 06.UIL\GSCM.FP.Common.UIL\Popup\FPC0107_MemoReadOnlyPopup.designer.cs | 06.UIL\GSCM.FP.Common.UIL\GSCM.FP.Common.UIL.csproj | 472 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.Load | Form_Load > InitControls | 158 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 158 | FP\Common\AmendMemo#find_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql |
| unreached:(진입점 미연결) | btnSave_Click | 199 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSave_Click | 199 | FP\Common\AmendMemo#save_memo | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | btnClose_Click | 221 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnClose_Click | 221 | FP\Common\AmendMemo#delete_memo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendMemo_delete_memo.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=save_memo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_memo] | BIZ_MATCH | 1 |  |  |  |
| FP\Common\AmendMemo#delete_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_delete_memo.sql | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#find_memo | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_AmendMemo_find_memo.sql | SELECT:FP_AMEND_MEMO_M |  |
| FP\Common\AmendMemo#save_memo | MATCH_PATTERN | 1 | [update-batch]  | MERGE:FP_AMEND_MEMO_M, SELECT:TH_UIS_CAL, REF:FN_SITE_TIME, SELECT:SCM_FACTORY_M, INSERT:HIS_AMEND_MEMO_M, SELECT:FP_AMEND_MEMO_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnClose_Click | set | BUCKET_FROM, BUCKET_TO, MEMO, USER_ID |
| btnSave_Click | set | BUCKET_FROM, BUCKET_TO, MEMO, USER_ID |
| InitControls | set | USER_ID, INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, PLAN_DATE, EQUIPMENT_ID, ELECTRODE_TYPE, ITEM_ID, MEMO_TYPE, BUCKET_FROM, BUCKET_TO |
| InitControls | SrcRow | COMPANY_ID, DIVISION_ID, SITE_ID, LINE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET, ELECTRODE_TYPE, ITEM_ID, MEMO_TYPE |
| InitControls | memoInfo.Tables[0].Rows[0] | CREATOR, CREATION, MEMO, BUCKET_FROM, BUCKET_TO |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:112 |

## 6. 컨트롤 (17개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | layoutControlItem6, layoutControlItem10, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem7 |
| UsrLabel | 4 | txtCreator, txtCreation, usrLabel1, usrLabel3 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTextBox | 1 | usrTextBox1 |
| UsrDateRangePicker | 1 | usrDateRangePicker1 |

## 7. 확인 필요 (3건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 158 | InitControls | FP\{?default:part_service}\AmendMemo#find_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 199 | btnSave_Click | FP\{?default:part_service}\AmendMemo#save_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 221 | btnClose_Click | FP\{?default:part_service}\AmendMemo#delete_memo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(행 존재, 생성 호출 미발견)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
