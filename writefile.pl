use strict;
use UTF8;
use Encode;
use File::Find::Rule;
use File::Spec;
use File::Basename;

binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $need = "2";   #0:ejytxtx ; 1:ejyshop , 2:interface

my $fileName = "Check";                          # 文件名
my $packageName = "format";                               # 包名
my $code = Encode::decode_utf8("审核线路信息");     # 注释

my $write_type = "0";           # 0:all 1:dao

my $vo = "1";  #0：不需要，1：需要
my $rvo = "0";
my $dto = "0";

my @write_file;

#寻找路径
my $old_package;
my $old_class;
if($need == "0"){
    $old_package = "app";
    $old_class = "AppBanner";
}elsif($need == "1"){
    $old_package = "format";
    $old_class = "ClubPoint";
}elsif($need == "2"){
    $old_package = "app";
    $old_class = "AppBanner";
}

# 类名
my $class_name;
if($need == "0"){
    $class_name = "Action";
}elsif($need == "1"){
    $class_name = "Action";
}elsif($need == "2"){
    $class_name = "Controller"
}

if($vo == "1"){
    push(@write_file,"${old_class}VO.java");
}
if($rvo == "1"){
    push(@write_file,"${old_class}RVO.java");
}
if($dto == "1"){
    push(@write_file,"${old_class}Dto.java");
}


if($write_type == "0"){
    push(@write_file,"${old_class}${class_name}.java");
    push(@write_file,"${old_class}Biz.java");
    push(@write_file,"${old_class}BizImpl.java");
}
push(@write_file,"${old_class}Dao.java");
push(@write_file,"${old_class}DaoImpl.java");
push(@write_file,"${old_class}.xml");


#目标文件夹
my $directory;
if($need == "0"){
    $directory = "F:\\eclipse_workspace\\ejycxtx\\src\\com\\ejycxtx";
}elsif($need == "1"){
    $directory = "F:\\eclipse_workspace\\ejyshop\\src\\com\\ejy"
}elsif($need == "2"){
    $directory = "F:\\eclipse_workspace\\CarFormat_Server\\src\\com\\ejycxtx"
}

# xml配置文件位置
my $springMvc;
if($need == "0"){
    $springMvc = "F:\\eclipse_workspace\\ejycxtx\\src\\com\\ejycxtx\\springmvc\\SqlMapConfig.xml";
}elsif($need == "1"){
    $springMvc = "F:\\eclipse_workspace\\ejyshop\\src\\springmvc\\SqlMapConfig.xml"
}elsif($need == "2"){
    $springMvc = "F:\\eclipse_workspace\\CarFormat_Server\\src\\springMVC\\SqlMapConfig.xml"
}

my $springMvc_match_position = "</sqlMapConfig>"; # 匹配位置

#方法模板
my $actionMould;
my $serviceMould;
my $serviceImplMould;
my $daoMould;
my $daoImplMould;
my $xmlMould;
my $VOMould;
my $RVOMould;
my $DtoMould;
&get_mould;                     # 获取模板
&write_method;                  # 写文件
&writeSpringMvc;                # 写xml配置文件

#写xml配置文件
sub writeSpringMvc{

    my $pre_package;
    if($need == "0"){
        $pre_package = "/com/ejyextx";
    }elsif($need == "1"){
        $pre_package = "/com/ejy"
    }elsif($need == "2"){
        $pre_package = "/com/ejyextx"
    }


    my $sql_map = "    <sqlMap resource=\"${pre_package}/ibatis/$packageName/$fileName.xml\" />";

    @ARGV = $springMvc;
    local $^I='.bak';
    while(<>){
        s/$springMvc_match_position/$sql_map\n$springMvc_match_position/;
        print;
    }

    #删除.bak文件
    unlink "${springMvc}.bak";
}

#写文件
sub write_method{

    #打开xml配置文件
    open(my $tmp_xmlfile, ">>:encoding(UTF-8)",$springMvc) || die "open file die:$!\n";

    my @files = File::Find::Rule->file()->name(@write_file)->in( $directory );

    foreach my $oldfile(@files){
        my $dir_name = dirname $oldfile;
        my $base_name = basename $oldfile;

        $dir_name =~ s/$old_package/$packageName/g;

        my $new_base_name = $base_name =~ s/$old_class/$fileName/gr;
        my $new_full_name = File::Spec->catfile($dir_name,$new_base_name);

        print "$new_full_name\n";
        mkdir $dir_name;
        #打开新文件
        open(my $tmp_newfile, ">:encoding(UTF-8)",$new_full_name) || die "open file die:$!\n";
        #print "$dir_name\n";
        if($new_full_name =~ /(${class_name}\.java)$/){
            print $tmp_newfile "$actionMould";
        }elsif($new_full_name =~ /(BizImpl\.java)$/){
            print $tmp_newfile "$serviceImplMould";
        }elsif($new_full_name =~ /(Biz\.java)$/){
            print $tmp_newfile "$serviceMould";
        }elsif($new_full_name =~ /(DaoImpl\.java)$/){
            print $tmp_newfile "$daoImplMould";
        }elsif($new_full_name =~ /(Dao\.java)$/){
            print $tmp_newfile "$daoMould";
        }elsif($new_full_name =~ /(xml)$/){
            print $tmp_newfile "$xmlMould";
        }elsif($new_full_name =~ /(${fileName}VO\.java)$/){
            print $tmp_newfile "$VOMould";
        }elsif($new_full_name =~ /(${fileName}RVO\.java)$/){
            print $tmp_newfile "$RVOMould";
        }elsif($new_full_name =~ /(Dto\.java)$/){
            print $tmp_newfile "$DtoMould";
        }
        close $tmp_newfile;
    }
}

#获取代码块
sub get_mould{
    my $lower_fileName  = lcfirst($fileName);
    my $datetime = &get_localtime;  # 获取现在时间
    #中文转码
    my $log = Encode::decode_utf8("日志");
    my $interface = Encode::decode_utf8("接口");
    # 包名
    my $pre_package;
    if($need == "0"){
        $pre_package = "com.ejycxtx";
    }elsif($need == "1"){
        $pre_package = "com.ejy"
    }elsif($need == "2"){
        $pre_package = "com.ejycxtx"
    }
    # 包名
    my $pre_package2;
    if($need == "0"){
        $pre_package2 = "controller";
    }elsif($need == "1"){
        $pre_package2 = "action";
    }elsif($need == "2"){
        $pre_package2 = "controller"
    }

    $actionMould = "package ${pre_package}.${pre_package2}.${packageName};

import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import ${pre_package}.biz.${packageName}.${fileName}Biz;

/**
 * ${code} ${class_name}
 * \@author lz
 * \@time $datetime
 */
\@Controller
\@RequestMapping(value = \"/${lower_fileName}\", produces = { \"application/json;charset=UTF-8\" })
public class ${fileName}${class_name} {

    /** $log */
    private static final Logger log = Logger.getLogger(${fileName}${class_name}.class);

    /** ${code}biz  */
    \@Resource(name = \"${lower_fileName}Biz\")
    private ${fileName}Biz ${lower_fileName}Biz;

}";
    $serviceMould = "package ${pre_package}.biz.${packageName};

/**
 * ${code} biz
 * \@author lz
 * \@time $datetime
 */
public interface ${fileName}Biz {

}";
    $serviceImplMould = "package ${pre_package}.biz.${packageName}.impl;

import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import ${pre_package}.biz.${packageName}.${fileName}Biz;
import ${pre_package}.dao.${packageName}.${fileName}Dao;

/**
 * ${code} bizImpl
 * \@author lz
 * \@time $datetime
 */
\@Service(\"${lower_fileName}Biz\")
public class ${fileName}BizImpl implements ${fileName}Biz{

    /** $log */
    private static final Logger log = Logger.getLogger(${fileName}BizImpl.class);

    /** ${code}Dao $interface */
    \@Resource(name = \"${lower_fileName}Dao\")
    private ${fileName}Dao ${lower_fileName}Dao;

}";

    $daoMould = "package ${pre_package}.dao.${packageName};

/**
 * ${code} dao
 * \@author lz
 * \@time $datetime
 */
public interface ${fileName}Dao {


}";
    $daoImplMould = "package ${pre_package}.dao.${packageName}.impl;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;
import ${pre_package}.base.BaseSqlMap;
import ${pre_package}.dao.${packageName}.${fileName}Dao;

/**
 * ${code} daoImpl
 * \@author lz
 * \@time $datetime
 */
\@Repository(\"${lower_fileName}Dao\")
\@SuppressWarnings({ \"deprecation\", \"unchecked\" })
public class ${fileName}DaoImpl extends BaseSqlMap implements ${fileName}Dao {

    /** $log */
    private static final Logger log = Logger.getLogger(${fileName}DaoImpl.class);

}

";
    my $xml_need = "";

    if($vo == "1"){
        $xml_need .= "    <typeAlias alias=\"${fileName}VO\" type=\"${pre_package}.vo.${packageName}.${fileName}VO\"/>\n";
    }
    if($rvo == "1"){
        $xml_need .= "    <typeAlias alias=\"${fileName}RVO\" type=\"${pre_package}.rvo.${packageName}.${fileName}RVO\"/>\n";
    }
    if($dto == "1"){
        $xml_need .= "    <typeAlias alias=\"${fileName}Dto\" type=\"${pre_package}.dto.${packageName}.${fileName}Dto\"/>\n";
    }

    $xmlMould = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE sqlMap PUBLIC \"-//iBATIS.com//DTD SQL Map 2.0//EN\" \"http://ibatis.apache.org/dtd/sql-map-2.dtd\">
<sqlMap namespace=\"${lower_fileName}\">
${xml_need}
</sqlMap>";

    $VOMould = "package ${pre_package}.vo.${packageName};

import ${pre_package}.vo.PagesVO;

/**
 * ${code} VO
 * \@author lz
 * \@time $datetime
 */
public class ${fileName}VO extends PagesVO {


}";

    $RVOMould = "package ${pre_package}.rvo.${packageName};

/**
 * ${code} RVO
 * \@author lz
 * \@time $datetime
 */
public class ${fileName}RVO {


}";

    $DtoMould = "package ${pre_package}.dto.${packageName};

/**
 * ${code} dto
 * \@author lz
 * \@time $datetime
 */
public class ${fileName}Dto {


}";

}

#获取本地时间
sub get_localtime{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    $year += 1900; # $year是从1900开始计数的，所以$year需要加上1900；
    $mon += 1; # $mon是从0开始计数的，所以$mon需要加上1；
    my $time = sprintf ("%d-%02d-%02d %02d:%02d:%02d", $year,$mon,$mday,$hour,$min,$sec);
    return $time;
}
