#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import boto3
from boto3.s3.transfer import TransferConfig
from botocore.exceptions import ClientError

import os
import sys
import threading
import time
import logging

from os.path import splitext, basename
from pydub import AudioSegment

AWS_REGION_NAME = "eu-west-1"
AWS_ACCESS_KEY = "AWS_ACCESS_KEY_TO_BE_FILLED"
AWS_SECRET_KEY = "AWS_SECRET_KEY_TO_BE_FILLED"

S3_BUCKET = "oso-ari"

MB = 1024 ** 2

# Create s3 client
s3_client = boto3.client(
    "s3",
    region_name=AWS_REGION_NAME,
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY,
)

# set transfers configuration
config = TransferConfig(
    multipart_threshold=10 * MB,
    max_concurrency=20,
    multipart_chunksize=8 * MB,
    num_download_attempts=10,
)


# Extract serial from cpuinfo file
def getSerial():
    cpuserial = "0000000000000000"
    try:
        f = open("/proc/cpuinfo", "r")
        for line in f:
            if line[0:6] == "Serial":
                cpuserial = line[10:26]
        f.close()
    except:
        cpuserial = "ERROR000000000"

    return cpuserial


def wav2flac(wav_file):
    flac_file = "%s.flac" % splitext(wav_file)[0]
    song = AudioSegment.from_wav(wav_file)
    song.export(flac_file, format="flac")
    return flac_file


def compress_and_upload_file(wav_file):
    flac_path = wav2flac(wav_file)
    file_name = getSerial() + "/" + basename(flac_path)
    s3_client.upload_file(flac_path, S3_BUCKET, file_name, Config=config)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage {sys.argv[0]} wav_file")
        sys.exit(1)

    try:
        compress_and_upload_file(sys.argv[1])
    except ClientError as e:
        logging.error(e)
