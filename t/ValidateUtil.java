import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.Map;
import java.util.Map.Entry;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;


public class ValidateUtil {


        public static Map<String, String> getMap(String... params)
                        throws Exception {

                Map<String, String> map = new HashMap<String, String>(params.length / 2);
                for (int i = 0, length = params.length; i < length;) {
                        map.put(params[i], params[i + 1]);
                        i += 2;
                }
                return map;
        }

        public static String getParams(String... params) {

                StringBuffer sb = new StringBuffer();
                for (int i = 0, j = params.length; i < j;) {
                        sb.append("&".concat(params[i]).concat("=").concat(params[i+1]));
                        i += 2;
                }
                return sb.toString().replaceFirst("&", "");
        }


        public static String getHash(Map<String, String> params, String salt)
                        throws IOException {

                Map<String, Object> sortedParams = new TreeMap<String, Object>(params);
                Set<Entry<String, Object>> entrys = sortedParams.entrySet();


                StringBuilder basestring = new StringBuilder();
                for (Entry<String, Object> param : entrys) {
                        basestring.append(param.getValue());
                }
                basestring.append(salt);
                byte[] bytes = null;
                try {
                        MessageDigest md5 = MessageDigest.getInstance("MD5");

                        bytes = md5.digest(basestring.toString().getBytes("UTF-8"));
                } catch (GeneralSecurityException ex) {
                        throw new IOException(ex);
                }

                StringBuilder sign = new StringBuilder();
                for (int i = 0; i < bytes.length; i++) {
                        String hex = Integer.toHexString(bytes[i] & 0xFF);
                        if (hex.length() == 1) {
                                sign.append("0");
                        }
                        sign.append(hex);
                }

                return sign.toString();
        }


        public static String getContent(Map<String, String> params,
                        List<String> excludeParamNames) {
                List<String> keys = new ArrayList<String>(params.keySet());
                Collections.sort(keys);
                StringBuffer prestr = new StringBuffer(200);

                boolean first = true;
                String key = null;
                for (int i = 0; i < keys.size(); i++) {
                        key = (String) keys.get(i);
                        if (params.get(key) == null) {
                                continue;
                        }
                        String value = params.get(key);
//			if (StringUtils.isBlank(value)) {
//				continue;
//			}
                        if (excludeParamNames != null && excludeParamNames.contains(key)) {
                                continue;
                        }
                        if (first) {
                                prestr.append(key).append("=").append(value);
                                first = false;
                        } else {
                                prestr.append("&").append(key).append("=").append(value);
                        }
                }
                return prestr.toString();
        }
}
