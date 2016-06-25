use strict;
use Encode;
use Win32::OLE;

#use Win32::OLE::Const 'Microsoft.Word';    # wd  constants
#use Win32::OLE::Const 'Microsoft Office';  # mso constants

#参数
my @data = "
releaseId 编队ID N~
userId 用户ID N~";

my @row = split(/~/,"@data");

my $fontName = encode("gbk", decode("utf8", "微软雅黑"));
my $fontSize = encode("gbk", decode("utf8", "五号"));

my $application = CreateObject Win32::OLE 'Word.Application' or die $!;
$application->{'Visible'} = 1;
my $document = $application->Documents->Add;
my $selection = $application->Selection;
#$selection->Font->{'Name'} = $fontName;
#$selection->Font->{'Size'} = $fontSize;

#$selection -> TypeText($fontName);
#$selection -> TypeParagraph;

my $t_row = @row;
my $t_col = 3;
my $table = $document->Tables->Add($selection->Range,$t_row, $t_col);

$table->Select();

#(样式，上下边框，第一行背景色，第一行是否加粗 颜色，线条颜色，倒数第二条线斜体，倒数第二条线，第一条竖线，最后一列头加粗，)
$table->AutoFormat(26,1,0,1,1,1,0,0,1,1);
$table->Range->Font->{Size} = "11";
$table->Range->Font->{Name} = $fontName;


my $line;
for (my $var = 0; $var < @row; $var++) {
    $line = $row[$var];
    $line =~ s/^\s+|s+$//g;    # 去除数据前的空格
    my @col = split(/ /,"$line");
    for (my $var2 = 0; $var2 < @col; $var2++) {
        $table->Cell($var+1,$var2+1)->Range->{Text} = encode("gbk", decode("utf8", $col[$var2]));
    }
}



#$document->saveas('C:\\Users\\Admin\\Desktop\\ceshi.doc');
#$word->quit()
