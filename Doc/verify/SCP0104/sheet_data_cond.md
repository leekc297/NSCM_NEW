# SCP0104 시트별 데이터 조건

- 측정 2026-11-17 15:53:49 · sqllog_calls.json GET 호출 재실행(TO-BE 사내 Oracle · AS-IS MSSQL .env.asis)
- Division 후보(combo_runtime.json) 81, 40, 82, 81_UC, 81_HM, 81_ST, 81_HD, 81_HG

| 시트 | 양쪽 행 있는 Div | TO-BE 행 있는 Div | TO-BE 최대 | AS-IS 최대 |
|---|---|---|---|---|
| ASSEMBLY | 81, 40, 82, 81_ST, 81_UC, 81_HG, 81_HD, 81_HM | 81, 40, 82, 81_ST, 81_UC, 81_HG, 81_HD, 81_HM | 608 (Div 81) | 608 (Div 81) |
| ELTR | 40, 81, 81_ST, 82, 81_UC, 81_HD, 81_HG, 81_HM | 40, 81, 81_ST, 82, 81_UC, 81_HD, 81_HG, 81_HM | 403 (Div 40) | 403 (Div 40) |
| LINE | 81, 40, 82, 81_UC, 81_HD, 81_ST, 81_HG, 81_HM | 81, 40, 82, 81_UC, 81_HD, 81_ST, 81_HG, 81_HM | 156 (Div 40) | 156 (Div 40) |
| SOP_ASSEMBLY | 81_HG, 81_ST | 81_HG, 81_ST | 27 (Div 81_HG) | 27 (Div 81_HG) |
| SOP_ELTR | 81_ST, 81_HG | 81_ST, 81_HG | 6 (Div 81_ST) | 6 (Div 81_ST) |
| SOP_MODEL_ASSEMBLY | 81, 81_UC, 82, 81_HD, 81_HG, 81_ST, 81_HM | 81, 81_UC, 82, 81_HD, 81_HG, 81_ST, 81_HM | 168 (Div 81) | 168 (Div 81) |
| SOP_MODEL_ELTR | 81, 40, 81_UC, 82, 81_HD, 81_ST, 81_HG, 81_HM | 81, 40, 81_UC, 82, 81_HD, 81_ST, 81_HG, 81_HM | 50 (Div 81) | 50 (Div 81) |

| 시트 | 종류 | Div | 조건 | TO-BE 행 | AS-IS 행 | 비고 | 측정 |
|---|---|---|---|---|---|---|---|
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 608 | 608 |  | 2026-11-17 15:53:54 |
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 74 | 74 |  | 2026-11-17 15:53:55 |
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 74 | 74 |  | 2026-11-17 15:53:55 |
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:53:56 |
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:53:56 |
| ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=P9500,P5500 | 96 | 96 |  | 2026-11-17 15:53:57 |
| ASSEMBLY | rec | 40 | p_version=202610, p_operation_id=A3000,A8210,A9000 | 294 | 294 |  | 2026-11-17 15:53:58 |
| ASSEMBLY | rec | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 136 | 136 |  | 2026-11-17 15:53:59 |
| ASSEMBLY | div | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 608 | 608 |  | 2026-11-17 15:54:00 |
| ASSEMBLY | div | 40 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:01 |
| ASSEMBLY | div | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 136 | 136 |  | 2026-11-17 15:54:01 |
| ASSEMBLY | div | 81_UC | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 80 | 80 |  | 2026-11-17 15:54:02 |
| ASSEMBLY | div | 81_HM | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 25 | 25 |  | 2026-11-17 15:54:02 |
| ASSEMBLY | div | 81_ST | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 88 | 88 |  | 2026-11-17 15:54:03 |
| ASSEMBLY | div | 81_HD | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 40 | 40 |  | 2026-11-17 15:54:03 |
| ASSEMBLY | div | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 75 | 75 |  | 2026-11-17 15:54:03 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 275 | 275 |  | 2026-11-17 15:54:06 |
| ELTR | rec | 40 | p_version=202610, p_operation_id=E2000 | 403 | 403 |  | 2026-11-17 15:54:09 |
| ELTR | rec | 82 | p_version=202610, p_operation_id=E2000 | 26 | 26 |  | 2026-11-17 15:54:11 |
| ELTR | rec | 81 | p_version=202609, p_operation_id=E2000 | 275 | 275 |  | 2026-11-17 15:54:13 |
| ELTR | rec | 81 | p_version=202608, p_operation_id=E2000 | 275 | 275 |  | 2026-11-17 15:54:16 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 31 | 31 |  | 2026-11-17 15:54:18 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:20 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:22 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 1 | 1 |  | 2026-11-17 15:54:24 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 183 | 183 |  | 2026-11-17 15:54:27 |
| ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 92 | 92 |  | 2026-11-17 15:54:29 |
| ELTR | rec | 81_HG | p_version=202610, p_operation_id=E2000 | 7 | 7 |  | 2026-11-17 15:54:31 |
| ELTR | div | 81 | p_version=202610, p_operation_id=E2000 | 275 | 275 |  | 2026-11-17 15:54:33 |
| ELTR | div | 40 | p_version=202610, p_operation_id=E2000 | 403 | 403 |  | 2026-11-17 15:54:36 |
| ELTR | div | 82 | p_version=202610, p_operation_id=E2000 | 26 | 26 |  | 2026-11-17 15:54:38 |
| ELTR | div | 81_UC | p_version=202610, p_operation_id=E2000 | 16 | 16 |  | 2026-11-17 15:54:40 |
| ELTR | div | 81_HM | p_version=202610, p_operation_id=E2000 | 4 | 4 |  | 2026-11-17 15:54:42 |
| ELTR | div | 81_ST | p_version=202610, p_operation_id=E2000 | 30 | 30 |  | 2026-11-17 15:54:44 |
| ELTR | div | 81_HD | p_version=202610, p_operation_id=E2000 | 10 | 10 |  | 2026-11-17 15:54:46 |
| ELTR | div | 81_HG | p_version=202610, p_operation_id=E2000 | 7 | 7 |  | 2026-11-17 15:54:48 |
| LINE | rec | 81 |  | 126 | 126 |  | 2026-11-17 15:53:50 |
| LINE | rec | 40 |  | 156 | 156 |  | 2026-11-17 15:53:50 |
| LINE | div | 81 |  | 229 | 229 |  | 2026-11-17 15:53:50 |
| LINE | div | 40 |  | 159 | 159 |  | 2026-11-17 15:53:51 |
| LINE | div | 82 |  | 48 | 48 |  | 2026-11-17 15:53:51 |
| LINE | div | 81_UC |  | 27 | 27 |  | 2026-11-17 15:53:51 |
| LINE | div | 81_HM |  | 4 | 4 |  | 2026-11-17 15:53:51 |
| LINE | div | 81_ST |  | 21 | 21 |  | 2026-11-17 15:53:51 |
| LINE | div | 81_HD |  | 23 | 23 |  | 2026-11-17 15:53:52 |
| LINE | div | 81_HG |  | 12 | 12 |  | 2026-11-17 15:53:52 |
| LINE | rec | 81 |  | 80 | 79 |  | 2026-11-17 15:54:56 |
| LINE | rec | 81 |  | 0 | 0 |  | 2026-11-17 15:54:56 |
| LINE | div | 81 |  | 80 | 79 |  | 2026-11-17 15:54:56 |
| LINE | div | 40 |  | 54 | 54 |  | 2026-11-17 15:54:56 |
| LINE | div | 82 |  | 12 | 12 |  | 2026-11-17 15:54:56 |
| LINE | div | 81_UC |  | 18 | 18 |  | 2026-11-17 15:54:56 |
| LINE | div | 81_HM |  | 3 | 3 |  | 2026-11-17 15:54:56 |
| LINE | div | 81_ST |  | 15 | 15 |  | 2026-11-17 15:54:56 |
| LINE | div | 81_HD |  | 12 | 12 |  | 2026-11-17 15:54:56 |
| LINE | div | 81_HG |  | 8 | 8 |  | 2026-11-17 15:54:56 |
| SOP_ASSEMBLY | rec | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 27 | 27 |  | 2026-11-17 15:54:56 |
| SOP_ASSEMBLY | rec | 40 | p_version=202610, p_operation_id=A3000,A8210,A9000 | 0 | 0 |  | 2026-11-17 15:54:56 |
| SOP_ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:56 |
| SOP_ASSEMBLY | rec | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 40 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81_UC | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81_HM | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81_ST | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 12 | 12 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81_HD | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ASSEMBLY | div | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 27 | 27 |  | 2026-11-17 15:54:57 |
| SOP_ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ELTR | rec | 81_ST | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:57 |
| SOP_ELTR | rec | 81_HG | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:57 |
| SOP_ELTR | rec | 40 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:57 |
| SOP_ELTR | rec | 82 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 40 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 82 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81_UC | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81_HM | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81_ST | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81_HD | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:58 |
| SOP_ELTR | div | 81_HG | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:58 |
| SOP_MODEL_ASSEMBLY | rec | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 27 | 27 |  | 2026-11-17 15:54:48 |
| SOP_MODEL_ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 168 | 168 |  | 2026-11-17 15:54:49 |
| SOP_MODEL_ASSEMBLY | div | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 168 | 168 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 40 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 31 | 31 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 81_UC | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 42 | 42 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 81_HM | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 12 | 12 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 81_ST | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 16 | 16 |  | 2026-11-17 15:54:50 |
| SOP_MODEL_ASSEMBLY | div | 81_HD | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 30 | 30 |  | 2026-11-17 15:54:51 |
| SOP_MODEL_ASSEMBLY | div | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 27 | 27 |  | 2026-11-17 15:54:51 |
| SOP_MODEL_ASSEMBLY | rec | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | rec | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 81 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 40 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 82 | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 81_UC | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 81_HM | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:53 |
| SOP_MODEL_ASSEMBLY | div | 81_ST | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ASSEMBLY | div | 81_HD | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ASSEMBLY | div | 81_HG | p_version=202610, p_operation_id=A5000,A7000,A7400,A8000,A8400,A9000,AFFFF | 0 | 0 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ELTR | rec | 81_HG | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:51 |
| SOP_MODEL_ELTR | div | 81 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:51 |
| SOP_MODEL_ELTR | div | 40 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:51 |
| SOP_MODEL_ELTR | div | 82 | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | div | 81_UC | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | div | 81_HM | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | div | 81_ST | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | div | 81_HD | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | div | 81_HG | p_version=202610, p_operation_id=E2000 | 0 | 0 |  | 2026-11-17 15:54:52 |
| SOP_MODEL_ELTR | rec | 81_HG | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ELTR | rec | 81_ST | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ELTR | rec | 81 | p_version=202610, p_operation_id=E2000 | 50 | 50 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ELTR | div | 81 | p_version=202610, p_operation_id=E2000 | 50 | 50 |  | 2026-11-17 15:54:54 |
| SOP_MODEL_ELTR | div | 40 | p_version=202610, p_operation_id=E2000 | 36 | 36 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 82 | p_version=202610, p_operation_id=E2000 | 10 | 10 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 81_UC | p_version=202610, p_operation_id=E2000 | 16 | 16 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 81_HM | p_version=202610, p_operation_id=E2000 | 2 | 2 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 81_ST | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 81_HD | p_version=202610, p_operation_id=E2000 | 8 | 8 |  | 2026-11-17 15:54:55 |
| SOP_MODEL_ELTR | div | 81_HG | p_version=202610, p_operation_id=E2000 | 6 | 6 |  | 2026-11-17 15:54:55 |
