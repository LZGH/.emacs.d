use strict;
use UTF8;
use Encode;
use DBI;
binmode(STDIN, ':encoding(utf8)');

binmode(STDOUT, ':encoding(utf8)');

binmode(STDERR, ':encoding(utf8)');
#根据数据库字段、注释和模板生成代码

my $tab_name = "T_F1_COUPONS_FORM";        # 表名

#模板类型 1:dto,2:html,3:jsrequire,4:common(vo)
my $mould_type = '4';

#dto模板
my $dto_mould = "/** 注释 **/\nprivate String column_name;";

#html模板
#新增修改页面必填字端样式
my $need_class = "<span style=\"color: red\">* </span>";

my $utf_string_html = Encode::decode_utf8("请输入");         # 新的汉字

# my $html_mould = "<tr>
#     <td width=\"150px\" class=\"text-right td_backColor\">名称:</td>
#     <td ><div ><input type=\"text\" class=\"form-control\" id=\"column_name\" placeholder=\"$utf_string_html虚文字\" maxlength=\"column_length\"  name=\"column_name\" value=\"\"/></div></td>
# </tr>";
my $html_mould = "<tr>
    <td width=\"150px\" class=\"text-right td_backColor\">名称:</td>
    <td ><span id=\"v_column_name\"></span></td>
</tr>";

my $utf_string1 = Encode::decode_utf8("不能为空"); # 解决乱码

#common模板
#my $common_mould = "\$('#v_column_name').text(data.column_name);";
#my $common_mould = "\$('#a_column_name').val(data.column_name);";

#my $common_mould = "* \@param column_name					注释";

#my $common_mould = "\@RequestParam(\"column_name\") String column_name,";
#my $common_mould = "\"column_name\", column_name,";
#my $common_mould = "dto\.setcolumn_name(map.get(\"column_name\"));";
my $common_mould = "\$(\"#l_column_name\").text(data.column_name);";

#my $common_mould = "column_name:{\n    required:true, \n},";
#my $common_mould = "column_name:{\n    required:\"注释$utf_string1\", \n},";
#my $common_mould = "<th>注释</th>";
#vo模板
#my $common_mould = "/** 注释 **/\nprivate String column_name;";
# 数据库日期类型

my $db_date_type = "DATE";

#从数据库获取字段和注释
my @data = &get_colname_and_comment($tab_name);
#@data = lc("@data");
#@data = "id 主键 number 22 n~ bannerType 类型【0：默认（不可点击）；1：html链接（可点击）；2：推荐线路】 varchar2 1 n~ bannerImg 图片 varchar2 50 n~ bannerUrl url varchar2 50 y~ formatId 线路编号 number 22 y~ sort 排序 number 22 y~ createDate 创建时间 date 7 n~";

#open(my $fileName, ">:encoding(UTF-8)","use.txt") || die "open file die:$!\n";

my @row = split(/~/,"@data");

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_column;
  if($mould_type eq "1"){
     $my_column = $dto_mould =~ s/注释/$col[1]/gr;
     $my_column =~ s/String/Date/ if "$col[2]" eq "$db_date_type";
  }elsif($mould_type eq "2"){
        if($col[4] eq "N"){
            $my_column = $html_mould =~ s/虚文字/$col[1]/gr;
            $my_column =~ s/名称/$need_class$col[1]/g;
        }else{
            $my_column = $html_mould =~ s/名称/$col[1]/gr;
            $my_column =~ s/虚文字/$col[1]/g;
        }

        $my_column =~ s/column_length/$col[3]/;
  }elsif($mould_type eq "3"){
      if($col[4] eq "N"){
          $my_column = $common_mould =~ s/注释/$col[1]/gr;
          my $hump_word = &get_hump_word(lc($col[0]));
          $my_column =~ s/column_name/$hump_word/g;
          print "$my_column\n";
          #print $fileName "$my_column\n";
      }
  }elsif($mould_type eq "4"){
      $my_column = $common_mould =~ s/注释/$col[1]/gr;
  }
  if($mould_type != "3"){
      my $hump_word = &get_hump_word(lc($col[0]));
      $my_column =~ s/column_name/$hump_word/g;
      print "$my_column\n";
      #print $fileName "$my_column\n";
  }

}

#获取指定表名的字段名，注释，字段类型
#参数：表名
#返回值 1,字段名；2，字段注释；3，字段类型,4,字段长度，5是否可以为空
sub get_colname_and_comment{

  #oracle查询字段语句
  my $sql = "select t.COLUMN_NAME,(select c.comments from user_col_comments c where c.table_name = t.TABLE_NAME and c.column_name = t.COLUMN_NAME) as comments,t.DATA_TYPE,t.DATA_LENGTH,t.NULLABLE from user_tab_columns t where t.table_name = '$tab_name'";
  my @sql_data = &select_db($sql);
  #断开数据库连接
}

#访问数据库~返回逗号分隔数据的数组
#参数：sql语句
sub select_db{

  my $dbname = "192.168.1.151:1521/TESTDATA";       # 数据库名
  my $db_user = "test";         # 用户名
  my $db_pass = "test2015";         # 密码
  my $database = "DBI:Oracle://$dbname";
  my $dbh = DBI->connect($database,$db_user,$db_pass,{ora_charset => 'AL32UTF8'});

  my $sth = $dbh->prepare($_[0]);                        #准备
  $sth->execute() or die "无法执行SQL语句:$dbh->errstr"; #执行
  my @need_data;
  while (my @data = $sth->fetchrow_array()) { #fetchrow_array返回row
    push(@need_data,"@data~");
  }
  $sth->finish();
  $dbh->disconnect;
  @need_data;
}

# 获取驼峰字符串
sub get_hump_word{

    my $wordFile = "word.txt";
    #打开文件
    open(my $tmp_file,"<:encoding(UTF-8)",$wordFile)||die"cannot open the file: $!\n";
    my @linelist=<$tmp_file>;
    my @wordList;

    foreach my $linelist(@linelist){
        chomp(@linelist);
        push(@wordList,split(/,/,$linelist));
    }
    my @word = grep  {$_[0] =~ /$_/ }  @wordList;
    my $result = $_[0];
    foreach my $word (@word){
        my $uc_first_word = ucfirst($word);
        $result =~ s/$word/$uc_first_word/g;
    }
    close $tmp_file;
    return lcfirst($result);

}
