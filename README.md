# aws_gl_multi
A Bash script to do a multipart upload to AWS Glacier

Eventually it will:
Create a tar file of all the files in a directory
Split the tar file into chunks
Initiate a multipart upload to AWS Glacier
Capture the uploadId into a variable
Upload each chunk
Calculate the hash tree
Complete the multipart upload
