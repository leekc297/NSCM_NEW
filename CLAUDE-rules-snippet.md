# CLAUDE.md 에 붙일 작업 규칙 스니펫

기존 CLAUDE.md 의 AS-IS 탐색 관련 서술(“전체를 읽어라”, “SKIP 금지” 등)을
아래로 **교체**하세요. CLAUDE.md 는 얇게 유지하고, 상세는 산출물이 들고 있게 하는 것이 핵심입니다.

---

```md
## AS-IS 참조 규칙

- 화면 작업 시작 시 `doc/asis/screen-inventory.csv` 에서 **해당 screen_id 행 1개만** 읽는다.
  AS-IS 트리 전체 탐색(Glob/Grep) 금지.
- 그 행의 `uil_files` / `wsl_files` / `biz_files` / `dac_files` 에 나열된 파일만 연다.
- 동적 생성 UI(Spread·DevExpress)는 디자이너로 볼 수 없다.
  `doc/asis/dynamic-ui.csv` 에서 해당 screen_id 행을 필터해 **파일:라인** 위치를 반드시 연다.
- 쿼리는 `foxml_refs` 의 ID로 `doc/asis/foxml-catalog.md` 의 해당 섹션만 본다. 전체 로드 금지.
- SP는 `sp_refs` 로 `doc/asis/sp/<schema>.<name>.sql` 을 연다.
  파라미터는 `doc/asis/sp-params.csv`, 참조 관계는 `doc/asis/sp-dependencies.csv`.
- 인덱스에 없는 파일이 필요하다고 판단되면, 임의로 탐색하지 말고 그 사실을 보고한다.
  (인덱스 정확도 문제이므로 asis-config.psd1 을 고쳐 재생성해야 한다)

## 완료 조건

화면 작업 완료는 스스로 선언하지 않는다. 다음을 모두 만족해야 완료다.

1. `doc/coverage/<domain>.csv` 의 해당 screen_id 행이 전부 `done` 또는 `n/a`
2. `done` 행에 `evidence_path`(TO-BE 산출물 경로) 기입
3. 아래가 exit 0 을 반환

   scripts/coverage/Check-Coverage.ps1 -ScreenId <SCREEN_ID>

`n/a` 로 표시할 때는 `note` 열에 이유를 반드시 남긴다.

## TO-BE 그리드

Wijmo FlexGrid 는 SpreadJS 가 아니다. API를 유추하지 말고 `doc/wijmo-flexgrid-guide.md` 를 참조한다.

## 세션 운용

- 화면 1개 = 세션 1개. 끝나면 `/clear`.
- 상세 가이드는 필요할 때만 `@doc/...` 로 import 한다.
```

---

## 참고 — 화면 1개 작업의 표준 프롬프트

```
DMF0043 화면을 TO-BE로 변환한다.

1. doc/asis/screen-inventory.csv 에서 screen_id=DMF0043 행만 읽어라.
2. 그 행에 나열된 파일만 열어라. 그 외 AS-IS 탐색 금지.
3. doc/asis/dynamic-ui.csv 에서 screen_id=DMF0043 인 행의 파일:라인을 열어
   실제 그리드 컬럼 구성을 파악하라.
4. foxml_refs / sp_refs 에 해당하는 쿼리·SP 정의를 확인하라.
5. 변환 결과를 작성하고, doc/coverage/DM.csv 의 DMF0043 행을
   done + evidence_path 로 갱신하라.
6. scripts/coverage/Check-Coverage.ps1 -ScreenId DMF0043 가 0을 반환하는지 확인한 뒤
   완료를 보고하라.
```
