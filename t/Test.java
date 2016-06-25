import java.util.HashMap;
import java.util.Map;
import java.net.URLEncoder;

public class Test {

    public static void main(String[] args) throws Exception {
        String china_string = URLEncoder.encode("", "UTF-8");
        String url = "http://192.168.1.71:8080/CarFormat_Server/search/getList";
        Map<String, String> map = new HashMap<String, String>();
        map.put("formatname", "老蔡农家乐");
        map.put("solr_type_id", "3");
        map.put("type_id", "2");
        map.put("endplace", "南京");
        map.put("pages", "1");
        map.put("xaxis", "1");
        map.put("yaxis", "1");
        map.put("rows", "10");
        map.put("hash", ValidateUtil.getHash(map, "CarFormat2015cxtx"));
        map.put("formatname", URLEncoder.encode("老蔡农家乐", "UTF-8"));
        map.put("endplace", URLEncoder.encode("南京", "UTF-8"));
        String parame = ValidateUtil.getContent(map, null);
        System.out.println(url+"?"+parame);
        String resultJson = HttpRequestUtil.sendGet(url+"?"+parame);
        System.out.println(resultJson);
    }
}
