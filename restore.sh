#/usr/bin/bash

# ////////////////////////////////////////////////////
# EE SANDBOX RESTORE
# by Ryan Irelan, Mijingo, LLC 
# http://eeinsider.com
# http://eescreencasts.com
# http://mijingo.com
# http://ryanirelan.com
# ////////////////////////////////////////////////////

# *******************************************************
# Please Read: 
# BY USING THIS SCRIPT YOU ASSUME ALL RESPONSIBILITY FOR 
# ITS USE AND ABSOLVE MIJINGO, LLC OF ANY LIABILITY AND/OR 
# RESPONSIBILITY OF ANY KIND. USE AT YOUR OWN RISK. 
# *******************************************************


# ----------------------------------------------------
# SET THE FOLLOWING VARIABLES TO FIT YOUR LOCAL SYSTEM
# ----------------------------------------------------            

# MySQL Settings
mysql_username='root'      
mysql_password='root'
database='eesandbox'
#-------------------------

# Where you keep your files used for restoring (sql file and tar.gz file)
restore_files_location='/Users/ryan/projects/code/default-ee' # no trailing slash

# the name of your sandbox directory
sandbox_name='eesandbox'

# Where you want the restore installed
destination='/Users/ryan/Sites' # no trailing slash

# the database dump file (.sql)
sql_file='default-ee.sql'

# The name of the tar.gz file that contains your EE files
tar_file='eesandbox.tar.gz'

# Are you using MAMP?
use_mamp='yes'

# ----------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ----------------------------------------------------

echo Restoring to default EE sandbox...

echo Restoring the database...

if [ $use_mamp='yes' ] ; then
/Applications/MAMP/Library/bin/mysqladmin -u $mysql_username --password=$mysql_password -f drop $database
/Applications/MAMP/Library/bin/mysql -u $mysql_username --password=$mysql_password < ${restore_files_location}/${sql_file}
else
mysqladmin -u $mysql_username --password=$mysql_password -f drop $database
mysql -u $mysql_username --password=$mysql_password < ${restore_files_location}/${sql_file}
fi


echo Restoring the EE system...
rm -rf ${destination}/${sandbox_name}
cp ${restore_files_location}/${tar_file} ${destination}/${tar_file}

echo Unpacking site files..
cd $destination
tar -xf $tar_file
 
echo Cleaning up...
rm $tar_file

echo Setting file and directory permissions...
chmod 777 ${destination}/${sandbox_name}/images/captchas
chmod 777 ${destination}/${sandbox_name}/images/uploads
chmod 777 ${destination}/${sandbox_name}/system/cache
chmod 666 ${destination}/${sandbox_name}/system/config.php
chmod 666 ${destination}/${sandbox_name}/system/config_bak.php
chmod 666 ${destination}/${sandbox_name}/path.php

echo Default EE Site install is now complete.
echo Learn about ExpressionEngine at EEInsider.com and EEScreencasts.com
echo