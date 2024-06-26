LANG=C

if [ "$BIN" == "" ]; then
	BIN=~/AozoraTxt/bin
fi

AOZORA_ROOT=./aozorabunko
TARGET_ROOT=./AozoraTxt
TARGET_ROOT_NPD=./AozoraTxtNpd

if [ -e $BIN/local.sh ]; then
	#AOZORA_ROOT=./TestAozora
	#TARGET_ROOT=./TestTarget
	. $BIN/local.sh
fi

cd $BIN/../..

if [ ! -d $AOZORA_ROOT ]; then
	echo "$AOZORA_ROOT is not found"
	exit 1
fi
if [ ! -d $TARGET_ROOT ]; then
	echo "Creating $AOZORA_ROOT"
	mkdir $TARGET_ROOT
	if [ $? -ne 0 ]; then
		exit 1;
	fi
fi

PERSON_TO=$TARGET_ROOT/person
PERSON_TO_UTF8=$TARGET_ROOT/person_utf8
PERSON_TO_NPD=$TARGET_ROOT_NPD/person
PERSON_TO_NPD_UTF8=$TARGET_ROOT_NPD/person_utf8
TARGET_ETC=$TARGET_ROOT/etc
TARGET_LOG=$TARGET_ROOT/log
TARGET_CSV=$TARGET_ROOT/csv

mkdir -p $PERSON_TO $PERSON_TO_UTF8 $TARGET_ETC $TARGET_LOG $TARGET_CSV

# $ROOT/aozorabunko/card/000005などを集出するための
# find . -type -d -name ... のパターン
PERSON_PATTERN="[0-9]*"
PERSON_LIST=$TARGET_ETC/person_list.txt
PERSON_LIST_NPD=$TARGET_ETC/person_list_npd.txt
PERSON_ID_NPD=$TARGET_ETC/person_id_npd.txt
NPD_PATTERN="＊著作権存続＊"
TMP=$TARGET_ROOT/_tmp
UPDATE=$TARGET_ETC/update
FILENAME_ILLEGAL=$TARGET_ETC/filename_illegal.txt
UPDATE_FILE=$TARGET_LOG/update_file.log
GIT_MV_FILE=$TARGET_LOG/git-mv_file.log
ZIP_LIST_NPD=$TARGET_ETC/zip_npd.txt
COMMIT_LIST=$TARGET_ETC/commit_all.txt
RELEASE_MD=$TARGET_ROOT/Release.md

ZIP_SJIS=$TARGET_ROOT/AozoraTxt_SJIS.zip
ZIP_UTF8=$TARGET_ROOT/AozoraTxt_UTF8.zip
NAME_LIST=$TARGET_CSV/name.csv
TITLE_LIST=$TARGET_CSV/title.csv

GAIJI2UTF8="$TARGET_ROOT/bin/gaiji2utf8.py"

#SJIS2UTF8="iconv -f SHIFT_JISX0213 -t utf8 -c"
SJIS2UTF8="iconv -f CP932 -t utf8 -c"
UTF82SJIS="iconv -f utf8 -t CP932 -c"

UNZIP="unzip"
UNZIP_OPT="-o -d$TMP -Ocp932"		#Win版zipはファイル名がSJIS
ZIP="zip"
ZIP_OPT="-rq"
GIT=git

# 著作権存続作者IDリストを作成
CreatePersonIdNpd(){
	echo "#Creating $PERSON_ID_NPD"
	while read html
	do
		grep "$NPD_PATTERN" $html > /dev/null
		if [ $? -eq 0 ]; then
			person_id=`basename $html`
			person_id=${person_id%.html}
			person_id=${person_id#person}
			printf "%06d\n" $person_id
		fi
	done < <(find $AOZORA_ROOT/index_pages/ -name "person[0-9]*.html") \
		> $PERSON_ID_NPD
	wc -l $PERSON_ID_NPD
}

# 作者リストを作成
CreatePersonList(){
	if [ ! -e $PERSON_ID_NPD ]; then
		CreatePersonIdNpd
	fi
	echo "#Creating $PERSON_LIST"
	rm -f $PERSON_LIST $PERSON_LIST_NPD
	touch $PERSON_LIST $PERSON_LIST_NPD
	while read person_dir
	do
		person_id=`basename $person_dir`
		grep -q $person_id "$PERSON_ID_NPD"
		if [ $? -ne 0 ]; then
			echo $person_dir >> $PERSON_LIST
		else
			echo $person_dir >> $PERSON_LIST_NPD
			if [ -e $PERSON_TO/$person_id ]; then
				echo removed $PERSON_TO/$person_id
				rm -r        $PERSON_TO/$person_id
			fi
		fi
	done < <(find $AOZORA_ROOT/cards/ -type d -name "$PERSON_PATTERN")
	wc -l $PERSON_LIST
	wc -l $PERSON_LIST_NPD
}

#123_ruby_456.zip   500456
#123_ruby.zip       400000
#123_txt_456.zip    300456
#123_txt.zip        200000
#others             100000
CalcZipPriority(){
	zip_file="$1"
	case $zip_file in
	*_ruby_*.zip) 	ret=500000;;
	*_ruby.zip)   	ret=400000;;
	*_txt_*.zip)	ret=300000;;
	*_txt.zip)    	ret=200000;;
	*)				ret=100000;;
	esac

	num=${zip_file%.zip}
	num=${num##*_}
	case "$num" in
	[0-9]*) let ret+=num;;
	esac
	echo $ret
}

CalcTxtPriority(){
	txt_file="$1"
	case $txt_file in
	*_ruby*) 	ret=5;;
	*_txt*)		ret=3;;
	*)			ret=1;;
	esac
	echo $ret
}

TxtIsNPD(){
	html="$1/card$2.html"
	grep -q $NPD_PATTERN $html
}

GetFilenameIllegal(){
	while read txt_file
	do
		# txt_file: ./000183/52884_ruby_utf8_I am_not.txt
		txt_id=`basename ${txt_file%%_*.txt}`	#52884
		person_id=`dirname "$txt_file"`
		person_id=`basename "$person_id"`
		echo "$txt_file	https://www.aozora.gr.jp/cards/$person_id/card$txt_id.html"
	done < <( cd $TARGET_ROOT/person; find . -name "[0-9]*.txt" | grep "[^a-z0-9_/.&'+=\-]" | sort ) > $FILENAME_ILLEGAL
}
