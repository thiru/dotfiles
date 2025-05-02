#!/bin/bash

# Convert all MS Word docx files to plain text

for i in *.docx ; do
  pandoc "$i" -t plain -o "$(basename "${i/.docx}").txt"
  sleep 1
done
