REM IN x64 DEBUG MODE ONLY

SET YourSiteAppPath="D:\Dev\YourSiteApp\YourSiteApp\bin\x64\Debug\AppX"

REM copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_system-vc140-mt-gd-1_59.dll %YourSiteAppPath%
REM copy D:\Dev\boost_1_59_0\lib64-msvc-14.0\boost_thread-vc140-mt-gd-1_59.dll %YourSiteAppPath%

REM copy D:\gstreamer\1.0\x86_64\bin\libffi-6.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libglib-2.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libgmodule-2.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libgobject-2.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libgstapp-1.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libgstbase-1.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libgstreamer-1.0-0.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libintl-8.dll %YourSiteAppPath%
REM copy D:\gstreamer\1.0\x86_64\bin\libwinpthread-1.dll %YourSiteAppPath%

copy D:\Dev\JSunchained\x64\Debug\JSunchained\JSunchained.dll %YourSiteAppPath%
copy D:\Dev\JSunchained\x64\Debug\Unchained\Unchained.dll %YourSiteAppPath%

mkdir D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained
mkdir D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained\Properties
copy D:\Dev\JSunchained\Unchained\Properties D:\Dev\JSunchained\Unchained\bin\x64\Debug\Unchained\Properties
