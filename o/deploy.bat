F:
cd apache-tomcat-7.0.68
call F:\apache-tomcat-7.0.68\bin\shutdown.bat
rd /s/q F:\apache-tomcat-7.0.68\work\Catalina\localhost
del/s/q F:\apache-tomcat-7.0.68\webapps\
move "C:\Users\lz\Desktop\123.bat" "F:\apache-tomcat-7.0.68\webapps"
call F:\apache-tomcat-7.0.68\bin\startup.bat