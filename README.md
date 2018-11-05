Amazon Web Sessions

General Info
AWSessions is a small shell script which generates a session token for an MFA enabled AWS account.
It then exports the authentication details into the current shell's environmental variables. 
A session file is created and time marked, and will simply re-export existing details should a new shell be opened within 12 hours.

Requirements:
This script assumes AWS CLI is installed and that AWS configure has been run to set up the relevant profile folder (~/.aws).
A new file called "serial" will need to be created in the .aws folder, containing the serial for your assigned MFA device.
This serial can be found on the console in IAM -> Users -> Your account name -> Security Credentials.

Sample Serial: arn:aws:iam::123456789012:mfa/jimmy@rustlers.com

Useage:
source awscli.sh [MFA Code]

- The MFA code will be prompted for if not included
- The script MUST be sourced or it will export the environment variables to a subshell, largely defeating the point.

License:
This script is free to use or modify for personal and commercial use. Any derivative works should be held under the same license.
