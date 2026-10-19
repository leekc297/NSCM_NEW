package com.lgcns.nscm.framework.utils;

import java.io.InputStream;
import java.util.*;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

public class ExcelUtils {

    /**
     * MultipartFile(Excel)을 List<Map> 구조(JSON 대응)로 변환하는 모듈화 함수
     */
    public static List<Map<String, Object>> convertExcelToJson(MultipartFile file) throws Exception {
        List<Map<String, Object>> resultList = new ArrayList<>();

        try (InputStream is = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0); // 첫 번째 시트 사용
            Row headerRow = sheet.getRow(0);     // 첫 번째 행을 헤더(Key)로 간주
            int columnCount = headerRow.getPhysicalNumberOfCells();

            // 두 번째 행(index 1)부터 데이터 읽기
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row currentRow = sheet.getRow(i);
                if (currentRow == null) continue;

                Map<String, Object> rowData = new HashMap<>();
                for (int j = 0; j < columnCount; j++) {
                    String columnHeader = headerRow.getCell(j).getStringCellValue();
                    Cell cell = currentRow.getCell(j);
                    rowData.put(columnHeader, getCellValue(cell));
                }
                resultList.add(rowData);
            }
        }
        return resultList;
    }

    /**
     * 2단 헤더(그룹행 + 하위행) 엑셀을 List&lt;Map&gt; 구조로 변환한다.
     * DMF0074(Metal Link Price) 전용 — Excel Form 다운로드가 그리드 그대로 내보내는
     * 2단 헤더(1행 그룹명 병합 + 2행 원소명)를 그대로 재업로드할 수 있도록 지원한다.
     *
     * 그룹행(0)은 병합 셀이라 그룹의 첫 칸에만 값이 있고 나머지는 공란 — 좌측 값을 이어 채운다
     * (forward-fill). 하위행(1)에 값이 있으면 "{그룹}_{하위}" 를, 없으면(그룹만 있는 단일 컬럼)
     * 그룹값 그대로를 헤더키로 쓴다 — SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 토큰과 1:1.
     * 데이터는 헤더 2행 다음(인덱스 2, 엑셀 3행)부터 읽는다.
     */
    public static List<Map<String, Object>> convertExcelToJsonTwoHeaderRows(MultipartFile file) throws Exception {
        List<Map<String, Object>> resultList = new ArrayList<>();

        try (InputStream is = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            Row groupRow = sheet.getRow(0);
            Row subRow = sheet.getRow(1);
            // 그룹행은 병합 셀이라 getPhysicalNumberOfCells() 로 세면 병합 구간의 빈 셀이 누락돼
            //   실제보다 적게 잡힐 수 있다 — 두 헤더행의 getLastCellNum()(마지막 셀 인덱스+1) 중
            //   큰 값을 쓴다(빈 셀도 Cell 객체로 존재하면 포함되므로 병합에 더 안전).
            int columnCount = Math.max(
                    groupRow.getLastCellNum(),
                    subRow != null ? subRow.getLastCellNum() : 0);

            String[] columnHeaders = new String[columnCount];
            String lastGroup = "";
            for (int j = 0; j < columnCount; j++) {
                String group = getHeaderCellValue(groupRow.getCell(j));
                if (!group.isEmpty()) lastGroup = group;
                String sub = subRow != null ? getHeaderCellValue(subRow.getCell(j)) : "";
                columnHeaders[j] = sub.isEmpty() ? lastGroup : lastGroup + "_" + sub;
            }

            for (int i = 2; i <= sheet.getLastRowNum(); i++) {
                Row currentRow = sheet.getRow(i);
                if (currentRow == null) continue;

                Map<String, Object> rowData = new HashMap<>();
                for (int j = 0; j < columnCount; j++) {
                    Cell cell = currentRow.getCell(j);
                    rowData.put(columnHeaders[j], getCellValue(cell));
                }
                resultList.add(rowData);
            }
        }
        return resultList;
    }

    // 헤더 셀 문자열 추출 — 헤더는 항상 텍스트이나 병합으로 비는 셀(null)도 안전하게 처리
    private static String getHeaderCellValue(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> String.valueOf(cell.getNumericCellValue());
            default -> "";
        };
    }

    // 셀 타입별 데이터 추출 헬퍼 함수
    private static Object getCellValue(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> {
                if (DateUtil.isCellDateFormatted(cell)) yield cell.getDateCellValue();
                double d = cell.getNumericCellValue();
                // 정수는 지수표기/소수점 없이 문자열화 (예: 20260720, 777).
                //   double.toString 이면 20260720 -> "2.026072E7" 로 깨져 TO_DATE/TO_NUMBER 파싱 실패.
                if (d == Math.rint(d) && !Double.isInfinite(d)) yield String.valueOf((long) d);
                yield java.math.BigDecimal.valueOf(d).stripTrailingZeros().toPlainString();
            }
            case BOOLEAN -> cell.getBooleanCellValue();
            case FORMULA -> cell.getCellFormula();
            default -> "";
        };
    }
}
