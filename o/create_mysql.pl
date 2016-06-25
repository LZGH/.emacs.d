use strict;
use UTF8;
use Encode;
use DBI;
#根据数据库字段、注释和模板生成代码

my $tab_name = "t_company_machine_tool";        # 表名

my $dbname = "db_wmy";          # 数据库名

#查询模板
my $mould = "    t.column_name,";
#更新模板
my $update_mould =  "    <if test=\"lower_name != '' and lower_name != null\">\n        t.column_name = #{lower_name},\n    </if>";
# 数据库日期类型
#my $db_date_type = "timestamp";
my $db_date_type = "datetime";

#查询时日期模板 %Y年%m月%d日 %T
my $date_mould = "    DATE_FORMAT(t.column_name,'%Y年%m月%d日') AS column_name,";

my $key_id = "";                # 主键
my $lower_key_id = "";          # 主键小写

#从数据库获取字段和注释
my @data = &get_colname_and_comment($tab_name,$dbname);

my @row = split(/~/,"@data");

#获取主键
foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  $key_id = $col[0];
  $lower_key_id = lc($col[0]);
  last;
}


#打印语句
print "<!-----------查询语句:------------------>\n";
my $select_sql;
$select_sql .= "SELECT\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_column;
  if("$col[2]" eq $db_date_type){
     $my_column = $date_mould =~ s/column_name/$col[0]/gr;
  }else{
     $my_column = $mould =~ s/column_name/$col[0]/gr;
  }
  $select_sql .= "$my_column\n";
}
$select_sql =~ s/,$//;
$select_sql .= "FROM $tab_name t\nWHERE t.DELFLAG = 0\n";

print $select_sql;

print "<!-----------新增语句：-------------------->\n";
my $insert_sql;
$insert_sql .= "insert into $tab_name\n    (\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  $insert_sql .= "        $col[0],\n" unless $key_id eq $col[0];
}
$insert_sql =~ s/,$//;

$insert_sql .= "    )values(\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_lower_column = lc($col[0]);
  $insert_sql .= "        #{$my_lower_column},\n" unless $key_id eq $col[0];;
}
$insert_sql =~ s/,$//;
$insert_sql .= ")\n";
print $insert_sql;


print "<!-----------修改语句：-------------------->\n";
my $update_sql;
$update_sql .= "update $tab_name t\n<set>\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_column;
  $my_column = $update_mould =~ s/column_name/$col[0]/gr;
  my $my_lower_column = lc($col[0]);
  $my_column =~ s/lower_name/$my_lower_column/g;
  $my_column = (split(/[\n]/s, $my_column))[1] if $col[3] eq"YES";
  $update_sql .= "$my_column\n" unless $key_id eq $col[0];
}
$update_sql .= "<set>\n<where>\n    t.DELFLAG = 0\n    AND t.$key_id = #$lower_key_id#\n</where>\n";
print $update_sql;


#获取指定表名的字段名，注释，字段类型
#参数：表名
#返回值 1,字段名；2，字段注释；3，字段类型；4，是否可以为空
sub get_colname_and_comment{
  #mysql查询字段语句
  my $sql = "select column_name,column_comment,data_type,is_nullable from information_schema.columns where table_name = '$_[0]' and table_schema = '$_[1]'";

  my @sql_data = &select_db($sql);

}


#访问数据库|返回逗号分隔数据的数组
#参数：sql语句
sub select_db{

  my $location = "192.168.1.151";   # 地址
  my $port = "3306";            # 端口
  my $db_user = "caojian";         # 用户名
  my $db_pass = "caojian";         # 密码;
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
