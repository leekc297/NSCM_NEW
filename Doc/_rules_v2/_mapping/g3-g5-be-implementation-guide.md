# G3 PerfLog + G5 File Transfer — BE 구현 사양 가이드

> Phase 7 후속 A3+A1 (2026-06-04) — BE 신규 작업은 룰 11 (NSCM 동적 SP 라우팅 표준) 검증 후 진행 의무.
>
> ⚠️ **사용자 결정 위임**: Phase 6 PoC 학습 (BE 신규 Controller 작성 = NSCM 표준 어긋남 가능). 본 가이드는 **사양만 작성** + 실제 코드 작성은 사용자 검토 후.

---

## §1 G3 PerfLog BE AOP — 사양

### §1.1 패턴 선택

| 옵션 | 설명 | NSCM 표준 적합도 |
|---|---|---|
| (A) 신규 `@PerfLog` annotation + `PerfLogAspect` + `PerfLogController` | 별도 endpoint `POST /admin/system/perf-log` | ⚠️ 신규 Controller (룰 11 표준 어긋날 수 있음) |
| (B) 기존 `@SystemLog(LogType.PERF)` 확장 + `SystemLogAspect` 안 measure 추가 | LogType enum 에 PERF 추가 + Aspect 안 분기 | ⭐ 표준 적합 (기존 패턴 확장) |
| (C) FE silently fail 유지 (BE 미구현) | 현재 상태 | UX 영향 0 (POC 검증 필요 없음) |

### §1.2 권장 = (B) `@SystemLog(LogType.PERF)` 확장

**LogType enum 확장**:
```java
// SystemLog.java
enum LogType {
    LOGIN, LOGOUT, MENU, BUTTON, SYSTEM, LOOKUP, COMBO, EXCELUPLOAD,
    PERF   // ⭐ G3 신규 (성능 측정)
}
```

**SystemLogAspect 안 PERF 분기 추가**:
```java
@Around("@annotation(systemLog)")
public Object logSystemAction(ProceedingJoinPoint joinPoint, SystemLog systemLog) throws Throwable {
    if (systemLog.value() == LogType.PERF) {
        // ⭐ G3 분기 — start/end duration 측정 + SCM_SYS_LOG INSERT (TYPE_CD='PERF')
        long startTime = System.currentTimeMillis();
        try {
            return joinPoint.proceed();
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            insertPerfLog(joinPoint, duration);
        }
    }
    // ... 기존 분기
}
```

**FE 통합**: `usePerfTrace.measure()` 의 `POST /admin/system/perf-log` 는 단순 endpoint — 메타 SQL `SCM_ADM_API_M` 에 등록 후 GeneralController 라우팅 가능 (BE 신규 Controller 불필요).

### §1.3 SCM_SYS_PERF_LOG 테이블 (대안 — SCM_SYS_LOG 재사용 우선)

```sql
-- SCM_SYS_LOG (기존) 재사용 권장 — TYPE_CD='PERF' 추가
INSERT INTO SCM_SYS_LOG (LOG_ID, USER_ID, MENU_ID, TYPE_CD, ACTION, START_TIME, END_TIME, DURATION_MS, ERROR_MSG, CREATED_AT)
VALUES (...);

-- 또는 별도 테이블 SCM_SYS_PERF_LOG (대량 로그 분리 시)
CREATE TABLE SCM_SYS_PERF_LOG (
    LOG_ID VARCHAR2(26) PRIMARY KEY,  -- ULID
    USER_ID VARCHAR2(50),
    MENU_ID VARCHAR2(20),
    ACTION VARCHAR2(100),
    PHASE VARCHAR2(10),  -- 'start' / 'end' / 'one'
    DURATION_MS NUMBER,
    ERROR_MSG VARCHAR2(2000),
    CREATED_AT TIMESTAMP DEFAULT SYSTIMESTAMP
);
```

### §1.4 결정 위임

→ 사용자 결정: (A) 신규 Controller / (B) SystemLog 확장 / (C) 현재 silently fail 유지.

**권장**: (B) — 기존 패턴 재사용 + NSCM 표준 적합 + 추가 인프라 최소.

---

## §2 G5 File Transfer — 사양

### §2.1 AS-IS 범위

| AS-IS 호출 | 의미 | DataService 위치 |
|---|---|---|
| `FP_DataPull` | 파일 다운로드 (server → client) | L147 |
| `FP_DataPush` | 파일 업로드 (client → server) | L152 |
| `FP_FileDataClient` | 양방향 file client | L159 |

### §2.2 TO-BE 패턴 (룰 11 표준)

| 컴포넌트 | 패턴 |
|---|---|
| **BE Controller** | ⭐ 신규 `FileController` 필요 (동적 SP 라우팅으로 부족 — multipart 처리) — 룰 11 표준 예외 |
| **BE Service** | `FileService.upload(file, menuId, sheetName)` + `download(menuId, fileId)` |
| **BE Storage** | `application.yml` 의 `file.storage.path` 설정 + S3 / local filesystem 분기 |
| **FE Hook** | `useFileUpload` (FormData + axios multipart) + `useFileDownload` (blob download) |
| **FE Component** | `FileUploadModal` + `FileDownloadButton` (공용) |

### §2.3 의무 endpoint

```
POST /admin/file/upload?menuId={mnuId}&sheetName={shtNm}
  body: multipart/form-data (file=...)
  return: { fileId, fileName, fileSize, uploadedAt }

GET /admin/file/download/{fileId}
  return: binary stream (Content-Disposition: attachment; filename="...")

DELETE /admin/file/{fileId}
  return: { success: true }
```

### §2.4 SCM_SYS_FILE 테이블

```sql
CREATE TABLE SCM_SYS_FILE (
    FILE_ID VARCHAR2(26) PRIMARY KEY,  -- ULID
    MENU_ID VARCHAR2(20),
    SHEET_NM VARCHAR2(50),
    FILE_NAME VARCHAR2(255),
    FILE_PATH VARCHAR2(1000),  -- (또는 S3 URL)
    FILE_SIZE NUMBER,
    MIME_TYPE VARCHAR2(100),
    UPLOADED_BY VARCHAR2(50),
    UPLOADED_AT TIMESTAMP DEFAULT SYSTIMESTAMP,
    DELETED_YN CHAR(1) DEFAULT 'N'
);
```

### §2.5 결정 위임

→ 사용자 결정: 신규 FileController 작성 진행 여부 / 우선순위 (현재 사용 화면 0건 — pending 가능).

**권장**: 사용 화면 (예: 첨부파일 화면 / 대량 업로드 화면) 등장 시 진행. 현재 격차 유지 (lazy).

---

## §3 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 신규 작성 — A3 (G3 PerfLog BE) + A1 (G5 File transfer) 사양 가이드. 사용자 결정 위임 + 권장 옵션 표시 |
