#!/bin/bash

s3_bucket_file="./s3_bucket_list.txt"

echo -e "수정된일이 오래된 순서로 보려면 old를 입력해주세요. 원하시지 않는다면 다른키를 아무커나 입력해주세요"
read sort_modified_old

if [ "$sort_modified_old" = "old" ]; then
  aws s3 ls / | sort | cut -d' ' -f3 >$s3_bucket_file
else
  aws s3 ls / | cut -d' ' -f3 >$s3_bucket_file
fi

while read bucket_name; do

  echo -e "\n버킷 이름: "$bucket_name"\n"
  echo "버킷 내부 오브젝트 불러오는 중... 오브젝트의 내용이 많다면 시간이 다소 소요될 수 있습니다."
  sleep 1
  aws s3 ls --summarize --human-readable --recursive s3://$bucket_name

  echo -e "\n"
  echo -e "버킷을 삭제하시려면 yes, 유지하시려면 다른키를 아무거나 입력해주세요\n종료를 원하신다면 end를 입력해주세요"
  read is_delete </dev/tty

  if [ "$is_delete" = "yes" ]; then
    aws s3 rb s3://$bucket_name --force
  elif [ "$is_delete" = "end" ]; then
    echo -e "작업을 종료합니다."
    break
  else
    continue
  fi

done <$s3_bucket_file
