package com.lgcns.nscm.framework.handler;

import java.io.InputStream;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class FileHandler extends BaseService {

   public Map<String, Object> fileUpload(MultipartFile mFile) throws Exception {

	   Map result = new HashMap<String, Object>();

	   if(saveFile(mFile)>0) {
		   result.put("code", "200");
		   result.put("message", "success");
	   } else {
		   result.put("code", "500");
		   result.put("message", "FileHandler.fileUpload fail!");
	   }

	   return result;
   }


   private int saveFile(MultipartFile mFile) throws Exception {
	   String mimeType = "unknown";
	   String extension = "unknown";

       if (mFile.getOriginalFilename().contains(".")) {
           extension = mFile.getOriginalFilename().substring(mFile.getOriginalFilename().lastIndexOf(".") + 1);
       }
       InputStream is = mFile.getInputStream();
	   mimeType = URLConnection.guessContentTypeFromStream(is);

	   Map<String, Object> param = new HashMap<String, Object>();
       param.put("fileName", mFile.getOriginalFilename());
       param.put("fileTpCd", "UPLOAD");
       param.put("fileKdnCd", "BASIC");
       param.put("ext", extension);
       param.put("ctnTp", mimeType);
       param.put("size", mFile.getSize());
       param.put("ctn", is);
       param.put("userId", "test");

	   return update("admin.file.saveFile", param);
   }

}
