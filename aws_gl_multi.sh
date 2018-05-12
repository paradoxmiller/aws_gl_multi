#!/bin/bash
aws --version
printf "\nPutting file names into filenames.txt"
printf ""
cd testbu
printf '%s\n' * > filenames.txt
printf "\nNow listing contents of filenames.txt"
printf ""
while read chunk; do
  echo $chunk #change to aws upload-multipart-part command
done <filenames.txt #change to chunkfile.txt

# tar the files in the testbu/ directory into mytar.tar.gz
# $> tar czf mybu.tar *
#Then split the tar file into 1MB chunks and output the chunk names into chunkfile.txt
# $> split --bytes1048579 --verbose mybu.tar chunks > chunkfile.txt
#Then initiate multipart upload and get the uploadId:
# $> aws glacier initiate-multipart-upload --account-id - --archive-description "multipart upload test" --part-size 1048576 --vault-name myvault > upid.txt
#Will need to extract uploadId from id.txt and put it into a variable like $UPLOADID - using awk command: 
# $> UPLOADID="$(awk '{print substr($2,2,88)} NR == 2 { exit }' upid.txt)"
#Then use the upload ID to upload each chunk - modify the above while do loop to run the commands below
#NOTE:  The chunk file names will be stored chunkfile.txt and looped through
#Will also need to calculate the ranges and put into variables like $a $z
# $> aws glacier upload-multipart-part --upload-id $UPLOADID --body $chunk --range 'bytes 0-1048575/*' --account-id - --vault-name myvault
# $> aws glacier upload-multipart-part --upload-id $UPLOADID --body $chunk --range 'bytes 1048576-2097151/*' --account-id - --vault-name myvault
# $> aws glacier upload-multipart-part --upload-id $UPLOADID --body $chunk --range 'bytes 2097152-3145727/*' --account-id - --vault-name myvault
#Then calculate the hashes
# $> openssl dgst -sha256 -binary chunkaa > hash1
# $> openssl dgst -sha256 -binary chunkab > hash2
# $> openssl dgst -sha256 -binary chunkac > hash3
# Combine the first two to get the binary hash of the result:
# $> cat hash1 hash2 > hash12
# $> openssl dgst -sha256 -binary hash12 > hash12hash
# Combine the parents with the remaining hash and output final to hex and store that in a variable
# $> cat hash12hash hash3 > hash123
# $> openssl dgst -sha256 hash123
#Then complete the upload
# $> aws glacier complete-multipart-upload --checksum $TREEHASH --archive-size 3145728 --upload-id $UPLOADID --account-id - --vault-name myvault
