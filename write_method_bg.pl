use strict;
use UTF8;
use Encode;
use File::Find::Rule;
use File::Basename;
use DBI;

#xml里dto,vo大小写，
my $directory = "F:\\eclipse_workspace\\ejycxtx\\src\\com\\ejycxtx";  # 目标文件夹
#my $directory = "F:\\eclipse_workspace\\ejyshop\\src\\com\\ejy";  # 目标文件夹
my $fileRegex = "Check";           # 目标文件
my $methodName = "getCouponState";    # 方法名
my $beanName = "Coupon";            # bean
my $methodNote = "查看优惠券是否启用状态";  # 方法注释
my $methodName2 = "getCouponAccountCount";            # 分页方法名
my $methodNote2 = "获取优惠券账户信息数目";                  # 分页注释(获取...数目)
my $argNote = "优惠券使用开关Id";
#方法类型 1:get rvo,2:insert,3:update,4:get list,5:get int, 6:get pager，7:get String
my $method_type = "2";

my $insert_id = "COUPONS_FORM_ID";           # 插入,count时的主键
my $tab_name = "T_F1_COUPONS_FORM";         # 表名

my $isUse_humpWord = "0";#0不使用 1使用

my $paramChoice = "1";#0:参数为VO 1:参数为string
my $string_alias = "coupon_state_id";#参数为string时，string别名
my $return_string_alias = "coupon_state";#$method_type为7时，返回string的别名
my $param_type;						# 参数类型
my $param_alias;					# 参数名称
my $parameterClass;					# xml参数名称


if ($paramChoice == "0") {
    $param_type = "${beanName}VO";    # 参数类型
    $param_alias = "\l${beanName}VO";  # 参数名称
    $parameterClass = "${beanName}VO";  # xml参数名称
} else {
    $param_type = "String";    # 参数类型
    $param_alias = $string_alias;  # 参数名称
    $parameterClass = "string";  # xml参数名称
}


#从数据库获取字段和注释
#my @db_data = &get_colname_and_comment($tab_name);
my @db_data = "CREATORID 创建人编号 NUMBER N~CLUB_LEVEL_ID 主键 NUMBER Y~CLUBID_PARENT 父级俱乐部编号 NUMBER Y~";
#print "@db_data\n";
#参数
my @data = "
USER_PHONE N~
COUPON_NAME N~
STATE N~";#不换行

my $param5;                     # dto塞值
my $insert_sql;                 # insert_sql
my $update_sql;                 # update_sql
my $select_sql;                 # select_sql
my $pager_sql;                  # 分页sql
#方法模板
my $actionMould;
my $serviceMould;
my $serviceImplMould;
my $daoMould;
my $daoImplMould;
my $xmlMould;

my @row = split(/~/,"@data");

my $datetime = &get_localtime;  # 获取现在时间
my $key_id = uc(&get_key_id);                # 主键(新增时主键为指定的值，否则就是数组的第一个)
$key_id =~ s/^\s+|s+$//g;

my $lowerBeanName = lcfirst($beanName);       # bean首字母小写
&get_sql;                       # 获取sql语句
&get_mould;                     # 获取代码块

&write_method;                  # 写入方法

#获取主键
sub get_key_id{
    if ($method_type == "2" || $method_type == "6") {
        return "$insert_id";
    } else {
        foreach my $row (@row) {
            $row =~ s/^ +//;              # 去除数据前的空格
            my @col = split(/ /,"$row");
            return $col[0];
        }
    }
}

#获取sql句语
sub get_sql{

    #方法注释
    my $param_mould2 = "            \@RequestParam(\"column_name\") String column_name,";
    #创建map
    my $param_mould3 = "                        \"column_name\", column_name,";
    #判断是否可以为空
    my $param_mould4 = "column_name.isEmpty() || ";
    #dto塞值
    my $param_mould5 = "        dto.setsuper_column_name(${param_alias}.getcolumn_name());";

    my $my_column1;
    my $my_column2;
    my $my_column3;
    my $my_column4;
    my $my_column5;
    my $my_column6;
    my $my_column7;

    my $lower_key_id = &get_hump_word(lc($key_id));          # 主键小写

# 数据库日期类型
    my $db_date_type = "DATE";
    my $db_price = "PRICE";
#查询时日期模板 %Y年%m月%d日 %T
    my $date_mould =  "                TO_CHAR(t.column_name, 'yyyy-MM-dd hh24:mi') AS column_name,";
    my $price_mould = "                nvl(TO_CHAR(t.column_name, 'fm9999999990.00'),'0.00') AS t.column_name,";
#查询模板
    my $select_mould = "                t.column_name,";
#更新模板
    my $where_mould =  "            <isNotEmpty  prepend=\"AND\" property=\"lower_name\">\n                t.column_name = #lower_name#\n            </isNotEmpty>";
#更新模板
    my $update_mould_must =  "            <isNotEmpty  prepend=\",\" property=\"lower_name\">\n                t.column_name = #lower_name#\n            </isNotEmpty>";
    my $update_mould = "           <isNotNull prepend=\",\" property=\"lower_name\">\n                t.column_name = #lower_name#\n            </isNotNull>";

    $insert_sql .= "<selectKey keyProperty=\"$lower_key_id\" resultClass=\"string\">
            SELECT T_F_SEQ_RECOMMENDPLAN.NEXTVAL AS $lower_key_id FROM DUAL
        </selectKey>
        <![CDATA[
            insert into $tab_name\n            (\n                $key_id,\n";
    $update_sql .= "<![CDATA[\n            update $tab_name t\n        ]]>\n        <dynamic prepend=\"set\">\n";

    foreach my $row (@row) {
        $row =~ s/^\s+|s+$//g;
        my @col = split(/ /,"$row");
        my $upper_word;
        my $hump_word;
        $hump_word = &get_hump_word(lc($col[0]));
        $upper_word = uc($col[0]);

        $my_column5 = $param_mould5 =~ s/super_column_name/\u$hump_word/gr;
        $my_column5 =~ s/column_name/\u$hump_word/g;
        $param5.= "$my_column5\n";

        $insert_sql .= "                $upper_word,\n";

        if($col[1] eq "Y"){
            $my_column6 = $update_mould =~ s/column_name/$upper_word/gr;
        }else{
            $my_column6 = $update_mould_must =~ s/column_name/$upper_word/gr;
        }

        $my_column6 =~ s/lower_name/$hump_word/g;
        $update_sql .= "$my_column6\n" unless $key_id eq $col[0];

    }

    $param5 =~ s/^ +//;

    $update_sql .= "        </dynamic>\n        <![CDATA[\n            where t.$key_id = #$lower_key_id#\n        ]]>\n";

    $insert_sql =~ s/,$//;
    $insert_sql .= "            )values(\n                #$lower_key_id#,\n";

    foreach my $row (@row) {
        $row =~ s/^ +//;              # 去除数据前的空格
        my @col = split(/ /,"$row");
        my $hump_word2 = &get_hump_word(lc($col[0]));
        $insert_sql .= "                #$hump_word2#,\n";
    }
    $insert_sql =~ s/,$//;
    $insert_sql .= "            )\n        ]]>\n";

    my @db_row = split(/~/,"@db_data");

    $select_sql .= "<![CDATA[\n            SELECT\n";

    $pager_sql .="<![CDATA[
            SELECT A.* FROM (
                SELECT B.*, ROWNUM RN FROM (
                    SELECT\n";
    if($method_type eq "6"){
        $select_sql .= "                COUNT(t.$key_id)\n";
    }
    if($method_type eq "5"){
        $select_sql .= "                COUNT(t.$key_id)\n";
    }else{
        foreach my $row (@db_row) {
            $row =~ s/^ +//;              # 去除数据前的空格
            my @col = split(/ /,"$row");
            my $my_column;
            my $upper_word2 = $col[0];
            if("$col[2]" eq $db_date_type){
                $my_column = $date_mould =~ s/column_name/$upper_word2/gr;
            }elsif(index($col[0],$db_price) != -1){
                $my_column = $price_mould =~ s/column_name/$upper_word2/gr;
            }else{
                $my_column = $select_mould =~ s/column_name/$upper_word2/gr;
            }
            $select_sql .= "$my_column\n" unless $method_type eq "6";
            $pager_sql .= "        $my_column\n";
        }
        $select_sql =~ s/,$//;
        $pager_sql =~ s/,$//;
    }
    $select_sql .= "            FROM $tab_name t\n            WHERE t.DELFLAG = 0\n        ]]>\n        <dynamic>\n";
    $pager_sql .= "            FROM $tab_name t
            WHERE t.DELFLAG = 0
        ]]>
        <dynamic>\n";
    foreach my $row (@row) {
        $row =~ s/^ +//;              # 去除数据前的空格
        my @col = split(/ /,"$row");
        my $upper_word3 = uc($col[0]);
        $my_column7 = $where_mould =~ s/column_name/$upper_word3/gr;
        my $hump_word = &get_hump_word(lc($col[0]));
        $my_column7 =~ s/lower_name/$hump_word/g;
        $select_sql .= "$my_column7\n";
        $pager_sql .= "$my_column7\n";

    }
    $select_sql .= "        </dynamic>";

    if($method_type eq "4"){
        $select_sql .= "\n        ORDER BY t.$key_id DESC";
    }

    $pager_sql .= "        </dynamic>
        <![CDATA[
            ORDER BY T.$key_id DESC ) B
            WHERE ROWNUM <= #end# ) A
        WHERE RN >= #begin#
        ]]>";


    chomp($param5);
    chomp($insert_sql);
    chomp($update_sql);

}

#获取本地时间
sub get_localtime{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
    $year += 1900; # $year是从1900开始计数的，所以$year需要加上1900；
    $mon += 1; # $mon是从0开始计数的，所以$mon需要加上1；
    my $time = sprintf ("%d-%02d-%02d %02d:%02d:%02d", $year,$mon,$mday,$hour,$min,$sec);
    return $time;
}

#获取代码块
sub get_mould{

    my $lowerFileRegex = lcfirst($fileRegex);
    my $requestType = &getRequestType; # 获取请求方式

    my $in_param;                   # 入参
    my $out_param;                  # 出参
    my $note_param;                 # 注释里的参数
    my $xml_result_class;           # xml返回值
    my $xml_sql;                    # sql语句
    my $xml_ibatis;                 # xml语句
    my $dao_sql_take;               # 接收sql返回值
    my $dao_query_type;             # 查询类型
    my $dao_sql_return;             # sql接收值（区分没有返回值）
    my $dao_return;                 # dao返回值
    my $bizImpl_code;               # serviceImpl语句
    #方法类型 1:get rvo,2:insert,3:update,4:get list,5:get int,6:get Pager

    #分页用
    my $out_param2;
    my $xml_result_class2;
    my $xml_sql2;
    my $dao_sql_take2;
    my $dao_query_type2;
    my $dao_sql_return2;
    my $dao_return2;


    if ($method_type == "1") {
        $out_param = "${beanName}RVO";
        $xml_result_class = "resultClass=\"${beanName}RVO\"";
        $xml_sql = $select_sql;
        $dao_sql_take = "rvo";
        $dao_query_type = "queryForObject";
        $dao_sql_return = "${out_param} ${dao_sql_take} \= (${beanName}RVO)";
        $bizImpl_code = "$out_param $dao_sql_take = ${lowerFileRegex}Dao.$methodName(${param_alias});
        resultVO = new ResultVO();
        resultVO.setResData(JSONObject.fromObject(rvo).toString());"
    } elsif ($method_type == "2") {
        $out_param = "void";
        $xml_ibatis = "insert";
        $xml_sql = $insert_sql;
        $dao_query_type = "insert";
    } elsif ($method_type == "3") {
        $out_param = "void";
        $xml_ibatis = "update";
        $xml_sql = $update_sql;
        $dao_query_type = "update";
    } elsif ($method_type == "4") {
        $out_param = "List<${beanName}RVO>";
        $xml_result_class = "resultClass=\"${beanName}RVO\"";
        $xml_sql = $select_sql;
        $dao_sql_take = "list";
        $dao_query_type = "queryForList";
        $dao_sql_return = "${out_param} ${dao_sql_take} \= ";
        $bizImpl_code = "$out_param $dao_sql_take = ${lowerFileRegex}Dao.$methodName(${param_alias});
        JSONObject json = new JSONObject();
        json.put(\"list\", JSONArray.fromObject(list));
        resultVO = new ResultVO();
        resultVO.setResData(json.toString());";
    } elsif($method_type == "5") {
        $out_param = "int";
        $xml_result_class = "resultClass=\"int\"";
        $xml_sql = $select_sql;
        $dao_sql_take = "count";
        $dao_query_type = "queryForObject";
        $dao_sql_return = "${out_param} ${dao_sql_take} \= ($out_param)";
        $bizImpl_code = "$out_param num = ${lowerFileRegex}Dao.$methodName(${param_alias});
        resultVO = new ResultVO();
        resultVO.setResData(JSONObject.fromObject(num).toString());";
    } elsif($method_type == "6") {

        $out_param = "List<${beanName}RVO>";
        $xml_result_class = "resultClass=\"${beanName}RVO\"";
        $xml_sql = $pager_sql;
        $dao_sql_take = "list";
        $dao_query_type = "queryForList";
        $dao_sql_return = "${out_param} ${dao_sql_take} \= ";
#分页用
        $out_param2 = "int";
        $xml_result_class2 = "resultClass=\"int\"";
        $xml_sql2 = $select_sql;
        $dao_sql_take2 = "count";
        $dao_query_type2 = "queryForObject";
        $dao_sql_return2 = "${out_param2} ${dao_sql_take2} \= ($out_param2)";
        $dao_return2 = "return count";

        $bizImpl_code = "// 获取sum
        int sum = ${lowerFileRegex}Dao.${methodName2}(${param_alias});

        ${param_alias}.getBeginEnd();
        // 获取List
        List<${beanName}RVO> list = ${lowerFileRegex}Dao.${methodName}(${param_alias});

        // 返回结果
        JSONObject json = new JSONObject();
        json.put(\"sum\", sum);
        json.put(\"list\", JSONArray.fromObject(list));
        resultVO = new ResultVO();
        resultVO.setResData(json.toString());";
    } elsif($method_type == "7") {
        $out_param = "String";
        $xml_result_class = "resultClass=\"string\"";
        $xml_sql = $select_sql;
        $dao_sql_take = $return_string_alias;
        $dao_query_type = "queryForObject";
        $dao_sql_return = "${out_param} ${dao_sql_take} \= ($out_param)";
        $bizImpl_code = "$out_param $return_string_alias = ${lowerFileRegex}Dao.$methodName(${param_alias});
        resultVO = new ResultVO();
        resultVO.setResData($return_string_alias);";
    }

    if ($method_type == "2" || $method_type == "3") {
        $in_param = "${beanName}Dto ${lowerBeanName}Dto";
        $note_param = "${lowerBeanName}Dto";
        $bizImpl_code = "${beanName}Dto dto = new ${beanName}Dto();
        $param5
        ${lowerFileRegex}Dao.$methodName(dto);
        resultVO = new ResultVO();";
    }else{
        $in_param = "${param_type} ${param_alias}";
        $note_param = "${param_alias}";
        $xml_ibatis = "select";
        $dao_return = "return $dao_sql_take;";
    }
    $serviceImplMould = "    /**
     * $methodNote
     * \@param session
     * \@param ${param_alias} $argNote
     * \@return
     * \@throws Exception
     * \@author lz
     * \@date $datetime
     */
    \@Override
    public ResultVO $methodName(HttpSession session,${param_type} ${param_alias}) throws Exception{

        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;

        $bizImpl_code

        log.info(GlobalContract.LOG_END);
        return resultVO;
    }\n";
    $daoImplMould = "    /**
     * $methodNote
     * \@param $note_param $argNote
     * \@throws SQLException
     * \@author lz
     * \@time  $datetime
     */
    \@Override
    public $out_param $methodName($in_param) throws SQLException {

        log.info(GlobalContract.LOG_BEGIN);

        ${dao_sql_return}this.getSqlMapClientTemplate().$dao_query_type(\"${lowerFileRegex}.$methodName\",$note_param);

        log.info(GlobalContract.LOG_END);
        $dao_return
    }\n";

    $daoMould = "    /**
     * $methodNote
     * \@param $note_param $argNote
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date $datetime
     */
    public $out_param $methodName($in_param) throws SQLException;\n";

    $xmlMould = "    <!-- $methodNote -->
    <$xml_ibatis id=\"$methodName\" parameterClass=\"$parameterClass\" $xml_result_class>
        $xml_sql
    </$xml_ibatis>\n";

    $actionMould = "    /**
     * $methodNote
     * \@param session
     * \@param ${param_alias} $argNote
     * \@return
     * \@author lz
     * \@date $datetime
     */
    \@ResponseBody
    \@RequestMapping(value = \"\/$methodName\")
    public String $methodName(HttpSession session,\@RequestBody ${param_type} ${param_alias}) {

        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;
        try {
            //调用业务层
             resultVO = ${lowerFileRegex}Biz.$methodName(session, ${param_alias});
        } catch (Exception e) {
            resultVO = new ResultVO(GlobalMessage.MSG_01);
            log.error(\"错误入参:\" + ${param_alias});
            log.error(e.getMessage());
            e.printStackTrace();
        }

        log.info(GlobalContract.LOG_END);
        return JSONObject.fromObject(resultVO).toString();
    }\n";

    $serviceMould = "    \/**
     * $methodNote
     * \@param session
     * \@param ${param_alias} $argNote
     * \@return
     * \@throws Exception
     * \@author lz
     * \@date $datetime
     */
    public ResultVO $methodName(HttpSession session,${param_type} ${param_alias}) throws Exception;\n";

    if($method_type == "6"){
        my $daoImplMould2 = "    /**
     * $methodNote2
     * \@param $note_param $argNote
     * \@throws SQLException
     * \@author lz
     * \@time  $datetime
     */
    \@Override
    public $out_param2 ${methodName2}($in_param) throws SQLException {

        log.info(GlobalContract.LOG_BEGIN);

        ${dao_sql_return2}this.getSqlMapClientTemplate().$dao_query_type2(\"${lowerFileRegex}.${methodName2}\",$note_param);

        log.info(GlobalContract.LOG_END);
        $dao_return2;
    }\n";

        my $daoMould2 = "    /**
     * $methodNote2
     * \@param $note_param $argNote
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date $datetime
     */
    public $out_param2 ${methodName2}($in_param) throws SQLException;\n";

        my $xmlMould2 = "\n    <!-- $methodNote2 -->
    <$xml_ibatis id=\"${methodName2}\" parameterClass=\"$parameterClass\" $xml_result_class2>
        $xml_sql2
    </$xml_ibatis>\n";

        $daoImplMould.=$daoImplMould2;
        $daoMould.=$daoMould2;
        $xmlMould.=$xmlMould2;
    }
}

#写入方法
sub write_method{

    #匹配位置
    my $match_position = "^}";
    my $xml_match_position = "</sqlMap>";

    #匹配文件
    my $actionRegex = "${fileRegex}Action\.java";
    my $serviceRegex = "${fileRegex}Biz\.java";
    my $serviceImplRegex = "${fileRegex}BizImpl\.java";
    my $daoRegex = "${fileRegex}Dao\.java";
    my $daoImplRegex = "${fileRegex}DaoImpl\.java";
    my $xmlRegex = "${fileRegex}\.xml";

    my @files = File::Find::Rule->file()->name(qr/.*$fileRegex.*/)->in( $directory );

    local $^I='.bak';
    @ARGV = @files;

    while(<>){
        my $filename = basename($ARGV);
        if($filename =~ /$actionRegex/){
            s/$match_position/$actionMould\n}/;
        }elsif($filename =~ /$serviceRegex/){
            s/$match_position/$serviceMould\n}/;
        }elsif($filename =~ /$serviceImplRegex/){
            s/$match_position/$serviceImplMould\n}/;
        }elsif($filename =~ /$daoRegex/){
            s/$match_position/$daoMould\n}/;
        }elsif($filename =~ /$daoImplRegex/){
            s/$match_position/$daoImplMould\n}/;
        }elsif($filename =~ /$xmlRegex/){
            s/$xml_match_position/$xmlMould\n$xml_match_position/;
        }
        print;
    }

    #删除.bak文件
    my @files_bat = File::Find::Rule->file() ->name('*.bak')->in( $directory );
    unlink @files_bat;
}

#获取请求方式
sub getRequestType{
    if($method_type == "2" || $method_type=="3"){
        return "POST";
    }else{
        return "GET";
    }
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
    if($isUse_humpWord == '1'){
        print $result;
        return lcfirst($result);
    }else{
        return $_[0]
    }

}

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
