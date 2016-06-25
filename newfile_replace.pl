use strict;
use UTF8;
use Encode;
use File::Find::Rule;
use File::Spec;
use File::Basename;

#my $directory = "D:\\eclipse_workspace\\ejycxtx\\src\\com\\ejycxtx";  # 目标文件夹
#my $directory = "D:\\eclipse_workspace\\CarFormat_Server\\src\\com1\\ejycxtx";
my $directory = "D:\\eclipse_workspace\\ejyshop\\src\com\\ejy";
my $old_china_string = Encode::decode_utf8("发布"); # 需要替换的汉字
my $new_china_string = Encode::decode_utf8("测试");   # 新的汉字

my $old_string = "AppBanner";     # 需要替换的字符串
my $new_string = "Message";  # 新的字符串

#切换包时输入，需要改xml里的包名
my $old_package = "app";
my $new_package = "app2";

my $springMvc = "D:\\eclipse_workspace\\CarFormat_Server\\src\\springMVC\\SqlMapConfig.xml"; # xml配置文件位置

my $springMvc_match_position = "</sqlMapConfig>"; # 匹配位置

&writeSpringMvc;                # 写xml配置文件
&write_new_file;                # 写文件

#写文件
sub write_new_file{

    my $s_old_string = lcfirst($old_string); #字符串首字母小写
    my $s_new_string  = lcfirst($new_string);

    my @files = File::Find::Rule->file()->name(qr/.*$old_string.*/)->in( $directory );

    foreach my $oldfile(@files){
        my $dir_name = dirname $oldfile;
        my $base_name = basename $oldfile;
        print "$base_name\n";
        $dir_name =~ s/$old_package/$new_package/g unless $new_package eq "";

        my $new_base_name = $base_name =~ s/$old_string/$new_string/gr;
        my $new_full_name = File::Spec->catfile($dir_name,$new_base_name);

        #打开文件
        open(my $tmp_oldfile,"<:encoding(UTF-8)",$oldfile)||die"cannot open the file: $!\n";

        mkdir $dir_name;
        #打开新文件
        open(my $tmp_newfile, ">:encoding(UTF-8)",$new_full_name) || die "open file die:$!\n";
        my @linelist=<$tmp_oldfile>;


        $linelist[0] =~ s/$old_package/$new_package/g;
        print $tmp_newfile "$linelist[0]";

        #处理不同包下的代码
        my $flag = "0";

        #向新文件写入内容
        foreach my $linelist(@linelist){
            if($flag eq "0"){
                $flag = "1";next;
            }
            $linelist =~ s/$old_string/$new_string/g;
            $linelist =~ s/$s_old_string/$s_new_string/g;
            $linelist =~ s/$old_china_string/$new_china_string/g;
            print $tmp_newfile "$linelist";
        }
        close $tmp_oldfile;
        close $tmp_newfile;
    }
}

#写xml配置文件
sub writeSpringMvc{

    my $sql_map = "    <sqlMap resource=\"/com/ejycxtx/ibatis/$new_package/$new_string.xml\" />";

    @ARGV = $springMvc;
    local $^I='.bak';
    while(<>){
        s/$springMvc_match_position/$sql_map\n$springMvc_match_position/;
        print;
    }

    #删除.bak文件
    unlink "${springMvc}.bak";
}
