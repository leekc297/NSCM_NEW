@{
    # =====================================================================
    # NSCM AS-IS 인덱싱 설정
    # 00-Probe-Asis.ps1 리포트를 보고 이 파일만 고치면 전체 스크립트가 따라옵니다.
    # =====================================================================

    # AS-IS 소스 루트 (Run-AsisIndex.ps1 의 -AsisRoot 로 덮어쓸 수 있음)
    AsisRoot = 'C:\Projects\NSCM\GSCM'

    # 산출물 루트
    DocRoot  = 'C:\Projects\NSCM\doc'

    # ---------------------------------------------------------------------
    # 화면ID 추출 정규식. named group 'id' 필수.
    # 예) DMF0043, SCPM0102 ...  →  2~5 영문자 + 3~5 숫자
    # 정찰 결과 실제 규칙이 다르면 여기만 바꿉니다.
    # ---------------------------------------------------------------------
    ScreenIdPattern = '(?<id>[A-Za-z]{2,5}\d{3,5})'

    # ---------------------------------------------------------------------
    # 레이어 판정 토큰. 앞에 오는 레이어가 우선순위가 높습니다.
    # ---------------------------------------------------------------------
    LayerToken = @{
        UIL = @('UIL', 'UI', 'Form', 'Forms', 'Screen', 'View', 'Presentation')
        WSL = @('WSL', 'WS', 'Service', 'Services', 'Facade', 'Proxy')
        BIZ = @('BIZ', 'Business', 'BL', 'Logic', 'Rule')
        DAC = @('DAC', 'DAO', 'Data', 'DataAccess', 'Repository', 'Persistence')
    }

    # ---------------------------------------------------------------------
    # 도메인 판정 (커버리지 장부 분할 기준). 화면ID 접두사로 매칭.
    # ---------------------------------------------------------------------
    DomainPrefix = @{
        DM  = @('DM')
        SCP = @('SCP', 'SP', 'CP')
    }

    # ---------------------------------------------------------------------
    # 스캔 대상 확장자
    # ---------------------------------------------------------------------
    SourceExtension = @('.cs')
    FoxmlExtension  = @('.foxml')

    # 제외 폴더 (경로 세그먼트 완전일치)
    ExcludeDirectory = @('bin', 'obj', '.vs', '.git', '.svn', 'packages', 'TestResults',
                         'node_modules', '_ReSharper', 'Backup', 'BACKUP', '_bak')

    # 개별 파일 크기 상한(KB). 초과 시 스킵하고 로그에 남깁니다.
    MaxFileSizeKB = 8192

    # ---------------------------------------------------------------------
    # 동적 UI 생성 패턴.
    # 라이선스가 없어 디자이너로 볼 수 없는 Spread / DevExpress 그리드의
    # 실제 컬럼 구성 코드 위치를 여기서 잡아냅니다.
    # name = 리포트에 찍힐 분류, pattern = .NET 정규식
    # ---------------------------------------------------------------------
    DynamicUiPattern = @(
        @{ name = 'Spread.New';        pattern = 'new\s+FpSpread\b|new\s+SpreadSheet\b|new\s+fpSpread\b' }
        @{ name = 'Spread.Sheet';      pattern = '\.Sheets\s*\[|\.ActiveSheet\b|SheetView\b|\.SheetCount\s*=' }
        @{ name = 'Spread.Column';     pattern = '\.Columns\s*\[|\.Columns\.Add\b|\.ColumnCount\s*=|\.AddColumns?\s*\(|\.Columns\.Count\s*=' }
        @{ name = 'Spread.CellType';   pattern = 'CellType\b|ComboBoxCellType|CheckBoxCellType|TextCellType|NumberCellType|DateTimeCellType|ButtonCellType' }
        @{ name = 'Spread.Header';     pattern = '\.ColumnHeader\b|\.RowHeader\b|ColHeader|SetColumnHeader|\.Label\s*=' }
        @{ name = 'DevEx.Grid';        pattern = 'new\s+GridControl\b|new\s+GridView\b|XtraGrid|DevExpress\.XtraGrid' }
        @{ name = 'DevEx.Column';      pattern = 'GridColumn\b|\.Columns\.AddField\b|\.Columns\.AddVisible\b|new\s+DevExpress\.XtraGrid\.Columns' }
        @{ name = 'DevEx.RepoItem';    pattern = 'RepositoryItem\w*\b' }
        @{ name = 'DevEx.Band';        pattern = 'GridBand\b|BandedGridView\b' }
        @{ name = 'WinForms.Grid';     pattern = 'new\s+DataGridView\b|DataGridViewColumn\b|\.Columns\.Add\s*\(\s*new\s+DataGridView' }
        @{ name = 'Factory.Create';    pattern = '\bCreateColumn\w*\s*\(|\bAddColumn\w*\s*\(|\bMakeGrid\w*\s*\(|\bInitGrid\w*\s*\(|\bSetGrid\w*\s*\(|\bBindGrid\w*\s*\(' }
        @{ name = 'Control.Dynamic';   pattern = '\.Controls\.Add\s*\(|new\s+(Button|TextBox|ComboBox|CheckBox|Label|Panel|DataGridView)\s*\(\s*\)' }
    )

    # ---------------------------------------------------------------------
    # SP 호출 추출 패턴. 문자열 리터럴 안의 SP 이름을 잡습니다.
    # 실제 명명규칙(usp_/sp_/UP_/PR_...)은 정찰 리포트를 보고 조정하세요.
    # ---------------------------------------------------------------------
    SpNamePattern = '(?<sp>\b(?:usp|sp|up|pr|proc|dbo\.usp|dbo\.sp)_[A-Za-z0-9_]{2,64}\b)'

    # SP 호출로 볼 코드 문맥(있으면 신뢰도 high, 없으면 medium)
    SpCallContextPattern = 'CommandType\s*\.\s*StoredProcedure|new\s+SqlCommand\s*\(|CommandText\s*=|ExecuteProcedure|ExecuteSP|ExecuteNonQuery|ExecuteDataSet|ExecuteReader|ExecuteScalar|\.Fill\s*\('

    # ---------------------------------------------------------------------
    # foxml 파싱: SQL 본문으로 인정할 최소 조건
    # ---------------------------------------------------------------------
    SqlDetectPattern = '(?is)\b(SELECT|INSERT\s+INTO|UPDATE|DELETE\s+FROM|MERGE|EXEC(UTE)?|WITH)\b'

    # foxml 파라미터 추출 (MSSQL @param, 치환 토큰 #param#, :param)
    FoxmlParamPattern = '@(?<p>[A-Za-z_][A-Za-z0-9_]{0,63})|#(?<p2>[A-Za-z_][A-Za-z0-9_]{0,63})#'

    # ---------------------------------------------------------------------
    # MSSQL SP 추출 대상 오브젝트 타입
    # ---------------------------------------------------------------------
    SqlObjectType = @('P', 'FN', 'IF', 'TF', 'V')
}
