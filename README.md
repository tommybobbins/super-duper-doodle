# super-duper-doodle
Worked example for migrating AWS AMIs to GCP 


When run using encrpyed AMIs, it will return the following:
```
An error occurred (InvalidParameter) when calling the ExportImage operation: The image ID (ami-<id>) provided has encrypted EBS block devices and is not exportable.
```

https://repost.aws/knowledge-center/create-unencrypted-volume-kms-key

