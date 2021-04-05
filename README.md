Docker assets for creating an image ([Docker Hub](https://hub.docker.com/r/kitaruk/mdbtools-docker/)) containing the [**mdbtools**](https://github.com/mdbtools/mdbtools) utility, an open source library (and related command-line tools) that supports extraction of data from Microsoft Access databases.

## Interactive Usage

Mount a volume that points to the host directory containing your Access database(s), then run the container interactively and execute `bash`:

```bash
docker run -it --rm -v $PWD:/opt/mdbdata kitaruk/mdbtools-docker:deb  bash
```

Now you have an interactive shell, e.g.:

```
bash-4.3# cd /opt/mdbdata
bash-4.3# pwd
/opt/mdbdata
bash-4.3# ls -l
total 384
-rw-r--r--    1 root     root        393216 Sep 10 16:59 mdbtools-demo.accdb
bash-4.3# mdb-ver mdbtools-demo.accdb
ACE12
bash-4.3# mdb-tables mdbtools-demo.accdb
DemoTable
bash-4.3# mdb-export mdbtools-demo.accdb DemoTable
RecordID,RecordValue
1,"First"
2,"Second"
3,"Third"
bash-4.3#
```

The toy Access database `mdbtools-demo.accdb` is available from the image github repo at https://github.com/scottcame/docker/tree/master/mdbtools

Inside the container, type

```bash
man mdb-tables
 ...
man [mdb-array|mdb-export|mdb-header|mdb-hexdump|mdb-import|mdb-parsecsv|mdb-prop|mdb-schema|mdb-sql|mdb-tables|mdb-ver]
```

## MS Access to MySQL/MariaDB dump

This image comes with a script `to_mysql.sh`, reading MS Access Database files and outputting as MySQL SQL.

```
docker run -it --rm -v /path/to/host/db.mdb:/opt/mdbdata/db.mdb:ro kitaruk/mdbtools-docker bash -c "to_mysql.sh /opt/mdbdata/db.mdb" > db.sql
```

## Notes

This image is based on Debian 11 (Bullseye) and it's pre-compiled package. 
It includes `7z` and `unrar` (as well as `gunzip` and `unzip`), as sometimes providers of Access databases use these compression tools when delivering their databases.
It also includes many other utils

The `mdbtools` included in the image is compiled with the limited sql support as well as ODBC support, and man pages.
