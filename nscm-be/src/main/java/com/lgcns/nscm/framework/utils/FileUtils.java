package com.lgcns.nscm.framework.utils;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.lgcns.nscm.framework.property.CommonProperties;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings("useed")
@Component
public class FileUtils {

    private final String filePath;

    public FileUtils (CommonProperties commonProperties) {
    	this.filePath = commonProperties.getFile().getPath();
    }

    /**
     * @MethodName : makeZipFileFromFileList
     * @Description: fileInfoList 리스트에 정보를 읽어와서 FILE_UPLOAD_PATH 경로아래
     *               년월일폴더에 zip파일로 저장한다.
     *               fileInfoList 키
     *               			fileSeq : Int
     *               			savedFilePath : String
     *               			originalFileName : String
     * <pre>
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param req
     * @param      : @param fileInfoList
     * @param      : @param FILE_UPLOAD_PATH
     * @param      : @return
     * @param      : @throws Exception
     * @return     : Map<String,Object>
     */
    @SuppressWarnings("useed")
    public static Map<String, Object> makeZipFileFromFileList(HttpServletRequest req, List<Map<String, Object>> fileInfoList, String FILE_UPLOAD_PATH) throws Exception {

        Map<String, Object> returnMap = new HashMap<>();
        if (fileInfoList != null && !fileInfoList.isEmpty()) {

            Date today = new Date();
            SimpleDateFormat year = new SimpleDateFormat("yyyy");
            SimpleDateFormat month = new SimpleDateFormat("MM");
            SimpleDateFormat day = new SimpleDateFormat("dd");
            String newFileName = UUID.randomUUID().toString();
            String savedSubPath = year.format(today) + month.format(today) + day.format(today);

            File chekExistsFile;
            ZipOutputStream zipOS = null;
            FileInputStream subFileinputstream = null;
            try {
                returnMap.put("savedFilePath", savedSubPath);
                returnMap.put("savedFileName", newFileName + ".zip");

                String savePath = FILE_UPLOAD_PATH + File.separator + savedSubPath;

                File file = new File(savePath);

                boolean existsPath ;

                if (!file.exists()) {
                    existsPath = file.mkdirs();
                }
                else{
                    existsPath = true;
                }
                if (existsPath) {

                    zipOS = new ZipOutputStream(new FileOutputStream(savePath + File.separator + newFileName + ".zip"));
//                    byte[] buffer = new byte[1024];
//                    FileInputStream in = null;


                    for (Map<String, Object> p : fileInfoList) {


                        if (p.get("fileSeq").toString().equalsIgnoreCase("0")) {
                            chekExistsFile = new File(FILE_UPLOAD_PATH + File.separator + p.get("savedFilePath").toString() + File.separator + p.get("savedFileName").toString());
                            boolean deleteFlag = false;
                            if (chekExistsFile.exists()) {
                                deleteFlag = chekExistsFile.delete();
                            }

                        }
                        else {
                            String subFilePath = FILE_UPLOAD_PATH + File.separator + p.get("savedFilePath").toString() + File.separator + p.get("savedFileName").toString();


                            File subFile = new File(subFilePath);
                            if (subFile.exists()) {
                                subFileinputstream = new FileInputStream(subFile);


                                ZipEntry zipSubEntry = new ZipEntry(p.get("originalFileName").toString());

                                zipOS.putNextEntry(zipSubEntry);

                                byte[] bytes = new byte[1024];

                                int length;

                                while ((length = subFileinputstream.read(bytes)) >= 0) {

                                    zipOS.write(bytes, 0, length);

                                }
                                subFileinputstream.close();
                                zipOS.closeEntry();


                            }
                        }
                    }
                }

            }
            catch (IOException ex) {
                log.debug(ex.getMessage());
            }
            finally {

                chekExistsFile = null;
                if (zipOS != null) {
                    zipOS.close();
                }
                if (subFileinputstream !=null){
                    subFileinputstream.close();
                }
                subFileinputstream = null;

                zipOS = null;
            }

        }

        return returnMap;
    }



    /**
     * list 형식으로 정보 return
     * @param mpRequest  : mpRequest
     * @return uploadFile : uploadFile
     * @throws Exception : Exception
     */

    /**
     * @MethodName : uploadFile
     * @Description:
     * <pre>
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param mpRequest
     * @param      : @return
     * @param      : @throws Exception
     * @return     : Map<String,Object>
     */
    public Map<String, Object> uploadFile(MultipartHttpServletRequest mpRequest) throws Exception{

        Iterator<String> iterator = mpRequest.getFileNames();

        MultipartFile multipartFile;
        String originalFileName;
        String originalFileExtension;
        String storedFileName;

        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> listMap;
        Map<String, Object> rtnMap = new HashMap<String, Object>();

        File file = new File(filePath);

        boolean isPath;
        if(!file.exists()) {
            isPath = file.mkdirs();
        }
        else{
            isPath = true;
        }

        if (isPath) {
            while (iterator.hasNext()) {
                multipartFile = mpRequest.getFile(iterator.next());
                assert multipartFile != null;
                if (!multipartFile.isEmpty()) {
                    originalFileName = multipartFile.getOriginalFilename();
                    assert originalFileName != null;
                    originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    storedFileName = getRandomString() + originalFileExtension;

                    file = new File(filePath + storedFileName);

                    multipartFile.transferTo(file);
                    listMap = new HashMap<>();
                    listMap.put("ORG_FILE_NAME", originalFileName);
                    listMap.put("STORED_FILE_NAME", storedFileName);
                    listMap.put("FILE_SIZE", multipartFile.getSize());
                    listMap.put("FILE_PATH", filePath);

                    list.add(listMap);

                }
            }
        }
        rtnMap.put("fileList", list);
        return rtnMap;
    }

    public static String getRandomString() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    /**
     *
     * @param request : request
     * @param response : response
     * @param paramMap : paramMap
     */
    public void downloadFile(HttpServletRequest request, HttpServletResponse response, Map<String, Object> paramMap){
        String path = filePath;
        String name = (String)paramMap.get("name");

        File file = new File(path);

        FileInputStream fileInputStream = null;
        ServletOutputStream servletOutputStream = null;

        try{
            String downName;
            String browser = request.getHeader("User-Agent");
            //파일 인코딩
            if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){//브라우저 확인 파일명 encode
                downName = URLEncoder.encode(name, StandardCharsets.UTF_8).replaceAll("\\+", "%20");
            }else{
                downName = new String(name.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
            }

            response.setHeader("Content-Disposition","attachment;filename=\"" + downName+"\"");
            response.setContentType("application/octer-stream");
            response.setHeader("Content-Transfer-Encoding", "binary;");

            fileInputStream = new FileInputStream(file);
            servletOutputStream = response.getOutputStream();

            byte[] b = new byte[1024];
            int data ;

            while((data=(fileInputStream.read(b, 0, b.length))) != -1){
                servletOutputStream.write(b, 0, data);
            }

            servletOutputStream.flush();//출력

        }catch (Exception e) {
        	log.error(e.getMessage());

        }finally{
            if(servletOutputStream!=null){
                try{
                    servletOutputStream.close();
                }catch (IOException e){
                	log.error(e.getMessage());
                }
            }
            if(fileInputStream!=null){
                try{
                    fileInputStream.close();
                }catch (IOException e){
                	log.error(e.getMessage());
                }
            }
        }
    }
}
