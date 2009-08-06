while getopts 'f:' OPTION
do
  case $OPTION in
  f)    fflag=1
                fval="$OPTARG"
                ;;
  ?)    printf "Usage: %s -f filename\n" $(basename $0) >&2
               exit 2
               ;;
  esac
done

if [ "$fflag" ]
then
  # First validate XML so it can be used by ElementTree
  sed s/'<!DOCTYPE'.*// $fval > temp.txt
  sed s/'<?xml'.*// temp.txt > $fval
  echo '<?xml version="1.0" encoding="UTF-8"?>' > temp.txt
  echo '<!DOCTYPE us-patent-application SYSTEM "us-patent-application-v42-2006-08-23.dtd" [ ]>' >> temp.txt
  echo '<us-patent-tree>' >> temp.txt
  echo '</us-patent-tree>' >> $fval
  cat $fval >> temp.txt
  mv temp.txt $fval

  # Now that xml is valid, run the python xml parser
  python parse_xml_to_files.py $fval
fi