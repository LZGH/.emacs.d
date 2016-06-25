use strict;
use UTF8;
use File::Find::Rule;

my $directory = "D:\\eclipse_workspace\\CarFormat_Server\\src\\com\\ejycxtx\\controller";

my $class = "search";
my $method = "getList";
my $over = '\@RequestParam\(\"hash\"\)';                  # 匹配结束位置

my @array = &get_param;         # 获取变量
print "@array";

my $test_code = &get_code_mould;
&write_file;

#写入文件
sub write_file{
    my $java_file = "F:\\emacs\\t\\Test.java";
    open(my $fh, ">:encoding(UTF-8)", $java_file)|| die "open file die:$!\n";
    print $fh $test_code;
}

#获取代码块
sub get_code_mould{
    my $requestType = pop(@array);
    my $requestMould;
    if($requestType eq "POST"){
        $requestMould = "String resultJson = HttpRequestUtil.sendPost(url,parame);";
    }else{
        if(@array){
            $requestMould = "String resultJson = HttpRequestUtil.sendGet(url+\"?\"+parame);";
        }else{
            $requestMould = "String resultJson = HttpRequestUtil.sendGet(url);";
        }
    }
    my $china_string = Encode::decode_utf8("测试");   # 汉字
    my $code_mould = "import java.util.HashMap;
import java.util.Map;
import java.net.URLEncoder;

public class Test {

    public static void main(String[] args) throws Exception {
        String china_string = URLEncoder.encode(\"\", \"UTF-8\");
        String url = \"http://192.168.1.60:8080/CarFormat_Server/$class/$method\";
        Map<String, String> map = new HashMap<String, String>();\n";

    foreach my $param (@array) {
        $code_mould.="        map.put(\"$param\", \"\");\n";
    }
    if(@array){
        $code_mould.="        map.put(\"hash\", ValidateUtil.getHash(map, \"CarFormat2015cxtx\"));\n";
    }
    $code_mould.="        //map.put(\"$array[0]\", URLEncoder.encode(\"$china_string\", \"UTF-8\"));
        String parame = ValidateUtil.getContent(map, null);
        System.out.println(url+\"?\"+parame);
        $requestMould
        System.out.println(resultJson);
    }
}";
    return $code_mould;
}

#获取变量
sub get_param{
    my $Class = ucfirst($class);
    my @files = File::Find::Rule->file()->name(qr/^$Class.*/)->in( $directory );

    #打开文件
    open(my $fh,"<:encoding(UTF-8)",$files[0])||die"cannot open the file: $!\n";

    local $/=undef;
    my $linelist=<$fh>;

    my @matched;
    if($linelist =~ /$method\(([\d\D]*?)$over/){
        my $tmp = $1 =~ s/[\n]//gr;
        @matched = ( $tmp =~ /\"([^\"]+?)\"/g);#取""内容
    }
    if($linelist =~ /$method.*RequestMethod\.(\S+)\)/){
        push(@matched,$1);
    }
    close $fh;
    return @matched;
}
