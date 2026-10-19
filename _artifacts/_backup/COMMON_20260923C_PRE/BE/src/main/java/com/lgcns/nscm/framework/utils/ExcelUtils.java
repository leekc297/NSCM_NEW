package com.lgcns.nscm.framework.utils;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.*;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
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

                Map<String, Object> rowData = new LinkedHashMap<>(); // 26.09.22 컬럼 순서 보존 (헤더 오류 안내 시 파일 순서로 나열)
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
     * 2단 병합 헤더 엑셀(AS-IS 양식)을 List<Map> 으로 변환한다. 2단 헤더가 아니면 null 을 돌려준다.
     *
     * <p>AS-IS 양식은 1행 = 단일 컬럼명(1~2행 세로 병합) 또는 그룹명(가로 병합), 2행 = 그룹 하위명이다
     * (예: DMF0074 'Key' 아래 Ni/Co/…). 하위명은 그룹마다 반복되므로 1행만 키로 쓰면 컬럼을 구분할 수 없다.
     * 그래서 컬럼 키를 "그룹명_하위명"(하위명 없으면 1행 값)으로 합성한다.
     *
     * <p>판정 = HEADER_CONTENT 토큰과 일치하는 키 수가 1단(1행 그대로) 해석보다 **많을 때만** 2단으로 본다.
     * 1단 양식을 쓰는 기존 화면은 1단 해석이 이미 전 토큰과 일치하므로 이 경로를 타지 않는다.
     *
     * <p>2단 경로의 값 규칙: 2행·중간 빈 행은 공란 행으로 위치 보존(끝의 빈 행만 제외) / 정수값 숫자 셀은 소수점 없이
     * ('202607.0' 이 되면 SP 의 Plan Date 6자리·기간 정수 검증에서 탈락한다).
     *
     * @param file       업로드 엑셀
     * @param targetKeys SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 토큰
     */
    public static List<Map<String, Object>> convertGroupedHeaderExcelToJson(MultipartFile file, String[] targetKeys) throws Exception {
        try (InputStream is = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            Row topRow = sheet.getRow(0);
            Row subRow = sheet.getRow(1);
            if (topRow == null || subRow == null) return null;

            int columnCount = Math.max(topRow.getLastCellNum(), subRow.getLastCellNum());
            if (columnCount <= 0) return null;

            Set<String> tokens = new HashSet<>();
            for (String tk : targetKeys) tokens.add(tk.trim());

            List<String> flatKeys = new ArrayList<>();
            List<String> groupedKeys = new ArrayList<>();
            for (int j = 0; j < columnCount; j++) {
                String top = mergedText(sheet, 0, j);
                // 1~2행 세로 병합 셀의 2행은 1행 값이 되풀이되므로 하위명으로 보지 않는다.
                String sub = isSameMergedRegion(sheet, 0, 1, j) ? "" : mergedText(sheet, 1, j);
                flatKeys.add(cellText(topRow.getCell(j)));
                groupedKeys.add(sub.isEmpty() ? top : top + "_" + sub);
            }

            if (countMatches(groupedKeys, tokens) <= countMatches(flatKeys, tokens)) return null;

            // ⭐ 행 위치 보존 — 반환 목록의 n번째 = 엑셀 (n+2)행 (1행 = 호출측 @TITLE).
            //   2행(하위 헤더)과 빈 행도 전 컬럼 공란 행으로 싣는다. 스테이징 UPLOAD_ID 순서가 엑셀 물리 행과
            //   1:1 이어야 결과 목록의 EXCEL_ROW(PR_GET_EXCEL_UPLOAD_RESULT) 가 실제 엑셀 행 번호가 된다.
            //   공란 행은 검증 SP 가 SKIP 처리한다 (P_DMF0074_EXCEL_UPLOAD B2 'SKIP EMPTY LINE').
            List<Map<String, Object>> resultList = new ArrayList<>();
            resultList.add(blankRow(groupedKeys));
            for (int i = 2; i <= sheet.getLastRowNum(); i++) {
                Row currentRow = sheet.getRow(i);
                if (currentRow == null) {
                    resultList.add(blankRow(groupedKeys));
                    continue;
                }

                Map<String, Object> rowData = new LinkedHashMap<>(); // 26.09.22 컬럼 순서 보존 (헤더 오류 안내 시 파일 순서로 나열)
                for (int j = 0; j < columnCount; j++) {
                    String key = groupedKeys.get(j);
                    if (key.isEmpty()) continue;
                    rowData.put(key, cellText(currentRow.getCell(j)));
                }
                resultList.add(rowData);
            }
            // 끝의 공란 행은 버린다 (서식만 남은 행) — 중간 공란 행은 위치 보존을 위해 유지.
            while (resultList.size() > 1 && isBlankRow(resultList.get(resultList.size() - 1))) {
                resultList.remove(resultList.size() - 1);
            }
            return resultList;
        }
    }

    private static Map<String, Object> blankRow(List<String> keys) {
        Map<String, Object> row = new LinkedHashMap<>(); // 26.09.22 컬럼 순서 보존 (헤더 오류 안내 시 파일 순서로 나열)
        for (String key : keys) if (!key.isEmpty()) row.put(key, "");
        return row;
    }

    private static boolean isBlankRow(Map<String, Object> row) {
        for (Object v : row.values()) if (v != null && !v.toString().isEmpty()) return false;
        return true;
    }

    private static int countMatches(List<String> keys, Set<String> tokens) {
        Set<String> matched = new HashSet<>();
        for (String k : keys) if (tokens.contains(k)) matched.add(k);
        return matched.size();
    }

    // 병합 영역 안의 셀이면 영역 좌상단 값을 돌려준다 (가로 병합 그룹명을 하위 컬럼 전부에 적용).
    private static String mergedText(Sheet sheet, int rowIdx, int colIdx) {
        for (CellRangeAddress region : sheet.getMergedRegions()) {
            if (region.isInRange(rowIdx, colIdx)) {
                Row r = sheet.getRow(region.getFirstRow());
                return r == null ? "" : cellText(r.getCell(region.getFirstColumn()));
            }
        }
        Row r = sheet.getRow(rowIdx);
        return r == null ? "" : cellText(r.getCell(colIdx));
    }

    private static boolean isSameMergedRegion(Sheet sheet, int rowA, int rowB, int colIdx) {
        for (CellRangeAddress region : sheet.getMergedRegions()) {
            if (region.isInRange(rowA, colIdx) && region.isInRange(rowB, colIdx)) return true;
        }
        return false;
    }

    // 셀 값을 문자열로 — 정수값 숫자 셀은 소수점 없이(3.0 → "3"), 그 외 숫자는 원형 유지.
    private static String cellText(Cell cell) {
        if (cell == null) return "";
        CellType type = cell.getCellType() == CellType.FORMULA ? cell.getCachedFormulaResultType() : cell.getCellType();
        switch (type) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) return new DataFormatter().formatCellValue(cell).trim();
                BigDecimal bd = BigDecimal.valueOf(cell.getNumericCellValue()).stripTrailingZeros();
                return bd.scale() <= 0 ? bd.toBigInteger().toString() : bd.toPlainString();
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
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
