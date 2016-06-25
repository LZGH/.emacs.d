use strict;
use UTF8;
use Encode;
use DBI;

#从数据库获取字段和注释

my $tab_name = "T_F1_MESSAGE_BOARD";        # 表名
my @data = &get_colname_and_comment($tab_name);
print @data;
#获取指定表名的字段名，注释，字段类型
#参数：表名
#返回值 1,字段名；2，字段注释；3，是否可以为空
sub get_colname_and_comment{

  #oracle查询字段语句
  my $sql = "select t.COLUMN_NAME,(select c.comments from user_col_comments c where c.table_name = t.TABLE_NAME and c.column_name = t.COLUMN_NAME) as comments,t.NULLABLE from user_tab_columns t where t.table_name = '$tab_name'";
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
