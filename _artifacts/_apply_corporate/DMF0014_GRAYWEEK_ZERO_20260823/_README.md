# DMF0014 Excel Upload — 회색(입력불가) 주차 값 **0 저장** (사내 적용 완료 2026-08-23)

## 요구 (사용자 지시 2026-08-23)
> Customer Fcst Master 기준 `VALID_YN` 이 `'Y'` 가 아닌 구간(Excel Form 에서 **Gray** 로 칠한 칸)에
> 값이 들어와 있으면 **0 으로 저장**한다. 가능하면 **UI 수정 없이 PKG 수정만으로**.

AS-IS 에는 없는 TO-BE 전용 규칙이다(사용자 확정) — AS-IS 소스 대조 대상 아님.

## 종전 동작과 무엇이 달라지나

| | 종전 `[E20260818-GRAYWEEK]` | 변경 `[E20260823-GRAYZERO]` |
|---|---|---|
| 회색 주차에 값 존재 | 스테이징 행 `UPLOAD_STATUS_CODE='ERROR'` + **업로드 전체 반려**(`CODE=-1`) | **반려하지 않음.** 그 칸만 **0** 으로 적재, 나머지 칸은 정상값 |
| 추적 | ERROR 메시지 `Invalid Upload Week...` | 로그 타입 `175` 에 대상 행수 기록(`GRAYZERO: ... rows=N`) |

## 변경 지점 — `PKG_DMF0014` BODY 2곳 (FE 무변경)

1. **검증 블록 축소** — `UPDATE ... SET UPLOAD_STATUS_CODE='ERROR'` + `RETURN` 제거 → `SELECT COUNT(*) INTO v_err_cnt` + 로그만.
2. **적재 값 CASE** — `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 의 `DM_PLN_CUSTOMER_PSI` INSERT:
   ```sql
   ,CASE WHEN EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                        WHERE  M.VALID_YN = 'Y'
                        AND    M.DIVISION_ID = MD.DIVISION_ID
                        AND    (MD.DIVISION_ID = V.ATTRIBUTE1 OR MD.DIVISION_NAME = V.ATTRIBUTE1)
                        AND    M.SCM_SITE_ID  = V.ATTRIBUTE2
                        AND    M.MEASURE      = V.ATTRIBUTE10
                        AND    M.SUMMARY_BUCKET_VALUE =
                               CASE WHEN REGEXP_LIKE(TRIM(C.YYYYMMDD), '^[0-9.eE+-]+$')
                                    THEN TO_CHAR(TO_NUMBER(TRIM(C.YYYYMMDD)), 'FM99999999')
                                    ELSE TRIM(C.YYYYMMDD) END)
         THEN TO_NUMBER(V.VALUE) ELSE 0 END
   ```

### 판정 술어를 종전 검증과 **같게** 둔 이유
화면 회색 판정(`P_DMF0014_GET_EXCEL_FORM_DATA` 의 `UPLOAD_VALID_WEEKS`)과 적재 판정이 갈라지면
"노란 칸인데 0으로 저장" 또는 "회색 칸인데 값이 남음" 이 생긴다. 두 곳 모두
`DM_MST_CUSTOMER_FCST.VALID_YN='Y'` + (division/site/measure/bucket) 동일 축을 쓴다.
마스터에 **행 자체가 없는** 버킷도 `NOT EXISTS` 로 같이 걸린다(회색의 실제 다수 사례 — 실측상
최근 30일 버킷에 `VALID_YN='N'` 행은 0건, 회색은 대부분 "행 부재").

숫자서식 정규화(`'20260803.0'` → `'20260803'`)를 넣은 이유: 헤더 셀이 엑셀 숫자로 들어오면
문자 비교가 어긋나 **정상 주차가 0 으로 뒤집힐** 수 있다. 종전 검증과 같은 방식으로 맞췄다.

## 적용·검증 실측 (사내)

| 항목 | 결과 |
|---|---|
| 컴파일 | `PACKAGE BODY` **VALID** |
| 마커 `E20260823-GRAYZERO` | ALL_SOURCE **2행** |
| 적재 CASE (`THEN TO_NUMBER(V.VALUE) ELSE 0 END`) | 1행 |
| 종전 반려 문구 `Invalid Upload Week` 잔존 | **0행** (반려 경로 제거 확인) |
| 최신 업로드 배치(08-23 18:23, minyonglee1) 시뮬레이션 | 회색칸 입력 0건 — 이 배치는 영향 없음 |

## 남은 일

- **런타임 실증 미완** — 회색 주차에 값을 넣은 파일로 [Upload] → [OK] 후 `DM_PLN_CUSTOMER_PSI.QTY = 0` 확인 필요.
  저장 SP 직접 호출은 내부 COMMIT 이라 원장을 실제로 바꾸므로 화면에서 확인하는 편이 안전하다.
- **클라우드 미적용** — 이관 시 `PKG_DMF0014` BODY 전체 교체 필요(직전 패키지 = `DMF0014_CLOUD_20260818`).
- `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(3-arg)은 **배선 제외 SP** 라 미적용(같은 적재 로직 보유).
  배선이 살아나면 같은 정정을 옮겨야 한다.

## 파일
- `apply.py` — 백업 → 패치 → 컴파일 → 마커 검증 (점검만: `--dry`)
- `BACKUP_PKG_DMF0014_BODY_20260823_183901.sql` — 적용 직전 원문 (원복용, 그대로 실행)
- `PREVIEW_PKG_DMF0014_BODY.sql` — 적용본 (숫자서식 정규화 보강 반영)
