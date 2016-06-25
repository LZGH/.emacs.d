use strict;
use UTF8;
use Encode;
use DBI;
#根据数据库字段、注释和模板生成代码

my $tab_name = "t_bill";        # 表名

my $dbname = "db_wmy";          # 数据库名

#模板类型 1:dto,2:html,3:jsrequired,4:common
my $mould_type = '1';

#dto模板
my $dto_mould = "/** 注释 **/\nprivate String column_name;";

#html模板
#新增修改页面必填字端样式
my $need_class = "<label class=\"need\"></label>";

my $html_mould = '<tr>
    <td width="100px" class="text_right td_backColor">名称：</td>
    <td ><div ><input type="text" id="column_name" placeholder="请输入虚文字" maxlength="column_length"  name="column_name" value=""/></div></td>
</tr>';

#common模板
#my $common_mould = "\$('#v_column_name').text(data.column_name);";

#my $common_mould = "column_name:{\n    required:true, \n},";
my $common_mould = "column_name:{\n    required:\"注释不能为空\", \n},";

# 数据库日期类型
#my $db_date_type = "timestamp";
my $db_date_type = "datetime";

#从数据库获取字段和注释
my @data = &get_colname_and_comment($tab_name,$dbname);

#open(my $fileName, ">","use.txt") || die "open file die:$!\n";

my @row = split(/~/,"@data");

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_column;
  if($mould_type eq "1"){
     $my_column = $dto_mould =~ s/注释/$col[1]/gr;
     $my_column =~ s/String/Date/ if "$col[2]" eq "$db_date_type";
  }elsif($mould_type eq "2"){
        if($col[3] eq "NO"){
            $my_column = $html_mould =~ s/虚文字/$col[1]/gr;
            $my_column =~ s/名称/$need_class$col[1]/g;
        }else{
            $my_column = $html_mould =~ s/名称/$col[1]/gr;
            $my_column =~ s/虚文字/$col[1]/g;
        }
        my $max_length;
        if($col[2] =~ /(\d+)/){$max_length = $1;}
        $my_column =~ s/column_length/$max_length/;
  }elsif($mould_type eq "3"){
      if($col[3] eq "NO"){
          $my_column = $common_mould =~ s/注释/$col[1]/gr;
           my $lower_name = lc($col[0]);
          $my_column =~ s/column_name/$lower_name/g;

          print "$my_column\n";
      }
  }elsif($mould_type eq "4"){
      $my_column = $common_mould =~ s/注释/$col[1]/gr;
  }
  if($mould_type != "3"){
      my $lower_name = lc($col[0]);
      $my_column =~ s/column_name/$lower_name/g;

      print "$my_column\n";
  }

}


#获取指定表名的字段名，注释，字段类型
#参数：表名
#返回值 1,字段名；2，字段注释；3，字段类型加长度；4，是否可以为空
sub get_colname_and_comment{
  #mysql查询字段语句
  my $sql = "select column_name,column_comment,column_type,is_nullable from information_schema.columns where table_name = '$_[0]' and table_schema = '$_[1]'";

  my @sql_data = &select_db($sql);
}


#访问数据库|返回逗号分隔数据的数组
#参数：sql语句
sub select_db{

  my $location = "192.168.1.151";   # 地址
  my $port = "3306";            # 端口
  my $db_user = "caojian";         # 用户名
  my $db_pass = "caojian";         # 密码;
  # my $location = "localhost";   # 地址
  # my $port = "3306";            # 端口
  # my $db_user = "root";         # 用户名
  # my $db_pass = "1234";         # 密码;
  my $database = "DBI:mysql:$dbname:$location:$port";
  my $dbh = DBI->connect($database,$db_user,$db_pass);

  $dbh->do("SET NAMES utf8");
  my $sth = $dbh->prepare($_[0]);                        #准备
  $sth->execute() or die "无法执行SQL语句:$dbh->errstr"; #执行
  my @need_data;

  while (my @data = $sth->fetchrow_array()) { #fetchrow_array返回row
    push(@need_data,"@data~");
  }

  $sth->finish();
  $dbh->disconnect; #断开数据库连接
  @need_data;
}
