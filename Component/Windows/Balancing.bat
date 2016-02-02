REM IN x64 DEBUG MODE #####################################################

SET YourSiteAppPath="D:\Dev\YourSiteApp\YourSiteApp\bin\x64\Debug\AppX"

copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_system-vc140-mt-gd-1_59.dll %YourSiteAppPath%
copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_thread-vc140-mt-gd-1_59.dll %YourSiteAppPath%

REM copy C:\gstreamer\1.0\x86_64\bin\libffi-6.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libglib-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgmodule-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgobject-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstapp.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstapp-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstbase-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstjpeg.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstreamer-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstvideo-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideoconvert.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libintl-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libjpeg-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\liborc-0.4-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libwinpthread-1.dll %YourSiteAppPath%

copy D:\Dev\JSunchained\x64\Debug\JSunchained\JSunchained.dll %YourSiteAppPath%
copy D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained.dll %YourSiteAppPath%

mkdir D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained
mkdir D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained\Properties
copy D:\Dev\JSunchained\Unchained\Properties D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained\Properties


REM IN x86 DEBUG MODE #####################################################

SET YourSiteAppPath="D:\Dev\YourSiteApp\YourSiteApp\bin\x86\Debug\AppX"

REM copy D:\Dev\boost_1_59_0\lib32-msvc-14.0\boost_system-vc140-mt-gd-1_59.dll %YourSiteAppPath%
REM copy D:\Dev\boost_1_59_0\lib32-msvc-14.0\boost_thread-vc140-mt-gd-1_59.dll %YourSiteAppPath%

REM copy C:\gstreamer\1.0\x86\bin\libffi-6.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libglib-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgmodule-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgobject-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\lib\gstreamer-1.0\libgstapp.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgstapp-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgstbase-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\lib\gstreamer-1.0\libgstjpeg.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgstreamer-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libgstvideo-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\lib\gstreamer-1.0\libgstvideoconvert.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libintl-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libjpeg-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\liborc-0.4-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86\bin\libwinpthread-1.dll %YourSiteAppPath%

copy D:\Dev\JSunchained\Debug\JSunchained\JSunchained.dll %YourSiteAppPath%
copy D:\Dev\JSunchained\Unchained\bin\x86\Debug\Unchained.dll %YourSiteAppPath%

mkdir D:\Dev\JSunchained\Unchained\bin\x86\Debug\Unchained
mkdir D:\Dev\JSunchained\Unchained\bin\x86\Debug\Unchained\Properties
copy D:\Dev\JSunchained\Unchained\Properties D:\Dev\JSunchained\Unchained\bin\x86\Debug\Unchained\Properties


REM IN x64 RELEASE MODE #####################################################

SET YourSiteAppPath="D:\Dev\YourSiteApp\YourSiteApp\bin\x64\Release\AppX"

REM copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_system-vc140-mt-1_59.dll %YourSiteAppPath%
REM copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_thread-vc140-mt-1_59.dll %YourSiteAppPath%

REM copy C:\gstreamer\1.0\x86_64\bin\libffi-6.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libglib-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgmodule-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgobject-2.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstapp.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstapp-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstbase-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstjpeg.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstreamer-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libgstvideo-1.0-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideoconvert.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libintl-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libjpeg-8.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\liborc-0.4-0.dll %YourSiteAppPath%
REM copy C:\gstreamer\1.0\x86_64\bin\libwinpthread-1.dll %YourSiteAppPath%

copy D:\Dev\JSunchained\x64\Release\JSunchained\JSunchained.dll %YourSiteAppPath%
copy D:\Dev\JSunchained\Unchained\bin\x64\Release\Unchained.dll %YourSiteAppPath%

mkdir D:\Dev\JSunchained\Unchained\bin\x64\Release\Unchained
mkdir D:\Dev\JSunchained\Unchained\bin\x64\Release\Unchained\Properties
copy D:\Dev\JSunchained\Unchained\Properties D:\Dev\JSunchained\Unchained\bin\x64\Release\Unchained\Properties
