#!/bin/sh

set -e

echo "$AWS_KEY:$AWS_SECRET_KEY" > passwd && chmod 600 passwd
s3fs -f "$S3_BUCKET" "$MNT_POINT" -o passwd_file=passwd   -o url="$S3_URL" -o use_path_request_style -o allow_other  && tail -f /dev/null
