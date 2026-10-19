# Hook #151 — asis-db-live-connection-mandatory (AS-IS 정보 확인 = DB 직접 접속 의무)

> **트리거**: AS-IS(GSCM MSSQL) 의 SP/뷰/함수 본문·스키마·데이터·메타를 **확인·인용·대조**하는 모든 작업
> **사용자 지시 (2026-09-09)**: "앞으로 AS-IS DB 정보를 확인할 때는 DDL 파일이 아닌 DB 를 직접 접속해서 확인해주세요.
> 혹시 VPN 연결이 되지 않아서 AS-IS DB 연결이 안되는 경우에는 반드시 사용자에게 확인 후 DDL 파일을 사용하는 것으로 해주세요."

---

## §1 원칙 (불변)

| # | 규칙 |
|---:|---|
| 1 | **AS-IS 사실의 정본 = 살아있는 DB** (`sys.sql_modules.definition` / `sys.objects` / `INFORMATION_SCHEMA` / 실데이터). |
| 2 | 전달받은 `.sql` DDL 파일·스크린샷·문서는 **보조 자료**다. 단독 근거로 결론을 내지 않는다. |
| 3 | DB 접속이 불가할 때(VPN 미연결 등) **작업을 중단하고 사용자에게 확인**한다. 사용자가 승인한 경우에만 DDL 파일로 진행한다. |
| 4 | DDL 파일로 진행하는 경우 산출물에 **"DB 미접속 · 파일 기준 · 사용자 승인 {일시}"** 를 명시한다. |
| 5 | 보고문에는 **접속한 서버·DB·계정·조회시각**을 항상 병기한다. 어느 DB 를 봤는지가 결론의 유효범위다. |

⛔ **금지**: DB 접속이 가능한 상태에서 "파일이 이미 있으니까" 파일만 읽고 결론 내기.
⛔ **금지**: 접속 실패를 조용히 파일 fallback 으로 대체하기 (사용자 확인 없이).

## §2 왜 (2026-09-09 실사고)

DMF0082 Biz Type 메시지 확인 요청에서, 전달된 `ASIS_QA_DMF0082_SAVE_MAIN_DATA.sql` **파일만 읽고** 판정을 보고했다.
사용자가 "파일로 확인하지 말고 DB 접속해서 확인해달라"고 재지시했고, DB 실측 결과 판정 자체는 같았으나 —

- 파일 기준 라인번호(L1013/L1014)와 **DB 정의 라인번호(L1015/L1016)가 달랐다** (파일에 SSMS 래퍼 2줄 존재).
  정정 스크립트는 라인 기준으로 만들므로 이 차이는 그대로 오적용 위험이 된다.
- 파일명은 `QA` 인데 내가 접속 가능한 DB 는 `DEV` 뿐이라는 사실이 **DB 를 열거해 보고서야** 드러났다
  (`sys.databases` 실측 — 해당 인스턴스에 QA DB 없음). 파일만 봤다면 "QA 확인 완료"로 잘못 보고됐을 것이다.

⇒ 파일은 **어느 DB 의 어느 시점 스냅샷인지 스스로 증명하지 못한다.** 그 증명은 DB 접속으로만 나온다.

## §3 절차 (의무)

### §3.1 착수
```python
# 접속정보는 C:\Projects\NSCM\.env.asis (gitignored) — 코드에 하드코딩 금지
# ASIS_DB_HOST / ASIS_DB_PORT / ASIS_DB_NAME / ASIS_DB_USER / ASIS_DB_PASS / ASIS_DB_DRIVER
import pyodbc
cs = (f"DRIVER={{{drv}}};SERVER={host},{port};DATABASE={db};UID={usr};PWD={pwd};TrustServerCertificate=yes")
cn = pyodbc.connect(cs, timeout=30)
```
- 정본 조회: `SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('dbo.<SP>')`
- 메타 동반 조회 의무: `sys.objects.create_date / modify_date` — **스냅샷 시점 고정** (hook `asis-dev-volatile-snapshot-gate` 연동)
- 어느 DB 인지 확인: `SELECT @@SERVERNAME, DB_NAME(), SUSER_SNAME(), GETDATE()`
- **대상 DB 가 요청받은 환경(DEV/QA/PROD)인지 반드시 확인** — 다르면 그 사실을 먼저 보고한다.
  인스턴스 내 DB 열거 = `SELECT name, state_desc, HAS_DBACCESS(name) FROM sys.databases`

### §3.2 접속 실패 시
1. 실패 원인 1차 구분: VPN/네트워크 · 자격증명 · DB 상태.
2. **사용자에게 보고하고 확인을 받는다.** 예:
   > AS-IS DB(`{host}:{port}/{db}`) 접속이 안 됩니다(VPN 추정, 오류: `{msg}`).
   > 전달받은 DDL 파일(`{path}`)로 진행할까요?
3. 승인 전까지 **DDL 파일 기준 결론을 내지 않는다.** (조사 착수 자체는 가능하되 판정·보고 금지)
4. 승인 후 진행 시 §1-4 표기 의무.

### §3.3 파일이 함께 제공된 경우 (권장)
DB 정본과 파일을 **양쪽 다** 확보해 교차검증한다. 차이가 나면 차이 자체를 보고한다.
- 비교 전 정규화: SSMS 래퍼(`USE`/`SET ANSI_NULLS`/`SET QUOTED_IDENTIFIER`/`GO`) 제거 + CRLF→LF
- **라인번호는 DB 정의 기준으로 표기**한다(파일 라인번호는 래퍼 때문에 어긋난다).

## §4 산출물 표기 양식

```
접속: 165.244.95.223:1433 / LGCE_SCMDEV (서버 LESDFPSTO1C01, 계정 SCP_MGR_DEV) · 조회 2026-09-09 10:37
대상: dbo.DMF0082_SAVE_MAIN_DATA  modify_date=2026-06-12 17:31:52  2,271줄
근거: sys.sql_modules.definition 원문 (파일 아님)
```
파일 기준일 때:
```
⚠ DB 미접속 (VPN 불가) · 파일 기준: {경로} · 사용자 승인 2026-09-09 10:20
```

## §5 자기점검 (보고 직전)

- [ ] AS-IS 사실 인용에 **접속 서버/DB/계정/시각**이 적혀 있는가
- [ ] 라인번호가 **DB 정의 기준**인가 (파일 라인 아님)
- [ ] 대상 DB 가 사용자가 말한 환경(DEV/QA/PROD)과 **일치**하는가, 다르면 그 사실을 보고했는가
- [ ] 파일만 썼다면 **사용자 승인 기록**이 있는가

관련: `db-error-asis-cross-check.md` (오류 시 AS-IS 교차확인) · `asis-dev-volatile-snapshot-gate`(스냅샷 정합성) ·
`oracle-db-workflow.md` (Oracle 작업 통합 진입) · 룰 v1 `32_CLAUDE_ORACLE_DIRECT.md`
