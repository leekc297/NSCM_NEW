package com.lgcns.nscm.framework.utils;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class StringUtilsTest {

    @Nested
    @DisplayName("숫자 변환 테스트")
    class NumberParsingTests {

        @Test
        @DisplayName("Double 변환: null이나 빈 값은 0을 반환해야 함")
        void parseStringToDouble_ShouldReturnZeroForEmptyOrNull() {
            assertThat(StringUtils.parseStringToDouble(null)).isEqualTo(0.0);
            assertThat(StringUtils.parseStringToDouble("")).isEqualTo(0.0);
        }

        @Test
        @DisplayName("Double 변환: 정상적인 문자열 숫자를 double로 변환")
        void parseStringToDouble_ShouldConvertCorrectValue() {
            assertThat(StringUtils.parseStringToDouble("123.45")).isEqualTo(123.45);
            assertThat(StringUtils.parseStringToDouble(100)).isEqualTo(100.0);
        }

        @Test
        @DisplayName("Int 변환: 소수점이 포함된 경우 반올림하여 int로 변환")
        void parseStringToInt_ShouldRoundValue() {
            assertThat(StringUtils.parseStringToInt("10.5")).isEqualTo(11);
            assertThat(StringUtils.parseStringToInt("10.4")).isEqualTo(10);
            assertThat(StringUtils.parseStringToInt(null)).isEqualTo(0);
        }

        @Test
        @DisplayName("Long 변환: 정상적인 숫자를 long으로 변환")
        void parseStringToLong_ShouldConvertCorrectValue() {
            assertThat(StringUtils.parseStringToLong("123456789")).isEqualTo(123456789L);
            assertThat(StringUtils.parseStringToLong("")).isEqualTo(0L);
        }
    }

    @Nested
    @DisplayName("문자열 포맷 및 URL 변환 테스트")
    class StringFormatTests {

        @ParameterizedTest
        @CsvSource({
            "123, '#,##0'",
            "123.4, '#,##0.0'",
            "123.456, '#,##0.000'"
        })
        @DisplayName("소수점 자릿수에 따른 포맷 문자열 생성 확인")
        void parsePointFormat_ShouldReturnCorrectFormat(String input, String expected) {
            assertThat(StringUtils.parsePointFormat(input)).isEqualTo(expected);
        }

        @Test
        @DisplayName("URL을 SQL ID 형태로 변환하며 'stream'은 제외")
        void makeSqlIdFromUrl_ShouldConvertPathAndExcludeStream() {
            // Case 1: 기본 변환
            String url1 = "/api/user/list";
            assertThat(StringUtils.makeSqlIdFromUrl(url1)).isEqualTo("api.user.list");

            // Case 2: 마지막이 stream인 경우 제외
            String url2 = "/api/data/fetch/stream";
            assertThat(StringUtils.makeSqlIdFromUrl(url2)).isEqualTo("api.data.fetch");

            // Case 3: 대소문자 구분 없이 stream 제외 확인
            String url3 = "/v1/export/STREAM";
            assertThat(StringUtils.makeSqlIdFromUrl(url3)).isEqualTo("v1.export");

            // Case 4: 빈 경로 처리
            assertThat(StringUtils.makeSqlIdFromUrl("///")).isEmpty();
        }
    }
}
