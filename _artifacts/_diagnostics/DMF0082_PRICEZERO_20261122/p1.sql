SELECT TOP 30 ProgramID, ProgramName FROM TB_FX_ProgramInfo WITH(NOLOCK) WHERE ProgramName LIKE N'%Lookup%' OR ProgramName LIKE N'%NERP%' OR ProgramName LIKE N'%Code%' ORDER BY ProgramID
