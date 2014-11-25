#!/bin/bash
FTP_USERNAME=***
FTP_PASSWORD=***
FTP_ADDR=ftp://$FTP_USERNAME:$FTP_PASSWORD@deploy.winupon.com

yum -y install lftp gcc automake zlib-devel libjpeg-devel giflib-devel freetype-deve mkfontscale libtool  SDL SDL-devel

cd /usr/local/src

if [ -f estudy_trans.zip ]  ; then
        tar zxvf estudy_trans.tar.gz	
else
	lftp -c "pget -n 10 $FTP_ADDR/softwares/estudy_trans/estudy_trans_6.3.tar.gz"
	tar zxvf estudy_trans_6.3.tar.gz
	mv estudy_trans_6.3 estudy_trans
fi

##OpenOffice安装与配置
cd /usr/local/src/estudy_trans
tar -zxvf  Apache_OpenOffice_4.0.0_Linux_x86-64_install-rpm_zh-CN.tar.gz 
cd zh-CN/RPMS/
rpm -ivh  *.rpm 
cd desktop-integration/
rpm -ivh openoffice4.0-redhat-menus-4.0-9702.noarch.rpm 

/opt/openoffice4/program/soffice "-accept=socket,host=127.0.0.1,port=8100;urp;StarOffice.ServiceManager" -nologo -headless -nofirststartwizard &
ps axu|grep openoffice

echo  "/opt/openoffice4/program/soffice "-accept=socket,host=127.0.0.1,port=8100;urp;StarOffice.ServiceManager" -nologo -headless -nofirststartwizard &
" >> /etc/rc.local 

##SWFTools
cd /usr/local/src/estudy_trans
tar -xzvf  freetype-2.1.10.tar.gz
cd  freetype-2.1.10
./configure 
make &&	make install

cd /usr/local/src/estudy_trans
tar -xzvf  jpegsrc.v8c.tar.gz
cd  jpeg-8c/
./configure 
make && make install



##增加环境变量
cat >> /etc/profile <<EOF

export SWF_HOME=/usr/local/bin/pdf2swf
export XPDF_LANGUAGE_HOME=/usr/xpdf-chinese-simplified
export FFMPEG_PATH=/usr/local/ffmpeg/bin/ffmpeg
export MENCODER_PATH=/usr/local/mplayer/bin/mencoder

EOF

source /etc/profile

ldconfig  /usr/local/lib


cd /usr/local/src/estudy_trans
tar -zxvf  swftools-0.9.1.tar.gz
cd swftools-0.9.1
./configure
make
make install


##安装xp win7字体
cd /usr/local/src/estudy_trans
unzip xp.zip
unzip win7.zip
chmod 755 xp/*.*
chmod 755 win7/*.*
cp -rf xp win7 /usr/share/fonts/chinese/TrueType/

yum -y install mkfontscale

cd /usr/share/fonts/chinese/TrueType/xp
mkfontscale 
mkfontdir 
fc-cache –fv

cd /usr/share/fonts/chinese/TrueType/win7
mkfontscale
mkfontdir
fc-cache –fv

####安装xpdf中文字体
cd /usr/local/src/estudy_trans
tar -zxvf xpdf-chinese-simplified.tar.gz -C /usr/ &&
##字体：gbsn00lp.ttf和gkai00mp.ttf，放到xpdf-chinese-simplified/CMap目录下。
cp -rf gbsn00lp.ttf  gkai00mp.ttf /usr/xpdf-chinese-simplified/CMap/ &&

mv /usr/xpdf-chinese-simplified/add-to-xpdfrc  /usr/xpdf-chinese-simplified/add-to-xpdfrc.bak &&
cat >> /usr/xpdf-chinese-simplified/add-to-xpdfrc <<EOF
#----- begin Chinese Simplified support package (2011-sep-02)
cidToUnicode    Adobe-GB1       /usr/xpdf-chinese-simplified/Adobe-GB1.cidToUnicode
unicodeMap      ISO-2022-CN     /usr/xpdf-chinese-simplified/ISO-2022-CN.unicodeMap
unicodeMap      EUC-CN          /usr/xpdf-chinese-simplified/EUC-CN.unicodeMap
unicodeMap      GBK             /usr/xpdf-chinese-simplified/GBK.unicodeMap
cMapDir         Adobe-GB1       /usr/xpdf-chinese-simplified/CMap
toUnicodeDir                    /usr/xpdf-chinese-simplified/CMap
#fontFileCC     Adobe-GB1       /usr/..../gkai00mp.ttf
#----- end Chinese Simplified support package
EOF


##视频转换和截图lib库安装

cd /usr/local/src/estudy_trans
tar -xzvf  yasm-1.2.0.tar.gz &&
cd  yasm-1.2.0
./configure --enable-shared --prefix=/usr &&
make && make install &&


cd /usr/local/src/estudy_trans
tar -xzvf  lame-3.99.5.tar.gz &&
cd  lame-3.99.5
./configure --enable-shared --prefix=/usr &&
make && make install &&

cd /usr/local/src/estudy_trans
tar -xzvf  libogg-1.1.3.tar.gz &&
cd  libogg-1.1.3
./configure  --prefix=/usr &&
make && make install &&

cd /usr/local/src/estudy_trans
tar -xzvf  libvorbis-1.3.3.tar.gz &&
cd  libvorbis-1.3.3 &&
./configure  --prefix=/usr &&
make && make install &&


cd /usr/local/src/estudy_trans
tar -xzvf  xvidcore-1.3.2.tar.gz 
cd  xvidcore/build/generic 
./configure  --prefix=/usr 
make && make install 

cd /usr/local/src/estudy_trans
tar -xjvf  x264-snapshot-20120717-2245.tar.bz2 
cd  x264-snapshot-20120717-2245
./configure --enable-shared --prefix=/usr 
make && make install 

cd /usr/local/src/estudy_trans
tar -xzvf  libdts-0.0.2.tar.gz &&
cd  libdts-0.0.2
./configure  --prefix=/usr &&
make && make install &&


##视频转换和截图
cd /usr/local/src/estudy_trans
tar xvfj  ffmpeg-git-e01f478.tar.bz2&&
mv ffmpeg-git-e01f478 ffmpeg

#install
cd ffmpeg
./configure --prefix=/usr/local/ffmpeg   --enable-gpl --enable-shared --enable-libmp3lame  --enable-libvorbis  --enable-libxvid --enable-libx264  --enable-pthreads --disable-ffserver --disable-ffplay
make&& make install

#cp lib,based in x64!
cp -r /usr/local/ffmpeg/include/* /usr/include/
cp /usr/local/src/estudy_trans/ffmpeg-0.4.9-p20051120/libavcodec/libavcodec.so /usr/lib64/
cp /usr/local/src/estudy_trans/ffmpeg-0.4.9-p20051120/libavformat/libavformat.so /usr/lib64/
cp /usr/local/src/estudy_trans/ffmpeg-0.4.9-p20051120/libavutil/libavutil.so /usr/lib64/
cp –r /usr/local/ffmpeg/lib/*.* /usr/lib64/
#you can test whether the ffmpeg can run!

/usr/local/ffmpeg/bin/ffplay /usr/local/src/estudy_trans/test.wmv
#if it exports "Could not initialize SDL - No available video device",it shows successfull!

##mencoder安装与配置

cd /usr/local/src/estudy_trans
tar vjxf essential-20071007.tar.bz2
mv essential-20071007 /usr/lib/codes

unzip windows-essential-20071007.zip
mv windows-essential-20071007 /usr/lib/wincodes

cd /usr/local/src/estudy_trans
tar vjxf MPlayer-1.0rc4.tar.bz2
cd MPlayer-1.0rc4
./configure --prefix=/usr/local/mplayer/ --enable-freetype --codecsdir=/usr/lib/codes/ --libdir=/usr/lib/wincodes/ --language=zh_CN &&
make && make install

