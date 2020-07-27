# s3tool

## Download/Install
Get this tool in one of the following ways
```bash
wget https://raw.githubusercontent.com/ferrymanders/s3tool/master/s3.sh; chmod +x s3.sh
# or
curl https://raw.githubusercontent.com/ferrymanders/s3tool/master/s3.sh -o s3.sh; chmod +x s3.sh
```

## Usage
Create a `.s3creds` file in your homedir, in that file put the following settings
```
s3Key="<Access Key>"
s3Secret="<Secret Key>"
s3Host="s3.host.tld"
```

After that put the file that you want to transfer
```
./s3.sh put <file> <bucket>
```
After uploading you'll get an download command

## S3 storage
For testing this tool i've used the Object Storage of scaleway.com, they currently offer 75GB of free storage with 75GB of monthly download traffic, incomming traffic and requests are fully free.
https://www.scaleway.com/en/object-storage/
