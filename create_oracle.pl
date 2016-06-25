use strict;
use UTF8;
use Encode;
use DBI;
#根据数据库字段、注释和模板生成代码

my $tab_name = "T_F1_INTERESTED";        # 表名

#查询模板
my $mould = "    t.column_name,";
#更新模板
my $update_mould_must =  "    <isNotEmpty  prepend=\",\" property=\"lower_name\">\n        t.column_name = #lower_name#\n    </isNotEmpty>";
my $update_mould = "    <isNotNull prepend=\",\" property=\"lower_name\">\n        t.column_name = #lower_name#\n    </isNotNull>";
# 数据库日期类型
#my $db_date_type = "timestamp";
my $db_date_type = "DATE";
my $db_price = "PRICE";

#查询时日期模板 %Y年%m月%d日 %T
my $date_mould = "    TO_CHAR(t.column_name, 'yyyy-MM-dd hh24:mi') AS column_name,";
my $price_mould = "    nvl(TO_CHAR(t.column_name, 'fm9999999990.00'),'0.00') AS t.column_name,";

my $key_id = "";                # 主键
my $lower_key_id = "";          # 主键小写

#从数据库获取字段和注释
my @data = &get_colname_and_comment($tab_name);

#print @data;

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
  }elsif(index($col[0],$db_price) != -1){
     $my_column = $price_mould =~ s/column_name/$col[0]/gr;
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
  $insert_sql .= "        $col[0],\n";
}
$insert_sql =~ s/,$//;

$insert_sql .= "    )values(\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $hump_word = &get_hump_word(lc($col[0]));
  $insert_sql .= "        #$hump_word#,\n" unless $key_id eq $col[0];
}
$insert_sql =~ s/,$//;
$insert_sql .= ")\n";
print $insert_sql;


print "<!-----------修改语句：-------------------->\n";
my $update_sql;
$update_sql .= "<![CDATA[\n    update $tab_name t\n]]>\n<dynamic prepend=\"set\">\n";

foreach my $row (@row) {
  $row =~ s/^ +//;              # 去除数据前的空格
  my @col = split(/ /,"$row");
  my $my_column;
  if($col[3] eq "Y"){
      $my_column = $update_mould =~ s/column_name/$col[0]/gr;
  }else{
      $my_column = $update_mould_must =~ s/column_name/$col[0]/gr;
  }
  my $hump_word = &get_hump_word(lc($col[0]));
  $my_column =~ s/lower_name/$hump_word/g;
  $update_sql .= "$my_column\n" unless $key_id eq $col[0];
}
$update_sql .= "</dynamic>\n<![CDATA[\n    where t.$key_id = #$lower_key_id#\n]]>\n";
print $update_sql;


#获取指定表名的字段名，注释，字段类型
#参数：表名
#返回值 1,字段名；2，字段注释；3，字段类型；4，是否可以为空
sub get_colname_and_comment{

  #oracle查询字段语句
  my $sql = "select t.COLUMN_NAME,(select c.comments from user_col_comments c where c.table_name = t.TABLE_NAME and c.column_name = t.COLUMN_NAME) as comments,t.DATA_TYPE,t.NULLABLE from user_tab_columns t where t.table_name = '$tab_name'";
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
