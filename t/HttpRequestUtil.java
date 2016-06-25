import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;


public class HttpRequestUtil {

        public static String sendGet(String url) {
                String result = "";
                BufferedReader in = null;
                try {
                        URL realUrl = new URL(url);

                        URLConnection connection = realUrl.openConnection();

                        connection.setRequestProperty("accept", "*/*");
                        connection.setRequestProperty("connection", "Keep-Alive");
                        connection.setRequestProperty("user-agent",
                                        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
                        connection.setRequestProperty("Accept-Charset", "UTF-8");
                        connection.setRequestProperty("contentType", "UTF-8");

                        connection.connect();
                        in = new BufferedReader(new InputStreamReader(
                                        connection.getInputStream(), "utf-8"));
                        String line;
                        while ((line = in.readLine()) != null) {
                                result += line;
                        }
                } catch (Exception e) {

                        result = "{\"resCode\":\"1\",\"errCode\":\"1001\",\"resData\":\"\"}";
                        e.printStackTrace();
                }

                finally {
                        try {
                                if (in != null) {
                                        in.close();
                                }
                        } catch (Exception e2) {
                                e2.printStackTrace();
                        }
                }

                return result;
        }

        public static String sendPost(String url, String param) {

                PrintWriter out = null;
                BufferedReader in = null;
                String result = "";
                try {
                        URL realUrl = new URL(url);

                        URLConnection conn = realUrl.openConnection();

                        conn.setRequestProperty("accept", "*/*");
                        conn.setRequestProperty("connection", "Keep-Alive");
                        conn.setRequestProperty("user-agent",
                                        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
                        conn.setRequestProperty("Accept-Charset", "UTF-8");
                        conn.setRequestProperty("contentType", "UTF-8");

                        conn.setDoOutput(true);
                        conn.setDoInput(true);

                        out = new PrintWriter(conn.getOutputStream());

                        out.print(param);

                        out.flush();

                        in = new BufferedReader(
                                        new InputStreamReader(conn.getInputStream()));
                        String line;
                        while ((line = in.readLine()) != null) {
                                result += line;
                        }
                } catch (Exception e) {

                        result = "{\"resCode\":\"1\",\"errCode\":\"1001\",\"resData\":\"\"}";
                        e.printStackTrace();
                }

                finally {
                        try {
                                if (out != null) {
                                        out.close();
                                }
                                if (in != null) {
                                        in.close();
                                }
                        } catch (IOException ex) {
                                ex.printStackTrace();
                        }
                }

                return result;
        }

        public static String sendFile(String url, String param,
                        BufferedInputStream bInputStream) {

                BufferedOutputStream out = null;
                BufferedReader in = null;
                String result = "";
                try {
                        URL realUrl = new URL(url);

                        URLConnection conn = realUrl.openConnection();

                        conn.setRequestProperty("accept", "*/*");
                        conn.setRequestProperty("connection", "Keep-Alive");
                        conn.setRequestProperty("user-agent",
                                        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
                        conn.setRequestProperty("Accept-Charset", "UTF-8");
                        conn.setRequestProperty("contentType", "multipart/form-data");


                        conn.setDoOutput(true);
                        conn.setDoInput(true);

                        StringBuffer sb = new StringBuffer();
                        sb = sb.append(param);
                        byte[] paramData = sb.toString().getBytes();
                        System.out.println(paramData.length);

                        out = new BufferedOutputStream(conn.getOutputStream());
                        out.write(paramData);

                        if (bInputStream != null) {
                                byte[] data = new byte[2048];
                                while (bInputStream.read(data) != -1) {
                                        out.write(data);
                                }
                        }

                        out.flush();

                        in = new BufferedReader(
                                        new InputStreamReader(conn.getInputStream()));
                        String line;
                        while ((line = in.readLine()) != null) {
                                result += line;
                        }
                } catch (Exception e) {

                        result = "{\"resCode\":\"1\",\"errCode\":\"1001\",\"resData\":\"\"}";
                        e.printStackTrace();
                }

                finally {
                        try {
                                if (out != null) {
                                        out.close();
                                }
                                if (in != null) {
                                        in.close();
                                }
                                if (bInputStream != null) {
                                        bInputStream.close();
                                }
                        } catch (IOException ex) {
                                ex.printStackTrace();
                        }
                }

                return result;
        }
}
