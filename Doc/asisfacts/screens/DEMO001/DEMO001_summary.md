# DEMO001 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 02.Launcher\GSCM.Launcher\Program.cs | 02.Launcher\GSCM.Launcher\GSCM.Launcher.csproj | 49 |
| only | 06.Sample\Minisoft.Windows.FormSample\Program.cs | 06.Sample\Minisoft.Windows.FormSample\Minisoft.Windows.FormSample.csproj | 23 |
| only | 06.Sample\Minisoft.Windows.Sample\Program.cs | 06.Sample\Minisoft.Windows.Sample\Minisoft.Windows.Sample.csproj | 33 |
| only | 10.Updater\GSCM.Updater.Dev\Program.cs | 10.Updater\GSCM.Updater.Dev\GSCM.Updater.Dev.csproj | 32 |
| only | 10.Updater\GSCM.Updater.Live\Program.cs | 10.Updater\GSCM.Updater.Live\GSCM.Updater.Live.csproj | 32 |
| only | 10.Updater\GSCM.Updater.Live2\Program.cs | 10.Updater\GSCM.Updater.Live2\GSCM.Updater.Live2.csproj | 32 |
| only | 10.Updater\GSCM.Updater.QAS\Program.cs | 10.Updater\GSCM.Updater.QAS\GSCM.Updater.QAS.csproj | 32 |
| only | 10.Updater\GSCM.Updater.Test\GSCM.Updater.Test\Program.cs | 10.Updater\GSCM.Updater.Test\GSCM.Updater.Test\GSCM.Updater.Test.csproj | 23 |
| only | 10.Updater\GSCM.Updater.Test\Program.cs | 10.Updater\GSCM.Updater.Test\GSCM.Updater.Test.csproj | 31 |
| only | 20.RFC\SAPRFC_Batch_NERP\Program.cs | 20.RFC\SAPRFC_Batch_NERP\SAPRFC_Batch_NERP.csproj | 104 |
| only | 20.RFC\SAPRFC\Program.cs | 20.RFC\SAPRFC\SAPRFC_Batch.csproj | 4451 |
| only | 21.WebService\WindowsFormsApplication1\Program.cs | 21.WebService\WindowsFormsApplication1\WindowsFormsApplication1.csproj | 22 |
| only | 88.Test\OralceImportTest\Program.cs | 88.Test\OralceImportTest\OralceImportTest.csproj | 23 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| excuteQury | ConfigurationManager.AppSettings | XIFConnectionString |
| GET_IFSEQNO | ConfigurationManager.AppSettings | SCMConnectionString |
| SCM_SYS_LOG_BATCH | ConfigurationManager.AppSettings | SCMConnectionString |
| XIF_ERP | ht | IN_PARM_NAMES, IN_PARM_VALUES, COLS, SAP_COLS, RFC_FNC_NAME, RFC_TABLE_NAME, PROGRAM_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| Run | Main:19, Main:27, Main:87, Main:18, Main:42, Main:29 | ApplicationStart.Run | __Query |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|

## 6. 컨트롤 (0개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

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
