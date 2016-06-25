use strict;
use UTF8;
use Encode;
use File::Find::Rule;

#my $directory = "D:\\eclipse_workspace\\ejycxtx\\src\\com\\ejycxtx";  # 目标文件夹
#my $directory = "D:\\eclipse_workspace\\CarFormat_Server\\src\\com\\ejycxtx";
my $directory = "D:\\eclipse_workspace\\ejyshop\\src\\com\\ejy";  # 目标文件夹
my $regex = ".*";      # 目标文件
#my $old_string = Encode::decode_utf8("陈旭");     # 需要替换的字符串
my $old_string = "package com.ejycxtx.controller.format;";
my $new_string = "package com.ejy.action.format.manage;";# 新字符串

#find all the  files in @INC
my @files = File::Find::Rule->file()->name(qr/$regex/)->in( $directory );
local $^I='.bak';
@ARGV = @files;
while(<>){
    s/$old_string/$new_string/g;
    print;
}


#删除.bak文件

my @files_bat = File::Find::Rule->file() ->name('*.bak')->in( $directory );

unlink @files_bat;
