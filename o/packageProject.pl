use strict;
use UTF8;
use Archive::Zip;

# 打包项目
my $locTom = "F:\\apache-tomcat-7.0.68\\webapps\\ejycxtx"; # 本地tomcat路径
my $todoFile1 = "F:\\ejy\\jdbc.properties";                 # 需替换的文件1
my $todoLoc1 = "WEB-INF\\classes\\com\\ejycxtx\\springmvc\\jdbc.properties"; # 文件1目标地址
my $todoFile2 = "F:\\ejy\\commonAjax.js";                 # 需替换的文件2
my $todoLoc2 = "js\\common\\commonAjax.js";#文件2目标地址
my $zip = Archive::Zip->new();
$zip->addTree( "$locTom");
$zip->addFile( "$todoFile1", "$todoLoc1");
$zip->addFile( "$todoFile2", "$todoLoc2");
#$zip->addTree( 'F:\apache-tomcat-7.0.68\webapps\examples', 'examples' );

$zip->writeToFileNamed('C:\Users\Admin\Desktop\ejycxtx.war');
