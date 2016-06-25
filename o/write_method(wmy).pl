use strict;
use UTF8;
use Encode;
use File::Find::Rule;
use File::Basename;


#向文件中写入方法

my $directory = "F:\\wmy_cms";  # 目标文件夹
my $fileRegex = ".*TestTemp.*";    # 目标文件

my $methodName = "getCeShiSum";            # 方法名
my $beanName = "TestTemp";            # bean
my $lowerBeanName = lcfirst($beanName);       # bean首字母小写
my $methodNote = "获取对象数目";    # 方法注释
#方法类型 1:get rvo,2:insert,3:update,4:get list,5,get int
my $method_type = "5";

#方法模板
my $actionMould;
my $serviceMould;
my $serviceImplMould;
my $daoMould;
my $daoImplMould;
my $xmlMould;

$actionMould = "    /**
     * $methodNote
     * \@param session
     * \@param request
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    \@ResponseBody
    \@RequestMapping(value = \"\/$methodName\", method = RequestMethod.POST)
    public String $methodName(HttpSession session, \@RequestBody ${beanName}VO ${lowerBeanName}VO) {

        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;

        try {
            //调用业务层
            resultVO = i$beanName.$methodName(${lowerBeanName}VO);
        } catch (Exception e) {
            e.printStackTrace();
            resultVO = new ResultVO(GlobalMessage.MSG_01);
            log.error(\"错误参数：\" + JSONObject.fromObject(${lowerBeanName}VO).toString());
            log.error(\"错误信息：\" + e.getMessage());
        }

            log.info(GlobalContract.LOG_END);
            return JSONObject.fromObject(resultVO).toString();
    }";


$serviceMould = "    \/**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    ResultVO $methodName(${beanName}VO ${lowerBeanName}VO) throws Exception;";


if($method_type eq "1"){
    $serviceImplMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    \@Override
    public ResultVO $methodName(${beanName}VO ${lowerBeanName}VO) throws Exception{
        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = new ResultVO();
        ${beanName}RVO rvo = ${lowerBeanName}Dao.$methodName(${lowerBeanName}VO);
        resultVO.setResData(JSONObject.fromObject(rvo).toString());
        log.info(GlobalContract.LOG_END);
        return resultVO;
    }";
    $daoMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    ${beanName}RVO $methodName(${beanName}VO ${lowerBeanName}VO) throws SQLException;;";
    $daoImplMould = "    daoImpl";
    $xmlMould = "    <!-- $methodNote -->
    <select id=\"$methodName\" resultMap=\"${beanName}RVO\">

    </select>";
}elsif($method_type eq "2"){

    $serviceImplMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    \@Override
    public ResultVO $methodName(${beanName}VO ${lowerBeanName}VO) throws Exception{
        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;
        int sum = ${lowerBeanName}Dao.$methodName(${lowerBeanName}VO);
        resultVO = new ResultVO();
        if (sum == 0) {
            resultVO.setSuccess(false);
        }

        log.info(GlobalContract.LOG_END);
        return resultVO;
    }";
    $daoMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date 2015年12月10日
     */
    int $methodName(${beanName}VO ${lowerBeanName}VO) throws SQLException;";
    $daoImplMould = "    daoImpl";
    $xmlMould = "    <!-- $methodNote -->
    <insert id=\"$methodName\" useGeneratedKeys=\"true\" keyProperty=\"image_id\">

    </insert>";
}elsif($method_type eq "3"){


    $serviceImplMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    \@Override
    public ResultVO $methodName(${beanName}VO ${lowerBeanName}VO) throws Exception{
        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;
        int sum = ${lowerBeanName}Dao.$methodName(${lowerBeanName}VO);
        resultVO = new ResultVO();
        if (sum == 0) {
                resultVO.setSuccess(false);
        }

        log.info(GlobalContract.LOG_END);
        return resultVO;
    }";
    $daoMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date 2015年12月10日
     */
    int $methodName(${beanName}VO ${lowerBeanName}VO) throws SQLException;";
    $daoImplMould = "    daoImpl";
    $xmlMould = "    <!-- $methodNote -->
    <update id=\"$methodName\">

    </update>";
}elsif($method_type eq "4"){


    $serviceImplMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@author lz
     * \@date 2015年12月10日
     */
    \@Override
    public ResultVO $methodName(${beanName}VO ${lowerBeanName}VO) throws Exception{
        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;

        List<OrderMessageRVO> list = ${lowerBeanName}Dao.$methodName(orderMessageVO);

        // 返回数据
        JSONObject json = new JSONObject();
        json.put(\"list\", JSONArray.fromObject(list));
        resultVO = new ResultVO();
        resultVO.setResData(json.toString());

        log.info(GlobalContract.LOG_END);
        return resultVO;
    }";
    $daoMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date 2015年12月10日
     */
    List<${beanName}RVO> get${beanName}List(${beanName}VO ${lowerBeanName}VO) throws SQLException;";
    $daoImplMould = "    daoImpl";
    $xmlMould = "    <!-- $methodNote -->
    <select id=\"get${beanName}List\" resultMap=\"${beanName}RVO\">

    </select>";
}elsif($method_type eq "5"){


    $serviceImplMould = "    /**
     * $methodNote
     * \@param repairOrderVO
     * \@return
     * \@throws Exception
     * \@author lz
     * \@date 2015年12月23日
     */
    \@Override
    public ResultVO $methodName() throws Exception {
        log.info(GlobalContract.LOG_BEGIN);
        ResultVO resultVO = null;
        resultVO = new ResultVO();

        int num = ${lowerBeanName}Dao.$methodName();
        MemoVO memoVO = new MemoVO();
        // 返回数据
        JSONObject json = new JSONObject();
        json.put(\"num\", num);

        resultVO.setResData(json.toString());
        log.info(GlobalContract.LOG_END);
        return resultVO;
    }";
    $daoMould = "    /**
     * $methodNote
     * \@param ${lowerBeanName}VO
     * \@return
     * \@throws SQLException
     * \@author lz
     * \@date 2015年12月10日
     */
    int $methodName(${beanName}VO ${lowerBeanName}VO) throws SQLException;";
    $daoImplMould = "    daoImpl";
    $xmlMould = "    <!-- $methodNote -->
    <select id=\"$methodName\" resultType=\"int\">

    </select>";
}

#匹配文件
my $actionRegex = ".*Action\.java";
my $serviceRegex = "^I.*";
my $serviceImplRegex = ".*Impl\.java";
my $daoRegex = ".*Dao.java";
my $daoImplRegex = ".*DaoImpl.java";
my $xmlRegex = ".*\.xml";

#匹配位置
my $match_position = "^}";
my $xml_match_position = "<\/mapper>";

my @files = File::Find::Rule->file()->name(qr/$fileRegex/)->in( $directory );
local $^I='.bak';
@ARGV = @files;
print @files;

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
        s/$xml_match_position/$xmlMould\n<\/mapper>/;
    }
    print;
}


#删除.bak文件

my @files_bat = File::Find::Rule->file() ->name('*.bak')->in( $directory );

unlink @files_bat;
